/** 占位符定义 */
export interface Placeholder {
  key: string         // 占位符标识，对应 {key}
  label: string       // 表单显示的中文标签
  default?: string    // 默认值
  required?: boolean  // 是否必填，默认 false
  maxLength?: number  // 最大长度，默认 100
}

/** 话术条目 */
export interface Quote {
  id: string
  text: string
  favorite: boolean
  placeholders?: Placeholder[]  // 可选的占位符列表
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
