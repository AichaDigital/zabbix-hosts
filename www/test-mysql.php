<?php
echo "<h1>MySQL Connection Test</h1>";

try {
    $pdo = new PDO('mysql:host=127.0.0.1;port=3306;dbname=testdb', 'testuser', 'testpass');
    echo "<p style='color: green;'>✓ MySQL connection successful</p>";

    // Create test table
    $pdo->exec("CREATE TABLE IF NOT EXISTS test_table (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");

    // Insert test data
    $stmt = $pdo->prepare("INSERT INTO test_table (name) VALUES (?)");
    $stmt->execute(['Test from LEMP - ' . date('Y-m-d H:i:s')]);

    // Display data
    echo "<h3>Data in test table:</h3>";
    $stmt = $pdo->query("SELECT * FROM test_table ORDER BY created_at DESC LIMIT 10");
    echo "<table border='1' style='border-collapse: collapse;'>";
    echo "<tr><th>ID</th><th>Name</th><th>Created</th></tr>";

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        echo "<tr>";
        echo "<td>" . htmlspecialchars($row['id']) . "</td>";
        echo "<td>" . htmlspecialchars($row['name']) . "</td>";
        echo "<td>" . htmlspecialchars($row['created_at']) . "</td>";
        echo "</tr>";
    }
    echo "</table>";

} catch(Exception $e) {
    echo "<p style='color: red;'>✗ MySQL Error: " . $e->getMessage() . "</p>";
}

echo "<p><a href='index.php'>← Back to main</a></p>";
?>