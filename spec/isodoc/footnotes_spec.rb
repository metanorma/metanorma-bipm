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
        <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <bibdata>
             <title>
                <fn reference="1" id="_1" original-reference="43" target="_">
                   <p>C</p>
                   <fmt-fn-label>
                      <span class="fmt-caption-label">
                         <sup>
                            <span class="fmt-label-delim">(</span>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-label-delim">)</span>
                         </sup>
                      </span>
                   </fmt-fn-label>
                </fn>
             </title>
             <fmt-footnote-container>
                <fmt-fn-body id="_21" target="_" reference="1">
                   <semx element="fn" source="_">
                      <p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                            <span class="fmt-caption-delim">
                               <tab/>
                            </span>
                         </fmt-fn-label>
                         C
                      </p>
                   </semx>
                </fmt-fn-body>
             </fmt-footnote-container>
          </bibdata>
          <boilerplate>
             <copyright-statement>
                <clause id="_2">
                   <title id="_14">
                      <fn reference="1" original-id="_" original-reference="44" id="_23" target="_">
                         <p>D</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </title>
                   <fmt-title depth="1" id="_33">
                      <semx element="title" source="_">
                         <fn reference="1" id="_3" original-reference="44" target="_">
                            <p>D</p>
                            <fmt-fn-label>
                               <span class="fmt-caption-label">
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">1</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </span>
                            </fmt-fn-label>
                         </fn>
                      </semx>
                   </fmt-title>
                   <fmt-footnote-container>
                      <fmt-fn-body id="_22" target="" reference="1">
                         <semx element="fn" source="_">
                            <p>
                               <fmt-fn-label>
                                  <span class="fmt-caption-label">
                                     <sup>
                                        <span class="fmt-label-delim">(</span>
                                        <semx element="autonum" source="_">1</semx>
                                        <span class="fmt-label-delim">)</span>
                                     </sup>
                                  </span>
                                  <span class="fmt-caption-delim">
                                     <tab/>
                                  </span>
                               </fmt-fn-label>
                               D
                            </p>
                         </semx>
                      </fmt-fn-body>
                   </fmt-footnote-container>
                </clause>
             </copyright-statement>
          </boilerplate>
          <preface>
             <clause type="toc" id="_13" displayorder="1">
                <fmt-title depth="1" id="_34">Contents</fmt-title>
             </clause>
             <foreword id="F" displayorder="2">
                <title id="_16">Foreword</title>
                <fmt-title depth="1" id="_35">
                   <semx element="title" source="_">Foreword</semx>
                </fmt-title>
                <p>
                   A.
                   <fn reference="1" id="_4" original-reference="2" target="_">
                      <p original-id="_">Formerly denoted as 15 % (m/m).</p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <span class="fmt-label-delim">(</span>
                               <semx element="autonum" source="_">1</semx>
                               <span class="fmt-label-delim">)</span>
                            </sup>
                         </span>
                      </fmt-fn-label>
                   </fn>
                </p>
                <p>
                   B.
                   <fn reference="1" id="_5" original-reference="2" target="_">
                      <p id="_">Formerly denoted as 15 % (m/m).</p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <span class="fmt-label-delim">(</span>
                               <semx element="autonum" source="_">1</semx>
                               <span class="fmt-label-delim">)</span>
                            </sup>
                         </span>
                      </fmt-fn-label>
                   </fn>
                </p>
                <p>
                   C.
                   <fn reference="2" id="_6" original-reference="1" target="_">
                      <p original-id="_">Hello! denoted as 15 % (m/m).</p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <span class="fmt-label-delim">(</span>
                               <semx element="autonum" source="_">2</semx>
                               <span class="fmt-label-delim">)</span>
                            </sup>
                         </span>
                      </fmt-fn-label>
                   </fn>
                </p>
                <fmt-footnote-container>
                   <fmt-fn-body id="_24" target="_" reference="1">
                      <semx element="fn" source="_">
                         <p id="_">
                            <fmt-fn-label>
                               <span class="fmt-caption-label">
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">1</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </span>
                               <span class="fmt-caption-delim">
                                  <tab/>
                               </span>
                            </fmt-fn-label>
                            Formerly denoted as 15 % (m/m).
                         </p>
                      </semx>
                   </fmt-fn-body>
                   <fmt-fn-body id="_25" target="_" reference="2">
                      <semx element="fn" source="_">
                         <p id="_">
                            <fmt-fn-label>
                               <span class="fmt-caption-label">
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">2</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </span>
                               <span class="fmt-caption-delim">
                                  <tab/>
                               </span>
                            </fmt-fn-label>
                            Hello! denoted as 15 % (m/m).
                         </p>
                      </semx>
                   </fmt-fn-body>
                </fmt-footnote-container>
             </foreword>
          </preface>
          <sections>
             <clause id="A" displayorder="3">
                <title id="_17">
                   BB
                   <fn reference="1" original-id="_" original-reference="45" id="_27" target="_">
                      <p original-id="_">Fourth footnote.</p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <span class="fmt-label-delim">(</span>
                               <semx element="autonum" source="_">1</semx>
                               <span class="fmt-label-delim">)</span>
                            </sup>
                         </span>
                      </fmt-fn-label>
                   </fn>
                </title>
                <fmt-title depth="1" id="_36">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">
                      BB
                      <fn reference="1" id="_7" original-reference="45" target="_">
                         <p id="_">Fourth footnote.</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Chapter</span>
                   <semx element="autonum" source="A">1</semx>
                </fmt-xref-label>
                <clause id="AA">
                   <fmt-title depth="2" id="_37">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="AA">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="AA">1</semx>
                   </fmt-xref-label>
                   <p>
                      A.
                      <fn reference="1" id="_8" original-reference="42" target="_">
                         <p original-id="_">Third footnote.</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </p>
                   <p>
                      B.
                      <fn reference="2" id="_9" original-reference="2" target="_">
                         <p original-id="_">Formerly denoted as 15 % (m/m).</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">2</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </p>
                   <fmt-footnote-container>
                      <fmt-fn-body id="_28" target="_" reference="1">
                         <semx element="fn" source="_">
                            <p id="_">
                               <fmt-fn-label>
                                  <span class="fmt-caption-label">
                                     <sup>
                                        <span class="fmt-label-delim">(</span>
                                        <semx element="autonum" source="_">1</semx>
                                        <span class="fmt-label-delim">)</span>
                                     </sup>
                                  </span>
                                  <span class="fmt-caption-delim">
                                     <tab/>
                                  </span>
                               </fmt-fn-label>
                               Third footnote.
                            </p>
                         </semx>
                      </fmt-fn-body>
                      <fmt-fn-body id="_29" target="_" reference="2">
                         <semx element="fn" source="_">
                            <p id="_">
                               <fmt-fn-label>
                                  <span class="fmt-caption-label">
                                     <sup>
                                        <span class="fmt-label-delim">(</span>
                                        <semx element="autonum" source="_">2</semx>
                                        <span class="fmt-label-delim">)</span>
                                     </sup>
                                  </span>
                                  <span class="fmt-caption-delim">
                                     <tab/>
                                  </span>
                               </fmt-fn-label>
                               Formerly denoted as 15 % (m/m).
                            </p>
                         </semx>
                      </fmt-fn-body>
                   </fmt-footnote-container>
                </clause>
                <clause id="AB">
                   <fmt-title depth="2" id="_38">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="AB">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Section</span>
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="AB">2</semx>
                   </fmt-xref-label>
                   <p>
                      A.
                      <fn reference="1" id="_10" original-reference="42" target="_">
                         <p original-id="_">Third footnote.</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </p>
                   <p>
                      B.
                      <fn reference="2" id="_11" original-reference="2" target="_">
                         <p original-id="_">Formerly denoted as 15 % (m/m).</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">2</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </p>
                   <fmt-footnote-container>
                      <fmt-fn-body id="_30" target="_" reference="1">
                         <semx element="fn" source="_">
                            <p id="_">
                               <fmt-fn-label>
                                  <span class="fmt-caption-label">
                                     <sup>
                                        <span class="fmt-label-delim">(</span>
                                        <semx element="autonum" source="_">1</semx>
                                        <span class="fmt-label-delim">)</span>
                                     </sup>
                                  </span>
                                  <span class="fmt-caption-delim">
                                     <tab/>
                                  </span>
                               </fmt-fn-label>
                               Third footnote.
                            </p>
                         </semx>
                      </fmt-fn-body>
                      <fmt-fn-body id="_31" target="_" reference="2">
                         <semx element="fn" source="_">
                            <p id="_">
                               <fmt-fn-label>
                                  <span class="fmt-caption-label">
                                     <sup>
                                        <span class="fmt-label-delim">(</span>
                                        <semx element="autonum" source="_">2</semx>
                                        <span class="fmt-label-delim">)</span>
                                     </sup>
                                  </span>
                                  <span class="fmt-caption-delim">
                                     <tab/>
                                  </span>
                               </fmt-fn-label>
                               Formerly denoted as 15 % (m/m).
                            </p>
                         </semx>
                      </fmt-fn-body>
                   </fmt-footnote-container>
                </clause>
                <fmt-footnote-container>
                   <fmt-fn-body id="_26" target="" reference="1">
                      <semx element="fn" source="_">
                         <p original-id="_">
                            <fmt-fn-label>
                               <span class="fmt-caption-label">
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">1</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </span>
                               <span class="fmt-caption-delim">
                                  <tab/>
                               </span>
                            </fmt-fn-label>
                            Fourth footnote.
                         </p>
                      </semx>
                   </fmt-fn-body>
                </fmt-footnote-container>
             </clause>
             <references id="_normative_references" obligation="informative" normative="true" displayorder="4">
                <title id="_20">Normative References</title>
                <fmt-title depth="1" id="_39">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">2</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Normative References</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Chapter</span>
                   <semx element="autonum" source="_">2</semx>
                </fmt-xref-label>
                <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
                <bibitem id="ISO712" type="standard">
                   <formattedref>
                      <em>
                         Cereals and cereal products
                         <fn reference="1" id="_12" original-reference="7" target="_">
                            <p original-id="_">ISO is a standards organisation.</p>
                            <fmt-fn-label>
                               <span class="fmt-caption-label">
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">1</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </span>
                            </fmt-fn-label>
                         </fn>
                      </em>
                   </formattedref>
                   <title format="text/plain">Cereals or cereal products</title>
                   <title type="main" format="text/plain">
                      Cereals and cereal products
                      <fn reference="1" id="_12" original-reference="7" target="_">
                         <p id="_">ISO is a standards organisation.</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </title>
                   <docidentifier type="ISO">ISO 712</docidentifier>
                   <docidentifier scope="biblio-tag">ISO 712</docidentifier>
                   <contributor>
                      <role type="publisher"/>
                      <organization>
                         <name>International Organization for Standardization</name>
                      </organization>
                   </contributor>
                   <biblio-tag> </biblio-tag>
                </bibitem>
                <fmt-footnote-container>
                   <fmt-fn-body id="_32" target="_" reference="1">
                      <semx element="fn" source="_">
                         <p id="_">
                            <fmt-fn-label>
                               <span class="fmt-caption-label">
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">1</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </span>
                               <span class="fmt-caption-delim">
                                  <tab/>
                               </span>
                            </fmt-fn-label>
                            ISO is a standards organisation.
                         </p>
                      </semx>
                   </fmt-fn-body>
                </fmt-footnote-container>
             </references>
          </sections>
          <bibliography>
           
       </bibliography>
       </iso-standard>
          INPUT
    output = <<~OUTPUT
       <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
          <div class="title-section">
             <p> </p>
          </div>
          <br/>
          <div class="prefatory-section">
             <p> </p>
          </div>
          <br/>
          <div class="main-section">
             <div class="authority">
                <div class="boilerplate-copyright">
                   <div id="_2">
                      <h1>
                         <a class="FootnoteRef" href="#fn:_22">
                            <sup>(1)</sup>
                         </a>
                      </h1>
                      <aside id="fn:_22" class="footnote">
                         <p>D</p>
                      </aside>
                   </div>
                </div>
             </div>
             <br/>
             <div id="_13" class="TOC">
                <h1 class="IntroTitle">Contents</h1>
             </div>
             <br/>
             <div id="F">
                <h1 class="ForewordTitle">Foreword</h1>
                <p>
                   A.
                   <a class="FootnoteRef" href="#fn:_24">
                      <sup>(1)</sup>
                   </a>
                </p>
                <p>
                   B.
                   <a class="FootnoteRef" href="#fn:_24">
                      <sup>(1)</sup>
                   </a>
                </p>
                <p>
                   C.
                   <a class="FootnoteRef" href="#fn:_25">
                      <sup>(2)</sup>
                   </a>
                </p>
                <aside id="fn:_24" class="footnote">
                   <p id="_">Formerly denoted as 15 % (m/m).</p>
                </aside>
                <aside id="fn:_25" class="footnote">
                   <p id="_">Hello! denoted as 15 % (m/m).</p>
                </aside>
             </div>
             <div id="A">
                <h1>
                   1.  BB
                   <a class="FootnoteRef" href="#fn:_26">
                      <sup>(1)</sup>
                   </a>
                </h1>
                <div id="AA">
                   <h2>1.1.</h2>
                   <p>
                      A.
                      <a class="FootnoteRef" href="#fn:_28">
                         <sup>(1)</sup>
                      </a>
                   </p>
                   <p>
                      B.
                      <a class="FootnoteRef" href="#fn:_29">
                         <sup>(2)</sup>
                      </a>
                   </p>
                   <aside id="fn:_28" class="footnote">
                      <p id="_">Third footnote.</p>
                   </aside>
                   <aside id="fn:_29" class="footnote">
                      <p id="_">Formerly denoted as 15 % (m/m).</p>
                   </aside>
                </div>
                <div id="AB">
                   <h2>1.2.</h2>
                   <p>
                      A.
                      <a class="FootnoteRef" href="#fn:_30">
                         <sup>(1)</sup>
                      </a>
                   </p>
                   <p>
                      B.
                      <a class="FootnoteRef" href="#fn:_31">
                         <sup>(2)</sup>
                      </a>
                   </p>
                   <aside id="fn:_30" class="footnote">
                      <p id="_">Third footnote.</p>
                   </aside>
                   <aside id="fn:_31" class="footnote">
                      <p id="_">Formerly denoted as 15 % (m/m).</p>
                   </aside>
                </div>
                <aside id="fn:_26" class="footnote">
                   <p>Fourth footnote.</p>
                </aside>
             </div>
             <div>
                <h1>2.  Normative References</h1>
                <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
                <p id="ISO712" class="NormRef">
                   <i>
                      Cereals and cereal products
                      <a class="FootnoteRef" href="#fn:_32">
                         <sup>(1)</sup>
                      </a>
                   </i>
                </p>
                <aside id="fn:_32" class="footnote">
                   <p id="_">ISO is a standards organisation.</p>
                </aside>
             </div>
          </div>
       </body>
           OUTPUT
    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input, true)
    expect(Xml::C14n.format(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to(be_equivalent_to(Xml::C14n.format(presxml)))
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to(be_equivalent_to(output))

    presxml = <<~OUTPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <bibdata>
             <title>
                <fn reference="1" id="_40" original-reference="43" target="_">
                   <p>C</p>
                   <fmt-fn-label>
                      <span class="fmt-caption-label">
                         <sup>
                            <semx element="autonum" source="_">1</semx>
                            <span class="fmt-label-delim">)</span>
                         </sup>
                      </span>
                   </fmt-fn-label>
                </fn>
             </title>
          </bibdata>
          <boilerplate>
             <copyright-statement>
                <clause id="_41">
                   <title id="_53">
                      <fn reference="2" original-id="_" original-reference="44" id="_62" target="_">
                         <p>D</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <semx element="autonum" source="_">2</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </title>
                   <fmt-title depth="1" id="_69">
                      <semx element="title" source="_">
                         <fn reference="2" id="_42" original-reference="44" target="_">
                            <p>D</p>
                            <fmt-fn-label>
                               <span class="fmt-caption-label">
                                  <sup>
                                     <semx element="autonum" source="_">2</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </span>
                            </fmt-fn-label>
                         </fn>
                      </semx>
                   </fmt-title>
                </clause>
             </copyright-statement>
          </boilerplate>
          <preface>
             <clause type="toc" id="_52" displayorder="1">
                <fmt-title depth="1" id="_70">Contents</fmt-title>
             </clause>
             <foreword id="F" displayorder="2">
                <title id="_55">Foreword</title>
                <fmt-title depth="1" id="_71">
                   <semx element="title" source="_">Foreword</semx>
                </fmt-title>
                <p>
                   A.
                   <fn reference="3" id="_43" original-reference="2" target="_">
                      <p original-id="_">Formerly denoted as 15 % (m/m).</p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">3</semx>
                               <span class="fmt-label-delim">)</span>
                            </sup>
                         </span>
                      </fmt-fn-label>
                   </fn>
                </p>
                <p>
                   B.
                   <fn reference="3" id="_44" original-reference="2" target="_">
                      <p id="_">Formerly denoted as 15 % (m/m).</p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">3</semx>
                               <span class="fmt-label-delim">)</span>
                            </sup>
                         </span>
                      </fmt-fn-label>
                   </fn>
                </p>
                <p>
                   C.
                   <fn reference="4" id="_45" original-reference="1" target="_">
                      <p original-id="_">Hello! denoted as 15 % (m/m).</p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">4</semx>
                               <span class="fmt-label-delim">)</span>
                            </sup>
                         </span>
                      </fmt-fn-label>
                   </fn>
                </p>
             </foreword>
          </preface>
          <bibdata>
             <ext>
                <editorialgroup>
                   <committee acronym="JCGM">
              Joint Committee for Guides in Metrology
              Comité commun pour les guides en métrologie
            </committee>
                </editorialgroup>
             </ext>
          </bibdata>
          <sections>
             <clause id="A" displayorder="4">
                <title id="_56">
                   BB
                   <fn reference="6" original-id="_" original-reference="45" id="_67" target="_">
                      <p original-id="_">Fourth footnote.</p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">6</semx>
                               <span class="fmt-label-delim">)</span>
                            </sup>
                         </span>
                      </fmt-fn-label>
                   </fn>
                </title>
                <fmt-title depth="1" id="_72">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">2</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">
                      BB
                      <fn reference="6" id="_46" original-reference="45" target="_">
                         <p id="_">Fourth footnote.</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <semx element="autonum" source="_">6</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">2</semx>
                </fmt-xref-label>
                <clause id="AA">
                   <fmt-title depth="2" id="_73">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="AA">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-title>
                   <fmt-xref-label>
                      <semx element="autonum" source="A">2</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="AA">1</semx>
                   </fmt-xref-label>
                   <p>
                      A.
                      <fn reference="7" id="_47" original-reference="42" target="_">
                         <p original-id="_">Third footnote.</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <semx element="autonum" source="_">7</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </p>
                   <p>
                      B.
                      <fn reference="3" id="_48" original-reference="2" target="_">
                         <p id="_">Formerly denoted as 15 % (m/m).</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <semx element="autonum" source="_">3</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </p>
                </clause>
                <clause id="AB">
                   <fmt-title depth="2" id="_74">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="AB">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-title>
                   <fmt-xref-label>
                      <semx element="autonum" source="A">2</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="AB">2</semx>
                   </fmt-xref-label>
                   <p>
                      A.
                      <fn reference="7" id="_49" original-reference="42" target="_">
                         <p id="_">Third footnote.</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <semx element="autonum" source="_">7</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </p>
                   <p>
                      B.
                      <fn reference="3" id="_50" original-reference="2" target="_">
                         <p id="_">Formerly denoted as 15 % (m/m).</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <semx element="autonum" source="_">3</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </p>
                </clause>
             </clause>
             <references id="_normative_references" obligation="informative" normative="true" displayorder="3">
                <title id="_59">Normative References</title>
                <fmt-title depth="1" id="_75">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Normative References</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="_">1</semx>
                </fmt-xref-label>
                <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
                <bibitem id="ISO712" type="standard">
                   <formattedref>
                      <em>
                         Cereals and cereal products
                         <fn reference="5" id="_51" original-reference="7" target="_">
                            <p original-id="_">ISO is a standards organisation.</p>
                            <fmt-fn-label>
                               <span class="fmt-caption-label">
                                  <sup>
                                     <semx element="autonum" source="_">5</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </span>
                            </fmt-fn-label>
                         </fn>
                      </em>
                   </formattedref>
                   <title format="text/plain">Cereals or cereal products</title>
                   <title type="main" format="text/plain">
                      Cereals and cereal products
                      <fn reference="5" id="_51" original-reference="7" target="_">
                         <p id="_">ISO is a standards organisation.</p>
                         <fmt-fn-label>
                            <span class="fmt-caption-label">
                               <sup>
                                  <semx element="autonum" source="_">5</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </span>
                         </fmt-fn-label>
                      </fn>
                   </title>
                   <docidentifier type="ISO">ISO 712</docidentifier>
                   <docidentifier scope="biblio-tag">ISO 712</docidentifier>
                   <contributor>
                      <role type="publisher"/>
                      <organization>
                         <name>International Organization for Standardization</name>
                      </organization>
                   </contributor>
                   <biblio-tag> </biblio-tag>
                </bibitem>
             </references>
          </sections>
          <bibliography>
           
       </bibliography>
          <fmt-footnote-container>
             <fmt-fn-body id="_60" target="_" reference="1">
                <semx element="fn" source="_">
                   <p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">1</semx>
                            </sup>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      C
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_61" target="" reference="2">
                <semx element="fn" source="_">
                   <p>
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">2</semx>
                            </sup>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      D
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_63" target="_" reference="3">
                <semx element="fn" source="_">
                   <p id="_">
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">3</semx>
                            </sup>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      Formerly denoted as 15 % (m/m).
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_64" target="_" reference="4">
                <semx element="fn" source="_">
                   <p id="_">
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">4</semx>
                            </sup>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      Hello! denoted as 15 % (m/m).
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_65" target="_" reference="5">
                <semx element="fn" source="_">
                   <p id="_">
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">5</semx>
                            </sup>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      ISO is a standards organisation.
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_66" target="" reference="6">
                <semx element="fn" source="_">
                   <p original-id="_">
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">6</semx>
                            </sup>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      Fourth footnote.
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_68" target="_" reference="7">
                <semx element="fn" source="_">
                   <p id="_">
                      <fmt-fn-label>
                         <span class="fmt-caption-label">
                            <sup>
                               <semx element="autonum" source="_">7</semx>
                            </sup>
                         </span>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      Third footnote.
                   </p>
                </semx>
             </fmt-fn-body>
          </fmt-footnote-container>
       </iso-standard>
    OUTPUT
    output = <<~OUTPUT
       <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
          <div class="title-section">
             <p> </p>
          </div>
          <br/>
          <div class="prefatory-section">
             <p> </p>
          </div>
          <br/>
          <div class="main-section">
             <div class="authority">
                <div class="boilerplate-copyright">
                   <div id="_41">
                      <h1>
                         <a class="FootnoteRef" href="#fn:_61">
                            <sup>2)</sup>
                         </a>
                      </h1>
                   </div>
                </div>
             </div>
             <br/>
             <div id="_52" class="TOC">
                <h1 class="IntroTitle">Contents</h1>
             </div>
             <br/>
             <div id="F">
                <h1 class="ForewordTitle">Foreword</h1>
                <p>
                   A.
                   <a class="FootnoteRef" href="#fn:_63">
                      <sup>3)</sup>
                   </a>
                </p>
                <p>
                   B.
                   <a class="FootnoteRef" href="#fn:_63">
                      <sup>3)</sup>
                   </a>
                </p>
                <p>
                   C.
                   <a class="FootnoteRef" href="#fn:_64">
                      <sup>4)</sup>
                   </a>
                </p>
             </div>
             <div>
                <h1>1.  Normative References</h1>
                <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
                <p id="ISO712" class="NormRef">
                   <i>
                      Cereals and cereal products
                      <a class="FootnoteRef" href="#fn:_65">
                         <sup>5)</sup>
                      </a>
                   </i>
                </p>
             </div>
             <div id="A">
                <h1>
                   2.  BB
                   <a class="FootnoteRef" href="#fn:_66">
                      <sup>6)</sup>
                   </a>
                </h1>
                <div id="AA">
                   <h2>2.1.</h2>
                   <p>
                      A.
                      <a class="FootnoteRef" href="#fn:_68">
                         <sup>7)</sup>
                      </a>
                   </p>
                   <p>
                      B.
                      <a class="FootnoteRef" href="#fn:_63">
                         <sup>3)</sup>
                      </a>
                   </p>
                </div>
                <div id="AB">
                   <h2>2.2.</h2>
                   <p>
                      A.
                      <a class="FootnoteRef" href="#fn:_68">
                         <sup>7)</sup>
                      </a>
                   </p>
                   <p>
                      B.
                      <a class="FootnoteRef" href="#fn:_63">
                         <sup>3)</sup>
                      </a>
                   </p>
                </div>
             </div>
             <aside id="fn:_60" class="footnote">
                <p>C</p>
             </aside>
             <aside id="fn:_61" class="footnote">
                <p>D</p>
             </aside>
             <aside id="fn:_63" class="footnote">
                <p id="_">Formerly denoted as 15 % (m/m).</p>
             </aside>
             <aside id="fn:_64" class="footnote">
                <p id="_">Hello! denoted as 15 % (m/m).</p>
             </aside>
             <aside id="fn:_65" class="footnote">
                <p id="_">ISO is a standards organisation.</p>
             </aside>
             <aside id="fn:_66" class="footnote">
                <p>Fourth footnote.</p>
             </aside>
             <aside id="fn:_68" class="footnote">
                <p id="_">Third footnote.</p>
             </aside>
          </div>
       </body>
    OUTPUT
    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input.sub("<sections>",
                                   "<bibdata>#{jcgm_ext}</bibdata><sections>"), true)
    expect(Xml::C14n.format(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to(be_equivalent_to(Xml::C14n.format(presxml)))
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))).to(be_equivalent_to(output))
  end
end
