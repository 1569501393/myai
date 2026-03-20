<?php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$host = '127.0.0.1';
$port = 3306;
$dbname = 'laravel_ini';
$username = 'root';
$password = 'root';

try {
    $dsn = "mysql:host=$host;port=$port;dbname=$dbname;charset=utf8mb4";
    $pdo = new PDO($dsn, $username, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    ]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => '数据库连接失败: ' . $e->getMessage()]);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$segments = array_filter(explode('/', trim($uri, '/')));
$segments = array_values($segments);

function jsonResponse($success, $data = null, $message = '', $code = 200): void
{
    http_response_code($code);
    echo json_encode([
        'success' => $success,
        'data' => $data,
        'message' => $message
    ]);
    exit;
}

function getJsonInput(): array
{
    $input = file_get_contents('php://input');
    return json_decode($input, true) ?? [];
}

function validateStudent($data, $excludeId = null): array
{
    $errors = [];
    
    if (empty($data['student_no'])) {
        $errors[] = '学号不能为空';
    }
    if (empty($data['name'])) {
        $errors[] = '姓名不能为空';
    }
    if (!empty($data['email']) && !filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
        $errors[] = '邮箱格式不正确';
    }
    
    return $errors;
}

if (count($segments) >= 2 && $segments[0] === 'api' && $segments[1] === 'students') {
    $id = isset($segments[2]) ? (int)$segments[2] : null;
    
    if ($method === 'GET' && $id) {
        $stmt = $pdo->prepare('SELECT * FROM students WHERE id = ?');
        $stmt->execute([$id]);
        $student = $stmt->fetch();
        
        if (!$student) {
            jsonResponse(false, null, '学生不存在', 404);
        }
        jsonResponse(true, $student);
    }
    
    if ($method === 'GET' && !$id) {
        $page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
        $perPage = isset($_GET['per_page']) ? (int)$_GET['per_page'] : 10;
        $search = isset($_GET['search']) ? trim($_GET['search']) : '';
        
        $offset = ($page - 1) * $perPage;
        
        $where = '';
        $params = [];
        if ($search) {
            $where = 'WHERE name LIKE ?';
            $params[] = "%{$search}%";
        }
        
        $countSql = "SELECT COUNT(*) as total FROM students $where";
        $stmt = $pdo->prepare($countSql);
        $stmt->execute($params);
        $total = $stmt->fetch()['total'];
        
        $sql = "SELECT * FROM students $where ORDER BY id DESC LIMIT $perPage OFFSET $offset";
        
        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $students = $stmt->fetchAll();
        
        jsonResponse(true, [
            'data' => $students,
            'total' => (int)$total,
            'page' => $page,
            'per_page' => $perPage
        ]);
    }
    
    if ($method === 'POST') {
        $data = getJsonInput();
        $errors = validateStudent($data);
        
        if (!empty($errors)) {
            jsonResponse(false, null, implode(', ', $errors), 422);
        }
        
        $checkStmt = $pdo->prepare('SELECT id FROM students WHERE student_no = ?');
        $checkStmt->execute([$data['student_no']]);
        if ($checkStmt->fetch()) {
            jsonResponse(false, null, '学号已存在', 422);
        }
        
        $sql = 'INSERT INTO students (student_no, name, gender, birth_date, phone, email, address) VALUES (?, ?, ?, ?, ?, ?, ?)';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            $data['student_no'],
            $data['name'],
            $data['gender'] ?? '男',
            $data['birth_date'] ?? null,
            $data['phone'] ?? '',
            $data['email'] ?? '',
            $data['address'] ?? ''
        ]);
        
        jsonResponse(true, ['id' => (int)$pdo->lastInsertId()], '创建成功', 201);
    }
    
    if ($method === 'PUT' && $id) {
        $data = getJsonInput();
        $errors = validateStudent($data, $id);
        
        if (!empty($errors)) {
            jsonResponse(false, null, implode(', ', $errors), 422);
        }
        
        $checkStmt = $pdo->prepare('SELECT id FROM students WHERE student_no = ? AND id != ?');
        $checkStmt->execute([$data['student_no'], $id]);
        if ($checkStmt->fetch()) {
            jsonResponse(false, null, '学号已存在', 422);
        }
        
        $sql = 'UPDATE students SET student_no = ?, name = ?, gender = ?, birth_date = ?, phone = ?, email = ?, address = ? WHERE id = ?';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
            $data['student_no'],
            $data['name'],
            $data['gender'] ?? '男',
            $data['birth_date'] ?? null,
            $data['phone'] ?? '',
            $data['email'] ?? '',
            $data['address'] ?? '',
            $id
        ]);
        
        jsonResponse(true, null, '更新成功');
    }
    
    if ($method === 'DELETE' && $id) {
        $stmt = $pdo->prepare('DELETE FROM students WHERE id = ?');
        $stmt->execute([$id]);
        
        jsonResponse(true, null, '删除成功');
    }
}

http_response_code(404);
jsonResponse(false, null, '接口不存在');