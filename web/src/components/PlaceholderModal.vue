<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { Icon } from '@iconify/vue'
import type { Quote } from '@/types'
import { replacePlaceholders } from '@/utils/placeholder'

/** FiveM 颜色代码映射 */
const FIVEM_COLORS: Record<string, string> = {
  '^0': 'inherit', '^1': '#F44336', '^2': '#4CAF50', '^3': '#FFEB3B',
  '^4': '#42A5F5', '^5': '#03A9F4', '^6': '#9C27B0', '^7': 'inherit',
  '^8': '#FF5722', '^9': '#9E9E9E',
}

interface ColorSegment { text: string; color: string | null }

function parseFivemColors(text: string): ColorSegment[] {
  const segments: ColorSegment[] = []
  const parts = text.split(/(\^[0-9])/g)
  let currentColor: string | null = null
  for (const part of parts) {
    if (!part) continue
    if (FIVEM_COLORS[part] !== undefined) {
      currentColor = FIVEM_COLORS[part] === 'inherit' ? null : FIVEM_COLORS[part]
    } else {
      segments.push({ text: part, color: currentColor })
    }
  }
  return segments
}

const props = defineProps<{
  quote: Quote
  visible: boolean
}>()

const emit = defineEmits<{
  submit: [message: string]
  cancel: []
}>()

// 表单值
const formValues = ref<Record<string, string>>({})
// 验证错误
const errors = ref<Record<string, string>>({})

// 初始化表单值
function initFormValues() {
  const values: Record<string, string> = {}
  if (props.quote.placeholders) {
    for (const p of props.quote.placeholders) {
      values[p.key] = p.default || ''
    }
  }
  formValues.value = values
  errors.value = {}
}

watch(() => props.visible, (visible) => {
  if (visible) initFormValues()
})

// 预览文本：未填写的占位符显示为 [label]
const previewText = computed(() => {
  let text = props.quote.text
  if (props.quote.placeholders) {
    for (const p of props.quote.placeholders) {
      const value = formValues.value[p.key]
      const pattern = new RegExp(`\\{${p.key}\\}`, 'g')
      if (value && value.trim()) {
        // 有值：替换为用户输入（已转义）
        text = text.replace(pattern, value.replace(/\{/g, '\\{').replace(/\}/g, '\\}').replace(/\^([0-9])/g, '\\^$1'))
      } else {
        // 无值：显示 [label]
        text = text.replace(pattern, `[${p.label}]`)
      }
    }
  }
  return parseFivemColors(text)
})

// 验证表单
function validate(): boolean {
  const newErrors: Record<string, string> = {}
  if (!props.quote.placeholders) return true

  for (const p of props.quote.placeholders) {
    const value = formValues.value[p.key] || ''
    const maxLen = p.maxLength || 100

    if (p.required && !value.trim()) {
      newErrors[p.key] = `${p.label} 不能为空`
    } else if (value.length > maxLen) {
      newErrors[p.key] = `${p.label} 不能超过 ${maxLen} 个字符`
    }
  }

  errors.value = newErrors
  return Object.keys(newErrors).length === 0
}

function handleSubmit() {
  if (!validate()) return
  // 构建最终值：空值使用默认值
  const finalValues: Record<string, string> = {}
  if (props.quote.placeholders) {
    for (const p of props.quote.placeholders) {
      const value = formValues.value[p.key]
      finalValues[p.key] = value && value.trim() ? value : (p.default || '')
    }
  }
  const message = replacePlaceholders(props.quote.text, finalValues)
  emit('submit', message)
}

function handleCancel() {
  emit('cancel')
}

function handleOverlayClick(e: MouseEvent) {
  if ((e.target as HTMLElement).classList.contains('modal-overlay')) {
    handleCancel()
  }
}

function handleKeydown(e: KeyboardEvent) {
  if (e.key === 'Escape' && props.visible) {
    e.stopPropagation()
    handleCancel()
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown, true)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown, true)
})
</script>

