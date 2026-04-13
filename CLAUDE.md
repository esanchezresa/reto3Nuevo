# CLAUDE.md — Reto3: Liga Nacional de Balonmano

Documentación técnica completa del proyecto para uso de Claude Code.

---

## Descripción general

Aplicación web PHP que muestra información de la **Federación Española de Balonmano**: equipos, jugadores, jornadas, clasificación y gestión de usuarios. Toda la información se almacena en un único XML y se renderiza con transformaciones XSLT. No hay base de datos.

**Stack:** PHP 8 + DOMDocument + XSLTProcessor + XML/XSLT + CSS puro + JS vanilla  
**Servidor:** XAMPP (Apache + PHP en Windows)  
**URL local:** `http://localhost/php/Reto3/index.php`

---

## Estructura de archivos

```
Reto3/
├── index.php                          # Router principal y punto de entrada único
├── css/
│   └── styles.css                     # Todos los estilos (un solo archivo)
├── js/
│   └── validation.js                  # Validación login, menú hamburguesa, auto-submit temporada
├── data/
│   ├── xml/
│   │   └── ligaBalonmano.xml          # Fuente de datos única (toda la app)
│   └── xsl/
│       ├── inicio.xsl                 # Página inicio (hero, clasificación, partidos, stats, equipos)
│       ├── equipos.xsl                # Grid de equipos con escudos
│       ├── equipo_detalle.xsl         # Ficha de equipo + plantilla de jugadores
│       ├── jugadores.xsl              # Grid de todos los jugadores
│       ├── jugador_detalle.xsl        # Ficha individual de jugador
│       ├── clasificacion.xsl          # Tabla de clasificación con escudos
│       ├── jornadas.xsl               # Lista de jornadas y resultados
│       └── gestion_usuarios.xsl       # Tabla de usuarios (solo admin)
├── php/
│   ├── interfaces/
│   │   ├── header.php                 # Header con nav, selector de temporada, login
│   │   └── footer.php                 # Footer con copyright
│   └── funcionalidades/
│       ├── iniciar_sesion.php         # POST: valida credenciales en XML, guarda sesión
│       ├── cerrar_sesion.php          # POST: destruye sesión, redirige a inicio
│       └── cambiar_temporada.php      # POST: valida temporada en XML, guarda en sesión
└── imagenes/
    ├── iconos/
    │   ├── logoFederacion.ico         # Favicon
    │   └── menuHamburguesa.png        # Icono del botón hamburguesa
    ├── imagenes_Logos/
    │   ├── BARCELONA.png
    │   ├── GRANADA.png
    │   ├── SEVILLA.png
    │   ├── VALENCIA.png
    │   ├── ZARAGOZA.png
    │   ├── ATHLETIC_CLUB.png
    │   └── logoFederacion.webp        # Logo oficial + fallback de escudos
    └── imagenes_jugadores/
        ├── jugador-default.png        # Fallback cuando no hay foto
        ├── 2024-2025/                 # Fotos de la temporada 2024-2025
        │   └── J{N}{0000001..0000013}.png
        └── 2025-2026/                 # Fotos de la temporada 2025-2026
            └── J{N}{0000001..0000013}.png
```

### Nomenclatura de imágenes de jugadores

El nombre de archivo sigue el patrón `J{N}{XXXXXXX}.png`:
- `N` = número de equipo (1=Barcelona, 2=Granada, 3=Sevilla, 4=Zaragoza, 5=Valencia, 6=Athletic Club)
- `XXXXXXX` = número de jugador en el equipo con 7 dígitos (0000001 a 0000013)

Ejemplo: `J10000003.png` = equipo 1 (Barcelona), jugador 3 de la temporada seleccionada.

---

## Flujo de la aplicación

