<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:param name="temporadaId"/>
<xsl:param name="jugadorId"/>

<xsl:template match="/">
    <xsl:variable name="jugador" select="//temporada[id=$temporadaId]//jugador[id=$jugadorId]"/>
    <xsl:variable name="equipo"  select="//temporada[id=$temporadaId]/equipos/equipo[id=$jugador/equipo]"/>
    <div class="page-jugador-detalle">
        <xsl:choose>
            <xsl:when test="$jugador">
                <div class="jugador-detalle-contenido">
                    <div class="jugador-foto-grande">
                        <xsl:choose>
                            <xsl:when test="$jugador/foto != ''">
                                <img src="{concat('imagenes/imagenes_jugadores/', $temporadaId, '/', $jugador/foto)}" alt="{$jugador/nombre}" class="foto-grande"
                                     onerror="this.src='imagenes/imagenes_jugadores/jugador-default.png'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <img src="imagenes/imagenes_jugadores/jugador-default.png" alt="Sin foto" class="foto-grande"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="jugador-ficha">
                        <h1><xsl:value-of select="$jugador/nombre"/></h1>
                        <p class="jugador-equipo-link">
                            Equipo: <a href="index.php?page=equipo&amp;id={$jugador/equipo}">
                                <xsl:value-of select="$equipo/nombre"/>
                            </a>
                        </p>
                        <table class="ficha-table">
                            <tr><th>Dorsal</th><td>#<xsl:value-of select="$jugador/dorsal"/></td></tr>
                            <tr><th>Posición</th><td><xsl:value-of select="$jugador/posicion"/></td></tr>
                            <tr><th>Edad</th><td><xsl:value-of select="$jugador/edad"/> años</td></tr>
                            <tr><th>Nacionalidad</th><td><xsl:value-of select="$jugador/nacionalidad"/></td></tr>
                            <tr><th>Altura</th><td><xsl:value-of select="$jugador/altura"/></td></tr>
                            <tr><th>Peso</th><td><xsl:value-of select="$jugador/peso"/></td></tr>
                        </table>
                    </div>
                </div>
                <div class="back-link">
                    <a href="index.php?page=equipo&amp;id={$jugador/equipo}">&#8592; Volver al equipo</a>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="error">Jugador no encontrado.</div>
            </xsl:otherwise>
        </xsl:choose>
    </div>
</xsl:template>

</xsl:stylesheet>
