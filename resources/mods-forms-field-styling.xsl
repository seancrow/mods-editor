<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fi="http://apache.org/cocoon/forms/1.0#instance" exclude-result-prefixes="fi">
	<xsl:include href="forms-field-styling.xsl"/>
	<!-- detect the "type" widget for a subject-widget-row; if value is "", make a dropdown, otherwise make it a hidden field -->
	<xsl:template match="fi:field[fi:selection-list][../@class='subject-widget-row']" priority="2">
		<xsl:variable name="value" select="fi:value"/>
		<xsl:comment>value: [<xsl:value-of select="$value"/>]</xsl:comment>
		<xsl:choose>
			<xsl:when test="normalize-space($value)=''">
				<!-- dropdown or listbox -->
				<select title="{fi:hint}" id="{@id}" name="{@id}">
					<xsl:apply-templates select="." mode="styling"/>
					<xsl:for-each select="fi:selection-list/fi:item">
						<option value="{@value}">
							<xsl:if test="@value = $value">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:copy-of select="fi:label/node()"/>
						</option>
					</xsl:for-each>
				</select>
				<xsl:apply-templates select="." mode="common"/>
			</xsl:when>
			<xsl:otherwise>
				<input type="hidden" name="{@id}" id="{@id}" value="{fi:value}">
					<xsl:apply-templates select="." mode="styling"/>
				</input>
				<span class="label">
					<xsl:value-of select="substring-after($value, '_')"/>:</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- don't put moveUp button on first row (i.e. one that has preceding-sibling::div -->
	<xsl:template match="fi:action[fi:label = '▲']">
		<xsl:if test="../../preceding-sibling::div">
			<input id="{@id}" type="submit" name="{@id}" title="{fi:hint}">
				<xsl:attribute name="value"><xsl:value-of select="fi:label/node()"/></xsl:attribute>
				<xsl:apply-templates select="." mode="styling"/>
			</input>
		</xsl:if>
	</xsl:template>
		<!-- don't put moveDown button on last row (i.e. one that has following-sibling::div -->
	<xsl:template match="fi:action[fi:label = '▼']">
		<xsl:if test="../../following-sibling::div[not(contains(@id, 'common-'))]">
			<input id="{@id}" type="submit" name="{@id}" title="{fi:hint}">
				<xsl:attribute name="value"><xsl:value-of select="fi:label/node()"/></xsl:attribute>
				<xsl:apply-templates select="." mode="styling"/>
			</input>
		</xsl:if>
	</xsl:template>
	<!-- don't show add button if there is already an entry in the repeater -->
	<xsl:template match="fi:action[fi:label = '+']">
		<xsl:if test="not(preceding-sibling::div)">
			<input id="{@id}" type="submit" name="{@id}" title="{fi:hint}">
				<xsl:attribute name="value"><xsl:value-of select="fi:label/node()"/></xsl:attribute>
				<xsl:apply-templates select="." mode="styling"/>
			</input>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