<template>
  <Transition name="modal">
    <div v-if="visible" class="modal-overlay" @click="handleOverlayClick">
      <div class="modal-content">
        <div class="modal-header">
          <h3>填写话术内容</h3>
          <button class="btn btn-icon" @click="handleCancel" title="取消">
            <Icon icon="mdi:close" width="20" />
          </button>
        </div>

        <div class="modal-body">
          <!-- 预览区域 -->
          <div class="preview-section">
            <label class="preview-label">预览效果</label>
            <div class="preview-text">
              <span
                v-for="(segment, index) in previewText"
                :key="index"
                :style="segment.color ? { color: segment.color } : undefined"
              >{{ segment.text }}</span>
            </div>
          </div>

          <!-- 表单字段 -->
          <div class="form-fields">
            <div
              v-for="placeholder in quote.placeholders"
              :key="placeholder.key"
              class="form-field"
            >
              <label :for="placeholder.key">
                {{ placeholder.label }}
                <span v-if="placeholder.required" class="required">*</span>
              </label>
              <input
                :id="placeholder.key"
                v-model="formValues[placeholder.key]"
                type="text"
                :placeholder="placeholder.default || `请输入${placeholder.label}`"
                :maxlength="placeholder.maxLength || 100"
                :class="{ 'has-error': errors[placeholder.key] }"
              />
              <span v-if="errors[placeholder.key]" class="error-msg">
                {{ errors[placeholder.key] }}
              </span>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button class="btn btn-secondary" @click="handleCancel">取消</button>
          <button class="btn btn-primary" @click="handleSubmit">
            <Icon icon="mdi:send" width="16" />
            发送
          </button>
        </div>
      </div>
    </div>
  </Transition>
</template>


<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: var(--bg);
  border-radius: 12px;
  width: 90%;
  max-width: 480px;
  max-height: 80vh;
  display: flex;
  flex-direction: column;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.modal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid var(--neutral-200);
}

.modal-header h3 {
  margin: 0;
  font-size: 1.125rem;
  font-weight: 600;
}

.modal-body {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
}

.preview-section {
  margin-bottom: 20px;
}

.preview-label {
  display: block;
  font-size: 0.875rem;
  color: var(--neutral-500);
  margin-bottom: 8px;
}

.preview-text {
  padding: 12px 16px;
  background: var(--neutral-50);
  border-radius: 8px;
  line-height: 1.5;
  font-size: 0.9375rem;
}

.form-fields {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.form-field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-field label {
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--neutral-700);
}

.form-field .required {
  color: #F44336;
  margin-left: 2px;
}

.form-field input {
  padding: 10px 14px;
  font-size: 0.9375rem;
  border: 1px solid var(--neutral-300);
  border-radius: 8px;
  background: var(--bg);
  color: var(--neutral-900);
  transition: border-color 0.15s ease;
}

.form-field input:focus {
  outline: none;
  border-color: var(--accent-blue);
}

.form-field input.has-error {
  border-color: #F44336;
}

.form-field .error-msg {
  font-size: 0.75rem;
  color: #F44336;
}

.modal-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 20px;
  border-top: 1px solid var(--neutral-200);
}

.btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 10px 20px;
  font-size: 0.9375rem;
  font-weight: 500;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.15s ease;
}

.btn-secondary {
  background: var(--neutral-100);
  color: var(--neutral-700);
}

.btn-secondary:hover {
  background: var(--neutral-200);
}

.btn-primary {
  background: var(--accent-blue);
  color: white;
}

.btn-primary:hover {
  opacity: 0.9;
}

/* 动画 */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.2s ease;
}

.modal-enter-active .modal-content,
.modal-leave-active .modal-content {
  transition: transform 0.2s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .modal-content,
.modal-leave-to .modal-content {
  transform: scale(0.95);
}
</style>