```
Petición GET → index.php
    ├── Carga XML (DOMDocument)
    ├── Obtiene temporadas disponibles (//temporadas/temporada/id)
    ├── Lee temporada actual de $_SESSION['temporada']
    ├── Determina $page desde $_GET['page'] (whitelist: inicio/equipos/jugadores/jornadas/clasificacion/equipo/jugador/gestion_usuarios)
    ├── Control acceso: gestion_usuarios solo si $_SESSION['rol'] === 'admin'
    ├── Llama a transformarXML($xml, '{page}.xsl', $params)
    │       → Carga XSL, crea XSLTProcessor, pasa parámetros, devuelve HTML
    └── Incluye header.php + $contenidoMain + footer.php
```

**Petición POST (login):**
```
formLogin → iniciar_sesion.php
    → Carga XML, busca //usuarios/usuario con username+password coincidentes
    → Guarda en sesión: username, password, nombre, apellidos, rol
    → Redirige a index.php (o ?page=gestion_usuarios si es admin)
```

**Petición POST (cambiar temporada):**
```
formTemporada → cambiar_temporada.php
    → Valida que la temporada existe en XML: //temporada[id="valor"]
    → Guarda $_SESSION['temporada']
    → Redirige a index.php?page={page_actual}
```

---

## Estructura del XML (`ligaBalonmano.xml`)

**IMPORTANTE:** El XML usa **elementos hijo** para IDs, no atributos. Todo el código XPath debe usar `[id=X]`, no `[@id=X]`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<federacionBalonmano>

    <usuarios>
        <usuario>
            <nombre>Ad</nombre>
            <apellidos>Min</apellidos>
            <username>Admin</username>
            <password>123</password>
            <rol>admin</rol>          <!-- admin | arbitro | invitado | usuario -->
        </usuario>
    </usuarios>

    <temporadas>
        <temporada>
            <id>2024-2025</id>        <!-- ID coincide con nombre de carpeta de imágenes -->
            <equipos>
                <equipo>
                    <id>E001</id>
                    <nombre>Barcelona</nombre>
                    <ganados>8</ganados>
                    <perdidos>2</perdidos>
                    <empatados>0</empatados>
                    <golesFavor>271</golesFavor>
                    <golesContra>194</golesContra>
                    <jugadores>
                        <jugador>
                            <equipo>E001</equipo>       <!-- referencia al ID del equipo -->
                            <id>JU00100</id>
                            <nombre>Diego Pacheco</nombre>
                            <edad>25</edad>
                            <nacionalidad>España</nacionalidad>
                            <altura>180 cm</altura>
                            <peso>80 kg</peso>
                            <dorsal>46</dorsal>
                            <posicion>Portero</posicion>
                            <foto>J10000001.png</foto>   <!-- solo nombre de archivo -->
                        </jugador>
                    </jugadores>
                    <escudo>
                        <url>./imagenes/imagenes_Logos/BARCELONA.png</url>
                    </escudo>
                </equipo>
            </equipos>
            <jornadas>
                <jornada>
                    <id>J01</id>
                    <partidos>
                        <partido>
                            <local>E001</local>          <!-- ID de equipo -->
                            <visitante>E002</visitante>
                            <id>P001</id>
                            <golesLocal>2</golesLocal>
                            <golesVisitante>15</golesVisitante>
                            <estado>Finalizado</estado>
                        </partido>
                    </partidos>
                </jornada>
            </jornadas>
        </temporada>

        <temporada>
            <id>2025-2026</id>
            <!-- misma estructura -->
        </temporada>
    </temporadas>

</federacionBalonmano>
```

### Datos actuales
- **2 temporadas:** `2024-2025` y `2025-2026`
- **6 equipos por temporada:** E001 Barcelona, E002 Granada, E003 Sevilla, E004 Zaragoza, E005 Valencia, E006 Athletic Club
- **~10 jugadores por equipo**
- **3 usuarios:** Admin/123 (admin), Arbitro/123 (arbitro), Invitado/123 (invitado)

---

## XSL: convenciones y patrones

### Parámetros estándar

Todos los XSL reciben `$temporadaId` desde PHP. Los de detalle también reciben `$equipoId` o `$jugadorId`.

### XPath con el nuevo XML (elementos hijo, no atributos)

```xsl
<!-- CORRECTO -->
<xsl:for-each select="//temporada[id=$temporadaId]/equipos/equipo">
<xsl:variable name="equipo" select="//temporada[id=$temporadaId]/equipos/equipo[id=$equipoId]"/>
<xsl:variable name="jugador" select="//temporada[id=$temporadaId]//jugador[id=$jugadorId]"/>

