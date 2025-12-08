<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { Icon } from '@iconify/vue'
import type { Job, Quote } from '@/types'
import Sidebar from './Sidebar.vue'
import CategoryAccordion from './CategoryAccordion.vue'
import PlaceholderModal from './PlaceholderModal.vue'

const props = defineProps<{
  jobs: Job[]
  activeJobId: string
}>()

const emit = defineEmits<{
  send: [message: string]
  close: []
}>()

const selectedJobId = ref(props.activeJobId || props.jobs[0]?.id || '')
const sidebarCollapsed = ref(false)
const expandedCategoryId = ref<string | null>(null)
const searchQuery = ref('')
const isDark = ref(false)

// 占位符弹窗状态
const placeholderQuote = ref<Quote | null>(null)
const showPlaceholderModal = computed(() => placeholderQuote.value !== null)

const selectedJob = computed(() => {
  return props.jobs.find(job => job.id === selectedJobId.value)
})

// 是否显示侧边栏（多个职业时显示）
const showSidebar = computed(() => props.jobs.length > 1)

// 过滤后的分类和话术
const filteredCategories = computed(() => {
  if (!selectedJob.value) return []
  const query = searchQuery.value.trim().toLowerCase()
  if (!query) return selectedJob.value.categories

  return selectedJob.value.categories
    .map(category => ({
      ...category,
      quotes: category.quotes.filter(quote =>
        quote.text.toLowerCase().includes(query)
      )
    }))
    .filter(category => category.quotes.length > 0)
})

function handleSelectJob(jobId: string) {
  selectedJobId.value = jobId
  expandedCategoryId.value = null
  searchQuery.value = ''
}

function handleToggleSidebar() {
  sidebarCollapsed.value = !sidebarCollapsed.value
}

function handleSelectCategory(_jobId: string, categoryId: string) {
  expandedCategoryId.value = categoryId
}

function handleToggleCategory(categoryId: string) {
  // 手风琴效果：点击已展开的折叠，点击未展开的展开（同时关闭其他）
  if (expandedCategoryId.value === categoryId) {
    expandedCategoryId.value = null
  } else {
    expandedCategoryId.value = categoryId
  }
}

function handleSend(message: string) {
  emit('send', message)
}

function handleClose() {
  emit('close')
}

// 打开占位符弹窗
function handleOpenPlaceholder(quote: Quote) {
  placeholderQuote.value = quote
}

// 占位符弹窗提交
function handlePlaceholderSubmit(message: string) {
  placeholderQuote.value = null
  emit('send', message)
}

// 占位符弹窗取消
function handlePlaceholderCancel() {
  placeholderQuote.value = null
}

function handleKeydown(e: KeyboardEvent) {
  // 如果弹窗打开，ESC 由弹窗处理，不关闭面板
  if (e.key === 'Escape' && !showPlaceholderModal.value) {
    handleClose()
  }
}

function applyTheme() {
  document.documentElement.setAttribute('data-theme', isDark.value ? 'dark' : 'light')
}

function toggleTheme() {
  isDark.value = !isDark.value
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
  applyTheme()
}

onMounted(() => {
  // 初始化主题
  const savedTheme = localStorage.getItem('theme')
  isDark.value = savedTheme === 'dark'
  applyTheme()

  window.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
})
</script>

