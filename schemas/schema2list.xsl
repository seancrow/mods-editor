<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
   exclude-result-prefixes="xs xd"
   version="1.0">
   <xd:doc scope="stylesheet">
      <xd:desc>
         <xd:p><xd:b>Created on:</xd:b> May 3, 2013</xd:p>
         <xd:p><xd:b>Author:</xd:b> peterbinkley</xd:p>
         <xd:p></xd:p>
      </xd:desc>
   </xd:doc>
   <xsl:output method="text"/>
   
   <xsl:template match="/xs:schema">
      <xsl:apply-templates select="xs:element[@name='mods']">
         <xsl:with-param name="path">/</xsl:with-param>
      </xsl:apply-templates>
   </xsl:template>
   
   <xsl:template name="cardinality">
      <xsl:param name="minOccurs"/>
      <xsl:param name="maxOccurs"/>
      <xsl:variable name="min">
         <xsl:choose>
            <xsl:when test="$minOccurs != ''">
               <xsl:value-of select="$minOccurs"/>
            </xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="max">
         <xsl:choose>
            <xsl:when test="$maxOccurs != ''">
               <xsl:value-of select="$maxOccurs"/>
            </xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$min = '1' and $max = '1'"> {1}</xsl:when>
         <xsl:otherwise>
            <xsl:text> {</xsl:text>
            <xsl:value-of select="$min"/>
            <xsl:text>..</xsl:text>
            <xsl:value-of select="$max"/>
            <xsl:text>}</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="xs:element">
      <xsl:param name="path"/>
      <xsl:param name="minOccurs"/>
      <xsl:param name="maxOccurs"/>
      <xsl:variable name="min">
         <xsl:choose>
            <xsl:when test="@minOccurs != ''">
               <xsl:value-of select="@minOccurs"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$minOccurs"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="max">
         <xsl:choose>
            <xsl:when test="@maxOccurs">
               <xsl:value-of select="@maxOccurs"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$maxOccurs"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="newpath">
         <xsl:value-of select="$path"/>
         <xsl:value-of select="@name"/>
         <xsl:text>/</xsl:text>
      </xsl:variable>
      <xsl:value-of select="$newpath"/>
      <xsl:call-template name="cardinality">
         <xsl:with-param name="minOccurs" select="normalize-space($min)"/>
         <xsl:with-param name="maxOccurs" select="normalize-space($max)"/>
      </xsl:call-template>
      <xsl:text>&#x0a;</xsl:text>
      <xsl:apply-templates select="/xs:schema/xs:complexType[@name = current()/@type] | /xs:schema/xs:simpleType[@name = current()/@type]">
         <xsl:with-param name="path" select="$newpath"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="*">
         <xsl:with-param name="path" select="$newpath"/>
      </xsl:apply-templates>
   </xsl:template>
   
   <xsl:template match="*">
      <xsl:param name="path"/>
      <xsl:param name="minOccurs"/>
      <xsl:param name="maxOccurs"/>
      <xsl:text># </xsl:text>
      <xsl:value-of select="local-name()"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="$path"/>
      <xsl:text>&#x0a;</xsl:text>
      <xsl:apply-templates select="*">
         <xsl:with-param name="path" select="$path"/>
         <xsl:with-param name="minOccurs" select="$minOccurs"/>
         <xsl:with-param name="maxOccurs" select="$maxOccurs"/>
      </xsl:apply-templates>
   </xsl:template>
   
   <xsl:template match="xs:group[@ref]">
      <xsl:param name="path"/>
      <xsl:param name="minOccurs"/>
      <xsl:param name="maxOccurs"/>
      <xsl:variable name="min">
         <xsl:choose>
            <xsl:when test="@minOccurs != ''">
               <xsl:value-of select="@minOccurs"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$minOccurs"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="max">
         <xsl:choose>
            <xsl:when test="@maxOccurs">
               <xsl:value-of select="@maxOccurs"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$maxOccurs"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="/xs:schema/xs:group[@name = current()/@ref]">
         <xsl:with-param name="path" select="$path"/>
         <xsl:with-param name="minOccurs" select="$min"/>
         <xsl:with-param name="maxOccurs" select="$max"/>
      </xsl:apply-templates>
      <!-- does this ever happen? -->
      <xsl:apply-templates select="*">
         <xsl:with-param name="path" select="$path"/>
         <xsl:with-param name="minOccurs" select="$min"/>
         <xsl:with-param name="maxOccurs" select="$max"/>
      </xsl:apply-templates>
   </xsl:template>
   
   <xsl:template match="xs:attributeGroup[@ref]">
      <xsl:param name="path"/>
      <xsl:apply-templates select="/xs:schema/xs:attributeGroup[@name = current()/@ref]">
         <xsl:with-param name="path" select="$path"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="*">
         <xsl:with-param name="path" select="$path"/>
      </xsl:apply-templates>
   </xsl:template>

   <xsl:template match="xs:element[@ref]">
      <xsl:param name="path"/>
      <xsl:param name="minOccurs"/>
      <xsl:param name="maxOccurs"/>
      <xsl:variable name="min">
         <xsl:choose>
            <xsl:when test="@minOccurs != ''">
               <xsl:value-of select="@minOccurs"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$minOccurs"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="max">
         <xsl:choose>
            <xsl:when test="@maxOccurs">
               <xsl:value-of select="@maxOccurs"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$maxOccurs"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:apply-templates select="/xs:schema/xs:element[@name = current()/@ref]">
         <xsl:with-param name="path" select="$path"/>
         <xsl:with-param name="minOccurs" select="$min"/>
         <xsl:with-param name="maxOccurs" select="$max"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="*">
         <xsl:with-param name="path" select="$path"/>
         <!-- sub-elements do not inherit minOccurs/maxOccurs, since those apply to the current element -->
      </xsl:apply-templates>
   </xsl:template>
 
   <xsl:template match="xs:choice">
      <xsl:param name="path"/>
      <xsl:param name="minOccurs"/>
      <xsl:param name="maxOccurs"/>
      <!-- choice with minOccurs=1 and maxOccurs=unbounded means you
         must have at least one of one of the options, but no option
         is required to occur. So each option needs minOccurs=0. -->
      <xsl:variable name="min">
         <xsl:choose>
            <xsl:when test="@minOccurs != ''">
               <xsl:value-of select="@minOccurs"/>
            </xsl:when>
            <xsl:when test="$minOccurs != ''">
               <xsl:value-of select="$minOccurs"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="'0'"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="max">
         <xsl:choose>
            <xsl:when test="@maxOccurs">
               <xsl:value-of select="@maxOccurs"/>
            </xsl:when>
            <xsl:when test="$maxOccurs">
               <xsl:value-of select="$maxOccurs"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="'unbounded'"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="*">
         <xsl:with-param name="path" select="$path"/>
         <xsl:with-param name="minOccurs" select="$min"/>
         <xsl:with-param name="maxOccurs" select="$max"/>
      </xsl:apply-templates>
   </xsl:template>

   <xsl:template match="xs:attribute">
      <xsl:param name="path"/>
      <xsl:value-of select="$path"/>
      <xsl:text>@</xsl:text>
      <!-- TODO are there any refs other than xml:lang? -->
      <xsl:value-of select="@name | @ref"/>
      <xsl:text>&#x0a;</xsl:text>
   </xsl:template>
   
   <xsl:template match="xs:extension">
      <xsl:param name="path"/>
      <xsl:if test="starts-with(@base, 'xs:')">
         <xsl:value-of select="$path"/>
         <xsl:value-of select="@base"/>
         <xsl:text>&#x0a;</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="/xs:schema/xs:complexType[@name = current()/@base] | /xs:schema/xs:simpleType[@name = current()/@base]">
         <xsl:with-param name="path" select="$path"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="*">
         <xsl:with-param name="path" select="$path"/>
      </xsl:apply-templates>
   </xsl:template>
   
   <xsl:template match="xs:any">
      <xsl:param name="path"/>
      <xsl:value-of select="$path"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@processContents"/>
      <xsl:call-template name="cardinality">
         <xsl:with-param name="minOccurs" select="normalize-space(@minOccurs)"/>
         <xsl:with-param name="maxOccurs" select="normalize-space(@maxOccurs)"/>
      </xsl:call-template>
      <xsl:text>&#x0a;</xsl:text>
   </xsl:template>
   
   <xsl:template match="xs:restriction">
      <xsl:param name="path"/>
      <xsl:value-of select="$path"/>
      <xsl:value-of select="@base"/>
      <xsl:text> (enumerated)&#x0a;</xsl:text>
   </xsl:template>
   
   <!-- don't recurse into relatedItems, since they are bottomless -->
   <xsl:template match="xs:complexType[@name='relatedItemDefinition']">
      <xsl:param name="path"/>
      <xsl:value-of select="$path"/>
      <xsl:text>*** relatedItemDefinition&#x0a;</xsl:text>
   </xsl:template>
   
</xsl:stylesheet>