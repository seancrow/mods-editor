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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:x="dummy" xmlns:fd="http://apache.org/cocoon/forms/1.0#definition" xmlns:ft="http://apache.org/cocoon/forms/1.0#template" xmlns:fi="http://apache.org/cocoon/forms/1.0#instance" xmlns:jx="http://apache.org/cocoon/templates/jx/1.0" xmlns:str="http://exslt.org/strings"  exclude-result-prefixes="str" extension-element-prefixes="str">
	<xsl:output method="xml" indent="yes"/>
	<!-- use namespace-alias to allow us to specify xsl elements in a dummy namespace, so they won't be interpreted as part 
of this stylesheet -->
	<xsl:namespace-alias stylesheet-prefix="x" result-prefix="xsl"/>
	<!-- convenience variables -->
	<xsl:variable name="brace1">{</xsl:variable>
	<xsl:variable name="brace2">}</xsl:variable>
	<!-- 

main stylesheet element 

-->
	<xsl:template match="/">
		<x:stylesheet version="1.0" xmlns:fd="http://apache.org/cocoon/forms/1.0#definition" xmlns:ft="http://apache.org/cocoon/forms/1.0#template" xmlns:fi="http://apache.org/cocoon/forms/1.0#instance" xmlns:jx="http://apache.org/cocoon/templates/jx/1.0" xmlns:fb="http://apache.org/cocoon/forms/1.0#binding">
			<!-- identity transformation -->
			<x:template match="* | @* | text() | comment()">
				<x:copy>
					<x:apply-templates select="* | @* | text() | comment()"/>
				</x:copy>
			</x:template>
			<xsl:apply-templates select="*"/>
		</x:stylesheet>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<!-- 

Suppression

-->
	<!-- handle top-level classes -->
	<xsl:template match="suppress">
		<xsl:comment>&#x0a;Suppress classes and fields&#x0a;</xsl:comment>
		<xsl:apply-templates select="*"/>
	</xsl:template>
	<xsl:template match="suppress/class">
		<xsl:comment>Remove <xsl:value-of select="."/> class.</xsl:comment>
		<x:template match="*[@id='{.}-class' or @id='{.}-group']"/>
	</xsl:template>
	<xsl:template match="suppress/field">
		<xsl:param name="mode"/>
		<xsl:variable name="class" select="@class | ancestor::subclass[1]/@class"/>
		<xsl:variable name="field" select="."/>
		<xsl:comment>Remove "<xsl:value-of select="$field"/>" field from class <xsl:choose>
				<xsl:when test="$mode != ''"><xsl:value-of select="$mode"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$class"/></xsl:otherwise>
			</xsl:choose>.</xsl:comment>
		<x:template match="fd:class[@id='{$class}-class']//fd:field[@id='{$field}']">
			<xsl:if test="$mode != ''"><xsl:attribute name="mode"><xsl:value-of select="$mode"/></xsl:attribute></xsl:if>
			<x:comment>Localization: removed <xsl:value-of select="$field"/> field.</x:comment>
		</x:template>
		<x:template match="fb:class[@id='{$class}-class']//fb:value[@id='{$field}']">
			<xsl:if test="$mode != ''"><xsl:attribute name="mode"><xsl:value-of select="$mode"/></xsl:attribute></xsl:if>
			<x:comment>Localization: removed <xsl:value-of select="$field"/> value.</x:comment>
		</x:template>
		<x:template match="ft:class[@id='{$class}-class']//ft:widget[@id='{$field}']">
			<xsl:if test="$mode != ''"><xsl:attribute name="mode"><xsl:value-of select="$mode"/></xsl:attribute></xsl:if>
			<x:comment>Localization: removed <xsl:value-of select="$field"/> widget.</x:comment>
		</x:template>
		<x:template match="ft:class[@id='{$class}-class']//ft:widget-label[@id='{$field}']">
			<xsl:if test="$mode != ''"><xsl:attribute name="mode"><xsl:value-of select="$mode"/></xsl:attribute></xsl:if>
			<x:comment>Localization: removed <xsl:value-of select="$field"/> widget-label.</x:comment>
		</x:template>
	</xsl:template>
	<!-- 

Selection lists

Add a selection list to a given element: for example, specify a list of types for notes. We assume that the element 
is specified within a class (e.g. textfield-class for notes), and that we only want to add the list to a given 
instantiation of that class (i.e. a given <xx:new id="textfield-class"/>). We therefore have to copy the contents of the class 
to replace the <new> element, and add the selection list while we are copying.

