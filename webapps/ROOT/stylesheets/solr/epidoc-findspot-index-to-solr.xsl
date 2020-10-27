<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a set of EpiDoc documents into a Solr
       index document representing an index of findspots. -->

  <xsl:import href="epidoc-index-utils.xsl" />

  <xsl:param name="index_type" />
  <xsl:param name="subdirectory" />

  <xsl:template match="/">
    <add>
      <xsl:for-each-group select="//tei:provenance[@type='found']//tei:placeName[@type='ancientFindspot'][1]" group-by="concat(@ref,'-',following-sibling::tei:placeName[not(@type)][1]/@ref,'-',following-sibling::tei:placeName[@type='monuList'][1]/@ref)">
        <doc>
          <field name="document_type">
            <xsl:value-of select="$subdirectory" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$index_type" />
            <xsl:text>_index</xsl:text>
          </field>
          <xsl:call-template name="field_file_path" />
          <field name="index_findspot_upper_level">
                <xsl:value-of select="." />
          </field>
          <field name="index_findspot_intermediate_level">
            <xsl:choose>
              <xsl:when test="following-sibling::tei:placeName[not(@type)]">
                <xsl:value-of select="following-sibling::tei:placeName[not(@type)][1]" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_findspot_lower_level">
            <xsl:choose>
              <xsl:when test="following-sibling::tei:placeName[@type='monuList']">
                <xsl:value-of select="following-sibling::tei:placeName[@type='monuList'][1]" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>-</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </field>
          <field name="index_external_resource">
            <xsl:choose>
              <xsl:when test="following-sibling::tei:placeName[@type='monuList']">
                <xsl:value-of select="following-sibling::tei:placeName[@type='monuList'][1]/@ref" />
              </xsl:when>
              <xsl:when test="following-sibling::tei:placeName[not(@type)]">
                <xsl:value-of select="following-sibling::tei:placeName[not(@type)][1]/@ref" />
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="@ref" /></xsl:otherwise>
            </xsl:choose>
          </field>
          <xsl:apply-templates select="current-group()" />
        </doc>
      </xsl:for-each-group>
    </add>
  </xsl:template>

  <xsl:template match="tei:placeName">
    <xsl:call-template name="field_index_instance_location" />
  </xsl:template>

</xsl:stylesheet>