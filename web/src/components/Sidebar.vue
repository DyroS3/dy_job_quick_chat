<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Icon } from '@iconify/vue'
import type { Job } from '@/types'

defineProps<{
  jobs: Job[]
  selectedId: string
  collapsed: boolean
}>()

const emit = defineEmits<{
  select: [jobId: string]
  toggle: []
  selectCategory: [jobId: string, categoryId: string]
}>()

const isDark = ref(false)

onMounted(() => {
  // 读取本地存储的主题设置
  const savedTheme = localStorage.getItem('theme')
  isDark.value = savedTheme === 'dark'
  applyTheme()
})

function applyTheme() {
  document.documentElement.setAttribute('data-theme', isDark.value ? 'dark' : 'light')
}

function toggleTheme() {
  isDark.value = !isDark.value
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
  applyTheme()
}

function handleSelect(jobId: string) {
  emit('select', jobId)
}

function handleToggle() {
  emit('toggle')
}

function handleSelectCategory(jobId: string, categoryId: string) {
  emit('select', jobId)
  emit('selectCategory', jobId, categoryId)
}
</script>

<template>
  <aside class="sidebar" :class="{ collapsed }">
    <!-- Header with Logo -->
    <div class="sidebar-header" @click="handleToggle" :title="collapsed ? '展开' : '收起'">
      <Icon icon="mdi:message-text-fast" class="logo-icon" />
      <span v-show="!collapsed" class="logo-text">快捷语录</span>
      <Icon
        v-show="!collapsed"
        :icon="'mdi:chevron-left'"
        class="toggle-icon"
      />
    </div>

    <!-- Job List -->
    <nav class="job-list">
      <div
        v-for="job in jobs"
        :key="job.id"
        class="job-item-wrapper"
        :class="{ expanded: job.id === selectedId && !collapsed }"
      >
        <button
          class="job-item"
          :class="{ active: job.id === selectedId }"
          @click="handleSelect(job.id)"
        >
          <Icon :icon="job.icon" class="job-icon" />
          <span v-show="!collapsed" class="job-name">{{ job.name }}</span>
          <Icon
            v-show="!collapsed"
            icon="mdi:chevron-down"
            class="job-chevron"
            :class="{ rotated: job.id === selectedId }"
          />
        </button>

        <!-- Inline submenu when expanded (not collapsed) -->
        <div v-if="!collapsed && job.id === selectedId" class="job-submenu-inline">
          <button
            v-for="category in job.categories"
            :key="category.id"
            class="submenu-item-inline"
            @click="handleSelectCategory(job.id, category.id)"
          >
            {{ category.name }}
          </button>
        </div>

        <!-- Popup submenu when collapsed -->
        <div v-if="collapsed" class="job-submenu">
          <div class="submenu-header">{{ job.name }}</div>
          <div class="submenu-list">
            <button
              v-for="category in job.categories"
              :key="category.id"
              class="submenu-item"
              @click="handleSelectCategory(job.id, category.id)"
            >
              {{ category.name }}
            </button>
          </div>
        </div>
      </div>
    </nav>

    <!-- Theme Toggle -->
    <div class="sidebar-footer">
      <button
        class="theme-toggle"
        @click="toggleTheme"
        :title="isDark ? '切换到浅色模式' : '切换到深色模式'"
      >
        <Icon :icon="isDark ? 'mdi:weather-sunny' : 'mdi:weather-night'" class="theme-icon" />
        <span v-show="!collapsed" class="theme-text">{{ isDark ? '浅色模式' : '深色模式' }}</span>
      </button>
    </div>
  </aside>
</template>

<style scoped>
.sidebar {
  display: flex;
  flex-direction: column;
  width: 200px;
  background: var(--neutral-50);
  border-right: 1px solid var(--neutral-200);
  transition: width 0.2s ease;
  overflow: visible;
  flex-shrink: 0;
}

.sidebar:not(.collapsed) {
  overflow: hidden;
}

.sidebar.collapsed {
  width: 60px;
}

.sidebar-header {
  display: flex;
  align-items: center;
  gap: 10px;
  height: 72px;
  padding: 0 16px;
  border-bottom: 1px solid var(--neutral-200);
  cursor: pointer;
  flex-shrink: 0;
  transition: all 0.15s ease;
  box-sizing: border-box;
}

.sidebar-header:hover {
  background: var(--neutral-100);
}

.logo-icon {
  width: 26px;
  height: 26px;
  color: var(--accent-blue);
  flex-shrink: 0;
}

.logo-text {
  flex: 1;
  font-size: 1.0625rem;
  font-weight: 600;
  color: var(--neutral-900);
  white-space: nowrap;
  overflow: hidden;
}

.toggle-icon {
  width: 18px;
  height: 18px;
  color: var(--neutral-400);
  flex-shrink: 0;
  transition: transform 0.2s ease;
}

.sidebar.collapsed .sidebar-header {
  justify-content: center;
  padding: 16px 12px;
}

.job-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
  padding: 12px;
  overflow-y: auto;
  overflow-x: visible;
  flex: 1;
}

.sidebar.collapsed .job-list {
  overflow: visible;
}

.job-item-wrapper {
  position: relative;
}

