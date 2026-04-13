<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:param name="temporadaId"/>

<xsl:template match="/">
    <div class="page-equipos">
        <h1>Equipos — Temporada <xsl:value-of select="$temporadaId"/></h1>
        <div class="equipos-grid">
            <xsl:for-each select="//temporada[id=$temporadaId]/equipos/equipo">
                <a href="index.php?page=equipo&amp;id={id}" class="equipo-card">
                    <div class="equipo-escudo">
                        <xsl:choose>
                            <xsl:when test="escudo/url != ''">
                                <img src="{escudo/url}" alt="{nombre}" class="escudo-img"
                                     onerror="this.src='imagenes/imagenes_Logos/logoFederacion.webp'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <img src="imagenes/imagenes_Logos/logoFederacion.webp" alt="Sin escudo" class="escudo-img"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="equipo-info">
                        <h2><xsl:value-of select="nombre"/></h2>
                        <p class="equipo-stats">
                            V: <xsl:value-of select="ganados"/> |
                            E: <xsl:value-of select="empatados"/> |
                            D: <xsl:value-of select="perdidos"/>
                        </p>
                    </div>
                </a>
            </xsl:for-each>
        </div>
    </div>
</xsl:template>

</xsl:stylesheet>
