<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:sc3="http://geofon.gfz-potsdam.de/ns/seiscomp3-schema/0.7">

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
    <xsl:output method="text" encoding="UTF-8" indent="no"/>
    <xsl:variable name="apos">'</xsl:variable>
    <xsl:template match="/sc3:seiscomp">
        <xsl:apply-templates select="sc3:EventParameters/sc3:event"/>
    </xsl:template>

    <xsl:template match="sc3:event">
        <xsl:variable name="preferredOriginID" select="sc3:preferredOriginID"/>
        <xsl:variable name="preferredMagnitudeID" select="sc3:preferredMagnitudeID"/>
        <xsl:variable name="publicID" select="@publicID"/>

        <xsl:value-of select="string('SELECT wfs.add_event(')"/>

        <!-- 1. publicId TEXT -->
        <xsl:value-of select="$apos"/>
        <xsl:value-of select="$publicID"/>
        <xsl:value-of select="$apos"/>
        <xsl:value-of select="string(',')"/>

        <!-- 2. eventtype TEXT -->
        <xsl:call-template name="valueOrNull">
            <xsl:with-param name="value" select="sc3:type"/>
            <xsl:with-param name="isText" select="true()"/>
        </xsl:call-template>
        <xsl:value-of select="string(',')"/>

        <!-- 3. origintime TIMESTAMP -->
        <xsl:value-of select="$apos"/>
        <xsl:value-of select="../sc3:origin[@publicID=$preferredOriginID]/sc3:time/sc3:value"/>
        <xsl:value-of select="$apos"/>
        <xsl:value-of select="string('::timestamptz,')"/>

        <!-- 4. modificationtime TIMESTAMP TODO max not available in xslt version1?? -->
        <xsl:value-of select="$apos"/>
        <!--
            TODO this function only avaiable in xslt version 2.0
            <xsl:value-of select="max((//creationTime|//modificationTime)/xs:dateTime(.))"/>
        -->
        <xsl:call-template name="maximun">
            <xsl:with-param name="dateString" select="//sc3:creationTime|//sc3:modificationTime"/>
        </xsl:call-template>
        <xsl:value-of select="$apos"/>
        <xsl:value-of select="string('::timestamptz,')"/>

        <xsl:apply-templates select="../sc3:origin">
            <xsl:with-param name="preferredOriginID" select="$preferredOriginID"/>
            <xsl:with-param name="preferredMagnitudeID" select="$preferredMagnitudeID"/>
        </xsl:apply-templates>

        <!-- close -->
        <xsl:value-of select="string(');')"/>

    </xsl:template>

    <xsl:template match="sc3:origin">
        <xsl:param name="preferredOriginID"/>
        <xsl:param name="preferredMagnitudeID"/>

        <xsl:if test="@publicID=$preferredOriginID">

            <!-- 5. latitude NUMERIC -->
            <xsl:value-of select="sc3:latitude/sc3:value"/>
            <xsl:value-of select="string(',')"/>

            <!-- 6. longitude NUMERIC -->
            <xsl:value-of select="sc3:longitude/sc3:value"/>
            <xsl:value-of select="string(',')"/>

            <!-- 7. depth NUMERIC -->
            <xsl:value-of select="sc3:depth/sc3:value"/>
            <xsl:value-of select="string(',')"/>

            <!-- 8. magnitude NUMERIC -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value"
                    select="sc3:magnitude[@publicID=$preferredMagnitudeID]/sc3:magnitude/sc3:value"/>
                <xsl:with-param name="isText" select="false()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 9. evaluationMethod TEXT -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value" select="sc3:methodID"/>
                <xsl:with-param name="isText" select="true()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 10. evaluationStatus TEXT -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value" select="sc3:evaluationStatus"/>
                <xsl:with-param name="isText" select="true()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 11. evaluationMode TEXT-->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value" select="sc3:evaluationMode"/>
                <xsl:with-param name="isText" select="true()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 12. earthModel TEXT -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value" select="sc3:earthModelID"/>
                <xsl:with-param name="isText" select="true()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 13. depthType TEXT -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value" select="sc3:depthType"/>
                <xsl:with-param name="isText" select="true()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 14. originError NUMERIC -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value" select="sc3:quality/sc3:standardError"/>
                <xsl:with-param name="isText" select="false()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 15. usedPhaseCount INT -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value" select="sc3:quality/sc3:usedPhaseCount"/>
                <xsl:with-param name="isText" select="false()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 16. usedStationCount INT -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value" select="sc3:quality/sc3:usedStationCount"/>
                <xsl:with-param name="isText" select="false()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 17. minimumDistance NUMERIC  -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value" select="sc3:quality/sc3:minimumDistance"/>
                <xsl:with-param name="isText" select="false()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 18. azimuthalGap NUMERIC -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value" select="sc3:quality/sc3:azimuthalGap"/>
                <xsl:with-param name="isText" select="false()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 19. magnitudeType TEXT -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value"
                    select="sc3:magnitude[@publicID=$preferredMagnitudeID]/sc3:type"/>
                <xsl:with-param name="isText" select="true()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 20. magnitudeUncertainty NUMERIC -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value"
                    select="sc3:magnitude[@publicID=$preferredMagnitudeID]/sc3:magnitude/sc3:uncertainty"/>
                <xsl:with-param name="isText" select="false()"/>
            </xsl:call-template>

            <xsl:value-of select="string(',')"/>

            <!-- 21. magnitudeStationCount INT -->
            <xsl:call-template name="valueOrNull">
                <xsl:with-param name="value"
                    select="sc3:magnitude[@publicID=$preferredMagnitudeID]/sc3:stationCount"/>
                <xsl:with-param name="isText" select="false()"/>
            </xsl:call-template>

        </xsl:if>
    </xsl:template>

    <!-- select empty value as null, also deall with test, add single quota -->
    <xsl:template name="valueOrNull">
        <xsl:param name="value"/>
        <xsl:param name="isText"/>
        <xsl:choose>
            <xsl:when test="string($value) != ''">
                <xsl:if test="$isText = true()">
                    <xsl:value-of select="$apos"/>
                </xsl:if>
                <xsl:value-of select="$value"/>
                <xsl:if test="$isText = true()">
                    <xsl:value-of select="$apos"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'null'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- max value for date string  -->
    <xsl:template name="maximun">
        <xsl:param name="dateString"/>
        <xsl:for-each select="$dateString">
            <xsl:sort select="." data-type="text" order="descending"/>
            <xsl:if test="position()=1">
                <xsl:value-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
