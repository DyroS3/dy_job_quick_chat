<script setup lang="ts">
import { Icon } from '@iconify/vue'
import type { Job } from '@/types'

defineProps<{
  jobs: Job[]
  selectedId: string
}>()

const emit = defineEmits<{
  select: [jobId: string]
}>()

function handleSelect(jobId: string) {
  emit('select', jobId)
}
</script>

<template>
  <div class="job-tabs">
    <button
      v-for="job in jobs"
      :key="job.id"
      class="tab-item"
      :class="{ active: job.id === selectedId }"
      @click="handleSelect(job.id)"
      :title="job.name"
    >
      <Icon :icon="job.icon" class="tab-icon" />
      <span class="tab-label">{{ job.name }}</span>
    </button>
  </div>
</template>

<style scoped>
.job-tabs {
  display: flex;
  gap: 4px;
  padding: 8px 16px;
  border-bottom: 1px solid var(--neutral-200);
  overflow-x: auto;
}

.job-tabs::-webkit-scrollbar {
  height: 4px;
}

.tab-item {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 12px;
  font-family: var(--font);
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--neutral-500);
  background: transparent;
  border: none;
  border-radius: var(--radius-sm);
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.15s ease;
}

.tab-item:hover {
  color: var(--neutral-700);
  background: var(--neutral-100);
}

.tab-item.active {
  color: var(--accent-blue);
  background: rgba(59, 130, 246, 0.1);
}

.tab-icon {
  width: 18px;
  height: 18px;
  flex-shrink: 0;
}

.tab-label {
  max-width: 80px;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>
