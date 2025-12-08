import type { Quote } from '@/types'

/**
 * 转义特殊字符：{ }
 * 防止用户输入干扰模板语法
 * 注意：颜色代码 ^0-^9 不转义，允许用户输入颜色
 */
export function escapeSpecialChars(input: string): string {
  let result = input
  // 只转义花括号
  result = result.replace(/\{/g, '\\{')
  result = result.replace(/\}/g, '\\}')
  return result
}

/**
 * 替换占位符，返回最终消息
 * @param template 话术模板，如 "嫌疑人{name}因{crime}"
 * @param values 用户输入的值，如 { name: "张三", crime: "超速" }
 */
export function replacePlaceholders(
  template: string,
  values: Record<string, string>
): string {
  let result = template
  for (const [key, value] of Object.entries(values)) {
    // 对用户输入进行转义
    const escapedValue = escapeSpecialChars(value)
    // 替换 {key} 为转义后的值
    const pattern = new RegExp(`\\{${key}\\}`, 'g')
    result = result.replace(pattern, escapedValue)
  }
  return result
}

/**
 * 检查话术是否包含占位符
 */
export function hasPlaceholders(quote: Quote): boolean {
  return Array.isArray(quote.placeholders) && quote.placeholders.length > 0
}
