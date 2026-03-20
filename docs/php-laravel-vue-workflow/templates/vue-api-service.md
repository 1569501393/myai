# Vue API Service 模板

## API 模块结构

```
src/api/
├── index.ts           # Axios 实例配置
├── user.ts           # 用户相关 API
└── feature.ts        # 功能相关 API
```

## Axios 实例配置

```typescript
// src/api/index.ts
import axios from 'axios'
import { ElMessage } from 'element-plus'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || '/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
})

// 请求拦截器
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// 响应拦截器
api.interceptors.response.use(
  (response) => {
    const res = response.data
    if (res.success !== undefined && !res.success) {
      ElMessage.error(res.message || '请求失败')
      return Promise.reject(new Error(res.message))
    }
    return response
  },
  (error) => {
    if (error.response) {
      switch (error.response.status) {
        case 401:
          ElMessage.error('登录已过期，请重新登录')
          localStorage.removeItem('token')
          window.location.href = '/login'
          break
        case 403:
          ElMessage.error('没有权限')
          break
        case 404:
          ElMessage.error('资源不存在')
          break
        case 500:
          ElMessage.error('服务器错误')
          break
        default:
          ElMessage.error(error.response.data?.message || '请求失败')
      }
    } else {
      ElMessage.error('网络错误')
    }
    return Promise.reject(error)
  }
)

export default api
```

## API Service 类型定义

```typescript
// src/api/feature/types.ts

export interface Feature {
  id: number
  name: string
  description: string | null
  status: 'active' | 'inactive' | 'draft'
  user_id: number | null
  created_at: string
  updated_at: string
}

export interface FeatureForm {
  name: string
  description?: string
  status: 'active' | 'inactive' | 'draft'
}

export interface FeatureListParams {
  page?: number
  per_page?: number
  status?: string
  keyword?: string
}

export interface PaginatedResponse<T> {
  data: T[]
  total: number
  current_page: number
  last_page: number
  per_page: number
}

export interface ApiResponse<T = any> {
  success: boolean
  data: T
  message: string
}
```

## API Service 实现

```typescript
// src/api/feature/index.ts
import api from '../index'
import type {
  Feature,
  FeatureForm,
  FeatureListParams,
  PaginatedResponse,
  ApiResponse,
} from './types'

export const featureApi = {
  /**
   * 获取列表
   */
  list(params: FeatureListParams = {}): Promise<ApiResponse<PaginatedResponse<Feature>>> {
    return api.get('/features', { params })
  },

  /**
   * 获取详情
   */
  get(id: number): Promise<ApiResponse<Feature>> {
    return api.get(`/features/${id}`)
  },

  /**
   * 创建
   */
  create(data: FeatureForm): Promise<ApiResponse<Feature>> {
    return api.post('/features', data)
  },

  /**
   * 更新
   */
  update(id: number, data: FeatureForm): Promise<ApiResponse<Feature>> {
    return api.put(`/features/${id}`, data)
  },

  /**
   * 删除
   */
  delete(id: number): Promise<ApiResponse<null>> {
    return api.delete(`/features/${id}`)
  },

  /**
   * 批量删除
   */
  batchDelete(ids: number[]): Promise<ApiResponse<null>> {
    return api.post('/features/batch-delete', { ids })
  },

  /**
   * 导出
   */
  export(params: FeatureListParams): Promise<Blob> {
    return api.get('/features/export', {
      params,
      responseType: 'blob',
    })
  },
}

export default featureApi
```

## 组件中使用

```vue
<template>
  <div>{{ feature?.name }}</div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { featureApi } from '@/api/feature'
import type { Feature } from '@/api/feature/types'

const feature = ref<Feature>()

onMounted(async () => {
  try {
    const res = await featureApi.get(1)
    feature.value = res.data
  } catch (error) {
    console.error('Failed to fetch feature:', error)
  }
})
</script>
```

## Composable 封装

```typescript
// src/composables/useFeature.ts
import { ref, reactive } from 'vue'
import { featureApi } from '@/api/feature'
import type { Feature, FeatureListParams } from '@/api/feature/types'

export function useFeature() {
  const loading = ref(false)
  const features = ref<Feature[]>([])
  const pagination = reactive({
    page: 1,
    pageSize: 15,
    total: 0,
  })

  const fetchList = async (params: FeatureListParams = {}) => {
    loading.value = true
    try {
      const res = await featureApi.list({
        page: pagination.page,
        per_page: pagination.pageSize,
        ...params,
      })
      features.value = res.data.data
      pagination.total = res.data.total
    } finally {
      loading.value = false
    }
  }

  const create = async (data: any) => {
    await featureApi.create(data)
  }

  const update = async (id: number, data: any) => {
    await featureApi.update(id, data)
  }

  const remove = async (id: number) => {
    await featureApi.delete(id)
  }

  return {
    loading,
    features,
    pagination,
    fetchList,
    create,
    update,
    remove,
  }
}
```

## 注意事项

- 使用 TypeScript 定义完整类型
- API 方法使用语义化命名
- 统一错误处理
- 支持分页参数
- 封装 Composable 复用逻辑