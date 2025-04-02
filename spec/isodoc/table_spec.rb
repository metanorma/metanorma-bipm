require "spec_helper"

RSpec.describe IsoDoc::Bipm do
  it "processes table" do
    mock_uuid_increment
    input = <<~INPUT
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <sections>
          <clause id="A">
           <table id="tableD-1" alt="tool tip" summary="long desc" width="70%" keep-with-next="true" keep-lines-together="true">
          <name>Repeatability and reproducibility of <em>husked</em> rice yield<fn reference="1"><p>X</p></fn></name>
          <colgroup>
          <col width="30%"/>
          <col width="20%"/>
          <col width="20%"/>
          <col width="20%"/>
          <col width="10%"/>
          </colgroup>
          <thead>
            <tr>
              <td rowspan="2" align="left">Description</td>
              <td colspan="4" align="center">Rice sample</td>
            </tr>
            <tr>
              <td valign="top" align="left">Arborio</td>
              <td valign="middle" align="center">Drago<fn reference="a">
          <p id="_0fe65e9a-5531-408e-8295-eeff35f41a55">Parboiled rice.</p>
        </fn></td>
              <td valign="bottom" align="center">Balilla<fn reference="a">
          <p id="_0fe65e9a-5531-408e-8295-eeff35f41a55">Parboiled rice.</p>
        </fn></td>
              <td align="center">Thaibonnet</td>
            </tr>
            </thead>
            <tbody>
            <tr>
              <th align="left">Number of laboratories retained after eliminating outliers</th>
              <td align="center">13</td>
              <td align="center">11</td>
              <td align="center">13</td>
              <td align="center">13</td>
            </tr>
            <tr>
              <td align="left">Mean value, g/100 g</td>
              <td align="center">81,2</td>
              <td align="center">82,0</td>
              <td align="center">81,8</td>
              <td align="center">77,7</td>
            </tr>
            </tbody>
            <tfoot>
            <tr>
              <td align="left">Reproducibility limit, <stem type="AsciiMath">R</stem> (= 2,83 <stem type="AsciiMath">s_R</stem>)</td>
              <td align="center">2,89</td>
              <td align="center">0,57</td>
              <td align="center">2,26</td>
              <td align="center"><dl><dt>6,06</dt><dd>Definition</dd></dl></td>
            </tr>
          </tfoot>
          <dl key="true">
             <name>Key</name>
          <dt>Drago</dt>
        <dd>A type of rice</dd>
        </dl>
              <source status="generalisation">
          <origin bibitemid="ISO712" type="inline" citeas="">
            <localityStack>
              <locality type="section">
                <referenceFrom>1</referenceFrom>
              </locality>
            </localityStack>
          </origin>
          <modification>
            <p id="_">with adjustments</p>
          </modification>
        </source>
              <source status="specialisation">
          <origin bibitemid="ISO712" type="inline" citeas="">
            <localityStack>
              <locality type="section">
                <referenceFrom>2</referenceFrom>
              </locality>
            </localityStack>
          </origin>
        </source>
        <note><p>This is a table about rice</p></note>
        </table>
            <table id="C" unnumbered="true">
              <name>Second Table</name>
            </table>
            <quote>
            <table id="D">
              <name>Second Table<fn reference="1a"><p>X1</p></fn></name>
              <tbody>
              <tr><td>Text<fn reference="2a"><p>Y</p></fn></td></tr>
              </tbody>
            </table>
            <table id="D1">
              <name>Second Table<fn reference="1a"><p>X11</p></fn></name>
              <tbody>
              <tr><td>Text<fn reference="2a"><p>Y1</p></fn></td></tr>
              </tbody>
            </table>
            </quote>
          </clause>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~INPUT
           <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <clause id="A" displayorder="2">
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Chapter</span>
                   <semx element="autonum" source="A">1</semx>
                </fmt-xref-label>
                <table id="tableD-1" alt="tool tip" summary="long desc" width="70%" keep-with-next="true" keep-lines-together="true" autonum="1">
                   <name id="_">
                      Repeatability and reproducibility of
                      <em>husked</em>
                      rice yield
                      <fn reference="1" original-reference="1" target="_" original-id="_">
                         <p>X</p>
                         <fmt-fn-label>
                            <sup>
                               <span class="fmt-label-delim">(</span>
                               <semx element="autonum" source="_">1</semx>
                               <span class="fmt-label-delim">)</span>
                            </sup>
                         </fmt-fn-label>
                      </fn>
                   </name>
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Table</span>
                         <semx element="autonum" source="tableD-1">1</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         .
                         <tab/>
                      </span>
                      <semx element="name" source="_">
                         Repeatability and reproducibility of
                         <em>husked</em>
                         rice yield
                         <fn reference="1" original-reference="1" id="_" target="_">
                            <p>X</p>
                            <fmt-fn-label>
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </fmt-fn-label>
                         </fn>
                      </semx>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Table</span>
                      <semx element="autonum" source="tableD-1">1</semx>
                   </fmt-xref-label>
                   <colgroup>
                      <col width="30%"/>
                      <col width="20%"/>
                      <col width="20%"/>
                      <col width="20%"/>
                      <col width="10%"/>
                   </colgroup>
                   <thead>
                      <tr>
                         <td rowspan="2" align="left">Description</td>
                         <td colspan="4" align="center">Rice sample</td>
                      </tr>
                      <tr>
                         <td valign="top" align="left">Arborio</td>
                         <td valign="middle" align="center">
                            Drago
                            <fn reference="a" id="_" target="_">
                               <p original-id="_">Parboiled rice.</p>
                               <fmt-fn-label>
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">a</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </fmt-fn-label>
                            </fn>
                         </td>
                         <td valign="bottom" align="center">
                            Balilla
                            <fn reference="a" id="_" target="_">
                               <p id="_">Parboiled rice.</p>
                               <fmt-fn-label>
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">a</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </fmt-fn-label>
                            </fn>
                         </td>
                         <td align="center">Thaibonnet</td>
                      </tr>
                   </thead>
                   <tbody>
                      <tr>
                         <th align="left">Number of laboratories retained after eliminating outliers</th>
                         <td align="center">13</td>
                         <td align="center">11</td>
                         <td align="center">13</td>
                         <td align="center">13</td>
                      </tr>
                      <tr>
                         <td align="left">Mean value, g/100 g</td>
                         <td align="center">81,2</td>
                         <td align="center">82,0</td>
                         <td align="center">81,8</td>
                         <td align="center">77,7</td>
                      </tr>
                   </tbody>
                   <tfoot>
                      <tr>
                         <td align="left">
                            Reproducibility limit,
                            <stem type="AsciiMath" id="_">R</stem>
                            <fmt-stem type="AsciiMath">
                               <semx element="stem" source="_">R</semx>
                            </fmt-stem>
                            (= 2,83
                            <stem type="AsciiMath" id="_">s_R</stem>
                            <fmt-stem type="AsciiMath">
                               <semx element="stem" source="_">s_R</semx>
                            </fmt-stem>
                            )
                         </td>
                         <td align="center">2,89</td>
                         <td align="center">0,57</td>
                         <td align="center">2,26</td>
                         <td align="center">
                            <dl>
                               <dt>6,06</dt>
                               <dd>Definition</dd>
                            </dl>
                         </td>
                      </tr>
                   </tfoot>
                   <dl key="true">
                      <name id="_">Key</name>
                      <fmt-name>
                         <semx element="name" source="_">Key</semx>
                      </fmt-name>
                      <dt>Drago</dt>
                      <dd>A type of rice</dd>
                   </dl>
                   <source status="generalisation">
                      [:
                      <origin bibitemid="ISO712" type="inline" citeas="" id="_">
                         <localityStack>
                            <locality type="section">
                               <referenceFrom>1</referenceFrom>
                            </locality>
                         </localityStack>
                      </origin>
                      <semx element="origin" source="_">
                         <fmt-origin bibitemid="ISO712" type="inline" citeas="">
                            <localityStack>
                               <locality type="section">
                                  <referenceFrom>1</referenceFrom>
                               </locality>
                            </localityStack>
                            , Section 1
                         </fmt-origin>
                      </semx>
                      —
                      <semx element="modification" source="_">with adjustments</semx>
                      ;
                      <origin bibitemid="ISO712" type="inline" citeas="" id="_">
                         <localityStack>
                            <locality type="section">
                               <referenceFrom>2</referenceFrom>
                            </locality>
                         </localityStack>
                      </origin>
                      <semx element="origin" source="_">
                         <fmt-origin bibitemid="ISO712" type="inline" citeas="">
                            <localityStack>
                               <locality type="section">
                                  <referenceFrom>2</referenceFrom>
                               </locality>
                            </localityStack>
                            , Section 2
                         </fmt-origin>
                      </semx>
                      ]
                   </source>
                   <note>
                      <fmt-name>
                         <span class="fmt-caption-label">Note</span>
                         <span class="fmt-label-delim">
                            :
                            <tab/>
                         </span>
                      </fmt-name>
                      <p>This is a table about rice</p>
                   </note>
                   <fmt-footnote-container>
                      <fmt-fn-body id="_" target="_" reference="a">
                         <semx element="fn" source="_">
                            <p id="_">
                               <fmt-fn-label>
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">a</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                                  <span class="fmt-caption-delim">
                                     <tab/>
                                  </span>
                               </fmt-fn-label>
                               Parboiled rice.
                            </p>
                         </semx>
                      </fmt-fn-body>
                   </fmt-footnote-container>
                </table>
                <table id="C" unnumbered="true">
                   <name id="_">Second Table</name>
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Table</span>
                      </span>
                      <span class="fmt-caption-delim">
                         .
                         <tab/>
                      </span>
                      <semx element="name" source="_">Second Table</semx>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Table</span>
                      <semx element="autonum" source="C">(??)</semx>
                   </fmt-xref-label>
                </table>
                <quote>
                   <table id="D" autonum="2">
                      <name id="_">
                         Second Table
                         <fn reference="2" original-reference="1a" target="_" original-id="_">
                            <p>X1</p>
                            <fmt-fn-label>
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">2</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </fmt-fn-label>
                         </fn>
                      </name>
                      <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Table</span>
                            <semx element="autonum" source="D">2</semx>
                         </span>
                         <span class="fmt-caption-delim">
                            .
                            <tab/>
                         </span>
                         <semx element="name" source="_">
                            Second Table
                            <fn reference="2" original-reference="1a" id="_" target="_">
                               <p>X1</p>
                               <fmt-fn-label>
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">2</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </fmt-fn-label>
                            </fn>
                         </semx>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Table</span>
                         <semx element="autonum" source="D">2</semx>
                      </fmt-xref-label>
                      <tbody>
                         <tr>
                            <td>
                               Text
                               <fn reference="3" original-reference="2a" id="_" target="_">
                                  <p>Y</p>
                                  <fmt-fn-label>
                                     <sup>
                                        <span class="fmt-label-delim">(</span>
                                        <semx element="autonum" source="_">3</semx>
                                        <span class="fmt-label-delim">)</span>
                                     </sup>
                                  </fmt-fn-label>
                               </fn>
                            </td>
                         </tr>
                      </tbody>
                   </table>
                   <table id="D1" autonum="3">
                      <name id="_">
                         Second Table
                         <fn reference="4" original-reference="1a" target="_" original-id="_">
                            <p>X11</p>
                            <fmt-fn-label>
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">4</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </fmt-fn-label>
                         </fn>
                      </name>
                      <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Table</span>
                            <semx element="autonum" source="D1">3</semx>
                         </span>
                         <span class="fmt-caption-delim">
                            .
                            <tab/>
                         </span>
                         <semx element="name" source="_">
                            Second Table
                            <fn reference="4" original-reference="1a" id="_" target="_">
                               <p>X11</p>
                               <fmt-fn-label>
                                  <sup>
                                     <span class="fmt-label-delim">(</span>
                                     <semx element="autonum" source="_">4</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </fmt-fn-label>
                            </fn>
                         </semx>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Table</span>
                         <semx element="autonum" source="D1">3</semx>
                      </fmt-xref-label>
                      <tbody>
                         <tr>
                            <td>
                               Text
                               <fn reference="5" original-reference="2a" id="_" target="_">
                                  <p>Y1</p>
                                  <fmt-fn-label>
                                     <sup>
                                        <span class="fmt-label-delim">(</span>
                                        <semx element="autonum" source="_">5</semx>
                                        <span class="fmt-label-delim">)</span>
                                     </sup>
                                  </fmt-fn-label>
                               </fn>
                            </td>
                         </tr>
                      </tbody>
                   </table>
                </quote>
                <fmt-footnote-container>
                   <fmt-fn-body id="_" target="_" reference="1">
                      <semx element="fn" source="_">
                         <p>
                            <fmt-fn-label>
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                               <span class="fmt-caption-delim">
                                  <tab/>
                               </span>
                            </fmt-fn-label>
                            X
                         </p>
                      </semx>
                   </fmt-fn-body>
                   <fmt-fn-body id="_" target="_" reference="2">
                      <semx element="fn" source="_">
                         <p>
                            <fmt-fn-label>
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">2</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                               <span class="fmt-caption-delim">
                                  <tab/>
                               </span>
                            </fmt-fn-label>
                            X1
                         </p>
                      </semx>
                   </fmt-fn-body>
                   <fmt-fn-body id="_" target="_" reference="3">
                      <semx element="fn" source="_">
                         <p>
                            <fmt-fn-label>
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">3</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                               <span class="fmt-caption-delim">
                                  <tab/>
                               </span>
                            </fmt-fn-label>
                            Y
                         </p>
                      </semx>
                   </fmt-fn-body>
                   <fmt-fn-body id="_" target="_" reference="4">
                      <semx element="fn" source="_">
                         <p>
                            <fmt-fn-label>
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">4</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                               <span class="fmt-caption-delim">
                                  <tab/>
                               </span>
                            </fmt-fn-label>
                            X11
                         </p>
                      </semx>
                   </fmt-fn-body>
                   <fmt-fn-body id="_" target="_" reference="5">
                      <semx element="fn" source="_">
                         <p>
                            <fmt-fn-label>
                               <sup>
                                  <span class="fmt-label-delim">(</span>
                                  <semx element="autonum" source="_">5</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                               <span class="fmt-caption-delim">
                                  <tab/>
                               </span>
                            </fmt-fn-label>
                            Y1
                         </p>
                      </semx>
                   </fmt-fn-body>
                </fmt-footnote-container>
             </clause>
          </sections>
       </bipm-standard>
          INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
      #{HTML_HDR}
            <br/>
             <div id="_" class="TOC">
                <h1 class="IntroTitle">Contents</h1>
             </div>
             <div id="A">
                <h1>1.</h1>
                <p class="TableTitle" style="text-align:center;">
                   Table 1.  Repeatability and reproducibility of
                   <i>husked</i>
                   rice yield
                   <a class="FootnoteRef" href="#fn:_5">
                      <sup>(1)</sup>
                   </a>
                </p>
                <table id="tableD-1" class="MsoISOTable" style="border-width:1px;border-spacing:0;width:70%;page-break-after: avoid;page-break-inside: avoid;table-layout:fixed;" title="tool tip">
                   <caption>
                      <span style="display:none">long desc</span>
                   </caption>
                   <colgroup>
                      <col style="width: 30%;"/>
                      <col style="width: 20%;"/>
                      <col style="width: 20%;"/>
                      <col style="width: 20%;"/>
                      <col style="width: 10%;"/>
                   </colgroup>
                   <thead>
                      <tr>
                         <td rowspan="2" style="text-align:left;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;" scope="col">Description</td>
                         <td colspan="4" style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;" scope="colgroup">Rice sample</td>
                      </tr>
                      <tr>
                         <td style="text-align:left;vertical-align:top;border-top:none;border-bottom:solid windowtext 1.5pt;" scope="col">Arborio</td>
                         <td style="text-align:center;vertical-align:middle;border-top:none;border-bottom:solid windowtext 1.5pt;" scope="col">
                            Drago
                            <a href="#tableD-1a" class="TableFootnoteRef">(a)</a>
                         </td>
                         <td style="text-align:center;vertical-align:bottom;border-top:none;border-bottom:solid windowtext 1.5pt;" scope="col">
                            Balilla
                            <a href="#tableD-1a" class="TableFootnoteRef">(a)</a>
                         </td>
                         <td style="text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;" scope="col">Thaibonnet</td>
                      </tr>
                   </thead>
                   <tbody>
                      <tr>
                         <th style="font-weight:bold;text-align:left;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;" scope="row">Number of laboratories retained after eliminating outliers</th>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">13</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">11</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">13</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">13</td>
                      </tr>
                      <tr>
                         <td style="text-align:left;border-top:none;border-bottom:solid windowtext 1.5pt;">Mean value, g/100 g</td>
                         <td style="text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;">81,2</td>
                         <td style="text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;">82,0</td>
                         <td style="text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;">81,8</td>
                         <td style="text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;">77,7</td>
                      </tr>
                   </tbody>
                   <tfoot>
                      <tr>
                         <td style="text-align:left;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">
                            Reproducibility limit,
                            <span class="stem">(#(R)#)</span>
                            (= 2,83
                            <span class="stem">(#(s_R)#)</span>
                            )
                         </td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">2,89</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">0,57</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">2,26</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">
                            <div class="figdl">
                               <dl>
                                  <dt>
                                     <p>6,06</p>
                                  </dt>
                                  <dd>Definition</dd>
                               </dl>
                            </div>
                         </td>
                      </tr>
                   </tfoot>
                   <div class="figdl">
                      <p class="ListTitle">Key</p>
                      <dl>
                         <dt>
                            <p>Drago</p>
                         </dt>
                         <dd>A type of rice</dd>
                      </dl>
                   </div>
                   <div class="BlockSource">
                      <p>[: , Section 1
            — with adjustments
         ;
           , Section 2]</p>
                   </div>
                   <div class="Note">
                      <p>
                         <span class="note_label">Note:  </span>
                         This is a table about rice
                      </p>
                   </div>
                   <aside id="fn:tableD-1a" class="footnote">
                      <p id="_">
                         <span class="TableFootnoteRef">(a)</span>
                           Parboiled rice.
                      </p>
                   </aside>
                </table>
                <p class="TableTitle" style="text-align:center;">Table.  Second Table</p>
                <table id="C" class="MsoISOTable" style="border-width:1px;border-spacing:0;"/>
                <div class="Quote">
                   <p class="TableTitle" style="text-align:center;">
                      Table 2.  Second Table
                      <a class="FootnoteRef" href="#fn:_7">
                         <sup>(2)</sup>
                      </a>
                   </p>
                   <table id="D" class="MsoISOTable" style="border-width:1px;border-spacing:0;">
                      <tbody>
                         <tr>
                            <td style="border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">
                               Text
                               <a class="FootnoteRef" href="#fn:_9">
                                  <sup>(3)</sup>
                               </a>
                            </td>
                         </tr>
                      </tbody>
                   </table>
                   <p class="TableTitle" style="text-align:center;">
                      Table 3.  Second Table
                      <a class="FootnoteRef" href="#fn:_11">
                         <sup>(4)</sup>
                      </a>
                   </p>
                   <table id="D1" class="MsoISOTable" style="border-width:1px;border-spacing:0;">
                      <tbody>
                         <tr>
                            <td style="border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">
                               Text
                               <a class="FootnoteRef" href="#fn:_13">
                                  <sup>(5)</sup>
                               </a>
                            </td>
                         </tr>
                      </tbody>
                   </table>
                </div>
                <aside id="fn:_5" class="footnote">
                   <p>X</p>
                </aside>
                <aside id="fn:_7" class="footnote">
                   <p>X1</p>
                </aside>
                <aside id="fn:_9" class="footnote">
                   <p>Y</p>
                </aside>
                <aside id="fn:_11" class="footnote">
                   <p>X11</p>
                </aside>
                <aside id="fn:_13" class="footnote">
                   <p>Y1</p>
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
       <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
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
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <clause id="A" displayorder="2">
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">1</semx>
                </fmt-xref-label>
                <table id="tableD-1" alt="tool tip" summary="long desc" width="70%" keep-with-next="true" keep-lines-together="true" autonum="1">
                   <name id="_">
                      Repeatability and reproducibility of
                      <em>husked</em>
                      rice yield
                      <fn reference="1" original-reference="1" target="_" original-id="_">
                         <p>X</p>
                         <fmt-fn-label>
                            <sup>
                               <semx element="autonum" source="_">1</semx>
                               <span class="fmt-label-delim">)</span>
                            </sup>
                         </fmt-fn-label>
                      </fn>
                   </name>
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Table</span>
                         <semx element="autonum" source="tableD-1">1</semx>
                      </span>
                      <span class="fmt-caption-delim">
                         .
                         <tab/>
                      </span>
                      <semx element="name" source="_">
                         Repeatability and reproducibility of
                         <em>husked</em>
                         rice yield
                         <fn reference="1" original-reference="1" id="_" target="_">
                            <p>X</p>
                            <fmt-fn-label>
                               <sup>
                                  <semx element="autonum" source="_">1</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </fmt-fn-label>
                         </fn>
                      </semx>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Table</span>
                      <semx element="autonum" source="tableD-1">1</semx>
                   </fmt-xref-label>
                   <colgroup>
                      <col width="30%"/>
                      <col width="20%"/>
                      <col width="20%"/>
                      <col width="20%"/>
                      <col width="10%"/>
                   </colgroup>
                   <thead>
                      <tr>
                         <td rowspan="2" align="left">Description</td>
                         <td colspan="4" align="center">Rice sample</td>
                      </tr>
                      <tr>
                         <td valign="top" align="left">Arborio</td>
                         <td valign="middle" align="center">
                            Drago
                            <fn reference="a" id="_" target="_">
                               <p original-id="_">Parboiled rice.</p>
                               <fmt-fn-label>
                                  <sup>
                                     <semx element="autonum" source="_">a</semx>
                                  </sup>
                               </fmt-fn-label>
                            </fn>
                         </td>
                         <td valign="bottom" align="center">
                            Balilla
                            <fn reference="a" id="_" target="_">
                               <p id="_">Parboiled rice.</p>
                               <fmt-fn-label>
                                  <sup>
                                     <semx element="autonum" source="_">a</semx>
                                  </sup>
                               </fmt-fn-label>
                            </fn>
                         </td>
                         <td align="center">Thaibonnet</td>
                      </tr>
                   </thead>
                   <tbody>
                      <tr>
                         <th align="left">Number of laboratories retained after eliminating outliers</th>
                         <td align="center">13</td>
                         <td align="center">11</td>
                         <td align="center">13</td>
                         <td align="center">13</td>
                      </tr>
                      <tr>
                         <td align="left">Mean value, g/100 g</td>
                         <td align="center">81,2</td>
                         <td align="center">82,0</td>
                         <td align="center">81,8</td>
                         <td align="center">77,7</td>
                      </tr>
                   </tbody>
                   <tfoot>
                      <tr>
                         <td align="left">
                            Reproducibility limit,
                            <stem type="AsciiMath" id="_">R</stem>
                            <fmt-stem type="AsciiMath">
                               <semx element="stem" source="_">R</semx>
                            </fmt-stem>
                            (= 2,83
                            <stem type="AsciiMath" id="_">s_R</stem>
                            <fmt-stem type="AsciiMath">
                               <semx element="stem" source="_">s_R</semx>
                            </fmt-stem>
                            )
                         </td>
                         <td align="center">2,89</td>
                         <td align="center">0,57</td>
                         <td align="center">2,26</td>
                         <td align="center">
                            <dl>
                               <dt>6,06</dt>
                               <dd>Definition</dd>
                            </dl>
                         </td>
                      </tr>
                   </tfoot>
                   <dl key="true">
                      <name id="_">Key</name>
                      <fmt-name>
                         <semx element="name" source="_">Key</semx>
                      </fmt-name>
                      <dt>Drago</dt>
                      <dd>A type of rice</dd>
                   </dl>
                   <source status="generalisation">
                      [:
                      <origin bibitemid="ISO712" type="inline" citeas="" id="_">
                         <localityStack>
                            <locality type="section">
                               <referenceFrom>1</referenceFrom>
                            </locality>
                         </localityStack>
                      </origin>
                      <semx element="origin" source="_">
                         <fmt-origin bibitemid="ISO712" type="inline" citeas="">
                            <localityStack>
                               <locality type="section">
                                  <referenceFrom>1</referenceFrom>
                               </locality>
                            </localityStack>
                            , Section 1
                         </fmt-origin>
                      </semx>
                      —
                      <semx element="modification" source="_">with adjustments</semx>
                      ;
                      <origin bibitemid="ISO712" type="inline" citeas="" id="_">
                         <localityStack>
                            <locality type="section">
                               <referenceFrom>2</referenceFrom>
                            </locality>
                         </localityStack>
                      </origin>
                      <semx element="origin" source="_">
                         <fmt-origin bibitemid="ISO712" type="inline" citeas="">
                            <localityStack>
                               <locality type="section">
                                  <referenceFrom>2</referenceFrom>
                               </locality>
                            </localityStack>
                            , Section 2
                         </fmt-origin>
                      </semx>
                      ]
                   </source>
                   <note>
                      <fmt-name>
                         <span class="fmt-caption-label">Note</span>
                         <span class="fmt-label-delim">
                            :
                            <tab/>
                         </span>
                      </fmt-name>
                      <p>This is a table about rice</p>
                   </note>
                   <fmt-footnote-container>
                      <fmt-fn-body id="_" target="_" reference="a">
                         <semx element="fn" source="_">
                            <p id="_">
                               <fmt-fn-label>
                                  <sup>
                                     <semx element="autonum" source="_">a</semx>
                                  </sup>
                                  <span class="fmt-caption-delim">
                                     <tab/>
                                  </span>
                               </fmt-fn-label>
                               Parboiled rice.
                            </p>
                         </semx>
                      </fmt-fn-body>
                   </fmt-footnote-container>
                </table>
                <table id="C" unnumbered="true">
                   <name id="_">Second Table</name>
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Table</span>
                      </span>
                      <span class="fmt-caption-delim">
                         .
                         <tab/>
                      </span>
                      <semx element="name" source="_">Second Table</semx>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Table</span>
                      <semx element="autonum" source="C">(??)</semx>
                   </fmt-xref-label>
                </table>
                <quote>
                   <table id="D" autonum="2">
                      <name id="_">
                         Second Table
                         <fn reference="2" original-reference="1a" target="_" original-id="_">
                            <p>X1</p>
                            <fmt-fn-label>
                               <sup>
                                  <semx element="autonum" source="_">2</semx>
                                  <span class="fmt-label-delim">)</span>
                               </sup>
                            </fmt-fn-label>
                         </fn>
                      </name>
                      <fmt-name>
                         <span class="fmt-caption-label">
                            <span class="fmt-element-name">Table</span>
                            <semx element="autonum" source="D">2</semx>
                         </span>
                         <span class="fmt-caption-delim">
                            .
                            <tab/>
                         </span>
                         <semx element="name" source="_">
                            Second Table
                            <fn reference="2" original-reference="1a" id="_" target="_">
                               <p>X1</p>
                               <fmt-fn-label>
                                  <sup>
                                     <semx element="autonum" source="_">2</semx>
                                     <span class="fmt-label-delim">)</span>
                                  </sup>
                               </fmt-fn-label>
                            </fn>
                         </semx>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Table</span>
                         <semx element="autonum" source="D">2</semx>
                      </fmt-xref-label>
                      <tbody>
                         <tr>
                            <td>
                               Text
                               <fn reference="2a" id="_" target="_">
                                  <p>Y</p>
                                  <fmt-fn-label>
                                     <sup>
                                        <semx element="autonum" source="_">2a</semx>
                                     </sup>
                                  </fmt-fn-label>
                               </fn>
                            </td>
                         </tr>
                      </tbody>
                      <fmt-footnote-container>
                         <fmt-fn-body id="_" target="_" reference="2a">
                            <semx element="fn" source="_">
                               <p>
                                  <fmt-fn-label>
                                     <sup>
                                        <semx element="autonum" source="_">2a</semx>
                                     </sup>
                                     <span class="fmt-caption-delim">
                                        <tab/>
                                     </span>
                                  </fmt-fn-label>
                                  Y
                               </p>
                            </semx>
                         </fmt-fn-body>
                      </fmt-footnote-container>
                   </table>
            <table id="D1" autonum="3">
               <name id="_">
                  Second Table
                  <fn reference="2" original-reference="1a" target="_" original-id="_">
                     <p>X11</p>
                     <fmt-fn-label>
                        <sup>
                           <semx element="autonum" source="_">2</semx>
                           <span class="fmt-label-delim">)</span>
                        </sup>
                     </fmt-fn-label>
                  </fn>
               </name>
               <fmt-name>
                  <span class="fmt-caption-label">
                     <span class="fmt-element-name">Table</span>
                     <semx element="autonum" source="D1">3</semx>
                  </span>
                  <span class="fmt-caption-delim">
                     .
                     <tab/>
                  </span>
                  <semx element="name" source="_">
                     Second Table
                     <fn reference="2" original-reference="1a" id="_" target="_">
                        <p>X11</p>
                        <fmt-fn-label>
                           <sup>
                              <semx element="autonum" source="_">2</semx>
                              <span class="fmt-label-delim">)</span>
                           </sup>
                        </fmt-fn-label>
                     </fn>
                  </semx>
               </fmt-name>
               <fmt-xref-label>
                  <span class="fmt-element-name">Table</span>
                  <semx element="autonum" source="D1">3</semx>
               </fmt-xref-label>
               <tbody>
                  <tr>
                     <td>
                        Text
                        <fn reference="2a" id="_" target="_">
                           <p>Y1</p>
                           <fmt-fn-label>
                              <sup>
                                 <semx element="autonum" source="_">2a</semx>
                              </sup>
                           </fmt-fn-label>
                        </fn>
                     </td>
                  </tr>
               </tbody>
               <fmt-footnote-container>
                  <fmt-fn-body id="_" target="_" reference="2a">
                     <semx element="fn" source="_">
                        <p>
                           <fmt-fn-label>
                              <sup>
                                 <semx element="autonum" source="_">2a</semx>
                              </sup>
                              <span class="fmt-caption-delim">
                                 <tab/>
                              </span>
                           </fmt-fn-label>
                           Y1
                        </p>
                     </semx>
                  </fmt-fn-body>
               </fmt-footnote-container>
            </table>
                </quote>
             </clause>
          </sections>
          <fmt-footnote-container>
             <fmt-fn-body id="_" target="_" reference="1">
                <semx element="fn" source="_">
                   <p>
                      <fmt-fn-label>
                         <sup>
                            <semx element="autonum" source="_">1</semx>
                         </sup>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      X
                   </p>
                </semx>
             </fmt-fn-body>
             <fmt-fn-body id="_" target="_" reference="2">
                <semx element="fn" source="_">
                   <p>
                      <fmt-fn-label>
                         <sup>
                            <semx element="autonum" source="_">2</semx>
                         </sup>
                         <span class="fmt-caption-delim">
                            <tab/>
                         </span>
                      </fmt-fn-label>
                      X1
                   </p>
                </semx>
             </fmt-fn-body>
          </fmt-footnote-container>
       </bipm-standard>
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
             <br/>
             <div id="_" class="TOC">
                <h1 class="IntroTitle">Contents</h1>
             </div>
             <div id="A">
                <h1>1.</h1>
                <p class="TableTitle" style="text-align:center;">
                   Table 1.  Repeatability and reproducibility of
                   <i>husked</i>
                   rice yield
                   <a class="FootnoteRef" href="#fn:_32">
                      <sup>1)</sup>
                   </a>
                </p>
                <table id="tableD-1" class="MsoISOTable" style="border-width:1px;border-spacing:0;width:70%;page-break-after: avoid;page-break-inside: avoid;table-layout:fixed;" title="tool tip">
                   <caption>
                      <span style="display:none">long desc</span>
                   </caption>
                   <colgroup>
                      <col style="width: 30%;"/>
                      <col style="width: 20%;"/>
                      <col style="width: 20%;"/>
                      <col style="width: 20%;"/>
                      <col style="width: 10%;"/>
                   </colgroup>
                   <thead>
                      <tr>
                         <td rowspan="2" style="text-align:left;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;" scope="col">Description</td>
                         <td colspan="4" style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;" scope="colgroup">Rice sample</td>
                      </tr>
                      <tr>
                         <td style="text-align:left;vertical-align:top;border-top:none;border-bottom:solid windowtext 1.5pt;" scope="col">Arborio</td>
                         <td style="text-align:center;vertical-align:middle;border-top:none;border-bottom:solid windowtext 1.5pt;" scope="col">
                            Drago
                            <a href="#tableD-1a" class="TableFootnoteRef">a</a>
                         </td>
                         <td style="text-align:center;vertical-align:bottom;border-top:none;border-bottom:solid windowtext 1.5pt;" scope="col">
                            Balilla
                            <a href="#tableD-1a" class="TableFootnoteRef">a</a>
                         </td>
                         <td style="text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;" scope="col">Thaibonnet</td>
                      </tr>
                   </thead>
                   <tbody>
                      <tr>
                         <th style="font-weight:bold;text-align:left;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;" scope="row">Number of laboratories retained after eliminating outliers</th>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">13</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">11</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">13</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">13</td>
                      </tr>
                      <tr>
                         <td style="text-align:left;border-top:none;border-bottom:solid windowtext 1.5pt;">Mean value, g/100 g</td>
                         <td style="text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;">81,2</td>
                         <td style="text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;">82,0</td>
                         <td style="text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;">81,8</td>
                         <td style="text-align:center;border-top:none;border-bottom:solid windowtext 1.5pt;">77,7</td>
                      </tr>
                   </tbody>
                   <tfoot>
                      <tr>
                         <td style="text-align:left;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">
                            Reproducibility limit,
                            <span class="stem">(#(R)#)</span>
                            (= 2,83
                            <span class="stem">(#(s_R)#)</span>
                            )
                         </td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">2,89</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">0,57</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">2,26</td>
                         <td style="text-align:center;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">
                            <div class="figdl">
                               <dl>
                                  <dt>
                                     <p>6,06</p>
                                  </dt>
                                  <dd>Definition</dd>
                               </dl>
                            </div>
                         </td>
                      </tr>
                   </tfoot>
                   <div class="figdl">
                      <p class="ListTitle">Key</p>
                      <dl>
                         <dt>
                            <p>Drago</p>
                         </dt>
                         <dd>A type of rice</dd>
                      </dl>
                   </div>
                   <div class="BlockSource">
                      <p>[: , Section 1
            — with adjustments
         ;
           , Section 2]</p>
                   </div>
                   <div class="Note">
                      <p>
                         <span class="note_label">Note:  </span>
                         This is a table about rice
                      </p>
                   </div>
                   <aside id="fn:tableD-1a" class="footnote">
                      <p id="_">
                         <span class="TableFootnoteRef">a</span>
                           Parboiled rice.
                      </p>
                   </aside>
                </table>
                <p class="TableTitle" style="text-align:center;">Table.  Second Table</p>
                <table id="C" class="MsoISOTable" style="border-width:1px;border-spacing:0;"/>
                <div class="Quote">
                   <p class="TableTitle" style="text-align:center;">
                      Table 2.  Second Table
                      <a class="FootnoteRef" href="#fn:_34">
                         <sup>2)</sup>
                      </a>
                   </p>
                   <table id="D" class="MsoISOTable" style="border-width:1px;border-spacing:0;">
                      <tbody>
                         <tr>
                            <td style="border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">
                               Text
                               <a class="FootnoteRef" href="#fn:_42">
                                  <sup>2a</sup>
                               </a>
                            </td>
                         </tr>
                      </tbody>
                      <aside id="fn:_42" class="footnote">
                         <p>
                            <sup>2a</sup>
                              Y
                         </p>
                      </aside>
                   </table>
                   <p class="TableTitle" style="text-align:center;">
                      Table 3.  Second Table
                      <a class="FootnoteRef" href="#fn:_34">
                         <sup>2)</sup>
                      </a>
                   </p>
                   <table id="D1" class="MsoISOTable" style="border-width:1px;border-spacing:0;">
                      <tbody>
                         <tr>
                            <td style="border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;">
                               Text
                               <a class="FootnoteRef" href="#fn:_45">
                                  <sup>2a</sup>
                               </a>
                            </td>
                         </tr>
                      </tbody>
                      <aside id="fn:_45" class="footnote">
                         <p>
                            <sup>2a</sup>
                              Y1
                         </p>
                      </aside>
                   </table>
                </div>
             </div>
             <aside id="fn:_32" class="footnote">
                <p>X</p>
             </aside>
             <aside id="fn:_34" class="footnote">
                <p>X1</p>
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
