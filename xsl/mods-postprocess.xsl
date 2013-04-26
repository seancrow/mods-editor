<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2005, 2007, 2008 University of Alberta Libraries  
    
This file is part of MODS Editor.

MODS Editor is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

MODS Editor is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MODS Editor.  If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- post-process MODS records after binding from the form, to return them to proper MODS

NOTE: this runs before add-namespaces.xsl, so all MODS elements are in the form "mods_xxx" -->
	<xsl:output method="xml" indent="yes" encoding="utf-8"/>
	<!-- identity transformation -->
	<xsl:template match="* | @* | text()">
		<xsl:copy>
			<xsl:apply-templates select="* | @* | text()"/>
		</xsl:copy>
	</xsl:template>
	<!-- convert true/false values into yes/no -->
	<xsl:template match="mods_typeOfResource/@collection | mods_typeOfResource/@manuscript">
		<xsl:choose>
			<xsl:when test=". = 'true'">
				<xsl:attribute name="{name()}">yes</xsl:attribute>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<!-- collapse various date elements into single element with type attribute -->
	<xsl:template match="temp_date[@temp_type]">
		<xsl:element name="mods_{@temp_type}">
			<xsl:apply-templates select="@*[not(local-name() = 'temp_type')] | * | text()[normalize-space(.) != '']"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
