<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html"/>
	<xsl:template match="mods-samples">
		<html>
			<head>
				<title>MODS Editor Prototype</title>
				<style type="text/css">
					.yes {background: #afa;}
					.no {background: #faa;}
					.update {font-style: italic; font-size: small;}
				</style>
			</head>
			<body>
				<h1>MODS Editor Prototype</h1>
				<p class="update">Last update: <xsl:value-of select="@last-update"/></p>
				<xsl:copy-of select="intro/*"/>
				<h2>Available records:</h2>
				<ul>
					<xsl:apply-templates select="item"/>
				</ul>
				<h2>Top-level Elements Included</h2>
				<p>(at least in a preliminary way)</p>
				<table border="1">
					<xsl:apply-templates select="work/element"/>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="item">
		<li>
			<a href="edit/mods/{@file}.html"><xsl:value-of select="@type"/></a> (<a href="view/mods/{@file}.xml">xml</a>)
		</li>
	</xsl:template>
	<xsl:template match="element">
		<tr>
			<td><xsl:value-of select="@name"/></td>
			<td class="{@done}"><xsl:value-of select="@done"/></td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
