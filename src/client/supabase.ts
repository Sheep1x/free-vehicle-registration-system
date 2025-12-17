// Supabase 配置
const SUPABASE_URL = 'https://codvnervcuxohwtxotpn.supabase.co'
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNvZHZuZXJ2Y3V4b2h3dHhvdHBuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjU1MTg0MjQsImV4cCI6MjA4MTA5NDQyNH0.FrxgBbqYWmlhrSKZPLtZzn1DMcVEwyGTHs4mKYUuUTQ'

// 初始化 Supabase 客户端
import { createClient } from '@supabase/supabase-js'
export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)
