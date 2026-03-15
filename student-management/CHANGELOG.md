# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-01

### Added

#### Backend (Laravel 12.x)
- Student model with Eloquent ORM
- RESTful API Controller for CRUD operations
- Database migration for students table
- Database seeder with sample data
- Form request validation
- API routes configuration

#### Frontend (Vue 3)
- Single Page Application setup with Vite
- Element Plus UI components integration
- Student list view with pagination
- Add/Edit student dialog
- Delete confirmation
- Search functionality
- Axios HTTP client configuration

#### Database
- MySQL 8.0 Docker container configuration
- docker-compose.yml with volume persistence

#### Documentation
- SPEC.md - Requirements specification
- TECHNICAL_DESIGN.md - Technical design document
- ARCHITECTURE.md - Architecture diagrams
- README.md - Installation and usage guide

### Features

- **Student CRUD**: Complete Create, Read, Update, Delete operations
- **Pagination**: Server-side pagination with configurable page size
- **Search**: Real-time search by name or student number
- **Data Validation**: Both frontend and backend validation
- **Responsive Design**: Mobile-friendly UI
- **RESTful API**: Standard REST API design

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /api/students | List students (paginated) |
| GET | /api/students/{id} | Get student by ID |
| POST | /api/students | Create new student |
| PUT | /api/students/{id} | Update student |
| DELETE | /api/students/{id} | Delete student |
| GET | /api/students/search | Search students |

### Data Model

**students table:**
- id (bigint, PK)
- student_no (varchar 20, unique)
- name (varchar 50)
- gender (enum: male/female/other)
- birth_date (date)
- class_name (varchar 50)
- phone (varchar 20, nullable)
- email (varchar 100, nullable)
- address (varchar 255, nullable)
- timestamps

### Technology Stack

- **Backend**: Laravel 12.x, PHP 8.3
- **Frontend**: Vue 3.4+, Vite 5.x, Element Plus 2.x
- **Database**: MySQL 8.0
- **Container**: Docker

---

## [Unreleased]

### Planned Features

- [ ] User authentication
- [ ] Export to Excel/CSV
- [ ] Student photo upload
- [ ] Batch operations
- [ ] Audit log
- [ ] Role-based access control

## Version History

- [1.0.0] - Initial MVP release
