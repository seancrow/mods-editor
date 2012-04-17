<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:zs="http://www.loc.gov/zing/srw/" xmlns:mods="http://www.loc.gov/mods/v3" >

<xsl:template match="/">
	<xsl:copy-of select="/zs:searchRetrieveResponse/zs:records/zs:record[1]/zs:recordData/mods:mods"/>
</xsl:template>

</xsl:stylesheet>
