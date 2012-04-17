<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3" exclude-result-prefixes="mods">
	<xsl:output method="xml" indent="yes"/>
	<!-- get rid of the wrapper element "upload" -->
	<xsl:template match="upload">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<!-- normalize order of top-level elements -->
	<xsl:template match="mods_mods">
		<mods:mods>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="mods_titleInfo"/>
			<xsl:apply-templates select="mods_name"/>
			<xsl:apply-templates select="mods_typeOfResource"/>
			<xsl:apply-templates select="mods_genre"/>
			<xsl:apply-templates select="mods_originInfo"/>
			<xsl:apply-templates select="mods_language"/>
			<xsl:apply-templates select="mods_physicalDescription"/>
			<xsl:apply-templates select="mods_abstract"/>
			<xsl:apply-templates select="mods_tableOfContents"/>
			<xsl:apply-templates select="mods_targetAudience"/>
			<xsl:apply-templates select="mods_note"/>
			<xsl:apply-templates select="mods_subject"/>
			<xsl:apply-templates select="mods_classification"/>
			<xsl:apply-templates select="mods_relatedItem"/>
			<xsl:apply-templates select="mods_identifier"/>
			<xsl:apply-templates select="mods_location"/>
			<xsl:apply-templates select="mods_accessCondition"/>
			<xsl:apply-templates select="mods_extension"/>
			<xsl:apply-templates select="mods_recordInfo"/>
		</mods:mods>
	</xsl:template>
	<xsl:template match="*">
		<xsl:variable name="name">
			<xsl:choose>
				<xsl:when test="contains(name(), '_')">
					<xsl:value-of select="substring-after(name(), '_')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="name()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="namespace">
			<xsl:choose>
				<xsl:when test="contains(name(), '_')">
					<xsl:value-of select="substring-before(name(), '_')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="name()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$namespace!=''">
				<xsl:element name="mods:{$name}">
					<xsl:apply-templates select="@* | * | text()"/>
				</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$name}">
					<xsl:apply-templates select="@* | * | text()"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@*">
		<xsl:copy-of select="."/>
	</xsl:template>
<!--	<xsl:template match="@temp_id"/>-->
	<xsl:template match="mods_typeOfResource/@collection | mods_typeOfResource/@manuscript">
		<xsl:if test=". = 'true'">
			<xsl:attribute name="{name()}">yes</xsl:attribute>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
