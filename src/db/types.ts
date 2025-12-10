// 车辆通行费票据识别记录类型定义
export interface TollRecord {
  id: string
  plate_number: string | null
  vehicle_type: string | null
  axle_count: string | null
  tonnage: string | null
  entry_info: string | null
  entry_time: string | null
  amount: number | null
  image_url: string | null
  created_at: string
}

// 创建记录时的输入类型
export interface CreateTollRecordInput {
  plate_number?: string
  vehicle_type?: string
  axle_count?: string
  tonnage?: string
  entry_info?: string
  entry_time?: string
  amount?: number
  image_url?: string
}
