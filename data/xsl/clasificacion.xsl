<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:param name="temporadaId"/>

<xsl:template match="/">
    <div class="page-clasificacion">
        <h1>Clasificación — Temporada <xsl:value-of select="$temporadaId"/></h1>
        <table class="tabla-clasificacion">
            <thead>
                <tr>
                    <th>Pos</th>
                    <th></th>
                    <th>Equipo</th>
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
                <xsl:for-each select="//temporada[id=$temporadaId]/equipos/equipo">
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
    </div>
</xsl:template>

</xsl:stylesheet>
