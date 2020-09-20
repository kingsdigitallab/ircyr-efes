<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of symbols in those
       documents. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:name[@nymRef][ancestor::tei:div/@type='edition']" group-by="@nymRef"> <!-- or "." -->
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_item_name">
            <!--<xsl:choose>
              <xsl:when test="@nymRef">-->
                <xsl:value-of select="@nymRef" />
              <!--</xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="descendant::tei:seg[@part='I']"><xsl:value-of select="." /><xsl:text>-</xsl:text></xsl:when>
                  <xsl:when test="descendant::tei:seg[@part='M']"><xsl:text>-</xsl:text><xsl:value-of select="." /><xsl:text>-</xsl:text></xsl:when>
                  <xsl:when test="descendant::tei:seg[@part='F']"><xsl:text>-</xsl:text><xsl:value-of select="." /></xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="." />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>-->
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:name">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>
