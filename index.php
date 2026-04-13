<?php
session_start();

// Rutas base
define('BASE_PATH', __DIR__);
define('XML_PATH', BASE_PATH . '/data/xml/ligaBalonmano.xml');
define('XSL_PATH', BASE_PATH . '/data/xsl/');

// Cargar XML una sola vez
$xml = new DOMDocument();
if (!$xml->load(XML_PATH)) {
    die('Error crítico: No se pudo cargar el archivo XML.');
}
$xpath = new DOMXPath($xml);

// Obtener todas las temporadas del XML
$temporadas = [];
$nodosTmp = $xpath->query('//temporadas/temporada');
foreach ($nodosTmp as $t) {
    $idNode = $xpath->query('id', $t)->item(0);
    if ($idNode) {
        $temporadas[] = $idNode->textContent;
    }
}

// Establecer temporada por defecto si no hay ninguna en sesión
if (empty($_SESSION['temporada']) && !empty($temporadas)) {
    $_SESSION['temporada'] = $temporadas[0];
}
$temporadaActual = $_SESSION['temporada'] ?? ($temporadas[0] ?? '');

// Páginas permitidas
$allowedPages = ['inicio', 'equipos', 'jugadores', 'jornadas', 'clasificacion', 'equipo', 'jugador', 'gestion_usuarios'];
$page = $_GET['page'] ?? 'inicio';
if (!in_array($page, $allowedPages)) {
    $page = 'inicio';
}

// Control de acceso: gestion_usuarios solo para admin
if ($page === 'gestion_usuarios' && (!isset($_SESSION['rol']) || $_SESSION['rol'] !== 'admin')) {
    $page = 'inicio';
}

// Función de transformación XSLT
function transformarXML(DOMDocument $xml, string $xslFile, array $params = []): string {
    $xslPath = XSL_PATH . $xslFile;
    if (!file_exists($xslPath)) {
        return '<div class="error">Error: No se encontró el archivo XSL: ' . htmlspecialchars($xslFile) . '</div>';
    }

    $xsl = new DOMDocument();
    if (!$xsl->load($xslPath)) {
        return '<div class="error">Error al cargar el XSL: ' . htmlspecialchars($xslFile) . '</div>';
    }

    $proc = new XSLTProcessor();
    $proc->importStylesheet($xsl);

    foreach ($params as $key => $value) {
        $proc->setParameter('', $key, (string)$value);
    }

    $result = $proc->transformToXml($xml);
    if ($result === false || $result === null) {
        return '<div class="error">Error en la transformación XSL.</div>';
    }
    return $result;
}

// Generar contenido del main
$contenidoMain = '';
switch ($page) {
    case 'inicio':
        $contenidoMain = transformarXML($xml, 'inicio.xsl', ['temporadaId' => $temporadaActual]);
        break;

    case 'equipos':
        $contenidoMain = transformarXML($xml, 'equipos.xsl', ['temporadaId' => $temporadaActual]);
        break;

    case 'jugadores':
        $contenidoMain = transformarXML($xml, 'jugadores.xsl', ['temporadaId' => $temporadaActual]);
        break;

    case 'jornadas':
        $contenidoMain = transformarXML($xml, 'jornadas.xsl', ['temporadaId' => $temporadaActual]);
        break;

    case 'clasificacion':
        $contenidoMain = transformarXML($xml, 'clasificacion.xsl', ['temporadaId' => $temporadaActual]);
        break;

    case 'equipo':
        $equipoId = $_GET['id'] ?? '';
        if (!preg_match('/^E\d+$/', $equipoId)) {
            $equipoId = '';
        }
        $contenidoMain = transformarXML($xml, 'equipo_detalle.xsl', [
            'temporadaId' => $temporadaActual,
            'equipoId'    => $equipoId,
        ]);
        break;

    case 'jugador':
        $jugadorId = $_GET['id'] ?? '';
        if (!preg_match('/^JU\d+$/', $jugadorId)) {
            $jugadorId = '';
        }
        $contenidoMain = transformarXML($xml, 'jugador_detalle.xsl', [
            'temporadaId' => $temporadaActual,
            'jugadorId'   => $jugadorId,
        ]);
        break;

    case 'gestion_usuarios':
        $contenidoMain = transformarXML($xml, 'gestion_usuarios.xsl', []);
        break;
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Federación Española de Balonmano</title>
    <link rel="icon" type="image/x-icon" href="imagenes/iconos/logoFederacion.ico">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Source+Sans+3:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <?php include 'php/interfaces/header.php'; ?>

    <main class="site-main">
        <?= $contenidoMain ?>
    </main>

    <?php include 'php/interfaces/footer.php'; ?>

    <script src="js/validation.js"></script>
</body>
</html>
