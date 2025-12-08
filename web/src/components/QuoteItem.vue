<script setup lang="ts">
import { computed } from 'vue'
import { Icon } from '@iconify/vue'
import type { Quote } from '@/types'
import { hasPlaceholders } from '@/utils/placeholder'

/** FiveM 颜色代码映射 */
const FIVEM_COLORS: Record<string, string> = {
  '^0': 'inherit',      // White - 使用继承色适配主题
  '^1': '#F44336',      // Red
  '^2': '#4CAF50',      // Green
  '^3': '#FFEB3B',      // Yellow
  '^4': '#42A5F5',      // Blue
  '^5': '#03A9F4',      // Light Blue
  '^6': '#9C27B0',      // Purple
  '^7': 'inherit',      // White - 使用继承色适配主题
  '^8': '#FF5722',      // Orange
  '^9': '#9E9E9E',      // Grey
}

/** 颜色片段 */
interface ColorSegment {
  text: string
  color: string | null
}

/** 解析 FiveM 颜色代码 */
function parseFivemColors(text: string): ColorSegment[] {
  const segments: ColorSegment[] = []
  const parts = text.split(/(\^[0-9])/g)
  let currentColor: string | null = null

  for (const part of parts) {
    if (!part) continue

    if (FIVEM_COLORS[part] !== undefined) {
      // 遇到颜色代码，更新当前颜色
      currentColor = FIVEM_COLORS[part] === 'inherit' ? null : FIVEM_COLORS[part]
    } else {
      // 普通文本，使用当前颜色
      segments.push({ text: part, color: currentColor })
    }
  }

  return segments
}

const props = defineProps<{
  quote: Quote
}>()

const emit = defineEmits<{
  send: [message: string]
  openPlaceholder: [quote: Quote]
}>()

/** 将占位符 {key} 替换为 [label] 用于显示 */
function formatDisplayText(quote: Quote): string {
  let text = quote.text
  if (quote.placeholders) {
    for (const p of quote.placeholders) {
      const pattern = new RegExp(`\\{${p.key}\\}`, 'g')
      text = text.replace(pattern, `[${p.label}]`)
    }
  }
  return text
}

/** 解析后的彩色文本片段 */
const parsedText = computed(() => parseFivemColors(formatDisplayText(props.quote)))

/** 是否有占位符 */
const hasPlaceholderFields = computed(() => hasPlaceholders(props.quote))

function handleClick() {
  if (hasPlaceholderFields.value) {
    // 有占位符，打开表单弹窗
    emit('openPlaceholder', props.quote)
  } else {
    // 无占位符，直接发送
    emit('send', props.quote.text)
  }
}
</script>

<template>
  <button class="quote-item" @click="handleClick">
    <span class="quote-text">
      <span
        v-for="(segment, index) in parsedText"
        :key="index"
        :style="segment.color ? { color: segment.color } : undefined"
      >{{ segment.text }}</span>
    </span>
    <Icon v-if="hasPlaceholderFields" icon="mdi:form-textbox" class="send-icon placeholder-icon" />
    <Icon v-else icon="mdi:send" class="send-icon" />
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

.placeholder-icon {
  opacity: 0.5;
}

.quote-item:hover .placeholder-icon {
  color: var(--accent-blue);
}
</style>
