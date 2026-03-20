# Vue 3 组件模板

## Composition API 组件

```vue
<template>
  <div class="feature-list">
    <el-card v-loading="loading">
      <template #header>
        <div class="card-header">
          <span>{{ title }}</span>
          <el-button type="primary" @click="handleCreate">
            新增
          </el-button>
        </div>
      </template>

      <el-table :data="data" stripe border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="名称" min-width="150" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getStatusLabel(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="created_at" label="创建时间" width="180" />
        <el-table-column label="操作" width="180" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" link @click="handleEdit(row)">
              编辑
            </el-button>
            <el-button type="danger" link @click="handleDelete(row)">
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.pageSize"
          :total="pagination.total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next"
          @size-change="fetchData"
          @current-change="fetchData"
        />
      </div>
    </el-card>

    <FeatureDialog
      v-model="dialogVisible"
      :data="currentItem"
      @success="handleSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { featureApi } from '@/api/feature'
import type { Feature, FeatureForm } from '@/api/feature/types'

defineOptions({
  name: 'FeatureList',
})

const title = '功能列表'
const loading = ref(false)
const data = ref<Feature[]>([])
const dialogVisible = ref(false)
const currentItem = ref<Feature | null>(null)

const pagination = reactive({
  page: 1,
  pageSize: 15,
  total: 0,
})

const statusMap = {
  active: { label: '启用', type: 'success' },
  inactive: { label: '禁用', type: 'danger' },
  draft: { label: '草稿', type: 'info' },
}

const getStatusType = (status: string) => statusMap[status]?.type || 'info'
const getStatusLabel = (status: string) => statusMap[status]?.label || status

const fetchData = async () => {
  loading.value = true
  try {
    const res = await featureApi.list({
      page: pagination.page,
      per_page: pagination.pageSize,
    })
    data.value = res.data.data
    pagination.total = res.data.total
  } catch (error) {
    ElMessage.error('获取数据失败')
  } finally {
    loading.value = false
  }
}

const handleCreate = () => {
  currentItem.value = null
  dialogVisible.value = true
}

const handleEdit = (row: Feature) => {
  currentItem.value = { ...row }
  dialogVisible.value = true
}

const handleDelete = async (row: Feature) => {
  try {
    await ElMessageBox.confirm('确定要删除吗？', '提示', {
      type: 'warning',
    })
    await featureApi.delete(row.id)
    ElMessage.success('删除成功')
    fetchData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleSuccess = () => {
  dialogVisible.value = false
  fetchData()
}

onMounted(() => {
  fetchData()
})
</script>

<style scoped lang="scss">
.feature-list {
  padding: 16px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pagination {
  margin-top: 16px;
  display: flex;
  justify-content: flex-end;
}
</style>
```

## Dialog 表单组件

```vue
<template>
  <el-dialog
    v-model="visible"
    :title="isEdit ? '编辑' : '新增'"
    width="500px"
    @close="handleClose"
  >
    <el-form
      ref="formRef"
      :model="form"
      :rules="rules"
      label-width="80px"
    >
      <el-form-item label="名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入名称" />
      </el-form-item>

      <el-form-item label="描述" prop="description">
        <el-input
          v-model="form.description"
          type="textarea"
          :rows="3"
          placeholder="请输入描述"
        />
      </el-form-item>

      <el-form-item label="状态" prop="status">
        <el-select v-model="form.status" placeholder="请选择状态">
          <el-option label="启用" value="active" />
          <el-option label="禁用" value="inactive" />
          <el-option label="草稿" value="draft" />
        </el-select>
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button @click="handleClose">取消</el-button>
      <el-button type="primary" :loading="submitting" @click="handleSubmit">
        确定
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { featureApi } from '@/api/feature'
import type { FeatureForm } from '@/api/feature/types'

const props = defineProps<{
  modelValue: boolean
  data?: Feature | null
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
  success: []
}>()

const formRef = ref()
const submitting = ref(false)

const form = ref<FeatureForm>({
  name: '',
  description: '',
  status: 'draft',
})

const rules = {
  name: [{ required: true, message: '请输入名称', trigger: 'blur' }],
  status: [{ required: true, message: '请选择状态', trigger: 'change' }],
}

const visible = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
})

const isEdit = computed(() => !!props.data?.id)

watch(
  () => props.data,
  (val) => {
    if (val) {
      form.value = { ...val }
    } else {
      form.value = { name: '', description: '', status: 'draft' }
    }
  },
  { immediate: true }
)

const handleClose = () => {
  visible.value = false
  formRef.value?.resetFields()
}

const handleSubmit = async () => {
  try {
    await formRef.value?.validate()
    submitting.value = true

    if (isEdit.value) {
      await featureApi.update(props.data!.id, form.value)
      ElMessage.success('更新成功')
    } else {
      await featureApi.create(form.value)
      ElMessage.success('创建成功')
    }

    emit('success')
    handleClose()
  } catch (error) {
    // 验证失败或API错误
  } finally {
    submitting.value = false
  }
}
</script>
```

## 注意事项

- 使用 `<script setup lang="ts">` 语法
- 使用 TypeScript 定义类型
- 组件 name 使用 PascalCase
- 样式使用 scoped
- 使用 Element Plus 组件库