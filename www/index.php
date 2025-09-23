<?php
echo "<h1>LEMP Stack Test Environment</h1>";
echo "<h2>Sistema configurado para pruebas con Zabbix</h2>";

echo "<h3>Información del Sistema:</h3>";
echo "<ul>";
echo "<li>Servidor Web: " . $_SERVER['SERVER_SOFTWARE'] . "</li>";
echo "<li>PHP Version: " . PHP_VERSION . "</li>";
echo "<li>Hostname: " . gethostname() . "</li>";
echo "<li>Server IP: " . $_SERVER['SERVER_ADDR'] . "</li>";
echo "</ul>";

echo "<h3>Pruebas de Conectividad:</h3>";
echo "<ul>";

// Test MySQL
try {
    $pdo = new PDO('mysql:host=127.0.0.1;port=3306;dbname=testdb', 'testuser', 'testpass');
    echo "<li style='color: green;'>✓ MySQL: Conexión exitosa</li>";
} catch(Exception $e) {
    echo "<li style='color: red;'>✗ MySQL: Error - " . $e->getMessage() . "</li>";
}

// Test Zabbix Agent
$zabbix_status = shell_exec('pgrep zabbix_agent2') ? 'Activo' : 'Inactivo';
echo "<li style='color: " . ($zabbix_status == 'Activo' ? 'green' : 'red') . ";'>" . ($zabbix_status == 'Activo' ? '✓' : '✗') . " Zabbix Agent: " . $zabbix_status . "</li>";

echo "</ul>";

echo "<h3>Enlaces útiles:</h3>";
echo "<ul>";
echo "<li><a href='test-mysql.php'>Test MySQL Detallado</a></li>";
echo "<li><a href='phpinfo.php'>PHP Info</a></li>";
echo "</ul>";

echo "<hr>";
echo "<p><small>Entorno de pruebas para Zabbix Server en localhost:8080</small></p>";
?>