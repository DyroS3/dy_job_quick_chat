<script setup lang="ts">
import { ref, watch, nextTick } from 'vue'
import { Icon } from '@iconify/vue'
import type { Category } from '@/types'
import QuoteItem from './QuoteItem.vue'

const props = defineProps<{
  category: Category
  isExpanded?: boolean
}>()

const emit = defineEmits<{
  send: [message: string]
  toggle: []
}>()

const accordionRef = ref<HTMLElement | null>(null)

// 当展开时自动滚动到可视区域
watch(() => props.isExpanded, (newVal) => {
  if (newVal) {
    nextTick(() => {
      accordionRef.value?.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
    })
  }
})

function handleToggle() {
  emit('toggle')
}

function handleSend(message: string) {
  emit('send', message)
}
</script>

<template>
  <div ref="accordionRef" class="accordion" :class="{ expanded: isExpanded }">
    <button class="accordion-header" @click="handleToggle">
      <span class="category-name">{{ category.name }}</span>
      <div class="header-right">
        <span class="quote-count text-muted text-sm">{{ category.quotes.length }}</span>
        <Icon
          icon="mdi:chevron-right"
          class="chevron"
          :class="{ rotated: isExpanded }"
        />
      </div>
    </button>

    <Transition name="slide">
      <div v-show="isExpanded" class="accordion-content">
        <QuoteItem
          v-for="quote in category.quotes"
          :key="quote.id"
          :quote="quote"
          @send="handleSend"
        />
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.accordion {
  border-bottom: 1px solid var(--neutral-200);
}

.accordion:first-child {
  border-top: 1px solid var(--neutral-200);
}

.accordion-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  padding: 16px 18px;
  font-family: var(--font);
  font-size: 1rem;
  font-weight: 500;
  color: var(--neutral-600);
  background: transparent;
  border: none;
  cursor: pointer;
  transition: all 0.15s ease;
}

.accordion-header:hover {
  color: var(--neutral-900);
  background: var(--neutral-50);
}

.accordion.expanded .accordion-header {
  color: var(--accent-blue);
}

.header-right {
  display: flex;
  align-items: center;
  gap: 8px;
}

.quote-count {
  padding: 2px 8px;
  background: var(--neutral-200);
  border-radius: 10px;
}

.chevron {
  width: 18px;
  height: 18px;
  color: var(--neutral-400);
  transition: transform 0.2s ease;
}

.chevron.rotated {
  transform: rotate(90deg);
}

.accordion-content {
  display: flex;
  flex-direction: column;
  padding: 0 16px 16px 16px;
}

/* Slide transition */
.slide-enter-active,
.slide-leave-active {
  transition: all 0.2s ease;
  overflow: hidden;
}

.slide-enter-from,
.slide-leave-to {
  opacity: 0;
  max-height: 0;
}

.slide-enter-to,
.slide-leave-from {
  opacity: 1;
  max-height: 500px;
}
</style>
