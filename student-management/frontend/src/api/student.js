import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
})

api.interceptors.response.use(
  (response) => response,
  (error) => {
    const message = error.response?.data?.message || error.message || '网络错误'
    console.error('API Error:', message)
    return Promise.reject(error)
  }
)

export const studentApi = {
  getList(params) {
    return api.get('/students', { params })
  },

  getById(id) {
    return api.get(`/students/${id}`)
  },

  create(data) {
    return api.post('/students', data)
  },

  update(id, data) {
    return api.put(`/students/${id}`, data)
  },

  delete(id) {
    return api.delete(`/students/${id}`)
  },

  search(query) {
    return api.get('/students/search', { params: { q: query } })
  },
}

export default api
