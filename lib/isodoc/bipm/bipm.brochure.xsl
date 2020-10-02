<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:bipm="https://www.metanorma.org/ns/bipm" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="java" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:param name="svg_images"/>
	<xsl:variable name="images" select="document($svg_images)"/>
	
	<xsl:param name="initial_page_number"/>
	<xsl:param name="doc_split_by_language"/>
	
	<xsl:variable name="pageWidth" select="'210mm'"/>
	<xsl:variable name="pageHeight" select="'297mm'"/>

	

	<!-- DON'T DELETE IT -->
	<!-- IT USES for mn2pdf -->
	<xsl:variable name="coverpages_count">2</xsl:variable><!-- DON'T DELETE IT -->
	

	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="copyrightYear" select="//bipm:bipm-standard/bipm:bibdata/bipm:copyright/bipm:from"/>
	
	<xsl:variable name="doc_first_language" select="(//bipm:bipm-standard)[1]/bipm:bibdata/bipm:language"/>
	
	<xsl:variable name="title-fr" select="//bipm:bipm-standard/bipm:bibdata/bipm:title[@language = 'fr' and @type='main']"/>
	
	<!-- <xsl:variable name="contents">
		<contents>
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
			<xsl:call-template name="processMainSectionsDefault_Contents"/>
		</contents>
	</xsl:variable> -->

	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>

	<xsl:variable name="root-element" select="local-name(/*)"/>

	<xsl:variable name="contents">
	
		
		
		<xsl:choose>
			<xsl:when test="$root-element = 'metanorma-collection'">
			
				<xsl:choose>
					<xsl:when test="$doc_split_by_language = ''"><!-- all documents -->
						<xsl:for-each select="//bipm:bipm-standard">
							<xsl:variable name="lang" select="*[local-name()='bibdata']/*[local-name()='language']"/>
							<xsl:variable name="num"><xsl:number level="any" count="bipm:bipm-standard"/></xsl:variable>
							<xsl:variable name="current_document">
								<xsl:apply-templates select="." mode="change_id">
									<xsl:with-param name="lang" select="$lang"/>
								</xsl:apply-templates>
							</xsl:variable>				
							<xsl:for-each select="xalan:nodeset($current_document)">
								<xsl:variable name="docid">
									<xsl:call-template name="getDocumentId"/>
								</xsl:variable>
								<doc id="{$docid}" lang="{$lang}">
									<xsl:call-template name="generateContents"/>
								</doc>
							</xsl:for-each>				
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="(//bipm:bipm-standard)[*[local-name()='bibdata']/*[local-name()='language'] = $doc_split_by_language]">
							<xsl:variable name="lang" select="*[local-name()='bibdata']/*[local-name()='language']"/>
							<xsl:variable name="num"><xsl:number level="any" count="bipm:bipm-standard"/></xsl:variable>
							<xsl:variable name="current_document">
								<xsl:apply-templates select="." mode="change_id">
									<xsl:with-param name="lang" select="$lang"/>
								</xsl:apply-templates>
							</xsl:variable>				
							<xsl:for-each select="xalan:nodeset($current_document)">
								<xsl:variable name="docid">
									<xsl:call-template name="getDocumentId"/>
								</xsl:variable>
								<doc id="{$docid}" lang="{$lang}">
									<xsl:call-template name="generateContents"/>
								</doc>
							</xsl:for-each>				
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			
			</xsl:when>			
			<xsl:otherwise>
				<xsl:variable name="docid">
					<xsl:call-template name="getDocumentId"/>
				</xsl:variable>
				<doc id="{$docid}" lang="{$lang}">
					<xsl:call-template name="generateContents"/>
				</doc>
			</xsl:otherwise>
		</xsl:choose>
	
	
		
	</xsl:variable>


	

	<xsl:template name="generateContents">
		<contents>
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
			<xsl:call-template name="processMainSectionsDefault_Contents"/>
		</contents>
	</xsl:template>
	
	
	
	<xsl:template match="/">
		<fo:root xsl:use-attribute-sets="root-style" xml:lang="{$lang}">
			<fo:layout-master-set>
				<!-- Cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="36mm" margin-bottom="43mm" margin-left="49mm" margin-right="48mm"/>
					<fo:region-before extent="36mm"/>
					<fo:region-after extent="43mm"/>
					<fo:region-start extent="49mm"/>
					<fo:region-end extent="48mm"/>
				</fo:simple-page-master>
				
				<!-- Title page  -->
				<fo:simple-page-master master-name="title-page" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="38mm" margin-bottom="25mm" margin-left="95mm" margin-right="12mm"/>
					<fo:region-before extent="38mm"/>
					<fo:region-after extent="25mm"/>
					<fo:region-start extent="95mm"/>
					<fo:region-end extent="12mm"/>
				</fo:simple-page-master>
				
				<!-- Document pages -->
				<fo:simple-page-master master-name="document-odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25.4mm" margin-bottom="22mm" margin-left="31.7mm" margin-right="40mm"/>
					<fo:region-before region-name="header-odd" extent="25.4mm"/> 
					<fo:region-after region-name="footer" extent="22mm"/>
					<fo:region-start region-name="left-region" extent="17mm"/>
					<fo:region-end region-name="right-region" extent="26.5mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="document-even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25.4mm" margin-bottom="22mm" margin-left="31.7mm" margin-right="40mm"/>
					<fo:region-before region-name="header-even" extent="25.4mm"/> 
					<fo:region-after region-name="footer" extent="22mm"/>
					<fo:region-start region-name="left-region" extent="17mm"/>
					<fo:region-end region-name="right-region" extent="26.5mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="document">
					<fo:repeatable-page-master-alternatives>						
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="document-even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="document-odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				<!-- Index pages -->
				<fo:simple-page-master master-name="index-odd" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25.4mm" margin-bottom="22mm" margin-left="31.7mm" margin-right="41.7mm" column-count="2" column-gap="10mm"/>
					<fo:region-before region-name="header-odd" extent="25.4mm"/> 
					<fo:region-after region-name="footer" extent="22mm"/>
					<fo:region-start region-name="left-region" extent="17mm"/>
					<fo:region-end region-name="right-region" extent="26.5mm"/>
				</fo:simple-page-master>
				<fo:simple-page-master master-name="index-even" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="25.4mm" margin-bottom="22mm" margin-left="31.7mm" margin-right="41.7mm" column-count="2" column-gap="10mm"/>
					<fo:region-before region-name="header-even" extent="25.4mm"/> 
					<fo:region-after region-name="footer" extent="22mm"/>
					<fo:region-start region-name="left-region" extent="17mm"/>
					<fo:region-end region-name="right-region" extent="26.5mm"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="index">
					<fo:repeatable-page-master-alternatives>						
						<fo:conditional-page-master-reference odd-or-even="even" master-reference="index-even"/>
						<fo:conditional-page-master-reference odd-or-even="odd" master-reference="index-odd"/>
					</fo:repeatable-page-master-alternatives>
				</fo:page-sequence-master>
				
				
			</fo:layout-master-set>
			
			
			<xsl:call-template name="addPDFUAmeta"/>
			
			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>

			<!-- <contents>
				<xsl:copy-of select="$contents"/>
			</contents> -->
			
			
			<xsl:call-template name="insertCoverPage"/>
			<xsl:call-template name="insertInnerCoverPage"/>
			
			
			<xsl:choose>
				<xsl:when test="$root-element = 'metanorma-collection'">
					
					
					<xsl:choose>
						<xsl:when test="$doc_split_by_language = ''"><!-- all documents -->
							<xsl:for-each select="//bipm:bipm-standard">
								<xsl:variable name="lang" select="*[local-name()='bibdata']//*[local-name()='language']"/>						
								<xsl:variable name="num"><xsl:number level="any" count="bipm:bipm-standard"/></xsl:variable>
								<!-- change id to prevent identical id in different documents in one container -->						
								<xsl:variable name="current_document">							
									<xsl:apply-templates select="." mode="change_id">
										<xsl:with-param name="lang" select="$lang"/>
									</xsl:apply-templates>
								</xsl:variable>
								
								<xsl:apply-templates select="xalan:nodeset($current_document)/bipm:bipm-standard" mode="bipm-standard">
									<xsl:with-param name="curr_docnum" select="$num"/>
								</xsl:apply-templates>
								
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="(//bipm:bipm-standard)[*[local-name()='bibdata']/*[local-name()='language'] = $doc_split_by_language]">
								<xsl:variable name="lang" select="*[local-name()='bibdata']//*[local-name()='language']"/>						
								<xsl:variable name="num"><xsl:number level="any" count="bipm:bipm-standard"/></xsl:variable>
								<!-- change id to prevent identical id in different documents in one container -->						
								<xsl:variable name="current_document">							
									<xsl:apply-templates select="." mode="change_id">
										<xsl:with-param name="lang" select="$lang"/>
									</xsl:apply-templates>
								</xsl:variable>
								
								<xsl:apply-templates select="xalan:nodeset($current_document)/bipm:bipm-standard" mode="bipm-standard">
									<xsl:with-param name="curr_docnum" select="$num"/>
								</xsl:apply-templates>
								
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					
					
				</xsl:when>			
				<xsl:otherwise>
				
					<xsl:variable name="flatxml">
						<xsl:apply-templates mode="flatxml"/>
					</xsl:variable>
				
					<!-- flatxml=<xsl:copy-of select="$flatxml"/> -->
				
					<xsl:apply-templates select="xalan:nodeset($flatxml)/bipm:bipm-standard" mode="bipm-standard">
						<xsl:with-param name="curr_docnum" select="1"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
			
			
		</fo:root>
	</xsl:template>
	
	<!-- flat xml for fit notes at page sides -->
	<xsl:template match="@*|node()" mode="flatxml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="flatxml"/>
		</xsl:copy>
	</xsl:template>	
	<!-- flat clauses from 2nd level -->
	<xsl:template match="bipm:clause[not(parent::bipm:sections) and not(parent::bipm:annex) and not(parent::bipm:abstract) and not(ancestor::bipm:boilerplate)]" mode="flatxml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml"/>
		</xsl:copy>
		<xsl:apply-templates mode="flatxml"/>
	</xsl:template>
	<xsl:template match="bipm:clause/*[count(following-sibling::*) = 1 and following-sibling::*[local-name() = 'note']]" mode="flatxml"> <!--   -->
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="flatxml"/>
			<xsl:copy-of select="following-sibling::*[local-name() = 'note']"/>
		</xsl:copy>		
	</xsl:template>
	<xsl:template match="bipm:clause/bipm:note[count(following-sibling::*) = 0]" mode="flatxml"/>
		<!-- envelope standalone note in p -->
		<!-- <p>
			<xsl:copy-of select="."/>
		</p>
	</xsl:template> -->
	<xsl:template match="bipm:preface/bipm:clause" mode="flatxml">
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<!-- flat lists -->
	<xsl:template match="bipm:ul | bipm:ol" mode="flatxml" priority="2">
		<!-- <xsl:copy>
			<xsl:copy-of select="@*"/>			
		</xsl:copy> -->
		<xsl:apply-templates mode="flatxml_list"/>
	</xsl:template>

	<xsl:template match="@*|node()" mode="flatxml_list">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="flatxml_list"/>
		</xsl:copy>
	</xsl:template>	
	
	
	<!-- <xsl:template match="bipm:li[last()]" mode="flatxml_list">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml_list"/>
			<xsl:attribute name="list_type">
				<xsl:value-of select="local-name(..)"/>
			</xsl:attribute>
			<xsl:attribute name="label">
				<xsl:call-template name="setListItemLabel"/>
			</xsl:attribute>
			<xsl:apply-templates select="node()" mode="flatxml_list"/>
			<xsl:copy-of select="following-sibling::*"/>
		</xsl:copy>		
	</xsl:template> -->
	
	<!-- copy 'ol' 'ul' properties to each 'li' -->
	<!-- move note for list into latest 'li' -->
	<xsl:template match="bipm:li" mode="flatxml_list">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="flatxml_list"/>
			<xsl:attribute name="list_type">
				<xsl:value-of select="local-name(..)"/>
			</xsl:attribute>
			<xsl:attribute name="label">
				<xsl:call-template name="setListItemLabel"/>
			</xsl:attribute>
			<xsl:apply-templates mode="flatxml_list"/>
			<xsl:if test="not(following-sibling::*[local-name() = 'li'])"><!-- move note for list into latest 'li' -->
				<xsl:copy-of select="following-sibling::*"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	<!-- remove latest element (after li), because they moved into latest 'li' -->
	<xsl:template match="bipm:ul/*[not(local-name() = 'li') and not(following-sibling::*[local-name() = 'li'])]" mode="flatxml_list"/>
	<xsl:template match="bipm:ol/*[not(local-name() = 'li') and not(following-sibling::*[local-name() = 'li'])]" mode="flatxml_list"/>
	
	<xsl:template name="setListItemLabel">
		<xsl:choose>
			<xsl:when test="local-name(..) = 'ul' and ../ancestor::bipm:ul">—</xsl:when> <!-- &#x2014; dash -->
			<xsl:when test="local-name(..) = 'ul'">•</xsl:when> <!-- &#x2014; dash -->
			<xsl:otherwise> <!-- for ordered lists -->
				<xsl:choose>
					<xsl:when test="../@type = 'arabic'">
						<xsl:number format="1."/>
					</xsl:when>
					<xsl:when test="../@type = 'alphabet'">
						<xsl:number format="a)"/>
					</xsl:when>
					<xsl:when test="../@type = 'alphabet_upper'">
						<xsl:number format="A)"/>
					</xsl:when>
					<xsl:when test="../@type = 'roman'">
						<xsl:number format="i)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number format="1)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="bipm:bipm-standard"/>
	<xsl:template match="bipm:bipm-standard" mode="bipm-standard">
		<xsl:param name="curr_docnum"/>
		<xsl:variable name="curr_xml">
			<xsl:copy-of select="."/>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($curr_xml)">
			<xsl:call-template name="namespaceCheck"/>
		</xsl:for-each>
		
		<xsl:variable name="curr_lang" select="bipm:bibdata/bipm:language"/>
		
		<xsl:if test="$debug = 'true'">
			<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
				DEBUG
				contents=<xsl:copy-of select="xalan:nodeset($contents)"/>
			<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
		</xsl:if>
		
		
		
		<!-- Document pages -->
		<fo:page-sequence master-reference="document" force-page-count="no-force">
			<!-- initial page number for English section -->
			<xsl:if test="$initial_page_number != ''">
				<xsl:attribute name="initial-page-number">
					<xsl:value-of select="$initial_page_number"/>
				</xsl:attribute>
			</xsl:if>
			
			<xsl:call-template name="insertFootnoteSeparator"/>
			<fo:flow flow-name="xsl-region-body" font-family="Arial">
				
				<fo:block-container font-size="12pt" font-weight="bold" border-top="1pt solid black" width="82mm" margin-top="2mm" padding-top="2mm">						
					<fo:block-container width="45mm">
						<fo:block>
							<xsl:value-of select="bipm:bibdata/bipm:contributor[bipm:role/@type='publisher']/bipm:organization/bipm:name"/>
						</fo:block>						
					</fo:block-container>
				</fo:block-container>
				
				<fo:block-container font-size="12pt" line-height="130%">
					<fo:block margin-bottom="10pt"> </fo:block>
					<fo:block margin-bottom="10pt"> </fo:block>
					<fo:block margin-bottom="10pt"> </fo:block>
					<fo:block margin-bottom="10pt"> </fo:block>
					<fo:block margin-bottom="10pt"> </fo:block>
					<fo:block margin-bottom="10pt"> </fo:block>
					<fo:block margin-bottom="10pt"> </fo:block>
					<fo:block margin-bottom="10pt"> </fo:block>
					<fo:block margin-bottom="10pt"> </fo:block>
				</fo:block-container>
				
				<fo:block-container font-size="18pt" font-weight="bold" text-align="center">
					<fo:block>						
						<xsl:value-of select="//bipm:bipm-standard/bipm:bibdata/bipm:title[@language = $curr_lang and @type='main']"/>
					</fo:block>	
				</fo:block-container>
				
				<fo:block-container absolute-position="fixed" left="69.5mm" top="241mm" width="99mm">						
					<fo:block-container font-size="9pt" border-bottom="1pt solid black" width="68mm" text-align="center" margin-bottom="14pt">
						<fo:block font-weight="bold" margin-bottom="2.5mm">
							<fo:inline padding-right="10mm">
								<xsl:apply-templates select="bipm:bibdata/bipm:edition">
									<xsl:with-param name="font-size" select="'70%'"/>
									<xsl:with-param name="baseline-shift" select="'45%'"/>
									<xsl:with-param name="curr_lang" select="$curr_lang"/>
								</xsl:apply-templates>
							</fo:inline>
							<xsl:value-of select="$copyrightYear"/>
						</fo:block>
					</fo:block-container>
					<fo:block font-size="9pt">
						<fo:block> </fo:block>
						<fo:block> </fo:block>
						<fo:block> </fo:block>							
						<fo:block text-align="right"><xsl:value-of select="bipm:bibdata/bipm:version/bipm:draft"/></fo:block>						
					</fo:block>
				</fo:block-container>
				
				<fo:block break-after="page"/>
				
				<xsl:apply-templates select="bipm:boilerplate/bipm:license-statement"/>
				
				<fo:block-container absolute-position="fixed" top="200mm" height="69mm" font-family="Times New Roman" text-align="center" display-align="after">
					<xsl:apply-templates select="bipm:boilerplate/bipm:feedback-statement"/>
					<!-- <fo:block margin-top="15mm">ISBN 978-92-822-2272-0</fo:block> -->
				</fo:block-container>
				
			</fo:flow>
		</fo:page-sequence>
		
		<fo:page-sequence master-reference="document" force-page-count="no-force">
			<xsl:call-template name="insertFootnoteSeparator"/>
			<xsl:call-template name="insertHeaderFooter"/>
			<fo:flow flow-name="xsl-region-body">
				<fo:block line-height="135%">
					<xsl:apply-templates select="bipm:preface/bipm:abstract"/>
				</fo:block>
			</fo:flow>
		</fo:page-sequence>


		
		<xsl:variable name="docid">
			<xsl:call-template name="getDocumentId"/>
		</xsl:variable>
		
		<fo:page-sequence master-reference="document" force-page-count="no-force">
			<xsl:call-template name="insertFootnoteSeparator"/>
			<xsl:call-template name="insertHeaderFooter"/>
			<fo:flow flow-name="xsl-region-body">
			
				<fo:block-container margin-left="-14mm" margin-right="0mm">
					<fo:block-container margin-left="0mm" margin-right="0mm">							
						<fo:block font-family="Arial" font-size="16pt" font-weight="bold" text-align-last="justify" margin-bottom="84pt">
							<xsl:variable name="title-toc">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-toc'"/>
								</xsl:call-template>
							</xsl:variable>
							<fo:marker marker-class-name="header-title"><xsl:value-of select="$title-toc"/></fo:marker>
							<fo:inline><xsl:value-of select="//bipm:bipm-standard/bipm:bibdata/bipm:title[@language = $curr_lang and @type='main']"/></fo:inline>
							<fo:inline keep-together.within-line="always">
								<fo:leader leader-pattern="space"/>
								<fo:inline>
									<xsl:value-of select="$title-toc"/>
								</fo:inline>
							</fo:inline>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			
				<fo:block-container line-height="135%">
					<fo:block>
						<!-- <xsl:copy-of select="$contents"/> -->
						
						<xsl:for-each select="xalan:nodeset($contents)/doc[@id = $docid]//item[@display='true' and not(@type = 'annex') and not(@parent = 'annex')]">								
							<xsl:call-template name="insertContentItem"/>								
						</xsl:for-each>
						<xsl:for-each select="xalan:nodeset($contents)/doc[@id = $docid]//item[@display='true' and (@type = 'annex' or (@level = 2 and @parent = 'annex'))]">								
							<xsl:call-template name="insertContentItem"/>								
						</xsl:for-each>
					</fo:block>
				</fo:block-container>
		
			</fo:flow>
			
		</fo:page-sequence>
		
		
		<xsl:apply-templates select="bipm:preface/*[not(local-name() = 'abstract')]" mode="sections"/> <!-- bipm:clause -->
		
		
		
		<!-- Document Pages -->
		
		<xsl:apply-templates select="bipm:sections/*" mode="sections"/>
		
		
		
		<!-- Normative references  -->
		<xsl:apply-templates select="bipm:bibliography/bipm:references[@normative='true']" mode="sections"/>

		
		<!-- Table of Contents for Annexes -->
		<!-- <fo:page-sequence master-reference="document" force-page-count="no-force">
			<xsl:call-template name="insertHeaderFooter"/>
			<fo:flow flow-name="xsl-region-body">
			
				<fo:block-container margin-left="-18mm"  margin-right="-1mm">
					<fo:block-container margin-left="0mm" margin-right="0mm">							
						<fo:block font-family="Arial" font-size="16pt" font-weight="bold" text-align-last="justify" margin-bottom="84pt">
							<xsl:variable name="title-toc">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-toc'"/>
								</xsl:call-template>
							</xsl:variable>
							<fo:marker marker-class-name="header-title"><xsl:value-of select="$title-toc"/></fo:marker>
							<fo:inline><xsl:value-of select="$title-fr"/></fo:inline>
							<fo:inline keep-together.within-line="always">
								<fo:leader leader-pattern="space"/>
								<fo:inline>
									<xsl:value-of select="$title-toc"/>
								</fo:inline>
							</fo:inline>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			
				<fo:block-container line-height="130%">
					<fo:block>
						<xsl:for-each select="xalan:nodeset($contents)/doc[@id = $docid]//item[@display='true' and @type = 'annex']">
							
							<xsl:call-template name="insertContentItem"/>
							
						</xsl:for-each>
					</fo:block>
				</fo:block-container>
		
			</fo:flow>
			
		</fo:page-sequence> -->
		
		
		<xsl:apply-templates select="bipm:annex" mode="sections"/>
		
		<!-- Bibliography -->
		<xsl:apply-templates select="bipm:bibliography/bipm:references[not(@normative='true')]" mode="sections"/> 
		
		<!-- End Document Pages -->
		
		
		<xsl:if test="($doc_split_by_language = '' and $curr_docnum = 1) or $doc_split_by_language = $doc_first_language">
			<xsl:call-template name="insertSeparatorPage"/>
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- Cover Pages -->
	<xsl:template name="insertCoverPage">	
	
		<fo:page-sequence master-reference="cover-page" force-page-count="even">
			
			<fo:flow flow-name="xsl-region-body">
			
				<!-- background color -->
				<fo:block-container absolute-position="fixed" left="0" top="-1mm">
					<fo:block>
						<fo:instream-foreign-object content-height="{$pageHeight}" fox:alt-text="Background color">
							<svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="{$pageWidth}" height="{$pageHeight}">
								<rect width="{$pageWidth}" height="{$pageHeight}" style="fill:rgb(214,226,239);stroke-width:0"/>
							</svg>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>
			
				<!-- BIPM logo -->
				<fo:block-container absolute-position="fixed" left="12.8mm" top="12.2mm">
					<fo:block>
						<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo-BIPM))}" width="35mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo"/>
					</fo:block>
				</fo:block-container>
				
				<!-- SI logo -->
				<fo:block-container absolute-position="fixed" left="166.5mm" top="253mm">
					<fo:block>
						<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo-SI))}" width="32mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo"/>
					</fo:block>
				</fo:block-container>
				
				<fo:block-container height="100%" display-align="center" border="0pt solid black"><!--  -->
					<fo:block font-family="WorkSans" font-size="50pt" line-height="115%">
					
						<xsl:variable name="languages">
							<xsl:call-template name="getLanguages"/>
						</xsl:variable>						
						<xsl:variable name="editionFO">
							<xsl:apply-templates select="(//bipm:bipm-standard)[1]/bipm:bibdata/bipm:edition">
								<xsl:with-param name="curr_lang" select="xalan:nodeset($languages)/lang[1]"/>
							</xsl:apply-templates>
						</xsl:variable>
						
						<xsl:variable name="titles">
							<xsl:for-each select="(//bipm:bipm-standard)[1]/bipm:bibdata/bipm:title">
								<xsl:copy-of select="."/>
							</xsl:for-each>
						</xsl:variable>
						
						<xsl:for-each select="xalan:nodeset($languages)/lang">
							<xsl:variable name="title_num" select="position()"/>							
							<xsl:variable name="curr_lang" select="."/>
							<xsl:variable name="title-cover" select="xalan:nodeset($titles)//bipm:title[@language = $curr_lang and @type='cover']"/>							
							<xsl:variable name="title-cover_" select="java:replaceAll(java:java.lang.String.new($title-cover),'( (of )| (and )| (or ))','#$2')"/>
							<xsl:variable name="titleParts">
								<xsl:call-template name="splitTitle">
									<xsl:with-param name="pText" select="$title-cover_"/>
									<xsl:with-param name="sep" select="' '"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="titleSplitted">							
								<xsl:call-template name="splitByParts">
									<xsl:with-param name="items" select="$titleParts"/>
									<xsl:with-param name="mergeEach" select="round(count(xalan:nodeset($titleParts)/item) div 4 + 0.49)"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="font-weight-initial">
								<xsl:choose>
									<xsl:when test="position() = 1">0</xsl:when>
									<xsl:otherwise>400</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<fo:block>
								<xsl:if test="$title_num != 1">
									<xsl:attribute name="text-align">right</xsl:attribute>
								</xsl:if>
								<xsl:for-each select="xalan:nodeset($titleSplitted)/part">
									<fo:block font-weight="{$font-weight-initial + 100 * position()}">										
										<xsl:value-of select="translate(., '#', ' ')"/>
										<xsl:if test="$title_num = 1 and position() = last()">
											<fo:inline font-size="11.7pt" font-weight="normal" padding-left="5mm" baseline-shift="15%" line-height="125%">
												<xsl:copy-of select="$editionFO"/>
												<xsl:text> </xsl:text>
												<xsl:value-of select="$copyrightYear"/>
											</fo:inline>
										</xsl:if>
									</fo:block>
								</xsl:for-each>
							</fo:block>
						</xsl:for-each>
						
						
					</fo:block>
				</fo:block-container>
				
			</fo:flow>
		</fo:page-sequence>	
	</xsl:template>
	
	<xsl:template name="insertInnerCoverPage">
		<fo:page-sequence master-reference="title-page" format="1" initial-page-number="1" force-page-count="even">
			
			<fo:flow flow-name="xsl-region-body" font-family="Arial">
			
				<xsl:variable name="languages">
					<xsl:call-template name="getLanguages"/>
				</xsl:variable>
			
				<xsl:variable name="titles">
					<xsl:for-each select="(//bipm:bipm-standard)[1]/bipm:bibdata/bipm:title">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:variable>
			
				<xsl:for-each select="xalan:nodeset($languages)/lang">
					<xsl:variable name="curr_lang" select="."/>
					<xsl:variable name="title" select="xalan:nodeset($titles)//bipm:title[@language = $curr_lang and @type='main']"/>
					<xsl:choose>
						<xsl:when test="position() = 1">				
							<fo:block-container font-size="12pt" font-weight="bold" width="55mm">
									<fo:block>
										<xsl:call-template name="add-letter-spacing">
											<xsl:with-param name="text" select="$title"/>
											<xsl:with-param name="letter-spacing" select="0.09"/>
										</xsl:call-template>
									</fo:block>									
									<fo:block font-size="10pt">
										<fo:block margin-bottom="6pt"> </fo:block>
										<fo:block margin-bottom="6pt"> </fo:block>
										<fo:block margin-bottom="6pt"> </fo:block>
										<fo:block margin-bottom="6pt" line-height="2.4"> </fo:block>							
									</fo:block>
								</fo:block-container>
							</xsl:when>
							<xsl:otherwise>
								<fo:block font-size="10pt" margin-bottom="3pt">
									<xsl:variable name="lang_version">
										<xsl:call-template name="getLangVersion">
											<xsl:with-param name="lang" select="$curr_lang"/>
										</xsl:call-template>
									</xsl:variable>
									<xsl:call-template name="add-letter-spacing">
										<xsl:with-param name="text" select="normalize-space($lang_version)"/>
										<xsl:with-param name="letter-spacing" select="0.09"/>
									</xsl:call-template>
								</fo:block>
								<fo:block-container font-size="12pt" font-weight="bold" border-top="0.5pt solid black" padding-top="2mm" width="45mm">						
									<fo:block>										
										<xsl:call-template name="add-letter-spacing">
											<xsl:with-param name="text" select="$title"/>
											<xsl:with-param name="letter-spacing" select="0.09"/>
										</xsl:call-template>
									</fo:block>
								</fo:block-container>
							</xsl:otherwise>
							
						</xsl:choose>
					</xsl:for-each>
				
				
				
				
			</fo:flow>
		</fo:page-sequence>
		
	</xsl:template>
	<!-- End Cover Pages -->
		
	<xsl:template name="insertSeparatorPage">
		<!-- 3 Pages with BIPM Metro logo -->
		<fo:page-sequence master-reference="document" force-page-count="no-force">
			<fo:flow flow-name="xsl-region-body">
				<fo:block> </fo:block>
				<fo:block break-after="page"/>
				
				<xsl:call-template name="insert_Logo-BIPM-Metro"/>
				<!-- <fo:block-container absolute-position="fixed" left="47mm" top="67mm">
					<fo:block>
						<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo-BIPM-Metro))}" width="118.6mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo"/>
					</fo:block>
				</fo:block-container> -->
				
				<fo:block break-after="page"/>
				<fo:block> </fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
		
	<xsl:template name="getLanguages">
		<xsl:choose>
			<xsl:when test="$doc_split_by_language = ''"><!-- all documents -->
				<xsl:for-each select="//bipm:bipm-standard/bipm:bibdata">
					<lang><xsl:value-of select="bipm:language"/></lang>
				</xsl:for-each>
				<!-- <xsl:choose>
					<xsl:when test="count(//bipm:bipm-standard) = 1">											
							<lang>fr</lang>
							<lang>en</lang>											
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="//bipm:bipm-standard/bipm:bibdata">
							<lang><xsl:value-of select="bipm:language"/></lang>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose> -->
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:for-each select="(//bipm:bipm-standard)[$docnum]/bipm:bibdata">
					<lang><xsl:value-of select="bipm:language"/></lang>
				</xsl:for-each> -->
				<lang><xsl:value-of select="$doc_split_by_language"/></lang>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<xsl:template name="insertContentItem">
		<fo:block>
			<xsl:if test="@level = 1">
				<xsl:attribute name="space-after">6pt</xsl:attribute>
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">10pt</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:if test="@type = 'annex'">
					<xsl:attribute name="space-before">14pt</xsl:attribute>
					<xsl:attribute name="space-after">0pt</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="@level &gt;= 2 and not(@parent = 'annex')">
				<xsl:attribute name="font-size">10.5pt</xsl:attribute>
			</xsl:if>									
			<xsl:if test="@level = 2">
				<xsl:attribute name="margin-left">8mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level &gt; 2">
				<xsl:attribute name="margin-left">9mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level &gt;= 2 and @parent = 'annex'">
				<xsl:attribute name="font-family">Arial</xsl:attribute>
				<xsl:attribute name="font-size">8pt</xsl:attribute>
				<xsl:attribute name="margin-left">25mm</xsl:attribute>
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="@level = 2 and not(following-sibling::item[@display='true']) and not(item[@display='true'])">
				<xsl:attribute name="space-after">12pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@level = 3 and not(following-sibling::item[@display='true']) and not(../following-sibling::item[@display='true'])">
				<xsl:attribute name="space-after">12pt</xsl:attribute>
			</xsl:if>
			
			<fo:list-block>
				<xsl:attribute name="provisional-distance-between-starts">
					<xsl:choose>
						<xsl:when test="@section = '' or @level &gt; 3">0mm</xsl:when>
						<xsl:when test="@level = 2 and @parent = 'annex'">0mm</xsl:when>
						<xsl:when test="@level = 2">8mm</xsl:when>
						<xsl:when test="@type = 'annex' and @level = 1">25mm</xsl:when>
						<xsl:otherwise>7mm</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block>
							<xsl:if test="@level = 1 or (@level = 2 and not(@parent = 'annex'))">
								<xsl:value-of select="@section"/>
							</xsl:if>
							<fo:inline font-size="10pt" color="white">Z</fo:inline> <!-- for baseline alignment in string -->
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block text-align-last="justify">
							<xsl:if test="@level &gt;= 3">
								<xsl:attribute name="margin-left">12mm</xsl:attribute>
								<xsl:attribute name="text-indent">-12mm</xsl:attribute>
							</xsl:if>
							<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
								<xsl:if test="@level &gt;= 3">
									<fo:inline padding-right="2mm"><xsl:value-of select="@section"/></fo:inline>
								</xsl:if>
								<xsl:variable name="sectionTitle">
									<xsl:apply-templates select="title"/>
								</xsl:variable>
								<fo:inline>
									<xsl:value-of select="$sectionTitle"/>															
								</fo:inline>
								<xsl:text> </xsl:text>															
								<fo:inline keep-together.within-line="always">
									<fo:leader leader-pattern="space"/>																																		
									<fo:inline font-family="Arial" font-weight="bold" font-size="10pt"><fo:page-number-citation ref-id="{@id}"/></fo:inline>
								</fo:inline>
							</fo:basic-link>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="node()">		
		<xsl:apply-templates/>			
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	<xsl:template match="node()" mode="contents">		
		<xsl:apply-templates mode="contents"/>			
	</xsl:template>

	<!-- element with title -->
	<xsl:template match="*[bipm:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="bipm:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="$level &gt;= 4">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::bipm:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::bipm:term">true</xsl:when>								
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$skip = 'false'">
			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>
			
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<xsl:variable name="type">
				<xsl:value-of select="local-name()"/>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" display="{$display}">
				<xsl:if test="ancestor::bipm:annex">
					<xsl:attribute name="parent">annex</xsl:attribute>
				</xsl:if>
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates mode="contents"/>
			</item>
		</xsl:if>
	</xsl:template>
	
	<!-- ============================= -->
	<!-- ============================= -->
	
	
	<xsl:template match="node()" mode="sections">
		<fo:page-sequence master-reference="document" force-page-count="no-force">
			<xsl:call-template name="insertFootnoteSeparator"/>
			<xsl:call-template name="insertHeaderFooter"/>
			<fo:flow flow-name="xsl-region-body">
				<fo:block line-height="125%">
					<xsl:apply-templates select="."/>
				</fo:block>
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	
	<xsl:template match="bipm:bipm-standard/bipm:bibdata/bipm:edition">
		<xsl:param name="font-size" select="'65%'"/>
		<xsl:param name="baseline-shift" select="'30%'"/>
		<xsl:param name="curr_lang" select="'fr'"/>
		<fo:inline>
			<xsl:variable name="title-edition">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-edition'"/>
					<xsl:with-param name="lang" select="$curr_lang"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="."/>
			<fo:inline font-size="{$font-size}" baseline-shift="{$baseline-shift}">
				<xsl:choose>
					<xsl:when test="$curr_lang = 'fr'">
						<xsl:choose>					
							<xsl:when test=". = '1'">re</xsl:when>
							<xsl:otherwise>e</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>					
							<xsl:when test=". = '1'">st</xsl:when>
							<xsl:when test=". = '2'">nd</xsl:when>
							<xsl:when test=". = '3'">rd</xsl:when>
							<xsl:otherwise>th</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
				
			</fo:inline>
			<xsl:text> </xsl:text>			
			<xsl:value-of select="java:toLowerCase(java:java.lang.String.new($title-edition))"/>
			<xsl:text/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="bipm:license-statement">
		<fo:block font-size="10.6pt" font-family="Times New Roman">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="bipm:license-statement//bipm:title">
		<fo:block text-decoration="underline" margin-bottom="6pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="bipm:license-statement//bipm:p">
		<fo:block text-align="justify" line-height="135%">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="bipm:license-statement//bipm:link">
		<fo:inline color="blue" text-decoration="underline">
				<fo:basic-link external-destination="{@target}" fox:alt-text="{@target}">
					<xsl:choose>
						<xsl:when test="normalize-space(.) != ''">
							<xsl:apply-templates/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@target"/>
						</xsl:otherwise>						
					</xsl:choose>
				</fo:basic-link>
			</fo:inline>
	</xsl:template>
	

	<xsl:template match="bipm:feedback-statement">
		<fo:block font-size="10pt" line-height="125%">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>


	<xsl:template match="bipm:feedback-statement//bipm:p">
		<fo:block margin-top="6pt">
			<xsl:variable name="p_num"><xsl:number/></xsl:variable>			
			<xsl:if test="$p_num = 1">Édité par le </xsl:if>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	
	<xsl:template match="bipm:title" name="clause_title">
		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 1">16pt</xsl:when>
				<xsl:when test="$level = 2 and ancestor::bipm:annex">10.5pt</xsl:when>
				<xsl:when test="$level = 2">14pt</xsl:when>
				<xsl:when test="$level = 3 and ancestor::bipm:annex">10pt</xsl:when>
				<xsl:when test="$level = 3">12pt</xsl:when>
				<xsl:otherwise>11pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<fo:block-container margin-left="-14mm" font-family="Arial" font-size="{$font-size}" font-weight="bold" keep-with-next="always" line-height="130%">				 <!-- line-height="145%" -->
			<xsl:attribute name="margin-bottom">
				<xsl:choose>
					<xsl:when test="$level = 1 and (parent::bipm:annex or parent::bipm:abstract or ancestor::bipm:preface)">84pt</xsl:when>
					<xsl:when test="$level = 1">6pt</xsl:when>
					<xsl:when test="$level = 2 and ancestor::bipm:annex">6pt</xsl:when>
					<xsl:when test="$level = 2">10pt</xsl:when>
					<xsl:otherwise>6pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>			
			<xsl:if test="$level = 2">
				<xsl:attribute name="margin-top">24pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="$level = 3 and not(ancestor::bipm:annex)">
				<xsl:attribute name="margin-top">20pt</xsl:attribute>
			</xsl:if>
			
			<fo:block-container margin-left="0mm">
				
				<xsl:if test="$level = 1">
					<fo:marker marker-class-name="header-title">
						<xsl:choose>
							<xsl:when test="*[local-name() = 'tab']">
								<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()" mode="header"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates mode="header"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:marker>
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="*[local-name() = 'tab'] and not(ancestor::bipm:annex)"><!-- split number and title -->					
						<fo:table table-layout="fixed" width="100%">
							<fo:table-column column-width="14mm"/>
							<fo:table-column column-width="136mm"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block line-height-shift-adjustment="disregard-shifts">
											<xsl:call-template name="extractTitle"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</xsl:when>
					<xsl:otherwise>
						<fo:block>
							<xsl:choose>
								<xsl:when test="ancestor::bipm:annex and $level &gt;= 2">
									<xsl:if test="$level = 3">
										<xsl:attribute name="margin-left">14mm</xsl:attribute>
										<fo:inline padding-right="2.5mm" baseline-shift="15%">
											<fo:instream-foreign-object content-height="2mm" content-width="2mm" fox:alt-text="Quad">
													<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" viewBox="0 0 2 2">
														<rect x="0" y="0" width="2" height="2" fill="black"/>
													</svg>
												</fo:instream-foreign-object>	
										</fo:inline>
									</xsl:if>
									<xsl:call-template name="extractTitle"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates/>
								</xsl:otherwise>
							</xsl:choose>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</fo:block-container>
		</fo:block-container>

	</xsl:template>
	
	<xsl:template match="*" mode="header">
		<xsl:apply-templates mode="header"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'stem']" mode="header">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'br']" mode="header">
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<!-- ====== -->
	<!-- ====== -->


	<xsl:template match="bipm:preface/bipm:abstract" priority="3">
		<fo:table table-layout="fixed" width="173.5mm">
			<xsl:call-template name="setId"/>
			<fo:table-column column-width="137mm"/>
			<fo:table-column column-width="2.5mm"/>
			<fo:table-column column-width="34mm"/>
			<fo:table-body>
			
				<xsl:variable name="rows2">
					<xsl:for-each select="*">
						<xsl:variable name="position" select="position()"/>
						<!-- if this is  first element -->
						<xsl:variable name="isFirstRow" select="not(preceding-sibling::*)"/>  
						<!--  first element without note -->					
						<xsl:variable name="isFirstCellAfterNote" select="$isFirstRow = true() or count(preceding-sibling::*[1][.//bipm:note]) = 1"/>					
						<xsl:variable name="curr_id" select="generate-id()"/>						
						<xsl:variable name="rowsUntilNote" select="count(following-sibling::*[.//bipm:note[not(ancestor::bipm:table)]][1]/preceding-sibling::*[preceding-sibling::*[generate-id() = $curr_id]])"/>
						
						<xsl:if test="$isFirstCellAfterNote = true()">
							<num span_start="{$position}" span_num="{$rowsUntilNote + 2}" display-align="after">
								<xsl:if test="count(following-sibling::*[.//bipm:note[not(ancestor::bipm:table)]]) = 0"><!-- if there aren't notes more, then set -1 -->
									<xsl:attribute name="span_start"><xsl:value-of select="$position"/>_no_more_notes</xsl:attribute>
								</xsl:if>
								<xsl:if test="count(following-sibling::*[.//bipm:note[not(ancestor::bipm:table)]]) = 1"> <!-- if there is only one note, then set -1, because notes will be display near accoring text-->							
									<xsl:attribute name="span_start"><xsl:value-of select="$position"/>_last_note</xsl:attribute>
								</xsl:if>
							</num>
						</xsl:if>
						<xsl:if test=".//bipm:note[not(ancestor::bipm:table)] and count(following-sibling::*[.//bipm:note[not(ancestor::bipm:table)]]) = 0"> <!-- if current row there is note, and no more notes below -->
							<num span_start="{$position}" span_num="{count(following-sibling::*) + 1}" display-align="before"/>
						</xsl:if>
						<xsl:if test=".//bipm:note[not(ancestor::bipm:table)] and following-sibling::*[1][.//bipm:note[not(ancestor::bipm:table)]] and preceding-sibling::*[1][.//bipm:note[not(ancestor::bipm:table)]]">
							<num span_start="{$position}" span_num="1" display-align="before"/>
						</xsl:if>
						
					</xsl:for-each>
				</xsl:variable>
				
				
				<xsl:variable name="total_rows" select="count(*)"/>
				
				<xsl:variable name="rows_with_notes">					
					<xsl:for-each select="*">						
						<xsl:if test=".//bipm:note[not(ancestor::bipm:table)]">
							<row_num><xsl:value-of select="position()"/></row_num>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<!-- rows_with_notes<xsl:copy-of select="$rows_with_notes"/> -->
				
				<xsl:variable name="rows3">
					<xsl:for-each select="xalan:nodeset($rows_with_notes)/row_num">
						<xsl:variable name="num" select="number(.)"/>
						<xsl:choose>
							<xsl:when test="position() = 1">
								<num span_start="1" span_num="{$num}" display-align="after"/>
							</xsl:when>
							<xsl:when test="position() = last()">
								<num span_start="{$num}" span_num="{$total_rows - $num + 1}" display-align="before"/>
							</xsl:when>
							<xsl:otherwise><!-- 2nd, 3rd, ... Nth-1 -->
								<xsl:variable name="prev_num" select="number(preceding-sibling::*/text())"/>
								<num span_start="{$prev_num + 1}" span_num="{$num - $prev_num}" display-align="after"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				
				<xsl:variable name="rows">					
					<xsl:for-each select="xalan:nodeset($rows_with_notes)/row_num">
						<xsl:variable name="num" select="number(.)"/>
						<xsl:choose>						
							<xsl:when test="position() = last()">
								<num span_start="{$num}" span_num="{$total_rows - $num + 1}" display-align="before"/>
							</xsl:when>
							<xsl:otherwise><!-- 2nd, 3rd, ... Nth-1 -->		
								<xsl:variable name="next_num" select="number(following-sibling::*/text())"/>
								<num span_start="{$num}" span_num="{$next_num - $num}" display-align="before"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				
				
				<!-- rows=<xsl:copy-of select="$rows"/> -->
				
				<xsl:apply-templates mode="clause_table">
					<xsl:with-param name="rows" select="$rows"/>
				</xsl:apply-templates>
			</fo:table-body>
		</fo:table>
	</xsl:template>
	


	<xsl:template match="bipm:preface/bipm:abstract/*" mode="clause_table">
		<xsl:param name="rows"/>
		
		<xsl:variable name="current_row"><xsl:number count="*"/></xsl:variable>
		
		<fo:table-row>
			<fo:table-cell>				
				<fo:block>					
					<xsl:apply-templates select="."/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell><fo:block> </fo:block></fo:table-cell>
			
			
			<xsl:if test="xalan:nodeset($rows)/num[@span_start = $current_row]">
				<fo:table-cell font-size="8pt" line-height="120%" display-align="before">
				
					<xsl:variable name="current_row_with_note" select="xalan:nodeset($rows)/num[@span_start = $current_row]"/>
					
					<xsl:attribute name="display-align">
						<xsl:value-of select="$current_row_with_note/@display-align"/>
					</xsl:attribute>
					
					<xsl:variable name="number-rows-spanned" select="$current_row_with_note/@span_num"/>
					<xsl:attribute name="number-rows-spanned">
						<xsl:value-of select="$number-rows-spanned"/>
					</xsl:attribute>
					
					<xsl:variable name="start_row" select="$current_row"/>
					<xsl:variable name="end_row" select="$current_row + $number-rows-spanned"/>
					<fo:block>
						<xsl:for-each select="ancestor::bipm:abstract/*[position() &gt;= $start_row and position() &lt; $end_row]//bipm:note[not(ancestor::bipm:table)]">
							<xsl:apply-templates select="." mode="note_side"/>
						</xsl:for-each>
					</fo:block>
					
					<!-- DEBUG -->
					<!-- <xsl:if test=".//bipm:note">
						<fo:block>Note</fo:block>
					</xsl:if>
					<fo:block font-size="6pt" color="red">
						<fo:block>current_row=<xsl:value-of select="$current_row"/></fo:block>													
						<xsl:for-each select="xalan:nodeset($rows)/num">
							<fo:block>span_start=<xsl:value-of select="@span_start"/></fo:block>
							<fo:block>span_num=<xsl:value-of select="@span_num"/></fo:block>
						</xsl:for-each>						
					</fo:block> -->
					
				</fo:table-cell>
				
			</xsl:if>
			
			
		</fo:table-row>
	</xsl:template>
	
	
	<xsl:template match="bipm:sections/bipm:clause | bipm:annex/bipm:clause" priority="3">
		<fo:table table-layout="fixed" width="174mm" line-height="135%">
			<xsl:call-template name="setId"/>
			<fo:table-column column-width="137mm"/>
			<fo:table-column column-width="5mm"/>
			<fo:table-column column-width="32mm"/>
			<fo:table-body>
			
				<xsl:variable name="rows2">
					<xsl:for-each select="*">
						<xsl:variable name="position" select="position()"/>
						<!-- if this is  first element -->
						<xsl:variable name="isFirstRow" select="not(preceding-sibling::*)"/>  
						<!--  first element without note -->					
						<xsl:variable name="isFirstCellAfterNote" select="$isFirstRow = true() or count(preceding-sibling::*[1][.//bipm:note]) = 1"/>					
						<xsl:variable name="curr_id" select="generate-id()"/>						
						<xsl:variable name="rowsUntilNote" select="count(following-sibling::*[.//bipm:note][1]/preceding-sibling::*[preceding-sibling::*[generate-id() = $curr_id]])"/>
						
						<num display-align="after">
							<xsl:if test="$isFirstCellAfterNote = true()">
								<xsl:attribute name="span_start">
									<xsl:value-of select="$position"/>
								</xsl:attribute>
								<xsl:attribute name="span_num">
									<xsl:value-of select="$rowsUntilNote + 2"/>
								</xsl:attribute>								
								<xsl:if test="count(following-sibling::*[.//bipm:note]) = 0"><!-- if there aren't notes more, then set -1 -->
									<xsl:attribute name="span_start"><xsl:value-of select="$position"/>_no_more_notes</xsl:attribute>
								</xsl:if>
								<xsl:if test="count(following-sibling::*[.//bipm:note]) = 1"> <!-- if there is only one note, then set -1, because notes will be display near accoring text-->							
									<xsl:attribute name="span_start"><xsl:value-of select="$position"/>_last_note</xsl:attribute>
								</xsl:if>								
							</xsl:if>
							
							<xsl:if test=".//bipm:note and count(following-sibling::*[.//bipm:note]) = 0"> <!-- if current row there is note, and no more notes below -->
								<xsl:attribute name="span_start">
									<xsl:value-of select="$position"/>
								</xsl:attribute>
								<xsl:attribute name="span_num">
									<xsl:value-of select="count(following-sibling::*) + 1"/>
								</xsl:attribute>
								<xsl:attribute name="display-align">before</xsl:attribute>
							</xsl:if>
							
							<xsl:if test=".//bipm:note and following-sibling::*[1][.//bipm:note] and preceding-sibling::*[1][.//bipm:note]">								
								<xsl:attribute name="span_start">
									<xsl:value-of select="$position"/>
								</xsl:attribute>
								<xsl:attribute name="span_num">1</xsl:attribute>
								<xsl:attribute name="display-align">before</xsl:attribute>
							</xsl:if>
							
							<xsl:if test=".//bipm:note and preceding-sibling::*[1][.//bipm:note] and not(following-sibling::*[1][.//bipm:note])">
								<xsl:attribute name="span_start">
									<xsl:value-of select="$position"/>
								</xsl:attribute>
								<xsl:attribute name="span_num">1</xsl:attribute>
								<xsl:attribute name="display-align">before</xsl:attribute>
							</xsl:if>
						</num>
					</xsl:for-each>
				</xsl:variable>
				
				
				<xsl:variable name="total_rows" select="count(*)"/>
				
				<xsl:variable name="rows_with_notes">					
					<xsl:for-each select="*">						
						<xsl:if test=".//bipm:note">
							<row_num><xsl:value-of select="position()"/></row_num>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<!-- rows_with_notes<xsl:copy-of select="$rows_with_notes"/> -->
				
				<xsl:variable name="rows3">
					<xsl:for-each select="xalan:nodeset($rows_with_notes)/row_num">
						<xsl:variable name="num" select="number(.)"/>
						<xsl:choose>
							<xsl:when test="position() = 1">
								<num span_start="1" span_num="{$num}" display-align="after"/>
							</xsl:when>
							<xsl:when test="position() = last()">
								<num span_start="{$num}" span_num="{$total_rows - $num + 1}" display-align="before"/>
							</xsl:when>
							<xsl:otherwise><!-- 2nd, 3rd, ... Nth-1 -->
								<xsl:variable name="prev_num" select="number(preceding-sibling::*/text())"/>
								<num span_start="{$prev_num + 1}" span_num="{$num - $prev_num}" display-align="after"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				
				<xsl:variable name="rows">					
					<xsl:for-each select="xalan:nodeset($rows_with_notes)/row_num">
						<xsl:variable name="num" select="number(.)"/>
						<xsl:choose>						
							<xsl:when test="position() = last()">
								<num span_start="{$num}" span_num="{$total_rows - $num + 1}" display-align="before"/>
							</xsl:when>
							<xsl:otherwise><!-- 2nd, 3rd, ... Nth-1 -->		
								<xsl:variable name="next_num" select="number(following-sibling::*/text())"/>
								<num span_start="{$num}" span_num="{$next_num - $num}" display-align="before"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				
				<!-- rows=<xsl:copy-of select="$rows"/> -->
				
				
				<xsl:apply-templates mode="clause_table">
					<xsl:with-param name="rows" select="$rows"/>
				</xsl:apply-templates>
					
			</fo:table-body>
		</fo:table>
	</xsl:template>
	
	
	<xsl:template match="bipm:sections/bipm:clause/* | bipm:annex/bipm:clause/*" mode="clause_table">
		<xsl:param name="rows"/>
		
		
		<xsl:variable name="current_row"><xsl:number count="*"/></xsl:variable>
		
	
		<fo:table-row> <!-- border="1pt solid black" -->
			<fo:table-cell> <!-- border="1pt solid black" -->
				<fo:block>					
					<xsl:apply-templates select="."/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell><fo:block> </fo:block></fo:table-cell>
			
			
			<!-- DEBUG -->
			<!-- <fo:table-cell font-size="8pt" line-height="120%" display-align="before" padding-bottom="6pt">
					
					<xsl:variable name="number-rows-spanned" select="xalan:nodeset($rows)/num[@span_start = $current_row]/@span_num"/>
					
					
					<xsl:variable name="start_row" select="$current_row"/>					
					
					<xsl:if test=".//bipm:note">
						<fo:block>Note</fo:block>
					</xsl:if>
					<fo:block font-size="6pt" color="red">
						<fo:block>current_row=<xsl:value-of select="$current_row"/></fo:block>													
						<xsl:for-each select="xalan:nodeset($rows)/num">
							<fo:block>span_start=<xsl:value-of select="@span_start"/></fo:block>
							<fo:block>span_num=<xsl:value-of select="@span_num"/></fo:block>
						</xsl:for-each>						
					</fo:block>					
					
				</fo:table-cell> -->
			
			
			<xsl:if test="xalan:nodeset($rows)/num[@span_start = $current_row]">
				<fo:table-cell font-size="8pt" line-height="120%" display-align="before" padding-bottom="6pt">
					
					<xsl:variable name="current_row_with_note" select="xalan:nodeset($rows)/num[@span_start = $current_row]"/>
				
					<xsl:attribute name="display-align">
						<xsl:value-of select="$current_row_with_note/@display-align"/>
					</xsl:attribute>
					
					<xsl:variable name="number-rows-spanned" select="$current_row_with_note/@span_num"/>
					<xsl:attribute name="number-rows-spanned">
						<xsl:value-of select="$number-rows-spanned"/>
					</xsl:attribute>
					
					<xsl:variable name="start_row" select="$current_row"/>
					<xsl:variable name="end_row" select="$current_row + $number-rows-spanned"/>
					
					<fo:block>
						<!-- <fo:block>display-align=<xsl:value-of select="xalan:nodeset($rows)/num[@span_start = $current_row]/@display-align"/></fo:block> -->
						<xsl:for-each select="ancestor::*[1]/*[position() &gt;= $start_row and position() &lt; $end_row]//bipm:note">
							
							<xsl:apply-templates select="." mode="note_side"/>
						</xsl:for-each>
					</fo:block>
				
				</fo:table-cell>
			</xsl:if>
			
			
			<!-- 
			<xsl:choose>
				<xsl:when test=".//bipm:note">
					<fo:table-cell font-size="8pt" line-height="120%">
						<xsl:variable name="curr_id" select="@id"/>						
						<xsl:attribute name="number-rows-spanned">
							<xsl:value-of select="count(following-sibling::*[.//bipm:note][1]/preceding-sibling::*[preceding-sibling::*[@id = $curr_id]]) + 1"/>
						</xsl:attribute>
						<fo:block>
							<xsl:for-each select=".//bipm:note">
								<xsl:apply-templates select="." mode="note_side"/>
							</xsl:for-each>
						</fo:block>
					</fo:table-cell>
				</xsl:when>
			</xsl:choose>			 -->
		</fo:table-row>
	</xsl:template>

	<!-- skip, because it process in note_side template -->
	<xsl:template match="bipm:preface/bipm:abstract//bipm:note[not(ancestor::bipm:table)]" priority="3"/>
	<xsl:template match="bipm:sections//bipm:note | bipm:annex//bipm:note" priority="3"/> <!-- [not(ancestor::bipm:table)] -->
	
	
	<xsl:template match="bipm:note" mode="note_side">
		<fo:block>
			<xsl:apply-templates mode="note_side"/>
		</fo:block>
	</xsl:template>
	<xsl:template match="bipm:note/bipm:name" mode="note_side" priority="2"/>	
	<xsl:template match="bipm:note/*" mode="note_side">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="bipm:title//bipm:fn |                  bipm:name//bipm:fn |                  bipm:p/bipm:fn[not(ancestor::bipm:table)] |                  bipm:p/*/bipm:fn[not(ancestor::bipm:table)] |                 bipm:sourcecode/bipm:fn[not(ancestor::bipm:table)]" priority="2" name="fn">
		<fo:footnote keep-with-previous.within-line="always">
			<xsl:variable name="number" select="@reference"/>
			<xsl:variable name="lang" select="ancestor::bipm:bipm-standard/*[local-name()='bibdata']//*[local-name()='language']"/>
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="{$lang}_footnote_{@reference}" fox:alt-text="footnote {@reference}">
					<xsl:value-of select="$number"/><!--  + count(//bipm:bibitem/bipm:note) -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="9pt" margin-bottom="12pt" font-weight="normal" text-indent="0" start-indent="0" line-height="124%" text-align="justify">
					<fo:inline id="{$lang}_footnote_{@reference}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"> <!-- baseline-shift="30%" padding-right="3mm" font-size="60%"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number "/><!-- + count(//bipm:bibitem/bipm:note) -->
					</fo:inline>
					<xsl:for-each select="bipm:p">
							<xsl:apply-templates/>
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="bipm:fn/bipm:p">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	

	<xsl:template match="bipm:p">
		<xsl:param name="inline" select="'false'"/>
		
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:element name="{$element-name}">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:when test="../@align"><xsl:value-of select="../@align"/></xsl:when>
					<xsl:otherwise>justify</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="not(ancestor::bipm:table)">				
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>			
			<xsl:if test="ancestor::bipm:dd and not(ancestor::bipm:table)">
				<!-- <xsl:attribute name="margin-bottom">4pt</xsl:attribute> -->
			</xsl:if>
			<xsl:if test="parent::bipm:li">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="@align = 'center'">
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="6pt">
				 <xsl:if test="ancestor::bipm:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block> </fo:block>
		</xsl:if>
	</xsl:template>


	<xsl:template match="bipm:ul | bipm:ol" mode="ul_ol">		
		<!-- <fo:block id="{@id}"/>		 -->
		<xsl:apply-templates/><!-- for second level -->
	</xsl:template>
	
	<!-- process list item as individual list --> <!-- flat list -->
	<xsl:template match="bipm:li">
		<fo:block-container margin-left="0mm">
			<xsl:if test="ancestor::bipm:li">
				<xsl:attribute name="margin-left">7mm</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm">
				<fo:list-block provisional-distance-between-starts="8mm">
					<xsl:if test="not(following-sibling::*[1][local-name() = 'li'])"> <!-- last item -->
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
						<xsl:if test="../ancestor::bipm:ul | ../ancestor::bipm:ol">
							<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						</xsl:if>
						<xsl:if test="../following-sibling::*[1][local-name() = 'ul' or local-name() = 'ol']">
							<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="../ancestor::bipm:note">
						<xsl:attribute name="provisional-distance-between-starts">0mm</xsl:attribute>
					</xsl:if>
	
					<fo:list-item id="{@id}">
						<fo:list-item-label end-indent="label-end()">
							<fo:block>
								<xsl:value-of select="@label"/>
								<!-- <xsl:choose>
									<xsl:when test="@list_type = 'ul'"><fo:inline font-size="14pt" baseline-shift="-15%">•</fo:inline></xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="../@type = 'arabic'">
												<xsl:number format="1."/>
											</xsl:when>
											<xsl:when test="../@type = 'alphabet'">
												<xsl:number format="a)"/>
											</xsl:when>
											<xsl:when test="../@type = 'alphabet_upper'">
												<xsl:number format="A)"/>
											</xsl:when>
											<xsl:when test="../@type = 'roman'">
												<xsl:number format="i)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:number format="1)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose> -->
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()" line-height-shift-adjustment="disregard-shifts">
							<fo:block margin-bottom="0pt">
								<xsl:if test="@list_type = 'ol'">
									<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
								</xsl:if>
								<xsl:if test="ancestor::bipm:note">
									<xsl:attribute name="text-indent">3mm</xsl:attribute>
								</xsl:if>
								
								<xsl:apply-templates/>
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>
		
			</fo:block-container>
		</fo:block-container>
		
	</xsl:template>

	<xsl:template match="bipm:ul2/bipm:note | bipm:ol2/bipm:note" priority="2">
		<fo:list-item>
			<fo:list-item-label><fo:block/></fo:list-item-label>
			<fo:list-item-body>
				<fo:block>
					<xsl:apply-templates select="bipm:name" mode="presentation"/>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="bipm:formula/bipm:stem">
		<fo:block margin-top="6pt" margin-bottom="6pt">
			<xsl:choose>
				<xsl:when test="../bipm:name">
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="95%"/>
						<fo:table-column column-width="5%"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell display-align="center">
									<fo:block text-align="center">
										<xsl:apply-templates/>
									</fo:block>
								</fo:table-cell>
								<fo:table-cell display-align="center">
									<fo:block text-align="right">
										<xsl:apply-templates select="../bipm:name" mode="presentation"/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</xsl:when>
				<xsl:otherwise>
					<fo:block text-align="center">
							<xsl:apply-templates/>
						</fo:block>
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>

	<xsl:template match="bipm:example" priority="2">
		<fo:block margin-top="6pt" margin-bottom="6pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="27.5mm"/>
				<fo:table-column column-width="108mm"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell>
							<fo:block><xsl:apply-templates select="*[local-name()='name']" mode="presentation"/></fo:block>
						</fo:table-cell>
						<fo:table-cell>
							<fo:block>
								<xsl:apply-templates/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="bipm:bibitem">
		<fo:block id="{@id}" margin-bottom="12pt" start-indent="25mm" text-indent="-25mm" line-height="115%">
			<xsl:if test=".//bipm:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>			
			<xsl:call-template name="processBibitem"/>			
		</fo:block>
	</xsl:template>

	<xsl:template match="bipm:bibitem/bipm:note" priority="2">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:choose>
					<xsl:when test="ancestor::bipm:references[preceding-sibling::bipm:references]">
						<xsl:number level="any" count="bipm:references[preceding-sibling::bipm:references]//bipm:bibitem/bipm:note"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number level="any" count="bipm:bibitem/bipm:note"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super"> <!--  60% baseline-shift="35%"   -->
				<fo:basic-link internal-destination="{generate-id()}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt" start-indent="0pt">
					<fo:inline id="{generate-id()}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"><!-- baseline-shift="30%" padding-right="9mm"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
					</fo:inline>
					<xsl:apply-templates/>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="bipm:references[not(@normative='true')]">
		<fo:block break-after="page"/>
		<fo:block id="{@id}" line-height="120%">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="bipm:annex//bipm:references">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->	
	<xsl:template match="bipm:references[not(@normative='true')]/bipm:bibitem">
		<fo:list-block id="{@id}" margin-bottom="12pt" provisional-distance-between-starts="13mm">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline>
							<xsl:number format="1."/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>
						<xsl:call-template name="processBibitem"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	

	<xsl:template match="bipm:references[not(@normative='true')]/bipm:bibitem" mode="contents"/>
	
	<xsl:template match="bipm:bibitem/bipm:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="bipm:pagebreak">
		<fo:block break-after="page"/>
		<fo:block> </fo:block>
		<fo:block break-after="page"/>
	</xsl:template>

	<xsl:template match="bipm:admonition">
		<fo:block-container border="0.5pt solid rgb(79, 129, 189)" color="rgb(79, 129, 189)" margin-left="16mm" margin-right="16mm" margin-bottom="12pt">
			<fo:block-container margin-left="0mm" margin-right="0mm" padding="2mm" padding-top="3mm">
				<fo:block font-size="11pt" margin-bottom="6pt" font-weight="bold" font-style="italic" text-align="center">					
					<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@type))"/>
				</fo:block>
				<fo:block font-style="italic">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="insertHeaderFooter">
		<xsl:variable name="header-title">Le BIPM et la Convention du Mètre</xsl:variable>
		<fo:static-content flow-name="header-odd">			
			<fo:block-container font-family="Arial" font-size="8pt" padding-top="12.5mm">
				<fo:block text-align="right">									
					<fo:retrieve-marker retrieve-class-name="header-title" retrieve-boundary="page-sequence" retrieve-position="first-starting-within-page"/>
					<xsl:text>  </xsl:text>
					<fo:inline font-size="13pt" baseline-shift="-15%">•</fo:inline>
					<xsl:text>  </xsl:text>
					<fo:inline font-weight="bold"><fo:page-number/></fo:inline>			
				</fo:block>
			</fo:block-container>
			<fo:block-container font-size="1pt" border-top="0.5pt solid black" margin-left="81mm" width="86mm">
					<fo:block> </fo:block>
				</fo:block-container>
			</fo:static-content>		
		<fo:static-content flow-name="header-even">
			<fo:block-container font-family="Arial" font-size="8pt" padding-top="12.5mm">
				<fo:block>
					<fo:inline font-weight="bold"><fo:page-number/></fo:inline>
					<xsl:text>  </xsl:text>
					<fo:inline font-size="13pt" baseline-shift="-15%">•</fo:inline>
					<xsl:text>  </xsl:text>					
					<fo:retrieve-marker retrieve-class-name="header-title" retrieve-boundary="page-sequence" retrieve-position="first-starting-within-page"/>
				</fo:block>
				<fo:block-container font-size="1pt" border-top="0.5pt solid black" width="86.6mm">
					<fo:block> </fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>		
	</xsl:template>

	<xsl:template name="insertFootnoteSeparator">
		<fo:static-content flow-name="xsl-footnote-separator">
			<fo:block>
				<fo:leader leader-pattern="rule" leader-length="30%"/>
			</fo:block>
		</fo:static-content>
	</xsl:template>

	<xsl:template name="insertIndexPages">
		<fo:page-sequence master-reference="index" force-page-count="no-force">
			<xsl:call-template name="insertHeaderFooter"/>
			<fo:flow flow-name="xsl-region-body">
				<fo:marker marker-class-name="header-title">Index</fo:marker>
				<fo:block font-size="16pt" font-weight="bold" margin-bottom="84pt" margin-left="-18mm" span="all">Index</fo:block>
				<xsl:variable name="alphabet" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
				<xsl:for-each select="(document('')//node())[position() &lt; 26]">
					<xsl:variable name="letter" select="substring($alphabet, position(), 1)"/>
					<fo:block font-size="10pt" font-weight="bold" margin-bottom="3pt" keep-with-next="always"><xsl:value-of select="$letter"/></fo:block>
					<fo:block>accélération due à la pesanteur (gn), 33</fo:block>
					<fo:block>activité d’un radionucléide, 26, 27</fo:block>
					<fo:block>ampère (A), 13, 16, 18, 20, 28, 44, 49, 51, 52, 54, 55, 71, 81, 83-86, 89, 91-94, 97, 99, 100, 101, 103-104</fo:block>
					<fo:block>angle, 25, 26, 33, 37 38, 40, 48, 55, 65</fo:block>
					<fo:block>atmosphère normale, 52</fo:block>
					<fo:block>atome gramme, 104</fo:block>
					<fo:block>atome de césium, niveaux hyperfins, 15, 17, 18, 56, 58, 83, 85, 92, 94, 97, 98, 102</fo:block>
					<xsl:if test="position() != last()"><fo:block> </fo:block></xsl:if>
				</xsl:for-each>
				
			</fo:flow>
		</fo:page-sequence>
	</xsl:template>
	
		
	<xsl:variable name="Image-Logo-BIPM">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAaIAAADRCAYAAACOyra0AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2dpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDpGOTdGMTE3NDA3MjA2ODExODIyQUJFNEQ3OTI1MkI2OSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpCMTdGMTkxM0YzNEIxMUVBOEZCREQ0ODFDQjY0QzlCNyIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpCMTdGMTkxMkYzNEIxMUVBOEZCREQ0ODFDQjY0QzlCNyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBJbkRlc2lnbiBDUzYgKE1hY2ludG9zaCkiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0idXVpZDoyNGQ2ZDM1ZS1kNDc4LTcxNGItYjYwZi1iMDMyYWFmYzM3OTYiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5pZDoxNjcwQkZBMDExMjA2ODExODIyQUJFNEQ3OTI1MkI2OSIvPiA8L3JkZjpEZXNjcmlw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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-Logo-SI">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAACbEAAAmxCAYAAABl/CeTAAAACXBIWXMAAC4jAAAuIwF4pT92AAAgAElEQVR42uzdYWyc930n+G+q1DXXtsgbpUrdVCFTuB038FBzaZMDVjnoCdDe4epNrKCH4hIkZ/Z2i3H2ClhZYJNc1ltPr9Nc4hdndlE0Nu5uTe8VSXFYXOQEzr3YoKKwpwW2ycVjypfarRGTUd0kTocVZevkOhF0L4Y0KUW2JYqceZ6ZzwcgJNkynz+/zyPKHHz5+73p4sWLAQAAAAAAAAAAgGH4CREAAAAAAAAAAAAwLEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADI0SGwAAAAAAAAAAAEOjxAYAAAAAAAAAAMDQKLEBAAAAAAAAAAAwNEpsAAAAAAAAAAAADM2bRQAAAADAKOnWZqeSNLf5nzeTTA3oqIvb/O/ONFeXuu40AAAAAKPiTRcvXpQCAAAAALumW5u9UjHs9Ypmxeu8u5kk01K9Kide77YkOXOFf768/vZjv7+5unRGpAAAAADsBiU2AAAAAK6oW5stLvtHl/96Zv1tq8OSGxtP5seLcIuXP0aX/Z7l5urSsugAAAAA2EqJDQAAAGCEXTYF7fLpZ5dPSFNAY9AuL8Itbvn5crZMhWuuLi2KCwAAAGA0KbEBAAAAVES3Nru1hHZ5Ia3Y8nNlNEbd1vLbcjbLbpf83NQ3AAAAgGpQYgMAAAAYosuKaTPZXM+5dUqaUhpcn62lt60rThfXf1R4AwAAABgiJTYAAACAXXBZOW2jkDaTS0tqk5KC0tkovJ1Jv/CWbBbfzjRXl7oiAgAAANhZSmwAAAAA16hbm51Jv4y2tahWrP+onAbj4cT6j8vrb6+W3pqrS4viAQAAALh6SmwAAAAAW2yZoKagBlyvjaluG5PcljferC8FAAAA2KTEBgAAAIyVLVPULn+bSnJQQsAArWWz4HbJj9aWAgAAAONEiQ0AAAAYKVeYpLbx40ySaQkBFXJ5yW05JrkBAAAAI0iJDQAAAKicLdPUNkpqxfq/OiwdYIyspF9q2yi6LcYUNwAAAKCClNgAAACAUnqNopqVnwBXZ2OK23K2FN2aq0uLogEAAADKRokNAAAAGJotqz8V1QAGxwQ3AAAAoFSU2AAAAIBd163NNrM5VW1m/c3qT4DyeTKbxbblJMumtwEAAAC7TYkNAAAA2DHd2myRzZLaxs+nJQNQeRvrSTdWlHbTL7gtiwYAAAC4XkpsAAAAwDVTVgNgixNZn9qW9Qluym0AAADAtVBiAwAAAF6TshoA12Gj3LYxwa3bXF06IxYAAADgckpsAAAAQLq12Wb6BbXmljdlNQB22ta1pBsrSRfFAgAAAONNiQ0AAADGSLc2O5VLi2ozSQ5LBoAhW8ml5baulaQAAAAwPpTYAAAAYER1a7Mz2SyrFbEKFIDqORFT2wAAAGDkKbEBAADACFhfB7r1zXQ1AEbVk1kvtSVZTH9q2xmxAAAAQHUpsQEAAEDFdGuzRS4trB2UCgBjbus60sUotgEAAEClKLEBAABAiSmsAcC2KbYBAABARSixAQAAQEkorAHArlNsAwAAgBJSYgMAAIAh6NZmt5bVmkkOSwUAhmKj2LaYfqltUSQAAAAwWEpsAAAAsMu6tdmZbJbViiisAUDZPZlLi21dkQAAAMDuUWIDAACAHbZlLejGj9NSAYDKO5H1UluSRWtIAQAAYOcosQEAAMB1WJ+yVmSztHZQKgAwFlayWWqzhhQAAACugxIbAAAAXIP1KWtFNktrk1IBANaZ1gYAAADboMQGAAAAr6Fbm51Kv6hWpF9aOywVAOAabExrW0x/WltXJAAAAPDjlNgAAABgXbc228zmhLUiybRUAIAdtJZLJ7UtigQAAACU2AAAABhj66W1Ysub1aAAwKBZQQoAAMDYU2IDAABgbHRrs0U2C2tWgwIAZfRkNleQKrUBAAAwFpTYAAAAGFlKawDACHgy61Pa0i+1LYsEAACAUaPEBgAAwMhQWgMAxsBKLp3UtiwSAAAAqk6JDQAAgMpSWgMAUGoDAACg+pTYAAAAqAylNQCAN7SS5Fg2S21nRAIAAEDZKbEBAABQWt3abDP9wtqRKK0BAGzHk7l0UptSGwAAAKWjxAYAAEBpdGuzM+kX1or1t0mpAADsqBPZLLQtigMAAIAyUGIDAABgaLq12alcWlqblgoAwEA9ls1SW1ccAAAADIMSGwAAAAPVrc1uLa0dlAgAQGmsJTmWzVLbskgAAAAYBCU2AAAAdlW3NttMv7B2JMlhiQAAVMaT2Sy0HRMHAAAAu0WJDQAAgB1lRSgAwMiyehQAAIBdocQGAADAdevWZotsTluzIhQAYPStpF9oO5Z+qe2MSAAAANguJTYAAACuWbc2O5PN0lqRZFIqAABj7UQ2C22mtAEAAHBNlNgAAAC4KuvT1jZKa6atAQDwWkxpAwAA4JoosQEAAHBF3drsVDZLa0di2hoAANtjShsAAACvS4kNAACAV3Vrs830C2tHYtoaAAA7byWbhbZj4gAAACBRYgMAABh73drsRmmtSDItEQAABuixbJbalsUBAAAwnpTYAAAAxky3NjuTzRWhd0kEAICSeDL9Qtsxa0cBAADGixIbAADAGLAmFACAillJsph+oc3aUQAAgBGnxAYAADCi1teEFukX16wJBQCgqtayXmhLv9R2RiQAAACjRYkNAABgRHRrs1PpF9aK9R8npQIAwAg6kc1C27I4AAAAqk+JDQAAoMK6tdmZbJbW7pIIAABj5slsFtq64gAAAKgmJTYAAICKWS+uHUkyl+SgRAAAIEmykn6hbUGhDQAAoFqU2AAAACqgW5ttpl9cOxLFNQAAeCNr2ZzQdkwcAAAA5abEBgAAUFLrxbW59Itr0xIBAIBtUWgDAAAoOSU2AACAElFcAwCAXbWWZDGbpbYzIgEAABg+JTYAAIAh69Zmi2yuClVcAwCAwXksCm0AAABDp8QGAAAwBN3a7EZp7UiSSYkAAMDQKbQBAAAMiRIbAADAgCiuAQBAZSi0AQAADJASGwAAwC7q1mabSeZiVSgAAFSVQhsAAMAuU2IDAADYYYprAAAwsh5LstBcXTomCgAAgJ2jxAYAALADFNcAAGCsrGVzOptCGwAAwHVSYgMAANimbm12Jv3i2lwU1wAAYFwptAEAAFwnJTYAAIBrsF5cO5J+ce2gRAAAgC1W0i+0LTRXl7riAAAAuDpKbAAAAG+gW5udymZx7bBEAACAq7BRaJtvri4tiwMAAOC1KbEBAAC8hm5tdi798tpd0gAAAK7Dk0kW0l85uiwOAACASymxAQAAbNGtzR5Jv7h2JMmkRAAAgB32WPoT2o41V5fOiAMAAECJDQAAIN3abDP9VaFHkkxLBAAAGJBH0y+zHRMFAAAwzpTYAACAsdStzc6kX1qbS3JQIgAAwBCtpb9udKG5utQVBwAAMG6U2AAAgLHRrc1OZXNV6F0SAQAASmglyXz6E9qWxQEAAIwDJTYAAGDkdWuzRTbXhU5KBAAAqIgT6U9oO9ZcXTojDgAAYFQpsQEAACNpfV3o3PrbtEQAAIAKW0tyLP11o4viAAAARo0SGwAAMDK2rAudS3JYIgAAwAhaSX8624J1owAAwKhQYgMAACrPulAAAGBMWTcKAACMBCU2AACgkqwLBQAAeJV1owAAQKUpsQEAAJXSrc3OpT9x7S5pAAAA/JiVJPPpT2dbFgcAAFAFSmwAAEDpdWuzzWxOXbMuFAAA4Oo8lv50tmOiAAAAykyJDQAAKKVubXYq/YlrR5MclAgAAMC2rSVZSDJvOhsAAFBGSmwAAECpdGuzRfoT1+6WBgAAwI47kf50tgVRAAAAZaHEBgAADN361LW59KeuTUsEAABg160lOZb+dLauOAAAgGFSYgMAAIbG1DUAAIBSeDLJfJJjzdWlM+IAAAAGTYkNAAAYKFPXAAAASst0NgAAYCiU2AAAgIEwdQ0AAKBSTGcDAAAGRokNAADYNaauAQAAVJ7pbAAAwK5TYgMAAHacqWsAAAAj6cn0y2wLogAAAHaSEhsAALAj1qeuHUnSjqlrAAAAo2wtyUL6hbZlcQAAANdLiQ0AALgu3dpsM/11oUeSTEoEAABgrJxIv8x2TBQAAMB2KbEBAADb0q3NzqW/MvSwNAAAAMbeSjans50RBwAAcC2U2AAAgKvWrc3OpF9cOxpT1wAAALiyR5MsNFeXFkUBAABcDSU2AADgDXVrs0X6xbW7pAEAAMBVejLJfJJjprMBAACvR4kNAAC4om5tdirJkSTtJNMSAQAAYJvWsrlqdFkcAADA5ZTYAACAS6yvDD2a/tpQK0MBAADYSY+lX2ZbFAUAALBBiQ0AAEhiZSgAAAADtZL+5G+rRgEAACU2AAAYZ1aGAgAAMGRWjQIAAEpsAAAwjqwMBQAAoISsGgUAgDGlxAYAAGPEylAAAAAqwKpRAAAYM0psAAAwBrq12bn0y2sHpQEAAEBFrCWZT7Jg1SgAAIw2JTYAABhR3drsVPrFtaOxMhQAAIBqezT9VaNdUQAAwOhRYgMAgBHTrc3OpL925W5pAAAAMGJOpF9mOyYKAAAYHUpsAAAwIrq12SL98tphaQAAADDiVta/Bj7WXF06Iw4AAKg2JTYAAKi4bm12Lv0X7qelAQAAwJhZSzKfZKG5urQsDgAAqCYlNgAAqKBubXYqydH1t0mJAAAAQB5Nf9VoVxQAAFAtSmwAAFAh3drsTPpT145EeQ0AAACu5ESSdnN1aVEUAABQDUpsAABQAd3abJFkLsnd0gAAAICrspJ+mW1BFAAAUG5KbAAAUGLd2uyR9FeGHpYGAAAAbMtKkvkkC83VpTPiAACA8lFiAwCAEurWZufSXxs6LQ0AAADYEWvZLLMtiwMAAMpDiQ0AAEqkW5ttp782VHkNAAAAds+jSY6azAYAAOXwEyIAAIBSKaLABgAAALvtiAgAAKA8lNgAAKBc2iIAAACAXXfMFDYAACgPJTYAACiR5urSYpITkgAAAIBd1RYBAACUhxIbAACUT1sEAAAAsGseba4uLYsBAADKQ4kNAABKZn0a25OSAAAAgF3RFgEAAJSLEhsAAJTTvAgAAABgx5nCBgAAJfSmixcvSgEAAEqoW5tdTjItCQAAANgx71BiAwCA8jGJDQAAyqstAgAAANgxprABAEBJKbEBAEBJNVeXFpKsSAIAAAB2xIIIAACgnJTYAACg3NoiAAAAgOt2orm6tCgGAAAoJyU2AAAoMdPYAAAAYEe0RQAAAOWlxAYAAOU3LwIAAADYNlPYAACg5JTYAACg/BaSrIkBAAAAtqUtAgAAKDclNgAAKLnm6tKZmMYGAAAA22EKGwAAVMCbRQAAAJUwn+RokklRAIyvm++8/ZJf33LoV179+Z69ezNxe2PLrydz4213JEm6tVnhAQDj/PU0AABQcm+6ePGiFAAAGHtFvTOVfknszOIz95XyBe5ubbad5H53C6DabnhnLTe8Y3+SZKLxi3nz3r2v/ruJX7oje27Z7Cvf9K5DO3LNZ95/Z86fPC18AGDcrDRXl2bKeLBeq1Gk/zrE/L6HTy26VQAAjDuT2AAAGGtbymsbU87WinpnYfGZ+86U8LimsQGMgFsOH8yBP/jDgV5zz9RNggcAxlG75Gc7nOSuXqtxIklbmQ0AgHH2EyIAAGAcFfXOVFHvtJMspz/dbKMYNpl+Uax0mqtLZ2INCkDl/f13visEAIDdt9JcXVoo48F6rcZM+gW2DYeTHO+1GsfW/x0AAIwdJTYAAMbK65TXtjq6PqGtjBbcRQAAAHhD7Qqe7a4kz/VajQVlNgAAxo0SGwAAY+Eqy2sbyjyNbTnJo+4oANdiovGLQgAAxknZp7Dd/Qa/7e4oswEAMGaU2AAAGGnXWF7baq7EH1bbnQWorvNfXxn4Nd+8d6/gAYBx0h6RsymzAQAwNpTYAAAYWUW9M5drL69tmF7/70vHNDaAarvwwnkhAADsnrWKT2G7EmU2AABGnhIbAAAjp6h35op6ZznJI7n28tpW7RJ/mG13GgAAAH7M/Ah/Lb9RZpvvtRpTbjUAAKNEiQ0AgJFxWXltegfepWlsAIyEiV+6QwgAwDhYS0lLbNcxhe1K7k2y3Gs12spsAACMCiU2AAAqr6h3ih0ur23VLvGH3nb3Aarp5WefGuj19twyKXQAYBzMN1eXzpT0bHM7/P4mk9wfZTYAAEaEEhsAAJW1Xl5bTHI8O19e21D2aWwnPAkA1XPh7JoQAAB2VpmnsE0lObpL735rme2oxwAAgKpSYgMAoHIuK68dHsAl2yWOo+2JAAAAgFJPYTuaftlsN00mebDXaiz3Wo05jwMAAFXzposXL0oBAIBKKOqdmfRLW3cP4fIfXHzmvmNlzKVbm13MYMp8AOyQX/ja53PTuw4N+u8LwQMAo2otyUwZS2zrU9iWs/sltsutJDm67+FTxzweAABUgUlsAACUXlHvzBT1zkKS5zKcAluye2s/dkLbUwJQLeefPiUEAICdc2zMp7BdyXSSL/VajcVeq1F4RAAAKDslNgAASquod6aKeqed4ZbXNhwu6p2ijDk1V5cWk5zwxABUx4WzZ4UAALBz2mU81PoUtmF/U9zhJMfXy2xNjwoAAGX1ZhEAAFA2Rb2z8SLvsL5b+bW0kxQlja2d5LinBwAAgDHzaHN1abmkZ5tLeV7XOJzkiV6r8WiS9r6HTy17dAAAKBOT2AAAKJWi3plL0k1yf8pVYEvKP43tSU8QAK/l5jtvFwIAMIraJT7b0RKe6e4kz/Vajfn1SXEAAFAKSmwAAJRCUe8cKeqd5SSPJJku8VHbJT7bvCcJoBpePPkNIQAAXL/STmHrtRpzKffrG/cmWe61Gm1lNgAAykCJDQCAoSrqnaKodxaTfCnlfnF3Q5mnsS0kWfFUAQAAMCbaznZdJtOfhL+8XroDAIChUWIDAGAoinpnpqh3jiU5nuRwxY4/V+KztT1dAAAAjAFT2HbOZJJHeq3Gcq/VOOLRAgBgGJTYAAAYqKLemSrqnYUkzyW5q6Ifxt1FvTNTxoOZxgbAa7nl0K8IAQAYJQslPlu7oplOJ/lSr9VY7LUahUcMAIBBUmIDAGAg1str7STLSe4egQ+p7WwAbNdLjz8tBACA7TvRXF1aLOPBKjiF7UoOJzneazWO9VqNGY8bAACDoMQGAMCuK+qduSTdJPenv6JiFJjGBgAAAMPRLvHZjo5Qznclea7Xasz3Wo0pjx0AALtJiQ0AgF1T1DtFUe90kzyS6n8X8pW0S3y2eU8gAFvt2btXCADAKCjzFLYiycERzPzeJMu9VqPt8QMAYLcosQEAsOOKememqHcWkxzPaL54u6G009iSLCRZ8zQCsGHi9oYQAIBR0Ha2oZhMcn+v1VheX5kKAAA7SokNAIAdU9Q7U0W9s5DkuSSHx+TDbpfxUM3VpTMxjQ2g1M5986QQAACuTdmnsI3DayHTSR7ptRqL6x8zAADsCCU2AACu23p5rZ1kOcndY/bhHynqnamSnm0+prEBAAAwOsr8zVrtMbsXh5Mc77Uax3qtxoxHEwCA66XEBgDAdSnqnbkk3ST3p79aYtxMJjlaxoOZxgbAVnv2TgoBAKiylebq0rEyHmyMprBdyV1Jnuu1Gu1eqzHlMQUAYLuU2AAA2Jai3imKemcxySPpr5IYZ0dNYwPgWl14cbCfnm+87Q6hAwBV1na2Urs/yXKv1ZgTBQAA26HEBgDANSnqnZmi3llIcjzj+13GlzONDYBrdv4vnhICAMDVWWmuLi2U8WDrqzS9PtI3meSRXquxvD6dDgAArpoSGwAAV6Wod6aKeqed/urQuyXyY8o8jW3B7QEAAKDC2s5WKdNJjvdajcX1kh8AALwhJTYAAN5QUe/MpV9euz/976rlx5V5GttykkfdIgD27J8QAgBQNWWfwuYb/V7b4STP9VqN+V6rMSUOAABejxIbAACvqah3iqLeWUzySPrfRcvrO1ris7XdHoBy+dHZswO/5sS7/XUOAFRO29kq794ky71WY04UAAC8FiU2AAB+TFHvzBT1zkKS4+l/1yxXZ3J9al3pmMYGUD7nT/2lEAAAXt+aKWwjYzLJI71Wo9trNQpxAABwOSU2AAAuUdQ77fRXh3ohdnvazgYAAAA7Yt7X2CPnYJLjvVbj2HoREAAAkiixAQCwrqh3jhT1znKS+9P/7li2Z9o0NgDK6qfefqsQAICqWEtJS2ymsO2Iu5J0e61Gu9dqTIkDAAAlNgCAMbe+OnQxyZeSTEtkR7SdDYA3cuHMuYFf84YDbxM8AFAV883VpTMlPduc27MjJtP/Zspur9U4Ig4AgPGmxAYAMKaKemeqqHfmkzyX5LBEdlTZp7GdcIsAhu/8ydNCAAC4sjJPYZtKctQt2lHTSb7UazUWe61GUxwAAONJiQ0AYAytF6yWk9wrjV3TdjYAAADYljJPYTua/gQxdt7hJE/0Wo15K0YBAMaPEhsAwBgp6p1ifXXoI/GC626bLuqdUq7CaK4uLcY0NoCxdMPbDggBACg7U9i4N8lyr9WYEwUAwPhQYgMAGAPrq0MXkhyP1aGDVOYXtttuD8Dw/fB7g10pesPb3i50AKDsjpnCxnrOj/RajW6v1SjEAQAw+pTYAABGXFHvHE1/dejd0hi4w0W9U5TxYKaxAZTDK3/zHSEAAFyqXcZDmcI2NAeTHO+1GgtWjAIAjDYlNgCAEbW+OrSb5MH4LuFhajsbAAAAXJVHm6tLyyU921y8vjJMd6e/YlSREABgRCmxAQCMmMtWhx6UyNCZxgZAadxYbwgBACizdonPpjw1fJNJHrRiFABgNCmxAQCMEKtDS6td4rMtuD0Aw/PK84NdJ7rnpr1CBwDKqrRT2HqtxlySabeoNKwYBQAYQUpsAAAjwOrQ0ivzNLaFJCtuEcBwvPL8aSEAAPS1nY1rZMUoAMAIUWIDAKgwq0MrZa7EZ2u7PQAAAAyRKWxs19YVo01xAABUlxIbAEBFFfXOXKwOrZK7i3pnpowHM40NYLxMHDoghKuwZ/9Ebr7z9lffAIBdtVDis7Xdnko4mOSJXqsxb8UoAEA1vVkEAADVUtQ7zSTzSQ5Lo3LaKe9EtnaSR9wigMF65fTzA7/mnqmbxibfy8tntxz6lc0c9u7NxO2NLb+ezI233XHF9/N3X/liXnr8f/LAXul52j+RiXdfOpzmledeyCvfWhUOAFfrRHN1abGMBzOFrZLuTTLXazWO7nv41II4AACq400XL16UAgBABRT1zlT6RaN7pVFp71h85r7lMh6sW5tdjhfnAQbq5jtvz23/+/8x0Gs++9HfzEuPP125rCYOHcjN//l/mjfv3bv5z37pjuy5ZfLVX9/0rkM7ft2Xn30qf/WP/nEuvHB+bJ/Rn3r7rbnhwNty83v6+d5Yb2TPTXuvKcMLZ9dy/ulTuXD2bF48+Q1FNwC2el+JS2zd9Cd8UU0nkszte/jUsigAAMrPJDYAgAoo6p0j6U9fUzCqvnZMYwOAazJx6EDqX3l8KNde+fgnx6bAtmf/RG7+1Ttyyz98d25+z3tfczLdtdp4Pxslw7fe0//nP/ze6Zx/5lRe/I//IS/9+ydy/uRpDzvA+CnzFLYiCmxVdzjJc71W4/eSzO97+NQZkQAAlJdJbAAAJVbUOzNJFmJ16Kgp5TS2bm12Kslykkm3CGAwhjGJ7fkH7ssPPvvlymS0Z/9Ebl/8t/nJnzkw8GtXLavtuOGdtUx+4L2Z+tX/alcm2V2LH37vdNb+7PG8+B++nrUvfN0nCIDxUOYpbIvxeswoWUl/KtuiKAAAykmJDQCgpIp6p53kaBSKRtGji8/cN1fGg3Vrs+0k97tFAIOxZ/9EGk//x4Fe8/sPPZDvfvpPKpPR9KP/Q/6T939o4Nc9e+Kr+fYHPzWyz96+j70vk//Ff5m9h3+9lOfbKLS98Md/au0owOg60VxdKsp4sPUpbMfdopH0WJKjVowCAJSPEhsAQMkU9U6R/upQKytG11qSmcVn7ivdGgvT2AAGr7m6NNDrVanENvnhd+cdf/S/Dfy6P/ze6Txd/Ncjt0Z0z/6J7D/6G6kd+dBQJttt18vPPm1zu7YAACAASURBVJW1r3311V+/cvr5/P13vpskuXDmnDWkANX1webq0rEyHswUtpG3lqS97+FT86IAACiPN4sAAKAcinpnKkk7yb3SGHmT6U/Za5ftYM3VpTPd2ux8TGMDYMj27J/I2z/34FCu/e3fvmekCmwb5bW3fPSe7Llpb+XOf+Ntd+TG2+64qt/78rNP5cLZtSTJK89/J6883y+4/ejs2Zw/9Zev/r7zX18ZuZIiQMWslLjAVkSBbdRNJnmw12rMpb9itCsSAIDhM4kNAKAEinrnSJKFmH41TkxjAyDJ4CexnfvmyfzVr36s9Ln8wtc+n5vedWjg163autU3su9j78vPfvr3K1leG5Qffu90Xvmb7yRJLry4lvN/8dSr/+7/e+qZXFh7MUnyynMvWG0KsHN+q7m6tFDGg5nCNpb+MP3JbGdEAQAwPEpsAABDVNQ7M+mX17w4Op5+b/GZ+9plPFi3NtuOaWwAA3H7n3/hqqdM7YQqlNh++lMfyNs+0Rn4datS8LsaE4cOZPrBzw302RonF86dzcvPnHr11+efPpULZ88mSV48+Y289PjTQgJ4bSvN1aWZMh6s12rMJHnOLRrP5zLJ0X0PnzomCgCA4bBOFABgSIp6p53+SknTrsbX0aLemS/jNLYkVooCDMjG6kP6Jg4dGEqB7cK5s/n2h//ZSGR462c+krfe8wkP0y7ac9PeSyYFXjo18AElNoDX13Y2Smg6yZd6rcZj6a8YNZUNAGDAfkIEAACDVdQ7zaLe6aZfEFJgG2+T6RcZS6e5unQmyaNuEQCDNv3g54Zy3efu+Se58ML5Sme3Z/9EfuFrn1dgA6DMVkq8RnQmyd1u0di7K8lyr9U4KgoAgMFSYgMAGJCi3pkq6p35JE8kOSgR1pX5RdG22wMwei6dGFUuP/dH/3Qo6y+//1D1J2dNHDqQd/4//67U93dcvHjyG0IAqObXmb4GZsNkkgd7rcbierkRAIABUGIDABiAot4pknST3CsNLjNZ1DtzZTxYc3VpOaaxAey680+fEkKSm++8PW/58D0Dv+7Lzz6V7376Tyqd3b6PvS+3/ekXs+emvR4kAMpszRQ2KuZwkud6rUZbFAAAu0+JDQBgF61PXzuW5HiSaYnwGtrOBjC+Lpw9O/YZ7Nk/kXc89L8OPvtzZ/Ptud+pdHb7Pva+HPiDP1RgA6AK5n3tS0Xd32s1ur1WoxAFAMDuUWIDANglRb1zJMlykrukwRuYNo0NgLH+i/Dh+4dSwvrOJz+eV761WtncNgpslMsrz70gBIAft5aSlthMYeMqHUxyvNdqzPdajSlxAADsPCU2AIAdVtQ7M0W9s5jkS0kmJcJVajsbAINy8523l+Ys+z72vuw9/OsDv+7ffuGhrH3h65W9hwps5VXlYiTALppvri6dKenZ5twersG9SUxlAwDYBUpsAAA7qKh3jibpJjksDa5R2aexPeYWAeyOF09+Y2w/9hveWcvPfvr3B37dl599Kn/9O39c2dwmDh1QYAOgSso8hW0qyVG3iGs0nf5UtmOmsgEA7BwlNgCAHbBl+tqDMX2N7WuX+Gzzbg8AO236X/3BwNeIXjh3Nisf/2RlM7vhnbXc9qdf9PCU1IVzZ4UAcIWvJ0s8he1ovI7D9t2VZLnXahwRBQDA9VNiAwC4TkW9007yXExf4/pNF/VOKV/4bK4uLSY54RYBjIY9k7cM/Qy3fuYjueldhwZ+3b/5zL/M+ZOnK3vvfn7hjwZe/OPqvfzMKSEAXMoUNkbdZJIvmcoGAHD9lNgAALapqHeaRb3TTXK/NNhBZX4Bve32AIyGf3BHfajXnzh0IG+95xMDv+7ffeWL6X3+eGXv262f+UhuvO0ODzAAVbJgChtjYmMqm2IkAMA2KbEBAGzD+vS1J5IclAY77HBR7xRlPJhpbAC746XHnx6rj3fP/on8/P/y0MCv+/KzT+Wv/3l1t2PffOftQyn+AcB1MoWNcTKZ5MFeq7HYazVmxAEAcG3eLAIAgKtX1DvNJAtRXmN3tZMUJT7bcbcIgO269Xd/Kz/5MwcGft2Vj38yF144X9ncfu7+3y3Vec5982Re+vOTefHkN3L+6ytXzHbP/olMvHs6E41fzC3/2T/MTb/y3pFfhfrSn5/0hxxg06PN1aXlkp5tLqawsXsOJ+n2Wo32vodPzYsDAODqKLEBAFyl9elrVocyCIeLeqdYfOa+xbIdrLm6tNitzZ5I/wVZACpqz97hFIkmP/zuvOXD9wz8us8/cF/Onzxd2fv105/6QCnWiP7we6fzwr95OKv/+t9dVSHwwgvn89LjT+elx5/OD/LlJMm+j70vtd/4zdz0rkP+IAKMvnaJz2YKG7v+v77pT2U7kmRu38OnlkUCAPD6rBMFAHgDRb1TFPXOchTYGKx2ic+24PYA7KwL584O9HoTtzcG/jHu2T+Rt3/uwYFf9+yJr+YHn/1yZZ+NPfsn8jP//SeG/nw+/8B9+X/feWd+8NkvX9dEu97nj+evfvVjefajv5mXn33KH36A0VXaKWy9VmMuybRbxIBsTGVTnAQAeANKbAAAr6God6aKemc+/dWJXtxk0A4X9U5RxoM1V5cWkqy4RQA75+VnTo38x/jzX/ifB75K8offO52V1u9VOrf9R39jqCs4z574ar71y7+240XAlx5/Ok+/58N5/oH7Ruo5f+X08z6hAfS1nQ1etTGVbbHXasyIAwDgypTYAACuYL081E1yrzQYorkSn63t9gBwtX76Ux8YyvrIb//2Pdc1NWzY9uyfyFs+es/Qrv/9hx7Itz/4qV3N8Aef/XKeef+dA59GuFv+/jvf9QcewBQ2eC2msgEAvA4lNgCALUxfo2TuLuqdmTIezDQ2gGrbs3dyYNeaOHRgKOswv//QAzl/8nSl71Ptv/u1oU1hO/0v7s13P/0nA7nW+ZOn861f/jXrRQFGx3yJz9Z2exgyU9kAAF6DEhsAwLqi3mkmWYzpa5RL29kARt+FF9cGer0bb7tjYNeafvBzAy9infvmyYEVsHbT/v+2NZTrnv4X96b3+eOD/TPwwvn81T/6x5WfyHbhzDmf0IBxd6K5utQt48FMYaNkTGUDALiMEhsAQJKi3mkneSLJQWlQMqaxAYyB838xmhOofu6P/ulAC3NJcuHc2Xz7w/+s8tndfOft+cmfOTDw6/7tFx4aeIHt1Xv3wvk8+998aCDPyPcfeiDff+iB/N1Xvphz3zyZc988uSOT4Ko+/Q9gB7RLfDZlIcrGVDYAgC3eLAIAYJytT19biPIa5dZOMlfisz3iFgFwuZvvvD1v+fA9A7/uc/f8k1x44Xzl89v3mx8c+DVffvap/PXv/PFQP+7zJ0/n+Qfuy9s+0dm1a+y5aW9+dPZsfvDZL7/hM7zhp95+a2448Lb+f793byZub7z6726sN4a29hWgZE40V5cWy3iwXqtRxGs/lNfGVLb2vodPzYsDABhXb7p48aIUAICxtD597X5JUBHvWHzmvuWyHapbm51Kspz+dw8DsE23fuYjees9nxjoNb/13iKvfGt1V973nv0TuX3x3w58ktj3H3pgJNaIJknj9P898GLUM++/szSTxH7ha5/PTe86tGvv/8K5s/nWL//aSBQeAUrkfSUusS2mXxSCsjuRZG7fw6eWRQEAjBvrRAGAsVPUO82i3ulGgY1qaZfxUM3VpTNJfJcwwHX60dmzA7/mDe/Yv2vve/rh+wdeYHv52adGpsA2cejAwAtsf/uFh0q1CvO7D/7hrr7/PTftzf6jv+GTD8DOKfsUNgU2qmJjKtsRUQAA40aJDQAYK+vT156IFRJUz5Gi3pkq6dnmk6y5RQDbd/7UX47Mx7LvY+/L3sO/PtBrXjh3Nt+e+52RyXDqzsMDz++7/2O5toO/9PjTOffNk7t6jbd89J7s2T/hExDAzmg7G+yYySRf6rUax3qtxpQ4AIBxocQGAIyFot6ZKeqdxZi+RnVNJjlaxoOZxgbAhhveWcvPfvr3B37d73zy47u2GnUYbn7PoYFe7+yfPV7KtZqmsQFUxoopbLAr7kqybCobADAulNgAgJFX1DtHk3TjRUuq76hpbADslJ96+607/j6n/9UfDGUN5toXvj5S9+amdw22xPbdzz1cyhxeevzp/PB7u7vitHbkQz4ZAFy/trPBrjGVDQAYG0psAMDIKuqdqfXpaw+m/4IPVJ1pbAAj6pXnXhj4NW848LYdfX+3fuYjAy9fvfzsU6Vbg3m9br7z9oFnWOYpdmt/9viuvv+f/JkDmTh0wCchgO1baa4uLZTxYL1WYya+oZHRcVeS7vp0QQCAkaTEBgCMpKLeOZJkOV6sZPSUfRobANtQ9VWYE4cO5K33fGKg17xw7mxWPv7JUq7BvB67MSHv9fT+zz8tdR5n/q8/2/Vr7PvQ+30SAti+trPBwEwnOd5rNeZNZQMARpESGwAwUtanrx1L8qWYvsZoKvs0tkfdIoDxsmf/RKYf/NzAr/s3n/mXOX/y9MjludMT8t7IS//+iVLn8dLjT+/6NW5+z3v9QQbYnrJPYbvbLWJE3ZtksddqNEUBAIwSJTYAYGQU9U6RpJv+eH0YZUdLfLa22wNQDTe8bWdWKN76u7+VG2+7Y6Bn/7uvfDG9zx8fyfty83sGt5L1wrmzlSgCnvvmyV19/zfedkf27J/wSQFgtL7+87Upo+5gkid6rYZnHQAYGUpsAMBIKOqd+STH0x+rD6Nusqh35sp4sObq0nJMYwPYlh9+b7Blohve9vbr/wvpw+/OWz58z8Bz+ut/boP1Tnj5mVOVOOcrz39n169x86/e4YEAuDamsEE53N9rNbrrzz0AQKUpsQEAlVbUO82i3ummP0Yfxknb2QBGyyt/851KnXfP/om8/XMPDvy63/7te3LhhfMj+xzcWG8M7Fov/fnJavzZeH73C57/4I66T0IA12bB16RQGgeTdHutxlFRAABVpsQGAFRWUe8cTfJE+i/UwLiZNo0NgKH+RfTw/dlz096BXvP5B+6rxPrL6zHITH909qwHed3EL5nEBnAN1pKUciyqKWyMsckkD/ZajWO9VmNKHABAFSmxAQCVU9Q7M0W9s5jkQWkw5trOBsB2Xc/Er5/+1Aey9/CvD/S8Z098NT/47JfduB10/tRfVuKcL578xq5fY88tkx4IgKs331xdOlPSs5lExbi7K8lyr9UoRAEAVI0SGwBQKUW9cyRJN8lhaUDpp7E95hYB/z979x8cd33nh/+VKPhQZCRhgwMBRSZjbn2uF2+5kHbqfMfLDddM4wPcfm86h4eOlNJ2TY5vUXrfI4T4juVuIQl3rUVLD7u9nOVJxtzke/3GCQed+4YJ6ym6uYaEOLJLrMMTLBSC42SFJazItU/D9w8Jwi+DLWt337v7ePyFDOz79Xm9Pyt5V899vTlzJ1+o7XGiC5341b6+Jy757TtqWuupI+MxVrjHTULV1PIYV4AGl/IUtu6I6LdFEF0R8USlkB00lQ0AaCRCbABAQ8hnSt35TGkoIr4Wc2/EAHOKCdc2aHsAztzJFxrjmMzebV+s+TGiY7/7OzF7dMZNQtXU+p4GaGCpT2HznhH8wu0RUa4UsjmtAAAagRAbAJC8fKaUj7npa326AW/ROz+hMDm5iZFyROy1RQDN49L7bo7zV62t6Zo/2X5/HH/0oOZXgb4CcJZSn8LmKFF4q3UR8b1KIev5AQAkT4gNAEhaPlMqRsQTEdGrG3BaKb8RWbQ9AOlqX99zxv/t0o2r4wNbanuM6PTTw/HiXV+xUS3ugvUf0QSANAyZwgYNa1ulkC07XhQASJkQGwCQpHymtDKfKe2LiLt1A97VhvmJhckxjQ3gzP38wGjN12zr7jiz/25Fe/T+0b+vaW2z01Pxw83/zo1RRUvWLNMEAM6GKWzQ2DZExOFKIbtJKwCAFAmxAQDJyWdK/TF3fOg63YAzVlQbQGObnXw52dp6d9wd513SU9M1n9vyr2L26EzL3QenjozXbK0lV6xoiJ4suazHNwiA+tuVmxg5nGhtprDBmeuKiK9VCtlBU9kAgNQIsQEAychnSt35TGkoInaGNx/hbJnGBkBVdG2+Jjo3fKKma/5s9/Y4/ujBluz3yR8/76Z7kyWXfUgTAOqvmHBt/bYHztrtEVGuFLI5rQAAUiHEBgAkIZ8p5WJu+lqfbsCCFROubcj2AKSnPfvL7/jvl6xZFh/64raa1nTi0IH40W1/0rJ7cvKF55PZ/1Scn8lWfY1aTsADaEDJTmGrFLL9EdFri2BB1kXE9yqFrON4AYAkCLEBAHWXz5SKEfG98KYjnKuUp7ENRcSYLQI4vZmnav9t8n2dne/473v/473R1tFZs3pmp6fih/23tfR9cPKF2oWpfunyy5Pvx5I1y2pyD5qAB/COimqDpratUsjucbwoAFBvQmwAQN3MHx9ajoi7dQMWTX/CtRVtD8DpzR6dSaqei++8ITquXl/TNV/6+u44+cxES98HLw9/p2Zrta/OJt+PCzasq83z7+VJ34QA3p4pbNAaboyIw5VCNq8VAEC9CLEBAHWRz5Q2RcThiNigG7Co+vKZ0soUCzONDaBxtK/vicvuKNV83Ys2b4mlG1e3dO9rOZGv1iHFhVj6D/9hbfr+gwOe+ABvbzDh2oq2BxZVV0Q8USlkB7UCAKgHITYAoObymdJgRHwt5t4YARZfUW0AnImlH31riKltRXv0bvti3Wq6YvufRtuK9pbdk9mjM3HiUO0CVV2br0m6H52/trEm6/z8wKhvCABvtTc3MbIvxcJMYYOqur1SyO6rFLIrtQIAqCUhNgCgZvKZ0sp8prQvIm7XDagq09gAGlQtw0unc+nvfzLOX7W2buu3dXRG747WPm3++LefrNlaF/yjdENsXZuvibaOzpqsdXLsiG9AAG9VVBu0rHURsa9SyG7SCgCgVoTYAICayGdK/RGxL+beAAGqr6g2gMYzOzVZ1/WXblwdF23eUvc+dG74RFx85w0tex+8/NdP1WytC2/cnGwfVvzLf1mb5930VMwMj/sGBPBGe3MTI+UUC6sUsvkwhQ1qoSsivlYpZIcqhWy3dgAA1SbEBgBUVT5T6s5nSkMRsTMcHwq1lOw0tojYExGTtgggLW0r2uOK7X+aTD2X3VGK9vU9LbkXk7ufitnpqdrse0dnLL/12uR6sGTNsui4en1N1joxut83AIC3KqoNmNcXEeVKIZvTCgCgmoTYAICqyWdKuYgox9wbHUDtFVMsKjcxciwiBm0PQP29PiTUu+Pumh3deKZ6t30x2la0t+TeTH3r0Zqtdcn/9X8nd/2XfqZQs7WOPf7ffTMAeKPUp7BtsEVQc+tiLsjWrxUAQLUIsQEAVZHPlAZiLsDm+FCon758ppTqcQ+DYRobwFsc//ZwXda9+M4bonPDJ5Lrx/mr1sblfzTQkvfC0f/ylZqtdd4lPUlNY1u6cXVceP1NtXve/Y/v+eYD8EZFtQFvoysidlYK2T2OFwUAqkGIDQBYVPPHh+6JiG3h+FBIQZK/+TeNDSAdS9Ysi0t++45k67vw+puSPO6y2maGx+PEoQM1W++Dd/1hMlPvLr/792u21qkj4zEzPO4bAcAvjJnCBryLGyNin+NFAYDFJsQGACya+eND98XcGxlAGgZMYwPgnax5spzcMaJv9sG7/jCWrFnWcnvz053/tWZrtXV0Ru+Ou+t+zZc/+Kk4f9Xamq03WcNjWwEaRFFtwBnojYjvVQrZAa0AABaLEBsAsCjmjw/9Xsy9gQGkoytMYwOgwbV1dMaHhx5sueuuPPREnDpSuylhnRs+EZfed3Pdrnf5rdfGRZu31LbHDz/iCQbwC2O5iZGhJH8mzk18MoUN0rPN8aIAwGIRYgMAzsmbjg8F0pT6NDYA5r08/B1NOI3zV62Nyx/8VMtd95H/9Mc1Xe8DW+6oy/Gt7et7oufeB2q65olDBxwlCvBGxZRf19oeSJbjRQGARSHEBgAsmONDoWGkPo1tly0C4ExctHlLLN24uqWuudbT2CIieu59IC6+84ba/UVl8zWx6s8frnlva3lcK0ADSHkK28qI6LNFkDTHiwIA50yIDQBYEMeHQsNJeRpb0fYAcKau2P6n0baivaWueex3f6fma152Ryl6d3226r2++M4b4ooHvxRtHZ01vb5TR8aj8tATnlAAjfG6zGtGaByOFwUAFkyIDQA4K44PhYbVFRGbUiwsNzFyOExjA+AMtXV0xod3/4eWuubjjx6Mqb2P1XzdC6+/KVaX/6Iq0++WrFkWVz7+UFx2R6kuPa31Ma0AiTOFDVhMjhcFABZEiA0AOGPzx4eWw/Gh0KiKagNI2/FHD2rCGei4en1Nj7tMwVjhnpidnqr5uudd0hOrvvzVuPLxhxYlzLZkzbK49L6bY82T5ei4en1demkKG8BbDHmtCCyyV48X7dcKAOBMveeVV17RBQDgXeUzpf6IGIy5aU5A4/pkeXTrUIqF7Vt21VD4hD1A5CZGNOEMjV6/MWaGx1vmers2XxNXPPilutZw4tCBqPy/fx7H/8f3zrj3bSvaY+l1a6P749fFhdffVPc+PnfbLTG5+ylPIIA5kxGxMjcxciy1wuansD1ni6Dh7YqIgeU79h/TCgDgnQixAQDvKJ8pdcdceE2wBJrDWHl068oUC9u37KqV4RcUAEJsZ+HUkfE4mP/NmD060zLX3Lvrs0kEwSIiZqen4sTo/jj+7eGIiPi7qak4+fyL8f61mYiIWHJZT7T/SjbOX7U2mf5NPz0cz153qycPwC/ck5sYKaZYWKWQHYyI220RNIXvR0T/8h3792kFAHA6QmwAwGnNHx86FBHrdAOaSsrT2PaEI4uBFpcdfzLaOjo14gy99MjDMdb3+Za53rYV7XHlX34pqWBYo5idnorRj98QJ5+Z0AyAOSlPYeuOiMPhRABotu85A8t37B/SCgDg7bxXCwCAt5PPlDZFRDkE2KAZFROubdD2AK3uxOh+TTgLF15/Uyy/9dqWud7ZozPx7G/cErPTUzb/LD3/mU8LsAG86fVXigG2eQMhwAbNpisids5PWQQAeAshNgDgLfKZ0mBEfC28WQjNqjefKfWnWFhuYqQcEXttEQBn44N3/WG0r+9pmeudPToTh37rJkG2s/DSIw/H5O6nNALgFyYj0Q8RzU9hG7BF0LRurxSy+yqF7EqtAABeT4gNAHhNPlPqzmdK+yLidt2AptefcG1F2wPQmKafHo4Thw7UfN22js7o3fbFlur1zPC4INsZOnHoQEsdOQtwhoZMYQPqaF1E7KsUsnmtAABeJcQGAERERD5TykfE4XB8KLSKDfPP++SYxga0utmXJxuy7lNHxuOHm/9djH36M3UJVp2/am1c/uCnWupeEWR7dycOHYhnf+MWjQB4K1PYgHrriognKoVsUSsAgAghNgAgIvKZ0kBEPBE+5Qqtpqg2gPTM/OBAQ9b9w3+9JWaPzsTM8Hgc+c/316WGizZvia7N17TW/TI8Hj/78nZPnLfxaoBt9uiMZgC80a7cxMjhRGszhQ1az92VQnbPfIgVAGhhQmwA0MLmjw/dExHbdANakmlsACyKF+7fGjPD4699/dMvfCOmnx6uSy0f+uK2aFvR3jK9v/S+m+MDW+5wE76JABvAOyomXFu/7YGWdGPMHS+a0woAaF1CbADQovKZUi4iyjH3BgHQuooJ1zZkewDS99IjD8dPv/CNt/z52L/9XF2OuWzr6IwP7/4PTd/39vU9sfrbuwXY3oYAG8A7SnYKW6WQ7Y+IXlsELas3Isrz3wsAgBYkxAYALSifKfXHXIBtnW5Ay0t5GttQRIzZIqDV/N3UVMPUeuLQgfjR7w6+7b87+cxE3Y4V7bh6fVx6381Ne48sv/XaWPXnD8f5q9Z6wrzJS488HAc/ulmADeD0imoDEtYVETsrheyQVgBA6xFiA4AWk8+UBiNi5/wbAgAREQMJ11a0PUCrmdn/tw1R5+z0VIx9+jPvGBaq57GiH9hyR7Sv72m6++PyBz8VPfc+EG0dnZ4sb7ofxz93e4z1fV4zAE7PFDagUfRVCtl9lUJ2pVYAQOsQYgOAFpHPlLrzmVI5Im7XDeBNbsxnSitTLMw0NoB0/fi+34uZ4fF3/e9+uPnf1eVY0YiID//X7dG2or1pet6767Nx0eYtbr43mX56OEY/fkNUHnpCMwDe2WDCtRVtD/Am6yJiX6WQzWsFALQGITYAaAH5TCkXEYcjYoNuAKdRVBsAZ+pnu7efcWBo9uhMPP+ZT9elzvMu6YneHXc3Rc97d302Lrz+Jjff65w6Mh7jn7s9nr3u1jj5zISGALyzvbmJkX0pFmYKG/AOuiLiiUohO6AVAND8hNgAoMnlM6X+iPheOD4UeGd9prEBpOHkc0eTru/EoQPxo9v+5Kz+n8ndT8XU3sfqUm/nhk/E8luvbeh7QoDtjWanp+In2++Pg/nfNH0N4MwV1QY0sG2VQnaoUsh2awUANC8hNgBoYvlMaSgiduoEcIaKagOov5QnSs1OT8UP+29b0P87VrinbseKfvCuP4z29T0NeT9cet/NVQ2wvfTIw/HSIw83RC9OHRmPn2y/P5751V+PF+/6SswenfENA+DM7M1NjJRTLGz+mEBT2IAz0RcR5Uohu1IrAKA5veeVV17RBQBoMvlMqTsiyhGxTjeAs3RFeXTr4dSK2rfsqu6YOxbZVEmgJeQmRpKs69C/+Odx/NGDC/7/uzZfE1c8+KW61H7i0IF49jduaajgU7X79cL9W+OnX/hGREQsWbMslt/8iVi26aY475K0An9Tex+Lyf/vr0xdA1i4axMOsZUjYoMtAs7CZET0L9+xf49WAEBzEWIDgCaTz5RyMRdgE/QAFmJXeXRrf4qF7Vt2VTEi7rZFQCtIMcT2k+33x4t3feWcH+fDX/tChEvfGgAAIABJREFUdG74RF2u4We7t5/1Uaj1smTNssj81TeiraOzKo8//rnbTxsK69p8TXR//Lro/LWNVVv/3UztfSxe/p9/HZPfeDLp6YQADWBvbmIkn2Jh81PYJJSBhbpn+Y79RW0AgOYhxAYATSSfKfWH40OBc3dheXTrsdSKMo0NaCV/75lHk5qGNf30cDx73a2L8lhtK9pjdfkv6nZ9z912S0zufir5e+DKxx+KjqvXV+Wx3ynA9mZLN66OC9Z/JJZ+dH3V6pmdnooTo/vj+LeH4+cHRhtifwAaiClsQDP7esxNZTumFQDQ+ITYAKBJ5DOloYjo0wlgEdxTHt1aTLEw09iAVlHNANPZmp2eimd+9dcX9RjOpRtXx6ovf7Vu1zP68RuSnu61/NZro+feB6ry2Oc6ja59fU8s6b0k3r82E22dndG+OvvavzvdPftqSO1Vx789HBERLw9/J04+d9SkNYDqGctNjKxMsTBT2IBF9P2YC7Lt0woAaGxCbADQ4PKZUnfMHR+6TjeARTIZEStNYwOon5RCbKPXb4yZ4fFFf9zLH/xUXLR5S12uaTEnyy22thXtsea736zKMZ6njozHwfxvLmogEYCkfTI3MTKUYmGmsAGLbDIiNi3fsb+sFQDQuN6rBQDQuPKZUi7mwhwCbMBi6oqIgRQLy02MHIuIQVsEUBsv3L+1KgG2iIgX/2BnnDoyXpfr6rh6fVx6381J9nzFwP9ZlQBbRMSR//THAmwArWMs4QBbLgTYgMXVFRFPVArZAa0AgMYlxAYADSqfKfVHxPfCNCKgOgbmJz2mSIgNaHonX3i+7jVM7X0sfvqFb1Tt8WePzsTY7/5O3a7vA1vuiKUbVye398s23VSdfk9PReUhp7YBtJBiyq83bQ9QJdsqhexQpZDt1goAaDxCbADQgPKZ0lBE7NQJoIpSn8a2yxYBzezkC+N1Xf/EoQMxVrin6uscf/Rg/Gz39rpdZ+8f/ftoW9Gezg/fzdfEeZf0VOWxp771qCcWQOtIeQrbyojos0VAFfVFRHn++w0A0ECE2ACggeQzpe58plQOb/YBtZHyNLai7QGojtnpqRj79Gdqduzkj277kzhx6EBdrvW8S3qid8fdyfS+++PXVe2xf/6D/+XmBmgdRbUBLW5dROybP74YAGgQQmwA0CDymVIuIvZFxAbdAGqkKyI2pVhYbmLkcJjGBlAVP77v92JmuLaT4MY+/Zm6XW/nhk/ExXfekETvO39tY9Uee2b/37q5AVqDKWwAc7oi4nuVQrZfKwCgMQixAUADyGdKmyKiHBG9ugHUWFFtALX38wOjdVn3pUcejspDT9R83Znh8fjJ9vvr1u9LfvuOaF/fU9c9X7pxdbR1dFbt8WePTXtiAbSGIa/hAN5gZ6WQHdIGAEifEBsAJC6fKRUj4msx98kxgFrrzWdK/SkWZhob0MxmJ1+u+ZonDh2Isb7P1+2aX7zrK3U7VrStozN6t30x2la01+3627O/XNXHr/V0PQDqYjIiBlMszBQ2oM76KoVsuVLIdmsFAKRLiA0AEpXPlLrzmdJQRNytG0CdFdUG0Px+dM8f1L2Geh4rev6qtXH5Hw3Ubf33dXZW9fGXblztJgdofoO5iZFjidY2YHuAOtsQEfsqhWxOKwAgTUJsAJCgfKbUHXPHh/qEKpCC1Kexfd0WAZy7C9Z/pO41zAyPxwv3b63b+hdef1N0bb6mLmsv/ej6qj5+W9cFbnKA5pbyFLbuiOi3RUACeiOiXClkN2kFAKRHiA0AEpPPlHIRcTgi1ukGkJBiwrUN2h6g2cw8Nday1/7TL3wjpp8ertv6H/ritliyZlnT9fWCf3SNJxZAc0t9CluXLQIS0RURX6sUsiZEAkBihNgAICHzk46+F97YA9KT8jS2ckTstUVAM5k9OtPS1z/2bz8Xs9NTdVm7raMzPjz0YNP19MIbN0fbinZPLoDmlPoUNkERIEXbKoXskDYAQDqE2AAgEflMaTAiduoEkLD+hGsr2h6A5nHymYk48p/vr9v6569aG5fed3NT9bStozMu/f1PurkAmtOQKWwAC9JXKWT3zQduAYA6E2IDgDrLZ0rd+UxpT0TcrhtA4jbkM6V8ioWZxgZw7pZ+dH1S9dT7WNEPbLkjlm5c3VR7fNHmLbH81mvd7ADNxxQ2gIVbFxH7KoVsTisAoL6E2ACgjvKZ0sqIKEfEjboBNIii2gBqo54BrlTU81jRiIgrtv9pzY7gnH15sibr9Nz7QFx85w2eYADNY1duYuRworWZwgY0it6IKFcK2U1aAQD1I8QGAHWSz5RyEbEv5j7pBdAoTGMDoGZOPjMRz3/m03Vbv62jM3p33F2TtWZ+cKBm13XZHaW48vGHYsmaZW4ygMZXTLi2ftsDNJCuiPhapZA1QRIA6kSIDQDqIJ8p9cfcBDafRgUaUTHh2gZtD0Bzmdz9VEztfaxu63du+ERNJpedHH+hptfVcfX6WPNkOXp3fbbpjk0FaCHJTmGrFLL9MTfZCKDRbKsUskPaAAC1955XXnlFFwCghvKZUjEi7tYJoMFdWx7dWk6xsH3LrjocflkCNIErH38oOq5eX+vvoUn2om1Fe6z57jejraOzbjWMXr8xZobHq/b47et7IvPIo3W7vlNHxmPyW4/Gy3/9VBx//EDMHp3xJARI3xUJh9i8LgMa3fcjIr98x/5jWgEAtSHEBgA1ks+UumNuQlCfbgBN4Ovl0a2bUixs37Kr+iNipy0CGt2l990cH9hyR62/hybbj67N18QVD36pbuufOHQgnv2NW6oa7sqOP1nXoN7rnToyHjOj+2PmBwfi5PgL8b+ffzFmj01XNcgHwFnZlZsY6U+xsPkpbF6TAc3g+xHRv3zH/n1aAQDVJ8QGADUwH2ArR8Q63QCayBXl0a2HUyzMNDagGQixvdWHv/aF6Nzwibqt/9IjD8dY3+er9vi9uz4bF15/U0Pcn7PTU3FidP9rX88c3B+zU1MREa+F3iJC8A2gev5+bmIkyVCFKWxAk5mMiE3Ld+wvawUAVNf7tAAAqiufKeUiYk948w5oPsWI6E+4Np/8BzhLbSvakz5GcqxwT6z57sfqNq3swutviuO3/k1UHnqiKo9/7K8eb5gQW1tH5xuOuz3To29PHDoQs1OTERFx8oXn4+QLcwG3v5uaipn9fxsRgm8AZ2BvwgG2/vAeGNBcuiLiiUoh+8nlO/YPaQcAVI9JbABQRflMKR9zAbYu3QCalGlsAFVSj0lsh/7FP4/jjx5Mui9LN66OVV/+at3Wn52eitGP3xAnn5moyuP/vWcejfMu6fEEmPdq6O3VSW8vD38nTj53tGr9B2gQ1+YmRsopFmYKG9DkHli+Y/+ANgBAdQixAUCV5DOl/jAFCGh+u8qjW/tTLGzfsqt8HwYaWj3CWo0QYouIuPzBT8VFm7fUbf0Thw7EwY9urspj1yO82Kimnx6OmYP7Y+Z//SBe3vt9wTagVezNTYzkUyysUsjmI+IJWwQ0uV0RMbB8x/5jWgEAi0uIDQCqIJ8pDUbE7ToBtIiUp7EdC9MwgQYlxHZ6bSvaY3X5L+o6sexnu7fHj277k6a8tkY1Oz0VU996NI7/zd8ItQHNLOUpbOWI2GCLgBbw/YjIC7IBwOJ6rxYAwOLJZ0rd+UxpKATYgNZSTLi2QdsDcObaui5oiDpnj87E2O/+Tl1ruGjzlli6cXVVru1HpaKbcSH3b0dnXHj9TdFz7wOx5slyrP727rj4zhtiyZplmgM0i70JB9jyIcAGtI51EbGvUsjmtAIAFo8QGwAsknym1B0R5Yjo0w2gxfTNfw9M0WBETNoioBHNHpuu+ZrvX5tpmP4cf/Rg/Gz39rrWcMX2P422Fe2L/riTu5+Kqb2PeRKco/NXrY3L7ijFmifLceXjD8XyW6/VFKDRFdUGkIzeiCjPh3gBgEUgxAYAiyCfKeUiYl/MfQILoBUNpFhUbmLkWJjGBjSomeFxTXgXL/7Bzjhx6EDd1m/r6IwP7/4PVXnsscI9ceqIe2CxdFy9PnrufSCy40/GpffdXJXwIUCVfd8UNoDkdEXEE5VCtl8rAODcCbEBwDnKZ0r5mJvA1qsbQAsbMI0NgFqbPToTY5/+TF1r6Lh6fVx85w1VubYf/ustMTs9ZaMXUVtHZ3xgyx2x5rvfFGYDGk3KH84p2h6gxe2sFLI+RAkA50iIDQDOQT5T6o+IJ2LuE1cArawrTGMDaHhtnZ0NV/PM8Hj8ZPv9da3hsjtK0b6+pyrXdui3bhJkq8a9/rowW9fmazQESN1YbmJkKMXCKoVsLkxhA4iIuL1SyA5pAwAsnBAbACxQPlMqRsROnQB4jWlsAIus1uGl9tXZhuzTi3d9pa7HikZEfPi/bq/KVC9Btupq6+iMKx78Ulz5+EOmsgEpK6b8OtD2ALymr1LI7qsUst1aAQBnT4gNABYgnykNRcTdOgHwBqlPY9tji4BGc2J0vyacoXofK3reJT1x+R9V58fgzPB4jH78hroH9ZpZx9XrY813vxlLN67WDCC5H3EJT2FbGRF9tgjgDdZFRHl+UiUAcBaE2ADgLOQzpe58plQOb9ABnE7K09iKtgegeaVwrOiF198Uy2+9tiqPffKZiXhxcJuNrqK2js5Y9eWvVm0PAZrwdYzXWABvT5ANABZAiA0AztB8KKMcERt0A+C0uiJiU4qF5SZGDkfELlsEcHpLPvihhq7/xbu+EtNPD9e1hg/e9YfRvr5nUR+zbUV7XHrfzXHFg19yk9ZAz70PCLIBqTCFDaBxdcVckK1fKwDgzAixAcAZyGdKuYg4HHOfoALgnRXVBrA4Zl+erOl6513S0/A9G/u3n4vZ6am6rd/W0Rm92764aI+3/NZrY813vxkf2HKHJ0QNCbIBiRj02gqgoXVFxE5BNgA4M+955ZVXdAEA3kE+U8pHxJ75F5wAnJlPlke3DqVY2L5lVw2FiQFAg7j0vptrHl7at+yqhu/bxXfeEJfdUVrUx5ydnooTo/tf+/rkC8/HyRfGf/H1+Avxv59/8bWvjz968JzWW7JmWfT+x3uj4+r1ngh19Nxtt8Tk7qc0AqiHyYhYmZsYOZZaYfNT2J6zRQBn5YHlO/YPaAMAnN77tAAATi+fKfVHxE6dADhrxYgYSrg2ITaAJvbTL3wjuq/7J28JgL35qNHj3/7F1383NRUz+//2ta9nj03HzPB4Xeq/+M4b4pLfviPaOjptZp196IvbYnTfDXHymQnNAGptMMUA2zwhDICzd3ulkO1evmN/v1YAwNsziQ0ATiOfKQ1ExDadAFgw09gAzlE9JrE987F8UwR22la0R0TE7NGZhqq5d8fd0bnhE27+hEw/PRzPXnerRgC1lPIUtu6IOBxOLABYqO9HRH75jv3HtAIA3ui9WgAAb5XPlIZCgA3gXBUTrm3I9gCN4OT4CzVfc8kVK5qid7NHZxoqwNa+vieu/MsvCbAlqOPq9dG1+RqNAGop9SlsAmwAC7cuIsrzoWAA4HWE2ADgdfKZUvd8gM10HoBz1zt/LHNychMj5YjYa4uA1P3v51/UhBbQvr4nVv35w3H+qrWakajLtxY1AaiVyYgYTLGw+cCFo0QBzt26iDhcKWRzWgEAv/A+LQCAOflMqTsiyvMvIAFYHP2R7tSzYkQ8YYuAVnPqyHic/PHzr309c3B/zE5Nvfb1yeeOalINvRpga+vorOo6U3sfixf/+D/H+69aFV3/+OMmvp2l8y7pieW3XhuVh/zVAag6U9gAWkNXzE1kyy/fsX+fdgBAxHteeeUVXQCg5eUzpZURsScE2ACq4dry6NZyioXtW3ZVOSI22CIgVUs3ro5VX/7qG/5sdnoqTozu/8XXL0/GzA8OvPb1301Nxcz+v33t65PPHY2Tz0xoZoJqEWCbnZ6KH9/3e28bvlq6cXVcsP4j0f4ra6M9k43zLumxKe/gxKEDcfCjmzUCqLYrchMjh1Mran4K2+EQYgOohk8u37F/SBsAaHVCbAC0vHymlIu5CWzehAOojr3l0a35FAvbt+yqfJjGBiSsbUV7tF/TG8cfPagZTaZWAbZDv3VTzAyPn/H/s3Tj6mjruiDevzYTbZ2d0b46GxERSz74ISG3iHjmY3mhUKCaduUmRvpTLKxSyBYj4m5bBFA1gmwAtDwhNgBamgAbQM2YxgYA89pWtMfq8l9UNRR24tCB+GH/bVUJXL0arnzVBes/8to/t//K2mi7YO7lVVtnV5y/am1T7d0L92+Nn37hG25ioFqSnMIWEVEpZA9HRK8tAqiqB5bv2D+gDQC0KiE2AFpWPlPqj4idOgFQEylPY9sUEV+zRQDUypWPPxQdV6+v2uOfOHQgnv2NW2L26ExS17104+rX/rk9+8vxvs7OWHJZTyy57ENxfiZb1al0i2X66eF49rpb3cRANaQ8ha0/vIcGULOfB8t37O/XBgBakRAbAC1JgA2gLlKexnY4TBUAoAYuvvOGuOyOUtUefyFHiKbi1Qlv7dlfjgv+wT+Kjo98LMlg275lV7mRgWowhQ2AV309IvqX79h/TCsAaCXv1QIAWk0+UxoMATaAekj5OISi7QGg2pasWRaX/PYdVV3juS3/qiEDbBERs0dn4vijB+OnX/hG/PCf3hn7ez4Wz912S7z0yMMxOz2VTJ2vnygHsEh2JRxg6w8BNoBauzEiypVCtlsrAGglQmwAtJR8pjQUEbfrBEBd3JjPlFamWFhuYmQoIsZsEQDVdOlnClWdLPaz3dvj+KMHm6pnk7ufirG+z8czv/rr8ZPt9ycRZmvrusDNDCy2otoAeJN1IcgGQIsRYgOgJeQzpe75AFufbgDUVVFtALSiJWuWxYXX31S1x5+dnooX/6B5B07PHp2JF+/6Sox+/IaYfnq4rrW8f23GDQ0spr2msAFwGusi4nClkM1pBQCtQIgNgKaXz5S6I6IcAmwAKegzjQ2AVnTpZwpVffwf3/d7MXt0pun7ePKZiXj2ulvjpUcedlMBzaKoNgDeQVfMTWQTZAOg6QmxAdDUXhdgW6cbAMkoqg2AVtK2or3qU9iO/be/aamejvV9Pqb2PlaXtdt/Za2bGlgse3MTI+UUC6sUsvkwhQ0gFa8G2fJaAUAzE2IDoGnlM6VcCLABpCj1aWyTtgiAxbTsX/56VR9/6luPtsQUtjcbK9wTs9NTNV+37YIuNzWwWIpqA+AMdUXEE/NHPQNAUxJiA6ApCbABJK+YcG2DtgeAxdR93T+p6uMf+6vHW7Kvs0dn4mdf3u4GAxpV6lPYNtgigCTtFGQDoFkJsQHQdF4XYPPxeIB09c0f+ZyiwTCNDYBF0raiPTquXl/VNY4/fqBl+1v5ymNuMqBRFdUGwALtrBSyvlcD0HSE2ABoKvlMaVMIsAE0ioEUi8pNjBwL09gAWCTt1/RW9fFnp6da8ijRV518ZiJOHRmv6ZozB/e7sYFz9X1T2AA4R3dXCtkhbQCgmQixAdA08plSf0R8LQTYABrFgGlsADS7C9Z/pKqPf2JUoOrkj5+v6XqzU1NubGAxXm+kqmh7ABpGnyAbAM1EiA2ApjAfYNupEwANpStMYwOgybV1dmoCAK83lpsYGUqxsEohmwtT2AAaTV+lkB2qFLLdWgFAoxNiA6Dh5TOlgRBgA2hUprEB0NTaV2c1ocn8/MCoJgDnopjy6zPbA9CQ+iKiLMgGQKMTYgOgoeUzpaGI2KYTAA0r9Wlse2wRACk7PyMkV2snx45oArBQKU9hWxlzIQgAGtO6EGQDoMEJsQHQsOYDbN5cA2h8KU9jK9oeAFLW1tEZS9Ysa+kedFy9vqbrzQyPu/GAZnx94bUPQOMTZAOgoQmxAdCQBNgAmkpXRPSnWFhuYuRwROyyRQCk7IIN61r22tvX99R0vemnh91wwEKZwgZALayLiH2VQjanFQA0GiE2ABpKPlPqzmdKe8IbawDNZiDh2oq2B4CUXfzJf92y177i39xc0/VmDu53wwELNeg1DwA10htzE9kE2QBoKEJsADSM+aPmyhFxo24ANJ3efKbUn2JhprEBkLrzV62NpRtXt9x1t61oj85f21jTNY/992+54YCFmIyIoRQLM4UNoGl1hSAbAA1GiA2AhvC6ANs63QBoWkW1AdBsajW5q/eP/n3L9fbS3/9ktHV01my92empOP7oQTc1sBCDuYmRY17rAFBjgmwANBQhNgCSJ8AG0DJMYwOg6cxOTdVknfMu6YnLH/xUy/R16cbVcdHmLTVdc+pbj7qhgYWYjESPEq0Ust0RsckWATS1V4Ns/VoBQOqE2ABIWj5TWhkCbACtpJhwbUO2B4Cz9fLwd2q21kWbt8TyW69t+p62rWiPK7b/ac3XPfpfvuKGBhYi5SlsAzEXbgCguXVFxE5BNgBSJ8QGQLLymVIuIvaFABtAK0l5Gls5IvbaIgDOxsxTYzVdr+feB5o6yNa2oj2u/Msv1fQY0YiI6aeHY2Z43A0NnK3Up7AN2CKAliLIBkDShNgASNJ8gK0cPg0K0IpS/kVK0fYAcDZmj87EiUMHarpmz70PNOXRoq8G2M5ftbbmax/9sz9zMwMLYQobAKkRZAMgWUJsACRHgA2g5a3LZ0r5FAszjQ2AhTj+7SdrvuZFm7fE6m/vjiVrljVFD5duXB1rvvvNugTYpp8ejsndT7mRgYUYSrEoU9gAWp4gGwBJEmIDICkCbADMK6oNgGZx9E/+vC7rnr9qbax5shyX3ndztK1ob8jeta1oj0vvuzlWffmrNT9C9FUvbnvATQwsxK7cxMjhRGszhQ2AnZVCtqgNAKREiA2AZAiwAfA6G0xjA6BZnHxmIqafHq7b+h/Yckes+e43Gy7MtvzWa2N1+S/iA1vuqFsNU3sfi+OPHnQTAwtRTLg2U9gAiIi4u1LIDmkDAKkQYgMgCflMaVMIsAHwRsWEaxu0PQCcjXpP82rr6HwtzNa767PRvr4n2V4tv/XaWP3t3dFz7wNx3iX1q3N2eirGCve4eYGFSHYK2/zxcd5/A+BVfYJsAKTiPa+88oouAFBX+UypPyJ26gQAb+Pa8ujWcoqF7Vt21eGI6LVFAJypKx9/KDquXp9MPaeOjMfktx6NY//9W3WfNrZkzbJYfvMnYtmmm+oaXHu95267JSZ3P+XGBRbiioRDbF7HAPB2di3fsb9fGwCoJyE2AOpKgA2Ad7G3PLo1n2Jh+5Zd5WcYAGdl6cbVserLX02yttnpqZj+zpMx84MD8fLwd2oSalu6cXV0/5Nfi6Uf/Vicv2ptUv146ZGHY6zv825aYCF25SZG+lMsbH4Km9cwAJz2Z5ggGwD1JMQGQN0IsAFwhq4oj249nGJhprEBcLYuf/BTcdHmLQ1R66kj43Hyx8/H8W8Px99NTcXM/r+NiDjrgFv7+p5o6+6I9uwvxy9dfnm0r84mNZHuzU4cOhAHP7rZzQos+PWLKWwANDBBNgDqRogNgLoQYAPgLOwqj27tT7Ew09gAOFttK9rjyr/8UnKTxxbqxKEDMTs1+ZY/Pz+TjbaOzoa7nlNHxuNg/jdj9uiMmxVYiL25iZF8ioWZwgbAWRBkA6AuhNgAqDkBNgAWwDQ2AJpG+/qeWPXnDzdkyKuZzU5PxaHfuilmhsc1A1ioa3MTI+UUCzOFDYCzJMgGQM29VwsAqCUBNgAWqKg2AJrFzPB4PP+ZT2tEQgTYgEWwN+EA26YQYAPg7PRVCtlypZDt1goAakWIDYCaEWAD4Bz05TOllSkWlpsYGYqISVsEwNmY3P1UjH/udo1IgAAbsEiKCdc2YHsAWIANESHIBkDNCLEBUBMCbAAsgmLCtQ3aHgDOVuWhJwTZ6uzEoQPxzK/+ugAbcK5SnsKWj7kQAgAsxLoQZAOgRoTYAKg6ATYAFkmy09hiLsRmGhsAZ+3VINvs9JRm1NjU3sfi2d+4JWaPzmgGcK6KagOgiQmyAVATQmwAVJUAGwCLrD/FonITI8fCNDYAFqjy0BNx6LduilNHTAOrlRfu3xo//Kd3CrABi+H7prAB0AIE2QCoOiE2AKomnykNhQAbAItrIJ8ppfpmmWlsACzYzPB4HMz/ZkztfUwzqujUkfEYvX5j/PQL39AMYDFfB6SqaHsAWESCbABUlRAbAFUxH2Dr0wkAFllXRAykWJhpbACcq9mjM/HDf3pnPHfbLY4XrYKfbL8/DuZ/M2aGTbwDFs1YbmJkKMXCTGEDoEoE2QCoGiE2ABadABsAVWYaGwBNbXL3U/HMr/56vPTIw5qxCKafHo7R6zfGi3d9xfGhwGIrJlxbv+0BoEoE2QCoCiE2ABaVABsANZD6NLY9tgiAczV7dCbG+j4fo9dvjOmnhzVkAU4dGY/nbrslnr3uVtPXgGpIeQrbyvD+HADVJcgGwKITYgNg0QiwAVBDKU9jK9oeABbLzPB4PHvdrXHoX/xzYbYzdOrIeIx/7vb4X2s2xuTupzQEaMW/93tNAkAtCLIBsKje88orr+gCAOdMgA2AOvh0eXTrYIqF7Vt2lZ+LAFRF+/qeWPFvbo4Lr79JM95k+unhOPpnfya4BtTCWG5iZGWKhc1PYXvOFgFQQ9+PiPzyHfuPaQUA58IkNgDOmQAbAHUykHBtRdsDQDXMDI/HWN/nY//qfxAv3L81Thw60NL9mJ2eipceeThGr98Yz153qwAbUCuDCdfmtQgAtWYiGwCLwiQ2AM6JABsAdfbJ8ujWoRQLM40NgFpZsmZZdN3wsVj+z34rzl+1tiWueWrvY1H5f/6b0BpQD5MRsTI3MZLctBlT2ACoMxPZADgnQmwALFg+UxqMiNt1AoA6GiuPbl2ZYmH7ll21MvwCCYAaW7JmWVywYV10/eOPR8dHPhZtHZ1NcV2njozH8aeejGN/9bjgGlBv9+QmRoopFlYpZIfCB2kAqC9BNgAWTIgNgAUXNiSSAAAgAElEQVTJZ0r9EbFTJwBIgGlsAHAa7et7Yun/8ffj/b/y92LpNR+L8y7paYi6Tx0Zj5nR/fHy//zrOP4/vhczw+M2E0hBylPYuiPicER02SYA6kyQDYAFeZ8WAHC2BNgASEwxIoYSrW0ohNgAqKOZ4fH5ANg3XvuzpRtXR3v2l+OXLr882ldnY8kHP1TXcNuJQwfi5AvPx8wPDsTLw9+JmafGYvbojM0DUjSYYoBt3kAIsAGQhnURUa4UsoJsAJwVk9gAOCsCbAAkKuVpbOWI2GCLAEhd+/qeaOvuiF/60KWxpOeyiIhYcllPLLnsQ6/9N2cTeJt+evi1f559eTJmfnAgIiJ+fmA0ZidfjpPPHY2Tz0xoPNAoTGEDgLNjIhsAZ8UkNgDOmAAbAAkbiHSnsRUj4glbBEDqXj2y83gc1AyAtzKFDQDOjolsAJyV92oBAGdCgA2AxK3LZ0r5FAvLTYyUI2KvLQIAgIY2lGJR81PYBmwPAIl6NcjWrRUAvBshNgDelQAbAA2iqDYAAKAKduUmRg4nWpspbACkbl1EDGoDAO9GiA2AdyTABkAD2WAaGwAAUAXFhGszhQ2ARtBXKWSHtAGAdyLEBsBpCbAB0ICKCdfmE6cAANB4kp3CVilk+8MUNgAahyAbAO9IiA2AtyXABkCDSnka256IGLNFAADQUIpqA4BFI8gGwGkJsQHwFgJsADS4otoAAIBFkPoUtl5bBEADEmQD4G0JsQHwBvlMaVMIsAHQ2DbkM6WVKRaWmxgZCtPYAACgURTVBgBVIcgGwFsIsQHwmnymlIsILxoAaAZFtQEAAOdgrylsAFBVgmwAvIEQGwAR8VqArRwRXboBQBPoM40NAAA4B0W1AUDVCbIB8BohNgAE2ABoVkW1AQAAC7A3NzFSTrGwSiG7KUxhA6C59M1PGQWgxQmxAbQ4ATYAmljq09gmbREAACSpmHBtA7YHgCa0U5ANACE2gBYmwAZACygmXNug7QEAgOSkPIUtHxEbbBEATUqQDaDFCbEBtKj5yTTlEGADoLklO40t5kJsprEBAEBaimoDgLoRZANoYUJsAC0onyl1R8SeEGADoDX0p1hUbmLkWJjGBgAAKfm+KWwAUHeCbAAtSogNoMXMB9jKEbFONwBoEQPzP/9SZBobAACk9ffzVBVtDwAtZGelkM1pA0BrEWIDaCECbAC0qK6IGEixMNPYAAAgGWO5iZGhFAszhQ2AFlUWZANoLUJsAC1CgA2AFmcaGwAA8E6KCdfWb3sAaEFdIcgG0FKE2ABax54QYAOgdaU+jW2PLQIAgLpJeQrbyojos0UAtChBNoAWIsQG0ALymdJQOHIAAFKexla0PQAA4O/jXisAwFu8GmRbqRUAzU2IDaDJzQfYfFoTAObe8OpPsbDcxMjhiNhliwAAoOZMYQOA9HVFxJ5KIdutFQDNS4gNoIkJsAHAWwwkXFvR9gAAgL+He40AAG9rXcxNZBNkA2hSQmwATSqfKQ2EABsAvFlvPlPqT7Ew09gAAKDmJiNiT4qFmcIGAG9LkA2giQmxATSh+V/Ob9MJAHhbRbUBAAARMZibGDnmtQEANJR1kWgIHYBzI8QG0GTmA2w7dQIATss0NgAAYDIiBlMsbH66zCZbBACntaFSyA5pA0BzEWIDaCL5TGlTCLABwJkoJlzbkO0BAICqS3kK20BEdNkiAHhHfYJsAM1FiA2gSeQzpVz4pTcAnKmUp7GVI2KvLQIAgKpJfQrbgC0CgDMiyAbQRITYAJrAfICtHD6hCQBnI+VfDBVtDwAAVI0pbADQPPoqhWy/NgA0vve88sorugDQwATYAOCcXFse3VpOsbB9y64qR8QGWwQAAIvuwhRDbPNT2A6H9/kAYCE+uXzH/iFtAGhcJrEBNLB8ptQdc0eIemMLABamqDYAAGgpu0xhA4CmtNNENoDGJsQG0KDmA2zliFinGwCwYBvymVI+xcJyEyPliNhriwAAYFEVE65twPYAwDkZrBSyOW0AaExCbAANSIANABZVUW0AANASduUmRg6nWNj85BhT2ADg3HRFRFmQDaAxCbEBNKbBEGADgMWS+jS2MVsEAACLoqg2AGh6gmwADUqIDaDB5DOloYjo0wkAWFRFtQEAQFNLfQpbry0CgEXTFRFDlUK2WysAGocQG0ADyWdKgyHABgDVsCGfKa1MsbDcxMhQmMYGAADnqqg2AGgp62JuIpsgG0CDEGIDaBD5TKk/Im7XCQComqLaAACgKX3dFDYAaEnrImKPNgA0BiE2gAYwH2DbqRMAUFV9prEBAEBTGky4tqLtAYCq2lApZIe0ASB9QmwAictnSrkQYAOAWimqDQAAmsre3MRIOcXCKoXspjCFDQBqoU+QDSB9QmwACZsPsJV1AgBqxjQ2AABoLsWEaxuwPQBQM32VQtbPXoCECbEBJGr+F+jliOjSDQCoqWLCtQ3ZHgAAOGMpT2HLR8QGWwQANbWtUsj2awNAmoTYABKUz5S6I2JPCLABQD0kO40tIgYjYtIWAQDAGSmqDQB4k53zYXIAEiPEBpCY+QBbOSLW6QYA1E1/ikXlJkaOxVyQDQAAeGemsAEAp7OnUsjmtAEgLUJsAOkZCgE2AKi3gflgeYpMYwMAgHc3lHBtRdsDAHXVFRFlQTaAtAixASQknykNRcSNOgEAddcVEQMpFmYaGwAAvKux3MTIUIqFmcIGAMnoioihSiHbrRUAaRBiA0hEPlMqRkSfTgBAMkxjAwCAxlRMuLZ+2wMAyVgXcxPZBNkAEiDEBpCAfKbUHxF36wQAJCX1aWxDtggAAN4i5SlsK8OHWAEgNevC+2wASRBiA6izfKaUj4idOgEASUp9GhsAAPBGRbUBAGfpxkohO6QNAPUlxAZQR/lMKRcRe3QCAJLVFYke95ObGDkcEbtsEQAAvMYUNgBgofoqheyANgDUjxAbQJ3kM6WVEVGOuV+OAwDpSvnNq6LtAQCAhvj7sb+7A0D6tlUK2X5tAKgPITaAOpg/lmxPCLABQCPozWdK/SkWZhobAAC8ZjISPfHAFDYAaCg7K4VsThsAak+IDaA+yhGxThsAoGEU1QYAAEkbzE2MHPN3dgBgEZQF2QBqT4gNoMbymdJQCLABQKMxjQ0AANI1GRGDKRZWKWS7I2KTLQKAhtIVEXvmf44DUCNCbAA1lM+UBsPRAQDQqIoJ1zZoewAAaGEpT2EbiLlfhAMAjaU35iayCbIB1IgQG0CNzE9vuV0nAKBhpTyNbV9E7LVFAAC0oNSnsA3YIgBoWOsiYkgbAGpDiA2gBvKZUj4iduoEADS8lH8BVbQ9AAC0IFPYAIBqurFSyA5pA0D1CbEBVFk+U8pFxB6dAICmsG4+nJ6c3MRIOUxjAwCg9ZjCBgBUW1+lkPVzHaDKhNgAqiifKXVHRDl84hIAmklRbQAAkIRdprABADWyrVLI9msDQPUIsQFUiQAbADStDaaxAQBAEooJ12ZaCwA0n8FKIZvTBoDqEGIDqJ6hiFinDQDQlIpqAwCAutqVmxg5nGJh81NafLAVAJpPV0SUK4XsSq0AWHxCbABVkM+UhiLiRp0AgKaV+jS2MVsEAECTK6oNAKiDrojYUylku7UCYHEJsQEssnym1B8RfToBAE2vqDYAAKiL1Kew9doiAGhq6yJijzYALC4hNoBFlM+UNkXETp0AgJawIZ8p5VIsLDcxMhSmsQEA0LyKagMA6mxDpZAd0gaAxSPEBrBI5n+J7S+rANBaBhKurWh7AABoQl83hQ0ASERfpZAd0AaAxSHEBrAI8plSd8yNDe7SDQBoKX35TGllioWZxgYAQJMaTLi2ou0BgJazbT7IDsA5EmIDOEfzAbZy+JQlALSqotoAAKAm9uYmRsopFlYpZDeF9wcBoFUNVgrZnDYAnBshNoBF+ItpRKzTBgBoWaaxAQBAbRQTrs1RYgDQuroiolwpZLu1AmDhhNgAzkE+UypGRJ9OAEDLKyZc25DtAf5/9u49Psr6zv/+O5NMkkkmk8NwMCBJQMnE6MAoVNZVy6Cl/lxFI/SwRioB1s6tskuUh61abIY61W19UGML7S911eDyo/ejuyAVe3e73Cth9be9rSeatCngr5iAGEEScj6a5P6D4HpADDCH7zXzej4e/aMI1/WZ9/dKcmXmc32+AADEAZOnsPklzWeJAABIaDSyAcA5ookNAM6S3xOqkFRFEgAAQAZPY9OJqbEdLBEAAAAsLkhtAADAcLPFA6UAcNZoYgOAs+D3hHySniEJAADwEUZuH+Rrq2/XiUY2AAAAwKqYwgYAAKzi5taAl/fiAOAs0MQGAGdobMpKHUkAAIBPqPB7QqZuF8A0NgAAAFhZrcG1BVkeAADwCatbA94KYgCAM0MTGwCcgbEPprfrxL72AAAAH5UtprEBAAAA4dbsa6uvNbEwprABAIDTeKY14PURAwCMH01sAHBmanViP3sAAIBTqWQaGwAAABBWQYNrq2B5AADAadS1BrxFxAAA40MTGwCMk98TqpZ0M0kAAIDTMH0aWy1LBAAAAAsxeQpbkaRlLBEAADiNbEnbWwPeHKIAgM9HExsAjIPfE6qQtJokAADAOJg+jQ0AAACwiiC1AQAAi5stHiwFgHGhiQ0APoffE/JJeoYkAADAOJk8ja1J0iaWCAAAABbAFDYAABAvbm4NeHm4FAA+B01sAHAafk+oSFIdScAEl8+bocKCPIIAAGuoMLi2IMsDAAAACwhSGwAAiCOrWwPeCmIAgM9GExsAfIaxbcC268Q0FSCmCgvy9MNny7Vx60oa2QDAIt+6x7YjNw7T2AAAAGABHTrxvpxxmMIGAADOwTOtAa+PGADg1GhiA4DPVqsT+9QDMVVYkKeNW1dKkpyuNG3aeZcWLCwlGAAwX5DaAAAAgLNS7Wurb+deGgAAxKG61oA3hxgA4NNoYgOAU/B7QkFJN5MEYm1CXqY2bl0ppyvtY39etWExjWwAYD6msQEAAABnrkNStYmFjX3gzBQ2AABwLrJFIxsAnBJNbADwCWMfNleRBGItI92uR36+9FMNbCdVbVisW5dfRVAAYLagwbVVszwAAAAw8T7V4ClslSwPAAAIg9nivTkA+JSk0dFRUgCAMX5PyCepTieeggBiJiPdrurNK1Tsnfi5f3fHlnqtX/c8oQGAuZbX7Vtba2Jhe/Jm1UmazxIBAADAEB2SikxsYhubltIk3jcEAADhs85d0xAkBgA4gUlsADDG7wnlSNou3oiCAR7eWD6uBjZJWlQ+S2uqbiI0ADBXkNoAAACAcTF9ChvvGwIAgHCqag14y4gBAE6giQ0A/ludpEJiQKytqbpJc66adkb/ZlH5LP38XwPKSLcTIACYp9DvCflNLMzXVl8naTdLBAAAAEMYua3W2BQ2thIFAACRUNsa8PqIAQBoYgMASZLfE6rVif3ngZhaU3WTFpXPOqt/W+ydqOrNK2hkAwAzBakNAAAAOK1NTGEDAAAJKFsnGtlyiAJAoqOJDUDC83tCFZKWkQRibdGSOWfdwHbSyUa2woI8AgUAs8xnGhsAAABwWkETi2IKGwAAiILZkrYTA4BERxMbgITm94R8kp4hCcTagoWlWvPI9WE5VrF3ojZuXUkjGwCYJ0htAAAAwClt8rXVNxlaW5mYwgYAACJvfmvAW00MABIZTWwAEpbfE8qRVEcSiLUFC0tVtWFxWI/pdKVp49aVKi3NJ2AAMIfp09iaWSIAAADESJDaAAAAtLo14K0gBgCJiiY2AAnpIw1sPEWJmCosyNOaR26IyLGdrjT99LmVWrCwlKABwBxBagMAAAA+xtgpbGMfIheyRAAAIIqqWwNeHzEASEQ0sQFI2BtAndhfHoiZwoI8bdy6Uk5XWkTPU7VhMY1sAGCO+WPbmRvH11ZfK6axAQAAIPqC1AYAAPChbEnbWwPeHKIAkGhoYgOQcPyeUKWkZSSBWMpIt0elge2kqg2L9c3KhQQPAGaoNLi2IMsDAACAKPoVU9gAAAA+pVDSdmIAkGhoYgOQUPyekF/S4ySBWMpIt6t684qoNbCdVH7nPK2puokFAIDYW+b3hIpMLIxpbAAAAIiyaoNrC7I8AAAghua3BrzVxAAgkdDEBiBhjH1YzFMLiKmTDWzF3okxOf+i8llaU3WTMtLtLAYAxFaQ2gAAAJDgdvva6utMLIwpbAAAwBCrx+5LACAh0MQGICH4PaEcnWhgyyYNxNK3HrklZg1sJy0qn6XqzStoZAOA2GIaGwAAABJd0ODaKlgeAABgiOrWgNdHDAASAU1sABLmBk/SbGJALK2pukn+G4qNqKXYO5FGNgCIvaDBtdWyPAAAAIggk6ew+SXNZ4kAAIAhsiVtbw14c4gCQLyjiQ1A3PN7QhWSlpEEYmlN1U1aVD7LqJqKvRP1TzvuUmFBHgsEALFh7DQ2nXgAoIMlAgAAQIQEqQ0AAGDcCnVixykAiGs0sQGIa35PyCfpGZJALC1YWGpcA9tJUwqytHHrShrZACB2Kk0sytdW364TjWwAAABAuDGFDQAA4MzNbw14eb8OQFyjiQ1A3PJ7QjmS6kgCsXT5vBmq2rDY6BqdrjRt3LpSpaX5LBgARF/F2D2LiZjGBgAAgEioNbi2IMsDAAAMtro14K0gBgDxiiY2APGsTif2iQdi5sBbR7S/4X3j63S60vTT51ZqwcJSFg0AoitbTGMDAABA4mj2tdXXmlgYU9gAAIBFVLcGvD5iABCPaGIDEJf8nlC1pNkkgVg71tajyqVPW6KRTZKqNiymkQ0Aoq+SaWwAAABIEEGT78tZHgAAYAHZkmpbA94cogAQb2hiAxB3/J5QhaTVJAFT9PYPqXLp06r79X5L1Fu1YbHWVN3EwgFA9Jg+ja2WJQIAAEAYmDyFrUjSzSwRAACwiNniPTsAcYgmNgBxxe8J+cS2VzBQb/+Qgvf+Uju21Fui3kXls2hkA4DoMn0aGwAAAHCugtQGAAAQNje3BrzcwwCIKzSxAYgbYx/8bteJaSaAkdave95SjWzBH31NGel2Fg4AIs/kaWxNkjaxRAAAADgHpk9hW8YSAQAAC6pqDXj9xAAgXtDEBiCe1EoqJAaYbv2657Vu1TZL1Oq/oVjVm1fQyAYA0VFhcG1BlgcAAABxej/JvS4AALCy7WNN+QBgeTSxAYgLfk8oKOlmkoBV7NrZaJlGtmLvRBrZACA6Cv2eUIWJhTGNDQAAAOegQyd2TzAOU9gAAEAcyDb1XgsAzhRNbAAsz+8J+SVVkQSsZtfORn3r9i3q7hwwvtZi70T98qVKFRbksXAAEFlBagMAAECcqfa11bdzjwsAABAxs1sD3lpiAGB1NLEBsDS/J1Qkni6Ahf3+lQO6e8lTlmhkc7rStHHrShrZACCymMYGAACAeNIhqdrEwloD3hwxhQ0AAMSPZa0BbwUxALAymtgAWN12nRiTC1hW88E2yzWyXT5vBgsHAJETNLi2apYHAAAAZ3L/aPAUtkqWBwAAxNu9V2vA6yMGAFZFExsAy/J7QtWSZpME4kHzwTZ97epq7W943/hana40/fDZci1YWMrCAUBkmDyNbY+k3SwRAAAAxsH0KWw0sQEAgHiTLal27F4HACyHJjYAljT2we5qkkA86e0fUuXSpy3RyCZJVRsWa9GSOSwcAERGkNoAAABgcaZPYWN3BwAAEI9mS6olBgBWlDQ6OkoKACzF7wn5JNWJN5oQpzLS7frWI7fIf0OxJerdsaVe69c9z8IBQPgtqNu3ts7EwvbkzaqTNJ8lAgAAwGnkmtjENjaZpEm8twgAAOLbPe6ahmpiAGAlTGIDYCl+TyhHJ54e4E0mxK3e/iEF7/2ldmypt0S9i8pnaU3VTSwcAIRfkNoAAABgUZuYwgYAABBTj7cGvD5iAGAlNLEBsJpqnRiDC8S99eue15afvWKJWheVz9L6p5YpI93OwgFA+Mz3e0J+EwvztdXXSdrNEgEAAOAzBE0samwKWyXLAwAAEkTd2P0PAFgCTWwALMPvCVVKWkYSSCQ/r96pdau2WaLWOVdNU/XmFTSyAUB4BakNAAAAFrPJ11bfZGhtZWIKGwAASBzZkrYTAwCroIkNgCX4PSGfpMdJAolo185GyzSyFXsnqnrzCk3Iy2ThACA8TJ/G1swSAQAA4BOC1AYAAGCM+a0BL/dAACyBJjYAxvN7QjniKQEkuF07G3XXLU+pu3PA+FqLvRNV+9u7VFiQx8IBQHgEqQ0AAAAWYewUttaAt0JSIUsEAAASUFVrwOsnBgCmo4kNgBXUijeYADU2tujuJdZoZHO60rRx60oa2QAgPOaPTaU1jq+tvlZMYwMAAMB/C1IbAACAkba3Brw5xADAZDSxATCa3xOqlHQzSQAnNB9s091LntK7B7uMr/VkI9uChaUsHACcu0qDawuyPAAAABBT2AAAAEyWLXa+AmA4mtgAGGts4sjjJAF8XPPBNv3dop9qf8P7xtfqdKWpasNiGtkA4Nwt83tCRSYWxjQ2AAAAjKk1uLYgywMAAKD5rQFvNTEAMBVNbACM5PeEcsTTAMBn6u0fUuXSpy3RyCZJVRsWa9GSOSwcAJybILUBAADAULt9bfV1JhbGFDYAAICPWd0a8JYRAwATJY2OjpICAOP4PaHtYhtR4HNlpNt157ev16LyWZaod8eWeq1f9zwLBwBnb3rdvrVNJha2J29Wk/hwEEAUOS5yf+rP7O6svtTJuUdP+fcLz09PSk7uP90xk+z2dHtW5uRovYbhgcHjwz29nZ/39/oPt6SMDAx+8Kl/39tv7286OuWTfz54qFPD3UNcJACiaYHBTWx1kuazRAAAAB/qkORz1zQ0EQUAk6QQAQDT+D2hStHABoxLb//Qh01hVmhkO1kjjWwAcNaCkioMra1WUhVLBGA8kp12pU5zffj/06ZNOJ6SlfFhM1fG9GkpSrJ92LRlz3ZNSkq2OcZxaIcs1FCbnJaam5yWmvt5fy81L+ez/+MXx3euwbb2j239/NHGuNGRkfTeve982Lw33DukweZOLlQA42XyFDa/aGADAAD4pGyd2BHLRxQATMIkNgBG8XtCPklvkgRw5r5ZuVDld86zRK37G95X5dKn1dvPdAgAOAtGTmPbkzcrR1KTTrwJBiDB2Cc5lOLOkPTxhrS0/Em2ZIdjRJKSMzNc42nYgnk+bIAbHUnpffvQKRvf+v7cSlBA4mIKGwAAgDU94a5pqCQGAKagiQ2AMfyeUI6kPWIbKuCsLVhYqqoNiy1RK41sAHDWnqjbt9bIN5f25M0KimlsQFxJLXQpOcP+sW06T27LGe2tN2ENH90i9eS0tw+6el0Dh47lSmx1CsSh3b62er+JhY1NYdvFEgEAAJzWAndNQx0xADABTWwAjOH3hLaLbUSBc/9tw2KNbN+/91/UfLCNhQOA8euQVFS3b227aYUxjQ2wlpMNaicnp9lzXTZ7bu4IzWmIhpPNbsN9fbaBlqMjH53sxlQ3wFJu8bXVbzexMKawAQAAjEuHpCJ3TUM7UQCINZrYABjB7wlVSnqcJIDwKCzI08atK+V0pRlfa3fngO5e8hSNbABwZtbV7VsbNLEwprEB5jjZpJZRcv6RJJutP2P6tBQl2T6wZ7smJSXbHCQE0w119RwZHRrqPznRre/t9wpH+gaZ5gaYo9nXVl9kYmFMYQMAADgju901DX5iABBrNLEBiDm/J+ST9CZJAOFFIxsAxDWmsQFQstOu1GmuD7f6TMufZEt2OEZoUkOiGGxrb9boSErv24c+3LL0g9ZeDR3tIxwgOpb72uprTSysNeBlxwcAAIAzs85d0xAkBgCxRBMbgJjye0I5kvZIKiQNIPwKC/L0nR99VcXeidb4DWnVNu3a2cjCAcA4v20aPI2tWtJqlgg4d5/VqJaal8PvUMBpDHX1HBkdHPiABjcgYkyewlYk6W2WCAAA4IwtcNc01BEDgFihiQ1ATPk9IZ6KBCIsI92uhzeWa85V0yxRL41sADBuJk9jKxIfHAJnxD7JoRR3hjJKzj+S6s4ZtOfmMlENiJDBtvbm4b4+20DL0ZGTW5T2/bmVYIAzY/IUtlpJy1giAACAM9Yhqchd09BOFABigSY2ADHj94QqJD1DEkB0rKm6SYvKZ1mi1pp/rNMvnnmZRQOAz2fyNLZa8eEh8CmphS7Z3ZlyTD+vOS1/ki3F5Uq1Z2VOJhkg9oYHBo8Pd3f39r596IPBI8cnDbV2OWhuA06JKWwAAADxa7e7psFPDABigSY2ADHh94R8kuokZZMGED0LFpaqasNiS9S6Y0u91q97nkUDgNNrrtu3tsjEwpjGhkT3yclqqZMm0awGWNRHm9v63n6vcKi1R4PNnQSDRMYUNgAAgPh2j7umoZoYAEQbTWwAos7vCeXoRAPbbNIAoq+wIE8bt66U05VmfK07ttTrZz/4jXr7h1g4APhsy+v2ra01sTCmsSFROC5yy+7O6ksvmNyWPjX/A7YBBRLDUFfPkcGjRwcHW9tTe/e+M3nwUKeGu/ndBXGvw9dWn2NiYUxhAwAACKtL3TUNe4gBQDTRxAYg6vyeULWk1SQBxM6EvEw98vOlKvZONL7W/Q3vq3Lp0zSyAcBnYxobECXJTrtSp7mYrgbgM31yatvgO+0aOtpHMIgn63xt9UETC2MKGwAAQFg1S/K5axraiQJAtNDEBiCq/J5QmaTnSAKIvYx0u+789vVaVD7L+FppZAOAz8U0NiDMPtqwlj71vMHUCW5nclpqLskAOFOjwyN9Q+3tbTS2IQ50SCrytdUb90Fma8CbI+k4SwQA8cUx/0Y5/ubv1fWzVRpqeotAgOj7lbumoYwYAEQLTWwAosbvCRVJ2iMpmzQAc9y6/CoF7vcbX+e7B7v0wMp/VvPBNhYNAD6NaWzAOaBhDUC00dgGizJ5CltQUhVLBADxI8i4nv0AACAASURBVGvpfUq9+nZJ0kjLXnU8tlwjPd0EA0TfcndNQy0xAIgGmtgARI3fE6qTNJ8kAPMsWFiqNY/cIKcrzeg6uzsHdPeSp2hkA4BTM3kaG/eBMIrjIrfSpk047ig4r5stQQGYYnR4pK//vSPH+g+/l9q7953Jg4c6NdzNNGoYw/QpbE3iwVkAiAu2TKey73tGtvySj/35B396UR0/Xk1AQGzuA/3umoY9RAEg0mhiAxAVfk8oKJ6GBIxWWJCnR5/6hqYUZBldZ3fngL61bLMaG1tYNAD4OJOnsfkl7WKJEAv2SQ6lnp+jzJKCw+lT8z9IzcspJBUAVjHU1XNk8OjRwb6D7zl797XkDjZ3EgpihSlsAIDI//5WNFNZ92xSUvqp36Me+O0GdW+rISgg+v7grmnwEQOASKOJDUDE+T0hv/jQErCEjHS7qjevULF3ovG1rlu1Tbt2NrJoAPBxC+r2ra0zsTCmsSFaUgtdyvDkH88sLupmW1AA8Wiwte1wz1+aU5jWhihiChsAIOIyri+Xo+yBz/17XU/crsHGNwkMiL4n3DUNlcQAIJJoYgMQUX5PKEfSHklMOwAsZE3VTVpUPsv4OmlkA4BP2V23b63fxMKYxoZISHbalTrNpYyS849kXlD4Qao7byqpAEg0Q109R/qaDn7Qf/BIXt/+I46ho32EgnDb5GurrzCxMKawAYD12TKdcpZ/W/a5ZeP6+6P9Xer4/mINH32P8IDoW+CuaagjBgCRQhMbgIjye0LbJd1MEoAFfxNZWKqqDYuNr3PLz17Rz6t3smAA8JFv4UxjQ7xKdtqVXjxBmSUFhx1FBSn2rMzJpAIAHzc8MHi8/53D3WxBijCa7murbzKtKKawAUAc/I436Ty57vqJbPklZ/TvRlr2quOx5Rrp6SZEILo6JBW5axraiQJAJKQQAYBI8XtCFaKBDbCMCXmZmnSeSxdcNEX50/Lk8U5Rd+eAnK40o+suv3OesrIdWr/ueRYRAE4ISvIbXBvT2DBu9kkOOYon92WWFB5LnTQp9SNNa0xcA4DPkJyWmpt5wfTczAumSwuk0eGRvv73jhzr2d9EUxvOxiYTG9jGlIkGNgCwrNTSS+UMbFRSetYZ/1tbfomc5d9W55MPESQQXdmStsvc9x4BWByT2ABEhN8TKtKJbUR5IwkwUEa6XZfMnqYLSqdo7lUXyDNrkvHNap9nx5Z6/ewHv1Fv/xALDABmT2PbI2k2S4RTSXbalemb2pdZUngs/fypzuS01FxSAYDwoqkNZ2i6qU1srQFvk6RClggArMe5OKC061ad83F6tzygvt0vECgQffe4axqqiQFAuNHEBiAi/J4QH04ChiksyNNfX1uqBTdcrGLvxLh8jfsb3lfl0qdpZAMAaXfdvrV+EwvbkzerQtIzLBEktgcFABOcbGrr2rNvQt/+I46ho32EgpM2+drqK0wsrDXg5Z4SACzIlulU1srvK+Xia8J2zM5HF2uo6S3CBaLvUndNwx5iABBONLEBCDu/JxSUVEUSQOxNyMvUwpsv1aLyOZpSkJUQr5lGNgD40KV1+9Ya+UbSnrxZTWJqRsJyXOSWc/YFxzJmFA7TtAYA5hkeGDze/87h7p69zRN69hx2DHfzu1UCYwobACBs7EUz5ax4RLb8krAed7S/S+0PflkjPd2EDETXHyT53TUN7UQBIFxoYgMQVn5PyC9pF0kAsVVamq+v/d3V8t9QnJCvv7tzQHcveUrNB9u4GAAksk11+9ZWmFgY09gSS2qhSxme/OOuWZ7eVHfeVBIBAGsZ6uo50td08IOevQen9rzRQiAJdC/JFDYAQLg45t8ox+IHlZQemQethw+8qvYfrCBoIPqecNc0VBIDgHChiQ1A2Pg9oRxJe8RTkEDMlJbma+WaL2vOVdMSPgsa2QBAkjS9bt/aJhMLYxpb/Ep22pXpm9qXWVJ4LKOocEJSss1BKgAQPwZb2w531u/L6N3XkjvY3Ekg8WuBr62+zsTCmMIGANaStfQ+pV59e+TvUV56Vl2bHyNwIPpucdc0bCcGAOFAExuAsPF7Qtsl3UwSQPRNyMvUqrU3JOzktc/S3Tmg763aqt+/coAwACQqprEhKtgiFAAS08mtRzvf2D+tf/8xsfVo3Njta6v3m1gYU9gAwDpsmU65Vv1YyTO+ELVz9m55QH27XyB8ILo6JBWxrSiAcKCJDUBY+D2hCvEGEhATi5bMUeD+a+R0pRHGZ1i3apt27WwkCACJimlsCDv7JIccxZP7snyeY+nnTWbaGgBAkjTU2XWs4/U/JjOlzfJMnsJWJ2k+SwQAhv/OWDRTWfdsitj2oZ9ltL9LXY8v01DTWywCEF2/ctc0lBEDgHNFExuAc+b3hIp0YhvRbNIAoicj3a6HN5azdeg40cgGIIGZPI2tUtLjLJE1pBa6lHXZ9CPOkguT7a6sCSQCADgdprRZlslT2PySdrFEAGA2x/wblVH+aMzOP9KyVx2PLddITzeLAUTXPe6ahmpiAHAuaGIDcM78nlCdeAISiKrS0nz9cNNSpq+doR1b6rV+3fMEASARGTmNbU/erBxJTeJhCCMlO+1KL54g12XFhzKKCpm2BgA4J32HWw717G9y9uw5mDt0tI9AzMUUNgDAWbFlOuUs/7bsc2M/jOmDP72ojh+vZlGA6OqQ5HfXNOwhCgBniyY2AOfE7wkFJVWRBBA9CxaWqmrDYoI4SzSyAUhQJk9j437SIPZJDmX6Co5nFhd1O6bmM+4VABARQ109R3oPNCd3/G7vBLYdNQpT2AAAZyV50nly3fUT2fJLjKlp4Lcb1L2thsUBousP7poGHzEAOFs0sQE4a35PyCfpTZIAoueblQtVfuc8gjhHdb/erx8++Jx6+9nOBkDC6JBUVLdvbbtphTGNLfbYJhQAEEsf3Xa0540WAomtW3xt9dtNLIwpbABg8O+UpZfKGdiopPQs42rrfHSxhpreYpGA6FrnrmkIEgOAs0ETG4Cz4veEciTtkVRIGkB0rKm6SYvKZxFEmOxveF+VS5+mkQ1AIllXt29t0MTCmMYWfY6L3HLOvuCYs+TC5OS01FwSAQCYYHR4pK//vSPHuvbsm9Cz57BjuJvf16Ko2ddWX2RiYUxhAwBzORcHlHbdKiNrG3ptuzqffIhFAmJjgbumoY4YAJwpmtgAnBW/J1QtaTVJANFBA1tk7G94Xw9+c7OOtfUQBoBEwDS2BJd5Wb5clxUfyigqnJCUbHOQCADAdH2HWw7R0BY1y31t9bUmFtYa8G6XdDNLBADmsGU6lbXy+0q5+Boj66OBDYi5Zkk+d01DO1EAOBM0sQE4Y35PyC+efgSihga2yOruHNDdS55S88E2wgCQCJjGlmBoXAMAxIuhzq5jHa//Mblnz8HcoaN9BBJeJk9hK5L0NksEAOawF82Us+IR2fJLzLxnoIENMMUmd01DBTEAOBM0sQE4I2PbiDaJKRlAVCxYWKqqDYuNrrG7c0CvvdSsfQ3v6i+N7+pIS7uaD7apsCBPG7eulNOVZnzONLIBSCAmT2MrEh9QnrNkp12Zvql9WT7PMcfU/GkkAgCIRzS0hZ3JU9hqJS1jiQDADI75N8qx+EElpWeZeY9AAxtgmlvcNQ3biQHAeNHEBuCM+D0hxvcDUXL5vBn64bPlRtb2+suHVPf//FH1r7592sYvqzWyrX/w19q1s5GLD0C8M3kaW634kPKM0bgGAEhkNLSdM6awAQDGJWvpfUq9+nZz7wloYANM1CGpiG1FAYwXTWwAxs3vCVVIeoYkgMgzsfnr3YNd+sX/fFn/8et69fYPjfvfZaTbVb15hYq9Ey2R/bpV22hkAxDvOur2rc0xsTCmsZ2ZzMvylfPXsw7RuAYAwAk0tJ0VprABAE7LlumUa9WPlTzjC+beA9DABpjsV+6ahjJiADAeNLEBGBe/J1QkaY/YRhSIONOavl5/+ZCeWv/vamxsiZvX9HnWP/gb7dj6OhcjgHi2vG7f2loTC2Ma2+llXpYv12XFhzKKCickJdscJAIAwKkNdXYdO/7S65k9ew47hruHCOTUOnxt9UY+3MAUNgAwg71oprLu2WTs9qESDWyARdzjrmmoJgYAn4cmNgDj4veE6iTNJwkg8r5ZuVDld86LeR3haF77qIx0u+789vVaVD7LEuuwY0u91q97ngsSQLxqrtu3tsjEwpjG9mmOi9zKufISGtcAADhLfYdbDnXt2TeBhrZPWedrqw+aWBhT2ADAgN9F59+ojPJHja6RBjbAMjok+dw1DU1EAeB0aGID8Ln8nlClpMdJAoi80tJ8/fS5lTGtobtzQN9btVW/f+VARI6/puomGtkAwAxMYzNYaqFL2VeUHHOWXJicnJaay+UKAEB49Pzl7UOdb+yf1vNGS6JH0SGpyNdW325aYa0Bb46k41ytABAbtkynnOXfln2u2bv/0cAGWM5ud02DnxgAnA5NbABOy+8J+STViW1EgajYsnO1phTEbjR73a/364cPPqfe/sg+mW7KtLnxeP3lQ3ro7i0RzwQAYoBpbIaxT3Io01dwPPeKy2zJ6WncfwMAEEGjwyN9PQeaOtv+Y8/kwebORIzA5ClsQUlVXKUAEH3Jk86T666fyJZfYnSdNLABlsW2ogBOiyY2AKfl94T2SJpNEkDk3br8KgXu98fs/Osf/I12bH09audbsLBUVRsWW2Jt9je8r8qlT9PIBiAemTyNrU4JsJ19stOuTN/UvuzLvZ1pE92TuSQBAIi+4YHB4917/89w+4sNE4aO9iXCSzZ9CluTeKAWAKIutfRSOQMblZSeZXSdNLABlnepu6ZhDzEAOJUUIgDwWfyeUFA0sAFRkZFu1213XRGTc3d3DujuJU+p+WBbVM+7a2ejtEqWaGQr9k5U9eYVevCbm3WsrYcLFkA8CUqqNbi2XfEafOZl+XJdVnwo84Lp0yQ5xv4HAABiIDktNTd7dqmyZ5dqqLPr2PGXXs/s2XPYMdwdtw8yVZvYwDamUjSwAUDUZVxfLkfZA8bXOXzgVRrYAOurleQjBgCnwiQ2AKc0to3omyQBREestteMVQPbR5WW5uuHm5bK6Uozfp1MyAsAIuCWun1rt5tYWLxNY0stdCn7ipJjrktKMpOSbTStAQBguL7DLYfa/6t+Ws8bLfH0spjCBgD4kC3TqayV31fKxddYpuYP/vSiht9plCQNHfyzRnu79EHzWxrp6WZBAetY565pCBIDgE+iiQ3AKbGNKBA9E/Iy9a+/uyfq5zWpIauwIE8bt66kkQ0AYmN33b61fhML25M3yy+LT2NLdtqV9dczjmfPuWTY7sqawOUGAID1jA6P9HX+cW9Px+/2Thhs7rT6y9nka6uvMLGw1oA3KKmKKw4AosNeNFPOikdkyy+Jm9c0fOBVjbQd1kjrOxrc+3ua2wCzsa0ogE+hiQ3Ap4xtI8obRkCU3Lr8KgXu90f1nCY2YhUW5OnRp76hKQVZlli3dau2ndgSFQDiw4K6fWvrTCzMqtPYPrFdKAAAiBNxsN3odF9bfZNpRTGFDQCiK23uF5X5jX9UUnpW3L/WkZa9Gj68V0P7X9HAa3U0tQHm+IO7poFtRQF8DE1sAD7G7wn5ZfFpF4CVZKTb9cuXKqM+geyuW55SY2OLkXlUb16hYu9ES6wfjWwA4gjT2MLAPskh119d2OG6zDuSnJaay2UFAEB86/nL24fa//cfp/X9udUqJZs8ha1C0jNcVQAQeVlL71Pq1bcn7Osfadmrofr/VwNvvKihpre4IIDYesJd01BJDABOookNwIf8nlCOpD2SCkkDiI4FC0tVtWFxVM+5/sHfaMfW143NxGqNbDX/WKdfPPMyFzOAuPixZPA0NqO3unddVdSXfbm3M22iezKXEQAAiWe4f6Dj+O/eGOnZczB36GifyaUaOYVNkloD3ibxniQARJQt0ynXqh8recYXCGPMSMteDbzynPr/83kmtAGxs8Bd01BHDAAkmtgAfITfE6qWtJokgOj5+b8Gotqs9frLh7Rm5SZLZLOm6iYtKp9liVp3bKnX+nXPc0EDsDqTp7FVyLDJHPZJDuVc4z3muqQkMynZ5uDyAQAAktR3uOVQ+3/VT+t5w7jp50xhA4AEZi+aqaw7NygpZwphfIah17ar/39v02Djm4QBRFezJJ+7pqGdKADQxAZAEtuIArEwIS9T//q7e6J6zq9c8biOtfVYJiMa2QAg6kyextYkA6ZzMHUNAACMx/DA4PHONxpsnf/f/8k2ZDobU9gAIEE55t+ojPJHCWK8P8MPvKreHT+hmQ2ILrYVBSCJJjYAYhtRIFYWLZmjNY9cH7XzWbXJ6tblVylwv98Ste5veF+VS59Wb/8QFzgAq9pUt29thYmFxXIaG1PXAADAuTBgOhtT2AAgQbnueFj2uWUEcRaGD7yqrmce1PDR9wgDiA62FQVAExsAthEFYiXaW4labQrbx35zWViqqg2LLVErjWwA4sD0un1rm0wsLNrT2Ji6BgAAwunkdLb2F/dmD3dH9XfGBb62+joTM2EKGwBERvKk8+S66yey5ZcQxjkafOlZ9Tz3M430dBMGEFlsKwpANiIAEtvYNqI0sAFRlpFuj2oD244t9ZZtYJOkXTsbtW7VNkvUWuydqOrNK1RYkMeFDsCqgolcm32SQ+6bvB0XhG7vm3SD30EDGwAACJfktNTc3CvmZE//zm3K/7v5hxwXuaNx2t0GN7BViAY2AAi71NJLlf2dbTSwhSvPq29Xzne3KrX0UsIAIqtQZr8vCSAKmMQGJDC2EQVi5/J5M/TDZ8ujdr67bnlKjY0tls+tsCBPG7eulNOVZnyt3Z0DunvJU2o+2MYFD8CKEm4am+Mit/KunXvIMTV/GssPAACiZbh/oKP1P36X2rPnsCNC09lMnsJWJ2k+VwEAhE/G9eVylD1AEBEy8NsN6t5WQxBAZLGtKJDAmMQGJLagaGADYsJ3xQVRO1d350BcNLBJUvPBNt295Cl1dw4YX6vTlaaNW1cykQ2Ale8TTVUdrgMlO+3K+bLn+PSqWzum3r5INLABAIBoS05Py550g99RdP+tfRP/9vJj9kmOcB7e5ClsftHABgBhY8t0KvsfnqCBLcLSrlul7H94QrZMJ2EAkVPbGvDmEAOQoPc0RAAkJrYRBWLL450StXPtemFfXGV3spFtf8P7xtfqdKVp0867tGBhKRc9AKtZ5veEigytrVZSx7kcwD7JofNWfPFI0f239k1YcEVucnpaNksOAABiKSnZ5sieXTqh8J6va9q9i45kXpYfjsMGDX7JQVYdAMLDXjRT2fc9o5SLryGMKEi5+Bpl3/cMjWxA5LCtKJDIvxuznSiQeNhGFIi9un1ro3audau2adfOxrjLMCPdrurNK1TsnWiJeuN1HQDEtU11+9ZWmFjYnrxZQUlVZ/rvMi/LV55/7pG0ie7JLC8AADDdcP9Ax/HfvTHS9V8Hcs9iq9HdvrZ6v4mva2wK2y5WGADOXdrcLyrzG/+opPQswoiy0f4udT2+TENNbxEGEBlsKwokICaxAYkpKBrYgJiZkJcZ1fMdOXw8LnPs7R9S5dKnLTGRTZKqNizWNysX8gUAwErKxh5+MFG1xjmN7aNbhuZ/9TrRwAYAAKwiOT0te8KCK3KL7r+177wVXzxyhluNVhv80oKsLgCcu6yl98l5x0ZLNrANH3hVwwde1Wj7u5bNPyk9S1n3bJK9aCYXIxAZbCsKJCAmsQEJZmwbUZ50BGKotDRfP31uZTS/7uM+0zVVN2lR+SxL1LpjS73Wr3ueLwQAVrGubt/aoImFfd40Nvskh3Ku8R5zXVKSmZRsc7CUAAAgHvQdbjnU9h+vTev7c+vp/lqzr62+yMT6mcIGAOfOlumUa9WPlTzjC5arfbS/Sz3/fL8GXvvPT72mlMKZSim8SMnuqUqeepFsU0os0aA32v6u2r+3RCM93VycQPg94a5pqCQGIHHQxAYkELYRBcywaMkcrXnk+mh+7SdErlZrZPvZD36j3v4hviAAmK5DUlHdvrXtphW2J29WjqQmSdkf/XPHRW7lXHnJocwLpk9j+QAAQLwa7h/oaP2P36V2vtx0qmb95b62+loT624NeLdLupkVBICzYy+aqaw7NygpZ4rlah9p2avu2gfPaPtNe9FMpRR6ZC+ep5RLrjW2qW2kZa86HltOIxsQGWwrCiQQmtiABOL3hKolrSYJILZuXX6VAvf7o3Ku/Q3v65tfqUmYbKPdIHiua1O59Gka2QBYgSWmsbmuKurLvtzbyXahAAAgkYwOj/S1//7NwfYX92YPdw9JZk9hK5L0NqsGAGfHMf9GZZQ/asnah17bru4tPzjnJi970UylX1Umu/dLxjXyDb22XZ1PPsSFCoRfs7umoYgYgMRgIwIgMfg9IZ9oYAOMMKUgL2rn6uroT6hsd2x9XetWbbNErcXeiarevEIZ6Xa+KACYrnJsoq+Jal3zp7dOr7q1Y9INfgcNbAAAINEkJdscuVfMyZ7+ndt03oovHrHnZ/7Q4HKDrBgAnB3XHQ9btoGtb/uj6nzyobBMKRtqektdmx9T27evU9cTt2vote3GvE773DJlXF/OxQqEX2FrwMt9JJAgaGIDEkctEQBmmFKQSwgRtGtno9at2qbuzgHjay32TtQ/7bhLhVFsbASAs5AtqdLEwnxt9U2T/sf8F5LT07JZJgAAkOicM2f0X/yn3/3UxNrGprAtY5UA4MwkTzpPucF/kX1umeVqH+3vUtcTt6v3N1sicvzBxjfV+eRDan9ooTHNbI6yB2QvmsmFC4RfVWvA6yMGIP7RxAYkAL8nFJQ0mySAxJNfkJOQr3vXzkbdveQpSzSyTSnI0satK2lkA2C6SoNrC7I8AAAAxt8Xcc8GAGcotfRSZX9nm2z5JZarfaRlr9of/LIGG9+M+LmGj773YTPbB396Meav3VnxiGyZTi5gIPxqiQCIfzSxAXFubBvRKpIAEtOUgqyEfe3NB9ss08jmdKVp49aVKi3N56IFYKpsvydUYeT30MC9TZI2sUQAACDBdTgD99aaWBhT2ADgzGVcX66s1c8qKd167+8OvbZdx4NfDcv2oWdi+Oh76vjxanU/ebdG+7ti9vpt+SXKvOVOLmIg/GazrSgQ/2hiA+JfLREASFTNB9tUcd1Ptb/hfeNrdbrS9NPnVmrBwlIWDoCpgtQGAABgrGru1QDA+myZTmX/wxNylD1gudpH+7vUu+UBdT75UEzrGHjtP9Xx/cUaadkbsxpSr76dbUWByGBbUSDe74WIAIhffk+oUmwjCiS8RJ/udaytR5VLn7ZEI5skVW1YTCMbAFMVMo0NAADASB0ytImNKWwAMH72opnKvu8ZpVx8jeVqH21/V12PL1Pf7heMqGf46HvqeGx5TBvZMr/+ABc1EBnVRADEL5rYgDjl94SKxFOOACRdcNGUhM+gt39IlUuf1usvH7JEvVUbFmtN1U1cvABMFKQ2AAAA41Q7A/e2G1pbBcsDAJ8vbe4XlXXPJtnySyxX+/CBV9X+vSUaanrLqLpGerpj2siWPOMLcsy/kYsbCL/5rQFvJTEA8YkmNiB+1UrKJgYAxZdMJQSdaGRbs3KTdmypt0S9i8pn0cgGwESmT2PbzRIBAIAEY/IUthxJfMAIAJ/3++zigJx3bFRSepblah986Vm1/2CFRnq6jazvZCPbaPu7MTm/42/+ngsciIzg2MRfAHGGJjYgDo1tIzqfJABI0pyrphPCR6xf97ylGtmCP/qaMtLtLBwAkwSpDQAAwBgmT2GrFA/ZAsBnsmU6lfPtp5V23SrL1T7a36XuJ+9W1+bHjK91pKdb3Zvuj8m5k3KmMI0NiIxsnRjoAiDe7o+IAIgvfk8oR3x4BxhtX0N0n/qaUpClCXmZBP8R69c9r3Wrtlnj+/oNxarevIJGNgAmKfR7QmUmFuYM3FsnprEBAIDEwRQ2ALAoe9FM5Xx3q5JnfMFytY+07FXX48s08Np/WqbmwcY3NfDbDTE5d/qCZVzwQGTMbw14y4gBiC80sQHxp1Y84QgYraujL+rnvGJBCcF/wq6djZZpZCv2TqSRDYBpTP5AMsjyAACABLGdKWwAYD2O+Tcq655NSsqZYrnaP/jTi+p4bLmGmt6yXO29v/1fMdlW1JZfotTSS7nwgcioHXt4AkCcSBodHSUFIE6MTcR4jiQAsy1aMkdrHrk+qufc3/C+vvmVGsI3ZD3OVnfngO5e8pSaD7axcABMsKBu39o6I79f1vyoTtJ8lgjAGd0zy6bGzp5zPk6pK1PFGiFQANEw3Rm4t8m0osY+SGwSTWwA8CmuOx6Wfa41Bwf1bX9Uvb/ZYun8HfNvVEb5o1E/79Br29X55EN8AQCR8St3TQMT2YA4kUIEQHwY20a0miQA8/3lz9F/2qvYO1GFBXk0PxmyHmfL6UrTxq0raWQDYIqgJL/Bte1iiQCciV/8cb9eevX1cz7Outu+puLUJAIFEGmbTGxgG1MhGtgA4GNsmU5l3/eMbPnW2zFjtL9L3TV3a7DxTcuvQ9/uF+T4m7+P+hS8lEuulUQTGxAhN7cGvH53TUMdUQBxcM9EBEDcCEoqJAbAfEff64zJeb+y/CrCjwNOV5r++tpSggBggvl+T8hv5PfKwL11kv7AEgE4E+FoYJOkwnSeGQUQFUGDa6tkeQDgv6WWXqqcR/7dkg1sIy171fH9xXHRwHZSf92mqJ8zKT1LaXO/yBcDEDlsKwrECZrYgDgw9uHhapIArOFYW09MzruofJYy0u0swCc0NrZYqt4dW+r1i2deZuEAmCJocG1MKQYwbu/YksN2rPNHhgkUQKQZO4WtNeCtEA/aAsCHMq4vV9bqZ5WUnmW52ode267jwa9q+Oh7cbUmA6+/GJPzppbM4wsCiJxCmf0+JYBxcE66ZwAAIABJREFUookNiA98QAdYzOsvH4rJeW++lV+UrWzHlnqtX/c8QQAwicnT2GolNbNEAMajuf+DsBzn6i/MIUwA0RCkNgAwmy3TKdcdD8tR9oAl6+/d8oA6n4zP7S+Hj76nkZa9UT9vyoWX84UBRNbq1oDXRwyAxe+hiACwNr8nFJQ0myQAa9nX8G5MznvbXVcwjc2i9je8TwMbAKOkptg0p+S8jsVfLl1lcJlBVgrAeDR1dIXlOBdOnkSYACLN2Clsvb989K70v7o+05bhZJUAJDR70Uxl3/eM7HPLLFf7aPu76nx0sfp2vxDXazR8OPpNbFbcThawoFoiAKyNJjbAwvyeUJGkKpIArOetPx2OyXmdrjQt/b/8LIDF7G94X5VLnyYIAEY42bxWXubrmz37/Oyc3Iwlz37334pMrJVpbADG6/8cORqW45TmuQgTQKTVmlpYUprjW7a8KRPS/V9X2twvHaGZDUAiSpv7RWXds8mSDUvDB15V+/eWaKjprbhfp5HWd2JyXnvRTL5IgMia3RrwBokBsC6a2ABrqyUCwJoaXo/d5+nld87ThLxMFsEi3j3YpcqlT6u3f4gwAMTcxUXu/pPNa7Zkm+Mj/ylocNlBVg7A53np1dfDcpyC5GTCBBBJu52Be+tMLKzvV9UVkgpP/v/kSYWTaWYDkGiciwNy3rFRSelZlqt98KVn1f6DFRrp6WYhIyiJn4lANFS2BrxFxABYE01sgEX5PaEKSfNJArCmY209evdgV8zO/8BjX2ERLKC7c0APrPxnGtgAxNzM83P6bivzdcybNz39E81rJy1jGhsAq3rHFp7GM3dertwaJlAAkRQ0uLaKU/3hyWa21FlXHkuyp7KCAOKSLdOpnG8/rbTrVlmu9tH+LnU/ebe6Nj/GQkZBasnlhABEXrYYBANY976KCADr8XtCOZKqSQKwtrpfN8bs3HOumqZFS+awCAbr7hzQ3UueUvPBNsIAEDMnm9euvvJCR1paSvbn/PWgwS+Fe2cAn6mxuz8sx5l3cSlhAogkk6ew+fU5D9umnF8ywXHtbX2pJXM6aGYDEE/sRTOV892tSp7xBcvVPtKyV12PL9PAa/+ZcOtmc5/PxQvEt/mtAW8ZMQAW/BlNBIAlVetEFzkAC9vzu7/E9PyB+69hW1GDfWvZZhrYAMTM5ByHbll40ZFxNq+dZOw0Np14+rKDlQVwKm+3tYflODMmuQkTQCQFLV+bzeZImeHLdlx7W599xsX9LCkAq3PMv1FZ92xSUs4Uy9X+wZ9eVMdjyzXU9FZCrl3y1BIuYCD+1bYGvDnEAFgLTWyAxfg9Ib+kZSQBWN/vXzmg7s6BmJ3f6UpjW1FJpaX5xtW0btU2NTa28EUCIOpynWm6ZeFFR2647mLl5mVOPotDBE18Xc7Ave1iGhuAz7D/cHjuu0pdPCACIGIsPYXtU2w2h73kr9IzFn6jI6WguI/lBWBFrjseVkb5o0pKz7Jc7X3bH1XHj1drpKc7IdcuedJ5suXTxAYkgGyZ/SAIgFP9ukgEgOXUEgEQP3a9sC+m559z1TTduvwqFiIMXn/5UFiOs27VNu3a2UigAKIqMy1F186bfuSWG7xn27x2Utmz3/03U59wrBbT2ACcwh8a/xyW45yfRJYAInofY6rgWf9Le2p26iVXOxzX/O2xZPd5rDIAS7BlOpUb/BfZ51pvl7rR/i51PXG7en+zJaHXMG3ONVzIQOJY3Rrw+okBsNC9FhEA1uH3hIKSCkkCiB8v/dsfY15D4H6/Lp83I2HX4IKLwjPuf83KTVq28Kfa3/D+WR9jy89eoYENQFSlptg0p+S8jq+X+VRY5J4chkNmS6o08bUyjQ3AqewP01tjFxQWKmN0hEABREKzM3DvdhMLO6spbKeQlJ45IW3eDXJcvfiILTuPFQdg7u/QpZcq55F/t+QUr5GWver4/mINNr6Z8OuY7mezIyDB8H4gYCE0sQEW4feEiiRVkQQQX2K9pehJ392wRIUFiflGcfElU8N2rOaDbfrmV2pU8491Z/xvd2yp18+rd/JFASBq5pSc11Fe5uubPfv87DAfupJpbACsoqk3PPfilxVfQJgAIiVocG1hfXghKSt3cvqVtyht7peO2DKcrDwAo2RcX66s1c9acvvQode263jwqxo++l7Cr6Nj/o1KypkSs/MPtx7miwmIvtmtAW+QGABroIkNsI5aIgDi0/P/a0/Ma3C60vSdH31VGen2hMvf480P+zF/8czLZzSVbceWeq1f9zxfDACiYub5OX23lfk6Zs8+P9uWbHNE4BRMYwNgGW+3tYflONPzcggTQCQ0OwP31ppYWN+vqosk3RyJYydPKpyc7v+6UkvmdCTZU7kKAMSc646H5Sh7wJK19255QJ1PPsQijnH8zd/H9PzD79PEBsRIZWvAW0QMgPloYgMswO8JVSgMo/kBmGnbs/9lRB3F3omq3rwioRrZMtLtKvZOjMixxzuVbX/D+/rZD37DFwKAiJuc49AtCy86cvWVFzrS0lKyI3w6k6ex1XI1APjwXuxwS1iOU5SRRpgAIiGYyLWlzPBlO669rc8+4+J+LgUAsZTkcFmu5tH+LnU+ulh9u19gAcc4FwdiOoVNkoaPtbAQQGxkiwdbAUugiQ0wnN8TyuGHKhDfjrX16PWXDxlRS7F3or71yC0Jk/0ls6dF/Bynm8q2v+F9VS59Wr39Q3whAIiYzLQUXX/1hcduuO5i5eZlTo7SaU2extYkaRNXBoDeJJv+0Pjn8NxHa4RAAYSb6VPYlkXlZDabw17yV+kZC7/RkZJf2MtlASAWup76jkZa9lqm3uEDr6r9wS9rqOktFm+MvWim0q5bFdMaRvu72NIViK2bWwPeMmIAzEYTG2C+oE58CAggjj21/t+NqcV/Q7HWVN2UELlf/T8uicp5TjWV7d2DXTSwAYio1BSbrpx9/rGvl/mUPyVnQgxKqDQ4niBXCIB3RsN0T/mFOYQJINHuV6Jfmz01O/XSL2U4rl58xJadx9UBIKpGerrVXfugRvu7jK918KVn1f6DFRrp6WbhxtgynXJWPBLzOob/8iqLAcRedWvAm0MMgME/t4kAMJffE/JLWk0SQPxrbGwxZhqbJC0qnxX3jWwZ6XYtuNET1XOenMpW9+v9emDlP9PABiBiLi5y95eX+fo8JedNiGEZ2c9+998qTMyHaWwAJKmxsycsx7lw8iTCBBBuHUxhO7WkrNzJ6VfeorS5XzqSZE/lSgEQNUNNb6lv2yPG1jfa36XeLQ+oa/NjLNYnZK38vmz5JbG/ht56hcUAYq9QZj94CyQ8mtgAs7GNKJBAXvi/zXoSK94b2eZdPVNOV1pYjvXuwfE/hdl8sE3Be3+p5oNtXPQAwm5yjkO3lfk65s2bnm5LtjkMKClocFxBrhggsR042hqW4xRlZxEmgHAz+T1BI+6hkicVTnZce1tfasmcDi4XANHSt/sFDb70rHF1jbTsVdfjy9S3+wUW6RNcdzyslIuvMaKWoT8ziQ0wRFVrwOsjBsBMNLEBhvJ7QpWSZpMEkDh27WzU/ob3jappUfks/fxfA8pIt8dd3nd8a2HYjtVysJ0LGEBMZaalqOxLJcduuO5ipaWlmLQVfSHT2ACYat/Bd8LzjS49hTABhFOHDG1i6/tVdY5iOIXtU2w2R8oMX3bGwm90pOQX9nLpAIiGrs2PafiAOc1IH/zpRXU8tlxDTW+xOJ+QcX257HPLjKhltP1d1ggwC4NkAEPRxAYYyO8J5YjJEEBi3jV/93njair2TlT15hVx1ci2YGGpphQwMQOA9aWm2DSn5LyOr5f5lOd2TjC0TJPva7nnBhJUb5JNf2luPufjuPNydf7IMIECCOtbA87AvaY+KWXm1kv21OzUS7+U4bh68RFbdh5XEICI69zwDxrt74p5HQO/3aCOH6/WSE83i/IJjvk3ylH2gDH1DL6yjUUBzDK/NeCtIAbAPDSxAWaqlpRNDEDiaWxs0esvHzKurmLvRP3ypUoVFsTHm8HhnMImSfsa3uXiBRB1M8/P6bu1zNc/e/b5pt83mj6NbTdXE5B43hkNz3FKL5hBmADCyfQpbJUmh5eUlTs5/cpblDrrymNJ9lSuJgARM9LTra7HYzeYcrS/S11P3K7ubTUsxilkXF+ujPJHzfo5+vKvWBjAPNWtAW8OMQBmoYkNMIzfE/LLpLH8AKLux+t2GFmX05WmjVtX6vJ51v6g7tblV4V9CltXRx8XLoComZzj0C0LLzpy9ZUXOpKTbekWKTtIbQBM0tjZE5bjzC6YSpgAwsn0KWyWeOg25fySCY5rb+uzz7i4n0sKQKQMNb2l3i3Rn/Q10rJXHd9frMHGN1mEU3Dd8bBRE9gkafjAqxo++h6LA5gnW7wvCBiHJjbAPLVEACS25oNt2vKzV4yszelK0w+fLdety6+yZLaFBXkK3O8P+3H/0sgkNgCRl5pi07Xzph+54bqLlZuXOdlq34Kf/e6/lRn5sy1wb52YxgYknD8cPByeb26ZDsIEEC5MYQsnm81hL/mrdMc1f3ss2X0eVxeAyHx/3P2Chl7bHrXzDb22XR2PLach6jO47nhY9rnmvfXQu+MnLA5grtWtAa+PGACDfpUjAsAcfk8oKKmQJABs/p916u4cMLa+wP1+BX/0NWWk2y2TaUa6Xd/50VcjcuzuLiaxAYisi4vc/eVlvr7CIvdkC78Mkz/4DHKVAYml8S8HwnIcTwpvrQEIm+1MYQu/pPTMCWnzblDa3C8dYYtRAJHQveUHGmnZG/Hz9G55QJ1PPqSRnm5C/wRbplO5wX8xsoFttP1dpuYB5qsmAsCgn+tEAJjB7wkVyWpPNAJxICPdrsvnzdCaqpu0aMkcY+rq7R/S91ZtNfv71g3F+qf/n717D4+yvvP//8rkNEkmJCQRATEJx8RARAREFyKDFYWi5WDVH+hCqGvnW6WK8dIVXXFEClouNXat/aZ+LYfauN92pVBwRflWQNh2EaiH1Eih0CRisJjEJJNkJoRkfn+AbVXQHO6Z+75nno/r2muvdfVzv+f1uSdzyDvvz5Y7lJOdYYu9vn/VXI0qPC8ka1dWHufJBCAkzk9P0s3fHFM3adJQpyPWYfdxP1M3LN/mtmJhTGMDoku9YlXf8Gmf1xmek6PkYBeBAjCK14pF2XIK21nEDsg5nyNGAYRCV2uLmp/7voIBX0jWDwZ8al49T/5dWwn7LOJzRyp9+ctyDMq3ZH3+/2IKG2ADU+s9hcXEAFgDTWyAdZTKpn/RCNhNsjNe06YXyPvUTfqvd/9VP9ywQNcvuFjz/5e1jsh8a+9R7XzlkKWzHJydqvXb77D88aL3PvItuWeNCsnahyo+4UkFwHD/eHRoSqozK4IempfaAJitprPTkHXysocQJgCjrHd5SqosWluxIuU7S44YBRAinSc+VkvZncave3SfGh+8Rh1Vhwn5LJKmXqfUe9YrJn2wNe+Lo/toPgTso7TeU5hODID5YoLBICkAJnPnrXRL2kESQGhdNmmYvnnzhK9sZlo0/TlV1zRYpuZkZ7x+uXupXP0SLZ/voYpP9IOSX1kqP+l0A9v1Cy4O2fpbyt/Tk4/+hicYAMOMzs0MTJyQE4yAyWvnMm3hihk7rVhYS9lT70gay10IRLZNzX49+3Lf37/df/M8XZMcT6AAjDDUqk1s/s2lVZJyIjH0zhPVfz357pvnBztOcgcCMIRrnkeJ1y4xZK2TuzfI9+IaQj2Hfrc/ZsnjQ88mGPCpq/b0kbOdH32gYFuzTh58S8G2FhoUAWt5JrOsglPTAJPFEQFgCeuIAAiNZGe8vjHr9JS1wdmpX/vvXztvvH5aut0y9X92rOgPNyywfNajCs/T+u13qOzxndr80l61BTpMrynUDWyS9Iff/ZknGgBDnJ+eJPc/Da+LsMlrZ+OV5LZobaWS1nI3ApHt3ZqPDFknNzlREseJAuiz9RZuYCtWhDawSX8/YrTj0FsxHUffd3IrAuirlo1lih1SoLjRV/V6jWDAJ//GVUzwOgdHiktp96217PGhZxPjTFXssImnX3vO/O/Ea/9hzxtr1dXwkU4d3quOmg90quaQOk98zGYD4Xd3vadwXWZZxTtEAZj4uskkNsBc7ryVXkmPkARgrGRnvGbPn6Rb7riiR1PMamt8WjD9Gcs9nu8una4F35tkm/xra3wq/bctemvvUdP2//5Vc0N2hOg/+vYVT6uuoZUnHYBeS4hzaOLowXV5+QOzouhhW3kaW5Ui+Je1AKSbN7+u+oZP+7zO/1t8M2ECMAJT2CwgGGitaz/welZXUwN3JIA+6UuTVdfxg2pZ9yDTuc4hoWCcXJ4fK8aZGvGPNRjwqfPIPnUc3quOD/ZxTwDhsyuzrMJNDIB5aGIDTOTOW5kr6R1JaaQBGKO3zWv/yGpHin7mp//p0ajC82y1Hwf2fKgXnnxdlZXHw3bNnOwMPfTUjWHJyqpNjwDsY+SQdP8/XT4sJjbWEW2TH9YvXDGj2IqFtZQ9VSymsQERq16xunlteZ/XGVtwkZ6cdDGBAujzeyKXp8SS74nOTGGLuvdEp44drOv4YF8WR4wC6Iv43JFKvWd9j5qtTr3/hnwvPKSu1hYCPIvkmQuUNGdZ1D7+YGOtTv35LbW/vV3t+9/khgBCa3FmWcU6YgDM4SACwFRe0cAGGOayScP0f7bcIc8D7l43sEmnjxS1oge/+6JamttttSfjp1yo5359m558YZEKCgaF9FrJznjNXzxF67ffEbZmv52vVPLEA9ArKYlxmnN1fl3R5BFJUdjAJkmLNizflmvFwlyeknWSqrlLgch08OQpQ9YZdcEgwgRghHUWrs0bjRsSNyQ/K+kbtwTiBuW0cXsC6K2OqsPyb1zV7X+//bVn1fSju2lgOwtHikv9bn8sqhvYJCkmfbDiJ8yR6/YfK+OZ36nf7Y8poWAcNwgQGqX1nsJ0YgBM+kxGBIA53Hkr3ZIWkQTQd1kZKVq25tsaP+VCY56fswr009LtlnucdQ2tun/Ri3ru17fZbo/GT7lQ46fcptoan17633v021feU1ugw7D1p00v0O33T9fg7PCOkn/n90d4AgLo+c/E/IFNY8cOSZOUFeVReCUVW7g2prEBEaiqyWfIOmMGGPcjvF6xqldQVW3tajt19ia7gn4pSnbEaEhXJ5sIRI5dLk/JTisWdmYKW/Qer+5wOBPGXa244Q11J/+wPaurjaYSAL34Wbprq+IuvEgJRQvP+e8EAz61lN2pk5VvE9hZxOeOlKt4Va+OZo1kMc5UxU+Yo/gJcxRsrJX/v/5d7ft30gQJGCdNp78bXEoUgAmvcxwnCpjDnbfyHUljSQLom2nTC3Tvqll9mrx2NlY9UvSzx/zIs/Nsv3c7XzmkXa/+URUHqlXX0Nrj/z4nO0PXzhuvb91yieH73x0tze26buIanoQAuu389CRd7c5rSkyMYxLv3w1duGJGlRULayl7qkrR/MtbIEI9+sc/a/e+A31eZ91tC3rdUFavWB1oC+iPtX/V3vcrVd/waY/++6KJ43XFsByNT3YqUzS1ATY2zcJNbHxv+ZmurrZTVe91nDx4gPfwAHol/V9/pthhE7/84+X4QTU/9311nviYkM4iccKVSvnnx3t0JGs0CwZ8Orlrvdpe+wXNbIBxxmWWVbxDDEB40cQGmMCdt3KppKdJAui9ZGe8vvevM3X9gotDsn75T/ZachrbZ+595Fshe+xmqK3x6VDFcf2polZHKmvV4vOf9d8bO2m48goHa0JRjimNa3a6RwBYR0KcQ0Xjc/6ak5t5Pml8yfqFK2YUW7GwlrKneM8ORKCr1/7fPq8xPCdHZVdd3qP/pi3GobfbO7Xx7Qq9W/mBYY+naOJ4zR8zSqPUxeYC9rLL5SlxW7Ew/+ZSt6QdbNHnBQOtde0HXs/qamogDAA94khxKX3V659rxurYv0kt5U/QbHQOrnkeJV67hCB69Xp1upmtZWMZYQAGvGfPLKtwEwMQXjSxAWHmzluZLqlKp0eRAuiFnOwMPfTUjRpVeF7IrlFb49OC6c9YOodIa2SzGytP6wNgHdkDXG3TrhzliI11OEnjnCw5ja2l7CnetwMR5pgjVsUvlPd5nRunXyXPkO59FmmLcej1pla9tGN3jyeu9bSmf77wfCUHaWYDbMLKU9h2SprKFp3dqWMH6zo+2JcV7DhJGAC6LT53pPot23j6/WH5Mvl3bSWUs3CkuJR62w8UN/oqwuijYGOtWn/1A7Xvf5MwgL6Zm1lWsYkYgDC+HyACIOxKxS/CgF7Lyc7Qj1++LaQNbJI0ODtVOdkZls7iyUd/o0MVn3BTmODAng9pYAPwlVIS4zTn6vy6q6flJ9PA9rW8VizK5SlpPPPeHUCEqA6cMmSdMQOyvvbfaYtxaFOzX4s3bdOzL/8mpA1skvSr7W/ont/+TsccsWw0YH27LNzA5hYNbF8pbkh+VpL75qbYzIGEAaDbOqoOq618mZpXz6OB7Rzic0cqffnLNLAZJCZ9sFy3/1hpdz0jR4qLQIDeK633FKYTAxA+NLEBYeTOW3mJpEUkAfTOtOkFWr/9jrAdI3ntvPGWz2TprT+jkc0EW/9jHyEAOKfRuZmBG781ti0j05VFGt0yZ8PybVb9MqhUUhNbBESGqiafIeuMS/zqRrHX2zrC1rz2j45UV+veX79KIxtgfVZukveyPd0Qn5CWOGmWnJfPrIuJTyAPAN3i37VVHVWHCeIskqZep9R71ismfTBhGCxu9FVKX/6y4nNHEgbQOzmSlhIDED40sQHhxSQHoJemTS/QI8/OC+s13bMKLJ9LW6CDRrYwq63xacf2SoIA8CX9XYmaO/2iv06aNNTpcMQkk0i3pcmiXwYxjQ2ILH84WtXnNcYWXHTOIzuPOWJ179739MP/uzGszWv/qL7hUz32//5bbTF85QdYVLXLU2LJ44iYwtZzjozBWUnfuCUQNyinjTQAoHdSb71PyQtWK8aZShghEpM+WP2WbVTS1OsIA+idR+o9hbnEAITpcxYRAOHhzltZLL4IAnrFjAY2yR5Hiko0soXb8z/cTggAvmR8/sCmubMK1T8j5XzS6JWlTGMDEGrvVn7Q5zUuHZZ71n++qdmv4hfKDblGXx2prtb/PlzDhgPW5KW2CONwOBPGXZ3svHxmnSOZ49oAoNs/PlNc6u/9lRKKFhJGmCQvWK1+tz9GEEDv8EeuQLjeIxABEHruvJXp4osgoFfMamD7jB2OFJVoZAuXQxWfMIUNwOf0dyXq5m+OqRs7dkgaafQJ09gAhPZ9nEFfgU087/P9tvU6PX3t2Zd/Y6nH+1+7/9uwxwzAMNUuT8k6Kxbm31yaK/74tk8cGYOznFfe2BY/bHSANADgq8XnjlT6qtflGJRPGOHOfsIcGtmA3pld7yl0EwMQhs9WRACExVKdPjMbQA9cNmmYqQ1skj2OFP3MZ41sO185xM0TIqXLf0MIAP7ms+lrKanOLNIw5j2zxaexAbCxqrZ2Q9YZpb8fJfrfJ4O6Y/Orlpi+djYv/ZHPBYDFeKktwjkcyfH5lzudU+YylQ0AziF55gL1W7bRlseHnnr/DbW/9qxO7t6gzqP71Hl0ny33gEY2oNfWEQEQejHBYJAUgBBy563MlfQXkgB6Jic7Qz9++Ta5+iWaXsv9C8v11t6jtsrv3ke+pesXXMyNZKCdrxySt+SXBAFA/V2JuubKkXU0r4XEowtXzPBasbCWsqfWSVrEFgH2VHbsE/1q+xt9WuObRZNVMmKIJOkXnzRr7dZXLf+41922QEO6OrkBAPNVuzwluVYs7MwUNr67NFpXV1vHobccHUffdxIGAJw+PtS14F8VP2GOLetvK18m/66t53xscTkjFZdzkeKGXKTYC/JtMWWuY/8mNT//MDcn0DP3ZJZV8MeuQAjFEQEQcryQAT2U7IzX6hf+2RINbJJUNGOM7ZrYnnz0N/I1+bXge5O4oQzQ0tyuHz74a4IAoPH5A5vOHB1KA1toLJV1J4F4RRMbYFuHPjre5zXGDD5fbTEOPfw/71h2+toXvVLzsTxDzuMGAKzxPoLaosnpqWyKHTyq7uQftmd1tbWQCYCoFTtgoPrd8e+2PD40GPDJ9/QidVQdPue/09XaopOVb+tk5duf++cJBeOUeOnVihtxmSUfe/yEOUo+9oHaXi3nJgV68N653lO4LrOsopEogBB9lCICIHTceSvdkmaTBNAzj/14gQZnW2ec+LTr8myZ409Lt+vRJRu5oQywYsnLagt0EAQQxfq7EnXzN8fUnWlgQ+ikbVi+rdiKhbk8JVWS1rNFgD0Z0XSWEhene377O9s0sEnSHw4dYfMB8zW5PCXrrFjYmSlsNOmHkKNfRpbzyhvb4oeNDpAGgGiUOOFKpT200ZYNbJ1H96nxwWu+soHtq5ysfFu+F9foU++Nanx4uvybVqvr+EFLPcakOcuUOOFKblSg+9LEH4EAof0MRQRASDGFDeih+YunaPyUCy1Vk6tfoi6bNMyWee7YXqlF059TS3M7N1cvlf9kr+0m8QEw1vj8gU1zZxWK40PDxkttAIx0yKCvvx75xS91pLraVo/9SHW1jjliuQkAc1n5+0He24TD6alsTueUuXWOZBd5AIgarnkeuW7/sWKcqbar/eTuDWp84jvqajVmkmbniY/V9mq5PvXeqObV89Sxf5NlHmvKPz+u2AEDuWGB7ru73lN4CTEAIfr4RARAaLjzVhZLGksSQPcVFAyS5wG3JWsrmjHGtrlW1zSo+NrndKjiE26yHjqw50P9tHQ7QQBRiulrpslhGhsAI1W1RfcfdFQHTnETAOZpkkWb2JjCFn5MZQMQNT/vUlxKu+sZJV67xHa1BwM+tZUvk+/FNSG7RkfVYTU//7AaH55uiWa2GGeqUhev4sYFeobNP4kGAAAgAElEQVRBNkCo3kcQAWA8d97KdF68gJ5Jdsbr3565ybL1paY5bZ1vXUOrlt76M20pf4+brZsOVXyih+8sJwggSjF9zXReagNglD/W/jWqH/8nAXolABOVujwljRatrZjtMQFT2QBEuPjckUpf/rLiRl9lu9q7jh+U7+lF8u/aGpbrdZ74WM3PP6zm1fPUeXSfqY89dthEueZ5uIGB7pta7ymcQwyA8WKCwSApAAZz560slXQ3SQDd992l07Xge5MsU09tjU8H9vxFu7f9MeKOkrz+hvG6d9VMbrqv0NLcrpuKStUW6CAMIMr0dyXqmitH1tG8ZgmLF66Ysc6SrxNlT22SNJstAuzB88b/mHYM6PCcHF1ZWKCCjH7Kjo1Vpjr/9v+rV6xqOjtV2dCs3/zuf1Tf8GlIaiiaOF6PjBnBjQCEX5OkXCs2sfk3l6ZLqpLExGEzdXX5T777RvDU8epkwgAQCZKmXqekeQ/a8vjQU++/Id8LDxl2fGhvuOZ5TJ1eFwz41PSDeeo88TE3M9A91ZllFbnEABiLJjbAYO68lbmS/kISQPcVFAzSc7++zRK1bCl/LyIb174oJztDq1/4Zw3OTuUG/IKW5nbdecMLqq5pIAwgyozOzQxMmjTUSRKWUb1wxYxcS75WlD3llrSDLQKsry3GoW/97KWwX7do4njNHzNKo9TV7f9mU7NfL+3YbXgzG01sgGkedXlKvFYszL+51CvpEbbIGroaauvaD/w2K9hxkjAA2FbqrfcpoWihLWtvf+1ZtWwss0QtCQXj5PL82LRGwM6j+9T4xHe4oYEevOfPLKvwEgNgHJrYAIO581YylQHooZ/+p0ejCs8z7fotze36xXO/1+aX9kbV5K1kZ7xu/V9uS03AMxsNbEB0SkmM0/SiEXUZmS6mr1nP3IUrZmyy5GtG2VM7JU1liwBrOySH7lgbvia23jSv/aNjjljd++tXDW1kG1twkZ6cdDE3AxBeTGFDz3R1BU6++0YXU9kA2I0jxaW0+9bKMSjfdrUHAz61/vwBte9/01J1xeeOVOo9601rZGt5/k7LZQJY/X1/ZllFI1EABr23IALAOO68lW7RwAb0yPU3jDe1ga3s8Z26qahUL63dE3VHR7YFOvTT0u26f2G5Wprbo/5ePFTxiW4qKqWBDYgyI4ek+2/81tg2Gtgsa6mFa/OyPYD1VTa3huU6mRn9df/N8/TImBG9bmCTpCFdnXrgumsMre3dyg+4EYDwW2fFBrZ/eH9FA5vVOBzOhHFXJydcPLkuJj6BPADYQnzuSKWvet2WDWxdxw+q6QfzLNms1VF1WL6nFykY8Jly/ZQbH+LmBrovTVIpMQAGfjQiAsBQvEgBPZDsjJfngatMufaBPR/q21c8HZXNa1/01t6juqmoVDtfORS1GRyq+ERLb/1Z1N8LQDRJiHNoZtGIuqLJI5IcjhimHVjX1A3Lt7mtWJjLU7JT0i62CLC2oyfqQ36Noonj9dzsmbomOd6Q9cbFnl4TgK1Z8jvCM1PYlrI91hU3JD8ryX1zU2zmQMIAYGnJMxeo37KNpk0L64uO/ZvUtGaxOk98bN0aqw7Lv3GVKdeOSR+spKnXcZMD3beo3lOYSwyAMWhiAwzizltZLGksSQDdN3v+JLn6JYb9umWP79S9t61XXUMrm3BGW6BD3pJf6o65L6i2xhdVj31L+Xv67rfLaGADosj56UmaP+eSwKDB6UxfswcvtQHorT/VHAvp+ouvm6lHxoxQpjoNXfdbF41g8wD7Wu/ylFRZtLZiMYXN+uIT0hInzVJC/vgmwgBgNY4Ul/rd/piS5iyzZf3+TavV/PzD6mptsX6tu7aqY/8mU66d9M3vc7MDPbOOCACD3msQAdB37ryV6WIKG9AjWRkp8jzgDus1W5rbdf/Ccr20dg8bcA6Vlce1YPozKnt8Z1QcMfrkg6/qyUd/w8YDUSIhzqHJY4fUzbp2tGJjHU4SsQ2msQHolXrF6kh1dUjWzszor0dvuUm3nNcvJOuPiz19DQC25LVwbUxhs5G4YZekJU27ucGR7CIMAJYQO2Cg0u5bq/gJc2xXezDgU/PqeWp7tdxWdbeUP6FgY23YrxuTPliJE67kpge6b2q9p9BNDEDf0cQGGGOp+CtGoEcWff8b4f2w19yuO294QW/tPUr43fDS2j0qvvY5bSl/LyIf36GKT7Ro+nPa8vIBNhuIEv1diZp7TUFdXv5Apq/Zk9fCta1jewBrqunsDMm6mRn99eTcmZqcEBPS+guGDzOsXgBhY9kpbP7NpcWSctgie4lJcmU4r7yxLX7Y6ABpADBTQsE4pT20UY5B+barvev4QTU+eI06qg7br/bWFvn/699Nubbzn27gxgd6Zh0RAH1HExvQR+68lbnirxiBHkl2xuv6BReH7XqfNbBV1zQQfg/UNbTqyUd/o0XTn9OBPR9GzOMq/8leLb31Z9wPQBQZnZsZmDurUCmpThrY7MvK09jWSapmiwDrqW71G77m2IKLtHbODA3p6gx5/SPOH2DIOkY1wwHoFi+1wXAOR3J8/uVO5+Uz62LiE8gDQPg/987zKPXuDYpxptqu9pO7N+hT7422OD70XPy7tpoyjS1u9FWKHTCQJwDQfTn1nkJ6BoC+fvwhAqDPvGIKG9Ajs+dPCuv1Vix5mYalPqiuadC9t63XHXNfsHUz24E9H2rR9Of009Ltagt0sLFAFEiIc2jO1fl1kyYN5ejQyFBs8c8EACzm3ZqPDF1vbMFFeuzyS5Qc7ApL/SmJ8WwiYC9MYUNIOTIGZyV945ZAbCYNBQDC9HMnxaW0u55R4rVLbFd7MOBTW/ky+V5cExF7YdY0tsTxV/FEAHrGW+8pTCcGoA/vP4gA6D133kq3pEUkAfTMLXdcEbZrlT2+kyNEDVJZeVz33rb+9DGcNjpmtLbGp0eXbNS9t62nmRGIItkDXG3z51wSyMh0MX0tcizasHxbrhULYxobYNH3r0eM+xwQ7gY2ALZUauHavGxPhHA4nImTZinh4sl1hAEglOJzRyrtvrWKG22/JqZgY618Ty+Sf9fWiNkP/66tCgZ8Yb9uwsVX82QAeiZNnOAG9O0jDxEAfeIlAqBnpk0vkKtfYliudWDPh3pp7R5CN1h1TYOefPQ3+ubYJ1T2+E7V1vgsWednzWsLpj+jHdsr2TggikweO6Tu6mn5ybGxDiaw8f6b2oAoVa9Y1Td8ashadm9gG5t9ATcEEHq7XJ6Sd6xYGFPYIlPckPyspGk3NziSXYQBwHBJU69T6j3r5RiUb7vaT73/hhpX3KCOqsMRty+n/vjbsF8zdthEnhBAzz1S7ynMJQagd2hiA3rJnbdyjqSpJAH0zHxPUViu09LcrtX3/SeBh1BboEMvrd2jBdOf0f0Ly7Wl/D21NLebXtfOVw7p/oXlNK8BUai/K1E3f3NMXV7+QKavRS6msQHolprOTkPWGZ6TY1oDm1HHoSbHxXFDAKHntXBtTIKIUDFJrgznlTe2xWWP8pMGAKOk3nqfkhesVowz1Xa1t7/2rJp+dLe6Wlsicm9OHfvAlOsmFIzjiQFE1ucDwNL4FgvovVIiAHomKyNFowrPC8u1fvHc71XX0EroYfLW3qN6a+9RPfmodNmkYSqaMUbjpwzV4OzwfNlxqOITbXlpv36/4yD7DkSpkUPS/ZOvGB50OGJoYIt8XknFFq5tLVsEmK+yodmQdWZOGGvaBLbm1jZD1slNTpTEMahACO1yeUp2WrEw/+ZSt6SxbFEEcziSE8YUKTZrSMPJij0ZwY6TZAKgdz9OUlzqt+RHtpy8FQz41PrzB9S+/82I3qNT1SY1seVfppOVb/MkAXpmUb2ncF1mWcVOogB6hiY2oBfceSuXijH8QI/NW/hPYblObY1Pm1/aS+Am+ayhTTrduFg4PkeX/tMI5RUOMqyJ8VDFJ/pTxXH94Xd/1t7dh9UW6CB4IEolxDn0jSuG1Q0anE7zWvRYtGH5Nu/CFTOqLFjbJp3+Y5c0tgkw15//esKQdXJSkkx7DO9WGvNLqiExkoLcE0AIeakNZosdODQjKfOCpsBbr6R1NTUQCIAeic8dqdR71tty+lrX8YNqfu776jzxMRsZIo7MIYQA9P69uJsYgJ6hiQ3oIXfeynTxBRDQu+fPrIKwXOf5H26nqcki6hpatWN75eeO9czJzlCKK1FjJw2XJOUVDlZq2rl/Obh/zxFJ0pHKWrX4/KqsPE6wACSdPj70m1df1JSYGEcDW/TxyoLT2FyeksaWsqdKJT3CFgHm2r3vgCHrZMfGSuoMe/2H5DBkneE5OaZNkgOihNWnsE1li6JIfEKac/JcdRz8n0DH0fedBAKgO5KmXqfkBattWXvH/k1qKX8iYo8PtQpHxgWEAPTO1HpP4ZzMsopNRAF0H01sQM8tFZMVgB7Lyc4Iy9GStTW+zzVMwXqqa07/RTDNaAD6YnRuZmDSpKFO3pdFrTkblm9LX7hiRqMFayvlMwNgrmOOWEPWyczor0wTGtgkqaqt3ZB1Lh01nBsCCC0vtcFq4vMvd8YOyK5rP/DbLI4XBXAujhSXXAv+VfET5tiyfv+m1Wp7tZyNDIOYpFRCAHqvVKdPbgDQ3fcoRAB0nztvZa6YqgD0yj99IzxT2LaUHyBsAIhgCXEOzSwaUXemgQ3RK02nG8Usx+UpadTpL6gAmKQ6cMqQdQqGDzPtMfylwZge3aEZ6dwQQAh/3DCFDVblyBicleS+ucmRlkEYAL4kdsBApd231pYNbMGAT82r50VlA1vseeZMRHMMyudJA/ReTr2nsJgYgB687hAB0CNeIgB6Z9qs0WG5zvbNbxM2AESo/q5E3XjdxU2DBqdzfCgkaemG5dus2p1RKqmJLQLMUdXkM2SdsdnmHZtz6CNjphbnJidyQwCh46U2WNqZ40Xjh40OEAaAzyQUjFPaQxtt2ZjUdfygGh+8Rh1Vh6Pzx/qoSdzAgD2V1nsK+QszoJtoYgO6yZ238hJJi0gC6LlkZ7xGFZ4X8uvsfOWQ6hpaCRwAItDo3MzA3FmFSkyM44hGfIZpbADO6s9/PWHIOjkpSaY9hncrPzBknVHq4oYAQqPa5SlZZ8XC/JtLc8UUNvyD+PzLnc7LZ9bFxCcQBhDlXPM8Sr17g2Kc9jse8uTuDfrUe6O6Wluidv/ixnyDmxiwJ8t+hwlYEU1sQPfxSyigl8aMvTAs19n16h8JGwAiDMeH4mtYfRobABPs3nfAkHWyY2NNqf+QQV/XjS24iJsBCB0vtcFOOF4UiPKfASkupd31jBKvXWK72oMBn9rKl8n34pqo3sPECVfasvkQwN8srfcU5hID0I33LUQAfD133kq3+AtGoNeGFwwOy3UqDlQTNgBEEI4PRTdYfRrberYICK9jDmMazzIz+itTnaY8hqq2dkPWGXXBIG4IIDSsPoWNkyRwdhwvCkTnUz93pNLuW6u40VfZrvZgY618Ty+Sf9fWqN/HpG8Um3btruMHeSIBfZcm/tgE6Baa2IDuYYoC0AcTpgwP+TVqa3wcJQoAEYTjQ9EDVh7H72V7gPCqbDHm9/IFw4eZ9hj+0tBoyDpjBtADDkTh6zvvPfC1OF4UiB5JU69T6j3r5RiUb7vaT73/hhpX3KCOqsNRv48JBeMUO2yiadcP+n08mQBjLGIaG/D1aGIDvoY7b2WxpLEkAfTe+CmhP070UMVxggaACJAQ59C0ibkNHB+KHkjbsHxbsRULc3lKqsQ0NiCsjGoAG5t9gWmP4dBHxny2yXHGcUMAxmMKGyKCI2NwlrNoXh3HiwKRK3nmAiUvWG3LIyjbX3tWTT+6W12tLWykpJSbHjT1+l0NH7EJgHEYnAN83WcVIgC+lpcIgN7LykgJy3X+VFFL2ABgc/1diZp7TUHd0GFZ/CYFkfSenc8TQBgZ1gCWkmTaY3i38gND1hnS1ckNARhvHe85EClinClZzitmt8Vlj/KTBhB5Oj7Yp2DAXhO0ggGfWp6/Uy0by9jAM1zzPKZP0uuqP8ZGAMaZXe8pdBMDcG40sQFfwZ23cqmkHJIAem/AwH5huc6RSprYAMDORg5J98+eOaYtJdXJ2WfojRymsQGQjGsAy46NNaX+QwZ9VVc0cTw3A2C8Jll0cgJT2NBrDkdywpiipMRLr2ogDCCydFQdVuvPH7BNvV3HD8r39CK173+TzTsjPnekEq9dYnodJw++xWYAxvISAfAVH1GIADg7d97KdF5EgL4bO2l4WK7T4uOPRgHAriaPHVJXNHlEksMRk0wa6AMvtQHRzagGsMyM/sqUOVPMKptbDVlnxPkDuCEA45W6PCWNFq2tmO1BX8QOHJqRNO3mBkeyizCACNK+/021v/as5evs2L9JTWsWq6PqMJt2hiPFpdTvWWPvTlWzL4DBptZ7CucQA3CO10AiAM5pqaQ0YgAAAAiNhDiHbvrmmIa8/IFMX4MRrD6NbTNbBIRWVVu7IesUDB9m2mM4eqLekHVy01K5IQBjWXkKW7pOf48J9ElMkivDeeWN/tjMgYQBRJCWjWXqPLrPsvX5N61W8/MPq6u1hc36B2n3rVVM+mDT6+g6fpC9AUKjlAiAs6OJDTiLM1PY+PIHMMCEKcMJAQDwJf1diZo/55KAK9WZQRowkNfCtfHlFBBif2kwZkDS2OwLTHsMf6o5Zsg6Oc44bgjA4NdxC09h4w9xYRyHIylx0iwl5F3aThhA5Gh+9i4FG2stVVMw4JPvmYVqe7WcDfqCfrc/JsegfEvU0r7312wIEBo59Z7CYmIAzvKRhAiAsyoVX/4AAACExOjczMDcWYWKjXU4SQMGy9mwfJslx/G7PCU7Je1ii4DQ+cOhI8b8IElJMqX+thiHjlRXG7LWkK5ObgjAOExhQ9SJGz4u0Xn5zLqY+ATCACJAV2uLfD9ZomDAZ416jh9U44PX6GTl22zOF/S7/THFT7DO1xrtB95gU4DQ8RIB8GU0sQFf4M5bmStpEUkAAAAYKyHOoWkTcxsmTRpK8xpCycq/yPWyPUBoGNkAlhdnztdlx4LGrFM0cTw3BGCsdUxhQzRyZAzOchbNq3OkMTwbiAQdVYfl37jK/Dr2b9Kn3hs5ovIsrNbA1nX8oDpPfMzGAKGTU+8p9BID8IXPIUQAfAkvFoCBxk+5kBAsbNr0As1fPEXzF0/RZZOGqaBg0Of+BwCMkpIYpznXFDQMHZbFb0AQalM3LN/mtmJhTGMDQseoBrDhOTlKDnaZ8hgqm1sNWcfM41CBCMUUNkStGGdKlvOK2f64QTltpAHYn3/XVnXs32TKtYMBn9rKl6n5+YfZiLOwWgObJAV2rGdjgNBbWu8pTCcG4O/iiAD4O3feykvEFDbAllypSYTQC9f9fxN73Gh4YM+HX/pn+/d8/uimj481aMf2SgIGIEk6Pz1JM6++yO+IddDAhnDxSnJbuLYdbBFgLKMawPKyh5j2GN6t+ciQdcw6DhWIUOtdnpIqi9ZWLKawIRwcjqSEcVfLkfZO08mDB7jnAJtrfv5h9b8gX45B+WG7ZrCxVr6fLFFH1WE24Is/YlNcSr3tB4obfZWl6goGfGrfv5MNAkIvTaf/MMVLFMBpNLEBn1dKBIA9DS8YrLf2HiWIMDhb09sX/9mBPR/SxAZAkjQ6NzNw5vhQfqOOcJq6Yfk298IVM3ZarTCXp2RnS9lTuyRNZZsA4xw9UW/IOsMGZJr2GCqPGPN5Jjs2VlInNwVgDK+Fa2MKG8IqbtglaY70AXXtB36bFew4SSCAjTWtWaz0Va8rxpka8mt1Ht2n5mfv4vjQs3CkuJR239qwNhR218ld69kzIIzv6+s9haWZZRWNRAFwnCjwN+68lW7xiyTAtvIKBxOChQzKZvoxAGnaxNyGMw1sgBm8Fq5tHdsDGOtPNccMWaegX4op9dcrVvUNn/Z5ncyM/sqkgQ0wimWnsPk3lxZLymGLEG6OjMFZzqJ5dY40hmwDdtbV2qKWsjtDfp32155V4xPfoRnqLOJzRyp91euWbGALBnxqe+0XbBIQPmli0A7w988cRAD8jZcIAPsaVTiIECxkcHYqIQBRLCHOoZu+OaZh6LAsfrMBM03dsHyb24qFuTwl6yRVs0WAMdpiHDpSbcxTakiMOY+hptOYxrOC4cO4IQDjeKkN+LIYZ0qW84rZ/rhBOW2kAdjXycq35d+0OiRrBwM+tTx/p1o2lhH0WSRNvU6p96wPyyS8Xt0bTGEDzLCo3lOYSwwATWyAJKawAZFgcHaqsjJSCAIATNbflaj5cy4JuFKdNLDBCqx8zJaX7QGMcSxozDrDc3KUHOwy5TFUt/oNWWds9gXcEIAxmMIGfBWHIylh3NXJ8cNGBwgDsK+2V8vVsX+ToWt2HT8o39OL1L7/TQI+i363P6bkBast28AWbKyl+RAwj5cIAJrYgM+sIwLA/grH8x0uAJhp5JB0/9xZhYqNdXCEKKxi9obl23KtWBjT2ADjVDa3GrJOXvYQ0x7DuzUfGbJOTkoSNwRgDCsf5+Nle2AV8fmXOxMvvaohJj6BMACbail/Ql3HDxqyVsf+TWpas1gdVYcJ9gscKS719/5K8RPmWLrO1l/9gM0CzMM0NkA0sQFy560sFn+9CITMgT0fhu1aU2eOIXAAMMnksUPqiiaP4DfnsCIvtQGRzagGsGEDMk17DLv3HTBknezYWG4IoO92uTwl71ixMKawwYpiBw7NcE6ZSyMbYFNdrS1qWfegggFf316jNq1W8/MPcwzlWSQUjFP6qtflGJRv6TpPvf8GE/QA85USAaIdTWwAvzgCIoZ71iglO+MJAgDCKCHOoTlX59fl5Q/MIg1Y1CKmsQGRrfLIUUPWKeiXYkr9xxzGNJ5lZvRXpjq5IYC+81q4tqVsD6woJsmVkfSNWwKOtAzCAGyoo+qwWn/+QK/+22DAJ98zC9X2ajlBnkXyzAVKvXuDZY8P/dw+vvAQGwaYb3a9p9BNDIhmNLEhqjGFDYg8k4pGEgIAhEl/V6LmXlNQl5HpooENVuelNiAy1StW9Q2fGrLWkBhzHkN14JQxn4VGF3BDAH23y+Up2WnFwvybS92SxrJFsCyHw+m8YnZbXPYoP2EA9tO+/021v/Zsj/6bruMH1fjgNTpZ+TYBfvFHYopL/W5/TElzltmi3tafP8AUPcA6vESAqH4NJQLwIgAglPbvORLW6833FBF6DwzKTicEAL1yfnqSZs8Y7U9JddLABjuw7DQ2SZskNbFFQO/UdBozeWx4To6Sg12mPIaqJp8h65h5HCoQQbzUBvSBw5GcMKYoKSF/PO9vARtq2VimzqP7uvXvduzfpE+9N9L4dBaxAwYq7b61ip8wxxb1nty9gWNEAWuZyjQ2RPVHCiJAtHLnrVwqprABEWdU4XkqKBhEEN00ODuVEAD02Mgh6f5Z146WI9aRRBqwEa8Vi3J5ShollbI9QO9Utxoz7CUve4hpj+HPfz1hyDpmHYcKRBCrT2GbyhbBLuKGXZKWeOlVDTHxCYQB2Ezzs3cp2Fh7zv9/MOBTW/kyNT//MGGdReKEK5X20EY5BuXbot6u4wfle3ENGwdYj5cIEK1oYkNUcuetTOeHPxAe7+49EvZr3nbvNQTfDVkZ/JILQM9Nm5jbUDR5BM1rsKNFG5Zvs+oI0lIxjQ3o3eeNmo8MWcfMKWa79x0wZB2zjkMFIoiX2gDjxA4cmuGcMpdGNsBmulpb5PvJEgUDX54WHGysle/pRfLv2kpQZ+Ga55Hr9h8rxmmPPxwPBnxqWrOYjQOsiWlsiFo0sSFaLZWURgxA6J34uDns1xw/5UKmsXXDgIH9QrZ2bY2PgIEIkxDn0MyiEXVDh2VlkAZs/jnAcpjGBvRe5ZGjhqxj1hSzQwZ9NWfmcahAhKhmChtgvJgkV0bSN24JONL4GAnYSUfVYfk3rvrcP+s8uk+NK25QR9VhAvoCR4pLaXc9o8Rrl9im5mDAJ9/TizgOFrA2LxEgKl9XiQDR5swUtqUkAYRHXUOrWprbw35dprF9vbGThods7eM1jQQMRJCUxDjNuaagYdDg9CzSgM0tZRobEDmOOWJV3/CpIWuZNcWsqs2Yz0pmHocKRAgvtQEh4nA4nVfM9scNymkjDMA+/Lu2qmP/JklS+2vPqvGJ79DwdBbxuSOVvvxlxY2+ylZ1t/78ARoSAeubWu8pLCYGRN3HByJAFGIKGxBmf3rvRNivOX7KhZo2vYDwv0Je4WBCAPC1+rsSdeP1F/tdqU7+dB6RIE1MYwMiRnXglCHrmDnF7C8Nxvzxh5nHoQKR8OPE5SlZZ8XC/JtLc8UUNkQChyMpYdzVyfHDRgcIA7CP5ucfVsvzd6plYxlhnEXS1OuUes96xaTb63v2tvJlat//JhsI2IOXCBB1Hx2IANGEKWyAOfbvOWLKde9dNUvJzng24BxGFQ6KuD0HYKyRQ9L9s2eOaXPEOpJIAxHE6tPYAHRTVZMxR9ibOcXs0EfHDVnHrONQgQjhpTYgPOLzL3cmXnpVA0kA9kGz09ml3nqfkhesVowz1VZ1t5Uvk3/XVjYQsI8cprEh2tDEhmjDFDbABEcqa025rqtfou5fNZcNOIusjBQNzg7dB+yWZj8hAzY3OjczUDR5RJLDEZNMGogwVp/Gtp4tArrnz381ZuKzmVPM3q38wJB1zDoOFYgAVp/CtogtQqSJHTg0wzllbl1MfAJhALAdR4pL/b2/UkLRQtvVTgMbYFteIkBUvdYSAaIFU9gA87y196h5z/1ZozhW9CyumJYf0vWPfFBLyICNTZuY2zBp0lAnSSCCWXkam5ftAbpn974Dhqxj1hSzQwZ9LWfmcahABPBSGxB+jn4ZWc4pcxscyS7CAGAb8bkjlb7qdTkG5duudhrYAFtjGhui67MCESCKMIUNMNGBPR+adu17V81STnYGm/APrpoe09IAACAASURBVJ8/IaTrVx2tI2TAhhLiHJpZNKJu6LAsfmgi0qVJmmPFwlyekioxjQ34WsccsYatZdYUs8rmVkPWuXTUcG4IoHeYwgaYKCbJleG88saAI42PnwCsL3nmAvVbttF2x4dKNLABEcJLBIgWNLEhKjCFDTDfzv/6o2nXdvVL1OoX/lnJzng2QqePEh1VeF7I1m9pbldboIOgAZtJiHNozjUFDYMGp2eRBqKEl9oA+6oOnDJkHTOnmB09UW/IOkMz0rkhgN5Zx3sBwGQOh9N5xWx/3KCcNsIAYMkfUyku9bv9MSXNWWbL+mlgAyIG09gQPa+9RIAoUSqmsAGm+v2Og6Zef3B2qkpf/A4bIWn67HEhXX//7mpCBmymvytR8+dcEnClOvkTeESTnA3LtxVbsTCmsQFfr6rJZ8g6Zk4x+1PNMUPWyU1O5IYAeq5Jp78vtBymsCHqOBxJCeOuTo7LHuUnDABWEjtgoNLuW6v4CXNsV3sw4FPL83fSwAZEFi8RICo+HhABIp07b2Wu+OIHMF1dQ6sOVXxiag2jCs/TvY98K+r34voF40O6/p8qarnhARs5Pz1Js2eM9sfGOpykgSjkpTbAnv5wtMqQdcyaYtYW49CRamP++GOUurghgJ4rdXlKGi1aWzHbg2iUMKYoKeHiyXUkAcAKEidcqbSHNsoxKN92tQcDPvmeXqT2/W+ykUBkYRobogJNbIgGXiIArGHLS/tNr+H6BRdHdSPbtOkFGpydGtJrvLv3CDc7YBMjh6T7Z107Wo5YRxJpIEpZfRrbZrYIOMd7zsoPDFnHrClmx4LGrDO24CJuBqDnrDyFLV3SUrYI0SpuSH5W4qVXNZAEAFM/j8/zyHX7jxXjTLVd7V3HD6rxwWvUUXWYjQQik5cIEOloYkNEYwobYC2/feU9S9QRzY1st98/PaTrtzS3q7LyODc7YAOjczMDRZNH0LwGWPvLn1K2B/iyQwZ+nWXWFLPK5lZj6r9gEDcE0IvXVwtPYVsqKY0tQjSLHTg0wzllbl1MfAJhAAgrR4pLaXc9o8Rrl9iy/o79m9S0ZrG6WlvYTCByMY0Nkf96TASIcF4iAKyjLdChLeU0spll/uIpIZ/Ctn93NTc6YAPTJuY2TJo0lONDgdOsPI1tp6RdbBHweVVt7YasY+YUs3drPjJkHbOOQwVsjClsgA04+mVkOafMbaCRDUC4xOeOVPrylxU3+ipb1u/ftFrNzz9MAxsQHbxEgIj+LEAEiFRMYQOs6dVf7bNMLdcvuFjep25SsjM+4nPPykjRLXdcEfLr7Hr1j9zkgIUlxDk0bWJuw9BhWRmkAXxOsYVr87I9wOf9pcGYAUpmTjGrPHLUkHXMOg4VsLF1TGED7CEmyZWR5L65yZHGx1cAoZU09Tql3rNeMemDbVd7MOCT75mFanu1nI0EogfT2BDRaGJDJPMSAWA9lZXHdWDPh5apxz1rlEpf/E7EN7ItW/NtufqF/hdce3cf5iYHLCohzqE51xTQwAac3dQNy7e5rVgY09iALzv0kTHH15s1xaxesapv+NSQtcw6DhWwMaawAXYSn5DmvGK2n0Y2AKGSeut9Sl6wWjHOVNvV3nX8oJp+ME8nK99mI4Ho4yUCRCqa2BCRmMIGWNvW/9hnqXpGFZ6nX+5eqpzsyPxCbP7iKRo/5cKQX+fAng/VFujgBgcs6LMGNleqk2/+gXPzUhtgD+9WfmDIOmZNMavp7DRknaKJ47kZgJ5Z7/KUVFm0tmIxhQ04O4cjyXnF7La47FF+wgBg2I+WFJf6e3+lhKKFtqy/Y/8mfeq9UZ0nPmYzgejENDZE7ms0ESBCeYkAsK4d2ytVW+OzVE2ufolav/0OXX9DZP0i6LJJw+R5wB2Wa1mtORHAaf1diZo/55IADWzA12IaG2ADhwz8KsusKWbVrcb8Dn7E+QO4IYCe8Vq4NqawAV/F4UhOGFOURCMbACPE545U+qrX5RiUb8v628qXqfn5h9lIAF4iQES+9ScCRBqmsAH2UPpvWyxZ172rZurJFxZFxPGiOdkZWv7sDWG7HkeJAtbT35Wo2TNG+2NjHU7SALrFa+Ha1rE9gFTZ3GrIOmMLLjLtMbxb85Eh6+SmpXJDAN1n2Sls/s2lxZJy2CLg6yWMKUqKHzY6QBIAeitp6nXqt2yjLY8PDTbWqnn1PPl3bWUjAUhMY0OEookNkchLBID1vbX3qA7s+dCStY2fcqF+uXupLps0zL7vXLMz9OOXb5OrX3iOSNpS/h5HiQIWkz3A1TZ7xmi/I9aRRBpAt1l5Gts6SdVsEaLd0RP1hqwz6oJBpj2G3fsOGPOe3xnHDQF0n5fagMgQn3+5M/HSqxpIAkBPOFJc6nf7Y0pesNqW9Xce3afGFTeoo4o/JAfAZwlE+Gs2ESCSMIUNsJcXnnzdsrW5+iXqhxsWyPvUTcrKSLFVruFuYJOkV3/FUaKAlYwcku6/elp+Mg1sQK9Y+TgvL9uDaPenmmOGrDM0I92U+o85Yg1ba0hXJzcE0D1MYQMiTOzAoRk0sgHo9s+MAQOVdt9axU+YY8v6T+7eoMYnvqOu1hY2E8AXMY0NEYcmNkSapUQA2Edl5XFtKX/P0jW6Z43Sutfu0PzFU2yR6WWThoW9ge3Ang9VWXmcGxqwiJFD0v1Fk0fQvAb03uwNy7flWrEwprEh2rXFOHSk2pinQG5yoimPoTpwypB1iiaO54YAuq/UwrV52R6gd2IHDs1wXj6zLiY+gTAAnFNCwTilPbRRjkH5tqs9GPCp5fk75XtxDRsJgM8UiBo0sSFiuPNWpksqJgnAXn7yxKtqaW63dI2ufonyPOBW+fa7NW16gWXrnL94in64YUFYG9gkaet/MIUNsIqJFw36Kw1sgCG81AZYz7GgcWuNUpcpj6GqyWfIOiPOH8ANAXTPLpen5B0rFsYUNqDvHBmDs5xT5jbQyAbgbFzzPEq9e4NinKm2q73r+EH5nl6k9v1vspEAvg7T2BBZ7/GJABFkqaQ0YgDspS3QobLH37BFrYOzU/XIs/Ms18yWk52hn/6nR54H3GG/dm2NTzu2V3IjAxYwbWJuQ+HFF5xPEoAhFjGNDbCeyuZWQ9YZW3CRaY/hz389Ycg6uWmp3BBA93gtXBsnSgAGiElyZdDIBuAfOVJcSrvrGSVeu8SW9Z96/w01rVmsjqrDbCaASPjcA/TsdZwIEAnOTGHjix/Apra8fEAH9nxom3q/2MyW7Iw3pY5kZ7zmL56i9dvv0KjC80yp4fkfbucGBixg2sTchqHDsjJIAjCUl9oAazl6ot6QdUZdMMi0x7B73wFD1slxxnFDAF9vl8tTstOKhfk3l7oljWWLAGPEJLkynEXz6hxpfCwGol187kil3bdWcaOvsmX9/k2r1fSju9XV2sJmAujR1wRMY0PEvLcPBoOkANtz5630SnqEJAD7SnbG65e7l4b9KEwjtDS36ze/eEevbTyg6pqGsGQ1e/4k3XLHFabmVVvj04Lpz3DzAiZKiHNo8rhsGtiA0Bm6cMWMKsu99yh7Kl1SlZhEjShzzBGrtq6+f4+VqRhlqjPs9bfFOPR6kzHT5Ob04/RwoBumWbiJbaekqWwRYLCuLn/g95uTupoayAKIQklTr1PSvAdteXxoMOBTS9mdOln5NhsJoLeqM8sqcokBdkcTG2zvzBS2KvELHMD2Lps0TD/csMDWj6G2xqedr1SGpKHtsknDVDRjjK5fcLElHusdc19QZeVxblzAJAlxDs25pqDBleqkgQ0InfULV8wotmJhLWVPecUf8gAAcC67XJ4StxULOzOFbQdbBIQIjWxAVEq99T4lFC2054+t4wfV/Nz31XniYzYSQF8tziyrWEcMsDOa2GB7TGEDIst3l07Xgu9NiojH0tLcrv27q/Wnilq9u/eITnzcrLqG7k9eKCgYpOEXDdb4ycM1oSjHUlPqDuz5UPfetp4bFjAJDWxAWPVfuGJGo+XeZzCNDQCAr8IUNiCa0cgGRA1Hikv9lvxIscMm2rL+jv2b1Pz8w2wkAKMwjQ22RxMbbI0pbEBk+ul/ejSq8LyIfXyHKj6Rrynwt//7TxW1yisc/Lf/O+/iAZY/VvXbVzzdo4Y8AMahgQ0Iu0cXrpjhtWJhTGMDAOCsql2eklwrFsYUNiCMurr8J999I3jqeHUyYQCRKT53pFLvWW/L40Mlqa18mfy7trKRAIw2N7OsYhMxwK7iiAA2t1Q0sAGR98S+9Wf6P1vu0ODs1Ih8fF9s0Bs/5UJb1V/2+E4a2ACT0MAGmPPWZMPybaVWnMYmqZTPRAAAfImX2gDI4UhKGHe1FL/bf6rmUBKBAJElaep1Sl6w2pa1Bxtr5fvJEnVUHWYjAYTCUkk0scG+b+OJAHZ1ZgrbUpIAIk9boEPLbvu5WprbCcNiDlV8opfW7iEIwAT9XYmaP+eSAA1sQNilWfVzh8tT0qjTjWwAAOC0apenZJ0VC/NvLs0Vx4gCYZcwpigpLnuUnySAyOBIcanf7Y/ZtoGt8+g+Na64gQY2AKE0td5T6CYG2Pa1nghgY3PExAEgYlXXNOj+RS8ShMX8oORXhACYoL8rUbNnjPbHxjqcpAGYYumG5dvSLVobTWwAAPydl9oAfBGNbEBkiB0wUGn3rVX8hDm2rP/k7g1qfOI76mptYTMB8NkDOAea2MAPXwCWVVl5XI8u2UgQFvHkg6+quqaBIIAw+6yBzRHr4PgTwDxWn8a2ni0CAMDyU9gWsUWAeWhkA2z+HC4Yp7SHNsoxKN92tQcDPrU8f6d8L65hIwGEC9PYYFs0scGW3HkriyXlkAQQ+XZsr6SRzQJ2vnJIW14+QBBAmNHABliKlaexedkeAACYwgbgq9HIBtiTa55HqXdvUIwz1Xa1dx0/KN/Ti9S+/002EgCfQYBuoIkN/NAFYHk0spmrtsanHz74a4IAwowGNsBy0iRZ8swSl6ekSkxjAwBEN6awAeiWhDFFSQkXT64jCcD6HCkupd31jBKvXWLL+k+9/4aa1ixWR9VhNhOAGabWewovIQbY7vWfCGA3TGEDohONbOZoaW7Xstt+rrZAB2EAYUQDG2BZXmoDAMCS1vEaDaC74obkZyVeelUDSQDWFZ87Umn3rVXc6KtsWb9/02o1/ehudbW2sJkAzLSUCGA3NLHBjrxEAEQnGtnC78kHX1F1Dd/pAeFEAxtgaTkblm8rtmJhTGMDAESxJkmlViyMKWyAdcUOHJpBIxtgTUlTr1PqPevlGJRvu9qDAZ98zyxU26vlbCQAK1hU7ynMJQbYCU1ssBV33kq3mMIGRLUd2yu1aPpzamluJ4wQe/LBV7VjeyVBAGF0fnoSDWyA9XmpDQAASyl1eUoaLVpbMdsDWBeNbID1pN56n5IXrFaMM9V2tXcdP6imH8zTycq32UgAVuIlAtgJTWzghywA26muadCdN7yg2hofYYTIlvL3tOXlAwQBhNHIIen+WdeOFg1sgOUxjQ0AAOuw8hS2dHF8D2B5NLIB1hGfO1IJRQttWXvH/k361HujOk98zEYCsBqmscFWaGKDbZyZwjaVJABIpxvZ/uX653So4hPCMNiW8vf05KO/IQggjEYOSfcXTR5B8xpgH14L17aO7QEARBErT2FbKimNLQKsj0Y2wBo6qg6r/bVnbVd3W/kyNT//MBsIwMq8RAC7oIkN/HAFYFttgQ5999tlKv/JXsIwCA1sQPjRwAbYkpWnse2UtIstAgBEAaawATAMjWyANbRsLNOp99+wRa3BgE/Nq+fJv2srGwfA6ubUewrTiQF2QBMbbMGdtzJXTGEDcA4/Ld2uR5dsVEtzO2H0AQ1sQPjRwAbYWrGFa/OyPQCAKLCOKWwAjEQjG2ANvhceUrCx1tI1dh7dp8YHr1FH1WE2DIAdpIk/soFN0MQGu/ASAYCvsmN7pYqv5XjR3qKBDQg/GtgA25u6Yfk2txULYxobACBKMIUNgOFoZAPM19XaIt9PligY8FmyvpO7N6jxie+oq7WFzQJgJ0uZxgY7oIkNlndmCtsikgDwdeoaWvXdb5ep7PGdhNEDTz74Kg1sQJjRwAZEDC+1AQBgivUuT0mVRWtjChtgczSyAebrqDos/8ZVlqopGPCprXyZfC+uYYMA2FGarH2yBCCJJjbYg5cIAPTES2v3aNF0prJ9nZbmdj26ZKO2vHyAMIAwooENiChMYwMAwBxeC9dWzPYA9kcjG2A+/66tOrl7gyVq6Tp+UL6nF8m/aysbA8DOmBgNy6OJDZbmzluZLmkOSQDoqeqaBqayfYXaGp/uvOEF7dheSRhAGNHABkQkr4VrK2V7AAARyLJT2PybS4sl5bBFQGSgkQ0wn+/FNeo6ftDUGk69/4aa1ixWR9VhNgSA3eXUewqLiQFWRhMbrI7x+wD65KW1e/TtK57WgT0fEsYZO185pH+5/jlV1/AdHBBO/V2JmnzF8CBJABHHytPYNkmqZosAABHGS20AwoVGNsB8TWsWKxjwmXLt9teeVdOP7lZXawsbAYDPU0AY0MQGyzozhY2RlgD6rK6hVffetl73LyxXbY0vanP47PhQb8kv1Rbo4MYAwqi/K1GzZ4z2OxwxyaQBRCQrf27xsj0AgAjCFDYAYUcjG2CurtYW+Z5eFNZrBgM++Z5ZqJaNZWwAgEiTU+8p5CQ8WBZNbLCyYjGFDYCB3tp7VAumP6Oyx3eqpbk9qh77gT0fqvja5zg+FDDB3xrYYh0cIwpErtkblm/LtWJhLk/JOjGNDQAQOax8VLaX7QEiF41sgLk6qg6rrXxZWK7Vdfygmn4wTycr3yZ4AJGKQUKwLJrYwA9PAFHnpbV7dFNRaVQ0s9XW+HT/wnLde9t61TW0svlAmNHABkQVL7UBABBSu1yeknesWBhT2IDoEDtwaEZC/vgmkgBMer3dtVUd+zeF9Bod+zepac1idZ74mMABRLKp9Z5CNzHAimKCwSApwHLceSuLJa0lCQChluyM1+z5k3TLHVfI1S8xYh5XS3O7fvHc77X5pb0cHQqYhAY2ICoNXbhiRpUl3xuUPVUlfrkOALC3aS5PyU4rFubfXMrrLBBFTv5xt/9UzSE+6wMmcKS4lHbfWjkG5Ru+dlv5Mvl3bSVkANFic2ZZBceKwnqv9UQAi2IKG4CwaAt0/G0y26NLNqq2xmfrx9PS3K6yx3fqpqJSvbR2Dw1sgEloYAOilpfaAAAIiV0WbmBziwY2IKokjClKisse5ScJIPy6WlvU/Nz3FQwY9z1+MOBT8+p5NLABiDaz6z2FucQAq2ESGyzHnbfSLWkHSQAwS0HBIN30L0Vyzxplm5qZvAZYBw1sQNSz8jS2RklpbBEAwIasPIVtp6SpbBEQfZjIBpgnoWCcUu/e0Od1Oo/uU/Ozd6mrtYVQAUSj9ZllFcXEACuhiQ2W485buVN88QPAApKd8frGrIt1/fwJGlV4niVr3PnKIe169Y/asb2SDQMsgAY2AJLWL1wxo9iKhbWUPeWV9AhbBACwmV0uT4nbioWdmcLGH+MCUYxGNsA8rnkeJV67pPfP390b5HtxDUECiHb9M8sqGokBVkETGyzFnbfyEklvkwQAq8nKSNEV0/I1fvJw0ye0Har4RFte2q/f7ziouoZWNgewiIQ4h+ZeU1CXkurMIg0g6vVfuGKG5b78aSl7Kl1SlZjGBgCwF6awAbA0GtkA86Td9YziRl/Vo/8mGPDJv3EVx4cCwGmPZpZVeIkBVkETGyzFnbdynaRFJAHA6goKBmnspOGaMGW4xk/5/9m79+Co7jvP+58+fZXUSK2WkATRpSUuLSRkCTDmKmiMjTGOjexcJk5wUC4b7TiVJwxbW7PPPLVOj0u7O1uZ3SE1W5mH7CSDSTKTOBeb+IazdgYCT4LHjmEGjAO+IIxtjJEaBLbuaj1/CGHAEkh9Pd3n/apylZH6dP/0+Z3uPqf7e76/iqQ+1vHDZ3Xs8Gm9/LvX9cK+11guFDAhl8NQy7q6iHeax08aACT95RcfXh8248DoxgYAyDAnvW1bA2YcGF3YAFxp4OBzPUOnT+aSBJBaRp5XBf/xH2TMqJ3U7aOn/6gPdvyFBjteIzwAGNUtKUA3NpgFRWwwjVCwPSDpBEkAyERVlX6VzvBpVt1Mzaz0a2ZloWZU+jSzctqk7+P44bO62N2nY4ff1elTEb3x6rvqeLOTojXA5ChgAzCObkkBurEBABC3L3nbtu4w48DowgbgKtFob9/vd+VEuyNkAaSYMzBH0/7sEdk81/8sfuiV3+ji9/8fRT/8gNAA4JrzrqLth3cQA8yAIjaYRijYHhYdAQBksbq6GVf9+8MP+nXyLT7YAjIZBWwAroNubAAAxMfMXdiaJB1kigBchUI2IG1yVn9SuZ//bxP+vv/Z/6UPfrmdoABggnOvou2HA8QAMzCIAGYQCrb7JG0hCQDZ7OjR01f9RwEbkPk2hOZ2UsAGYAJbdj6022fSsW3TaLc4AADMLGzm93mmB8DHGEaOZ9nGXqOAjwmAVOvd+6QG9u382M9H+i7q4ne+SAEbAFxfVVdbQysxwBSH1EQAk2gVy9kAAIAMsmZxIOIv8haTBIAJFMikX3B727ael/Q4UwQAMLGTJl5GNCBpM1MEYFxjhWy5XrIAUuzij76t4TdfvPzv6Ok/qvu/3KeBozRPBYBJaCUCmOJwmghgEly9CAAAMsaaxYFIdU0xl1YDuOF5jom7sYWZHgCAiYUZG4CMZRg57iV3RWxOF1kAKXbhf/1fGum7qMGXHlf3t7+k4fffIxQAmJzVXW0NIWJA2g+liQDpFgq2t0qqIgkAAJAJKGADMAUFklrMODBv29YOSY8wRQAAE6ILG4CMZ8vx+j0r76WQDUix6Icf6PxfrNOF//2fFf3wAwIBgKlpJQKkG0Vs4MUQAABgkuoDRX0UsAGYojBjAwBgSnbw3gkgG1DIBqQHxWsAELPNXW0NAWJAOlHEhrQKBdtDklaTBAAAMLs55b7eJUuqPSQBYIqqdj60u9WMA6MbGwDAhLolbTPjwOjCBiAWthyv371obSdJAACADLGFCJBOFLEh3VqJAAAAmN2ccl9v84rZOSQBIEZhxgYAwKRs87ZtPW/SsfFlDoCYGP6Zxe6Ft0ZIAgAAZIDWrrYGHzEgbcfORIB0CQXbA+LqRQAAYHKFXrcoYAMQJ7qxAQBwY2buwuYTF+MCiIO9rNpPIRsAAMgABZz7IJ0oYkM6cfUiAAAwtUKvWxvX1/eSBIAECJt4bDuYHgCACZi9C1sBUwQgHvayar+zpr6PJAAAgMlRx4G0oYgNaREKtnP1IgAAMLWxAjbDbtCFDUAimLkb2x5Je5kiAEAamb0LG1/iAEgIZ+1Sj6NyLhfLAQAAM6vqamtoJQakA0VsSJdWcfUiAAAwKZfD0LpVczopYAOQhPMgswozPQCANKILGwDLcM1vznHMqOohCQAAYGKtRIB0oIgN6cLViwAAwJRcDkMt6+oiedM8xaQBIMFW73xod8iMA6MbGwAgzXaYcVB0YQOQLK7GW21GgZ8gAACAWa3uamtoIgakGkVsSLlQsL1FUhVJAAAAM9oQmtvpnebhk2QAyRJmbAAAXOURb9vWDpOOjS5sAJLDMHI8yzb2UsgGAABMjAt6kPrDZCIAL3YAAACj1iwORPxFXjqwAUgmurEBAHC1sInH1sr0AEgaw8jx3HJXt83pIgsAAGBGm7vaGgLEgJQeIhMBUikUbG+StJokAACA2axoLO+srinmEmgAqRA28di2MT0AgBQybRe23l3bWsVqEgCSzekq8Ky8N0IhGwAAMKlWIkAqUcSGVKMLGwAAMJ055b7eYG0ZHdgApIqZu7E9LukkUwQASJEwYwNgdbYcr9+95K5OkgAAACZEfQdSiiI2pEwo2O6TtJkkAACAmcwp9/U2r5idQxIAUszMHwCFmR4AQArQhQ0ALjHy/cXuhbdGSAIAAJhMQVdbQysxIGXHxUSAFKJKFwAAmEqh160Vy2aNkASANNi486HdATMOzNu2dYfoxgYASL4wYwOAj9jLqv2u2kXdJAEAAEyGOg+kDEVsSKVWIgAAAGZR6HVr4/r6XsOw5ZIGgDQJMzYAgEXtpQsbAHyco6apwFE5t5ckAACAiTR2tTWEiAGpQBEbUiIUbG8VH/4AAACTcDkMrVs1p9OwGywjCiCdNtONDQBgUWHGBgDjc81vzrEXlREEAAAwk1YiQCpQxAZe1AAAgOW0rKuL5E3zFJMEABMIMzYAgMXs9bZt3WPGgfXu2hYSF+ICMAH34jt7jQI/QQAAALPY3NXWECAGJBtFbEi6ULC9SdJqkgAAAGawZnEg4p3m4ZNgAGZh9m5s3UwRACDBwowNAG7AMHI8yzb22ZwusgAAAGbRSgRI+mEwESAFthABAAAwgxWN5Z3VNcUUsAEwm7CJx7aN6QEAJJDZu7BxIS4A8zAMj2flvREK2QAAgElQ94HkHwITAZIpFGz3SdpMEgAAIN3mlPt6g7VlLCEKwIw273xot8+kY9smurEBABInzNgAYPJsOV6/e9HaTpIAAAAmUNDV1tBKDEgmitiQbFTjAgCAtCv15ah5xewckgDAudPUeNu2nhfd2AAAifGvdGEDgKkz/DOL3QtvjZAEAAAwAeo/kNxjXyJAkrUSAQAASKdCr1t33javlyQAmNwWurEBALKcmYuiw0wPADOzl1X7HZVz+WwDAACkW2NXW0OIGJAsFLEhaULB9hZJVSQBAADSxeUwtOG2ed2G3aALGwCzKxDd2AAA2eukt23rDjMOrHfXtibRhQ1ABnDNb85xzKjqIQkAAJBmrUSAZKGIDclEK0kAAJBWLevqIm63o4AkAGTKORTd2AAAWSps5vdfpgdApnA13mozCvwEAQAA0mlzV1uDjxiQDBSxISlCwfaAuIIRAACk0ZrFKgCoIgAAIABJREFUgYh3modPdgFkErN3Y3ucKQIAxMDMXdgCkjYzRQAyhmHkeG65q9vmdJEFAABIJy4GQnIOd4kASRImAgAAkC6Lasu6q2uKKWADkInM3I2N8zwAQLa9f/DeBiDzOF0FnpX3RihkAwAAadRKBEgGitiQcKFgu09SC0kAAIB0mFPu621sLGcJUQCZqsCs51Petq0dkh5higAAU0AXNgBIAluO1+9qWBkhCQAAkCZVXW0N1IQg4ShiQzK0aPSLFwAAgJQq9Lq1YtmsEZIAkOHCjA0AkCW28Z4GAMlhL6v2u2oXdZMEAABIE5YURcJRxIZkCBMBAABINZfD0D3r6/sMw5ZLGgAyXNXOh3a3mnFgdGMDAExBt6QdZhwYXdgAZAtHTVOBo3JuL0kAAIA0WN3V1hAgBiQSRWxIqFCwPSSpiiQAAEAquRyGWtbVRex2w0MaALJEmLEBADLcNm/b1vMmHRsdAwBkDVfdihGjwE8QAACAcytkPIrYkGitRAAAAFJtxYLKiHeah09sAWQTurEBADJZt0y6lGjvrm0+8RkmgGxiGLmeW+7qtjldZAEAAFKttautwUcMSNihLREgUULBdp9oww8AAFKsPlDUV11TTAEbgGwUNvHYdjA9AIDrMHsXtgKmCEBWcboKPCvvjRAEAABIsQJJLcSARKGIDYlEq0gAAJBSlSXeniVLqllCFEC2MnM3tj2S9jJFAIBxmL0LG59hAshKthyv373wVgrZAABAqnGOhYShiA2J1EoEAAAgVQq9bt26aq6NJABwnpU2YaYHADAOurABQJrYy6r9zpr6PpIAAAAp1NjV1tBEDEgEitiQEKFge4ukKpIAAACp4HIYWrdqTqdhN3JIA0CWW73zod0hMw6MbmwAgAnsMOOg6MIGwCqctUs99qIyggAAAKnEuRYSgiI2JEorEQAAgFTZEJrbmTfNU0wSACwizNgAABniEW/b1g6Tjo0ubAAsw734zl4j10sQAAAgVTZ3tTX4iAHxoogNcQsF2wOSNpIEAABIhRWN5Z3+Ii8FbACshG5sAIBMETbx2FqZHgCWYRg57iV3RWxOF1kAAADOuZA5h7FEAF6MAABApphT7usN1pZRwAbAisImHts2pgcAIBN3Yevdta1VUhVTBMBKbDlev6thZYQkAABAirCkKOJGERsSoZUIAABAshV63VqxbNYISQCwKDN3Y3tc0kmmCAAsL8zYAMBc7GXVfmdNfR9JAACAFKjqamsIEQPiQREb4hIKtreIqxgBAECSuRyGNtw2r9swbLmkAcDCwowNAGBSdGEDAJNy1i712IvKCAIAAKRCKxEgHhSxgRchAABgehtCczvdbkcBSQCwuNU7H9odMOPAvG1bd4hubABgZWHGBgDm5V58Z6+R6yUIAACQbJu72hp8xIBYUcSGmIWC7QFJG0kCAAAk04rG8k5/kbeYJABAEkUCAADz2UsXNgAwOcPIcS+5K2JzusgCAAAkWysRIObDViIALz4AAMCsKku8PcHaMgrYAOAjm+nGBgAwmTBjAwDzs+V4/a6GlRGSAAAASbaFCBAritgQj1YiAAAAyVLodevWVXNtJAEAHxNmbAAAk9jrbdu6x4wD6921LSS6sAHAVexl1X5nTX0fSQAAgCSq6mprCBEDYkERG2ISCra3iA+BAABAkrgchtatmtNp2I0c0gCAjzF7N7ZupggALCPM2AAgszhrl3qMAj9BAACAZGolAsSCIjbwogMAAExn7bKazrxpHpYRBYCJhU08tm1MDwBYgtm7sK1migBgfJ5lG/tsThdBAACAZNnc1dbgIwZMFUVsmLJQsD0gaSNJAACAZKgPFPXNmOmjgA0Ars+03dg0WsRGNzYAyH5hxgYAGcowPJ6V90YIAgAAJFErEWDKh6lEAF5sAACAWZT6crRkSbWHJAAgc8/NvG1bz4tubACQ7f6VLmwAkNlsOV6/66YVnSQBAACSZAsRYKooYkMsWokAAAAkmsthaP1t8/pIAgAmbcvOh3abtS0/3dgAILuZuVg5zPQAwOQ4ymuLHTOqekgCAAAkQVVXW0OIGDAVFLFhSkLB9hZJVSQBAAASbUNobqfdbtCFDQAmr0AmvaKRbmwAkNVOetu27jDjwHp3bWsSXdgAYEpcjbfajAI/QQAAgGRoJQJMBUVs4EUGAACk3YrG8k5/kbeYJABgyujGBgBItbCZ3xeZHgCYIsPIcS9a12lzusgCAAAkWktXW4OPGDDpQ1MiwGSFgu0BSRtJAgAAJFJlibcnWFtGARsAxMbs3dgeZ4oAIKuYuQtbQNJmpggAps7mySt2NayMkAQAAEiwAkktxIDJoogNU8GLCwAASKg8t0O3rpprIwkAiIuZu7GFmR4AyCphxgYA2cleVu13VM7tJQkAAJBgdMzGpFHEBl5cAABA2ty1tjZi2I0ckgCAuBRIajXjwLxtWzskPcIUAUBWoAsbAGQ5V92KEaPATxAAACCRGrvaGpqIAZNBERsmJRRsD0mqIgkAAJAoKxrLO73TPHwyCgCJYeaLjsJMDwBkhW281wBAljOMXM8td3XbnC6yAAAAidRKBJjU4SgRgBcVAACQapUl3p5gbVkxSQBAwlTtfGi3Kc/b6MYGAFmhW9IOMw6MLmwAkGBOV4F70dpOggAAAAnUSgSYDIrYcEOhYLtPUgtJAACARMhzO3Trqrk2kgCAhAszNgBAkmzztm09b9KxbWF6ACCxDP/MYmdNfR9JAACABCnoamtoJQbc8DiUCDAJLZIKiAEAACTCXWtrI4bdyCEJAEg4urEBAJKhWyZdSrR31zafuKIfAJLCWbvUYxT4CQIAACQK5264IYrYMBlczQgAABJiRWN5p3eah09AASB5wiYe2w6mBwAyktm7sHHxLQAkieeWu7ptThdBAACARFjd1dYQIAZcD0VsuK5QsD0gqZEkAABAvCpLvD3B2rJikgCApDJzN7Y9kvYyRQCQUczehY2LbwEgmZyuAlfDyghBAACABGklAlwPRWy4ET4IAgAAcctzO3Trqrk2kgAAy5/HhZkeAMgodGEDAIuzl1X7HZVze0kCAAAkQCsR4HooYgMvIgAAIOnuWlsbMexGDkkAQEo07nxod8iMA6MbGwBknB1mHBRd2AAgtVx1K0aMAj9BAACAeFV1tTWEiAEToYgNEwoF21vE1YwAACBOi2rLur3TPHzSCQCpFWZsAIA4PeJt29ph0rHRhQ0AUskwct2L1nXanC6yAAAA8WolAkx42EkE4MUDAAAkS6kvR42N5Xy5BACpt5pubACAOIVNPLZWpgcAUsvmySt2zlvcSRIAACBOLV1tDT5iwHgoYsO4QsF2n6SNJAEAAGLlchhaf9u8PpIAgLQJm3hs25geADA103Zh6921rVVSFVMEAKnnKK8tdsyo6iEJAAAQhwJJLcSA8VDEhom0EgEAAIjH2mU1nXa74SEJAEgbM3dje1zSSaYIAEwrzNgAAONxNd5qM3K9BAEAAOKxhQgwHorYMJFWIgAAALGqDxT1zZjpKyYJAEi7MGMDAEwRXdgAABMzjBzXwttZVhQAAMSjsautIUAMuJZtZGSEFHCVULC9SdJBkgAAALEo9Lp1710NBAEA5lH9xYfXd5hxYB9s/58dohgBKeQor/jYz4ziEtnc7gm3sc8oT9jjR7vOamSgf8LfD79z6uM/O/u+Rvr7mTyk9H3DxEVsvG8AgEkMvXmoe+CPfyggCQAAEKPvFG0/TEc2XMVBBBhHKxEAAIBYuByG1q2a0ymJLmwAYB5hE5/nhSX9A1OEqbC53bJPLxn9f5dbxqX/l64pOHO5ZRRON9XYjdLrF8Q5m5be8D5GPrygkQ8uXP73lYVx0QvdGrl44fL/Ry9cYIfBVO2lCxsAYDIcNU0FQ6dPKNodIQwAABCLFrGsKK5BJzZ8TCjYfl4SV88AAIApW9FY3hmsLaOADQDMh25sML0ri9PGuqPZvPkypuWP/qy0nJBiFD13Vhro18hAv6JdZ0d/dvb90X9T7IarrfG2bd1jxoHRhQ0ATGhwoLt3z08LRgYHyAIAAMR0Dlq0/fAeYsAYOrHhKqFge4soYAMAADGoLPH2UMAGAKYVFt3YkGZjRWq2afky8gs+KlAzYce0bHNlvvaKWePeZmSgXyPnzl4udBvp71e0c3Qp0+Gz7xOiNew1cQFbSBSwAYD5OF0FroaVkf6Xf+MnDAAAEINWSXuIAWPoxIarhILtj0vaSBIAAGAqXA5D97c09dnthoc0AMC06MaGpDPyRwvUxjqp2WeUU6SWJcaWMR1bvnT4nVMUuGUfM3dh2yNpNVMEAOY0cPC5nqHTJ3NJAgAATFG3pEDR9sPniQISndhwhVCw3ScK2AAAQAw2hOZ22u0GXdgAwNzCMm83th2SvsUUZQ779BIZ0/JlTC+53FGN5T6zmy0vX7a8j+bZ2bT08u/GlisdPv22ohe6NXLxgobePkVomcXsXdgoYAMAE3M13mqLdv9M0Z4PCAMAAExFgaQWjX42CFDEhqu0EAEAAJiq+kBRn7/ISwEbAJjf5p0P7Q6btBvbNklbNPrBFUxkrLOa/RMVMoqmjxas0VUN1+4nl/aJawsZx7q3jRW3RTvP0rnNvMKMDQAQ+8GAkeNaeHtn3/7H+HwIAABMVasoYsMlFLHhSluIAAAATEWh163FiwNRkgCAjNEqExYDeNu2nv9g+//cJrqxpZV9eomM4umyF5eMFqwVTpfN5SYYxOza7m1joufOKtp16b/O9zV89n2N9PcTWPr8K13YAADxMvL9xc6a+r7BN1/xkAYAAJiC1V1tDYGi7Yc7iAIUsUGSFAq2ByQ1kgQAAJiKdavmdBqGjatsASBzbNn50O5tX3x4/XkTjo1ubCl0bcEaS4EilYzC6aPd22Z/9LORDy8oGhktbBt+5xTLkab+9deswkwPAGQOZ+1Sz3DXaUW7I4QBAACmosXk56ZIEYrYMKaVCAAAwFQsqi3rzpvmoYANADJLgUYLxcJmGxjd2JLHyM+Xvbjk8pKgFKzBjGx5+bLn5cteMUvOpqWSru7YNvzOKZYiTY6T3ratO8w4sN5d25pEFzYAyDjuRes6e3/zEz4vAgAAU7FFFLFBFLHhI61EAAAAJqvUl6PGxnI65QBAZqIbW5ZzlFfIKC6RfWa5DP902fLyCQUZabyObdEzb2v49NuKnn1fQ++cYhnS+IXN/H7F9ABA5rF58opdN63oHPi3/49CNgAAMFlVXW0NTUXbDx8iCmujiA0KBdubJFWRBAAAmAyXw9BtoWC3KDAAgExl9m5sOyR9k2maHJvbLfv00S5r9hnldFlD1jNKP9rP3brUre302xrufF/D75xS9MIFQpo8M3dhC0jazBQBQGZylNcWD7/zhoa73iMMAAAwWa3iYiaOI4kAvBAAAICpWFw/s9PtdnA1LQBk+HmgybuxUcQ2AZvbLccnKkaXBp1RPtqlCrCwsW5tYx9yjnx4QcOn39bwu6coaruxMGMDACSLe+Ht3b17flowMjhAGAAAYDJaRe2K5dlGRkZIweJCwfbzopMKAACYhMoSb89ta2pzSQIAssKfffHh9dvMOLBL3djowHOJo7xCjurZFK0BMbiyqG3ozddZfvQjJ71tWwNmHNilLmwnmCIAyHzD752I9L/8Gz9JAACASbq3aPvhx4nBuujEZnGhYHuLKGADAACT4HIYWrNqrkESAJA1tmi065kZhWXhIrax5UEdgVksDwrEyZaXL8fsOjlm18m96o6Plh9955QG33zdytFsM/HYwuy5AJAlx7Vl1X7HjKqeodMnuSASAABMRoskitgsjE5sFhcKtj8uaSNJAACAG7mzeXbnjJk+lhEFgOzypS8+vH6HGQdmpW5sNrdbjprZss+skL1ylmwuN3smkCLRM29rqOMNDb9zSsNn37fKn90tKeBt22q6JaXpwgYA2fhmG+3rff7HHpYVBQAAkz1fLdp++DxRWBOd2CwsFGz3iQI2AAAwCZUl3h4K2AAgK4Ul7TDx2LK2iM0+vWS0cK1qFkuEAmlklJbLdanj4eWlR0+8rqF3TmXz0qPbzFjAdskW9koAyLY3W8PjXrS2s+/AM3yuBAAAbqRAo93YdhCFNdGJzcJCwfZWSf9AEgAA4HpcDkP3tzT12e2GhzQA8xqxR9XrPK/cPj9hYKroxpYCNrdbjk9UyF49m25rQIYYPvWGht99W0NvvqbohQvZ8meZuQubT1KHRr+0AABkmYGDz7GsKAAAmIxdRdsPtxCDNdGJzdpaiQAAANzI2mU1nXa7wdWygIkNuXu1//iTOnrsiL5293+Soz+HUDAVYZn36sZtyuAiNiM/X46aObLPLJe9YhZ7GpBh7BWzZK+YJdeS1YqeO6vo6bc1+MdXMn3ZUbN3YaOADQCylKvxVmO488diWVEAAHADG7vaGnwsKWpNdGKzqFCwPSDpBEkAAIDrqSzx9ty2pparZAETG3L36uf7v6fIuYgkyV/o16dXfo1CNkyVmbux7ZG0OlOCtE8vkf0TFXLMrWOZUCBLXbns6OCbr2fS0OnCBgBIq2jkXZYVBQAAk/FnRdsPbyMG66ETm3XRfhEAAFyXy2Fozaq5BkkA5nVtAZskRc5F9PP936OQDVO1RebtxhaW9M9mDs8+vUTO2nrZq2bJlpfP3gRkOVtevhyz6+SYXSfXQL+G33ojUwra6MIGAEgrwz+z2DGjimVFAQDAjbRqdIUGWAyd2CwqFGw/JKmRJAAAwETubJ7dOWOmj6tjTWDI3auzg+9oRnQ2YeCq/eLaArYr0ZENMVjzxYfX7zHjwMzYjY3CNQDXGjF/QVu1t21rh9kGRRc2ALCYaLSv9/kfe1hWFAAA3Ogctmj74Q5isBY6sVnQpaVEKWADAAATqizx9lDAZh77jz+p3FyvZkyniA2jblTAJtGRDTEJSwqZeGxp78ZG4RqA67G53Gbu0PaIGQvYLqELGwBYiWF43IvWsqwoAAC4kRbRjc16h4pEYEmtRAAAACbCMqLmctp4XUePHdGbHccJA5ImV8A2ZqyQbcjdS3CYjNU7H9odMuPAvG1b90jam47HNvLz5WpapNzPPqCc+zbJUbeAAjYANzRW0Oa+/R7lfenr8qxdL/v0knQOKWziuLawxwCAtYwtK0oSAACAc0VcdZxIBJbUSgQAAGAia5fVdNrthock0m/I3avHdv9Q0mgxEoVIGPBcnHQB25ixQrZhJ0u1YFLCjE2yud1yzqtX7mcfUO79X5VryWoZhdPZOwDE9ppyqaAt575Nytv0VXma18jIT2kxrGm7sPXu2tYqurABgCW5Gm81bE4XQQAAgIlUdbU1NBGDtVDEZjGhYHuTpCqSAAAA42EZUXPZf/zJq/59PnqWUCzul/t+MKUCtjGRcxHte32XRuxRQsSNmL0b28lkPoazZrZyNmxUXuvX5V51B4VrABLOlpcvR90C5d7/VeV+9gG5mhbJ5nYn+2HDJo4kzF4BABZ1aVlRggAAANfRSgQWO0QkAp7kAAAAEsuIms3YMqJX/ayrg2As7tMrvyZ/oT+mbY8eO6K9b/6CQjZMRthKY7NPL5GneY3yvvR1uW+/R/aKWewBAFLCKJwu15LVymv9unI2bJSzZnYyHsbsXdi42BYArPxeyLKiAADg+lqIwGLHh0TAkxwAAEBiGVEzuXIZ0Su9cuwg4Vicoz+HQjakwuqdD+0OmHFg3ratO5SAbmw2t1uupkXK/ewDyrlvkxx1C2RzuZl5AGljr5gl9+33KO9LX5eneY3s00sSdddhE//ZYWYeAMCyogAA4DpYUtRiKGKzEJYSBQAAE2EZUXO5dhnRMZFzEQ25ewnI4ihkQ4qEs3FsjvIKedauV17r1+VasprlQgGYjs3llqNugXLu26Tczz4g57z6eJYb3UsXNgCA6bGsKAAAuL5WIrDQoSERWMoWIgAAANdyOQw1L589SBLmMN4yolfq0QVCAoVsSIXN2dKNzcjPl3vJcuVt+qo8d31Gjtl1zC6AjGAUTpd71R3K/fxX5Vm7PpbubGET/3lhZhgAcPk9zz+z2F5URhAAAGA8rDZopeNCIuDJDQAArG1x/cxOt9tRQBLpN9Eyold6r/stgoIkCtmQEuFMHttY17Xc+78qZ9NS2fLymVEAGcnmcssxu26q3dn2etu27jHj39O7a1uL6MIGALiGe+Ht3SwrCgAAxlHV1dZArYtFUMRmEaFge4skvpwGAABXKfXlKFhbxjKiJjHRMqJXeu3EEYLCZY7+HN3X/OWYtz967IiOnNtPkJhIxnVjs7ndcjUtousagKx1bXc2I3/CAt2wif8MVosAAHyc01XgnLeYZUUBAMB4KGKzCIrYeFIDAAALuy0U7CYFc7jRMqJjTp7q0LBzgMBwmatvmjbd/WDM2+878LyO971IkJhI2MRj2zH2P/bpJaNd1z7/VbmWrKbrGoCsN9adLff+ryq35bNyzqu/8tdm7sIWkrSaGQQAjMdRXsuyogAAYDzUu1gERWw8qQEAgEUtqi3rZhlRc5jMMqJX+tA4R2i4Sn5/aVyFbM/99kkK2TAR03Zjk7TNWd/Qm9vyWeXct0mO2XWyudzMGADLMUrL5V51h/I2fVXuJctlLyv7axMPN8yMAQCux9UYohsbAAC4VgFLiloDRWwWwFKiAADgWoVetxobyzk+MInJLCN6pXO9ZwkNH0MhG5Ko1WTj8UkKe9u2HnKvvD3HKC1nhgBAki0vX86mpcrZ+PknNNqtMmCm8dGFDQAwqfczT16xq3YRKwcAAIBrUcRmARSx8WQGAAAWFFpWc4YUzGGyy4he6cSpVwkO46KQDUmyZedDu30mGEdAo0UZHZK+JamKqQGACW2WdELSHpnns8Ew0wIAmAxHTVOBkeslCAAAcCXqXizANjIyQgpZLhRsPy86sQEAgEvqA0V9S5ZUe0gi/YbcvfreE38V07Z/eue3ZBvmmhSM74L7jH70xHdj3v62VZ/UXM9igsSV/vKLD68Pp+u0VtIWSRuZBgCI2UmNFpHtSMeDX+rC9s9MA2Bup/rtOtsXVce5D/Vh36Bee/ej69+OvnZCXZHI5X/PClRpZmnx5X831Yx2x60v8arYJRU5ogSKuEQvRDr79j9WTBIAAOAK9xZtP/w4MWQvitiy3KWlRB8jCQAAIEl5boc+c09jj2HYckkj/f7l7DN66eCBmLZtveebyu3zEyImFG8h273rH9CM6GyCxJhuSYEvPrz+fAofs1WjxWuNxA8ACX0933bpv5S9pvfu2rZDo93hAJhEb9TQqxdH9Mrp83rt3TPa98IfEnr/RX6/6uZUq6mmXPUlXgVzKWrD1A0c2dc79NbxHJIAAACXPFK0/XArMWQvBxFkPVoqAgCAy1bdEug0DBtXsWaBsz3vqsqgiA0TG1taNNZCtsd2/1Cb7n5Q+f2lhAlptLv3FiV/KTjfpfPYsFguFACS9Xr+rUuv6Y9fer3tSOYD9u7aFhAFbIApnOq368XTF7Xv347r0CuvJvWxuiIR7Xshcrk4rsjv19olC7SkulQLC2iugMlx1a2wDZ/u0MjgAGEAAACJ+pesRye2LMdSogAAYExlibfntjW1dGAzkdPG63ps9w9j2rYuOF+hqs8QIm4o3o5sFLLhCsnsxubTaEHFFs5hASDlHlESi9nowgakV9eQoRff79PP976kNzpOmmJMRX6/Nq5eqg2zC1l2FDc0/P7JM/0vPcdJKQAAGMOSolnMIILsdWkpUT78BwAAcjkMNS+fPUgS5lLkiv0z2KPHjhAgJmWsI1usfvTEd3XBfYYgoUvnl60Jvk+fPiqc+BbnsACQFpslndBoZ7ZQIu+YLmxA+hzrMfTt35/Sp7/9Y/33R35hmgI2abRL2w8ee1qf/vaP9dBvjutYD19VYWL2kqpSe1EZQQAAgDF0Y8tinBnw5AUAABbQMLuk2+12UBhgMs7BvLi2H/BcJERMCoVsSKAtCbqfgKQdongNAMxko6R/lrRHiStmCxMrkFr7O6N66DfH9e+/82M9vWe/6ce774U/6N9/h2I2XJ974e3dpAAAAC6hDiaLcUbAkxcAAGS5Qq9bjY3lFAeYkG3YUFVFIObtuwYoKsLk5feX6mt3/yf5C/0xbU8hGy6p2vnQ7tY4tg9otHjthEY78/D+BADms1oJKGajCxuQWsd6DH31n36n//y/f6p9L/wh48Y/Vsz27d+fUtcQX13hGk5Xgat2EYVsAABAkgq62hqohclSnAlkKZYSBQAAl48LltVQdWJic6rnx7ztqTOvESAmNOwc0AX3GZ2MHtG/nH1Ge07+TN974q8UOReJ+T4pZMMl4Ri2Cejq4jUAgPnFW8wWJkIg+U712y93XjPTkqGxenrPfrV9/xntfneAycVVHDVNBUaulyAAAIBEQ6esZRsZGSGFLBQKtu8QXwwAAGB5c8p9vc0rZueQhHl1Ot/So099P+btH1z3l4SIq1xwn9Ef335ZLx08kJT79xf69emVX5Ojn5cWi/vSFx9ev2MStwtotIiB81MAyHx7L72m77nRDXt3bfNpdMloLrIFkqQ3aujnx8/pB489nbV/Y/OSRfrmqloVOaJMOCRJ0QuRzr79jxWTBAAAltddtP2wjxiyD53YsheVpwAAWJzLYWj50hobSZibz5ge1/YDnouEiMv7wp6TP9OPnvhu0grYJClyLqKf7/+ehty9hG5t4Rv8PiA6rwFAtplKZ7YtooANSJpjPYa+8dP9WV3AJo0uMdr2/Wf0cjcfbWCUke8vdsyo6iEJAAAsjyVFs/V4jwiyD0uJAgAASWpeVHXGbjc8JGFu8Xaz6hpgaUdIp43X9fe/+msdPXYkJY9HIRskVe18aHfrOD/3abTAjeI1AMhe1y1mu9SFbQsxAYnXGzX0wz92Z83SoZM6541E9B+++48irDtsAAAgAElEQVQsL4rLXPNXDdqcLoIAAAAUsWUhith4sgIAgCxU6stRVaColCQyw80Llsa8bef5dwnQ4o73vajHdv8w5Y9LIRt0dYHCWPFah6RvEQ0AWMJYMdvjGu3AeeX7AxfYAgl2qt+uv3jy5azvvjaR//7IL/R3h95nR4DkdBU45y3uJAgAACyPupgsRBEbT1YAAJCFQstn8WFeBiktqoh521eOHSRACzve96Ke++2TaXt8Ctksr3HnQ7tDurp4jaIFALCejRrtwLkjeubNm0QXNiDh9ndG9Wc7ntahV161dA6PPvM8hWyQJDnKa4uNAj9BAABgbSwpmo3HeUSQXVhKFAAA1AeK+vKmeYpJInNMz50Z87aRcxENuXvjXpYUmSfeArabFyxVRekc5TmnyWPL1e+O7Y5pOdKxQrZPr/wa+6HF1Cyo0KLb5zwjiaWrAQCStNkordnsuimkwVd/r5HBfhIBEuCXHT3623/aRRCXPPrM85LW6k+bSgjD4tw3hc707vslqxAAAGBtLRrtDo4sQRFb9gkRAQAA1uVyGFp8c9UISWQW97A3ru3PR8+qWJUEaSE9noie+/XUC9iqKgJqbtqgaUPTZRs2pKikS98vr675lD7s+UAnT3VM+X4j5yJ69tBPtGH+5tH7RVYrDRRrxX3z5fV5JArYAADXsFc3yV5Rp6E3D2ro9ZcpZgPi8HeH3r9UtIUrUcgGSbJNKyx1VM7tHXrrOFdTAQBgXSEiyC58u5B9aJcIAICFNS+qOmPYDT68yzD2QZeqKgIxb3+6q4MQLWTEHtWv9v1wStv4C/3adPeDumvel5TfXzpuoZlt2NAdTZ+TvzC2JVlOnurQ3jd/oRF7lEnKUoVlBVr35aW648s3jxWwAQAwPodLjrlL5F6zSY6qOvIAYkAB2/U9+szz+mVHD0FYnKtuhc3mdBEEAADWVdXV1tBEDNnDHg6HSSFLhILtTZL+nCQAALCmUl+OFt9c5SWJzNTvvqi33j4R07YffNit+Z9YSogW8Z7tDR088sKkb18XnK87GzcpZ6Dghrc1hp2qrWnUibNH1dvXO+Wxne16Xz32LlUVzZNtxMZkZYk8X65uvrNey+6ZR/EaAGBKbE637GWz5Jg5WyMfntNIzwVCASbB7AVsRX6/br6pTlXlM6/6z+l06dz57pSN41+OHNPsefWqzOXcw7pvNDaHzTbSPdx5mhMVAACsqz/37gd3E0N2YDnR7NJKBAAAWFdo+axOScUkkZmKfTNj3jZyLqJh54Dsg1x9nO1G7FHtPfDUpG9fF5yv1TWfkm1w8k24Hf05+vTKr+nn+7+nyLnIlMd49NgRSaPLk7K0aGZzepyat6xG9csr5XTbCQQAEDNbfrFcyz+laOQdDb78rKIfUswGTMRMBWxFfr+W3FSnWTOKVF/iVbFLKnJcr/PyXEnL1TVkqHNAeuX9D3Tozbe174U/JG2M237xf1TVukEV7mF2Hoty1DQVDL11TNGeDwgDAABrapG0hRiy5PODkZERUsgSoWB7h6QqkgAAwHrmlPt6m1fMZhnRDDbguai//9Vfx7z9prsfVH5/KUFmuQvuM/rRE9+d1G39hX59ZvmfxlzcOOTujbmQTbqigI5CtoxUs6BCSzbUUrwGAEiK4ROHNPjq7zUy2E8YwBV+2dGjv/2nXWkdQ1P9PN1xc53qi3ISVhjWGzX0h8iQfv/aO3p6z/6kjPlv7mEVKSuLXoh09u1/jAs7AQCwrgVF2w8fIobMRye2LHFpKVEK2AAAsCCXw9DypTWsnZHp89g3La7t3+t+S/keitiy3cmzxyZ929VL7oqrOx8d2aypNFCsxRvmyV+WRxgAgKSxVzfJXlGnoWMHNPj6ywQCSHq525a2ArZZgSptWNak1eXeKzqtJa6zWY4R1cpiQyuLK/TlxV/Qo0feS2i3uUOvvKpf3jRX9wVy2ZEsysj3FztmVPUMnT7JTgAAgDW1im5s2XFcRwRZo4UIAACwpsX1MzvtdsNDEpmvLjg/5m1fO3GEAC1g34HJf9FTZquJ+/HGCtn8hf6Ytj967Ij2vvkLJi4D5PlytezeJt3x5ZspYAMApIbDJUf9KnnWbJJ9egV5wNK6hgz915/sTvnjNi9ZpP/x4Of19/cv132B3BssFZoYRY6o/rSpRDu3blLzkkUJu99/fHafuob4ysvKXPNXDdqcLoIAAMCaQkSQHTiizx4UsQEAYEGFXreCtWUsl5AlqivmxbztyVMdGnYOEGIWG/BcnPRtm5euTVj3M0d/jjas/FzM2x89dkTH+15kAk3spjVB3fP1FZqzoIwwAAApZ8svlmv5p+Reeo+MvHwCgSW1P/2yuiKRlD1e85JF+n+/+QU9fOtcLSwYScvfXOEe1sO3ztU37t+YkPvrikT06JH32JmszOkqcM5q6CYIAAAsqbGrrSFADJmPIrYsEAq2ByQ1kgQAABY8DlhWc4YUskdhzvS4tu+3f0CIWezC8LlJ37bYNzOhj53fX6pNdz8Y8/bP/fZJCtlMqDRQrPu2htS0plpOt51AAABpZZTWyB3aJOe8ZYQBS/llR48OvfJqSh6rqX7e5eK1YG7UFH//fYFc/Y8HP68ivz/u+3r0mefpxmZxjsBNTiPXSxAAAFgTjZ+y4bMBIuDJCAAAMlNliben0J9XShLZI1fxdZ442/MuIWaxweH0dtqjkC175PlyFbr/Zt3x5Zvl9bEaNQDARBwuOeYukWfdV1hiFJbQNWToH5/dl/THKfL79eebP6W/uafJNMVrV1pYMKK/ad2QkEK2p18/x45lZYaR66xbygWfAABYUysRZMHhHBHwZAQAAJmpefnsQVLILo7+HPkLY//Q/sSpVwkRSUUhW+YbWzq0ch4rUQMAzMuWM40lRmEJjx55L+nLiDYvWaTtX7lT62e6TJ1FhXtYf/G59XHfz669B9ixLM5eUlVqLyojCAAArIclRbMARWwZLhRs94mlRAEAsJxFtWXdbrejgCSyT01gbszbHj12RCP2KCEiqShky0ylgWJ98sFmlg4FAGSUy0uMzl5IGMg6XUOGHn3m+aQ+xp9v/pQevnWuihyZcZ64sGBE37h/Y3y5RiJ6udvGDmZxrsZQJykAAGBJISLI8M8BiCDjsZQoAAAW43IYaphv8kuoEbOK0jlxbd/rPE+I0KkzryX1/ilkyxxOj1PL7m3SHV++Wf6yPAIBAGQeh0uO+lXyrNkkwzedPJA1Hj3yXtLuu8jv186tm0zffW089wVy1bxkUVz38cppzoutzubJK3ZUzu0lCQAALIf6mQxHERtPQgAAkGGaF1WdMexGDklkpyJXaVzbn+15lxChNzuOJ/0x8vtLde/6B2Le/rnfPqlO51tMVhLVLKjQp/9DSHMWsJQOACDz2fKL5V79BbluCsnmdBMIMlpvNHld2Jrq5+mH/+5OVbiHMzaff7diXlzb7z34CjsZ5KpbYbM5uQYUAACL2djV1uAjhsxFEVsWPAmJAAAA6yj0ulUVKColiezlHIyvU9KZrlOEmK37hn3yH75HzkXU44kkfUwzorN126pPxrz9o099XxfcZ5jcBMvz5Wrdl5dq5b31LB0KAMg69uomuddskmPmbMJAxtr7Xl9S7repfp7+6ycXKseIZnQ+Fe5hffbOtTFv/0bHSfVG+frL8gzD45zV0E0QAABYDo2gMvkQjggyVyjYzpMPAACrvf8vq6HaI8vZhg1VVQRi3v6lgwcIMUvl2wundPsjp15IybjmeharLjg/5u1/9MR3KWRLoJvWBHXP11eoLMAFhwCALD5mzpkm5+JPyr30HrqyISM9+9LRhN9n85JF+pt7mjK+gG3Mkur4rt97q4/9DJIjcJPTyPUSBAAA1hIigsxFEVtmo4gNAAALqSzx9hT68+jCZgFzqufHtf2A5yIhZiFX37Qp3f6lgwdSti/kxvmlAIVs8SssK9AnH2xW05pquq8BACzDKK2RZ91X5KiqIwxkjN6ooUOvvJrQ+2yqn6f/O1SbVTktLBhRkd8f8/YnzlPFBkmGkeusW8rJJgAA1kIdTSYfvhEBTz4AAJAZmpfPHiQFa/BPi69WsWuAz2czSY8nopPRI/qXs8/ou7/+lk4br09426l2PDt0an/G5HCu9yw7Q4xuWhPU3Q8uk78sjzAAANbjcMnZtE7u5s/IyMsnD5jeqxdHEnp/swJVWbGE6LjnP3OqYz/PGhhiZ4MkyV5SVWovKiMIAACso6CrrSFEDJmJIrYMFQq2N0kqIAkAAKyhPlDU53Y7eO+3CJ8xPa7tT515jRBNbtg5oON9L+onL35HO371HT313M8uLwXbef7dCbcLVi+Y0uO8dPCAOp1vJf3v6en5IK7tP3vXV1RlzGfHmKIru68BAGB1hv8Tcoc2yTl7IWHA1F45fT6h9/et+5qzsoBNkppqytlhkBCuuuVc7QcAgLXQECpTz+2JIGO1EgEAANbgchhafHPVCEmkz5C7VyP21H0p4OjPiWv7sWIomM+IParjfS9q+1P/Rc/99klFzkU+dpu33nljwu1L7JVTfsznfveYhty9Sf27jh47EvO2m+5+UMWDlewcU0T3NQAAxjuQdslRv4qubDC1195NXC3NN+7fqAr3MKECN2CbVljqmFHVQxIAAFgGRWwZiiI2nnQAAMDkGmaXdBt2I4ck0mPEHtWzh36ivW/+IqWFbDcvWBrX9gOei0yeyVxwn9FPD/ytnvvtk9e93clTHRp2Doz7O/uga8r7RuRcRM8e+knS9t/rFchVVQTkL/RP+PtNdz+o/P5Sdo4poPsaAAA3Rlc2mNnR104k5H5mBap0Z6WXQIFJcs1fNUgKAABYRlVXW0MTMWTg+TwRZJ5QsD0gqYokAADIfnluhxoby1lGNI3eGjyqk6c6dPTYkZQWspUWVcS1/YXhc0yeiRzve1E/euK743ZeG0+/feLlOWvLp/5l7MlTHUnbf9/pnbhz3PTiMv3J0m+MW3hHAdvU0X0NAIApoCsbTKorEknI/bTevjRrlxEFksLpKnDW1PcRBAAAlhEigsxDEVtmogsbAAAWsbSp4gwppM+A56Keeu5nl/+dykK26bkz49r+dFcHE2gCI/aoDl/47Q27r12re2DiL7by+0tVVRGY8liStf8eOfbihL/LcefJNmzolul36t71D1z+OQVsU0P3NQAAYjfWlc1RVUcYyBpFfr8W+R1Z/3eeOf8Bk42Ecs69ZcTmdBEEAADW0EoEGXgOTwQZiSI2AAAsoNSXo6pAEVUeaTJij+r/HPz5x36eqkI293B8y8K8cuwgk2gCr334B+078PyUtzt15rXr/n7Ngo0xjSfR+2+n8y2dPNUx4e+LfR8VY86IzlbrPd9U6z3fpIBtCmqX1dB9DQCAeDlccjatk3vpPbI53eSBtOmNJuYrmbVLFliiC9vpyPmYt811Odjh8HGGkeOc1dBNEAAAWEJjV1uDjxgy7HCNCDJLKNjuk7SaJAAAyH7LFwfowpZGY8uIjicVhWz2QVdM3bbGRM5FNOTuZSLT6Hjfi1PuwDbmpYMHrvv73D7/uEt0TsbY/hvv/jHk7tVzv3vsurfJc0772Lhz+/zsHJOQ58vVui8v1S13ziUMAAASxCitkWfdV+SYOZswkBY9CTqFbCgvtkReR187EfO21T4POxzG5ahpKjByvQQBAIA10CAq047ViIAnGQAAMJ9SX44K/Xm0KkqTAc9FPfWrn133NkePHZEkra75lGzDybk2pPITs67b5epGzkfPqliVTGgaXHCf0XO/fjKu+xhy98rRnzPh7xfNXKs3O44rci4y5fs+euyI3nv/Xd3T/EBMRWUj9qj2H3/yho+dq3x2hhiUz5uh5vvmy+m2EwYAAInmcMm5+JMyThzS4Ku/18hgP5kgZYocialim57rkJT9ndh+3naHJKlryFDnwOjPPhwcUce5D0f/v29Qr7370fV/+174w0fn09Sw4TqcdUvP9L/0HJ+7AQCQ/Vok7SCGDDplJ4KMEyICAACy322hYLekApJIvYmWER1PsgvZrlyKMRaRi2dU7KGILdWGnQN6ev9Pprydv9CvhQ3LVVZQKY8tV46+nOve3j7o0m3L79WjT30/tv3jXEQ7fvUdNS9dq7qipbIPuia13ZC7V88e+skNCyz9hf7rFuHh45wep1bc26jKecWEAQBAktmrm2QUlWvg4LOKnj9LIMgowdyopf7eIkdURVd8m7WwIPejf9Re8dHJrVd2MY6yo2Di94CSqlKjwK9od4QwAADIbiEiyCwsJ5p56MQGAECWm1Pu63W7HRSwpcn1lhEdTzKXFi1yxXdR8GsnjjChafCHd5+fUne0qoqANt39oD63+Jua61ms/P5SufqmTWrb4sFKNS9dG9d49x14Xj/73d/pZPSIhp0DE95uxB7VaeN1fe+Jv5rUc2Rhw3J2hikoDRTr7gdXUMAGAEAK2fKL5V79BTlnLyQMALAY902hM6QAAEDWK+hqa6DGJoPQiS2DhILtIdGRBQCArOZyGLrl5sCAJNoXpcFklhEdT7I6sk22kGkiJ091qPOmt+QzptMRK0V6PBG9dPDApG/fvHSt5heulK0/9v1mfuFKdQXPXN4PYxE5F9FTz43u+3XB+QpWL5DT7lKu3avugYg6z7+rV44dnFJxXrlvltTHPjEZN60JqmlNNUEAAJAmjvpVMmbM0sCBX7G8KJKuecmiq5a9jEVv1FCOQacxIB62aYWl9qIyDXe9RxgAAGS3kKTHiSFDzs+JIKNQIQoAQJZrmF3STRe29JjKMqLjSVYhW11wflzFSWNLTfoL/aoPLlCxb6aKXKVxF8hhfP98cNekb3vbqk9qrmexNBzfY9qGDa2u+ZQ+7PlgSl0Er7cvx7PPSaPd5XL7/OwQN5Dny9WK+25SWcBHGAAApJnh/4Q8676iwYO/1tC7rxMIkmaGP/5jv7f6pGAuWQLxctUtP9O775elJAEAQFZrkbSFGDIDRWyZJUQEAABkL5fDUMP8mS6SSI+pLiM6nmQUslVXzIu7oEga7bS178DzV/3s5gVLVVE6RwUuv3IGfQktvrOiHk9k0vtQXXD+aAFbgtiGDd3R9Dn9/IPvTalbWrI0N22QaGJyXeXzZqj5vvlyuu2EAQCAWThcci7+pIwThzTwb3vIA0lRXRJ/EduJ830K5vLxARD3ufS0wlJH5dzeobeO074eAIDsVdXV1hAo2n64gygy4LScCDJDKNgekNRIEgAAZK+G2SXdht2gC1saxLqM6HgSXchWmDM9aX/3SwcP6CV9tPRlXXC+qivmqTBnuvKihbIP8qXIVLzx/uSLDZtnb5QGE3xy15+jT6/8mn6+P72FbFUVAeX3cyH79Sy6s171yyoIAgAAk7JXN8lTVK6Bf/mVoh9eIBAkVH1R/LUyz750VOvvaSJMIAFcwSUDFLEBAJD1WiRtIwbzo4gts55UAAAgS+W5HWpo+ISTJFIv3mVEx5PIQrZc5acsi2uXkayqCGhO9Xz5p5XKZ0yXo5/PdK+3H13b6W4i965/IGkFgo7+HP3J0m9o75u/SEgHv1jc0fQ5urBN9Frvy9Wazy+SvyyPMAAAMDlbfrHcoU0sL4qEq3APa1agSm90nIz5Pg698qq6NixUkSNKoEC8nK4CurEBAJD1KGLLEBSxZY4QEQAAkL2WNlWcMQwbrYvSIBHLiI4nUYVsjv4c+Qv9aemsdfJUx1XZ+Av9qg8uULFvpopcpXL1TWMHuuSi4+ykb1tir5SS+F2TbdjQ6ppPKTfXq5cOHkhpDpvufpBixwmwfCgAABmI5UWRJKsX1MdVxCZJT79+Tg/U0swdSAS6sQEAkP2H4F1tDb6i7YfPE4XJT8OJIGNsJAIAALJTntuhqkARBWxpMOTu1VNP/Cxp95+oQraawFxFzh1Ie16Rc5GPdRu7ecFSVZTOUYHLr5xBX0KWUM1E73W/Nanb3bxgaUqWabUNG7pl+p0qva1CTz33s5RkcNdtn2EZ0QmwfCgAAJmN5UWRaKFqv34Q53384LGnteE/foFubEAiOF0FrtpF3QN//AOVoQAAZPFhuKTHicHk59/hcJgUzP5MCra3SPocSQAAkJ1W3Vx1xufL9ZJE6hnDThV8wqs3Tx5P2mOc7XpfPfYuVRXNk23EFts4p9n0x9f/zZQZvvve2/rj6/+mQ8de0Euv79WHjk7Z8kdkeEbkMFwyotboOnXgtV+r+8KNL+Ja0rRG00b8KRuXz1aixvqb1dXz7qTGF6tNdz+o0mgNLyrXyPPl6o4vL1XVvGLCAAAgw9ncuXJU1ksfnlP0YoRAEJcCx4j+9dyw3jvbGdf9fOAq0IoKam6ARDAKSkaGTh51KjpMGAAAZKf+3LsfpIjN5OjElhlCRAAAQHaiC1v6zfUsllZJz/32yaQ9Rrwd2YpcmbOLHD125PLfK0lVFQHNqZ6vsoJK5So/a5eanOyStHnOaVJ/asfm6pumDfM3663g0YR3ZauqCOj2BZ9madlxlAaKdesXFrB8KAAA2eTS8qK24y9o8NXfkwfi8qnlN+nQK6/GdR9P79mvZXP+RCuLDQIF4mUYOf8/e/ceHdVhn3v/mZFGGl1AowuWMAgNGBjujLCxmQBm4/h+BTccJakTu6SNW7q6ktLmPe05PrWTo/ePtzlHdk672pf0TesTO6tWFTeu7eTEJolHvmHHMYhgYwsbIiHigIVAAoNGGknz/qEZNIO5jEZz2bP397OWVhIiJPFoNLO39rN/P9dVy5nGBgCAdRlEkAen3USQFzYRAQAA1nT9td7jkhjRk2NmL7K5wmV5m213T1dCwauqskpLfY2aWe3V9IJKS5SfRooHk35ft6M0J1+jY9SpBucyPXjHQh08vTctj/U7btyiOa4lcoS4YHa+FRt98m+cSxAAAFhU4cLr5KyZreE3nlUkPEQgSMm6Gqeu8jboYFf3lD7OY0/vVMMDt6u+mOlRwJSf370risIH9ykSHiYMAACsp6HvweX+6h37OojCvFgnanKGr9kr6WGSAADAemo9JVrVOKeUJMyhunCWaVeLOiIOfTzcldF1kNkyGBrU4SO/0bsf7NHuztf11sGgItNDck5zqLjYJWfElfLa1VwZcYW0u/P1pN53hW+1XCO5m0bnHCtQdeEsrVq0VnUNdRoOn53U46qqskprr/2sblq2RZWRmXn3vco0l9ul67eskm/1LMIAAMDiHCXTVTB7kcb6jigSOksgSEnVzFl6afe7UzvHGhzUy51HdNeqhXI5IoQKTOnJ3eFyOCIDo8d/5yYMAAAsqbP0rm1vEIN5MYnN/JjCBgCARX1mtfeYJFaJmoiZJ7ItmLss6ZWV+eZXe97QrzRx3rjEt0xz6xdrRumVKh4tV0G4yDL/1oHhEypVVc6/joJwkRqcy9SweJlG/IPqH+vV7/q6NDh0Roe6DujEyRPnvhelpeWqra7XjNIrVRqKfu1hni/OV1lXobX3rlBVXRlhAABgE46SaSre8PsKd7yoke79BIJJW1fj1PrrrtYrb749pY/Td+KE/svzu7X9lquZyAZMEdPYAACwtE2SHiMGE59nRyLcmWNmhq/5GUn3kAQAANZS6ynRHbcsJQiTOhB6K6NFNmm8HDSZIttx12H924+/Z8vvR0O9VwvmLlNdxRyVaroKh0pM9fUNu0/r/3v2fyT1vuvXfFbLp1+f9a/xrPuECuWSK1w26XW2uLzZi2dq/b3L5CouIAwAAGxq7Mh7Gnr7BYLApPUMFejLLU+m5WNVV1Xp//7SbfKVjhEsMAWjH3cfG/rVz7jxFAAAa6qs3rGvnxjMiUls5keBDQAAC2IKm7mZcSKbxznDtt+P7p6uhCl0VZVVWupr1Mxqr6YXVKooNC1v/i3vdu7R8tXZL7G90/OmfrXnjXP5zfMuVG11vcqKp2t6QSXltilYsdEn/8a5BAEAgM05Zy+We/oMDb3apkh4iECQtPriUf3ZF+7R3/3rf0z5Y/WdOKE//s4P9GdfuEf3eksJF0hRwRUNtc7Sco2d/YQwAACwHkPSM8RgTpTYzPyT42tmlSgAABZU6ylRZVUZBTaTM1uRzWzTx3LpxMkTeuWNnyf82TWNa1Rfu0DVRbVZL2S5wmWT+tpPFR/T9KHsPgUc6jqQ8DWcOPmGFLfCVZK23fxNHlyT+b67XVq7eaXmLK4hDAAAIElyTK+R++avaOi1No319xIIknavt1SvLF2sjnffS8vH+7t//Q/9xNugb9yzjqlsQKrnfEvWMI0NAABr2iRKbKZFic3cDCIAAMB6mMKWP8xWZLumcc25aVpI9Ks9b+hXcaWsJb5lmlu/WDNKr1TxaLkKwkUZ+9yTLcy9f2S3rp1xW1bzOXHyBA+SNKqsq9Dae1eoqq6MMAAAQKLCIhWv3aLwO0GNdO8nDyTtodtX6cHfHVPfifQcux/s6tYff6db66+7WjevmK91NUxeBiaDaWwAAFiWQQQmPgZ75JFHSMGkHv/7l/9fSR6SAADAOmo9JVqxfFY5SeSP6sJZqphVrkPdBzL2OXr7PtbZgj41VC+WI+K46PuNlAzpg0NcCEs20w8O7VdH55t6+4NX9PFwlzRtRJ6SGXKOFaT980Wmh/TR0SNJve9HR49o6dKVco1kZ7resPu0dne+ftn3W33VRh44yTyPe2t00/3XqNxTTBgAAODCnAUqqLtKzmK3Ro91kQeSUuqMaOWShXr+zX1p/biHf/s7vbT7XT2//yMNlc+Qu7RUNa4IgQNJcJROOzb60SF+jwcAgLV4Bp//x/8ovWvbUaIw4ek0EZiT4Wv2SmogCQAArCU6hQ15ZqF7tW68/s6Mfo79ne+o/dDTihRcfNXLjNIr+WakqLunSx/85h05xzIzjLq2un5S7//Snv+45Pc6nU6Nnrzs+yzxLeNBkoR5jfW6Zes1chUXEAYAAGxizyMAACAASURBVLisgrl+Fa+5Ww4X5Xckx1c6pv/+R00Z+dh9J07on3/0E/3xd36gz+14Qd/e1aPOs1wiAi75PB6dxgYAACzHIAJz4gyFHxoAAJAltZ4SVVaVsUY0T5mhyFY8mvovTjff+iXdceMWW5eVbmr83KRXfyZrZunk7j/p7unSB2fezsq/+50P37zs+1RX8tR0OYHNfq3bvJQgAADApDhr56l43RY5y6YTBpKyrsaZsSJbTN+JE/pJ8FWdCTORDbgc15I13JAKAID1bCICk55DEwE/NAAAIDuYwpb/cl1kKwgXqaHem/LHbnAuk9GwRX9y28N64O6v2arUdseNW1QUmpaxj18Umjbp783PXn5ex12HM/rvHnUNa3/nO5d9v5nVXn7AL8LldunmrWu0oLGOMAAAQEoc02tUbNwnp2cGYSAp62qc+rMv3JPRz1FdVaVVFZTYgMthGhsAAJa0gQjMiRKbeRlEAACAdTCFzTpyXWSbM+uqlD5mz7EPzv13x6hTpaEq25TaGuq9muNakvHPs8y3etJ/599+/D2dKs5cv/Xg6b1JvZ/HyQXVC6msq9AtW9eozushDAAAMDWFRSre8PsqbFhCFkjKvd7SjE5ku24Fj0UgWUxjAwDAevoeXM5gKROixGZChq/ZkFRBEgAAWAdT2Kwll0W2Gs+VKX28Q10HLvr/XazUduP1d05p8ptZZHKNaLzZxQtT+ntPPvcPGSmyDbtP62cvP3/Z92uo96pwqIQf7PNU1lXo1q9cq6q6MsIAAABp4/LfLNfiAEEgKZlcLRpYMIuAgSQxjQ0AAEsyiMB8KLHxwwIAADKMKWzWlKsiW3VRag+lEydPaNQ1nNT7xkptC92rdcfiP9CDd/xX3XfXtrwstWV6jWi8gnBRyo+JJ5/7Bx0IvZW2ryVSMKZ/f+Wfk3rfVCbIWd28xnrdtS0gV3EBYQAAgLQrXHidiq++hSCQlHU1Tn1/+32qrqpK68e9uqqQcIFJYBobAACWYxCB+VBiMyfGFgIAYCFMYbOuXBTZplLIGir4JKW/VxAu0vSh2rwrtWVrjWi8BWVXq6oytYtLP3v5eQW725IuG15MpGBM7Yee1omTJ5J6/1QnyFnVosA8rdu8lCAAAEBGOWcvlnvjfXK4igkDl1VfPKon/ug2rb/u6rR8vNuNdSpxjhEsMAlMYwMAwHJW9j243EsMJjvmeuSRR0jBRAxfs0fSoyQBAIA11HpKtGL5LH7DZWHVhbNUMatch7oPZOxz9PZ9rLMFfWqoXixHxKEzhcfV2/fxpD/O3LkLNS0y9bv3nWMFKh4tV3XhLC2c0ahVi9Zq8aLluqKuVqNjwxo41W+K780W4w9VGHZn9XM6Ig7Vea/Uux/sSfl7/fYHr2j2gnqVOz1yRByT+vvD7tP64es7dPhId1Lvf03jGtW7F/GDHBXY7NeK9Q0EAQAAsnPsWFyqgtq5GuvtUiQ8RCC4JJcjoo1zq1V3lU/v9xzT4OBgyh/ryzcFNKfUQajAZJ+3S6cdG/3oEL/nAwDAOvaW3rWtgxjMgxKbyTz+9y/fKunzJAEAgDXcvH7BsZKSIn65ZXHZLrI5y6UPDu2f9Mcon1aqWWUL0v61nV9qa1yyRlct8KmqukqfnBnQYGgw69+TO27courR+pw8HkrHKhSZHtJHR4+k/DHe//DXOtS3T9X1NSotLJdz7NJrLUddw/rw7G798MXHJ5X37dd+XgUjTP9wuV26fssqzVt+BU9oAAAgqxzFpSqcs3S8yBY6SyC4rPnTCvRZ/0J9UlShD7oOp/QxvnGTXy5HhDCBSXKWecpHf/uBIuFhwgAAwBoGSu/a9gwxmOgcORLhRMVMDF/z45LuJwkAAPJfradEd9zCSjo7ORB6Sz97+fmMfo4lvmXyzW3Uj376REp/f9vN38x6LiPFg+of69Xv+rr0bueepNdcpqqh3qvbl90vx6gzZ4+FSMGYWt/4u7T9W5f4lmlu/WJVlsyQ21EqSQpFzupM+LQ6f7NH+zvfmfTHvPH6O7XQvdr2P7cut0u3bF2jqroynsQAAEDujAxr+JfPabS3hyyQtM6zTv3gjff1yptvJ/131l93tb51w0LCA1I0+nH3saFf/ayWJAAAsISB6h37PMRgHpTYTMbwNXdJYn8NAAAWsPmmxccqq8r4pZbNZKPINhVfveuvVDhUktOvIdOltj+8+y9VFJqW86xHigf1w1e/m/HSXiqqKqvUtObPclr0M4PKugpt/GKjyj1uAQAAmEG440WNdO8nCEzKZMps//n+39OtVxYRGpCqsbHBwZ//oIRpbAAAWEZj9Y59rBQ1iUIiMA/D1+wVBTYAACyh1lMiCmz2tNC9WsU3lujHP2sz5dd3Vqc0XbktsRUOlahGc1QzfY6Wr77+XKnt0Efv6ld73pjSx77jxi2mKLDF/p23r/u8nnzuH0z3OLh7/ZfkCFFgu/Ur18pVXMATFwAAMA2X/2Y5XG6FP9xNGEiar3RM37phoTrXLNIvDhzVv/2fn1/0fVdf4ZY0RmhAqpzOEtdVyweG33+7gjAAALAEQxIlNpNgEpuZfjJ8zQ9I+heSAAAg/90UmNdTP6eqniTs61TxMVOWl+64cYsanMtMnd2w+7T6ho+p59gHkyq1mWGNaD48Fjbf+iXNHJtv65/PWm+Nbvj9RgpsAADAtMaOvKeht18gCKRkcMypt0+MaNcHv9VPgq+e+3P/0sV69G4/AQFTfpJmGhsAABbSXr1jn0EM5kCJzUQMX/Mzku4hCQAA8ltZcaGaNvFLYZizyHZN4xpdO+O2vMox2VKbWdaIXshZ9wk9+8oTOV8teuP1d2qhe7Wtfy7nNdZr3ealPEEBAADTo8iGdIgvtAUWzNK6GiehAGkwcqiDaWwAAFhE9Y59DlIwB0psJmL4mvslccALAECe++x1c481eKtZJQpJ5iyybbv5m3md6YVKbfkwYW6keFAvdDyl7p6unHx+CmwU2AAAQP4ZO3ZIw2+/oEh4iDAAwFRP0ExjAwDAQjZW79gXJIbco8RmEoav2S9pD0kAAJDfmMKGCzFbkc3ME8tSMew+LVe4zHRrRC8kUjCmd06+qlfe+HlWPy8rRKUVG33yb5zLExIAAMg7kVPHNfRqG0U2ADCZcOcvT4YP7qskCQAA8t53qnfs+zox5B5zo83DIAIAAPLfGn/9MVLA+aYP1eq+u7aZ5us5NXrSUvkWhablRYFNkhyjTi2ffr3+0x1fUVVlVcY/X1VllR64+2u2L7AFNvspsAEAgLzlmF6j4nVb5HAVEwYAmIhrnp/rrAAAWINBBObAwZV5bCICAADyW1GhU6wRxcWYqch24jRdy1yrCc/Rls/8iW68/s6MfY71az6rLZ/5E5WGqmyddWCzXwsa63jQAQCAvBYrsjnLphMGAJiFq6iicM7CQYIAACDvrex7cLmHGHKPEpt5bCACAADy2/L5VwyQAi7FLEW2j4518c0wgYJwkRa6V+vBO/5rWsts1zSu0R/e/ZdaPv16FYSLbJ0xBTYAAGAljuk1Kjbuk9MzgzAAwCSKfNcNkwIAAJZgEIEJznsjkQgp5PonwddsSHqJJAAAyF9FhU59cZN/0FngLCENXM6p4mN68rl/yOnXsO3mb/KNMJlR17BO6qje+fBN7e98Z1J/t6qySquWf0ZezyIVhabZPkuX26WNX7xadV5ungMAABY0Mqyh19o01t9LFgBgAsPvvDI4cvgAvxMEACC/fad6x76vE0NuFRKBKRhEAABAfls+/4oBZ4GzgiSQjNhEtlwW2Ybdpyk7mUxBuEg1miOjYY7Wz79HZ5wndSZ8Wj3HPpAknT37ifZ3vqNrGtdIkkqKy1TjuVLVRbUT38sQObrcLt2ydY2q6soIAwAAWFNhkYrXbqHIBgBmOQ9tWHaKEhsAAHnPIILcYxKbGX4SfM1BsU4UAIC8dt8m/8mi4sJKksBk5HIi2+Zbv6SZY/P5JsBSKLABAABbYSIbAJjG0Js/1mjfUYIAACC/za3esa+LGHLHSQS5ZfiaPaLABgBAXlsw2zNIgQ2piE1ky4Xj/R/xDYClUGADAAC2E53I5vTMIAsAyLGiJZ85RgoAAOQ9gwhyixIbPwQAAGCKrr3GO0wKSFWuimyHf3uQ8GEZFNgAAIBtUWQDAFNwTKusdZaWEwQAAPnNIILcosTGDwEAAJiC+hnlKi4urCAJTEUuimzdPV2KFIwRPvIeBTYAAGB7FNkAwBznp0vWMI0NAID8ZhBBblFi44cAAABMwTX+en45hbTIRZEt7DpD8MhrFNgAAACiokW2wivnkwUA5EjBFQ1MYwMAIL819D243EsMuUOJLYcMX7NH0kqSAAAgP9V6SlRZVVZLEkiXbBfZ+obpYCJ/UWADAAA4T2GRXKvvVGHDErIAgFw9Fc9feZwUAADIawYR5A4lNh78AAAgRSsWz+whBaRbNotsPcc+IHDkJQpsAAAAlzhW8t/MalEAyJHCKxeWOVxFBAEAQP4yiCB3KLHx4AcAACkoKy5U/ZyqepJAJmSryHao64BGigcJHHmFAhsAAMDlFa/dQpENAHLB6SwpnOM7SRAAAOQtgwhyeChFBDz4AQDA5PkX1bEaABmVjSLbiZMn9MNXv0uRDXmDAhsAAECSCososgFArs5d5/m5/goAQP5q6HtwuZcYcoODqBwxfM0eSStJAgCA/FNU6NSCBVfQoEDGUWQDJlBgAwAAmCSKbACQoxPYoorCOQv5RQsAAPnLIILcoMTGgx4AAEzS8vlXDDgLnCUkgWygyAZQYAMAAEgZRTYAyM15bMOyU6QAAEDeMoggNyix8aAHAACTtHhR3RgpIJsossHOKLABAABMEUU2AMg6x7TK2oLqOoIAACA/GUSQG5TYeNADAIBJWDDbM1hUXFhJEsg2imywq41fvJoCGwAAwFRRZAOA7D/1zlvRQwoAAOSlhr4Hl3uJIfsoseWA4Wv2SFpJEgAA5J9li2eyCgA5Q5ENdhPY7Fed10MQAAAA6UCRDQCyqmBGfb2ztJwgAADITwYRZB8lNh7sAAAgSbWeElVWldWSBHKJIhvsIrDZrwWNrF4BAABIq8IiFTXeIoermCwAIBtPu/NXHicFAADykkEE2UeJjQc7AABI0orFM1kBAFOgyAaro8AGAACQOY7pNSpet4UiGwBkQeGVC8scriKCAAAg/xhEkH2U2HiwAwCAJJQVF6p+TlU9ScAsKLLBqq6+bSkFNgAAgAyjyAYAWeJ0lhTM9PKLFQAA8k9D34PLvcSQ5UMnIsgJDxEAAJBfFs2tGSAFmA1FNljNvMZ6LQ3QFwYAAMiGWJENAJBZRb7rhkkBAIC8MyC6Pdk/T41EIqSQA4av2SvJr/GpbIaklaQCAIB5PfC5VYPOAmcJScCMThUf05PP/UNGP0dVZZU+t+6rKhzixwCZMa+xXus2LyUIAACALBs78p6G3n6BIAAgg4be/LFG+44SBAAA5tUtKSipQ1Kwese+DiLJPkpsJmL4mg2NF9pi5bYKUgEAIPcWzPYMrl87n+YOTI0iG/LZ7MUzdcMXuK8HAAAgVyiyAUCGn2f7P+4Jvf4co8cBADCPdkULaxovrfUTSe5RYjMxw9fsV+K0tgZSAQAg+5puX3a8bJq7hiRgdhTZkI8q6yp061eulau4gDAAAAByaOTAmwq/t4sgACBDQsFWjZ39hCAAAMi+ASVOWQsSiTlRYssjhq/Zo8RJbRtIBQCAzKr1lOiOW1hvh/xBkQ35hAIbAACAuYQ7XtRI936CAIAMGDny/vHhX7/GjbIAAGTeXiVOWesikvxAiS3PRVeQxkptfjGtDQCAtLopMK+nfk4Vo/6RVyiyIR+43C7dtW2tyj1uwgAAADARimwAkCFjY4ODP/9BSSQ8TBYAAKRXu6KFNUkdrAbNX5TYLMbwNXuVOK1tJakAAJCasuJCNW3yEwTyEkU2mJnL7dItW9eoqq6MMAAAAMxmZFhDr7VprL+XLAAgzYbfeWVw5PABfpECAEDqupU4Za2DSKyDEpvFRVeQxgptRvS/V5AMAACXd/WiuoGVK2fzuom8RZENZnXz1jWq83oIAgAAwKwosgFAZoSHB87ufILfNwIAkLy9Spyy1kUk1kWJzYYMX3P8+lFDrCAFAOCC7tvkP1lUXFhJEshnFNlgNoHNfi1orCMIAAAAk4sMntbQS08qEh4iDABIo6E3f6zRvqMEAQDApw0occpakEjshRIbYitI44ttG0gFAGB3C2Z7BtevnU8jB5ZAkQ1msWKjT/6NcwkCAAAgT0ROHdfQq20U2QAgjUZ7e3qG3nqxniQAAFC3EqessRrU5iix4YIMX7OhxGltjDYGANjK5psWH6usKqslCVgFRTbk2rzGeq3bvJQgAAAA8szYkfc09PYLBAEAaRQKtmrs7CcEAQCwm3ZFC2san7TWTySIR4kNSYlOazM0UWxbSSoAAKsqKy5U0yY/QcByKLIhVyrrKnTXtgBBAAAA5CmKbACQXiOHOgaG33+bARIAACsbUOKUtSCR4HIosSElhq/Zo8RJbawgBQBYxtqVs4/7FtXVkASsiCIbsq2yrkK3fuVauYoLCAMAACCPhTte1Ej3foIAgLQ8qQ6fPLvziUqCAABYyF4lTlnrIhJMFiU2pI3ha44V2gyNl9saSAUAkG+KCp364ib/oLPASfsGlkWRDdnicrt0y9Y1qqorIwwAAAALGH79aY329hAEAKTjOXX3To0cPUwQAIB8FVsNGtT4pDVWg2LKKLEhY+JWkMbKbawgBQCY3oLZnsH1a+fTuoHlUWRDNty5bT0FNgAAACsZGdbQa20a6+8lCwCYorH+j3tCrz9XTxIAgDzQrcQpax1EgkygxIasMnzNhhKntVWQCgDATJpuX3a8bJqbVaKwhWwU2e64cYsanMsI24YCm/1a0FhHEAAAABYTGTytoZeeVCQ8RBgAMEWhYKvGzn5CEAAAs2lXtLCm8SlrXUSCbKDEhpyKriCNX0PKClIAQM5Ulhdr8x3LCQK2kskiW0O9V7cvu1+OUSdB28yiwDxde9tCggAAALCoyKnjCr30JEEAwBSNHOoYGH7/bQY+AAByaUCJU9aCRIJcocQGUzF8zR4lTmrbQCoAgGz57HVzjzV4q2tJAnaTqSLbH979lyoKTSNgm5m9eKZu+MJKggAAALC4sSPvaejtFwgCAKYiPHzy7M4nKgkCAJBFe5U4ZY3VoDANSmwwvegK0vhpbdyRAgBIu6JCp764yT/oLHCWkAbsKN1FNtaI2lNlXYVu/cq1chUXEAYAAIANjLz7ssIf7iYIAJiC4d07NXL0MEEAADKlXYmT1vqJBGZFiQ15x/A1e5U4rY0xDwCAKVsw2zO4fu18CmywtXQV2Vgjak8ut0u3bF2jqroywgAAALCR4def1mhvD0EAQIrG+j/uCb3+XD1JAADSoFuJU9aCRIJ8QokNeS+6gjR+UhsrSAEAk9Z0+7LjZdPcNSQBu0tHkY01ovZ089Y1qvN6CAIAAMBuRoY1FHxSY2dOkQUApCgUbNXY2U8IAgAwWXuVOGWti0iQzyixwZIMX3Os1Bb7zwZSAQBcTGV5sTbfsZwggKipFNlYI2pPV9+2VEsD3DQOAABgV5FTxzX0apsi4SHCAIAUjBzqGBh+/+0KkgAAXMKAJqasBZmyBiuixAZbiK4gjZ/WxgpSAMA5a1fOPu5bVMcUNiBOKkU21oja07zGeq3bvJQgAAAAbG7s2CENvfEsQQBAKsLDJ8/ufKKSIAAAcbqVOGWtg0hgdZTYYFuGr9lQ4rQ27nABAJt64HOrBp0FzhKSABJNtsjGGlH7qayr0K1fuVau4gLCAAAAgEYOvKnwe7sIAgBSMLx7p0aOHiYIALCvdiVOWusnEtgNJTYgKrqCNH5aGytIAcAGFsz2DK5fO58CG3ARyRbZWCNqPy63S3dtW6tyj5swAAAAcM7w609rtLeHIABgksb6P+4Jvf5cPUkAgC0MKHHKWpBIAEpswEUZvmaPEie1bSAVALCezTctPlZZVVZLEsDFXa7IxhpRe7p56xrVeT0EAQAAgEQjwxoKPqmxM6fIAgAmaXDnE4qEhwkCAKxnrxKnrHURCfBplNiASYiuII2V2vxiWhsA5LWy4kI1bfITBJCESxXZWCNqPys2+uTfOJcgAAAAcEGRU8c19GqbIuEhwgCASQh3/vJk+OC+SpIAgLzXrmhhTVIHq0GB5FBiA6bA8DV7lTitbSWpAED+uHpR3cDKlbMrSAJIzoWKbKwRtZ/Zi2fqhi9w2AsAAIBLGzvynobefoEgAGAywsMDZ3c+we8rASC/dCtxyloHkQCpocQGpFF0BWms0GZE/zsnGwBgUvdt8p8sKi7kzkZgEuKLbKwRtZ8yT6nu/tO1chUXEAYAAAAuK9zxoka69xMEAExC6LUfaWzgBEEAgHntVeKUtS4iAdKDEhuQYYavOX79qCFWkAKAKdR6SnTHLUsJAkhBrMjGGlH7uXPbelXVlREEAAAAkjMyrKHX2jTW30sWAJCk0Y+7jw396me1JAEApjCgxClrQSIBMocSG5Bl0WlthiaKbRtIBQCy76bAvJ76OVX1JAGkZtQ1rIJwEUHYSGCzXwsa6wgCAAAAkxIZPK2hl55UJDxEGACQjLGxwbM//ZcSggCAnOhW4pQ1VoMCWUSJDTABw9dsKHFaGytIASCDigqduu/3VhEEACRpXmO91m1meiUAAABSM3bskIbeeJYgACBJw++8Mjhy+ABFNgDIvHZFC2san7TWTyRA7lBiA0zI8DV7lTitbSWpAED6LJjtGVy/dj6/BAKAJFTWVejWr1wrV3EBYQAAACBlI+++rPCHuwkCAJIw1v9xT+j159giAQDpNaDEKWtBIgHMhRIbkAfiVpDGJrWxghQApqDp9mXHy6a5a0gCAC7N5Xbplq1rVFVXRhgAAACYsqH2H2isv5cgACAJoWCrxs5+QhAAkLq9Spyy1kUkgLlRYgPylOFrjhXaDI2X2xpIBQAur6y4UE2b/AQBAEkIbPZrQWMdQQAAACAtIoOnNfTSk4qEhwgDAC4j3PnLk+GD+ypJAgCSMqBoWU0Tk9ZYDQrkGUpsGdAWaOmPf3Lcsmt7kFSQadEVpPHFNlaQAsAFXL2obmDlytkVJAEAlzZ78Uzd8AUOKQEAAJBeY8cOaeiNZwkCAC4nPDxwducT/B4TAC6sW4lT1jqIBJkWanX4NdHJ8Et6xN0UeYZk0ocSW5q1BVoMSS9d4P9qV1zzd8uu7bR+kXGGr9lQ4rQ2TnYA2N59m/wni4oLuYMRAC6hzFOqu/90rVzFBYQBAACAtBt592WFP9xNEABwGaHXfqSxgRMEAQCJfYsOVoMiK6/DrQ5DE10LQ5/uW3zH3RT5OkmlDyW2NGsLtHxd0qNJvGusGRzU+LQ2msHIuOgK0vhpbawgBWArtZ4S3XHLUoIAgMu4c9t6VdWVEQQAAAAyY2RYQ6+1aay/lywA4FJPl0fePz7869dqSAKAzQwoccpakEiQaaFWh1eJU9Y2JPHX2t1NEYP00ocSW5q1BVoel3R/ik/E8ZPaeCJGxhm+Zo8SJ7VtIBUAVnZTYF5P/ZyqepIAgItbsdEn/8a5BAEAAICMipw6rqFX2xQJDxEGAFzM2Njg2Z/+SwlBALC4vUqcssYAIGRcdDWooYniWkoDgNxNEQdppg8ltjRrC7R0KX3TrfYqcVpbFwkj06IrSOOntbGCFIBlPPC5VYPOAie/9AGAi6j11uiWrdcQBAAAALJi9DcdGv51kCAA4BKGd+/UyNHDBAHAStqVOGmtn0iQSaFWh0eJHQi/0teDaHQ3RShepgkltjRqC7R4JJ3M4KfoVuK0Nn4QkHGGr9mrxAbySlIBkI8WzPYMrl87nwIbAFyEy+3S5/7CkKu4gDAAAACQNeG3ntfIRx8SBABcxGhvT8/QWy+yXQJAvkroODBlDdkQXQ1qKDsdhz9wN0UeJ/X0KCSCtPJn+OM3RN/ukaS2QIt0Xkt5y67ttJSRVsHOh7oknXvSja4gjW8ps4IUQF5YNP+K45L4ZQ8AXMTazSspsAEAACDrXI03a7S3h7WiAHARBTPq6x2uIkXCw4QBIB/Ets3Fpqx1EQkyLdTqMJS7bXN+vgPpwyS2NGoLtDwi6WETvCjET2vjRQEZZ/ia07IvGgAypajQqft+bxVBAMBFLArM07W3LSQIAAAA5MTYid9q6JU2ggCAixh+55XBkcMH2DIBwGwGlDhlLUgkyLToalBDE92EXA/d2etuilBkSxNKbGnUFmh5RtEpaSZ74QhqYlIbLxzIuOgK0vimMytIAeQUq0QB4OLKPKW6+0/XMoUNAAAAOTXy7ssKf7ibIADgAsb6P+4Jvf4cWyYA5Fq3EqessRoUGRdqdfiV2D0w3UAdd1PEwXcqPSixpVFboKVL+TGBql2J09pYQYqMM3zNsReV2AtMBakAyJam25cdL5vmriEJAPi0O7etV1VdGUEAAAAgt0aGNfRam8b6e8kCAC4gFGzV2NlPCAJANiX0Cqp37KNXgMy/3o2vBjWUX72Cje6mSJDv3tRRYkuTtkCLR9LJPP3yExrTW3ZtpzGNjIuuII1fQ8q0NgAZUVZcqKZNTPEFgAtZsdEn/8a5BAEAAABTiJw6rtBLTxIEAFxAuPOXJ8MH91WSBIAMiW14C0rqYDUosiHU6vDKGhve/tzdFHmM7+jUUWJLk7ZAiyHpJQu9QHXEv0gxrQ2ZZviazba7GoBFLJ9Xc3L1ai+/3AGA81TWVeiubQGCAAAAgKmMHHhT4fd2EQQAnCcSOnN88BdPsW0CQLrsVeKUtS4iQaZFV4MamugFNFjkn/a/3U2RB/gOT10hEaSNYaF/S4XGC0QbJD0sSW2Blr1KnNbGixjSKtj5UL+kZ6Jv4z9U4ytIHG8USgAAIABJREFU/RZ8EQOQRUsW1Y2SAgB82tp7VxACAAAATKdw4XUa/d2HrBUFgPM43GU1ztJyVooCSFW7EietMcQGGRVqdXiUOGXNykNsWAmVruMdJrGlR1ug5RlJ99jon9ytiWZ2x5Zd24M8CpBphq/Zq8RpbawgBXBJrBIFgAu7+ralWhqoJwgAAACYUmTwtIZeelKR8BBhAEAcVooCSFL8tfxg9Y59HUSCTIuuBjU0cT3fVtfy3U0RB4+CqaPEliZtgZYuMSUq1t6OTWujvY2Miq4gPX/kaAXJAIhZu3L2cd+iOkbsA0CcWm+Nbtl6DUEAAADA1EZ/06HhXwcJAgDihYcHzu58gusgAM4X26oW1PiUtS4iQaaFWh2GEq/V2/31aaO7KcIJzBRRYkuDtkCLR9JJkviU7vgXyy27ttPwRsYZvub49aOGKJcCtnbfJv/JouJC7kwEgCiX26W7tq1VucdNGAAAADC94def1mhvD0EAQJzQaz/S2MAJggDsa0Bxg2Wqd+wLEgky/tozvhrU0MR1+A2k8il/7m6KPEYMU0OJLQ3aAi2GpJdIYnIvqKwgRTZEp7XxggrYUGV5sTbfsZwgACAOa0QBAACQT1grCgCfNnLk/ePDv36N7ROAfSQMjmE1KLIh1OpgcMzk/W93U+QBYpgaSmxp0BZoeUTSwySRkoTRplt2be8iEmSa4Ws2znvRZfQ2YEGsEgWARKwRBQAAQD5irSgAnCc8fPLszifYPgFYV7sSJ631EwkyLboaNPbmF9fPU7HX3RTxE8PUUGJLg7ZAyzOS7iGJtOhW4rQ2muTIOMPX7D3vRXklqQD5j1WiADCBNaIAAADIZ6wVBYBErBQFLCO2ySyo8SlrQSJBxl9DWh1eJQ584dp4mribIg5SmBpKbGnQFmjpEuMTM6ldidPaaJsjo+JWkMZeuFlBCuQZVokCQCLWiAIAACCfsVYUABKxUhTIW7EtZbEpa11EgkyLWw1qaPz6N92WzGl0N0UY1DQFlNimqC3Q4pF0kiSy/uLeEX2BD7KCFNlg+Jp5cQfyCKtEAWBCZV2F7toWIAgAAADktZEDbyr83i6CAACJlaJAfhhQ3DVtjU9aY1gLMirU6mBYS279gbsp8jgxpK6QCKaMnbbZtzL6dr8ktQVaEsasbtm1PUhESLdg50Md0QPNx6RzK0jji22MWQVMZO7cmgJSAIBxa+9dQQgAAADIe4ULr9Po7z7UWH8vYQCAq6jSWVHFSlHAXLqVOGWNaUzIuOiUtdg1a7+4Zp1r9IemiElsU9QWaPm6pEdJwnTalTitjVY7Ms7wNRtKnNZWQSpA9rFKFAAmrNjok3/jXIIAAACAJUROHVfopScJAgDESlHABOKvR3ewGhTZEGp1GEqctMb1aJM9L7ibIgYxpI4S2xS1BVoeV3QiGEwt1nwPanxaG813ZFx0BWn8tDZWkAJZwCpRABjHGlEAAABYEWtFASCKlaJANsU2g8WmrAWJBJkWanV4lThljdWgecDdFHGQQuoosU1RW6ClQ4xkzNcDjfhJbRxoIOMMXzM7yIEsuG+T/2RRcSG/vAFgezdvXaM6r4cgAAAAYC0jwxoKPqmxM6fIAoDthV77EStFgczYq8QpawxIQeaf08dXgxqauJbMgJT81OhuivCckSJKbFPUFmghQGsdjARjByRbdm3vIhJkWnQFafy0Nka+AlPAKlEAGLcoME/X3raQIAAAAGBJYyd+q6FX2ggCgO2xUhRIm3YlTlrrJxJkUqjV4VHiNWKGn1jHZndT5BliSA0ltiloC7QYkl4iCcvqVuK0NtqyyDjD1+xVYsOeSY/AJLBKFAAkl9ulz/2FIVdxAWEAAADAssIdL2qkez9BALD5kyErRYEUJFwDZsoasiG6GtQQ14Dt4JvupsgjxJCaQiKYEi8RWFpD9O0eSWoLtEjntfC37NpOCx9pFex8qEvS47H/HV1BSgsfSNLcuTU0NgDY3trNKymwAQAAwPJcywyNfnRQkfAQYQCw8ZNhUaWzooqVosClJWzjqt6xr4tIkGmhVochtnHZlUEEqWMS2xS0BVoek/Q1krD9QU/8tDYOepD5Vz1fM/vQgQtglSgASLXeGt2y9RqCAAAAgC2MHXlPQ2+/QBAAbI2VokCCASVOWQsSCTItuhrU0MS1W4aS2Px5yN0U8RBDaiixTUFboCXIExAucGAU1MSkNg6MkHHRFaTxxTael2BLK+bP+OiaqxuuJAkAduVyu3TXtrUq97gJAwAAALYx/PrTGu3tIQgAthUJnT02+It/rSUJ2FS3EqessRoUGRdqdfiVOGWNgSM4X6W7KcJWvxRQYpuCtkBLvxj7iMtr10Tjv4NpbcgGw9ccO2iKHUDxXAXLa7p92fGyaW7uOARgWys2+uTfOJcgAAAAYCuRU8cVeulJggBga6Fgq8bOfkIQsIP4667B6h37KIkg88+x46tBY29+cd0Vl7fR3RQJEsPkUWJLUVugxSvpNySBFCTcEbBl13buCEDGRVeQxk9rW0kqsJKy4kI1bfITBAD7Pg96SvV7268nCAAAANjSyIE3FX5vF0EAsK1w5y9Phg/uqyQJWExsA1ZQUgerQZENoVaHV4lT1rimilR8090UeYQYJq+QCFLGlXKkqkHS/dE3tQVaEnaza3xaG3cNIK2CnQ91RB9nj0uS4WtmNzssZd4sz0lJ/JIGgG2tvXcFIQAAAMC2Cuc1avTwuxo7c4owANjzebBh6Wj44D6CQL7bq8Qpa11EgkyLrgY1NHHdlNWgSAcvEaR4TEMEKaPEhnSp0HiBaIOkhyWpLdCyV4nT2jhIQ1oFOx/ql/RM9E3SuRWkfg7SkI+WLKobJQUAdjV78UzVeT0EAQAAAPsqLJJruaGhN54lCwC25HCX1ThLy1kpinzTrsRJawz5QEaFWh0eJU5ZY8gHMoU+UarHNKwTTU1boOUZSfeQBLKkWxN3HnRs2bU9SCTINMPX7FXitDbG5cKUigqduu/3VhEEAFtyuV26a9talXvchAEAAADbG379aY329hAEAHs+B77zyuDI4QMlJAGT6lbcAI/qHfs6iASZFl0NamjieifXOpE17qaIgxQmjxJbitoCLV1iShFyq12J09q4OwEZF53WFn+wV0EqyLUFsz2D69fO55czAGxpxUaf/BvnEgQAAAAgKTJ4WqEXv0cQAGxprP/jntDrz9WTBEwitnUqqPEpa11EgkwLtToMJQ7o4DomcqnR3RShsDtJrBNNHQU25FpsBakkqS3Q0h1/MLhl13aeEJF2wc6HYo8xSZLha/afdzDIcyOybtH8K45L4pczAGynzFNKgQ0AAACI4yiZJtf8VQp/uJswANiO03NFvcNVpEh4mDCQbQNKnLIWJBJkWnQ1qKGJ65SsBoXZ+KPPi5jMOR2T2CavLdBiSHqJJJBPB4ysIEU2GL5mDhiRdVubriEEAPZ83f3CNZqzuIYgAAAAgHgjwwq9+D1FwkNkAcB2hnfv1MjRwwSBTEsYrMFqUGRDqNXBYA3km2+6myKPEMPkUGJLQVug5QFJ/0ISyEMJo3u37NreRSTItLgVpIzuRdrVzyjXTTcsIggAtlPrrdEtWynxAgAAABcyduQ9Db39AkEAsJ3R3p6eobdeZGsF0q1diZPW+okEmRa3GtTQ+DVGri8i75473U0Rgxgmh3WiqfETAfLUyujb16SEFaSxaW3cKYG0u8AKUu95B50rSQmpWjT/ih6xShSADa29dxkhAAAAABfhnL1YzoO7NdbfSxgAbKWgehYj2zFV3YpeN9T4lLUgkSDTQq0OrxIHYnDtEFbgJYLJYxJbCtoCLUGxIg/WFbubIqjxaW3cTYGMiq4gjR2UGjy/YjIe+NyqQWeBs4QkANjJosA8XXvbQoIAAAAALmHsxG819EobQQCwnaE3f6zRvqMEgWTFtjjFpqx1EQkyLTplLX49KKtBYVWV7qYIfYtJoMSWgrZAS78YVwl7HbzG7rgIsoIU2WD4muNLbRy84sJHfeXF2nzHcoIAYCsut0uf+wtDruICwgAAAAAuI/zW8xr56EOCAGArI0fePz7869eYyIYLGVDcNT+NT1qjXIGMCrU6PEqcssYwC9jJRndTJEgMyaPENkltgRaPpJMkAZsf4J47uN2yaztPusi46ArS+GIbY4ShtStnH/ctquOXMQBs5erblmppgC3KAAAAQDIig6cVevF7BAHAXsLDJ8/ufKKSIKDx1aBBTUxZ6yASZFqo1eFX4pQ1runBzv7c3RR5jBiSV0gEk+YnAthchaR7om9qC7RI4ytI46e1cdcG0irY+VCXpC5Jz8T+zPA1G0qc1saETJupr68cJQUAdlLmKaXABgAAAEyCo2SaXIsDCr+3izAA2IerqNJZWq6xs5+Qhf3EX6/rYDUosiG6GtTQRHGN63XABC8RTA4ltsmjxAZ82obo29ckqS3QEruzI6jxaW3c2YG0C3Y+FHuMSTq3gjR+WhsrSC2srLhQpWXFtSQBwE5W37aEEAAAAIBJKpzXqJEPdysSHiIMALZRMHPuybGD+5jGZm2xzUmxKWtBIkGmhVodXiVOWWM1KHBp9IsmiXWik9QWaHlc0v0kAUz6QDp+UhsH0sg4w9fsUeKdHxxIW8iC2Z7B9Wvnl5AEALuo9dbolq3XEASAC+ru7taZM2d05swZHTp48Nyff/DBBzp9+nTC+77z7jvq6+tL+mNXV1dr2dJlCX82bdo0LViw4Nz/nnfVVSorK1NZWZkaGriXBABgPqO/6dDwr4MEAcA2ImcGfjvY/sNZJGEpexV3rY0pa8iG6GpQQxPX2jjpByZnwN0U8RBD8iixTVJboCUoihBAug62g7ED7i27tnOwjYyLriCNn9bGSOM8dZexsGdG7XR26gGwjZu3rlGdl3NdwK5iJbV9v/61PjnziQ50HtCpU6e0p2OPab/mRn+jpk+froW+hSovK9fyFSsouQEAcmroZ/+ssTOnCAKAbQzufEKR8DBB5K92JU5a6ycSZFKo1eFR4jU0OhFAesx1N0W6iCE5lNgmqS3QQmBAZnQrcVobK0iRcYav2avEO0hWkkp+2NrENCIA9jGvsV7rNi8lCMAOJ0Xd3fr444916OBB7d69W0eOHNHBQwct9++8at5Vmj17tlatWqXaujrNnTuXchsAIOPGjh3S0BvPEgQA2xjevVMjRw8TRJ6cDipxyhrXyJBx0dWghrhGBmTaRndTJEgMyaHENgltgRavpN+QBJA1CXeZbNm1nbtMkFHRFaTcZWJy9TPKddMNiwgCgG3cu91QucdNEIDF9Pb26t1339XBgx/qQOcBtb/cbvtMGv2N8i3yaf78+Vq+fAXFNgBA2g2//rRGe3sIAoAtjPb29Ay99SLbLMwpYVsRq0GRDaFWhyG2FQG58E13U+QRYkhOIRFMipcIgKzaoLgSUVugZa8Sp7VxUI+0CnY+1B97fMX+zPA1xw7oY//JlbQca5hd+VtJs0gCgB0sCsyjwAZYRHd3t/bt+7U69nRo1xu71NfXRyjn2dOx51MrUjdcv0GrVq3S8hUr5PV6VVpaSlAAgJQVLlpDiQ2AbRR4astJwRQGlDhlLUgkyLToalBDE9e2GNoA5I6XCJLHJLZJaAu0PCLpYZIATHXgH9TEpDYO/JFx0RWk8cU2Dvyz7L5N/pNFxYWVJAHA6lxulz73F4ZcxQWEAeSh2KS1V195hdJaGjX6G3XN6msUCHxGS5YsIRAAwKQxjQ2AnYRe+5HGBk4QRHZ1a+Jm+Q5WgyIrP+utDr8Sp6wxkAEwj3Z3U8QghuRQYpuEtkDL45LuJwnA3C8CmrijpYNpbcgGw9ccOymInSAwgjlDyooL1bTJTxAAbGHFRp/8G+cSBJBHuru79bOf7dSv3vrVpyaKITPuvONO+Rv9uu66NZoxYwaBAAAuKzJ4WqEXv0cQAGwh3PnLk+GD+7ghOLPir0sFq3fs6ycSZFp0NWjszS+uSwGm5m6KOEghOZTYJqEt0BIUE3eAfBO74yU2rY07XpBx0RWk8dPaVpJKeiyfV3Ny9Wovv3QBYHlMYQPyx1tvvaXXXntVO3fuZNpajl017yrd8NkbdOONN6mhgZvOkXu9vb36xc9/bpl/T21dnQzD4BsLSwh3vKiR7v0EAcDyImcGfjvY/sNZJJE2sQ1BQY1PWQsSCTIt1OrwKnHKGtecgPwz190U6SKGy6PENgltgRbCAqxxgtERf5KxZdd27opBRhm+Zo8SJ7VRiE7RXcbCnhm10+tJAoDVXX3bUi0N8HQHmNX+/fv14osvUFwzserqat10001au3adVq9eTSDI2XPF1q1/YJl/z4brN+j/+du/5RsLS2AaGwA7Gdz5hCLhYYJIzV4lTlnrIhJkWnQ1qKGJ60rcpQXkv43upkiQGC6vkAiS0xZo8ZICYAkVGi8QbZD0cPTne68Sp7VxEoK0CnY+1C/pmeibpHMrSP2chEwOBTYAdlDmKaXABphQb2+vnn32P/SLn/9CBw8dJBCT6+vr01NPPaWnnnrqXKFt8+Z7mdAGAJAkOUqmqbBhCdPYANhCQXWdRo4eJojktCtx0hpDEJBRoVaHR4lT1hiCAFiTEX1twWVQYkuelwgAy1qpuNG7bYGWbk3cWdOxZdd2XlCQdsHOh2Inwo9JkuFr9ipxWhvjoM9T6ykhBAC2sGLjQkIAzHTcFgzq//zkJ2p/uZ0w8lR8oS22cvTuu+/RjBkzCAcAbMy1zNDoRwcVCQ8RBgBLK6hf1DNy9DB3y31at+IGHFTv2NdBJMi06GpQQxPXg7gWBNiDhwiSQ4kteX4iAGyjIfp2jyS1BVqkibtvYtPauPsGaRXsfKhL0uPxfxad1hZ/MlNh54zmN1Qfl1TDowWAlZV5SrWgsY4ggByLTV3793//d9aFWszBQwd18NBB/dM//ZM2XL9Bt91+u6699lqVlpYSDgDYTWGRCuevUvi9XWQBwNIKPLXlpCBpfDVoUBNT1rqIBJkWanUYShxgUEEqgC3RN0r2NI0IkuYlAsDWYitIJZ2b1nbuZGfLru3coYO0i5vWJkkyfM3+8052bLULqb6+cpRHBQCrYwobkFv79+/Xvz/9tJ7/8fOEYQPtL7er/eV21o0CgI0VzmvUyIe7mcYGwNpcRZXO0nKNnf3ETv/qASVOWQvyQECmRVeDGpq4jsNqUAAxlNiSPUcjAh5UAFLSIOn+6JvaAi0JJ0SsIEUmBDsf6og+xiRJhq/ZNidEZcWFKi0rruVRAMDKmMIG5PA4KxhU61NPaU/HHsKwofh1o7HpbIZhEAwA2AHT2ADYRMHMuSfHDu6rtPA/MWHwAKtBkQ2hVoetBw8AmJSKUKvD426KsO3tcqdoRJA0SmwALvnCo/H1o/dIeji6gjRhNPWWXdu7iAnpFOx8qF/SM9E3SedWkMZOmAxZZDT1lTPKByWV8F0HYGVMYQNycDwVDOqfvvtdHTx0kDAgaWI621XzrtLdd9+tu+6+m1WjAGBxTGMDYAcFtd5PwtYqsbUrcdIapQBkXNxqUEPj12FYDQpgMvyK28CFi5yfEcHltQVaPLwIAUjByujb16LPJd1KnNbGnUBIu7gVpI9JkuFr9p53UrUyH/9d3vqq45Lq+Q4DsCqmsAFZPmaivIbLOHjooB597FF9/4nv66abbtLv//59mjFjBsEAgBUxjQ2ADTin19Tk8Zffreh1FY1PWQvyHUWmhVodXiVOWVtJKgCmiBJbMqdnRJD0gwkApur8FaTSxN1CQY1Pa+NuIaRVsPOhLkmPR99iK0jjJ7XlxQrS2trp5Xw3AVgZU9iALB0bUV7DJMWvGv385z9PmQ0ALIppbAAsz+ksKaiu02jf0Xz4amNbbmJT1rr4BiLTolPW4teDshoUQLp5iCCJczMiSIqXCABkyIbo28OS1BZo2auJO4qCrCBFukVXkAYV1/Q3fM3xpTbTnZxVlherqLiwku8eAKtiChuQefv379ff/a//pT0dewgDKaPMBgAWxjQ2ADZQUFt/bLTvaK3JvqwBxV0T0fikNW72R0aFWh0eJU5Z20AqALLAIIIkTs2IICleIgCQJbEVpLFpbQNKnNQWJCKkW7DzoY7oLwriV5DGF9tyOiZ79hXTTkqixAbAspjCBmROb2+v/se3v632l9sJA2lDmQ0ArIlpbACsrmBGw4j0Vq6/jG4lTlnr4DuDTAu1OvxKnLLGalAAueAlgiTOy4ggKQYRAMiRCkn3RN/iV5DGT2vjriSkVXQFaZekZ869EPqaDSXemVSRtSO6OVWfiBIbAItiChuQGWfPntVzzz6rRx97lDCQMZTZAMBimMYGwOIcZRWzHK4iRcLD2fy08dczOlgNimyIrgY1lIPrGQBwCawpTua0jAiSwm5aAGYSW0H6NUlqC7Qk3Lm0Zdd27lxC2gU7Hwrq0ytI46e1ZezAq7qmvIbvAACrYgobkH5vvfWWHnv0UR08dJAwkBXxZbavfvVBlZaWEgoA5CmmsQGwuoLqOo0cPZypDx/bLBObshYkcWRaqNXhVeKUNVaDAjDzc5bf3RThWv6lzsmIICmMFAVgZg0aXz8av4I0flIbJ4pIu7gVpI9LkuFr9ijxzqa0nCjWekrkLHCWkDgAK2IKG5BerA5Frj311FPauXOnvvylL+uuu++mzAYA+aiwSIUNSxX+cDdZALCkgtqG344cPTwrTR9ur+KuRTBlDdkQXQ1qaOJaBJONAOQTb/S1Exc7JSOCS2sLtPhJAUCeqdDEtLaHoytI9ypxWhsnk0irYOdD/RpfP3r+CtL4aW2THtk9Z6bnmKRaEgZgRUxhA9Ln+eef0z/+4z+qr6+PMJBTfX19evSxR/Xss8/qj776VRmGQSgAkGcK5jVSYgNgWc7q2VO5NtyuxElr/SSKTAq1OjxKvMbAlDUA+c6vuGup+DRKbJfHKlEAVrBScVMloytI46e10fhG2sWtIH1Mkgxfs1eJd0hddtLpnPrKEZIEYEVMYQPSg+lrMKuDhw7qr/7qP2vD9Rt0/wMPaMmSJYQCAHnCUTJNhQ1LNNK9nzAAWO85zl1a63AVKRIevty7JlxDqN6xj2sIyLjoalBDk7iGAAB5xksEl0aJ7fIMIgBgQQ3Rt3skKTqtLeEuqi27tnMXFdIq2PlQl6LrR6VzK0jj76Ly67xpbRWVpbNIDoAVXdVYTwjAVI8tgkF9+9t/y/Q1mFr7y+1qf7ldn//85/XVrz7IilEAyBOFvgAlNgCWVVBdp5Gjh8//49g2l6CkDlaDIhtCrQ5DU9zmAgB5xksElzkXIwIeRAAQFVtBKklqC7Ts1cSdVh1Ma0O6RVeQBqNvkiTD1xw7YfXPrCy9VawSBWBBLrdLSz8zhyCAFJ09e1Yt//N/6vkfP08YyBtPPfWUdu7cqW984/9ixSgA5AGmsQGwsoK6uYdGjh7u0cSUtSCpINOiq0ENTZTWWA0KwI547rsMSmyX5yUCADYVW0F6vyS1BVoGlDipjRNbpF2w86GO6GNMkvT9v/mpN+6k1s/BHQArWByYJ1dxAUEAKeju7tZ/+eu/1sFDBwkDeaevr+/citG//MY3NGPGDEIBABMrnLeKEhsAy5xKKW7KWvmf/H1HOZkgw0KtDr8Sp6w1kAoAjJd63U0RNqJd7DyMCC7LTwQAIGl8jPM90beH41aQxk9r6yImpNOXv3Vrl6QuSc/E/uz7f/PT2Elv7ASYEeMA8gpT2IDUPP/8c2pubiYI5L3YitE///qfq+nznycQADApx/QaFcyo12hvD2EAyLtDTk383j5Ycs/XuVCOjIuuBo29+cXv7QHgYvyK21KFRJTYLo8XWAC4uNgK0q9JUlugJXZHV2xaGytIkXZf/tatwfiDu+//zU/j7+jya3yCIACY0rzGeqawAZN09uxZffe7O/TUU08RBizl0cceVTAY1F/99V+roYGhBABgRoWL1lBiA2B2sQ0qQUkdJfd8PUgkyLRQq8OrxClr/E4eAJLnJYJLnIMRwcW1BVoMUgCASWnQ+PrR+BWkHfEn0Vt2beeuL6TVl791a2wF6eOS9P2/+alHiZPaWEEKwDT8G68iBGASent79Tf/7b9pT8cewoAl7enYo6am/8RUNgAwKWfVLDk9MzTW30sYAMxir+JuJC+55+tdRIJMi64GNTTxe3fuwgGA1HmJ4OIosV2ahwgAYEoqNDGt7WFJagu0JJxks4IU6fblb93ar/H1o/ErSDnJBpBzsxfPVLnHTRBAkrq7u7Vt25+or6+PMGB5jz72qHbv3q2//MY3NGPGDAIBABNxXfX/s3f/0XHfZX7on5Fs/RjbshJF/gFORrFcIKIhEnsU1rcQT6G763OxcXvvZi2gdViWhMIujR1KYm6NE0wu+UEj+3TvEjambOqWrLymWw5xer2bhY5y3EO76WKLLgaWOJbOsluIqkuSEuGQIN8/NGPNOLHjHzOjmfm+XufMCdiJ7M/7+7U83888n+d5a7z4F38iCGC+jEZppzWHxKmok/tTDokDVFa/CM5OEZubB6Daroui1tL5bm2nH8Jv/OZtORFRbkXd2vZEROzbeajnjAdx7c6Biutbq34Wzlcul4vt2+8QBIky+sRo/OV3/jI+8YnbI5vNCgSgRjStuiaavvfNmHnheWEAlTYRpV3WjoqESsuPBs3G3H65vXKAytJM6xwUsZ1bjwgAKm5pRGzKv+LA2uGIudNlhW5tTpdRVlt2rR+P/PjRgn07D2XPeFhfKimgXJb3XBErejybwvk4ePDRuPvuuwVBIk1NTcX27XfEhndviNs+/vFIp9NCAagBC3rfGj//dk4QQLkVppbkYrbL2rhIqLST+1PZKD3gbR8coLp0uDzXs5cIzqlHBADz9pf36b/AD6wdnojSbm1OoFF2W3atL9xjEVEygrTwTy2UgIu2emCVEOAZhvHiAAAgAElEQVQ87NmzO0ZGRgRB4h187GB897vfjc/ec09kMt6GAsy35iv7IvXdb8apl14UBnCxChNJCl3WciKh0opGg2Zjdp9b4QRAjXx/btt8ShOXV6GI7dyMEwWoDZmIuCn/Kh5BWujU5oGfsisaQRoREft2HvLAD1yURZ3p+DsDKwQBr0EBG5Q6/vTx2Lz5N2LHjh2xYcNGgQDMpwUt0fy63nh54pgsgPM1Fvn965jtsuZgNhV3cn/KwWyA+tAfRY01KHr0EsE5aZ8KULvfnwsjSO/MjyAtab1+4zdvGxcT5bRl1/pnI+Kr+VdEnB5BWtgQyHrvALya3oErhQCvQQEbnN3dd98dR48cNV4UYJ4teONaRWzAuYxGaac13VWoqHyXteK96f6wPw1QL3pEcJbnLhG8ugNrh7NSAKgr1+Vft+a/j0/E3Em3nBGkVELRCNI9ERH7dh7qOWPT4DopQbItbFsYb/7frhIEnMX09HQ89NDvK2CD13DwsYPxN3/zN7H9k580XhRgnqTal8SC162Jl//2KWEAxXvPR40GpRpO7k/1RGmXNXvPAPWrRwSvThHb2XWKAKCuZfKvTRER+W5thdNwuZjt1uY0HGW1Zdf68Yh4OP8qjCAtPg1nBCkkzJXXrIiFrc2CgLP49F13xegTo4KA83Dk6JH46Ec/Enfd9ekYHBwUCMA8aO4dUMQGyVSYAlLosjYuEirt5P5UNub2lvvDaFCARtIvgleniM1NA5Ak6/KvOyMiDqwdHovSbm3jIqKc8iNIc1E0137fzkNntni3+QCN/FDx93uFAGexZ89uBWxwgaampuJjH/ud2LZ1W2weGhIIQJU1Xf76aFrUETMvPC8MaFzPRdGeccx2WnMYmorKjwbNxlzRmsPQAI1NU62zUMR2dj0iAGh4hRGkN0VEHFg7/FyUdmrLiYhy27Jr/dGY3QgrHkFaXNimDTw0iOU9V8TizjZBwKvYs2e3EaJwCXbv2R3/40f/I2655cORTqcFAlBFC9+0Nl78iz8RBDSOiSjtsnZUJFTayf2p/ijtsmZPGCBZFCufhSK2s+sRAUDiLI3Z8aNnjiAt7tbm1B1llR9BOh4RXy382L6dh7JRevJuqaSg/qweWCUEeBUK2KA8RkZG4vvf+348MDyskA2gippW9EZqYWuceulFYUB9Ktnv1WWNasiPBs2G/V4A5v5u6GzbfMr7kDMoYju7HhEAEHMjSG+NiDiwdrjkZN6N37zNyTzKbsuu9bl45QjS4m5tRpBCjVvUmY6/M7BCEHCG/SMjCtigjI4cPRI3f+hD8dl77olMxltEgKpY0BILMm+Ol576liyg9hUmbxS6rOVEQqWd3J/qCZM3AHht/VH0WSD5xy0RnJWdPwDO9vfDTVE6grS4U5s3G5Rd0QjShyMi9u081BmlJ/e0HYYa0ztwpRDgDLlcLnbv2S0IKLPjTx+Pj370I/H5zz+okA2gSppXDyhig9o0FqVd1sZFQqXlR4NmY26v1ptyAM5HpwheSRHbqziwdrhfCgCcp6Ux163tzvwI0rEo7dY2LibKacuu9c/G7PjRM0eQFp/w05Ie5tGagZVCgCLHjh2L7dvvEARUyNTUVGze/Btx7733RTabFQhAhaXal0Rz95Xxi8m/FgbMr9Eo7bRmJBcVdXJ/qjNK92AdLgbgYvVH0ed8zFLE9upUPAJwKa6Lohbh+RGkxd3ajCCl7IpGkO6JiNi381BPlJ4A1LYeqmT1wJWxuLNNEJA3MTERn/jEPxcEVMH27XcoZAOokgVX9Sligyo/WkRplzV7rFRcfjRoNuyxAlB+PSJ4lecsEbwqndgAKKdM/rUpIiLfra3klOCN37zNKUHKasuu9eORHz8acXoEafEpwf7QrQ0qYs3A64UAedPT03HvPffE1NSUMGrIQP9AdHR0nNe/O/rEqMDqjEI2gOpoWnVNpL6di1MvvSgMqIzCtItcRBw1GpRqOLk/lQ3TLgCojh4RvJIitlenExsAlVYYQRoREQfWDo/F3EnCo7q1UW75EaS5/CsiIvbtPFTYkCn8MyMpuDSLOtOxosfjBBQMP/BAHDl6RBDVeHN5w+xby7e+9a0REbG6tzcWLVoUERF9fX1l+3UmJydjcnIyIiKeeeaZ+PGPfhQREd/61rciQtFbrdi+/Y4YGhqKrVu3CQOgghaseWu89N1vCgIu3XNR2mUtJxIqLT8aNBtz+6NGgwJQTT0ieJVnLBG8qqwIAKiywgjSmyIiDqwdfi5KO7XlRES5bdm1/mj+HouI0yNIiwvbbNzABXrT2quFAHkHDz4aBx87KIgyW3fDunjDG98Qy5cvj9Wre6OnpyfS6XTVfv3u7u7o7u6OiNLiuM1DQ6f/9/T0dIyPj58ucvvWt74VP/zhD+P408ddwCoaGRmJiFDIBlBBzVf2KWKDizMRpV3WHOil4k7uT/VHaZc1B3oBmE/+HnoVqVOnTknhDAfWDufCh7YA1J7RKO3WNi4SKm3fzkPZKO3WpoU+nMN7/8WvxMLWZkGQeMeOHYsPfvA3BXGJelf3xuD1g7FmzZq49tq3RCZT33tbheK2//7tb8cPfvCD+OZ/+aZRs1WgI5vvheWy7oZ1cd/997uwcIaXnjwYL//tU4KAcyve18y1b9r6rEiotPxo0MKrP+xrAlB7rm7bfGpcDHN0Ynt1CtgAqNW/n9ZFxK0REQfWDhdOLBa6tTmxSNlt2bU+F6UjSHuidPPnOinBrNUDVypgg5gtVPq/775bEBehq6sr1v7y2nj7O94Rb37zm093PGsU6XQ6+vr6Sjq4TU5Oxne+8504evRIPPnnT+rWVgE6sgFUVvPKXkVsUKowYSIXs13WciKh0k7uT/VEaZc1e5YA1IOeiBgXwxxFbABQvzIxO360eATp6RONMdutzalGymrLrvXjEfFw/hX7dh7qjNJObQ4DkFhrBl4vBIiI4QceUIh0Abq6uuJXfuVX4u/9vbfH4OBg4tbf3d0d2Ww2stlsRMwWtf3X//pf4uiRo8bRltHIyEisWbMmNmzYKAyAMmtadU2kvp2LUy+9KAySaiyKDtq2b9o6LhIqLT8aNBtz+5JGsgFQj/qjqJEExom+woG1w9mI+E+SAKBBlGwiGUFKNezbecgmEomzqDMd/+dtNwiCxMvlcrF9+x2CeA1JL1y7EE8++WT85/98OB5//HGjRy9B7+re2PvFL0Y6nRZGFRknCsnx8neeiJee+pYgSIrRKO205hAtFXVyf8ohWgAa1afbNp+6SwxzdGIDgMZ2XRS1Ts93a8vFXKe2nIgoty271h+N2cLJPRElI0gLG03a+dNwegeuFAKJNzk5GZ/7nOKGcxnoH4jNQ0Nx/fXXKyY6T4ODgzE4OBhbt25T0HaRurq64rP33OOeA6ig5tUDithoVBNR2mXtqEiotPxo0GzM7SfaSwSgUfWLoJQitlfKigCABrY0IjblX3Fg7XDE3OnJQrc2pycpq6IRpKft23koG6WbUUslRT1bM7BSCCTev/zc5xQWncXQ0FD8o3/0f0QmoznppXi1graRkRHBvIa77vq0ew+gwlLtS6Kpsztmnp0UBvWuMNUhF7Nd1sZFQqWd3J/KRukBWPuEACRFpwhKKWIDANZFUQv2A2uHCycsczHbrc0JS8puy671hXssIk6PIC0eQ+qTVurG8p4rYnFnmyBItFwuF6NPjAriDENDQ/H+9//j6O7uFkaZFQrabrnlw/GNb3w9/vCRP4zjTx8XzBl27NhhZC1AlSzsfWu8+Bd/IgjqSWFiQ6HLWk4kVFrRaNBszO4FGg0KQJLpxHYGRWyvlBUBAAmXiYib8q/iEaSFTm05EVFuRSNIH46I2LfzkA0t6sbqgVVCINGmp6eNET3D0NBQ3HLLh41vrIJ0Oh0bNmyMDRs2xrFjx+JP//RPdGcrug83bNgoCIAqaVrRKwRq3Vjk9/ditsuag6tU3Mn9qcKh1cI/HVwFgDm6j55BERsAcD5voAojSO/MjyAtGS1w4zdvGxcT5bRl1/pnI+Kr+VdEnB5BWtytzZt75t3CtoXxdwZWCIJEe+ih3zdGNE/ntfnV19cXfX198f73/+P4xte/Hvv+7b7E3psD/QOxdes2NwVANS1oiQWZvnh54pgsqBWjUdpp7VmRUEn5LmvFe3f9Yf8OAF7r78+ets2nxiWRf6wSwSvo8gEAr+26/OvWiNMjSAsnOXNGkFIJRSNI90RE7Nt5qCdKN8WukxLVduU1CthItmPHjul6FbMFQx/7Z/8s+vr63BQ1oLu7OzYPDcXG97wn/vzP/zz2PvRQokaN9q7ujQeGh90IAPOgeeUaRWzMl+K9uaNGg1INJ/eneqK0y5q9OQC4cD0RMS6GWYrYAIByyORfmyIi8t3aCqc9czHbrc1pT8pqy6714zE7fvThiNMjSItPezqcQMWtGXi9EEi0f/Pww4lef1dXV3zkIx8xsrFGpdPpyGazkc1mI5fLJaKYraurKz57zz1G2QLMk6blq6NpUUfMvPC8MKi0wpSEQpe1cZFQaSf3p7Ixt/fWH0aDAkA59IhgjiK2IgfWDmelAABlsy7/ujP/9+xYlHZrGxcR5ZQfQZrLvyIiYt/OQ8Uba9mwuUYZLepMx4qeTkGQWLlcLkafGE3uG50b1sU//8QnjA6tE0kpZrvrrk9HJuPtDsB8al65Jmae+pYgKKfnomhPLWY7rTksSkXlR4NmY25PzWFRAKiMHhHMUcQGAFRLYQTpTRERj2148Kd9m679euQ34a6++e05EVFuW3atP5q/xyLi9AjS4m5txhxw0YwSJen2PvRQYte+beu22Dw05CaoQ8XFbJ/73P0xNTXVMGvbsWNHDA4OusgA86z5yr54SREbl2YiSrusHRUJlTYzNtwf+T2zX0zm1kTE35MKAFRFjwjmKGIr1S8CAKiOjlVLX4rZ8aObIuLOE3sPR8yOID19svTqm9/uVClllR9BOh4RXy382L6dh7JRerJ0qaQ4H31rrxICibV/ZKThxzK+mt7VvfHZe+7R6aoBZLPZuP766+PRr30t9v3bfXVfzDY0NGSsLUCNSHVcEU2d3THz7KQwOF8l+2G6rFENM2PD2TjLfljT0mv/5hdTjwoJAKqjRwRzFLGVMgsIAKpk8fIlP42Iy8744cII0lsjIk7sPVxy8vTqm9/u5Cllt2XX+ly8cgRpcbc2lQq8wmUrlsbizjZBkEjT09Ox79/uS9y6192wLu68665Ip9NuggaRTqdj89BQvPNd74ovf/nfxcjISF2uY6B/ILZu3eaCAtSQBVe9OX7+bE4QvJrnorTLmhuFipsZG+6JC5hMkFrYebnUAKBq1CkVP0uJoIRObABQJW0d7TPn8a9lYnb86E0RESf2Hn4uSju15SRJuRWNIH04ImLfzkOdUXoydZ2UWD2wSggk1qNf+1pDjWA8H0NDQ4qEGlh3d3ds3botfvVXfy1+91/9qzhy9Ejd/N57V/fGA8PDLiJAjWla0Rvx7ZwgiIgYi9Iua+MiodLyo0GzMbeXdWEHNFPN7amFy+LUS88IEwAq7zoRzFHEVkqFIwBUSVtH28V0t1oac93aCiNIx6K0W9u4dCmnLbvWPxuz40fPHEFavCGoW1vCZK7pFgKJlMQubDt27DCmMSH6+vriwS98IQ4efDQefPDBmi/W7Orqis/ec4/ugAA1KNW+xEjR5BqN0k5rRoNSUTNjw51R2mWtLIcvU60ZRWwAUCUn96c62zaf8r4xFLGdqUcEAFB56a72cn6566LolEJ+BGnhhOtR3dqohKIRpHsiIvbtPNQTpSdcnZxpYMt7rjBKlMRKWhe2e++9L7LZrAufMBs2bIx3vvNdMfzAA3HwsYM1+/u8665PRyajjh6gVhkpmgjFe1C59k1bj4qESsuPBs1GhfegmhatmZj56ZPebAJAdfTn31N6jhJBCW/GAKAK0lcs+llEtFfoy2fyr00REflubSWnYK+++e1OM1BWW3atH4/8+NGI0yNIi0/B9sdsJ0EagFGiJNnXvva1xKxVAVvC36+m07HjU5+KX1u/Pvbs3h3Hnz5eU7+/HTt2xODgoAsFUMOar+wzUrTxFKYB5CLiqNGgVMPM2HA2SveYqrK/lFp0tc+QAYCq8wYk78DaYaNEAaBKFq9Y8v9FxOur+EsWRpBGRMSJvYfHorRbm5OylFV+BGkuik7O7Nt5qHj8aDYcoKhbPX1GiZJMuVyu5gp5KkUBGwWDg4Ox94tfjD/8w0di7969NfF7GhoaMuIWoB4saIkFr1sTL//tU7KoT89FaZe1nEiotPxo0GzM7R+tm6/fS2ph5+WuCABUTTZ0Ypt9jBLBaf0iAIDqWNy95OV5/i0URpDeFBFxYu/h56K0U5s3ipTdll3rj+bvsYg4PYK0uLBtnZRq36prVsbC1mZBkEj7R0YSsU4FbJwpnU7Hb/3Wh+Itb7ku7rrrznkdqTvQPxBbt25zUQDqRPPKXkVs9WMiSrusOfBIxc2MDfdHaZe12jnwmGpuj+ZFEb94wYUCAKpGERsAUHVtHW211oFqacyOH90UEXcWjSAt7tY27spRTvkRpOMR8dXCj+3beSgbpd3ajCCtMVe+abkQSKRjx47FkaNHGn6dQ0NDCtg4q8HBwThw4Csx/MADcfCxg1X/9XtX98YDw8MuBEAdaVrRK4TaNRpFBxrbN219ViRUWn40aOHVHzW+79PUmomZ6WMuHABUnqZbeYrY5mRFAACV17q4pV5+q4URpLdGRJzYe7hwIrfQrc2JXMpuy671uSgdQdoTpZub10lpfhklSlL96Z/+ScOvccO7N+hwxWtKp9Ox41Ofiv6B/njwwQer1pWtq6srPnvPPZFOp10EgHpipGitKHTgz8Vsl7WcSKi0mbHhnijtslZ3ezpNi//uj2emjznNBwCV1ymC/COUCACAamrvqtsP3jIxO360MII0Yu7Ubi5mu7U5tUtZ5bu1PZx/xb6dhzqjtFObEaRVZJQoSTU9PR0jDT5KdKB/IG77+MddbM7bhg0b49pr3xL33nNPVboU3nXXpyOTyQgeoA4ZKTovxqK0y9q4SKi0/GjQbMzt29T9m7dU+qqfu7IAUBU9IpiliG2O9nwAUAVLXtcxEQ2wiZNX6NZ2Z0TEib2HSzZJjSCl3LbsWv9szI4fLR5B2nCbpLXKKFGS6hvf+HpDr6+rqyu2f/KTOlxxwTKZTDwwPBwPPfT7FS303LFjRwwODgocoE4ZKVoVJYcMjQal0mbGhpNxyHDhkhZXGwCqwuc6eYrY5mjPBwBVsKhrUVMDL++6KBoNcGLv4ZJxFVff/PacO4By27Jr/dGYLZzcE1EygrSwkWoEaZkYJUpSPXbwsYZe30c+8hEdrrho6XQ6tm7dFv39A7F9+x1l//pDQ0OxYcNGQQPUswUt0dx9Zfxi8q9lUR4TUdpl7ahIqLT8aNBszO23JGKvJdW82Gk+AKiSk/tTnW2bTyX+MIYitjk9IgCAymvvTC9O0HKXRsSm/OvMEaSFbm1OB1NWRSNIT9u381A2Sjdbl0rqwly2YqlRoiTSxMREVUYlzpd1N6xTIERZZLPZ2L//j+L/+uQn4/jTx8vyNQf6B2Lr1m3CBWgAzSt7FbFdvNHI76HEbJe1cZFQaTNjw9koPSCY2H2UpnRfzEwfc1MAQOX159/zJpoitjmOXQNAFTS3NF+W8AgKI0gjIuLE3sOFE8S5mO3W5gQxZbdl1/pc8cNPfgRp8RhS74Vfw+qBVUIgkf7szx5v2LV1dXXFP//EJ1xkyiaTycTeL34xPn7bbZdc/Nm7ujceGB4WKkCDaFrRG/HtnCBeW6GjfaHLmtCouKLRoNmY3StZJ5UiLct+FtPH2gUBAFSDIjYAoGqWrFwihFfKRMRN+VdhBGnhhHHOCFIqoWgE6cMREft2HrJh+1p/UK8xSpRk+sbXv9Gwa/vIRz4S3d3+bFNe6XQ6HvzCF2LPnt0xMjJyUV+jq6srPnvPPZFOpwUK0CBS7UuiqbM7Zp6dFEapsSjtsuZgHxU3MzZcONRX+KeDfefQ1LrymRkZAUA16MQWitgiIuLA2uGsFACg8hYtW/STiLhMEue0NOa6td2ZH0E6FqXd2sbFRDlt2bX+2Yj4av4VEadHkBZ3a0vs6IzLViyNxZ1tbhQSZ2JiomxjEWtN7+peY0SpqK1bt0V//0Bs337HBf+3d9316chkfE4I0GgWXPXm+PmzuaTHMBqlndaedWdQSfkua8V7G/2R4P2Ni5FadLXPkgGgOjpFoIgNAKiits726VDEdjGuy79ujTg9grS4W5uTypRd0QjSPRER+3Ye6onSTd/rkpLFldescEOQSI08SvRf7NjhAlNx2Ww2fvd3/5+46647Y2pq6rz+mx07dsTg4KDwABpQU9eqpC25eO/iqNGgVMPM2HBPlHZZu04qlya1sPNyKQBAVfSIQBFbQb8IAKDyFncveVkKZZHJvzZFROS7tRVOM+ditlub08yU1ZZd68djdvzowxGnR5AWn2Zu2BGkV12zzA1AIv23J/9bQ65r3Q3roq+vzwWmKgYHB+Pzn38wPvrRj7xmIdvQ0JAOgQANLNVxRTQt6oiZF55v1CUWusgXuqyNu+pU2szYcDbm9ib6w9jLCnzzam6P5kURv3hBFgBQWT0iUMRWoC0fAFRB6+JWlSCVc3oEaUTEib2Hx6K0W9u4iCin/AjSXP4VERH7dh4q3jjORgNsHi/qTMflKxa54CTO5ORkHDl6pCHXdtMHPuACU1WZTCYOHPhKfPy2287652qgfyC2bt0mLIAG17xyTcw89a1GWMpzUbTnoMsa1ZAfDZqNuT2HdVKpjqbWTMxMHxMEAFBxithmKWIDgAprbmmOVFOqXRJVUxhBelNExIm9h5+LohPRV9/89pyIKLctu9Yfzd9jEXF6BGlxt7a6G+NhlChJ9Z3vfKch16ULG/MlnU7HA8PDr1rI1ru6Nx4YHhYSQAI0reyNqM8itoko7bJ21NWk0mbGhvujtMua0aDzJNV29U9i+thlkgCAilKgH4rYCowTBYAKS3elhTC/lsbs+NFNEXFn0QjS4m5tRpBSVvkRpOMR8dXCj+3beSgbpSenl9byGlb0XO5CkkhHG7QL26/feKOLy/y9H84Xsg0/8EAcfOxgRER0dXXFZ++5J9Jp75UBkqDp8tdHamFrnHrpxVr/rZbsF7Rv2mq/gIrLjwatm/2CJEm1dk9HhCI2AKDiFLEBAFWxaNmin4TNjlpTGEF6a0TEib2HS05WX33z252spuy27Fqfi1eOIC3u1lZTI0ivuuYKF41EevzxxxtuTb2re2NwcNDFZV6l0+nY8alPxeIli2NkZCTuuuvTkclkBAOQIM2v642XJ2pqLF9J53ajQamGmbHhnqjzzu1JkkqvelkKAFB5J/eneto2nxpPcgaK2GbpxAYAFdbW2e7EXu3LxOz40eIRpMWd2nIiotyKRpA+HBGxb+ehzig9eT1vLbRXXbPSBSKRJiYmYmpqquHW9d73vdfFpWZs3botfvVXf814W4AEar7iyvkuYhuL0i5r464KlZYfDVr8rK+Kv46kFnQskwIAVEVPzE63SSxFbLO0JAaAClvcvcSJvfp8j1To1lYYQToWpd3axsVEOW3Ztf7ZmB0/euYI0uIN76psdl/5puUuCIl04sSJhlzX2972yy4uNUUBG0AyNa3orfYvOZp/js9FxFGjQam0mbHhzijtsrZOKnUu1dwezYsifvGCLACAilLEBgBUReviVif2GsN1UTTiIT+CtHCC+6hubVRC0QjSPRER+3Ye6onSE9wVGTuy8upO4ZNIR48eabg1bXj3huju7nZxAYD5t6Almjq7Y+bZyUp89eJn9Fz7pq1HBU6l5UeDZoue040GbUBNrZmYmT4mCACorGz+vXxyH5eSfgccWDuc9ecAACqruaU5Uk2pdkk0pEz+tSkiIt+trXDKu9CtzSlvymrLrvXjkR8/GnF6BGnxKe/+uMRuy5etWBqLO9uETSJ9/3vfb7g1vf0d73BhAYCa0bxyTbmK2Ard0nMx22VtXLpU2szYcPaMZ3DTjhIg1Xb1T2L62GWSAAAqSSc2AKDi0l1pISRLYQRpRESc2Ht4LEq7tTkJTlnlR5DmouiE0r6dh4rHj2bjAkeQLr+6S7Ak1pEG7MR2/fXXu7AAQM1oXtEbL333mxf6nz0XpV3WcpKk0vKjQbNFz9dGgyZUqrV7OiIUsQFAZSV+PIwitogeEQBAZS1atugnYZMjyQojSG+KiDix9/BzUdqpLSciym3LrvVH8/dYRJzu1paN89x4v+oaE5BJpmPHGm88zED/QKTTCuoBgNqR6rgiUgtb49RLL57rX5uI0i5rDoRRcTNjw/1R2mUtIxUiIlLpVS9LAQAqrj/pAShiU8QGABW3MN3yfChiY87SmB0/uiki7iwaQVrcrW1cTJRTvlvbV/OviIjYt/NQNkq7tZ0egbKip1NoJNLTTx9vuDVls1kXFgCoOc3dV8bLf/tU8Q+NRtGBr/ZNW5+VEpWWHw1a/GxsNChn+aaV7hACAFBpitgAgIrrWLnUew5eS2EE6a0RESf2Hi6cOC90a3PinLLbsmt9LkpHkPZERPYN1/dsiYi/LyGS6Mc//nHDrenat7zFhQUAak5zz9/965f/9qnhmO2ylpMIlTYzNtwTpQe5rpMK5yvV1OqAMgBUnk5s7gE3AQBUWku6xQwvLlQmZsePFkaQRsydSs/FbLc2p9Ipqy271o9HxMP5ZwRFbCTSX33/rxpuTX19fS4sAFBzmrp7Zto3bd0jCSolPxo0G3OFa0aDcmnft9J9MTN9TBAAUDmJ74qriC3CnCAAqLDmlmYn9SiHQre2OyMiTuw9PBal3drGRUSZZEVAUv3whz9sqPUM9A+4qABArcpERE9EeNBKdlUAACAASURBVJblks2MDXdGaZe1dVKh7JoWyQAAqChFbABARaW72oVApVwXRaMvTuw9/FyUdmrLiYiL0BlGqpBgx58+3lDreeOb3uiiAgC17B9GhG5sXLCi0aDZmC1c8xxLxTUtWjMx89MndfQDgAo6uT+Vbdt8KpfU9SticxoFACqqZXGrEKiWpRGxKf86cwRpoVubEaS8ln8oApJqYmKi4da0csVKFxYAqGXZUMTGeZgZG85Gaae1pVKh2lLtr2+SAgBQSYrYAICKWvK6jomYHZEB86EwgjQiIk7sPTwRpd3ajoqIM2RFQFK98MILDbema9/yFhcWAPD8QV3Jd1krFKv1h2YM1IrmthkhAACVlOgitgNrhzvdAgBQWa1LWp3Qo5ZkIuKm/KswgvRo5AvbjCAlfIhEgj3dYKNEIyIWLVrkwgIAtWxpzBYpOWCVYDNjw8UFa9lwGJQalVp4mXsTACovG7OfWSVS0jux9bv/AaCy2jrandCjli2NuW5td+ZHkI5Fabe2cTElRk/4sIAEe+GnjdeJLZPxRxoAqHnZUMSWGDNjw50xV6yWzf9vo0GpH82LIn7xghwAgIowThQAqKjWxa3LpECduS7/ujXi9AjS4m5tPlxoXFkRAAAA8/AcskcMjSk/GjQbc4Vr10mFetbUmomZ6WOCAIDKSfREyQUuPgBQSammVLsUqHOZ/GtTRES+W9tolHZre1ZMDSErApLsW9/6VkOtZ90N61xUAMBzCFU1MzacjbmCtf7Q7ZtG07LsZzF9zH4vAFROoidKGicKAFTMkpVLhECjOj2CNCLixN7DY1HarW1cRHUpKwIAAKDKlsbsZxW6fteZ/GjQbMwVrTlFQcNral35zIziTACgQowTBQAqprmlWQgkRWEE6U0RESf2Hn4u8l3aYraoLSeimtcTNmEBAID5kQ1FbDVvZmy4P+YK1rKeIUmiVPvrm6QAABVlnKiLDwBUwpLXdUyEDT2SaWnMjh/dFBF3Fo0gLe7WZgRpbcmKAAAAmMfnkT1iqC350aDZmCtcWyoVEq+5bUYIAFBR1yV58caJAgAV07qk1ck8mFMYQXprRMSJvYcnorRbm1P38ysrApLuL7/zl0IAAPA8kkgzY8M9Udpl7TqpwCulFl7mwDIAUDHGiQIAFdPW0e5kHpxdJmbHjxaPIC3u1JYTUVU54ELiTU1NCQEAYH4szT+TONxUJfnRoNmYK1xTmAMAAPNMERsAUDEL2xZ2SAHO29KY69ZWGEE6FqXd2sbFVBGd4ZQ9AAAwv7KhiK0iZsaGO6O0y9o6qcDFa0r3xcz0MUEAQIWc3J/Ktm0+lUvi2pNexOZBBQAqqLml+TIpwCW5LoqKq/IjSAvd2o7q1lY2WREAAADzTHfoMsmPBs3GXKc1h5agnJoWyQAAqAid2ACAikh3tQsByi+Tf22KiMh3axuN0m5tz4rpgvmwCAAAmG9ZEVycmbHhbJR2WlsqFaicpkVrJmZ++qQRvABA2SliAwAqornF2wyoksII0oiIOLH38FiUdmszjua1ZUUAAADMs0xEdEaEg0nnkB8Nmo25Lmsm7kC1NbXa+AWAysrG7Gc8iZPYNxkH1g7rtgAAFbRo2aKfRIRxolB9hRGkN0VEnNh7+Lko7dSWE9Er+NADGtDzzz8vBACg3mQj4qtimDMzNtwfpV3WdH+CeZZKr3pZCgBAJSS5Ur7T5QeAylmYbnk+FLFBLVgas+NHN0XEnfkRpGMxW9iWi9lubeMJzsfhFmhQR44eEQIAUI/PJ4kuYsuPBi28+sNoUKg9TQvbhAAAVIJ2rwBARSzqWtQkBahZhW5tt0ZEnNh7eCJKu7UlaQRp1u0AAAB4Pqm+mbHhnpgrVsvmn1OBGpdqXrxcCgBQUT1JXfgCFx0AqMibjLaFM1KAupGJ2fGjhRGkERGjUdqt7dkGXbtObJA30D/QcN3Ljh07Fn19fS4uAFAv1jXy4vKjQbMxV7hmNCjUq+ZFEb94QQ4AUBk9SV24IjYAoCJaF7cukwLUtXX5150RESf2Hi6MIC10axtvkHVmXWqY1dHR0XBreuEFH6oAAHWnP//cVddmxoY7o7TL2jqXFhpHU2smZqaPCQIAKCvjRAGAikg1pdqlAA2lMII0IiJO7D38XJR2asvV4Zo6w8l/aGhPHz8eg4ODggAA6kldFrEVjQbN5tdgNCg0sqZFMgCAyulM6sIVsQEAZde6uEUI0PiWRsSm/Kt4BOnRyBe31cEIUqNEocH94Ac/EAIAUG+yEfFwrf8mZ8aGs1HaaW2pSwfJ0bRozcTMT590MBAAKiOxB0KSXMSWdd8DQGW0LGkVAiRTYQTprRERJ/YenojSbm211k3AMwEUWfm6lQ23pu9+97suLABQb2rusE2+y1qhWK0/jAYFmlo1SgEAys4bDACg7Fo7Wn8WEcaJApmIuCn/KowgLe7Ulpvn359ObFBk5YrGK2I7/vTxmJycjO7ubhcYAKgX8951YWZsuLhgLZt/tgM4LZVe9bIUAIByU8QGAJRd++XpZ8IGJ/BKS2OuW9ud+RGkY1HarW28ir8fRWyQAN/5zncim80KAgCoJ9n8M1LFzYwNd8ZcsVo2/7+NBgUAgHl0cn+qp23zqfGkrTvJRWw9bnsAqIzmlmaF8sD5ui7/Kh5BWtytrVIjSDtDsS2UWL5iRUOu6+jRI4rYAIB60x8VKmLLjwbNxlzh2nXiBi5UauFl9lQAoLJ6ImI8aYtO8gfM3lwBQIUs7l6inTxwKe/TMxGxKSIi361tNPKd2mK2sO3ZMvw6urDBGZYtW9aQ63r88cdj69ZtLjAAUE/K9rwyMzacjbmCtf7w2QgAAFCjdEkBAABqXWEEaUREnNh7eCxKu7WNX8TXzIoVSnV3dzfkuqampmJiYiIyGZ/XAgB1o+di/qP8aNBszBWtrRMlUCmptqvj1MkTggAAykYRGwBQdm0dbT4lBiqpMIL0poiIE3sPPxelndpy5/E1dGKDMzRqEVtExJ/92ePxW7/1IRcZAKgX51V8NjM23B9zBWvZ0GUNqKJUU3ucEgMAVEp/zH7ukSiJLGI7sHa4x/0OAAANY2nMjh/dFBF3Fo0gLe7WduYIUs8E8Cp6V/fG8aePN9y6/viP/1gRGwBQb/rzzzSn5UeDZmOucG2pmIB507LsZzF9rF0QAFARnUlcdFI7sfW43wGgMtJd9i2AmlAYQXprRMSJvYcnorRb23UigldatWpVQxaxTU1NxZNPPhmDg4MuMgBQF06dnPoHp77/b3pirsuaZxigpjS1rnxmRgdIAKCc7y9EAACUU3OLaeVATcrE7PjR3W2rLj8iDnh1b3jjGxp2bV85cMAFBgDqx7NPfS4i/kPMHsxRwAbUnqZWG8EAQHnfXogAACin5pZmIQA1bcGSNiHAWSxfvrxh1zb6xGhMTk66yABAfViySgZATUulV70sBQComGwSF53UIrYe9zsAVMaS13VMSAGoZS1di4QAZ7F6dW9Dr+/LX/53LjIAUBdS7VcIAQAASBRFbAAAQKK0Xq6IDc6mr6+vodc3MjKiGxsAUB+aWiOaW+UA1KzUgo5lUgAAyvoYJAIAoJw6Vi5dIAWglrVc3i4EOIeB/oGGXp9ubABAvUi1LxcCUMPfpJptsAAAZaWIDQAoq1RT6mUpADX7ANS6MJoWNgsCzuGNb3pjQ69vZGQkJiZMPwcA6kC7JkdAjWvW7R4AKqQ/iYtOahFbp/sdACqjeUFTmxSAWtXSvUQI8BrWrFnT8Gv8/O/9ngsNANTBA0yHDICa1tSaEQIAVMbSRL63SOjF7ne/A0BlLEy3mHUB1KyWrsVCgNdw7bVvafg1jj4xGrlczsUGAGpbe7cMAACAxDBOFAAASIwFS1qFAK8hk8lEV1dXw6/zc5+7P6anp11wAKBmpdqvEAJQ21qW/UwIAEC5KGIDAMom3dUuBKCmtV6+SAhwHtb+8tqGX+PU1FQMP/CAiw0A1K6m1ohmB3GAWv42tfIZKQBAZZzcn+pM3HsLlx0AKJfmlgVCAGpay+WKbeF89A/0J2KdBx87GAcPPuqCAwA1K9W+XAgAAJBM/UlbcJMLDQAAJOYBaGGzEOA8vO1tv5yYtT744IMxMTHhogMAtallqQyAmpVqf72GKQBA2ST1jYWnPgCoxF+wV3X+WApArWpbdbkQ4Dx1d3dH7+reRKx1amoq/q9PfjKmp6ddeACg9izskAFQu5rbZoQAAJSL6ngAoGxSTamTUgBq9uHHyGO4IO981zsTs9bjTx+PT991l4sOANSeJatkAAAAJIIiNgAAIBFauhYLAS7AP/gHv5Ko9Y4+MRp79ux24QGA2tLcKgOgZqUWXpaRAgBUTE/SFqyIDQAom46VS7U5AmpWS1daCHABMplMYkaKFoyMjMT+kREXHwCoGam2K4QAAADJ1JO0BSeuiO3A2uGs+xwAKiPVlHpZCkCtajZOFC5YkkaKFuzesztyuZyLDwDUjpalMgAAABqeTmwAAEAitFzeLgS4QEkbKVqwffsdCtkAgJqRUsQG1LCmdJ8QAIDyvK8QAQBQLm0dbRkpADX78LOwWQhwgZI4UrRAIRsAUDPal8kAAABoeIrYAACAhte26nIhwEV6z3vek9i1b99+R+wfGXETAADzq6lVBgAAkDw9iXv0cc0BAICGf/BpWSAEuEjvfNe7Er3+3Xt2x549u90IAMD8SevEBtSuVNvVP5ECAFRET9IW3OQiAwDlkO5qFwJQs1q6FgsBLlJ3d3dsePeGRGcwMjISd3/mMzE9Pe2GAACqr7lFBkDNSi3seF4KAEA5KGIDAMqiWZcjoJYffFqbhQCX4NfWr098BgcfOxgfv+22mJycdEMAAFWVar9CCAAAQMMzThQAAGh4rZcvEgJcgsHBwehd3Zv4HI4cPRIf+MBN8eSTT7opAIDqaWqVAVDL36OcbgYAyvO2QgQAQDk0t+hyBNSulO9RcMluvuUWIUTE1NRUfOxjvxP7R0aEAQBU75mmfZkQgNr8/pRe9bIUAIByUMQGAJTFktd1TEgBqFWtl7ULAS7R9ddfH11dXYLI271nd9xx++3GiwIA1dHcJgMAAEiW/qQtWBEbAAAA8JrS6XRs+SdbBFFk9IlR40UBgOrQiQ0AAJJmadIWnMQitn73OQAAJEfbqsuFAGWy8T3v0Y3tDIXxond/5jMxPT0tEACgMppaZQDUpNSCDlW2AEB5HnsSuOZOlx0Ayq91SasOrwDQ4HRjO7uDjx2MG2/8dV3ZAIDKaF0qA6A2pZrbhQAAlIMPmwGAsmjraJ+RAlCLWroWCwHKSDe2syt0Zbvj9ttjcnJSIABAGR9slsgAAABoaIrYAACAxn7oaVkgBCgj3dhe2+gTo/GBD9wU+0dGhAEAlEezcaIAAEBjU8QGAAA0tAVLfNgD5bZ5aCh6V/cK4hympqZi957d8f73vc+IUQDgkqXarhACUMPfo64WAgBUwMn9qc4krVcRGwBQFgvbFnZIAajJ70+LFbFBJdx8yy1COA/Hnz5+esToxMSEQAAAgIaTamoXAgBURn+SFquIDQAoi+aW5sukAADJkc1mY90N6wRxnkafGI3Nm38j9uzZHZOTkwIBAC5Yqn2ZEAAAgIaVxCK2fpcdAACSo235YiFAhXz0t39bCBdoZGQkNm7cEPtHRmJ6elogAMD5a26TAQAA0LCSWMS21GUHAACAS5fJZOLmm28WxEXYvWd33HjjrytmAwDOX3OrDIDa1LLsZ0IAAC6VcaIAAEDjPvC0LhQCVNh73/u+6F3dK4iLMDU1pZgNADh/bcaJArWpqXXlM1IAAC75PYUIAIBLtWTlEiEANaml2/cnqLR0Oh3/YscOQVwCxWwAAAAAQNIpYgMAAAAuSV9fXwwNDQniEp1ZzDY5OSkUAGBO61IZAAAADUsRGwAA0LAWLGkTAlTJLbd82FjRMikUs23cuCH27NmtmA0AmNWi0zQAACRMT5IWq4gNAABoWAsWK2KDajFWtDJGRkZi48YNcfdnPhPHjh0TCAAAUHNS7a/3mTMAVEZPkhbrDQUAAABQFn19fbFt6zZBVMDBxw7GBz/4m3HH7bdHLpcTCAAkUGphhxCA2tTcNiMEAOBSJaqI7cDa4X6XHADKb+lVnT+WAlCTDzytzUKAKts8NBQD/QOCqJDRJ0Zj+/Y74v3ve18cPPhoTE9PCwUAksI4UQAAoIElrRNbp0sOAOWXakqdlAJQi1ovXyQEmAe7PvOZ6OrqEkQFHX/6eNx9991x442/Hnv27I7JyUmhAAAAAAB1yzhRAAAAoKy6u7vjc5/7l4KogqmpqRgZGYmNGzfEHbffHk8++aRQAAAAAIC6o4gNAAAAKLu+vr7YsWOHIKpo9InR+NjHfseoUQBoYKnFVwkBAABoSIrYAACAhtW2fLEQYB5t2LAxhoaGBFFlRo0CAADVlFp4WUYKAMClUsQGAAAAVMzWrdtioH9AEPPAqFEAAAAAoF4oYgMALlnHyqULpAAAnM0Dw8MK2eaZUaMA0CCaW2UAAAA0JEVsAMAlSzWlXpYCAHA26XQ6tn/yk9HV1SWMeWbUKADUubZlMgAAgOToT9JiFbEBAAANqW3V5UKAGpLJZOLzn39QIVuNMGoUAAAAAGpeZ5IWq4gNAAAAqIpCIRu1xahRAAAAAGC+KWIDAAAAqiaTycS9994niBpk1CgAAAAAMF+SVsTW45IDAADA/MpmswrZaphRowBQw5askgFQk5rSfUIAAC7t/UTC1tvjkgMAQEIedloWCAFqmEK2+mDUKAAAAABQDcaJAgAADamla7EQoMYpZKsfRo0CAAAAAJWkiA0AuGRtHW0ZKQAAFyObzcaXvvQH0dXVJYw6YNQoAAAAAFAJitgAAACAedXX1xef//yDCtnqjFGjAAAAAEC5KGIDAAAA5l0mk1HIVqeKR43+63/9RaNGAaCSmltlAAAANCRFbAAAAEBNyGQyceDAV2Kgf0AYdWhqair27t0bGzduiLs/85k4duyYUACgzFJtVwgBAABoSIrYAAAAgJqRTqfjgeHh2PDuDcKoYwcfOxgf/OBvxvvf977I5XJGjQIAAAAA56SIDQAAaEjtKzuEAHUqnU7Hjk99Km6++WZh1LnjTx+P7dvvMGoUAAAAADgnRWwAAABATfqt3/pQ3HvvfYJoAEaNAgAAAADnoogNAAAAqFnZbDb27/+j6OrqEkaDMGoUAAAAADiTIjYAAACgpmUymThw4Cux7oZ1wmggRo0CAEDjSLVlTkoBALgUitgAAACAmpdOp+O++++PbVu3CaPBGDUKAAD1L7Ww88dSAAAuhSI2AAAAoG5sHhqKL33pD4wXbVBGjQIAAABAMiliAwAAAOpKX1+f8aINzqhRAAAAAEgWRWwANayjb1lc+Y+ujTd99B3CAACAIoXxojt27NCVrYEVjxrds2e3UaMAEBGpxVcJAQAAkiFRp3gXuN4AtaF9VUcsfdPy6HzDiljWf2Usv3ZFyc8/+1c/ih/92Q8EBQAARTZs2BjXXvuWuPeee+LI0SMCaWAjIyMxMjISA/0DsXloKLLZrFAAAAAAoEEoYgOYB2cWrF3W2xUt6YXn/G96/ve3KGIDAIBXkclk4sEvfCH2j4zE7j27BdLgjhw9EkeOHomurq7Y8k+2xDvf9a7o7u4WDAAAAADUMUVsABW2sKM1Oq5ZHt2/lInONcvist4rYvGyRRf8da5cm4m/6GiNl55/UagAAPAqNg8NxS+vXRuf/73fi9EnRgXS4KampmL3nt2xe8/uGBoail/91V+Lvr4+wQAAAABAHVLEBlBmHX3L4opf6ollA1dedMHa2XRdf5VubAAAcA6ZTCbuu//+OHjw0XjwwQdjampKKAlg1CgAAAAA1DdFbABl1vehd8SVazMV+drdb+1RxAYAAOdhw4aN8ba3/XL8/he+EAcfOyiQhDhz1OjG97wn0um0YAAAAACgxjWJAKC8nn3qmYp97cvWdAsYAADOU3d3d+z41KfiS1/6g+hd3SuQBCmMGr3xxl+PPXt2x+TkpFAAAAAAoIYpYgMos8m/mKjY115+7QoBAwDABerr64svP/JIbNu6Lbq6ugSSIFNTUzEyMhIbN26IPXt2x7Fjx4QCAAAAADVIERtAnenoWyYEAAC4CJuHhuLAga/E0NCQMBJoZGQkPvjB34w7br9dMRsAAAAA1BhFbAB1ZuGSNiEAAMBFSqfTsXXrtti//49i3Q3rBJJAo0+MKmYDAAAAgBqjiA2gznT/UkYIAABwiTKZTNx3//3xpS/9QfSu7hVIAhWK2d7/vvdFLpcTCAAAAADMI0VsAGX2unVvFAIAANSJvr6++PIjj8S9996nmC2hjj99PLZvv0MxGwAAAADMI0VsAGXU0bcsVv/amyr6a3SuWSZoAAAos2w2q5gt4QrFbMaMAgAAAED1KWIDKJOOvmXx9393c7SkF1b012lZ3CpsAACoEMVsFMaMKmYDoFad+vlzQgAAgGSYSNJiFbEBXKKFHa3xpo++oyoFbAAAQHUoZqO4mG1yclIgANQORWwAAJAU40la7ALXG+D8tK/qiPTrO0///+5fykTnmmVx5dqMcAAAoEFls9nIZrORy+Vi70MPxfGnjwslYUafGI3RJ0ZjaGgobrnlw5FOp4UCAAAAAGWmiA2oG11vu+qcP9/9S+cuJutcs+ycozgv6+3SSQ0AAHhVxcVs/+9//I8x+sSoUBJmZGQkHn/88djyT7bExve8RzEbAAAAAJSRIjbgvJzZhexMC5e0RucbVpz95xe3xWVrus/5ayy/doWgAQCAmlYoZjt27Fj88b//93HwsYNCSZCpqanYvWd3fO1rX4ut27bF4OCgUAAAICJmXnjK2BoA4JIoYoM60dG3LBYuaTvrzy99w4poWXL2LmOv1YVs0fIlsXjZIkEDAACch76+vujr64sP/9N/Gl/+8r+Lxx9/PKampgSTEMefPh4f+9jvxLob1sVHf/u3I5PxeR0AAAk384IMAIBLoogNzsPCjtbouGb52X/+NbqQRUQs67/ynD+vCxkAAED96e7ujq1bt8Utt3w4vvGNr8cfPvKHcfzp44JJiNEnRmP0idG4+eab473vfZ8RowAAAABwkRSxkRg3PPS+s/6cLmQAAI3npZ++GG3LFwsCqIp0Oh0bNmyMDRs2xpNPPhlfOXAgRp8YFUxC7N27N77x9W8YMQoAAAAAF0kRG4mi2xmN4CdPTQoBAM7Dy//rRSEA82JwcDAGBwdjcnLSqNEEKYwY3fDuDXHbxz+uKxsAAAAAXIAmEQDUl5d+elIIAABQBwqjRg8c+Eps27otelf3CiUBDj52MG688dfj4MFHhQFA+c04rAMAADQmRWwAdebZv/qREAAAoI6k0+nYPDQUX37kkbj33vti3Q3rhNLgpqam4u677447br89Jid10wagfE797H8KAQAAaEiK2ADqzHPf+7EQAACgTmWz2bjv/vvjS1/6gxgaGhJIgxt9YjQ+8IGb4sknnxQGAAAAAJyDIjaAOvLTZ16In/3weUFQc07NnPqZFAAAzl9fX19s3botHn30YGzbui26urqE0qCmpqbiYx/7nbj7M5+J6elpgQAAAADAq1DEBlBHfjz2N0KgJr340xefkQJQa2Z+/rIQgJrX3d0dm4eG4rHH/mPce+990bu6VygN6uBjB+PmD30ojh07JgwAAAAAOIMiNoA68rdPfF8IAHCefj71UyEAdSWbzcaXH3kkvvSlP4gN794gkAZ0/Onj8cEP/mbsHxkRBgAAAAAUSVoRW84lB+rVz6dfih/92Q8EAQAADa6vry92fOpT8eijB2NoaMio0Qa0e8/uuOP2240XBeDC/fx/yQCoSade+p9CAAAuiU5sJMYzR/9aCNS1p//ke0IAAIAE6e7ujq1bt8WBA1+JHTt2GDXaYEafGI2bP/ShmJiYEAYA5+/F52QA1KRTLz0jBADgkihiA6gTTz3yX4UAAAAJlE6nY8OGjfHlRx6Je++9L9bdsE4oDeL408dj8+bfiFwuJwwAAAAAEk0RG0Ad+N5/+O/xsx8+LwgAuAAvP/8zIQANJ5vNxn333x/79/9RDA0NCaRBbN9+R+zZs1sQAAAAACSWIjaAGvfz6Zfie194QhAAcIEUsQGNLJPJxNat2+Ib3/hPsW3rtujq6hJKnRsZGYk7br89pqen/3/27j0+yvLA+/83QE6TEELGZIIQQhJOhgZRiQgqxFaq7aIWe4BqfWq12sqjfRT3aWmtrtvaX9U+Htbdta60rrVSQa0Wxa4V1BAVilAJRgICOQwBc2ImySQzyUwymd8fiIKAQDIzuQ+f9+vV16ua5L7n+l63dyYz37kuwgAAHF9/kAwAAAAA+6i002ApsQGAwW369avq9fHiFIytr6eX5xQAAABDwOFwaNHixXrllb/q3nvv01kzziIUE1tfsV63L12q1tZWwgAAHFt3CxkAAAAA9tFup8HyhjMAGNjOF6vUtG43QcDw/B5/PykAAAAMrbKyMv32scf0xBP/rQX/tIBATGpr5VZde+135Xa7CQMAAAAAAAC2QYkNAAyqZu0uVd2/liAAAEMqlBA29ePv9YeYRAC2U1xcrJ/feadefnmNbrjhBrYaNSGPx6MlS26iyAYAAABziIS7CQEAAAwWJTYAMKCatbv03l1rCAIAMGQaIu16tqFC/7r2t6YeR7iLEhsA+8rOztb1139fzz33vO699z4VFRYRiol4PB4tWvQtlZeXEwYA4BORUAchADDevanPx17HAABg0EYQAeyi9R9u6ZpSgoDh7XyxihXYAABDpiHSrtVV6/TO5o2EAQAW4XA4VFZWprKyMm3evFnPP/ec1lesJxiTWLbsJ7r33vtUVlZGGAAAiRIbAAAAAIuixAYABhEK9GrTr19V07rdhAEAiLttInSEuQAAIABJREFUwQa99eGmY5bXfAlBZUSSCQkALKC0tFSlpaVqbW3VihVPa+XKlYRiAhTZAAAAAAAAYHV22060kikHYEQ1a3fprwsfp8AG0+oNhDJIATCnbcEG3bHuP3Tv0w8fd/W1jv5u046vu9HHJAPAMWRnZ+vWW2/TG2+8qdtuvY2tRk1g2bKfsLUoAAAAAAAALMtWJbZvblzazpQDMJLmqia9cevzeu+uNer1BQkEpuVv8Y8mBcA8QglhvdH+wSfltVp33ed+vzfUSWgAYFEOh0OLFi/Wij/9Sffee5/OmnEWoRgYRTYAsLeIfz8hAAAAALAsthMFgDgLBXrV8E6ddjxeoe59rA4DAIjj76CEsN5u26EX3nxJHq/npH/O090hJecRIABYXFlZmcrKylRdXa3XXvsbW40aFFuLAgBgbCs39ahkQrpy0qXstD4CgS1EAvt4zxkAAAwaTygAIA4OFdc+qviQLUMBAHHnSwjq1b2b9OJrqwf08wc6vVKmOcfe09guzTidiwAATkFxcbGKi4t19dXf0Ruvv66n/viUPB4PwRjIb35zvwoKCpSfn08YAAAYyPbmEXrkiSP/9p47Z6bGZGfK5UxT4RiHckYO14TRvYQFa+kP0tgEACA2Ku00WEpsABAD3lqv2moOqH13iw78o16+6hZCAQDE3WDLa4e0tLVILMQGALaTnZ2tRYsX67LLL9e7776r5Y8/rpraGoIxAI/HoyVLbtKjj/6WIhsA2EnnPjIwuJaOo3s8FRu2HPN7Z5ScobG5Tn3twnxNc9H/AQAAwDG122mwlNgA4BQ0VzUd8c9dTT4FmjokSa3/cKu3s4fCGmwpHOKFNsBIGiLtWl21Tu9s3hiV4zW2NJk2Cz4IDACD53A4jthq9A9PPqn1FesJZogdKrI999zzcjgcBAIAgAE0t/Wc9PdWVu1QZZX0ytq3teiKi3XVPBfbjwIAAMDWKLHBNnw7mgnB5Lpa/PI3dx7366GuoNr3HL9AFuoMqmPX578J79m0l6CBAQh4ugkBMIAP+5q1tvqtqJXXDql115k2k1CrjwsDAKKouLhY991/v1pbW7VixdNau3YtW40OIY/Ho9uXLtUDDz5IkQ0A7KA/SAYGV7lz/4B+btXqdVq1WvrRdVfo8nPS5BgRJkwAAADYDiU22Eavjz/wB8tb61WvP3Tcr7ftaVVv1/E/aeZvbFfgo47jfj2wv13d+3ijGQCAU7Ut2KBn31od07KZLyGojEgyYQMAJB3cavTWW2/TjTf+QC+/9JKe+uNTlNmGyNbKrXr88f/SrbfeRhgAYHXd7ABhdPsbWwf18488sVor/pKlq792oRbPSiFQmEa/fw973AMAgEGzY4nNLYknUjCdUKBXbTXHf0PgRKuQSQe3u/w8rEIGAICJnhskhPWPrjqt2fhqXFZK6+jvVkaCOUtsvf6QEtOSuGgAIAYcDocWLV6sRYsXq7y8XMsff1w1tTUEE2crV67UmNwxWrR4MWEAADCEaurcgz6Gx+vVI0+s1itv5uu6K8/TRZPJFSbQ7ycDAAAwaHYssdWLEhsG4ESrkHU1+RRoOv4qYydahay3s0e+aj5JBwAAPl8oIay323bohTdfkscb2xVvnFlOzZ15gS4dP8vUq7CFuyixAUA8lJWVqaysTJs3b9bzzz2n9RXrCSWOHnr4IZVMn67i4mLCAACLinQ3E4KBbW+O7ltuNXVu3fGAW3PnzNQ1l07RNFcfIQMAAMDS2E4UtvLGrc8f92u+Hc1sOQoAg9AbCDUnOpJcJAHEhi8hqIrmKr36zmsxL68V5hdowexLdU56gZIiw6UI+QMATl5paalKS0tVXV2t1177m1auXEkocfJ//+8/68kn/6Ds7GzCAAArCvP6tZG1dMSmZFaxYYsqNmzR3Dkzdfs3pig7jTIbAAAArIkSG2yF7TIBIHbCff09icQARJ0vIahX927Si6+tjvm5zi+drfnFF2rKiI/7qBYpr3U3+pTiSudiAoA4Ky4uVnFxsa6++jtaseJpymxx4PF4dNedd+q3jz1GGABgNf0U2Iyuua0npsc/VGZbdMXFumqeizIbDCXSe4AQAACIgZRFkXI7jZcSGwAAAGBADZF2vb7n7/pbxdqYnscqW4YCAIwrOztbt956m2688Qd6+aWX9NQfn5LH4yGYGNlauVWrVq7UosWLCQMALCTSTUHE6Goa4vP8ZtXqdVr3Vpau/tqFuvycNDlGhAkfQ3+P6m0hBAAAMGiU2AAAAAADaYi0a3XVOr2zeWNMz2OnLUNDni4uLAAwAIfDoUWLF+uyyy/Xyy+9pJdeekk1tTUEEwMPPfyQSqZPV3FxMWEAABAn+5viV9L3eL165InVWvGXLC393nxdNJn8AQAAYH6U2AAAQFR0tXaOSMlIIQhggLYFG/TsW6tV666L6XmsumXo5+kPscUKABjJoTLbosWLVV5eruWPP06ZLQZ+dc89Wv6738nhcBAGAFhB5z4yMLjKqh1xP6fH69UdD6xSUUG+brlqjs4d389EAAAAwLTsWGKrlDSPqQcAILrCoTAtEeAUhRLC2tHzUczLa3bfMrTP183FBgAGVVZWprKyMspsMVBTW6NnnvmTrr/++4QBAECM1bclDu3v/Tq3bv2VW3PnzNQ1l07RNBcv0yF+Iv3BNkmjSQIAAAyWHUts7Uw7AAAAhlIoIay323bohTdfkscbn+1GvpU31xarrh0LJTYAMD7KbLGxfPlyzZ49h21FAcAKelrIwMBaOsOGeBwVG7aoYsMWLbriYl01z6XsNMpsiINwwCdKbAAAIAqGEQEAAIiGSH+EvUSBE/AlBPVG+wda+sJ9Wv7n/45bgS1e5zGy/t4wFyAAmEBZWZlW/OlPuvfe+1RUWEQgUfDvjzxCCABgBeEgGRhYbWPAUI9n1ep1umLpCv2uvFOBvuFMEAAAgDm57TZgSmwAACAqOva2u0gBODZfQlDPNlToB7/7WVzLa599DHYW8rIaGwCYCWW26NlauVWrVq4kCAAwuUiogxAMrKbBmB8ee+KZv2rRna9q5aYeJgkxvEH1jyAEAABiot5uA6bEBgAAAMRIQ6T9k/Lai6+tjsk5CvMLTur7OvrtXeIKh9hCBQDM6PAym9PpJJABeuqPT6m1tZUgAMDMKLEZ2v4m466A7vF69cgTq3XNvX/Xm7uYK0RfxF/Hiy4AACAqaMYDAAAAUdYQadfqqnV6Z/PGmJ1j4Zev0Oxx05WXkKn/eP/5E57LG+pUXnKmbeck5AkoLS+TixMATKqsrEznnnuuXn7pJT31x6fk8bBV9qnweDxaseJp3XrrbYQBAKb8g6aTDAyusmqH4R9jTZ1bdzzg1oySM/S/v3m2prnoHQEAAMBY7Fhiq2TaAQCIvlBnkBBge9uCDfrre6/r/eqqmBzfmeXUlRddrpmjJykjknxKP+vp7pCS82w7N/2sxAYApudwOLRo8WJddvnlevzx/9JKtsg8JStXrtSXv3yJiouLCQMATCbS6yMEA6tvSzTV462s2qEbqnZo7pyZ+uHlUzVhdC+TCAAAAEOwY4mtnWkHACD6gl0hQoBtbQs26Nm3VqvWXReT408vLtFXz/6SzjxUQosc+fXi8VNPuBLbgU6vZOOFyEKeLi5UALAIh8OhW2+9TQsXXqlH//M/tb5iPaGcpD88+aTuu/9+ggAAs+lmS2gj84cipnzcFRu2qGLDFi264mJdNc+l7DQ+/IWB6Q825pACAACIBrYTBQAAAAYglBDW22079PqW8piV1y6ZO19fmnie8hIG3z5raWuR7LsQm/p83Vy0AGAx+fn5uu/++7V582Y9/NBDqqmtIZQTWF+xXtXV1azGBgCm+4OG1e+NrKre3B+aWrV6nda9laWrv3ahLj8nTY4RYSYVpybUkkoIAADERLndBkyJDQAARE2kP9KdMCyBFy1gaYfKay+8+ZI8Xk/Uj+/McurS87+sua6Sk94ydNKocSf8nsaWJlvPGyU2ALCu0tJSLf/d7/TMM3/S8uXLCeQEWI0NAEyop4UMDKzZ4zf9GDxerx55YrVW/CVLN377i7ps+nAmFgAAAHFHiQ0AAERNsCvYkpKRkk8SsLLv/u7HMTnuibYMHaxYrRZnJr3+kBLTkriIAcCCHA6Hrr/++7r44vm699e/1tbKrYRyHKzGBgAmFGYlNiNrbG23zFg8Xq9+/Z/P69mCfN1y1RydO76fCcYJRfr54CAAAIiOYTYcczvTDgAAgIGaXlwStWM5s5xa+OUr9G/f/4V+OvvaTwtsp+hktxv1Jdj7jY9wV4gLGAAsLj8/X7997DHddutthPE5/vDkk4QAACYS6dpLCAZWsWHLoH6+qCBfv7p9kYoKjPO50Jo6t2791TNa9ocabW9mPQyc4B7VwwcnAQBAdNiuxPbNjUsrmXYAAGKjr6d3GCnA6kampQ/6GNOLS7TsO7fqwSt/om/lzVVOJC0uj73D5p+MDXr9XMAAYBOLFi/WqlXP6qwZZxHGMRxajQ0AYAL9rMJmZK3+wRe8xo7J1kWTpT8uO89wZbaKDVt0w10r9Kvn90dlrAAAAMDn4Y1mAAAQNX6Pnz0GYHkTcicM6OeOtepaUmR41B7X+aWzT/g93lCnreeuPxjmAgYAG2FVts/HamwAYA6R7gOEYGAtXYM/xoypYz/5/0Yts72y9m1dsXSFflfeqUDfcCYeh92kwuwlCgBA7NhukS5KbAAAAMApcCSlnNL3D9Wqa8fi6e6w9dz1NLZzAQOADS1avFhPPPHfcjqdhHGY9RXr1draShAAYHQ2/zCS0VXVD77F5hp99OsMh5fZnFlZhhnvE8/8VYvufFUrN/VQZoMkKdLnayEFAABixnZvalBiAwAAUdMbCGWQAqxubHr2Cb8n1quuHUvx+Kkn/J4DnV5bz12fjw8HA4BdFRcX67nnnte8ufMI4zArVjxNCABgdMEOMjCwZo9/0MfIGXX8bTovmiyt+uWl+tF1VximzObxevXIE6v1g//3jt7cxTUAAACA6LFric3N1AMAEH3+Fv9oUoDVOYYnn/B7PF6Ptn34vp7d9j96tqFCb7R/oG3BBjVE2uVLCA7ZY29ps/eHYymxAYDNf4c7HLrv/vt1ww03EMbH1q5dq0AgQBAAYGT+BjIwsMbWwS+OMc3V9/nPYUaEtXhWiuHKbDV1bt3xwCpdc+/ftb15BBeDXYXaWDAFAABEjV2fVdZLymf6AQAAcKpGDUs9qe+rddep1l133K8X5hdoTE6uJuROkCMpRWPTszU6MX3A241OGjXuhN/T2NJk+/kLtnUreXQqFzIA2Nj1139fRUUTtWzZT2yfhcfj0bvvvquysjIuDAAwqnAPGRhYxYYtg/r5UymkHSqzXX7OpXrpH36t+Mtb8niHfsX1mjq3brjLrblzZuqHl0/VhNG9XBg2Egl5+0kBAABECx+NAAAAURPqDBICLC8jkhyV4xwqub2jjUd97fCCmzMtU+Mcp8k1bOSgtyT9vFKdXfR1BSmxAQBUVlamVaue1ZIlN8nj8dg6i1UrV1JiAwADi3S3EIJBtfoH/xbbtKmFp/wzRi2zVWzYoooNW7Toiot11TyXstP6uEgAAAAGIWVRpNxuY6bEBgAAoibYFSIE2EJhfkFMC2HHK7g5s5yaWjT5iHLbqGGpyogkKy8h86SO7UsIRq2IZ0YhT0BpeZlcxAAA5efn69FHf2v7ItvWyq1qbW1VdnY2FwUAGEyk5wAhGFhL1+CPMTE/Z8A/e3iZbflrLVq1ep0hclm1ep1WrZZ+dN0VuvycNDlGhLlYLKzfv4edrwAAQNRQYgMAAABO0Zic3CFZ1czj9egd78Zjrt52funskzpGR3+3MhLsXGLr4gIGAHwiPz9fTz75B911553aWrnVtjm89NJqXX/997kgAMBwf8B0koGB1TYPfkcCV5Zj0MdwjAjr/3zVqavmXa0/rW82TJntkSdWa8VfsnTjt7+oy6YP54Kxqn4/GQAAgKixa4mtXNI8ph+wjoziHCWOTJEkjZqcq6SRJ35zvn1Xk3o/3vrQt6NZvT62QQSiocfX407JSOETeLC0nNE5hntM72zeeFLf5w11Ki/ZviuR9XX2cAEDAI6QnZ2tBx58ULcvXWrbItsbr79BiQ0AjCjAVqJG1uwNDPoYha5kSdHZdjM7rc9wZTaP16tf/+fzerYgX9ddeZ4umsx1AwAAgONjJTYApuGcNV6O00cpbUymcmbkSZJcJblRPYe31qtef0gtlQ3yN7ar48Nm+ap5sQgAcKTTRmaZ9rHf+/TDkqTpxSUac1quxmeP09j0bDmGn/yWpGYWavVxAQMAjuJwOGxdZKuprZHb7VZ+Pp9FAQBD6eF1SSPb4x78/BQ4I1F/XEYss9XUuXXHA27NnTNT11w6RdNcfVxAFtEfqCYEAABiw23HQVNiA2BIGcU5GjXFpeyz8jW66DRlFcanLHDoPIeX40KBXrXVeNRS2aCPyj+k1AacQF9P7zBlpBAELG3SqHE6v3S2GluahmRb0Wh4v7pK76vqqH9fmF+gMTm5Kh4/Vc7UUcpKGinXsJFKilhn649gW7eSR6dyIQMAjuBwOLTspz/VkiU3yePx2G7869atZTU2ADCaUAcZGNj2nbWD+nlnVpYcI8Ixe3yHl9ke/x+3Xln79pBnVrFhiyo2bNE/zb9AN34lX9lplNkAAACOo96Og6bEBsAQUsdl6LTSfGWfla+88wuU5Eg0zGNLciTKVZIrV0muSq4pVSjQq4Z36vRRxYfyvLuXbUiBz/B7/P3pOSMJApaWl5Cpm6d/Q5IUSgirub9Tuzv2aW/rPu127zFtsU2Sat11qnXXHbU9qTPLqalFkzUhd4IcSSn6YuYXTDvGvq4gJTYAwDHl5+fr0Ud/a8si25bNWyixAYDBRLr5MK1RBfqGy+P1DuoY06YWxuWxZqf16Y5vjNXXLrxaf3z1Q1Vs2DLk+b2y9m29svZtLbriYt3w5ZyYlvkQw3tUf7BN0miSAAAA0WLXElslUw8MvdRxGRpz0VQVXFoct5XWoiHJkaii+ZNVNH/yEYW2pnW7mVQAsKGkyHDlJWQqLzNTyvyCNOnIYtuBTq9q9tXq/eoqU4/T4/XoHe9GvaOD5bZJ191p2u1HQ56A0vIyuXgBAMeUn5+vu+/+V91yy822GvfWyq1qbW1VdnY2FwEAGECk5wAhGFidJ2HQx5iYnxPXxzzN1ad7v1uk7ZdOMUyZbdXqdVr3Vpau/tqFuvycNMpsZhMO+ESJDQAARJFdS2ztTD0wNBIzkpX7pcma/I1zTFVcO57DC21dt/j14fNb1bB6G6uzwdY6P/Llu87IJQjY2pHFNkl5c6XZUkOkXfsCB9Tg/cgSxTazCnm6CAEA8LlKS0v185//XPfcc4+txr1p09+1YMFlXAAAYATdlNiMrLZ58K//urIcQ/LYjVZm83i9euSJ1Vrxlywt/d58XTSZ68s0Iv3s+AUAQOzYstfEkwsAcZFRnKOJi89V0Xzr/gWanpOmc5ZcoJJrZ6nhnTrteLxC3ft8TD5sJxziE5PA8eQlZCovLVOz0yYeUWzzhjrV0NGs+qb6o7bxNKrdHfsOlvRMKHSgk4sRAHBCCxZcpsqtlVrzyhrbjLlyayUlNgAwimAHGRhYszcw6GMUupIl9Q3ZGIxYZrvjgVUqKsjXsu9doGmuPi40g4v465gkAABix5Y7TFJiAxBTeQtLVPCVErlK7LMq0+Grs9Ws3UWZDbYT6mQlQuCUflcmZCovOVNn5uRJOTN18/RvqCXBr8Yer+mKbWbR5+smBADASVl6++3asWOHamprbDHejX/nOQcAGIa/gQwMbI+7ZdDHyEk3xlgOldnevWiS/v1PG1RT5x7Sx1NT59YNd7k1d85MXXPpFMpsAAAANmLXElslUw/EVt7CEn3h2jlKz0mzdQ5F8ycr7/wCffjnStU8/S7bjMIWgl0hQgAGKSeSppzktCOKbb6EoBp727W/q1XVe3dqZ80uebyeIXuM1Xt36ouZXzBtxj3NXUpxpXOxAQA+l8Ph0B0//7muu+57thivx+NRdXW1iouLmXwAGGKR7mZCMLDtO2sHfYzsNGOVs84d368/LjtPb+46T0+88PchL7NVbNiiig1btOiKi3XVPJfh8oLU79+TTwoAACCabFli++bGpe3PzX6Q2QdiwDlrvM792VdsX147XJIjUSXXlKrgkmJt/fc31LRuN6HA8iL9ke6EYQmpJAFET0YkWRkjXJqS6TpYHpuuo4ptjS1NqnXXEdZJCHr9lNgAACeluLhYN9xwg5YvX26L8Va9/z4lNgAYav1BKcyHYY3M4/UO6ufnzplp2LFdNFm6yEBltlWr12nVaulH112hy89Jk2NEmAvQMPcqPxkAABA77XYcNNuJAoiK1HEZKr1rga22DT1V6TlpuvCXl6nhq2794+41rMoGSwt2BVtSMlL4JB4QY0cV2ySFEsJq7u/U7o592tu6T7vde2JSbHtn80bdPP0bps0u5OGFVgDAyfv2t6/SG6+/YYttRXfv5oNXADDUIt0HCMHAtjcP/q21MdmZhh+n0cpsjzyxWiv+kqWrv3ahFs9K4UI0wr2ql3sVAAAxZMsdJimxARiUxIxkFX3nXJVcU0oYJylvdr5cL96oTb9+lVXZYFmR/gjPMYAhkhQZrryETOVlZkqZX5AmHVlsO9DpVc2+Wr1fXWXrnEIHurhYAAAnzeFw6NbbbtMtt9xs+bFu/PtGJhwAhlrnPjIwsJaOwW9r6XKaZycTI5XZPF6vHnlitV55M1/XXXmeLprM9TiUIr0thAAAAKLKzm8wb5N0JpcAMHBsHTpwSY5EXfjLy7Tz7CpV3b+WQGA5vsaOvtRMdhMFDPN754him6S8udJsqSHSrn2BA2rwfjSgYltLgl85EXM+Dwi1+rgwAACnpLS0VPPmztP6ivWWHqfH41Fra6uys7OZdAAYKj0UQ4ysua1n0McomZAuqc9U4zZSma2mzq07HnBr7pyZuubSKZrm6uPCjLdIuFsSLwADAICosnOJrZ3pBwbxR/aP52vqwhKCGKSpC0uUc+ZYVdz0DNuLAgDiLi8hU3lpmZqdNvGIYps31KmGjmbVN9Xrnc3HX40l2N8rJZh3/D3NXUpxpXMhAABO2pL//b8tX2KTpO3bt6usrIwJB4AhEummxGZklTv3D/oYOSb+U9RIZbaKDVtUsWGL5s6Zqdu/MUXZaZTZ4naf6vO1SMonCQAAYqbejoNmqy8ApyR1XIbm3HelsgqzCCNKsgqz9NUXb9Sbt6ySr5oXqGANnR/58l1n5BIEYEJ5CZnKS87UmTl5Us5M3Tz9G2pJ8Kuxx3tUsW1f4IDy0jJNO9ag10+JDQBwSvLz87V48WKtXLnS0uNsbmpisgFgqPQHpVAHORjY/sbWQR/DCmUrI5bZFl1xsa6a56LMFg+Rft5jBgAghlIWRertOO5hNp5zVmIDTlHuxZP05T98lwJbDCQ5EnXRvy9SHqvbwSLCoTAhABaSE0nTmcl5WvBxqe2Z6x/Qf33//9O09DxTjyvk8TO5AIBTdvXV37H8GN977z0mGgCGSKT7ACEY3GDLWnPnzLRUHhdNlv647Dz96vZFKioY2oW5Vq1ep+vu+R+t3NSjQN9wLtZY3qv8dTQFAQBA1Nm5xFbJ9AMnr/Cac3XhLy9TkiORMGIkyZGo8348nyIbLCHUyfa4gNVlRJKVEUk2973qQBcTCQA4ZdnZ2VrwTwssPcYPtn/ARAPAUOncRwYGtr158ItPjcnOtGQ2RimzebxePfLEai2681W9uYtrNmYi4RRCAAAA0TaMCACcyNm/WKBzllxAEHFCkQ1WEOwKEQIAwwu1+ggBADAgV37965Yen8fjUSAQYKIBYCj0tJCBgbV0DH7xKZczzdIZHV5mm1FyxtA9n/F6dccDq3TNvX/Xu3t5OzTa+rs+cJECAAAxs96uA+dZG4DjSsxI1tm/WKCi+ZMJI84ossEKwqFwGykAMLqeZlZjAwCcuuLiYhUVFll6jPX19Uw0AAyBSNdeQjCw5raeQR+jZEK6LbK6aLL06M3TtfwXVw/pFqo1dW7d+qtnorKKHgAAAGKL7UQBHFNiRrLm/vbbFNiGEEU2mF1vTy9LHAEwvKDXTwgAgAH59lXftvT4WlpYCQgA4i7UKYWD5GBglTv3D/oYaUkJtspsmqtP9363aMjLbNNcfVzAUdQfdBMCAACIOjuX2NqZfuDYDhXYsgqzCGOInX1zmTKKcwgCptTj62bFVwDGv1d91EEIAIABmTXrPEuPr7mpiUkGgDiL9BwgBIPb39g66GNMGN1ry+yGssxWVJDPxRttYT4UCABADNXbdeC8uQzgKCX/PJ8Cm0EkORJ10b8vUuq4DMKA6QQ7g/2kAMDoQgc6CQEAMCDZ2dla8E8LLDu+3bt3M8kAEG9dDWRgcDV1g1t9akbJGbbPcCjKbGPHZHPxRlEk3NVMCgAAxFS9XQfOSmwAjnD2LxawhajBJDkSNee+K5WYkUwYMJVub4BlBAEYXp+vW73+EEEAAAbkggsvtOzYOjspegNA3HWzlbOR1bclDvoYY3OdBPmxeJbZZkwdS+DRFA6yNysAAIgJ25bYvrlxaSXTDxxp6pILKbAZVFZhlkr+eT5BwFSCvmAqKQAwg5A3QAgAgAGZNm2aZcf2wfYPmGAAiLNI115CMLCWzvCgj1GUR4ntqOdTcSizuUanEHQ071X+OkpsAADElm0X5WI7UQCSpNyLJ6nkmlKCMLCi+ZOVt7CEIGAaoc4gIQAwhZ5GHyEAAAYkOztbZ804y5Jj83g8TDAAxFHEv58QDK62cfAfgCoc4yDI44hlmS1n1AgCjuoNK0wrEACA2LLtolyU2AAoozhHs356KUGYwNk3lyl1XAZBwBSCXWzPB8CXBpvIAAAgAElEQVQcej5qJwQAwIDNLJ1p2bEFAqxWCgBx07mPDAyupmHwBe+ckcMJ8gRiUWYrcEYINor6uz5wkQIAAIgFu5fY1nMJwO4SM5JVesdXleRIJAwTSHIkqvSuBQQB0+gNhJpJAYDRhVpZiQ0AMHDTp59p2bHV19czwQAQLz0tZGBw+5sGX2KbMLqXIE/SNFef7rp6sq779lcHdRxnVpYcI8IECgAAYAKsnwvY3NQfzlVWYRZBmIirJFd5C0vU8GIVYcDwwn39PVRkAZhBT3OXUlzpBAEAOGXTpk0jBADAoEW69hKCwVVW7RjUz88oOYMQjyHQN1x1ngS1dPSpua1HNQ0edfp7VLFhS3Seq00tJOQo6w9UEwIAADGUsihSbtexU2IDbMw5a7ymLiwhCBM6++YyNb2+S72+IGHA0LpaO0ekZKQQBADD6270UWIDAAyIw+FQUWGRamprCAMAMCCRngNSmNf5jKy+bfAf0xyb67Rtfq3+EWrpkmqbg/J390a9qPZ5JubncAFH9YYV7paUShAAACAW7F5iK5c0j8sAdpSYkaxzf/YVgjCpJEeipv5wrqruX0sYMLS+nj4K8wBMoaexXZpxOkEAAAbkjDPOsGSJrer991VcXMwEA0Csde0jA4Nr6Rz8dpRFedYusX22qFa5c798nf5Br2A3WK4sBxdwFEX6fC2S8kkCAADEAm8sAzZV9J1zlZ6TZpnxeGu96vWH1FLZIElq39Wk3s6Dn14M7G9X9z7fMX8uozhHiSMPrhI1anKukkYmK3NijtJcIw2/zerUhSXa86dNxx0bYAQde9tdudPGEAQAw+vZ5yUEAMCATZo0iRAAAAPX3UoGBlfbGBj0MVyjzb9bQX1bovyhiKrqu9TV3as97hZDFNU+T6ErWVIfF3G0hNqGEQIAADG13s6Dp8QG2FDquAyVXFNqzr+PAr1qq/GopbJB7buaFPioQ77qlgEf7/Cf9Wzae9TXnbPGK/ucfI09v8iQpbYzbpyr9+5aw0UNwwqHeIEIgHn0NHexpSgAYEBcubmEAAAYsEjXXkIwuJoGz6CPkTNqhMxQpjpWUW1/Y6tq6tymnLsCZ4QLOJr3q5C3nxQAAECssJ2o9C9cBrCb0rsWmOrxNmx0q2Vrgw78o35QhbWB8GzaK8+mvdr56FtKzEhW7pcmq+ArJXKVGOMNiqL5k7Xj8QxWY4NhBTzdhADANLobfZTYAAADkpOTQwgAgIEJdUqhDnIwuE5/z6CPMc1lrALb9uYRaunoU3Nbj2oaPNrf5DH0imoD4czKkmNEmAs4ivr9e9hKFAAAxAwrsQE245w13jAFrOMJBXrV8E6dPqr4UE3rdhvmcfX6gmp4sUoNL1YpdVyGJl41S4WXTFWSI3FIHxerscHowqFw2/Ck4aNJAoDR9TS2SzNOJwgAwCmbMGECIQAABiTi308IJlCxYcugfr6oYGh6P63+EWrpkmqbg2r2BrTH3aLtO2vl8XptMW/TphZy8UZbv58MAACIrXI7D54SG2Az066/wLCPrbmqSXX/c7AkZnTd+3yqun+tdj5WoaLvnKspX58xZGU2VmOD0fX29PoosQEwg559XkIAAAyIw+Gw5Lh2797N5AJArHU1kIHBtfoH/1ba2DHZMX2M9W2JaukMq7YxoJoGjzr9PYMu3lnBxHxWy422/kA1IQAAgJixdYntmxuXlj83+0GuAtiGEVdhCwV6Vfu3ndrzp02mLGH1+oLa+ehbcr+0TWcuna+82UPzibqJV81S1f1ruchhSF2tnSNSMlIIAoAp9DR3saUoAGBAigqLVFNbY6kxdXZ2MrEAEGORjl2EYHAtXYM/xoypYwd9jEDfcNV5Ej7ZArRy537tb2xVTZ2bSTqO9NREQojqDSvcLSmVIAAAQKywEhtgI0ZahS0U6NWHf65UzdPvqtcXNH223ft8+vvSP2v/whKdfXNZ3FdlK7xkKiU2GFZfTx/PNwCY53d6o48SGwBgQMaNG2e5EhsAILYiPQekcJAgDK6qfvAtNtfok/+A56EtQKvqu9Ts8auxtd1WW4BGU8mEdEl9BBGte1afr0VSPkkAABBT5XYePG8qSx2SRhEDrC51XIZhVmHb+WKVdj5WYYny2mc1vFiljg+bVXrHV5VVmBW38yY5EpW3sMQUW7HChr9o97a7cqeNIQgAptDT2C7NOJ0gAAAAAMRe1z4yMIFmj3/Qx8gZNUKfLVNtbx4hf7D/ky1A9zd5VFm1g8CjKIfPqEVXqG0YIQAAgFiixCZVSppHDLC6iVfNGvo/9quaVPnwOvmqWyydta+6RRU3PaO5v/12XItsYy+cTIkNhhQO8WlHAObRs8+r/t6whiUOJwwAAAAAsdXVQAYm0NjaPuhj1DYHtXFHQHvcLWwBGkfZabwuGU2RkLefFAAAiLl2Ow+eEhtgE4WXTB3S8//j0bdV+8d3bZN3ry8Y9yJb3ux8/SMj2ZIr3MHcAp5uQoDt+BKC6uj/9Nrf3XHw0/XO1FE6MzmPgAyuu6lTaXmZBAEAOCWTp0zW+or1BAEAOGmRrr2EYAIVG7YM+hi//s/nCTLO5s6ZSQhR1u/fw1aiAADEWMqiSKWdx0+JTaoXK7HB4vIWlijJkTgk5+5q8eudn75o+dXXjmUoimy5X2I1Nhj0v4dAqDnRkeQiCZhNS4Jfwf7eT/75UBlNkg50etXS9unvt3c2bzzh8ZxZTv3Hwp8RrMH1NPoosQEATll6GvtVAQBOXsS/XwrzYVSja/XzNppZjcnm7/qo37f6DhACAACIKZ59HyyxAZY29sLJQ3Le5qombfznP9t6ZbBDRbavvnhjXIqEbCkKo+oLhfsSHeSAoXN4GS0QDmp/V+snX9vbuk9d3V2SpE5/l96vjt191OP1qCXBr5xIGpNiYD0ftUsaTxAAAAAAYqdzHxmYQEsXGZjB3DkzNSY7U4XjMlXoSlaBMyLHiDDBRFmkp44QAACILdvvOU+JDbC4xIxk5c2O/wrPNWt36b271jABOlhke/tnq/XFh78R83Plzc7X34kcBuRr7OhLzUwlCAyaUcpog/FBW52+mPkFJtPAQq0+9fpDSkxLIgwAgK1NnjKZEAAgVny7ycAEquppsRlJUUG+pk7MU1GeU4VjHCpwDlN2Wt9nvquPoGIg0h9skzSaJAAAiKl6uwdAiU2qJAJYmfPc+K8iQoHtaJ5Ne7XzxSpNXVgS+zmfNV6eTXsJHYbS7Q3kkAIOZ4Uy2kBt2rFFX5xNic3oepo6lVjkJAgAgK2xRSoAxEh/UJHuFnIwgWaPnxCGgDMrS9OmFmpifo5cWQ4VupI1zfXZclr/x/9DXPR1BUSJDQAAxBglNqmdCGBlp8+dEtfzUWA7vp2PVajwkqkx31Y0+5x8SmwwnKAvyDJsFtUQ+fSplN3KaAP1fnWVQnPCSooMJwwDC9R7NJISGwAAAIAYiHSwJZ9ZNLbyFlKszSg5Q2NznSrKc6pkQrpy0sXqaka8b/nrmAQAAGLP9otwUWIDLM515ti4nctb61XV/1tL6MfR6wvqwz9XquSa0pieJ2dGnnYSNwyms7GTEAzu8DKaN9QpT3fHJ/9cvffTu0pjS5Nq3bzYPlh1vQc0ZYSLIAysZ38bIQAAAACIja4GMjCJ7TtrCSFKDq2uNmPqWLlGpyhn1IhjrK5GT8qo+oON7LQBAEDs2f4TFLYvsX1z49Ly52Y/yH8KsKTUcRlKz0mLy7lCgV5t+MkL6vUFCf5z1Dz9rqZ8fUZMV2NzleQSNAwpHAq3DU8azpLzMUYZzRy2NX6oKXmU2IysP9irnuYupbjYRg0AcHLee+89QgAAnJRIxy5CMIFA33B5vF6CGIAZJWdoSuFYuZxpKpmQrgJnRI4R4c98F4U1Uwm1sNMGAACxR4mNawCwrtNK8+N2rk2/flXd+3yEfgK9vqBq/7ZTUxeWxPQ8GcU58lW3EDgMJRQIBVKTUimxRcG2YIPe+nCTJMpopp3DD9/Xt/LmEoTB+d1eSmwAAFsrmT6dEAAgyiI9B6QwHwQ2gzpPAiGcQFFBvsaOydaMqWNVOMahnJHDNWF072e+i7KaFfQHqgkBAIDYYztRrgFJkltSPjHAajInxWdFroaNbjWt203gJ3vDWbMt5iU2x+mjKLHBcHyNHX2pmXxgLxrGpGTpnc0bCcLEat118iUElRFJJgwD6/moXdJ4ggAAAAAQPe01ZGCWv92bKRsebu6cmZqYnyNXlkOFruRjrK7W//H/YDWR/mCbJD6cDAAAYo4S20H1osQGCxo9MTsu59n24FrCPgW+6hZ1tfhjutVr5uRcioUwnG5vIIcUoiMnkiZnllMer4cwTGx7V4Nmp00kCAMLtfrU6w8pMS2JMAAAJ7Rv3z5CAACcmI/X7Myi2Ruw5biLCvI1dWKeivKcKhzjUIFzmLLTPruaGqur2UpfV0CU2AAAiAdWYuMaAKzLVRL7ldhq1u5iG9EB2PdObUxXY8ucSFcIxhP0BVmGLYrmzrxAL762miBM7MOP9mj2JEpsRhfY26ZRZ7gIAgBw4r+Pa623sk5xcTETCwDR1B9UpJvdE8xij9vac+XMytK0qYWamJ+jotNHKmfUCE1zfbacxupqkCL+OlqLAADEQcqiSLvdM6DEdlC5pHnEACtJHZcRl/PseLyCsAeg9b36mJbYktLZng7G09nYSQhRNCWngBBMbssH7+naSZcShMH1fNRBiQ0AcEKBQIAQAAAnFOmoIwQT2b6z1jJjmVFyhsbmOlWU51TJhHTlpIvV1XDS+oONfGoeAIDY6yACSmyAZTnGZsb8HA0b3azCNtDfQDubY3r8NNdIQoYhhUPhtuFJw1l6PgoKUnjtyOw8Xo8aIu3KS8gkDAML1Laof26RhiUOJwwAwHHV19dbbkxnzTiLiQWAaOtgK1HT/C3YN1wer9d0j/vQ6mozpo6Va3SKCrITNWF072e+i7IaTlGohR02AACIvUoioMR2SD0RwGocp4+K+Tn2v7WLoAco1uW/9Jw0QoYhhQKhQGpSKiW2KMiIJGt6cYner64iDBPb1rpHeTkzCcLov7ebOpWWR9kQAHB8LS3W224sIyODiQWAKItQYjONOk+C4R/j3DkzNSY7Uy5nmkompKvAGZFjRPgz39XLZGLQ+gPVhAAAAOKCEttB9UQAq0kbE/s3Wptep8Q2GM1VTXKV5BIEbMXX2NGXmskH96KlpOgLlNhMrqrmAy2gxGZ4AbeXEhsA4PP/vmtqstyYJk+ZzMQCQBRFfGwlaia1zUHDPJaignyNHZOtGVPHqnCMQzkjh7O6GuJ37+oPtkniQ8kAAMQeK7GJEhuAAfLWetXrCxKEgSVmJDNHMJxub4A9MKNoUlYeIcTQ+aWzlTP64CX74murY3KO96urFJoTVlKErSqNLFDbKl1QSBAAgON67733LDem9LR0JhYAoqljDxmYiL97aFYwmztnpibm58iV5VChK/kYq6v1f/w/IE76ugKixAYAQDy0EwElNknSNzcuLX9u9oMEAUtx5MZ2O9GWbfsJ2eAyznDJs2kvQcBQAgf8LMMWRVNGuAghCs4vna0JuRPkSErRpFHjNGpYqjIiyZKkjf49WvHaszE7tzPLqXb1KEdsA21k/cFe+RvaWY0NAHBcH2z/wHJjKpk+nYkFgCiKdLCrhZlU7ozt699FBfmaOjFPRXlOFY5xqMA5TNlpn11NjdXVYIB7l7+OCxEAgPigxCZKbIBlpedmxPYOuruJkAGcsoCnmxCi7JK58/W3irUEcQLOLKemFk3WhNwJcqZlapzjtCPKakeISA2Rdj32+tOqdcduu5fzS2frf5152bEfAwynp9FHiQ0AcEytra3yeDyWG1d2djaTCwBREvHvl8LsmGAmP7x8qmZMHauu7l7tcbdo+85aebzeUz6OMytL06YWamJ+jopOH6mcUSM0zfXZThCrq8G4+v178kkBAIC4YDtRUWI73DZJZxIDcHICH3UQAoAB6Q2EmhMdSSwhFiVTTp+ov4kS2yGF+QUak5Or4vFTlZqYonGO0+QaNvLY23VGjv5XvoSgXtj1ZsyLgTd8/Xv6YuYXjvkYYNDnPnWtcp47niAASYFAQI8//l+68cYfyOFwEAhsb/v27ZYcFyU2AIiijhoyMJkJo3s1YVaKpBRJIyUVKdA3XHWeBNU2B9XsDRxVbptRcobG5jpVlOdUyYR05aSL1dVgepG+A4QAAADihhLbp1iaDwCAOAh2BUOJjiSCiJKi9DG2G/P5pbMlScXjp0qSJo0ap+RhicqJHGdLzpMoioUSwnq7bYdeePMlebyxW0llenGJrp/zzeM/VhhWn69bwbZuJY9mV2TYWyAQ0O1Ll2pr5VZ1dXbp53feSSiwvcrKrZYb07y585hYAIiiSMduQrAAx4iwprmkaa7hOlhsO1huO85fkQQGa9y/euoIAQCAOEhZFCknBUpsh6uXxCt0wEny7WgmBAAD0tXalZSeM5IgoiQnkqbC/IKYbnsZa4dWT5Ok9NR0jc8e98nXxqZnyzE8+fNLatKgVjT7sK9ZT5U/F/MMWX3NAvev3a1KZjU22NyDDzygrR8Xdta8skbpI9N16623EQxsbfO7my03pslTJjOxABAlkZ4DUohdLQCY8P7V2+aWxHaiAAAgbiixfaqeCICT1+sLEsIguUpyY3r8wH4WmIQxdextd+VOG0MQUXTmlOmGKLE5s5yaWvTpG56HVkqTJGfqKGUlfVpezEvIPLWDx6D45UsI6qltL+udzRtjmgurr1kHW4rC7h5++CGteWXNEf9u5cqVkkSRDbbldrtVU2u9LeKKiiYyuQAQLd5qMgBgTqG2YYQAAEBcbCOCgyixARgQ56zx8mzaSxADlDouI+bn6N7nI2gYUsATIIQom5JTEPVjHtqyU5Im5E6QIynl4P0rMUXjHKd98jXXsJFKigw3VV6hhLBea96qFS8/E/NzsfqatbClKOysvLz8k8LaZ61cuVJdnV1aevvtcjgchAVbqap635LjKigoYHIBIErYShSAWfX769NJAQCAuGB1mo9RYvtUuaR/IQZYRaiLldKM7LRSVuCGfYVDYUX6I90JwxJogUTJGSmnH/drh5fRckbn6LSRWZ/886RRn27bOWpYqjIiyad+cpOVs7YFG7T8r3+Ux+uJ6XlYfc262FIUdrR582YtW/aTz/2eNa+s0f79+/XAgw9SZIOtvLLmFcuNyel0Kj+fv1kBIBrYShSAue9hdaNJAQCAuKDE9jFKbIBV73J7WpQ3mxedjSr7rNjOTSjQS8gwtB5fjzc1M3UsSURHUmS47r/uTklS8rDEgRWnLL5SWEOkXaur1sV861CJ1desji1FYTdut1t3331yn/faWrlVty9dSpENttHa2qqtlVstN67Z581mcgEgWthKFICJ9Qe4hwEAECeVRHAQJTYuCmBAss/JZzvRQcg7P7Zbs7TVeAgZhuZr7OhLzWQhtqjeVxIyD/4filNHCCWE9Ze97+jF11bH/FysvmYPbCkKOwkEAlqy5CZ5PCf/3JIiG+zkjddft+S4Jk2axOQCQJSwlSgA096/+oNtkliJDQCA+GAlto8NI4KDvrlxKRcFLMXfGNtL2pE7ipAHKG9hiZIciTE9B9vJwug6P/KxVCRibqN/j5a+cF9cCmxXX/Zt/XT2tRTYbKJrdyshwPICgYBuX7r0lApshxwqsrndboKEpb300kuWHNd5s1mJDQCiga1EAZhayNtFCAAAxA2Lbn2MldiOtE3SmcQAKwh8FNsXSFxnsgvgQBV8pSTm52jf00LQMLRuT4AQEDMNkXY99vrTqnXXxfxchfkF+uGXvvPpSniwx/MsthSFDfzr3XcPapvErZVbtWTJTXr00d8qP5/uOqxn8+bNqqmtsdy4nE4n/80CQLSwlSgAE4sE9iaRAgAAiDdWYjsSq7HBMgL7Y3s5p+ekKXVcBkGfIues8XKV5Mb+ZraribBhaMGuECEg6kIJYT25+1X9+IlfxqXAdvVl39a/zL+JApsN9fm61dPMB5JhXQ8//JDWV6wf9HE8Ho+WLLlJmzdvJlRYzvPPPWfJcc0+j1XYACBaIt4qQgBgWv1dH7hIAQCA+EhZFCknhYMosR2pnghgFd37fDE/x2mlfDr7VE27/oK4nCfWK/EB0dDj62GPMUTNh33NWvrCffpbxdqYn6swv0D3X3enFuTMVFJkOOHbVOduVj2FNa1Z87JWrlwZteN5PB7dcsvNKi8vJ1xYRmtra1SKnkZ0wYUXMsEAEAURX50UDhIEANPqD/LSLQAAiD9KbEeqJwJYibfWG9Pjx2NbTCspvObcuKzCJkm+at5Yh/F1tXayrTkGLZQQ1pqWLbr7D/fL4/XE/HysvoZDArWthADLKS8v1z333BOTYy9b9hP9/ve/I2RYwooVT1t2bNOmTWOCASAaOvaQAQDTivQH2xT2EwQAAPGxjQg+xZvHR2I7UVhKW80BZRVmxez4rpJcpY7LiMuqb2aXOi5DJdfOisu5mqvYShTm0NXUmXVaUTZBYMAaIu16bN3Tcdk6tDC/QD/80ncOltciZA+pP9grf0O70vIoNMIa3G63fvOb+2N6juXLl6vxo0Ytvf12ORwOQocptba2RnW1QiM5a8ZZys7m+TkAREOkYxchADCvkLdL0miCAAAgLugpHYaV2I5USQSw1N0uDttcnXHjXII+CXPuu1JJjsS4nKulsoHAYQqBA/5UUsBAHFp97cdP/DIuBTZWX8PxdO1i5VNYQ2trq5YsuUkeT+xXtFzzyhrdvnSpWltZzRDmZOVV2MrKyphgAIiCSNtOthIFYO77WGBvEikAABA39JQOQ4ntSDQcYSkdu2K/Ilfe+QVKHZdB2J/j7F8siOmKeJ/V+g83ocMUAp5uQsApa4i061/X/lYrXn4m5ucqzC/Q/dfdqQU5M5UUGU74OPo+Vtui/t4wQcDc13EgoLvuvDMuBbZDtlZu1bXXflfV1dVMAEylurrasquwSdJ5s2czyQAQDR27yQCAqfV3feAiBQAA4oae0mEosR3mmxuX0nCEpXg27Y35OZIciazG9jnO/sUCFc2fHLfzhQK9cZl3IFq627v3kwJO6v4W59XXLpk7n9XXcFL8e/n7EuZ2+9Kl2lq5Nf5/q3g8uu6672nNmpeZBJjGH5580rJjKyosUn5+PpMMAIPVH1SEEhsA09/K+KA8AABxVE8EnxpBBEfpkDSKGGAVDRvdypsd2xeii+ZPlvuV8ZSnPmPqkgvjWmCTpOZtHxE8TMXX2NGXmsmuojjB77JIux5b93RcymvOLKduuex6TRnhkiJkj5O4j1Xt18giJ0HAlB5++KEhKbAd7p577lHl1kotvf12ORwOJgWGVV5ervUV6y07vssvv5xJBoAoiHh3EAJM681dUnNbjySppsGjTn+PLpldpIsmk42t7mP9wTaF/aNJAgCAuKkngk9RYjtapaR5xACraNnaEPMSmySd+7OvaN01T6rXFyR0xX8FtkP2v7WL8GEqnR/58l1n5BIEjuuN9g+0/M//HZdzXTJ3vq6aPJ+tQ3FKQq0+9fpDSkxLIgyYyqqVKw2zLeKaV9Zo//79WvbTn7ISFAwpEAjoN7+539Jj/OKXvsREA0A0eD8gA5hWc1uPHnli9RH/bsbUsZJSCMdOQt4uSZTYAACIn3oi+BTbiR6N/YBgKY1v7ozLedJz0nTO3Qtsn3diRrLOe/DrQ1Jgk6Sm1ymxwVy6PQFCwDG1JPj1641PxqXA5sxy6u7v/ljXTrqUAhsGxLe9iRBgKuXl5Xro4YcM9Zi2Vm7VkiU3qby8nAmC4Tz4wAPyeDyWHd9ZM85SdnY2Ew0AgxTpOaBIdwtBwLS6unsJAYoE9vIpPQAA4ihlUaSeFD5Fie1olUQAK+ne55O31huXc+XNztfZv7BvkS2jOEcX//HauKx8dyw1a3exEh5MJ9gVUqQ/0k0SONwb7R/o//zuLr1fXRXzc10yd74evPInB7cPBQYoUNdKCDANt9utZct+YsjH5vF4tGzZT3TPL3+pQICiO4xh8+bNWvPKGkuPcdHixUw0AESDt5oMYGp73EeXMCm22U9/1we8SAYAQPy4ieBIlNgAG6h7NX4voBTNn2zLItvUJRfqkt9/R+k5aUP3G+6V97nYYUo9vh4vKUBi9TWYV5+vW/4GFnSG8bndbi1ZcpPhH+eaV9bohu9/X243r+FgaLW2turuu//F0mN0Op0699xzmWwAiIKIt4oQYDnHKrbB2voDFHJhbSPGXacR464jCABGUU8ER6LEdrRyIoDVxGtL0UPsVGRzzhqvr6z+gUquKR3Sx9HV4pdn014udphSx/72EaQAVl+D2QXc9HFh8Gs0ENC9v/61abZErKmt0aJF39KqlSuZPAyZu+6809LbiErS/Pnz5XA4mGwAGKRI204pzA4JMLeKDVsIwe73snBXMynAypLPflIjzv+9Rpz7bxo+eh6BADCCeiI4EiW2o7GEAiyne59PzVVNcT1n0fzJ+tKKa5WYkWzJTDOKczT38av0xYe/MaSrrx3ywZMbuNBhWh1722kS2Rirr8EqunZ8pP7eMEHAkAKBgG5fulRbK7ea7rE/9PBDuumHP2RVNsTdww8/ZMr/Zk7VwoVXMtkAEA0du8kApvbuXt4uhKSelhAhwIoSknKUPOsFJUz67sF/kZiuxIvWaFjaFwgHwFCrJ4Ij8az0M765cWklKcCK6v4n/svZZxVm6asv3qjciydZJkfnrPE678Gv65Lff0euklxDPKZQoFdNr+/iIodpBTwBQrCpjf49+sUL/xaX1dfOL53N6muIuc49BwgBhvT44/9l6jLO1sqtWrToW1qz5mUmE3FRXl6ulTZYBXDe3HnKz89nwgFgsEKdilBig8lt/KD1mP/e1+knHBsJd24/jRRgNQlJOQLiqYgAACAASURBVEr6YoUSJiw88guJ6Uq88HklJOUQEoChVE8ER6LEdmwdRACraXixSqFAb9zPm+RI1IW/vExzH79KqeMyTJtf3sKST1Zey5ttrBf5P/xzpXp9bFcA8wqHwuoNhFiq3kZ8CUH9x/vP65GVv5XHG9stupxZTv1o8U26efo3WH0Nsb+2399HCDCc3//+d5Yp49xzzz36yY9/zKpsiKny8nItW/YTW4z1K1/9KhMOAFEQ8VYTAkxte/MIrVq97phfq6zaQUB2up/1uFNJAVbySYFt1JRjf33UFCVd8ApBARhK9URwpBFEcOzn5ZLYCBuW8+GfK1VyTemQnNtVkqsFz31fNWt3acfjFere5zN8XrkXT9Lpc6co7/wCJTkSDfkYQ4Fe1Tz9Lhc3TM/v9YcyHUkEYQMb/Xu04rVnY15ekw6uvva/zrxMGZFkgkdc9Pm61dPcpRRXOmHAEMrLy7V8+XJLjWl9xXqtr1iv2269TYsWL2aSEVVut1u/+c39thhrUWGRysrKmHQAiIJI2weEANOqb0vUsof/ShCQIuHuSE8dJTZYxvDR8zTigj8pwXH6535fQvZMJc96QcFNVxIagCF5OkYER6LEdmztRAArqnn6XU35+owhLWQVzZ+sovmT1VzVpF3PblbTOuMstZ+YkSznueMNX1w7HKuwwSq6mjvTM8eNJggL8yUE9dS2l/XO5o0xP5czy6mrv/wtzU6bKEXIHvHVubuFEhsMobq62tKrST308EMqLy/XLT/6kYqLi5lwDJrb7daSJTfJ4/HYYrw33Hgjkw4AURDx1UkhNnaBOb25S3rwv/8qj9dLGFCkt90raSxJwAqGj56nxIvWSIkn9xpdwoSFSmz/hXo/vIvwAMRVyqJIPSkciRLbsVVKuoIYYDW9vv+fvXuPj6qw8///nskFSMIlhEwQgiGJXIxggjVSCkIQrbXFKlYb1m63aouX/bYVo7W1XS11e1FWUNtda+ul+GtrsbqlbLGtjdqAWsRQCAaigAkJuUgmmdwzITOZnN8fMYjIJZc5kzlzXs/Hw8cDJMzlPSeHmcl7Pp/uEZ3GdryUuZOVMvdK+e7xq/qNQ6rbtl+etw6HtJA1JnWcxs9OUfIF0+XKnqqJGRMt9Xh2uDuZwoaI0VbTmqhPkEOkYvoa7KTjnTolzU+TM4b1tRg5VVVV+ta37or4+7m7ZLduuulGrVy5UjfffIvi4uJ48DHk7xk7FdiYwgYAQdTEFDZYS2VzjEqrj+r3fy5W+aGqAf2dhs5oJcf3EF6EMzre42fGiAiOWNegCmz9onLuleFvVU/FOkIEECpVRPBxPCE5OSaxIWKFwzS248XGxRybziZJTRVNcu+pVcvBI/LWtcqz4/Cwr2NM6jjFTZ2g8TMnK3bsKLlypikxM8kSk9ZOZ/fPXmUKGyKG19NFCBGI6Wuwq/b3GjX+3BSCwMj8m+r16rv33GObMo4kbdy4UYWFhbrtttu0fPmVHAQYFLsV2CTp85//PA88AASDr11G60FyQNhp6IyWu0Pq7O5Vxfte1Xs69X5Di7b9Y+eQLs/dISXHk2uk6+3YyxsZsDxHrEuxl2wbdIGtX3TOGhnNOxVo3kqYAEKhkghOci4mgpMqIQJEqnCaxnYyEzMmfjARbe5H/n996RFJkq+jWy3vuU/59yec41JsQt/0nUgoqp1KfemRsFrFCgRDV0tX7ZgJYxhZHyH299TrZ396iulrsKW2t2sosWFEeL1e3VlQoPKKctvdd4/Hox/+8Id6ccuLrBjFgBUXF2vNmu/bqsCWlJSkKymxAUBQGE1lhBDm3jrs1Oof/Y4ggAHo7WYYDKytv8DmGD9r6BcSk6CYpVtkvLRAvZ1MWwVgOnpJJ0GJ7eQqiQCR7N3HXlP65VlKcFnn41Mpcycf+/W0BWm2fvx8Xr+K79/CgYyI01rbEj1mwhiCsPo5yhHQswcK9dK2QtOvi+lrCFc9bV06Wt+h0SkJhIGQWr9unXaX7LZ1Bv0rRpd/brluufVWJScnc2DgpIqKivSd73zbdvf7W9+6m9W7ABAkRjM/3A532/c2EAIwkPNZoKNegU4+jQdLGzX/WWk4BbZ+MQmKufgF+V5dLMPnJlgAZmJD5Ek4ieDjrtteUEkKiHRv/fgvhGBRpRt2qKumjSAQcVoPt/BGicXt76lXwR8eDEmB7fysubrvmtv7CmxAGGo/yJtcCK1HHnlYW17kgw79try4RVdeuVxPPfWkvF4vgeBj3y92LLBlZmQqLy+PAwAAgsBoflfytRJEGPP2ROm5zS8TRBC4W3sIIdIddfsIAVY2av4fpCnLgnZ5jvGzFLvoRYIFYDYmsZ0EJbZTY24uIppnx2FVb+cwt5r60iOq+PVbBIGI5PXwA2ar8jkC2nDwr1rzzNqQrA9d9YUbdc+CG+Qy4gkfYavjnTr5O3kPGKFRVFSkjRs3EsRJPPHEE7ruumv13MaNlNkgr9erb999t22/X1bdfDMHAQAESxNT2MLdjooAIQRJffNRQohwgfZ9k0gBVhWdcacc01cE/XIdyRf2leMAwDxMYjsJSmynVkkEiHT/XLNFPq+fICzC5/Vr+13/SxCIWAFfQH6vr54krCXU09ce/dr9umTCHIKHJXQcbCQEmK64uNiWE6UGw+Px6OFHHqbMZnNlZWW67rprtXXbVlve/yWLlzCFDQCCxdcuo+MwOYS5f7xdSwjAABmdZWNIAVYUlbhE0bkPmXb5jukrFDPrfoIGYIrR+UYRKXwcJbZTY3QfIp6/rVs7fvJXgrCI17+7Wf62boJARGt9n/0EVsH0NeDM2t6uJgSYqqqqSmvWfJ8gBogym3099dSTuummG+XxeGybwVduuIEDAQCCxKh/kxDCnLcnSi8Wvk4QwIBOaoEuw+8mB1iOI9almKVbTL+eqJx7FZ1xJ4EDCLZWIjg5Smynxug+2MKRlw+qvPAAQYS5N9cWyrODT3gi8nUcaZ9ICuGv2mgJ2fS1yxdfpl987cdMX4Ml9Xb71V7uIQiY5rv33GPrUs5QUWazj6qqKt1266164oknbJ3DypUrlZWVxQEBAMF5ki+jlfdSw11cdECLP3UhQQRJeTWvOSKZ0e1mjDwsKXbRi1JMQkiuKzpnjaISlxA6gGBiqNYpUGI7tSIigF2UPlSopoomggjXNwkKD6h6UylBwBbaa9sYXR/GfI6Atrh36u6n/9P06WsZaelae9O9umHGZzTOGEX4sKy2UlbYwDw//slPlJSURBBDdGKZraGhgVAihNfr1VNPPan8/C9qd8luW2eRlJSkm2++hYMCAILEaHpHCrApwQru+9JM5cw9lyCCoL3zKCFEsN62dxJIAVYTM+t+OZJDWFaOSVDM0i1yxvNBawBBw1CtU6DEBkD+tm7949t/kM/rJ4wwU154QLvu20IQsI3uDp8CvkAzSYSfaqNFPyj8uX77p9+Zej1JE5P0zZW36UeXfl3THBMIHpbna2jT0foOgoAp0tLS9NhjP6fINkz9ZbYrr1yuRx55WFVVVYRiYUVFRVr1ta/Zfvpav9tuu01xcXEEAQBBYjT8kxAsIi46oIdunUeRDTiDXm9ZIinASqISlygq597QX3FMgmIufoEHAECwMIntFCixncJ12wuKSAF20lXTpte/u5kgwkhTRRMFNthSu7uNtkcYOX76WkXVIVOva8Wnr9L6a76tBfHnEDwi67x20E0IMA1FtuDauHGj8vO/qG/ffbeKinhbwErKysr07bvv1ne+822VV5QTiKR5OfO0fPmVBAEAQWI0vyv5WgnCQiiyAQM4tx09RAiwlOj5vxix6+499HseAADBUkkEpzjPE8FptUoaTwywC8+Ow3pzbaE+efdlhDHCmiqatO223xEEbKmlqnnShFQ+ABgOqo0WPf7yb0wvry3MXaAvZl8hlxEvGfbLuF+Nt1Fd/r4VHY3tTXI3f1h8eqN4u6S+SXX/veK7HJwW0/FOnSbMS1VMfCxhwBT9RbZ///fb5PF4CCQItm7bqq3btiozI1Of//zndcmyZUpOTiaYMNTQ0KCH/uu/tHXbVsI4wXfuuYcQACCYmvaSgQX1F9nuelwqKX2HQIDjGD5PraSpJAGriJ37qBzjZ4X+iv0d6nnrdvXUPM2DACBYKong5CixnV6JpCXEADup3lQqSRTZRlB/gc3f1k0YsCVvY+cYUhhZPkdAf6vfbfrq0Iy0dH3x4quUPWqa5ctrbY5utfZ29R3DgW7VdjQc+7PDDTXq6OobMPi++8iwSoGeJo/cjs6+wh8speNgoxJzphAETEORzRzlFeV6+JGH9fAjD2v555br8s98Rrm5uQQTBsrKyvS3v72kjRs3EsZJ3LH6DqWlpREEAASJcbRRRsdhgrCo/iJb/r318jQ1EcggnZPmIoRIPbd1vMfPiWEZUYlL5Mz6Zuiv2N8h/9+XK9DMB6cABBXrRE+BJyenVylKbLAhimwjp7zwACtEYXteT5eMXqPL4XRQZhsBbkenHi38lenT11Z94UYtSjxXsUZU+P07eNx0tCZfuzxdfetivL6jqjxSeezP3i0/IE9T6Isi5R3vy8XKVctpe7ta489LkTMmijBgmrS0NG3Y8Izuu/de7S7ZTSBBtuXFLdry4hYlJSXpsssu04oV11ASGgHFxcV64fnnmbx2GvNy5il/5UqCAIBgauC5ldXFRQf0s7s/q2+s/TNFtkG6NHuiJD9BRKDejr0ppACriJ73UMiv02jdL9+ri2X43DwAAIJqdP5xP4jCR8/3RHBalUQAu6LIFnoU2IAPdTZ2NCa4xk4jidB6tWWvnvjfX5l6HZcvvkzXzFyqccYo06evHT8dTZIOttYc+/Xx09HaOzv0dlmpZR6nf5aXaMH5lNisprfbr/b3GjX+XN4fhrmSk5O1bv163VlQQJHNJB6PRxs3btTGjRuVmZGpS5ZdoksvvYxCm4m8Xq9effUV/e7Z36m8opxATiMpKYk1ogAQbL52GU2l5BABpif6KbINUmZ6mqYnUmCLVL3eMkKAJURn3ClH8oUhvc5IK7A54+fIGT/j4+eBzoPq7WRlOhBifDLzdOd8IjgtRvjB1iiyhc6bawuP5Q1AaqluTkhwjSWIEHE7OvXUP543tciVkZauW5f9q6Y5Jgy7vNZfTjt+SlrZ4XclDX9dpxW8UbxdXz//Wg5cC2p7u4YSG0IiLi6OIluIlFeUq7yiXE888QSFNhMUFxfrjTdeZ2XoINx2220cfwAQZEYjz6ciSTCKbEkTJ+q82RmWvP/npLmUMCZmwF+fcVacpF4OnEg8t/k8tZKmkgTCnSPWpajzCkL7/WHxApszfo6cKZcrKnmhlJglx/hZZ77P3jo5Wt5Rb8s+9dYXqce9iYMPMA9T2E6DEtvpVRIB7K6/WHXB1/MUGxdDIEHm8/r19288p7YyRhEDx2uraU3UJ8ghFMyevpY0MUlf+vQXtWCQ6y+rjRZ5A92q7WhQY3uT3M1uWxTUBmp/T71mRVOGspqeti61l3s0NjOJMGC6/iLb+nXrtOVFpv2GwomFttyLcrVw4SLl5uYSziD0F9cKCwvl8XgIZBCWf265li+/kiAAIJh6u5nCFoEGU2TLv+pS3f5ZO7+Go8AWqYyO9/gZMSwhZtb35IibErrvDYsW2ByxLkWnf13O9C8OqLT2sb8fN0WKmyLnlGVyZn1T0f4OqWGHemr/op6KdRyIQHAxTOs0eIJyGtdtLyh5fsF6goDtVW8qVev+ei39WT5FtiCqLz2i7Xf9r/xt3YQBnMDr6ZLRa3Q5nI4xpGGOUExfW/Hpq3T12QsVa0Sd8jZ09/p1sLXmWFHt3fID8jTxA+szOdhUrVkuSmxW1FZaS4kNIRMXF6f/uPdeJYxNYJJViPUX2vpzX7J4iS5efLHmzj2fKVknPu/zerVv3z6Ka8OUmZGpgjvvJAgACDLDXSIFeO8uEvUX2a7/zm9O+3XPbX5Zkt2LbIhEvR17eWMJYc8R65Jzxk2h+3ffggU2Z/wcxcy5X47pK4J7wTEJ0pRlip6yTNE5a2TUFsq/9z5WjwLBUUkEp0aJ7cyqJPEOM2yvrcytP6/4pRY89AWlzJ1MIMPg8/pVumGHKn79FmEAp9HZ2NGY4Bo7jSSCb39PvdY8s9a0y1+Yu0BfzL5CLiNeMvqmqvWv/iw7/K7aOztMLc/Zwfa339TySy8kCCs+D2ho09H6Do1OSSAMhMzq1Xdo7NixeuKJJwhjhGzdtlVbt22VJCUlJWnBJxcoZ16OMjIylZWVZbs8ysrKVPr229q1a9exXDB0SUlJ+vFPfqK4uDjCAIAgM5r5QW0km57o14/uzNf31j132q+jyIZI1OstIwSEvdg5a/vKVKH4N99iBTZHrEux8x5X0MtrJxOTIMf0FYqdvkKqe0X+vf+pQDOv5YFhqCSCU6PENrADiBIbIMnf1q1tNz+r2f9+seZ+mZU4Q1FfekTF929RV00bYQBn0FLdnJDgGksQJoiLGmXq5U+fPF2/3/MXpqqZqKLqkNoc3RpnjCIMC2redVhnXZFFEAipr371a8rMPEff+c63CWOEeTwebXlxy0fWvC5ZvEQzZ81UZuY5Sk9Pj6hpbQ0NDaqsrNTbb+/Rgf0HKK2Z4FvfupsJfwBgAqP5XcnXShARbulMUWSD/c5vPk+tpKkkgXDmjJ8jx4yvhOZ7wmIFtphZ9yvqvDtCVvD7iCnLFDNlmaIrN8m3+1bLrV0FwgTrRE+DEtvADqAlxAB86N3HXlPDP6t00XevUIIrnkAGwOf1a9d/F6l6E5OHgIFqq2lN1CfIwQzTHBOUNDHJtILZb//0O0IOgUNH3coexbBCKzpa06Tu5i6NSmRjMkIrLy9PTz/9K33rW3exsjHMHD+prd+SxUt01pSzdNbkszT3/PMVHx8f1kUlr9eryspKVVSUq76+Xgf2H9DefXs51ky2cuVK5eXlEQQAmMA48gYh2ARFNtju/NbxHj8fRtiLzlgVmivyd6hnxy2WKGM54+coZv6v5Ege+Q0djukrNGrqZQrse1j+/fdxwAID1zo632ghhtOc/4ngjDiAgJPw7Disl7+8QbNvXazZK+YSyGmU/rpY5b95S/62bsIABsHr6ZLRa3Q5nA5aHia4cM4FemlbIUFY2O7D+5Q9gxKbVbXte1/JizIIAiGXlZWlxx77ub57zz0qrygnkDB2qollmRmZSk1NPVZwS5k8WS6XS5I0ffp001ZKlpX1rRvq7OxURXnfsbNr167T3laYa8niJVq9+g6CAAATMIXNfgZbZFv1aZfiogMEB0vq7dibQgoIZ45Yl5wzbgrJdfn/vtwSqzGjU29S9EWPjsz0tVOJSVBUzr2Kcn1K3TuuZyobMDBMYTvT+Y4IzqhI0veJATjJE7u2bpWuLVTVlj3KWX2pUuZOJpTjlBce0Du/3MbqUGAYWutaGiekJtLSMcGsKefoJVFis7Kde3fphhmfIQiL6ninThPmpSomPpYwEHJpaWl64skndWdBgXaX7CYQq73OqCgfcAFxyeKhD5anmBbe5uXM0/fXrCEIADBLw04ysKGlM6V7/t+1+sn/vHDar3tu88vaX3GuHrp1HkU2WFKvt4wQENZiZn0vJGWtQMl/WqLANuqCDSFbrTokU5Yp9vLd6nn9ekvkCYywSiI4PUpsHETAsLWVubXt5mc1+dIZmveNS2y/YpTyGhA8LVXNkyakJhKECc5LoBtodZ4mj9yOTrkMVntb9hy3u4ZpbBgxcXFx+vnjj+uRRx7Wxo0bCSRCUUSLTElJSfrOPfeYNnUPAOzO6KyV0cUkEbu68vwoVVx16QcT106tpPQd3fW4KLLBeuc4n6dW0lSSQDhzTL/W/CupeyXs12A6Yl2Knfe4HNNXhP9jFjdFMUu3yPH6v6nHvYmDGDi1SiI4PScRnN512ws4iIABOvLyQf3lql/ozbWF6nB32uq++7x+lf66WFuue1K77ttCgQ0IkvbaNlaJmmScMUoZaekEYXF7mw8RgoV1vFMnf6ePIDCiVq++Qw888CBBABaRlJSkxx77udLS0ggDAMxyZDsZ2Nztn01S/lWXnvHr+opsu+XtiSI0WEZvyx4+CYGwFp16kxxxU0y9DsNbp+4d14d1Do5Yl2Iv2SYrFNiOiUlQ9NI/KDrjTg5k4DRPIYng9CixDcweIgAGrnpT6bEyW33pkYi+r/WlR/Tm2kJtXvYzvfvYa5TXgCDr7vAp4As0k4Q5Fpz/SUKwuB3vsOLG6lp21xACRlxeXp6ee+73SkpKIgwgzP3Xfz1EgQ0ATGR01sroOEwQoMiGiNXrLWPtBcJadLr55bLAjq/L8IXv1NVjBbbxs6z5GOY+pOjUmziYgZOrJILTo8TGgQSYpnpTqbbd/Kxe+upvVF54QD6vPyLuV1NFk/752Ovact2T2nbzs6reVMqDDZio3d3WQQrmmDGRlaJW93ZZqXwO1pZYGdPYEC7S0tL0/PMvaF7OPMIAwtQDDzyorKwsggAAMzGFDcehyIaIYwS6jKNM9Uf4csbPkaYsM/fb4OAzYb3u0uoFtn7RFz2qqMQlHNTACUbnG0xiO9O/BUQwIBxIwDC0lbm1674t2rzsZ3pzbaGqt1dZ7j7Ulx45Vlx75UsbVPHrt5i6BoRIS1XzJFIwR3oM0VrZ+VlztTB3gVp0lDCsfp5jGhvCRFxcnH7++ONatWoVYQBh5oEHHlReXh5BAICJmMKGk6HIhog6z3W7G0kB4Swq9YvmXoG/Q769d4ft/Y+UApskKSZBMUu3yBHr4sAGPlRFBGcWTQQDUkkEQHBUbypV9aZSvSlp8qUzlHzBdKUuzFCCKz6sbmdTRZPce2rVsKtSnrcOy9/WzYMHjJDmQ81jpi8kBzPEGlFamLtAbxTzSfORlJGWrrNck4/9Puvs2cd+nTRmvCbGjpUkjXLGyGWc5N9LgwytzlvRoN75aXLG8MMOhIevfvVrOv/8bK1Z8315PB4CAUYYBTYACBGmsOEUVn3apf0V56qk9J3Tfl1fkU166NZ5iotmajrCT6BlJ59oRVhzpptbYuspWRPWa0QjpsDWLyZBsYteVPeruRzcQJ9KIjgzSmwcTMCIOfLyQR15+aBKJY1JHafxs1OUfMF0JZ6TrMTMJMXGxYTkdtSXHlHHkTa1HHSr9cAReXbwiUsgnAR8Afm9vvqYuNgU0gi+rLNnU2ILkqSJSZqdOfPY76dPnq642NGSpDExo5Ua9+H7hNMcEwZ/BZTVIlZvt1+t++qVmDOFMBA2cnNztWHDM7rv3nu1u2Q3gQAjhAIbAIQGU9hwOnHRAT106zzd9bgossHi57qyMaSAcOWMn2Nqgcvw1qmnYl3Y3v9R8/8QWQW2DziSL1TMrPvl338fBzkgFRHBmVFiG4DrthcUPb9gPUEAJuqqaVNXTZuOvHzw2P8bkzpOcVMnaPzMyYodO0oTznEpNmGUJA245NZU0SR/p0+S1Pxeg/wdR9X5fou8da3y1rawEhSwiJbalqjkGYydNsOcxHRCOImFuQuO/dqV6NKksRP7/m06oYyW4hyrWIPpWRi+trerNf68FKaxIawkJyfr548/ruc2btTDjzxMIECIUWADgBBiChvOgCIbrM7o7W42/O5EkkC4cqZcburlB/aF78/6Y+c+Ksf0FRH72Eadd4cCNb9Xb+deDnTYXSURnBkltoFrlTSeGIDQ6S+2MRkNQNN7nkmU2MzhMuKVNDFJnqbIXBd3ftZcjY1PkCQljEnQ2cmpx/5sxvgPfz3eOUbjjFGDvwKmoyFIerv98uyoUvKiDMJA2MlfuVJzzz9fP/rhD1VeUU4gQAhQYAOA0GEKGwaKIhssrau2QxIlNoSt6KlXmPdvfRhPYYtOvUnOrG9G9oMbk6CY+b9irShAiW1g50UiGLASSUuIAQCA0Gt/v50QTLT4wkXa9LfNYX0bM9LSdZZr8rHfZ509+9ivpyYkKy6qr4A2yhkjlxE/+CugjIYw0PFOnSbMS1VMfCxhIOxkZWXpiSef1Pp167TlxS0EApgkKSlJa9b8QLm5vLkPACHDFDYMAkU2WFWg+a1ppICwljzfvOM/TKewRSUuUfRFj9ri4XUkX6ho1wr1uDdxrMPOSojgzCixDe6AosQGAMAI6XC3Vye4xvJmiwlmuUK3UjRpYpJmZ8489vvjy2hJY8ZrYuzYY7+f5pgw+CugjAaLa9ldwzQ2hK24uDj9x7336vLPfEZr1nxfHo+HUIBgPk9KStJjj/1caWlphAEAIcIUNgzpeXF0QD+48QLd9MN6eZqaTvu1FNkQLnq7yggBYSsqcYkUk2DOhfs7FKj5ddjdZ0esS9Hzf2He/Q7Hx3nOd9XzKiU22Fbr6HyjhRjOjBLbwFUSAQAAI6elujkhwTWWIEyQPnpoq1oX5i449uvpk6crLna0JGlMzGilxk069mcpzrGKNaIIGhgAprHBCnJzc/X88y8wlQ0Ionk58/Sde+6hwAYAocYUNgxRcnyPfnb3Z/WNtX+myIawZ/g8tQp0TiUJhCuna5l5x39toQyfO+zuc+y8x+UYP8tWjzPT2GBzTGEbIEpsHFQAAFhCW01roj5BDmYYZ4zSik9fJXezW65ElyaNnXjsz2aMTz326/HOMRpnjBrCOwVkDAwG09hgBUxlA4JnXs48rVu/XnFxcYQBACHEFDYM1/REP0U2WON81/EePw9GWItyfcq0y+45EH7rOqMz7pRj+gpbPtbRs/4fJTbYFX2jAXISAQcVAABW4PV0KeALNJOEOb44bbG+fv61+uK0xbpkwpxj/01zTDj235AKbAAGreOdOvk7fQQBS+ifyrb8c8sJAxiClStX6uePP06BDQBGQu3fyQDD1l9kS5o48Yxf21dk2y1vD9PqEVqBtuIUUkA4Myaca87leusUaN4aVvc1KnGJonPW2PfBnrJMtEkZVQAAIABJREFUzvg5HPSwo0oiGBhKbAN03faCFkmtJAEAwMhpd7d1kAIAO2jZXUMIsIz+qWxPP/0rZWZkEggwQA888KBWr76DIABgBBjN78rochMEgmKwRbaCx3apsjmG4BCiE16gyzh6iBwQ1hxxU8y54NrCsLuv0fN/IcUk2Prxjs5YxUEPO2Jo1gBRYuPAAgDAMhr3N0wjBQB20PFOnY7W09uFtWRlZemJJ5/UHZRygNNKSkrSc8/9Xnl5eYQBACPEOPIGISCopif6de9tlw/oa9/e966+sfbPFNkQmvOdt6qRFBDOol3mrdUMuLeF1X2NnfuoHONn2f4xd0y/lgMfdkTXaIAosXFgAQBgGe3vtxMCANto3nWYEGA5cXFxyl+5Us8993stWbyEQIATLFm8RM8//4LS0tIIAwBGiNH8ruRj6QqC76Kze/WjO/MH9LWepiZd/53f6E9vBwgOpgq075tECghnjsR55h3/7i1hcz+jEpfImfVNHnD1Td6LSuQ9I9hK6+h8o4UYBoYS2+BUEgEAACMn4Auoq6WrliQA2MHRmiamscGy0tLS9ODatXrggQdZMQp84I7Vd+jBtWsVFxdHGAAwUnq7mcIGUy2dqQEX2STpJ//zgn70Qq28PVGEB3NOe+3FY0gB4cwRO96UyzVa98vwhc/q8Oj5v+DBPo7TtYwQYCcMyxrM+YEIOLgARL6YcaM0bcVcfXL9F3TF5lsIBJbmKW/gp34AbINpbLC6vLw8VozC9jIzMvX0079S/sqVhAEAI8xwlzCFDaYbbJHtxcLXlX/vX5nKhuCf83raGxXoJAiENUfyp8y5YPebYXMfWSP6cVGuTxEC7ISe0SBEEwEHF4DIFDNulCYvm6mpF8/UtAUfXVUzLsultjI3IcGS2mpaE/UJcgBgD0drmtRe7tHYzCTCgGX1rxi9ZNky/eLxx7XlxS2EAttYuXKlbr75FqavAUA46O2W0biTHBAS/UW27617bkBf72lq0k/+5wX9cuJEXXrxBVowJ1lzpjgUF02xDUNntJVxAMG+/+x3hscHQ6NdK8JijajhrZPcO2R4q4/9P0fcNMk1X464KaG/QcnzOUhhJ5VEMIjzJhEM3HXbC1qeX7C+VdJ40gAQriZfOkNTFs9S5mUzT/k1acuzVVpWSFiwJK+nSwFfoDkqNiqRNADYQcvOSkpsiAjJycn6j3vv1TVf+IKe2bBBW7dtJRRErKSkJK1Z8wPl5uYSBgCECePIDinQTRAImaUzpW/edJV++vTmAf8dT1OTntv8sp774K9kpqdp6lnJypk9VfFjYpSRMkrxsQ5NT/QTMM4o0FacQgoId47kC835d79598jft1iXoub/98g+/2nYqcDeH6vHvemUXxOVuETRM2+XY/qK0N2wmARFJS5RoJn3hmALDMsaBEpsQzvAlhADgHDSX1ybtjBdsXExZ/z61IUZKiU2WFhzdZN3UmYyJTYAttDT1qXmkjol5kwhDESErKwsPbh2rYqLi/XIww+rvKKcUBBRmL4GAGHI1y6jgSlsGIHnBfNHq95zqZ7b/PKQ/n75oSqVH6rStn+c/PjNmXuuxo2NV87sqUpJHK05U6OVHN9D8JCMQJdx9NAYgoBtvwX8TSN+G2LnrB2ZKWeS5O9Qz1u3q6fm6TN+aaB5qwI7tirqwBJFz/9FyFafOuIzJUpssAdKbINAiW1oBxglNgAjbrDFteMluOJZKQpLa6lsnjopM5kgANhG29vVGn9eipwxUYSBiJGbm6vfPvusioqK9MQvf0mZDZaXmZGp7/3HfygrK4swACDMGHVFhIARc/tnkyQNvch2OiWl70jSR0puOXPP1XWfPl9LZ5K9rc973qpGSdNIAnY10hO+ol0r5JjxlZH5/m/dL9+ri2X43IPOLPDX2Ro1/w8KxVQ2Z2K2VMOxiojXOjrfaCGGQZw/iWDQKokAwEgZl+XSOSsvGlJx7USsFIWVtVTxfA+AvfR2+9W8u1ZJF51NGIg4eXl5ysvLo8wGS7tj9R268vOfZ/oaAIQho7NWRutBgsCIMrPIdqKS0ndUUvqOcuaeq7u/9AlWj9pUoPktCmwIe1GJkTk3ZkTXiNa9It+O6wddYDte945rNErmF9mcE87jmwB2wBS2QaLExkEGIMyNy3IpbXm2UhdmKMEVH7TLZaUorK7D3V6d4BrLmzEAbKNtz2GNO2+yYuJjCQMRiTIbrGjJ4iW661vfUnIyU4IBIGwd2U4GCAuhLLJJfWW2b6yt18/u/ixFNhvq7SojBIQ9R8zEiLxfo+Y/K43EGtG6V3T0tUuDclG+3bcqNjHL1NWiRsx4vglgB/SLBslJBBxkAMLPuCyX5t59ma7YfIsuf+pfNXvF3KAW2KS+laJJ85nmAutqPNgwiRQA2E3Tm5WEgIiXl5en3z77rB544EFlZmQSCMJSZkamnn76V3pw7VoKbAAQxozmd2V0HCYIhI3bP5uk/KsuDdn1eZqa9I21f1ZDJzMtbHXuO/p+tQKdBAGMgOjUm6Qpy0L/fd+6X907rg/e5fncCuy6x9wbHT+FAwZ2UEkEg0OJbZCu217QIqmKJAAE25jUcZr97xebWlw7Udrnzid4WFZ7bdsYUgBgN94Kt47WdxAEbOH4Mtu8nHkEgrCQmZGpBx54UL999lllZWURCACEs95uGUfeIAeEnZEosj27tZ7g7XT6a3sngRRgdyOxqtQZP0fRFz0a8us1vHXyvbp4WCtET6bHvUlGw07TbrcjjhIbbIEhWYPERy+GplJSGjEAGK4xqeN01tLZSv9MliZmhH5s8rSF6drFwwCL6u7wydfpa4yNj2UiGwBb8Wyv0NSrKaLDPvrXjJaVlemZDRu0ddtWQkHIJSUl6d++/G+68vOfV1xcHIEAgAUY7hLJ10oQCEuhXi368mu7dPtnLyN4m+htL04kBdjdSKwqjbn4BSkmxB1Sf4d6Xr8+6AW2foHKjYpOvpADChii0flGESkMDiW2oSmStIQYAAzFSBfXjhcbF6PJl87QkZcP8sDAkpoqPYHJ551FEABsxdfQpvZyj8ZmJhEGbCUrK0sPrl2rhoYG/fa3v1FhYaE8Hg/BwFSU1wDAqk+a22U07iQHhLVQFtk8TU2qbI7R9EQ/wUc4I9BRb/jdKSQBu3Om5EnuTSG7vlEXbJBj/KyQ38+ekjUKNJv3Yb9Aza8VnfsQBxQwNGx4HAJKbENTSQQABiNm3ChNuyo7LIprJ5qyeBYlNlhW03uNKZTYANjy/PfGe4o/e4KcMVGEAdtJTk7W6tV36Oabb9Grr76i3z37O5VXlBMMgoryGgBYm1H/phToJgiEvds/m6Tzz8nX99Y9Z/p1dfoMArfD+a/9Pd4oACQ5J5wXsuuKzrhTjhlfCf33e+Um9VSsM/c6fG4ZDTvlYBobMBSVRDCEcyoRDAl7awGcUcy4UZq8bKamXjxT0xaE7wZiVorCyryeLgV8geao2ChG5AOwld5uv5p31yrporMJA7YVFxen5cuv1PLlV6q4uFgv/fWv2vLiFoLBsGRmZOpfrv8XXXLJMsprAGBRRmetjKZSgoBlLJ0p/ejO0BTZEPkCLa9PIgVYRW+niQMWpiyTI9Zl2prNflGJSxSdsyb0z3da98u3+9bQXFnLPokSGzAURUQweJTYhuC67QUlzy9YTxAAPsYqxbXjsVIUVtdc3eSdlJlMiQ2A7bTtOayEGckalTiGMGB7ubm5ys3N1S233qpXX3lF//d//8d0NgzKksVLdMVnP6u8vDzCAACrq/07GcBy+ots657+m5qam025jvhYB0FHOKO3u9k4eoj3SWEZvZ17Tb386PSvy7//PtMu3xHrUvSiZ6WYhJBn17PjFtMLesfOLf5W8S8IMCQMxxrKuZsIhmyPpGxiACBJ01bMtVRx7USsFIWVtVQ2T52UmUwQAGyp6c1DOuuKLIIAPpCcnKz8lSuVv3KlysrK9Le/vaTCwkJ5PB7CwUmtXLlSn/705crK4lwKAJHAaCyR0eUmCFjS0plS+rc/p2+s/bM8TU1Bv/zpiX5CjnRdtR2SKLEBH3DO/Koch/7blLKXI9al2Eu2yRE3JeT3q7fspwo0b+UBBsJfJREMHiW24R1wlNgAG5t86QxNWTxL0xamKzYuxtL3hZWisLKWqhYZvUaXw+lgFBEA2zla06TO6hbFT5tAGMAJsrKylJWVpZtvvkVvvfWWXn/tNdaNQhIrQwEgYvV2yzjyBjnA0qYn+vX0f1yh7/9ql0pK3wna5X7uskWEawOB5remkQKsxmjdL8f4WaZctiNuimJmfU++0tuDe7n9BTaTbveZ8gr2/QFgjtH5BpPYhoAS29CVSLqKGAB7iaTi2vFYKQqra61raZyQmsibNABsqekf5RpzTY6cMVGEAZxEXFyc8vLylJeXp4I776TQZlNJSUm67LLLmLoGABHMqN0mBboJApaXHN+jh26dp4f/mKQXC18PymV+6vypBBvxJ8FAV29HMR/yhfX42k29eGfWNxXdvEc9NU8H5fJGssAm9a0RjRj+Do5/RDLGJQ4RJbahK5L0fWIAIl+kFtdONP2z51Nig2U17m+YNiGVSfkA7KmnrUut++qVmDOFMIAzoNBmP8s/t1yLLr5YF110EVPXACCCGZ21MppKCQKR87w1OqDvXTtVmdOu0k+f3jysy0qaOFHzM6IkBQg2ks+D3qpGSXzIF9bTsk9KvtDUq4i+6FEZneXDXsHpjJ+jmItfGLECW6StETVa3uX4RySrJIIhnrOJgIMOwMeNy3IpbXm2UhdmKMEVb4v7PG1Bmv45bpT8bXxiFRZ8nVvVQggA7H0eLK5QXFqiRiXyoWtgoE5WaCsp2a3CwkJ5PB4CsjCKawBgQ7V/JwNEpJXzR2vu9C/px09t06Gq6iFdxpeuvlhx0RTYIh2rRGFVvZ2HZfpugZgExSzdIkfJGvVUrBvSRUSn3qToix6VYhJGJKeRXCPqiBnPgQoMHqtEh3rOMQyDFIbo+QXrWyRx1gYihB2Layd6c22hqjfxqVVY0+zl51YnuMbyZg0A2xqdOlFnXcGKPCAYysrKtH37P7SzeKd2l+wmkDCXlJSkBZ9cQHENYaehoUGvvvJKxNyflMmTlZeXxwOLsGM0lsiofZUgENG8PVF64m9uPbf55UH9vZy55+qhW+dRYrMB38H7pEAnQcByol0rFL30D6F73tCwU/4dN6q3c++Avt4ZP0cxc+6XY/qKEc2p5+/XqMe9aUSue9QlxXKYMC3POPiMunfdwDcBItXS0flGETEMHiW2YXh+wfoiSUtIArAuimsfVb29Sm8W/C8HBixp0qxJXdMXZjCCCIC9z4WXnKuxmUkEAQSR1+s9NqWt+K1ilVeUE0oYmJczTxfmXqgFCz6lrCwKvABgW73d6i17UgqwWQD2sK8+Wr/+635t+8fOM35teto0PXL7YiXH9xBchDOOvl/tr3yID/fCskbnj0Bfoe4V9dT+RYGaX8vwuT/2x1GJSxQ983aNdHlNGvmy1+hr2k2ZQNdb9tMRmy4HhEDi6HyDNVJDQIltGJ5fsH6NpO+TBGAtY1LH6ayls5X+mSxNzJhIICf44+X/w0pRWFJUbJTm/esnCAKArTlHxWjav1woZ0wUYQAmaWho0L59+1RSslv7393PpLYQyczIVO5FucrJmafzzjtPycnJhAIAkFH5JxmtBwkCtvPWYacK36rWi4Wvn/TP86+6VKs+7WICm030HPlTV29LER/uhWWZNelrwM8nWvdLvvZjv3dMmD1ia0M/dtu8dfK9NO+kRbtQcMbPUexyczY49bzxVfXUPM03ACJR1eh8YzoxDE00EQxLJREA1kBxbeAmL5vJSlFYUsAXUIe7nZWiAGytt9svz44qJS/KIAzAJMnJycrLyzu2Us/r9Wrfvn2qKC/Xrl27tHffXnk8HoIapv5Ja5mZ51BaAwCclNFZS4ENtnXR2b266Oyp+t61+dpXHy13a4/qm49q7vQEpScZH5TXKLDZ5r2A9mIKbLD2v+kN/xjREptj/KywzSaw4+sjVmCTJGfK5SY+l2PSPSJWCREMHSU2Dj4gYlFcG5qpF1Nig3U1HmyYlOAaSxAAbK3jnTqNneHS6JQEwgBCIC4uTrm5ucrNzVX+ypWS+qa1VVZWUmwboHk58zRr9iydc845ysjIZD0oAODMertlHP4rOQCSzkvp0XkpkjRaEqtD7cY4+n61Ap18qBeWFqj5g5xZ3ySIE7+/Dz6jHvemEb0NUckLzXvcm7fyICNS0SMaBtaJDtPzC9YTIBBGYsaN0uRlM5V+xVylzJ1MIEPESlFYFStFAaBP9LgxmpbP+RAIJ16vt6/YVlGu+vp6Hdh/QDU1NSqvsM8njzMzMpWamqoLLrhAKZMny+VyUVgDAAyJcWSHjPo3CAKA7bFKFJFi1JW1csRNIYj+5zojvEa03+hr2k1ZrWo07FT3q7k80IhUK0bnG38khqFhEtvwbZW0hBiAkdNfXJt68UxNW5BGIEHASlFYFStFAaBPT1uXmkvqlJjDm39AuIiLi1NWVtZJS1tVVVXq7OxU6dtvS5J27dolSZac4LZkcd9bJBdccIEkae755ys+Pl5pabxWAwAEh3G0kQIbAHyAVaKIGLWF0oyvkMMHRnqNqCRFp95kSoFNktSyjwcZkYxJbMM59xDBsFWKEhswIsZluXTOyos0bWG6YuNiCCSIZl77CUpssCxWigJAn5biCsWlJWpUIu9nA+Guv+DVX3DrX0var6GhQQ0NDZIkt9ut+iNHJEkdnR06sP/AR742mMW3/kJav7OmnKWzJp8lSYpPiFdGRqYkKTk5WcnJyTyQAIDQYI0oAEhilSgii3//Q4qlxNb3vR0Ga0QlKWrqctMuO9DCzyARsVpH5xuVxDB0lNiGr0QS/6ICIdI/dW3mtZ/QxIyJBGKS2IRRhADLaj7UPGb6QnIAAElqevOQzrqCVX2A1R1fEmP9JgDAzozGEhldboIAAEmBlp2TSAGRordzr4yGnXIkX2jv5zqt++Xbe/eI3w5HrEuOqZeZ93jXv8RBj0jFFLZhosTGQQhYQsy4Ucr814s06ws5TF0zSYe7UzVvVKhqyx61lfFmIKyLlaIA8KGjNU1qfade489NIQwAAABYm69dxhHWiAJAP1aJItIEDvxc0clP2TqDnh23jPgaUUmKmfU901aJGt469Xbu5YBHpKI/NEyU2Ibpuu0FRc8vWE8QgEnGpI7TuTcvVuZlMwnDBBTXEKlYKQoAH2oprlTc2YmKiY8lDAAAAFiWUf2SFOgmCAAQq0QRmXpqnlaU9z/liJtiy/sfKPlPBZq3jvjtcMS65Jxxk3lXUFvIwY5IRoltmCixBcceSdnEAARPzLhRmnvXZZTXTODz+lXx0rsU1xDRWCkKAB/q7farcdt7rBUFAACAZRmNJTI6DhMEAHyAVaKI2GN7972KXmjDaWx1r8i//76wuClmTmGTpIB7Gwc6IhkltmGixBa8A5ESGxCMJ0asDTWFz+tX9RuHVLdtv468fJBAEPkvdFkpCgAfwVpRAAAAWBZrRAHgY1glikjVU/O0ohpukyP5QtvcZ8NbJ9+O68Pitpg+hc3foZ6apznQEbFG5xuU2IaJEltwlEj6CjEAwzP50hma941LlOCKJ4wgoLgGu2OlKAB8FGtFAQAAYEWsEQWAE86LrBJFhOvZfZdiPl1kjzvr71DP69fL8IXH5qTYeY+bOoXNYJUoIttWIhg+SmzBQZsSGIYxqeOUe99ypcydTBhBUF54gOIaIFaKAsCJWCsKAAAAq2GNKAB8HKtEEfHHePNWRZX9VM6sb0b8fe0pWaNAc3j0XqJdK+SYvsLcx7Z2Cwc4Ihm9oWCci4hg+K7bXlD0/IL1BAEMQcaXL9LcG+azOnSYqrdXqfa1AzryygH52/hkKiCxUhQAToa1ogAAALAM1ogCwEmxShS2eBpQertGTb1cjvGzIvd7ueyn6qlYFxa3xRHrUtT8/zb3SlglishHiS0IKLEFT5WkNGIABiZm3Ch9Ys1yTVvAt81QUVwDzoyVogDwcawVBQAAgBWwRhQATnJuZJUobKRnxy2KWbrF1PWWI/a9XLlJvtLbw+b2xM57XI64KSbf5//loEako8QWBJTYgntA0sYBBmBclksLf7JCCa54whgkimvA4LBSFAA+jrWiAAAACHesEQWAk2OVKGx1vDdvleOt2xW98KnIep7TsFPdO64Jm9sTnXGnzF4jKkn+/Q9xUCOijc43KLEF45xEBEFTIukqYgBOb9qKubrg63msDx2EpoomHfprmd7/+7vqqmkjEGAwL3J9AbXUNFdPSE3k04kAcBzWigIAACBssUYUAE7OCHSxShR201PztFScqOjcyChAGa375Xv9c2Fze6ISl4Qm27pX1Nu5lwMakWwrEQQHJbbgKZL0fWIATm3airn65N2XEcQAUFwDgqdxf8O0CamJBAEAJ2gprtToyeM0KpH3vwEAABA+jMrNrBEFgJOdH71VjawShR31VKxT1IS5csz4irW/h1v3y/fqYhk+d1jcnqjEJX3rWkPxGO7/Hw5kRDqmsAUJJbYguW57QdHzC9YTBHAKF9y/XJmXzSSI06C4BpijpapFRq/R5XA6aGkAwHF6u/1q3HpQU68+nzAAAAAQFowjO2R0uQkCAE4i0PwWBTbYVveuGxTrb5Uz65vWfI4TZgU2R6xL0fN/IcUkmH/fG3aqx72JgxiRjhJbkFBiC649krKJAfgoCmyn1uHuVM0bFaraskdtZbxBB5ilta6lkZWiAPBxvoY2NZfUKTFnCmEAAABgRBlHG2XUs0YUAE5+kgx09XawShT25iu9XdGdhy23WtSo3CTf7lvDqsAWe8k2OcbPCsn1Bfb+mIMXdkCJLUgosQX/wKTEBhwn48sXUWA7AcU1IPTqS4+wUhQATqGluEJjzhqn0SkJhAEAAICR0dstHf4rOQDAqU6TnRVtkiixwfZ6KtZJHRWKXvT/hWSK2HAZB59R964bwub2hLrAxhQ22MXofIMSW5BQYguuEklfIQagz7QVc/WJf19EEKK4Boy09vfbFfAFmqNio2iyAcBJNBTt19RrcuSMiSIMAAAAhBxrRAHg9AKNL6WQAtCnx71JgS2Zil30ohzJF4bnjfR3qKdkTV/pLkyEusAmMYUNtrGVCIKHEltw0a4EPjAuy6ULvp5n6wx8Xr+q3zikum37deTlgxwUwAhrqvIEkme4CAIATqKnrUueHVVKXpRBGAAAAAgpo+2QjIadBAEApzpP9nY3G0cP8eFc4PjvC59b3a/mKmbW/Yo6746wmspmNOyUf8eN6u3cGza3aSQKbEblJqawwS7oCQXzfGUYBikE0fML1hMobC9m3Chd+usblOCKt919p7gGhK+4pDHKumouQQDAabg+M0fx0yYQBAAAAEKjt1u9ZU9KgW6yAIBTnSo921t7Gl4YTxLAyTliXYqd97gc01eM7A3xdyiw72H5998XVvlEJS5R9PxfhLTAJn+HfC8tCKsiH2CiG0fnGxuIITiYxBZ8eyRlEwPsbPati21VYKO4BliD19MlX6evMTY+dhJpAMDJNf59v2K/ME8x8bGEAQAAANMZh/5EgQ0AziDQso0CG3C65xM+t7p3XCPn3jmKmXO/RqLMZlRukm/3rTJ84bUePSpxiWKWbgn5pLrAvocpsMFOioggeCixBV+JKLHBxpLmn63ZK+wx6ah6e5VqXzug6k2lPPCARbjfPRKV+omzCQIATqG32y934buaevX5hAEAAABTGY0lMjoOEwQAnO5c2dPeaPjdfCgXGIDezr3q3nGNHLtdik7/upwzvypH3BTzrtDfIaO2UP6994VtYcuReGHIC2xG6/6wm0YHmKh1dL5RSQzBQ4kt+IokfYUYYFc537wkou9ff3HtyCsH5G/jU6KA1TSXNyVSYgOA0/M1tKl1X339+PNSUkgDAAAApvB3NBq1r1LKAIAzCDQWxZMCMDiGz91Xotp/X98qzfQbJdcng7dOs+4V9dT+RYGaX4fd5LUT9VSsU9SEuXLMCFF9wd+hnh23cBDCTkqIILgosXGQAkEzbcVcTcyYGHH3i+IaEDm6O3zqcLdXJ7jGTiMNADilZ8afl3KD+j6gs4Q4AAAAEGStiknIlZQjaYMk1uQBwCn0thePIQVg6ALNWxVo3ipJcsS6FDVhoZwpeXJOOE9GfOoZi22Gt07qrJPR8A/1Nu9RwL0l7ItrJ+redYNGx6dKU5aZn/e+h4/lDdhEEREEl8MwDFIIsucXrCdU2NIVm29RgisyPhTUVNGkQ38tU/XmPRTXgAgzadakrukLM3jzBwA+rlXS6vRVizZ88PsJkirFDxUBAAAQXCsk/VGSeves7y+yZRMLAHyUcfT9an/lQ3wYFwiB/oKbJBn+pogrYjliXYq9ZFvwptGdTN0rOvrapRxMsN1rm9H5xh+JIXiYxGaOrWJiAWxm2oq5li+w9RfX3v/7u+qqaeNBBSJU4/7GMWkL0rscTgdFNgD4UJWkq9NXLTp+snSLpKsl/Z14AAAAECTP6IMCmyQ5swtKevesz1Nfke0q4gGADwUat1JgA0LE8LnV494U0ffP/9q1ir18uxSTEPzL99bJt+N6DiTYURERBBclNnOUiBIbbCb9irmWvN0U1wB7aq1raZyQmsibQADQZ6v6Cmwtp3gR/gNJ3ycmAAAADNMeSatP/J/O7IIWSVf37lm/huedAPABI9DV28EqUQDB09u5Vz2v/5uil/4h6Jfd8/r1lluzCgRB1eh8o4UYgosSmzmKJN1ODLCLManjlDJ3smVur8/rV8VL76pqyx61lfGECrCjun/WTJuQmkgQACA9mr5q0eozfM0aSXnigzoAAAAYulZJN6hv2u9JObML1vTuWV+ivqlsrLQHYGsaP4nNAAAgAElEQVS9raWdkiixAQiqHvcmqfguRec+FLzLLL4r4tavAgNUQgTBR4mNgxUYtrOWzrbE7WyqaNKBF/6p6k2lPGiAzXk9Xerp7mmNHhXNm+IA7KpV0ur0VYs2DPDrr5ZUKX6YCAAAgKFZrQG8b+7MLvjjcetFs4kNgF0FWl6fRAoAzNBTsU5RyQvlmL5i2JdlHHxGPRXrCBV2VUQEweckguC7bntBpfp+KATYgmteeG/kqy89oldXv6BXvrSBAhuAY47sreslBQA2VSUpbxAFNqlvYsbVRAcAAIAheFR9pbQBcWYXlKhvEvBmogNgR0ZPe6Nx9BBBADBN945rZDTsHN65qnKTunfdQJiwM4ZbmYASm3mKiAB2kZI9JSxvV395bdvNz8qz4zAPFICPaC5vYp8oADvaKiknfdWiobzALpL0AyIEAADAIOxR3xS2QXFmF7Q4swuu5vknADvqbSqOIgUAZvO9/jkZrfuH9pfrXlH3jmsIEbY2Ot8oIoXgo8RmHlqXsIVxWS7FxsWE1W3qcHfqtXv/RHkNwGl1d/jU4W6vJgkANvJo+qpFeemrFrUM4zLWiIkYAAAAGJhWDXOarzO7YI2kFWLzCQAbCbQW8eFbAKYzfG717LhF8ncM7u+17lf3jusJEHa3hwjMQYnNPEVEADsYPyslrG7Pu5tK9fKXN+jIywd5cACcUePBhkmkAMAGWiXdmL5q0eogXd4N6ltJCgAAAJzO1ZIqh3shzuyCP6pvvSg/KAIQ8YzOimoFOgkCQEgEmreq5/V/G/g5qnW/fK8uluFzEx7srogIzEGJzSTXbS/goIUtxJ81ISxuh8/r16urX1Dp2kL527p5YAAMSOP+xjFGr9FFEgAiWJWkvPRVizYE8TJb1PcDSaZhAAAA4FR+oCD+YMeZXVCiviIbU4EBRLRA81vTSAFAKPW4N6mn+K4zfh0FNuAj2MxoEkps5uKTYYh4cZPHj/htaKpo0p9X/JLVoQCGpLG8gY82AohUWyXlpK9aZMYL6hJJq4kYAAAAJ7FZfWvog8qZXdDizC64Wn0FOQCIOEZvd3NvRzFBAAi5nop1Mio3nfoL6l6hwAZ8VBERmIMSGwcuMCwJk8eN6PU3VTRp222/Y/oagCFrKKtnpSiASPRo+qpFeemrFrWYeB0bJD1D1AAAADjOHvWtnzeNM7tgjaQVYjIwgAhjNO/i57YARkz3jmtktO7/+LmpcpOOvnYpBTbgQ62j841KYjDp9R4RmIoRgoCJKLABCAavp0u+Tl8jSQCIlBfQkm5MX7UoVFPSbhATqAEAAPDhc9Eb1Ld+3lTO7II/qm+9KM9FAUSMQMu28aQAYCT5Xl0sw1t37Pe9ZT9V945rCAb4qCIiMPG1HhFw8AKWfBLl9esf3/4DBTYAQVFXUhNPCgAiQJWkvPRVizaE+HrzxBQMAAAA9K2bD9kHu53ZBSUfPBfdTPQArM44+n614WfKEYARPhf53Op5/XoZ3jr1FN8lX+nthAJ8HMOszHydRwTmuW57QaX4YQ5gitINO9RV00YQAIKi+VDzGKPX6CIJABa2VVJO+qpFI/ECukV9PzwEAACAff1AfevmQ8qZXdDizC64+oPrBwDLCrTsnEQKAMLifNS8Vd1/mqqeinWEAZxcERGY+BqPCDiAAavpcHeq4tdvEQSA4L0o8wXUUtNMMxaAVT2avmpRXvqqRS0jeBtKJN3IQwEAAGBLmyWtGckb4MwuWCNpqfhQOQArMgJdvS1FYwgCAIDwNzrfKCIFE1/bEYHpGCUIBNneDf8gBABB9/7u2hRSAGAxrZJWpK9atDpMbs8GSY/ysAAAANjKHkk3hMMNcWYXFEnK+eA2AYBl9LaWdpICAACWef0DM1/XEYHpiogAkcxdUh3S6/N5/areVErwAILO6+mSr9PXSBIALPRiOS991aI/htntWq2+1aYAAACIfK3qK7C1hMsNcmYXVKpv1f0zPDwArCLgeYlVogAAWEMREZj8mo4IzHXd9gIOYiCI6vfUEQIA09SV1MSTAgAL2Ky+Alu4Tn2+WnwiDQAAwA6uVhhuInFmF7Q4swtukHQHDxGAcGf4GuoNv5sgAACwBjYxmv16jghCgh/gIGK1HDgS2ut7jxdzAMzTfKh5jNFrdJEEgDD2g/RVi65OX7WoJYxvY4v6JnK08nABAABErBsV5lMInNkFj0hayvNSAOEs0PTmOFIAAMAyiojA5NdxRMCBDAyHty607wGFujSHwUmaf7aS5p9NELCsgC+glprmNpIAEIZaJa1IX7VojUVub4n6JnMAAAAg8jwjaYMVbqgzu6BIUo74oDmAcGQEunpbisYQBAAAllA1Ot+oJAaTX8MRQUgUEQEiVVtZaCej+du7CT3MjMtyae7dl+mKzbfokkeuVc43LyEUWNr7u2tTSAFAmNmjvvWhf7Tg66AbefgAAAAiylb1Td21DGd2QaWkPPWV7wAgbPS2lnaSAgAAlsEq0RCIJgIOZmC46kuPKGXuZIKwkXFZLqUtz1bqwgwluOI/8mcTMyZqXJYr5AVHIFi8ni75On2NsfGxk0gDQBjYLOmGMF8fejob1PcDw6/wUAIAAFjeHll02q4zu6BF0g29e9aXSHqYhxJAOAh4XuL9RwAArKOICELw2o0IzHfd9oJKSVUkgUjlLqkO2XXFTRlP4CPk+Ilrlz/1r5q9Yu7HCmz90pZnExgsra6kJp4UAISBH6SvWnS1hQts/W5QXxkPAAAA1tWqvgKbpZ+bOrMLHpG09IP7AwAjxjj6frXh54PgAABYSBERhOA1GxFwQAPD1fDP0HU048+aQOAhNCZ1nDK+fJGW/faGMxbXjpe6MIPwYGnNh5rHGL1GF0kAGCGtklakr1q0JoLu0w3qm9wBAAAAaz4/zZNUGQl3xpldUCQph+enAEZSoHHrNFIAAMA6RucbbGAMAdaJhk6RWKGDCOXZcThk1zXhHBeBm2xM6jidtXS20j+TpYkZE4d0GQmueFaKwtICvoAayxs6k2e4xpAGgBDbo771oZH2grhFUp5h6G2HQ7xRDwAAYC3/P3v3Hh3Vfd97/4NAaJCwJDAWYMBosLmYeKqx8xCsWtj4QhNbThFNHJ0kzUKsVOk5SXMspGf5rNOsjsXpWu1JW8byynPanDyPl6Xlps1Ebg11VNsHuwhfirHrWGPFBDNG6IaQhCQ0Qjc00p7njw0JcbAtQJqZ/dvv15++MPp9fltCe+azf98KSUb9fppWUNlqhYNbJdWI9+0BJFjcOn/WGn57EUkAAOAYh4ggMSixJQ6tTBit43CbVhWunvXXWXTzEsKeBTNRXPuo1Q8XqPnoAcKFY3W/27XkhrUUZwEk1H7ZBbZBExcXCEXyvYsXjH1t643KSOdQcAAAACd4/9QrY60DTSr2VRm3trSCykFJZVY42CTpCXYbQKLEz/6cm2IAAJylkQgSdJ9GBInxyOHKJtnHrgNGOvXa8YS8zsUTvnDt0rMztGqHT3cGv6SH6/9In/120YwV2CRGisL5zg9PaPTsaA9JAEiQPd7yohKDC2wlkhpPDoyt++lrp9ltAAAAB+gaPKbWgaYFkp5uaN5bY+o60woqayTdK96/B5AgkwMv5JACAACO0kgECbo/IwIubGAmdL9yPGGvteSz+QR+lS4trpW89B3d+di2WTtBj8IhTND1886lpABglkUl7fCWF1WbusBAKFIt6TlJOZIUOTOq548wchwAACCl74cHj+ndjoZL/9GjDc17Gxua9+aauN60gspGSX5JYXYfwGyKj7R0aGqEIAAAcBBPabyRFBJ0b0YECcWFDWPFhs7rxIHEFNnWf/l2Ar8CiSyufdTqhwvYADjaYNugJs9P8iQ2gNkSlrTVW160z8TFBUKR3EAosk/S4x/9d2+3RnXg5/1cAQAAACno3Hi/3u965XL/6h5JTQ3Ne/0mrjutoLJV0lZJdVwFAGbLVP/BVaQAAICj8KBLIu/LiCChmogAJmtreC8hr7MwL0vXb76JwD/FsgfW6o7/8XDCi2uXYqQoTHDmOKcFAZgV+2UX2Iy8RwiEIn7ZD/Fs/7j/5rXIgJpbhrkSAAAAUsi58X692fITTUyNf9x/slpSY0Pz3jIT159WUDmYVlBZJmk3VwOAmRafPNdnjR4lCAAAnKWRCBJ4T0YEifPI4Uoubhit/0i7epq7E/Jan/lmEYFfxsXi2vZXvqstf/5F3bxtXVK/HgqHMEF3+HQOKQCYYXu85UUl3vKiQRMXFwhFSi7c2H/qkaz1b5+myAYAAJAiJq0JvdO275MKbBflSHq6oXlvjalZpBVU1ki6XRKnswOYMVN9jVmkAACA4zQSQQLvxYgg4Q4RAUz2/lOvJ+R1lvqWadkDawlcly+uzc9MT5mvb3Xx77BJcLSpiSmdbR/oIQkAMyAq6V5veVG1qQsMhCLVkp6T/cHmtNS/fVq9Zye4OgAAAJJo0prQkZafamTiip6zeLSheW9jQ/PeXBMzSSuobJKUL8YHAZgJ8akxa7BxAUEAAOA4jUSQwPswIuACB2ZSIk9ju/279yk9O8OVOWdvzEvp4tqlVt3l5RsDjnf63VNLSQHANQpL8nvLi4y8HwiEIrmBUGSfpMev5v9/+mAHRTYAAIAkuVhgGxy7que37pHU1NC8129iNhfGi/ol1XGlALgW1sBb3PQCAOA8YU9pfJAYEngPRgQJ10gEMF2iTmNbmJcl3/+9zTW5Zm/Mk++xbXpw/x/r80/9YUoX1y41PzOdU/PgeKP9Yxo9O8ppbACuVp2krd7yolYTFxcIRfwX7nO2X+2fMRKzKLIBAAAkybHTh662wHbRaknvNjTvLTM1o7SCyjJJu7haAFytqcFXc0gBAADHaSSCBN97EUFiPXK4koscxus/0q4TB44n5LVu3rZOa77xOWOz/GhxbcMOnxbmZTluHTfevZ5vDDhe79HubFIAcBV2e8uLyrzlRUY+rRUIRUou3MgXXOufNRKztO9It87HLK4aAACABPnFqQNqG3hvpv64pxua99aamlVaQWWtpNslRblyAFyJ+EhLRzzWSxAAADhPIxEk1px4PE4KCVZfGGyUfcw6YKz07Aw99Ny3EnZS2Jt/dUAdzzUbkd2Cldla/fsF8n5+oyMLa5czMRrT/vt/wDcGHM//9Tui8zLm8dQkgOmISioxdXyoJAVCkRpJj870n7syJ0M771+pjHSeuQIAAJhNM1xgu1RY0tZiX5WRD3JY4WCuZuhBDgDuMNn+lKzRowQBAIDzeD2l8VZiSBw+FUiORiKA6WJD5/X6n+5P2Ovd+dg2rdrhc2xeC1Zma803Pqf7f1ymh+v/SL5vbDKmwCYxUhTm6P5FF8cDAZiOsCS/qQW2QCiSGwhFGjULBTZJ6oyeV90rnZzIBgAAMItO9L41WwU2yS53tTY07/WbmF1aQeVgWkGlX1IdVxKATxOfPNdHgQ0AAEdqo8CWhPstIkiKRiKAG/QfadexBJ6O5rQi20eLa5/9dpEWr1ls7PXASFGY4MwvzyyKW/ExkgDwCeokbfWWFxl5cxsIRfySmjTLJ0tTZAMAAJg9XYPHdKzntdl+mRxJ7zY07y0zNce0gsoySbu4ogB8kqm+xixSAADAkRqJIPEYJ5ok9YVBgodr3P2jr2mpb1nCXq/5mbd17G9fS8ks0rMztGp7gbxf2Gh0Ye1yGCkKU9z8wC09i25avJQkAFzGbm95UY2piwuEImWSamR/IJkQm/Jz9MXNeVxZAAAAM6Rr8Jje7WhI9MvWFfuqykzN1AoH/bI/4MrhCgNwqbh1/mzs+J8uIgkAABxpl6c0XksMiUWJLUnqC4ONmuXTC4BUkZ6dobv/7qsJLW11HG7TO9U/U2zofEqsf9n967RiyzqtKlzt6mvhtT97Xt0vR/imgKNlLJwv31f8BAHgUlFJJaaOD5WkQChSo1kaH/ppKLIBAADMjCQV2C4KS9pa7KsaNDFbKxzMlV1kK+BKA/Crnw39h6OTZ56l4AoAgDN5GSeaeJTYkqS+MFgt6XGSgFssWJmt36vbqfmZ6Ql7zeHeEb31Fy+o/0h7wtdLce3yOg636c3KfyIION6Gh2/tWJh33SqSACD7w7gSg8eH5krapyQ/gEORDQAA4NokucB2UVR2ka3J1JytcLBW0k6uOACKT41NfLhngaZGyAIAAOdp85TG84kh8dKIIGkaiQBuMtY5pIPfDWliNJaw11yYl6X7ar4s32PblJ6dkZDXXLXDpzuDX1LJS9/RnY9to8D20XwKVydsL4DZdOqdTgpsACSpTtJWgwtsfklNSoETpN9ujer5I71ccQAAAFchRQpskj1u892G5r1lpmadVlBZJmkXVx0Aa6RliAIbAACO1UgEycFJbElUXxgkfLhO9sY83fuD0oSeyCbN7qlsyx5YqxvvXq9Vd3kTvi4nevOvDqjjuWaCgOP9Tqm/b37W/CUkAbjWbm95UY2piwuEImWSamR/0JgyOJENAADgypwb79ebLT/RxNR4qn1pdcW+qjJTc7fCQb/sD74YIwi4VOzE9xWP8TAWAAAOtctTGq8lhsSjxJZE9YXBRqXAqQZAoi1Yma3f/f4faPGaxQl/7Y7DbQoHD2isc+ia/hyKa9e2B4wUhQmWrF8yln/XmgUkAbhOVPb40EZTFxgIRWokPZqqXx9FNgAAgOlJ4QLbRWHZ40UHTczfCgdzZRfZCrgaAXeJj5/uiLX+DZMcAABwLq+nNN5KDIlHiS2J6guD1ZIeJwm4UXp2hu7+u68mpcgmSScOHFfz3xxQbOj8tP8fimszZ9/n/9cVZQ+kqtv/8LNn586fu4gkANcIyy6wGXnzGghFciXtkwMetKHIBgAA8MkcUGC7KCq7yNZk6l5Y4WCtpJ1clYB7TLY/JWv0KEEAAOBMbZ7SeD4xJEcaESRVIxHArWJD5/XK12t14sDxpLz+zdvW6aHnvqUN396i9OyMj/3vsjfmyffYNj24/4+15c+/qJu3raPANgOW3b+OEGCE3g96+F0KcI86SVsNLrD5JTXJISdFv90a1fNHGMsCAABwOQ4qsEn2uM13G5r3lpm6H2kFlWWSdsku7AEwXHziTA8FNgAAHK2RCJKHk9iSrL4wyAbA9Vbt8OmOP9matHLYxGhMHW+c1C9/9KrGOoeUvTFPqx8u0Mq71mhhXhYbNAsYKQpTzJ0/V/6v3TE2J20OY0UBs+32lhfVmLq4QChSJqlG9geIjsKJbAAAAL/JYQW2j6or9lWVmbo3Vjjol33y8WquVMBck93Pj1mDjbxXCACAc+3ylMZriSE5KLElWX1hsFEOOe0AmE3ZG/O06XsPJW286EXDvSMU12ZRx+E2nXrtuLpfOc44URhj9Zb8vhvW5i0hCcBIUdmnrxk72igQitRIetTJa6DIBgAAYHN4ge2isOzxooMm7pEVDubKLrLxmQBgoLg1Ho0d/14OSQAA4GheT2m8lRiSgxJbktUXBqslPU4SgG3Dt7fI941NBGGQgZYBHX/2HYprMFbGwvnyfcVPEIB5wrILbEZ+eBYIRYz68IwiGwAAcDtDCmwXRSWVFPuqGk3dLyscdPzDJAB+G6ewAQDgeGFPaZwP/ZKIEluS1RcGt0o6SBLAr6XKqWy4egMtAzr54lGdPnhMY51DBALj3fzALT2Lblq8lCQAY9R5y4vKTF1cIBQxcowRRTYAAOBWhhXYLrW72FdVY+q+WeFgmaQaSZzaBJggPjU28eGeBZoaIQsAAJzrSU9pvIIYkocSWwqoLwyyCcBlbPj2Fq3/kl/zM9MJwwEorsHNOI0NMMoub3lRramLC4QiZTL4gzKKbAAAwG26Bo/p/a5XTCywXVQnqcLg8aJGPmACuJHVfzg6eeZZSqkAADjbDk9pfB8xJA8lthRQXxhslCFjfICZtmBltm791t26eds6wkhBw70j+uDZdymuAZI27ritJ3NRJqexAc4VlT0+tMnUBQZCkVpJO03fSIpsAADALboGj+ndjgY3LDUse7xoq4mLs8LBXNlFNj4jAJyKU9gAADDFIk9pfJAYkocSWwqoLwxWSHqCJICPd/3mm/SZbxZpqW8ZYSTZcO+IOt9oUdvPwho62ksgwAXXLb9O6x+8lSAAZwrLLrAZeXMaCEVyJTVKKnDLhlJkAwAApnNRge2iqOwiW6OpC7TCwRpJj3J1Aw78/h2O9Ex2/pCHWwEAcLawpzTO2KUko8SWAuoLg35J75IE8Omu33yTPvenD2phXhZhJBDFNWB6OI0NcKQ6b3lRmamLC4QiftkFNteNNKHIBgAATOXCAtuldhf7qmpMXZwVDpZJqnHj7++Ak8VOfF/xGO+bAwDgcE96SuMVxJBclNhSRH1hcJAbU2D6Vu3w6bay36XMNosmRmNqeekYxTXgCuSuztUt9zP+GHCQXd7yolpTFxcIRcokPe3mDV57Q6a+smW5MtLTuNoBAIARXF5gu6hOUkWxr8rIk5StcNAve7zoaq54wAHfs5zCBgCAKXZ4SuP7iCG5KLGliPrC4D5J20kCuDKrdvjkfdDHmNEZMjEaU8cbJ9X16gfqfjlCIMBV8H/9jui8jHkU04HUFpU9PrTJ1AUGQpFaSTvZamllToZ23r+SIhsAAHC8E71v6VjPawRhC8seL9pq4uKscDBXdpHtHrYaSG2cwgYAgBk8pfE5pJB8lNhSRH1hsELSEyQBXJ3rN9+kz3yziDLbVaC4BsysJeuXjOXftWYBSQApKyy7wGbkqQ2BUCRX9vjQArb61yiyAQAAp/vFqQNqG3iPIH5TVHaRrdHUBVrhYI2kR9lqIDXFJ870xFr+J6ewAQDgfIc8pfGtxJB8vIOfOjiWELgG/UfadfKFZoKYponRmE4cOK7X/ux57b//B/p54GcU2IAZ0vdB34LJ85NRkgBSUp23vMhvcIHNL6lVFNh+S2f0vOpe6dTQyCRhAAAAx6HA9rFyJB1saN5bYeoC0woqKyTtkl3YA5Biprr/hQIbAABmaCSC1MBJbCmkvjDYKmk1SQBXbtUOn+58bBtBfIqOw2069dpxdb9yXLGh8wQCzBJOYwNS0i5veVGtqYsLhCJlkp5mmz9ZVnqadt27SnmL5hMGAABIeZPWhI6dPkSBbXrqJFUU+6qMfGDFCgf9sh+E5/MDIEVwChsAAEa53VMabyKG5KPElkLqC4O1knaSBHBlKLB9MoprQHJ8tmzT2Jy0ORTZgOSLyh4fauwNaCAU4T7iClBkAwAATjBpTehIy081ONZDGNMXlj1etNXExVnhYK7sIts9bDWQAj+n25+SNXqUIAAAcL6opzSeSwypgRJbCqkvDJaJ0xOAK7LsgbXa8udfJIiPoLgGJN+KTSujy3035pAEkFRh2QU2U8eH5so+5pzxoVcoKz1Nf7B5udauyCQMAACQciiwXZOo7CJbo6kLtMLBGkmPstVA8nAKGwAARtnvKY2XEENqoMSWQuoLg7mSzpIEMD3ZG/N07w9KNT8znTAkDbQM6OSLR3X64DGNdQ4RCJBkc+fPlf9rd3AaG5A8dd7yojJTFxcIRfyyC2yUZa/BI5uWy7dmIUEAAICUcW68X++07dPIxCBhXJvdxb6qGlMXZ4WDJZJquR8AkmOy8yeyht8mCAAADLl38JTGa4ghNVBiSzH1hcEmcZIC8KnSszP00HPfcn2BjeIakNo4jQ1IiqikCm95Ua2pCwyEImXiBOcZ8/v+PP1f6/lRDQAAku/ceL/ebPmJJqbGCWNm1EmqKPZVGdkItMJBv+wiG58nAAkUt8ajsePf4yYSAABzeD2l8VZiSA2U2FJMfSFHgQPTcfePvqalvmWuXDvFNcA5OI0NSLg2SSXe8qImUxcYCEVqJe1kq2fWpvwcfXFzHkEAAICk6Ro8pve7XqHANvPCsseLtpq4OCsczJVdZNvOVgOJMdn9/Jg12Mh7fQAAmKHNUxrPJ4bUMY8IUk6jKLEBn2jDt7e4rsA23Duizjda9OE/HKG4BjjI1MSUut8/PbHcdyNvbAGz75DsApuRpywEQpHcC/cKnLIwC95ujWp8wtLv35mnjPQ0AgEAAAnVNXhM73Y0EMTsKJDU1NC8t6zYV7XPtMWlFVQOSiqxwsFqSY+z3cDsilvjUWuwkVPYAAAwRyMRpBZOYktB9YVBNgX4GAtWZuvh+j9yxVovFtfafhbW0NFeNh9wKE5jAxLiSW95UYWpiwuEIv4LN9O8UT7LVuZkaOf9KymyAQCAhDl2+lWd6HubIBJjT7GvqtrUxVnhYInsU9m4bwBmCaewAQBgnB2e0vg+YkgdlNhSUH1hcJ84/hu4LNPHiFJcA8y0YtPK6HLfjbyJDMy8qKQKb3lRrakLDIQiFZKeYKsT5/rMdH216EblLZpPGAAAYNZMWhM6dvqQ2gbeI4zE2i+prNhXZeQJzlY46JddZOMEZ2CGxa3xaOz493h/DwAAsyzylMYHiSF1UGJLQfWFQT6oAi5j2QNrteXPv2jcuiZGY+p446TaGt5T/5F2NhowEKexAbOiTfb40CYTF3dhfGiNpJ1sdeJlpadp172rKLIBAIBZMWlN6EjLTzU41kMYyRGWXWQz8l7CCgdzZRfZeFAemMmf3ZzCBgCAcfcFntK4nxhSCyW2FFRfGPRLepckgN/04P4/1sK8LCPWcrG41vXqB+p+OcLmAi7AaWzAjDoku8Bm5BNSgVAkX9I+cXpC0j2yabl8axYSBAAAmDHnxvv1Tts+jUzwsH+SRWUX2YwdHWSFg9WSHmergWvHKWwAABhpj6c0Xk0MqYUSW4qqLwy2SlpNEoDNhFPYKK4B7sZpbMCMedJbXlRh6uICochW2QU23hxPEVvWLta2O64nCAAAcM0GRrr0TttzmpgaJ4zUsafYV1Vt6uKscLBE9qls3F8A14BT2AAAMNK9ntJ4IzGkFkpsKaq+MDdzEJUAACAASURBVFgrRgcBv3L3j76mpb5ljvzaOw63qfVf36O4BoDT2IBrE5VU4S0vqjV1gYFQpELSE2x16tmUn6Pfu2OJMtLTCAMAAFyVrsFjerejgSBS037Zp7IZeTyeFQ76ZRfZOOkZuAqcwgYAgJGintJ4LjGknnlEkLIaRYkNkCQtWJntuAJbT3O3Tr7QrO5Xjis2dJ5NBCBJ6g6fzln2meWcxgZcuTbZ40ObTFxcIBTJlVTD7/+p6+3WqE6fHdfO+1dSZAMAAFfsF6cOqG3gPYJIXdslNTY07y0r9lUZd8+RVlDZZIWDW2UX2baz3cCVmeo9MJ8UAAAwTiMRpOj9CxGkrH1EANiW37vBEV/nxGhMx55r1s8e+f/06rf+QR3PNVNgA/Abpiam1P3+6QmSAK7IIUl+gwts+eIBFkfojJ5XzfMn1XuWH+MAAGB6Jq0JvXXyWQpszlAgu8hWYuLi0goqB9MKKksk7WGrgemLW+NRxogCAGAk+jgpinGiKay+MNgkjvgGdP+Py7R4zeKU/fqGe0f0i9p/59Q1ANMyd/5c+b92B6exAdPzpLe8qMLUxQVCka0XbpYZS+IgWelpesi/VL41CwkDAAB8rHPj/Xqv8wUNjvUQhvPsKfZVVZu6OCscLJF9Khv3IcCnmOx+fowSGwAARvJ6SuOtxJB6OIkttdH+hOulZ2ekbIFtuHdEb/7VAb2w/X9z6hqAaeM0NmBaopJ2GV5gq5B0UHxw5DgjMUv1b5/WgZ/3EwYAALisgZEuvdnyEwpszvV4Q/PefQ3Ne3NNXFxaQeU+SVslhdlq4ONxChsAAMYKU2BL4fsVIkhplNjgetm3Lk25r2liNKZ3/vb1X5XXAOBKdYdP58St+BhJAJfVJmmrt7yo1sTFBUKR3EAoUivpCbba2V6LDOiZfzul8zGLMAAAwK+094d1uOUfNTE1ThjOtl32eFG/iYtLK6hskl1k289WA5c31XtgPikAAGCkRiJI4XsVIkhdjxyubJJ9CgXgWjd8dnVKfT0dh9v0rzt+pJZn3mJzAFw1TmMDPtYhSX5veVGTiYsLhCL5F26Qd7LVZoicGVXdK53qPcuPdAAA3G7SmtAvTh1Qc9fLhGGOAtlFthITF5dWUDmYVlBZImkPWw38Jk5hAwDAaI1EkML3KUSQ8jiNDa6We0teSnwdE6MxvflXB/Rm5T8xNhTAjOA0NuC3POktL9rqLS8aNHFxgVBkq6Qm2R+EwSCd0fN6+mCHIqdGCQMAAJcaiw3rSMtP1TbwHmGYJ0fScw3Ne6tNXWBaQWW1pHvFA/XAr3AKGwAA5vKUxungpPL9CRGkvEYigJvNX5iR9K9hoGVAB78bYnQogBnFaWzAr0Ql7fCWF1WYusBAKFIh6aDsD8BgoJGYpWdeP6UDP+8nDAAAXGZgpEuvR+o0ONZDGGZ7vKF5776G5r25Ji4uraCyUZJfUpithtvFJ8/1cQobAADG2k8EKX5vQgQpjxYoXC1r6XVJff2BlgG9+l/+UUNHe9kMADOO09gAhSVt9ZYXGfk7byAUyQ2EIrWSnmCr3eG1yICe+bdTOh+zCAMAABc40fuWDrf8oyamxgnDHbbLHi/qN3FxaQWVrZK2Sqpjq+FmU10/XUIKAAAYq5EIUvy+hAhS2yOHKwfF009wsYV5WUl77YsFNsaHApgtnMYGl9svu8DWZOLiAqFI/oUb4p1stbtEzozqhy+2q/csP94BADDVpDWhprbndaznNcJwnwLZRbYyExeXVlA5mFZQWSZpN1sNN4pPnOmxRo8SBAAA5uIQqVS/JyECvpEA/LaJ0Zj+/b/9MwU2ALPu1NudOZPnJ6MkAZfZ4y0vKvGWFw2auLhAKLJVUpPsD7jgQv2jMf0//6dNzS3DhAEAgGHOjffr9cgzOjV0nDDcK0fS0w3Ne2tMXWBaQWWNpHsl8X4FXGWq+1+WkgIAAMZq85TGW4khxe9FiMARKLEBCXbkL1/UWOcQQQBIiM7/aJ9PCnCJqKQd3vKialMXGAhFqiUdlP3BFlyu/u3Tev5IL+NFAQAwRNfgMb3Z8hONTAwSBiTp0YbmvY0NzXtzTVxcWkFloyS/mBQDl+AUNgAAjEfvxgn3IUSQ+h45XNkknngCEqanuVvdL0cIAkDC9H3Qt4DT2OACYdnjQ428UQyEIrmBUGSfpMfZalzq7dao6l7pZLwoAAAONmlN6BenDujdjgZNTI0TCC51j6Smhua9fhMXl1ZQ2Sppq6Q6thqm4xQ2AACMR4nNCfcgRMA3FIDf9P5TrxMCgITjNDYYbr/sAluTiYsLhCJ+SY2StrPVuOzP+Oh5PX2wg/GiAAA40Lnxfh1p+anaBt4jDHyc1ZIaG5r3lpm4uLSCysG0gsoySbvZapgqPtrRxylsAAAYLeopjTcSgwPuP4jAMfiGgiv1NHcn9PWGe0fUf6Sd4AEkXN8HfQsmRib6SAIG2uMtLyrxlhcZOXMpEIqUXPhdvYCtxicZiVmMFwUAwGEujg8dHOshDHyaHElPNzTvrTF1gWkFlTWS7hVTY2CgydP/sIQUAAAwWiMROOS+gwgcg5PYgATofKOFEAAkzclXT/CGGUwSlbTDW15UbeoCA6FItaTnZH9gBUwL40UBAEh9jA/FNXi0oXlvY0Pz3lwTF5dWUNkoyS8pzFbDFNZwpCce6yUIAADMRt/GKfccROAMjxyuHJR0iCTgNsPdQwl9va5DHxA6gKQ5d/qcRs+O8og/TBCWPT7UyBvDQCiSGwhF9kl6nK3G1WC8KAAAKXxfxvhQXLt7JDU1NO/1m7i4tILKVklbJdWx1TDBVM8/LyUFAACM10gEDrnfIAJHoR0K1xntTuzp9KOnBgkdQFJ1vNnGG2dwuv2yC2xNJi4uEIr4L9zwbmercS0ujhetf62b8aIAAKSI9v6wXo3UMj4UM2G1pMaG5r1lJi4uraByMK2gskzSbrYaTmb1H45yChsAAMYLe0rjrcTgkHsNInCURiKA25x5py2hrzfWOUToKWjBymyt+cbndP+Py7TmG58jEBjt3OlzGuoe6iMJONQeb3lRibe8yMhWeCAUKbnwO3kBW42Z0tx1Tj98sV0dvYwqAwAgWSatCTW1Pa/mrpcJAzMpR9LTDc17a0xdYFpBZY2keyVF2W44TnxqbHLghRyCAADAeBwW5SBz4vE4KThIfWGwVfZTXIArpGdnqOSl7yTye4zQU2jvV20vkPcLG7V4zeJf/fOBlgG98vVaAoLRMhbOl+8rfoKAk0QllZk6PlSSAqFItRgfiln2e59ZoqLbFhEEAAAJNDDSpXfantPEFIVyzKpDkkqKfVVGPvBjhYP5sj8c5IEfOOe67T8cnTzzLCU2AADMd7unNN5EDM7ASWzOQ0sUrhIbOq/h3pGEvV56dgahJ1F6doZW7fDpzuCXVPLSd/TZbxf9RoFNkhavWawFK7MJC0Y7Pzyhs+0DzK+BU4Rljw818vfUQCiSGwhF9okCGxLg/7zfpx+92K6hkUnCAAAgAY6dflWHW/6RAhsS4R5JTQ3Ne418Yi2toLJV0lZJdWw1nCBujUc5hQ0AAFeIUmBz2L0FEThOIxHAbXrCpxL2Wtm3LiXwBPtoce3Ox7ZpVeEnHzi5/N4NBAfjtb56cmncio+RBFLcftkFNiNvAgOhiP/C79/b2WokSmf0vP7upTY1twwTBgAAs+TceL/e+PDvdaLvbcJAIq2W1NjQvLfMxMWlFVQOphVUlknazVYj1U31HpivqRGCAADAfBwS5bT7CiJwlkcOV+6TPa4JcI2uVz9I2Gtl3sjDV4lypcW1S3m/sJEAYbypiSl1v396giSQwvZ4y4tKvOVFRo7DCYQiJbILbIzDQcKNxCzVv31a9a9163zMIhAAAGZQe39Yr0ZqNTjG4ddIihxJTzc0760xdYFpBZU1km4Xn2MgRcWt8ag12LiAJAAAcAVKbA4zjwgcqVGcBgEX6X+rPWGvlbt2mTrUTOizZNkDa3Xj3eu16i6v5memX/Wfc3Gk6FjnEKHCaN3h0znLNi4fnzN3joc0kEKikkq85UWNpi4wEIpUi/GhSAHNXefU8vyI/mDzcq1dkUkgAABcg7HYsJo7X9SZ4TbCQCp49MJo0ZJiX5VxDwalFVQ2WeFgvngwCCloqvPHPMkOAIB7NBKBw+4liMCRaIvCVWJD59VxODFvMOYVrCDwGbbsgbW64388rO2vfFdb/vyLunnbumsqsF10y9c2Ey6MNzUxpbY3T8ZJAikkLMlvaoEtEIrkBkKRfaLAhhQyErP0zOundODn/ZzKBgDAVWrvD+v1SB0FNqSaeyQ1XSizGefCeFG/pDq2GqkiPnGmxxo9ShAAALjDfk9pfJAYHHYfQQSORIkNrnPqteMJeZ2LJ3zh2sxWce1SK+9aQ9Bwhb4P+hZMnp9kBAdSQZ2krd7yolYTFxcIRfzixGOksNciA/rhi+3q6B0nDAAApmnSmlBT2/Nq7npZE1P8HYqUtFrSuw3Ne8tMXWBaQWWZpF1sNVLi74Wu0FJSAADANejVONCceJzDPZyovjDYJI7hhoukZ2eo5KXvJOS13vnb19XyzFuEfoWyN+Zp9cMFWnnXGi3My0rIa770zb/X0NFewofxrlt+ndY/eCtBIJl2e8uLakxdXCAUKZFUK4mRInCELWsX627fImWk81waAAAfp/fcSYU7/pXyGpykrthXVWbq4qxw8OKDQ9x3ITnX4HCkZ7Lzh5TYAABwD6+nNN5KDM7CO97OVUsEcJPY0HmdOJCY09jWf/l2Ap+m7I158j22TQ/u/2N9/qk/1IYdvoQV2CRp9cN0eeEO506f0+jZ0R6SQBJEJd1reIGtRtJz4oMUOAinsgEA8PEunr72dus/U2CD0+xsaN7b1NC8N9fExaUVVDZJypcUZquRcHFrdKrnnymwAQDgHmEKbM40jwgcq5EI4DZtDe/p5m3rZv11FuZl6frNN6n/SDuhX0YyTlz7OCvvWqNmtgQu0frqiaUbt/sIAgm9yZNUYvD40FzZx4nfw1bDifpHY/p/D3ZwKhsAAJfg9DUYoEBSa0Pz3q3Fvqom0xaXVlA5KMlvhYO1knay3UgUa+BILB5jogcAAC7CKFGn3jMQgTM9criySVIbScBN+o+0q6e5OyGv5f+v9xH4JRaszNaab3wuaSeufZyFeVnK3pjHBsEVRvvHdLZ9gNPYkCh1krYaXGDzS2oSBTYYgFPZAACQxmLDeuvks5y+BlPkSHq3oXlvmakLTCuoLJO0i61GQsSnxicHXuD0dQAA3IUSm1PvFYiAbzzASd5/6vWEvM7iNYu15hufc3XWF4tr9/+4TA/X/5E+++2ilCiufRQjReEmnW+2L41b8VGSwCzb7S0vKvOWFw2auLhAKFIm+1Tj1Ww1THHxVLbnj/TqfMwiEACAq7T3h/V6pE5nhnneF8Z5uqF5b62pi0srqKyVdLukKFuN2TTZ869xTY0QBAAA7tHmKY03EYMzzYnH46TgUPWFwa2SDpIE3ObuH31NS33LZv11JkZjOvjdkIaOuueY8QUrs7X83g3yfmGjFq9Z7Iivebh3RC9s/998Y8A1VmxaGV3uu5GnRzEborLHhzaausBAKFIj6VG2GibLSk/TH2xerrUrMgkDAGC0sdiwmjtfpLwGNwhL2lrsqzLyQSMrHMyV/aART6pixsUnz/XFPqxeQhIAALjKk57SeAUxOBMlNoerLwwOyj5eHHCN7I15+vxTf5iQ1xpoGdCr/+UfFRs6b2ye6dkZWnb/Onkf9CWkHDgbXvrm37uqbAh3mzt/rnyPFETnZczj73/MpLDsAluriYsLhCK5sk8xZnwoXGPtDZnavnmpsrPmEQYAwDgnet/SsZ7XCAJuEpVdZDP2RAkrHKyVtJOtxkyabH9K1uhRggAAwF12eErjTDV0qLnV1dWk4GBHnzq8QZKfJOAm58+MaO71C7Xk1qWz/loLFi1Q1i1L1fnSL43KMD07Qyse2qiN39qizf99m1bedbMWLl3o2PXMyfTo9MHjfHPAFeJTcU1OxOK5Ny1KJw3MkDpJ/8lbXtRt4uICoYhfPNUPFxoYjSl8ckietLm6cYmHQAAAZvz9NtKlIyd/qtNDvAcA1/FI+s+R3sNt65b+rpFFtjnLCvfFew63SSphuzET4qMdfVN9z3NENQAA7hL1lMbLiMHB9wWcxOZs9YXBEknPkQTcJj07Qw88U6aFeVkJeb0TB47r54GfOT6zZfev04ot67SqcLVR18PEaEz77/8B3xhwlY07buvJXJS5lCRwjXZ7y4tqTF1cIBQpk1QjTi6Gy63MydCDd+RpVR5lNgCAM01aEzp2+pDaBt4jDECqK/ZVlZm6OCscvPggEvdxuCaxE99XPMb0DgAA3Pa7MiU2Z6PEZoD6wiCbCFe6fvNNuq/mywl7PacW2ZY9sFb5D/2OccW1j3rtz55X98sRvjHgGtctv07rH7yVIHC1orLHhzaausBAKFIj6VG2Gvi1LWsX627fImWkpxEGAMAxugaP6f2uVzQxNU4YwK+FZY8XHTRxcVY4mCtO1Ma1XEP9h6OTZ56lCAkAgPswStThKLEZoL4wuE/SdpKAG2349hb5vrEpYa/XcbhN71T/TLGh8ymdy7IH1urGu9dr1V1ezc90x8RBE07LA67UzQ/c0rPopsWcxoYrFZZdYGs1cXGBUCRX0j5J97DVwG/LSk/TQ/6l8q1ZSBgAgJR2brxfvzx9UGeG2wgDuLyo7CJbk6kLtMLBWkk72WpckfjU+MSHezyaGiELAADcZ5GnND5IDM5Fic0A9YXBMklPkwTc6s7glxJ6ythAy4D+/b/9s8Y6h1IqBzcW1y7FSFG4UcbC+brtywWjc9LmZJIGpqlOUoW3vMjIm7hAKOKXXWBbzVYDn2ztDZn6/O03KG/RfMIAAKSUSWtCH/a8qRN9bxMGMD27in1VtaYuzgoHyyTViPGimO7fI93Pj1mDjQtIAgAA19nvKY2XEIOzUWIzQH1hMFfSWZKAW6VnZ+juv/uqFq9ZnLDXnBiN6chfvpj08ZXZG/N0y3/6nGuLax/FSFG40YpNK6PLfTfyRi6mY7e3vKjG1MUFQpEy8cEGcMUYMQoASCWMDgWuWl2xr6rM1MVZ4SAPLGFa4pPn+mIfVi8hCQAAXGmXpzReSwzORonNEPWFwUYxMgkulowimyQde65Zx374akLHi2ZvzNPqhwu08q41WpiXxeZfgpGicCv/1++IzsuYR3EHHycqaau3vMjYETOBUKRG0qNsNXB1GDEKAEg2RocCMyIse7yokSdvW+FgruwiG5+D4GNNtj8la/QoQQAA4E6MEjUAJTZD1BcGKyQ9QRJws+yNebr3B6UJP5FsuHdEb/3FC+o/0j6ra6O49ukYKQq3ys3PHb3lvnWMFMXlhGUX2EwdH8qHGMAMWntDprbedr1W5XkIAwCQEJPWhI6dPqS2gfcIA5gZUUklxb6qRlMXaIWDPMSEy18bw5Geyc4fLiUJAABcKewpjfuJwfkosRmivjCYL+kkScDtsjfm6a6/3JGUolfH4TaFgwc01jk0I3/egpXZuuVrmymuXSFGisKtNpbc1pe5OJNxCbhUnbe8qMzUxQVCEcbJALNkU36O7rltsbKz5hEGAGDWnOh9Sy19bzM6FJgdu4t9VTWmLs4KB8sk1UjiVHrY4tZorOWvM+OxXrIAAMClv/96SuM1xOB8lNgMUl8YbJJUQBJwu2SNFpXsk8A++Kcmnfj7t65qxOiCldlafu8Geb+wMSlfvwk6Drfpzcp/Igi4TsbC+fJ9hYdM8Cu7vOVFtaYuLhCKlIkPLIBZlZWeprvWLdam9TnKSE8jEADAjOk9d1JHu/5NIxNMeQFmWZ2kCoPHi/JgE359PfQfjk6eeZb3CAAAcC+vpzTeSgzOR4nNIIwUBX4tPTtDhX/zJS31LUvK60+MxtRce0Qtz7z1qf8txbWZt+/z/+uqSoSA063YtDK63Hcjb9i5W1T2+NAmUxcYCEVqJe1kq4HEuD4zXfd9Zol8axYSBgDgmpwb79cvTx/UmeE2wgASJyx7vGiriYuzwsFc2UW2e9hq94pb49HY8e/xfhgAAC7+nZdRouagxGYQRooCv8332DZt2OFL2usP947og2ffVcf+8G+UqtKzM7RqewHFtVny5l8dUMdzzQQB15k7f658jxRE52XM4407l96oyS6wGfmUfSAUyZXUKE4eBpJi7Q2Z2nrb9VqV5yEMAMAVGYsN60TvYbUNvEcYQHJEZRfZGk1doBUO1kh6lK12p8n2p2SNHiUIAADci1GiBqHEZhhGigK/bdUOn+74k62an5metK/h4pjRkdODWrFlnVYVcsr9bBnuHdG7P/g3db8cIQy40pL1S8by71qzgCRcp85bXlRm6uICoYhfdoGNgiaQZGtvyNT2zUuVnTWPMAAAn2jSmlBbX5Na+t7WxNQ4gQDJt7vYV2Xsh3tWOFgmqYb7RneJj3b0xdprlpAEAACuxihRg1BiM0x9IU8cAZezYGW2fvf7f8CpZ4Ya7h1R5xstavtZWENHewkErrdxx209mYsyl5KEa+zylhfVmrq4QChSJulpthlILZvyc3TPbYspswEALqu9P6wPel6nvAaknjpJFcW+KiNP8LbCQb/s8aI8QewGcWs01vLXmfEY7wcDAOBibZ7SeD4xmIMSm2HqC4N+Se+SBHB5G769Rb5vbCIIA1BcAz5e5vULtHG7jyDMF5U9PrTJ1AUGQpFaSTvZaiA1ZaWn6a51i7VpfY4y0tMIBACgrsFjOt7zhkYmBgkDSF1h2eNFW01cnBUO5soust3DVpvN6j8cnTzzLCfvAQDgbk96SuMVxGAOSmwGqi8MtoonjYCPlb0xT/6KB7TUt4wwHGZiNKaON06qreE99R9pJxDgE6zekt93w9o8ximYKyy7wGbkp4OBUCRX9vjQArYaSH2U2QAAAyNd+uXpf9PgWA9hAM4QlV1kazR1gVaYqTUmi1vj0djx71FgAwAAt3tK403EYA5KbAZipCgwPat2+HTHn2zV/Mx0wkhhF4trXa9+oO6XIwQCTNPc+XPle6QgOi9jHm/omafOW15UZuriAqGIX3aBjWsXcJjrM9N132eWyLdmIWEAgEsMjHTpw95/15nhNsIAnGl3sa+qxtTFWeFgmaQa7i/NM9n+lKzRowQBAIC7MUrUQJTYDMRIUWD60rMztOE/360NOxi7l0oorgEzIzc/d/SW+9ZlkoRRdnnLi2pNXVwgFCmT9DTbDDgbZTYAMB/lNcAodZIqin1VRp70bYWDftnjRZleY4j4aEdfrL2G6QMAAIBRogaixGYoRooCV2bBymzd+q27dfO2dYSRRB2H29T6r+9RXANm0MaS2/oyF2fyxp7zRWWPDzX2WOxAKFIraSdbDZiDMhsAmGcsNqwPug7q1NBxwgDMEpY9XrTVxMVZ4WCu7CLbPWy1w8Wt0VjLX2fGY71kAQAAGCVqIEpshmKkKHB1KLMlXsfhNp167bi6Xzmu2NB5AgFmWMbC+fJ9xU8QzhaWXWAz8qn4QCiSK3t8aAFbDZiJMhsAON9YbFgneg+rbeA9wgDMFZVdZGs0dYFWmM9NnG6q9+XxqYEXPCQBAIDrMUrUUJTYDMVIUeDaUGabXRTXgMRasWlldLnvxhyScKQ6b3lRmamLC4QiftkFNq5PwAUoswGA81BeA1xpd7GvqsbUxVnhYImkWu5DnSc+ea4v9mE10wYAAIDEKFFjUWIzGCNFgWu3YGW2Ciq3aVUh30rXqqe5WydfaKa4BiSJ/+t3ROdlzOMNWueISqrwlhfVmrrAQChSJulpthpwH8psAJD6Bka61DX4PuU1wL3qJFUU+6qMPBHcCgf9sotsnAjuIJPtT8kaPUoQAABAYpSosSixGYyRosC1u37zTfL/1/u0eM1iwrgKAy0DOvniUZ0+eExjnUMEAiTRdcuv0/oHbyUIZ2iTVOItLzL2BiwQitRK2slWAy7/XZsyGwCk3n38SJc+7P13nRluIwwAYdnjRVtNXJwVDubKLrJtZ6sdsF+DTX2T3c9wChsAAJAYJWo0SmwGY6QocPWu33yTPvPNIi31LSOMK0RxDUhd6x7a0Je9LJs3/FLbIdkFNiOfdg+EIrmyx4fytDuAX//ufaHMtm5VpjLS0wgEAJJxL095DcDlRSWVFfuq9pm6QCscrJb0OFudwuJT4xMf7vFoaoQsAACAxChRo1FiMxwjRYErQ3nt6gz3juiDZ9+luAakuLnz58r/tTvG5qTNWUAaqXnj5S0vMvbGKxCK+GUX2BhrC+CystLTdNe6xdq0PocyGwAkSNfgMZ3s+w8NjvUQBoBPsqfYV1Vt6uKscLBE9qls3K+moMlTPx21zh3JJAkAAHABo0QNRonNcIwUBaZn1Q6fvA/6KK9dgeHeEXW+0aK2n4U1dLSXQACHWOpbOr5q02oPSaSUqKQKb3lRrakLDIQiFZKeYKsBTEdWepruyM/V5vU5ys6aRyAAMAu6Bo/peM8bGpkYJAwA07Vf9qlsRv7gsMJBv+wiGyeHp5D4+d6+2MnvM1UAAABcxChRw1FiMxwjRYFPtmqHT7eV/a4W5mURxjRQXAPMsHHHbT2ZizKXkkRq3HDJHh9q5FNDF8aH1kjayVYDuBqb8nO0eV2u8hbNJwwAuEaT1oTa+prU0ve2JqbGCQTA1QjLLrIZeQ9rhYO5sots29nqFBC3RmMtf50Zj/E+NAAA+BVGiRqOEpsLMFIU+G2U16aP4hpgnszrF2jjdh9BJN8h2QU2I59iD4Qi+ZL2iafYAcyAtTdk6s71i7R2BVOEAOBKjcWGdaL3sE5Hj1NeAzATorKLbPtMXaAVDlZLepytTvI+9B+OTp55lhGvAADgUowSNRwlNhdgpChgS8/O0LL711FeIoUMtwAAIABJREFUm4aJ0Zg63jiprlc/UPfLEQIBDLRi08roct+NvBGYPE96y4uMfVooEIpslV1g4xoDMKOuz0zXfZ9ZonWrMpWRnkYgAPAJBka61N73jk4NHScMALNhT7GvqtrUxVnhYInsU9m4r02C+OS5vtiH1YwRBQAAl2KUqAtQYnMBRooC0rIH1mrzf/+C5memE8bHoLgGuI//63dE52XM483YxIpKqvCWF9WausBAKFIh6Qm2GsBsykpP0x35udq8PkfZWfMIBAAu0TV4TMd73tDIxCBhAJht+2WfymbkDxwrHPTLLrJxwniCTbY/JWv0KEEAAIBLMUrUBSixuQQjReF22Rvz9Pmn/pAgPoLiGuBu1y2/TusfvJUgEqdN9vhQI4+6DoQiuZJqJO1kqwEk0qb8HPm92VqV5yEMAK41FhtWW9/P1XG2mZGhABItLLvIZuS9rhUO5sousm1nqxOU+WBT32T3M5zCBgAAPopRoi5Aic0lGCkKSA/u/2PGiF7QcbhNp147ru5Xjis2dJ5AABdbvSW/74a1ebwxOPsOyS6wGfl0eiAUyZc9PpSn0wEkDaNGAbgRI0MBpIio7CLbPlMXaIWD1ZIeZ6tnV9waj8ZO/EWOpkYIAwAAXIpRoi5Bic0lGCkKSL7HtmnDDp9r109xDcDlzJ0/V/6v3jE+Z+4cjq+ZPU96y4uMPeI6EIpslV1gYzQtgJSQlZ6mjSuu0z23LWbUKAAjTVoT6jr7S7X0/QcjQwGkmj3FvqpqUxdnhYMlsk9l4/53tv6OY4woAAC4PEaJugQlNhdhpCjczo0jRSmuAZiO3Pzc0VvuW5dJEjMuKqnCW15Ua+oCA6FIhaQn2GoAqWrtDZny5+fIt2YhYQBwvIGRLnUNvq+2gfcIA0Aq2y/7VDYjW7ZWOOiXXWTjJPIZFh/t6Iu11zAtAAAAXA6jRF2CEpuL1BcG+ZARrueGkaIDLQM6+eJRdewPU1wDMG3rHtrQl70smzcKZ06b7PGhRt5UBUKRXEk1knay1QCcICs9TXfk52rz+hxOZwPgKJy6BsChwrKLbEbeE1vhYK7sItt2tnqGxKfGJz7c42GMKAAAuNzvlp7SuJ8Y3IESm4vUFwbzJZ0kCbjZmm98Tp/9dpFx67pYXDt98JjGOofYaABXjLGiM+qQ7AKbkZ8yBkKRfNnjQ3nqHIAjrczJUOG6xVq3KlMZ6WkEAiA17/M5dQ2A80VlF9n2mbpAKxyslvQ4W33tJk/9dNQ6d4QpAQAA4HJ2e0rjNcTgDpTYXKa+MNgkPnCEiy1Yma2H6//IiLVQXAMw0xgrOiOe9JYXVZi6uEAoslV2gS2HrQbgdFnpadq44jr5vdlalUeHG0DyjcWG1XX2qDrONnPqGgCT7Cn2VVWbujgrHOQ++RoxRhQAAHwKr6c03koM7kCJzWUYKQpI9/+4TIvXLHbk1z7cO6KTLx1V27+EKa4BmBUbS27ry1ycyRuHVy4qqcxbXmTsE+aBUITfIwEY6/rMdH3Wm6Pf8V7HuFEACTVpTah3qEWdZ3+hM8NtBALAVPtln8pmZEPXCgfzxYnlVydujcZa/jozHuslCwAAcDmMEnUZSmwuw0hRwHkjRYd7R9T5RovafhbW0FFu5gHMroyF83XblwtG56TN4US2K7iJkl1gazJxcYFQJFdSjaSdbDUAN1h7Q6b8+TmMGwUwq3rPnVTv0Ic6HT2uialxAgHgmnvnYl+VkffOVjjIvfNVmOp9eXxq4AWORQYAAB+HUaIuQ4nNhRgpCrdzwkhRimsAkmmpb+n4qk2reQNxevbLLrAZ+TR5IBTJF0+TA3Ax343Xyb8mW2tX0O0GcO3Ojffr1Nn31T0UYVwoALeKSqoo9lXVmrpAK8w0nOmKn+/ti538PtMAAADAJ2GUqMtQYnOh+sJgmaSnSQJuloojRSdGY+p446Q+/MlbFNcAJB1jRadlj7e8qNrUxQVCka2yC2w5bDUAt8tKT9PGFddpw8qFFNoAXJGx2LC6zh5Vx9lmimsA8GtPFvuqKkxdnBUOcj/9aRgjCgAAPt1+T2m8hBjchRKbC9UXBnMlnSUJuFmqjBS9WFzrevUDdb8cYWMApAzGin6iqOzT1/aZusBAKFIt6XG2GgB+28VC2+Z1ucpbNJ9AAPyWsdiwzgydUMfZZg2O9RAIAFzeIUklxb4qIxu+VjiYL042/1iMEQUAANOwy1MaryUGd6HE5lL1hcF9kraTBNwqmSNFKa4BcArGil5WWHaBrcnExQVCkVxJtfyeCADTc31m+oUT2rK0Ko+/MgE3o7gGAFelTXaRzch7bCsczJVUI2knW/1rjBEFAADTtMhTGudIc5ehxOZSjBQFEj9S9MSB4xTXADgOY0V/w37ZBTYjb5oCoYhfdoGNp8QB4CowchRwn3Pj/To70klxDQCuTVRSRbGvqtbUBVrhYIWkJ9hqMUYUAABMF6NEXYoSm0tdGCnaKimHNOBWq3b4dOdj22b1NToOt+nUa8fV/cpxxYbOEzoAx2Gs6K/s8ZYXVZu6uEAoUiK7wMbvhgAwAy4ttN2U51FGehqhAIY4N96vU2ffV/dQRCMTPBAOADPoyWJfVYWpi7PCwa2yx4u6+r6bMaIAAGCaGCXqUpTYXKy+MFgrjrGGi6VnZ6jkpe/M+J9LcQ2AaVw+VjQq+/S1faYuMBCKVEt6nCsdAGaP78brtGHFQq1e6lF21jwCARym99xJ9Q59qNPR45qYGicQAJg9h2SPFzWyJWyFg/myi2yuPAGdMaIAAGCaop7SeC4xuBMlNherLwyWSHqOJOBmdwa/pFWFq6/5z+lp7tbJF5oprgEwlkvHioZlF9iaTFxcIBTJlX362naucABInJU5Gdq48jqtW5GlvEXzCQRIQWOxYZ0ZOqGB4XadGjpOIACQWG2yi2xG3otb4WCupBq57YABxogCAIDpq/OUxsuIwZ0osblcfWFwUIyNgotdy0jRgZYBnXzxqE4fPKaxziHCBGC0C2NFx+akzVngkiXvl11gM/Lp70Ao4pddYCvg6gaA5Lk4djT/hkytW5XJ2FEgiQZGutQ79KH6R9o1ONZDIACQXFFJFcW+qlpTF2iFgxWSnnDLhk52Pz9mDTYu4NIGAADTsMNTGt9HDO5Eic3l6guDNZIeJQm41ZWOFKW4BsDNcvNzR2+5b12mC5a6x1teVG3q4gKhSInsAhsPMgBAirl4StvqvAValechEGAWcdoaADjCk8W+qgpTF2eFg1tljxc1+v48PtrRF2uvYYwoAACYjjZPaTyfGNyLEpvL1RcG/ZLeJQm42aeNFKW4BgC/tu6hDX3Zy7JNfeMxKvv0NWOf8AmEItWSHudKBoDUl5WepjU3ZMmbt0A35S1g9ChwjSatCfUOtWhgpEN9w+0amRgkFABwhkOyx4sa+YPbCgfzZRfZzDwpPT41PvHhHo+mRriSAQDAdDzpKY1XEIN7UWKD6guDrZJWkwTc6nIjRYd7R9T5RovafhbW0NFeQgKAC+bOnyv/V+8YnzN3jmnHw4RlF9iaTNy3QCiSK/v0te1cxQDgTJeOHl291KPsrHmEAnyCSWtCAyOnNDDcwYhQAHC+NtlFNiPv2a1wMFdSjaSdxv19fOqno9a5I5lcwgAAYJpu95TGm4jBvSixQfWFwWpxIgdc7OJIUYprADA9Bo4V3S+7wGbkU92BUMQvu8BWwNULAOa4PjNda/IytTw3g5PaAFFaAwAXiEqqKPZV1Zq6QCscrJD0hCnrYYwoAAC4QmFPadxPDO5GiQ2qLwzmSzpJEnCzBSuzGRUKAFdg9Zb8vhvW5pnwRuQeb3lRtan7FAhFSmQX2HK4agHAbJeOH126KEOr8jyEAqONxYZ1dqST8aAA4D5PFvuqjB0xZYWDfkmNTr+Pj1vj0diJv8hhjCgAALgCuz2l8RpicDdKbJAk1RcGm8TpHAAAYJrmzp8r3yMF0XkZ85z6pmpUUom3vKjR1D0KhCLV4rRdAHC1tTdkalmuR/lLF2hp7nxGkMLRBka6dHakU+fGenRmpF0TU+OEAgDudUj2eFEjG8wXxos2ysGf2Uy2PyVr9ChXKgAAuBJeT2m8lRjcjRIbJEn1hcEySU+TBAAAmK7rll+n9Q/e6sQvPSy7wGbkzVAgFMmVffradq5SAMClrs9M1425Hi1flKHVF0aQZqSnEQxSzrnxfp0bP6OBkQ5Fx3oYDQoAuJw22UW2JlMXaIWDtZJ2Ou7rHmzqm+x+hjGiAADgSuz3lMZLiAGU2CBJqi8M5ko6SxIAAOBKrNi0Mrrcd6OTTmOrk1ThLS8y8mntQCjil11g44RdAMC0UGxDsl0srA2N9WpovFdnhtsIBQBwJXYV+6pqTV2cFXbWAQTxyXN9sQ+rKbABAIAr/p3OUxqvJQZQYsOv1BcG94kTOwAAwBX6nVJ/3/ys+U54g3K3t7yoxtR9CIQiJbILbDlclQCAa3FpsW3pogxGkWJGTFoTGhr7/9m79+A4y/v++5/1QdyyTCWvHYcmFMkQzsHaJZTUxsEibX5+cgKTdOeeX/tkrN0OdJg8E8Smw2/aaYVo55c+TSJb8EvLhJnYq0khc9dPsAzIqYHEK7C9jXHQysIHLIxWVBgw8lqydVjr4Pv5Y2VwwEdpV7t77fs1k5nG0V66v9/r6mr33s9eV5+ODfVqZGyAHdYAAJnU/PVbvl9ranGnOtb6lD5eNO/f748lfiI31c2KBAAAl2JAUpVlu/20AoTY8KGNy9aulrSJTgAAgEsxb2Gpbvzm54c9szzz8vgN0Ool962ImjoH9U5Xk6QHWY0AgGy69lPzVFE2VwvK5qpycanKy+YQbsMnnA6rpcaOf7i72sDI+xqdSNEcAEA2dUiq+fot3zfyw89THWsrlA6y5e3O6xNHXkpNJH9lsRQBAMAlarZst5Y2QCLEho/ZuGxtv9i9AwAAXKJP3/Lp1B/9cWU+3qjsUDrAljCx7/VOV4WkFkkrWYUAgFw5M9z26QWXyZo7S3+0mM8vTTcyNqiR0eM6NtSrsYkUYTUAQD4YUDrIFje1wFMdayOS1uTbdbknj/SNdf8Lx4gCAICpuNey3RbaAIkQGz5m47K17OIBAACm5Lqv3dD3B1f8QT7dsGyWVLfkvhVGfgu73unyKR1gq2T1AQDyUdncWfpMhfWJgNviBSW6bO4sGlQATqSOamzipI4N9UqSjg69rbGJFMeAAgDyXfDrt3w/YmpxpzrW1krakDcX5E6MjL3141J37AgrDwAAXKoey3araANOI8SG37Nx2VqfpHY6AQAALtXsktny/c9bU57ZnnzYeuWhJfetaDK11/VOV62kJrGDLgCggF1ZfplKS2brigpLpSWzPgy5cUzpzDh97KekD0NqJ0be1+ipk+yoBgAwQfPXb/l+ranFnepY61P6eNGc3xcYf+c/hk+d+O08lhwAAJiCxyzbraMNOI0QGz5h47K1cUnVdAIAAFyqy//wcl3/1RtzeQkDSh8fGjW1x/VOFzvnAgCKxrWfSn8eeno3N0kfht0kcWzpWZzePU2SBlMfaGzi5IfHfUoioAYAKCYdSh8vauQO7ac61lYoHWTL2ec5p068kRx/50kvSw0AAEzREst2E7QBpxFiwydsXLa2TtI6OgEAAKai8ktVfZ+6dnEujhXtUDrAZuQbnnqnq0Lp40NXssoAAPik0zu7SZI1d7b+cMFlv/8aZXHpJx6TjyG4kbFBjYwe/71/S40d/71/Gxkb0PDowIf//YPBHhYAAABnN6B0kC1uaoGnOtZGJK2Z6d/rnkoNjB36QbkmhlhlAABgKjos2/XRBpyJEBs+YeOytRWSjtEJAAAwVUttX19JWclMBtmaJdUtuW+Fkd+urne6fEoH2CpZXQAAZNY/2td6zvLPFZKyeSM1Mfmf39Pa2RgVgXUAALIh+PVbvh8xtbhTHWtrJW2Yyd85lviJ3FQ3KwsAAEz59ZlluxHagDMRYsNZbVy2tkXSPXQCAABMxbyFpbrxm58f9szyzJuBX/fQkvtWNJnay3qnq1ZSk6RyVhYAAJl3jhBbThBiAwAgq5q/fsv3a00t7lTHWp/Sx4tm/f7BxJGXUhPJX3GuOwAAmI4Flu320wacaRYtwDlEaAEAAJiq4aMj6v3d29l+rTkg6S7DA2xNSn+TmgAbAAAAAADTs6a1szHe2tlYYWJxs6rDcUlVkjqy+Xvck0f6CLABAIBpaibAhrO+pqUFOJtALNyi9AfDAAAAU/J+5/vW8feO92Vp+A5JviX3rYia2Lt6p6ui3umKSnqQlQQAAAAAQMZUS0q0djb6TCxuVnW4f1Z12CepOSu/wJ1Ijb39k0UsIwAAME0ttABnfT1LC3AeEVoAAACm49BLXYvGT45nOhjfLKlmyX0rEib2rN7p8kmKi6PEAAAAAADIhnJJ7a2djbWmFjirOlwrKagMb1Yw/t8RSxNDrCAAADAdPZbtEmLD2V/H0gKcR4QWAACA6ZgYndDB/9yfyaMwH1py34raJfetMHKb6Xqnq1ZSVFIlqwcAAAAAgKza0NrZGDG1uFnV4YikGkk9mRjvVH+879TwPlYNAACYLgJsOPdrWFqAcwnEwnGlj+oCAACYsuGjI3q38/B0v/k7IMm/5L4VTab2qd7papK0QelvhAMAAAAAgOxb09rZGG/tbKwwsbhZ1eG4JJ+ktumM444fT46/93OOEQUAAJnQRAtwztevtAAXEKEFAABgut55tbd8ODncN8WHd0iqWnLfiriJval3uirqna6opAdZKQAAAAAAzLhqSYnWzsYaE4ubVR3un1UdrpH02JQGcCdGxnue8LJMAABABrRZtpugDTjna1dagAuI0AIAAJAJb2zZv8idcFOX+LDmJfet8Bl8fKhPUlzSSlYIAAAAAAA5Uy5pW2tnY52pBc6qDtdJCiq92/1FGz/8S9cdO8IKAQAAmRChBTjva1ZagPMJxML9kprpBAAAmK6J0QkdfOGAdQkPCS65b0Wtqf2od7pqJUUlVbI6AAAAAADIC+taOxsjBh8vGpFUI6nnYn7+VH+879SJ385jWQAAgAwYkNRCG3De16u0ABeBJxIAAJARJ949oXc7D1/oG78DkvxL7lsRMbUP9U5XRNIGpb/pDQAAAAAA8scaSdHWzsYqE4ubVR2OS/JJajvfz7njJ/rGP3hmEcsBAABkSItlu/20Aed9rUoLcCGBWLhFF/mtHAAAgAt559Xe8uHkcN85/ucOSVVL7lsRN7H2eqerot7piit9QxwAAAAAAOSnaknx1s7GGhOLm1Ud7p9VHa6R9NhZf8A9NTze27xIE0OsBAAAkCkRWoALvk6lBeAJBQAAzLQ3tuxf5E64qY/9c/OS+1b4lty3wshv4tQ7XT5JCaVvhAMAAAAAgPxWLmlba2djnakFzqoO10kKKr0r/ofG32/1uKluVgAAAMiUHst2o7QBF3x9SgtwkSK0AAAAZMrE6IQOvnDAOuOfgkvuW1Frar31TletpHZxfCgAAAAAAIVmXWtnY6S1s7HCxOJmVYcjkmo0eSLPqRNvJE/1R0uZdgAAkEFNtAAX9dqUFuBiBGLhhKQ2OgEAADLlxLsn9E5772FJ/iX3rYiYWme90xWRtIEZBwAAAACgYK2RFG3tbKwysbhZ1eG4JJ978siO8Xee9DLdAAAgwyK0ABf1upQWgCcWAACQIx3vth++ecl9K+ImFlfvdFXUO11xpW90AwAAAACAwlYtKd7a2VhjYnGzqsP9s2//f1dIeoypBgAAGbTZst1+2oCLek1KC3CxArFwRNIAnQAAABnQHIiFfYFY2Mg3LvVOl09SQukb3AAAAAAAwAzlkra1djbWmVqgZbt1koLi8yAAAJAZEVqAi0WIDTzBAACAmRYMxMK1phZX73TVSmpX+sY2AAAAAAAwz7rWzsZIa2djhYnFWbYbkVQjqYepBgAA09Bj2W4LbcDFIsSGSxWhBQAAYIoGJPknd3c1Ur3TFZG0gakGAAAAAMB4ayRFWzsbq0wszrLduCSfpDamGgAATFGEFuBSEGLDJQnEwnFJHXQCAABcog5JVZOvJYxT73RV1DtdcaVvYAMAAAAAgOJQLSne2tlYY2Jxlu32W7ZbI+kxphoAAExBhBbgUhBiw1Q00QIAAHAJmgOxsC8QC/ebWFy90+WTlFD6xjUAAAAAACgu5ZK2tXY21plaoGW7dZLuVXqXfQAAgIux2bLdBG3ApSDEhqlo4Y0KAAC4CAOSgoFYuNbUAuudrlpJ7UrfsAYAAAAAAMVrXWtnY6S1s7HCxOIs222RVCNO6wEAABcnQgtwqQix4ZJN7qLSQicAAMB59EiqCcTCxr5JqXe6IpI2MNUAAAAAAGDSGknR1s7GKhOLs2w3rnSQbTNTDQAAzmNgMgAPXBJCbJgqjhQFAADn0ibJF4iF4yYWV+90VdQ7XXGlb0wDAAAAAACcqVpSvLWzcbWJxVm222/Z7mpJjzLVAADgHCK0AFNBiA1TMvmhNFtGAwCAj3ssEAvXTO7capx6p8snKaH0DWkAAAAAAICzKZe0qbWzscHUAi3bbZB0r6QBphsAAHwMmyJhSgixgSceAACQCQOSgoFYuM7UAuudrjpJ7UrfiAYAAAAAALiQR1o7G1taOxsrTCxu8piwGrHpAQAA+EibZbsJ2oCpIMSG6WgR37ABAABSj6SaQCwcMbG4yeNDI5LWMdUAAAAAAOAS3SMp2trZ6DOxOMt240oH2TYz1QAAQBwlimkgxIYpmzwmrIVOAABQ1Nok+SaPGjdOvdNVJSkqaQ1TDSAflbijKhvroxEAAABAfqtWOsi22sTiLNvtt2x3taRHmWoAAIragGW7EdqAqSLEhuniSFEAAIrXY4FYuGYy2G6ceqerRlJc6RvNAJCXku2ONv2kTn07nlBZ6h0aAgAAAOSvckmbWjsbG0wt0LLdBkn3ilN8AAAoVuRHMC2E2DAtk7uudNAJAACKyoCkYCAWrjO1wHqnq07SNqVvMANAXrrsyG7tbNsqSXpt1w5teuJ/EWYDAAAA8t8jrZ2NLa2djRUmFmfZbovSx4vy2REAAMUnQgswHYTYkAmkaQEAKB49kmoCsbCRb0Tqna6KeqcrImkdUw0gn5WN9em5pz75VowwGwAAAFAQ7lH6eFGficVZthtXOsi2makGAKBobLZsN0EbMB2E2JAJLWJraAAAikGbJN/kTqzGqXe6qiRFJa1hqgHksxJ3VL977vHz/gxhNgAAACDvVSsdZFttYnGW7fZbtrta0qNMNQAARSFCCzBdhNgwbYFYuJ8nJAAAjPdYIBaumfy7b5x6p6tGUlzpG8gAkNcO7/yZ3u5566J+9sww27xje2keAAAAkF/KJW1q7WxsMLVAy3YbJN0rNkMAAMBkPZNHigPTQogNmcKRogAAmGlAUjAQC9eZWmC901UnaZvSN44BIK/N6X1Zr+3accmPe23XDrVE/lkHnqknzAYAAADkn0daOxtbWjsbK0wsbvJD7RpJHUw1AABGitACZAIhNmREIBZOKH3EGAAAMEePpJpALGzkm496p6ui3umKSFrHVAMoBGWpd7Rl45PTGuPtnrcIswEAAAD56R6ljxf1mVicZbtxpYNsm5lqAACME6EFyARCbOCJCQAAnE2bJF8gFo6bWFy901UlKSppDVMNoBCUuKNqc36YsfHODLNZ4ydoMAAAAJAfqpUOsq02sTjLdvst210t6VGmGgAAYzRbtpugDcgEQmzImMldWgboBAAABe+xQCxcE4iF+00srt7pqpEUV/rGMAAUhDdfaFIyeTTj415Zda1Scy6nwQAAAED+KJe0qbWzscHUAi3bbZB0l/hMCQAAE0RoATKFEBsyrYkWAABQsAYk3RuIhetMLbDe6aqTtE3pG8IAUBDcQ1t1YN+ejI97w01L5fXbNBgAAADIT4+0dja2tHY2VphYnGW7UUk+SR1MNQAABatn8m86kBGE2JBpEVoAAEBB6pBUE4iFW0wsrt7pqqh3uiKS1jHVAApJ2eAhvfjszzM+rte7UDd+OaRRTwlNBgAAAPLXPUofL+ozsbjJo8dqJDUz1QAAFCQ2OUJGEWJDRgVi4YSkzXQCAICCslnpAFvcxOLqna4qSVFJa5hqAIXEGj+htl8+npWx77z7fg3NXUSTAQAAgPxXrXSQrdbI9z2222/Zbq2kh5hqAAAKyoDY5AgZRogN2UDaFgCAwvFoIBZeHYiF+00srt7pqpEUV/qGLwAUjBJ3VAd//YSSyaMZH7tm1bc0vOBmmgwAAAAUjnJJG1o7G439/MWy3SZJdyn9gTgAAMh/LZbt9tMGZBIhNmRcIBaOSuqhEwAA5LUBSfcGYuEGUwusd7oaJG1T+kYvABSUwf3P68C+PRkf94ablmr+jd+gwQAAAEBherC1szHa2tlYYWJxlu1GJfkkdTDVAADkPTY3QsYRYgNPWAAAFJ8OpY8PbTGxOE/QqfD8P8++MHHKfZipBlCI5h3bq+jWZzI+rte7UNf96QMa9ZTQZAAAAKBwrdx7OLYn5Ph9JhZn2W5CUo2kZqYaAIC81WbZbpw2INMIsSFbImLLZwAA8tFmpQNsRr658AQdn6Sohka+8q/t3S7TDaDQlI316eVnn8zK2Cu//T2l5lxOkwEAAIAC9v7xRPJA/6E/khQNOf5aE2u0bLffst1aSQ8x4wAA5KUILUA2EGJDVgRi4X5JLXQCAIC88mggFl49+XfaOJ6gs1pSVFK1JA180D9vQ0fPCNMOoFCUuKPa/5v1SiaPZnzsr9z9HQ3Nv4YmAwAAAAVsMHW0b3vvdu/kfy2XtCHk+I09Gcey3SZJd4lNEwAAyCcDlu1GaAOygRAbsqmBFgAAkB9vKCTdG4iFjf3b7Ak6DZI2KX0D90O97x4tff3wsSRLAEAhSLY7OrBvT8bHveGmpfJcs4oFzfv6AAAgAElEQVQGAwAAAAUsNTbYF028tOgs/9ODIccfDTn+ChPrtmw3KsknqYNVAABAXmiiBcgWQmzImkAsnJDURicAAMipDqWPDzVyh1RP0KnwBJ0WSY+c62c27en2HhkY7mMpAMhnlx3ZrZ1tWzM+rte7UJ/7H3U0GAAAAChgrjsx8l9vb1t08tTYuX5kpaR4yPH7TKzfst2EpBpJzawGAAByLkILkC2E2MATGAAA5tqsdIAtbmJxnqDjU/r40Hsu9LM/fbVr0cDwKDuyAchLZWN9eu6p7HyBcaX9sEY9JTQZAAAAKGBtb20pPXrygidqVkqKhhx/rYk9sGy337LdWkkPsSIAAMiZ5slwOZAVhNiQVYFYOCKph04AADDjHg3EwqsDsXC/icV5gs5qpQNs1Rf1gPEJPb7roHfilDvC0gCQT0rcUbU9/U9ZGftrgfs1ZH2WJgMAAAAFrPPwjpGLCLCdVi5pQ8jxG3vMl2W7TZLukjTA6gAAYMZFaAGyiRAbeCIDAMAsA5LuDcTCDaYW6Ak6DZI2KX1j9uKlRvWDnQdKCbIByCeHd/5MyeTRjI976+13aPzKO2kwAAAAUMC6+/YMHOzvLp3CQx8MOf5oyPFXmNgXy3ajknySOlglAADMmI7Jv8FA1hBiw0xoogUAAMzMGwiljw9tMbE4T9Cp8ASdFkmPTHmQwRH9a3u3y1IBkA/m9L6s13btyPi4V1Verc8s/ysaDAAAABSw948nkq8d2VM+jSFWSoqHHL/PxP5MHmVWI6mZ1QIAwIwg94GsI8SGrJs8xow3EQAAZNdmpQNscROL8wQdn9LHh94z3bEGPuift6Gjh93YAORUWeodbdn4ZFbG/sI3v6dRTwlNBgAAAArUYOpo3/be7d4MDFUpKRpy/LUm9smy3X7LdmslPcSqAQAgqwYs243QBmQbITbMFFK5AABkz6OBWHj1ZHDcOJ6gs1rpAFt1psbsffdo6euHjyVZOgBywRo/oTbnh1kZ+5t/WaehuYtoMgAAAFCgUmMnktHES5l8UV8uaUPI8Rv7OY1lu02S/JIGWEEAAGQFeQ/MCEJsmBGTu8K00QkAADJqQNJdgVi4wdQCPUGnQdImpW+4ZtSmPd1egmwAcuHgr59QMnk04+MuX7lKJxffRoMBAACAAuW6EyMvHdriPXlqLBvDPxhy/NGQ468wsXeW7cYlVUnqYCUBAJBxEVqAmUCIDTyxAQBQmDok+QKxcNTE4jxBp8ITdFokPZLN37Np39vegeFRgmwAZox7aKsO7NuT8XGvqrxaXr9NgwEAAIBCfa/gToy0vbWlNEsBttNWSoqHHL/PxB5OHi/qk9TMigIAIGOaLdtN0AbMBEJsmDGBWDgiqYdOAAAw/TcMkmoCsbCRbxo8Qcen9PGh92T9l41P6PGd+73HR0b7WFYAsq1s8JBefPbnGR/X612oL3zzexr1lNBkAAAAoEDFEi+WHj05I6dhVkqKhhx/ram9tGy3VlKQVQUAQEZEaAFmCiE28AQHAEBheSgQC9cGYuF+E4vzBJ3VSgfYqmfsl45P6LHfHVo0ccodYXkByJaysT61/fLxrIx95933a2juIpoMAAAAFKjOwztG3h2Z0e/XlUvaEHL8EVN7atluRJJf0gArDACAKeuwbDdKGzBTCLFhpjXxhgEAgCkZkHRXIBZuMrVAT9BpkrRJ6RupM2twRD/YeaCUIBuAbChxR7X/N+uVTB7N+Ng1q76l4QU302QAAACgQO1/79XUwf7u0hz9+jUhxx8POf4KE3tr2W5cUpWkDlYaAABT0kQLMJMIsWFGTe4a00InAAC4JB2SfIFYOGpicZ6gU+EJOlFJD+b0QgZH9K/t3S7LDUDGn172P68D+/ZkfNwbblqq+Td+gwYDAJBBqWNzNfjenE/8J3VsLs0BkHHvH08k9yXfsHJ8GdWSEiHH7zOxx5bt9lu265PUzIoDAOCSDEzubArMmDm0ADnQIGkNbQAA4KI0S6oz+PhQn9IB98q8eEf2Qf+8DR09I8HqylKWHoBMmHdsr17Y+kzGx/V6F+rGL4c05CmhyQAATJE7Nlv970iHuwf0RmdCezv3XfAxN99yk66/pUrX+BbIWjBGEwFM2fvHE8ntvdu9eXI55ZLaQ44/uN5uj5jYb8t2a1OOJyppA6sPAICLwi5smHEe12WzCcy8jcvWRiWtpBMAAJzXQ4YfH1o7+SaoPN+u7fNXLU7de9OVFksQwHSUjfWp7el/ysoxovfe96iG5l9Dk4EM+Ef7Wk++XEtrZ2NU3C8Bsu5YYrZe39Wr6IuvTGucqiWVWvXtP9Hi67nHDuDSpMZOJF86tMV78lRehmGb19vttcb23vH4JEWVh/ejAADIMwss2+2nDZhJ7MSGXGmQtI02AABwVgOSVpt6fKgkeYJOk3J9fOh5vP72EevairLk5z+zwMtyBDAVJe6ofvfc41kJsH3l7u8QYAMA4BK5Y7P133vH1LblVSW6ezIyZqK7Rz/9cY+qllTqG3+xXAuqJmg0gAvK8wCbJK2ZPFq0Zr3dbtwH15btxlOOp0rpIFs1KxIAgLNqJsCGXGAnNuTMxmVrE8qTo8MAAMgjHUoH2BJGvvgMOhVKHx9aEDuM3Lt0CUE2AFMy+NrPtbNta8bHveGmpbpq1cM0GMggdmIDzPdm7KS2tryiZDKZ1d9T85UvacW9V8ozlzAbgLNz3YlU6xv/n5XHAbYzDSgdZIubOh8pxxORtIaVCQDAJyyxbDdBGzDTZtEC5FADLQAA4Pc0S6oxOMDmkxRXAX0wu2lPt/fIwHAfSxPApbjsyO6sBNi83oW67k8foMEAAFykwffm6Oc/+K1+sX5z1gNskhR98RX9299vVerYXJoP4BNcd2Kk7a0thRJgk9LHbbaHHH+tqXNi2W6tpCCrEwCA39NGgA25QogNudSi9Dd5AACA9FAgFq4NxMJGbs/sCTq1Sh/TUHC7sP701a5FA8OjSZYogItRNtan555qysrYK+2HlZpzOU0GAOAC3LHZ2v18Uuv+4emMHR16sZLJpH708FM68oaHiQDw0fNSOsBWevRkQX4ksiHk+COmzo1luxFJfvF5FQAApzXRAuQKITbkzOSH9DwBAgCK3YCkuwKxsLF/Ez1Bp0nSBqW/wVt4xif0+M79XoJsAC6kxB1V29P/lJWxvxa4X0PWZ2kyAAAXkDo2V//+o5361eaXcnodP/2xQ5ANwId+19vmFmiA7bQ1IccfDzn+ChPnx7LduKQqSR2sVgBAkeuxbLeFNiBXCLEh1yK0AABQxDok+QKxcNTE4jxBp8ITdKKSHiz4YsYn9Piug96JU+4IyxbAuRze+TMlk0czPu6tt9+h8SvvpMEAAFzAkTc8+tHDT8347mvnQpANgCR1Ht4x0nPi8DwDSqmWlAg5fp+J82TZbr9luz5JzaxaAEARa6AFyCVCbMipQCyc4A0BAKBINUuqmfxbaBxP0PFJiktaaUxRqVH9YOeBUoJsAM5mTu/Lem3XjoyP6/Uu1GeW/xUNBgDgAt6MndRPf+zk3XX99MeOBt+bwwQBRarz8I6Rg/3dpQaVVC6pPeT4a02dM8t2ayUFxfGiAIDiMyCJXdiQU4TYkA84UhQAUGweCsTCtZNHaxvHE3RqJUUlVRpX3OAIQTYAn1CWekdbNj6ZlbFX/sU/aNRTQpMBADiP3c8n9Yv1m/P2+prX/afGhwiyAcWmu2/PgGEBtjNtCDn+iKlzZ9luRFKNpB5WMgCgiDRZtttPG5BLhNiQc4FYOC6pjU4AAIrAgCR/IBY2NsDtCTpNkjYo/c1cM00G2VjOACTJGj+hNueHWRn7m39Zp6G5i2gyAADnsfv5pH61+aW8vsZkMqlnfxZnsoAi8v7xRPK1I3vKDS9zTcjxx0OOv8LI93q2G5fkE59fAQCKB5sPIecIsSFfNNACAIDhOiRVTYa3jeMJOhWeoBOV9GBRzObgiDZ09LAbGwAd/PUTSiaPZnzc5StX6eTi22gwAADnUQgBttP2du7T3m2DTBpQBN4/nkhu793uLZJyqyUlQo7fZ2Jxlu32W7ZbI+kxVjYAwHDN7MKGfECIDXkhEAtHxbbMAACDX/wHYmGfwceH+iTFJa0spkntffdoKUE2oLi5h7bqwL49GR/3qsqr5fXbNBgAgPM48oanYAJspz3z9BYNvsexooDJiizAdlq5pPaQ468ztUDLduskBZU+ZQEAABM10ALkA0Js4IkRAIDsCgZi4VpTi/MEnVpJUUmVxTi5BNmA4lU2eEgvPvvzjI/r9S7UF775PY16SmgyAADnMPjeHP30x05BXvum9TuYQMBQqbETxRhgO9O6kOOPGHy8aERSjdiQAQBgnjbLdhO0AfmAEBvyRiAWjohvsQAAzDEgyT/5981InqATkbRB6W/cFq3ed4+WbtrXm2LJA8WjbKxPbb98PCtj33n3/Rqau4gmAwBwDuNDc9S87j+zNr7X69Xty29T1ZLsfE8n0d2jN2MnmUjAMKmxE8mXDm3x0gmtkRQNOf4qE4uzbDcuySepjakGABikgRYgX7B3OfJNk6RHaAMAoMB1SKox+PjQCqV3X6tmqtNef/uIdW1FWfLzn1nADWvAcCXuqPb/Zr2SyaMZH7tm1bc0vOBmmgwAwHn8+j8OKplMZmy8qiWVunXZzaq8sULzrxg/43+5WtIXdSwxW4de/yCjR5dubXlF19y2Sp65E0woYIDTAbaTp8ZoRlq1pHjI8a9eb7dHTSvOst1+STUpx9Mk6UGmGwBQ4Dos243SBuQLdmJDvmkSu7EBAApbcyAW9hkcYPNJSogA2yds2tPtff3wsSSdAMw2uP95Hdi3J+Pj3nDTUs2/8Rs0GACA83gzdlK7du7OyFhVSyr1139j6zt/90XdfNf8jwXYPrKgakK3fcOrv236C92+/LaM/O5kMqnfbf2ACQUMQIDtnMolbQs5/jpTC7Rst05SUHymBQAobE20APmEEBvyyuQH/hE6AQAoUMFALFxranGeoFMrqV1Ffnzo+RBkA8w279heRbc+k/Fxvd6FuvHLIY16SmgyAADnMD40R79YvzkDf3e9WvPdP9d3/u6LWny9e9GPm1M2rlXBq7Xmu3+ekXp+tfkljQ9xUApQyAiwXZR1IccfCTn+ChOLs2w3IqlGUg9TDQAoQD2Tf8uAvEGIDfmItC8AoNAMSPIHYmFjX+x7gk5E0gam+sIIsgFmKhvr08vPPpmVse+8+34NzV2U8xqt8RO67Mhuzel9WSXuKJMOAMgrv/6Pg9Me4+ZbbtJf1/9fuso39dviV/lm6a//xs5ITfFtR5hYoEC57sTIy90vEmC7OGskRUOOv8rE4izbjUvySWpjqgEABYZcBvIOITbknUAsnJDUTCcAAAWiQ1JVIBaOm1icJ+hUeIJOXOkbjrhIBNkAs5S4o/rdc48rmTya8bG/cvd3NLzg5pzWN+/YXg2+9nM9+38e0HNPNWnLxif1fFNIo/uekTV+ggUAAMi5Y4nZ0z5G9OZbbtK9D1RrTtn4tK9n8fVuRnZkYzc2oDC57sRI21tbSk+MD9OMi1ctKR5y/DUmFmfZbr9luzWSHmOqAQAFYkCckIc8RIgN+YrULwCgEDQHYmHf5HHYxvEEHZ+khNI3GnGJNu3p9h4ZGO6jE0DhS7Y7ervnrYyPe8NNS+W5ZlVOaiob69Povme0u/lBtUT+WTvbtn7iZ6Jbn9Gz/+cBwmwAgJx7/umd03r86QCbZ+5Exq7pKt8s1XzlS9MeJ7FniAkGCsjpANvRkwM049KVS9oWcvx1phZo2W6dpKDSwQAAAPJZk2W7/bQB+YYQG/LS5G42bL0MAMhnwUAsXGtqcZ6gUyupXekbjJiin77atWhgeJQd2YACdtmR3WcNeE2X17tQ1/3pAzNay+njQg88U69NP6lTdOszF7W7HGE2AEAuHXnDo0R3z5Qfn40A22kr7r1SXq93WmPEtsWZZKBAEGDLmHUhxx8JOf4KE4uzbDciqUZSD1MNAMhjbCqEvESIDfmsgRYAAPLQgCR/IBaOmFqgJ+hEJG1gqjNgfEKP79zvJcgGFKaysT4991R27ues/Pb3lJpz+YzU8fHjQqe6qxxhNgBALmz95X9N+bFer1df+44/KwE2SfLMnVAg9JVpjZHo7tGxxGwmGshzBNgybo2kaMjxV5lYnGW7cUk+sVkDACA/NbMLG/IVITbkrUAsHJXUQScAAHmkQ1LV5I6hxvEEnQpP0IkrfSMRmUKQDShIJe6o2p7+p6yM/bXA/Rqaf01Wr/9ijgudKsJsAICZMt1d2L75P78sa8FYVq9x8fWuqpZUTmuMQ69/wGQDeYwAW9ZUS4qHHH+NicVZtttv2W6NpMeYagBAnmmgBchXhNiQ79jGEgCQL5oDsbAvEAsb+e0UT9DxSUoofQMRmUaQDSg4h3f+7KKO2rxUt95+h8avvDMr1zzV40Kn6swwW1nqHRYNACDjtm/tnPJjb19+m67yzczt71Xf/pNpPf63r7zGZAN5igBb1pVL2hZy/HWmFmjZbp2ke5U+3QEAgFxrtmw3QRuQrwixIa9NHtXWQycAADk0ICkYiIVrTS3QE3RqJbUrfeMQ2UKQDSgYc3pf1mu7dmR8XK93oT6z/K8yPm6mjgudqujWZ7Tpif+lvh1PEGYDAGRM6thc7e3cN+XH3/HV62bsWqe7G1symVTq2FwmHcgzBNhm1LqQ44+EHH+FicVZttsiqUacPgQAyL0ILUA+I8SGQtBACwAAOdIjqWYyVG0kT9CJSNrAVM8QgmxA3itLvaMtG5/Mytgr7Yc16inJzHVm8bjQqXpt1w7CbACAjHl9x/tTfuzty2/T/CvGZ/R6l93lm9bjew8MMulAHiHAlhNrJEVDjr/KxOIs240rHWTbzFQDAHKkzbLdKG1APiPEhrw3GRzgnSIAYMZfzEvyBWLhuInFeYJOhSfoxJW+QYiZRJANyFvW+Am1OT/Mytjf/Ms6DVmfnfb1zel9ecaOC52q13bt0LG3fitr/ASLCgAwZdM5YvP2u66d8eutWlo2rccfOkAAHMgXBNhyqlpSPOT4a4x8z2m7/Zbtrpb0KFMNAMiBBlqAfDeHFqBANEl6hDYAAGbIY4FYuM7U4jxBxycpKo4PzZ3JINv3lt+YLJ9X4qUhQH44+OsnshIKW75ylU4uvm1Kjy1xRzWnv0tv78vOEaeZdMNNS3XD7V/XeMW1GvWUKMWSAgBM0bHEbCWTU/vOR9WSSi2ompjxa55TNq6bb7lpykeg7tq5W6uCVzP5QI4RYMsL5ZK2hRz/o+vt9gYTC7RstyHleOJKH+nG/TkAwEzoYBc2FAJCbCgUTZLqeDEPAMiyAUl1hh8fWidpHVOdBwiyAXnFPbRVB/btyfi4V1VeLa/f1uglPq4s9Y6OvfVb7X61LS93Wzuzvuur71Bp5XKl5lyuYZYSACADDr3+wZQfe+uym3N23Uv/+Noph9gkKXVsrqwFYywAIFfvCQiw5ZtHQo7fJ6l2vd3eb1pxlu22pBxPjdJBtmqmGwCQZU20AIWAEBsKQiAW7t+4bC27sQEAsqlH0mqTjw+dfJPC8aH5hCAbkBfmHdurlmd/npWxv/DN72nIU3JRP2uNn9D4e+16fddLervnrbzuWc2qb2nBVdUamn+NJLHrGgAgo/bv6ZryYytvrJA0npPrvmLJ9I4UPX5kXNYC5h/IBQJseeseSdGQ469db7cbd8/Ost34GUG2e5huAECW9Fi2G6ENKASE2FBIIiLEBgDIjjalA2z9JhbnCTpVklrEtzrzE0E2IKfKxvrU9uyTWRl7de3famjuovP+TCEfFzrE8gEAZEHq2Fwlunum9Fiv16v5V+QmwHbkDY/adx6c1hjHkykt1mUsAmCGEWDLe9X6KMjWYlpxlu32S1qdcjwN4jMwAEB2NNACFApCbCgYgVg4sXHZ2maxgwwAILMeC8TCdaYW5wk6NUoH2DiSO58RZANyosQd1f7frM/KcZ01q76l4QXnPs6sUI4L9XoX6gsrvqb5V31BQ3MXcVwoACDrjvScnPJjP3fD1TN/vW94tPWX/zXl4N2ZDh14R59bdjWLAJhBBNgKRrmkTSHH/+h6u73BxAIt221IOZ640hs6cB8PAJAp7MKGgkKIDYWmQYTYAACZMSCpLhALG/vi3RN06iStY6oLBEE2YMYN7n9eB/btyfi4N9y0VPNv/IZGP/bvhXRc6PKVq/Tp65Z/eFwou64BAGbKkd6pb5B9zQ2fnZFrdMdm64O3TmUsvAYgNwiwFaRHQo7fJ6l2vd1u3IkKlu22nHG8KCcqAAAyIUILUEgIsaGgsBsbACBDepQ+PjRuYnGeoFMhqYm/lwWIIBswY+Yd26sXtj6T8XG93oW68cshDXlKJBXecaHX+r8s91NLOS4UAJAzb791eMqPXfiH8yRNZO3a3LHZOrR7WFtbXlEymcz4+Lt27taqIDuxATOBAFtBu0cfHS9q3L09y3bjZwTZ7mG6AQDTMKD0Z0VAwSDEhkLUID6UBwBMXZvSAbZ+E4vzBJ0qpY8P5duahYogG5B1ZWN92hT556yMfefd92to7qKCPS70JMsDAJBjezv3Tfmxcy1Pdl6iD81RYs9Q1sJrAGYWATYjVOujIFuLacVZttsvaXXK8TRIeoTpBgBMUdPk3xSgYBBiQ8GZ3I1ts/gGCgDg0j0WiIXrTC3OE3RqlA6wlTPVBY4gG5A1Je6ofvfc41kZ+6rKqzWU7NUb2xyOCwUAYAoG35ve7eqyhW5mX5YPzVF82xH9avNLWa/d6/Vq1eovsQiALCPAZpRySZtCjv/R9XZ7g4kFWrbbkHI8caV3ZeN+HwDgUrALGwoSITYUqiYRYgMAXNqL9bpALBwxtUBP0KmTtI6pNsj4hB5/+XXvvUuXJD//mQUE2YAMSbZnL2D2ds9beR1e47hQAEC+G0tNL4TmmZuZo0RzEV675rZ5Gbt+AGdHgM1Yj4Qcv09S7Xq73bjdZizbbTnjeFFOXgAAXCx2YUNBIsSGghSIhaMbl61tk7SSbgAALqBH6eND4yYW5wk6FUqHuzlq21Cb9nR7JRFkAzLgsiO79ULb1qKq2etdqKV/vFILrr2T40IBAHnv6LvDOf39g+/N0Y5fHdSunbuz/ruqllRq1bf/RJ+6etZkeI0AG5BNBNiMd48+Ol7UuHuAlu3GzwiyscEDAOBiRGgBChEhNhSyBknbaAMA4DzalA6wGfltE0/QqVL6+FC+hWk4gmzA9JWl3tGmp4pnB/3lK1dp8ZJbNbzgZkkcFwoAwPnkIry2+HpXkivCa0D2pcZOJF/uftF7YnyYZpitWh8F2VpMK25yN53VKcfTIOkRphsAcB7Nlu0maAMKESE2FCx2YwMAXMBjgVi4ztTiPEGnRukAWzlTXRwIsgFTV+KOqs35ofF1XlV5tapX3C2P93ql5lwuPqIDABSad/87OaO/78gbHm3f2qm9nfuy/rtuX36b/MuvOSO8BmAmpMZOJF86tMV78tQYzSgO5ZI2hRz/o+vt9gYTC7RstyHleKLiviAA4NwaaAEKFSE2mPAEzG5sAIAzDUiqDcTCLaYW6Ak6dZLWMdXFhyAbMDWHd/5MyeRRI2vjuFAAgEmGh0Zm5PccecOjrb/8LyW6e7L+u25ffpvu+Op1mn/FuAivATOLAFtReyTk+H2Satfb7cad0GDZbjTleHzihAYAwCexCxsKGiE2FDR2YwMAfEyH0gG2uInFeYJOhaQmSWuY6uK1aU+399jI2Ptfumbxp+kGcBFventf1mu7dhhXF8eFAgBwadyx2frvvWNq2/LqjITXar7yJfnv/KPJ8No4EwDMMAJskHSPPjpe1Lh7hZbtJlKOp0bcKwQA/L4GWoBCRogNJoiIEBsAQNqsdICt38TiPEGnSny7EpOiXb2ffnNwZCRYXVlKN4BzKxs8pE0bnzSmHo4LBQDg/Nyx2fLMnfjEvx3aPaytLa8omcz+caVfvefP5LtrseaUEV4DcoUAG85QrY+CbMad2mDZbr+k2pTjiYtTGwAA7MIGAxBiQ8ELxMKRjcvWNkiqpBsAULQeDcTCDaYW5wk6NUoH2MqZapzW++7R0g0SQTbgHKzxE2r75ePG1LO69m81vOBmjgsFAOA8ho56NP+K9P89PjRHiT1DhNeAIvP+8URye+92L53AGcolbQo5/sfW2+11Rr7/td2mySAb9w8BoLg10AIUOkJsMOkJeQNtAICiM6D07mstphboCToNkh5hqnE2BNmAczv46yeUTB415+9BaQWTCgDABYylXI0PzVF82xH9avNLWf99Xq9Xq1Z/SdfcNm9yBzjCa0AuEWDDBTwYcvw+SavX2+3GneRg2W405Xh84iQHAChW7MIGIxBigxHYjQ0AilKH0gG2uInFeYJOhdJHZt/DVON8et89Wvr4+MTwd/1LPLNneQizAZLcQ1t1YN8eo2oasj7LxAIAcAHPP71Tie6erP+eT4bXJmg+kGME2HCRVkqKhxz/6vV2u3H3FC3bTaQcT42kJklrmG4AKCpNtAAmmEULYJAGWgAARWOzpBqDA2w+SVERYMNFGvigf94Pdh4onTjljtANFLt5x/bqxWd/TiMAAChC2Q6wVS2p1F//ja3v/suf6XPLLpsMsAHIte6+PQME2HAJKiVFQ46/1sTiLNvtt2y3VtJDTDUAFI02y3bjtAEmIMQGYwRi4YikHjoBAMZ7NBALrw7Ewv0mFucJOquVDrCx7T8uzeCICLKh2JWN9enlZ5/Mq2vyeheqZtW3mBwAAArY6fDad/7ui1p8vUtDgDzSeXjHyGtH9pTTCVyickkbQo7f2F1rLNttknSXpAGmGwCM10ALYAqOE4WJT9AbaAMAGGlA6eNDW0wt0BN0GiQ9wlRjyiaDbA9+4Zq+PygtWURDUEHp2TsAACAASURBVExK3FHt/816JZNHc34tXu9CLf3jlVpwVbWG5l+T/setzzBJAABcwDU3fFa7du7Om+u5ffltuv2ua7WgakIS4TUg33Qe3jFysL+7lE5gGh4MOX6fpNXr7XbjvjBr2W405Xh8klrEF2YBwFRtlu1GaQNMQYgNRgnEwpGNy9Y2KL0dNADAHB1KB9hMPT60QlJEHB+KTBgc0WM79i/63vIbk+XzSjhOBcWz9Pc/rwP79uT0GpavXKXFS27V8IKbJUlDGRr3hpuWMsEAAMyg25ffpju+ep3mXzEuiSNDgXzjuhMjv+ttc3tOHJ5HN5ABKyXFQ45/9Xq73bh7j5btJlKOp0ZSk6Q1TDcAGKeBFsAkhNhg6hM1u7EBgDk2Kx1gM/X4UJ/SATa+DYnMGZ/Q4zv3ewmyoVjMO7ZXL+Rop7PTwbXxims16inR8Fl+piz1zvTqm385kwwAKAoL/zC3eZSv3vNnuuG2xZPhtXEmBMhDrjsx0vbWltKjJzkhERlVKSkacvx16+32iGnFWbbbL6k25XjiktYx3QBgDHZhg3EIscE47MYGAEZ5NBALN5hanCforFY6wFbOVCPjJoNs9950VfLzn1lAkA3GKhvr06bIP8/o77zhpqW61v9lebzXKzXn8rMG1wAAwKWba3ly8nu/es+fyXfXYs0pI7wG5DPXnUgRYEMWlUvaEHL8vvV2e52JBVq22zQZZGsR9yMBwAQNtACmIcQGk5+w2Y0NAArXgNK7r7WYWqAn6DRIeoSpRlaNT2jTnm6vJIJsMFKJO6rfPff4jPyujwfXTtJ+AAAyLr0D2szwer364pduJbwGFIjU2InkS4e2eE+eGqMZyLYHQ47fJ2n1ervduJMhLNuNphyPT+kgGydDAEDhYhc2GIkQG4zEbmwAUNA6lA6wxU0szhN0KpTefe0ephozZdOebm/f0MmBmmuv4Fu2MEqy3dHbPW9lbfyrKq/W9dV3aP5VX9DQ3EVTDq6d7Ds0rev4gwWfZrIBAEWjakmlEt09WRvf6/Vq1eov6Zrb5skzd0KE14D8R4ANObBSUjzk+Fevt9uNu0dp2W4i5XhqJDVJWsN0A0BBaqAFMBEhNpj+xM1ubABQWDYrHWDrN7E4T9DxKR1g41uOmHGvHDpc3j18ciRYXVlKN2CCy47s1gttWzM+rte7UF9Y8bUPg2uSNJTjWuf9wSI+XgcAFI2qz12VlRDbJ8NrEzQbKADvH08kXz38WwJsyIVKSdGQ469bb7dHTCvOst1+SbWTx4uuY7oBoKCwCxuMNYsWwFSBWDgiqYdOAEDBeDQQC682OMC2WlJUBNiQQ73vHi3d0NEzcuqUO0w3UMjKUu/ouaeasjL2nXffL881qz4MsGXC2MkRJg0AgIv0h3/kzeh4VUsq9dd/Y+u7//Jn+tyyyyYDbAAKwfvHE8ntvdsJsCGXyiVtCDn+JlMLtGy3SZJf0gDTDQAFo4EWwFSE2MATOAAg1wYk3RWIhY19zvYEnQZJm5S+8QXkVO+7R0v/984D8yZOuaRqUJBK3FG1OT/Mytg1q76l4QU3Z3zco++9xcQBAHCRrlhSlrGx1nz3z/Wdv/uiFl/v0ligwHT37RnY3rvdSyeQJx4MOf5oyPFXmFicZbtxSVWSOphqAMh77MIGoxFig9HYjQ0A8l6HJF8gFjbyBbcn6FR4gk6LpEeYauSVwRH9YOeB0pGxcb5li4JzeOfPlEwezfi4N9y0VPNv/EZe1lxStpCJBwAUjflXjMvrzUxuxSqdnde1vhk7qVf+4125Y7OZeOAMnYd3jLx2ZA9fBES+WSkpHnL8PhOLs2y337Jdn6RmphoA8loDLYDJCLGBJ3IAQK40S6oJxMIJE4vzBB2f0seH3sNUIy8NjujHbXvLB4ZHkzQDhWJO78t6bdeOjI/r9S7UdX/6gEY9JVm57uHBE9P7m1JaweQDAIrK0i9kZmfU7Vs787ZGd2y2tra8ouiLr+jf/n6rjiUIsgGuOzGys/s/dbC/u5RuIE9VSoqGHH+tqQVatlsrKchUA0BeYhc2GI8QG4zHbmwAkJceCsTCtYFYuN/E4jxBZ7XSAbZqphp5bXxCj+/c7030neijGch3ZYOHtGXjk1kZe+W3v6fUnMuzdu0H9u1hAgEAuATXV38mI+Ps7dynwffm5GWN2zf1KplMf58kmUzqJ//7F9q7bZBd2VC0XHdipO2tLaXvjvD2FHmvXNKGkOOPmFqgZbsRSX5J7OAPAPmlgRbAdITYwBM6AGAmDUi6KxALN5laoCfoNEnapPQNLSD/jU/o57u7Fr1++Bg7siFvWeMn1PbLx7My9lfu/o6G5l9DkwEAyCPeKzMX5Nrxq4N5V9+xxGxFX3zlE//+zNNb9O8/2pm3wTsgW1JjJ5Ivdm0uPXqSvAwKypqQ44+HHL+RW2dbthuXVCWpg6kGgLzALmwoCoTYUBTYjQ0A8kKHJF8gFjbyRbYn6FR4gk5U0oNMNQrRpj3d3k37elN0Avno4K+fUDJ5NOPj3nDTUnmuWZXVa7fGT0x/kNmXsQgAAEVlTtm4bl9+W0bG2rVzd16Fwtyx2Xr6ia3n/N8T3T1a9w9P683YSRYCisLI2PGBlw5t8Z4YH6YZKETVkhIhx+8zsTjLdvst2/VJamaqASDnGmgBigEhNvDEDgCYCc2SagKxcMLE4jxBxycpLmklU41C9vrbR6wNHT0jdAL5xD20NSvHcXq9C3Xdnz6Q9eufPX582mMMzV3EQgAAFB3/8sztlJpPu7G98O9dHx4jej6/WL9Zzzz+ulLH5rIYYKz3jyeSW7qeLT95aoxmoJCVS2oPOf5aUwu0bLdWUpCpBoCcYRc2FA1CbCga7MYGADnzUCAWrg3Ewv0mFucJOrWSopIqmWqYoPfdo6X/tH2/Jk65hNmQF+ZeViqvd2HGx11pP6zUnMtpMAAAeepTV8+S1+vNyFi7du7WkTc8Oa9p77ZB7dq5++J/vnOffvTwU+zKBiN19+0Z2N673UsnYJANIccfMbU4y3YjkvySOPcXAGZeLS1AsSDEhmLTQAsAYMYMSLorEAs3mVqgJ+g0Sdqg9DcuAXMMjugHOw+UHh8Z7aMZyLXxK+/UbWse0+rav9VVlVdnZMyvBe7XkPXZGbl+d6SfSQQAYCrvt+ZO6ItfujVj421c/6LGh3J3rOiRNzx65uktU3rsL9Zv1tYNb7EoYIzOwztGXjuyh3spMNGakOOPhxx/hYnFWbYbl1QlqYOpBoAZ02zZboI2oFgQYkNRYTc2AJgxHZJ8gVg4amJxnqBT4Qk6UUkPMtUw1uCIHtuxf9HA8GiSZiAfDC+4WTd86x+nHWa79fY7NH7lnTN23aNDR5k8AACm6PN3fDpjYyWTST37s3hO6jjyhkc//bEzrTGurFrMgkDBc92Jkeih53Swv7uUbsBg1ZISIcfvM7E4y3b7Ldv1SWpmqgFgRjTQAhQTQmwoRrW0AACyqllSTSAWTphYnCfo+CTFJa1kqmG88Qk9/vLr3tcPHyPIhrwxnTCb17tQn1n+VwVV762338GkAwCKlrVgTLcvvy1j4+3t3Kfdz8/sS9tMBNi8Xq9uWsGmVShsqbHBvra3tpQePclJhCgK5ZLaQ46/1ti/0bZbKynIVANAVrELG4oOITYUncldgdroBABkxUOBWLg2EAsbeXaaJ+jUSopKqmSqUUw27en2Rrve45MG5JWphNlW2g9r1FMyo9fZf4SNoAEAmI47vnpdRsf71eaXZizItnfb4LQDbJL0Fw+skmfuBIsBBSs1diL50qHWRQTYUIQ2hBx/xNTiLNuNSPJL4v+5ASA7GmgBig0hNvCEDwDIhAFJdwVi4SZTC/QEnSZJG5T+JiVQdF45dLh8Q0fPyKlT7jDdQD652DDb1wL3a8j67IxfX2pkkEkCAGAa5l8xntHd2KSPgmzu2OysXPP40Bxt3fCWnnl6y7THqvnKl7SgigAbCtf7xxPJ1q7N3pOnxmgGitWakOOPhxx/hYnFWbYbl1QlqYOpBoCMYhc2FCVCbChK7MYGABnVIck3+dxqHE/QqfAEnaikB5lqFLved4+W/u+dB+ZNnHJH6AbyzZlhto8fwbl85SqNX3knTQIAoEBlejc2KR1k2/REh1LH5mZsTHdstt6MndRP//E/tWvn7mmPV7WkUivuvZIFgIK1/71XU9t7t3vpBKBqSYmQ4/eZWJxlu/2W7fokNTPVAJAxDbQAxYgQG3jiBwBMR7OkmkAsnDCxOE/Q8UmKS1rJVAOTBkf0g5f3lg4MjyZpBvLR8IKbteiOB3TvA/+iW2+/Q1dVXi2v387Z9STePDCtx19ReTOTCgAoetnYjU2S9nbu048efkpvxk5Oa1e28aE5ejN2Uv/291v1i/WblUxO/6Wy1+tV4IEVHCOKguS6EyO7//s3w/uSb1h0A/hQuaT2kOOvNbVAy3ZrJQXF8aIAMF3swoai5XFdly6gaG1ctjYqggkAMFUPGX58aK2kJnF8KHB2c2brO76r+6oWXb6IZiCflbijGvWU5Oz3v7Du/57W478W+P/Zu9/gtu77zvefo38+lBQDkmnTia2IaZIm6zQV0Ol2L7ubGp5JJzdpZ0S3iz1t7u0IBzN3O907s6Yw3Qd9ckXFa9+5d1KayqPkCUVOZ/bOWaYVNRnVShtboJUaTa2YoCxLllhJhCSLIg2KhEgRoEjw3AcHbv1HtigRJIEf3q+ZPEqr6Pv9kToHOJ/z/f5npsgBq+x7zpetWvm7HHvrL9PiewrgrhZvb9L/3fE/Vu3P37lzp/7dN35DX/y1R5e1vrM0tVkTuXmdGxqtytS1j/rTP3f02Ff47h51+Ltani/8fPTvQpPzZFiAT9HX4wwlTC2u5FkRSQOSdnPUAHDfCpJabcefphVoRJtoARpcp6QTtAEA7vsGOhbPpLKmFmi5XrdYHwp8usWy/urUSPO3/83n87+5u5kgG2rWegbYAABA9Wzatqg/Tu7V/9dzdFX+/Js3b+rloz+TKn/8b/32b+qRR8MKP7LtX/5vpidva/K9af3zO5eqMm3tk/xxci8BNtSl0sLMzZ9d/Nud80sLNAP4dPsqq0VjPc6QcSEF2/GzHwiy8YIGANyfbgJsaOjP/rQAjSyeSaX727r6JO2jGwCwLMMKAmxG3kBbrhcWX64A9+Xlc1ea35q+Xdz39c/7GzZYW+kI8K+2ld6lCQAAVNEXf3OrWk/s1ujl3Kr/b63GdLXl+Pbeb+pLbQ9x2Kg747dGb/782s930glg2fZIGk160ViPM2Tcy8KVAEas5Fm8LAwAy1dQsCEIaFgbaAGgTloAAMvSF8+kIgYH2CKSsiLABty3a2OTTS+8/s7W8pJfohtAdT0UfoImAADw/ue2zWXF/+w/GFvft/d+U7/5+2SAUH/O3XijRIANeCAhSUNJL9phaoG243dIchUEMwAAn44pbGh4hNjQ8OKZ1KikPjoBAJ/KjWdSCVOLs1wvISktaTdHDTyg2aJefPW0XZi7c5NmAFW0yaYHAAB8gL1jQX+c3GtcXQTYUI98v1x8/fJxnb15nptWYGVeSnrR3qQXDRt57Xb8XkkxSTmOGgA+EVPYABFiA97XSQsA4BNvmqPxTKrX1AIt1+uVdFjBm48AVmKxrB+8dmbnmetTBNkASfP5izQBAIBV8KW2hxT73W8YUw8BNtSj0sJsfvDS3zaNFfM0A6iOfZLSSS/aamJxtuNnJUUkDXLUAHBXnUxhAwixAZKYxgYAn2BYUms8k8qaWJzlemHL9bIKviACUEVHTl/eeeTsNVaLAgAAYNX8h2ef1Ne+/lTd1/Gnf+4QYEPduXl7LP+zi8eaJ+fZDghU2R5J2aQXjZlYnO3407bjxyQd4qgB4ENytuMzhQ0QITbggzoUTBwCAEh98UwqEs+kjHzrw3K9iKRRBV8MAVgFZ65M2C9kLqi85BfpBhrVwvzKf/wXHnqURgIAcLfPdZvLevbP9tRtkG3nzp3a//x39dhXfA4TdeVy/nThRO6V5vmlBZoBrI6QpBNJL9phaoG243dIcsUzOQB4XyctAAKE2ICKSlCDhDMASG48k0qYWpzleglJQ2J9KLDqlgqzevG1t5sKc3dYL4qGNHnj0or/jDvWFhoJAMAnfb7bXNZ3/iSqnTvra5LZ177+lP70//pftf3xRQ4RdcP3l+beuv4PxTcnTvN9CrA2Xkp60d6kFw2bWJzt+L2SYpJyHDWABper/JsIQITYgI/qFm9+AGhcBUnReCZl7M2y5Xq9kg5z1MAaKt3RD14/t/PM9SmCbAAAAKg6e8eC/st//1bdTGT74+Re/cF//TVt2kaADfVjsTxfGLx0bOuF6ctNdANYU/skpZNetNXIa7jjZyVFJA1y1AAaWActAP4VITbgA5jGBqCBDUtqjWdSWROLs1wvbLleVsEXPwDW2mJZR05f3nnk7LUSzUAjyY+P0QQAANbiM19ltehv/fZv1uzf8Wtff0r/7f/93/Sltoc4MNSVm7fH8sdHBkKT87z7DayTPZKySS8aM7E42/GnbcePSTrEUQNoQIO24w/QBuBfEWIDPiKeSXWK8cUAGktfPJOKVIK8xrFcLyJpVMEXPgDW0ZkrE/YLmQsqL/lFuoFGcCW3snWin9/9KzQRAIDlfvbbXNa33F/RH3z3OzX199q5c6f2/Z//UX/wX39N9o4FDgp15XL+dOFE7pXm+SV+doF1FpJ0IulFjZ3WYzt+hyRXbEsC0Fg6aQHwYYTYAC4YABqbG8+kEqYWZ7leQtKQgi96ANSApcKsXnzt7abC3B3WiwL30NzyWZoAAMB9+toz27X/+e+q9Qu71/3v8gff/Y7+y3//lj4f4Wt41BffLxdPXX117s2J03yfAtSWl5JetDfpRcMmFmc7fq+kmBg0AaAxDNqOn6YNwIfx6Rm4i3gm1ctNMgDDFSRFK//eGclyvV5JhzlqoAaV7ugHr5/beeb6FEE2GMtenKEJAACsk+2PL+p//2+/rT9O7l3z/+2dO3fq23u/qb/o/q6+9sx2WZvLHAjq6+Pawmx+8NLfNuVmrm+lG0BN2icpnfSirUZ+lnb8rKSIpEGOGoDhOmgB8HGbaAHwqReOI7QBgIGGJcUMXh8alpQW60OB2rZY1pHTl3e+8d6tortndxMNgWk2Lt6iCQAArOdnw81lfantIf3Fr39X2RMT+sXJN3Xz5uq9Q9H6hd16+jv/Vru+trkSXFvkEFB3xm+N3nzj+i9YHwrUvj2Sskkv2t7jDKVNK852/GlJsZJndUt6juMGYKC+SmgXwEc/y/u+TxeAT9Df1pWW9DSdAGDSjbHh60MjCgJsrLsA6sn2Jv35v/tyoWnzJn53YZStU2/rzROeruQuPdD//28//S1t/40/oZHAKvue82WrVv4ux976y7T4HgJYFf7CRl19e0GnXjurt986W5U/s/ULu/UbbV/TFyM7ZO8g9IP6du7GG6WzN8/bdAKoO/t7nKFuU4sreVa7pF7xfS8As3zBdvxR2gB8HCE24FP0t3XFJJ2gEwAMUJDUYfj60IRYHwrUr00b9af/9sv5x0Jbm2kGTPOgYbbvxP+zFp/8HRoIrDJCbEDjWby9SddH7mji2rSuXLq+7FDb177+lD7/K5/TY0+G9djuhwiuwQi+Xy4NXvpbe3K+QDOA+tUnqaPHGTJy80bJsyIKgmxs3gBggkO247NKFPgEhNiAe+hv6xqQtJdOAKhjOUnt8UzK2NHEluv1StrHUQP17xtf/Fwh9uXHebsWRrrfMBshNmBtEGIDIEmlqc1anL/7d+X2Z6RN21gPCvPMlibz6dGfsT4UMMOwpPYeZ2jUyOu0Z4UVBNl4XgegnhUktVbWJgO4iw20ALgnktAA6tmgpIipATbL9cKW62VFgA0wxsmL10MvZC6ovOQX6QZMM7fja/rqH3xP7Ym/0Od3/woNAQCghtg7FrT98cW7/ocAG0z07tSF/E8vvUyADTDHHknZpBeNGXmddvxp2/HbJR3kqAHUsW4CbMCnI8QG3EM8kxpVMIoZAOrNoXgmFYtnUkbeEFuuF5E0KsbIA8ZZKszqxdfebirM3blJN2Ci5YbZNm7ZSrMAAABQVb5fLp66+urcP479UzPdAIwTknQi6UU7TS3QdvxOSc8qmGYEAPUkJ6mbNgCfjhAbsDyd3BADqCMFSW48kzJ2kqTleh2ShhR8MQPARKU7+sFrZ3aeyuXzNAOmej/M9uz/cVC/8Vv//mP//aaHP0uTAAAAUL2PWQszN/9+5GhTbuY6b0sAZjuQ9KIDSS8aNrE42/EHJMUUrFAFgHrRyRQ24N4IsQHLUJnGRjIaQD3ISYrFM6leE4urrA/tlfQSRw00hpfPXWn+wS8vzbFeFCa7vf2Lav73f6Zn/+z/uWuYDQAAAFipd6cu5I+NHN05szhHM4DGsFdSOulFIyYWZzt+VkGQ7ShHDaAO5GzH76UNwL0RYgOWr1tMYwNQ2wYlReKZVNbE4izXa5WUlrSPowYaS+G96a2sF0UjuG0/QZgNAAAAVcX6UKCh7VEQZGs3sTjb8adtx2+XdJCjBlDjErQAWB5CbMAyxTOpaUkddAJAjToUz6RilX+rjGO5XkxSVsEXLwAaEetF0UDeD7Pdtp+gGQAAAHjwj1GsDwUghSQdSXrRTlMLtB2/U9KzYhAFgNo0aDt+mjYAy0OIDbgPlfV8OToBoIYUJLnxTMrYkK3leh2STij4wgVAg2O9KAAAAADcG+tDAXzEgaQXHUh60bCJxdmOP6BgvegwRw2gxnTSAmD5CLEB949pbABqRU5SrBKwNY7lemHL9XolvcRRA/gg1osCAAAAwN2xPhTAp9irYL1oxMTibMfPKgiyHeWoAdSIPqawAfeHEBtwn+KZ1ICkQToBYJ0NSorEM6msicVZrtcqKS1pH0cN4K5YLwoAAAAAH/6YxPpQAPe2R0GQrd3E4mzHn7Ydv13SQY4aQA3opAXA/SHEBnDBAVB/DsUzqVg8k5o2sTjL9WKSsgq+UAGAT/WB9aIlugEAAACgUV3Ony6wPhTAMoUkHUl60U5TC7Qdv1PSs5IKHDeAdXLQdvxR2gDcH0JswAOIZ1JpSX10AsAaK0hy45mUsWuNLdfrkHRCwRcpALC8fxzfm9764qun7YnCHFPZAAAAADQU3y+XXr98XG9OnOa7FAD360DSiw4kvWjYxOJsxx9QsF50mKMGsMYKkrppA3D/CLEBD66TFgBYQzlJsXgm1WticZbrhS3X65X0EkcN4IEslvWjzDvN6ZEbvGELAAAAoCFMzd24cez8j+2xIu/zAHhgexWsF42YWJzt+FkFQbajHDWANdRpO/40bQDuHyE24AHFM6lRSQfpBIA1MCgpEs+ksiYWZ7leq6S0pH0cNYCVOnnxeuj5n59TcWGRMBsAAAAAY5278Ubp1dGfPT6/tEAzAKzUHgVBtnYTi7Mdf9p2/HbxTA/A2sjZjs8UNuABEWIDVqZbwThQAFgth+KZVCyeSRn5xoblejFJWQVflABAdcwW9f3Bt0Nnrk/dpBkAAAAATFJamM2nL/5EZ2+et+kGgCoKSTqS9KKdphZoO36npGfEcz0Aq6uDFgAPjhAbsAKVUEknnQCwCgqSno1nUsbe7Fqu1yHphIIvSACguhbLOnL68s7Dw7ni0pI/R0MAAAAA1Lt3py7kf3bxWPPkPPkLAKvmQNKLDiS9aNjE4mzHT0uKSBrmqAGsgkHb8QdoA/DgCLEBKxTPpLol5egEgCoalhSLZ1JG3uharhe2XK9X0kscNYDVdm1ssumF197eOlGYy9MNAAAAAPXI98ulU1dfnfvHsX9qZn0ogDWwV8F60YiJxdmOPyopJqmPowZQZZ20AFgZQmxAdSRoAYAqOaogwJY1sTjL9VolpSXt46gBrJnSHf0o805zeuQG4woAAAAA1JXZ0mT+2Pkf27mZ61vpBoA1tEdBkK3dxOJsx5+2HT8haT9HDaBK+irTHgGsACE2oArimVRa0iCdALBCB+OZVHtlVbFxLNeLScoq+AIEANbcyYvXQ8///JyKC4uE2QAAAADUNN9fmjt3443STy+9zPQ1AOslJOlI0ot2m1qg7fjdkp6RxHdFAFaiIKawAVVBiA2ong5aAGAFN7fPxjMpY29wLdfrlHRCwRcfALB+Zov6/uDboVO5POtFAQAAANSk0sJsfvDSsa1nb5636QaAGvBc0oumk140bGJxlclJEUnDHDWAB9RdWVUMYIUIsQFVUln910cnANynYQXrQwdMLM5yvbDlegOSDnDUAGrGYlkvn7vS/INfXporL/klGgIAAACgVlzOny4cGxlonpxnKBCAmvK0pGzSi0ZMLK4SPomJ53wA7l9OUjdtAKqDEBtQXR1i5DCA5TuqIMCWNbE4y/UiktKS9nLUAGpR4b3prS++etoezc8wlQ0AAADAuloszxdev3xcb06cZoo9gFq1W1I66UUTJhZnO/607fgJSfs5agD3odN2/GnaAFQHITagiuKZ1LRIWgNYnoPxTKq98u+GcSzXa1cQYNvDUQOoaYtl/dWpkeYjZ6+Vlpb8ORoCAAAAYK29O3Uhf3xkIDRW5P0aADUvJOlw0osa+yzMdvxuSc+IoRUA7m3Qdvxe2gBUDyE2oMrimVSngrGhAHA3BUnPVv6tMJLlep2Sjij4QgMA6sKZKxP2C6+9vXWiMMdTIwAAAABrwvfLpVNXX537x7F/ap5fWqAhAOrJc0kvmk560bCJxdmOn5YUkTTMUQP4FJ20AKguQmzA6uigBQDuYljB+tABE4uzXC9sud6ApAMcNYC6VLqjH2XeYSobAAAAgFV38/ZY/tj5H9u5metb6QaAOvW0pGzSi0ZMLM52/FFJMUl9HDWAu+irBF4BVBEhNmAVVAIqg3QCwAccVRBgy5pYnOV6EQXrOBvjGAAAIABJREFUQ/dy1ADq3ZkrE/YLr7+z9VbxDlPZAAAAAFTV+9PXTuReYfoaABPslpROetGEicXZjj9tO35C0n6OGsAHFMQUNmBVEGIDVg/T2AC872A8k2qPZ1LTJhZnuV67ggDbHo4agDFmizo0eKY5PXKjQDMAAAAAVAPT1wAYKiTpcNKLdptaoO343ZKeURBcAYDuyrRGAFVGiA1YJZVpS4wYBhpbQdKz8Uyq09QCLdfrlHREwRcVAGCckxevh57/+TkxlQ0AAADAg/L9pblzN94oMX0NgOGeS3rRdNKLhk0srrI2MCJpmKMGGlpOUjdtAFYHITZgdXWItzKARjWsYH3ogInFWa4XtlxvQNIBjhqA8ZjKBgAAAOBBP06UJvN/PzKw9ezN8zbdANAAnpaUTXrRiInFVSYvxcQQC6CRddqOP00bgNVBiA1YRZXVgSSxgcZzVEGALWticZbrRRSsD93LUQNoJExlAwAAALBc709f++mll5tnFudoCIBGsltSOulFEyYWZzv+tO34CUn7OWqg4Qzajt9LG4DVQ4gNWGWVNYI5OgE0jIPxTKq9EmI1juV67QoCbHs4agANialsAAAAAO7h5u0xpq8BaHQhSYeTXtTYQQ+243dLioqNTEAj6aQFwOoixAasjQQtAIxXkPRMJbhqJMv1OiUdUfAFBAA0NKayAQAAAPgo3y+XTl19de5E7hWmrwFA4LmkF00nvWjYxOJsx89KapU0zFEDxuuzHT9NG4DVRYgNWAPxTCotaZBOAMYalhSp/K4bx3K9sOV6A5IOcNQA8AGVqWw/Offu1NKSzxMqAAAAoIHdvD2WP3b+x3Zu5vpWugEAH/K0pGzSi0ZMLK6yXjQiqY+jBoxVkNRBG4DVR4gNWDsJWgAYqU9SLJ5JjZpYnOV6EQXrQ/dy1ABwd9nc+I4XXnt760RhjqlsAAAAQIP54PS1+aUFGgIAd7dbUjrpRROmFmg7fkKSy1EDRuq2HX+aNgCrjxAbsEYqAZeDdAIwyv54JpWIZ1JG3rharteuIMC2h6MGgHso3dGPMu80Hzl7rcRUNgAAAKAxTMzkxpm+BgDLFpJ0OOlFe00t0Hb8XklRBVObAJghZzt+J20A1gYhNmBtdXPjChihIOmZeCbVbWqBlut1Szqi4IsFAMAynbkyYb/w2ttbR/MzTGUDAAAADLVYni+8fvm4Tl492cL0NQC4b/uSXjSb9KJhE4uzHT8rqVXSMEcNGCFBC4C1Q4gNWEOVaU3sywbq27CkSDyTSptYnOV6Ycv10pKe46gB4AGV7uivTo00/+CXl+bKS36JhgAAAADmuJw/XTg+MhAaK/LeCgCswB5Jo0kvGjGxONvxp23Hj0jq46iBujZoO36aNgBrhxAbsMbimVSvpEE6AdSlPkmxynpg41iuF5GUlfQ0Rw0AK1d4b3rri6+etk/l8jzdAgAAAOpcaWE2n774E705cTrE9DUAqIqQpKGkF02YWqDt+AlJLkcN1K0ELQDWFiE2YH0wjQ2oP/vjmVSiMlHROJbrJSSlJe3mqAGgihbLevncleYXMhdUXFhkrTwAAABQZ3x/ae7cjTdKx0YGmifnuaUHgFVwOOlFe00tznb8XklRSVxEgPpy0Hb8UdoArC1CbMA6iGdSWUmH6ARQFwqSnolnUt2mFmi5XrekwwrefAMArIKlwqy+/8rpUHrkBl9YAgAAAHVitjSZ//uRga1nb5636QYArKp9SS+aTXrRsInF2Y6fldQqaZijBupCTlI3bQDWHiE2YP10ircugFo3LCkSz6TSJhZnuV7Ycr20pOc4agBYGycvXg89nz6jicIcK0YBAACAGuX75dKpq6/O/fTSy80zi3M0BADWxh5Jo0kvGjGxONvxp23Hj0jq46iBmtdhO/40bQDWHiE2YJ1UVhJ20gmgZvVJisUzqVETi7NcLyIpK+lpjhoA1ljpjn6Ueaf58HCuWF7ySzQEAAAAqB3vTl3IHzv/Yzs3c30r3QCANReSNJT0oglTC7QdPyHJ5aiBmjVoO/4AbQDWByE2YB1V1hMyOhioPfvjmVSiEjY1juV6CUlpSbs5agBYP9fGJptefPW0fSqXZyobAAAAsM5KC7P59MWf6B/H/ql5fmmBhgDA+jqc9KK9phZnO36vpKjY2ATUogQtANYPITZg/XXQAqBmFCQ9UwmYGslyvW5JhxW80QYAWG+LZb187krzC5kLulW8Q5gNAAAAWGO+Xy6eu/FG6djIQPPkPFkCAKgh+5JeNJv0omETi7MdPyupVQy7AGrJIdvxR2kDsH4IsQHrLJ5JpRWsLQSwvoYlRSq/k8axXC9suV5a0nMcNQDUnqXCrA4Nnmk+cvZaqbzkF+kIAAAAsPomZnLjx87/uOnszfM23QCAmrRH0mjSi0ZMLM52/Gnb8SPiOSFQCwqSOmkDsL4IsQG1oUOMDAbWU5+kWDyTGjWxOMv1IpKykp7mqAGgtp25MmG/+OrpptH8DFPZAAAAgFWyWJ4vvH75uE5ePdnC6lAAqHkhSUNJL5owtUDb8ROSXPGsEFhPHbbjT9MGYH0RYgNqQDyTmhbJbmC97I9nUonK76FxLNdLSEpL2s1RA0CdWCzrr06NNL+QuaDiwiJfXgIAAABV4vtLc5fzpwtHz/eHxoq8NwIAdeZw0ov2mlqc7fi9kmKSchw1sOYGK7+DANYZITagRsQzqW6x9x5YSwVJ0crvnpEs1+uWdFjBm2oAgDqzVJjV9185HUqP3CgsLflzdAQAAAB4cDdvj+X/fmRg65sTp/meBADq176kF80mvWjYxOJsx89Kikga5KiBNdVBC4DaQIgN4AIJNKJhSa3xTCprYnGW64Ut10tLeo6jBoD6d/Li9dALr7299eyN6XG6AQAAANyf0sJs/vXLx3Ui90rzzCLvhgCAAfZIGk160YiJxdmOP207fkzSIY4aWBMHKwFSADWAEBtQQ+KZVFpSH50AVlVfPJOKGLw+NCIpK+lpjhoADFK6o7/OXmp5IXNBt4p32HsEAAAA3IPvl4vnbrxROjYy0MzqUAAwTkjSUNKLGjscwnb8Dkmugq0yAFZHTlI3bQBqByE2oPZ0cEMKrBo3nkklTC3Ocr2EpLSk3Rw1AJhpqTCrQ4Nnmo+cvVYqL/lFOgIAAAB83MRMbvzY+R83nb153qYbAGC0l5JetNfg9aK9kmIKgjYAqq/Ddvxp2gDUDkJsQI2pTIfqpBNAVRUkReOZVK+pBVqu1yvpsII30AAAhjtzZcJ+8dXTTadyeUZKAAAAABW356fG0xd/opNXT7bMLy3QEABoDPskpZNetNXE4iprDiOSBjlqoKoGbccfoA1AbSHEBtSgeCbVzc0oUDXDklrjmZSR++wt1wtbrpetfFAHADSSxbJePnel+fmfn9N7t4rjNAQAAACNe2s8X3jr+j8Uj1881jI5z5ILAGhAeyRlk140ZmJxtuNP244fk3SIowaqJkELgNpDiA2oXR20AFixvngmFalMODSO5XoRSaOVD+gAgEY1W9QPXz/X8oNfXporLizyxA4AAAANw/eX5i7nTxeOjwyELkxfbqIjANDQQpJOJL2osc/XbMfvkOQq2D4D4MEdtB1/lDYAtYcQG1CjKlOjeKMCeHBuPJNKmFqc5XoJSUNifSgAoKLw3vTW779yOpQeuVEoL/lFOgIAAACTTczkxv9+ZGDrmxOnQ6wOBQB8wEtJL9qb9KJhE4uzHb9XUkxSjqMGHkhOUjdtAGoTITagtnWKtymA+1WQFI1nUr2mFmi5Xq+kwxw1AOBuTl68Hnrx1dNNZ29Ms2IUAAAAxrk9PzX++uXjOnn1ZMvM4hwNAQDczT5J6aQXbTWxONvxs5IikgY5auC+JWzHn6YNQG0ixAbUsMoKxASdAJZtWFJrZZKhcSzXC1uul618AAcA4JMtlvXX2Ustz//8nN67VSTMBgAAAANucecLb13/h+Lxi8daxop5GgIAuJc9krJJLxozsTjb8adtx4+JrU7A/ThqO36aNgC1ixAbUOPimdSAeJMCWI6+eCYVqYQ/jWO5XkTSaOWDNwAAyzNb1A9fP9fyQuaCiguLTPgFAABA3fH9cvFy/nTh+MhA6ML05SY6AgC4DyFJJ5JetMPUAm3H75Dkis1OwL0UJHXQBqC2EWID6kOCFgCfyo1nUsb+nliul5A0VPnADQDAfVsqzOr7r5wOHR7OFctLfomOAAAAoB5MzOTGj53/cdObE6dD80sLNAQA8KBeSnrR3qQXDZtYnO34vZJiknIcNfCJOm3HH6UNQG0jxAbUgXgmNSrpIJ0APqYgKRrPpHpNLdByvV5JhzlqAEA1XBubbHrx1dN2euRGYWnJn6MjAAAAqEWzpcn83134G528erKF8BoAoEr2SUonvWiricXZjp+VFBHbnYC7GbYdv5s2ALXP8n2fLgB1or+ta1TSbjoBBDeckmIGrw8NS0qL9aEAgNVib9EffvXJ8aceD7fQDACN7HvOl61a+bsce+sv05Ke5lQANKrb81Pjw9d/0TJWzNMMAMBqKUhq73GG0qYWWPKsbknPcdTAv4hWgp4AahyT2ID6kqAFgCSpL55JRQwOsEUkjYoAGwBgNZXu6K+zl1qeT5/RRGGOp4QAAABYN4vl+cJb1/+hePziMQJsAIDVFpJ0IulFO0wt0Hb8DknPKgjsAY3uEAE2oH4QYgPqSDyTSkvqoxNoYAVJbjyTSphaoOV6CUlDlQ/SAACsvtId/SjzTvMLmQt671ZxnIYAAABgrfh+uXjuxhulo+f7QxemLzfREQDAGnop6UV7k140bGJxtuMPSIop2GoDNKqCpE7aANQPQmxA/ekQb06gMeUUrA/tNbVAy/V6JR3mqAEA62GpMKsfvn6u5fBwrlhcWOR+EwAAAKvG98vFy/nThWPnf9x09uZ5m44AANbJPknppBdtNbG4yvSpmKSjHDUaVMJ2/GnaANQPy/d9ugDUmf62roQIuqCxDEpqN3h9aFhSWqwPBQDUkCc/+0jxj5564k7T5k1MBwVgtO85X7Zq5e9y7K2/TEt6mlMBYLKJmdz4P737jy3zSws0AwBQKwqS2nucobSpBZY8q1PSAY4aDWTQdvwYbQDqC5PYgDpUmUQ1SCfQIA7FM6mYwQG2iKRREWADANSYa2OTTd8ffDuUHrlRKC/5RToCAACAlZiYyY3/3YW/0cmrJwmwAQBqTUjSiaQX7TS1QNvxOyU9K7Y9oTEUJCVoA1B/CLEB9YsLLxrhBtONZ1IdphZouV6HpKHKB2QAAGrPYlknL14Pvfjq6SbCbAAAAHgQs6XJ/PvhtZnFORoCAKhlB5JedCDpRcMmFmc7/oCC9aLDHDUM1207/ihtAOoPITagTsUzqVFJB+kEDJWTFKtMHTSO5Xphy/V6Jb3EUQMA6sIHwmyncvk8DQEAAMC93J6fGn/98nH99NLLzYTXAAB1ZK+kdNKLRkwsznb8rIIg21GOGoYarkweBFCHCLEBdSyeSXUqCPsAJhmUFIlnUlkTi7Ncr1VSWtI+jhoAUHcWy3r53JXm59NndPbG9DgNAQAAwEe9H147fvFYy1iR9x8AAHVpj4IgW7uJxdmOP207frsYlgEzJWgBUL8IsQFciIFaciieScXimdS0icVZrheTlK18AAYAoH6V7uivs5daCLMBAADgfYTXAACGCUk6kvSinaYWWJlW9aykAscNQxyqTBsEUKcIsQF1Lp5JpSUdohOocwVJbjyT6jC1QMv1OiSdqHzwBQDADITZAAAAGt5ieb5w6uqrc4TXAACGOpD0ogNJLxo2sTjb8QcUrBcd5qhR53KSOmkDUN8IsQFm6BRvSaC+bypj8Uyq18TiLNcLW67XK+kljhoAYCzCbAAAAA1nsTxfeOv6PxSPnu8P5Waub6UjAACD7VWwXjRiYnGVyVUxSUc5atSxDtvxp2kDUN8IsQEGqKxeTNAJ1KFBSZF4JmXkaF/L9VolpSXt46gBAA2BMBsAAIDxPhheuzB9uYmOAAAaxB4FQbZ2E4uzHX/advx2SQc5atSho5WpggDqnOX7Pl0ADNHf1jWg4G0QoB4cMnx9aEzSgFgfCgBoZPYW/eFXnxx/6vFwC80AUKu+53zZqpW/y7G3/jIt6WlOBUAtWizPF86Nn9pCcA0AAB3scYY6TS2u5FntknrF8w3Uh4KkVqawAWZgEhtglg6xVhT1cTPpGh5g65B0gg94AICGx2Q2AACAusfkNQAAPuZA0osOJL1o2MTiKhOtYpKGOWrUAdaIAgZhEhtgmP62rg5JL9EJ1KicpHaD14eGJXWL9aEAANwdk9kA1CAmsQHA3d2enxq/NHn2YYJrAAB8omFJiR5nyMhnHiXPCiuYyMYWKNSqQdvxY7QBMAeT2ADDxDOpbkmDdAK1eCMpKWJwgK1VUloE2AAA+GRMZgMAAKh5t+enxl+/fFzHLx5rIcAGAMCn2iMpnfSi7SYWZzv+tO347ZIOctSoQQVJCdoAmIUQG2AmLtioNYfimVQsnkkZOc7Xcr2YpGzlAysAALgXwmwAAAA154PhtbFinoYAALA8IUlHkl6009QCbcfvlPSMgtAQUCu6bccfpQ2AWVgnChiqv62rU9IBOoF1VpCUiGdSA8ZeSF2PFb4AAKzUpo36xu6Wwje+2LJl4waLaR8A1hTrRAE0utvzU+PD139BcA0AgJU7qmC9qJEv9Jc8q1XSgHihH+tv2Hb8CG0AzEOIDTBYf1sXk6GwrjeQCgJspq4PDUvqFutDAQCoHsJsANYBITYAjWpiJjeeHftly8ziHM0AAKB6hhUE2Yx8NlLyLJ6NoBZEbcfP0gbAPKwTBcyWoAVYJ0clxQwOsLVKSvMhDQCAKlss6+TF66EXXz3d9JNz704VFxZZUwEAAFBlEzO58b+78Dc6efUkATYAAKpvj6R00ou2m1ic7fjTtuMnJO3nqLFODhJgA8zFJDbAcKwVxXrcPMYzqU5jL5yuF1MwLjvEUQMAsPqe/OwjxT966ok7TZs3ce0FsCqYxAagEfh+uTg6+fadt/PnQvNLCzQEAIC1cajHGeowtbiSZ8XE8xKsLdaIAoZjEhtgvm5JOdqANVCQ9KzhAbZOSSf4QAYAwNq5NjbZ9P1XTodeyFzQe7eK43QEAABg+RbL81OX86cLx87/uOnNidME2AAAWFvPJb1oOulFwyYWZzt+WlJEwQpVYC100ALAbExiAxpAf1tXTEHwBlgtw5ISBq8PDUvqlbSXowYAYH1tCG3Xf/yVlqtfaQntohsAqoFJbABMtFieL5wbP7XlwvTlJroBAMC6y0lq73GGjHyGUvKssIKhGvs4aqyiQ7bjE2IDDMckNqABxDOptKRDdAKr5KikmMEBtoiktAiwAQBQE5YKs/qfQxd3PZ8+o7M3psfLS36RrgAAAARuz0+Nv375uI6e7w8RYAMAoGbslpROetGEicXZjj9tO35C0n6OGqskJ6mTNgDm20QLgIbRKam9cqMMVMtBw9eHtiuYwMb6UAAAak3pjv46e6lFmzbqG7tbCt/4YsuWjRssHtQCAICGNDGTGz87cbplcr7QQjcAAKhJIUmHk1400uMMGTlNynb87pJnZSUNiOcqqK6E7fjTtAEwH+tEgQbCWlFUUUHB+tABYy+Qrtcp6QBHDQBA/Xjys48U/+ipJ+40bd7EF6UAlo11ogDqle+Xi6OTb98ZufnPoZnFORoCAED9GFSwXtTIUE7Js1oVBNn2cNSoAtaIAg2EEBvQYPrburolPUcnsALDCgJspq4PDSuYvsb6UAAA6tSG0Hbt++oTV5/csW0X3QBwL4TYANSbxfJ84dz4qS25W9ea5pcWaAgAAPUppyDIZuSzlpJnhSV1S9rHUWOFvycRprABjWMDLQAaTmflgg88iKOSYgYH2CKS0iLABgBAXVsqzOrwL87vej59RmdvTI+Xl/wiXQEAAPXu9vzU+BtXXtHR8/2hC9OXCbABAFDfdktKJ71owsTibMefth0/IWk/R40VYI0o0GCYxAY0oP62rnZJR+gE7tPBeCbVaewF0fXaFUxgY/0YAACm2bRRkSeap775pZYNrBoF8FFMYgNQy3y/XHxv9tqt7NgvW1gZCgCAsQ71OEPGrksseVZMwXpRvpPBff1esEYUaDyE2IAG1d/WNSCmTWF5CgrWhw4YezF0vU5JBzhqAADMt605pD/51c+NP/pwUwvdACARYgNQmxbL84WL+beWRqYu7mDiGgAADWFQwXpRI6dOlTyrVUGQbQ9HjWUoSGplChvQeDbRAqBhJSSNirce8OmGFQTYTF0fGlYwfY1AJwAADeJ2vqAf5gstsrfoD7/65PhXHgs9vHGD1URnAABATdyrzE+Nnx1/s+XK7Bjf2QEA0FielpRNetH2HmfIuGcytuOPViaydUvax3HjHlgjCjQoJrEBDYy1oriHowoCbEbeJFquF1EQYOOtHwAAGhmrRoGGxyQ2AOvN98vFscKlm2cm3nqClaEAADS8gqSOHmeo19QCS57VIekljhqf4Kjt+O20AWhMhNiABsdaUXyCg/FMqtPYi5/rtSsIsPGgGgAA/IsNoe3a99Unrj65Y9suugE0DkJsANZLaWE2P/Le8LbcrWtNrAwFAAAfcajHGeow9j7IsyKS0uI5DT6MNaJAg2OdKICEWCuKD98ctsczqbSpBVqu1ynpAEcNAAA+aqkwq8O/OL9L9hZ944nmQlvro0sPbd64g84AAIBqem/m6tWR/Nu7xor5ZroBAAA+wXNJLxqR1N7jDBkX6LEdP1vyrFYFQTY25uB9rBEFGhyT2ACwVhTvG1YQYBs18oLnemEF09eYPAgAAJbtyc8+Uvz9Lzx269GHm1roBmAmJrEBWAuL5fnCxfxbSyNTF3cwdQ0AANyHnIIgW9bUAkue1StpH0fd8FgjCkAbaAGAeCY1IKmPTjS0PkkxgwNs74+lJsAGAADuy7WxyaYfvn6u5fn0GZ3K5fPlJb9IVwAAwHK9N3P16uuXj+vo+f7Qmcl3CLABAID7tVtSOulFE6YWaDt+QpLLUTe0nILtYQAaHJPYAEiS+tu6wpKylZthNJb98Uyq29gLneu1K5jAxspcAABQFUxnA8zCJDYA1cbUNQAAsEr6epyhhKnFlTzr/YEEPM9pPM/Yjp+mDQAIsQH4F/1tXTFJJ+hEwygoWB9q7E2h5Xrdkp7jqAEAwKqwt+jbX3g8//XP7dj40OaNO2gIUJ8IsQGolvdmrl4dyb+9a6yYpxkAAGC1DEuK9ThD0yYWV/KssIIg2x6OumEcsh2/gzYAkAixAfiI/rYuQj+N8yGn3eD1oWFJA+LhDwAAWCPbmkP6T198/OqTO7btohtAfSHEBmAlSguz+dzNdzYydQ0AAKyhgoIgW9bYeyzP6pW0j6M2Xk5SxHb8aVoBQJI20AIAH9FZuWGAufokxQwOsEUUrMblwQ8AAFgzt/MFHf7F+V3Pp8/oJ+fenSouLBboCgAAZvL9cnFiJjeevvgTHRsZaD4z+Q4BNgAAsJZCkoaSXjRhaoG24yckuRy18RIE2AB8EJPYAHwMa0WNtj+eSXUbe1FzvYSk7soHOAAAgPW1vUl/+KXPjn/lsdDDGzdYTTQEqE1MYgOwXLfnp8YvTZ59+ML0Za7rAACgVvT1OEMJU4sreVZEwXpRnvuYhzWiAD6GEBuAu2KtqHEKCtaHpo29oLkeP7MAAKA2bdqoJx8NF3//C4/devThphYaAtQWQmwAPs1ieX7q6tT5DSM3/zk0szhHQwAAQC0aVrBe1MiJViXPCisIsu3hqI3BGlEAd7WJFgD4BJ2S2iXtphVGfHhpN3h9aFjSgHjQAwAAatViWdfGJpt+ODbZJHuLIi07pr75pZYNTZs38RYxAAA1yPfLxfdmr906O3G6ZXK+sIOOAACAGrdH0mjSi8Z6nKGsacVVgk6Rkmf1StrHcRuBNaIA7opJbAA+UX9bV0TSEJ2oa32SOuKZlJE3gpbrRRQE2AhbAgCA+sO6UaAmMIkNwPsKcxNXr0yPNLMuFAAA1DG3xxnqNbW4kmclJB3mmOvaQdvxO2kDgLshxAbgU/W3dXVKOkAn6tL+eCbVbewFzPUSkrolMcEEAADUvW3NIf3eruarX2kJ7aIbwNoixAY0ttLCbD53852NI1MXd8wvLdAQAABggr4eZyhh7P2bZ0UUrBfl+VD9GbYdP0IbAHwSQmwA7qm/rSsr9szXk4KC9aFpYy9ertct6TmOGgAAGGfTRj35aLj4u59vzj+5YxuBNmANEGIDGs9ieX7q6tT5DSM3/zk0szhHQwAAgImGJcV6nCEjN/WUPCusIMjG88v6ErUdP0sbAHySTbQAwDIkxFrRevpQ0h7PpEZNLM5yvbCC9aE81AEAAGZaLOva2GTT4bHJXbK3KNKyY+rp1kfLDzdtaaY5AACs5BI7PzV+K1ceuXm+eXK+sIOOAAAAw+2RNJr0orEeZ8i40JDt+NOSIiXP6pW0j+OuCwcJsAG4FyaxAViW/rauDkkv0Yma1iepI55JGflWjeV6EQUBtt0cNQAAaDiVQNs3v9SyoWnzJtZlAFXEJDbAXL5fLuZnr+dHpy7sujI7RkMAAECjcnucoV5Tiyt5VkLSYY65prFGFMCyEGIDsGz9bV1p8WV6rdofz6S6jb1YuV5CUrckHtgCAABsb9K3dz2a//rndmx8aPNGJskAK0SIDTALwTUAAIC76utxhhKmFlfyLAYh1K6CpIjt+KO0AsC9EGIDsGz9bV2tkrIiSFRrN36xeCZl7Phdy/W6JT3HUQMAANwFgTZgxQixAfWP4BoAAMCyDEuK9ThDRm70KXlWWEGQjc9UtWW/7fjdtAHAchBiA3Bf+tu6EmIkb0192DB4fSgfNgAAAO4HgTbggRBiA+oTwTUAAIAHUlAQZDN2OELJsxgCmWB8AAAgAElEQVSOUDsGbceP0QYAy0WIDcB962/rGpC0l06sq754JpUw9uLkeox9BgAAWAkCbcCyEWID6gfBNQAAgKrZ3+MMGTsdq+RZCUndYrvUeipIarUdf5pWAFguQmwA7lt/W1dY0ig3fuvGjWdSvcZemFyPDxYAAADVtL1Jsc8+Mr7nc+GNDzdtaaYhwIcRYgNqG8E1AACAVdMnqcPg9aIMTFhfz9qOP0AbANwPQmwAHkh/W1e7pCN0Yk0VFKwPNXbEs+V6vZL2cdQAAACrxN6iSMuOqadbHy0TaAMChNiA2rNYnp8av5Urj9w83zw5X6AhAAAAq2dYUnuPMzRqYnElzworCLLxOWtt9dmOn6ANAO4XITYAD6y/rYud8mv7ISIWz6SMfBvGcr2wpLSkPRw1AADAGtm0UU8+Gi7+7ueb80/u2LaLhqBREWIDakNpYTZ/o3C5PFoYbSG4BgAAsKYKCoJsaWPvNT2LZ5prJycpwhpRAA+CEBuAB1ZZK5oVY3hXW188k0oYeyFyvYiCABvrQwEAANbLpo3aFt6u39vVfPVLjz7cvHGD1URT0CgIsQHrpzA3cfXGzJXtucKVHTOLczQEAABgfe3vcYa6TS2u5FkJSd3iedRqe8Z2/DRtAPAgCLEBWJH+tq6IpCE6sWrceCbVa+xFyPUSkg5zzAAAADVme5O+vevR/FdaQuXP2JtbaAhMRogNWDu+Xy7mZ6/nR6cu7Bqfy2t+aYGmAAAA1JY+SR09zpCRU7RKnhVRsF6UAR2r46Dt+J20AcCDIsQGYMX627o6JR2gE1VVULA+NGvsBcj1eiXt46gBAABqnL1FkZYdU9HHw7OsHYWJCLEBq2t+cW48P3Nt48jN882sCQUAAKgLwwrWi46aWFzJs8IKgmx89qryz43t+BHaAGAlCLEBqIr+tq40N3tV/XAQi2dSRr7lYrleWMH60D0cNQAAQP3Z1hzS7+1qvtq6c/v2hzZv3EFHUO8IsQHV5fvl4q3iZP7K9Ejz2Ox4E2tCAQAA6lJBQZAtbWqBJc/qlvQcR121n5eY7fhZWgFgJTbRAgBVkpCUFXvkV6ovnkklTC3Ocr2IggAbPycAAAB16na+oP+ZLwQT2bY3KfLIw1O/veuRuUe220/QHQBoTO9PW8tNX2oeK+abJDG5EwAAoL6FJJ1IetH9Pc5Qt4kF2o7fUfKsrKRu8dxqpToJsAGoBiaxAaia/rauhKTDdOKBufFMqtfYC47r8fMBAABguG3NIcVawu9+7fHwVqa0oV4wiQ24f0xbAwAAaCh9kjp6nCEjNwiVPCuiYL3obo76gRy1Hb+dNgCoBkJsAKqqv61rQNJeOnFfCgrWhxr7hoLler2S9nHUAAAADcTeoid3fKb4u59vzn82tLV54wariaagFhFiA5Znbn763YmZq5tGC6Mtk/MFGgIAANBYhhWsFx01sbiSZ4UVBNn4PHZ/CpJabcefphUAqoF1ogCqLaFgrShvKyz/pj8Wz6SMvLmzXC+sYH3oHo4aAACgwZTu6NrYZNPhscl/WT0a++wj40+1PLzI6lEAqH3zi3Pjk7PvLr5768oT43N5zS8t8G83AABA49ojKZv0ou09zlDatOIqIaxYybO6JT3HcS9bOwE2ANXEJDYAVdff1hWTdIJO3FNfPJNKGHuBcb2IggBbiKMGAADAR20Ibde3Prcz/5WWUPkz9uYWOoL1wiQ2ILBYnp+ampuYvTFzhRWhAAAA+DT7e5yhblOLK3lWQlK3eL51L4dsx++gDQCqiRAbgFXR39bVKekAnbirgqSOeCbVa+zFxfUSkg5z1AAAAFiWTRu1LbxdsZbwu19+9OFNhNqwlgixoVERWgMAAMAK9Enq6HGGjJzCVfKsiKResWnokwzbjh+hDQCqjRAbgFXT39aV5ebuY3KS2uOZVNbYC4vr9Urax1EDAADggRFqwxoixIZGQWgNAAAAVTYsqb3HGRo1sbiSZ4UVBNn2ctQfUpAUsx0/SysAVNsmWgBgFbVLyopxu+8bVBBgM/KtFMv1wgrWhxJcBAAAwMoslnU7X9CxfOEJSR8KtX1h5/bFHdse2k2TAOBe/5R+LLS2Q9IOOgMAAIAq2SMpm/Si7T3OUNq04mzHn5bUXvKsTrF96oM6CbABWC1MYgOwqvrbuhJiraQkHYpnUsbuhbdcL6IgwEZgEQAAAGtiQ2i7fuex8PhTLQ8vhrc+tHPjBquJruBBMIkNpphfnBufnH138d1bV56YKhXEpDUAAACsoYM9zlCnqcWVPKtdwVS2Rn8OdtR2/HZ+3AGsFkJsAFZdf1tXrxp3vWRBUkc8k+o19kLieh2SXuInHQAAAOtqe5Mijzw89as7t8+27ty+/aHNG5k2hGUhxIZ65PvlYvHOzM2Jmaubrs+823JzvqD5pQUaAwAAgPV0VFKixxkyciNRybMiCoJsjbqRqCCptTKhDgBWBetEAayFDkkxSY228ienYH2okSN1K+tDu9W4AUUAAADUktmisrPFHdnceBBes7do2/YmVpACMML84tz4reLknRszV5onizebJucLTZKeoDMAAACoIXslpZNeNNHjDBn3bMx2/GzJs2IKgmx7G/B82wmwAVhtTGIDsCb627oikoYaqORBBQE2I2/mLNdrlTSgxn3bBAAAAHVoQ2i7fj28jWlt+BAmsaHWMGUNAAAAda6gYCLbgKkFljyrU9KBBjrTg7bjd/KjDWC1EWIDsGb627oa5YbuUDyT6jD2wuF6MQUBthA/1QAAAKhrmzZqw7Ym/c5j4fEv7Nx259HtNsG2BkSIDeuteOdWbmpufNO7t648MVUqaGZxjqYAAADABAd7nKFOU4sreVa7gqlspj8vG7YdP8KPM4C1QIgNwJrqb+tKy9wv5AuSOuKZVK+xFw3X65D0Ej/JAAAAMNamjdoW3q7/Zedncl957OFN2x/avJVgm9kIsWEtvR9Ym5yb2FlZC0pTAAAAYLKjCqayGbm5qORZEQVBNlM3FxUkRWzHH+VHGcBaIMQGYE31t3WFJY3KvLcScgrWh2aNvFi4XlhSt6R9/BQDAACg4TCxzWiE2LAa3l8Jmp99d7EwP/0YgTUAAAA0sGEFQTYjn6GVPCusIMi218DynrUdf4AfYQBrhRAbgDXX39YVk3TCoJIGFQTYjHyLxHK9VgXrQ/fw0wsAAABUVIJtvx7eNvWrO7fPPrbdXtqx7aHdNKb+EGLDSi2W56duzxdmC8X3lsZv39jNSlAAAADgYwoKgmzGBqJKntUp6YBBJfXZjp/gRxfAWiLEBmBd9Ld1dUt6zoBSDsUzqQ5jLxKuF1MQYAvxUwsAAAAsw/YmbbO3sI60jhBiw3L5frlYWrg9MTU3vmlmvrB1ci6/Y6yYpzEAAADA8h3scYY6TS2u5FntCqay1ftztWFJMdvxp/mRBbCWCLEBWDf9bV1Z1e90r4Kkjngm1WvsBcL1OiS9xE8qAAAAsHIbQtv1ua0PFb/ymaYJwm21hRAbPupuYbWb8wXNLy3QHAAAAGDljiqYymZkQKrkWZH/n727j46rvu/E/xlig0AEyRiMzaOdOrHLUpB+JGD21xARyNPaS9Q23iHZ00WjttluKIuBk+VkgRqX0CzNgdrrkvzaZjVy9mxgFro11DQpwWCSbk0c6MjUJZiosc2TH8BBgy0/IDfz+0MSNcYY2dbM3Lnzep2Tc2JZuvd+3/crM7be87kxXGSr55+BdjRly322KlBtE0QA1FBnRPRF/b0bYVMMPz40lS/eMrlCa0QsjoirbVEAABgfvyjtjJdKO49/aXOcs/L5f/n4geW2Yye8b8L7myaeJjGovH3/vPf1oX/e+8ZBymrHR4THAwMAQGV8NiJWdRfau3qyxdT9rK0pW+7bU8h0xHCR7bN1uITbFNiAWjGJDaip+y+5uzMi/rKOLvmJGC6wpfLdIZlcYXoMPz70ArsTAABq6MTj45j3vS8undK6tfnY9+2bcfKJ+046/tgp7zsmc7xwxpdJbOm3+803Nr25b88xpd2v/mLr4JZzhv55KDwGFAAAaq4UwxPZlqd1gXsKmdsiYmEdXfKDTdlyp60J1IoSG1Bz919yd2/Ux9SvJfNX37Agtf9ByBU6YrjA1mJXAgBAch3TcmIcP/F9Mefk929qmvi+CTNOPnHfCcdOOMnjSY+MElv9G33852hRrbR3YMqOvTuO9whQAACoC4t6ssXb0rq4PYVMZwxPZUv6z982RURbU7Y8YEsCteJxokASLIiItkju9K9SRHTNX31Dat8JkskVFkTEH9uKAACQfL8o7YzBiFj5WumdjzscmeB2fmvz65OPm/jG2ZOaj2k+dsIvTHGj3u3dt2vrL36xb8/ru7ZOeHPfngmv7Hj5tIgYnajm8Z8AAFC/FnYX2ttieCpb6gpUTdny8j2FTFsk/0lInQpsQK2ZxAYkwv2X3N0WEasiee9CWBvDBbZUPvs9kyu0RsTiqI9JeAAAwNE6oOQ2ufm4Y6ac2PSLYyccM7H5uImnN2IkJrHV3ugktXL5FxNe2/nyvl+Uf9E0WlIzTQ0AABrG2hgusqXyZ3J7Cpkk/0zu+qZsebEtCNSaEhuQGPdfcndXROQTdEkPxnCBLZXvOsjkCtMj+e/6AAAAquyYlhMjIt5RdIuImNR8XOqmXSmxVdboBLXRR33uX1DbObQrduzb5ZsOAAAYVYrhIltqn460p5BJ2tORHmzKljttPSAJlNiARLn/krt7IxnvQFg0f/UNt6X2D/9coSOGC2wtdh0AAHDYJrwvjmkefjrp6Scct3vW+4/fFhEx+vjSiPopvCmxHb7RYlpExOu7tk7Y989vvm162pu/GIrte0u+TwAAgCO1pCdbXJDWxe0pZDoiGT+n2xQRbR4jCiTFBBEACbMgItqidtPBSjE8fS217/DI5Aq3RcRCWw0AADhi+/45flHaGRERL5V2Hv/S5jh0YW3kMaYRby+9RUTMmnLShGMymX0RERPed0zT+5smnibgat3Gva8P/fPeN0Z/PVpIi4jYvW/3Sdt3vTZp9Pc2735t/y91jwAAgEq6rrvQ3hYRnT3ZYuoKVk3Z8qo9hUxb1P6JSZ0KbECSmMQGJM79l9zdFhGrovrvPlgbwwW2vlT+gZ8rtEZEb0R81i4DAADqwn4T30YdWIKLiNj/kadv//L3LsUlaRLbg31/+NSE9x134bv9/oGls1Gjj+rc/2P7T0Yb5fGdAABAndkUw0W2VP7sbk8h0xoRi6M2T6m6vilbXmyLAUmixAYk0v2X3N0VEfkqnvLBGC6wpfLdBplcoS2GC2wX2F0AAAD/opzPJqbE1l1oXxV18DhRAACAKipFxIKebLE3rQvcU8gsiIg/ruIpH2zKljttLSBpjhEBkETzV9/QGxHLqnS6RfNX39CZ4gJbZwxPtlNgAwAAAAAAoJ60RES+u9Ce2qlhIxPRLovhwl6lbYqILtsKSCIlNiDJFsTwIz4rpRQRvzZ/9Q23pTXATK5wW0T8ZVT/0awAAAAAAAAwXq7rLrSv6i60t6ZxcU3Z8qqIaIvK/mw0IqKzKVsesJ2AJFJiAxJrZDJaV1TmXQdrI6Jj/uoblqcxu0yu0JrJFZZHxEI7CQAAAAAAgBT4WET0dRfa29K4uKZseWNEdETlnlZ1fVO23GcbAUmlxAYk2vzVN/TF8ES28fRgDBfYUvkiLZMrtMXw40M/awcBAAAAAACQIudExKruQntXGhfXlC0PNGXLXRFx/Tgf+sGRx5YCJJYSG5B481ff0Bvj946DRfNX39A5MuUtdTK5QmcMF9gusHMAAAAAAABIoZaIyHcX2lNbyhopnF0W4/PEqk0x/PQrgERTYgPqxYI4umfAlyLi1+avvuG2tAaUyRVui4i/HHnhDgAAAAAAAGl2XXehfVV3ob01jYtrypZXRURbHN3PSCMiOpuy5QHbBUg6JTagLoxMTuuMI3u3wdoYfnzo8jRmk8kVWjO5wvKIWGinAAAAAAAA0EA+FhF93YX2tjQurilb3hgRHXHkT626vilb7rNNgHqgxAbUjfmrb9gYhz/q9sEYLrCl8sVZJldoi+HHh37WDgEAAAAAAKABnRMRq7oL7V1pXFxTtjzQlC13RcT1h/mly0YeSwpQF5TYgLoyMk1tyRg/fdH81Td0jkxxS51MrtAZwwW2C+wMAAAAAAAAGlhLROS7C+2pLW2NFNIui7E9uWptRCywLYB6osQG1J35q29YEId+9nspIi6bv/qG29KaQSZXuC0i/nLkBTkAAAAAAAAQcV13oX1Vd6G9NY2La8qWV0XE9Hjvn5V2NWXLA7YDUE+U2IB61REHf5fB2ohom7/6hlVpXHQmV2jN5ArLI2KhLQAAAAAAAADv8LGI6OsutLelcXEjjxdti4hl7/IpC5qy5T7bAKg3SmxAXRp5RGjnAR9eFhEd81ffsDGNa87kCm0x/PjQz9oBAAAAAAAA8K7OiYhV3YX2rrQusClb7oqI3AEfXtKULfe6/UA9UmID6tbItLVFI7+8fv7qG7pGym2pk8kVOmO4wHaBOw8AAAAAAADvqSUi8t2F9t60LnCksNYew0+wWtuULS9w24F6lSmXy1IA6trzJ93++x9649Y/SO0f1LnC4oi4zp0GAAAYf+V8NpOUa+kutK+K4cfeAAAAML7WRkRHT7aYyoEYewqZ1ojhR4261UC9MokNqHvv37Hvv2/OLEzduwoyuUJrJldYFQpsAAAAAAAAcDQuiIiN3YX2tjQurilbHlBgA+qdEhtQ96aVFw1ExKrNmYWdaVlTJldoi4i+8A58AAAAAAAAGA8tEVHsLrR3iQIgeZTYgFSYVl7UFxGxObOw7t89kckVuiJiVUSc484CAAAAAADAuMp3F9p7xQCQLEpsQGpMKy9aHhGdmzMLW+t1DZlcYXFE5GP4nSAAAAAAAADA+Lu6u9De111obxUFQDIosQGpMq286LaIuK3erjuTK7RmcoVVEXGduwgAAAAAAAAVd0FEbOwutLeJAqD2lNiANFq8ObNwQb1cbCZXaIuIvoj4mFsHAAAAAAAAVdMSEcXuQnuXKABqS4kNSJ1p5UUbI6Jvc2ZhZ9KvNZMrdEXEqog4x50DAAAAAACAmsh3F9p7xQBQO0psQCpNKy9aFRGtmzMLEzv+N5MrLI6IfAy/wwMAAAAAAAConau7C+193YX2VlEAVJ8SG5Ba08qLeiOic3NmYaJeaGZyhdZMrrAqIq5zlwAAAAAAACAxLoiIjd2F9jZRAFSXEhuQdosjYkFSLiaTK7RFRF9EfMytAQAAAAAAgMRpiYhid6G9SxQA1aPEBqTatPKigYhYvjmzsOZFtkyu0BURqyLiHHcGAAAAAAAAEi3fXWjvFQNAdSixAak3rbyoLyI2bs4s7KzVNWRyhcURkY/hd24AAAAAAAAAyXd1d6G9r7vQ3ioKgMpSYgMawrTyouURMX1zZmFVn1+fyRVaM7nCqoi4zl0AAAAAAACAunNBRGzsLrS3iQKgcpTYgIYxrbxocUR0bc4srMo7JTK5QltE9EXEx6QPAAAAAAAAdaslIordhfYFogCoDCU2oNHcNvK/isrkCl0RsSoizhE5AAAAAAAApMIfdxfaez1eFGD8KbEBDWVaedFARPRuziys2LskMrlCb0TkY/gdGQAAAAAAAEB6XB0Rq7oL7dNFATB+lNiAhjOtvKgvIgY2ZxZ2judxM7lCayZX6Bt54QoAAAAAAACk0wUR0dddaO8QBcD4UGIDGtK08qLeiGjbnFk4fTyOl8kV2iJi48gLVgAAAAAAACDdWiLi8e5C+wJRABw9JTagYU0rL7otIhZsziw8qmfWZ3KFrogohseHAgAAAAAAQKP54+5Ce293ob1VFABHTokNaHS3RUTXkX5xJlfojYi8GAEAAAAAAKBhXR0Rq7oL7dNFAXBklNiAhjatvGggIlZtzizsOpyvy+QKrZlcoW/kBSkAAAAAAADQ2C6IiL7uQnuHKAAOnxIb0PCmlRf1RcTA5szCMb2gzOQKbRGxceSFKACQcN/69Q/HFdOnCAIAAAAAqLSWiHi8u9C+QBQAh0eJDSAippUXLY+Its2ZhdMP9XmZXKErIoojL0ABgIS7YvqU+K1/+0vx/YWXxY9uvEKZDQAAAACohj/uLrT3dhfaW0UBMDZKbAAjppUXLY6Irs2ZhQd9MZnJFXojIi8pAKgfd/zG+W/9/4vOm6zMBgAAAABUy9URsaq70D5dFADvTYkN4O0WR0TX/h/I5AqtmVyhb+SFJgBQJ66YPiUuOm/yOz6uzAYAAAAAVMkFEdHXXWjvEAXAoSmxAexnWnnRQEQs35xZ2BURkckV2iJi48gLTACgjvzHj/7SIX9fmQ0AAAAAqIKWiHi8u9C+QBQA706JDeAA08qLNkZE3+Jf/7P/FhHFkReWAEAdmdDSHJ/7+Nlj+tzRMttPfv8z8aUPf0B4AAAAAEAl/HF3ob1XDAAHp8QGcBDTyov6rm9peU4SAFCf7r3y/MP+mtkzTop7rvlIvHznlcpsAAAAAEAlTBcBwMEpsQG8i3I+2xsRyyQBAPXlcKawHczpU45XZgMAAAAAxtvaiOgUA8DBKbEBHEI5n+2KiCckAQD140imsB2MMhsAAAAAME5KEdHVky0OiALg4JTYAN5bZwy/MwIASLijncJ2MMpsAADA/i48pS1+/+M98Yefuj9aJjQLBAAYi86ebLFPDADvTokN4D2U89mBiOiK4XdIAAAJNl5T2A5m/zLbLZfOijjuWIEDAEADGS2vXXN5Pqaf2h5TW2fGFy/+Q8EAAO8l15MtrhIDwKFlyuWyFADG8gdmrtAREY9LAgCSaUJLcwwtnle18+0YHIo/X9EfNz7+XMTeN90AgDpVzmczSbmW7kL7qoj4mLsCkCyfPGdedMy+Oqa2zjzo7xc3PBxL19wiKADgYJb1ZItdYgB4byaxAYxROZ9dFRE5SQBAMlVyCtvBvL95YtyQ/eV44655cdenzzeZDQAAUuaT58yLu+Z9N66ac/u7FtgiItpnzI1rL/qqwACAAz2hwAYwdkpsAIehnM/2RsQySQBAskxoaY7Pffzsmpx7tMx2/7+70I0AAIA61zKhOTpnfuGt8tqk5qlj+jpFNgDgAGsjolMMAGM3QQQAh6ecz3ZlcoXp4REvAJAY1Z7CdjCff+gZNwIAAOpUy4Tm+Dez/kN8dNa/j6aJzUd0jPYZc+O333wjvtX3RwIFgMZWioiunmxxQBQAY6fEBnBkOiNiVURcIAoAqLHjjo1PXTytppfwwGMvxL7SoHsBAAB15owTTotLZ/z6UZXX9vevZ30+Xnj92Xhk0wrhAkDj6uzJFvvEAHB4lNgAjkA5nx3I5ApdMVxka5EIANTOXZfNjvc3T6zpNZjCBgAA9eWME06LXz/v2mifMXfcj33VnNsjIhTZAKAx5XqyxVViADh8SmwAR6icz/ZlcoWOiChKAwBq5Lhj43fmzazpJZjCBgAA9aOS5bX9KbIBQENa1pMt9ooB4MgosQEchZEiWy4i8tIAgOozhQ0AABiLC09pi7nn/+eYfmp71c6pyAYADeXBnmyxSwwAR06JDeAolfPZ3kyu0BYR10kDAKrIFDYAAOA91KK8tr+r5twemwaei/WlfjcDANJrbUR0iQHg6BwjAoCjV85nF0TEMkkAQPWYwgYAALybT54zL/7wU/fHNZfna1ZgG3Xd5b0xq2WmmwIA6VSKiI6ebHFAFABHxyQ2gPGzICLaIuICUQBAhZnCBgAAHMQnz5kXn/qVa2JS89TEXFPTxOa47vLeWLKyy0Q2AEgXBTaAcWQSG8A4KeezAxHRERGbpAEAlWUKGwAAMKplQnN0zvxC3DXvu3HVnNsTVWAbNVpkM5ENAFJlQU+22CcGgPGhxAYwjkaKbJ0x/M4LAKASTGEDAABGdM78Qnztyr+JKy/8ciLLa/sbLbKdccJpbhwA1L/re7LFXjEAjB8lNoBxVs5n+yKiSxIAUBlJmML2pz/8JzcCAAAS4PjjWqJpYnPdXG/TxOa45qN/Ei0Tmt08AKhfy3qyxcViABhfSmwAFVDOZ5dHRE4SADDOEjCFbc267fHoxm3uBQAAcESmts6Mmy7vVWQDgPr0RE+22CUGgPGnxAZQIeV8tjcilkgCAMbPl37lzJpPYbv5L55xIwAAICGe37q6Lq9bkQ0A6tLaiOgUA0BlKLEBVFA5n10QEcskAQDj4+b559X0/KawAQBAsuwc2lm3167IBgB1pRQRnT3Z4oAoACpDiQ2g8hbE8DszAICj8KUPfyBOn3J8Ta/BFDYAAEiW9aX+ur7+qa0z44sX/6EbCQDJVoqIjp5scaMoACpHiQ2gwsr57EBEdETEJmkAwJEzhQ0AADiYPUODdX39v3zmpXHtRV91IwEgubp6ssU+MQBUlhIbQBWMFNk6Y/idGgDAYTKFDQAAeDdbBp6v+zW0z5iryAYAyZTryRaXiwGg8pTYAKqknM/2xfBENgDgMJnCBgAAvJvde3ekYh2KbACQOMt6ssVeMQBUhxIbQBWNFNlykgCAsTOFDQAAOJSXBp5LzVraZ8yN3277L24qANTesp5ssUsMANWjxAZQZeV8tjcirpcEAIyNKWwAAMCh7N5bStV6/vWsz8cnz5nnxgJA7ayNiAViAKguJTaAGijns4sjYpkkAODQTGEDAADey4sDz6ZuTVfNuV2RDQBqY21EdPRkiwOiAKguJTaAGinns10R8aAkAODd1XoK2yvbdpvCBgAACbdzaGcq16XIBgBVV4qILgU2gNpQYgOora4YfkcHAHCAJExhu+P+dW4EAAAk3PpSf2rXpsgGAFVTiuEJbH2iAKgNJTaAGirnswMR0RGKbADwDld/7AM1Pf8r23bHN576mRsBAAB1YM/QYEWOu2WgP+783vyKHX8srppze/S5CU8AACAASURBVFx4SpubDACV1aXABlBbSmwANTZSZOuK4Xd4AAARccX0KXHReZNreg2msAEAQP3YMvB8RY47tXVmrC/1x3dW31zT9f3WpX8Ss1pmutEAUBm5nmxxuRgAakuJDSAByvlsXwxPZFNkA4CIuOM3zq/p+Rt9CtuElua4/zcviXI+G/f/5iUxoaXZpgQAINFe3/lKxY49q2Vm/O3mJ+Khp79es/U1TWyO6y7vVWQDgPG3pCdb7BUDQO0psQEkxEiRbYEkAGh0prDVzmh5bWjxvPjcx8+OiIjPffzsGFo8T5kNAIBEe23w5Yod+5zW2RERsbz/O1Hc8HDN1qjIBgDjbllPtuhncwAJocQGkCDlfLY3InKSAKCRmcJWfQcrrx1ImQ0AgCTbvvPFih377EnnvvX/l665JTa+WqzZOhXZAGDcPNiTLXaJASA5lNgAEmakyLZIEgA0IlPYqp/3e5XXDjRaZnvkdy+NK6ZPsWkBAEiE7YMvVezYp588+22/XvKDa2PLQH/N1to0sTmunvO1aJngzSUAcITWRkSXGACSRYkNIIHK+extEbFMEgA0GlPYquOK6VPiRzdeEd9feNmYy2sH+sTF0+L7Cy+LH914hTIbAAA1t2XX5oode/qp7W/7dWnfYCx78iuxZ2iwZuud2jozbrq8V5ENAA7f2ojo6MkWB0QBkCxKbAAJVc5nuyLiQUkA0ChMYatOxqPltfHK+qLzJiuzAQBQcy/v2lrR4x/4+M71pf74Hz/4vZquWZENAA5bKSK6FNgAkkmJDSDZumL4HSEAkHqmsFVOJcprB1JmAwCg1l4f3FKxY5/TOvsdH3v6tb6478lba7pmRTYAGLNSDE9g6xMFQDIpsQEkWDmfHYiIjlBkAyDlkjCF7b7HN6Yu1y99+AMVL68dSJkNAIBaKVXwkaJnTzr3oB9/ZNOKKG54uKbrnto6M667dKkNAACH1qnABpBsSmwACTdSZOuM4XeIAEAq/ZdPz67p+XcMDsWNjz+Xmjy/9OEPxMt3Xhn3XPORmpUD9y+zZc890yYHAKDiXt/5SsWOffrJ7/53lqVrbomfvPSDmq59+qntce1FX7UJAODgcj3Z4ioxACSbEhtAHSjnsxtjeCKbIhsAqTOhpTk+cfG0ml7Dn6/oj9j7Zt1nuX957fQpxyfimi46b3Lc9+X/N16+88r40oc/YMMDAFAxrw2+XLFjTz+1/ZC//2c/+q+xZaC/putvnzFXkQ0A3inXky32igEg+ZTYAOpEOZ/tC0U2AFLo3ivPr+n50zCFLYnltQOdPuX4uOeajyizAQBQMS/+/NmKHn9Wy8x3/b3SvsG454e/F3uGBmuagSIbALzNMgU2gPqhxAZQR0aKbAskAUBaTGhpjs99/OyaXkPdTmE77ti469PnJ768diBlNgAAKmX3UGXf+3lO6+xD/v7Lu7bGkpVdNc9BkQ0AImK4wNYlBoD6ocQGUGfK+WxvROQkAUAamMJ2BEbKa2/cNS9uyP5y3ZTXDqTMBgDAeOsf+GlFj3/2pHPf83PWl/rjvidvrXkW7TPmxifPmWdTANCoHlRgA6g/SmwAdWikyHa9JACoZ6awHaYDymvvb56Yin2gzAYAwHgp7avsozxPP3n2mD7vkU0r4u/W31vzPK6ac7siGwCNaG1EdIkBoP4osQHUqXI+uzgilkkCgHplCtsYpbS8dqDTpxwfN88/L265dJZvDgAAjtiWgf6KHXv6qe1j/txv9f1RFDc8XPM8FNkAaDBrI6KjJ1scEAVA/ZkgAoD6Vc5nuzK5QkTE1dIAoK7+ImIK25gyuvfK8+NTF09LbXFt1Cvbdscd96+Lbzz1M98cAAAclT1DOyp6/FktM2N9aWxFuW///ddi2qRZMbV1Zk0zuWrO7RExPCEOAFJsUyiwAdQ1k9gA6lw5n+2KiAclAUA9MYXt3U1oaY77f/OSGFo8Lz738bNTXWB7ZdvuuOaeH8cZNz2kwAYAwPi8xvx5ZV/nn9M6e8yfW9o3GHeu7Io9Q4M1z+WqObfHhae02SAApFUpIjoV2ADqmxIbQDp0xfCIZABIvCRMYfvfj72QuClsB5bX0kx5DQCAShms8CS2ySeedVifX9o3GEsSUmT7rUv/JGa1zLRJAEibUgxPYOsTBUB9U2IDSIFyPjsQER2hyAZAHaj1FLaIiN9d+ZPE5NFI5bU167bHJxY9rrwGAEDFvPjzZyt6/A+e9pHD/pr1pf74zuqba55N08TmuO7yXkU2ANJEgQ0gRZTYAFJCkQ2AepCEKWwPPPZC7CvVfgrCFdOnxCO/e2lDldcuvuvReHTjNt8IAABUzO6hUkWPP7X1Q0f0dX+7+Yl46Omv1zwfRTYAUmaBAhtAeiixAaTISJGtM4bfeQIAiXPnJb9U82v4/EPP1PT8V0yfEj+68Yr4/sLL4hMXT0v1/VZeAwCg2p5+rbI/x26a2BxnnHDaEX3t8v7vRHHDwzXPSJENgJTI9WSLvWIASA8lNoCUKeezG2N4IpsiGwDJctyx8TvzavtDklpOYdu/vHbReZNTfasfeOyFmPWVR5TXAABIpRkts4/4a5euuSU2vlqs+RqaJjbH1XO+Fi0Tmt1QAOqRAhtACimxAaRQOZ/tC0U2ABLmrstmx/ubJ9b0Gmoxha3RymsTF6yI+f9zdTy/5XWbHgCAmqh0Seysk889qq9f8oNrY8tAf81zmto6M266vFeRDYB6s0iBDSCdlNgAUmq/IhsA1F4DTmH70oc/EC/feWXDlddqNekOAACq5czW2Uf19aV9g3HPD38v9gzV/rWzIhsAdWZZT7Z4mxgA0kmJDSDFRopsOUkAUGuNNIVttLx2zzUfidOnHJ/ae7pjcCj+x1/9k/IaAACJ89OtP67o8adO+tBRH+PlXVtjycouRTYAGLtlPdlilxgA0kuJDSDlyvlsbyiyAVBLDTKFrZHKa3cXfhIn3bgifvv/PKW8BgBAw5nUPHVcjrO+1B/Ln/5viVjT1NaZcd2lS91cAJJKgQ2gASixATQARTYAaintU9gasbx24/eeidj7ps0NAEAiPb91dcXPceEpbeNynEc2rYiHnv56InKbfmp7XHvRV20gAJLmCQU2gMYwQQQAjaGcz/ZmcoWIiLw0AKiatE5hO+7YuOuy2fE782bWvKBXaa9s2x33Pb4xbnz8OcU1AAAYcVbrufH0a33jcqzl/d+Js04+N9pnzK35utpnzI1rI2LpmlvcZACSYG1EdIoBoDEosQE0kJEiW0dEXC0NAKohCVPYbv7+c+N3sAYrr91x/7r4xlM/s5EBAKgr41UuO5SzTj53XI+3dM0t8fsnnh7TT22veX6KbAAkxNqI6OjJFgdEAdAYPE4UoMGU89muiFgmCQAqLgFT2Nas2x7Pb3l9XNZy16fPjzfumhc3ZH851QW2V7btjmvu+XGccdNDCmwAAPAuJp14+rgfc8kPro0tA/2JWF/7jLkeLQpALSmwATQgJTaABqTIBkA13HLxjNpPYfuLZ47uAMprAABQlza+Wqzo8SsxMa20bzDuXNkVe4YGE5Fh+4y58clz5tlMAFSbAhtAg/I4UYAGVc5nuzK5QoRHiwJQIf9p7qyann/Nuu3x6MZtR/YXpZbmuPfK8+NzHz879fdpzbrtcfd3n4vCsy/ZtAAApMbuvTsqfo4zTjgtXt61dVyPWdo3GEtWdsV1l/dG08Tmmud41ZzbIyLikU0rbCoAqqEUEZ0KbACNySQ2gAZmIhsAlfKlD38gTp9yfE2v4UimsE1oaY77f/OSGFo8L/UFtjXrtscnFj0eF9/1qAIbAACp89LAcxU/x4yW2RU57vpSf/yPH/xeYrK8as7tJrIBUA2lGJ7AtlEUAI1JiQ2gwY0U2dZKAoDxdPP882p6/sOdwtao5bUjnVQHAABJt3tvqeLnOOvkcyt27Kdf64v7nrw1MXkqsgFQYaMFtj5RADQujxMFICKiIyJWRcQFogDgaNXTFLYPTZ0Ud3xidkM8NvSBx16IP/3hPymuAQDQEF4ceLbi5zizdXZFj//IphVxwsST4soLv5yITK+ac3tsH3wpnn5NvwCAcaXABkBEKLEBEBHlfHYgkyt0hCIbAOOgHqawXTF9StzxG+fHRedNTv39eOCxF+LzDz0T+0qDNicAAA1j59DOip9j0omnV/wcy/u/E2edfG60z5ibiFx/69I/iZ0ru2J9qd8mA2A8KLAB8BaPEwUgIoaLbDE8kc2jRQE4YkmfwnbF9CnxoxuviO8vvCz1BbYHHnshJi5YEfP/52oFNgAAGk41SlZTW2dWZS1L19wSxQ0PJyLXponNcd3lvTGrZaZNBsDRUmAD4G2U2AB4iyIbAEcrqVPYGqW8tmNwSHkNAABG7Bmq/OvhC09pq8pavv33X4stA8mYfqbIBsA46VRgA2B/SmwAvI0iGwBHKolT2LLnntkw5bW7Cz+Jk25UXgMAgFFbBp6v+DkmN59ZlbWU9g3GnSu7FNkASItcT7a4SgwA7E+JDYB3UGQD4EjUegrbcxveeGsK25c+/IF4+c4r474v/78NU1678XvPROx900YEAIARu/fuqPg5Jp94VtXWM1pkq8aEubFomtgcV8/5WrRMaLbZADgcuZ5ssVcMABxIiQ2AgxopsnVGREkaALyXJExhW/rX698qr91zzUdqfj2VpLwGAADv7aWB5yp+jg+e9pGqrqm0bzCWJKjINrV1Ztx0ea8iGwBjpcAGwLtSYgPgXZXz2Y0xPJFNkQ2AQ7r238yq+TXcc81HUl9ee2Xb7rjmnh/HSb/3f5TXAADgPWzf+WLFz9FywrSqr2t9qT+WrOxKTM6KbACMkQIbAIekxAbAIZXz2b5QZAPgEK6YPiVmzzhJEBU0Wl4746aH4htP/UwgAAAwBtsHX6r4OSY1T63J2taX+uO+J29NTNaKbAC8BwU2AN6TEhsA70mRDYBDueM3zhdChSivAQDAkduya3NVznPhKW01Wd8jm1bEQ09/PTF5T22dGdddutTGA+BACmwAjIkSGwBjosgGwMFcMX1KXHTeZEGMszXrtsdVX/+/ymsAAHAUXt61tSrnmdx8Zs3WuLz/O1Hc8HBiMp9+antce9FXbT4ARimwATBmSmwAjJkiGwAHMoVtfK1Ztz0+sejxuPiuR6Pw7EsCAQCAo/T64JaKn2PyiWfVdI1L19ySqCJb+4y5imwARCiwAXCYlNgAOCyKbACMMoVt/OxfXnt04zaBAADAOClV4ZGiHzztIzVf57f//muxZaA/MbkrsgE0PAU2AA6bEhsAh02RDYAIU9jGwwOPvaC8BgAAFfT6zlcqfo6mie+v+TpL+wbjzpVdimwAJIECGwBHRIkNgCOiyAbQ2ExhOzoPPPZCTFywIub/z9XKawAAUEGvDb5c8XNMbZ2ZiLWW9g3Gsie/EnuGBhOTf/uMudE58ws2IkDjUGAD4IgpsQFwxBTZABqXKWxHZs267W+V1/aVBgUCAAAVtn3ni1U5z6yWZBTZ1pf6Y8nKrkQV2a688MvxyXPm2YwA6afABsBRUWID4KgosgE0HlPYjtw/bBhQXgMAgCraPvhSVc5z4sQTE7Pm9aX+WP70f0vUfbhqzu2KbADppsAGwFFTYgPgqCmyATQWU9iO3K/MaBUCAABU0ZZdm6tyng+ddkmi1v3IphVx35O3JuqaFNkAUkuBDYBxocQGwLhQZANoDB+aOskUNgAAoG68vGtrVc5zSvMZiVv7I5tWxN+tvzdR13TVnNvjV6d9zMYESA8FNgDGjRIbAONGkQ0g/e74xGwhAAAAdWXLQH/FzzHpxNMTufZv9f1RFDc8nKhr+sIld8Sslpk2JkD9U2ADYFwpsQEwrhTZANJrQktzfO7jZwviKJhiBwAA1bdnaEfFzzG19UOJXf/SNbdUpcg3Vk0Tm+O6y3sV2QDqmwIbAONOiQ2AcafIBpBO9155vhAAAIC688rPn6v4OZomNkfLhObEZnDnyq54fXBLYq5HkQ2grimwAVARSmwAVIQiG0C6mMIGAADUq8EqTGKLiJjZ+sFErv/CU9riukuXxqTmqYm6LkU2gLqkwAZAxSixAVAximwA6WEK2/j50NRJQgAAgCp68efPVuU8Z7Wem6h1f/KceXHXvO/GNZfnY/qp7Ym8N00Tm+OLH12a6Cl2ALxFgQ2AilJiA6CiFNkA6p8pbOPr7KaJQgAAgCraPVSdf5Y65cQzE7He0fLaVXNuT9z0tYOZ1Dw1brq8V5ENINkU2ACoOCU2ACpOkQ2gvpnCBgAA1LP+gZ9W5Tynnzy7ZmtsmdAcn/9X/6muymv7m9o6U5ENILkU2ACoCiU2AKpCkQ2gPpnCNv4+dMqJQgAAgCoq7Rusynmmtn6o6msbLa997cq/iU+c98W6K6+9PT9FNoAEUmADoGqU2ACoGkU2gPpjCtv4+yUlNgAAqLotA/0VP0fTxOaqFbDOOOG0+O22//JWea1pYjqKX6NFNgASQYENgKpSYgOgqhTZAOpHo0xh2zE4FM9teMMNBwCAFNsztKMq55nZ+sGKHv+ME06Lay/6atz+b78X/3rW51NTXtvf1NaZce1FX7VpAWpLgQ2AqlNiA6Dq9iuybZIGQHL9f5f/cqrX98q23XFrvi9OunFFLP3r9VU7b8sJx9pcAABQZT/d+uOqnOes1nMrctxZLTPfKq+1z5ib+vvVPmOuIhtA7SiwAVATE0QAQC2U89m+TK7QFhGrIuICiQAkzHHHxr9L6RS2V7btjjvuXxffeOpnb33s+dd2Vu38vzKj1f4CAICUOuXEM8f1eBee0hZzz//PMf3U9obLsn3G3Lg2IpauucXGAqgeBTYAakaJDYCaKeezA5lcoSMU2QAS567LZsf7myemak1r1m2PZU/87G3lNQAAoDE8v3V1fOK8L1b8PKefPHtcjtPI5bX9KbIBVJUCGwA1pcQGQE0psgEk0HHHxu/Mm5ma5axZtz1u/otn4tGN29xbAACgolpOmHZUX//Jc+bFp37lmpjUPFWYI9pnzI3Onz8by/u/IwyAyihFRGdPtrhKFADUkhIbADWnyAaQLGmZwvbAYy/En/7wn8ZUXnt080DVruui8ybbZAAAUGVPv9ZXlfMcaflMee3Qrrzwy7Fr6I14ZNMKYQCMr1JEdPRki32iAKDWlNgASARFNoCESMEUtgceeyE+/9Azsa80OPYv2vumew8AAIyLC09pG1NprmVCc/ybWf8hPjzjSuW1Mbhqzu0REYpsAONHgQ2ARFFiAyAxFNkAaq9ep7DtGByK//3YC/G7K39yeOU1AACgYWx8tRjTT22v+HkmN58ZcYgS22h57aOz/n00TWx2Yw6DIhvAuFFgAyBxlNgASJT9imy9EfFZiQBUUR1OYdsxOBR/vqI/bnz8ubqapnbF9CljeswpAABQfyafeNZBP37GCafFZz50dfw/H7hSee0oXDXn9tj15o74281PCAPgyCiwAZBISmwAJE45nx2IiM5MrtAbEVdLBKA66mkK2yvbdsc3H14fX/3RhnErr61Ztz0uOm+yjQAAACn1060/rsoktg+e9pGIf/zmW78+44TT4tfPuzbaZ8x1E8bJFy65I15d2RXrS/3CADg8CmwAJJYSGwCJVc5nuzK5QoQiG0Dl1ckUtle27Y477l8X33jqZ+4ZAABwWHbvLVXlPC0nTIuIiFktM+OTs7qU1yqgaWJzXHd5byxRZAM4HGsjorMnW9woCgCSSIkNgERTZAOojqRPYVuzbnvc/d3novDsS6nIe87ZkzxOFAAAquzFgWercp5JzVPj9z/eU5Wpb41MkQ3gsKyN4QlsA6IAIKmOEQEASVfOZ7siYpkkACrnqsumJ/K61qzbHp9Y9HhcfNejFS+wlQbfrNq6Jp1wnE0HAABVtnNoZ9XOlaYCW3HDw3Hn9+bHnd+bn7hrGy2yzWqZaYMDvDsFNgDqghIbAHVhpMh2vSQAxt+XPvyBOH3K8Ym6pgceeyFmfeWRuPiuR6s2sewfNvp3PAAASDPTug5PccPDcetffTqWrrkl1pf6Y32pP+578tbEXWfTxOb44keXRsuEZjcN4J0U2ACoGx4nCkDdKOezizO5wkBE5KUBMH5unn9eYq7lgcdeiM8/9EzsKw2mOvOzT/XDFQAAqIU9Q4PRNNHr8UPl8/c/eyi++/yyeHnX1nf8/iObVkRExFVzbk/UdU9qnho3Xd4bd67sitK+QTcSYNgTEdGpwAZAvVBiA6CulPPZ3kyuEKHIBjAukjCFbcfgUPz5iv64afU/pb68NursKX5oBgAAtbBl4PlUPepzvOwZGowfrv9f8dfrv/2eJbBHNq2IWafNifYZcxO1hqmtMxXZAP7Fsp5ssUsMANQTJTYA6o4iG8D4qfUUtjXrtsfFf/KDiL1v1jyLNS/83IYAAICU2713hxD28/rglnhqw0NjKq/tb+maW+LaCEU2gGRSYAOgLh0jAgDqUTmf7Y2IyyKiJA2AI5OEKWw3/8UziSiwRURs31W96zipeaINCAAANfDSwHNCiOHy2n1P3ho3rvhM3PuP3zyiwte3//5rsWWgP3FrGy2yATQoBTYA6pYSGwB1q5zProqIjlBkAzgiSZjC9ujGbQ2Z/ewZJ9mAAABQA7v3NvY/I+1fXntk04qjOlZp32DcubIrsUW2ay/6qg0PNJpFCmwA1DMlNgDqWjmf7QtFNoDDlpgpbAAAAFX04sCzDbnuja8W456VuXEpr+2vtG8w7vnh78WeoeQ9urN9xlxFNqCR5HqyxdvEAEA9U2IDoO7tV2TbJA2AsTGF7Z0adSocAAA0kp1DOxtqvaPltT94rDuefq2vIud4edfWWLKyS5ENoHZyPdlirxgAqHdKbACkwkiRrS0i1koD4NCSMIXt7u8+1/D34YrpU2xGAACosvWl/oZYZ3HDw3Hn9+ZXtLx2YK7fWX1zIrNQZANSrBQKbACkiBIbAKlRzmcHYngimyIbwCHUegrbK9t2R+HZl9wIAACgJl4f3JLatRU3PBy3/tWnY+maW6pe2PvbzU/EfU/emshc2mfMjc6ZX7D5gTQpRUSHAhsAaaLEBkCq7Fdke0IaAO+UPffMmk9hu+P+dYnNZ8fgkE0CAAApV9q1OVXr2TM0GH+3/t63ymsv79pas2t5ZNOK+P66P0tkTlde+OX45DnzfAMAqfhPWQwX2PpEAUCaKLEBkDrlfHagnM92RMQyaQC83Q2fmV3T87+ybXd846mfJTafn2x4o2rn+szsqTYkAADUwOs7X0nFOvYMDcb31/1ZfOWhT8W3+v6opuW1/d37j9+M4oaHE5nZVXNuV2QD6t2mUGADIKUmiACAtCrns12ZXCEi4mppAERcMX1KXHTe5JpeQ5KnsAEAAI3htcGX6/r6Xx/cEk9teCj+ev23o7RvMJHXuHTNLfH7J54e009tT9y1XTXn9ogYnhoHUGfWxnCBbUAUAKSRSWwApFo5n+2KiEWSAIi44zfOr+n5kz6FDQAAaAzbd75Yl9f9+uCWuO/JW+PGFZ+Je//xm4ktsI1a8oNrY8tAfyKv7ao5t8evTvuYbwagniiwAZB6SmwApF45n70tInKSABqZKWxj88K26v0Q6Femt9qYAABQA9sHX6qr692/vFZP08NK+wbjzpVd8frglkRe3xcuuSNmtcz0DQHUgwdDgQ2ABqDEBkBDKOezvaHIBjQwU9jG5oVXq1dia2k+1sYEAIAa2LJrc11c58ZXi3HPylzdldf2V9o3GH/2w2tjz1DypsY1TWyO6y7vVWQDkm5ZT7bYqcAGQCNQYgOgYYwU2S6LiJI0gEZiChsAAMC/eHnX1kRf32h57Q8e646nX+ur+7zXl/pjycquRF6bIhuQcMt6ssUuMQDQKJTYAGgo5Xx2VUR0hCIb0EBMYUumM6ecIAQAAKiRJD7isrjh4bjze/NTU17b3/pSf9z35K2JvDZFNiChcgpsADQaJTYAGk45n+2L4SLbWmkAaWcK2+FZ88LPq3au06ccb4MCAECNlBL0SNHihofj1r/6dCxdc0usL/WnNvNHNq2Ih57+eiKvrWlic3zxo0ujZUKzbw4gCXI92WKvGABoNEpsADQkRTagUdR6CtuOwaG6msK2fdebNg0AADSAV37+XE3Pv2doMP5u/b1vldeS/ojT8bK8/ztR3PBwIq9tUvPUuOnyXkU2oJZKEXGZAhsAjUqJDYCGVc5nB2K4yPaENIA0SsIUtj9f0e9GHMpxx8oAAABqYHBoR03Ou2doML6/7s/iKw99Kr7V90cNU17b39I1tyS2yPb6zldiavM03yBALZQioqMnW1wlCgAa1QQRANDIRotsmVyhNyKulgiQJv/xo79U0/PvGByKGx9/zo04hCumtcajG7cJAgAAquzFnz9b1fO9PrglntrwUPz1+m9Had9gw+f/7b//WkybNCumts5MxPUUNzwc/2fd0oYsFQKJsDYiunqyxT5RANDIlNgAICLK+WxXJleIUGQD0vJCv6U5Pvfxs2t6DX++oj9ib309nlOhDAAAGsPuoVLVzrVloD/+69/MF/p+SvsG486VXXHT5b01LbIprwEJsDaGJ7ANiAKARudxogAwopzPdkVEThJAGtx75fk1Pb8pbAAAQJL1D/y0audq9XjKgyrtG4xlT34l9gxVdzLd6CNdr/+LX42la25RYANq6YlQYAOAtyixAcB+yvlsbyiyAXXOFLb68ZnZU4UAAAA1UM1HejZNbI6WCc1CP4j1pf5YsrKrKkW20fLaVx76VNz7j9/0WFeg1pb1ZIsKbACwHyU2ADjASJGtPSJK0gDqkSlsR3/9AABA+m0Z6K/auWa2flDg72J9qT++s/rmih3/9cEtcd+TtyqvAUmypCdb7BIDALydEhsAHEQ5n+2LiI5QZAPqjClsR+8nG96wkQAAoAHsGdpRMttnJgAAIABJREFUtXOd1XquwA/hbzc/Efc9eeu4HnO0vHbjis/EI5tWKK8BSZHryRYXiAEA3kmJDQDexUiRbXpErJUGUC9MYasvv/qvpggBAABq5JWfV+/vLqeceKbA38Mjm1bE362/96iPs/HV4tvKawAJUYqIX+vJFntFAQAHN0EEAPDuyvnsQCZX6IiI5RHxMYkAiX5xbwobAADAmA1WcRLb6SfPFvgYfKvvj+L4Y0+K9hlzD/trN75ajIef+e/x9Gt9ggSSphQRHT3Zoj+gAOAQTGIDgPdQzmcHyvlsR0QskwaQZKawjY9/2DBgMwEAQAN48efPVu1cU1s/JPAxWrrmltj4anHMn/+Tl34Q96zMxR881q3ABiTR2lBgA4AxUWIDgDEq57NdEbFEEkASJWEK29/8aHMqprCVdlVvDb884ySbFwAAamT3UKlq52qa2BwtE5qFPkZLfnBtbBnoP+TnFDc8HLf+1afj6//3OuU1IKkU2ADgMCixAcBhKOezCyIiJwkgaWo9hS0i4vMPPeNGHKb3N08UAgAA1Ei1i08zWz8o9DEq7RuMO1d2xZ6hwXf83mh5bemaW+LlXVuFBSTVshgusBn5DwBjNEEEAHB4yvlsbyZXGIiI3ohokQhQc8cdG5+6eFpNL+GBx16IfaVB9wIAAOBdTG4+M8LEsDEr7RuMJSu74rrLeyMi4ofr/1f89fpvR2mfv3sCibesJ1vsEgMAHB6T2ADgCJTz2eUR0RERJWkAtXbFtNaaX0OaprB997ktVT3fhBaPFAIAgFrZ+GqxaueafOJZAj9M60v9ccf3fiO+8tCn4t5//KYCG1APcgpsAHBklNgA4AiV89m+iJgeEWulAdTSoxu3xUk3roi7Cz+JV7btrvr5TWE7Oh2TlNgAAKARfPC0jwjhCLy8a6vyGlAPShHxaz3ZYq8oAODIKLEBwFEo57MDMTyR7QlpADW198248XvPxBk3PRTX3PPjqpbZ0jSFDQAAaCw/3frjqp2r5YRpAgdIp1JEdPRki8tFAQBHTokNAI5SOZ8dKOezHRGxTBpAEnzjqZ9VrcyWxilsL+wZqur5Jp9wrE0LAAANYFLzVCEApM/aiGjryRb7RAEAR0eJDQDGSTmf7YqI6yUBJEU1ymxpnML2/JbXq3q+i84+2WYFAIBavf7furqq57vwlDahA6THEzE8gW2jKADg6CmxAcA4KueziyMiF8PjwwESoVJltjROYQMAAKikyc1nCgEgHZb1ZIsdPdnigCgAYHwosQHAOCvns70R0RGKbEDCjHeZLY1T2AAAgMby9GvVffrb5BPPEjpA/bu+J1vsEgMAjC8lNgCogHI+2xcRbRGxVhpA0oyW2T6x6PFYs277ER0j7VPYKvX41YP51X81xaYEAIAa2jNUvb/bfPC0jwgcoH6VIiLXky0uFgUAjD8lNgCokHI+uzGGJ7I9IQ0giR7duC0uvuvRIyqz/ekP/ynV2by0bZcNAgAADWLLwPNVO1fLCdMEDlCfShHR0ZMt9ooCACpDiQ0AKqiczw6U89mOiFgmDSCpDrfMtmbd9nh04zbBAQAAqbB7746qnWtS81SBA9SftRHR1pMt9okCACpHiQ0AqqCcz3ZFRE4SQJKNtcx28188I6xxdNF5k4UAAAA19NLAc1U936yWmUIHqB8PxvAEto2iAIDKUmIDgCop57O9EfFrMTx2HCCxDlVma5QpbP+wYcBGAACABrF7b3X/qebUE84QOkB9WNaTLXb2ZIv+oQgAqkCJDQCqqJzPLo+IjojYJA3+f/bu7UfS/C4P+FOWDWENmTFgMJh4epPIWBFoeqSIhKvplcjpansu0O9yu27JTa+4iKIkoucPSNSTyCjKRb01QVFUUi56iCEJIaE6iUIORm93DsQGC3dDIIvB2SrwOIa19Obird7umZ1Tn+r4+Uil6elZzys98u7sdj/1fGHenZTZfvBv/kL+2b/9zSSrs8I2/vof+z8AAACsiN8a/epUn/envvPPCR1g/nV7pd4SAwBMjxIbAExZU5WDJOtJDqUBLIJfe+fd/PjP/HI+sv25lVhhm4VPf+JjQgAAgBn52ntfm+rzfuDmZ4QOML/GSd7olbovCgCYLiU2AJiBpiqjtItsD6UBLIpvjh8L4Zp86k98RAgAADAjXxx/aarP+9i3f7/QAebTYZKNXqmHogCA6VNiA4AZaaoyaqqyleS+NADmy7/4wjtCAACAFfKN96b3pp1P3PyzAgeYP/tpC2wHogCA2VBiA4AZa6qyk6SbdqYcgBX06e/+diEAAMAMvTP6tak+7wdvKLIBzJGHvVJv9Eo9EgUAzI4SGwDMgaYq/bTnRRXZAFbQn1FiAwCAmXr3a78z1ed9/LVPCh1gPnR7pd4SAwDMnhIbAMyJpioHSdaSHEoDYLZ+8xvvCQEAAFbI7z/+7ak+7099558TOsBsjZO80St1XxQAMB+U2ABgjjRVGaVdZHsoDYDZ+bV33p3q82689i1CBwCAGfrq135rqs/7gZufETrA7Bwm2eiVeigKAJgfSmwAMGeaqoyaqmwleVsaAKvhh1+/KQQAAJihrz7+31N93rd963cIHWA29tMW2A5EAQDzRYkNAOZUU5XdJPfSzpoDAAAAcE3e+fr/merz1j5+R+gA0/ewV+qNXqlHogCA+aPEBgBzrKnKXtrzosfSAJiuL3z5D4QAAAAr4re//rtTf+YnX/tewQNMT7dX6i0xAMD8UmIDgDnXVOUgyXramXMApuQPHr83tWf9yA99l8ABAGDG3n38zlSf94nXvk/oANdvnOROr9R9UQDAfFNiA4AF0FRl1FRlI8lDaQAAAABcvfGUT4p++nt/VOgA1+swyXqv1AeiAID5p8QGAAukqcpWkq4kAAAAAK7Wu1/7nak+77s/+kmhA1yfh0k2eqU+EgUALAYlNgBYME1V+knupJ1BB+Ca/If/+ZWpPu/Tn/iY0AEAYIZ+//FvT/V5H/v27xc6wPV4u1fqrV6pR6IAgMWhxAYAC6ipykGStbRz6AAsgU/9iY8IAQAAZuirX/utqT5v7eN3hA5wtcZJ7vVKvSsKAFg8SmwAsKCaqoyaqqynnUUHAAAA4BK++vh/T/2Zn3ztewUPcDUO054P3RMFACwmJTYAWHBNVbaSvC0JgKv17tf/aKrP+4ufck4UAABm6UujX5/6Mz/x2vcJHuDyHqUtsB2IAgAWlxIbACyBpiq7Sd5IO5cOwBX4T7/57lSf97HXvlXoAAAwQ+NvPp76Mz/9vT8qeIDLud8r9Wav1CNRAMBiU2IDgCXRVGWYZD3tbDoAAAAA5/TO6EtTfd5HP/IdQge4mHGSe71S74gCAJaDEhsALJGmKkdJNpI8lAbAYvnUxz8qBAAAmLFvvPeHU33e93/nZ4QOcH6Hac+H7okCAJaHEhsALJmmKqOmKltJ3pYGwMUN353uKaFPfY8SGwAAzNrv/N8vTPV5n7j5aaEDnM+jtAW2A1EAwHJRYgOAJdVUZTfJG2ln1QE4p2+OHwsBAABWzOMpL7EBcC73e6Xe7JV6JAoAWD5KbACwxJqqDJOspZ1XB2CO/cmPfkQIAAAwY7/1f391Ks/5xnuP86//xz/K3/zZvyJ0gJcbJ7nXK/WOKABgeX1YBACw3JqqjJKsd7qDfpK3JAIwnz7z+p8UAgAAzNj/e+96B+3fffxOPv/ln83Pf/EfZ/xN688Ar+AwyWav1EeiAIDlpsQGACuiqcpWpzsYJqmkAfBqvvDlP1AuAwCAFfKl0a9fy+/77uN38q/++2fzC8efEzLAq3uYZNv5UABYDUpsALBCmqr0O93BQZK9JLckAvBif/D4PSEAAMAKuep1NOU1gAt7u1fqXTEAwOr4kAgAYLU0VTlIsp5kXxoA8+XH1r5HCAAAMGNHv1dfye/x2X/TzU9+7q8psAGczzjJGwpsALB6LLEBwApqqjJKstHpDnaS/JREAAAAAC7v6Pfq/Nx/+/v5ld8/EAbA+R0m2XA+FABWkxIbAKywpio7k/Oi/SQ3JALwpP/wP7+SH/mh7xIEAACskF//3f+atY/fOdf/pv7yz+UXvtjPF8dfEiDAxTzolXpbDACwupwTBYAV11RlL8lG2ne5ATBDf/FTHxMCAAAskPrLP5e/88//av7Bf/nbCmwAFzNO0lVgAwCU2ACANFU5SFtkeygNgFM/+UtfyN8b/K/84eP3pvK8j732rUIHAIAZ+7Xf/eUX/vo33nuc//jFf/p+ee23v/67QgO4mJPzoX1RAADOiQIASZKmKqMkW53uYJikkghAkj/64/zkv/xv+clf+kJ+4od/IH/rx38o3/893yYXAABYQd9473H+/Rf/SX7+i/84428+FgjA5TxMst0r9UgUAECixAYAPKWpSr/THRwk2UtySyIASf7oj/PTn/+N/PTnfyM/8ef/9LWV2X547aasAQBgxn7l9w+e+Pm7j9/J57/8s8prAFfn7V6pd8UAAJylxAYAfEBTlYNOd7CepJ/kTYkAnLrOMtuNj36LgAEAYE68+/id/Kv//tn8wvHnhAFwNY6TbPZKfSAKAOBpSmwAwDNNzotudrqDnSQ/JRGAJ01jmQ0AAJiNz/6b7gcW2QC4lP20BTbnQwGAZ/qQCACAF2mqspPkjSRjaQB80E9//jfyyb/xs/nrn/2v+Z2v/L9L/V4/8D2vCRQAAOaAAhvAlbrfK/WGAhsA8CJKbADASzVVGSZZS/tuOQCe4WyZ7b/8j69e6Pew5gYAAAAskXGSN3ql3hEFAPAySmwAwCtpqjJqqrKR5L40AJ7vpz//G/kLf/cX85fu/9KFy2wAAAAAC24/yVqv1ENRAACvQokNADiXyXnRe3FeFOCFfvHoKxcrs33rtwgPAAAAWGQPnA8FAM5LiQ0AOLemKntJ1pMcSgPgxc5bZvux77spNAAAAGARjZPc65V6WxQAwHkpsQEAF9JU5aipynqSB9IAeLkLL7MBAAAAzL/DJOu9Uu+JAgC4CCU2AOBSmqpsx3lRgFd2tsz2r//z/xEIAAAAsOge9Eq93iv1kSgAgItSYgMALs15UYDz+8Wjr+Qv/8N/l49sfy7/7N/+5vuf/2uf+YRwAAAAgEXgfCgAcGWU2ACAK+G8KMDFfHP8OD/+M7/8gTIbAAAAwBxzPhQAuFIfFgEAcJWaqmx3uoNhkn6SGxIBeDUnZTYAAACAOXe/V+odMQAAV8kSGwBw5SbnRdeS7EsDAAAAAGApjJO8ocAGAFwHJTYA4Fo0VRk1VdlIcl8aAAAAAAALbT/JWq/UQ1EAANdBiQ0AuFZNVXaSvJH2XXoAAAAAACyW+71Sb/RKPRIFAHBdlNgAgGvXVGWY9rzoI2kAAAAAACyE4zgfCgBMiRIbADAVk/Oim0nelgYAAAAAwFx7lGTd+VAAYFqU2ACAqWqqspvkTtp38QEAAAAAMF/e7pV60/lQAGCalNgAgKlrqnKQZD3JQ2kAAAAAAMyFwyR3eqXeFQUAMG1KbADATEzOi24l6SYZSwQAAAAAYGYeJtnolfpAFADALCixAQAz1VSln3aV7VAaAAAAAABTNU5yr1fqLedDAYBZUmIDAGauqcpRU5X1JPelAQAAAAAwFftJ1nul3hMFADBrSmwAwNxoqrKT5I04LwoAAAAAcJ3u90q90Sv1kSgAgHmgxAYAzJWmKsMka0keSQMAAAAA4EodJ7nTK/WOKACAeaLEBgDMnaYqo6Yqm0nejlU2AAAAAICr8DDt+dADUQAA80aJDQCYW01VdpNsJDmUBgAAAADAhYyT3OuVeqtX6pE4AIB5pMQGAMy1pioHTVXWkzyQBgAAAADAueynXV/bEwUAMM+U2ACAhdBUZTvJG0mOpQEAAAAA8FL3e6Xe6JX6SBQAwLxTYgMAFkZTlWGS9SSPpAEAAAAA8EzHSe70Sr0jCgBgUSixAQALpanKqKnKZpJukrFEAAAAAADe9yDt+dADUQAAi0SJDQBYSE1V+mlX2falAQAAAACsuHGSe71Sb/dKPRIHALBolNgAgIXVVOWoqcpGkvvSAAAAAABW1KMka71S74kCAFhUSmwAwMJrqrKT5E6SQ2kAAAAAACtinOTtXqk3ra8BAItOiQ0AWApNVQ6SbCR5IA0AAAAAYMkdJlnvlXpXFADAMviwCACAZdFUZZRku9Md7CXpJ7klFQAAAABgydzvlXpHDADAMrHEBgAsnaYqwyTrSR5JAwAAAABYEodJ7iiwAQDLSIkNAFhKTVVGTVU2k9xLMpYIAAAAALDAHiTZ6JX6QBQAwDJSYgMAllpTlb0ka7HKBgAAAAAsnuMkb/RKvd0r9UgcAMCyUmIDAJbemVW2t2OVDQAAAABYDA+SrPdKPRQFALDslNgAgJXRVGU3yXqSfWkAAAAAAHNqnOSe9TUAYJUosQEAK6WpylFTlY1YZQMAAAAA5s+jJGu9Uu+JAgBYJUpsAMBKssoGAAAAAMyRk/W1TetrAMAqUmIDAFbWmVW2+9IAAAAAAGbE+hoAsPKU2ACAlddUZSfJnSSH0gAAAAAApsT6GgDAhBIbAECSpioHTVXWY5UNAAAAALh+1tcAAM5QYgMAOMMqGwAAAABwjcZJ3ra+BgDwJCU2AICnWGUDAAAAAK7BfpL1Xql3RQEA8CQlNgCA57DKBgAAAABcgXGSbq/UG71SH4kDAOCDlNgAAF7AKhsAAAAAcAmPkqz1St0XBQDA8ymxAQC8AqtsAAAAAMA5jJPc65V6s1fqkTgAAF5MiQ0A4BU9tco2lggAAAAA8Awn62t7ogAAeDVKbAAA5zRZZVtPsi8NAAAAAGDC+hoAwAUpsQEAXEBTlaOmKhtJ3o5VNgAAAABYddbXAAAuQYkNAOASmqrsxiobAAAAAKyq41hfAwC4NCU2AIBLOrPK1o1VNgAAAABYFQ+SrFtfAwC4PCU2AIAr0lSln2Qt7ekAAAAAAGA5HSd5o1fqbetrAABXQ4kNAOAKNVUZNVXZTHIvVtkAAAAAYNncT7u+NhQFAMDVUWIDALgGTVX20q6yPZAGAAAAACy8wyR3eqXesb4GAHD1PiwCAIDr0VRllGS70x3sJeknuSUVAAAAAFgo4yS7vVLviAIA4PpYYgMAuGZNVYZNVdbSnhoAAAAAABbDftrToTuiAAC4XkpsAABT0lRlJ8mdtF/8AgAAAADm0zhJt1fqjV6pj8QBAHD9lNgAAKaoqcpBU5WNJG+n/WIYAAAAADA/HiVZ65W6LwoAgOlRYgMAmIGmKrtJ1tN+UQwAAAAAmK3jJG/0Sr3ZK/VIHAAA06XEBgAwI01VjpqqbCa5l/aLZAAAAADA9N1Pst4r9VAUAACzocQGADBjTVX20q6yPZAGAAAAAEzNfpI7vVLvWF8DAJitD4sAAGD2mqqMkmx3uoN+kn6S21IBAAAAgGsxTrLTK/WuKAAA5oMlNgCAOdJU5aCpynqSt9N+MQ0AAAAAuDqPkqwpsAEAzBclNgCAOdRUZTftidFH0gAAAACASztO8kav1JtOhwIAzB8lNgCAOdVU5aipymaSe2m/yAYAAAAAnN/9JOu9Ug9FAQAwn5TYAADmXFOVvbSrbPelAQAAAACvbD/J671S71hfAwCYbx8WAQDA/GuqMkqy0+kO9pLsJrkrFQAAAAB4pnGS7V6p+6IAAFgMltgAABZIU5WDpiobSbppvxgHAAAAAJx6kGRNgQ0AYLEosQEALKCmKv0ka2m/KAcAAAAAq+4wyZ1eqbedDgUAWDzOiQIALKjJidHtMydGb0sFAAAAgBUzTrLTK/WuKAAAFpclNgCABddUZdhUZT3J23FiFAAAAIDV8TDt6VAFNgCABafEBgCwJJqq7KY9MfpQGgAAAAAsscMkb/RKveV0KADAcnBOFABgiUxOjG51uoN+nBgFAAAAYLk4HQoAsKQssQEALCEnRgEAAABYMk6HAgAsMSU2AIAl5sQoAAAAAAvO6VAAgBXgnCgAwJJzYhQAAACABeR0KADACrHEBgCwIs6cGO3GiVEAAAAA5teDOB0KALBSlNgAAFZMU5V+2hOjD6QBAAAAwBzZT3KnV+ptp0MBAFaLc6IAACtocmJ0+8yJ0btSAQAAAGBGjtOeDu2LAgBgNVliAwBYYU1VDpqqbCS5l/aLhQAAAAAwTfeTrCuwAQCsNiU2AADSVGUvyXraLxqOJQIAAADANXuU5PVeqXecDgUAwDlRAACSvH9idGdyYnQnyVtSAQAAAOCKHSfZ6pV6KAoAAE4osQEA8ISmKkdJtiZltt0kt6UCAAAAwCWNk+z0Sr0rCgAAnuacKAAAz9RUZdhUZT1JN06MAgAAAHBxD5KsKbABAPA8SmwAALxQU5V+krUk96UBAAAAwDnsJ3m9V+rtXqlH4gAA4HmcEwUA4KWaqoyS7Jw5MfqmVAAAAAB4juMkW71SD0UBAMCrUGIDAOCVNVU5SrLZ6Q420pbZbksFAAAAgIlxkh1nQwEAOC/nRAEAOLemKsOmKutJumm/OAkAAADAanuQZE2BDQCAi1BiAwDgwpqq9JOsJbkfZTYAAACAVbSf5PVeqbd7pR6JAwCAi3BOFACAS2mqMkqy0+kO+kl2krwlFQAAAICld5hku1fqoSgAALgsJTYAAK5EU5WjJFtnymx3pQIAAACwdI6T7PRK3RcFAABXxTlRAACuVFOVYVOVjST30n5REwAAAIDFN05yP8m6AhsAAFfNEhsAANeiqcpekr1Od7CddpnthlQAAAAAFtLDtKdDR6IAAOA6WGIDAOBaNVXZTbKW9p26AAAAACyO/SSv90q9pcAGAMB1ssQGAMC1a6oySrLT6Q76aVfZ3pIKAAAAwNw6TLu8NhQFAADToMQGAMDUNFU5SrLV6Q52k+wmuSsVAAAAgLlxnGSnV+q+KAAAmCYlNgAApq6pykGSjU53sJG2zHZbKgAAAAAzM06y2yv1jigAAJiFD4kAAIBZaaoybKqynqSb9p2+AAAAAEzX/SRrCmwAAMySJTYAAGauqUo/Sb/THewk2U5yQyoAAAAA1+ph2tOhR6IAAGDWLLEBADA3mqrsJFlL+w7gsUQAAAAArtx+ktd7pd5SYAMAYF5YYgMAYK40VRkl2el0B/0kO0nekgoAAADApe2nXV4bigIAgHmjxAYAwFxqqnKUZGtyYnQnymwAAAAAF3GcZLtX6j1RAAAwr5TYAACYa2fKbP20Zba7UgEAAAB4qeO0y2t9UQAAMO+U2AAAWAhNVYZJNjrdwUaU2QAAAACeZ5y2vLYrCgAAFsWHRAAAwCJpqjJsqrKR5F7adxQDAAAA0JbX7idZU2ADAGDRWGIDAGAhNVXZS7LX6Q620i6z3ZIKAAAAsILGSXaT7PZKPRIHAACLSIkNAICF1lSln6Q/KbPtJrkhFQAAAGBFPEx7OvRIFAAALDLnRAEAWAqTMtta2rMZY4kAAAAAS+xhktd7pd5SYAMAYBlYYgMAYGk0VRkl2el0B7tJticvy2wAAADAsrC8BgDAUlJiAwBg6SizAQAAAEtmP8l2r9QHogAAYBkpsQEAsLSeUWb7KakAAAAAC2Q/7fLaUBQAACwzJTYAAJbemTJbP8lOkrekAgAAAMwx5TUAAFaKEhsAACujqcpRkq1Od7ATZTYAAABg/iivAQCwkpTYAABYOcpsAAAAwJxRXgMAYKUpsQEAsLKU2QAAAIAZU14DAIAosQEAgDIbAAAAMG3KawAAcIYSGwAATCizAQAAANdMeQ0AAJ5BiQ0AAJ6izAYAAABcMeU1AAB4ASU2AAB4DmU2AAAA4JKU1wAA4BUosQEAwEsoswEAAADnpLwGAADnoMQGAACv6Bllts0kNyQDAAAATCivAQDABSixAQDAOZ0ps91Msj15KbMBAADA6lJeAwCAS1BiAwCAC2qqMkqy0+kOdqPMBgAAAKvoYZLdXqkPRAEAABenxAYAAJekzAYAAAAr52Ha5bUjUQAAwOUpsQEAwBV5qsy2lbbMdksyAAAAsDSU1wAA4BoosQEAwBWblNl2k+x2uoOtJDtRZgMAAIBFNU7ST3s29EgcAABw9ZTYAADgGjVV6SfpK7MBAADAwhln8ia1XqlH4gAAgOujxAYAAFNwpsy2kbbMdlcqAAAAMJeOc7q8prwGAABToMQGAABT1FRlmGRDmQ0AAADmznGSnV6p+6IAAIDpUmIDAIAZOFNmW0tbZntLKgAAADATh2lX1/qiAACA2VBiAwCAGWqqcpRkq9Md7KQts20muSEZAAAAuHb7aZfXhqIAAIDZUmIDAIA5cKbMdjPJ9uSlzAYAAABX72Ha5bUDUQAAwHxQYgMAgDnSVGWUZKfTHeymXWXbSXJLMgAAAHAp4yR7aZfXjsQBAADzRYkNAADm0KTM1k/S73QHW2mX2W5LBgAAAM5lnGQ37fLaSBwAADCflNgAAGDONVXppy2zbaRdZrsrFQAAAHih47Sra31RAADA/FNiAwCABdFUZZhko9MdrKUts70lFQAAAHjCftrVtT1RAADA4lBiAwCABdNU5SjJVqc72E57ZnQ7yQ3JAAAAsMIeJun3Sj0UBQAALB4lNgAAWFBNVUZJdjrdwW6SzbTrbLckAwAAwIoYJ+mnXV47EgcAACwuJTYAAFhwkzJbP0m/0x1spl1muysZAAAAltRxkt20y2sjcQAAwOJTYgMAgCXSVGUvyV6nO1hPW2Z7SyoAAAAsif20xbW+KAAAYLkosQEAwBJqqnKQZKvTHewk2UpbaLshGQAAABbQw7TltaEoAABgOSmxAQDAEmuqcpRkJ8lOpzvYmnx8SzIAAADMuXGSfpLdXqmPxAEAAMtNiQ0AAFZEU5V+kn6nO9hIu8z2plQAAACYM8dp34C11yv1SBwAALAalNgAAGDFNFUZJhl2uoO1tGW2rTg1CgAAwGztJ9lxMhQAAFaTEhsAAKyoyalnTyL3AAAQRklEQVTR7U53sJO2yLYdp0YBAACYnnGSvbTltSNxAADA6lJiAwCAFddUZZRkN8lupzvYTFtmuysZAAAArsnx5L9D+06GAgAAiRIbAABwRlOVvSR7To0CAABwDR4l2XUyFAAAeJoSGwAA8AFPnRrdTLITp0YBAAA4v3GSftry2pE4AACAZ1FiAwAAnmtyarSfpN/pDjbSLrO9JRkAAABe4jDtydA9J0MBAICXUWIDAABeSVOVYZLhZJ1ta/KyzgYAAMBZD5P0nQwFAADOQ4kNAAA4l8mp0Z0kO53uYCttme2uZAAAAFbWcU5PhlpdAwAAzk2JDQAAuLCmKv20p0bX0hbbNpPckAwAAMBKeJR2dW1PFAAAwGUosQEAAJc2WWfb6nQHN9MW2baT3JYMAADA0hnndHXtSBwAAMBVUGIDAACuTFOVUdpvZvQ73cF62jLbW5IBAABYePtpV9f6ogAAAK6aEhsAAHAtmqocpF1n206ylbbQdksyAAAAC8PqGgAAMBVKbAAAwLWarLPtJtntdAcbaQtt1tkAAADml9U1AABgqpTYAACAqWmqMkwytM4GAAAwd6yuAQAAM6PEBgAATJ11NgAAgLlhdQ0AAJg5JTYAAGCmnlpn20y7znZbMgAAANfG6hoAADBXlNgAAIC5MFln6yfpd7qD9bRlts0kN6QDAABwJR4l2bO6BgAAzBslNgAAYO40VTlIstXpDm6mLbJtJbkrGQAAgHM7zuQNQ1bXAACAeaXEBgAAzK2n1tnWcrrOdks6AAAAL/Qw7eranigAAIB5p8QGAAAshKYqR2lLbNud7uBkne1NyQAAALzvMKerayNxAAAAi0KJDQAAWDhNVfaS7E3OjW5NXrclAwAArKBxTotrB+IAAAAWkRIbAACwsCbnRneT7Ha6g/WcFtpuSAcAAFhyj9IW15wLBQAAFp4SGwAAsBSaqhzEuVEAAGC5ORcKAAAsJSU2AABg6Tg3CgAALBHnQgEAgKWnxAYAACyt55wb3UxySzoAAMCccy4UAABYGUpsAADASnjGudHNJG9JBgAAmCOHad+Is+dcKAAAsEqU2AAAgJVz5tzodtoy22aSNyUDAADMwHFOz4UeiQMAAFhFSmwAAMDKmpwb7Sfpd7qDtbRltq0kt6UDAABco3GSvSS7vVIfiAMAAFh1SmwAAABJmqocpT3bs9vpDtbTltk2k9ySDgAAcEUepj0VuicKAACAU0psAAAAT2mqcpBkO8l2pzvYyGmh7YZ0AACAc3qUdnVtr1fqkTgAAAA+SIkNAADgBZqqDJMMk6TTHWymLbO9JRkAAOAFDpP0k/QV1wAAAF5OiQ0AAOAVNVXZS7LX6Q6205bZNpO8KRkAACCnxbW9XqmPxAEAAPDqlNgAAADOqanKKJNVhU53cDMKbQAAsKqO054K7fdKfSAOAACAi1FiAwAAuISnCm1ractsW0luSwcAAJaS4hoAAMAVU2IDAAC4Ik1VjpLsJtlVaAMAgKWiuAYAAHCNlNgAAACugUIbAAAsPMU1AACAKVFiAwAAuGYKbQAAsDDGaYtre71S74kDAABgOpTYAAAApkihDQAA5s7J4tper9RDcQAAAEyfEhsAAMCMKLQBAMDMOBUKAAAwR5TYAAAA5oBCGwAAXDvFNQAAgDmlxAYAADBnniq03UxbaNtM8qZ0AADgXA6TDKO4BgAAMNeU2AAAAOZYU5VRkn6SvkIbAAC8ksPJv0Pv9Up9JA4AAID5p8QGAACwIM4W2pKk0x2cFNo2k9yQEAAAK+xR2sU1xTUAAIAFpMQGAACwoJqq7CXZS5JOd7CR00LbLekAALDkxpmU1tIW10YiAQAAWFxKbAAAAEugqcow7TfxtjvdwXpOC223pQMAwJI4zuna2p44AAAAlocSGwAAwJJpqnKQ5CDJTqc7WEtbZttI8qZ0AABYMIdpi2v9XqkPxAEAALCclNgAAACWWFOVoyS7SXY73cHNtGW2k5W2GxICAGAO7ef0TOiROAAAAJafEhsAAMCKaKoyyuSbgUnS6Q42clpouyUhAABmZDz5d9Rh2uLaSCQAAACrRYkNAABgRTVVGab9RuG2s6MAAEyZM6EAAAC8T4kNAACAF50d3YiVNgAArsajnK6tHYkDAACAE0psAAAAPOEZZ0fX05bZtpLclhAAAK/oePLvlMNeqffEAQAAwPMosQEAAPBCTVUOkhzkdKXtZKFtM8kNCQEAcIa1NQAAAM5NiQ0AAIBXNllp609eJyttJ6W2uxICAFg51tYAAAC4NCU2AAAALuzMSlsmK20bOS213ZIQAMDSGaddWhvG2hoAAABXRIkNAACAKzFZadubvE5W2jYmrzclBACwsA5zWlobigMAAICrpsQGAADAtTiz0rabJJ3uYCOnK223JQQAMLeO8+Ta2kgkAAAAXCclNgAAAKaiqcow7TdCT06PnhTaNuL0KADALJ09ETrslfpAJAAAAEyTEhsAAABTNzk92p+80ukO1vJkqe2GlAAArtV+TktrQ3EAAAAwS0psAAAAzFxTlaO0Z0dPTo+upy2zbSa5KyEAgEs7zJNra06EAgAAMDeU2AAAAJg7TVUOkhzktNS2kdOVNqU2AICXO05bWNuL0hoAAABzTokNAACAuddUZZj2m7BJkk53cPb06G0JAQC8X1obpi2tHYkEAACARaHEBgAAwMJpqrKXdlUkne7gZk4LbRtRagMAVoPSGgAAAEtDiQ0AAICF1lRllLbQptQGACwzpTUAAACWlhIbAAAAS+XpUluSdLqDjZyW2u5KCQBYAEprAAAArAwlNgAAAJZeU5Vh2m8AJ/lAqW09yQ0pAQAzdpgnS2sjkQAAALAqlNgAAABYOc8ota3nyROkSm0AwHXbz2lp7UBpDQAAgFWmxAYAAMDKa6pykOQgyW6SdLqDtTy51HZbSgDAJYzzZGFtKBIAAAA4pcQGAAAAT2mqcpSkP3ml0x3czGmhbSPJXSkBAC9wchr0IO1p0CORAAAAwPMpsQEAAMBLNFUZJdmbvJI8cYL05MdbkgKAlTTOpKwWp0EBAADgQpTYAAAA4ALOnCBNYq0NAFbIYU5Lawe9Uh+IBAAAAC5HiQ0AAACuwAvW2s4utt2WFAAslOO0hbWTs6BDkQAAAMDVU2IDAACAa3Jmra1/8rlOd7CR01LbepwhBYB5sp/JwlralbUjkQAAAMD1U2IDAACAKWqqMkz7zfEkzzxDup7khqQA4Nrt53RlzVlQAAAAmCElNgAAAJih55whXcvpUttGFNsA4LIU1gAAAGCOKbEBAADAnGmqcpTkKIptAHARCmsAAACwYJTYAAAAYAG8QrHt5HVLWgCsEIU1AAAAWAJKbAAAALCgnlNsu5nTtba1yce3pQXAgjue/Jk3zGlh7UgsAAAAsByU2AAAAGCJNFUZpf0G//Ds5zvdwUZOS20nL+dIAZhHh2mLakeTP88OeqUeiQUAAACWlxIbAAAArICmKsOnPzc5R7qWdrVtffKx1TYApuXsutpRnAMFAACAlaXEBgAAACvqzDnS4dnPd7qDk6W2tZyeJb0lMQAuaJzJCdDJnzsn50CtqwEAAABJlNgAAACApzRVOSkaPOHMSdK1KLcB8Gz7aYtqR3EKFAAAAHhFSmwAAADAK3nWSdJEuQ1gBT1rWe2oV+oj0QAAAAAXocQGAAAAXMpLym03054mXZ98fFdiAAvjOKeLaqM4AwoAAABcEyU2AAAA4FqcKbftnf18pztYS7vWtv7Uj9bbAGbj7AnQk1W1A7EAAAAA06LEBgAAAExVU5WjnC77PKHTHTxdbDv5+IbkAC5lP6draif/HLaqBgAAAMwFJTYAAABgbjRVOUhbsNh7+teeOk+6duZlwQ2gpagGAAAALCQlNgAAAGAhPO88afL+gtvNJBuTT21Mfn5bcsASOc7pyc+TstqoV+qhaAAAAIBFpsQGAAAALLzJglvy7BOlJ+ttz/pRyQ2YJycltQ+8eqU+Eg8AAACwrJTYAAAAgKXWVGWU03Lbs1bcni63JaeLbnclCFyhw7QLakdRUgMAAAB4nxIbAAAAsNJeVnJLnjhXuvbUK1F0A1onK2onZz5z5p8tB71Sj0QEAAAA8GxKbAAAAAAvceZc6XM9o+iWnC66rSW5JUlYWPuTH4/ywaKaghoAAADAJSmxAQAAAFyBVym6JUmnO9iYfLiWD5bdbia5LU2YipPltKQtpJ0U0YaTH534BAAAAJgSJTYAAACAKWqqMnyVv67THazltOR2svL2rI9vSBXed5gPltHOfjzqlfpATAAAAADzRYkNAAAAYA41VTnK6UrU8GV//ZlzpsmTK28305bdTii+sSjOFtLO/v3wxN8TvVIPRQUAAACw2JTYAAAAAJbAq54zPavTHTxdcFvLafntWT937pTzGKc903nW8MzHo6d+3flOAAAAgBWlxAYAAACwopqqjPIKK28v0ukONp761NPFuBMbz/icUtx8eVbpLPngCtrzPnfQK/VIjAAAAACclxIbAAAAABfWVGX4jE/vXfb3fUY57qznFeWedvbE6iJ4lTW94Sv8NaOX/F7KZgAAAADMlU7TNFIAAAAAAAAAAABgJj4kAgAAAAAAAAAAAGZFiQ0AAAAAAAAAAICZUWIDAAAAAAAAAABgZpTYAAAAAAAAAAAAmBklNgAAAAAAAAAAAGZGiQ0AAAAAAAAAAICZUWIDAAAAAOD/t2vHAgAAAACD/K2Hsac4AgAAANhIbAAAAAAAAAAAAGwkNgAAAAAAAAAAADYSGwAAAAAAAAAAABuJDQAAAAAAAAAAgI3EBgAAAAAAAAAAwEZiAwAAAAAAAAAAYCOxAQAAAAAAAAAAsJHYAAAAAAAAAAAA2EhsAAAAAAAAAAAAbCQ2AAAAAAAAAAAANhIbAAAAAAAAAAAAG4kNAAAAAAAAAACAjcQGAAAAAAAAAADARmIDAAAAAAAAAABgI7EBAAAAAAAAAACwkdgAAAAAAAAAAADYSGwAAAAAAAAAAABsJDYAAAAAAAAAAAA2EhsAAAAAAAAAAAAbiQ0AAAAAAAAAAICNxAYAAAAAAAAAAMBGYgMAAAAAAAAAAGAjsQEAAAAAAAAAALCR2AAAAAAAAAAAANhIbAAAAAAAAAAAAGwkNgAAAAAAAAAAADYSGwAAAAAAAAAAABuJDQAAAAAAAAAAgI3EBgAAAAAAAAAAwEZiAwAAAAAAAAAAYCOxAQAAAAAAAAAAsJHYAAAAAAAAAAAA2EhsAAAAAAAAAAAAbCQ2AAAAAAAAAAAANhIbAAAAAAAAAAAAG4kNAAAAAAAAAACAjcQGAAAAAAAAAADARmIDAAAAAAAAAABgI7EBAAAAAAAAAACwkdgAAAAAAAAAAADYSGwAAAAAAAAAAABsJDYAAAAAAAAAAAA2EhsAAAAAAAAAAAAbiQ0AAAAAAAAAAICNxAYAAAAAAAAAAMBGYgMAAAAAAAAAAGAjsQEAAAAAAAAAALCR2AAAAAAAAAAAANhIbAAAAAAAAAAAAGwkNgAAAAAAAAAAADYSGwAAAAAAAAAAAJsAn0db7kNB5a8AAAAASUVORK5CYII=</xsl:text>
	</xsl:variable>

	<xsl:variable name="Image-Logo-BIPM-Metro">
		<xsl:text>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</xsl:text>
	</xsl:variable>

	<xsl:template name="insert_Logo-BIPM-Metro">
		<fo:block-container absolute-position="fixed" left="47mm" top="67mm">
			<fo:block>
				<fo:instream-foreign-object content-width="118.6mm" fox:alt-text="Image Logo">								
					<svg xmlns="http://www.w3.org/2000/svg" height="547.66" width="547.66" version="1.0">
						<path id="path4" d="m543.54 276.94a276.23 276.23 0 1 1 -552.47 0 276.23 276.23 0 1 1 552.47 0z" transform="matrix(.95831 0 0 .95831 17.669 8.4373)" fill="#fff"/>
						 <path id="path6" d="m382 55.094c-2.56 0-7.13 3.091-7.91 5.344-1.88 5.447-2.31 5.759-1.81 1.312 0.32-2.85 0.14-4.688-0.47-4.688-2.15 0-6.03 2.346-6.03 3.657 0 0.988-0.64 1.191-2.22 0.687-4.12-1.314-5.15-0.987-5.47 1.75-0.16 1.461 0.23 3.597 0.85 4.75 0.92 1.723 0.79 2.38-0.69 3.5-0.99 0.75-2.98 1.358-4.44 1.375-3.34 0.04-4.08 1.18-2.28 3.563 1.98 2.616 1.81 4.344-0.44 4.344-1.05 0-2.17 0.416-2.5 0.937-0.36 0.596-33.67 0.916-90.06 0.844-82.35-0.106-89.47-0.26-89.47-1.75 0-1.939-1.85-3.969-3.62-3.969-0.71 0-1.31 0.772-1.32 1.719 0 0.947-0.37 2.298-0.84 3.031-0.49 0.774-0.64-1.666-0.34-5.812 0.5-6.969 0.47-7.112-1.63-6.563-1.78 0.467-2.29 0.077-2.78-2.375-1.05-5.272-5.15-4.555-5.19 0.906-0.01 2.427-1.12 2.744-4.03 1.188-1.33-0.711-2.52-0.695-3.93 0.062l-2.04 1.063 1.97 3.312c2.08 3.518 1.88 4.438-1 4.438-2.27 0-2.32 1.74-0.09 4.281 1.61 1.837 1.61 1.92 0.03 1.344-1.57-0.571-4.73 1.495-4.69 3.062 0.01 0.367 1.42 1.65 3.13 2.844l3.12 2.156-2.59 0.969c-2.98 1.134-4.92 4.21-4.06 6.437 0.76 1.988 5.9 2.038 6.65 0.063 0.81-2.113 2.25-1.806 2.88 0.594 0.4 1.561 1.05 1.891 2.59 1.411 1.47-0.47 2.03-0.24 2.03 0.87 0 0.85 0.59 1.56 1.31 1.56 2.14 0 4.64-3.438 5.26-7.216 0.71-4.436 3.15-5.477 5.62-2.438 1.02 1.251 2.55 3.165 3.44 4.25 0.88 1.085 2.71 2.704 4.09 3.594 3 1.93 4.29 6.75 6.38 23.94 0.79 6.5 2.47 14.74 3.71 18.34 2.3 6.64 7.35 15.6 8.79 15.6 0.43 0 0.75 0.48 0.75 1.09s0.79 1.84 1.75 2.72c2.04 1.88 7.53 9.13 7.71 10.19 0.07 0.4 0.27 5.06 0.41 10.34l0.25 9.59 0.72-7.12c0.85-8.07 1.56-10.46 2.81-9.69 0.48 0.29 1.2 1.98 1.6 3.75 1.61 7.17 2.93 36.36 1.43 31.75-0.52-1.62-0.85-4.58-0.75-6.59 0.11-2.02-0.12-3.97-0.5-4.35-1.93-1.93-0.29 22.53 1.94 28.85 0.48 1.35 0.35 1.49-0.56 0.65-0.66-0.6-1.81-6.12-2.59-12.28-2.86-22.5-2.99-23.12-3.85-21.19-0.48 1.08 0.02 7.74 1.19 16.22 1.09 7.93 1.83 14.58 1.66 14.78-0.18 0.2-2.01 0.05-4.07-0.37-3.7-0.77-3.71-0.81-0.9-1.38l2.81-0.56-4.28-4.66c-5.51-5.94-10.39-8-16.75-7.12l-4.78 0.66v-4.04c0-2.21 0.4-4.03 0.9-4.03s2.31-1.2 4.03-2.65c2.79-2.35 3.09-3.05 2.63-6.5-0.35-2.57-1.6-4.97-3.69-7.13l-3.12-3.28 3.06-3.91c3.29-4.15 3.83-6.44 1.84-7.71-2.35-1.51-8.11-3.24-10.84-3.25-3.68-0.02-7.98 4.18-7.1 6.96 0.58 1.8 0.42 1.95-1.34 1-2.83-1.51-6.21-1.31-8.81 0.5-2.11 1.48-2.41 1.41-4.81-1-1.4-1.4-3.51-2.53-4.72-2.53-8.22 0-17.78 11.67-10.32 12.6 1.35 0.17 4.34 1.01 6.66 1.87 4.2 1.56 4.22 1.57 2.34 3.63-3 3.3-4.29 6.47-3.65 9 0.81 3.21 6.27 9.28 8.37 9.28 1.57 0 4.94 2.84 4.94 4.15 0 0.31-1.2 0.86-2.69 1.22-4.9 1.21-11.85 6.72-13.75 10.88-0.98 2.16-3.11 6.27-4.72 9.12-2.38 4.25-3.36 5.14-5.37 5-2.59-0.17-5.55 0.81-7.66 2.54-0.69 0.56-1.84 1.49-2.53 2.03-0.68 0.54-2.64 2.28-4.34 3.84l-3.1 2.81-6.09-5.28c-4.892-4.24-6.849-6.83-9.842-13.16-2.583-5.45-4.963-8.9-7.719-11.15-2.288-1.87-3.969-4.1-3.969-5.25 0-1.19-0.819-2.22-2-2.53-1.382-0.36-1.825-1.06-1.438-2.28 0.308-0.97 0.127-2.06-0.437-2.41-0.599-0.37-0.815-2.15-0.469-4.31 0.402-2.52 0.143-4.21-0.781-5.16-0.87-0.89-1.324-3.59-1.313-7.5 0.022-7.2-1.811-9.49-6.937-8.62-2.025 0.34-3.481 0.05-4.281-0.91-1.067-1.29-1.505-1.31-3.594 0.06-1.303 0.86-2.375 2.4-2.375 3.41s-1.116 2.55-2.469 3.44c-1.612 1.05-2.425 2.52-2.406 4.21 0.036 3.2 4.833 8.68 8.375 9.57 1.719 0.43 3.11 1.76 4.031 3.97 0.768 1.83 2.635 4.13 4.156 5.06 1.522 0.93 2.587 2.18 2.376 2.81-0.212 0.63 0.247 1.75 1.031 2.47 1.028 0.95 1.3 2.72 0.937 6.28-0.425 4.18-0.11 5.6 2.188 9.41 1.494 2.47 3.954 5.32 5.468 6.34 1.68 1.13 3.554 3.92 4.782 7.13 2.146 5.6 4.968 10.29 4.968 8.25 0.001-0.68-1.116-3.49-2.5-6.22-1.383-2.73-2.312-5.46-2.093-6.1 0.337-0.97 4.593 7.05 4.593 8.66 0.001 0.31 0.943 2.55 2.094 5 2.328 4.95 1.909 7.13-0.531 2.75l-1.563-2.81 0.25 3.93c0.205 3.26-0.134 4.1-1.968 4.91-1.218 0.54-2.219 1.34-2.219 1.75s-0.684 0.72-1.531 0.72c-2.435 0-7.956 4.71-9.282 7.91-1.519 3.66-0.294 5.42 4.469 6.31 3.207 0.6 4.862 2.52 2.188 2.53-1.81 0.01-5.807 6.32-5.125 8.09 0.679 1.77 4.408 3.3 8.656 3.57 1.268 0.08 1.676 0.79 1.469 2.37-0.335 2.56 3.4 9.09 5.687 9.97 1.669 0.64-0.08 2.88-7.718 10.13-4.699 4.45-5.423 7.06-6.25 21.84-0.39 6.96-1.275 13.29-2.032 14.75-0.729 1.41-4.971 7-9.437 12.47-6.854 8.38-10.685 12.09-17.969 17.34-0.541 0.39-2.246 1.85-3.812 3.22-1.567 1.37-2.966 2.47-3.094 2.47-0.063 0-0.337-0.44-0.75-1.22l0.531 7.94 4.937 2.87c-0.651-1.08 0.805-1.44 5-1.44 4.263 0 6.007-0.53 8.876-2.71 1.958-1.5 3.562-3.13 3.562-3.63s1.116-2.1 2.469-3.56c1.352-1.46 2.437-3.19 2.437-3.84 0-0.66 1.468-2.56 3.219-4.19l3.156-2.94 1.188 2.25c1.015 1.94 0.694 3.19-2.188 9.06-1.842 3.75-3.358 7.8-3.375 9-0.019 1.43-1.049 2.74-3 3.75-3.26 1.69-5.038 5.05-4.25 8.07 0.437 1.67 0.104 1.85-2.75 1.46-2.273-0.31-2.996-0.12-2.312 0.6 0.541 0.57 3.181 1.17 5.844 1.34 2.762 0.18 4.987 0.83 5.218 1.53 0.223 0.68-0.334 1.25-1.281 1.25s-1.434 0.29-1.063 0.66c0.967 0.97 9.794 0.39 10.907-0.72 0.587-0.58-0.241-0.94-2.219-0.94-1.731 0-3.156-0.38-3.156-0.87 0-0.5 3.12-0.84 6.906-0.75 3.786 0.08 6.874 0.5 6.875 0.9 0.001 0.41 1.949 0.72 4.313 0.72 5.443 0 20.842 2.68 23.432 4.06 2.75 1.48 17.39 1.13 27.35-0.62 4.6-0.81 10.13-1.47 12.31-1.47s5.03-0.72 6.31-1.62l2.35-1.66-0.6 3.63c-0.7 4.31-0.01 4.46 7.28 1.59 3.16-1.24 6.15-1.8 7.82-1.44 2.52 0.55 2.6 0.8 1.59 3.47-1.49 3.96-0.34 4.6 5.03 2.78 3.75-1.27 6.93-1.45 16.91-0.9 6.76 0.37 13.05 0.32 13.94-0.1 0.88-0.42 2.89-0.78 4.43-0.75 1.55 0.03 4.79 0.07 7.22 0.06 7.22-0.01 23.66 4.03 20.25 4.82l4.94 4.93 8.34-5.9c-0.23-0.08-0.37-0.13-0.28-0.22 0.85-0.84 5.83-1.52 14.75-1.97 7.42-0.37 17.25-0.99 21.85-1.34 4.63-0.36 10.21-0.2 12.53 0.34 2.44 0.57 4.43 0.61 4.75 0.09 0.3-0.48 2.2-0.87 4.25-0.87 2.24 0 5.8-1.15 8.9-2.85 4.65-2.53 5.94-2.8 13.07-2.56 5.77 0.2 9.37-0.22 13.34-1.59 6.9-2.37 10.77-2.37 12.84 0 1.82 2.07 9 3.56 9 1.87 0-0.67 0.53-0.6 1.44 0.16 2.03 1.69 18.25-0.15 18.25-2.06 0-0.47 1.66-0.85 3.66-0.85 3.94 0 3.48-1.44-0.72-2.31-1.35-0.28-0.7-0.34 1.47-0.12 5.01 0.5 7.91 1.04 12.69 2.28 2.23 0.58 5.93 0.67 8.87 0.22 2.77-0.43 8.02-0.66 11.69-0.5 4.31 0.18 7.93-0.21 10.22-1.16 2.5-1.05 3.84-1.18 4.59-0.44 1.29 1.3 6.53 1.4 6.53 0.13 0-0.51-1.43-1.13-3.19-1.35l-3.18-0.37 3.53-0.16c2.89-0.13 3.71 0.27 4.62 2.28 1.11 2.43 1.35 2.47 12.88 2.47 6.43 0 13.04 0.27 14.68 0.6l2.76 0.59 7.21-2.59 5.13-17.63c-2.18 3.66-3.05 3.89-5.78 4.09-6.24 0.48-8.37-3.32-11.5-20.46-0.94-5.14-2.33-11.35-3.06-13.78-1.2-3.95-2.51-11.38-3.85-21.63-0.66-5.08-2.05-11.56-3.94-18.22-0.91-3.24-2.07-8.53-2.56-11.78s-1.35-7.91-1.87-10.34c-0.53-2.44-0.95-8.45-0.97-13.35-0.03-4.89-0.45-9.33-0.91-9.84-0.76-0.85-2.08-5.49-3.53-12.44-0.87-4.17 0.46-10.41 3-13.87 2.99-4.08 3.76-5.83 5.81-13.13 1.36-4.82 2.69-6.96 6.47-10.62 3.7-3.59 4.87-5.49 5.35-8.69 1.49-9.97-0.81-15.22-5.6-12.66-8.57 4.58-10.26 5.94-12.09 9.75-1.08 2.24-2.87 4.34-3.97 4.63-4.51 1.17-11.34 9.84-11.34 14.4-0.01 1.79-2.28 4.16-3.16 3.29-0.3-0.3-2.08 1.04-3.94 2.96-2.45 2.53-3.72 5.06-4.62 9.16-1.94 8.75-2.09 8.88-9.63 9.34-3.89 0.24-9.34 1.44-13.12 2.91-5.51 2.14-7.21 2.38-11.6 1.69-2.83-0.45-5.92-1.05-6.84-1.35-2.21-0.71-8.22-13.57-8.81-18.84l-0.47-4.13 3.78-0.53c2.09-0.3 6.93-0.86 10.72-1.21 3.78-0.36 7.33-0.96 7.87-1.35s2.74-1.22 4.91-1.84c2.16-0.63 5.18-2.14 6.72-3.38 2.47-1.99 2.91-3.24 3.78-10.62 0.54-4.59 0.68-14.75 0.34-22.6-0.57-13.08-0.84-14.77-3.5-20.34-5.49-11.5-20.47-24.43-25.9-22.34-1.57 0.6-1.57 0.76 0 2.5 0.91 1.01 2.18 1.84 2.84 1.84s1.73 0.6 2.34 1.34c0.86 1.03 0.72 1.68-0.5 2.69-1.26 1.05-1.45 2.38-0.97 6.5 0.73 6.2-0.04 7.8-6.81 14.41-6.03 5.89-13.39 10.69-18.78 12.25-5.68 1.64-5.63 1.67-4.94-3.41 0.52-3.76 0.18-5.52-1.97-9.91-1.43-2.92-3.97-6.32-5.65-7.56-3.93-2.9-10.69-5.5-14.28-5.5-4.8 0-12.93 3.17-16.19 6.32-2.96 2.85-2.97 3-0.94 3.31 1.17 0.18 2.36 1.01 2.69 1.87 0.68 1.77-2.01 5.22-4.06 5.22-0.75 0-1.6 0.66-1.91 1.47-0.76 1.97-2.31 1.89-2.31-0.13 0-1.93 2.76-4.2 5.15-4.24 0.95-0.02 1.72-0.52 1.72-1.1 0-0.59-0.82-0.77-1.87-0.44-1.32 0.42-2.02 0.05-2.28-1.18-0.3-1.4-0.8-1.04-2.5 1.68-1.47 2.35-2.19 5.03-2.19 8.38 0 5.38 3.29 15.28 5.5 16.53 2.08 1.18 1.66 3.62-0.97 5.69-1.8 1.41-2.41 3.02-2.75 7.09-0.3 3.64-1.12 6.01-2.59 7.59-1.18 1.27-2.16 3.02-2.16 3.88s-0.58 2.43-1.31 3.5-2.78 5.71-4.53 10.31-3.54 9.13-4.03 10.07c-0.5 0.93-0.96 2.71-1 3.93-0.04 1.23-0.93 3.57-1.97 5.19s-2.74 4.71-3.78 6.88c-1.6 3.3-1.91 3.56-1.97 1.59-0.04-1.29 0.82-3.83 1.94-5.63 1.81-2.93 1.97-4.36 1.53-14.12-0.53-11.61 0.39-16.32 3.31-17.25 3.39-1.08 6.74-7.7 9.22-18.22 3.95-16.74 4.56-22.39 4.56-40.78v-17.47l6-6.09c6.7-6.86 8.44-10.16 11.69-22.22 2.75-10.21 3.97-17.17 4.59-25.57 0.47-6.3 0.59-6.45 6.1-11.53 3.07-2.828 5.88-5.144 6.24-5.152 0.37-0.009 0.98-2.577 1.38-5.688 0.65-5.09 0.8-5.393 1.5-2.812 1.07 3.911 4.81 6.298 4.81 3.062 0-1.654 2.5-2.02 3.44-0.5 0.33 0.541 1.48 0.969 2.53 0.969 2.66 0 2.48-3.649-0.31-6.688l-2.22-2.406 2.22 1.344c1.22 0.742 2.22 1.665 2.22 2.062 0 0.825 5.3 3.719 6.81 3.719 0.55 0 1.5-0.934 2.12-2.094 0.98-1.828 0.69-2.519-2.03-5.062-2.4-2.249-3.01-3.457-2.56-5.25 0.45-1.783 0.2-2.344-1.09-2.344-1.32 0-1.42-0.238-0.5-1.156 0.65-0.649 1.18-2.026 1.18-3.063 0-1.513 0.42-1.767 2.19-1.187 1.22 0.397 3.57 0.803 5.19 0.875 2.78 0.122 2.94-0.083 2.94-3.594 0-2.175 0.58-4.115 1.4-4.625 2.04-1.257-0.4-3.969-3.56-3.969-1.96 0-2.29-0.367-1.78-1.969 0.45-1.429 0.19-1.968-1-1.968zm-2.31 2.156c0.8-0.108 0.85 1.148-0.5 3.219-0.9 1.369-2.04 2.5-2.57 2.5-1.42 0-1.16-1.206 0.94-3.938 0.9-1.169 1.64-1.716 2.13-1.781zm-10.94 2.781c0.54 0 0.98 0.543 0.97 1.219s-0.45 1.907-0.97 2.719c-0.74 1.15-0.96 0.858-0.97-1.25-0.01-1.488 0.43-2.688 0.97-2.688zm15.69 1.344c0.29-0.018 0.54-0.015 0.75 0.063 0.84 0.324 1.33 0.79 1.09 1.031-1.16 1.164-7.72 3.367-7.72 2.593 0-1.319 3.84-3.56 5.88-3.687zm-23.66 1.719c0.44-0.019 1.21 0.547 2.34 1.687 1.88 1.877 1.96 2.323 0.69 3.125-2.24 1.426-2.65 1.184-3.22-1.75-0.39-2.053-0.37-3.038 0.19-3.062zm-204.72 3.281c0.07-0.016 0.11-0.016 0.19 0.031 0.54 0.335 1 2.598 1 5 0 2.403-0.46 4.344-1 4.344s-0.97-2.232-0.97-4.969c0-2.684 0.3-4.294 0.78-4.406zm225.66 0.719c1.32-0.047 2.75 0.724 2.75 1.75 0 1.227-1.95 1.316-3.78 0.156-0.98-0.617-1.05-1.05-0.22-1.562 0.35-0.218 0.81-0.329 1.25-0.344zm-12.97 2.844c0.81-0.03 2.13 0.381 2.94 0.906 1.8 1.162 0.23 1.162-2.47 0-1.3-0.558-1.44-0.871-0.47-0.906zm-221.22 0.937c0.57 0.001 1.66 0.356 3.28 1.094 1.38 0.628 2.5 1.973 2.5 2.969 0 2.4-0.31 2.299-4.09-1.157-2.1-1.915-2.63-2.908-1.69-2.906zm13.13 1.5c0.36-0.043 0.52 1.09 0.53 3.625 0.01 2.57-0.13 4.688-0.31 4.688-1.77 0-2.26-5.45-0.69-7.876 0.17-0.266 0.34-0.423 0.47-0.437zm195.28 1.406c2.58 0 6.99 2.538 5.78 3.313-0.2 0.127-1.12 0.806-2.06 1.531-0.95 0.725-1.75 0.948-1.75 0.469s-0.95-1.341-2.13-1.875c-3.46-1.562-3.38-3.438 0.16-3.438zm13.22 0c0.23 0 0.72 0.459 1.06 1 0.33 0.541 0.13 0.969-0.44 0.969s-1.03-0.428-1.03-0.969 0.17-1 0.41-1zm2.03 3.969c1.96 0.016 1.96 0.054 0 1.219-2.56 1.512-6.38 2.031-6.38 0.875 0-1.005 3.36-2.119 6.38-2.094zm-223.63 1.125c0.33-0.012 0.67-0.006 1.06 0.031 1.76 0.17 3.22 0.74 3.22 1.282 0 1.1-3.29 1.604-5.18 0.812-2.15-0.897-1.4-2.043 0.9-2.125zm18.03 2.437c0.33 0.009 0.56 0.835 0.91 2.688 0.7 3.744 1.43 4.289 3.25 2.469 0.6-0.602 1.61-0.768 2.25-0.375 0.78 0.481 0.47 1.091-1.03 1.844-2.45 1.23-4.07 4.241-1.78 3.312 4.83-1.964 5.29-1.89 2.81 0.312-2.3 2.044-2.32 2.125-0.31 1.5 1.99-0.619 2.07-0.507 1 1.813-0.64 1.372-1.41 2.527-1.72 2.531-1.05 0.015-5.96-8.222-6.5-10.906-0.3-1.47-0.09-3.438 0.44-4.375 0.29-0.53 0.49-0.818 0.68-0.813zm207.72 0.844c0.09-0.012 0.18-0.004 0.28 0 0.23 0.011 0.5 0.076 0.82 0.188 2.18 0.775 5.15 3.288 5.15 4.375 0 1.281-2.23 0.897-4.68-0.813-2.19-1.521-2.81-3.562-1.57-3.75zm-221.53 0.719c3.12-0.082 5.7 0.327 6.28 1.031 0.76 0.914-0.27 1.188-4.4 1.188-7.32 0-9.03-2.031-1.88-2.219zm31.13 0.75c3.19 0 3.84 0.336 3.84 1.969 0 1.729-0.65 1.968-5.41 1.968-3.96 0-5.4-0.369-5.4-1.374 0-1.77 2.16-2.563 6.97-2.563zm103.59 0c5.33 0 7.42 0.364 7.81 1.375 0.29 0.759 0.26 1.645-0.06 1.969-0.32 0.323-3.84 0.593-7.81 0.593-6.56 0-7.22-0.18-7.22-1.968 0-1.79 0.66-1.969 7.28-1.969zm64.28 0c1.22-0.008 2.22 0.459 2.22 1 0 1.232-1.03 1.232-2.94 0-1.19-0.771-1.07-0.988 0.72-1zm-85.03 0.125c0.9-0.008 2.04 0.029 3.5 0.094 5.28 0.233 6.58 0.604 6.84 2 0.29 1.515-0.52 1.718-7 1.718-6.92 0-7.37-0.108-6.87-2 0.35-1.355 0.84-1.788 3.53-1.812zm-73.78 0.438c0.15-0.016 0.3-0.006 0.47 0 11.3 0.361 12.03 0.477 12.03 1.843 0 1.951-0.55 2.052-8.19 1.719-5.7-0.248-6.62-0.545-6.34-1.969 0.17-0.884 0.95-1.487 2.03-1.593zm23.72 0.437c5.37 0 7.42 0.346 7.81 1.375 0.29 0.767-0.15 1.653-0.97 1.969-0.82 0.315-4.34 0.562-7.81 0.562-5.66 0-6.31-0.174-6.31-1.937 0-1.79 0.66-1.969 7.28-1.969zm18.28 0c5.46 0 6.91 0.298 6.91 1.469s-1.45 1.468-6.91 1.468c-5.47 0-6.88-0.297-6.88-1.468s1.41-1.469 6.88-1.469zm16.72 0c5.46 0 6.9 0.298 6.9 1.469s-1.44 1.468-6.9 1.468c-5.47 0-6.88-0.297-6.88-1.468s1.41-1.469 6.88-1.469zm74.84 0c4.55 0 7.78 0.396 7.78 0.969 0 0.579-3.45 1-8.4 1-5.37 0-8.2-0.374-7.82-1 0.34-0.541 4.14-0.969 8.44-0.969zm14.75 0c2.41 0 3.74 0.375 3.38 0.969-0.34 0.541-2.14 1-4 1-1.87 0-3.38-0.459-3.38-1s1.81-0.969 4-0.969zm25.81 0.375c0.36-0.067 1.08 0.515 2.38 1.812 1.46 1.46 2.43 2.882 2.15 3.157-0.9 0.901-4.84-2.475-4.84-4.157 0-0.482 0.1-0.772 0.31-0.812zm-60.5 0.062c4.08-0.069 8.12 0.264 8.32 1.032 0.14 0.584-3.3 1.08-8.47 1.25-6.77 0.222-8.58 0.018-8.25-0.969 0.26-0.775 4.33-1.243 8.4-1.313zm49.82 0c0.47 0.033 0.53 0.614 0.53 1.969 0 4.746-4.95 12.24-9.91 14.939-5.56 3.02-6.77 5.42-7.78 15.59-1.5 15.08-6.35 32.05-8.75 30.56-0.44-0.27-2.07 0.92-3.59 2.63-1.72 1.93-2.32 3.26-1.6 3.5 0.75 0.25 0.23 1.67-1.47 4-2.96 4.09-8.22 8.68-8.22 7.19 0.01-0.55 1.35-1.97 2.97-3.13 1.63-1.15 2.94-2.51 2.94-3.03s-1.29 0.02-2.91 1.22c-3.28 2.43-3.92 2.23-3.96-1.22-0.07-5.98 1.51-10.52 4.65-13.16 1.76-1.47 3.22-3.29 3.22-4.06 0-0.76 0.46-1.37 1.03-1.37 0.58 0 0.8-0.45 0.47-0.97-0.32-0.53-1.88 0.48-3.47 2.22-3.95 4.35-3.7 1.83 0.72-6.53 3.65-6.92 4.52-8.28 6.91-10.94 0.67-0.76 1.22-1.77 1.22-2.28 0-0.52 0.68-1.52 1.53-2.22 0.84-0.7 2.22-2.52 3-4.03 1.24-2.41 1.22-2.67-0.03-2.19-1.22 0.47-1.25 0.07-0.25-2.72 1.5-4.2 3.19-6.04 8.15-8.87 5.07-2.905 10.22-7.264 10.22-8.629 0-0.576-0.92-1.062-2.03-1.062-1.22 0-1.74-0.414-1.34-1.063 0.36-0.593 1.94-0.916 3.5-0.687s2.84 0.098 2.84-0.313c0-1.242-3.77-2.058-6.12-1.312-1.97 0.622-2.1 0.563-0.91-0.875 0.74-0.89 2.23-1.625 3.28-1.625s2.77-0.471 3.81-1.032c0.62-0.33 1.06-0.519 1.35-0.5zm-211.29 0.532c1.07 0 2.77 0.589 3.76 1.312 2.85 2.089 1.38 3.506-1.69 1.625-3.86-2.364-4.27-2.937-2.07-2.937zm218.54 0.406c0.06 0.011 0.11 0.051 0.18 0.094 0.54 0.334 0.97 1.45 0.97 2.5s-0.43 1.906-0.97 1.906-1-1.115-1-2.5c0-1.071 0.27-1.815 0.63-1.969 0.06-0.025 0.13-0.042 0.19-0.031zm-208.13 0.594c2.43 0.011 2.84 0.245 1.72 0.968-1.93 1.25-4.91 1.25-4.91 0 0-0.541 1.43-0.977 3.19-0.968zm149.47 6.031c31.7-0.018 35.18 0.524 32.44 2.219-0.47 0.289-0.68 1.576-0.44 2.812 0.28 1.459-0.47 3.244-2.12 5.154-1.41 1.62-2.8 4.06-3.1 5.41s-0.98 3.64-1.53 5.09c-0.55 1.46-0.69 3.19-0.28 3.85 0.42 0.68 0.33 0.96-0.22 0.62-0.53-0.32-2.24 1.92-3.78 5-1.55 3.08-3.03 5.82-3.35 6.1-0.31 0.27-1.8 2.93-3.28 5.9-3.21 6.47-11.09 13.68-19.56 17.91-3.26 1.63-6.18 3.59-6.47 4.34-0.3 0.79-1.91 1.35-3.84 1.35-1.84-0.01-3.35 0.45-3.35 1 0.01 1.39-7.2 1.23-8.62-0.19-0.65-0.65-1.22-2.02-1.22-3.07 0-2.35 5.43-13.25 7.97-16 2.56-2.77 2.39-4.85-1.06-11.93-1.91-3.91-3.77-6.31-5.19-6.75-1.21-0.38-3.44-1.72-4.97-3s-3.19-2.35-3.69-2.35-1.82-0.88-2.9-1.97c-1.48-1.47-1.86-2.88-1.53-5.53 0.81-6.52-2.44-8.801-8.29-5.78-2.87 1.49-3.02 2.16-1.59 8.38 0.23 0.98-4.12 5.87-5.22 5.87-1.75 0-7.89 4.33-7.9 5.56-0.01 0.62-0.72 1.41-1.53 1.72-0.82 0.32-1.47 1.36-1.47 2.38 0 1.01-0.68 3.28-1.53 5-2.6 5.2 0.43 16.84 4.37 16.84 0.98 0 2.34 1.05 3.03 2.35 1.04 1.94 1.01 3.1-0.16 6.59-0.77 2.33-1.7 3.77-2.06 3.19s-2.44-1.37-4.65-1.72c-2.45-0.39-6.08-2.16-9.22-4.53-2.85-2.15-5.71-3.91-6.35-3.91-0.63 0-1.93-0.43-2.87-0.94-0.94-0.5-2.38-1.15-3.19-1.47-0.81-0.31-2.64-1.34-4.06-2.28s-3.98-2.61-5.69-3.68c-1.72-1.08-3.32-3.08-3.59-4.44s-0.92-3.81-1.44-5.47-0.96-3.63-0.97-4.41c-0.01-2.37-11.79-24.93-13.87-26.56-1.49-1.16-1.82-2.173-1.32-4.186 0.37-1.463 1.12-2.903 1.63-3.219s34.73-0.812 76.09-1.063c17.66-0.106 31.37-0.181 41.94-0.187zm-156.12 0.094c0.07-0.001 0.15 0.03 0.18 0.062 0.29 0.287-0.4 1.436-1.53 2.563-1.74 1.746-6 2.924-6 1.656 0-0.752 6.15-4.271 7.35-4.281zm193.59 0c0.72 0.037 1.48 0.418 2.19 1.125 2 2.008 1.92 2.23-1.63 4-3.92 1.955-3.66 2.031-3.56-1.406 0.07-2.372 1.42-3.801 3-3.719zm-184.28 0.25c0.71-0.117 1.03 0.479 1.03 1.812 0 2.856-2.38 6.289-3.31 4.781-0.97-1.571 0.31-5.875 1.93-6.5 0.12-0.045 0.25-0.077 0.35-0.093zm21.72 1c0.98-0.125 2.93 1.434 2.93 2.562 0 0.475-0.88 0.875-1.96 0.875-1.9 0-2.66-1.903-1.32-3.25 0.1-0.093 0.21-0.169 0.35-0.187zm-27.07 1.469c0.82 0 1.47 0.253 1.47 0.562s-0.65 1.22-1.47 2.031c-1.31 1.312-1.46 1.249-1.46-0.562-0.01-1.156 0.63-2.031 1.46-2.031zm26.57 6.002 2.43 0.56c3.38 0.79 6.72 4.75 8 9.56 1.03 3.85 2.84 8.29 6.88 16.75 2.28 4.77 2.44 7.89 0.37 7.1-0.9-0.35-1.47-0.01-1.47 0.87 0 0.8 0.43 1.44 0.94 1.44s1.65 1.23 2.53 2.72c0.89 1.49 3.35 3.94 5.47 5.47 3.98 2.85 5.07 5.59 2.25 5.59-1.21 0-1.32 0.29-0.5 1.28 0.6 0.72 0.91 3.49 0.72 6.16-0.19 2.66 0.08 5.68 0.59 6.65 2.14 4.08-0.02 3-5.31-2.59-3.1-3.28-5.91-5.68-6.22-5.38-0.3 0.31 0.98 2.25 2.88 4.32s3.25 3.97 2.97 4.25c-0.87 0.87-7.26-7.23-6.78-8.6 0.25-0.71-1.09-2.94-2.97-4.93-1.89-1.99-3.4-4.11-3.41-4.72 0-0.61-0.66-1.63-1.4-2.25-1.68-1.39-2.38-4.56-4.07-17.78-1.23-9.65-2.05-14.21-3.87-20.97-0.71-2.64-0.65-2.72 2.06-2.06l2.81 0.65-2.47-2.03-2.43-2.06zm79.87 1.87c2.07 0.04 3.43 1.87 2.81 3.81-0.76 2.41-3.29 2.77-4.12 0.6-0.65-1.68 0.16-4.43 1.31-4.41zm0.06 9.81c0.74-0.03 2.31 0.58 4.25 1.72 3.04 1.8 3.83 4.19 1.38 4.19-0.81 0-1.47 0.52-1.47 1.13 0 0.66-1.05 0.87-2.66 0.56-1.46-0.28-3.61-0.14-4.81 0.31-1.97 0.75-2.17 0.55-2.03-2.22 0.09-1.68 0.7-3.24 1.38-3.47 0.76-0.25 1.04 0.19 0.68 1.13-0.49 1.28-0.23 1.34 1.88 0.34 1.83-0.86 2.2-1.51 1.44-2.43-0.67-0.81-0.61-1.22-0.04-1.26zm0.69 4.41c-0.69 0-1.44 0.45-1.44 1.09 0 0.24 0.69 0.41 1.53 0.41 0.85 0 1.25-0.45 0.91-1-0.21-0.34-0.58-0.5-1-0.5zm-12.34 2.31c0.7-0.11 1.55 0.87 3.43 3.6 2.15 3.1 3.74 4.46 5.35 4.47 1.39 0 2.12 0.47 1.87 1.21-0.24 0.74-2.14 1.22-4.75 1.22-3.21 0-4.54 0.45-5.06 1.72-0.77 1.89-3.23 2.31-4.22 0.72-0.34-0.55-0.35-2.33 0-3.94 0.51-2.3 1.2-2.9 3.16-2.9h2.47l-2.28-1.85c-1.98-1.59-2.09-2.11-0.94-3.5 0.37-0.44 0.65-0.7 0.97-0.75zm20.22 1.32c0.88-0.05 2.05 0.28 4.15 0.93 5.03 1.57 6.83 3.85 3.03 3.85-1.29 0-2.85 0.43-3.5 0.97-0.85 0.71-0.93 0.67-0.21-0.19 1.54-1.86 1.14-3.47-1-4.03-1.99-0.52-2.37 0.14-2 3.59 0.1 1.02-0.38 2.26-1.1 2.72-2.42 1.53-5.75 0.51-5.75-1.78 0-1.01-0.62-1.34-1.91-1-1.05 0.28-2.71-0.18-3.68-0.97-1.64-1.33-1.57-1.39 0.87-0.87 1.46 0.3 2.9 0.17 3.22-0.35s1.25-0.72 2.06-0.41c0.82 0.32 2.37-0.21 3.44-1.18 0.9-0.81 1.49-1.24 2.38-1.28zm6.31 7.72c0.84-0.09 2.04 0.45 2.4 1.4 0.31 0.8 1.35 1.18 2.41 0.91 1.02-0.27 2.39 0.21 3.09 1.06 1.18 1.41 0.18 2.3-1.12 1-0.31-0.31-1.18-0.73-1.91-0.91-3.68-0.88-5.75-1.81-5.75-2.59 0-0.53 0.37-0.82 0.88-0.87zm-33.56 1.71c0.68 0.03 1.42 0.79 2.12 2.25 0.78 1.61 1.78 2.91 2.22 2.91s0.78 0.69 0.78 1.5c0 0.82-0.87 1.47-1.97 1.47-1.15 0-1.93-0.66-1.93-1.6 0-1.12-0.61-1.44-2.07-1.06-1.81 0.48-1.98 0.22-1.4-2.09 0.57-2.27 1.37-3.41 2.25-3.38zm20.18 0.85c1.95-0.19 4.45 1.08 6.32 3.34 0.85 1.03 1.19 1.11 1.22 0.25 0.04-1.8 2.46-1.48 4.31 0.56 2.71 3 1.2 14.29-2.66 19.72-3.39 4.78-6.39 6.33-10.19 5.38-1.63-0.41-2.31-0.25-1.9 0.4 0.34 0.56 1.85 1.22 3.34 1.47 1.5 0.26 3.59 0.84 4.63 1.28 1.33 0.57 1.66 0.44 1.15-0.37-0.39-0.63-0.26-1.16 0.32-1.16 0.57 0 1.03 0.71 1.03 1.53 0 0.83 1.11 1.98 2.47 2.6 2.36 1.07 3.35 2.78 1.62 2.78-0.46 0-2.54 1.69-4.66 3.75-4.47 4.35-7.36 4.44-10.96 0.34-3.59-4.06-5.19-8.73-5.19-15.31 0-3.98-0.52-6.85-1.57-8.34-0.91-1.32-1.64-4.35-1.68-7.22-0.07-4.25 0.34-5.29 2.65-7.28 1.49-1.28 3.57-2.35 4.66-2.35s2.84-0.44 3.87-1c0.38-0.2 0.78-0.33 1.22-0.37zm15.44 2.34c0.54 0 1 0.46 1 1s-0.46 0.97-1 0.97-0.97-0.43-0.97-0.97 0.43-1 0.97-1zm-6.28 2.97c-3.67 0-6.17 3.28-5.22 6.91 0.4 1.5-0.18 2.84-1.97 4.5l-2.53 2.37h3.1c2.87 0 3.06-0.27 3.06-3.44 0-3.38 2.34-5.8 5-5.18 0.62 0.14 1.26-0.98 1.44-2.47 0.29-2.47 0.04-2.69-2.88-2.69zm-14.59 0.16c-2.06 0.1-2.6 1.32-2.07 4.03 0.47 2.38 1 2.68 4.25 2.68 2.98 0 3.84-0.43 4.29-2.15 0.76-2.92 0.17-3.55-3.88-4.31-1.04-0.2-1.91-0.29-2.59-0.25zm-16.13 1.15c0.32-0.06 1 0.41 1.6 1.13 0.77 0.93 0.83 1.5 0.18 1.5-1.19 0-2.55-1.88-1.87-2.57 0.03-0.03 0.05-0.05 0.09-0.06zm70.13 11.56c0.29 0.01 0.31 2.27 0 5.32-0.33 3.24-0.93 11.34-1.29 17.97-0.35 6.62-1 12.03-1.46 12.03-0.47 0-0.76 3-0.66 6.65l0.16 6.63 0.37-5.66c0.2-3.11 0.8-5.65 1.31-5.65 0.52 0 0.91-1.98 0.91-4.41 0-2.6 0.45-4.44 1.09-4.44 0.69 0 0.9 1.04 0.54 2.72-0.32 1.49-0.89 10.2-1.26 19.41-0.57 14.49-0.43 17.19 0.97 19.9 2.01 3.89 2.03 5.19 0.13 5.19-0.81 0-1.48-0.11-1.5-0.25-0.02-0.13-0.31-2.03-0.63-4.19-0.31-2.16-1.15-4.8-1.9-5.87-1.22-1.74-1.36-1.27-1.35 4.44 0.02 7.38 0.74 10.76 2.32 10.81 0.61 0.02 1.89 0.66 2.87 1.4 0.98 0.75 1.44 1.53 1 1.76-1.59 0.8-5.2-1.72-6.31-4.41-1.62-3.92-1.8-16.21-0.25-18.25 1.77-2.34 1.63-10.14-0.28-13.97-1.59-3.19-1.59-9.11 0.06-30.5 0.32-4.22 3.74-15.32 5.09-16.59 0.03-0.02 0.05-0.04 0.07-0.04zm-95.53 0.63c0.07-0.01 0.14 0 0.21 0 0.35 0.02 0.64 0.25 0.72 0.75 0.09 0.54-0.03 0.59-0.28 0.12-0.24-0.46-0.86-0.23-1.37 0.5-0.64 0.91-0.84 0.96-0.63 0.13 0.22-0.84 0.81-1.4 1.35-1.5zm51.06 1.47c-2.16-0.07-5.38 1.09-5.38 2.34 0 1.67 1.18 1.8 2.66 0.32 0.77-0.78 1.27-0.78 1.75 0 0.37 0.59-0.05 1.06-0.91 1.06-1.83 0-2.05 1.61-0.31 2.31 2.27 0.92 2.75 0.66 3.75-1.97 0.62-1.63 0.67-2.96 0.09-3.53-0.33-0.33-0.93-0.51-1.65-0.53zm-44.75 1.37c0.47-0.02 1.13 0.03 2 0.16 2.78 0.41 4.78 2 8.43 6.63 1.44 1.82 1.53 1.81 0.97 0.09-0.5-1.58-0.37-1.65 0.91-0.59 0.83 0.68 2.92 1.52 4.62 1.87 3.62 0.74 4.24 2.76 2.16 6.94-0.92 1.84-1.96 2.69-2.87 2.34-0.79-0.3-1.44 0.03-1.44 0.72s-0.27 0.95-0.59 0.63c-0.33-0.33 0.13-2.02 1-3.76 1.96-3.93 2-3.66-0.91-3.5-2.26 0.14-2.44 0.56-2.44 4.85 0 2.57-0.46 4.65-1 4.65-1.08 0-1.22-0.51-1.09-3.43 0.05-1.08-0.18-1.46-0.47-0.81-0.29 0.64-1.16 0.95-1.94 0.65-0.9-0.35-1.42 0.11-1.47 1.28-0.04 1.09-0.61 0.43-1.4-1.62-1.62-4.21-1.81-6.22-0.5-5.41 1.55 0.96 1.16-1.12-0.47-2.47-0.91-0.75-1.23-2.08-0.88-3.5 0.42-1.65-0.04-2.63-1.53-3.56-2.16-1.35-2.51-2.09-1.09-2.16zm-3.91 0.38c0.53 0 1.24 1.23 1.6 2.72 0.35 1.49 0.95 3.14 1.31 3.69 0.36 0.54 0.57 3.47 0.5 6.56-0.07 3.08 0.27 5.4 0.72 5.12 0.44-0.27 0.82-1.7 0.87-3.15l0.1-2.63 0.84 2.75c1.77 5.9 2.78 23.44 2.16 37.56-0.66 14.76-0.66 14.77-1.32 6.41-0.36-4.6-0.73-13.78-0.78-20.41-0.06-7.31-0.5-12.06-1.09-12.06-0.97 0-1.15 4.45-1.47 33.44-0.16 14.42-0.84 19.25-3.19 21.91-0.83 0.94-1.81 1.71-2.15 1.71-1.02 0-3.01-2.24-2.97-3.37 0.04-1.33 4.87-4.92 4.87-3.63 0 0.54-0.43 1.26-0.97 1.6-1.19 0.73-1.31 3.43-0.15 3.43 1.19 0.01 3.19-6.7 3.37-11.31 0.5-12.61-0.38-43.78-1.25-43.78-0.62 0-1.06 7.9-1.16 21.41l-0.15 21.37-0.69-13.75c-0.38-7.57-1.03-21.1-1.44-30.03-0.4-8.93-0.93-16.55-1.18-16.97s-0.14-2.19 0.25-3.94c0.61-2.77 0.82-2.94 1.5-1.21 0.67 1.71 0.78 1.63 0.84-0.72 0.04-1.49 0.5-2.72 1.03-2.72zm85.97 0c0.91 0 0.46 11.8-0.47 12.37-0.48 0.3-0.9 1.8-0.9 3.35-0.01 1.54-0.45 2.96-1.04 3.15-0.58 0.2-1.41 2.79-1.84 5.75s-0.87 4.13-0.94 2.57c-0.06-1.57-0.73-3.34-1.5-3.94-1.06-0.83-1.22-2.23-0.65-5.81 0.77-4.88-0.26-7.31-1.47-3.47-0.38 1.2-1.34 2.83-2.13 3.62-1.23 1.23-1.55 1.23-2.34 0.03-0.51-0.76-0.76-2.6-0.56-4.09 0.22-1.71-0.12-2.72-0.91-2.72-2.51 0-2.41-1.99 0.16-2.97 1.78-0.68 3.03-0.67 3.84 0 0.87 0.72 1.51 0.32 2.31-1.43 0.73-1.59 1.65-2.23 2.63-1.85 0.96 0.37 1.5 0.02 1.5-0.97 0-1.33 2.7-3.59 4.31-3.59zm-53.78 1.41c0.14-0.1 0.05 0.88-0.22 3.03-0.27 2.16-0.52 5.15-0.5 6.65 0.03 2.86-4.01 7.6-6.5 7.6-0.73 0-1.34 0.48-1.34 1.03 0 0.56 1 0.7 2.31 0.37 3.23-0.81 3.97 1.73 1.84 6.25-0.94 2-2.49 3.79-3.44 3.97-1.49 0.29-1.71-0.5-1.71-5.9 0-5.04 0.48-6.96 2.47-9.88 1.35-1.99 2.43-3.92 2.43-4.31s0.64-1.4 1.38-2.25c0.74-0.86 1.83-2.91 2.43-4.53 0.47-1.26 0.74-1.96 0.85-2.03zm79.94 2.81c0.02 0 0.03 0.04 0.03 0.06 0 0.19-0.89 1.15-1.97 2.13-1.08 0.97-1.97 1.36-1.97 0.87s0.89-1.48 1.97-2.16c0.95-0.59 1.75-0.95 1.94-0.9zm-17.79 4.25c0.39 0.06 0.54 2.48 0.35 5.62-0.54 9.12-1 9.91-1.13 1.97-0.06-3.89 0.25-7.29 0.69-7.56 0.03-0.02 0.07-0.04 0.09-0.03zm-39.84 0.68c0.27-0.07 0.66 0.43 0.94 1.16 0.66 1.73 0.09 2.01-0.88 0.44-0.35-0.58-0.44-1.27-0.18-1.53 0.03-0.03 0.08-0.05 0.12-0.07zm26.69 1.35c-0.2 0.17-0.48 2.01-0.81 5.5-0.25 2.57-0.07 4.65 0.4 4.65 0.48 0 0.86-2.54 0.82-5.65-0.05-3.17-0.21-4.67-0.41-4.5zm-17.09 0.41c0.91-0.12 2.34 0.66 4.09 2.28 1.95 1.8 2.45 3 2.06 5.12-0.28 1.53-1.04 3.12-1.69 3.53-2.58 1.65-3.62 0.74-3.62-3.15 0-2.17-0.46-3.94-1-3.94s-0.97-0.89-0.97-1.97c0-1.16 0.41-1.79 1.13-1.87zm40.87 0.5c0.17-0.04 0.28-0.02 0.28 0.09 0 1.44-5.46 7.26-6.15 6.56-1.23-1.22-0.79-2.05 2.71-4.72 1.42-1.08 2.64-1.82 3.16-1.93zm84.53 2.37c0.85 0 11.19 10.66 11.19 11.53 0 0.26 0.94 1.79 2.09 3.41 1.15 1.61 2.49 4.51 3 6.5 1.24 4.84 1.89 32.64 0.82 35.12-0.83 1.92-0.84 1.93-0.91 0.07-0.09-2.52-1.61-0.9-2.44 2.62-0.63 2.67 0.73 3.88 1.69 1.5 0.27-0.68 0.55-0.28 0.59 0.91 0.08 2.28-5.06 6.95-8.4 7.62-1.01 0.2-3.08 0.83-4.57 1.41-1.69 0.65-2.72 0.69-2.72 0.09 0-0.53-0.45-0.94-1.03-0.94-0.57 0-0.77 0.43-0.43 0.97 0.33 0.54-0.55 1.43-1.97 1.97-3.56 1.35-4.45 1.23-3.78-0.5 0.46-1.21-0.49-1.47-5.25-1.47-6.02 0-8.19-1.08-8.19-4.12 0-0.98-0.43-1.78-0.97-1.78s-1-0.37-1-0.85c0-0.47 1.97-1.36 4.38-1.97 5.31-1.34 6.43-1.37 4.5-0.12-2.09 1.35 2.93 1.32 6.5-0.03 1.97-0.75 2.86-0.71 3.4 0.15 0.54 0.88 1.16 0.75 2.38-0.46 2.08-2.09 3.36-2.06 5.09 0.09 1.24 1.55 1.35 1.4 0.81-1.38-0.36-1.86 0.02-4.55 0.94-6.75 0.84-2 1.32-3.96 1.06-4.37-0.25-0.41 0.41-1.58 1.5-2.56 1.09-0.99 1.75-2.37 1.47-3.1-0.49-1.29-0.19-2.17 2.35-7.03 0.74-1.42 0.8-2.06 0.15-1.66-1.29 0.8-1.35-0.4-0.12-2.34 0.49-0.78 0.58-1.9 0.21-2.47-1.16-1.79-0.79-5.47 0.54-5.47 2.44 0 1.26-2.73-1.72-3.96-1.65-0.69-3.68-2.55-4.5-4.13-1.16-2.24-2.07-2.8-4.06-2.56-1.42 0.17-2.74-0.23-2.97-0.91s0.27-1.25 1.09-1.25 1.8-0.5 2.19-1.12c0.48-0.78-0.12-0.98-1.94-0.63-2.61 0.5-2.61 0.49-1-1.97 1.49-2.27 1.49-2.43 0.03-1.87-2.1 0.8-2.04-0.26 0.1-1.82 1.42-1.04 1.45-1.47 0.34-2.81-0.72-0.87-0.9-1.56-0.44-1.56zm-138.5 0.25c-0.6 0.09-1.26 0.62-1.56 1.53-0.22 0.64 0.3 1.16 1.16 1.16 0.85 0 1.53-0.71 1.53-1.57s-0.52-1.21-1.13-1.12zm-61.5 2.12c0.44 0.02 1.52 0.85 2.63 2.04 1.26 1.35 1.89 2.46 1.34 2.46-1.26 0-4.75-3.78-4.09-4.43 0.03-0.04 0.06-0.07 0.12-0.07zm71.06 0.13c0.3-0.02 0.54 0 0.69 0.09 1.52 0.92 0.64 1.98-3.03 3.6-4.61 2.03-6.18 2.09-5.47 0.25 0.51-1.34 5.72-3.82 7.81-3.94zm-27.12 1.44c0.53 0 1.74 1.2 2.69 2.69 0.94 1.48 2 2.94 2.34 3.21s1.14 1.47 1.78 2.69 1.93 2.22 2.91 2.22c0.97 0 2.27 1.09 2.87 2.41 0.97 2.13 0.81 2.48-1.4 3.21l-2.47 0.85 2.06 1.84c1.81 1.64 2.03 1.63 2.03 0.19 0-1.89 1.51-2.14 2.56-0.44 0.4 0.65 0.18 1.35-0.47 1.56-0.64 0.22-1.76 1.02-2.53 1.79-0.76 0.76-1.6 1.06-1.84 0.65s-2.35-4.29-4.66-8.62c-2.3-4.33-4.76-8.59-5.5-9.44-1.54-1.8-1.78-4.81-0.37-4.81zm-13.44 1.72c1.22-0.17 1.64 2.13 1.1 6.71-0.48 3.99-0.28 5.36 1.09 6.72 1.64 1.64 2.82 1.65 6.59 0.1 1.26-0.52 1.99 0.01 2.91 2.03 0.98 2.16 1 2.8 0.03 3.12-0.67 0.23-1.22 1.25-1.22 2.25 0 1.01-0.46 2.08-1 2.41-1.24 0.77-1.28 2.47-0.06 2.47 0.96 0 2.59-3.83 2.22-5.22-0.12-0.45 0.22-0.53 0.78-0.19 1.25 0.78 1.34 3.72 0.12 4.97-0.5 0.52-1.22 2.71-1.62 4.88-0.62 3.34-0.54 3.73 0.66 2.75 1.18-0.98 1.37-0.54 1.06 2.71-0.68 7.14 1.41 3.97 2.62-3.96 1.35-8.83 0.44-14.51-2.9-17.85-2.1-2.09-1.86-3.25 1-4.78 1.52-0.82 2.18-0.26 4.22 3.69 11.7 22.64 14.52 28.48 14.53 29.97 0 0.94 0.45 1.72 0.97 1.72 0.51 0 1.2 1.53 1.56 3.43 0.35 1.9 1.05 3.71 1.53 4 0.48 0.3 0.87 1.65 0.87 2.97s0.35 2.38 0.78 2.38c0.44 0 1.64 1.89 2.63 4.19 0.99 2.29 2.51 4.9 3.37 5.78 0.87 0.88 2.34 2.48 3.22 3.56 0.89 1.08 2.2 2.21 2.94 2.47s1.11 0.73 0.81 1.06c-0.71 0.79-8.84-3.2-8.84-4.34 0-0.49-0.83-1.74-1.84-2.75-2.07-2.07-7.05-12.31-8.91-18.32-0.67-2.16-2.07-5.8-3.12-8.06-1.06-2.26-2.17-5.34-2.44-6.87-0.28-1.53-0.9-2.93-1.38-3.1-0.47-0.17-1.63-2.6-2.56-5.4s-2.4-6.28-3.28-7.72c-1.53-2.52-1.59-2.11-1.56 9.03 0.01 6.39 0.12 11.5 0.25 11.37s0.88-1.94 1.62-4.06l1.35-3.87 1.03 8.34 1.06 8.38-0.25-6.66c-0.23-6.94 0.32-8.13 2.03-4.41 3.87 8.46 6.32 14.62 7.28 18.44 0.61 2.43 1.4 4.64 1.75 4.91s1.41 2.15 2.34 4.18c1.59 3.43 1.6 3.69 0.07 3.69-1.43 0-1.41 0.21 0.25 1.53 1.66 1.33 1.47 1.3-1.35-0.06-1.77-0.86-2.99-1.91-2.71-2.34 0.6-0.98-2.94-10.89-4.41-12.35-0.77-0.75-0.79-0.28-0.06 1.66 0.56 1.48 0.77 3.35 0.47 4.15-0.31 0.81 0.13 2.14 1 3 0.86 0.87 1.56 2.05 1.56 2.6 0 1.86-2.44 0.2-3.78-2.56-1.12-2.29-1.1-2.89 0-3.57 0.72-0.44 0.95-1.14 0.53-1.56s-1.18-0.12-1.66 0.66c-0.71 1.14-1.34 0.86-3.37-1.5-3.17-3.68-3.33-1.96-0.19 1.97 1.9 2.38 2.07 3.11 1.03 4.15-1.8 1.8-2.72 1.6-5.72-1.19-1.45-1.34-2.96-2.34-3.34-2.24-1.77 0.44-6.99-1.44-7.47-2.69-0.3-0.77-1.16-1.18-1.94-0.88-0.8 0.31-2.07-0.43-2.97-1.72-1.54-2.2-1.59-2.21-1.59-0.18 0 3.1-3.63 3.69-5.47 0.87-1.13-1.72-1.35-3.89-0.91-9.03 0.94-10.76 3.56-26.32 4.66-27.69 0.56-0.69 0.69-1.56 0.31-1.94-0.37-0.37-1.09-0.01-1.59 0.79-0.64 1-0.9-0.1-0.91-3.6-0.01-3.3 0.48-5.48 1.44-6.28 0.81-0.67 1.47-1.68 1.47-2.22 0-0.55-0.65-0.43-1.47 0.25-2.18 1.82-1.76-0.3 0.66-3.37 0.87-1.12 1.57-1.71 2.12-1.78zm-63.56 1.53c0.75-0.02 1.65 0.08 2.69 0.25 8.14 1.34 10.2 4.34 3 4.34-2.44 0-4.41-0.43-4.41-0.97s-0.43-0.97-0.94-0.97-1.05 1.66-1.22 3.69l-0.31 3.69-1.31-3.72c-1.5-4.23-0.78-6.22 2.5-6.31zm69.16 0.68c-0.55 0-1 0.43-1 0.97s0.45 1 1 1c0.54 0 0.96-0.46 0.96-1s-0.42-0.97-0.96-0.97zm34.9 0.13c1.23-0.03 1.47 0.62 1.47 1.91 0 1.78 0.39 2 2.72 1.37 5.37-1.46 9.09-1.26 9.09 0.47 0 2.01 3.8 12.94 5 14.41 0.92 1.11 3.13 31.96 2.35 32.75-0.25 0.24-0.47-0.64-0.47-1.97 0-1.34-0.49-2.96-1.1-3.57-1.52-1.52-2.77-9.01-1.62-9.71 0.51-0.32 0.64-1.3 0.28-2.19s-0.86-2.51-1.09-3.6c-1.78-8.18-2.18-8.73-1.82-2.46 0.98 16.78 2.11 26.18 3.53 28.84 0.53 0.97 0.83 2.95 0.66 4.41-0.24 2.11-0.49 2.36-1.25 1.18-0.91-1.4-1.52-4.7-3.37-18.34-0.45-3.31-1.18-6.59-1.63-7.31-0.44-0.72-0.91-3.65-1.06-6.53-0.51-9.51-2-9.04-2.63 0.84-0.55 8.75-2.14 14.61-4 14.63-0.47 0-0.54-1.01-0.15-2.22 1.44-4.56 1.64-7.42 0.59-8.07-0.65-0.4-1.06 0.15-1.06 1.41 0 1.3-0.43 1.84-1.13 1.41-1.12-0.7-0.79-6.02 1.07-18.13 0.45-2.97 0.51-5.76 0.12-6.19-0.39-0.42-0.78-0.19-0.87 0.5-0.8 6.08-1.4 9.38-1.88 10.63-0.31 0.81-0.46 2.45-0.34 3.66 0.35 3.61-0.9 4.5-2.97 2.12-1.19-1.37-1.81-3.48-1.72-5.72 0.12-2.97 0.19-3.08 0.53-0.81 0.74 4.89 2.39 2.88 2.09-2.56-0.21-3.97-0.65-5.23-1.78-5.16-0.82 0.05-1.78 0.75-2.15 1.56-0.49 1.07-0.67 0.88-0.72-0.72-0.04-1.21-0.58-2.21-1.16-2.21-0.57 0-0.75-0.46-0.43-0.97 0.31-0.52 1.33-0.66 2.21-0.32 1.18 0.46 1.43 0.22 1-0.9-0.32-0.85 0.08-2.45 0.88-3.6 0.8-1.14 1.04-2.09 0.53-2.09s-1.64 1.12-2.53 2.47-2.26 2.44-3.06 2.44c-2.02 0-1.83-0.98 0.75-3.72l2.22-2.31-2.97 0.65c-1.63 0.39-3.17 0.73-3.44 0.72-3.99-0.08-3.88-1.4 0.25-3.13 6.27-2.61 9.48-3.83 11.06-3.87zm43.56 1.84c1.12 0 0.52 20.14-0.81 27.53-0.63 3.52-1.63 6.72-2.25 7.13-0.82 0.54-0.78 0.97 0.19 1.59 1.36 0.88 0.99 5.24-0.81 9.47-0.46 1.08-1.08 2.74-1.38 3.69s-0.94 1.72-1.4 1.72c-1.19 0-0.15-6.23 1.18-7.1 0.71-0.46 0.23-1.28-1.31-2.37l-2.34-1.69 2.12-0.75c2.06-0.76 2.12-1.32 2.19-17.31 0.04-9.08 0.44-17.39 0.9-18.47 0.73-1.68 0.85-1.72 0.91-0.25 0.11 2.71 2.03 2 2.03-0.75 0-1.35 0.37-2.44 0.78-2.44zm-173.81 1.94c3.47 0 4.21 1.23 3.41 5.5-0.68 3.63-2.5 4.65-2.5 1.41 0-2.98-5.95-3.12-9.22-0.22-1.85 1.64-1.86 1.59-0.78-0.47 1.72-3.28 6.03-6.22 9.09-6.22zm202.03 1.97c2.18 0 1.85 1.73-0.47 2.47-1.08 0.34-1.97 1.21-1.97 1.94 0 0.72-1.31 1.77-2.93 2.34-1.63 0.57-2.97 1.49-2.97 2.06s-0.77 1.02-1.72 1c-1.36-0.03-1.14-0.5 1-2.25 1.49-1.22 2.69-2.72 2.69-3.31 0-1.35 4.35-4.25 6.37-4.25zm-186.37 1.09c1.17-0.09 1.97 0.15 1.97 0.88 0 0.54-0.89 1-1.97 1-3.75 0-1.96 1.87 2.43 2.53 4.68 0.7 5.16 2.36 0.69 2.38-1.45 0-4.63 0.65-7.06 1.4-2.43 0.76-5.32 1.66-6.41 2.03-1.66 0.58-1.58 0.41 0.41-1.22 1.63-1.33 1.97-2.12 1.16-2.62-0.89-0.55-0.89-1.06-0.03-2.09 1.79-2.17 6.22-4.08 8.81-4.29zm156.4 0.88c-0.54 0-1 0.92-1 2.03s0.46 1.77 1 1.44c0.54-0.34 0.97-1.25 0.97-2.03s-0.43-1.44-0.97-1.44zm19.32 0c0.81 0 1.17 0.46 0.84 1s-1.28 0.97-2.09 0.97c-0.82 0-1.18-0.43-0.85-0.97 0.34-0.54 1.28-1 2.1-1zm17.47 0.09c0.66 0 1.24 0.19 1.68 0.63 0.46 0.45-0.36 0.91-1.81 1.03-3.21 0.26-5.51 2.16-2.66 2.19 1.57 0.01 1.65 0.22 0.47 0.97-2.14 1.35-0.54 2.33 1.78 1.09 2.5-1.34 5.37-1.4 4.57-0.09-0.34 0.54-1.68 1-3 1s-2.41 0.42-2.41 0.96 0.54 1 1.22 1c0.82 0.01 0.76 0.34-0.22 0.97-2.77 1.79-6.91 0.16-6.91-2.75 0-3.25 4.39-6.98 7.29-7zm-180 2.22c0.35-0.06 0.56 0.17 0.56 0.6 0 0.57-0.43 1.03-0.97 1.03s-0.97-0.17-0.97-0.41 0.43-0.73 0.97-1.06c0.13-0.09 0.29-0.14 0.41-0.16zm-33.85 0.66c0.54 0 0.97 0.43 0.97 0.97s-0.43 1-0.97 1-1-0.46-1-1 0.46-0.97 1-0.97zm263.72 0c2.69 0 2.78 1.14 0.5 6.37-0.71 1.63-1.91 4.38-2.66 6.13-1.27 3-3.54 4.86-4.62 3.78-0.27-0.27 0.08-1.19 0.78-2.03s1.05-1.77 0.75-2.07c-0.3-0.29-1.96 1.52-3.69 4.04-4.26 6.19-13.5 15.15-16.37 15.87-1.29 0.32-2.97 0.33-3.75 0.03s-1.61-0.02-1.88 0.63c-0.37 0.9-0.47 0.91-0.53 0-0.04-0.65 1.53-1.94 3.5-2.88 3.16-1.49 11.86-7.51 14.6-10.06 0.54-0.5 2.08-2.34 3.43-4.06 1.36-1.73 3.36-4.15 4.44-5.41 3.95-4.6 5.41-6.85 5.41-8.31 0-1.8-7.8 5.71-7.85 7.56-0.02 0.68-0.46 1.22-1 1.22s-1 0.5-1 1.13c0 1.83-7.31 8.01-12.97 10.93-6.04 3.12-7.49 3.37-5.59 1.03 1.16-1.42 1.14-1.55-0.13-1.09-5.02 1.84-5.87 1.91-5.31 0.44 0.31-0.82 1.98-1.77 3.69-2.13 1.71-0.35 5.03-1.78 7.38-3.12 2.34-1.35 4.41-2.27 4.62-2.06 0.21 0.2-1.59 1.46-4 2.78-3.72 2.03-5.62 3.9-3.94 3.9 2.04 0 13.32-7.65 13.32-9.03-0.01-0.61-0.71-0.51-1.72 0.28-0.95 0.74 1.73-2.06 5.96-6.25 4.24-4.19 8.13-7.62 8.63-7.62zm-176.53 1.84c0.14-0.11 0.15 1.36 0.22 4.78 0.07 3.38-0.01 6.16-0.22 6.16-0.94 0-1.24-3.89-0.6-7.91 0.31-1.9 0.49-2.94 0.6-3.03zm-84.25 0.13c0.54 0 1 0.2 1 0.43 0 0.24-0.46 0.7-1 1.04-0.54 0.33-0.97 0.13-0.97-0.44 0-0.58 0.43-1.03 0.97-1.03zm268.72 0.53c0.09 0 0.19 0 0.28 0.03 2.94 1.13 2.03 13.28-1.72 23.53-0.79 2.17-1.71 5.8-2.09 8.06-0.75 4.45-1.84 5.06-10.32 5.69-2.09 0.16-4.27 0.57-4.87 0.94s-1.13 0.4-1.13 0.09c0-1.11 2.48-4.98 3.69-5.75 0.68-0.43 1.25-1.43 1.25-2.22 0-0.78 0.37-1.4 0.84-1.4 0.48 0 1.44-1.43 2.1-3.19s1.98-4.76 2.97-6.66c2.01-3.86 4.94-11.5 5.25-13.75 0.34-2.48 2.11-5.08 3.47-5.34 0.09-0.02 0.18-0.04 0.28-0.03zm-344.19 1.53c0.28 0.04 0.677 0.45 1.312 1.31 0.773 1.05 1.376 2.71 1.376 3.69-0.001 0.98-0.447 1.78-0.969 1.78-1.496 0-3.173-3.93-2.469-5.75 0.288-0.74 0.47-1.07 0.75-1.03zm248.59 0.87c-1.1 0-1.3 3.26-0.28 4.28 1.09 1.09 1.28 0.77 1.28-1.81 0-1.35-0.46-2.47-1-2.47zm-161.31 1c0.54 0 0.97 0.17 0.97 0.41s-0.43 0.73-0.97 1.06c-0.54 0.34-1 0.14-1-0.43 0-0.58 0.46-1.04 1-1.04zm134.38 0c-1.58 0-3.77 2.4-2.94 3.22 0.87 0.87 3.11-0.22 3.72-1.81 0.3-0.78-0.04-1.41-0.78-1.41zm-216.47 0.32c0.152 0.02 0.338 0.15 0.562 0.37 1.215 1.22-0.372 7.48-2.562 10.13-0.673 0.81-1.483 2.12-1.782 2.93-0.357 0.97-0.542 1.06-0.594 0.22-0.042-0.7 0.793-3 1.876-5.12 1.082-2.12 1.968-5.08 1.968-6.57 0-1.23 0.126-1.83 0.406-1.93 0.043-0.02 0.075-0.04 0.126-0.03zm288.22 0.12c1.71-0.13 2.4 0.52 2.4 2.06 0 1.69-2.65 1.8-5.37 0.22-1.85-1.07-1.79-1.15 0.9-1.87 0.81-0.22 1.49-0.36 2.07-0.41zm-17.88 0.75c2.02-0.04 3.69 0.16 4.03 0.72 0.35 0.57 1.4 1.03 2.32 1.03 0.91 0 3.62 1.67 6 3.72 3.71 3.2 4.15 4.03 3.24 5.72-0.95 1.78-0.42 5.47 2.54 17.37 0.1 0.41 0.18 1.47 0.18 2.35 0 1.22 0.65 1.46 2.72 1.03 1.49-0.31 4.15-0.85 5.91-1.22 2.57-0.53 3.19-0.38 3.19 0.91 0 0.88-0.49 1.51-1.1 1.37-0.61-0.13-1.3 0.25-1.53 0.88-0.23 0.62 1.54 1.89 3.94 2.81 4.78 1.82 7.8 6.01 5.41 7.53-2.05 1.29-2.8 1-5.72-2.13-1.52-1.62-3.48-2.96-4.35-2.96-2.22 0-1.98 0.87 1.07 3.68l2.68 2.47-3.62 3.31c-3.82 3.5-7.51 4.25-9.78 1.97-0.75-0.74-2.71-2.04-4.38-2.9s-3.31-2.3-3.66-3.19c-0.34-0.91-1.25-1.37-2.06-1.06-0.79 0.3-1.71 0.14-2.03-0.38-0.32-0.51-1.53-0.89-2.72-0.84-1.84 0.07-1.73 0.24 0.85 1.37 3.26 1.44 7.04 5.01 4.09 3.88-1.13-0.43-1.51-0.05-1.41 1.37 0.12 1.54 1.08 2.1 4.38 2.6 4.49 0.67 4.87 2.47 0.53 2.47-1.41 0-2.26 0.33-1.87 0.71 0.38 0.39 2.48 0.57 4.62 0.41 2.3-0.16 3.88 0.16 3.88 0.78 0 0.6-1.93 1.07-4.41 1.07-3.39-0.01-4.63-0.46-5.44-1.97-0.58-1.09-1.47-1.97-2-1.97s-1.7 0.88-2.62 1.97c-1.99 2.32-6.19 2.66-6.19 0.5 0-0.82-0.46-1.5-1-1.5s-0.97 0.42-0.97 0.93 0.43 1.2 0.97 1.54c0.54 0.33 1 1.02 1 1.53 0 1.87-1.68 0.84-2.91-1.79-1.18-2.53-1.31-2.56-2.06-0.71-0.99 2.45-1.19-6.06-0.28-11.57 0.71-4.29 5.18-9.2 9.22-10.09 1.91-0.42 2.87-1.38 3.28-3.25 0.34-1.6 2.14-3.74 4.53-5.41 2.18-1.52 3.94-3.21 3.94-3.75 0-0.53-1.51 0.2-3.38 1.63-2.5 1.91-3.99 2.4-5.65 1.87-6.86-2.17-12.59-9.92-12.57-16.96 0.01-2.55 0.37-5.25 0.85-6 0.66-1.05 4.98-1.79 8.34-1.85zm-78.69 0.41c0.3 0.02 0.51 0.22 0.72 0.56 0.94 1.52 0.19 2.75-1.65 2.75-0.78 0-1.41 0.46-1.41 1s0.66 0.97 1.47 0.97 1.47-0.43 1.47-0.97 0.46-1 1-1 0.97 0.66 0.97 1.47-0.38 1.5-0.88 1.5-1.59 0.22-2.41 0.53c-0.9 0.35-1.9-0.24-2.59-1.53-0.95-1.78-0.77-2.41 1.09-4.03 1.04-0.9 1.72-1.29 2.22-1.25zm-104.87 0.44c2.05 0.05 1.66 0.34-1.75 1.28-2.44 0.66-6.41 2.46-8.84 4-2.44 1.54-4.73 3.31-5.13 3.9-0.52 0.78-0.74 0.78-0.75-0.03-0.05-3.49 10.39-9.31 16.47-9.15zm-98.658 0.28c0.209-0.01 0.492 0.18 0.907 0.53 0.753 0.62 1.597 2.03 1.875 3.09 0.278 1.07 0.153 2.13-0.25 2.38-1.246 0.77-3-1.68-3-4.19 0-1.2 0.121-1.8 0.468-1.81zm115.53 0.62c0.58 0 1.07 0.46 1.07 1s-0.2 0.97-0.44 0.97-0.7-0.43-1.03-0.97c-0.34-0.54-0.17-1 0.4-1zm99.82 0.19c-0.21 0.07-0.32 0.6-0.28 1.37 0.04 1.15 0.24 1.38 0.56 0.6 0.28-0.71 0.26-1.55-0.06-1.88-0.09-0.08-0.16-0.12-0.22-0.09zm-219.13 0.09c0.256-0.12 0.328 0.46 0.344 1.88 0.03 2.64 1.638 4.85 4.75 6.59 2.331 1.31 1.163 1.88-1.406 0.69-3.151-1.46-5.619-6.09-4.375-8.22 0.325-0.56 0.534-0.86 0.687-0.94zm178.59 0.38c-0.92 0.08-0.93 0.56-0.56 1.75 0.35 1.11 1.03 2.19 1.5 2.37s0.85 1.36 0.85 2.63c0 3.1 2.58 15.47 4.56 21.97 1.1 3.61 1.89 4.89 2.59 4.18 0.7-0.7 0.56-2.33-0.53-5.25-0.86-2.32-1.85-5.99-2.15-8.15-0.46-3.18 0.05-2.43 2.65 3.94 1.77 4.32 3.59 8.48 4.06 9.21 0.56 0.86 0.37 1.64-0.5 2.19-0.74 0.47-0.88 0.88-0.34 0.88 2.95 0 3.1-1.64 0.69-6.88-2.6-5.64-3.96-10.08-4.82-15.47-0.27-1.75-0.88-2.97-1.34-2.69-1.1 0.69-2.28-5.75-1.5-8.21 0.52-1.65 0.1-1.97-2.84-2.32-0.79-0.09-1.39-0.14-1.85-0.15-0.17-0.01-0.33-0.01-0.47 0zm-66.21 0.68-2.6 2.26c-2.15 1.85-2.55 2.95-2.31 6.28 0.16 2.21-0.26 4.65-0.91 5.43-0.93 1.13-0.91 1.4 0.16 1.41 1.1 0.01 1.09 0.21-0.06 0.94-1.17 0.74-1.19 1.15-0.13 2.44 1.42 1.7 5.97 2.13 5.97 0.56 0-0.54-0.54-0.96-1.22-0.97-0.82-0.01-0.73-0.35 0.25-1 1.06-0.7 1.13-1.19 0.32-1.72-0.63-0.41-1.29-2.29-1.47-4.19-0.31-3.12-0.08-3.47 2.37-3.75 3.25-0.37 3.63-2.09 0.5-2.25-1.59-0.08-1.73-0.24-0.53-0.56 0.92-0.24 1.95-1.3 2.28-2.34 1.07-3.39 2.19-2.03 2.88 3.46 0.76 6.09-0.54 9.71-5.38 15.04-1.6 1.75-3.01 3.18-3.15 3.12-0.15-0.05-1.77-0.47-3.6-0.9-7.12-1.69-11.27-7.03-11.37-14.66-0.06-3.82 0.29-4.51 2.93-6 1.65-0.93 5.71-1.92 9.04-2.16l6.03-0.44zm160.75 0.97c0.22-0.04 0.41 0.01 0.53 0.13 0.26 0.26-0.58 2.03-1.88 3.94-2.64 3.88-3.84 4.36-3.84 1.56 0-1.63 3.64-5.35 5.19-5.63zm15.84 0.66c-4.78 0-8.29 3.24-4.56 4.22 2.93 0.76 3.2 0.72 5.68-0.91 2.85-1.86 2.35-3.31-1.12-3.31zm15.53 0.06c0.92-0.04 1.95 0.37 2.28 0.91 0.7 1.13 0.67 1.13-1.97 0-1.6-0.69-1.66-0.85-0.31-0.91zm-180.81 0.1c0.07-0.03 0.17 0.01 0.25 0.09 0.33 0.33 0.35 1.16 0.06 1.88-0.31 0.78-0.55 0.58-0.59-0.57-0.03-0.78 0.08-1.33 0.28-1.4zm135.03 0.18c-0.44-0.09-0.6 0.72-0.56 2.66 0.06 3.19 0.14 3.23 1.15 1.13 0.8-1.67 0.79-2.53-0.06-3.38-0.22-0.22-0.38-0.37-0.53-0.41zm-33.84 1.07c-0.07 0-0.15 0.02-0.22 0.06-0.54 0.33-1 1.71-1 3.06 0 1.39 0.44 2.19 1 1.84 0.54-0.33 0.97-1.7 0.97-3.06 0-1.21-0.3-1.96-0.75-1.9zm-57.1 1.75c0.2-0.08 0.53 0.12 0.97 0.56 0.64 0.64 0.94 1.38 0.66 1.65-0.28 0.28-0.77 0.24-1.13-0.12s-0.69-1.13-0.69-1.69c0-0.23 0.07-0.36 0.19-0.4zm75.13 0.34c0.05-0.11 0.12 0.24 0.18 1.13 0.2 2.82 0.2 7.68 0 10.81-0.19 3.13-0.37 0.82-0.37-5.13 0-4.09 0.08-6.57 0.19-6.81zm-142.5 0.41c-2.56 0-4.63 0.48-4.63 1.06 0 0.61 1.62 0.87 3.94 0.66 5.63-0.53 6.11-1.72 0.69-1.72zm179.15 0c-0.99-0.01-1.81 0.81-1.81 2.46 0 1.98 0.51 2.47 2.5 2.47 1.75 0 2.75 0.75 3.41 2.47 1.07 2.81 2.2 3.1 3.93 1 1.01-1.21 0.77-1.65-1.37-2.47-1.42-0.54-3.07-2.07-3.69-3.43-0.75-1.66-1.97-2.5-2.97-2.5zm-68.21 0.12c0.91 0 1.59 1.25 2.68 4.06 0.89 2.3 2.51 6.43 3.6 9.19l1.96 5.06-2.87-0.12c-3.44-0.12-3.75-1.29-0.69-2.59 2.05-0.88 2.03-0.91-0.62-0.69-3.38 0.28-4.77-2.1-1.69-2.91 2.11-0.55 2.61-1.45 1.44-2.62-0.36-0.37-1.44 0.05-2.38 0.9-2.45 2.22-3.23 0.12-0.93-2.53 2.28-2.63 1.77-3.94-1.54-3.94-2.75 0-2.94-0.52-0.96-2.5 0.81-0.82 1.45-1.31 2-1.31zm-35.94 1.41c-0.44 0.03-0.92 1-1.13 2.4-0.34 2.34-0.16 2.68 0.88 1.82 1.49-1.24 1.72-3.4 0.43-4.19-0.06-0.04-0.12-0.04-0.18-0.03zm164.09 0.65c1.56-0.2-5.23 9.87-10.03 14.32-4.29 3.96-6.47 5.09-6.47 3.4 0-0.42 3.12-3.6 6.91-7.09 3.78-3.49 6.87-6.85 6.87-7.47s0.66-1.7 1.47-2.38c0.59-0.49 1.03-0.75 1.25-0.78zm-237.34 0.13c-0.57-0.1-1.66 0.25-3.1 1.03l-2.78 1.5 2.63 0.06c1.45 0.02 2.98-0.45 3.34-1.03 0.57-0.93 0.48-1.46-0.09-1.56zm170.12 0.06c0.47-0.01 0.57 1.09 0.57 4.03 0 4.1 0.43 5.19 2.71 7.06 3.39 2.77 2.43 3.03-1.06 0.29-3.38-2.67-5.12-8.69-3.09-10.72 0.4-0.41 0.66-0.65 0.87-0.66zm69.13 1.72c0.21-0.04 0.27 0.3 0.28 0.97 0.02 0.88-0.66 2.14-1.47 2.81-1.89 1.57-1.91-0.01-0.03-2.5 0.61-0.8 1-1.24 1.22-1.28zm-173.41 0.34 0.5 9.85c0.3 5.41 0.28 17.13-0.06 26.06s-0.9 24.66-1.25 34.94-1.05 21.54-1.56 25.06c-1.94 13.24-1.9 15.68 0.25 17.19 1.19 0.83 1.73 2.01 1.37 2.93-0.32 0.85-0.17 1.54 0.31 1.54 0.49 0 1.02-1.23 1.19-2.72 0.57-4.97 7.69-3.53 7.69 1.56 0 1.08-0.47 2.11-1.06 2.31-0.6 0.2-1.1 2.04-1.1 4.07 0 2.55-0.55 3.98-1.81 4.65-2.54 1.36-3.02 1.2-3.59-1-0.28-1.06-1.25-2.18-2.16-2.47s-1.73-1.45-1.81-2.59c-0.09-1.14-0.85-2.82-1.69-3.75-2.07-2.28-2.11-28.15-0.06-42.72 0.81-5.78 1.51-14.14 1.56-18.59 0.05-4.46 0.74-14.3 1.5-21.88 0.76-7.57 1.46-18.41 1.56-24.09l0.22-10.35zm-77.28 0.57c0.28-0.06 0.52-0.01 0.72 0.18 0.25 0.25 0.18 1.18-0.16 2.07-0.76 1.99-2.37 2.14-2.37 0.21 0-1.1 0.98-2.28 1.81-2.46zm88.13 0.09c-0.4 0.13-1.09 1.74-2.19 5.16-1.21 3.74-2.19 7.6-2.19 8.59 0 3.04 0.85 2.05 1.97-2.34 0.58-2.3 1.53-5.12 2.09-6.25 0.57-1.14 0.89-3.14 0.69-4.44-0.08-0.54-0.2-0.78-0.37-0.72zm-164.29 0.28c0.065 0.01 0.142 0.09 0.218 0.28 0.273 0.68 0.273 1.79 0 2.47-0.272 0.68-0.499 0.14-0.5-1.22 0-0.84 0.087-1.38 0.219-1.5 0.02-0.01 0.041-0.03 0.063-0.03zm-3 2.38c0.294 0.01 0.781 0.65 1.25 1.65 0.635 1.36 0.734 2.41 0.218 2.41-1.093 0-2.169-2.48-1.687-3.88 0.047-0.13 0.121-0.19 0.219-0.18zm278.29 1.34c-1.22-0.03-4.22 1.72-4.22 2.66 0 1.07 3.78 0.16 4.56-1.1 0.32-0.51 0.34-1.16 0.06-1.43-0.08-0.09-0.23-0.13-0.4-0.13zm-13.66 0.09c0.35-0.06 1 0.58 1.53 1.57 1.29 2.4 0.83 2.69-0.94 0.56-0.68-0.83-1.02-1.76-0.72-2.06 0.04-0.04 0.08-0.06 0.13-0.07zm-258.6 1.07c0.1-0.03 0.206-0.02 0.281 0.06 0.303 0.3 0.016 1.11-0.656 1.78-0.972 0.96-1.096 0.84-0.562-0.56 0.277-0.73 0.637-1.21 0.937-1.28zm291.88 0c0.45-0.1 0.75 0.49 0.75 1.43 0 1.09-0.43 2.26-0.97 2.6-0.54 0.33-1-0.26-1-1.35 0-1.08 0.46-2.26 1-2.59 0.07-0.04 0.16-0.08 0.22-0.09zm-115.31 0.59c-0.54 0-1 0.89-1 1.97s0.46 1.97 1 1.97 0.97-0.89 0.97-1.97-0.43-1.97-0.97-1.97zm143.19 0.25c0.28-0.02 0.11 0.44-0.47 1.53-0.6 1.12-1.57 2.32-2.16 2.69-0.77 0.48-0.78 0.11 0-1.35 0.6-1.11 1.6-2.32 2.19-2.68 0.19-0.12 0.34-0.18 0.44-0.19zm-48.38 2.06c-0.12 0.02-0.24 0.04-0.38 0.13-0.54 0.33-1 0.82-1 1.06s0.46 0.44 1 0.44c0.55 0 0.97-0.49 0.97-1.06 0-0.43-0.24-0.63-0.59-0.57zm67.88 0c-0.12 0.02-0.24 0.04-0.38 0.13-0.54 0.33-1 0.82-1 1.06s0.46 0.44 1 0.44 0.97-0.49 0.97-1.06c0-0.43-0.24-0.63-0.59-0.57zm65 0.16 0.78 5.25c0.83 5.77-1.18 11.94-3.88 11.94-1.19 0-1.13-0.28 0.19-1.6 0.87-0.87 1.29-1.86 0.97-2.18-0.33-0.33-0.99 0.07-1.5 0.87-0.82 1.27-1.07 1.26-1.97-0.03-0.85-1.23-0.99-1.14-0.75 0.47 0.19 1.29-0.37 2.02-1.69 2.25-1.62 0.27-1.71 0.15-0.5-0.69 1-0.69 1.08-1.05 0.25-1.06-0.69-0.01-1.22-1.21-1.22-2.75 0-1.52 0.54-3.34 1.22-4.06 1.01-1.09 0.94-1.25-0.47-0.76-2.47 0.88-2.23-1.93 0.28-3.28 1.12-0.59 2.55-0.92 3.16-0.72 0.61 0.21 2.02-0.54 3.13-1.65l2-2zm-295.41 1.03c0.09-0.02 0.29 0 0.65 0.09 0.73 0.19 1.96 0.35 2.72 0.35 2.56 0 1.43 1.9-1.93 3.31-1.83 0.76-3.64 1.9-4 2.5-0.84 1.35-3.5 1.42-3.5 0.09 0-0.54 0.59-1 1.31-1 1.65 0 6.02-4.53 4.94-5.12-0.23-0.12-0.28-0.2-0.19-0.22zm210.22 2.72c0.07 0.01 0.1 0.09 0.09 0.22-0.02 0.51-0.67 1.79-1.47 2.84-0.79 1.05-1.42 1.48-1.4 0.97 0.01-0.51 0.67-1.76 1.47-2.81 0.59-0.79 1.1-1.26 1.31-1.22zm-4.07 0.19c0.16-0.01 0.26 0.08 0.26 0.28 0 0.51-0.66 1.48-1.47 2.15-0.82 0.68-1.47 0.94-1.47 0.57 0-0.38 0.65-1.38 1.47-2.19 0.5-0.51 0.95-0.8 1.21-0.81zm-230.62 1.9c3.48-0.07 8.56 1.25 8.56 2.53 0 0.52-1.77 0.94-3.94 0.94-2.16 0-3.93-0.43-3.93-0.97s-0.43-0.97-0.97-0.97-1 0.66-1 1.47c0 0.84-0.88 1.47-2.03 1.47-2.95 0-2.02-3.07 1.25-4.16 0.54-0.18 1.26-0.29 2.06-0.31zm28.81 0.57c0.15-0.01 0.28-0.02 0.41 0 0.61 0.06 1 0.36 1 0.87 0 0.5-0.57 1.15-1.25 1.47-0.98 0.46-0.98 0.7 0 1.16 2.16 1 1.33 2.37-1.47 2.4-2.59 0.03-2.61 0.09-0.78 1.47 1.79 1.36 1.68 1.44-1.66 1.44-1.95 0-4.12 0.15-4.84 0.34-2.09 0.55-21.5-1.45-21.5-2.22 0-1.1 8.72-2.94 16.72-3.53 4.04-0.3 8.32-1.21 9.53-2 1.35-0.89 2.82-1.37 3.84-1.4zm152.19 0.03c0.5 0.03-0.27 1.3-2.53 3.5-2.01 1.95-3.66 3.95-3.66 4.43s-0.44 0.85-1 0.85c-1.49 0 0.71-3.77 3.81-6.5 1.83-1.61 2.99-2.31 3.38-2.28zm-147.69 0.15c0.19-0.08 0.61 0.2 1.31 0.78 0.82 0.68 1.5 1.59 1.5 2.07 0 1.46-1.71 0.96-2.34-0.69-0.52-1.35-0.71-2.05-0.47-2.16zm29 0.78c0.21 0 0.35 1.32 0.35 2.94s-0.34 2.94-0.78 2.94c-0.45 0-0.65-1.32-0.41-2.94s0.63-2.94 0.84-2.94zm54.35 0c0.84-0.04 2.1 1.14 3 3.19 1.85 4.25 7.73 13.35 10.78 16.72 1.34 1.49 3.44 2.72 4.65 2.72 2.31 0 6.29-4.18 6.29-6.59-0.01-0.78 0.42-1.15 0.96-0.82 0.54 0.34 1 0.05 1-0.65 0.01-0.71 0.98-0.13 2.19 1.31 1.22 1.43 2.91 2.81 3.72 3.09 0.95 0.33 0.68 0.55-0.72 0.6-1.24 0.04-2.61-0.78-3.22-1.91-1.41-2.63-3.11-1.5-2.34 1.56 0.45 1.8 0.18 2.41-1 2.41-0.87 0-1.59 0.69-1.59 1.56-0.01 1-0.54 1.39-1.47 1.03-0.89-0.34-1.47-0.01-1.47 0.82 0 2.07-1.59 2.68-2.91 1.09-0.64-0.77-2.46-1.69-4.03-2.03-3.35-0.74-11.3-9.19-13.47-14.28-0.8-1.9-1.86-4.21-2.34-5.16-0.55-1.08-0.5-1.72 0.12-1.72 0.55 0 0.97-0.66 0.97-1.47 0-0.99 0.37-1.44 0.88-1.47zm53.43 0.1c0.57-0.09 0.81 0.29 0.6 0.94-0.24 0.71-1.01 1.48-1.72 1.71-0.74 0.25-1.09-0.1-0.85-0.84 0.24-0.71 1.01-1.51 1.72-1.75 0.1-0.03 0.17-0.05 0.25-0.06zm-138.47 0.87c0.24 0 0.7 0.43 1.04 0.97 0.33 0.54 0.16 1-0.41 1s-1.06-0.46-1.06-1 0.2-0.97 0.43-0.97zm-44.24 1.07c0.36 0.05 0.25 0.49-0.07 1.31-0.58 1.53-5.31 2.78-5.31 1.4 0-0.48 1.14-1.31 2.53-1.84 1.63-0.62 2.48-0.93 2.85-0.87zm91.4 0c-0.22-0.08-0.14 0.31 0.19 1.18 0.37 0.97 0.91 1.52 1.22 1.22 0.3-0.3 0.01-1.11-0.66-1.78-0.36-0.36-0.61-0.58-0.75-0.62zm-24.56 0.28c0.35 0.01 0.59 0.43 0.59 1.06 0 0.84-0.46 1.53-1 1.53s-0.97-0.43-0.97-0.94 0.43-1.19 0.97-1.53c0.14-0.08 0.29-0.13 0.41-0.12zm-63.34 0.62c0.54 0 0.96 0.43 0.96 0.97s-0.42 1-0.96 1c-0.55 0-1-0.46-1-1s0.45-0.97 1-0.97zm-66.818 1.97c0.445-0.09 1.434 0.21 2.844 0.97 2.394 1.28 5.906 7.07 5.906 9.72 0.001 1.15-0.395 2.09-0.906 2.09-1.459 0-4-4.14-4-6.53 0-1.19-1.168-3.1-2.594-4.22-1.5-1.18-1.821-1.92-1.25-2.03zm213.5 0.13c0.14-0.07 0.46 0.28 0.97 1.15 0.58 0.99 0.85 2.03 0.59 2.28-0.25 0.26-0.75-0.24-1.09-1.12-0.53-1.39-0.65-2.23-0.47-2.31zm53.19 0.09c-0.12 0.04-0.19 0.17-0.19 0.41 0 0.55 0.3 1.32 0.66 1.68s0.88 0.41 1.16 0.13c0.27-0.28-0.02-1.02-0.66-1.66-0.44-0.44-0.77-0.63-0.97-0.56zm116.22 0.19c0.23 0.06 0.43 0.74 0.78 2.06 0.9 3.36 0.59 4-1 2.09-0.63-0.75-0.82-2.19-0.44-3.19 0.22-0.57 0.41-0.87 0.57-0.93 0.03-0.02 0.06-0.04 0.09-0.03zm-389.5 0.12c0.079 0.04 0.168 0.25 0.281 0.69 0.409 1.57 1.519 2.16 3.5 1.84 0.406-0.06 0.75 0.34 0.75 0.88s-0.428 0.97-0.969 0.97c-1.75 0-1.06 1.98 0.719 2.06 1.028 0.05 1.235 0.26 0.5 0.56-1.74 0.7-1.52 2.31 0.312 2.31 0.918 0 1.237 0.44 0.813 1.13-0.415 0.67 0.471 2.09 2.125 3.4 1.554 1.24 2.604 2.49 2.344 2.76-0.602 0.6-6.209-4.36-7.156-6.32-0.393-0.81-1.374-2.58-2.157-3.94-0.782-1.35-1.367-3.55-1.312-4.9 0.042-1.04 0.117-1.51 0.25-1.44zm68.281 2.1c1.8-0.12 3.97 1.38 9.53 5.71 5.13 4 13.99 9.37 15.53 9.41 0.67 0.02 2.96 0.86 5.13 1.91 2.16 1.04 4.72 1.92 5.68 1.93 1.35 0.03 1.67 0.68 1.38 2.75-0.35 2.47-0.69 2.71-4.19 2.5-2.11-0.12-5.32 0.02-7.15 0.32-3.13 0.5-3.27 0.61-1.72 2.15 1.28 1.28 3.5 1.66 9.9 1.66 6.99 0 8.41 0.32 9.38 1.87 0.82 1.32 0.86 2.12 0.09 2.88-0.76 0.76-1.06 0.58-1.06-0.66 0-2.47-1.63-1.12-2.19 1.81-0.36 1.9-0.09 2.47 1.25 2.47 0.96 0 1.95-0.54 2.19-1.21 0.24-0.68 0.8-0.89 1.25-0.47s-1.41 3.08-4.16 5.9c-2.74 2.83-5.51 6.12-6.12 7.31-0.77 1.51-1.63 1.96-2.81 1.5-1.61-0.61-1.62-0.49-0.07 1.88 1.33 2.03 1.48 3.31 0.72 6.69-1.03 4.6-3.88 8.32-4.62 6.09-0.3-0.89-0.9-0.56-1.97 0.97-1.12 1.6-1.22 2.31-0.38 2.59 1.44 0.48 1.61 11.66 0.19 12.54-1.16 0.71-1.33 3.43-0.22 3.43 0.42 0 1.49-2.31 2.38-5.15 1.31-4.2 1.65-4.64 1.72-2.32 0.08 3.18-4.02 10.87-6.25 11.72-2.23 0.86-3.88-1.77-2.07-3.28 0.82-0.68 1.48-1.93 1.47-2.81 0-1.03-0.7-0.56-1.97 1.34-1.07 1.63-1.74 3.5-1.5 4.16 0.25 0.66-0.29 1.65-1.21 2.19-1.55 0.9-1.53 0.97 0.15 1 1.5 0.02 1.27 0.5-1.15 2.62-3.14 2.75-17.82 9.65-18.69 8.78-0.29-0.28 1.2-1.23 3.31-2.09 7.46-3.05 14.09-6.34 14.69-7.31 0.84-1.37 0.11-1.23-4.07 0.75-2.68 1.27-3.73 1.41-4.03 0.53-0.41-1.22-0.64-1.14-6.68 1.94-1.63 0.82-4.49 1.79-6.38 2.18-1.89 0.4-3.9 1.09-4.44 1.5-1.06 0.81-8.35 2.5-14.87 3.47-3.01 0.45-5.25 1.73-8.6 4.94-2.49 2.39-4.56 4.49-4.56 4.65 0 0.17 0.91 0.36 2 0.44 1.1 0.08 1.73-0.29 1.41-0.81s-0.04-0.84 0.65-0.69c0.7 0.15 1.29-0.21 1.32-0.84 0.05-1.46 4.86-5.25 6.65-5.25 0.76 0 1.83-0.48 2.41-1.06s2.52-0.93 4.31-0.75c3.23 0.31 3.25 0.35 0.88 1.5-1.32 0.63-3.67 1.42-5.19 1.75-2.88 0.62-14.44 11.2-14.44 13.21 0 0.64-2.89 4.06-6.4 7.6-3.52 3.53-6.379 6.64-6.379 6.94 0 0.29 1.085 0.32 2.438 0.06 1.352-0.26 2.471-0.12 2.471 0.28 0 1.15-4.792 1.79-5.159 0.69-0.18-0.54-2.509 0.61-5.187 2.62-7.641 5.73-8.438 6.47-7.875 7.38 0.29 0.47-0.195 1.11-1.031 1.43-1.02 0.4-1.274 0.23-0.813-0.59 0.527-0.93 0.39-0.97-0.563-0.09-0.683 0.63-1.747 2.17-2.374 3.44-0.628 1.26-2.12 2.45-3.313 2.62-1.571 0.23-2.487 1.39-3.344 4.25-1.009 3.37-1.525 3.87-3.469 3.5-1.253-0.24-2.281-0.06-2.281 0.41 0 0.46 0.428 0.87 0.969 0.87 1.817 0 1.012 1.61-1.469 2.94-1.352 0.72-2.468 1.87-2.469 2.53 0 0.66-1.084 1.4-2.437 1.66-1.649 0.31-2.469 0.02-2.469-0.88 0-0.74-0.427-1.34-0.968-1.34-0.542 0-1 0.88-1 1.97 0 1.08-0.428 1.97-0.969 1.97s-1.015-0.78-1.031-1.72c-0.029-1.64-0.046-1.64-1 0-1.41 2.42-3.836 2.23-3.188-0.25 0.283-1.09 1.127-1.97 1.875-1.97s1.375-0.43 1.375-0.97c0-1.79-2.819-1.04-4.375 1.19-1.696 2.42-2.097 1.65-0.594-1.16 1.346-2.52 15.913-13.09 19.657-14.28 1.442-0.46 1.935-1.2 1.562-2.38-0.361-1.13 0.883-3.28 3.656-6.31 5.035-5.49 5.546-6.12 8.625-10.53 1.322-1.89 5.128-6.1 8.469-9.34 3.341-3.25 7.48-8.54 9.219-11.78 3.161-5.91 11.801-15.26 19.161-20.72 2.14-1.6 4.7-3.69 5.68-4.66 0.99-0.97 2.81-2.17 4-2.69 1.2-0.52 2.82-1.33 3.63-1.81s2.58-1.35 3.93-1.88c1.36-0.52 4.02-1.59 5.91-2.4s7.37-2.07 12.16-2.78c5.51-0.82 9.51-1.95 10.84-3.1l2.06-1.81-2.84 0.66c-2.02 0.46-2.65 0.33-2.16-0.47 0.42-0.67 0.08-1.16-0.87-1.16-1.48 0-1.47-0.12 0-1.59 2.69-2.69 0.65-2.86-2.22-0.19-5.06 4.71-12.02 4.37-10.47-0.53 0.55-1.73 0.46-1.91-0.75-0.91-1.14 0.95-1.94 0.87-3.84-0.43-3.19-2.18-3.83-3.23-3.85-6.29-0.02-3.69 3.41-7.56 7.38-8.31 1.86-0.35 3.12-1.03 2.81-1.53s-2.12-0.64-4.03-0.28c-3.27 0.61-3.36 0.55-2.34-1.34 0.59-1.11 1.52-2.19 2.09-2.38s1.46-3.15 1.94-6.56c1.07-7.58 2.13-9 6.84-9 4.22 0 9.88-1.73 9.88-3.03 0-1.21-4.65-1.13-5.41 0.09-0.8 1.29-4.44 1.26-4.44-0.03 0-0.55-1.24-0.9-2.75-0.78-4.03 0.31-4.99-0.73-5.68-6-0.56-4.22-0.9-4.75-3.04-4.75-1.83 0-2.25 0.37-1.75 1.59 1.78 4.3 1.67 4.94-1.15 5.57-4.63 1.01-5.32 1.35-5.32 2.53 0 0.62 0.85 0.89 1.88 0.62 2.32-0.6 4.78 0.7 3.19 1.69-0.6 0.37-1.13 0.17-1.13-0.44s-2.66 1.46-5.9 4.66c-3.25 3.19-5.88 6.22-5.88 6.68 0 0.47 1.32-0.44 2.94-2 1.62-1.55 2.94-2.39 2.94-1.84s-2.11 2.72-4.72 4.84c-2.62 2.13-4.6 4.46-4.38 5.13 0.4 1.19-2.8 1.76-3.87 0.69-0.69-0.69 2.85-13.74 4.69-17.28 0.79-1.53 2.89-4.22 4.71-6 1.83-1.79 3.66-4.34 4.07-5.69 1.62-5.43 5.75-10.91 10.62-14.06 0.95-0.62 1.65-0.98 2.47-1.03zm52.34 0.34c1.16 0 2.75 0.34 3.97 1 1.04 0.55 2.42 1.98 3.06 3.19 1.06 1.98 1.02 2.06-0.46 0.84-0.9-0.74-1.66-0.99-1.66-0.56s-1.12-0.26-2.47-1.53c-1.97-1.85-2.47-1.99-2.47-0.72 0 0.87 0.46 1.85 1 2.18 0.54 0.34 0.97 1.03 0.97 1.54 0 0.9-2.18 1.31-3 0.56-0.22-0.21-6.41-0.72-13.72-1.1-7.3-0.37-15.71-1.32-18.69-2.15-6.47-1.81-8.99-3.68-3.93-2.91 9.2 1.41 13.66 1.74 21.03 1.56 4.4-0.1 9.71-0.13 11.78-0.06 2.36 0.09 3.52-0.21 3.12-0.84-0.4-0.66 0.32-1 1.47-1zm264.5 0c0.87 0 1.1 0.52 0.69 1.59-0.35 0.91-0.06 2.01 0.63 2.44 1 0.62 0.97 1.03 0 2-0.68 0.67-1.22 1.93-1.22 2.75 0 1.05 0.46 0.81 1.53-0.72 1.83-2.61 4.34-2.87 4.5-0.47 0.06 0.95 0.26 3 0.44 4.53 0.24 2.09-0.05 2.65-1.1 2.25-0.77-0.29-1.75 0.15-2.22 0.97-1.07 1.92-5.32 2.42-7.43 0.88-1.73-1.27-2.17-3.44-0.72-3.44 0.48 0 1.13-0.8 1.47-1.75 0.33-0.95 0.84-2.26 1.15-2.94 0.33-0.69-0.06-1.22-0.9-1.22-0.82 0-1.79 0.89-2.13 1.97s-1.29 1.97-2.12 1.97c-1.06 0-1.31-0.52-0.82-1.72 0.39-0.94 0.95-2.53 1.22-3.47s0.87-1.45 1.35-1.15c0.47 0.29 0.54-0.23 0.18-1.16-0.5-1.31-0.25-1.57 1.07-1.06 0.93 0.36 1.45 0.26 1.15-0.22-0.29-0.48 0.15-1.14 1-1.47 0.99-0.38 1.76-0.56 2.28-0.56zm-242.87 0.97c0.54 0 0.97 0.65 0.97 1.47 0 0.81-0.43 1.46-0.97 1.46s-0.97-0.65-0.97-1.46c0-0.82 0.43-1.47 0.97-1.47zm-66.13 0.28c0.54 0.02 1.63 0.4 3.16 1.19 4.97 2.57 21.54 5.36 32.47 5.5 4.81 0.06 9.5 1.25 14.5 3.62 3.56 1.7 4.39 3.67 1.09 2.63-1.76-0.56-1.98-0.38-1.43 1.15 0.55 1.55 0.36 1.5-1.1-0.28-1.24-1.5-2.3-1.89-3.69-1.37-1.07 0.39-3.5 0.38-5.4-0.07-4.45-1.03-4.94-1.03-4.94 0 0 0.48 1.68 1.12 3.72 1.44 3.98 0.64 13 5.84 13 7.5 0 1.32-1.03 1.24-3.44-0.37-1.87-1.26-11.03-3.98-21.65-6.41-5.08-1.16-21.16-8.6-21.16-9.78 0-0.37-1.34-1.49-3-2.47-2.44-1.44-3.03-2.32-2.13-2.28zm177.63 0.19c0.29-0.04 0.24 0.42-0.03 1.46-0.65 2.47-2.28 3.67-2.28 1.69 0-0.77 0.63-1.95 1.4-2.59 0.43-0.36 0.74-0.54 0.91-0.56zm-102.19 0.81c0.07-0.11 0.47 0.26 1.22 0.94 1.17 1.05 3.49 1.71 6 1.71 3.66 0.01 4.16 0.27 4.69 2.69 1.13 5.18 1.69 5.81 2.44 2.72 0.53-2.21 0.72-1.29 0.81 3.69 0.06 3.65 0 6.62-0.16 6.62-0.96 0-2.65-2.59-2.65-4.09 0-0.97-0.45-1.78-0.97-1.78-1.67 0-7.68-5.84-9.91-9.63-1.08-1.84-1.56-2.74-1.47-2.87zm193.85 0.65c0.33 0.01 0.39 0.32-0.04 1-0.33 0.54-1.56 1.48-2.75 2.1-2.14 1.12-2.14 1.16-0.28-0.94 1.18-1.32 2.5-2.17 3.07-2.16zm-126.16 0.44c0.21 0.02 0.61 0.3 1.22 0.91 0.81 0.81 1.47 1.75 1.47 2.06 0 0.77-1.48 0.71-2.29-0.09-0.36-0.36-0.68-1.3-0.68-2.06 0-0.58 0.06-0.83 0.28-0.82zm30.28 2.72c1.19 0.03 1.25 3.44-0.06 4.25-0.54 0.34-0.97 1.45-0.97 2.47 0 2.96-2.2 6.98-3.53 6.47-0.73-0.28-1.9 1.2-2.88 3.65-1.43 3.57-2.09 6.39-3.94 16.91-0.19 1.08-1.05 5.67-1.93 10.19-1.5 7.67-1.46 10.27 0.15 8.66 0.38-0.38 1.26-4.33 1.94-8.79 1.06-6.89 1.15-7.12 0.66-1.68-0.32 3.51-0.74 10.94-0.88 16.53-0.14 5.58-0.43 10.37-0.68 10.62-0.26 0.26-0.67-2.29-0.91-5.65-0.41-5.65-0.75-6.34-4.22-9.25-3.46-2.91-3.7-3.46-3.22-7.07 0.29-2.15 1.2-5.41 2.03-7.25 0.84-1.83 2.24-5.55 3.13-8.25 0.88-2.69 1.96-5.35 2.4-5.9 0.44-0.56 1.57-3.43 2.47-6.41 1.93-6.35 8.49-18.9 10.19-19.47 0.09-0.03 0.17-0.03 0.25-0.03zm89.91 0.88c0.56-0.03 0.39 0.4-0.44 1.4-1.36 1.64-2.97 1.96-2.97 0.6 0-0.49 0.71-1.18 1.56-1.5 0.9-0.35 1.51-0.49 1.85-0.5zm-86.75 1.9c0.12 0 0.08 6.27-0.1 13.97-0.38 16.47 0.31 22.86 2.38 22.06 1.82-0.7 1.95 6.79 0.15 8.69-0.67 0.71-1.95 2.17-2.84 3.25-0.89 1.09-2.42 2.44-3.37 2.97-2.15 1.2-3.41 12-1.41 12 0.85 0 1.03-1.02 0.59-3.38-0.36-1.95-0.21-3.6 0.38-3.96 0.59-0.37 1 0.42 1 1.93 0 1.47 0.44 2.32 1 1.97 0.54-0.33 0.97-1.71 0.97-3.06 0-1.39 0.44-2.19 1-1.84 0.54 0.33 0.97 2.28 0.97 4.34 0 5.21 1.06 9.91 2.21 9.91 0.56 0 0.74-1.36 0.41-3.19-1.69-9.37-1.55-11.69 0.28-4.69 1.06 4.06 2.13 8.49 2.41 9.85 0.3 1.46 2.52 3.99 5.5 6.21 2.74 2.05 4.72 4.17 4.37 4.72-0.34 0.56-2.35 0.9-4.44 0.75-2.08-0.15-4.08 0.03-4.46 0.41-0.87 0.87-1.34 0.79-3.82-0.63-3.82-2.19-6.04-4.12-8.28-7.18-2.05-2.82-2.28-4.23-2.4-15.44-0.13-11.28 0.02-12.5 1.81-13.81 1.34-0.99 2.18-1.07 2.62-0.35 0.45 0.72 1.13 0.6 2.1-0.37 2.01-2.01 2.8-5.04 1.75-6.72-0.74-1.18-1.35-1.23-3.56-0.22-4.23 1.92-4.87 0.42-3.57-8.41 0.62-4.2 1.42-10.54 1.78-14.06 0.37-3.52 0.73-6.83 0.85-7.37 0.27-1.3 3.42-8.35 3.72-8.35zm-120.85 0.32c0.36-0.07 0.57 0.12 0.57 0.53 0 0.54-0.43 1.26-0.97 1.59s-1 0.2-1-0.34 0.46-1.29 1-1.63c0.13-0.08 0.28-0.13 0.4-0.15zm39.31 0.46c0.29-0.06 0.61 0.01 1.04 0.16 1.69 0.6 1.72 0.72 0.25 1.28-1.14 0.44-1.66 1.79-1.66 4.28 0 4.23 0.9 3.88 1.94-0.78 0.6-2.71 0.86-1.91 1.5 4.88 1.05 11.17 2.74 11.65 1.97 0.56-0.47-6.62-0.34-8.3 0.5-6.97 0.6 0.96 1.37 7.22 1.68 13.91 0.63 13.36 0.74 12.97-5.96 20.22-1.97 2.12-3.59 4.68-3.6 5.65-0.05 4.19-4.44 10.99-11.37 17.66-9.69 9.32-9.61 11.33 0.5 12.47 6.95 0.78 8.51 2.3 7 6.72-1.07 3.1-7.94 8.83-7.94 6.62 0-0.54 1.35-1.7 2.97-2.62 3.36-1.92 3.88-5.09 0.97-5.85-1.09-0.28-1.97-0.82-1.97-1.19s-2.22-1.45-4.94-2.43l-4.97-1.79 0.56-19.34c0.32-10.62 0.8-21.97 1.03-25.22 0.24-3.24 0.74-10.88 1.1-16.97 0.66-11.18 1.9-15.43 1.72-5.9-0.08 4.24-0.02 4.43 0.31 1 0.57-6.04 3.22-4.96 3.22 1.31 0 1.46 0.56 2.38 1.47 2.38 1.29-0.01 1.43 2.71 0.87 21.62-0.47 15.97-0.33 21.66 0.5 21.66 0.81 0 1.1-5.44 1.1-19.19 0-11.2 0.4-19.19 0.93-19.19 0.55 0 0.77 6.24 0.57 15.25-0.2 8.62 0.05 15.5 0.56 15.81 0.53 0.33 0.91-5.69 0.91-14.75 0-9.54 0.35-15.31 0.96-15.31 0.54 0 1.02 2.32 1.07 5.16 0.04 2.84 0.45 7.39 0.87 10.09 0.72 4.59 0.78 4.37 0.91-3.37 0.09-5.95 0.43-8.04 1.19-7.28 0.58 0.58 1.29 2.89 1.59 5.12s0.94 4.03 1.44 4.03c0.49 0 0.83-0.54 0.75-1.22-0.09-0.67-0.12-1.87-0.04-2.69 0.12-1.16 0.38-1.12 1.19 0.29 0.77 1.32 0.66 2.38-0.5 4.15-1.78 2.72-2.02 4.41-0.59 4.41 0.54 0 0.97-0.66 0.97-1.47s0.42-1.5 0.9-1.5c0.49 0 1.15-1.14 1.5-2.56 0.48-1.92-0.03-3.65-2.06-6.66-5.6-8.33-5.89-9.35-4.78-16.44 0.68-4.35 1.03-5.8 1.87-6zm98.97 0.19c-0.54 0-0.97 0.49-0.97 1.06 0 0.58 0.43 0.74 0.97 0.41s1-0.79 1-1.03-0.46-0.44-1-0.44zm45.25 0.13c0.63 0 1.25 0.06 1.72 0.18 0.95 0.25 0.18 0.47-1.72 0.47-1.89 0-2.66-0.22-1.72-0.47 0.48-0.12 1.1-0.18 1.72-0.18zm-16.72 0.87c1.62 0 1.15 3.64-1 7.47-1.1 1.97-1.81 3.78-1.53 4.06 0.76 0.76 3.63-1.81 4.57-4.12 0.77-1.91 0.81-1.88 0.87 0.28 0.04 1.35-1.23 3.42-3.12 5.16-1.75 1.59-2.75 2.93-2.22 3 0.52 0.06 1.62 0.17 2.43 0.24 0.88 0.08 1.63 1.32 1.82 3.07 0.45 4.19 1.9 5.23 2.72 1.97l0.65-2.72 1.28 2.34c1.17 2.17 1 2.36-2.37 3.53-4.81 1.68-4.66 1.76-4.53-2.15 0.07-2.27-0.33-3.44-1.19-3.44-0.72 0-1.3 0.54-1.31 1.22-0.01 0.82-0.27 0.89-0.75 0.18-0.4-0.58-1.52-1.33-2.47-1.68-1.26-0.47-1.72-1.75-1.72-4.69 0-2.22-0.44-4.89-1-5.94-0.85-1.58-0.69-1.9 0.94-1.9 3.26 0 6.97-2.15 6.97-4.07 0-0.99 0.42-1.81 0.96-1.81zm13.72 0.97c0.58 0 1.04 0.46 1.04 1s-0.2 0.97-0.44 0.97-0.7-0.43-1.03-0.97c-0.34-0.54-0.14-1 0.43-1zm75.25 0.31c-0.53 0.09-1.28 1.15-1.68 2.69-0.44 1.67-0.31 1.83 0.84 0.88 0.77-0.64 1.41-1.82 1.41-2.6 0-0.74-0.25-1.02-0.57-0.97zm-371.46 0.72c0.579 0.03 1.413 0.54 2.187 1.47 0.685 0.82 0.942 1.78 0.594 2.12-0.347 0.35-0.625 0.1-0.625-0.53s-0.657-1.12-1.469-1.12c-0.811 0-1.5-0.46-1.5-1 0.001-0.55 0.246-0.83 0.594-0.91 0.073-0.01 0.136-0.03 0.219-0.03zm366.5 1.28c-0.11 0.02-0.23 0.08-0.37 0.16-0.54 0.33-1 0.79-1 1.03s0.46 0.44 1 0.44 0.97-0.46 0.97-1.03c0-0.43-0.24-0.66-0.6-0.6zm-7.15 0.57c0.49-0.09 1.31 0.73 2.53 2.53 3.15 4.63 2.43 6.69-0.88 2.47-1.4-1.8-2.31-3.91-2.03-4.66 0.09-0.23 0.22-0.32 0.38-0.34zm-193.91 0.15c0.5-0.05 1.05 0.98 1.13 3.13 0.23 6.67 1.04 7.84 1.84 2.68 0.61-3.91 0.68-3.53 0.81 3.22 0.09 4.2-0.07 7.63-0.34 7.63s-0.47-1.12-0.47-2.47-0.39-2.47-0.84-2.47c-1.35 0-3.1-4.76-3.1-8.41 0-2.15 0.47-3.26 0.97-3.31zm-36.15 0.13-0.63 4.59c-0.36 2.51-1.08 9.57-1.62 15.69-0.55 6.11-1.43 12.2-1.94 13.56-0.52 1.36-0.97 5.68-0.97 9.62 0 3.95-0.28 9.9-0.63 13.22-0.56 5.42-0.84 6.07-2.81 6.07-1.21 0-2.76 0.65-3.43 1.47-0.68 0.81-1.62 1.5-2.1 1.5-1.12-0.01-1.12-2.33 0-3.54 1.55-1.67 3.99-15.42 4.63-26 0.34-5.68 0.94-10.77 1.28-11.31s0.82-6.27 1.09-12.75l0.5-11.78 3.31-0.19 3.32-0.15zm-95.03 0.15c0.8 0.03 1.34 0.22 1.34 0.6 0 0.55-0.11 1-0.25 1s-1.68 0.43-3.44 0.93c-3 0.86-4.4-0.03-2.19-1.4 1.18-0.73 3.2-1.17 4.54-1.13zm80.21 0.03c0.17-0.05 0.52 0.53 0.91 1.5 0.52 1.3 0.75 2.51 0.53 2.72-0.49 0.5-1.64-2.43-1.56-3.97 0.01-0.15 0.07-0.23 0.12-0.25zm260.29 0.66c0.28-0.1 0.01 0.4-0.66 1.66-1.22 2.29-2.06 2.84-2.06 1.34 0-0.47 0.75-1.44 1.65-2.19 0.56-0.46 0.9-0.75 1.07-0.81zm-377.16 1c0.134 0.05 0.385 0.26 0.75 0.62 0.672 0.67 0.959 1.48 0.656 1.79-0.303 0.3-0.849-0.25-1.219-1.22-0.333-0.88-0.411-1.27-0.187-1.19zm356.31 0.38c0.06-0.01 0.11-0.02 0.16 0 0.2 0.07 0.27 0.47 0.28 1.09 0.01 1.56 0.16 1.62 0.91 0.44 0.5-0.8 1.26-1.11 1.65-0.72s-0.26 1.72-1.44 2.97c-2.14 2.28-2.88 5.59-1.25 5.59 0.49 0 1.15-1.02 1.47-2.31 0.84-3.34 3.53-4.23 3.53-1.16 0 1.3-0.42 2.67-0.96 3-0.55 0.34-1 3.63-1 7.34-0.01 7.13-0.56 9.85-2.1 9.85-0.51 0-0.64-0.46-0.28-1.03 0.86-1.4-0.43-7.82-1.56-7.82-0.49 0-0.83 2.62-0.82 5.82 0.02 3.85-0.55 6.69-1.65 8.37-0.92 1.4-2.05 2.53-2.53 2.53-1.33 0-1.04-1.11 0.78-3.12 1.21-1.34 1.66-3.77 1.72-9.19 0.04-4.5-0.34-7.23-0.94-7.03-0.54 0.18-1.12 1.14-1.31 2.12-0.19 0.99-0.75 2.29-1.25 2.88-0.51 0.59-1.55 1.95-2.32 3.03-1.26 1.79-1.33 1.65-0.5-1.47 0.51-1.89 1.61-6.26 2.44-9.72 1.04-4.31 2.45-7.21 4.47-9.28 1.39-1.42 2.11-2.12 2.5-2.18zm-352.25 1.28c0.427-0.03 1.697 1.08 4.313 3.62 2.756 2.67 5.286 4.56 5.626 4.22s-0.53-1.69-1.94-3c-3.723-3.45-3.18-4.16 0.84-1.09 4.1 3.12 4.28 4.27 1 7.12-1.35 1.18-2.81 2.16-3.21 2.16-0.91 0-5.627-8.47-6.598-11.81-0.224-0.78-0.287-1.21-0.031-1.22zm25.279 0.68c0.88-0.15-4.22 5.72-7.87 9-5.91 5.31-7.07 6.54-7.07 7.38 0 0.48 0.22 0.87 0.5 0.87 0.74 0 7.13-5.78 10.72-9.71 5.16-5.65 5.59-6.04 7.28-6.04 1.15 0 0.56 1-1.9 3.22-2.55 2.3-4.72 6.03-7.72 13.28-2.3 5.56-4.58 10.32-5.03 10.6s-1.3-0.42-1.91-1.56c-0.93-1.74-0.63-2.75 1.69-6.16 4.53-6.65 4.68-7.24 1.13-3.88-3.87 3.66-6.32 4.1-7.22 1.25-0.42-1.3 0.14-2.93 1.62-4.71 2.31-2.8 12.71-11.81 15.5-13.44 0.11-0.07 0.22-0.09 0.28-0.1zm262.91 0.88c0.04-0.01 0.07-0.01 0.12 0 0.14 0.03 0.34 0.18 0.53 0.37 0.78 0.78 0.79 1.58 0.04 2.88-0.93 1.59-1.1 1.48-1.13-1.06-0.01-1.39 0.13-2.1 0.44-2.19zm-115.25 0.03c0.21-0.05 0.56 0.37 1.16 1.16 1.42 1.88 1.43 1.88 1.59-0.07 0.08-1.08 0.51 0.92 0.97 4.44 0.92 7.18 2.89 12.03 3.81 9.41 0.5-1.42 0.78-1.4 2.78 0 1.21 0.84 2.17 2.27 2.16 3.19-0.03 1.45-0.24 1.42-1.5-0.26-1.43-1.89-1.43-1.89-1.44 0-0.01 1.62-0.17 1.69-1.03 0.44-0.84-1.21-0.98-1.12-0.72 0.5 0.23 1.43 1.06 1.98 3.12 2 2.02 0.03 3.12 0.68 3.69 2.22 0.45 1.2 1.23 2.16 1.72 2.16 0.5 0 1.12 0.88 1.41 1.97 0.28 1.08 0.95 1.97 1.53 1.97 1.2 0 0.53-2.14-2-6.38-2.21-3.71-4.75-9.33-4.75-10.47 0-0.47-0.44-0.84-0.97-0.84-1.14 0-3.98-6.43-3.87-8.75 0.04-0.88 0.61-0.25 1.24 1.37 1.2 3.07 3.64 7.09 6.88 11.31 1.75 2.28 1.83 2.29 1.22 0.29-0.64-2.1-0.58-2.12 2.22-0.72 2.49 1.24 2.99 2.16 3.56 6.75 0.36 2.92 0.36 6.9 0 8.84-0.46 2.44-0.31 3.53 0.5 3.53 0.78 0 1 1.06 0.62 3.19l-0.56 3.19 1.47-3.19c2.29-4.99 3.43-3.76 1.66 1.78-1.55 4.86-1.55 5.11 0.69 9.6 2.67 5.36 3.57 7.47 5.03 11.46 0.82 2.27 1.25 2.6 1.93 1.5 0.98-1.58 0.84-1.89 2.91 5.72 0.66 2.43 0.85 6.08 0.47 8.63-0.5 3.34-0.29 4.73 0.81 5.62 1.8 1.46 2.97 4.63 1.72 4.63-0.51 0-1.39-0.89-1.97-1.97s-1.56-1.97-2.19-1.97c-0.85 0-0.84 0.28 0.03 1.16 0.65 0.65 1.19 3.19 1.19 5.65 0 2.69 0.79 5.75 1.94 7.63 1.05 1.72 2.19 4.76 2.56 6.75 0.48 2.52 0.91 3.21 1.5 2.28 0.68-1.07 0.87-1.01 0.88 0.22 0.01 0.84-0.5 2.02-1.13 2.65-0.86 0.87-0.87 2.07-0.03 4.88 0.61 2.05 1.4 6.21 1.75 9.25 0.41 3.46 0.27 5.73-0.37 6.12-1.12 0.69-7.1-5.94-7.1-7.87 0-0.65-0.57-1.8-1.25-2.53-2.33-2.54-12.3-21.26-12.87-24.16-0.19-0.93-0.67-2.42-1.07-3.34-0.39-0.92-0.44-2.15-0.09-2.72s-0.05-1.06-0.87-1.06c-0.99 0-2.05-1.96-3.13-5.66-0.9-3.1-2-6.31-2.41-7.13-0.4-0.81-1.51-4.78-2.46-8.84s-2.01-7.83-2.38-8.37c-1.17-1.74-2.98-8.98-2.97-11.91 0.01-2.19 0.23-2.52 0.97-1.38 0.53 0.82 0.96 2.48 0.97 3.69 0.01 1.22 0.38 2.22 0.81 2.22 0.44 0 1.61 2.93 2.63 6.47 1.01 3.54 2.23 6.67 2.72 6.97 1.76 1.09 1.87-0.57 0.25-4.25-2.32-5.26-3.74-9.14-7.13-19.5-0.88-2.71-2.08-5.22-2.62-5.6-1.31-0.89-1.82-8.68-0.57-8.68 0.54 0 1 0.77 1 1.72 0.03 2.99 5.3 18.51 9.28 27.31 0.74 1.62 2.73 6.06 4.44 9.84 5.95 13.14 9.08 19.19 9.91 19.19 0.46 0-0.65-3-2.47-6.66-5.87-11.74-9.21-19.35-9.81-22.37-0.55-2.74-0.54-2.8 0.53-0.75 0.63 1.22 1.47 2.22 1.84 2.22 0.38 0 1.55 1.89 2.56 4.18 1.02 2.3 2.12 4.39 2.44 4.66 0.33 0.27 1.46 2.05 2.5 3.94 2.76 5 5.34 8.35 5.25 6.78-0.04-0.75-0.93-2.69-1.97-4.31-1.03-1.63-2.45-4.06-3.12-5.41s-1.51-2.67-1.88-2.94c-0.36-0.27-1.75-2.93-3.09-5.9-1.34-2.98-3.15-6.3-4-7.38-1.48-1.87-1.56-1.87-1.59-0.12-0.06 3.23-2.4 0.15-3.82-5-0.72-2.61-1.9-6.07-2.62-7.69-1.49-3.36-4.39-12.95-4.44-14.63-0.02-0.61-0.63-1.91-1.4-2.93-1.28-1.68-1.38-1.5-0.85 1.97 0.33 2.1 0.32 3.57 0 3.28s-0.8-3.15-1.09-6.32c-0.3-3.16-1.22-7.05-2.03-8.68-0.82-1.63-1.5-4.56-1.5-6.47 0-1.84 0.04-2.66 0.31-2.72zm78.5 0.59c0.56-0.02 0.87 0.2 0.87 0.69 0 1.27-3.77 5.22-5 5.22-0.55 0-1.68 0.66-2.5 1.47-0.81 0.81-2.04 1.5-2.75 1.5-0.7 0-1.85-0.69-2.53-1.5-0.84-1.02-0.89-1.47-0.12-1.47 0.6 0 1.13 0.57 1.15 1.25 0.03 0.68 1.49-0.42 3.25-2.41 2.27-2.55 5.94-4.68 7.63-4.75zm-111.78 0.5c-0.17 0.02-0.27 0.76-0.25 1.97 0.02 1.63 0.22 2.15 0.47 1.19s0.23-2.27-0.04-2.94c-0.06-0.16-0.13-0.22-0.18-0.22zm87.18 0c0.36-0.06 0.47 0.53 0.22 1.47-0.6 2.3-1.31 2.6-1.31 0.57 0-0.78 0.42-1.67 0.91-1.97 0.06-0.04 0.13-0.06 0.18-0.07zm35.38 0.57c2.08 0 4.41 1.57 7.75 4.97 2.74 2.77 4.97 5.57 4.97 6.18s1.16 2.3 2.53 3.78c2.16 2.33 3.27 2.69 8.13 2.69 5.82 0 17.52 2.01 21.81 3.72 1.35 0.54 5.78 1.3 9.84 1.69 4.43 0.42 9.41 1.64 12.47 3.06 2.81 1.3 5.65 2.38 6.28 2.38s2.46 1.08 4.06 2.43c2.71 2.28 2.4 2.99-1.06 2.5-0.86-0.12-1.13 0.39-0.75 1.38s0.04 1.56-0.94 1.56c-0.96 0-1.42 0.77-1.31 2.19 0.1 1.21 0.12 2.79 0.06 3.47-0.21 2.45-2.66 1.17-2.62-1.38 0.03-2.02-0.5-2.67-2.41-2.97-1.34-0.21-4.01-1.51-5.93-2.84-1.93-1.34-4.14-2.41-4.88-2.41s-2.16-0.72-3.16-1.62c-1.59-1.45-2.11-1.48-4.4-0.25-3.14 1.68-24.07 1.82-26.1 0.18-0.71-0.57-2.8-1.38-4.65-1.78-3.99-0.85-9.42-3.72-9.44-5-0.02-1.19-3.64-5.31-4.66-5.31-0.44 0-0.33 0.89 0.25 1.97 1.75 3.26 0.1 2.25-5.18-3.19-2.76-2.84-4.69-4.61-4.28-3.93 0.4 0.67 0.29 1.21-0.26 1.21-1.44 0-1.98-1.23-2.18-5-0.24-4.46 0.23-5.97 2.47-8.03 1.19-1.09 2.34-1.66 3.59-1.65zm-73.53 0.62c0.58-0.03 0.69 0.46 0.69 1.66 0 1.18 0.71 3.12 1.56 4.34 1.79 2.56 1.52 4.87-0.34 3-0.67-0.67-1.24-1.68-1.26-2.25-0.01-0.57-0.74-1.92-1.59-3-1.51-1.92-1.53-1.94-0.84 0.34 0.43 1.46 0.35 2.13-0.25 1.76-2.13-1.32-1.91-4.16 0.4-5.26 0.78-0.36 1.28-0.57 1.63-0.59zm-18.47 0.5c0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.22 0 4.44-0.24 1.22-0.44 0.22-0.44-2.22 0-1.82 0.1-2.87 0.25-2.75zm120.69 1.53c0.3-0.13 0.68 0.82 1.47 3.16 1.58 4.69 1.26 5.76-1.07 3.44-1.78-1.79-1.84-1.98-0.97-5.25 0.22-0.79 0.38-1.27 0.57-1.35zm-176.38 0.22c0.58 0 1.07 0.46 1.07 1s-0.2 0.97-0.44 0.97-0.73-0.43-1.06-0.97c-0.34-0.54-0.14-1 0.43-1zm63.94 0c0.45 0 1.09 1.23 1.37 2.72 0.58 2.97 0.26 3.91-0.74 2.28-1.08-1.74-1.5-5-0.63-5zm185.78 0c0.42 0 0.86 1.12 0.97 2.47 0.23 2.8-0.25 3.2-1.12 0.91-0.82-2.12-0.77-3.38 0.15-3.38zm-285.25 0.1c1.94-0.06 3.02 0.31 2.66 0.9-0.34 0.54-0.71 0.93-0.82 0.88-0.1-0.06-1.27-0.45-2.62-0.88-2.31-0.74-2.28-0.81 0.78-0.9zm19.25 0.03c0.73-0.07 1.85 0.04 3.59 0.21 8.5 0.85 10.44 5.73 9.54 24.26-0.6 12.18-3.86 25.92-8.04 33.96-0.76 1.47-1.15 3.22-0.9 3.88s-0.25 1.77-1.1 2.47c-1.19 0.99-1.27 1.58-0.37 2.65 0.87 1.05 0.86 1.67 0 2.54-0.63 0.62-1.13 1.74-1.13 2.46 0 0.73-0.83 2.23-1.87 3.35-2.07 2.22-1.73 4.98 0.5 4.12 0.77-0.29 1.37-0.03 1.37 0.57 0 1.96-4.08 1.16-4.62-0.91-0.28-1.08-0.9-1.97-1.38-1.97-1.13 0-1.12 0.7 0.13 3.03 0.78 1.47 0.7 1.88-0.37 1.88-0.77 0-1.73-0.97-2.13-2.19l-0.72-2.22-0.44 2.22c-0.54 2.74-2.28 2.93-2.28 0.25 0-1.09-0.65-1.97-1.47-1.97-0.91 0-1.46 0.91-1.46 2.44 0 1.35-0.46 2.47-1 2.47-2.77 0 0.84-7.21 6.78-13.57 1.65-1.77 3.51-5.09 4.09-7.37 0.58-2.29 1.25-4.74 1.5-5.47s0.68-6.27 0.97-12.28c0.33-6.79 1.26-13.11 2.44-16.69l1.87-5.75-2.44-9.03c-1.33-4.97-2.4-10.08-2.4-11.34 0-1.36 0.12-1.9 1.34-2zm-52.75 1.84c0.11 0-0.06 0.49-0.37 1.47-0.35 1.08-2.24 3.67-4.19 5.75-4.37 4.64-8.97 8.04-8.97 6.62 0-0.57 0.42-1.06 0.91-1.06 0.87 0 8.44-7.52 11.37-11.31 0.76-0.98 1.14-1.47 1.25-1.47zm159.72 0c2.14 0 2.17 0.1 0.97 3.25-0.51 1.34-0.51 2.94-0.03 3.72 0.59 0.96 1.03 0.12 1.5-2.78 0.36-2.28 0.94-3.95 1.31-3.72 0.92 0.57 0.08 7.3-1 7.97-0.48 0.29-0.91 1.61-0.91 2.93 0 1.33-0.46 2.41-1.06 2.41-0.64 0-0.86-0.92-0.53-2.25 0.34-1.37-0.19-3.5-1.34-5.4-2.15-3.54-1.69-6.13 1.09-6.13zm46.31 0c2.28 0 2.21 1.22-0.56 10.84-1.93 6.7-2 10.85-0.22 13.29 1.14 1.55 1.61 1.64 2.88 0.59 0.83-0.7 1.33-1.77 1.09-2.41-0.24-0.63 0.71-1.67 2.09-2.31 2.48-1.15 2.54-1.11 1.88 1.97-0.37 1.72-1.11 3.67-1.66 4.34-1.41 1.76-5.25 1.53-7.22-0.44-2.1-2.1-4.39-7.35-3.68-8.5 0.76-1.24 0.9-9.5 0.15-9.5-0.34 0.01-0.94 1.66-1.34 3.69l-0.75 3.69-1.28-2.94c-2.26-5.12-1.79-7.33 1.97-8.9 1.85-0.78 3.66-1.86 4-2.41s1.54-1 2.65-1zm-133.62 1.19c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.17 0.06 1.88-0.31 0.78-0.52 0.55-0.56-0.6-0.03-0.78 0.05-1.3 0.25-1.37zm-76.28 0.28c0.36 0 0.35 0.46-0.25 1.44-0.36 0.57-1.63 1.54-2.82 2.15-2.05 1.07-2.05 0.97 0.22-1.5 1.28-1.38 2.38-2.09 2.85-2.09zm182.53 0.69c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.16 0.06 1.88-0.31 0.78-0.55 0.55-0.59-0.6-0.04-0.78 0.08-1.3 0.28-1.37zm-85.06 0.81c-0.89 0-1.99 5.88-1.32 6.97 0.94 1.51 1.21 1.03 1.6-3.03 0.2-2.17 0.07-3.94-0.28-3.94zm-71.16 0.47c-0.41 0.12-1.21 0.72-2.5 1.81-1.72 1.45-3.67 2.62-4.38 2.62-0.7 0-1.85 0.66-2.53 1.47-1.58 1.92-0.57 1.86 3.28-0.15 1.71-0.89 3.79-1.9 4.6-2.28 0.81-0.39 1.65-1.52 1.84-2.5 0.15-0.74 0.1-1.1-0.31-0.97zm169.09 0.34c0.02-0.01 0.04-0.01 0.07 0 0.05 0.03 0.09 0.17 0.15 0.41 0.25 0.94 0.25 2.49 0 3.44-0.25 0.94-0.44 0.17-0.44-1.72 0-1.25 0.09-2.02 0.22-2.13zm-72.15 0.72c0.89 0.01 1.55 13.99 1 21.91-0.13 1.8 0.29 3.88 0.9 4.62 0.62 0.74 0.84 2.2 0.5 3.25-0.33 1.05-0.12 4.97 0.47 8.66s0.84 7.59 0.56 8.69c-0.76 3.05-5.5 9.12-5.5 7.06 0-0.94 0.61-1.94 1.35-2.22 1.56-0.6 4.21-7.95 3.22-8.94-1.9-1.9-6.69-0.97-9.75 1.91-4.03 3.78-8.89 4.92-15.57 3.65-2.84-0.53-5.31-1.12-5.5-1.31-0.77-0.78 0.98-3.56 2.25-3.56 0.76 0 1.38-0.49 1.38-1.06 0-0.6 0.84-0.8 1.97-0.44 1.56 0.5 1.83 0.3 1.31-1.06-0.4-1.05-0.28-1.45 0.34-1.07 0.56 0.35 2.03-0.47 3.29-1.81 2.94-3.13 4.08-3.09 2.87 0.09s-1.25 9.29-0.06 9.29c0.49 0 1.09-2.55 1.31-5.66 0.3-4.21 0.01-5.99-1.09-6.91-0.94-0.78-1.03-1.22-0.29-1.22 0.65 0.01 1.16-1.08 1.16-2.4s0.35-2.61 0.78-2.88c0.43-0.26 0.59 1.02 0.38 2.88-0.24 2.05 0.05 3.37 0.72 3.37 0.62 0 1.13-1.97 1.22-4.65 0.1-3.31 0.29-3.81 0.59-1.72 0.85 5.99 2.24 4.81 2.41-2.03 0.09-4.01 0.3-5.29 0.53-3.13 0.21 2.03 0.82 3.69 1.34 3.69 0.56 0 0.73-1.83 0.37-4.44-0.39-2.89-0.25-4.43 0.44-4.43 0.7 0 1.06 3.74 1.06 10.96 0.01 6.05 0.27 10.74 0.6 10.41s0.61-6.03 0.62-12.69c0.02-9.06 0.23-11 0.82-7.68 0.42 2.43 0.8 7.83 0.84 12.03 0.04 4.37 0.5 7.62 1.06 7.62 1.2 0 1.21-0.25 0-21.06-0.64-11.08-0.65-17.04 0-17.69 0.03-0.03 0.07-0.03 0.1-0.03zm192.96 0.59c0.16 0.04 0.42 0.39 0.85 1.13 0.57 0.99 0.85 1.99 0.62 2.22-0.69 0.69-1.75-0.78-1.71-2.44 0.01-0.64 0.09-0.94 0.24-0.91zm-161.18 0.19c0.35 0.02 0.56 0.43 0.56 1.06 0 0.85-0.43 1.53-0.97 1.53s-1-0.39-1-0.9 0.46-1.23 1-1.56c0.14-0.09 0.29-0.13 0.41-0.13zm64.47 0.63c-1.4 0-1.13 1.33 0.78 3.72 1.83 2.29 3.19 2.82 3.19 1.21-0.01-0.54-0.41-1-0.91-1-0.51 0-1.19-0.88-1.53-1.97-0.35-1.08-1.03-1.96-1.53-1.96zm-258.19 0.31c0.07-0.06 0.236 0.03 0.437 0.15 1.037 0.65 9.384 17.59 10.434 21.19 0.4 1.36 1.17 3.03 1.72 3.72s0.78 1.47 0.5 1.75c-0.27 0.28-1.17-0.97-2-2.75s-3.44-7.19-5.78-12.06c-4.448-9.25-5.616-11.75-5.311-12zm67.811 1.09c-0.13 0.06 0.07 0.66 0.47 1.72 0.54 1.45 1.54 3.54 2.22 4.63 0.68 1.08 1.6 1.73 2.03 1.47 1.26-0.78 0.87-1.63-2.28-5.29-1.54-1.78-2.26-2.6-2.44-2.53zm100.5 0.06 0.72 11.82c0.39 6.49 1.13 15.36 1.66 19.68 1.87 15.48 1.96 17.34 0.97 16.72-0.54-0.33-0.97-2.1-0.97-3.93s-0.38-3.56-0.85-3.85c-0.46-0.28-0.65 3.77-0.44 9.03 0.55 13.44 1.29 20 2.26 19.41 0.45-0.28 0.71-1.64 0.56-3.03s0.05-2.16 0.47-1.72c0.41 0.44 0.9 2.9 1.09 5.47 0.37 4.95-0.11 5.66-2.19 3.16-0.7-0.86-2.92-2.41-4.93-3.44-4.1-2.09-5.48-5.59-4.32-11.03 1.48-6.91 4.41-7.04 4.41-0.22 0 2.37 0.43 4.57 0.97 4.9 1.18 0.74 1.19 0.24 0.03-14.75-1.17-15.14-1.22-28.2-0.22-39.34l0.78-8.88zm-125.12 0.5c1.13 0 0.52 1.8-3.85 11.66l-3.62 8.22 1.78 4.06c0.97 2.25 2.71 5.44 3.87 7.06 2.41 3.35 3.65 7.38 2.32 7.38-0.49 0-0.88-0.74-0.88-1.66 0-1.72-4.66-7.22-6.12-7.22-0.46 0 0.04 1.24 1.09 2.72 3.31 4.69 3.42 6.71 0.5 9-3.86 3.04-4.67 2.64-3.94-1.93 0.57-3.52 0.29-4.5-2.44-7.94-2.88-3.64-3.07-4.32-2.59-9.66 0.36-4 1.31-6.89 3.13-9.53 2.56-3.71 2.6-3.73 1.93-0.84-0.37 1.62-1.1 3.73-1.59 4.68-0.55 1.07-0.49 2.39 0.12 3.44 0.9 1.53 0.98 1.51 1-0.4 0.02-1.18 0.73-3.38 1.54-4.91s2.15-4.36 3-6.25c2.59-5.82 3.85-7.88 4.75-7.88zm41.9 0c-0.54 0-0.97 0.46-0.97 1 0 0.55 0.43 0.97 0.97 0.97s1-0.42 1-0.97c0-0.54-0.46-1-1-1zm25.69 0c0.49 0 0.88 0.89 0.88 1.97 0 1.09-0.17 1.97-0.38 1.97s-0.59-0.88-0.88-1.97c-0.28-1.08-0.11-1.97 0.38-1.97zm247.38 2.13c0.28-0.07 0.69 0.42 1 1.22 0.35 0.91 0.42 1.88 0.15 2.15-0.27 0.28-0.8-0.24-1.15-1.15-0.36-0.91-0.37-1.89-0.1-2.16 0.04-0.03 0.05-0.05 0.1-0.06zm-130.82 0.19c-0.32 0.12-0.59 1.8-0.59 4.09 0 2.62 0.18 4.54 0.41 4.31 0.76-0.78 1.01-7.67 0.31-8.37-0.05-0.05-0.08-0.05-0.13-0.03zm-164.94 0.9c-0.34 0.01-0.68 0.09-1 0.28-0.75 0.47-0.68 0.95 0.26 1.54 1.75 1.11 2.78 1.08 2.78-0.07 0-1.02-1-1.76-2.04-1.75zm293.1 1.22 0.06 2.82c0.04 1.61-0.68 3.41-1.66 4.15-2.29 1.74-4.18 1.72-4.18-0.06 0-0.8 0.57-1.21 1.28-0.94 0.75 0.29 1.97-0.86 2.9-2.75l1.6-3.22zm-356 0.1c1.016 0.04 1.64 0.71 2.5 2.37 1.871 3.61 1.851 6.75-0.031 7.47-0.812 0.31-1.469 1.13-1.469 1.75s-1.03 2.21-2.281 3.56c-1.252 1.35-2.743 3.33-3.344 4.41-0.965 1.72-1.125 1.49-1.406-1.97-0.247-3.03-0.699-3.87-1.969-3.66-0.906 0.15-1.938-0.16-2.281-0.71-0.344-0.56-1.91-1.04-3.469-1.04s-3.061-0.35-3.344-0.81c-1.13-1.83 10.041-9.71 15.906-11.22 0.44-0.11 0.849-0.17 1.188-0.15zm19.311 0.31c0.37 0.01 0.43 0.69-0.06 2.28-0.38 1.22-0.93 3.22-1.22 4.44-0.29 1.21-0.9 2.22-1.37 2.22-0.48 0-0.91 0.65-0.91 1.47 0 0.81-0.43 1.46-0.97 1.46-1.46 0-1.22-1.55 1.09-6.93 1.31-3.03 2.82-4.95 3.44-4.94zm181.38 0.06c1.46 0 1.18 3.55-0.38 4.85-0.75 0.61-1.6 2.33-1.91 3.81-0.53 2.59-3.53 7.44-3.59 5.81-0.02-0.44 1.09-3.23 2.44-6.19 1.35-2.95 2.47-6.01 2.47-6.81s0.43-1.47 0.97-1.47zm-35.19 0.5 0.87 3.85c0.91 3.86 0.81 5.08-0.4 3.87-0.36-0.36-0.65-2.25-0.6-4.19l0.13-3.53zm-71.91 0.09c0.07-0.01 0.15-0.01 0.19 0.04 0.34 0.34-0.66 2.48-2.22 4.75-3.2 4.65-5.97 7.27-5.97 5.65 0-0.58 0.67-1.41 1.44-1.84s2.44-2.7 3.75-5c1.14-2.01 2.31-3.48 2.81-3.6zm238.66 0.41c2.74 0.01 3.32 0.26 2.22 0.97-1.94 1.25-5.91 1.25-5.91 0 0-0.54 1.66-0.98 3.69-0.97zm-80 1.35c0.35 0 0.59 0.36 0.59 0.96 0 0.8 0.54 1.63 1.19 1.85 0.92 0.3 0.92 0.55 0 1.12-0.65 0.4-1.19 0.23-1.19-0.37 0-0.61-0.46-0.81-1-0.47-0.54 0.33-0.97-0.06-0.97-0.88 0-0.81 0.43-1.76 0.97-2.09 0.14-0.08 0.29-0.13 0.41-0.12zm92.47 0.12c0.02-0.01 0.04-0.01 0.06 0 0.11 0.05 0.24 0.34 0.34 0.84 0.22 1.01-0.07 2.26-0.59 2.78-0.62 0.62-0.74-0.04-0.37-1.84 0.22-1.12 0.4-1.7 0.56-1.78zm-233.1 0.34c0.35-0.05 0.73 0.47 1.16 1.6 0.8 2.09-2.56 25.12-4.16 28.47-0.75 1.57-1.37 3.46-1.37 4.18 0 0.73-0.46 1.32-1 1.32-1.25 0-1.26-2.43-0.03-4.66 2-3.65 4.17-15.81 4.12-23.09-0.03-4.85 0.52-7.7 1.28-7.82zm70.75 0.25c-0.22-0.08-0.14 0.28 0.19 1.16 0.37 0.97 0.92 1.55 1.22 1.25s0.02-1.11-0.66-1.78c-0.36-0.36-0.61-0.58-0.75-0.63zm-125.5 0.16c-0.32 0-0.61 0.01-0.87 0.03-5.95 0.56-5.74 1.69 0.31 1.69 3.55 0 5.86 0.48 6.63 1.41 0.8 0.96 3.08 1.4 7.09 1.34 3.35-0.05 5.49-0.45 5-0.94-1.31-1.31-13.27-3.57-18.16-3.53zm217.29 0.72c-0.71 0.01-0.58 0.43 0.31 1 1.89 1.22 2.22 1.22 1.47 0-0.34-0.54-1.14-1.01-1.78-1zm-93.94 0.12c-0.17 0.04-0.19 0.55-0.19 1.63 0 1.21 0.44 2.97 0.94 3.9 0.5 0.94 1.14 2.53 1.43 3.47 0.3 0.95 0.79 1.72 1.1 1.72 0.95 0-0.67-7.24-2.1-9.31-0.65-0.95-1.01-1.44-1.18-1.41zm179.62 0.03c0.18 0.01 0.39 0.01 0.6 0.04 1.79 0.25 2.11 1.05 2.37 5.65 0.17 2.95 0.06 6.38-0.25 7.63-0.31 1.24-1.07 2.28-1.66 2.28-0.58 0-0.76-0.7-0.43-1.56 1.46-3.8 1.72-6.32 0.69-6.32-0.6 0-1.09 1.23-1.1 2.72-0.01 2.02-0.26 2.35-0.94 1.28-0.54-0.86-0.52-2.08 0.04-3.12 0.5-0.94 0.87-3.21 0.81-5-0.07-2.07-0.33-2.53-0.63-1.28-0.8 3.32-1.91 3.69-1.44 0.47 0.32-2.13 0.72-2.81 1.94-2.79zm-26.34 0.97c0.44 0 0.88 0.09 1.22 0.22 0.67 0.28 0.13 0.47-1.22 0.47s-1.93-0.19-1.25-0.47c0.34-0.13 0.8-0.22 1.25-0.22zm-93 0.1c0.22-0.23 0.88 1.52 1.5 3.87 3.2 12.2 14.82 29.35 19.84 29.35 0.96 0 3.35 1.11 5.35 2.47l3.62 2.46h-4.44c-2.75 0-4.93-0.58-5.68-1.5-1.57-1.89-4.91-1.91-4.91-0.03 0 2.54 3.18 3.28 14.97 3.44 10.28 0.14 12.23-0.14 18.19-2.44 9.18-3.54 16.95-7.33 20.62-10.06 1.7-1.26 4.04-2.46 5.22-2.69s3.11-0.71 4.28-1.06c1.63-0.48 1.32 0.1-1.31 2.41-1.89 1.65-3.99 2.8-4.69 2.56s-1.55 0.34-1.9 1.28c-0.73 1.9-4.2 5.04-5.6 5.09-0.5 0.02-1.61 0.65-2.47 1.41-2.16 1.91-13.45 7.73-18.78 9.69-2.43 0.89-7.07 2.08-10.28 2.65-7.82 1.4-9.13 1.39-7.63-0.12 2.07-2.06 1.33-2.47-5.71-3.13-5.22-0.48-7.8-1.3-10.75-3.34-2.15-1.48-3.95-3.08-3.97-3.56s-1.08-1.83-2.35-3c-2.51-2.33-4.44-11.38-2.43-11.38 0.59 0 0.84-0.88 0.56-1.97-0.28-1.08-0.15-1.97 0.34-1.97 0.49 0.01 0.91 0.69 0.91 1.54 0 0.84 1.11 3.95 2.47 6.9 1.35 2.96 2.43 5.75 2.43 6.19 0 1 3.47 5.03 4.32 5.03 1.33 0 0.51-2.3-1.82-5.06-1.33-1.59-2.92-4.73-3.53-7-0.6-2.28-1.5-4.65-2-5.25-0.49-0.6-1.32-4.38-1.84-8.38-0.52-3.99-1.39-8.76-1.94-10.62s-0.82-3.56-0.59-3.78zm-153.16 0.31c0.05 0 0.1 0 0.13 0.03 0.26 0.26-0.31 1.22-1.28 2.16-1.7 1.62-1.75 1.6-0.5-0.47 0.62-1.04 1.32-1.73 1.65-1.72zm253.75 0.56c0.36-0.11 0.35 0.31 0.16 1.32-0.2 1.02-0.92 2.02-1.59 2.24-1.76 0.59-1.54-1.22 0.34-2.78 0.51-0.42 0.88-0.71 1.09-0.78zm-282.69 1c-0.83 0.08-1.69 0.94-1.81 2.56-0.11 1.55 0.4 2.22 1.66 2.22 1.28 0 1.78-0.7 1.78-2.5 0-1.61-0.79-2.35-1.63-2.28zm-28.71 0.85c0.4 0 0.24 1.46-0.35 3.21-1.6 4.81-2.66 5.41-1.44 0.82 0.59-2.21 1.39-4.03 1.79-4.03zm249.78 1.09c-0.76 0.01-0.93 0.26-0.63 0.75 0.38 0.61 2.09 1.16 3.82 1.22 1.72 0.05 4.24 0.44 5.59 0.87 3.37 1.08 9.84 1.19 9.84 0.16 0-0.46-3-1.14-6.65-1.5-3.66-0.36-8.14-0.92-9.97-1.25-0.89-0.16-1.55-0.26-2-0.25zm-187.72 0.03c0.48 0 0.17 0.79-0.85 2.19-1.02 1.41-2.24 2.54-2.71 2.56-1.22 0.05 1.76-4.17 3.31-4.69 0.1-0.03 0.18-0.06 0.25-0.06zm177.91 0.13c0.03-0.06 0.56 0.17 1.62 0.68 1.22 0.59 2.22 1.28 2.22 1.54 0 0.75-0.53 0.54-2.53-1.07-0.92-0.73-1.35-1.09-1.31-1.15zm-206.19 0.4c-1.63 0.03-1.88 0.6-0.81 1.66 0.9 0.91 3.51 0.77 5.12-0.25 0.93-0.59 0.25-0.99-2.22-1.28-0.85-0.1-1.55-0.14-2.09-0.13zm-59.5 1.32c1.84 0 4.95 3.68 5.5 6.5 0.48 2.52 0.06 3.59-2.41 6.12-1.65 1.69-3.3 4.66-3.66 6.56-0.35 1.9-1.014 3.44-1.495 3.44s-0.906 1.31-0.906 2.94c0 2.26-0.441 2.97-1.907 2.97-2.482 0-3.336-1.5-3.968-6.91-0.487-4.17-0.687-4.41-3.594-4.5-6.712-0.21-8.173-2.99-3.781-7.16 3.048-2.89 3.216-1.59 0.219 1.66l-2.219 2.38 2.469-0.72c1.352-0.41 3.003-1.17 3.656-1.69 0.652-0.52 1.573-0.72 2.031-0.44 1.313 0.81 7.917-5.8 8.625-8.62 0.35-1.4 1.02-2.53 1.44-2.53zm181.97 0c-0.54 0-0.97 0.42-0.97 0.96s0.43 1 0.97 1 1-0.46 1-1-0.46-0.96-1-0.96zm168.37 0c0.5 0 0.43 0.88-0.15 1.96-0.58 1.09-1.21 1.97-1.41 1.97s-0.13-0.88 0.15-1.97c0.29-1.08 0.91-1.96 1.41-1.96zm-92.69 0.43c1.81 0 3.56 0.65 4.94 2.03 1.28 1.29 1.24 1.48-0.47 1.57-1.06 0.05-0.24 0.48 1.81 0.97 2.06 0.48 6.27 2.07 9.35 3.53l5.59 2.65-5.65 1.69c-4.13 1.22-6.65 1.41-9.35 0.78-4.8-1.11-5.42-1.09-4.68 0.09 0.33 0.55 1.92 1 3.53 1 2.57 0.01 2.86 0.3 2.47 2.47-0.4 2.16-0.11 2.44 2.37 2.44 3.25 0 4.84-1.57 2.25-2.25-1.08-0.28-0.75-0.49 0.94-0.56 1.58-0.07 2.72-0.68 2.72-1.47s1.51-1.58 3.68-1.94c5.67-0.93 20.87-0.72 25.82 0.38 6.79 1.51 7.4 1.82 6.12 3.09-0.82 0.82-1.47 0.83-2.47 0-1.82-1.51-14.68-3.28-19.19-2.62-2 0.29-5.16 0.7-7.03 0.87-4.56 0.43-4.94 2.21-0.56 2.72 2.82 0.33 3.42 0.12 2.97-1.06-0.41-1.07-0.02-0.95 1.44 0.37 1.95 1.77 2 1.76 2.03-0.06 0.03-1.83 0.06-1.83 1.47 0.03 0.79 1.05 1.44 1.33 1.44 0.66 0-0.68 0.52-0.91 1.12-0.53 0.6 0.37 1.47 0.05 1.94-0.69 0.72-1.15 0.86-1.14 0.87 0 0.01 1.04 0.32 1.1 1.38 0.22s1.75-0.78 2.97 0.43c0.87 0.87 1.56 1.08 1.56 0.5 0-0.57 0.66-1.03 1.47-1.03s1.47 0.47 1.47 1.07 0.73 0.83 1.59 0.5 1.97-0.33 2.5 0c1.84 1.13-11.36 7.02-16.19 7.22-1.08 0.04-1.52 0.52-1.09 1.21 0.5 0.82-0.43 0.97-3.41 0.57-3.66-0.49-4-0.39-2.87 0.96 1.11 1.34 0.95 1.43-1.19 0.76-1.35-0.43-3.13-0.99-3.94-1.29-1.26-0.46-1.25-0.33-0.09 1.1 2.61 3.21-4.73 1.96-10.66-1.81-2.95-1.88-5.95-3.41-6.69-3.41-0.73 0-1.04-0.45-0.68-1.03s-0.29-1.96-1.44-3.03-3.44-4.77-5.12-8.22l-3.1-6.28 2.84-2.53c1.55-1.39 3.42-2.06 5.22-2.07zm-240.25 0.22c1.91 0.01 3.25 2.54 3.25 7.09 0 2.56-0.53 5.2-1.18 5.85-1.77 1.76-3.45 1.41-5.16-1.03-1.59-2.28-2.03-7.42-0.78-9.13 1.39-1.89 2.73-2.79 3.87-2.78zm50.66 1.69c-0.07 0.02-0.12 0.05-0.19 0.09-0.54 0.34-1 1.06-1 1.57 0 0.5 0.46 0.9 1 0.9s0.97-0.69 0.97-1.53c0-0.63-0.24-1.02-0.59-1.03-0.06 0-0.12-0.02-0.19 0zm12.87 0.06c0.29-0.12 0.23 0.59-0.03 2.34-0.25 1.71-0.86 3.13-1.34 3.13-1.3 0-1.07-2.34 0.44-4.41 0.45-0.61 0.77-0.99 0.93-1.06zm193.6 0.66c0.34-0.02 0.71 0.04 1.06 0.18 0.79 0.32 0.58 0.55-0.56 0.6-1.04 0.04-1.64-0.17-1.31-0.5 0.16-0.16 0.47-0.27 0.81-0.28zm18.59 1.97c0.63 0 1.25 0.06 1.72 0.18 0.95 0.25 0.18 0.47-1.72 0.47-1.89 0-2.66-0.22-1.72-0.47 0.48-0.12 1.1-0.18 1.72-0.18zm-289.65 0.21c-1.45 0.11-8.41 5.58-8.41 6.76 0 1.09 5.52-2.06 7.63-4.38 0.86-0.95 1.32-1.99 1-2.31-0.05-0.05-0.13-0.07-0.22-0.07zm342.46 0.94c2.02-0.1 4.19 0.61 6.72 2.1 3.23 1.88 4.41 3.24 4.41 4.87 0 3.19-1 3.83-3.09 1.94-2.6-2.35-3.46-0.79-1.44 2.62 1.46 2.48 1.48 2.81 0.19 2.32-0.84-0.33-1.57-0.06-1.57 0.56 0 0.61 0.71 1.37 1.54 1.69 1.1 0.42 1.21 0.9 0.43 1.84-0.75 0.91-0.77 1.46 0 1.94 0.72 0.44 0.78 1.06 0.13 1.84-0.61 0.73-0.63 1.73-0.06 2.63 0.5 0.79 0.9 2.75 0.9 4.37 0 2.71-0.2 2.53-2.56-2.22-1.42-2.84-2.96-5.15-3.44-5.15s-0.35 1 0.28 2.21c2.45 4.73 2.78 5.71 2.78 7.57 0 1.05 0.46 2.19 1 2.53 1.24 0.76 1.32 4.4 0.1 4.4-0.5 0.01-1.5 0.19-2.22 0.41-1.61 0.5-5.58-0.66-8.47-2.47-1.75-1.09-2.77-1.11-5.31-0.15-1.74 0.65-3.29 1.05-3.47 0.87-0.57-0.57 5.01-5.76 7.06-6.56 1.9-0.74 1.93-0.78 0.13-1.5-1.27-0.51-2.26-0.2-3.07 0.9-2.9 3.98-4.43 0.26-4.43-10.84 0-7.14 0.66-8.81 5.75-14.22 2.74-2.91 5.13-4.37 7.71-4.5zm-306.18 0.03c-0.12 0.03-0.27 0.08-0.41 0.16-0.54 0.33-1 1.08-1 1.63 0 0.54 0.46 0.67 1 0.34 0.54-0.34 0.97-1.05 0.97-1.6 0-0.4-0.21-0.59-0.56-0.53zm158.75 0.66c0.43 0 0.77 1.18 0.75 2.63-0.03 1.44-0.68 2.83-1.44 3.09-0.97 0.32-1.21-0.03-0.75-1.22 0.36-0.93 0.66-2.36 0.66-3.13 0-0.76 0.35-1.37 0.78-1.37zm113.75 0.13c0.44 0 0.56 0.29 0.56 0.74 0 0.47-1.9 1.56-4.22 2.44-6.29 2.4-7.83 1.79-2.19-0.87 3.44-1.62 5.1-2.32 5.85-2.31zm-131.32 0.87c-0.57 0-0.77 0.43-0.43 0.97 0.33 0.54 0.79 1 1.03 1s0.44-0.46 0.44-1-0.46-0.97-1.04-0.97zm77.47 0c-3.22-0.03-0.78 1.66 3.5 2.44 2.32 0.42 4.5 0.73 4.91 0.65s0.75 0.28 0.75 0.82 0.25 1 0.56 1c0.32 0 0.42-0.47 0.22-1.07-0.4-1.2-7.14-3.82-9.94-3.84zm43.85 0.13c0.52 0 0.72 0.26 0.72 0.84 0 0.54-1.23 0.97-2.72 0.94-2.4-0.07-2.46-0.19-0.72-0.94 1.34-0.58 2.19-0.84 2.72-0.84zm-11.1 0.96c0.45 0 0.92 0.09 1.25 0.22 0.68 0.28 0.11 0.5-1.25 0.5-1.35 0-1.89-0.22-1.22-0.5 0.34-0.13 0.78-0.22 1.22-0.22zm-117.65 0.07c0.06-0.03 0.13 0.01 0.22 0.09 0.32 0.33 0.34 1.16 0.06 1.88-0.32 0.78-0.52 0.55-0.56-0.6-0.04-0.78 0.08-1.3 0.28-1.37zm141.93 0.15c0.28 0 0.54 0.18 0.76 0.53 0.34 0.57-0.7 1.7-2.32 2.53-3.63 1.89-4.03 1.88-4.03 0.04 0-0.82 0.81-1.47 1.78-1.47 0.98 0 2.26-0.48 2.85-1.07 0.36-0.36 0.69-0.55 0.96-0.56zm-227.34 1.28c0.79 0.02 0.93 2.74 0.63 11-0.23 6.3-0.78 11.93-1.19 12.47-0.42 0.54-1.05 2.37-1.41 4.07-0.36 1.69-1.76 4.12-3.15 5.4-4.08 3.77-7.23 9.39-7.88 14.13-0.65 4.76 0.29 5.62 3.13 2.78 1.38-1.39 2.28-1.48 5.59-0.6 3.21 0.86 4.47 0.73 6.72-0.56 2.86-1.64 5.84-6.71 5.84-9.91 0-2.42 1-2.61 11.1-2.21l8.59 0.34v5.87 5.85l-3.69-0.66c-2.03-0.37-3.91-1.01-4.18-1.4-0.28-0.39-1.52-1.05-2.79-1.44-1.7-0.53-2.79-0.13-4.25 1.44-1.08 1.16-4.35 3.14-7.28 4.43-2.93 1.3-5.34 2.74-5.34 3.22s-1.12 1.47-2.47 2.19-2.47 1.72-2.47 2.19-0.87 1.79-1.94 2.94c-1.06 1.14-2.28 3.88-2.72 6.09-0.61 3.15-1.3 4.09-3.06 4.34-1.23 0.18-2.45 0.95-2.75 1.72-0.68 1.78-1.75 1.7-7.09-0.47-5.02-2.03-7.22-4.5-6.81-7.81 0.22-1.85 1.29-2.68 4.97-3.84 2.56-0.82 4.65-2.07 4.65-2.75 0-0.69 0.5-1.41 1.06-1.6 0.67-0.22 0.49-1.61-0.5-3.97-0.9-2.16-1.32-5.01-1-7.03 0.61-3.84-0.52-5.02-3.97-4.15-1.74 0.43-2.45 1.5-2.93 4.28-0.36 2.03-1.65 4.94-2.91 6.5-2.14 2.65-2.39 2.73-3.28 1-0.66-1.28-0.47-3.45 0.59-6.97 1.72-5.71 4.78-8.04 13.19-10.16 2.57-0.64 4.66-1.58 4.66-2.06s0.69-0.88 1.5-0.88c0.81 0.01 1.47-0.36 1.47-0.84s0.94-1.14 2.06-1.44c1.12-0.29 2.24-1.44 2.53-2.56s1.02-2.03 1.56-2.03 0.72-0.89 0.44-1.97-0.13-1.74 0.31-1.47c1.56 0.97 2.87-5.97 2.47-13.09-0.43-7.66-0.08-9.6 1.84-10.34 0.06-0.03 0.11-0.04 0.16-0.04zm255.63 0.41c-0.48 0.04-1.31 0.38-2.82 1.06-1.37 0.63-2.53 1.48-2.53 1.91 0 0.42 1.35 0.35 2.97-0.22s2.94-1.42 2.94-1.91c0-0.57-0.09-0.88-0.56-0.84zm-126.57 0.56c0.51-0.31 1.23 4.42 1.6 10.88 0.63 11.05 0.38 14.18-0.75 10.43-1.05-3.46-1.74-20.76-0.85-21.31zm138 0.35c-0.2-0.02-0.4 0.06-0.62 0.28-0.33 0.32-0.27 1.12 0.16 1.81 0.61 1 0.85 1 1.18 0 0.36-1.07-0.1-2.03-0.72-2.09zm-36.34 0.5c0.53-0.06 0.88 0.13 0.88 0.53 0 0.52-0.66 0.93-1.47 0.93-0.82 0-1.47-0.16-1.47-0.37s0.65-0.66 1.47-0.97c0.2-0.08 0.41-0.1 0.59-0.12zm-240.31 0.5c0.12 0 0.15 0.31 0.12 0.96-0.03 0.82-0.47 2.39-0.93 3.47-0.85 1.97-0.83 1.97-0.88 0-0.03-1.08 0.35-2.65 0.88-3.47 0.42-0.65 0.68-0.96 0.81-0.96zm-29.07 1.37c-0.15 0.01-0.37 0.08-0.65 0.19-0.78 0.3-1.64 1.17-1.94 1.94-0.82 2.13 1.16 1.68 2.35-0.54 0.62-1.17 0.71-1.62 0.24-1.59zm145.91 0.06c0.03-0.01 0.06 0 0.09 0 0.18 0.03 0.45 0.24 0.88 0.6 0.77 0.64 1.41 1.55 1.41 2.03 0 1.71-1.74 0.79-2.25-1.19-0.24-0.91-0.31-1.36-0.13-1.44zm-170.97 0.19 2.66 2.88c2.26 2.43 2.55 3.41 2.03 6.65-0.57 3.57-2.58 6.19-6.66 8.57-1.35 0.78-1.58 0.67-1.12-0.54 0.49-1.28 0.11-1.25-2.47 0.22-2.01 1.14-2.59 1.86-1.62 2.06 0.8 0.18 1.5 0.63 1.5 1 0 1.26-3.85 3.1-5.32 2.54-0.8-0.31-2.27-0.14-3.25 0.43-1.59 0.93-1.51 1.07 0.66 1.1 2.3 0.03 2.34 0.12 0.72 1.75-0.94 0.94-2.48 1.71-3.41 1.72-0.93 0-1.72 0.68-1.72 1.53 0 1.96-3.11 5.18-4.31 4.43-0.5-0.3-2.17-0.07-3.688 0.5-1.688 0.65-2.31 1.3-1.624 1.72 0.806 0.5 0.616 2.11-0.688 5.82-2.386 6.77-6.636 12.56-10.625 14.46-1.777 0.86-3.366 1.54-3.531 1.54-0.66 0 0.625-21.17 1.312-21.63 0.406-0.27 1.029-1.61 1.375-2.97 0.551-2.15 17.349-20.65 18.749-20.65 0.29 0 2.81-2.15 5.56-4.79 3.26-3.1 6.83-5.4 10.22-6.56l5.25-1.78zm-15.53 0.44c0.53-0.03 1 0.5 1.41 1.56 0.42 1.1-0.38 2.55-2.38 4.38-3.36 3.07-3.98 1.7-1.47-3.16 0.96-1.84 1.76-2.75 2.44-2.78zm44.63 0.22c-0.48 0-1.19 0.37-1.85 1.03-1.73 1.73-0.88 2.12 1.44 0.65 0.8-0.5 1.18-1.19 0.81-1.56-0.09-0.09-0.24-0.12-0.4-0.12zm-48.91 0.09c0.21-0.04 0.34 0.03 0.34 0.22 0 0.5-0.88 1.67-1.97 2.59-1.08 0.93-1.96 1.33-1.96 0.88s0.88-1.65 1.96-2.63c0.68-0.61 1.28-0.98 1.63-1.06zm69.84 0.97c0.25 0.05 0.34 0.76 0.35 2.25 0.01 1.73-0.46 3.42-1 3.75-1.26 0.78-1.26-3.46 0-5.41 0.27-0.42 0.51-0.62 0.65-0.59zm5.63 0.44c0.29 0.11 0.14 3.1-0.56 7.09-0.62 3.49-1.49 6.74-1.94 7.25-1.12 1.28-1.05-2.04 0.12-5.78 0.53-1.66 1.25-4.26 1.57-5.81 0.35-1.75 0.58-2.59 0.75-2.72 0.02-0.02 0.04-0.04 0.06-0.03zm241.4 0.28c0.19 0.03 0.22 0.39 0.22 1.12 0 0.93-0.33 1.69-0.75 1.69-0.69 0-5.54 6.71-9.12 12.63-0.84 1.37-2.12 2.68-2.88 2.93-1.24 0.42 8.2-14.07 11.41-17.5 0.59-0.63 0.94-0.91 1.12-0.87zm-70.96 0.69c0.18-0.02 0.76 0.46 1.75 1.56 1.41 1.57 2.53 3 2.53 3.19 0 0.73-0.72 0.26-2.13-1.38-1.67-1.95-2.45-3.34-2.15-3.37zm-48.6 1.15c0.95 0 1.87 1.91 2.69 5.6 1.22 5.43 1.3 5.51 2.59 3.18 1.47-2.64 1.7-1.74 0.78 2.85-0.33 1.65-1.24 3.26-2.03 3.56-1.01 0.39-1.25 0.03-0.87-1.19 0.61-1.93-1.77-10.64-3.47-12.68-0.85-1.03-0.79-1.32 0.31-1.32zm156.56 0.19c0.07-0.02 0.14 0.01 0.22 0.09 0.33 0.33 0.35 1.17 0.07 1.88-0.32 0.78-0.52 0.55-0.57-0.6-0.03-0.77 0.08-1.3 0.28-1.37zm-120.5 0.78c-1.13 0-1.1 0.71 0.19 3.13 0.59 1.09 1.27 1.8 1.47 1.59 0.67-0.67-0.76-4.72-1.66-4.72zm-183.09 0.09c3.29 0.09 3.41 0.21 1.22 0.91-3.52 1.13-4.94 1.13-4.94 0 0-0.54 1.69-0.96 3.72-0.91zm270.72 0.79c0.35 0-0.47 1.24-2.63 4.15-2.16 2.93-4.67 6.63-5.59 8.25-2.18 3.85-6.08 9.28-8.75 12.13-1.67 1.78-1.84 2.42-0.81 3.06 0.91 0.57 0.98 1 0.22 1.47-0.6 0.37-1.1 0.17-1.1-0.47 0-0.82-0.48-0.77-1.68 0.19-1.6 1.26-1.61 1.18-0.16-1.13 5.33-8.49 5.3-8.46 9.03-13.28 1.26-1.62 3.49-4.94 5-7.37 1.51-2.44 3.91-5.28 5.28-6.32 0.63-0.46 1.03-0.69 1.19-0.68zm-99.31 0.12c-1.39 0-1.25 5.96 0.22 9.13 0.67 1.45 1.57 2.68 2 2.68 0.42 0.01 0.34-0.86-0.22-1.9-0.56-1.05-1.03-3.71-1.03-5.91s-0.43-4-0.97-4zm102.72 1.97c1.3 0 0.4 2.64-1.69 4.91-3.25 3.52-13.92 20.85-16.06 26.06-1.01 2.43-2.22 4.43-2.66 4.44-1.01 0 0.15-3.8 1.94-6.38 0.74-1.07 1.31-2.7 1.31-3.62 0-0.93 0.63-2.26 1.38-3 0.74-0.74 1.59-2.23 1.93-3.32 0.35-1.08 2.63-5.04 5.07-8.75 2.43-3.7 4.4-7.09 4.4-7.53 0-0.76 3.2-2.81 4.38-2.81zm30.43 0.41c0.15-0.04 0.36 0.14 0.63 0.56 0.52 0.81 0.96 2.27 0.97 3.22 0.01 0.94-0.43 1.72-0.97 1.72s-0.98-1.46-0.97-3.22c0.01-1.52 0.1-2.22 0.34-2.28zm-159.75 0.56c0.53 0 0.72 0.66 0.41 1.47s-0.76 1.5-0.97 1.5-0.4-0.69-0.4-1.5c-0.01-0.81 0.44-1.47 0.96-1.47zm141.35 1c-1.69 0-6.57 3.72-6.57 5.03 0.01 0.54 1.78 0 3.94-1.22 3.98-2.23 5.09-3.81 2.63-3.81zm9.19 0c-0.55 0-1 0.46-1 1.03-0.01 0.57 0.45 0.77 1 0.44 0.54-0.34 0.96-0.83 0.96-1.06 0-0.24-0.42-0.41-0.96-0.41zm-177.16 0.97c0.41 0 1.25 1.89 1.84 4.18 0.6 2.3 1.93 6.85 3 10.1 1.08 3.24 2.73 8.53 3.66 11.78 3.13 10.91 12.31 29.52 22.4 45.47 2.92 4.61 13.88 16.19 16.82 17.75 1.82 0.97 1.81 1.03-0.22 2.12-1.76 0.94-2.04 0.88-1.56-0.37 0.31-0.83 0.16-1.5-0.38-1.5-0.53 0-3.11-2.01-5.75-4.44-2.63-2.43-5.11-4.43-5.53-4.44-1.41-0.02 2.19 4.44 5.62 6.91 3.84 2.77 4.43 3.98 1.54 3.22-2.67-0.7-10.68-9.57-17.16-19-4.51-6.57-4.53-6.53-4.53-4.69 0 0.82 1.15 2.74 2.53 4.31 1.38 1.58 3.13 4.29 3.88 6.04 0.74 1.74 4.66 6.52 8.71 10.59 6.04 6.05 7.03 7.41 5.25 7.41-5.77 0-24.32-16.82-34.31-31.1-1.85-2.65-4.69-7.16-6.28-10s-3.25-5.15-3.69-5.16c-0.44 0-0.6 0.35-0.37 0.76 4.48 8.09 9.79 16.67 13.15 21.24 2.34 3.18 4.25 6.11 4.25 6.54 0 1.18 5.01 6.19 8.85 8.84 1.89 1.31 3.66 2.66 3.94 3 0.27 0.34 2.5 1.78 4.93 3.22 2.44 1.44 3.88 2.65 3.19 2.66-0.69 0-2.89-1.03-4.91-2.29-6.28-3.91-8.06-4.2-4.75-0.75 1.59 1.66 3.63 3.04 4.5 3.04 0.88 0 2.45 0.64 3.5 1.43 1.05 0.8 2.8 1.43 3.88 1.44 1.59 0.01 1.67-0.13 0.5-0.87-2.34-1.49-0.75-1.79 1.94-0.38 1.35 0.71 1.89 1.3 1.18 1.31-0.7 0.01-1.02 0.43-0.68 0.97 0.33 0.54 0.07 1-0.57 1-0.86 0-0.85 0.37 0.07 1.47 1.43 1.73 1.28 1.71-1.97-0.09-1.36-0.75-3.21-1.37-4.16-1.38s-1.72-0.46-1.72-1-0.52-0.97-1.12-0.97c-2.05 0-12.11-6.71-18.72-12.47-6.26-5.45-16.43-16.75-21.31-23.72-1.44-2.04-2.17-4.31-1.97-6.15 0.29-2.83 0.44-2.73 4.47 3.25 2.28 3.38 5.17 7.24 6.4 8.59 1.24 1.36 3.94 4.56 6 7.13 2.07 2.56 4.2 4.68 4.75 4.68 0.96 0-1.73-3.85-6.03-8.59-1.09-1.2-2-2.46-2-2.81s-2.2-3.43-4.9-6.88c-2.71-3.44-4.94-6.54-4.94-6.87 0-0.34-0.82-1.78-1.82-3.22-1.95-2.81-3.3-7.05-2.24-7.03 0.35 0 1.51 1.83 2.56 4.03 1.75 3.66 6.44 10.68 6.44 9.66-0.01-0.24-1.53-3.53-3.41-7.32-1.89-3.78-3.43-7.19-3.44-7.56-0.02-0.99 3.89-2.08 7.81-2.19 3.3-0.08 3.58 0.2 7.63 7.78 2.31 4.33 4.53 8.54 4.94 9.35 2.7 5.41 12.61 20.86 15.47 24.12 1.89 2.17 3.45 4.25 3.46 4.66 0.03 0.97 1.97 0.97 1.97 0 0-0.41-0.99-1.84-2.22-3.19-2.08-2.3-4.84-6.07-7.12-9.72-0.55-0.87-1.87-2.87-2.91-4.4-3.26-4.85-5.4-8.78-8.97-16.38-1.9-4.06-4.29-9.15-5.31-11.31-1.01-2.16-2.11-5.71-2.44-7.87l-0.59-3.94 2.44 4.94c1.35 2.7 2.48 5.67 2.5 6.62 0.03 1.63 2 2.59 2 0.97 0-0.42-1.58-4.52-3.5-9.06-1.92-4.55-3.31-9.17-3.1-10.29 0.31-1.6 0.56-1.36 1.16 1.16 0.42 1.76 1.15 3.22 1.63 3.22 1.1 0 1.1-1.51 0-3.69-1.53-3-2.93-6.6-3.44-8.93-0.41-1.88-0.22-2.06 0.94-1.1 1.78 1.48 1.74 1.28-0.54-6.94-1.04-3.78-1.54-6.9-1.12-6.9zm-60.28 3.94c3.13 0 2.95 0.68-1.06 4.59-3.29 3.19-7.44 4.4-7.44 2.19 0-1.94 6.08-6.78 8.5-6.78zm196.22 0c0.9 0-2.94 6.6-5.91 10.15-1.21 1.45-1.24 1.91-0.19 2.56 0.91 0.57 0.98 1.03 0.22 1.5-0.6 0.37-1.14 0.09-1.16-0.62-0.05-2.44-4.87 4.23-4.87 6.75 0 2 0.27 2.3 1.31 1.44 2.37-1.97 2.64 0.05 0.41 3.18-1.2 1.69-2.06 3.72-1.91 4.54 0.25 1.29 0.17 1.3-0.68 0.03-0.7-1.03-0.53-1.95 0.59-3.19 0.87-0.96 1.31-2.06 0.97-2.41-0.79-0.78-4.45 3.69-4.16 5.07 0.12 0.55 0.01 0.68-0.22 0.28-0.67-1.21-3.22-0.87-3.75 0.5-0.27 0.69-1.48 1.35-2.69 1.43l-2.15 0.13 2.22-1.81c1.22-1.01 2.8-2.01 3.47-2.25s0.95-0.69 0.68-0.97c-0.6-0.64-13.13 5.17-13.59 6.31-0.18 0.45-0.98 0.81-1.75 0.81s-3.27 0.87-5.56 1.94c-2.3 1.07-6.1 2.64-8.47 3.47-4.76 1.66-10.25 2.11-6.53 0.53 1.08-0.46 4.19-1.41 6.87-2.09 3.45-0.89 5.84-2.35 8.28-5 1.9-2.07 4.06-3.75 4.75-3.75 0.7 0 1.25-0.41 1.25-0.88s2.62-2 5.82-3.44c6.84-3.07 16.45-11.2 14.97-12.68-0.65-0.65-2.47-0.27-5.44 1.12-2.46 1.16-4.79 2.09-5.16 2.09-1.47 0.01-8.22 3.39-8.22 4.13 0 0.44-1.94 0.81-4.31 0.81s-5.96 0.69-7.97 1.53c-4.02 1.69-11.46 1.57-12.03-0.18-0.23-0.71 2.07-1.38 6.34-1.82 8.65-0.89 20.44-4.21 25.1-7.09 2.02-1.25 4.16-2.28 4.75-2.28s4.04-2.1 7.65-4.63c3.62-2.52 5.99-3.96 5.32-3.21-2.43 2.66-1.16 3.05 1.81 0.56 1.66-1.4 3.43-2.56 3.94-2.56zm-95.13 0.24c0.17 0 0.4 0.15 0.69 0.44 0.59 0.59 0.9 1.8 0.72 2.72-0.44 2.16-1.82 0.79-1.82-1.81 0.01-0.91 0.13-1.33 0.41-1.35zm-18.59 2c-0.07 0-0.12 0.03-0.16 0.07-0.3 0.3 0.39 1.83 1.53 3.43 1.14 1.61 2.07 3.41 2.07 4-0.01 0.6 0.22 1.07 0.5 1.07 0.27 0 0.5-0.54 0.5-1.22-0.01-1.62-3.47-7.2-4.44-7.35zm134.97 0.54c0.14 0.02 0.28 0.12 0.4 0.31 1.39 2.19 0.98 6.12-1.09 10.19-3 5.88-2.56 9.48 1.66 14.18 2.27 2.54 4.44 4 5.9 4 1.27 0 3.09 0.4 4.03 0.88s3.45 1.71 5.6 2.72c2.15 1 4.78 2.62 5.84 3.56s2.62 1.91 3.47 2.19c0.85 0.27 2.28 2.27 3.19 4.43 0.93 2.23 2.31 3.94 3.18 3.94 0.9 0 1.57 0.84 1.57 1.97 0 2.83-2.41 2.4-5.19-0.91-1.7-2.01-2.81-2.58-3.78-1.96-2.19 1.38-2.69 1.12-5.72-3.07-1.58-2.17-3.03-3.38-3.25-2.71-0.22 0.66-4.94-3.36-10.53-8.88l-10.19-10.03 0.56-6.69c0.57-6.74 2.8-13.8 4.22-14.09 0.05-0.01 0.08-0.04 0.13-0.03zm-215.63 0.68 0.63 6.41c0.34 3.51 0.46 6.52 0.25 6.75s-0.38-0.09-0.38-0.72c0-0.78-2.53-1.16-7.87-1.16-7.26 0.01-7.88-0.15-7.88-2 0-2.27 0.77-2.65 6.69-3.31 3.14-0.35 4.82-1.2 6.4-3.22l2.16-2.75zm-15.9 0.85c0.26 0 0.28 0.37 0.03 1.03-0.66 1.7-1.35 2.04-1.35 0.62 0-0.51 0.44-1.2 0.97-1.53 0.14-0.08 0.26-0.12 0.35-0.12zm54.34 0.22c0.02-0.01 0.06 0.02 0.09 0.06 0.45 0.62 0.98 10.23 1.16 21.37 0.18 11.15 0.06 20.28-0.25 20.28-0.32 0-0.6-4.16-0.6-9.21 0-5.06-0.21-14.67-0.53-21.38-0.29-6.29-0.25-11.07 0.13-11.12zm-79.84 0.37c0.33-0.01 0.56 0.23 0.56 0.88 0 0.47-0.61 1.39-1.38 2.03-1.14 0.95-1.28 0.78-0.84-0.88 0.32-1.23 1.1-2.01 1.66-2.03zm134.15 0.13c1.06-0.23 2.15 2.3 1.56 4.18-0.41 1.32-0.22 1.64 0.66 1.1 0.93-0.57 1.07-0.08 0.56 1.93-0.39 1.58-0.31 2.43 0.22 2.1 0.5-0.31 1.16 0.33 1.44 1.4 0.32 1.23 0.04 1.97-0.78 1.97-0.72 0-1.62-1.32-1.97-2.93s-1.13-2.81-1.75-2.69-1.32-0.79-1.5-2c-0.26-1.67 0.05-2.04 1.22-1.59 0.85 0.32 1.53 0.11 1.53-0.44 0-0.56-0.54-1.2-1.22-1.44s-0.87-0.85-0.44-1.31c0.15-0.16 0.32-0.25 0.47-0.28zm-131.91 0.28c0.16-0.1 0.19 0.33 0.22 1.19 0.05 1.13-0.82 2.86-1.9 3.84-1.12 1.01-1.94 1.27-1.94 0.62 0-0.62 0.41-1.12 0.91-1.12 0.49 0 1.33-1.23 1.87-2.72 0.41-1.13 0.69-1.72 0.84-1.81zm93.29 0.15c0.06 0.01 0.11 0.22 0.18 0.69 0.23 1.5 0.24 3.7 0 4.91-0.23 1.21-0.44 0.02-0.43-2.69 0-1.86 0.12-2.92 0.25-2.91zm-18.63 0.19c0.33-0.13 0.75 1.52 0.91 3.69 0.46 6.42 1.74 37.69 1.9 46.53 0.29 15.53-1.75 9.06-2.71-8.66-0.17-2.97-0.43-0.54-0.57 5.41-0.2 8.8-0.44 10.37-1.31 8.38-0.86-1.99-1.14-2.14-1.47-0.79-0.31 1.31-1.1 1.59-3.53 1.16-11.74-2.06-19.38-11.29-19.38-23.41 0-3.87 0.22-4.27 1.97-3.81 2.82 0.74 4.91-1.42 4.91-5.06 0-3.62 3.02-8.13 9.38-14 3.05-2.82 4.4-4.85 4.4-6.63 0-2.08 0.48-2.56 2.47-2.56 1.35 0 2.71-0.11 3.03-0.25zm212.06 1.69c1.15-0.04 1.99 4.83 1.25 7.78-0.5 1.99-0.28 2.59 0.94 2.59 1.88 0 2.1 1.53 0.35 2.35-0.99 0.46-0.99 0.73 0 1.18 0.67 0.32 1.24 0.91 1.24 1.35s-0.57 1.01-1.28 1.28c-2.3 0.89-4.94-15.06-2.72-16.44 0.08-0.05 0.15-0.09 0.22-0.09zm-55.72 0.94c0.1-0.03 0.21-0.02 0.29 0.06 0.3 0.3-0.02 1.11-0.69 1.78-0.97 0.96-1.07 0.84-0.53-0.56 0.27-0.73 0.64-1.21 0.93-1.28zm16.16 0.03c0.04 0 0.03 0.05 0.03 0.12 0.01 0.58-0.64 1.89-1.43 2.94-1.88 2.47-1.91 3.97-0.07 2.44 1.18-0.98 1.56-0.75 2.07 1.28 0.34 1.36 0.41 3.26 0.15 4.25-0.25 0.99-0.54 0.27-0.62-1.63l-0.13-3.43-1.5 2.72c-1.31 2.41-1.65 2.53-2.94 1.24-1.29-1.28-1.11-1.98 1.5-6.15 1.43-2.27 2.66-3.81 2.94-3.78zm31.78 0.72c0.18-0.07 0.44 0.13 0.85 0.53 0.6 0.6 0.92 1.59 0.71 2.22-0.48 1.46-1.81 0.14-1.81-1.82 0-0.55 0.08-0.87 0.25-0.93zm-284.53 0.81c0.54 0 0.97 0.2 0.97 0.44 0 0.23-0.43 0.69-0.97 1.03-0.54 0.33-1 0.13-1-0.44s0.46-1.03 1-1.03zm189.35 2.81-7.88 4.09c-4.33 2.26-8.3 4.48-8.84 4.91-2.1 1.65-8.18 2.44-15.25 1.97l-7.38-0.5-0.28-4.09-0.31-4.13 5.25-0.56c2.87-0.3 11.82-0.78 19.93-1.1l14.76-0.59zm-254.29 2.09c-0.54 0.01-0.97 0.46-0.97 1 0 0.55 0.43 0.97 0.97 0.97s0.97-0.42 0.97-0.97c0-0.54-0.43-1-0.97-1zm46.57 0.1c0.48-0.01 0.43 0.44-0.35 1.37-0.67 0.82-1.9 1.5-2.75 1.5-1.23 0-1.15-0.31 0.38-1.47 1.25-0.94 2.23-1.39 2.72-1.4zm287.4 0.06c0.98-0.09 2.45 0.2 4.44 0.81 2.42 0.75 2.39 0.8-1.22 2.38-4.1 1.8-7.41 2-9.59 0.62-1.17-0.74-1.23-1.18-0.25-2.15 0.92-0.93 1.22-0.93 1.22-0.03 0 0.65 0.88 1.18 1.96 1.18 1.1 0 1.97-0.68 1.97-1.5 0-0.78 0.49-1.22 1.47-1.31zm15.47 0.91c0.06-0.06 0.5 0.31 1.35 1.12 0.97 0.94 1.54 1.93 1.28 2.19s-1.07-0.49-1.78-1.69c-0.63-1.03-0.91-1.56-0.85-1.62zm-66.69 1c0.08-0.01 0.16-0.01 0.22 0 0.29 0.04 0.35 0.33 0.35 0.81 0 0.49-1.42 1.37-3.13 1.97-4.46 1.55-4.68 1.32-1.03-0.91 1.98-1.2 3.04-1.79 3.59-1.87zm-295 0.9c-0.712 0-1.551 0.69-1.875 1.53-0.325 0.85-0.989 1.31-1.438 1.04-0.783-0.49-4.125 2.7-4.125 3.93 0 0.33 0.632 0.12 1.375-0.5 0.743-0.61 2.021-0.84 2.844-0.53 1.001 0.39 1.993-0.45 3-2.47 1.191-2.38 1.244-3 0.219-3zm52.596 0.1c0.81 0-0.25 0.84-2.38 1.9-2.12 1.06-4.36 1.93-4.94 1.91-1.58-0.06 5.61-3.81 7.32-3.81zm303.87 0.12c0.61-0.06 1.27 0.34 2.47 1.13 1.39 0.91 2.53 2.29 2.53 3.09 0 1.65-1.55 1.95-2.47 0.47-0.33-0.54-2-0.97-3.72-0.97h-3.09l2.13-2.12c1.01-1.02 1.55-1.54 2.15-1.6zm-338.87 0.75c-0.24 0-0.44 0.46-0.44 1s0.49 0.97 1.06 0.97c0.58 0 0.77-0.43 0.44-0.97s-0.82-1-1.06-1zm306.31 0c0.12 0 0.13 0.35 0.09 1-0.04 0.81-0.47 2.59-0.9 3.94l-0.75 2.44-0.1-2.44c-0.04-1.35 0.32-3.13 0.85-3.94 0.42-0.65 0.69-1 0.81-1zm-108 0.78c0.01 0 0.05 0.02 0.06 0.04 1.52 1.8 2.86 9.32 2.28 12.9-0.64 4.03-2.23 5.47-2.53 2.28-0.42-4.57-0.27-15.1 0.19-15.22zm97.44 1.69-1.5 3.13c-1.79 3.69-1.88 4.25-0.57 4.25 0.55 0 1.06-0.78 1.1-1.72 0.04-0.95 0.3-1.23 0.56-0.6 0.26 0.64-1.14 3.23-3.06 5.75-1.93 2.52-3.5 3.94-3.5 3.13s0.5-1.67 1.12-1.88c0.99-0.33 1.43-1.82 1.75-6.28 0.05-0.61 0.99-2.16 2.1-3.43l2-2.35zm34.34 0.5c0.54 0 1 0.43 1 0.97s-0.46 1-1 1-0.97-0.46-0.97-1 0.43-0.97 0.97-0.97zm-305.47 0.13c0.5 0 0.43 0.26-0.47 0.84-0.81 0.52-2.12 0.94-2.93 0.91-0.98-0.04-0.8-0.35 0.5-0.91 1.35-0.58 2.4-0.84 2.9-0.84zm241.91 0.93c0.7-0.01 0.59 0.26 0.59 0.79 0 0.93-9.29 5.22-14.75 6.81-6.4 1.87-8.73 2.16-9.31 1.22-0.51-0.83 2.7-2.01 8.84-3.25 1.09-0.22-1.05-0.39-4.75-0.35-5.06 0.06-7-0.29-7.87-1.47-0.63-0.86-1.81-1.86-2.63-2.22-0.81-0.35 0.28-0.38 2.44-0.06 5.63 0.85 16.05 0.59 22.13-0.56 3.14-0.6 4.61-0.89 5.31-0.91zm-238.35 0.03c0.35-0.01 0.74 0.05 1.1 0.19 0.78 0.32 0.55 0.55-0.6 0.6-1.03 0.04-1.6-0.18-1.28-0.5 0.17-0.17 0.44-0.27 0.78-0.29zm-43.682 0.1c-0.224 0.07-0.569 1.04-1.032 2.97-0.385 1.6-0.22 2.72 0.375 2.72 0.552 0 0.969-1.38 0.969-3.1 0-1.79-0.089-2.66-0.312-2.59zm191.34 0c-0.12 0.04-0.19 0.17-0.19 0.4 0 0.56 0.33 1.33 0.69 1.69s0.85 0.41 1.13 0.13-0.02-1.02-0.66-1.66c-0.44-0.44-0.77-0.63-0.97-0.56zm-132.5 0.22c0.33-0.09 0.5 0.51 0.5 1.75 0 2.26-5.29 12.9-8.09 16.28-0.57 0.69-0.8 1.48-0.5 1.78 0.74 0.74 5.62-6.57 5.62-8.41 0-0.91 1.1-0.25 2.91 1.72 1.59 1.75 3.07 3.16 3.28 3.16 1.43 0 6.62-9.18 6.62-11.72 0-1.67 0.43-3.03 0.97-3.03s1.04 1.43 1.07 3.19c0.02 1.75 0.58 4.53 1.28 6.15 1.21 2.82 1.14 3.05-1.94 5.16-1.78 1.22-3.87 2.22-4.62 2.22-1.95 0-4.63 3.24-4.63 5.59 0 1.09 0.82 2.92 1.81 4.06 2.13 2.46 11.4 7.29 13.19 6.88 2.41-0.55 5.46 3.99 7.19 10.69l1.75 6.75-3 6.37c-1.65 3.51-4.03 8.84-5.28 11.81-3.06 7.28-5.25 9.58-12.22 12.91-6.5 3.11-10.28 3.48-14.75 1.44-1.63-0.75-4.94-2.26-7.38-3.38-2.43-1.11-6.21-2.69-8.37-3.47-7.55-2.72-15.25-6.51-15.25-7.5 0-0.54-0.54-0.99-1.22-1-1.4-0.01-10.45-10-12.31-13.59-0.68-1.3-1.22-2.93-1.22-3.59 0-0.67-0.686-2.62-1.534-4.32-2.095-4.2-1.472-7.91 1.754-10.31 2.6-1.93 2.75-1.94 4.68-0.19 1.1 0.99 1.97 2.62 1.97 3.6 0 3.78 8.96 16.59 11.6 16.59 0.52 0 2.02 0.83 3.31 1.85 3.13 2.44 7.51 3.13 24.65 3.9 7.94 0.36 14.73 1 15.13 1.41 1.46 1.47-1.74 8.18-4.94 10.37-5.13 3.52-9.12-0.02-4.62-4.09 2.35-2.13 5.21-2.17 4.4-0.06-0.39 1.03-0.83 1.19-1.28 0.47-0.45-0.73-1.23-0.46-2.37 0.81-2.36 2.6-0.45 3.55 3.28 1.62 3.34-1.72 4.85-5.68 3-7.9-1.57-1.89-2.44-1.86-5.06 0.25-8.8 7.04-10.11 12.15-4 15.56 3.62 2.02 3.73 2.03 8.5 0.28 6.4-2.34 8.26-4.11 6.31-6.06-1.15-1.15-1.78-1.2-3.13-0.22-2.31 1.69-2.08 2.78 0.32 1.5 1.08-0.58 1.96-0.69 1.96-0.25 0 1.11-6.76 4.64-7.5 3.91-0.33-0.34 1-2.45 2.91-4.69 1.92-2.24 3.85-5.69 4.31-7.66 0.76-3.18 1.22-3.57 4.25-3.81 6.71-0.53 7.45-1.71 2.94-4.72-1.62-1.08-2.97-2.5-2.97-3.19 0-0.68-0.5-2.23-1.12-3.43-0.63-1.21-1.46-2.91-1.85-3.72-0.73-1.52-3.14-1.63-10.31-0.57-9.77 1.45-9.77 1.43-10.31-2.59-0.27-2.02-1.25-4.57-2.19-5.66-2.03-2.35-6.85-2.64-8.97-0.53-1.63 1.64-3.62 1.96-3.62 0.6 0-0.49-1.11-1.15-2.5-1.5-1.89-0.48-3.71 0.15-7.07 2.37-2.48 1.64-4.74 2.76-5 2.5-0.25-0.25 0.96-2.34 2.66-4.66 12.92-17.61 15.25-21 22.63-32.59 2.5-3.93 4.03-4.31 2.03-0.5-2.08 3.97-8.17 12.92-10.5 15.44-1.23 1.33-2.25 2.79-2.25 3.25s-0.87 1.74-1.97 2.84c-1.93 1.93-1.84 4.56 0.12 3.35 0.85-0.53 4.41-5.61 7.28-10.47 0.56-0.93 2.86-4.38 5.16-7.66s4.19-6.34 4.19-6.78 0.98-1.63 2.15-2.66c2.47-2.15 2.33-1.92-4 8.44-2.47 4.06-4.86 7.54-5.28 7.72-0.41 0.18-0.75 0.79-0.75 1.34 0 0.56-1.11 2.3-2.47 3.91-1.35 1.61-2.46 3.31-2.46 3.81 0 2.05 1.66 0.66 4.4-3.75 1.6-2.57 3.17-4.88 3.5-5.15s2.19-3.13 4.13-6.38c9.06-15.21 8.87-14.91 8.22-11.97-0.34 1.54-1.74 4.49-3.07 6.6-1.33 2.1-2.4 4.11-2.4 4.47 0 0.35-2.15 3.57-4.78 7.15-4.69 6.38-7.04 10.17-7.04 11.44 0.01 2.51 14.47-19.13 17-25.44 1.6-3.96 2.61-5.95 3.16-6.09zm66.06 0.06 0.69 8.84c0.37 4.87 1.12 11.57 1.66 14.88 0.53 3.31 0.93 7.2 0.93 8.62 0 1.43-0.42 2.57-0.96 2.57s-1-1.52-1-3.38-0.45-3.69-1-4.03c-0.56-0.34-0.92-1.11-0.82-1.75 0.11-0.64-0.11-4.05-0.5-7.56-0.38-3.52-0.31-9.04 0.16-12.28l0.84-5.91zm-83.56 0.62c0.42-0.01 0.02 0.37-1.12 1.29-1.05 0.84-2.56 1.53-3.38 1.53-2.08 0-0.22-1.6 2.81-2.41 0.89-0.23 1.44-0.4 1.69-0.41zm315.75 0.85c0.65-0.01 1.45 0.46 1.78 1 0.76 1.22 0.42 1.22-1.47 0-0.88-0.57-1.01-0.99-0.31-1zm-12.06 1c0.84 0 1.56 0.43 1.56 0.97s-0.43 0.97-0.94 0.97-1.19-0.43-1.53-0.97c-0.33-0.54 0.07-0.97 0.91-0.97zm25.31 0.44c0.08-0.01 0.18 0.01 0.31 0.03 0.53 0.08 1.32 1.86 1.75 3.97 0.44 2.11 0.63 4.51 0.41 5.34-0.36 1.31-0.45 1.32-0.66 0.03-0.12-0.81-0.13-2.06-0.03-2.81 0.13-0.94-0.36-1.16-1.59-0.69-1.44 0.55-1.58 0.4-0.59-0.59 1.35-1.37 1.65-4.36 0.5-5-0.31-0.17-0.33-0.28-0.1-0.28zm-363 0.56c-1.34 0.03-1.32 0.25 0.28 1.47 2.49 1.88 4.1 1.86 2.53-0.03-0.67-0.82-1.93-1.46-2.81-1.44zm157.81 0c0.05 0 0.11 0.1 0.16 0.28 0.33 1.27 1.2 1.69 3.06 1.47 2.21-0.26 2.68 0.11 2.94 2.34 0.24 2.11-0.3 2.97-2.66 4.19-1.63 0.84-3.2 1.53-3.5 1.53-0.29 0-0.5-2.54-0.43-5.66 0.05-2.52 0.23-4.16 0.43-4.15zm164.94 0.31c0.87-0.03 4.86 3.46 11.35 10.13 8.87 9.12 11.77 11.44 18.06 14.47 4.11 1.97 8.43 3.59 9.59 3.59 1.2 0 2.09 0.61 2.09 1.44 0 0.88-0.6 1.25-1.5 0.9-2.07-0.79-1.93 2.94 0.19 5.07 0.92 0.91 2.92 2.12 4.44 2.65 1.72 0.6 2.75 1.65 2.75 2.81 0 1.03-0.2 1.88-0.47 1.88s-0.5-0.43-0.5-0.97-0.47-1-1.03-1c-1.08 0-2.54-1.05-6.44-4.63-1.3-1.19-2.37-1.73-2.37-1.18s-0.54 0.67-1.22 0.25-2.12-0.9-3.19-1.07c-4.52-0.7-16.98-11.34-22.19-18.93-2.84-4.15-3.87-5.46-6.12-7.94-0.95-1.04-1.43-1.91-1.09-1.91 0.33 0-0.15-1.16-1.07-2.56-1.32-2.02-1.74-2.98-1.28-3zm-82 0.03c0.19 0.03 0.39 0.22 0.56 0.5 0.38 0.61 0.14 1.1-0.5 1.1-0.86 0-0.85 0.37 0.07 1.47 0.77 0.93 0.84 1.46 0.18 1.46-1.65 0-2.36-1.8-1.37-3.56 0.31-0.55 0.61-0.85 0.87-0.94 0.07-0.02 0.13-0.04 0.19-0.03zm-116.31 0.03c0.05-0.01 0.1-0.01 0.16 0 0.06 0.02 0.11 0.06 0.18 0.1 0.54 0.33 1 1.25 1 2.03s-0.46 1.41-1 1.41c-0.54-0.01-0.97-0.92-0.97-2.04 0-0.85 0.26-1.42 0.63-1.5zm107.56 0.5v3.5 3.47h-5.66c-6.71-0.02-8.38-0.9-7.93-4.06 0.31-2.18 0.81-2.36 6.97-2.63l6.62-0.28zm14.75 0.57-0.47 5.9c-0.63 8.15-1.57 13.58-2.53 14.78-0.45 0.56-1.68 5.17-2.78 10.22-1.1 5.06-2.42 9.68-2.91 10.28-0.82 1.03-1.31 3.4-2.72 12.69-0.3 2.03-0.98 3.92-1.46 4.22-0.49 0.3-0.88 1.65-0.88 2.97s-0.49 2.41-1.06 2.41c-1.24 0-0.28-7.62 1.59-12.82 0.69-1.89 1.97-6.98 2.88-11.31 0.9-4.33 2.05-8.65 2.56-9.59s0.92-2.91 0.94-4.41c0.02-2.52 2-10.17 5.4-20.91l1.44-4.43zm-212.62 0.47c0.16 0.02 0.17 0.29-0.07 0.78-2.16 4.55-3.3 6.71-3.72 7.12-0.27 0.27-2.12 3.05-4.15 6.16-3.65 5.58-4.69 6.58-4.69 4.65 0-0.54 0.46-0.97 1-0.97s0.97-0.66 0.97-1.43c0-0.78 0.54-1.99 1.22-2.72 1.82-1.98 3.69-5.51 3.69-6.94 0-0.69 1.15-2.42 2.53-3.91 1.64-1.77 2.85-2.8 3.22-2.74zm-35.88 0.21c-0.2 0.08-0.28 0.6-0.25 1.38 0.05 1.14 0.25 1.38 0.56 0.59 0.29-0.71 0.27-1.55-0.06-1.87-0.08-0.08-0.18-0.12-0.25-0.1zm313.97 0.69c0.78 0.14 1.44 2.32 1.44 6.5 0 3.61-0.42 6.41-0.97 6.41-0.6 0-0.95 4.08-0.88 10.56 0.11 9.57 0.23 10.05 0.97 5.16 0.45-2.98 0.57-6.95 0.32-8.85-0.44-3.18-0.37-3.24 0.62-0.97 0.59 1.36 0.94 5.45 0.75 9.1s-0.02 6.62 0.41 6.62c1.27 0 0.85 8.53-0.47 9.6-0.68 0.54-2.58 1.27-4.22 1.62-3.85 0.82-15.12 10.87-13.75 12.25 1.15 1.17 6.4 0.32 6.4-1.03 0.01-0.51 0.47-0.63 1.04-0.28s1.85-0.3 2.84-1.44c1.1-1.26 2.4-1.81 3.38-1.44 1.16 0.45 1.59 0.06 1.59-1.5 0-1.31 0.45-1.88 1.12-1.47 0.61 0.38 1.47 0.06 1.94-0.68 0.69-1.09 0.86-1.04 0.88 0.28 0 0.9-0.48 1.82-1.1 2.03-0.84 0.28-0.81 2.06 0.16 6.94 1.22 6.13 1.17 6.67-0.59 8.62-1.54 1.7-2.69 2.04-6.1 1.66-4.48-0.51-5.96 0.32-3.78 2.12 2.08 1.73 9.58 1.65 13.12-0.12 3.02-1.51 3.19-1.49 3.19 0.19 0 1.01-0.93 2.03-2.19 2.37-2.3 0.62-10.34 0.7-12.06 0.13-0.54-0.18-2.2-0.58-3.68-0.91-2.32-0.51-2.72-1.07-2.72-3.97 0-2.38 0.58-3.73 1.96-4.47 1.28-0.68 1.97-0.7 1.97-0.06 0 0.54 0.72 0.73 1.57 0.41 0.84-0.33 2.57-0.04 3.87 0.65 1.92 1.03 2.67 1.03 3.91 0 2.45-2.03 0.05-3.76-6.19-4.43-11.61-1.26-12.95-1.59-12.94-3.29 0.02-2.27 4.7-20.95 5.44-21.68 0.33-0.33 0.32 1.03-0.06 3.06-0.52 2.77-0.38 3.73 0.62 3.81 11.93 1.01 14.63 0.53 14.63-2.62 0-2.89-2.55-3.17-8.88-0.94-2.3 0.81-4.33 1.5-4.53 1.5-0.75 0-0.35-4.13 0.56-5.84 0.52-0.98 2.11-6.16 3.5-11.5 1.4-5.35 2.95-10.84 3.44-12.19 0.49-1.36 1.08-4.09 1.31-6.07 0.49-4.09 1.38-5.98 2.16-5.84zm-211.75 0.1c0.51-0.01 0.65 1 0.28 2.21-2.66 8.76-3.65 13.54-3.81 18.35l-0.19 5.53 9.59 0.25c5.31 0.15 9.6 0.72 9.6 1.25 0 0.55-4.32 0.94-10.22 0.94-11.54 0-11.38 0.13-11.41-8.72-0.01-4.74 4.67-19.81 6.16-19.81zm249.03 0c0.24-0.01 0.73 0.45 1.06 1 0.34 0.54 0.14 0.96-0.43 0.96-0.58 0-1.07-0.42-1.07-0.96 0-0.55 0.2-1 0.44-1zm-44.06 0.9c0.21 0 0.36 0.17 0.53 0.47 0.6 1.08 0.13 2.84-1.59 5.75-1.38 2.31-3 5.42-3.6 6.91-1.29 3.24-3.28 3.67-2.31 0.5 0.37-1.22 2.02-5.04 3.66-8.47 1.74-3.65 2.67-5.15 3.31-5.16zm-277.81 1.06c0.42 0 0.75 0.35 0.75 0.75-0.01 1.06-4.84 6.82-4.88 5.82-0.05-1.29 3.26-6.57 4.13-6.57zm236.47 0c0.81 0 1.2 0.46 0.87 1s-1.28 0.97-2.09 0.97c-0.82 0-1.18-0.43-0.85-0.97 0.34-0.54 1.25-1 2.07-1zm88.9 0c0.54 0 1 0.46 1 1s-0.46 0.97-1 0.97-0.97-0.43-0.97-0.97 0.43-1 0.97-1zm-245.22 0.1c1.69 0.04 3.48 0.55 4.72 1.5 1.89 1.45 1.85 1.48-0.75 0.84-2.98-0.73-3.86 0.99-0.97 1.91 0.95 0.3 2.35 1.59 3.1 2.81l1.34 2.19-2.41-2.19c-3.8-3.5-4.01-1.4-0.25 2.56 1.87 1.97 3.37 4.6 3.38 5.85 0.01 3.1-1.58 1.9-2.31-1.75-0.33-1.64-1-2.97-1.5-2.97-0.51 0-0.18 2.16 0.71 4.81 0.9 2.65 1.94 4.63 2.35 4.38 0.4-0.26 0.75-0.02 0.75 0.56 0 0.57-1.27 1.06-2.81 1.06-1.55 0-4.75 0.21-7.13 0.47-5.32 0.57-6.78-0.04-6.78-2.78 0-4.18 3.06-16.59 4.41-17.94 0.9-0.9 2.46-1.35 4.15-1.31zm-84.9 1.28c0.35 0.01 0.59 0.36 0.59 0.97 0 0.81-0.43 1.76-0.97 2.09-0.54 0.34-1-0.03-1-0.84s0.46-1.76 1-2.1c0.14-0.08 0.26-0.12 0.38-0.12zm298.03 0c0.28-0.12 1.19 1.3 2.87 4.53 4.39 8.42 5.92 10.84 6.97 10.84 0.48 0 0.44-0.57-0.06-1.25-0.5-0.67-1.44-2.56-2.09-4.18l-1.19-2.94 2.56 2.94c8.12 9.44 11.84 13.28 12.87 13.28 0.65 0 1.32 0.34 1.5 0.75 0.54 1.19 7.45 6.15 8.6 6.15 0.58 0 1.06 0.41 1.06 0.91s1 1.21 2.22 1.59 2.42 0.98 2.69 1.32c0.9 1.11 7.05 4.06 8.47 4.06 2.05 0 1.67 2.3-0.6 3.72-2.2 1.37-2.64 5.33-0.75 6.84 0.68 0.54 2.34 1.28 3.69 1.66 8.11 2.23 10.79 4.77 3.69 3.47-2.82-0.52-5.18-0.35-7.28 0.53-2.68 1.12-3.42 1.08-5.41-0.28-2.16-1.49-2.2-1.48-0.94 0.09 1.72 2.13 0.77 2.11-2.62-0.03-2.63-1.66-2.63-1.65-1 0.25 1.58 1.85 1.51 1.94-1.16 1.94-1.53 0-3.67-0.85-4.81-1.88s-2.09-1.51-2.09-1.06c-0.01 0.45-1.12-0.23-2.47-1.5-3.89-3.65-3.73-1.8 0.28 3.22 3.78 4.74 7.02 5.85 10.93 3.75 0.96-0.51 4.13-1.25 7.07-1.63l5.34-0.69-2.91 2.35c-1.6 1.28-5.34 3.54-8.34 5.03-7.31 3.64-9.25 3.51-11.78-0.78-1.14-1.93-2.06-3.86-2.06-4.31 0-0.46-1.5-3.52-3.35-6.79-1.84-3.26-3.68-6.94-4.06-8.18-0.8-2.64-3.19-8.41-4.53-10.94-0.51-0.97-0.67-2.15-0.38-2.62 0.3-0.48-1-3.54-2.9-6.79-3.83-6.53-4.13-7.49-2.03-6.68 0.95 0.36 1.24 0.04 0.87-0.91-0.3-0.78-1.04-1.4-1.65-1.41-1.2-0.01-4.49-8.33-5.25-13.28-0.11-0.68-0.1-1.04 0.03-1.09zm-225.47 0.5c0.64-0.01 0.89 0.41 0.5 1.34-0.29 0.68-1.05 3.11-1.69 5.41-0.71 2.58-1.73 4.19-2.65 4.19-2.12 0-4.12 2.93-4.16 6.12-0.03 2.34-0.41 2.72-2.97 2.72-2.02 0-2.97-0.48-2.97-1.53 0-0.9-0.43-1.25-1.09-0.85-1.71 1.06-0.14-4.42 2.28-7.96 2.91-4.27 10.45-9.43 12.75-9.44zm144.87 0.09c0.24 0 0.7 0.46 1.03 1 0.34 0.54 0.17 0.97-0.4 0.97s-1.06-0.43-1.06-0.97 0.2-1 0.43-1zm18 0.28c0.61 0.03 0.54 0.23-0.21 0.57-3.45 1.54-8.98 2.43-7.88 1.28 0.54-0.57 2.97-1.29 5.41-1.6 0.75-0.09 1.36-0.18 1.84-0.22 0.36-0.02 0.64-0.04 0.84-0.03zm-111.4 0.57c-0.13 0.11-0.22 0.88-0.22 2.12 0 1.89 0.16 2.67 0.41 1.72 0.24-0.95 0.24-2.49 0-3.44-0.07-0.23-0.08-0.37-0.13-0.4-0.02-0.02-0.04-0.02-0.06 0zm-141.94 1.12c-0.51 0-1.48 0.69-2.16 1.5-0.67 0.81-0.9 1.47-0.53 1.47 0.38 0 1.35-0.66 2.16-1.47s1.04-1.5 0.53-1.5zm9.25 0c0.78 0 1.06 0.99 0.78 2.72-0.24 1.49-0.68 6.23-0.97 10.56-0.28 4.33-0.89 8.76-1.34 9.85-0.45 1.08-1.37 3.41-2.03 5.18-1.78 4.72-2.68 4.72-3.94 0-1.22-4.58-3.45-7.65-5.53-7.65-1.81 0-1.67-1.88 0.19-2.6 0.82-0.31 2.86-3.5 4.56-7.09 3.3-6.98 6.31-10.97 8.28-10.97zm223.31 0.31c1.23-0.17 4.31 0.99 4.31 1.79 0 1.23-3.65 1.07-4.43-0.19-0.36-0.58-0.5-1.23-0.28-1.44 0.08-0.08 0.23-0.13 0.4-0.16zm-243.15 0.69c-0.238 0-0.406 0.43-0.406 0.97s0.458 1 1.031 1 0.772-0.46 0.438-1c-0.335-0.54-0.824-0.97-1.063-0.97zm290.93 0c0.46 0 0.82 5.75 0.82 12.78 0 14.33-0.89 17.54-1.16 4.19-0.1-4.73-0.23-10.48-0.31-12.78-0.09-2.3 0.2-4.19 0.65-4.19zm3.03 0.97c0.41 0 0.75 4.55 0.76 10.09 0 5.55 0.28 11.76 0.62 13.78 0.38 2.33 0.22 3.69-0.44 3.69-0.57 0-1.29-2.34-1.59-5.19-0.73-6.88-0.27-22.37 0.65-22.37zm-74.74 0.03c0.12-0.03 0.28 0.04 0.46 0.19 0.68 0.56 1.22 2.47 1.22 4.25s0.69 6.7 1.5 10.94 1.47 10.29 1.47 13.43c0 3.15 0.46 6.59 1.03 7.66 1.1 2.06 0.89 9.98-0.22 8.28-0.35-0.54-0.97-2.79-1.37-4.94-0.59-3.11-0.86-3.49-1.41-1.93-0.38 1.07-0.48-2.38-0.22-7.66 0.42-8.46 0.29-9.59-1.15-9.59-1.3 0-1.43-0.37-0.63-1.88 0.56-1.05 0.61-2.04 0.13-2.22s-1.03-4.15-1.22-8.84c-0.22-5.47-0.15-7.54 0.41-7.69zm62.06 0.16c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.17 0.06 1.88-0.31 0.78-0.55 0.55-0.59-0.6-0.04-0.78 0.08-1.3 0.28-1.37zm3.4 0.22c0.05 0 0.05 0.03 0.1 0.06 0.59 0.37 1.06 3.8 1.06 7.9 0 10.18-1.52 10.05-1.84-0.15-0.17-5.42 0.06-7.9 0.68-7.81zm-56.37 0.59c0.35-0.01 0.77 0 1.22 0 3.62 0.01 3.69 0.08 3.84 3.97 0.09 2.47 1.01 5.14 2.5 7.12 1.31 1.75 2.71 3.93 3.06 4.88 0.56 1.51-0.06 1.72-5.03 1.72h-5.65l-1.19-5.19c-0.67-2.86-1.22-6.83-1.22-8.84 0-3.13 0.04-3.6 2.47-3.66zm143.34 0c0.41 0 0.75 0.66 0.75 1.47v2.22c0 0.4-0.34 0.83-0.75 0.97-0.4 0.13-0.72-0.87-0.72-2.22 0-1.36 0.32-2.44 0.72-2.44zm-347.75 0.41c0.09 0.03 0.13 0.22 0.13 0.56-0.02 0.81-0.41 2.58-0.85 3.94-0.63 1.97-0.75 2.08-0.78 0.5-0.01-1.09 0.32-2.86 0.78-3.94 0.26-0.6 0.49-0.95 0.63-1.03 0.03-0.02 0.07-0.05 0.09-0.03zm125.5 0.28c-0.09 0.12-0.14 1.13-0.18 2.9-0.07 2.26 0.16 4.84 0.5 5.72 1.14 2.99 1.38 0.84 0.5-4.5-0.5-2.96-0.7-4.28-0.82-4.12zm65 0.9c0.31-0.07 0.95 1.65 1.56 4.19 1.03 4.24 1.03 5.38 0.04 6-0.79 0.49-1 1.75-0.6 3.38 0.66 2.6 0.5 3.08-0.68 1.9-1.05-1.04-0.81-7.03 0.31-7.4 0.68-0.23 0.65-1.39-0.1-3.53-0.6-1.75-0.88-3.69-0.65-4.38 0.03-0.09 0.08-0.15 0.12-0.16zm73.82 0.16c0.39 0.06 0.51 1.82 0.53 5.88 0.01 3.92-0.11 7.12-0.32 7.12-1 0-1.63-10.93-0.71-12.5 0.19-0.33 0.36-0.52 0.5-0.5zm-259.47 0.53c0.21 0.04 0.34 0.23 0.34 0.53 0 0.54-0.43 1.26-0.97 1.6-0.54 0.33-1 0.19-1-0.35s0.46-1.29 1-1.62c0.14-0.09 0.26-0.1 0.38-0.13 0.08-0.01 0.17-0.04 0.25-0.03zm270.28 0.72c0.25-0.11 0.61 0.19 1.03 0.87 0.31 0.51 0.14 1.2-0.41 1.54s-1.03-0.1-1.03-0.94c0-0.87 0.15-1.36 0.41-1.47zm-17.75 0.13c0.06-0.03 0.17 0.01 0.25 0.09 0.32 0.33 0.34 1.16 0.06 1.87-0.31 0.79-0.55 0.56-0.59-0.59-0.04-0.78 0.08-1.3 0.28-1.37zm82.68 0.81c0.24 0 0.73 0.43 1.07 0.97 0.33 0.54 0.13 1-0.44 1s-1.03-0.46-1.03-1 0.17-0.97 0.4-0.97zm-67.96 0.75c0.16-0.21 0.39 1.84 0.78 6.12 0.46 5.14 0.7 9.81 0.53 10.35-0.52 1.59-1.61-9.45-1.47-14.79 0.03-1.02 0.08-1.59 0.16-1.68zm24.28 0.22c0.54 0 0.97 0.2 0.97 0.43 0 0.24-0.43 0.7-0.97 1.03-0.54 0.34-1 0.17-1-0.4s0.46-1.06 1-1.06zm-295.69 0.43c0.06 0.01 0.14 0.13 0.22 0.32 0.27 0.67 0.27 1.76 0 2.43-0.27 0.68-0.47 0.14-0.47-1.22 0-0.84 0.06-1.38 0.19-1.5 0.02-0.01 0.04-0.03 0.06-0.03zm241.84 0.66c0.16 0.03 0.29 0.56 0.47 1.63 0.46 2.59 2.96 2.88 4.66 0.56 1.43-1.96 3.47-0.94 3.47 1.72 0 1.94 0.74 2.22 4.65 1.9 1.85-0.15 2.22 0.34 2.22 2.82 0 3.36 0.94 4.31 2.97 3.06 2.31-1.43 4 0.72 2.75 3.47-1.38 3.03-0.48 5.16 2.34 5.59 1.43 0.22 2.15 0.9 1.91 1.81-1.32 5.04-1.27 5.85 0.5 6.5 2.74 1.01 3.37 2.55 1.59 3.85-1.36 0.99-1.4 1.57-0.31 4.22 0.7 1.68 1.68 2.85 2.16 2.56 0.48-0.3 0.84 0.38 0.84 1.53 0 1.14-0.36 1.83-0.84 1.53-0.49-0.3-1.17 0.15-1.5 1-0.97 2.53-0.69 5.11 0.62 5.66 0.87 0.36 0.65 0.99-0.71 2.09-1.07 0.86-1.99 2.77-2.1 4.25s-0.24 2.98-0.28 3.38c-0.04 0.39-1.46 0.45-3.12 0.12-2.58-0.51-2.97-0.33-2.69 1.22 0.34 1.97-2.93 3.3-4 1.62-0.34-0.52-1.63-1.24-2.85-1.62-1.64-0.52-2.18-0.31-2.18 0.84 0 2.47-2.91 1.78-3.94-0.94-0.77-2.03-1.41-2.35-3.44-1.84-2.16 0.54-2.47 0.28-2.47-1.9 0-2.79-1.57-4.18-4.19-3.76-1.84 0.31-2.37-1.31-0.74-2.31 1.57-0.97-1.69-6.42-3.44-5.75-1.16 0.45-1.47-0.31-1.47-3.53 0-3.15-0.6-4.65-2.59-6.5-2.02-1.86-2.34-2.71-1.47-3.75 0.82-0.99 0.81-2.16 0-4.5-0.61-1.75-0.83-4.92-0.47-7.12 0.39-2.48 0.23-4.53-0.47-5.38-0.91-1.09-0.72-1.34 0.91-1.34 2.58 0 5.04-3.46 4.34-6.13-0.46-1.75-0.21-1.96 1.81-1.47 2.64 0.65 5.03-0.74 6.31-3.72 0.41-0.94 0.59-1.4 0.75-1.37zm58.41 0.31c0.06 0 0.14 0.06 0.25 0.19 0.4 0.47 1.33 2.85 2.03 5.28 0.71 2.44 1.85 6.21 2.56 8.38 0.71 2.16 2.28 7.37 3.47 11.56 1.2 4.19 2.59 7.62 3.13 7.62 1.39 0 3.59 3.12 3.62 5.16 0.02 0.95 0.49 1.72 1.03 1.72 1.37 0 1.32-0.19-1.62-6.59-1.44-3.13-2.55-6.04-2.47-6.44 0.08-0.41-0.25-0.72-0.75-0.72s-1.21-1.46-1.56-3.22c-0.36-1.76-0.86-4.07-1.13-5.16-0.27-1.08 1.1 1.09 3.03 4.85 1.94 3.75 3.5 7.19 3.5 7.62s2.22 5.35 4.91 10.91 5 11.17 5.16 12.5c0.5 4.42-3.76 3.56-5.41-1.1-0.32-0.9-1.82-2.27-3.34-3-3.26-1.55-5.61-5.88-7.53-14.06-0.77-3.24-2.81-11.22-4.57-17.72-3.78-13.99-4.71-17.73-4.31-17.78zm-83.28 0.56c0.54 0.01 1 0.66 1 1.47 0 0.82-0.46 1.5-1 1.5s-0.97-0.68-0.97-1.5c0-0.81 0.43-1.47 0.97-1.47zm130.28 0c0.24 0.01 0.73 0.46 1.06 1 0.34 0.55 0.14 0.97-0.44 0.97-0.57 0-1.06-0.42-1.06-0.97 0-0.54 0.2-1 0.44-1zm-274.88 1.16c1.11-0.03 1.37 2.65 0.41 5.16-0.33 0.85-1.01 1.56-1.53 1.56-1.38 0-0.57-6.18 0.88-6.66 0.08-0.02 0.17-0.06 0.24-0.06zm-73.5 2.13c0.22-0.1 0.57 0.13 1.16 0.62 1.28 1.06 1.3 1.55 0 4.06-1.75 3.4-2.86 3.77-2.03 0.66 0.33-1.22 0.59-3.05 0.59-4.06 0.01-0.76 0.07-1.19 0.28-1.28zm137.16 1.56c0.07-0.01 0.14 0.02 0.22 0.15 1.21 1.93 1.57 26.5 0.41 27.35-0.46 0.33-1.61 2.17-2.57 4.06-0.95 1.89-3.02 5.52-4.62 8.09-1.6 2.58-3.33 6.12-3.81 7.88-0.79 2.84-0.96 3-1.66 1.25-0.44-1.08-1.07-2.21-1.37-2.5-0.31-0.29-2.41-2.49-4.66-4.91-4.06-4.36-4.1-4.47-5.22-15.22-0.62-5.95-1.37-11.92-1.69-13.28l-0.59-2.46 2.59 2.4c1.43 1.31 2.65 3.28 2.69 4.41 0.07 1.98 0.07 1.98 0.81 0.09 0.69-1.75 0.89-1.64 1.85 1 0.86 2.38 1.06 2.49 1.12 0.78 0.11-2.84 4.4-3.9 7.5-1.87 1.66 1.09 2.46 2.78 2.91 6.19 0.34 2.58 0.68 5.32 0.78 6.09s0.8 1.62 1.56 1.87c1.08 0.36 1.25-0.3 0.75-2.9-0.39-2.06-0.28-2.8 0.25-1.97 1.91 2.97 2.71-2.31 2.35-14.97-0.23-7.78-0.08-11.45 0.4-11.53zm146.5 0.34c0.2 0.02 0.3 0.16 0.28 0.41-0.04 0.44-0.44 1.7-0.9 2.78-0.82 1.9-0.84 1.89-0.91-0.19-0.04-1.18 0.37-2.44 0.91-2.78 0.13-0.08 0.29-0.15 0.4-0.19 0.09-0.02 0.15-0.03 0.22-0.03zm30.81 0.22c-0.46-0.03-0.58 0.35-0.31 1.06 0.3 0.79 0.99 1.41 1.47 1.41 1.41 0 0.99-1.72-0.56-2.31-0.24-0.09-0.44-0.15-0.6-0.16zm-333.31 0.5c0.54 0 0.71 0.43 0.38 0.97-0.34 0.54-1.06 1-1.6 1s-0.71-0.46-0.37-1c0.33-0.54 1.05-0.97 1.59-0.97zm295.47 0.22c0.02-0.02 0.01-0.01 0.03 0 0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.19 0 4.41-0.24 1.21-0.44 0.21-0.44-2.22 0-1.6 0.1-2.58 0.22-2.72zm-82.91 1.25 0.91 4.44c0.49 2.43 0.77 5.52 0.63 6.87l-0.26 2.47-0.74-2.47c-0.4-1.35-0.68-4.44-0.63-6.87l0.09-4.44zm51 0.41c-2.63 0-5.17 1.16-7.5 3.56-3.11 3.21-3.37 3.91-3.37 9.78 0 3.48 0.42 7.32 0.91 8.56 5.13 13.25 10.04 20.99 15.65 24.63 3.61 2.34 10.33 1.72 13.5-1.25 2.16-2.03 2.41-3.07 2.41-10.28 0-6.16-0.56-9.39-2.41-14.1-5.26-13.41-12.47-20.91-19.19-20.9zm41.07 0.15c0.13 0.03 0.18 0.38 0.18 1.1 0.01 0.91-0.42 1.94-0.97 2.28-1.24 0.77-1.24-0.54 0-2.47 0.42-0.64 0.65-0.93 0.79-0.91zm-275.94 0.25c-0.46 0.03-1.09 0.38-1.72 1.22-0.79 1.04-1.45 2.3-1.47 2.75-0.05 1.28 2.18 0.2 3.31-1.59 0.93-1.48 0.64-2.42-0.12-2.38zm48.75 1.13c0.79-0.04 1.75-0.01 2.87 0.12 5.04 0.6 6.13 1.05 6.13 2.44 0 1.24-10.54 1.19-11.31-0.06-0.93-1.51-0.07-2.38 2.31-2.5zm185.78 0.5c1.39-0.02 2.37 1.1 2.78 3.31 0.34 1.81 0.49 4.58 0.31 6.16l-0.34 2.84-3.66-4.91c-3.3-4.45-3.5-5.04-2.03-6.15 1.11-0.84 2.1-1.24 2.94-1.25zm37.53 1.28c0.08 0.01 0.09 0.18 0.09 0.47 0.03 0.67-1.28 5.94-2.9 11.72-1.62 5.77-3.22 10.74-3.56 11.06s-0.37-0.29-0.07-1.38c0.3-1.08 1.34-5.28 2.29-9.34 1.49-6.43 3.6-12.64 4.15-12.53zm-146.87 0.09c0.05-0.04 0.12 0.24 0.18 0.88 0.22 2.03 0.22 5.34 0 7.37-0.21 2.03-0.37 0.37-0.37-3.68 0-2.79 0.07-4.46 0.19-4.57zm-64.35 0.13-0.65 2.47c-0.37 1.35-1.74 5.15-3.04 8.43-1.29 3.29-2.34 6.54-2.34 7.22s-0.89 1.98-1.97 2.88-2.86 3.4-3.97 5.56c-2.74 5.37-1.29 0.42 2-6.88 1.47-3.24 3.43-7.9 4.35-10.34 0.92-2.43 2.56-5.52 3.65-6.87l1.97-2.47zm36.07 0.5c0.54 0 1.49 1.43 2.12 3.18 1.5 4.21 3.98 18.02 4 22.38 0.02 3.39 1.9 10.15 3.22 11.47 0.37 0.37 0.69 4.59 0.69 9.41 0 10.08 1.47 10.85 2.5 1.28 0.37-3.51 1.08-6.41 1.56-6.41s0.84 2.89 0.84 6.41c0 3.51 0.43 6.37 0.91 6.37 1.06 0 2.06-2.41 2.06-4.94 0-1.01 1.13-3.02 2.47-4.47 1.34-1.44 2.69-4.13 3.03-5.96 0.35-1.84 1.1-3.63 1.66-3.97 1.2-0.75 0.28 6.28-1.47 11.19-1.33 3.7-0.7 4.8 1.97 3.37 1.4-0.75 2.07-2.54 2.56-6.69 0.85-7.19 1.59-10.15 2.56-10.15 0.42 0 0.53 3.66 0.25 8.18-0.32 5.1-0.12 8.49 0.5 8.88 0.66 0.41 1.14-4.26 1.38-13.59 0.23-8.99 0.78-14.66 1.5-15.38 1.15-1.15 1.39-0.06 2.62 11.59 0.34 3.23 0.14 3.98-0.93 3.57-1.03-0.4-1.25 0.2-0.91 2.31 0.25 1.54 0.69 5.21 1 8.19s1.03 6.1 1.59 6.9c1.03 1.48 0.91-1.53-0.53-11.31-0.43-2.91-0.32-3.43 0.38-1.97 0.52 1.08 1.21 4.12 1.56 6.75 0.42 3.22 0.96 4.45 1.62 3.78 0.67-0.66 0.49-2.84-0.5-6.72-1.29-5.09-2.28-13.1-3.03-24-0.13-1.89-0.37-3.86-0.53-4.4-0.15-0.54-0.18-2.32-0.06-3.94 0.2-2.74 0.25-2.68 1 0.97 0.44 2.16 1.12 6.48 1.47 9.59 0.34 3.11 1.1 5.66 1.65 5.66 0.64 0 0.77-1.89 0.38-5.16-0.4-3.27-0.32-4.62 0.25-3.69 0.49 0.82 1.22 4.99 1.59 9.29 0.38 4.29 0.98 8.27 1.35 8.84 0.36 0.57 0.74 2.15 0.81 3.5 0.37 6.91 1.73 14.78 2.59 14.78 0.61 0 0.76-3.06 0.41-8.12-0.32-4.59-0.22-6.8 0.22-5.1 0.89 3.51 4.11 9.28 5.19 9.28 0.4 0 0.49 0.66 0.18 1.47-0.68 1.77 0.76 1.96 2.41 0.32 1.8-1.81 1.39-3.76-0.78-3.76-1.16 0-2.55-1.18-3.44-2.9-1.66-3.22-3.41-13.91-3.41-20.72 0-4.34 0.05-4.25 2.82 3.94 1.55 4.6 3.33 10.27 3.96 12.62 1.55 5.77 2.35 4.5 2.22-3.53l-0.12-6.62 1.9 3.93c1.05 2.17 2.19 5.37 2.54 7.13 0.4 2.05 1.98 4.35 4.43 6.37 2.11 1.74 3.82 3.52 3.82 3.94 0 0.43-1.79 0.75-3.97 0.75-2.19 0-5.15 0.77-6.6 1.72-3.88 2.54-19.99 2.43-24.81-0.16-4.01-2.15-15.38-2.35-19-0.37-2.02 1.11-14.47 1.94-14.47 0.97 0-0.24 1.32-1.94 2.94-3.78 2.05-2.34 2.94-4.34 2.88-6.53l-0.1-3.16-0.9 2.97c-1.15 3.76-7.38 10.77-8.29 9.31-0.85-1.37 0.32-7.61 1.57-8.38 0.52-0.32 0.9 0.59 0.9 2 0 1.42 0.41 2.36 0.88 2.07 0.46-0.29 0.71-4.87 0.53-10.16-0.28-7.95-0.2-8.96 0.62-5.72 0.55 2.16 1.5 4.39 2.1 4.94 0.78 0.72 0.91 0.3 0.47-1.47-0.34-1.35-0.62-3.9-0.63-5.72-0.01-2.63-0.35-3.2-1.62-2.72-1.42 0.55-1.49-0.29-0.94-7.53 0.58-7.71-0.24-16.89-1.85-20.65-0.41-0.99-0.31-1.72 0.26-1.72zm106.43 0.53c5.2-0.03 5.41 0.04 5.13 2.41-0.89 7.3-1.49 10.42-2.16 11.31-0.41 0.54-1.77 5.51-3.03 11.06-1.86 8.22-2.61 10.09-4.06 10.09-1.4 0-1.78-0.78-1.78-3.68-0.01-2.03-0.64-7.67-1.44-12.54-0.8-4.86-1.46-10.74-1.47-13.06-0.02-4.96 0.89-5.55 8.81-5.59zm70.38 1.84c0.03-0.02 0.07 0 0.09 0 0.16 0.05 0.08 0.69-0.22 2.03-0.81 3.62-1.39 4.43-1.37 1.91 0.01-1.04 0.48-2.56 1.03-3.37 0.2-0.31 0.36-0.5 0.47-0.57zm-34.44 0.41c0.05 0.03 0.09 0.17 0.16 0.4 0.24 0.95 0.24 2.5 0 3.44-0.25 0.95-0.44 0.18-0.44-1.72 0-1.42 0.12-2.21 0.28-2.12zm2.91 0.37c0.01-0.02 0.01-0.01 0.03 0 0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.23 0 4.44-0.24 1.22-0.44 0.22-0.44-2.22 0-1.59 0.1-2.6 0.22-2.75zm-150.5 0.63-3.19 3.03c-3.28 3.09-3.34 4.34-0.06 1.37 0.99-0.89 2.13-1.3 2.53-0.9 0.86 0.87-4.91 5.85-9.22 7.94-2.96 1.43-6.24 4.43-4.84 4.43 1.47 0 10.03-5.36 13.06-8.18 1.76-1.65 3.18-2.69 3.18-2.32 0 0.94-2.73 3.54-7.37 7.03-2.13 1.61-4.66 3.73-5.63 4.69-2.2 2.21-2.95 2.2-4.34-0.03-1.51-2.41-3.61-12.78-2.94-14.53 0.3-0.77 1.58-1.37 2.82-1.34 1.23 0.02 5.33-0.23 9.12-0.57l6.88-0.62zm-133.72 0.16c0.843 0 1.271 0.42 0.937 0.96s-1.053 1-1.563 1c-0.509 0-0.906-0.46-0.906-1s0.688-0.96 1.532-0.96zm95.282 0c0.87 0 1.57 0.54 1.56 1.21-0.02 1.6-1.92 4.57-1.94 3.03 0-0.63-0.29-1.83-0.62-2.68-0.39-1.02-0.04-1.56 1-1.56zm291.03 0.21c0.12 0.05 0.36 0.74 0.78 2.16 0.9 2.99 0.77 4.02-0.37 2.87-0.36-0.36-0.64-1.78-0.6-3.18 0.04-1.25 0.07-1.89 0.19-1.85zm-372.22 0.91c-0.63-0.05-0.69 0.68-0.25 2.47 0.38 1.54 1.04 2.94 1.5 3.12s0.84 1.09 0.84 2.03c0 0.95 1.36 3.82 3.04 6.35 2.12 3.2 3.67 4.52 5.15 4.47 1.43-0.05 1.66-0.22 0.69-0.6-3.25-1.28-7.47-8.25-8.81-14.5-0.34-1.58-1.19-3.05-1.88-3.28-0.11-0.04-0.19-0.05-0.28-0.06zm243.94 0.09c1.09 0.14 1.29 4.69 1.25 24.6-0.02 11.45-0.25 11.78-5.31 9.03-2.48-1.35-2.69-1.95-2.69-7.28 0-3.2 0.37-6.06 0.84-6.35 0.73-0.44 1.67-4.03 2.69-10.4 0.83-5.2 2.08-9.27 2.97-9.57 0.08-0.02 0.18-0.04 0.25-0.03zm12.31 0.1c0.11-0.07 0.23-0.02 0.41 0.15 0.56 0.54 1.19 3.75 1.37 7.13s-0.03 6.16-0.44 6.15c-0.4 0-0.74-1.06-0.74-2.34-0.01-1.28-0.26-4.48-0.6-7.12-0.32-2.5-0.31-3.77 0-3.97zm-178.69 0.15c0.28 0.04 0.65 0.65 1.16 1.88 0.65 1.58 0.99 3.58 0.78 4.44-0.26 1.06-0.75 0.65-1.56-1.32-0.65-1.58-0.99-3.55-0.78-4.4 0.09-0.4 0.24-0.62 0.4-0.6zm11.5 0.1c0.49-0.16 0.49 2.32-0.37 6.47-0.6 2.88-1.74 8.99-2.5 13.59-0.77 4.6-1.84 9.92-2.38 11.81-0.81 2.89-0.93 2.33-0.59-3.43 0.62-10.57 1.65-18.6 2.5-19.69 0.42-0.54 1.3-2.97 1.97-5.41 0.6-2.21 1.08-3.25 1.37-3.34zm184.53 0.4c0.55 0 0.97 1.09 0.97 2.44s-0.42 2.47-0.97 2.47c-0.54 0-1-1.12-1-2.47s0.46-2.44 1-2.44zm-177.62 0.25c0.1-0.01 0.22 0.04 0.38 0.13 0.55 0.34 1.31 2.48 1.68 4.78 0.38 2.3 1.24 5.5 1.94 7.12 0.7 1.63 1.53 3.75 1.84 4.69 0.35 1.06 0.05 1.72-0.75 1.72-0.81 0-1.92-2.83-3-7.62-0.94-4.2-1.94-8.46-2.21-9.47-0.23-0.83-0.18-1.31 0.12-1.35zm-61.66 0.03c0.68-0.03 1.33 0.42 2.57 1.32 1.88 1.37 2.54 2.73 2.56 5.37 0.04 4.43 2.44 6.85 6.15 6.13 1.49-0.29 2.72-0.91 2.72-1.38s1.01-0.85 2.22-0.81c1.22 0.04 3.85-0.25 5.82-0.63 3.48-0.67 3.57-0.57 4.74 3.13 0.67 2.09 1.73 4.24 2.35 4.78s1.72 1.77 2.47 2.72c1.24 1.58 1 1.72-3.03 1.72-2.41 0-4.68-0.3-5.03-0.66-0.36-0.35-6.24-0.57-13.07-0.47-8.34 0.13-12.9-0.19-13.84-0.96-0.77-0.64-3.54-1.52-6.19-1.94-2.64-0.42-5.78-1.64-6.97-2.69s-3.01-2.62-4.03-3.5c-2.82-2.45-2.22-3.75 3.63-7.81 4.87-3.39 5.55-3.6 6.93-2.22 2.07 2.06 3.9 1.95 7.25-0.53 1.39-1.03 2.07-1.53 2.75-1.57zm220.19 0.35c0.25-0.08 0.28 0.97 0.31 3.53 0.04 2.57-0.11 4.69-0.37 4.69-1.1 0-1.52-4.66-0.63-6.91 0.32-0.8 0.54-1.26 0.69-1.31zm79.09 0.34c-0.05 0.05 0.24 0.47 0.85 1.25 1.28 1.64 2.09 2.16 2.09 1.35 0-0.21-0.77-0.98-1.72-1.72-0.78-0.61-1.16-0.93-1.22-0.88zm-240.03 0.07c0.55-0.07 0.97 0.71 0.97 2.34 0 1.33 0.54 3.54 1.16 4.9 0.87 1.92 0.84 2.81-0.13 3.97-0.68 0.83-1.76 1.45-2.37 1.41-0.7-0.05-0.65-0.22 0.12-0.53 1.93-0.78 1.48-1.92-1.31-3.19-1.82-0.83-2.27-1.49-1.59-2.34 0.52-0.67 1.2-2.42 1.56-3.91 0.4-1.68 1.05-2.59 1.59-2.65zm229.5 2.21c0.03 0.02 0.05 0.09 0.1 0.19 0.23 0.54 1.41 5.4 2.59 10.81 1.19 5.41 2.39 10.5 2.69 11.32 0.3 0.81 0.71 2.58 0.94 3.93 0.47 2.89 2.72 5.62 5.31 6.44 1.13 0.36 1.84 1.5 1.84 2.97 0 2.2-0.36 2.41-4.72 2.41-7.28 0-8.59-1.5-8.34-9.47 0.12-3.66-0.18-7.12-0.66-7.69-0.47-0.57-0.89-2.15-0.93-3.5-0.05-1.35-0.28-4.67-0.53-7.38-0.46-4.84-0.44-4.88 0.59-1.24 0.57 2.02 1.48 3.68 2.03 3.68s0.68-0.77 0.31-1.72c-0.67-1.74-1.67-10.95-1.22-10.75zm-31.34 0.13c0.06 0.01 0.14 0.12 0.22 0.31 0.27 0.68 0.27 1.76 0 2.44s-0.5 0.13-0.5-1.22c0-0.85 0.09-1.38 0.22-1.5 0.02-0.02 0.04-0.03 0.06-0.03zm-80.22 0.62c0.49-0.05 1.09 0.44 1.5 1.5 0.33 0.86 0.56 1.65 0.56 1.78 0 0.14-0.65 0.26-1.47 0.26-0.81-0.01-1.46-0.79-1.46-1.79 0-1.1 0.38-1.7 0.87-1.75zm64.41 0.13c0.06-0.03 0.17-0.02 0.25 0.06 0.32 0.33 0.34 1.17 0.06 1.88-0.31 0.78-0.55 0.58-0.59-0.57-0.04-0.77 0.08-1.3 0.28-1.37zm-15.35 0.22c0.07-0.01 0.15 0.01 0.22 0.06 0.54 0.33 1 2.37 1 4.5s-0.46 3.87-1 3.87-0.97-2.03-0.97-4.5c0-2.39 0.28-3.86 0.75-3.93zm-271.59 0.25c0.154-0.01 0.144 1.16 0.031 3.75-0.17 3.88-0.63 5.11-2.219 5.81-2.286 1.01-4.826 7.47-2.937 7.47 0.623 0 1.65-0.49 2.281-1.13 1.428-1.42 2.516 0.87 2.032 4.28-0.232 1.64-0.989 2.27-2.626 2.29-2.523 0.02-5.997 3.89-6.031 6.68-0.056 4.56-4.873 8.68-7.531 6.47-1.102-0.91-1.7-0.92-2.562-0.06-1.371 1.37-2.75 1.48-2.75 0.22-0.001-1.4 2.955-4 4.531-4 1.006 0 1.375-1.2 1.375-4.31 0-4.39 2.911-12.6 4.875-13.82 0.586-0.36 1.045-2.31 1.062-4.31 0.023-2.7 0.678-4.07 2.469-5.37 2.202-1.61 2.335-1.62 1.75-0.1-0.433 1.13-0.247 1.45 0.531 0.97 0.633-0.39 1.125-1.34 1.125-2.12s0.454-1.41 1.032-1.41c0.602 0 0.795 0.84 0.437 1.97-0.351 1.1-0.168 1.94 0.406 1.94 0.562 0 1.466-1.43 2-3.19 0.398-1.31 0.6-2.03 0.719-2.03zm-16.281 0.37c-0.502 0-1.4 0.45-2.625 1.38-1.871 1.41-1.878 1.47 0.187 1.5 1.16 0.01 2.376-0.66 2.688-1.47 0.359-0.94 0.252-1.4-0.25-1.41zm296 1.1c2.67 0.18 5.87 3.95 5.87 8.56 0 3.78-0.2 4.08-2.71 4.06-1.49-0.01-3.23-0.41-3.91-0.84-1.94-1.23-3.23-6.83-2.19-9.57 0.63-1.64 1.73-2.3 2.94-2.21zm-89.16 0.12c-0.05 0.01-0.08 0.03-0.12 0.06-0.31 0.31 0.03 1.24 0.72 2.07 1.76 2.13 2.25 1.87 0.96-0.54-0.52-0.98-1.2-1.65-1.56-1.59zm-13.72 1.13c0.07 0 0.15 0.12 0.22 0.31 0.28 0.68 0.28 1.76 0 2.44-0.27 0.67-0.5 0.13-0.5-1.22 0-0.85 0.09-1.39 0.22-1.5 0.02-0.02 0.04-0.04 0.06-0.03zm112.32 0.68c1.84 0.13 2.92 3.83 1.22 4.91-2.09 1.32-2.82 1.01-2.82-1.13 0-1.08-0.06-2.28-0.15-2.68-0.1-0.41 0.51-0.9 1.37-1.06 0.13-0.03 0.25-0.04 0.38-0.04zm-284.97 0.54c0.634-0.17 1.062 0.58 1.062 2.28 0 1.02 1.288 4.06 2.87 6.75 2.25 3.81 2.73 5.52 2.16 7.68-0.58 2.18-1.39 2.86-3.78 3.1-2.681 0.26-3.142-0.1-4.031-2.97-2.239-7.23-2.361-9.81-0.625-13.66 0.869-1.93 1.709-3.02 2.344-3.18zm275.93 0.5c-0.25-0.02-0.53 0.03-0.78 0.12-2.09 0.8-2.06 2.68 0.1 5.38 1.99 2.49 3.56 2.33 3.97-0.38 0.35-2.36-1.49-5.01-3.29-5.12zm105.63 0c0.1-0.01 0.16 0.1 0.16 0.31 0 0.54-0.45 1.62-0.97 2.43-0.53 0.82-0.94 1.05-0.94 0.5 0-0.54 0.41-1.65 0.94-2.46 0.33-0.51 0.64-0.78 0.81-0.78zm-233.81 2.28c-0.07-0.02-0.13-0.01-0.19 0.03-1.21 0.75-0.16 16.21 1.22 17.87 1.81 2.18 3.05 1.43 2.34-1.44-0.77-3.11-1.39-6.86-2.12-12.81-0.25-2.02-0.78-3.52-1.25-3.65zm231.62 2.72c0.28 0.02 0.41 0.5 0.41 1.5 0 2.37-0.48 2.74-1.5 1.09-0.36-0.59-0.2-1.56 0.41-2.16 0.3-0.3 0.51-0.45 0.68-0.43zm-114.15 0.71h1.47c4.98 0 6.28 2.33 2.81 5-3.16 2.43-3.53 2.39-5.28-1-1.79-3.46-1.99-3.94 1-4zm-140.66 0.97c0.38 0 0.11 0.69-0.56 1.5-0.68 0.81-1.61 1.47-2.13 1.47-0.51 0-0.28-0.66 0.53-1.47 0.82-0.81 1.78-1.5 2.16-1.5zm-26.63 0.1c0.56-0.12 1.63 0.36 3.44 1.4 1.36 0.78 1.81 1.36 1 1.32-2.76-0.15-4.9-0.97-4.9-1.88 0-0.47 0.13-0.78 0.46-0.84zm189.44 0.09c0.88 0.07 1.32 1.85 1.69 5.69 0.51 5.35-0.07 5.89-3.47 3.06-2.71-2.26-2.77-4.06-0.31-7.09 0.9-1.11 1.57-1.7 2.09-1.66zm-169.78 0.94c0.5 0 0.43 0.26-0.47 0.84-0.81 0.53-2.12 0.94-2.93 0.91-0.98-0.04-0.83-0.35 0.46-0.91 1.36-0.58 2.44-0.84 2.94-0.84zm-29.72 0.84c0.41 0 0.72 2.23 0.72 4.94 0 4.31-0.39 5.33-3.19 7.87-1.75 1.6-3.91 2.89-4.78 2.91-1.23 0.02-0.68-1.7 2.47-7.84 2.22-4.33 4.38-7.87 4.78-7.88zm20.91 2.47c3.95 0 6.65 0.35 6.03 0.75s-3.33 0.69-6.03 0.69c-2.71 0-5.44-0.29-6.06-0.69-0.63-0.4 2.1-0.75 6.06-0.75zm217.25 0.69c0.07-0.03 0.17 0.01 0.25 0.09 0.33 0.33 0.35 1.17 0.06 1.88-0.31 0.78-0.55 0.55-0.59-0.6-0.03-0.78 0.08-1.3 0.28-1.37zm-230.53 0.78c0.54 0 0.97 0.2 0.97 0.44 0 0.23-0.43 0.69-0.97 1.03-0.54 0.33-1 0.16-1-0.41s0.46-1.06 1-1.06zm184.69 1c1.34 0.01 7 5.84 7.65 7.91 0.36 1.11 0.13 2.61-0.47 3.34-0.6 0.72-2.16 1.53-3.47 1.78-2.15 0.41-2.47-0.01-3.4-4.38-1.22-5.67-1.34-8.66-0.31-8.65zm-159.5 0.47 0.18 9.12c0.17 8.21-0.08 10.49-0.97 8.35-0.16-0.41-0.05-4.5 0.25-9.1l0.54-8.37zm-12.29 0.5c1.88 0 2.74 0.41 2.32 1.09-0.37 0.59-1.55 0.81-2.6 0.53-1.19-0.31-1.77-0.03-1.53 0.69 0.47 1.42 2.56 1.57 5 0.37 1.37-0.67 1.73-0.55 1.41 0.44-0.63 1.91-6.11 2.2-7.6 0.41-1.72-2.08-0.47-3.53 3-3.53zm161.19 0c1.53 0 1.97 0.67 1.97 2.97 0 3.49-0.07 3.52-2.25 0.97-2.23-2.61-2.13-3.94 0.28-3.94zm3.34 0.18c0.07-0.02 0.14 0.02 0.22 0.1 0.33 0.33 0.35 1.16 0.07 1.87-0.32 0.79-0.52 0.56-0.57-0.59-0.03-0.78 0.08-1.3 0.28-1.38zm-155.62 0.32c0.59-0.22 0.81 1.32 0.81 5.22 0 3.35-0.18 6.09-0.4 6.09-1.06 0-1.69-10.1-0.69-11.09 0.1-0.1 0.2-0.19 0.28-0.22zm60.03 0.59c0.13 0.02 0.37 0.18 0.72 0.5 0.67 0.62 1.01 2.57 0.78 4.44-0.33 2.7-0.43 2.85-0.56 0.72-0.09-1.45-0.43-3.45-0.78-4.44-0.31-0.86-0.38-1.26-0.16-1.22zm-53.81 0.25c0.24-0.11 0.35 1.4 0.4 4.81 0.06 3.66-0.06 6.63-0.28 6.63-0.82 0-1.2-7.47-0.53-10.28 0.17-0.7 0.3-1.11 0.41-1.16zm4.84 0.63c0.24 0 0.73 0.46 1.06 1 0.34 0.54 0.14 0.97-0.43 0.97-0.58 0-1.07-0.43-1.07-0.97s0.2-1 0.44-1zm-57.4 1c-1.12 0-2.04 0.42-2.04 0.97 0 0.54 0.63 1 1.41 1s1.7-0.46 2.03-1c0.34-0.55-0.29-0.97-1.4-0.97zm206.03 0.53c0.06 0 0.11 0.22 0.19 0.68 0.22 1.5 0.23 3.7 0 4.91-0.24 1.21-0.45 0.02-0.44-2.69 0-1.86 0.12-2.91 0.25-2.9zm105.84 0.31c2.28-0.05 5.32 0.86 7.35 2.59 1.57 1.36 3.75 2.44 4.81 2.44 1.46 0 1.62 0.29 0.75 1.16s-0.75 1.47 0.53 2.4c0.93 0.68 1.37 1.57 0.97 1.97-0.41 0.41-0.75 0.2-0.75-0.43 0-0.79-1.69-1.05-5.38-0.79-4.97 0.36-5.65 0.17-8.37-2.62-1.63-1.67-2.97-3.83-2.97-4.81 0-1.25 1.29-1.87 3.06-1.91zm-370.47 1.13c0.81 0 1.47 0.13 1.47 0.34 0 0.2-0.66 0.95-1.47 1.62-1.21 1.01-1.5 0.94-1.5-0.37 0-0.88 0.69-1.59 1.5-1.59zm181.25 0c0.03-0.02 0.09 0 0.13 0 0.85 0 2.18 2.45 4.5 8.24 1.78 4.48 1.54 5.29-0.85 2.66-1.84-2.04-4.69-10.39-3.78-10.9zm29.16 0c0.21 0 0.66 0.65 0.97 1.46 0.31 0.82 0.12 1.47-0.41 1.47-0.52 0-0.97-0.65-0.97-1.47 0-0.81 0.2-1.46 0.41-1.46zm-121.85 0.96c0.06-0.04 0.12 0.2 0.19 0.75 0.22 1.76 0.22 4.62 0 6.38s-0.37 0.33-0.37-3.19c0-2.42 0.06-3.85 0.18-3.94zm24.6 0c0.05-0.04 0.12 0.2 0.19 0.75 0.21 1.76 0.21 4.62 0 6.38-0.22 1.76-0.38 0.33-0.38-3.19 0-2.42 0.07-3.85 0.19-3.94zm-103.41 0.07c-0.28 0.02-0.4 0.29-0.4 0.78 0 0.46 1 1.32 2.21 1.9 3.2 1.54 3.34 1.42 0.97-0.78-1.42-1.33-2.31-1.94-2.78-1.9zm353.81 1.12c0.53 0.03 1.17 0.39 2.19 1.06 1.32 0.86 2.62 2.48 2.91 3.6 0.48 1.85 0.08 2.03-4.38 2.03-4.61 0-4.81-0.13-4.18-2.22 0.36-1.22 1.24-2.83 1.96-3.59 0.57-0.6 0.98-0.9 1.5-0.88zm-269.15 0.09c0.59-0.14 1.55 1.44 1.65 3.47 0.12 2.32 0.16 2.35 0.54 0.41 0.66-3.46 2.25-2.57 2.25 1.25 0 1.89 0.48 3.44 1.06 3.44 0.61 0 0.79-0.93 0.44-2.22l-0.6-2.22 2.03 2.34c1.11 1.28 2 3.53 2 5.03 0 2.45-0.39 2.82-3.68 3.13-4.99 0.47-11.1-0.13-11.1-1.06 0-0.42 1.12-2.93 2.47-5.6 1.35-2.66 2.47-5.61 2.47-6.59 0-0.87 0.2-1.31 0.47-1.38zm-7.81 0.29c0.05-0.04 0.11 0.19 0.18 0.65 0.23 1.49 0.23 3.92 0 5.41-0.22 1.49-0.4 0.26-0.4-2.72 0-2.05 0.09-3.27 0.22-3.34zm-100 0.06c2.187-0.05 5.444 0.57 10.254 1.84 5.5 1.45 11.57 3.47 13.47 4.47 1.89 1 4.32 2.15 5.4 2.56 1.44 0.56 0.69 0.85-2.87 1.1-2.68 0.18-5.88-0.21-7.13-0.88-1.24-0.66-2.52-0.94-2.84-0.62-1.42 1.42 4.54 2.94 13.47 3.44 9.47 0.52 11.97 1.39 7.5 2.59-1.22 0.32-2.65 0.51-3.19 0.47-3.7-0.32-19.96-3-21.16-3.5-0.81-0.34-2.58-0.78-3.94-1-1.35-0.22-2.86-0.84-3.37-1.35-0.51-0.5-1.739-0.9-2.688-0.9-3.441 0-6.718-2.24-6.718-4.57 0-2.42 1.001-3.59 3.812-3.65zm202.65 0.34c0.49 0 1.21 2.32 1.6 5.16 0.75 5.6 1.97 8.62 3.47 8.62 1.41 0 1.08-3.17-0.57-5.34-3.13-4.14-0.78-4.76 4.07-1.06 3.35 2.56 4.94 3.01 5.5 1.62 0.4-1.01 13.59 0.96 13.59 2.03 0 0.43-1.48 0.78-3.25 0.78-3.35 0-5.96 1.46-10 5.5-3.39 3.39-6.77 3.05-9.81-0.93-3.71-4.86-6.95-16.38-4.6-16.38zm30 0.03c4.33-0.05 13.56 2.36 18.03 5.25 3.57 2.31 4.28 4.05 1.28 3.1-1.5-0.48-2.04-0.05-2.53 1.9-0.66 2.67-0.59 2.67-10.03 1.82-4.02-0.37-5.6-2.23-3.18-3.72 1.53-0.95 1.14-4.44-0.5-4.44-0.82 0-1.47-0.46-1.47-1s-0.89-0.97-1.97-0.97-1.97-0.46-1.97-1c0-0.65 0.9-0.92 2.34-0.94zm-240.22 1.41c1.838-0.22 2.882 1.54 2.594 4.56-0.282 2.95-0.699 3.39-3.438 3.66-3.744 0.36-5.021-1.29-2.875-3.66 0.865-0.95 1.563-2.2 1.563-2.78-0.001-0.57 0.587-1.28 1.312-1.56 0.294-0.11 0.581-0.19 0.844-0.22zm377.57 0.53c0.54 0 0.96 0.4 0.96 0.91s-0.42 1.23-0.96 1.56-1-0.09-1-0.94c0-0.84 0.46-1.53 1-1.53zm-393.32 0.06c0.493-0.09 0.812 0.32 0.812 1.28 0 0.75-0.856 1.61-1.906 1.88-1.657 0.43-1.758 0.27-0.75-1.34 0.682-1.1 1.35-1.72 1.844-1.82zm423.04 0c0.36-0.03 0.81 0 1.34 0.1 1.54 0.3 1.54 0.47 0.16 1.62-1.11 0.92-1.74 0.95-2.22 0.16-0.68-1.09-0.37-1.77 0.72-1.88zm-369.85 0.04c-0.34-0.03-0.1 0.24 0.56 0.96 0.7 0.76 2.68 1.93 4.41 2.57 3.58 1.31 6.28 1.62 5.28 0.62-0.37-0.37-2.09-1.2-3.84-1.84s-4.11-1.49-5.19-1.91c-0.62-0.24-1.01-0.39-1.22-0.4zm229.44 0.12c0.02-0.02 0.01-0.01 0.03 0 0.05 0.04 0.13 0.23 0.19 0.53 0.23 1.22 0.23 3.19 0 4.41-0.24 1.21-0.44 0.21-0.44-2.22 0-1.6 0.1-2.58 0.22-2.72zm-32.06 0.69c0.2-0.02 0.47 0.09 0.71 0.34 0.33 0.33 0.39 1.13 0.16 1.81-0.33 1-0.57 1.01-1.19 0-0.61-0.99-0.3-2.09 0.32-2.15zm-3.91 0.06c0.57 0 1.06 0.46 1.06 1s-0.2 0.97-0.44 0.97c-0.23 0-0.69-0.43-1.03-0.97-0.33-0.54-0.16-1 0.41-1zm-94.97 0.47c0.08-0.07 0.18 0.03 0.28 0.28 0.28 0.68 0.28 1.79 0 2.47-0.27 0.68-0.5 0.1-0.5-1.25 0-0.85 0.09-1.39 0.22-1.5zm-38.37 0.72c0.06-0.03 0.16 0.01 0.25 0.09 0.32 0.33 0.34 1.17 0.06 1.88-0.32 0.78-0.55 0.55-0.59-0.6-0.04-0.78 0.07-1.3 0.28-1.37zm130.56 0.9c0.34-0.01 0.71 0.05 1.06 0.19 0.79 0.32 0.58 0.55-0.56 0.59-1.04 0.05-1.64-0.17-1.31-0.5 0.16-0.16 0.47-0.26 0.81-0.28zm-178.53 1.85c-0.51 0.04-0.64 0.29-0.19 0.75 0.4 0.4 2.16 1.27 3.88 1.9 4.89 1.81 6.39 1.4 2.59-0.68-2.31-1.27-5.17-2.07-6.28-1.97zm82.4 0.19c0.07-0.03 0.17 0.01 0.25 0.09 0.33 0.33 0.35 1.16 0.07 1.87-0.32 0.79-0.55 0.59-0.6-0.56-0.03-0.78 0.08-1.33 0.28-1.4zm-125.37 1.06c0.41 0.01 0.97 0.15 1.687 0.53 1 0.52 2.929 1.44 4.284 2l2.47 1.03-2.972 0.03c-1.624 0.02-3.77-0.62-4.813-1.41-1.431-1.08-1.687-1.97-1.031-2.15 0.098-0.03 0.238-0.04 0.375-0.03zm384.9 1.62c2.36-0.02 4.34-0.02 5.44 0.03 0.68 0.04 1.25 0.95 1.25 2.03 0 1.86-0.66 1.97-11.84 1.97-9.76 0-11.96-0.24-12.44-1.5-0.32-0.83-0.37-1.72-0.15-1.93 0.24-0.24 10.67-0.54 17.74-0.6zm-290.46 1.06c0.38 0 1.5 0.62 2.5 1.35 1.25 0.92 1.47 1.54 0.68 2.03-0.62 0.39-1.15 1.79-1.15 3.12 0 1.7-0.77 2.71-2.53 3.38-3.27 1.24-3.38 1.22-3.38-0.5 0-2.03 3.04-9.38 3.88-9.38zm-100.28 0.1c0.973 0.03 0.829 0.35-0.469 0.9-2.704 1.17-4.267 1.17-2.468 0 0.811-0.52 2.125-0.93 2.937-0.9zm89.845 0.31c2.54 0.03 4.59 0.77 4.59 2.31 0 1.12-0.68 1.32-2.87 0.88-1.66-0.33-4.41 0.05-6.38 0.87-4.85 2.03-5.77 1.81-4-0.9 1.36-2.07 5.39-3.19 8.66-3.16zm42.28 0.59c0.89 0 2.08 0.89 2.66 1.97 0.8 1.51 0.75 1.97-0.25 1.97-0.73 0-1.85-0.54-2.5-1.18-0.92-0.92-1.19-0.59-1.19 1.43 0 1.43-0.46 2.88-1.06 3.25-0.74 0.46-0.91-0.07-0.47-1.65 0.62-2.23 0.57-2.24-1.44 0.34-2.02 2.61-2.44 2.72-11.13 2.69-10.28-0.04-13-1.01-11.4-4 0.57-1.07 1.47-1.63 2.03-1.28 0.56 0.34 4.95 0.6 9.75 0.56 7.69-0.07 8.64 0.08 8.09 1.5-0.41 1.07-0.2 1.35 0.57 0.87 0.63-0.39 1.12-1.27 1.12-1.97 0-1.71 3.24-4.5 5.22-4.5zm103.91 1.26c0.96-0.06 1.81 0.05 2.43 0.4 1.44 0.8 1.3 1.09-0.93 2.28-2.03 1.09-2.91 1.13-4.41 0.19-1.67-1.04-1.86-0.92-1.66 1.03 0.17 1.61-0.36 2.31-1.9 2.53-1.17 0.17-2.35-0.09-2.63-0.53-1.34-2.16 4.92-5.66 9.1-5.9zm69.34 0.18c0.91-0.05 1.56 0.09 1.56 0.5 0 0.55-0.4 1-0.87 1-0.48 0-2.36 0.26-4.19 0.56-2.27 0.39-2.85 0.26-1.84-0.37 1.53-0.95 3.82-1.59 5.34-1.69zm-282.66 0.66c0.35-0.02 0.74 0.04 1.1 0.19 0.78 0.31 0.55 0.51-0.6 0.56-1.03 0.04-1.6-0.14-1.28-0.47 0.17-0.16 0.44-0.27 0.78-0.28zm7.07 0.97c2.03-0.07 3.68 0.33 3.68 0.87 0 1.09-0.17 1.09-4.43 0-2.94-0.74-2.93-0.76 0.75-0.87zm316.06 0.09c-1.93 0.05-2.53 0.41-2.53 1.31 0 1.2 1 1.49 4.62 1.25 6.22-0.4 6.44-2.23 0.31-2.53-0.96-0.04-1.76-0.05-2.4-0.03zm-296.22 0.22c1.97 0.01 3.28 0.13 3.12 0.38-0.3 0.49-4.62 0.99-9.62 1.09s-8.91-0.02-8.66-0.25c0.63-0.55 7.83-1.08 13-1.19 0.78-0.02 1.5-0.03 2.16-0.03zm223.84 0.69c-0.8 0-1.58 0.04-2.18 0.15-1.22 0.24-0.25 0.41 2.18 0.41 2.44 0 3.44-0.17 2.22-0.41-0.61-0.11-1.41-0.15-2.22-0.15zm-268.53 0.84c-5.246 0-8.874 0.42-8.874 1-0.001 0.58 3.628 0.97 8.874 0.97 5.247 0 8.848-0.39 8.848-0.97s-3.601-1-8.848-1zm298.53 1c-2.68 0-3.08 0.92-1.25 2.75 1.43 1.42 12.57 1.59 12.57 0.19 0-0.54-1.98-0.97-4.41-0.97s-4.44-0.46-4.44-1-1.11-0.97-2.47-0.97zm-39.81 0.13c-0.44 0-0.91 0.05-1.25 0.18-0.68 0.28-0.1 0.5 1.25 0.5s1.9-0.22 1.22-0.5c-0.34-0.13-0.77-0.18-1.22-0.18zm-99.5 0.28c1.17-0.05 3.18 0.42 4.78 1.09 3.26 1.36 3.29 1.43 1.75 3.78-0.87 1.33-2.24 2.65-3 2.94-1.94 0.74-2.83-1.12-1.37-2.87 1.84-2.22 0.3-2.88-2.47-1.07-2.29 1.5-2.4 1.5-1.81-0.03 0.42-1.1 0.27-1.38-0.5-0.9-0.64 0.39-1.19 0.21-1.19-0.38 0-0.77-0.56-0.79-1.97-0.03-1.3 0.69-1.97 0.72-1.97 0.06 0-0.9 1-1.25 7.31-2.53 0.13-0.03 0.27-0.06 0.44-0.06zm-159.22 1.56c-1.623 0-2.968 0.32-2.968 0.75s1.345 0.91 2.968 1.03c1.624 0.12 2.938-0.23 2.938-0.78s-1.314-1-2.938-1zm266.72 0c-2.08 0.06-5.36 0.5-6.53 1.03-1.32 0.6-0.37 0.69 2.94 0.28 2.7-0.33 5.12-0.77 5.34-0.97 0.32-0.28-0.5-0.38-1.75-0.34zm-202.69 0.12c-0.34 0.02-0.65 0.09-0.81 0.26-0.33 0.32 0.28 0.54 1.31 0.5 1.15-0.05 1.35-0.28 0.57-0.6-0.36-0.14-0.72-0.17-1.07-0.16zm-11.4 1.85c-1.9 0-3.44 0.43-3.44 0.97s1.54 0.97 3.44 0.97c1.89 0 3.44-0.43 3.44-0.97s-1.55-0.97-3.44-0.97z"/>
						 <rect id="rect8" height="10.014" width="420.03" y="430.82" x="63.422"/>
						 <path id="path10" d="m543.54 276.94a276.23 276.23 0 1 1 -552.47 0 276.23 276.23 0 1 1 552.47 0z" transform="matrix(.95831 0 0 .95831 17.669 8.4373)" stroke="#000" stroke-linecap="round" stroke-miterlimit="2.41" stroke-width="9.7" fill="none"/>
						 <path id="path12" d="m207.05 63.887c0 1.932 0 3.667-0.03 5.205-0.02 1.537-0.08 2.752-0.18 3.646-0.07 0.612-0.19 1.122-0.35 1.532-0.17 0.409-0.45 0.66-0.85 0.753-0.19 0.043-0.41 0.081-0.66 0.114s-0.53 0.05-0.84 0.052c-0.24 0.001-0.42 0.03-0.52 0.088s-0.15 0.14-0.14 0.244c0 0.284 0.28 0.423 0.83 0.416 0.42-0.004 0.88-0.017 1.38-0.042 0.51-0.024 1-0.038 1.48-0.041 0.51-0.02 0.97-0.032 1.39-0.037 0.42-0.004 0.75-0.006 0.98-0.005 0.33 0 0.77 0.011 1.33 0.031 0.56 0.021 1.15 0.052 1.79 0.094 0.62 0.023 1.19 0.049 1.72 0.078 0.53 0.028 0.92 0.044 1.19 0.047 3.8-0.1 6.61-1.054 8.41-2.862s2.7-3.874 2.68-6.196c-0.1-2.428-0.94-4.386-2.5-5.875-1.57-1.488-3.26-2.521-5.06-3.1 1.18-0.89 2.17-1.905 2.98-3.044 0.8-1.139 1.22-2.548 1.26-4.227 0.1-1.224-0.44-2.538-1.61-3.943-1.17-1.404-3.58-2.168-7.24-2.29-0.7 0.005-1.47 0.026-2.3 0.062-0.84 0.037-1.76 0.057-2.77 0.063-0.46-0.006-1.23-0.026-2.31-0.063-1.08-0.036-2.2-0.057-3.34-0.062-0.31-0.003-0.54 0.023-0.69 0.078-0.15 0.054-0.23 0.153-0.23 0.296s0.06 0.241 0.18 0.296c0.13 0.055 0.3 0.08 0.53 0.078 0.3 0 0.6 0.01 0.9 0.031s0.54 0.052 0.72 0.094c0.67 0.137 1.13 0.392 1.38 0.763 0.24 0.371 0.38 0.906 0.41 1.605 0.04 0.554 0.06 1.399 0.07 2.534 0.01 1.136 0.01 3.228 0.01 6.275v7.312zm4.99-16.869c-0.01-0.224 0.02-0.389 0.07-0.493 0.06-0.105 0.16-0.176 0.3-0.213 0.2-0.04 0.41-0.064 0.62-0.073 0.22-0.009 0.47-0.012 0.75-0.01 1.78 0.094 3.09 0.819 3.94 2.176 0.84 1.356 1.26 2.778 1.25 4.264 0 1.02-0.15 1.899-0.44 2.638-0.3 0.74-0.72 1.328-1.26 1.766-0.35 0.306-0.76 0.515-1.25 0.629-0.48 0.113-1.06 0.167-1.74 0.161-0.48 0-0.87-0.011-1.2-0.032-0.32-0.02-0.57-0.051-0.75-0.093-0.09-0.016-0.16-0.056-0.21-0.12-0.05-0.063-0.08-0.175-0.08-0.337v-10.263zm9.51 21.855c-0.09 2.113-0.7 3.539-1.81 4.28-1.12 0.741-2.19 1.087-3.22 1.039-0.47 0.008-0.96-0.018-1.45-0.078-0.5-0.06-1.02-0.2-1.58-0.421-0.64-0.231-1.05-0.62-1.23-1.168-0.17-0.548-0.25-1.488-0.22-2.821v-9.847c0-0.201 0.08-0.298 0.25-0.291 0.3-0.001 0.58 0.001 0.84 0.005 0.27 0.005 0.58 0.017 0.94 0.037 0.8 0.039 1.47 0.137 2.01 0.296 0.53 0.158 1.02 0.392 1.44 0.701 1.55 1.147 2.62 2.478 3.2 3.994s0.86 2.94 0.83 4.274zm14.88-4.986c0 2.032-0.01 3.827-0.03 5.386s-0.08 2.783-0.18 3.672c-0.05 0.604-0.17 1.08-0.34 1.429-0.17 0.348-0.46 0.565-0.87 0.649-0.18 0.043-0.4 0.081-0.65 0.114s-0.53 0.05-0.84 0.052c-0.25 0.001-0.42 0.03-0.52 0.088s-0.15 0.14-0.15 0.244c0.01 0.284 0.29 0.423 0.84 0.416 0.88-0.005 1.84-0.026 2.88-0.062 1.03-0.037 1.82-0.058 2.35-0.063 0.59 0.005 1.47 0.026 2.63 0.063 1.17 0.036 2.45 0.057 3.85 0.062 0.24 0.001 0.42-0.032 0.57-0.099 0.14-0.066 0.22-0.172 0.22-0.317 0.01-0.214-0.21-0.325-0.66-0.332-0.33-0.002-0.69-0.019-1.08-0.052s-0.74-0.071-1.04-0.114c-0.61-0.088-1.03-0.307-1.25-0.66-0.23-0.352-0.37-0.811-0.41-1.376-0.08-0.909-0.13-2.145-0.15-3.708-0.02-1.564-0.02-3.361-0.02-5.392v-7.312c0-3.047 0-5.139 0.01-6.275 0.01-1.135 0.03-1.98 0.07-2.534 0.03-0.722 0.16-1.273 0.38-1.652s0.61-0.618 1.16-0.716c0.24-0.042 0.46-0.073 0.65-0.094 0.2-0.021 0.39-0.031 0.6-0.031 0.21 0.003 0.37-0.024 0.48-0.083 0.12-0.059 0.18-0.17 0.18-0.333 0-0.123-0.08-0.209-0.23-0.259-0.16-0.05-0.37-0.075-0.64-0.073-0.84 0.005-1.75 0.026-2.74 0.062-0.99 0.037-1.76 0.057-2.33 0.063-0.65-0.006-1.51-0.026-2.56-0.063-1.05-0.036-2-0.057-2.84-0.062-0.33-0.002-0.58 0.022-0.75 0.073-0.17 0.05-0.25 0.136-0.25 0.259 0 0.163 0.06 0.274 0.18 0.333 0.11 0.059 0.28 0.086 0.49 0.083 0.25-0.001 0.5 0.011 0.76 0.036s0.5 0.069 0.73 0.13c0.46 0.1 0.79 0.337 1.02 0.712 0.22 0.374 0.36 0.913 0.39 1.615 0.04 0.554 0.07 1.399 0.08 2.534 0.01 1.136 0.01 3.228 0.01 6.275v7.312zm18.74 0c0.01 1.932 0 3.667-0.02 5.205-0.02 1.537-0.08 2.752-0.18 3.646-0.07 0.612-0.19 1.122-0.36 1.532-0.16 0.409-0.45 0.66-0.85 0.753-0.19 0.043-0.4 0.081-0.65 0.114s-0.53 0.05-0.84 0.052c-0.25 0.001-0.42 0.03-0.52 0.088s-0.15 0.14-0.15 0.244c0.01 0.284 0.28 0.423 0.83 0.416 0.89-0.005 1.85-0.026 2.88-0.062 1.04-0.037 1.82-0.058 2.36-0.063 0.57 0.005 1.43 0.026 2.59 0.063 1.17 0.036 2.45 0.057 3.85 0.062 0.23 0.001 0.42-0.032 0.56-0.099 0.15-0.066 0.22-0.172 0.23-0.317 0-0.214-0.22-0.325-0.67-0.332-0.32-0.002-0.68-0.019-1.07-0.052-0.4-0.033-0.74-0.071-1.05-0.114-0.6-0.094-1.01-0.343-1.23-0.748-0.21-0.405-0.34-0.904-0.39-1.496-0.1-0.913-0.16-2.141-0.18-3.682-0.02-1.542-0.03-3.278-0.03-5.21v-16.62c0.01-0.45 0.12-0.713 0.34-0.789 0.19-0.062 0.43-0.105 0.71-0.13 0.29-0.025 0.59-0.037 0.91-0.036 0.5-0.019 1.12 0.08 1.87 0.296 0.75 0.215 1.51 0.657 2.28 1.324 1.12 1.083 1.82 2.21 2.1 3.381s0.4 2.122 0.35 2.852c-0.08 2.139-0.72 3.812-1.91 5.017-1.18 1.205-2.4 1.818-3.65 1.838-0.43-0.001-0.74 0.033-0.91 0.104-0.18 0.071-0.26 0.189-0.26 0.353 0.01 0.141 0.07 0.234 0.17 0.281 0.11 0.047 0.22 0.078 0.33 0.093 0.12 0.02 0.26 0.032 0.44 0.037 0.17 0.004 0.32 0.006 0.43 0.005 3.01-0.05 5.45-0.989 7.33-2.815 1.87-1.827 2.84-4.24 2.9-7.24-0.03-1.115-0.27-2.105-0.7-2.971-0.44-0.866-0.9-1.524-1.38-1.974-0.29-0.371-1.01-0.844-2.17-1.418-1.15-0.573-3.01-0.89-5.56-0.95-0.98 0.005-2.01 0.026-3.09 0.062-1.08 0.037-2.06 0.057-2.94 0.063-0.62-0.006-1.48-0.026-2.6-0.063-1.11-0.036-2.24-0.057-3.38-0.062-0.31-0.003-0.54 0.023-0.69 0.078-0.15 0.054-0.22 0.153-0.22 0.296s0.06 0.241 0.18 0.296 0.29 0.08 0.52 0.078c0.3 0 0.61 0.01 0.91 0.031s0.54 0.052 0.71 0.094c0.67 0.137 1.13 0.392 1.38 0.763s0.39 0.906 0.41 1.605c0.04 0.554 0.06 1.399 0.07 2.534 0.01 1.136 0.02 3.228 0.01 6.275v7.312zm24.61 7.895c-0.08 0.739-0.25 1.432-0.49 2.077-0.24 0.646-0.64 1.048-1.21 1.205-0.3 0.06-0.55 0.096-0.73 0.109-0.19 0.013-0.36 0.019-0.52 0.016-0.21-0.001-0.37 0.022-0.48 0.068-0.12 0.045-0.18 0.12-0.18 0.223 0 0.183 0.08 0.305 0.22 0.369 0.14 0.063 0.31 0.092 0.53 0.088 0.7-0.005 1.45-0.026 2.26-0.062 0.8-0.037 1.42-0.058 1.85-0.063 0.4 0.005 1 0.026 1.81 0.063 0.8 0.036 1.66 0.057 2.55 0.062 0.32 0.004 0.56-0.025 0.74-0.088 0.17-0.064 0.26-0.186 0.26-0.369 0-0.103-0.07-0.178-0.19-0.223-0.12-0.046-0.26-0.069-0.43-0.068-0.21 0.002-0.46-0.012-0.75-0.042-0.29-0.029-0.62-0.084-1-0.166-0.36-0.078-0.65-0.222-0.89-0.431-0.23-0.208-0.35-0.508-0.35-0.898 0-0.326 0.01-0.641 0.03-0.946 0.02-0.304 0.05-0.64 0.09-1.007l2.16-16.537h0.17c0.79 1.693 1.65 3.511 2.56 5.453 0.92 1.943 1.51 3.2 1.76 3.771 0.2 0.447 0.61 1.293 1.24 2.538 0.63 1.244 1.28 2.53 1.97 3.858 0.68 1.327 1.2 2.339 1.57 3.036 0.33 0.632 0.6 1.134 0.83 1.506s0.44 0.563 0.62 0.571c0.17 0.025 0.35-0.118 0.55-0.431 0.2-0.312 0.53-0.944 0.99-1.895l9.06-18.864h0.16l2.5 18.282c0.08 0.578 0.09 1.011 0.05 1.298-0.05 0.288-0.13 0.45-0.26 0.489-0.15 0.06-0.26 0.126-0.34 0.197s-0.12 0.157-0.12 0.26c-0.01 0.123 0.07 0.219 0.25 0.29 0.17 0.071 0.49 0.127 0.96 0.167 0.6 0.042 1.5 0.082 2.69 0.12 1.19 0.037 2.34 0.068 3.46 0.092s1.88 0.036 2.28 0.037c0.3 0.002 0.55-0.033 0.76-0.104 0.2-0.071 0.31-0.189 0.32-0.353 0-0.121-0.07-0.201-0.19-0.239-0.13-0.038-0.28-0.055-0.47-0.052-0.27 0.006-0.62-0.016-1.04-0.067-0.43-0.052-0.94-0.168-1.54-0.348-0.61-0.175-1.06-0.594-1.35-1.257s-0.52-1.643-0.69-2.94l-3.78-25.678c-0.12-0.866-0.37-1.295-0.74-1.288-0.19 0-0.34 0.083-0.48 0.249-0.13 0.166-0.28 0.416-0.44 0.748l-11.3 23.725-11.34-23.434c-0.27-0.526-0.48-0.876-0.64-1.049-0.17-0.173-0.33-0.253-0.49-0.239-0.34 0.007-0.57 0.367-0.7 1.08l-4.12 27.091z"/>
						 <path id="path14" d="m162.68 489.86c-0.34 0.57-0.72 1.09-1.16 1.53-0.43 0.45-0.9 0.64-1.43 0.56-0.27-0.06-0.49-0.11-0.64-0.17-0.16-0.06-0.3-0.11-0.43-0.17-0.18-0.08-0.32-0.12-0.43-0.12-0.11-0.01-0.19 0.03-0.23 0.12-0.06 0.15-0.04 0.28 0.05 0.38s0.23 0.19 0.41 0.27c0.58 0.24 1.21 0.5 1.88 0.76 0.68 0.26 1.2 0.46 1.56 0.61 0.33 0.15 0.82 0.39 1.47 0.71s1.35 0.64 2.09 0.97c0.26 0.12 0.47 0.18 0.64 0.19 0.16 0.01 0.28-0.06 0.35-0.21 0.03-0.09 0.01-0.17-0.08-0.25-0.08-0.08-0.19-0.15-0.33-0.21-0.18-0.08-0.38-0.18-0.61-0.31s-0.48-0.29-0.76-0.49c-0.27-0.2-0.46-0.42-0.58-0.68-0.11-0.26-0.11-0.55 0.03-0.87 0.12-0.27 0.24-0.53 0.37-0.77 0.12-0.25 0.27-0.51 0.44-0.8l7.74-12.88 0.14 0.06c0.04 1.68 0.09 3.49 0.15 5.43 0.06 1.93 0.09 3.18 0.09 3.74 0.01 0.44 0.04 1.29 0.11 2.55 0.07 1.25 0.15 2.55 0.24 3.89 0.09 1.35 0.15 2.37 0.2 3.08 0.05 0.64 0.1 1.15 0.15 1.54 0.06 0.39 0.16 0.63 0.31 0.7 0.13 0.08 0.33 0.03 0.61-0.16 0.27-0.19 0.77-0.59 1.49-1.21l14.29-12.32 0.13 0.06-4.53 16c-0.14 0.51-0.28 0.87-0.42 1.09-0.14 0.23-0.27 0.33-0.39 0.31-0.14 0-0.26 0.01-0.35 0.05-0.09 0.03-0.16 0.08-0.19 0.17-0.06 0.09-0.02 0.2 0.09 0.32 0.12 0.13 0.37 0.29 0.74 0.49 0.48 0.25 1.21 0.61 2.18 1.07s1.91 0.9 2.83 1.32c0.91 0.43 1.54 0.71 1.87 0.85 0.24 0.11 0.46 0.18 0.66 0.19 0.2 0.02 0.33-0.04 0.39-0.17 0.04-0.11 0.02-0.19-0.07-0.27s-0.21-0.15-0.37-0.21c-0.22-0.1-0.5-0.24-0.83-0.43-0.34-0.2-0.72-0.48-1.15-0.85-0.44-0.36-0.66-0.87-0.66-1.52s0.16-1.54 0.49-2.68l6.13-22.57c0.21-0.77 0.16-1.21-0.15-1.34-0.15-0.06-0.31-0.05-0.48 0.04s-0.39 0.24-0.64 0.46l-17.89 15.53-0.92-23.45c-0.03-0.53-0.08-0.9-0.15-1.1s-0.18-0.33-0.31-0.37c-0.29-0.12-0.61 0.09-0.98 0.64l-13.16 20.9zm39.96 8.38c-0.48 1.67-0.93 3.17-1.33 4.49-0.41 1.33-0.77 2.36-1.08 3.11-0.22 0.51-0.45 0.93-0.69 1.24-0.25 0.31-0.56 0.46-0.93 0.44-0.17-0.01-0.37-0.04-0.6-0.07-0.22-0.04-0.47-0.09-0.74-0.17-0.21-0.06-0.37-0.08-0.47-0.05-0.1 0.02-0.16 0.08-0.19 0.17-0.06 0.25 0.14 0.44 0.62 0.57 0.37 0.1 0.77 0.21 1.21 0.31 0.44 0.11 0.87 0.22 1.29 0.34 0.44 0.11 0.85 0.22 1.21 0.32s0.65 0.18 0.85 0.24c0.53 0.16 1.09 0.33 1.69 0.52 0.59 0.2 1.26 0.42 2.02 0.68 0.76 0.25 1.65 0.53 2.66 0.85s2.19 0.68 3.53 1.07c0.65 0.22 1.13 0.31 1.42 0.29s0.56-0.24 0.79-0.66c0.22-0.4 0.52-1.02 0.87-1.86 0.36-0.85 0.61-1.51 0.76-1.99 0.06-0.18 0.09-0.34 0.1-0.47s-0.06-0.22-0.2-0.26c-0.12-0.04-0.22-0.02-0.3 0.04-0.08 0.07-0.16 0.2-0.25 0.38-0.33 0.7-0.68 1.22-1.05 1.56-0.38 0.35-0.82 0.56-1.34 0.63-0.55 0.07-1.15 0.03-1.8-0.11s-1.22-0.29-1.71-0.44c-1.79-0.49-2.9-1.03-3.34-1.6-0.43-0.58-0.46-1.47-0.09-2.68 0.16-0.62 0.42-1.52 0.78-2.72 0.35-1.2 0.64-2.15 0.84-2.85l0.83-2.84c0.03-0.11 0.07-0.2 0.12-0.25 0.05-0.06 0.11-0.07 0.2-0.05 0.55 0.16 1.42 0.42 2.61 0.79 1.2 0.37 2.02 0.64 2.47 0.81 0.63 0.26 1.06 0.56 1.29 0.9s0.34 0.7 0.31 1.09c-0.02 0.25-0.05 0.49-0.1 0.71-0.05 0.23-0.1 0.44-0.13 0.62-0.03 0.09-0.03 0.18 0 0.25 0.03 0.08 0.1 0.13 0.23 0.17 0.15 0.03 0.27-0.02 0.35-0.15 0.07-0.14 0.13-0.28 0.17-0.44 0.05-0.16 0.17-0.5 0.36-1.01 0.18-0.51 0.35-0.96 0.48-1.36 0.34-0.87 0.59-1.49 0.76-1.86 0.17-0.36 0.27-0.59 0.3-0.68 0.03-0.1 0.03-0.19-0.01-0.24-0.03-0.06-0.09-0.1-0.16-0.12-0.09-0.02-0.19-0.01-0.3 0.05s-0.25 0.14-0.41 0.25c-0.21 0.13-0.47 0.19-0.77 0.19-0.31-0.01-0.68-0.06-1.11-0.15-0.33-0.07-0.89-0.22-1.7-0.44-0.81-0.23-1.62-0.46-2.42-0.69s-1.35-0.39-1.66-0.48c-0.1-0.03-0.16-0.08-0.18-0.16-0.01-0.08 0.01-0.18 0.04-0.31l2.66-9.09c0.06-0.25 0.18-0.35 0.35-0.29 0.28 0.08 0.78 0.24 1.51 0.46 0.72 0.23 1.43 0.45 2.14 0.69 0.71 0.23 1.18 0.39 1.42 0.48 0.84 0.36 1.38 0.7 1.64 1.01s0.39 0.64 0.39 0.99c0.02 0.25 0.01 0.51-0.03 0.77-0.05 0.25-0.09 0.45-0.13 0.59-0.05 0.16-0.07 0.29-0.04 0.39 0.02 0.1 0.09 0.17 0.21 0.2 0.13 0.04 0.23 0.02 0.3-0.05 0.08-0.07 0.14-0.15 0.18-0.24 0.11-0.25 0.27-0.64 0.46-1.18 0.19-0.53 0.33-0.91 0.41-1.14 0.29-0.78 0.52-1.33 0.68-1.64 0.16-0.3 0.25-0.51 0.29-0.61 0.03-0.09 0.04-0.17 0.03-0.24-0.02-0.07-0.06-0.12-0.15-0.15-0.09-0.02-0.2-0.03-0.31-0.02h-0.31c-0.16-0.01-0.38-0.03-0.65-0.07-0.28-0.05-0.6-0.1-0.96-0.17-0.31-0.07-1.1-0.3-2.38-0.66-1.29-0.37-2.59-0.75-3.93-1.14-1.33-0.38-2.23-0.65-2.69-0.78-0.25-0.08-0.57-0.18-0.96-0.31-0.39-0.12-0.81-0.27-1.28-0.42-0.45-0.14-0.93-0.28-1.43-0.44l-1.47-0.45c-0.27-0.08-0.48-0.11-0.62-0.1-0.14 0-0.23 0.07-0.27 0.2-0.03 0.12-0.01 0.22 0.08 0.3 0.09 0.07 0.24 0.14 0.44 0.2 0.26 0.07 0.52 0.16 0.77 0.25 0.26 0.1 0.46 0.18 0.6 0.26 0.54 0.29 0.88 0.63 1 1.01 0.12 0.39 0.1 0.88-0.05 1.49-0.11 0.49-0.3 1.23-0.58 2.22-0.28 0.98-0.8 2.79-1.57 5.43l-1.85 6.33zm26.73 6.73c-0.31 1.72-0.6 3.25-0.87 4.61s-0.52 2.43-0.75 3.21c-0.15 0.53-0.33 0.97-0.55 1.3-0.22 0.34-0.51 0.51-0.89 0.53-0.17 0.01-0.37 0.01-0.6-0.01-0.22-0.01-0.48-0.04-0.75-0.09-0.22-0.04-0.38-0.04-0.48 0-0.09 0.03-0.15 0.1-0.17 0.19-0.03 0.25 0.19 0.42 0.67 0.5 0.79 0.14 1.65 0.28 2.57 0.42 0.93 0.13 1.62 0.24 2.1 0.32 0.54 0.1 1.32 0.27 2.35 0.49 1.04 0.22 2.17 0.45 3.41 0.68 0.21 0.04 0.38 0.04 0.52 0 0.14-0.03 0.22-0.11 0.25-0.24 0.04-0.19-0.14-0.33-0.54-0.4-0.28-0.06-0.6-0.13-0.94-0.22-0.34-0.1-0.65-0.19-0.91-0.27-0.52-0.19-0.84-0.47-0.97-0.87-0.13-0.39-0.16-0.85-0.1-1.39 0.06-0.82 0.2-1.92 0.43-3.29s0.51-2.91 0.82-4.63l2.76-15.1 4.62 0.96c1.61 0.35 2.69 0.79 3.25 1.31 0.57 0.53 0.81 1.04 0.73 1.55l-0.04 0.41c-0.04 0.27-0.04 0.47 0 0.59 0.03 0.12 0.12 0.2 0.27 0.22 0.11 0.02 0.2-0.02 0.26-0.12 0.07-0.09 0.13-0.23 0.18-0.41 0.1-0.55 0.26-1.28 0.46-2.2 0.2-0.91 0.34-1.6 0.43-2.05 0.05-0.28 0.07-0.48 0.06-0.61-0.02-0.13-0.09-0.2-0.21-0.22-0.08-0.01-0.19-0.02-0.36-0.01-0.16 0-0.39 0-0.67 0.01-0.28-0.01-0.64-0.03-1.06-0.07s-0.93-0.11-1.52-0.21l-14.59-2.66c-0.62-0.12-1.25-0.25-1.89-0.4s-1.22-0.31-1.76-0.46c-0.44-0.13-0.77-0.28-0.98-0.44s-0.39-0.25-0.52-0.29c-0.11-0.02-0.21 0.02-0.3 0.12-0.08 0.1-0.18 0.27-0.27 0.5-0.06 0.12-0.2 0.48-0.44 1.05-0.23 0.58-0.46 1.17-0.69 1.78s-0.37 1.03-0.42 1.26c-0.04 0.2-0.04 0.36-0.01 0.46 0.03 0.11 0.11 0.17 0.23 0.19 0.11 0.02 0.21 0 0.28-0.06 0.08-0.06 0.15-0.17 0.21-0.31s0.16-0.31 0.3-0.51 0.33-0.42 0.56-0.66c0.33-0.35 0.78-0.55 1.34-0.59 0.57-0.05 1.38 0.01 2.43 0.17l5.52 0.86-2.76 15.1zm20.29 3.06c-0.13 1.74-0.26 3.29-0.38 4.68-0.13 1.38-0.26 2.46-0.41 3.26-0.11 0.54-0.25 1-0.43 1.35-0.17 0.36-0.44 0.57-0.81 0.62-0.17 0.03-0.37 0.05-0.6 0.06s-0.48 0.01-0.76-0.01c-0.22-0.02-0.38 0-0.47 0.04-0.1 0.05-0.15 0.12-0.15 0.21-0.01 0.26 0.23 0.4 0.72 0.43 0.8 0.06 1.66 0.1 2.59 0.14 0.94 0.04 1.64 0.08 2.12 0.11 0.51 0.04 1.29 0.12 2.33 0.23s2.19 0.22 3.45 0.32c0.21 0.02 0.38 0 0.52-0.05 0.13-0.05 0.21-0.14 0.22-0.27 0.02-0.19-0.17-0.31-0.57-0.34-0.3-0.03-0.62-0.07-0.97-0.12-0.35-0.06-0.66-0.12-0.93-0.18-0.53-0.12-0.89-0.37-1.05-0.75-0.17-0.38-0.25-0.84-0.25-1.37-0.03-0.83 0-1.94 0.09-3.33 0.08-1.38 0.2-2.95 0.33-4.68l1.14-14.94c0.04-0.4 0.15-0.63 0.35-0.69 0.18-0.04 0.4-0.06 0.66-0.06 0.25-0.01 0.53 0 0.81 0.03 0.45 0.01 1 0.15 1.67 0.39 0.66 0.25 1.31 0.69 1.95 1.35 0.94 1.05 1.49 2.11 1.66 3.18s0.21 1.93 0.12 2.59c-0.22 1.91-0.91 3.37-2.06 4.38-1.15 1-2.29 1.46-3.41 1.4-0.39-0.03-0.66-0.02-0.83 0.03-0.16 0.05-0.24 0.15-0.25 0.3 0 0.13 0.04 0.21 0.14 0.26 0.09 0.05 0.18 0.09 0.28 0.11s0.23 0.05 0.39 0.06c0.16 0.02 0.29 0.03 0.39 0.04 2.71 0.16 4.97-0.52 6.78-2.03 1.81-1.52 2.84-3.62 3.1-6.31 0.05-1.01-0.09-1.91-0.42-2.72s-0.7-1.43-1.11-1.87c-0.23-0.35-0.85-0.83-1.85-1.42-1-0.6-2.64-1.01-4.93-1.24-0.88-0.06-1.81-0.11-2.78-0.15-0.98-0.04-1.86-0.09-2.65-0.15-0.55-0.04-1.33-0.12-2.33-0.23s-2.01-0.21-3.04-0.29c-0.27-0.02-0.48-0.01-0.62 0.02-0.14 0.04-0.21 0.13-0.22 0.26-0.01 0.12 0.04 0.22 0.14 0.27 0.1 0.06 0.26 0.1 0.47 0.11 0.27 0.02 0.54 0.05 0.81 0.09s0.48 0.08 0.63 0.13c0.6 0.17 0.99 0.43 1.19 0.78s0.28 0.84 0.26 1.47c0 0.5-0.04 1.27-0.11 2.29s-0.21 2.9-0.42 5.64l-0.5 6.57zm18.94-2.51c0.1 2.19 0.73 4.28 1.91 6.25 1.17 1.97 2.88 3.56 5.13 4.76l-2.96 0.13c-0.73 0.03-1.41-0.03-2.04-0.21-0.63-0.17-1.1-0.46-1.42-0.88-0.12-0.16-0.25-0.41-0.39-0.73s-0.26-0.72-0.36-1.18c-0.05-0.21-0.1-0.35-0.16-0.43-0.06-0.09-0.15-0.13-0.28-0.12-0.14 0.01-0.23 0.08-0.25 0.21-0.03 0.13-0.04 0.29-0.02 0.48 0.02 0.33 0.07 0.89 0.16 1.7 0.09 0.8 0.18 1.6 0.29 2.39s0.21 1.33 0.28 1.61c0.13 0.46 0.34 0.74 0.61 0.83 0.28 0.09 0.77 0.11 1.45 0.06 1.5-0.07 3.11-0.15 4.83-0.25s3.03-0.18 3.93-0.24c0.38 0.02 0.6 0.03 0.67 0.04 0.06 0 0.28-0.01 0.64-0.02 0.11-0.01 0.18-0.05 0.21-0.12s0.04-0.17 0.03-0.31l-0.07-1.79c-2.09-1.08-3.76-2.86-4.99-5.33-1.24-2.47-1.93-5.03-2.06-7.68-0.09-1.66 0.11-3.38 0.6-5.15 0.49-1.78 1.42-3.31 2.77-4.59s3.27-2 5.75-2.16c3.51-0.05 6.07 1.06 7.69 3.32 1.63 2.26 2.49 5.07 2.6 8.42 0.12 3.58-0.38 6.33-1.48 8.27-1.11 1.93-2.57 3.47-4.37 4.62l0.07 1.79c0.01 0.14 0.03 0.24 0.06 0.31 0.04 0.07 0.11 0.1 0.22 0.09 0.36-0.01 0.58-0.02 0.64-0.03 0.07-0.01 0.29-0.04 0.67-0.1 0.89-0.01 2.2-0.05 3.93-0.1 1.73-0.04 3.34-0.1 4.83-0.16 0.69-0.01 1.17-0.07 1.44-0.19 0.27-0.11 0.45-0.4 0.54-0.87 0.06-0.32 0.11-0.88 0.15-1.68s0.07-1.6 0.08-2.4c0.02-0.8 0.02-1.35 0.01-1.67 0-0.19-0.02-0.35-0.06-0.47-0.04-0.13-0.13-0.19-0.27-0.19-0.13 0-0.22 0.05-0.27 0.14s-0.09 0.24-0.12 0.44c-0.05 0.47-0.14 0.89-0.26 1.26s-0.27 0.67-0.47 0.91c-0.35 0.42-0.84 0.72-1.48 0.9s-1.36 0.28-2.18 0.31l-2.88 0.12c2.02-1.68 3.62-3.53 4.8-5.53 1.17-2.01 1.72-4.27 1.64-6.78-0.19-3.97-1.54-7.09-4.05-9.36s-6.01-3.34-10.51-3.21c-2.27 0.09-4.59 0.68-6.97 1.77-2.37 1.08-4.36 2.69-5.96 4.81s-2.36 4.78-2.3 7.99zm59.66-16.67c0.36-0.93 0.7-1.68 1.01-2.26s0.66-0.97 1.05-1.17c0.48-0.26 0.9-0.43 1.27-0.5 0.19-0.04 0.32-0.1 0.41-0.18s0.13-0.17 0.11-0.28c-0.03-0.11-0.11-0.18-0.24-0.21-0.12-0.03-0.29-0.02-0.49 0.02-0.7 0.16-1.37 0.32-2.02 0.49-0.65 0.18-1.16 0.31-1.55 0.39-0.37 0.08-0.89 0.17-1.57 0.28-0.67 0.11-1.38 0.25-2.11 0.4-0.52 0.11-0.75 0.27-0.7 0.49 0.03 0.13 0.09 0.21 0.19 0.24s0.2 0.03 0.32 0c0.15-0.04 0.34-0.07 0.56-0.11 0.22-0.03 0.43-0.04 0.63-0.03 0.2 0.02 0.37 0.08 0.51 0.18s0.23 0.21 0.26 0.34c0.03 0.16 0.04 0.37 0.04 0.64-0.01 0.26-0.06 0.55-0.15 0.84-0.13 0.44-0.41 1.23-0.85 2.38-0.43 1.15-0.89 2.34-1.36 3.57-0.48 1.23-0.85 2.18-1.11 2.85-0.99-1.09-2.02-2.22-3.1-3.4-1.08-1.17-2.18-2.4-3.29-3.7-0.15-0.18-0.28-0.36-0.39-0.54s-0.17-0.33-0.2-0.44-0.02-0.23 0.02-0.36c0.05-0.12 0.14-0.23 0.29-0.32s0.31-0.16 0.5-0.23c0.19-0.06 0.34-0.1 0.46-0.13 0.17-0.03 0.3-0.08 0.38-0.15 0.09-0.07 0.12-0.17 0.1-0.3-0.03-0.12-0.1-0.2-0.23-0.22s-0.32-0.01-0.57 0.05c-0.73 0.16-1.48 0.34-2.27 0.54-0.78 0.21-1.33 0.34-1.63 0.41-0.93 0.2-1.97 0.4-3.11 0.61s-1.97 0.37-2.48 0.48c-0.24 0.05-0.41 0.11-0.53 0.18-0.11 0.07-0.16 0.16-0.14 0.27 0.03 0.12 0.08 0.21 0.16 0.25 0.08 0.05 0.18 0.06 0.29 0.03 0.18-0.04 0.42-0.07 0.7-0.08 0.27-0.02 0.57-0.02 0.89 0.01 0.67 0.06 1.3 0.27 1.88 0.62 0.58 0.34 1.16 0.84 1.75 1.47l8.54 9.09-4.85 11.5c-0.42 0.99-0.8 1.74-1.16 2.26-0.35 0.51-0.77 0.89-1.25 1.13-0.27 0.13-0.52 0.24-0.76 0.31-0.24 0.08-0.42 0.13-0.56 0.16-0.15 0.03-0.26 0.09-0.35 0.16-0.08 0.08-0.11 0.17-0.09 0.28 0.05 0.22 0.25 0.29 0.62 0.21l0.62-0.13c0.34-0.08 0.84-0.2 1.49-0.38 0.65-0.17 1.17-0.3 1.56-0.39 0.54-0.11 1.2-0.23 2-0.37s1.29-0.23 1.47-0.26l0.66-0.14c0.24-0.05 0.42-0.11 0.53-0.19 0.11-0.07 0.16-0.17 0.13-0.3-0.03-0.11-0.09-0.18-0.19-0.22-0.1-0.03-0.2-0.04-0.32-0.01-0.15 0.03-0.3 0.05-0.45 0.07-0.16 0.02-0.29 0.03-0.41 0.03-0.18 0-0.34-0.04-0.5-0.11-0.16-0.08-0.27-0.2-0.33-0.36-0.06-0.2-0.07-0.44-0.04-0.72s0.11-0.59 0.23-0.93l3.54-9.91c1.15 1.21 2.4 2.56 3.77 4.07 1.36 1.5 2.74 3.05 4.15 4.65 0.17 0.21 0.26 0.4 0.25 0.55 0 0.16-0.05 0.26-0.14 0.3-0.16 0.07-0.28 0.15-0.35 0.23s-0.1 0.18-0.08 0.29c0.02 0.12 0.13 0.19 0.32 0.2 0.2 0.02 0.53-0.02 1.01-0.1 1.46-0.28 2.8-0.55 4.03-0.8 1.23-0.26 2.09-0.44 2.57-0.55l1.1-0.23c0.21-0.05 0.37-0.11 0.48-0.2 0.12-0.08 0.16-0.19 0.14-0.32-0.03-0.11-0.09-0.17-0.19-0.2-0.1-0.02-0.22-0.02-0.35 0.01-0.16 0.04-0.36 0.07-0.6 0.09-0.23 0.01-0.51 0.01-0.84-0.01-0.5-0.04-0.93-0.15-1.31-0.32s-0.76-0.43-1.14-0.76c-0.48-0.42-1.46-1.41-2.97-2.99-1.51-1.57-3.04-3.18-4.59-4.82-1.55-1.63-2.63-2.75-3.23-3.36l4.15-9.93zm12.65 10.58c0.54 1.65 1.02 3.14 1.43 4.47 0.41 1.32 0.7 2.38 0.86 3.17 0.11 0.55 0.15 1.02 0.13 1.41-0.03 0.4-0.2 0.69-0.52 0.89-0.15 0.09-0.33 0.18-0.53 0.28-0.21 0.09-0.44 0.19-0.71 0.28-0.21 0.07-0.35 0.14-0.42 0.22-0.07 0.07-0.09 0.16-0.06 0.25 0.09 0.24 0.37 0.28 0.83 0.12 0.76-0.25 1.58-0.54 2.46-0.86 0.87-0.32 1.54-0.55 2-0.71 0.48-0.15 1.23-0.38 2.24-0.67 1-0.29 2.11-0.63 3.31-1.02 0.2-0.06 0.35-0.14 0.46-0.24 0.1-0.1 0.14-0.21 0.1-0.33-0.05-0.19-0.27-0.22-0.66-0.1-0.28 0.08-0.59 0.17-0.94 0.25-0.34 0.08-0.65 0.15-0.92 0.19-0.55 0.09-0.97-0.01-1.27-0.29-0.3-0.29-0.55-0.68-0.75-1.18-0.34-0.75-0.73-1.79-1.18-3.1-0.45-1.32-0.94-2.8-1.48-4.46l-4.64-14.24c-0.12-0.39-0.1-0.65 0.07-0.77 0.14-0.11 0.34-0.21 0.57-0.31 0.24-0.11 0.5-0.2 0.77-0.29 0.42-0.15 0.98-0.24 1.69-0.27 0.7-0.02 1.48 0.14 2.32 0.5 1.26 0.62 2.18 1.39 2.74 2.31 0.57 0.93 0.94 1.71 1.1 2.35 0.53 1.86 0.45 3.47-0.24 4.83-0.68 1.37-1.55 2.23-2.62 2.6-0.37 0.12-0.62 0.23-0.75 0.34s-0.17 0.24-0.12 0.38c0.05 0.11 0.13 0.18 0.23 0.19s0.21 0 0.31-0.01c0.1-0.02 0.23-0.05 0.38-0.09 0.15-0.05 0.28-0.09 0.38-0.12 2.56-0.88 4.39-2.37 5.49-4.46 1.09-2.09 1.25-4.42 0.46-7.01-0.34-0.95-0.81-1.73-1.43-2.35-0.61-0.62-1.19-1.06-1.73-1.31-0.35-0.24-1.1-0.44-2.25-0.61s-2.83 0.08-5.04 0.74c-0.84 0.28-1.71 0.58-2.63 0.91-0.91 0.34-1.75 0.63-2.5 0.88-0.53 0.16-1.28 0.39-2.24 0.67-0.97 0.28-1.94 0.58-2.92 0.89-0.27 0.08-0.46 0.17-0.57 0.26s-0.15 0.19-0.11 0.31c0.04 0.13 0.12 0.19 0.24 0.21 0.12 0.01 0.28-0.02 0.47-0.08 0.26-0.09 0.52-0.16 0.79-0.23 0.26-0.06 0.47-0.1 0.64-0.12 0.61-0.07 1.07 0.02 1.39 0.27s0.58 0.67 0.8 1.26c0.19 0.47 0.44 1.18 0.77 2.16 0.32 0.97 0.91 2.76 1.76 5.37l2.04 6.27zm16.57-9.55c0.92 2 2.3 3.69 4.14 5.06 1.84 1.38 4.02 2.2 6.56 2.46l-2.69 1.24c-0.66 0.31-1.32 0.5-1.96 0.58-0.65 0.08-1.2-0.01-1.65-0.27-0.18-0.11-0.4-0.28-0.65-0.53-0.25-0.24-0.51-0.56-0.78-0.96-0.12-0.17-0.22-0.28-0.31-0.33-0.09-0.06-0.19-0.06-0.3 0-0.13 0.06-0.18 0.16-0.16 0.29 0.03 0.12 0.08 0.27 0.17 0.44 0.14 0.3 0.4 0.8 0.79 1.51s0.78 1.41 1.18 2.1 0.69 1.16 0.88 1.39c0.29 0.38 0.58 0.56 0.88 0.53 0.29-0.02 0.74-0.18 1.36-0.49 1.35-0.63 2.81-1.32 4.37-2.07s2.74-1.32 3.54-1.71c0.36-0.13 0.57-0.2 0.63-0.22 0.07-0.02 0.26-0.11 0.59-0.26 0.1-0.05 0.15-0.11 0.15-0.19s-0.03-0.18-0.09-0.3l-0.75-1.63c-2.34-0.2-4.56-1.22-6.64-3.03-2.09-1.82-3.69-3.92-4.82-6.32-0.72-1.5-1.18-3.17-1.4-5s0.05-3.6 0.81-5.29c0.77-1.7 2.27-3.09 4.51-4.19 3.22-1.37 6.01-1.33 8.37 0.15 2.36 1.47 4.23 3.74 5.61 6.8 1.46 3.27 2.05 6 1.76 8.21s-1.05 4.19-2.28 5.94l0.75 1.63c0.05 0.12 0.11 0.21 0.17 0.26s0.14 0.05 0.24 0c0.33-0.15 0.52-0.24 0.58-0.27 0.06-0.04 0.25-0.15 0.58-0.34 0.82-0.36 2.02-0.89 3.6-1.59s3.05-1.36 4.4-1.99c0.64-0.27 1.06-0.51 1.26-0.72 0.21-0.2 0.27-0.54 0.17-1.01-0.06-0.32-0.23-0.86-0.5-1.61-0.26-0.76-0.54-1.51-0.83-2.25-0.29-0.75-0.5-1.26-0.63-1.55-0.08-0.17-0.16-0.31-0.24-0.42-0.08-0.1-0.18-0.12-0.32-0.06-0.11 0.05-0.18 0.12-0.19 0.23-0.02 0.1 0 0.25 0.05 0.45 0.13 0.46 0.21 0.88 0.24 1.27 0.03 0.38 0 0.72-0.09 1.01-0.16 0.52-0.5 0.99-1.03 1.4-0.52 0.4-1.15 0.78-1.89 1.11l-2.62 1.21c1.23-2.32 2.01-4.64 2.33-6.94s-0.03-4.6-1.05-6.9c-1.69-3.59-4.13-5.97-7.31-7.11-3.18-1.15-6.83-0.81-10.94 1.02-2.06 0.95-3.99 2.38-5.77 4.28-1.79 1.91-3.01 4.15-3.69 6.72-0.67 2.57-0.37 5.32 0.91 8.26z"/>
					</svg>
				</fo:instream-foreign-object>
			</fo:block>
		</fo:block-container>
		<!-- grey opacity -->
		<fo:block-container absolute-position="fixed" left="0" top="0">
			<fo:block>
				<fo:instream-foreign-object content-height="{$pageHeight}" fox:alt-text="Background color">
					<svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="215.9mm" height="279.4mm">
						<rect width="215.9mm" height="279.4mm" style="fill:rgb(255,255,255);stroke-width:0;fill-opacity:0.73"/>
						</svg>
					</fo:instream-foreign-object>
				</fo:block>
			</fo:block-container>
	</xsl:template>
	
	<xsl:template name="splitTitle">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:if test="string-length($pText) &gt; 0">
		<item>
			<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
		</item>
		<xsl:call-template name="splitTitle">
			<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
			<xsl:with-param name="sep" select="$sep"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="splitByParts">
		<xsl:param name="items"/>
		<xsl:param name="start" select="1"/>
		<xsl:param name="mergeEach"/>
		<xsl:if test="xalan:nodeset($items)/item[$start]">
			<part>
				<xsl:for-each select="xalan:nodeset($items)/item[position() &gt;= $start and position() &lt;  ($start + $mergeEach)]">
					<xsl:value-of select="."/><xsl:text> </xsl:text>
				</xsl:for-each>
			</part>
		</xsl:if>
		<xsl:if test="$start &lt;= count(xalan:nodeset($items)/item)">
			<xsl:call-template name="splitByParts">
				<xsl:with-param name="items" select="$items"/>
				<xsl:with-param name="start" select="$start + $mergeEach"/>
				<xsl:with-param name="mergeEach" select="$mergeEach"/>
			</xsl:call-template>
		</xsl:if>		
	</xsl:template>

	<xsl:template match="node()" mode="change_id">
		<xsl:param name="lang"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="change_id">
				<xsl:with-param name="lang" select="$lang"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*" mode="change_id">
		<xsl:param name="lang"/>
		<xsl:choose>
			<xsl:when test="local-name() = 'id' or                local-name() = 'bibitemid' or               (local-name() = 'target' and local-name(..) = 'xref')">
				<xsl:attribute name="{local-name()}">
					<xsl:value-of select="."/>_<xsl:value-of select="$lang"/>
				</xsl:attribute>
			</xsl:when>			
			<xsl:otherwise>				
				<xsl:copy>
					<xsl:apply-templates select="@*" mode="change_id">
						<xsl:with-param name="lang" select="$lang"/>
					</xsl:apply-templates>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
<xsl:variable name="titles" select="xalan:nodeset($titles_)"/><xsl:variable name="titles_">
				
		<title-annex lang="en">Annex </title-annex>
		<title-annex lang="fr">Annexe </title-annex>
		
			<title-annex lang="zh">Annex </title-annex>
		
		
				
		<title-edition lang="en">
			
				<xsl:text>Edition </xsl:text>
			
			
		</title-edition>
		
		<title-edition lang="fr">
			
				<xsl:text>Édition </xsl:text>
			
		</title-edition>
		

		<title-toc lang="en">
			
				<xsl:text>Contents</xsl:text>
			
			
			
		</title-toc>
		<title-toc lang="fr">
			
			
				<xsl:text>Table des matières</xsl:text>
			
			</title-toc>
		
			<title-toc lang="zh">Contents</title-toc>
		
		
		
		<title-page lang="en">Page</title-page>
		<title-page lang="fr">Page</title-page>
		
		<title-key lang="en">Key</title-key>
		<title-key lang="fr">Légende</title-key>
			
		<title-where lang="en">where</title-where>
		<title-where lang="fr">où</title-where>
					
		<title-descriptors lang="en">Descriptors</title-descriptors>
		
		<title-part lang="en">
			
			
		</title-part>
		<title-part lang="fr">
			
			
		</title-part>		
		<title-part lang="zh">第 # 部分:</title-part>
		
		<title-modified lang="en">modified</title-modified>
		<title-modified lang="fr">modifiée</title-modified>
		
			<title-modified lang="zh">modified</title-modified>
		
		
		
		<title-source lang="en">
			
				<xsl:text>SOURCE</xsl:text>
						
			 
		</title-source>
		
		<title-keywords lang="en">Keywords</title-keywords>
		
		<title-deprecated lang="en">DEPRECATED</title-deprecated>
		<title-deprecated lang="fr">DEPRECATED</title-deprecated>
				
		<title-list-tables lang="en">List of Tables</title-list-tables>
		
		<title-list-figures lang="en">List of Figures</title-list-figures>
		
		<title-list-recommendations lang="en">List of Recommendations</title-list-recommendations>
		
		<title-acknowledgements lang="en">Acknowledgements</title-acknowledgements>
		
		<title-abstract lang="en">Abstract</title-abstract>
		
		<title-summary lang="en">Summary</title-summary>
		
		<title-in lang="en">in </title-in>
		
		<title-partly-supercedes lang="en">Partly Supercedes </title-partly-supercedes>
		<title-partly-supercedes lang="zh">部分代替 </title-partly-supercedes>
		
		<title-completion-date lang="en">Completion date for this manuscript</title-completion-date>
		<title-completion-date lang="zh">本稿完成日期</title-completion-date>
		
		<title-issuance-date lang="en">Issuance Date: #</title-issuance-date>
		<title-issuance-date lang="zh"># 发布</title-issuance-date>
		
		<title-implementation-date lang="en">Implementation Date: #</title-implementation-date>
		<title-implementation-date lang="zh"># 实施</title-implementation-date>

		<title-obligation-normative lang="en">normative</title-obligation-normative>
		<title-obligation-normative lang="zh">规范性附录</title-obligation-normative>
		
		<title-caution lang="en">CAUTION</title-caution>
		<title-caution lang="zh">注意</title-caution>
			
		<title-warning lang="en">WARNING</title-warning>
		<title-warning lang="zh">警告</title-warning>
		
		<title-amendment lang="en">AMENDMENT</title-amendment>
		
		<title-continued lang="en">(continued)</title-continued>
		<title-continued lang="fr">(continué)</title-continued>
		
	</xsl:variable><xsl:variable name="tab_zh">　</xsl:variable><xsl:template name="getTitle">
		<xsl:param name="name"/>
		<xsl:param name="lang"/>
		<xsl:variable name="lang_">
			<xsl:choose>
				<xsl:when test="$lang != ''">
					<xsl:value-of select="$lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="language" select="normalize-space($lang_)"/>
		<xsl:variable name="title_" select="$titles/*[local-name() = $name][@lang = $language]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($title_) != ''">
				<xsl:value-of select="$title_"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$titles/*[local-name() = $name][@lang = 'en']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable><xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable><xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/><xsl:variable name="linebreak" select="'&#8232;'"/><xsl:attribute-set name="root-style">
		
			<xsl:attribute name="font-family">Times New Roman, STIX Two Math, HanSans</xsl:attribute>
			<xsl:attribute name="font-size">10.5pt</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="link-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		
		
		
		
		
				
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="permission-style">
		
	</xsl:attribute-set><xsl:attribute-set name="permission-name-style">
		
	</xsl:attribute-set><xsl:attribute-set name="permission-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-name-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-subject-style">
	</xsl:attribute-set><xsl:attribute-set name="requirement-inherit-style">
	</xsl:attribute-set><xsl:attribute-set name="recommendation-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="recommendation-name-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="recommendation-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="termexample-style">
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-style">
		
		
		
		
		
		
		
		
		
		
		
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="example-body-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-name-style">
		
		
		
		
		
		
		
		
		
		
		
		
		
		
				
		
		
		
			<xsl:attribute name="font-style">italic</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="example-p-style">
		
		
		
		
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termexample-name-style">
		
		
		
				
	</xsl:attribute-set><xsl:attribute-set name="table-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		
		
		
		
				
		
		
		
				
		
		
		
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">25mm</xsl:attribute>
			<xsl:attribute name="text-indent">-25mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>			
		
	</xsl:attribute-set><xsl:attribute-set name="appendix-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="appendix-example-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="xref-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="eref-style">
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="note-style">
		
		
		
				
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:variable name="note-body-indent">10mm</xsl:variable><xsl:variable name="note-body-indent-table">5mm</xsl:variable><xsl:attribute-set name="note-name-style">
		
		
		
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="note-p-style">
		
		
		
				
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termnote-style">
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termnote-name-style">		
				
	</xsl:attribute-set><xsl:attribute-set name="quote-style">		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="quote-source-style">		
		
				
				
	</xsl:attribute-set><xsl:attribute-set name="termsource-style">
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="origin-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="term-style">
		
	</xsl:attribute-set><xsl:attribute-set name="figure-name-style">
				
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
	</xsl:attribute-set><xsl:attribute-set name="formula-style">
		
	</xsl:attribute-set><xsl:attribute-set name="image-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="figure-pseudocode-p-style">
		
	</xsl:attribute-set><xsl:attribute-set name="image-graphic-style">
		
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>
		
		
		
				

	</xsl:attribute-set><xsl:attribute-set name="tt-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="domain-style">
				
	</xsl:attribute-set><xsl:attribute-set name="admitted-style">
		
	
	</xsl:attribute-set><xsl:attribute-set name="deprecates-style">
		
	</xsl:attribute-set><xsl:attribute-set name="definition-style">
		
		
	</xsl:attribute-set><xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" mode="contents"/>
	</xsl:template><xsl:template name="processMainSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']" mode="contents"/>			
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']" mode="contents"/>	
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |                       /*/*[local-name()='sections']/*[local-name()='definitions'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]" mode="contents"/>		
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and                                                local-name() != 'definitions' and                                                not(@type='scope') and                                               not(local-name() = 'clause' and .//*[local-name()='terms']) and                                               not(local-name() = 'clause' and .//*[local-name()='definitions'])]" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']" mode="contents"/>		
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]" mode="contents"/>
	</xsl:template><xsl:template name="processPrefaceSectionsDefault">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']"/>
	</xsl:template><xsl:template name="processMainSectionsDefault">			
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']"/>
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']"/>
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |                       /*/*[local-name()='sections']/*[local-name()='definitions'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]"/>
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and                                                local-name() != 'definitions' and                                                not(@type='scope') and                                               not(local-name() = 'clause' and .//*[local-name()='terms']) and                                               not(local-name() = 'clause' and .//*[local-name()='definitions'])]"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']"/>
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]"/>
	</xsl:template><xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="*[local-name()='br']">
		<xsl:value-of select="$linebreak"/>
	</xsl:template><xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text() | *[local-name()='dt']//text() | *[local-name()='dd']//text()" priority="1">
		<!-- <xsl:call-template name="add-zero-spaces"/> -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template><xsl:template match="*[local-name()='table']">
	
		<xsl:variable name="simple-table">	
			<xsl:call-template name="getSimpleTable"/>			
		</xsl:variable>
	
		
		
		
		
		
			<fo:block> </fo:block>				
		
		
		<!-- $namespace = 'iso' or  -->
		
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
		
				
		
			<xsl:call-template name="fn_name_display"/>
		
			
		
		<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
		
		<!-- <xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="*[local-name()='thead']">
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="*[local-name()='tbody']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable> -->
		<!-- cols-count=<xsl:copy-of select="$cols-count"/> -->
		<!-- cols-count2=<xsl:copy-of select="$cols-count2"/> -->
		
		
		
		<xsl:variable name="colwidths">
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="table" select="$simple-table"/>
			</xsl:call-template>
		</xsl:variable>
		<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
		
		<!-- <xsl:variable name="colwidths2">
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
			</xsl:call-template>
		</xsl:variable> -->
		
		<!-- cols-count=<xsl:copy-of select="$cols-count"/>
		colwidthsNew=<xsl:copy-of select="$colwidths"/>
		colwidthsOld=<xsl:copy-of select="$colwidths2"/>z -->
		
		<xsl:variable name="margin-left">
			<xsl:choose>
				<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<fo:block-container margin-left="-{$margin-left}mm" margin-right="-{$margin-left}mm">			
			
			
						
						
						
			
			
									
			
			
			
			
			
				<xsl:attribute name="space-after">12pt</xsl:attribute>
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
				<xsl:attribute name="margin-right">0mm</xsl:attribute>
				<xsl:if test="not(ancestor::*[local-name()='note'])">
					<xsl:attribute name="font-size">10pt</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			
			
			
			<xsl:variable name="table_attributes">
				<attribute name="table-layout">fixed</attribute>
				<attribute name="width">100%</attribute>
				<attribute name="margin-left"><xsl:value-of select="$margin-left"/>mm</attribute>
				<attribute name="margin-right"><xsl:value-of select="$margin-left"/>mm</attribute>
				
				
				
				
								
								
								
				
								
									
					<xsl:if test="not(ancestor::*[local-name()='preface']) and not(ancestor::*[local-name()='note'])">
						<attribute name="border-top">0.5pt solid black</attribute>
						<attribute name="border-bottom">0.5pt solid black</attribute>
					</xsl:if>
					<attribute name="margin-left">0mm</attribute>
					<attribute name="margin-right">0mm</attribute>					
				
			</xsl:variable>
			
			
			<fo:table id="{@id}" table-omit-footer-at-break="true">
				
				<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">					
					<xsl:attribute name="{@name}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				
				<xsl:variable name="isNoteOrFnExist" select="./*[local-name()='note'] or .//*[local-name()='fn'][local-name(..) != 'name']"/>				
				<xsl:if test="$isNoteOrFnExist = 'true'">
					<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute> <!-- set 0pt border, because there is a separete table below for footer  -->
				</xsl:if>
				
				<xsl:for-each select="xalan:nodeset($colwidths)//column">
					<xsl:choose>
						<xsl:when test=". = 1 or . = 0">
							<fo:table-column column-width="proportional-column-width(2)"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="proportional-column-width({.})"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				
				<xsl:choose>
					<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
						<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
				
			</fo:table>
			
			<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
				<xsl:call-template name="insertTableFooterInSeparateTable">
					<xsl:with-param name="table_attributes" select="$table_attributes"/>
					<xsl:with-param name="colwidths" select="$colwidths"/>				
				</xsl:call-template>
			</xsl:for-each>
			
			<!-- insert footer as table -->
			<!-- <fo:table>
				<xsl:for-each select="xalan::nodeset($table_attributes)/attribute">
					<xsl:attribute name="{@name}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				
				<xsl:for-each select="xalan:nodeset($colwidths)//column">
					<xsl:choose>
						<xsl:when test=". = 1 or . = 0">
							<fo:table-column column-width="proportional-column-width(2)"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="proportional-column-width({.})"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</fo:table>-->
			
			
			
			
			
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name() = 'name']"/><xsl:template match="*[local-name()='table']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="table-name-style">
				
				<xsl:apply-templates/>				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row"/>
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans" select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template><xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:choose>
					<xsl:when test="not($table)"><!-- this branch is not using in production, for debug only -->
						<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
						</xsl:for-each>
						<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
							
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($table)//tr">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="td[$curr-col]" mode="td_text"/>
								
								<!-- <xsl:if test="$namespace = 'bipm'">
									<xsl:for-each select="*[local-name()='td'][$curr-col]//*[local-name()='math']">									
										<word><xsl:value-of select="normalize-space(.)"/></word>
									</xsl:for-each>
								</xsl:if> -->
								
							</xsl:variable>
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​', ' '))"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="td[$curr-col]/@divide">
											<xsl:value-of select="td[$curr-col]/@divide"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$max_length div $divider"/>
							</width>
							
						</xsl:for-each>
					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			
			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template match="text()" mode="td_text">
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:value-of select="translate(., $zero-space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name()='termsource']" mode="td_text">
		<xsl:value-of select="*[local-name()='origin']/@citeas"/>
	</xsl:template><xsl:template match="*[local-name()='link']" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template><xsl:template match="*[local-name()='math']" mode="td_text">
		<xsl:variable name="math_text" select="normalize-space(.)"/>
		<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
	</xsl:template><xsl:template match="*[local-name()='table2']"/><xsl:template match="*[local-name()='thead']"/><xsl:template match="*[local-name()='thead']" mode="process">
		<xsl:param name="cols-count"/>
		<!-- font-weight="bold" -->
		<fo:table-header>
			
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template><xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>		
		<!-- row for title -->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black">
				<xsl:apply-templates select="ancestor::*[local-name()='table']/*[local-name()='name']" mode="presentation"/>
				<xsl:for-each select="ancestor::*[local-name()='table'][1]">
					<xsl:call-template name="fn_name_display"/>
				</xsl:for-each>				
				<fo:block text-align="right" font-style="italic">
					<xsl:text> </xsl:text>
					<fo:retrieve-table-marker retrieve-class-name="table_continued"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='thead']" mode="process_tbody">		
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template><xsl:template match="*[local-name()='tfoot']"/><xsl:template match="*[local-name()='tfoot']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template name="insertTableFooter">
		<xsl:param name="cols-count"/>
		<xsl:if test="../*[local-name()='tfoot']">
			<fo:table-footer>			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template><xsl:template name="insertTableFooter2">
		<xsl:param name="cols-count"/>
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		<xsl:if test="../*[local-name()='tfoot'] or           $isNoteOrFnExist = 'true'">
		
			<fo:table-footer>
			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
				
				<!-- if there are note(s) or fn(s) then create footer row -->
				<xsl:if test="$isNoteOrFnExist = 'true'">
				
					
				
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							
							
							
							<!-- fn will be processed inside 'note' processing -->
							
							
							
								<xsl:attribute name="border">solid black 0pt</xsl:attribute>
							
							<!-- except gb and bipm -->
							
							
							
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">
										<!-- show Note under table in preface (ex. abstract) sections -->
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>
										<!-- empty, because notes show at page side in main sections -->
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							
							
							
							<!-- horizontal row separator -->
							
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display"/>
							
						</fo:table-cell>
					</fo:table-row>
					
				</xsl:if>
			</fo:table-footer>
		
		</xsl:if>
	</xsl:template><xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		
		<xsl:if test="$isNoteOrFnExist = 'true'">
		
			<xsl:variable name="cols-count" select="count(xalan:nodeset($colwidths)//column)"/>
			
			<fo:table keep-with-previous="always">
				<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">
					<xsl:choose>
						<xsl:when test="@name = 'border-top'">
							<xsl:attribute name="{@name}">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:when test="@name = 'border'">
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				
				<xsl:for-each select="xalan:nodeset($colwidths)//column">
					<xsl:choose>
						<xsl:when test=". = 1 or . = 0">
							<fo:table-column column-width="proportional-column-width(2)"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="proportional-column-width({.})"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							
							
							
							<!-- fn will be processed inside 'note' processing -->
							
							
							
								<xsl:attribute name="border">solid black 0pt</xsl:attribute>
							
							<!-- except gb and bipm -->
							
							
							
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">
										<!-- show Note under table in preface (ex. abstract) sections -->
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>
										<!-- empty, because notes show at page side in main sections -->
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							
							
							
							<!-- horizontal row separator -->
							
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display"/>
							
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
				
			</fo:table>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name()='tbody']">
		
		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../*[local-name()='thead']">					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:apply-templates select="../*[local-name()='thead']" mode="process">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>
		
		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>
		
		<fo:table-body>
			

			<xsl:apply-templates/>
			<!-- <xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/> -->
		
		</fo:table-body>
		
	</xsl:template><xsl:template match="*[local-name()='tr']">
		<xsl:variable name="parent-name" select="local-name(..)"/>
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:table-row min-height="4mm">
				<xsl:if test="$parent-name = 'thead'">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					
					
					
					
					
				</xsl:if>
				<xsl:if test="$parent-name = 'tfoot'">
					
					
				</xsl:if>
				
				
				
				
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='th']">
		<fo:table-cell text-align="{@align}" font-weight="bold" border="solid black 1pt" padding-left="1mm" display-align="center">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>center</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			
			
			
			
			
			
			
			
			
			
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:attribute name="border">solid black 0pt</xsl:attribute>				
				<xsl:attribute name="border-top">solid black 0.5pt</xsl:attribute>
				<xsl:attribute name="border-bottom">solid black 0.5pt</xsl:attribute>
				<xsl:attribute name="height">8mm</xsl:attribute>
				<xsl:attribute name="padding-top">2mm</xsl:attribute>
			
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template name="display-align">
		<xsl:if test="@valign">
			<xsl:attribute name="display-align">
				<xsl:choose>
					<xsl:when test="@valign = 'top'">before</xsl:when>
					<xsl:when test="@valign = 'middle'">center</xsl:when>
					<xsl:when test="@valign = 'bottom'">after</xsl:when>
					<xsl:otherwise>before</xsl:otherwise>
				</xsl:choose>					
			</xsl:attribute>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name()='td']">
		<fo:table-cell text-align="{@align}" display-align="center" border="solid black 1pt" padding-left="1mm">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			
			
			
			
			
			
			
			
			
			
				<xsl:attribute name="border">solid 0pt white</xsl:attribute>
				<xsl:variable name="rownum"><xsl:number count="*[local-name()='tr']"/></xsl:variable>
				<xsl:if test="$rownum = 1">
					<xsl:attribute name="padding-top">3mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="not(ancestor::*[local-name()='tr']/following-sibling::*[local-name()='tr'])"> <!-- last row -->
					<xsl:attribute name="padding-bottom">2mm</xsl:attribute>
				</xsl:if>
			
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			<fo:block>								
				<xsl:apply-templates/>
			</fo:block>			
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='note']" priority="2"/><xsl:template match="*[local-name()='table']/*[local-name()='note']" mode="process">
		
		
			<fo:block font-size="10pt" margin-bottom="12pt">
				
				
				
				
									
					<xsl:attribute name="text-align">justify</xsl:attribute>
					<xsl:attribute name="margin-top">18pt</xsl:attribute>
				
				
				<fo:inline padding-right="2mm">
					
					
					
					
						<xsl:attribute name="font-size">10pt</xsl:attribute>						
						<xsl:attribute name="text-decoration">underline</xsl:attribute>
					
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						
				</fo:inline>
				
					<fo:block> </fo:block>
				
				<xsl:apply-templates mode="process"/>
			</fo:block>
		
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='name']" mode="process"/><xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='p']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template name="fn_display">
		<xsl:variable name="references">
			<xsl:for-each select="..//*[local-name()='fn'][local-name(..) != 'name']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					
					
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
				<fo:block margin-bottom="12pt">
					
					
					
					
					
						<xsl:attribute name="font-size">9pt</xsl:attribute>
						<xsl:attribute name="text-indent">-6.5mm</xsl:attribute>
						<xsl:attribute name="margin-left">6.5mm</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					
					<fo:inline font-size="80%" padding-right="5mm" id="{@id}">
						
						
						
						
						
						
						
							<xsl:attribute name="font-style">italic</xsl:attribute>
							
							<xsl:attribute name="padding-right">2.5mm</xsl:attribute>
							<fo:inline font-style="normal">(</fo:inline>
						
						<xsl:value-of select="@reference"/>
						
							<fo:inline font-style="normal">)</fo:inline>
						
						
					</fo:inline>
					<fo:inline>
						
						<!-- <xsl:apply-templates /> -->
						<xsl:copy-of select="./node()"/>
					</fo:inline>
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template name="fn_name_display">
		<!-- <xsl:variable name="references">
			<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		$references=<xsl:copy-of select="$references"/> -->
		<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:for-each>
	</xsl:template><xsl:template name="fn_display_figure">
		<xsl:variable name="key_iso">
			 <!-- and (not(@class) or @class !='pseudocode') -->
		</xsl:variable>
		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn'][not(parent::*[local-name()='name'])]">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- current hierarchy is 'figure' element -->
		<xsl:variable name="following_dl_colwidths">
			<xsl:if test="*[local-name() = 'dl']"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
				<xsl:variable name="html-table">
					<xsl:variable name="doc_ns">
						bipm
					</xsl:variable>
					<xsl:variable name="ns">
						<xsl:choose>
							<xsl:when test="normalize-space($doc_ns)  != ''">
								<xsl:value-of select="normalize-space($doc_ns)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-before(name(/*), '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
					<xsl:element name="{$ns}:table">
						<xsl:for-each select="*[local-name() = 'dl'][1]">
							<tbody>
								<xsl:apply-templates mode="dl"/>
							</tbody>
						</xsl:for-each>
					</xsl:element>
				</xsl:variable>
				
				<xsl:call-template name="calculate-column-widths">
					<xsl:with-param name="cols-count" select="2"/>
					<xsl:with-param name="table" select="$html-table"/>
				</xsl:call-template>
				
			</xsl:if>
		</xsl:variable>
		
		
		<xsl:variable name="maxlength_dt">
			<xsl:for-each select="*[local-name() = 'dl'][1]">
				<xsl:call-template name="getMaxLength_dt"/>			
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:if test="xalan:nodeset($references)//fn">
			<fo:block>
				<fo:table width="95%" table-layout="fixed">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
						
					</xsl:if>
					<xsl:choose>
						<!-- if there 'dl', then set same columns width -->
						<xsl:when test="xalan:nodeset($following_dl_colwidths)//column">
							<xsl:call-template name="setColumnWidth_dl">
								<xsl:with-param name="colwidths" select="$following_dl_colwidths"/>								
								<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>								
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="15%"/>
							<fo:table-column column-width="85%"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:table-body>
						<xsl:for-each select="xalan:nodeset($references)//fn">
							<xsl:variable name="reference" select="@reference"/>
							<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@id}">
												
												<xsl:value-of select="@reference"/>
											</fo:inline>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block text-align="justify" margin-bottom="12pt">
											
											<xsl:if test="normalize-space($key_iso) = 'true'">
												<xsl:attribute name="margin-bottom">0</xsl:attribute>
											</xsl:if>
											
											<!-- <xsl:apply-templates /> -->
											<xsl:copy-of select="./node()"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
		
	</xsl:template><xsl:template match="*[local-name()='fn']">
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:inline font-size="80%" keep-with-previous.within-line="always">
			
			
			
			
			
			
				<xsl:attribute name="font-size">70%</xsl:attribute>
				<xsl:attribute name="vertical-align">super</xsl:attribute>
				<xsl:attribute name="font-style">italic</xsl:attribute>
			
			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="{@reference}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->
				
				
					<fo:inline font-style="normal"> (</fo:inline>
				
				<xsl:value-of select="@reference"/>
				
					<fo:inline font-style="normal">)</fo:inline>
				
			</fo:basic-link>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='fn']/*[local-name()='p']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='dl']">
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<fo:block-container margin-left="0mm">
	
				<xsl:variable name="parent" select="local-name(..)"/>
				
				<xsl:variable name="key_iso">
					 <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="$parent = 'formula' and count(*[local-name()='dt']) = 1"> <!-- only one component -->
						
						
							<fo:block margin-bottom="12pt" text-align="left">
								
								<xsl:variable name="title-where">
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-where'"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="$title-where"/><xsl:text> </xsl:text>
								<xsl:apply-templates select="*[local-name()='dt']/*"/>
								<xsl:text/>
								<xsl:apply-templates select="*[local-name()='dd']/*" mode="inline"/>
							</fo:block>
						
					</xsl:when>
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">
							
							
							
							
							<xsl:variable name="title-where">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-where'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-where"/>
						</fo:block>
					</xsl:when>
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')">
						<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">
							
							
							
							<xsl:variable name="title-key">
								<xsl:call-template name="getTitle">
									<xsl:with-param name="name" select="'title-key'"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-key"/>
						</fo:block>
					</xsl:when>
				</xsl:choose>
				
				<!-- a few components -->
				<xsl:if test="not($parent = 'formula' and count(*[local-name()='dt']) = 1)">
					<fo:block>
						
						
						
						
						<fo:block>
							
							
							
							
							<fo:table width="95%" table-layout="fixed">
								
								<xsl:choose>
									<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'">
										<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
									</xsl:when>
									<xsl:when test="normalize-space($key_iso) = 'true'">
										<xsl:attribute name="font-size">10pt</xsl:attribute>
										
									</xsl:when>
								</xsl:choose>
								<!-- create virtual html table for dl/[dt and dd] -->
								<xsl:variable name="html-table">
									<xsl:variable name="doc_ns">
										bipm
									</xsl:variable>
									<xsl:variable name="ns">
										<xsl:choose>
											<xsl:when test="normalize-space($doc_ns)  != ''">
												<xsl:value-of select="normalize-space($doc_ns)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring-before(name(/*), '-')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
									<xsl:element name="{$ns}:table">
										<tbody>
											<xsl:apply-templates mode="dl"/>
										</tbody>
									</xsl:element>
								</xsl:variable>
								<!-- html-table<xsl:copy-of select="$html-table"/> -->
								<xsl:variable name="colwidths">
									<xsl:call-template name="calculate-column-widths">
										<xsl:with-param name="cols-count" select="2"/>
										<xsl:with-param name="table" select="$html-table"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- colwidths=<xsl:value-of select="$colwidths"/> -->
								<xsl:variable name="maxlength_dt">							
									<xsl:call-template name="getMaxLength_dt"/>							
								</xsl:variable>
								<xsl:call-template name="setColumnWidth_dl">
									<xsl:with-param name="colwidths" select="$colwidths"/>							
									<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
								</xsl:call-template>
								<fo:table-body>
									<xsl:apply-templates>
										<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
									</xsl:apply-templates>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:block>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>		
		<xsl:param name="maxlength_dt"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name()='dl']"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 2"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="5%"/>
						<fo:table-column column-width="95%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 5"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="10%"/>
						<fo:table-column column-width="90%"/>
					</xsl:when>
					<!-- <xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.7">
						<fo:table-column column-width="60%"/>
						<fo:table-column column-width="40%"/>
					</xsl:when> -->
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.3">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
					</xsl:when>
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 0.5">
						<fo:table-column column-width="40%"/>
						<fo:table-column column-width="60%"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($colwidths)//column">
							<xsl:choose>
								<xsl:when test=". = 1 or . = 0">
									<fo:table-column column-width="proportional-column-width(2)"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="proportional-column-width({.})"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <fo:table-column column-width="15%"/>
				<fo:table-column column-width="85%"/> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getMaxLength_dt">
		<xsl:for-each select="*[local-name()='dt']">
			<xsl:sort select="string-length(normalize-space(.))" data-type="number" order="descending"/>
			<xsl:if test="position() = 1">
				<xsl:value-of select="string-length(normalize-space(.))"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template match="*[local-name()='dl']/*[local-name()='note']" priority="2">
		<xsl:param name="key_iso"/>
		
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='dt']" mode="dl">
		<tr>
			<td>
				<xsl:apply-templates/>
			</td>
			<td>
				
				
					<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
				
			</td>
		</tr>
		
	</xsl:template><xsl:template match="*[local-name()='dt']">
		<xsl:param name="key_iso"/>
		
		<fo:table-row>
			
			<fo:table-cell>
				
				<fo:block margin-top="6pt">
					
					
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
						
					</xsl:if>
					
					
					
					
					
					
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					
					<xsl:apply-templates/>
					<!-- <xsl:if test="$namespace = 'gb'">
						<xsl:if test="ancestor::*[local-name()='formula']">
							<xsl:text>—</xsl:text>
						</xsl:if>
					</xsl:if> -->
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					
					<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
						<xsl:if test="local-name(*[1]) != 'stem'">
							<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
						</xsl:if>
					</xsl:if> -->
					
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="local-name(*[1]) = 'stem'">
				<fo:table-row>
				<fo:table-cell>
					<fo:block margin-top="6pt">
						<xsl:if test="normalize-space($key_iso) = 'true'">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>
						<xsl:text>&#xA0;</xsl:text>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell>
					<fo:block>
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>
			</xsl:if>
		</xsl:if> -->
	</xsl:template><xsl:template match="*[local-name()='dd']" mode="dl"/><xsl:template match="*[local-name()='dd']" mode="dl_process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='dd']"/><xsl:template match="*[local-name()='dd']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='dd']/*[local-name()='p']" mode="inline">
		<fo:inline><xsl:text> </xsl:text><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name()='em']">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='strong'] | *[local-name()='b']">
		<fo:inline font-weight="bold">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='sup']">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='sub']">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='tt']">
		<fo:inline xsl:use-attribute-sets="tt-style">
			<xsl:variable name="_font-size">
				
				
				
				
				
				
				
				
				
				
				
				
				
						
			</xsl:variable>
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='del']">
		<fo:inline font-size="10pt" color="red" text-decoration="line-through">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="text()[ancestor::*[local-name()='smallcap']]">
		<xsl:variable name="text" select="normalize-space(.)"/>
		<fo:inline font-size="75%">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:call-template name="recursiveSmallCaps">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:if>
			</fo:inline> 
	</xsl:template><xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div 0.75}%">
          <xsl:value-of select="$upperCase"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$upperCase"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($text) &gt; 1">
      <xsl:call-template name="recursiveSmallCaps">
        <xsl:with-param name="text" select="substring($text,2)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template><xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
					<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
					<xsl:variable name="len_str">
						<xsl:choose>
							<xsl:when test="normalize-space(translate($text, $upper, '')) = ''"> <!-- english word in CAPITAL letters -->
								<xsl:value-of select="$len_str_tmp * 1.5"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$len_str_tmp"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable> 
					
					<!-- <xsl:if test="$len_str_no_en_chars div $len_str &gt; 0.8">
						<xsl:message>
							div=<xsl:value-of select="$len_str_no_en_chars div $len_str"/>
							len_str=<xsl:value-of select="$len_str"/>
							len_str_no_en_chars=<xsl:value-of select="$len_str_no_en_chars"/>
						</xsl:message>
					</xsl:if> -->
					<!-- <len_str_no_en_chars><xsl:value-of select="$len_str_no_en_chars"/></len_str_no_en_chars>
					<len_str><xsl:value-of select="$len_str"/></len_str> -->
					<xsl:choose>
						<xsl:when test="$len_str_no_en_chars div $len_str &gt; 0.8"> <!-- means non-english string -->
							<xsl:value-of select="$len_str - $len_str_no_en_chars"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$len_str"/>
						</xsl:otherwise>
					</xsl:choose>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))"/>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template name="add-zero-spaces-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| )','$1​')"/>
	</xsl:template><xsl:template name="add-zero-spaces">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-chars">-</xsl:variable>
		<xsl:variable name="zero-space-after-dot">.</xsl:variable>
		<xsl:variable name="zero-space-after-colon">:</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space-after-underscore">_</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-chars)">
				<xsl:value-of select="substring-before($text, $zero-space-after-chars)"/>
				<xsl:value-of select="$zero-space-after-chars"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-chars)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-dot)">
				<xsl:value-of select="substring-before($text, $zero-space-after-dot)"/>
				<xsl:value-of select="$zero-space-after-dot"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-dot)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-colon)">
				<xsl:value-of select="substring-before($text, $zero-space-after-colon)"/>
				<xsl:value-of select="$zero-space-after-colon"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-colon)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-underscore)">
				<xsl:value-of select="substring-before($text, $zero-space-after-underscore)"/>
				<xsl:value-of select="$zero-space-after-underscore"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-underscore)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getSimpleTable">
		<xsl:variable name="simple-table">
		
			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>
			
			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			
			<xsl:copy-of select="xalan:nodeset($simple-table-rowspan)"/>
					
			<!-- <xsl:choose>
				<xsl:when test="current()//*[local-name()='th'][@colspan] or current()//*[local-name()='td'][@colspan] ">
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="current()"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template><xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template><xsl:template match="*[local-name()='fn']" mode="simple-table-colspan"/><xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="td">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="td">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="@colspan" mode="simple-table-colspan"/><xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<xsl:element name="tr">
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</xsl:element>
	</xsl:template><xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template><xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>
		
		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template><xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template><xsl:template match="tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="tr[1]"/>
				<xsl:apply-templates select="tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="tr[1]"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template><xsl:template match="tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="."/>
	
		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//td">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1"/>
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]"/>
												<xsl:copy-of select="node()"/>
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/td[1 + count(current()/preceding-sibling::td[not(@rowspan) or (@rowspan = 1)])]"/>
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*"/>
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)"/>
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow"/>

		<xsl:apply-templates select="following-sibling::tr[1]" mode="simple-table-rowspan">
				<xsl:with-param name="previousRow" select="$newRow"/>
		</xsl:apply-templates>
	</xsl:template><xsl:template name="getLang">
		<xsl:variable name="language" select="//*[local-name()='bibdata']//*[local-name()='language']"/>
		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="capitalizeWords">
		<xsl:param name="str"/>
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<!-- <xsl:value-of select="translate(substring($substr, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($substr, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="translate(substring($str2, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($str2, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$str2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="capitalize">
		<xsl:param name="str"/>
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(substring($str, 1, 1)))"/>
		<xsl:value-of select="substring($str, 2)"/>		
	</xsl:template><xsl:template match="mathml:math">
		<fo:inline font-family="STIX Two Math"> <!--  -->
			<xsl:variable name="mathml">
				<xsl:apply-templates select="." mode="mathml"/>
			</xsl:variable>
			<fo:instream-foreign-object fox:alt-text="Math">
				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy-of select="xalan:nodeset($mathml)"/>
			</fo:instream-foreign-object>			
		</fo:inline>
	</xsl:template><xsl:template match="@*|node()" mode="mathml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
	</xsl:template><xsl:template match="mathml:mtext" mode="mathml">
		<xsl:copy>
			<!-- replace start and end spaces to non-break space -->
			<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'(^ )|( $)',' ')"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name()='localityStack']"/><xsl:template match="*[local-name()='link']" name="link">
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
					<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="link-style">
			<xsl:choose>
				<xsl:when test="$target = ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<fo:basic-link external-destination="{@target}" fox:alt-text="{@target}">
						<xsl:choose>
							<xsl:when test="normalize-space(.) = ''">
								<xsl:value-of select="$target"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:basic-link>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='bookmark']">
		<fo:inline id="{@id}"/>
	</xsl:template><xsl:template match="*[local-name()='appendix']">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="*[local-name()='title']" mode="process"/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='appendix']/*[local-name()='title']"/><xsl:template match="*[local-name()='appendix']/*[local-name()='title']" mode="process">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name()='appendix']//*[local-name()='example']" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'callout']">		
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates/>&gt;</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'annotation']">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>		
		<fo:block id="{$annotation-id}" white-space="nowrap">			
			<fo:inline>				
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>		
	</xsl:template><xsl:template match="*[local-name() = 'annotation']/*[local-name() = 'p']">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::*[local-name() = 'p'])"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates/>
		</fo:inline>		
	</xsl:template><xsl:template match="*[local-name() = 'modification']">
		<xsl:variable name="title-modified">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-modified'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:text>—</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:text> — </xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'xref']">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
			
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'formula']" name="formula">
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<fo:block-container margin-left="0mm">	
				<fo:block id="{@id}" xsl:use-attribute-sets="formula-style">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'dt']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'admitted']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'note']" name="note">
	
		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style">
			
			
			
			
			<fo:block-container margin-left="0mm">
				
				
				
				
				
				

				
					<fo:block>
						
						
						
						
						<fo:inline xsl:use-attribute-sets="note-name-style">
							<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						</fo:inline>
						<xsl:apply-templates/>
					</fo:block>
				
				
			</fo:block-container>
		</fo:block-container>
		
	</xsl:template><xsl:template match="*[local-name() = 'note']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1">
				<fo:inline xsl:use-attribute-sets="note-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style">						
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">			
			<fo:inline xsl:use-attribute-sets="termnote-name-style">
				<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
			</fo:inline>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'note']/*[local-name() = 'name'] |               *[local-name() = 'termnote']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'note']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					
						<xsl:text>:</xsl:text>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'terms']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'term']">
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">
			
			
			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline>
				<xsl:apply-templates/>
				<!-- <xsl:if test="$namespace = 'gb' or $namespace = 'ogc'">
					<xsl:text>.</xsl:text>
				</xsl:if> -->
			</fo:inline>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'figure']">
		<fo:block-container id="{@id}">
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="*[local-name() = 'note']">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']//*[local-name() = 'p']">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'image']">
		<fo:block xsl:use-attribute-sets="image-style">
			
			
			<xsl:variable name="src">
				<xsl:choose>
					<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
						<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@src"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" xsl:use-attribute-sets="image-graphic-style"/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="contents">		
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="bookmarks">		
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template><xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template><xsl:template match="*[local-name() = 'stem']" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'stem']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template><xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)//item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($contents)/doc">
						<xsl:choose>
							<xsl:when test="count(xalan:nodeset($contents)/doc) &gt; 1">
								<xsl:for-each select="xalan:nodeset($contents)/doc">
									<fo:bookmark internal-destination="{contents/item[1]/@id}" starting-state="hide">
										<fo:bookmark-title>
											<xsl:variable name="bookmark-title_">
												<xsl:call-template name="getLangVersion">
													<xsl:with-param name="lang" select="@lang"/>
												</xsl:call-template>
											</xsl:variable>
											<xsl:choose>
												<xsl:when test="normalize-space($bookmark-title_) != ''">
													<xsl:value-of select="normalize-space($bookmark-title_)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="@lang = 'en'">English</xsl:when>
														<xsl:when test="@lang = 'fr'">Français</xsl:when>
														<xsl:when test="@lang = 'de'">Deutsche</xsl:when>
														<xsl:otherwise><xsl:value-of select="@lang"/> version</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</fo:bookmark-title>
										<xsl:apply-templates select="contents/item" mode="bookmark"/>
									</fo:bookmark>
									
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="xalan:nodeset($contents)/doc">
									<xsl:apply-templates select="contents/item" mode="bookmark"/>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="xalan:nodeset($contents)/contents/item" mode="bookmark"/>				
					</xsl:otherwise>
				</xsl:choose>
				
				
				
				
				
				
				
				
			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template><xsl:template name="getLangVersion">
		<xsl:param name="lang"/>
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				
				English version
				</xsl:when>
			<xsl:when test="$lang = 'fr'">
				
				Version française
			</xsl:when>
			<xsl:when test="$lang = 'de'">Deutsche</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/> version</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="item" mode="bookmark">
		<fo:bookmark internal-destination="{@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:if test="@section != ''">
						<xsl:value-of select="@section"/> 
						<xsl:text> </xsl:text>
					</xsl:if>
					<xsl:value-of select="normalize-space(title)"/>
				</fo:bookmark-title>
				<xsl:apply-templates mode="bookmark"/>				
		</fo:bookmark>
	</xsl:template><xsl:template match="title" mode="bookmark"/><xsl:template match="text()" mode="bookmark"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |         *[local-name() = 'image']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">			
			<fo:block xsl:use-attribute-sets="figure-name-style">
				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'fn']" priority="2"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note']"/><xsl:template match="*[local-name() = 'title']" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template><xsl:template name="getSection">
		<xsl:value-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
	</xsl:template><xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'title']/*[local-name() = 'tab']">
				<xsl:copy-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="*[local-name() = 'title']/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="insertTitleAsListItem">
		<xsl:param name="provisional-distance-between-starts" select="'9.5mm'"/>
		<xsl:variable name="section">						
			<xsl:for-each select="..">
				<xsl:call-template name="getSection"/>
			</xsl:for-each>
		</xsl:variable>							
		<fo:list-block provisional-distance-between-starts="{$provisional-distance-between-starts}">						
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<xsl:value-of select="$section"/>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>						
						<xsl:choose>
							<xsl:when test="*[local-name() = 'tab']">
								<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template><xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="*[local-name() = 'tab']">
					<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'fn']" mode="contents"/><xsl:template match="*[local-name() = 'fn']" mode="bookmarks"/><xsl:template match="*[local-name() = 'fn']" mode="contents_item"/><xsl:template match="*[local-name() = 'tab']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'strong']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template><xsl:template match="*[local-name() = 'br']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name()='sourcecode']" name="sourcecode">
	
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<fo:block-container margin-left="0mm">
	
				<fo:block xsl:use-attribute-sets="sourcecode-style">
					<xsl:variable name="_font-size">
						
												
						
						
						
						
						
								
						
						
						
												
						
								
				</xsl:variable>
				<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
				<xsl:if test="$font-size != ''">
					<xsl:attribute name="font-size">
						<xsl:choose>
							<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
							<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
					<xsl:apply-templates/>			
				</fo:block>
				<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='sourcecode']/text()" priority="2">
		<xsl:variable name="text">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:call-template name="add-zero-spaces-java">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template><xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">		
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'permission']">
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="permission-name-style">
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']">
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='label']" mode="presentation"/>
			<xsl:apply-templates select="@obligation" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='subject']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="requirement-name-style">
				
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/@obligation" mode="presentation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'inherit']">
		<fo:block xsl:use-attribute-sets="requirement-inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']">
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="recommendation-name-style">
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt">
			<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">	
						<xsl:call-template name="getSimpleTable"/>			
					</xsl:variable>					
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<!-- <fo:table-column column-width="35mm"/>
						<fo:table-column column-width="115mm"/> -->
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:for-each select="*[local-name() = 'tbody']">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="fn_display"/>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='thead']" mode="requirement">		
		<fo:table-header>			
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template><xsl:template match="*[local-name()='tbody']" mode="requirement">		
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template><xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">			
			<xsl:if test="parent::*[local-name()='thead']"> <!-- and not(ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']) -->
				<!-- <xsl:attribute name="border">1pt solid black</xsl:attribute> -->
				<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Requirement ')">
				<xsl:attribute name="background-color">rgb(252, 246, 222)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Recommendation ')">
				<xsl:attribute name="background-color">rgb(233, 235, 239)</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(165, 165, 165)</xsl:attribute>				
			</xsl:if>
			<xsl:if test="ancestor::*[local-name()='table']/@type = 'recommendtest'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>				
			</xsl:if> -->
			
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:if test="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>				 
				<xsl:if test="parent::*[local-name()='tr']/preceding-sibling::*[local-name()='tr'] and not(*[local-name()='table'])">
					<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>					
				</xsl:if>
			</xsl:if> -->
			<!-- 2nd line and below -->
			
			<fo:block>			
				<xsl:apply-templates/>
			</fo:block>			
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name() = 'p'][@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt" color="rgb(237, 193, 35)"> <!-- font-weight="bold" margin-bottom="4pt" text-align="center"  -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'p2'][ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block> <!-- margin-bottom="10pt" -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:apply-templates/>
			</fo:inline>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'example']">
		<fo:block id="{@id}" xsl:use-attribute-sets="example-style">
			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			
			<xsl:variable name="element">
				block				
				
				<xsl:if test=".//*[local-name() = 'table']">block</xsl:if> 
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="contains(normalize-space($element), 'block')">
					<fo:block xsl:use-attribute-sets="example-body-style">
						<xsl:apply-templates/>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<fo:inline>
						<xsl:apply-templates/>
					</fo:inline>
				</xsl:otherwise>
			</xsl:choose>
			
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']" mode="presentation">

		<xsl:variable name="element">
			block
			
		</xsl:variable>		
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'appendix']">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="normalize-space($element) = 'block'">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template><xsl:template match="*[local-name() = 'example']/*[local-name() = 'p']">
	
		<xsl:variable name="element">
			block
			
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="normalize-space($element) = 'block'">
				<fo:block xsl:use-attribute-sets="example-p-style">
					
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>					
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template><xsl:template match="*[local-name() = 'termsource']">
		<fo:block xsl:use-attribute-sets="termsource-style">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->			
			<xsl:variable name="termsource_text">
				<xsl:apply-templates/>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>					
					
						<xsl:text>[</xsl:text>
					
					<xsl:apply-templates/>					
					
						<xsl:text>]</xsl:text>
					
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termsource']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'origin']">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			
				<fo:inline>
					
					<xsl:call-template name="getTitle">
						<xsl:with-param name="name" select="'title-source'"/>
					</xsl:call-template>
					<xsl:text>: </xsl:text>
				</fo:inline>
			
			<fo:inline xsl:use-attribute-sets="origin-style">
				<xsl:apply-templates/>
			</fo:inline>
			</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'modification']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'modification']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'quote']">		
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:if test="not(ancestor::*[local-name() = 'table'])">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			<fo:block-container margin-left="0mm">
		
				<fo:block xsl:use-attribute-sets="quote-style">
					<xsl:apply-templates select=".//*[local-name() = 'p']"/>
				</fo:block>
				<xsl:if test="*[local-name() = 'author'] or *[local-name() = 'source']">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="*[local-name() = 'author']"/>
						<xsl:apply-templates select="*[local-name() = 'source']"/>				
					</fo:block>
				</xsl:if>
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'source']">
		<xsl:if test="../*[local-name() = 'author']">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'author']">
		<xsl:text>— </xsl:text>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'eref']">
		<fo:inline xsl:use-attribute-sets="eref-style">
			<xsl:if test="@type = 'footnote'">
				
					<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
					<xsl:attribute name="font-size">80%</xsl:attribute>
					<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
					<xsl:attribute name="vertical-align">super</xsl:attribute>
									
				
			</xsl:if>	
		
			<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
					
				<xsl:if test="@type = 'inline'">
					
						<xsl:attribute name="color">blue</xsl:attribute>
						<xsl:attribute name="text-decoration">underline</xsl:attribute>
					
					
					
				</xsl:if>
			
			
				<xsl:apply-templates/>
			</fo:basic-link>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'tab']">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="padding">
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
				<xsl:choose>
					<xsl:when test="ancestor::bipm:annex">2</xsl:when>
					<xsl:otherwise>8</xsl:otherwise>
				</xsl:choose>
			
		</xsl:variable>
		
		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($padding)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="language" select="//*[local-name()='bibdata']//*[local-name()='language']"/>
		
		<xsl:choose>
			<xsl:when test="$language = 'zh'">
				<fo:inline><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline padding-right="{$padding-right}mm">​</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'domain']">
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'admitted']">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'deprecates']">
		<xsl:variable name="title-deprecated">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-deprecated'"/>
			</xsl:call-template>
		</xsl:variable>
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:value-of select="$title-deprecated"/>: <xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definition']">
		<fo:block xsl:use-attribute-sets="definition-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]/*[local-name() = 'p']">
		<fo:inline> <xsl:apply-templates/></fo:inline>
		<fo:block> </fo:block>
	</xsl:template><xsl:template match="/*/*[local-name() = 'sections']/*" priority="2">
		
		<fo:block>
			<xsl:call-template name="setId"/>
			
			
			
			
						
			
						
			
			
			
			<xsl:apply-templates/>
		</fo:block>
		
		
		
	</xsl:template><xsl:template match="/*/*[local-name() = 'preface']/*" priority="2">
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'clause']">
		<fo:block>
			<xsl:call-template name="setId"/>			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definitions']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="/*/*[local-name() = 'bibliography']/*[local-name() = 'references'][@normative='true']">
		
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'annex']">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">
			
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'review']">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template><xsl:template match="*[local-name() = 'ul'] | *[local-name() = 'ol']">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'note']">
				<fo:block-container>
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					
					<fo:block-container margin-left="0mm">
						<fo:block>
							<xsl:apply-templates select="." mode="ul_ol"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:apply-templates select="." mode="ul_ol"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'errata']">
		<!-- <row>
					<date>05-07-2013</date>
					<type>Editorial</type>
					<change>Changed CA-9 Priority Code from P1 to P2 in <xref target="tabled2"/>.</change>
					<pages>D-3</pages>
				</row>
		-->
		<fo:table table-layout="fixed" width="100%" font-size="10pt" border="1pt solid black">
			<fo:table-column column-width="20mm"/>
			<fo:table-column column-width="23mm"/>
			<fo:table-column column-width="107mm"/>
			<fo:table-column column-width="15mm"/>
			<fo:table-body>
				<fo:table-row font-family="Arial" text-align="center" font-weight="bold" background-color="black" color="white">
					<fo:table-cell border="1pt solid black"><fo:block>Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates/>
			</fo:table-body>
		</fo:table>
	</xsl:template><xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template name="processBibitem">
		 
		
		
		 
	</xsl:template><xsl:template name="processBibitemDocId">
		<xsl:variable name="_doc_ident" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($_doc_ident) != ''">
				<xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]/@type"/>
				<xsl:if test="$type != '' and not(contains($_doc_ident, $type))">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="$_doc_ident"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]/@type"/>
				<xsl:if test="$type != ''">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="processPersonalAuthor">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'completename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'completename']"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'initial']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'initial']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'forename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'forename']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="renderDate">		
			<xsl:if test="normalize-space(*[local-name() = 'on']) != ''">
				<xsl:value-of select="*[local-name() = 'on']"/>
			</xsl:if>
			<xsl:if test="normalize-space(*[local-name() = 'from']) != ''">
				<xsl:value-of select="concat(*[local-name() = 'from'], '–', *[local-name() = 'to'])"/>
			</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'name']/*[local-name() = 'initial']/text()" mode="strip">
		<xsl:value-of select="translate(.,'. ','')"/>
	</xsl:template><xsl:template match="*[local-name() = 'name']/*[local-name() = 'forename']/text()" mode="strip">
		<xsl:value-of select="substring(.,1,1)"/>
	</xsl:template><xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'">January</xsl:when>
				<xsl:when test="$month = '02'">February</xsl:when>
				<xsl:when test="$month = '03'">March</xsl:when>
				<xsl:when test="$month = '04'">April</xsl:when>
				<xsl:when test="$month = '05'">May</xsl:when>
				<xsl:when test="$month = '06'">June</xsl:when>
				<xsl:when test="$month = '07'">July</xsl:when>
				<xsl:when test="$month = '08'">August</xsl:when>
				<xsl:when test="$month = '09'">September</xsl:when>
				<xsl:when test="$month = '10'">October</xsl:when>
				<xsl:when test="$month = '11'">November</xsl:when>
				<xsl:when test="$month = '12'">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $day, ', ' , $year))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template><xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="/*/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="/*/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="insertKeyword">
		<xsl:param name="charAtEnd"/>
		<xsl:param name="charDelim"/>
		<xsl:apply-templates/>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="addPDFUAmeta">
		<fo:declarations>
			<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
					<pdf:dictionary type="normal" key="ViewerPreferences">
						<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
					</pdf:dictionary>
				</pdf:catalog>
			<x:xmpmeta xmlns:x="adobe:ns:meta/">
				<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
					<rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/" rdf:about="">
					<!-- Dublin Core properties go here -->
						<dc:title>
							<xsl:variable name="title">
								
								
									<xsl:value-of select="//*[local-name() = 'bibdata'][@type='standard']/*[local-name() = 'title'][@language = 'en' and @type = 'main']"/>
								
								
								
																
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="normalize-space($title) != ''">
									<xsl:value-of select="$title"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text> </xsl:text>
								</xsl:otherwise>
							</xsl:choose>							
						</dc:title>
						<dc:creator>
							
							
								<xsl:value-of select="//*[local-name() = 'bibdata'][@type='standard']/*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']/*[local-name() = 'organization']/*[local-name() = 'name']"/>
							
							
						</dc:creator>
						<dc:description>
							<xsl:variable name="abstract">
								
								
								
								
								
									<xsl:copy-of select="//*[local-name() = 'bibdata'][@type='standard']/*[local-name() = 'abstract']//text()"/>									
								
							</xsl:variable>
							<xsl:value-of select="normalize-space($abstract)"/>
						</dc:description>
						<pdf:Keywords>
							<xsl:call-template name="insertKeywords"/>
						</pdf:Keywords>
					</rdf:Description>
					<rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about="">
						<!-- XMP properties go here -->
						<xmp:CreatorTool/>
					</rdf:Description>
				</rdf:RDF>
			</x:xmpmeta>
		</fo:declarations>
	</xsl:template><xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="concat(local-name(..), '_', text())"/> -->
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getLevel">
		<xsl:param name="depth"/>
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*)"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="parent::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<!-- <xsl:when test="parent::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when> -->
						<xsl:when test="ancestor::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'bibliography']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="local-name() = 'annex'">1</xsl:when>
						<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$level_total - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$level"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:if test="string-length($pText) &gt;0">
		<item>
			<xsl:value-of select="normalize-space(substring-before(concat($pText, ','), $sep))"/>
		</item>
		<xsl:call-template name="split">
			<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
			<xsl:with-param name="sep" select="$sep"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="getDocumentId">		
		<xsl:call-template name="getLang"/><xsl:value-of select="//*[local-name() = 'p'][1]/@id"/>
	</xsl:template><xsl:template name="namespaceCheck">
		<xsl:variable name="documentNS" select="namespace-uri(/*)"/>
		<xsl:variable name="XSLNS">			
			
			
			
			
			
			
			
			
			
			
						
			
			
			
				<xsl:value-of select="document('')//*/namespace::bipm"/>
			
		</xsl:variable>
		<xsl:if test="$documentNS != $XSLNS">
			<xsl:message>[WARNING]: Document namespace: '<xsl:value-of select="$documentNS"/>' doesn't equal to xslt namespace '<xsl:value-of select="$XSLNS"/>'</xsl:message>
		</xsl:if>
	</xsl:template><xsl:template name="getLanguage">
		<xsl:param name="lang"/>		
		<xsl:variable name="language" select="java:toLowerCase(java:java.lang.String.new($lang))"/>
		<xsl:choose>
			<xsl:when test="$language = 'en'">English</xsl:when>
			<xsl:when test="$language = 'fr'">French</xsl:when>
			<xsl:when test="$language = 'de'">Deutsch</xsl:when>
			<xsl:when test="$language = 'cn'">Chinese</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="setId">
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id()"/>
				</xsl:otherwise>
			</xsl:choose>					
		</xsl:attribute>
	</xsl:template><xsl:template name="add-letter-spacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm">
				<xsl:if test="$char = '®'">
					<xsl:attribute name="font-size">58%</xsl:attribute>
					<xsl:attribute name="baseline-shift">30%</xsl:attribute>
				</xsl:if>				
				<xsl:value-of select="$char"/>
			</fo:inline>
			<xsl:call-template name="add-letter-spacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template></xsl:stylesheet>