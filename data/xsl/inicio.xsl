<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:param name="temporadaId"/>

<xsl:template match="/">
    <xsl:variable name="equipos"  select="//temporada[id=$temporadaId]/equipos"/>
    <xsl:variable name="jornadas" select="//temporada[id=$temporadaId]/jornadas"/>
    <xsl:variable name="partidos" select="$jornadas/jornada/partidos/partido[estado='Finalizado']"/>
    <xsl:variable name="totalPartidos" select="count($partidos)"/>

    <div class="page-inicio">

        <!-- ── HERO ─────────────────────────────────────────────────── -->
        <section class="hero">
            <img src="imagenes/imagenes_Logos/logoFederacion.webp"
                 alt="Federación Española de Balonmano" class="hero-logo"/>
            <div class="hero-text">
                <h1>Federación Española de Balonmano</h1>
                <p class="hero-subtitle">Liga Nacional — Temporada <xsl:value-of select="$temporadaId"/></p>
            </div>
        </section>

        <!-- ── CLASIFICACIÓN ─────────────────────────────────────────── -->
        <section class="inicio-seccion">
            <h2 class="seccion-titulo">Clasificación</h2>
            <table class="tabla-clasificacion">
                <thead>
                    <tr>
                        <th>Pos</th>
                        <th colspan="2">Equipo</th>
                        <th title="Victorias">V</th>
                        <th title="Empates">E</th>
                        <th title="Derrotas">D</th>
                        <th title="Goles a favor">GF</th>
                        <th title="Goles en contra">GC</th>
                        <th title="Diferencia de goles">DG</th>
                        <th title="Puntos">Pts</th>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="$equipos/equipo">
                        <xsl:sort select="ganados * 2 + empatados" data-type="number" order="descending"/>
                        <xsl:sort select="golesFavor - golesContra" data-type="number" order="descending"/>
                        <tr>
                            <td class="pos"><xsl:value-of select="position()"/></td>
                            <td class="escudo-cell">
                                <a href="index.php?page=equipo&amp;id={id}">
                                    <xsl:choose>
                                        <xsl:when test="escudo/url != ''">
                                            <img src="{escudo/url}" alt="{nombre}" class="escudo-mini"
                                                 onerror="this.src='imagenes/imagenes_Logos/logoFederacion.webp'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <img src="imagenes/imagenes_Logos/logoFederacion.webp" alt="Escudo" class="escudo-mini"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </a>
                            </td>
                            <td class="nombre-cell">
                                <a href="index.php?page=equipo&amp;id={id}">
                                    <xsl:value-of select="nombre"/>
                                </a>
                            </td>
                            <td><xsl:value-of select="ganados"/></td>
                            <td><xsl:value-of select="empatados"/></td>
                            <td><xsl:value-of select="perdidos"/></td>
                            <td><xsl:value-of select="golesFavor"/></td>
                            <td><xsl:value-of select="golesContra"/></td>
                            <td><xsl:value-of select="golesFavor - golesContra"/></td>
                            <td class="puntos"><xsl:value-of select="ganados * 2 + empatados"/></td>
                        </tr>
                    </xsl:for-each>
                </tbody>
            </table>
            <div class="seccion-link">
                <a href="index.php?page=clasificacion" class="btn-card">Ver clasificación completa</a>
            </div>
        </section>

        <!-- ── ÚLTIMOS 3 PARTIDOS ─────────────────────────────────────── -->
        <section class="inicio-seccion">
            <h2 class="seccion-titulo">Últimos partidos</h2>
            <div class="ultimos-partidos">
                <xsl:for-each select="$partidos">
                    <xsl:if test="position() > $totalPartidos - 3">
                        <xsl:variable name="localId"     select="local"/>
                        <xsl:variable name="visitanteId" select="visitante"/>
                        <xsl:variable name="localNombre"     select="$equipos/equipo[id=$localId]/nombre"/>
                        <xsl:variable name="visitanteNombre" select="$equipos/equipo[id=$visitanteId]/nombre"/>
                        <xsl:variable name="localEscudo"     select="$equipos/equipo[id=$localId]/escudo/url"/>
                        <xsl:variable name="visitanteEscudo" select="$equipos/equipo[id=$visitanteId]/escudo/url"/>
                        <div class="partido-card">
                            <div class="partido-equipo-bloque">
                                <xsl:choose>
                                    <xsl:when test="$localEscudo != ''">
                                        <img src="{$localEscudo}" alt="{$localNombre}" class="escudo-partido"
                                             onerror="this.src='imagenes/imagenes_Logos/logoFederacion.webp'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <img src="imagenes/imagenes_Logos/logoFederacion.webp" alt="Escudo" class="escudo-partido"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <span class="partido-nombre-equipo"><xsl:value-of select="$localNombre"/></span>
                            </div>
                            <div class="partido-resultado-bloque">
                                <span class="resultado-grande">
                                    <xsl:value-of select="golesLocal"/>
                                    <span class="resultado-guion"> — </span>
                                    <xsl:value-of select="golesVisitante"/>
                                </span>
                                <span class="partido-estado-badge"><xsl:value-of select="estado"/></span>
                            </div>
                            <div class="partido-equipo-bloque">
                                <xsl:choose>
                                    <xsl:when test="$visitanteEscudo != ''">
                                        <img src="{$visitanteEscudo}" alt="{$visitanteNombre}" class="escudo-partido"
                                             onerror="this.src='imagenes/imagenes_Logos/logoFederacion.webp'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <img src="imagenes/imagenes_Logos/logoFederacion.webp" alt="Escudo" class="escudo-partido"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <span class="partido-nombre-equipo"><xsl:value-of select="$visitanteNombre"/></span>
                            </div>
                        </div>
                    </xsl:if>
                </xsl:for-each>
            </div>
            <div class="seccion-link">
                <a href="index.php?page=jornadas" class="btn-card">Ver todas las jornadas</a>
            </div>
        </section>

        <!-- ── ESTADÍSTICAS DE LA TEMPORADA ──────────────────────────── -->
        <section class="inicio-seccion">
            <h2 class="seccion-titulo">Estadísticas de la temporada</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <span class="stat-numero"><xsl:value-of select="count($equipos/equipo)"/></span>
                    <span class="stat-label">Equipos</span>
                </div>
                <div class="stat-card">
                    <span class="stat-numero"><xsl:value-of select="count($equipos/equipo/jugadores/jugador)"/></span>
                    <span class="stat-label">Jugadores</span>
                </div>
                <div class="stat-card">
                    <span class="stat-numero"><xsl:value-of select="$totalPartidos"/></span>
                    <span class="stat-label">Partidos jugados</span>
                </div>
                <div class="stat-card">
                    <span class="stat-numero">
                        <xsl:value-of select="sum($partidos/golesLocal) + sum($partidos/golesVisitante)"/>
                    </span>
                    <span class="stat-label">Goles totales</span>
                </div>
            </div>
        </section>

        <!-- ── EQUIPOS PARTICIPANTES ──────────────────────────────────── -->
        <section class="inicio-seccion">
            <h2 class="seccion-titulo">Equipos participantes</h2>
            <div class="equipos-grid-inicio">
                <xsl:for-each select="$equipos/equipo">
                    <a href="index.php?page=equipo&amp;id={id}" class="equipo-card-inicio">
                        <xsl:choose>
                            <xsl:when test="escudo/url != ''">
                                <img src="{escudo/url}" alt="{nombre}" class="escudo-inicio"
                                     onerror="this.src='imagenes/imagenes_Logos/logoFederacion.webp'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <img src="imagenes/imagenes_Logos/logoFederacion.webp" alt="Sin escudo" class="escudo-inicio"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <span class="equipo-nombre-inicio"><xsl:value-of select="nombre"/></span>
                    </a>
                </xsl:for-each>
            </div>
        </section>

    </div>
</xsl:template>

</xsl:stylesheet>
