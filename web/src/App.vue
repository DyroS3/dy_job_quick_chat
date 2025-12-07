<script setup lang="ts">
import { onMounted } from 'vue'
import { useNui } from '@/composables/useNui'
import QuickChatPanel from '@/components/QuickChatPanel.vue'

const { isVisible, jobs, activeJobId, sendMessage, closePanel } = useNui()

// 开发模式：模拟 NUI 消息（只显示当前职业）
if (import.meta.env.DEV) {
  onMounted(() => {
    window.postMessage({
      action: 'open',
      data: {
        activeJobId: 'police',
        // 模拟只传递当前职业数据（单职业模式）
        jobs: [
          {
            id: 'police',
            name: '警察',
            icon: 'mdi:police-badge',
            description: '执法人员常用语录',
            categories: [
              {
                id: 'patrol',
                name: '日常巡逻',
                expanded: true,
                quotes: [
                  { id: 'p001', text: '请靠边停车，接受检查', favorite: false },
                  { id: 'p002', text: '请出示您的驾照和行驶证', favorite: false },
                  { id: 'p003', text: '这是例行检查，请配合', favorite: false },
                ]
              },
              {
                id: 'chase',
                name: '追捕嫌疑人',
                expanded: true,
                quotes: [
                  { id: 'c001', text: '停下！这是警察！', favorite: false },
                  { id: 'c002', text: '放下武器，双手抱头！', favorite: false },
                ]
              }
            ]
          }
        ]
      }
    }, '*')
  })
}
</script>

<template>
  <Transition name="fade">
    <QuickChatPanel
      v-if="isVisible"
      :jobs="jobs"
      :active-job-id="activeJobId"
      @send="sendMessage"
      @close="closePanel"
    />
  </Transition>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
