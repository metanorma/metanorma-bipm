require "spec_helper"

RSpec.describe IsoDoc::Bipm do
  it "processes footnotes" do
    mock_uuid_increment
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata>
      <title><fn reference="43"><p>C</p></fn></title>
      </bibdata>
      <boilerplate>
      <copyright-statement>
      <clause><title><fn reference="44"><p>D</p></fn><</title>
      </clause>
      </copyright-statement>
      </boilerplate>
          <preface>
          <foreword id="F"><title>Foreword</title>
          <p>A.<fn reference="2">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Formerly denoted as 15 % (m/m).</p>
      </fn></p>
          <p>B.<fn reference="2">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Formerly denoted as 15 % (m/m).</p>
      </fn></p>
          <p>C.<fn reference="1">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Hello! denoted as 15 % (m/m).</p>
      </fn></p>
          </foreword>
          </preface>
          <sections>
          <clause id="A">
          <title>BB<fn reference="45">
          <p id="_1e228e29-baef-4f38-b048-b05a051747e5">Fourth footnote.</p>
      </fn></title>
      <clause id="AA">
          <p>A.<fn reference="42">
          <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Third footnote.</p>
      </fn></p>
          <p>B.<fn reference="2">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Formerly denoted as 15 % (m/m).</p>
      </fn></p>
      </clause>
      <clause id="AB">
        <p>A.<fn reference="42">
          <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Third footnote.</p>
      </fn></p>
          <p>B.<fn reference="2">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">Formerly denoted as 15 % (m/m).</p>
      </fn></p>
      </clause>
          </clause>
          </sections>
          <bibliography>
          <references id="_normative_references" obligation="informative" normative="true">
          <title>Normative References</title>
          <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
      <bibitem id="ISO712" type="standard">
        <title format="text/plain">Cereals or cereal products</title>
        <title type="main" format="text/plain">Cereals and cereal products<fn reference="7">
        <p id="_1e228e29-baef-4f38-b048-b05a051747e4">ISO is a standards organisation.</p>
      </fn></title>
        <docidentifier type="ISO">ISO 712</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
          </organization>
        </contributor>
      </bibitem>
      </references>
      </bibliography>
          </iso-standard>
    INPUT
    presxml = <<~INPUT
<?xml version="1.0"?>
<iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
<bibdata>
<title><fn reference="1" id="_" original-reference="43" target="_"><p>C</p><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></title>
<fmt-footnote-container><fmt-fn-body id="_" target="_" reference="1"><semx element="fn" source="_"><p><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>C</p></semx></fmt-fn-body></fmt-footnote-container></bibdata>
<boilerplate>
<copyright-statement>
<clause id="_"><title id="_"><fn reference="1" original-id="_" original-reference="44" id="_" target="_"><p>D</p><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></title><fmt-title depth="1" id="_"><semx element="title" source="_"><fn reference="1" id="_" original-reference="44" target="_"><p>D</p><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></semx></fmt-title>
<fmt-footnote-container><fmt-fn-body id="_" target="" reference="1"><semx element="fn" source="_"><p><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>D</p></semx></fmt-fn-body></fmt-footnote-container></clause>
</copyright-statement>
</boilerplate>
    <preface><clause type="toc" id="_" displayorder="1"><fmt-title depth="1" id="_">Contents</fmt-title></clause>

    <foreword id="F" displayorder="2"><title id="_">Foreword</title><fmt-title depth="1" id="_"><semx element="title" source="_">Foreword</semx></fmt-title>
    <p>A.<fn reference="1" id="_" original-reference="2" target="_">
  <p original-id="_">Formerly denoted as 15 % (m/m).</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
    <p>B.<fn reference="1" id="_" original-reference="2" target="_">
  <p id="_">Formerly denoted as 15 % (m/m).</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
    <p>C.<fn reference="2" id="_" original-reference="1" target="_">
  <p original-id="_">Hello! denoted as 15 % (m/m).</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">2</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
    <fmt-footnote-container><fmt-fn-body id="_" target="_" reference="1"><semx element="fn" source="_">
  <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Formerly denoted as 15 % (m/m).</p>
