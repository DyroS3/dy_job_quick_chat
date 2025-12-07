<script setup lang="ts">
import { Icon } from '@iconify/vue'
import type { Quote } from '@/types'

defineProps<{
  quote: Quote
}>()

const emit = defineEmits<{
  send: [message: string]
}>()

function handleClick(text: string) {
  emit('send', text)
}
</script>

<template>
  <button class="quote-item" @click="handleClick(quote.text)">
    <span class="quote-text">{{ quote.text }}</span>
    <Icon icon="mdi:send" class="send-icon" />
  </button>
</template>

<style scoped>
.quote-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  width: 100%;
  padding: 12px 16px;
  font-family: var(--font);
  font-size: 0.9375rem;
  color: var(--neutral-700);
  text-align: left;
  background: var(--bg);
  border: none;
  border-bottom: 1px solid var(--neutral-100);
  cursor: pointer;
  transition: all 0.15s ease;
}

.quote-item:last-child {
  border-bottom: none;
}

.quote-item:hover {
  background: var(--neutral-50);
  color: var(--neutral-900);
}

.quote-item:hover .send-icon {
  opacity: 1;
  color: var(--accent-blue);
}

.quote-text {
  flex: 1;
  line-height: 1.4;
}

.send-icon {
  width: 16px;
  height: 16px;
  flex-shrink: 0;
  opacity: 0;
  color: var(--neutral-400);
  transition: all 0.15s ease;
}
</style>
