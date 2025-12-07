import { ref, onMounted, onUnmounted } from 'vue'
import type { NuiMessage, NuiOpenData, NuiCallbackResponse } from '@/types'

/** 获取 FiveM 资源名称 */
function getResourceName(): string {
  // @ts-expect-error FiveM 全局函数
  if (typeof GetParentResourceName === 'function') {
    // @ts-expect-error FiveM 全局函数
    return GetParentResourceName()
  }
  return 'dy_job_quick_chat'
}

/** NUI 通信 composable */
export function useNui() {
  const isVisible = ref(false)
  const jobs = ref<NuiOpenData['jobs']>([])
  const activeJobId = ref('')

  /** 处理来自客户端的消息 */
  function handleMessage(event: MessageEvent<NuiMessage>) {
    const { action, data } = event.data

    if (action === 'open' && data) {
      jobs.value = data.jobs
      activeJobId.value = data.activeJobId
      isVisible.value = true
    } else if (action === 'close') {
      isVisible.value = false
    }
  }

  /** 发送回调到客户端 */
  async function nuiCallback<T = NuiCallbackResponse>(
    name: string,
    data: Record<string, unknown> = {}
  ): Promise<T> {
    const resourceName = getResourceName()
    const url = `https://${resourceName}/${name}`

    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      })
      return await response.json()
    } catch {
      // 开发环境下模拟成功响应
      return { success: true } as T
    }
  }

  /** 发送话术消息 */
  async function sendMessage(message: string): Promise<boolean> {
    const result = await nuiCallback<NuiCallbackResponse>('sendMessage', { message })
    return result.success
  }

  /** 关闭面板 */
  async function closePanel(): Promise<void> {
    await nuiCallback('close')
    isVisible.value = false
  }

  onMounted(() => {
    window.addEventListener('message', handleMessage)
  })

  onUnmounted(() => {
    window.removeEventListener('message', handleMessage)
  })

  return {
    isVisible,
    jobs,
    activeJobId,
    sendMessage,
    closePanel
  }
}