</semx></fmt-fn-body><fmt-fn-body id="_" target="_" reference="2"><semx element="fn" source="_">
  <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">2</semx><span class="fmt-label-delim">)</span></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Hello! denoted as 15 % (m/m).</p>
</semx></fmt-fn-body></fmt-footnote-container></foreword>
    </preface>
    <sections>
    <clause id="A" displayorder="3">
    <title id="_">BB<fn reference="1" original-id="_" original-reference="45" id="_" target="_">
    <p original-id="_">Fourth footnote.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></title><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A">1</semx><span class="fmt-clause-delim">.</span></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_">BB<fn reference="1" id="_" original-reference="45" target="_">
    <p id="_">Fourth footnote.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></semx></fmt-title><fmt-xref-label><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="A">1</semx></fmt-xref-label>
<clause id="AA"><fmt-title depth="2" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="AA">1</semx><span class="fmt-clause-delim">.</span></span></fmt-title><fmt-xref-label><span class="fmt-element-name">Section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="AA">1</semx></fmt-xref-label>
    <p>A.<fn reference="1" id="_" original-reference="42" target="_">
    <p original-id="_">Third footnote.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
    <p>B.<fn reference="2" id="_" original-reference="2" target="_">
  <p original-id="_">Formerly denoted as 15 % (m/m).</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">2</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
<fmt-footnote-container><fmt-fn-body id="_" target="_" reference="1"><semx element="fn" source="_">
    <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Third footnote.</p>
</semx></fmt-fn-body><fmt-fn-body id="_" target="_" reference="2"><semx element="fn" source="_">
  <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">2</semx><span class="fmt-label-delim">)</span></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Formerly denoted as 15 % (m/m).</p>
</semx></fmt-fn-body></fmt-footnote-container></clause>
<clause id="AB"><fmt-title depth="2" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="AB">2</semx><span class="fmt-clause-delim">.</span></span></fmt-title><fmt-xref-label><span class="fmt-element-name">Section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="AB">2</semx></fmt-xref-label>
  <p>A.<fn reference="1" id="_" original-reference="42" target="_">
    <p original-id="_">Third footnote.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
    <p>B.<fn reference="2" id="_" original-reference="2" target="_">
  <p original-id="_">Formerly denoted as 15 % (m/m).</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">2</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
<fmt-footnote-container><fmt-fn-body id="_" target="_" reference="1"><semx element="fn" source="_">
    <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Third footnote.</p>
</semx></fmt-fn-body><fmt-fn-body id="_" target="_" reference="2"><semx element="fn" source="_">
  <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">2</semx><span class="fmt-label-delim">)</span></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Formerly denoted as 15 % (m/m).</p>
</semx></fmt-fn-body></fmt-footnote-container></clause>
    <fmt-footnote-container><fmt-fn-body id="_" target="" reference="1"><semx element="fn" source="_">
    <p original-id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Fourth footnote.</p>
</semx></fmt-fn-body></fmt-footnote-container></clause>
    <references id="_normative_references" obligation="informative" normative="true" displayorder="4">
    <title id="_">Normative References</title><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="_">2</semx><span class="fmt-clause-delim">.</span></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_">Normative References</semx></fmt-title><fmt-xref-label><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="_">2</semx></fmt-xref-label>
    <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
<bibitem id="ISO712" type="standard"><biblio-tag>ISO&#xA0;712 </biblio-tag><formattedref><em>Cereals and cereal products<fn reference="1" id="_" original-reference="7" target="_">
 <p original-id="_">ISO is a standards organisation.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></em></formattedref>
  <title format="text/plain">Cereals or cereal products</title>
  <title type="main" format="text/plain">Cereals and cereal products<fn reference="1" id="_" original-reference="7" target="_">
  <p id="_">ISO is a standards organisation.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></title>
  <docidentifier type="ISO">ISO&#xA0;712</docidentifier><docidentifier scope="biblio-tag">ISO&#xA0;712</docidentifier>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>International Organization for Standardization</name>
    </organization>
  </contributor>