We will need other options to add the selection list to the class as a whole rather than to a single instantiation, and to add
selection lists to elements that aren't in a class.
-->
	<!-- simplest case: change the class e.g. common-language-->
	<xsl:template match="selectionlist">
		<xsl:param name="mode"/>
		<xsl:variable name="class" select="@class | ancestor::subclass[1]/@class"/>
		<xsl:for-each select="field">
			<xsl:variable name="field" select="@id"/>
			<xsl:comment>Selection list for field "<xsl:value-of select="$field"/>" in class <xsl:choose>
				<xsl:when test="$mode != ''"><xsl:value-of select="$mode"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$class"/></xsl:otherwise>
			</xsl:choose></xsl:comment>

			<x:template match="fd:class[@id='{$class}-class']/fd:widgets/fd:field[@id='{$field}']">
				<xsl:if test="$mode != ''"><xsl:attribute name="mode"><xsl:value-of select="$mode"/></xsl:attribute></xsl:if>
				<x:copy>
					<x:apply-templates select="* | @* | text() | comment()"/>
					<fd:selection-list>
						<xsl:for-each select="item">
							<fd:item value="{@value}">
								<!-- use copy-of to allow for e.g. i18n tags -->
								<fd:label>
									<xsl:copy-of select="* | text()"/>
								</fd:label>
							</fd:item>
						</xsl:for-each>
					</fd:selection-list>
				</x:copy>
			</x:template>
			<xsl:apply-templates select="styling">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>


	<xsl:template match="styling">
		<!-- note: parent is <field id="xxx"> and grandparent is <selectionlist class="yyy"> 
				so: field id is ../@id and class id is ../../@class
		-->
		<xsl:param name="mode"/>
		<xsl:variable name="field" select="../@id"/>
		<xsl:variable name="class" select="../../@class | ancestor::subclass[1]/@class"/>
		<x:template match="ft:class[@id='{$class}-class']//ft:widget[@id='{$field}']/fi:styling">
			<xsl:if test="$mode != ''"><xsl:attribute name="mode"><xsl:value-of select="$mode"/></xsl:attribute></xsl:if>
			<!-- if the new <styling> element has no attributes, suppress the <fi:styling> element in output -->
			<x:comment>Localization: modified styling</x:comment>
			<xsl:if test="@*">
				<fi:styling>
					<xsl:copy-of select="@*"/>
				</fi:styling>
			</xsl:if>
		</x:template>
	</xsl:template>
	<xsl:template match="subclass">
		<xsl:variable name="class" select="@class"/>
		<xsl:variable name="userclasses" select="@userclasses"/>
		<!-- if source class name is "foo" for use by "bar" and "yip", subclass name will be "foo-subclass-bar-yip" -->
		<xsl:variable name="subclass" select="concat($class, '-subclass-', translate(normalize-space($userclasses), ' ', '-'))"/>
	
		<xsl:comment>Subclass of <xsl:value-of select="$class"/> for use by <xsl:value-of select="$userclasses"/></xsl:comment>
		<xsl:comment>identity transformation for this subclass</xsl:comment>
		<x:template match="* | @* | text() | comment()" mode="{$subclass}">
			<x:copy>
				<x:apply-templates select="* | @* | text() | comment()" mode="{$subclass}"/>
			</x:copy>
		</x:template>
		<!-- cause the new subclass to be inserted instead of the old class -->
		<xsl:for-each select="str:tokenize($userclasses)">
		<x:template match="fd:class[@id='{.}-class']//fd:new[@id='{$class}-class'] | fb:class[@id = '{.}-class']//fb:new[@id='{$class}-class'] | ft:class[@id = '{.}-class']//ft:new[@id='{$class}-class']">
			<x:copy>
				<x:attribute name="id"><xsl:value-of select="$subclass"/></x:attribute>
			</x:copy>
		</x:template>
		</xsl:for-each>
		<!-- suppress fields -->
		<xsl:if test="suppress">
			<xsl:comment>Suppress fields</xsl:comment>
			<xsl:apply-templates select="suppress"/>
		</xsl:if>
		<!-- insert selection lists -->
		<xsl:if test="selectionlist">
			<xsl:comment>Insert selection lists</xsl:comment>
			<xsl:apply-templates select="selectionlist">
				<xsl:with-param name="mode" select="$subclass"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
		<!-- suppress a given field from a given instance of a given class:
		This is done by generating a new version of the class, modified as required, and causing that version to be instantiated where required instead
		of the original version. -->
	<xsl:template match="subclass/suppress">
		<xsl:variable name="class" select="../@class"/>
		<xsl:variable name="userclasses" select="../@userclasses"/>
		<!-- if source class name is "foo" for use by "bar" and "yip", subclass name will be "foo-subclass-bar-yip" -->
		<xsl:variable name="subclass" select="concat($class, '-subclass-', translate(normalize-space($userclasses), ' ', '-'))"/>
		
		<x:template match="fd:class[@id='{$class}-class'] | fb:class[@id = '{$class}-class'] | ft:class[@id = '{$class}-class']">
			<x:copy>
				<x:apply-templates select="* | @* | text() | comment()"/>
			</x:copy>
			<x:comment>Localization: Subclass of <xsl:value-of select="$class"/> for use by <xsl:value-of select="$userclasses"/></x:comment>
			<x:copy>
				<x:apply-templates select="@*[name() != 'id']"/>
				<x:attribute name="id"><xsl:value-of select="$subclass"/></x:attribute>
				<x:apply-templates select="* | text() | comment()" mode="{$subclass}"/>
			</x:copy>
		</x:template> 
		<xsl:apply-templates select="field">
			<xsl:with-param name="mode" select="$subclass"/>
		</xsl:apply-templates>
	</xsl:template>
	
</xsl:stylesheet>
