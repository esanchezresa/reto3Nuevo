<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
    <div class="page-gestion-usuarios">
        <h1>Gestión de Usuarios</h1>
        <table class="tabla-usuarios">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Nombre</th>
                    <th>Apellidos</th>
                    <th>Usuario</th>
                    <th>Rol</th>
                </tr>
            </thead>
            <tbody>
                <xsl:for-each select="//usuarios/usuario">
                    <tr>
                        <td><xsl:value-of select="position()"/></td>
                        <td><xsl:value-of select="nombre"/></td>
                        <td><xsl:value-of select="apellidos"/></td>
                        <td><xsl:value-of select="username"/></td>
                        <td>
                            <span class="badge badge-{rol}">
                                <xsl:value-of select="rol"/>
                            </span>
                        </td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
    </div>
</xsl:template>

</xsl:stylesheet>
