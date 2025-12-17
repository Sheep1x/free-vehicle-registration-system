import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [
    react({
      // 完全禁用 Babel 转换，使用 esbuild 替代
      babel: false
    })
  ]
})