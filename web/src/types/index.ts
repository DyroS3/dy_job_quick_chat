/** 话术条目 */
export interface Quote {
  id: string
  text: string
  favorite: boolean
}

/** 话术分类 */
export interface Category {
  id: string
  name: string
  expanded: boolean
  quotes: Quote[]
}

/** 职业数据 */
export interface Job {
  id: string
  name: string
  icon: string
  description: string
  categories: Category[]
}

/** NUI 打开消息数据 */
export interface NuiOpenData {
  jobs: Job[]
  activeJobId: string
}

/** NUI 消息类型 */
export interface NuiMessage {
  action: 'open' | 'close'
  data?: NuiOpenData
}

/** 发送消息回调参数 */
export interface SendMessageData {
  message: string
}

/** NUI 回调响应 */
export interface NuiCallbackResponse {
  success: boolean
  error?: string
}
