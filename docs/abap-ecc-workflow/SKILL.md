---
name: abap-ecc-workflow
description: ABAP ECC workflow development skill. Use when: (1) Developing ABAP programs on ECC system, (2) Creating workflows, (3) ABAP requirement analysis, (4) Writing ABAP documentation, (5) ABAP code review and deployment
---

# ABAP ECC Workflow Skill

ABAP ECC 工作流开发：从需求对齐→模板复用→分析设计→严格测试→规范部署。

## 5-Phase Workflow

### Phase 1: 需求对齐 (Requirement Alignment)
1. 收集业务需求文档
2. 明确输入/输出/边界条件
3. 确认 SAP 版本和增强点
4. 输出: `docs/abap/requirements/YYYY-MM-DD-requirement.md`

### Phase 2: 模板复用 (Template Reuse)
1. 搜索现有代码库中的相似功能
2. 复用标准模板:
   - 报表模板 → `references/report-template.md`
   - 增强模板 → `references/enhancement-template.md`
   - 批处理模板 → `references/batch-template.md`
3. 输出: 复用的模板路径

### Phase 3: 分析设计 (Analysis & Design)
1. 创建技术设计文档
2. 绘制数据流图
3. 定义数据库表结构
4. 编写伪代码
5. 输出: `docs/abap/design/YYYY-MM-DD-design.md`

### Phase 4: 严格测试 (Strict Testing)
1. 单元测试 (ABAP Unit)
2. 集成测试
3. 用户验收测试 (UAT)
4. 性能测试
5. 输出: `docs/abap/test/YYYY-MM-DD-test-report.md`

### Phase 5: 规范部署 (Standard Deployment)
1. 代码审查 (Code Review)
2. 生成传输请求
3. 准备部署文档
4. 输出: `docs/abap/deployment/YYYY-MM-DD-deployment.md`

## 交付物清单

| 阶段 | 交付物 | 路径 |
|------|--------|------|
| 需求 | 需求文档 | `docs/abap/requirements/` |
| 设计 | 技术设计 | `docs/abap/design/` |
| 代码 | ABAP源码 | `src/abap/` |
| 测试 | 测试报告 | `docs/abap/test/` |
| 部署 | 部署文档 | `docs/abap/deployment/` |

## Git 提交流程

```bash
# 按阶段提交
git add .
git commit -m "feat(abap): 完成 [功能名] 开发

- 需求文档
- 技术设计
- ABAP 代码
- 测试报告
- 部署文档"
```

## 快速启动

当用户请求开发 ABAP 功能时:
1. 询问业务需求
2. 按 Phase 1-5 推进
3. 每阶段完成后保存文档
4. 最终提交全部交付物