<template>
  <div class="panel card">
    <!-- Left Sidebar (只在多职业时显示) -->
    <Sidebar
      v-if="showSidebar"
      :jobs="jobs"
      :selected-id="selectedJobId"
      :collapsed="sidebarCollapsed"
      @select="handleSelectJob"
      @toggle="handleToggleSidebar"
      @select-category="handleSelectCategory"
    />

    <!-- Right Main Content -->
    <div class="main-content">
      <!-- Header with Job Info -->
      <div class="panel-header">
        <div class="header-title" v-if="selectedJob">
          <Icon :icon="selectedJob.icon" class="header-icon" />
          <div class="header-meta">
            <h3>{{ selectedJob.name }}</h3>
            <span class="header-desc text-muted text-sm">{{ selectedJob.description }}</span>
          </div>
        </div>
        <div class="header-title" v-else>
          <Icon icon="mdi:message-text-fast" class="header-icon" />
          <h3>快捷语录</h3>
        </div>
        <div class="header-actions">
          <!-- 单职业模式下显示主题切换 -->
          <button
            v-if="!showSidebar"
            class="btn btn-icon"
            @click="toggleTheme"
            :title="isDark ? '切换到浅色模式' : '切换到深色模式'"
          >
            <Icon :icon="isDark ? 'mdi:weather-sunny' : 'mdi:weather-night'" width="20" />
          </button>
          <button class="btn btn-icon" @click="handleClose" title="关闭 (ESC)">
            <Icon icon="mdi:close" width="20" />
          </button>
        </div>
      </div>

      <!-- Search Bar -->
      <div v-if="selectedJob" class="search-bar">
        <Icon icon="mdi:magnify" class="search-icon" />
        <input
          v-model="searchQuery"
          type="text"
          class="search-input"
          placeholder="搜索话术..."
        />
        <button
          v-if="searchQuery"
          class="search-clear"
          @click="searchQuery = ''"
          title="清除"
        >
          <Icon icon="mdi:close" width="16" />
        </button>
      </div>

      <!-- Content -->
      <div class="panel-content">
        <template v-if="selectedJob">
          <div v-if="filteredCategories.length > 0" class="categories">
            <CategoryAccordion
              v-for="category in filteredCategories"
              :key="category.id"
              :category="category"
              :is-expanded="expandedCategoryId === category.id || !!searchQuery"
              @toggle="handleToggleCategory(category.id)"
              @send="handleSend"
              @open-placeholder="handleOpenPlaceholder"
            />
          </div>
          <div v-else class="empty-state">
            <Icon icon="mdi:text-search" width="48" class="text-muted" />
            <p class="text-muted">未找到匹配的话术</p>
          </div>
        </template>

        <div v-else class="empty-state">
          <Icon icon="mdi:folder-open-outline" width="48" class="text-muted" />
          <p class="text-muted">暂无可用的职业话术</p>
        </div>
      </div>
    </div>

    <!-- 占位符输入弹窗 -->
    <PlaceholderModal
      v-if="placeholderQuote"
      :quote="placeholderQuote"
      :visible="showPlaceholderModal"
      @submit="handlePlaceholderSubmit"
      @cancel="handlePlaceholderCancel"
    />
  </div>
</template>

<style scoped>
.panel {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: row;
  overflow: hidden;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
}

.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 72px;
  padding: 0 24px;
  border-bottom: 1px solid var(--neutral-200);
  flex-shrink: 0;
  box-sizing: border-box;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

/* Search Bar */
.search-bar {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 24px;
  border-bottom: 1px solid var(--neutral-200);
  flex-shrink: 0;
}

.search-icon {
  width: 20px;
  height: 20px;
  color: var(--neutral-400);
  flex-shrink: 0;
}

.search-input {
  flex: 1;
  padding: 8px 0;
  font-family: var(--font);
  font-size: 0.9375rem;
  color: var(--neutral-900);
  background: transparent;
  border: none;
  outline: none;
}

.search-input::placeholder {
  color: var(--neutral-400);
}

.search-clear {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 24px;
  height: 24px;
  color: var(--neutral-400);
  background: transparent;
  border: none;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.15s ease;
}

.search-clear:hover {
  color: var(--neutral-600);
  background: var(--neutral-100);
}

.header-title h3 {
  font-size: 1.25rem;
  font-weight: 600;
  margin: 0;
  line-height: 1.2;
}

.header-meta {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.header-desc {
  font-size: 0.9375rem;
  line-height: 1.3;
}

.header-icon {
  width: 36px;
  height: 36px;
  color: var(--neutral-500);
  flex-shrink: 0;
}

.panel-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px 24px;
}

.categories {
  display: flex;
  flex-direction: column;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  padding: 64px 0;
}

/* 响应式调整 */
@media (min-width: 1920px) {
  .panel-header {
    padding: 20px 32px;
  }
  .panel-content {
    padding: 24px 32px;
  }
  .header-title h3 {
    font-size: 1.25rem;
  }
  .header-icon {
    width: 36px;
    height: 36px;
  }
}

@media (max-width: 1280px) {
  .panel-header {
    padding: 14px 20px;
  }
  .panel-content {
    padding: 16px 20px;
  }
  .header-title h3 {
    font-size: 1rem;
  }
  .header-icon {
    width: 28px;
    height: 28px;
  }
}

@media (max-width: 1024px) {
  .panel-header {
    padding: 12px 16px;
  }
  .panel-content {
    padding: 14px 16px;
  }
  .header-icon {
    width: 24px;
    height: 24px;
  }
}
</style>
