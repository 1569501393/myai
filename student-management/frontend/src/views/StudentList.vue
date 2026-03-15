<template>
  <div class="student-list">
    <el-card class="header-card">
      <div class="header-actions">
        <h2>学生管理系统</h2>
        <el-button type="primary" :icon="Plus" @click="handleAdd">添加学生</el-button>
      </div>
    </el-card>

    <el-card class="table-card">
      <div class="search-bar">
        <el-input
          v-model="searchQuery"
          placeholder="搜索姓名或学号"
          :icon="Search"
          clearable
          @input="handleSearch"
          @clear="fetchStudents"
        />
      </div>

      <el-table :data="students" v-loading="loading" stripe>
        <el-table-column prop="student_no" label="学号" width="120" />
        <el-table-column prop="name" label="姓名" width="100" />
        <el-table-column prop="gender" label="性别" width="80">
          <template #default="{ row }">
            <el-tag :type="row.gender === 'male' ? 'primary' : row.gender === 'female' ? 'danger' : 'info'">
              {{ getGenderLabel(row.gender) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="birth_date" label="出生日期" width="120" />
        <el-table-column prop="class_name" label="班级" width="150" />
        <el-table-column prop="phone" label="联系电话" width="130" />
        <el-table-column prop="email" label="邮箱" min-width="180" />
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" :icon="Edit" circle @click="handleEdit(row)" />
            <el-button type="danger" :icon="Delete" circle @click="handleDelete(row)" />
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <el-dialog
      v-model="dialogVisible"
      :title="isEdit ? '编辑学生' : '添加学生'"
      width="600px"
      @close="handleDialogClose"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="学号" prop="student_no">
          <el-input v-model="form.student_no" placeholder="请输入学号" />
        </el-form-item>
        <el-form-item label="姓名" prop="name">
          <el-input v-model="form.name" placeholder="请输入姓名" />
        </el-form-item>
        <el-form-item label="性别" prop="gender">
          <el-select v-model="form.gender" placeholder="请选择性别">
            <el-option label="男" value="male" />
            <el-option label="女" value="female" />
            <el-option label="其他" value="other" />
          </el-select>
        </el-form-item>
        <el-form-item label="出生日期" prop="birth_date">
          <el-date-picker
            v-model="form.birth_date"
            type="date"
            placeholder="选择日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="班级" prop="class_name">
          <el-input v-model="form.class_name" placeholder="请输入班级" />
        </el-form-item>
        <el-form-item label="联系电话" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input v-model="form.address" type="textarea" placeholder="请输入地址" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Edit, Delete, Search } from '@element-plus/icons-vue'
import { studentApi } from '../api/student'

const students = ref([])
const loading = ref(false)
const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)

const dialogVisible = ref(false)
const isEdit = ref(false)
const submitting = ref(false)
const formRef = ref(null)
const editingId = ref(null)

const form = reactive({
  student_no: '',
  name: '',
  gender: '',
  birth_date: '',
  class_name: '',
  phone: '',
  email: '',
  address: '',
})

const rules = {
  student_no: [
    { required: true, message: '请输入学号', trigger: 'blur' },
    { max: 20, message: '学号不能超过20个字符', trigger: 'blur' },
  ],
  name: [
    { required: true, message: '请输入姓名', trigger: 'blur' },
    { max: 50, message: '姓名不能超过50个字符', trigger: 'blur' },
  ],
  gender: [
    { required: true, message: '请选择性别', trigger: 'change' },
  ],
  birth_date: [
    { required: true, message: '请选择出生日期', trigger: 'change' },
  ],
  class_name: [
    { required: true, message: '请输入班级', trigger: 'blur' },
  ],
  phone: [
    { pattern: /^[\d-]+$/, message: '请输入正确的电话号码', trigger: 'blur' },
  ],
  email: [
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' },
  ],
}

const genderMap = {
  male: '男',
  female: '女',
  other: '其他',
}

const getGenderLabel = (gender) => genderMap[gender] || gender

const fetchStudents = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      per_page: pageSize.value,
    }
    const res = await studentApi.getList(params)
    students.value = res.data.data.data || res.data.data
    total.value = res.data.data.total || 0
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '获取列表失败')
  } finally {
    loading.value = false
  }
}

const handleSearch = async () => {
  if (!searchQuery.value) {
    fetchStudents()
    return
  }
  loading.value = true
  try {
    const res = await studentApi.search(searchQuery.value)
    students.value = res.data.data.data || res.data.data
    total.value = res.data.data.total || 0
  } catch (error) {
    ElMessage.error('搜索失败')
  } finally {
    loading.value = false
  }
}

const handleAdd = () => {
  isEdit.value = false
  editingId.value = null
  Object.keys(form).forEach((key) => {
    form[key] = ''
  })
  dialogVisible.value = true
}

const handleEdit = async (row) => {
  isEdit.value = true
  editingId.value = row.id
  try {
    const res = await studentApi.getById(row.id)
    Object.keys(form).forEach((key) => {
      form[key] = res.data.data[key]
    })
    dialogVisible.value = true
  } catch (error) {
    ElMessage.error('获取详情失败')
  }
}

const handleDelete = (row) => {
  ElMessageBox.confirm(`确定要删除学生 "${row.name}" 吗？`, '警告', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  })
    .then(async () => {
      try {
        await studentApi.delete(row.id)
        ElMessage.success('删除成功')
        fetchStudents()
      } catch (error) {
        ElMessage.error(error.response?.data?.message || '删除失败')
      }
    })
    .catch(() => {})
}

const handleSubmit = async () => {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    submitting.value = true
    try {
      if (isEdit.value) {
        await studentApi.update(editingId.value, form)
        ElMessage.success('更新成功')
      } else {
        await studentApi.create(form)
        ElMessage.success('添加成功')
      }
      dialogVisible.value = false
      fetchStudents()
    } catch (error) {
      const msg = error.response?.data?.message || error.response?.data?.errors?.student_no?.[0] || '操作失败'
      ElMessage.error(msg)
    } finally {
      submitting.value = false
    }
  })
}

const handleDialogClose = () => {
  formRef.value?.resetFields()
}

const handleSizeChange = () => {
  currentPage.value = 1
  fetchStudents()
}

const handleCurrentChange = () => {
  fetchStudents()
}

onMounted(() => {
  fetchStudents()
})
</script>

<style scoped>
.student-list {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: 100vh;
}

.header-card {
  margin-bottom: 20px;
}

.header-actions {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions h2 {
  margin: 0;
  font-size: 20px;
  color: #303133;
}

.table-card {
  min-height: 500px;
}

.search-bar {
  margin-bottom: 20px;
}

.search-bar .el-input {
  max-width: 300px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
