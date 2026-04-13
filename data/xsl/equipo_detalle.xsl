<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:param name="temporadaId"/>
<xsl:param name="equipoId"/>

<xsl:template match="/">
    <xsl:variable name="equipo" select="//temporada[id=$temporadaId]/equipos/equipo[id=$equipoId]"/>
    <div class="page-equipo-detalle">
        <xsl:choose>
            <xsl:when test="$equipo">
                <div class="equipo-header">
                    <div class="equipo-escudo-grande">
                        <xsl:choose>
                            <xsl:when test="$equipo/escudo/url != ''">
                                <img src="{$equipo/escudo/url}" alt="{$equipo/nombre}" class="escudo-grande"
                                     onerror="this.src='imagenes/imagenes_Logos/logoFederacion.webp'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <img src="imagenes/imagenes_Logos/logoFederacion.webp" alt="Sin escudo" class="escudo-grande"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="equipo-datos">
                        <h1><xsl:value-of select="$equipo/nombre"/></h1>
                        <table class="stats-table">
                            <tr><th>Victorias</th><td><xsl:value-of select="$equipo/ganados"/></td></tr>
                            <tr><th>Empates</th><td><xsl:value-of select="$equipo/empatados"/></td></tr>
                            <tr><th>Derrotas</th><td><xsl:value-of select="$equipo/perdidos"/></td></tr>
                            <tr><th>Goles a favor</th><td><xsl:value-of select="$equipo/golesFavor"/></td></tr>
                            <tr><th>Goles en contra</th><td><xsl:value-of select="$equipo/golesContra"/></td></tr>
                            <tr><th>Diferencia</th><td><xsl:value-of select="$equipo/golesFavor - $equipo/golesContra"/></td></tr>
                            <tr><th>Puntos</th><td class="puntos"><xsl:value-of select="$equipo/ganados * 2 + $equipo/empatados"/></td></tr>
                        </table>
                    </div>
                </div>

                <h2 class="plantilla-titulo">Plantilla</h2>
                <div class="jugadores-grid">
                    <xsl:for-each select="$equipo/jugadores/jugador">
                        <a href="index.php?page=jugador&amp;id={id}" class="jugador-card">
                            <div class="jugador-foto">
                                <xsl:choose>
                                    <xsl:when test="foto != ''">
                                        <img src="{concat('imagenes/imagenes_jugadores/', $temporadaId, '/', foto)}" alt="{nombre}" class="foto-jugador"
                                             onerror="this.src='imagenes/imagenes_jugadores/jugador-default.png'"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <img src="imagenes/imagenes_jugadores/jugador-default.png" alt="Sin foto" class="foto-jugador"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </div>
                            <div class="jugador-info">
                                <h3><xsl:value-of select="nombre"/></h3>
                                <p class="jugador-dorsal">#<xsl:value-of select="dorsal"/></p>
                                <p class="jugador-posicion"><xsl:value-of select="posicion"/></p>
                            </div>
                        </a>
                    </xsl:for-each>
                </div>
                <div class="back-link">
                    <a href="index.php?page=equipos">&#8592; Volver a equipos</a>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="error">Equipo no encontrado.</div>
            </xsl:otherwise>
        </xsl:choose>
    </div>
</xsl:template>

</xsl:stylesheet>
