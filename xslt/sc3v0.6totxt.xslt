<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sc3="http://geofon.gfz-potsdam.de/ns/seiscomp3-schema/0.6"
    xpath-default-namespace="http://geofon.gfz-potsdam.de/ns/seiscomp3-schema/0.6">
    <!--  
Copyright 2010, Institute of Geological & Nuclear Sciences Ltd or
third-party contributors as indicated by the @author tags.
 
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
-->

    <!-- 
xslt template to transform quake events in seiscomp3 xml document into simple event txt file
 -->
    <xsl:output method="text" indent="no" standalone="yes"/>

    <xsl:template match="/seiscomp">
        <xsl:value-of select="string('publicID time longitude latitude depth magnitude std_error')"></xsl:value-of>
        <xsl:value-of select="$newline"/>
        
        <xsl:apply-templates select="EventParameters/event"/>
    </xsl:template>

    <xsl:template match="event">
        <xsl:variable name="preferredOriginID" select="preferredOriginID"/>
        <xsl:variable name="preferredMagnitudeID" select="preferredMagnitudeID"/>
        <xsl:variable name="publicID" select="@publicID"/>

        <xsl:apply-templates select="../origin">
            <xsl:with-param name="preferredOriginID" select="$preferredOriginID"/>
            <xsl:with-param name="preferredMagnitudeID" select="$preferredMagnitudeID"/>
            <xsl:with-param name="publicID" select="$publicID"/>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="origin">
        <xsl:param name="preferredOriginID"/>
        <xsl:param name="preferredMagnitudeID"/>
        <xsl:param name="publicID"/>

        <xsl:if test="@publicID=$preferredOriginID">

            <xsl:value-of
                select="$publicID, time/value, longitude/value, latitude/value, depth/value, string('')"/>

            <xsl:apply-templates select="magnitude">
                <xsl:with-param name="preferredMagnitudeID" select="$preferredMagnitudeID"/>
            </xsl:apply-templates>

            <xsl:value-of select="string(''), quality/standardError"/>

            <xsl:value-of select="$newline"/>

        </xsl:if>
    </xsl:template>

    <xsl:template match="magnitude">
        <xsl:param name="preferredMagnitudeID"/>

        <xsl:if test="@publicID=$preferredMagnitudeID">
            <xsl:value-of select="magnitude/value"/>
        </xsl:if>
    </xsl:template>

    <xsl:variable name="newline">
        <xsl:text>&#xa;</xsl:text>
    </xsl:variable>

</xsl:stylesheet>