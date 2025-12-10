import {supabase} from '@/client/supabase'
import type {CreateTollRecordInput, TollRecord} from './types'

// 创建识别记录
export async function createTollRecord(input: CreateTollRecordInput): Promise<TollRecord | null> {
  const {data, error} = await supabase.from('toll_records').insert([input]).select().maybeSingle()

  if (error) {
    console.error('创建识别记录失败:', error)
    return null
  }

  return data
}

// 获取所有识别记录（按创建时间倒序）
export async function getAllTollRecords(): Promise<TollRecord[]> {
  const {data, error} = await supabase.from('toll_records').select('*').order('created_at', {ascending: false})

  if (error) {
    console.error('获取识别记录失败:', error)
    return []
  }

  return data || []
}

// 根据车牌号筛选记录
export async function getTollRecordsByPlateNumber(plateNumber: string): Promise<TollRecord[]> {
  const {data, error} = await supabase
    .from('toll_records')
    .select('*')
    .ilike('plate_number', `%${plateNumber}%`)
    .order('created_at', {ascending: false})

  if (error) {
    console.error('筛选识别记录失败:', error)
    return []
  }

  return data || []
}

// 删除单条记录
export async function deleteTollRecord(id: string): Promise<boolean> {
  const {error} = await supabase.from('toll_records').delete().eq('id', id)

  if (error) {
    console.error('删除识别记录失败:', error)
    return false
  }

  return true
}

// 批量删除记录
export async function deleteTollRecords(ids: string[]): Promise<boolean> {
  const {error} = await supabase.from('toll_records').delete().in('id', ids)

  if (error) {
    console.error('批量删除识别记录失败:', error)
    return false
  }

  return true
}

// 根据ID获取单条记录
export async function getTollRecordById(id: string): Promise<TollRecord | null> {
  const {data, error} = await supabase.from('toll_records').select('*').eq('id', id)

  if (error) {
    console.error('获取识别记录详情失败:', error)
    return null
  }

  return data && data.length > 0 ? data[0] : null
}

// ==================== 后台管理相关API ====================

// 获取所有收费员列表
export async function getAllCollectors(): Promise<Array<{id: string; name: string; code: string}>> {
  const {data, error} = await supabase
    .from('toll_collectors_info')
    .select('id, name, code')
    .order('name', {ascending: true})

  if (error) {
    console.error('获取收费员列表失败:', error)
    return []
  }

  return data || []
}

// 获取所有监控员列表
export async function getAllMonitors(): Promise<Array<{id: string; name: string; code: string}>> {
  const {data, error} = await supabase.from('monitors_info').select('id, name, code').order('name', {ascending: true})

  if (error) {
    console.error('获取监控员列表失败:', error)
    return []
  }

  return data || []
}

// 获取班次设置
export async function getShiftSettings(): Promise<
  Array<{id: string; shift_name: string; start_time: string; end_time: string}>
> {
  const {data, error} = await supabase.from('shift_settings').select('*').order('shift_name', {ascending: true})

  if (error) {
    console.error('获取班次设置失败:', error)
    return []
  }

  return data || []
}

// 根据当前时间判断班次
export function getCurrentShift(shifts: Array<{shift_name: string; start_time: string; end_time: string}>): string {
  const now = new Date()
  const currentTime = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:00`

  for (const shift of shifts) {
    const {shift_name, start_time, end_time} = shift

    // 处理跨天的情况（如夜班23:30-7:30）
    if (start_time > end_time) {
      if (currentTime >= start_time || currentTime < end_time) {
        return shift_name
      }
    } else {
      if (currentTime >= start_time && currentTime < end_time) {
        return shift_name
      }
    }
  }

  return '未知班次'
}