.job-item {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  padding: 12px 14px;
  font-family: var(--font);
  font-size: 1rem;
  font-weight: 500;
  color: var(--neutral-600);
  text-align: left;
  background: transparent;
  border: none;
  border-radius: var(--radius-sm);
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.15s ease;
}

.sidebar.collapsed .job-item {
  justify-content: center;
  padding: 12px;
}

.job-item:hover {
  color: var(--neutral-900);
  background: var(--neutral-50);
}

.job-item:hover .job-icon,
.job-item:hover .job-chevron {
  color: var(--neutral-900);
}

.job-item.active {
  color: var(--accent-blue);
  background: transparent;
}

.job-item.active .job-icon {
  color: var(--accent-blue);
}

.job-item.active .job-chevron {
  color: var(--accent-blue);
}

.job-icon {
  width: 24px;
  height: 24px;
  flex-shrink: 0;
}

.job-name {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
}

.job-chevron {
  width: 18px;
  height: 18px;
  color: var(--neutral-400);
  flex-shrink: 0;
  transition: transform 0.2s ease;
}

.job-chevron.rotated {
  transform: rotate(180deg);
}

/* Inline submenu for expanded state */
.job-submenu-inline {
  display: flex;
  flex-direction: column;
  margin-left: 32px;
  padding: 8px 0;
  border-left: 1px solid var(--neutral-200);
}

.submenu-item-inline {
  display: block;
  width: 100%;
  padding: 10px 16px;
  font-family: var(--font);
  font-size: 0.9375rem;
  font-weight: 400;
  color: var(--neutral-500);
  text-align: left;
  background: transparent;
  border: none;
  cursor: pointer;
  transition: all 0.15s ease;
}

.submenu-item-inline:hover {
  color: var(--accent-blue);
}

/* Submenu for collapsed state */
.job-submenu {
  position: absolute;
  left: 100%;
  top: 0;
  margin-left: 8px;
  min-width: 160px;
  background: var(--bg);
  border: 1px solid var(--neutral-200);
  border-radius: var(--radius);
  box-shadow: var(--shadow-lg);
  opacity: 0;
  visibility: hidden;
  transition: all 0.15s ease;
  z-index: 100;
  overflow: hidden;
}

.job-submenu::before {
  content: '';
  position: absolute;
  left: -6px;
  top: 14px;
  border: 6px solid transparent;
  border-right-color: var(--neutral-200);
}

.job-submenu::after {
  content: '';
  position: absolute;
  left: -5px;
  top: 15px;
  border: 5px solid transparent;
  border-right-color: var(--bg);
}

.submenu-header {
  padding: 10px 14px;
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--neutral-500);
  background: var(--neutral-50);
  border-bottom: 1px solid var(--neutral-200);
  text-transform: uppercase;
  letter-spacing: 0.02em;
}

.submenu-list {
  display: flex;
  flex-direction: column;
  padding: 6px 0;
}

.submenu-item {
  display: block;
  width: 100%;
  padding: 10px 14px;
  font-family: var(--font);
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--neutral-700);
  text-align: left;
  background: transparent;
  border: none;
  cursor: pointer;
  transition: all 0.1s ease;
}

.submenu-item:hover {
  color: var(--accent-blue);
  background: var(--neutral-50);
}

.job-item-wrapper:hover .job-submenu {
  opacity: 1;
  visibility: visible;
}

/* Sidebar Footer */
.sidebar-footer {
  padding: 12px;
  border-top: 1px solid var(--neutral-200);
  flex-shrink: 0;
}

.theme-toggle {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  width: 100%;
  padding: 10px 12px;
  font-family: var(--font);
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--neutral-600);
  background: transparent;
  border: 1px solid var(--neutral-200);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: all 0.15s ease;
}

.theme-toggle:hover {
  color: var(--neutral-900);
  background: var(--neutral-100);
  border-color: var(--neutral-300);
}

.sidebar.collapsed .theme-toggle {
  padding: 10px;
}

.theme-icon {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
}

.theme-text {
  white-space: nowrap;
  overflow: hidden;
}

/* 响应式调整 */
@media (min-width: 1920px) {
  .sidebar {
    width: 240px;
  }
  .sidebar.collapsed {
    width: 72px;
  }
  .toggle-btn {
    height: 52px;
    margin: 16px;
  }
  .job-list {
    gap: 8px;
    padding: 16px;
  }
  .job-item {
    padding: 14px 16px;
    font-size: 1rem;
  }
  .job-icon {
    width: 24px;
    height: 24px;
  }
}

@media (max-width: 1280px) {
  .sidebar {
    width: 180px;
  }
  .sidebar.collapsed {
    width: 56px;
  }
  .job-item {
    padding: 10px 12px;
    font-size: 0.875rem;
  }
  .job-icon {
    width: 20px;
    height: 20px;
  }
}

@media (max-width: 1024px) {
  .sidebar {
    width: 160px;
  }
  .sidebar.collapsed {
    width: 52px;
  }
  .toggle-btn {
    height: 40px;
    margin: 8px;
  }
  .job-list {
    gap: 4px;
    padding: 8px;
  }
  .job-item {
    padding: 8px 10px;
  }
}
</style>
