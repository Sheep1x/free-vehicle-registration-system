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
