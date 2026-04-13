<?php
// $temporadas y $temporadaActual se pasan desde index.php
$paginaActual = $_GET['page'] ?? 'inicio';
$loggedIn = isset($_SESSION['username']);
$esAdmin  = isset($_SESSION['rol']) && $_SESSION['rol'] === 'admin';
?>
<header class="site-header">
    <div class="header-content">
        <div class="header-top">
            <div class="header-brand">
                <a href="index.php">
                    <img src="imagenes/imagenes_Logos/logoFederacion.webp" alt="Logo Federación" class="logo-federacion">
                </a>
                <div class="header-titles">
                    <span class="header-title">Federación Española de Balonmano</span>
                    <?php if (!empty($temporadaActual)): ?>
                        <span class="header-season">Temporada: <?= htmlspecialchars($temporadaActual) ?></span>
                    <?php endif; ?>
                </div>
            </div>

            <div class="header-controls">
                <!-- Selector de temporada -->
                <form method="POST" action="php/funcionalidades/cambiar_temporada.php" class="season-form" id="formTemporada">
                    <input type="hidden" name="page_actual" value="<?= htmlspecialchars($paginaActual) ?>">
                    <label for="selectTemporada">Temporada:</label>
                    <select name="temporada" id="selectTemporada">
                        <?php foreach ($temporadas as $t): ?>
                            <option value="<?= htmlspecialchars($t) ?>"
                                <?= ($t === $temporadaActual) ? 'selected' : '' ?>>
                                <?= htmlspecialchars($t) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </form>

                <!-- Área de usuario -->
                <div class="header-user">
                    <?php if ($loggedIn): ?>
                        <span class="user-info">
                            <?= htmlspecialchars($_SESSION['nombre']) ?>
                            <span class="user-role">(<?= htmlspecialchars($_SESSION['rol']) ?>)</span>
                        </span>
                        <form method="POST" action="php/funcionalidades/cerrar_sesion.php" class="logout-form">
                            <button type="submit" class="btn-logout">Cerrar sesión</button>
                        </form>
                    <?php else: ?>
                        <form method="POST" action="php/funcionalidades/iniciar_sesion.php" class="login-form" id="formLogin" novalidate>
                            <input type="text" name="username" id="loginUsername" placeholder="Usuario" autocomplete="username">
                            <input type="password" name="password" id="loginPassword" placeholder="Contraseña" autocomplete="current-password">
                            <button type="submit" class="btn-login">Entrar</button>
                        </form>
                        <?php if (!empty($_SESSION['login_error'])): ?>
                            <span class="login-error"><?= htmlspecialchars($_SESSION['login_error']) ?></span>
                            <?php unset($_SESSION['login_error']); ?>
                        <?php endif; ?>
                    <?php endif; ?>
                </div>
            </div>

            <!-- Botón hamburguesa -->
            <button class="hamburger" id="hamburger" aria-label="Menú">
                <img src="imagenes/iconos/menuHamburguesa.png" alt="Menú">
            </button>
        </div>
        <nav class="site-nav" id="siteNav">
            <ul>
                <li><a href="index.php?page=inicio" class="<?= ($paginaActual === 'inicio') ? 'active' : '' ?>">Inicio</a></li>
                <li><a href="index.php?page=equipos" class="<?= ($paginaActual === 'equipos') ? 'active' : '' ?>">Equipos</a></li>
                <li><a href="index.php?page=jugadores" class="<?= ($paginaActual === 'jugadores') ? 'active' : '' ?>">Jugadores</a></li>
                <li><a href="index.php?page=jornadas" class="<?= ($paginaActual === 'jornadas') ? 'active' : '' ?>">Jornadas</a></li>
                <li><a href="index.php?page=clasificacion" class="<?= ($paginaActual === 'clasificacion') ? 'active' : '' ?>">Clasificación</a></li>
                <?php if ($esAdmin): ?>
                    <li><a href="index.php?page=gestion_usuarios" class="<?= ($paginaActual === 'gestion_usuarios') ? 'active' : '' ?>">Gestionar Usuarios</a></li>
                <?php endif; ?>
            </ul>
        </nav>
    </div>
</header>