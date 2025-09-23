<?php
echo "<h1>LEMP Stack Test Environment</h1>";
echo "<h2>System configured for Zabbix testing</h2>";

echo "<h3>System Information:</h3>";
echo "<ul>";
echo "<li>Web Server: " . $_SERVER['SERVER_SOFTWARE'] . "</li>";
echo "<li>PHP Version: " . PHP_VERSION . "</li>";
echo "<li>Hostname: " . gethostname() . "</li>";
echo "<li>Server IP: " . $_SERVER['SERVER_ADDR'] . "</li>";
echo "</ul>";

echo "<h3>Connectivity Tests:</h3>";
echo "<ul>";

// Test MySQL connection
try {
    $pdo = new PDO('mysql:host=127.0.0.1;port=3306;dbname=testdb', 'testuser', 'testpass');
    echo "<li style='color: green;'>✓ MySQL: Connection successful</li>";
} catch(Exception $e) {
    echo "<li style='color: red;'>✗ MySQL: Error - " . $e->getMessage() . "</li>";
}

// Test Zabbix Agent status
$zabbix_status = shell_exec('pgrep zabbix_agent2') ? 'Active' : 'Inactive';
echo "<li style='color: " . ($zabbix_status == 'Active' ? 'green' : 'red') . ";'>" . ($zabbix_status == 'Active' ? '✓' : '✗') . " Zabbix Agent: " . $zabbix_status . "</li>";

echo "</ul>";

echo "<h3>Useful Links:</h3>";
echo "<ul>";
echo "<li><a href='test-mysql.php'>Detailed MySQL Test</a></li>";
echo "<li><a href='phpinfo.php'>PHP Info</a></li>";
echo "</ul>";

echo "<hr>";
echo "<p><small>Testing environment for Zabbix Server on localhost:8080</small></p>";
?>