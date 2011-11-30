<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:quakeml="http://quakeml.org/xmlns/quakeml/1.0"
    xmlns:geonet="http://www.geonet.org.nz"
    xpath-default-namespace="http://quakeml.org/xmlns/quakeml/1.0">

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
xslt template to transform quake events in seiscomp3 xml document into simple event xml
 -->
    <xsl:output method="text" indent="no" standalone="yes"/>

    <xsl:template match="/quakeml">
        <xsl:apply-templates select="eventParameters/event"/>
    </xsl:template>




    <xsl:template match="event">
        <xsl:variable name="preferredOriginID" select="preferredOriginID"/>
        <xsl:variable name="preferredMagnitudeID" select="preferredMagnitudeID"/>
        <xsl:variable name="publicID" select="@publicID"/>

        <xsl:apply-templates select="origin">
            <xsl:with-param name="preferredOriginID" select="$preferredOriginID"/>
            <xsl:with-param name="preferredMagnitudeID" select="$preferredMagnitudeID"/>
            <xsl:with-param name="publicID" select="$publicID"/>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="eventParameters/event/pick">
        <xsl:param name="pickID" as="xs:string"/>
        <xsl:param name="originTime" as="xs:dateTime"></xsl:param>
        <xsl:param name="phaseName" as="xs:string"/>
        <xsl:if test="@publicID=$pickID">
            <xsl:value-of
                select="waveformID/@networkCode, waveformID/@stationCode, waveformID/@locationCode, waveformID/@channelCode, $phaseName, geonet:epoch(time/value), string(''), geonet:pickTimeDiff($originTime, time/value), time/upperUncertainty, $newline"
            />
        </xsl:if>
    </xsl:template>

    <xsl:template match="event/origin">
        <xsl:param name="preferredOriginID"/>
        <xsl:param name="preferredMagnitudeID"/>
        <xsl:param name="publicID"/>

        <xsl:if test="@publicID=$preferredOriginID">

            <xsl:value-of
                select="string('#'), geonet:epoch(time/value), year-from-dateTime(time/value), month-from-dateTime(time/value), day-from-dateTime(time/value), hours-from-dateTime(time/value), minutes-from-dateTime(time/value), seconds-from-dateTime(time/value), longitude/value, latitude/value, depth/value, string('')"/>
            
            <xsl:variable name="originTime" select="time/value"/>
            
            <xsl:apply-templates select="../magnitude">
                <xsl:with-param name="preferredMagnitudeID" select="$preferredMagnitudeID"/>
            </xsl:apply-templates>

            <xsl:value-of select="string(''), $publicID"/>

            <xsl:value-of select="$newline"/>

            <xsl:for-each select="arrival">
                <xsl:apply-templates select="../../pick">
                    <xsl:with-param name="pickID" select="pickID"/>
                    <xsl:with-param name="originTime" select="$originTime"/>
                    <xsl:with-param name="phaseName" select="phase"/>
                </xsl:apply-templates>
            </xsl:for-each>

        </xsl:if>
    </xsl:template>

    <xsl:template match="magnitude">
        <xsl:param name="preferredMagnitudeID"/>
        <xsl:if test="@publicID=$preferredMagnitudeID">
            <xsl:value-of select="mag/value"/>
        </xsl:if>
    </xsl:template>

    <xsl:variable name="newline">
        <xsl:text>&#xa;</xsl:text>
    </xsl:variable>
    
    <xsl:function name="geonet:epoch">
        <xsl:param name="dt" as="xs:dateTime"/>
        <xsl:value-of
            select="($dt - xs:dateTime('1970-01-01T00:00:00Z')) div xs:dayTimeDuration('PT1S')"/>
    </xsl:function>
    
    <xsl:function name="geonet:pickTimeDiff">
        <xsl:param name="originTime" as="xs:dateTime"/>
        <xsl:param name="pickTime" as="xs:dateTime"/>
        <xsl:variable name="diff" select="$pickTime - $originTime"/>
        <xsl:value-of separator=":" select="format-number(hours-from-duration($diff),'00'), format-number(minutes-from-duration($diff),'00'), format-number(seconds-from-duration($diff), '00.00')"></xsl:value-of>
    </xsl:function>

</xsl:stylesheet>