<!-- INCORRECTO (formato antiguo) -->
<xsl:for-each select="//temporada[@id=$temporadaId]/equipos/equipo[@id=$equipoId]">
```

### Ruta de imagen de jugador

```xsl
<!-- La foto en el XML solo contiene el nombre de archivo -->
<img src="{concat('imagenes/imagenes_jugadores/', $temporadaId, '/', foto)}"
     onerror="this.src='imagenes/imagenes_jugadores/jugador-default.png'"/>

<!-- Para jugador variable: -->
<img src="{concat('imagenes/imagenes_jugadores/', $temporadaId, '/', $jugador/foto)}"/>
```

### Escudo de equipo

```xsl
<xsl:choose>
    <xsl:when test="escudo/url != ''">
        <img src="{escudo/url}" onerror="this.src='imagenes/imagenes_Logos/logoFederacion.webp'"/>
    </xsl:when>
    <xsl:otherwise>
        <img src="imagenes/imagenes_Logos/logoFederacion.webp"/>
    </xsl:otherwise>
</xsl:choose>
```

### Links de navegación

```xsl
<a href="index.php?page=equipo&amp;id={id}">...</a>
<a href="index.php?page=jugador&amp;id={id}">...</a>
```

### Lookup de equipo por ID (en jornadas)

```xsl
<xsl:variable name="equipos" select="//temporada[id=$temporadaId]/equipos"/>
<xsl:variable name="localId" select="local"/>
<xsl:value-of select="$equipos/equipo[id=$localId]/nombre"/>
```

### Últimos N partidos (XSLT 1.0)

```xsl
<xsl:variable name="partidos" select="$jornadas/jornada/partidos/partido[estado='Finalizado']"/>
<xsl:variable name="total" select="count($partidos)"/>
<xsl:for-each select="$partidos">
    <xsl:if test="position() > $total - 3">
        <!-- solo los últimos 3 -->
    </xsl:if>
</xsl:for-each>
```

---

## PHP: convenciones

### Leer ID de temporada desde XML (DOMDocument)

```php
// CORRECTO — el ID es elemento hijo <id>
$nodosTmp = $xpath->query('//temporadas/temporada');
foreach ($nodosTmp as $t) {
    $idNode = $xpath->query('id', $t)->item(0);
    if ($idNode) {
        $temporadas[] = $idNode->textContent;
    }
}

// INCORRECTO — el ID ya no es atributo
$t->getAttribute('id');
```

### Validar existencia de temporada

```php
// CORRECTO
$nodos = $xpath->query('//temporada[id="' . addslashes($temporada) . '"]');

// INCORRECTO
$nodos = $xpath->query('//temporada[@id="' . addslashes($temporada) . '"]');
```

### Validación de parámetros GET

```php
// Equipo: debe coincidir con /^E\d+$/
$equipoId = $_GET['id'] ?? '';
if (!preg_match('/^E\d+$/', $equipoId)) { $equipoId = ''; }

