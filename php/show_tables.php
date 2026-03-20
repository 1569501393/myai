<?php
$host = '127.0.0.1';
$port = 3306;

echo "=== MySQL 数据库连接测试 ===\n\n";

$databases = ['laravel_ini', 'test', 'ai_video_research', 'openclaw_content', 'spider_data'];

foreach ($databases as $db) {
    $conn = @new mysqli($host, 'root', '', $db, $port);
    if ($conn->connect_error) {
        echo "❌ $db: 连接失败\n";
        continue;
    }
    echo "✅ $db: 连接成功\n";
    
    $result = $conn->query("SHOW TABLES");
    if ($result && $result->num_rows > 0) {
        echo "   表:\n";
        while ($row = $result->fetch_row()) {
            echo "   - {$row[0]}\n";
        }
    } else {
        echo "   (无表)\n";
    }
    $conn->close();
    echo "\n";
}
