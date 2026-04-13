<?php
session_start();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: ../../index.php');
    exit;
}

$temporada = trim($_POST['temporada'] ?? '');
if ($temporada !== '') {
    $_SESSION['temporada'] = $temporada;
}

$page = $_POST['page_actual'] ?? 'inicio';
$allowedPages = ['inicio', 'equipos', 'jugadores', 'jornadas', 'clasificacion', 'gestion_usuarios'];
if (!in_array($page, $allowedPages)) {
    $page = 'inicio';
}

header('Location: ../../index.php?page=' . urlencode($page));
exit;