// Jugador: debe coincidir con /^JU\d+$/
$jugadorId = $_GET['id'] ?? '';
if (!preg_match('/^JU\d+$/', $jugadorId)) { $jugadorId = ''; }
```

### Función transformarXML

```php
function transformarXML(DOMDocument $xml, string $xslFile, array $params = []): string {
    // Carga XSL_PATH . $xslFile
    // Pasa $params como setParameter('', key, value)
    // Devuelve HTML string o <div class="error">...</div>
}
```

---

## Sesión

| Clave | Contenido | Cuándo existe |
|---|---|---|
| `$_SESSION['temporada']` | ID de temporada, ej: `"2024-2025"` | Siempre (se inicializa con la primera temporada del XML) |
| `$_SESSION['username']` | Nombre de usuario | Tras login exitoso |
| `$_SESSION['nombre']` | Nombre real del usuario | Tras login exitoso |
| `$_SESSION['apellidos']` | Apellidos | Tras login exitoso |
| `$_SESSION['rol']` | `admin` / `arbitro` / `invitado` | Tras login exitoso |
| `$_SESSION['login_error']` | Mensaje de error | Tras login fallido (se limpia en header.php) |

---

## CSS: clases principales

| Clase | Elemento | Descripción |
|---|---|---|
| `.page-inicio` | div raíz inicio | Contenedor de toda la página inicio |
| `.hero` | section | Banner principal con logo y título |
| `.inicio-seccion` | section | Cada sección del inicio (card blanca con sombra) |
| `.seccion-titulo` | h2 | Título de sección con borde rojo inferior |
| `.partido-card` | div | Tarjeta de partido con escudos y resultado |
| `.stats-grid` | div | Grid de 4 cifras estadísticas |
| `.stat-card` | div | Número grande + label |
| `.equipos-grid-inicio` | div | Flex wrap de escudos en inicio |
| `.equipos-grid` | div | Grid de tarjetas de equipo |
| `.equipo-card` | a | Tarjeta de equipo con escudo e info |
| `.jugadores-grid` | div | Grid de tarjetas de jugador |
| `.jugador-card` | a | Tarjeta de jugador con foto e info |
| `.escudo-img` | img | Escudo en grid de equipos |
| `.escudo-grande` | img | Escudo en detalle de equipo |
| `.escudo-mini` | img | Escudo en tabla de clasificación |
| `.escudo-partido` | img | Escudo en tarjeta de partido |
| `.foto-jugador` | img | Foto en grid de jugadores |
| `.foto-grande` | img | Foto en detalle de jugador |
| `.tabla-clasificacion` | table | Tabla de clasificación |
| `.ficha-table` | table | Tabla de datos del jugador |
| `.stats-table` | table | Tabla de estadísticas del equipo |

---

## JavaScript (`validation.js`)

Cuatro funcionalidades, todas en un solo `DOMContentLoaded`:

1. **Menú hamburguesa** — toggle clase `open` en `#siteNav` al pulsar `#hamburger`
2. **Validación login** — previene submit si `loginUsername` o `loginPassword` están vacíos; muestra `.field-error` inline
3. **Auto-submit temporada** — `#selectTemporada` hace submit del formulario `#formTemporada` al cambiar (sin necesidad de pulsar botón)
4. **Fallback imágenes** — listener `error` en todas las imágenes `.foto-jugador`, `.escudo-img`, `.escudo-mini`, `.escudo-grande`, `.foto-grande` para mostrar imagen por defecto

---

## Seguridad implementada

- **Whitelist de páginas** en `index.php` — solo páginas permitidas en `$allowedPages`
- **Control de acceso por rol** — `gestion_usuarios` redirige a inicio si `$_SESSION['rol'] !== 'admin'`
- **`addslashes()`** en queries XPath con datos del usuario en `cambiar_temporada.php`
- **`htmlspecialchars()`** en toda salida de datos de sesión en `header.php`
- **`preg_match()`** para validar formato de IDs en parámetros GET (`E\d+`, `JU\d+`)
- **Verificación de método POST** en los tres scripts de funcionalidades

---

## Errores frecuentes y causas

| Error | Causa |
|---|---|
| `Class "XSLTProcessor" not found` | La extensión `extension=xsl` está comentada en `php.ini` de XAMPP |
| Temporada no cambia al usar el selector | XPath con `[@id=]` en vez de `[id=]` en `cambiar_temporada.php` |
| Escudos no aparecen | `escudo/@url` en XSL en vez de `escudo/url` |
| Fotos de jugadores no aparecen | `foto/@url` en XSL en vez de ruta construida con `concat(...)` |
| Página en blanco / error XSLT | Mismatch entre XPath con atributos y XML con elementos hijo |
| Selector de temporada no lista las temporadas | `$t->getAttribute('id')` en vez de leer el elemento `<id>` hijo |
