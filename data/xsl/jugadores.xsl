<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:param name="temporadaId"/>

<xsl:template match="/">
    <div class="page-jugadores">
        <h1>Jugadores — Temporada <xsl:value-of select="$temporadaId"/></h1>
        <div class="jugadores-grid">
            <xsl:for-each select="//temporada[id=$temporadaId]/equipos/equipo/jugadores/jugador">
                <xsl:variable name="equipoNombre" select="parent::jugadores/parent::equipo/nombre"/>
                <xsl:variable name="equipoId" select="parent::jugadores/parent::equipo/id"/>
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
                        <p class="jugador-equipo">
                            <xsl:value-of select="$equipoNombre"/>
                        </p>
                    </div>
                </a>
            </xsl:for-each>
        </div>
    </div>
</xsl:template>

</xsl:stylesheet>