</bibitem>
<fmt-footnote-container><fmt-fn-body id="_" target="_" reference="1"><semx element="fn" source="_">
 <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><span class="fmt-label-delim">(</span><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>ISO is a standards organisation.</p>
</semx></fmt-fn-body></fmt-footnote-container></references></sections>
    <bibliography>
    
</bibliography>
    </iso-standard>
    INPUT

    output = <<~OUTPUT
  <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><div class="authority">
  <div class="boilerplate-copyright">
  <div id="_"><h1><a class="FootnoteRef" href="#fn:_"><sup>(1)</sup></a></h1>
  <aside id="fn:_" class="footnote"><p>D</p></aside></div>
  </div>
  </div><br/><div id="_" class="TOC"><h1 class="IntroTitle">Contents</h1></div><br/><div id="F"><h1 class="ForewordTitle">Foreword</h1><p>A.<a class="FootnoteRef" href="#fn:_"><sup>(1)</sup></a></p><p>B.<a class="FootnoteRef" href="#fn:_"><sup>(1)</sup></a></p><p>C.<a class="FootnoteRef" href="#fn:_"><sup>(2)</sup></a></p><aside id="fn:_" class="footnote">
    <p id="_">Formerly denoted as 15 % (m/m).</p>
  </aside><aside id="fn:_" class="footnote">
    <p id="_">Hello! denoted as 15 % (m/m).</p>
  </aside></div><div id="A"><h1>1<span class="fmt-clause-delim">.</span>  BB<a class="FootnoteRef" href="#fn:_"><sup>(1)</sup></a></h1><div id="AA"><h2>1.1<span class="fmt-clause-delim">.</span></h2>
      <p>A.<a class="FootnoteRef" href="#fn:_"><sup>(1)</sup></a></p>
      <p>B.<a class="FootnoteRef" href="#fn:_"><sup>(2)</sup></a></p>
  <aside id="fn:_" class="footnote">
      <p id="_">Third footnote.</p>
  </aside><aside id="fn:_" class="footnote">
    <p id="_">Formerly denoted as 15 % (m/m).</p>
  </aside></div><div id="AB"><h2>1.2<span class="fmt-clause-delim">.</span></h2>
    <p>A.<a class="FootnoteRef" href="#fn:_"><sup>(1)</sup></a></p>
      <p>B.<a class="FootnoteRef" href="#fn:_"><sup>(2)</sup></a></p>
  <aside id="fn:_" class="footnote">
      <p id="_">Third footnote.</p>
  </aside><aside id="fn:_" class="footnote">
    <p id="_">Formerly denoted as 15 % (m/m).</p>
  </aside></div><aside id="fn:_" class="footnote">
      <p>Fourth footnote.</p>
  </aside></div><div><h1>2<span class="fmt-clause-delim">.</span>  Normative References</h1>

      <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
  <p id="ISO712" class="NormRef">ISO 712 <i>Cereals and cereal products<a class="FootnoteRef" href="#fn:_"><sup>(1)</sup></a></i></p>
  <aside id="fn:_" class="footnote">
   <p id="_">ISO is a standards organisation.</p>
  </aside></div></div></body>
    OUTPUT
    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input, true)
    expect(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
      .to(be_xml_equivalent_to(presxml))
    expect(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"))).to(be_html5_equivalent_to(output))

    presxml = <<~OUTPUT
<?xml version="1.0"?>
<iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
<bibdata>
<title><fn reference="1" id="_" original-reference="43" target="_"><p>C</p><fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">1</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></title>
</bibdata>
<boilerplate>
<copyright-statement>
<clause id="_"><title id="_"><fn reference="2" original-id="_" original-reference="44" id="_" target="_"><p>D</p><fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">2</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></title><fmt-title depth="1" id="_"><semx element="title" source="_"><fn reference="2" id="_" original-reference="44" target="_"><p>D</p><fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">2</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></semx></fmt-title>
</clause>
</copyright-statement>
</boilerplate>
    <preface><clause type="toc" id="_" displayorder="1"><fmt-title depth="1" id="_">Contents</fmt-title></clause>

    <foreword id="F" displayorder="2"><title id="_">Foreword</title><fmt-title depth="1" id="_"><semx element="title" source="_">Foreword</semx></fmt-title>
    <p>A.<fn reference="3" id="_" original-reference="2" target="_">
  <p original-id="_">Formerly denoted as 15 % (m/m).</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">3</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
    <p>B.<fn reference="3" id="_" original-reference="2" target="_">
  <p id="_">Formerly denoted as 15 % (m/m).</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">3</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
    <p>C.<fn reference="4" id="_" original-reference="1" target="_">
  <p original-id="_">Hello! denoted as 15 % (m/m).</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">4</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
    </foreword>
    </preface>
    <bibdata>    <contributor>
    <role type="author">
       <description>committee</description>
    </role>
    <organization>
       <name>Bureau International des Poids et Mesures</name>
       <subdivision type="Committee">
          <name language="en">Joint Committee for Guides in Metrology</name>
          <identifier id="_">JCGM</identifier><fmt-identifier><tt><semx element="identifier" source="_">JCGM</semx></tt></fmt-identifier>
          <identifier type="full" id="_">JCGM</identifier><fmt-identifier><tt><semx element="identifier" source="_">JCGM</semx></tt></fmt-identifier>
       </subdivision>
    </organization>
</contributor>
</bibdata><sections>
    <clause id="A" displayorder="4">
    <title id="_">BB<fn reference="6" original-id="_" original-reference="45" id="_" target="_">
    <p original-id="_">Fourth footnote.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">6</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></title><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A">2</semx><span class="fmt-clause-delim">.</span></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_">BB<fn reference="6" id="_" original-reference="45" target="_">
    <p id="_">Fourth footnote.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">6</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></semx></fmt-title><fmt-xref-label><span class="fmt-element-name">Clause</span> <semx element="autonum" source="A">2</semx></fmt-xref-label>
<clause id="AA"><fmt-title depth="2" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A">2</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="AA">1</semx><span class="fmt-clause-delim">.</span></span></fmt-title><fmt-xref-label><semx element="autonum" source="A">2</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="AA">1</semx></fmt-xref-label>
    <p>A.<fn reference="7" id="_" original-reference="42" target="_">
    <p original-id="_">Third footnote.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">7</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
    <p>B.<fn reference="3" id="_" original-reference="2" target="_">
  <p id="_">Formerly denoted as 15 % (m/m).</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">3</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
</clause>
<clause id="AB"><fmt-title depth="2" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A">2</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="AB">2</semx><span class="fmt-clause-delim">.</span></span></fmt-title><fmt-xref-label><semx element="autonum" source="A">2</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="AB">2</semx></fmt-xref-label>
  <p>A.<fn reference="7" id="_" original-reference="42" target="_">
    <p id="_">Third footnote.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">7</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
    <p>B.<fn reference="3" id="_" original-reference="2" target="_">
  <p id="_">Formerly denoted as 15 % (m/m).</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">3</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></p>
</clause>
    </clause>
    <references id="_normative_references" obligation="informative" normative="true" displayorder="3">
    <title id="_">Normative References</title><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="_">1</semx><span class="fmt-clause-delim">.</span></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_">Normative References</semx></fmt-title><fmt-xref-label><span class="fmt-element-name">Clause</span> <semx element="autonum" source="_">1</semx></fmt-xref-label>
    <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
<bibitem id="ISO712" type="standard"><biblio-tag>ISO&#xA0;712 </biblio-tag><formattedref><em>Cereals and cereal products<fn reference="5" id="_" original-reference="7" target="_">
 <p original-id="_">ISO is a standards organisation.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">5</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></em></formattedref>
  <title format="text/plain">Cereals or cereal products</title>
  <title type="main" format="text/plain">Cereals and cereal products<fn reference="5" id="_" original-reference="7" target="_">
  <p id="_">ISO is a standards organisation.</p>
<fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">5</semx><span class="fmt-label-delim">)</span></sup></span></fmt-fn-label></fn></title>
  <docidentifier type="ISO">ISO&#xA0;712</docidentifier><docidentifier scope="biblio-tag">ISO&#xA0;712</docidentifier>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>International Organization for Standardization</name>
    </organization>
  </contributor>
</bibitem>
</references></sections>
    <bibliography>
    
</bibliography>
    <fmt-footnote-container><fmt-fn-body id="_" target="_" reference="1"><semx element="fn" source="_"><p><fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">1</semx></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>C</p></semx></fmt-fn-body><fmt-fn-body id="_" target="" reference="2"><semx element="fn" source="_"><p><fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">2</semx></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>D</p></semx></fmt-fn-body><fmt-fn-body id="_" target="_" reference="3"><semx element="fn" source="_">
  <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">3</semx></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Formerly denoted as 15 % (m/m).</p>
</semx></fmt-fn-body><fmt-fn-body id="_" target="_" reference="4"><semx element="fn" source="_">
  <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">4</semx></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Hello! denoted as 15 % (m/m).</p>
</semx></fmt-fn-body><fmt-fn-body id="_" target="_" reference="5"><semx element="fn" source="_">
 <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">5</semx></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>ISO is a standards organisation.</p>
</semx></fmt-fn-body><fmt-fn-body id="_" target="" reference="6"><semx element="fn" source="_">
    <p original-id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">6</semx></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Fourth footnote.</p>
</semx></fmt-fn-body><fmt-fn-body id="_" target="_" reference="7"><semx element="fn" source="_">
    <p id="_"><fmt-fn-label><span class="fmt-caption-label"><sup><semx element="autonum" source="_">7</semx></sup></span><span class="fmt-caption-delim"><tab/></span></fmt-fn-label>Third footnote.</p>
</semx></fmt-fn-body></fmt-footnote-container></iso-standard>
    OUTPUT
    output = <<~OUTPUT
<body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><div class="authority">
<div class="boilerplate-copyright">
<div id="_"><h1><a class="FootnoteRef" href="#fn:_"><sup>2)</sup></a></h1>
</div>
</div>
</div><br/><div id="_" class="TOC"><h1 class="IntroTitle">Contents</h1></div><br/><div id="F"><h1 class="ForewordTitle">Foreword</h1><p>A.<a class="FootnoteRef" href="#fn:_"><sup>3)</sup></a></p><p>B.<a class="FootnoteRef" href="#fn:_"><sup>3)</sup></a></p><p>C.<a class="FootnoteRef" href="#fn:_"><sup>4)</sup></a></p></div><div><h1>1<span class="fmt-clause-delim">.</span>  Normative References</h1>

    <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
