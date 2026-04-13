<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:param name="temporadaId"/>

<xsl:template match="/">
    <xsl:variable name="equipos" select="//temporada[id=$temporadaId]/equipos"/>
    <div class="page-jornadas">
        <h1>Jornadas — Temporada <xsl:value-of select="$temporadaId"/></h1>
        <xsl:for-each select="//temporada[id=$temporadaId]/jornadas/jornada">
            <div class="jornada-bloque">
                <h2 class="jornada-titulo">Jornada <xsl:value-of select="id"/></h2>
                <div class="partidos-lista">
                    <xsl:for-each select="partidos/partido">
                        <xsl:variable name="localId"     select="local"/>
                        <xsl:variable name="visitanteId" select="visitante"/>
                        <xsl:variable name="localNombre"     select="$equipos/equipo[id=$localId]/nombre"/>
                        <xsl:variable name="visitanteNombre" select="$equipos/equipo[id=$visitanteId]/nombre"/>
                        <xsl:variable name="localEscudo"     select="$equipos/equipo[id=$localId]/escudo/url"/>
                        <xsl:variable name="visitanteEscudo" select="$equipos/equipo[id=$visitanteId]/escudo/url"/>
                        <div class="partido">
                            <span class="partido-equipo local">
                                <img class="escudo-partido" src="{$localEscudo}" alt="{$localNombre}" onerror="this.src='imagenes/imagenes_Logos/logoFederacion.webp'"/>
                                <xsl:value-of select="$localNombre"/>
                            </span>
                            <span class="partido-resultado">
                                <xsl:choose>
                                    <xsl:when test="estado = 'Finalizado'">
                                        <span class="goles"><xsl:value-of select="golesLocal"/></span>
                                        <span class="guion"> - </span>
                                        <span class="goles"><xsl:value-of select="golesVisitante"/></span>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <span class="sin-jugar">vs</span>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </span>
                            <span class="partido-equipo visitante">
                                <xsl:value-of select="$visitanteNombre"/>
                                <img class="escudo-partido" src="{$visitanteEscudo}" alt="{$visitanteNombre}" onerror="this.src='imagenes/imagenes_Logos/logoFederacion.webp'"/>
                            </span>
                            <span class="partido-estado estado-{estado}">
                                <xsl:value-of select="estado"/>
                            </span>
                        </div>
                    </xsl:for-each>
                </div>
            </div>
        </xsl:for-each>
    </div>
</xsl:template>

</xsl:stylesheet>
