<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fi="http://apache.org/cocoon/forms/1.0#instance" exclude-result-prefixes="fi">
	<xsl:import href="../resources/forms-advanced-field-styling.xsl"/>
	<!-- get the id of the current author, assuming we are editing an author -->
	<xsl:variable name="thisid" select="/html/body/fi:form-template/div[@class='title']/h2/fi:field[@id='id']/fi:value"/>
	<!--
      | this adds a fi:styling type="link" to widgets of type output
      | it will produce an http link
      -->
	<xsl:template match="fi:field[fi:styling/@type='itemviewlink']">
		<!-- if the current id is the id of the author being edited, just display it; otherwise build a link to view it -->
		<xsl:choose>
			<xsl:when test="fi:value=$thisid">
				<xsl:value-of select="./fi:value"/>
			</xsl:when>
			<xsl:otherwise>
				<a href="../../item/view/{./fi:value}" onclick="this.target='_blank';">
					<xsl:value-of select="./fi:value"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="fi:field[fi:styling/@type='authorviewlink']">
		<xsl:choose>
			<xsl:when test="fi:value=$thisid">
				<xsl:value-of select="./fi:value"/>
			</xsl:when>
			<xsl:otherwise>
				<a href="../../author/view/{./fi:value}" onclick="this.target='_blank';">
					<xsl:value-of select="./fi:value"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="fi:field[fi:styling/@type='peellink']">
		<xsl:choose>
			<xsl:when test="fi:value=$thisid">
				<xsl:value-of select="./fi:value"/>
			</xsl:when>
			<xsl:otherwise>
				<a href="http://peel.library.ualberta.ca/cocoon/peel/{./fi:value}.html" onclick="this.target='_blank';">
					<xsl:value-of select="./fi:value"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
