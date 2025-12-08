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
                  { id: 'p001', text: '^1[警察]^0 请靠边停车，接受检查', favorite: false },
                  { id: 'p002', text: '^4[LSPD]^0 请出示您的驾照和行驶证', favorite: false },
                  { id: 'p003', text: '^2[提示]^0 这是例行检查，请配合', favorite: false },
                ]
              },
              {
                id: 'chase',
                name: '追捕嫌疑人',
                expanded: true,
                quotes: [
                  { id: 'c001', text: '^1[警告]^0 停下！这是^1警察^0！', favorite: false },
                  { id: 'c002', text: '^8[紧急]^0 放下^3武器^0，^6双手抱头^0！', favorite: false },
                ]
              },
              {
                id: 'judgment',
                name: '判罚公告',
                expanded: true,
                quotes: [
                  {
                    id: 'j001',
                    text: '^3嫌疑人{name}因^8{crime}^3。警方判罚：罚款{fine}，监狱{time}。望各位市民遵纪守法，快乐游戏。',
                    favorite: false,
                    placeholders: [
                      { key: 'name', label: '嫌疑人名称', required: true, maxLength: 20 },
                      { key: 'crime', label: '罪名', default: '违法行为', required: true, maxLength: 30 },
                      { key: 'fine', label: '罚款金额', default: '10W', maxLength: 10 },
                      { key: 'time', label: '监狱时间', default: '10分钟', maxLength: 10 }
                    ]
                  },
                  {
                    id: 'j002',
                    text: '^1[警方通报]^0 {name}因{crime}被依法处理，罚款{fine}。',
                    favorite: false,
                    placeholders: [
                      { key: 'name', label: '当事人', required: true, maxLength: 20 },
                      { key: 'crime', label: '违法行为', required: true, maxLength: 50 },
                      { key: 'fine', label: '罚款金额', default: '5W', maxLength: 10 }
                    ]
                  }
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
