<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3">
	<xsl:output method="xml"/>
	<xsl:template match="*">
		<xsl:element name="{translate(name(), ':', '_')}">
			<xsl:apply-templates select="@* | * | text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="mods:*">
		<xsl:element name="mods_{local-name()}">
			<xsl:attribute name="temp_id"><xsl:value-of select="position()"/></xsl:attribute>
			<xsl:apply-templates select="@* | * | text()[normalize-space(.) != '']"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:attribute name="{translate(name(), ':', '_')}"><xsl:value-of select="."/></xsl:attribute>
	</xsl:template>
	<xsl:template match="mods:typeOfResource/@collection | mods:typeOfResource/@manuscript">
		<xsl:attribute name="{name()}"><xsl:choose><xsl:when test=". = 'yes'">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<!-- collapse dates into single element with type attribute -->
	<xsl:template match="mods:dateIssued | mods:dateCreated | mods:dateCaptured | mods:dateValid | mods:dateModified | mods:copyrightDate | mods:dateOther">
		<temp_date>
			<xsl:attribute name="temp_type"><xsl:value-of select="local-name()"/></xsl:attribute>
			<xsl:attribute name="temp_id"><xsl:value-of select="position()"/></xsl:attribute>
			<xsl:apply-templates select="@* | * | text()[normalize-space(.) != '']"/>
		</temp_date>
	</xsl:template>
</xsl:stylesheet>
