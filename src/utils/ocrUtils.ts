import {createChatDataHandler, sendChatStream} from 'miaoda-taro-utils/chatStream'

const APP_ID = process.env.TARO_APP_APP_ID || ''
const ENDPOINT = 'https://api-integrations.appmiaoda.com/app-84zvdc9gufwh/api-2jBYdN3A9Jyz/v2/chat/completions'

// OCR识别结果接口
export interface OCRResult {
  plateNumber?: string
  vehicleType?: string
  axleCount?: string
  tonnage?: string
  entryInfo?: string
  entryTime?: string
  amount?: number
}

// 从AI响应中提取票据信息
function parseOCRResponse(content: string): OCRResult {
  const result: OCRResult = {}

  // 提取车牌号
  const plateMatch = content.match(/车牌[号]?[:：]?\s*([^\n，,。\s]+)/i)
  if (plateMatch) {
    result.plateNumber = plateMatch[1].trim()
  }

  // 提取车型
  const vehicleTypeMatch = content.match(/车型[:：]?\s*([^\n，,。\s]+)/i)
  if (vehicleTypeMatch) {
    result.vehicleType = vehicleTypeMatch[1].trim()
  }

  // 提取轴数
  const axleMatch = content.match(/(\d+)\s*轴/i)
  if (axleMatch) {
    result.axleCount = `${axleMatch[1]}轴`
  }

  // 提取吨位
  const tonnageMatch = content.match(/([\d.]+)\s*吨/i)
  if (tonnageMatch) {
    result.tonnage = `${tonnageMatch[1]}吨`
  }

  // 提取入口信息
  const entryMatch = content.match(/入口[:：]?\s*([^\n]+?)(?=\n|时间|$)/i)
  if (entryMatch) {
    result.entryInfo = entryMatch[1].trim()
  }

  // 提取时间
  const timeMatch = content.match(/时间[:：]?\s*(\d{4}[-年]\d{1,2}[-月]\d{1,2}[日]?\s*\d{1,2}:\d{1,2}:\d{1,2})/i)
  if (timeMatch) {
    result.entryTime = timeMatch[1].trim()
  }

  // 提取金额
  const amountMatch = content.match(/金额[:：]?\s*([\d.]+)\s*元/i) || content.match(/([\d.]+)\s*元/)
  if (amountMatch) {
    result.amount = Number.parseFloat(amountMatch[1])
  }

  return result
}

// 调用OCR识别API
export async function recognizeTollReceipt(
  base64Image: string,
  onProgress?: (content: string) => void
): Promise<OCRResult> {
  return new Promise((resolve, reject) => {
    let fullContent = ''

    const handleData = createChatDataHandler((content) => {
      fullContent = content
      if (onProgress) {
        onProgress(content)
      }
    })

    const {abort} = sendChatStream({
      endpoint: ENDPOINT,
      appId: APP_ID,
      messages: [
        {
          role: 'system',
          content: '你是一个专业的票据识别助手，擅长从车辆通行费票据图片中提取关键信息。'
        },
        {
          role: 'user',
          content: [
            {
              type: 'text',
              text: `请仔细识别这张车辆通行费票据图片，提取以下信息：
1. 车牌号（例如：蓝 鲁P233CV）
2. 车型（例如：一型 客车）
3. 轴数（例如：2轴）
4. 吨位（例如：1.26吨）
5. 入口信息（包含站点和省份，例如：[1313-1A02] 内蒙高速-河北段1 河北清河站）
6. 通行时间（例如：2025-12-06 13:25:05）
7. 金额（例如：79.00元）

请按照以下格式输出：
车牌号：xxx
车型：xxx
轴数：xxx
吨位：xxx
入口：xxx
时间：xxx
金额：xxx元`
            },
            {
              type: 'image_url',
              image_url: {
                url: base64Image
              }
            }
          ]
        }
      ],
      onUpdate: handleData,
      onComplete: () => {
        const result = parseOCRResponse(fullContent)
        resolve(result)
      },
      onError: (error: Error) => {
        console.error('OCR识别出错:', error)
        reject(error)
      }
    })

    // 可以在需要时中止请求
    // abort()
  })
}
