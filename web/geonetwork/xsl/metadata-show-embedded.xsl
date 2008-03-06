<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:geonet="http://www.fao.org/geonetwork" 
	xmlns:xalan= "http://xml.apache.org/xalan"
	xmlns:dc = "http://purl.org/dc/elements/1.1/" 
	xmlns:gmd="http://www.isotc211.org/2005/gmd" 
	xmlns:gco="http://www.isotc211.org/2005/gco">

	<!--
	show metadata form
	-->
	
	<xsl:include href="main.xsl"/>
	<xsl:include href="metadata.xsl"/>
	
	<xsl:variable name="host" select="/root/gui/env/server/host" />
	<xsl:variable name="port" select="/root/gui/env/server/port" />
	<xsl:variable name="baseURL" select="concat('http://',$host,':',$port,/root/gui/url)" />
	<xsl:variable name="serverUrl" select="concat('http://',$host,':',$port,/root/gui/locService)" />
	
	<xsl:template match="/">
		<table width="100%" height="100%">
			
			<!-- content -->
			<tr height="100%"><td>
				<xsl:call-template name="content"/>
			</td></tr>
		</table>
	</xsl:template>
		
	<!--
	page content
	-->
	<xsl:template name="content">
		<xsl:param name="schema">
			<xsl:apply-templates mode="schema" select="."/>
		</xsl:param>
		
		<table  width="100%" height="100%">
			<xsl:for-each select="/root/*[name(.)!='gui' and name(.)!='request']"> <!-- just one -->
				<tr height="100%">
<!--					<td class="blue-content" width="150" valign="top">
						<xsl:call-template name="tab">
							<xsl:with-param name="tabLink" select="concat(/root/gui/locService,'/metadata.show')"/>
						</xsl:call-template>
					</td>-->
					<td class="content" valign="top">
						
						<xsl:variable name="md">
							<xsl:apply-templates mode="brief" select="."/>
						</xsl:variable>
						<xsl:variable name="metadata" select="xalan:nodeset($md)/*[1]"/>
						<xsl:variable name="mdURL" select="normalize-space(concat($baseURL, '?uuid=', geonet:info/uuid))"/>
						
						<xsl:call-template name="socialBookmarks">
							<xsl:with-param name="baseURL" select="$baseURL" /> <!-- The base URL of the local GeoNetwork site -->
							<xsl:with-param name="mdURL" select="$mdURL" /> <!-- The URL of the metadata using the UUID -->
							<xsl:with-param name="title" select="$metadata/title" />
							<xsl:with-param name="abstract" select="$metadata/abstract" />
						</xsl:call-template>
												
						<table width="100%">
						
							<xsl:variable name="buttons">
								<tr><td class="padded-content" height="100%" align="center" valign="top">
									<xsl:call-template name="buttons"/>
								</td></tr>
							</xsl:variable>
							<xsl:if test="$buttons!=''">
								<xsl:copy-of select="$buttons"/>
							</xsl:if>
							<tr>
								<td align="center" valign="left" class="padded-content">
								</td>
							</tr>
							<!-- subtemplate title button -->
							<xsl:if test="(string(geonet:info/isTemplate)='s')">
								<tr><td class="padded-content" height="100%" align="center" valign="top">
									<b><xsl:value-of select="geonet:info/title"/></b>
								</td></tr>
							</xsl:if>

							<tr><td class="padded-content">
								<table class="md" width="100%">
<!--									<form name="mainForm" accept-charset="UTF-8" method="POST" action="{/root/gui/locService}/metadata.edit">
										<input type="hidden" name="id" value="{geonet:info/id}"/>
										<input type="hidden" name="currTab" value="{/root/gui/currTab}"/>
-->										
										<xsl:choose>
											<xsl:when test="$currTab='xml'">
												<xsl:apply-templates mode="xmlDocument" select="."/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates mode="elementEP" select="."/>
											</xsl:otherwise>
										</xsl:choose>
										
<!--									</form>-->
								</table>
							</td></tr>
							
							<xsl:if test="$buttons!=''">
								<xsl:copy-of select="$buttons"/>
							</xsl:if>
							
						</table>
					</td>
				</tr>
			</xsl:for-each>
			<tr>
				<td class="blue-content" />
			</tr>
		</table>
	</xsl:template>
	
</xsl:stylesheet>
