<?php
session_start();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../../index.php');
    exit;
}

$username = trim($_POST['username'] ?? '');
$password = trim($_POST['password'] ?? '');

if ($username === '' || $password === '') {
    $_SESSION['login_error'] = 'Por favor, introduce usuario y contraseña.';
    header('Location: ../../index.php');
    exit;
}

$xml = simplexml_load_file(__DIR__ . '/../../data/xml/ligaBalonmano.xml');
if (!$xml) {
    $_SESSION['login_error'] = 'Error al cargar los datos.';
    header('Location: ../../index.php');
    exit;
}

$encontrado = false;
foreach ($xml->usuarios->usuario as $u) {
    if ((string)$u->username === $username && (string)$u->password === $password) {
        $_SESSION['username']  = (string)$u->username;
        $_SESSION['nombre']    = (string)$u->nombre;
        $_SESSION['apellidos'] = (string)$u->apellidos;
        $_SESSION['rol']       = (string)$u->rol;
        $encontrado = true;
        break;
    }
}

if (!$encontrado) {
    $_SESSION['login_error'] = 'Usuario o contraseña incorrectos.';
    header('Location: ../../index.php');
    exit;
}

unset($_SESSION['login_error']);

if ($_SESSION['rol'] === 'admin') {
    header('Location: ../../index.php?page=gestion_usuarios');
} else {
    header('Location: ../../index.php');
}
exit;