<p id="ISO712" class="NormRef">ISO 712 <i>Cereals and cereal products<a class="FootnoteRef" href="#fn:_"><sup>5)</sup></a></i></p>
</div><div id="A"><h1>2<span class="fmt-clause-delim">.</span>  BB<a class="FootnoteRef" href="#fn:_"><sup>6)</sup></a></h1><div id="AA"><h2>2.1<span class="fmt-clause-delim">.</span></h2>
    <p>A.<a class="FootnoteRef" href="#fn:_"><sup>7)</sup></a></p>
    <p>B.<a class="FootnoteRef" href="#fn:_"><sup>3)</sup></a></p>
</div><div id="AB"><h2>2.2<span class="fmt-clause-delim">.</span></h2>
  <p>A.<a class="FootnoteRef" href="#fn:_"><sup>7)</sup></a></p>
    <p>B.<a class="FootnoteRef" href="#fn:_"><sup>3)</sup></a></p>
</div></div><aside id="fn:_" class="footnote"><p>C</p></aside><aside id="fn:_" class="footnote"><p>D</p></aside><aside id="fn:_" class="footnote">
  <p id="_">Formerly denoted as 15 % (m/m).</p>
</aside><aside id="fn:_" class="footnote">
  <p id="_">Hello! denoted as 15 % (m/m).</p>
</aside><aside id="fn:_" class="footnote">
 <p id="_">ISO is a standards organisation.</p>
</aside><aside id="fn:_" class="footnote">
    <p>Fourth footnote.</p>
</aside><aside id="fn:_" class="footnote">
    <p id="_">Third footnote.</p>
</aside></div></body>
    OUTPUT
    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
        .new(presxml_options)
        .convert("test",
                 input.sub("<sections>",
                           "<bibdata>#{jcgm_ext}</bibdata><sections>"),
                 true)
    expect(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
      .to(be_xml_equivalent_to(presxml))
    expect(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"))).to(be_html5_equivalent_to(output))
  end
end
