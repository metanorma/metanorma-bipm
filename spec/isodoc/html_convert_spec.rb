require "spec_helper"

RSpec.describe IsoDoc::Bipm do
  it "injects JS into blank html" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections/>
      </bipm-standard>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor
      .convert(input, backend: :bipm, header_footer: true))))
      .to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Times New Roman})
  end

  it "processes unordered lists" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface>
          <clause type="toc" id="_" displayorder="1"> <fmt-title depth="1">Table of contents</fmt-title> </clause>
          <foreword displayorder="2" id="fwd"><fmt-title>Foreword</fmt-title>
          <ul id="_61961034-0fb1-436b-b281-828857a59ddb"  keep-with-next="true" keep-lines-together="true">
          <name>Caption</name>
        <li>
          <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a2">Level 1</p>
        </li>
        <li>
          <p id="_60eb765c-1f6c-418a-8016-29efa06bf4f9">deletion of 4.3.</p>
          <ul id="_61961034-0fb1-436b-b281-828857a59ddc"  keep-with-next="true" keep-lines-together="true">
          <li>
          <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a3">Level 2</p>
          <ul id="_61961034-0fb1-436b-b281-828857a59ddc"  keep-with-next="true" keep-lines-together="true">
          <li>
          <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a3">Level 3</p>
          <ul id="_61961034-0fb1-436b-b281-828857a59ddc"  keep-with-next="true" keep-lines-together="true">
          <li>
          <p id="_cb370dd3-8463-4ec7-aa1a-96f644e2e9a3">Level 4</p>
        </li>
        </ul>
        </li>
        </ul>
        </li>
          </ul>
        </li>
      </ul>
      </foreword></preface>
      </iso-standard>
    INPUT
    presxml = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <preface>
            <foreword displayorder="1" id="fwd">
               <title id="_">Foreword</title>
               <fmt-title depth="1">Foreword</fmt-title>
               <ul id="_" keep-with-next="true" keep-lines-together="true">
                  <name id="_">Caption</name>
                  <fmt-name>
                     <semx element="name" source="_">Caption</semx>
                  </fmt-name>
                  <li>
                     <fmt-name>
                        <semx element="autonum" source="">•</semx>
                     </fmt-name>
                     <p id="_">Level 1</p>
                  </li>
                  <li>
                     <fmt-name>
                        <semx element="autonum" source="">•</semx>
                     </fmt-name>
                     <p id="_">deletion of 4.3.</p>
                     <ul id="_" keep-with-next="true" keep-lines-together="true">
                        <li>
                           <fmt-name>
                              <semx element="autonum" source="">−</semx>
                           </fmt-name>
                           <p id="_">Level 2</p>
                           <ul id="_" keep-with-next="true" keep-lines-together="true">
                              <li>
                                 <fmt-name>
                                    <semx element="autonum" source="">o</semx>
                                 </fmt-name>
                                 <p id="_">Level 3</p>
                                 <ul id="_" keep-with-next="true" keep-lines-together="true">
                                    <li>
                                       <fmt-name>
                                          <semx element="autonum" source="">•</semx>
                                       </fmt-name>
                                       <p id="_">Level 4</p>
                                    </li>
                                 </ul>
                              </li>
                           </ul>
                        </li>
                     </ul>
                  </li>
               </ul>
            </foreword>
            <clause type="toc" id="_" displayorder="2">
               <fmt-title depth="1">Table of contents</fmt-title>
            </clause>
         </preface>
      </iso-standard>
    INPUT
    xml = Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
    .convert("test", input, true))
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes ordered lists" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface>
          <foreword id="_" displayorder="2">
          <ol id="_ae34a226-aab4-496d-987b-1aa7b6314026" type="alphabet"  keep-with-next="true" keep-lines-together="true">
          <name>Caption</name>
        <li>
          <p id="_0091a277-fb0e-424a-aea8-f0001303fe78">Level 1</p>
          </li>
          </ol>
        <ol id="A">
        <li>
          <p id="_0091a277-fb0e-424a-aea8-f0001303fe78">Level 1</p>
          </li>
        <li>
          <p id="_8a7b6299-db05-4ff8-9de7-ff019b9017b2">Level 1</p>
        <ol>
        <li>
          <p id="_ea248b7f-839f-460f-a173-a58a830b2abe">Level 2</p>
        <ol>
        <li>
          <p id="_ea248b7f-839f-460f-a173-a58a830b2abe">Level 3</p>
        <ol>
        <li>
          <p id="_ea248b7f-839f-460f-a173-a58a830b2abe">Level 4</p>
        </li>
        </ol>
        </li>
        </ol>
        </li>
        </ol>
        </li>
        </ol>
        </li>
      </ol>
      </foreword></preface>
      </iso-standard>
    INPUT
    presxml = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <preface>
            <clause type="toc" id="_" displayorder="1">
               <fmt-title depth="1">Contents</fmt-title>
            </clause>
            <foreword id="_" displayorder="2">
               <title id="_">Foreword</title>
               <fmt-title depth="1">
                  <semx element="title" source="_">Foreword</semx>
               </fmt-title>
               <ol id="_" type="alphabet" keep-with-next="true" keep-lines-together="true" autonum="1">
                  <name id="_">Caption</name>
                  <fmt-name>
                     <semx element="name" source="_">Caption</semx>
                  </fmt-name>
                  <li id="_">
                     <fmt-name>
                        <semx element="autonum" source="_">a</semx>
                        <span class="fmt-label-delim">)</span>
                     </fmt-name>
                     <p id="_">Level 1</p>
                  </li>
               </ol>
               <ol id="A" type="alphabet">
                  <li id="_">
                     <fmt-name>
                        <semx element="autonum" source="_">a</semx>
                        <span class="fmt-label-delim">)</span>
                     </fmt-name>
                     <p id="_">Level 1</p>
                  </li>
                  <li id="_">
                     <fmt-name>
                        <semx element="autonum" source="_">b</semx>
                        <span class="fmt-label-delim">)</span>
                     </fmt-name>
                     <p id="_">Level 1</p>
                     <ol type="arabic">
                        <li id="_">
                           <fmt-name>
                              <semx element="autonum" source="_">1</semx>
                              <span class="fmt-label-delim">.</span>
                           </fmt-name>
                           <p id="_">Level 2</p>
                           <ol type="roman">
                              <li id="_">
                                 <fmt-name>
                                    <span class="fmt-label-delim">(</span>
                                    <semx element="autonum" source="_">i</semx>
                                    <span class="fmt-label-delim">)</span>
                                 </fmt-name>
                                 <p id="_">Level 3</p>
                                 <ol type="alphabet_upper">
                                    <li id="_">
                                       <fmt-name>
                                          <semx element="autonum" source="_">A</semx>
                                          <span class="fmt-label-delim">.</span>
                                       </fmt-name>
                                       <p id="_">Level 4</p>
                                    </li>
                                 </ol>
                              </li>
                           </ol>
                        </li>
                     </ol>
                  </li>
               </ol>
            </foreword>
         </preface>
      </iso-standard>
    INPUT
    xml = Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
    .convert("test", input, true))
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes ordered lists, #2" do
    input = <<~INPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
          <clause id="A" displayorder="1">
            <fmt-title>Clause</fmt-title>
            <ol start="4" type="arabic">
              <li>
                <ol type="roman_upper">
                  <li>A</li>
                </ol>
              </li>
            </ol>
          </clause>
        </sections>
      </bipm-standard>
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
      #{HTML_HDR}
          <div id='A'>
            <h1>Clause</h1>
            <div class="ol_wrap">
            <ol type='1' start='4'>
              <li>
              <div class="ol_wrap">
                <ol type='I'>
                  <li>A</li>
                </ol>
                </div>
              </li>
            </ol>
            </div>
          </div>
        </div>
      </body>
    OUTPUT
    stripped_html = Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "processes nested roman and alphabetic lists" do
    input = <<~"INPUT"
      <bipm-standard type="semantic" version="#{Metanorma::Bipm::VERSION}" xmlns="https://www.metanorma.org/ns/bipm">
        <preface>
        <foreword displayorder="1"><fmt-title>Foreword</fmt-title>
          <ol id="_a165a98f-d641-4ccc-9c7e-d3268d93130c" type="alphabet_upper">
            <li>
              <p id="_484e82a7-48a3-4d88-a575-34143c9f7813">a</p>
              <ol id="_512ecf9b-3920-4726-892c-6c5563d97cea" type="alphabet">
                <li>
                  <p id="_ce9cb812-6652-4cf4-bf61-7237df4f3958">a1</p>
                </li>
              </ol>
            </li>
            <li>
              <p id="_8a13966e-2d6c-4b76-94e3-240d5a00a66b">a2</p>
              <ol id="_b9fb9f0c-29a0-498c-ae78-42b5fab5c418" start="5" type="alphabet">
                <li>
                  <p id="_36f055e4-5cfa-430c-80b9-8a53617af152">b</p>
                  <ol id="_fccf5477-00b4-42dc-8a32-d7838b3a6880" start="10" type="alphabet">
                    <li>
                      <p id="_388d07a4-882d-4f1b-8832-aca813714043">c</p>
                    </li>
                  </ol>
                </li>
                <li>
                  <ol id="_e883e785-1a4f-4af1-be63-28187c9b8c6a" start="2" type="roman">
                    <li>
                      <p>c1</p>
                    </li>
                  </ol>
                  <p id="_16e6dafe-d3f2-44c5-bb79-303bc9385d92">d</p>
                  <ol id="_e883e785-1a4f-4af1-be63-28187c9b8c69" type="roman">
                    <li>
                      <p id="_c11e737b-0f02-4d80-9733-84561d743cbf">e</p>
                      <ol id="_46c2218e-d5e4-4aca-940e-37e8c6099a27" start="12" type="roman">
                        <li>
                          <p id="_5c9d3bb2-1a86-4724-8f87-56a2df85f6d9">f</p>
                        </li>
                        <li>
                          <p id="_23f4cf36-19c6-48ac-be10-0740cc143a29">g</p>
                        </li>
                      </ol>
                    </li>
                    <li>
                      <p id="_20c2f77a-932c-41ac-8077-8bab94e56232">h</p>
                    </li>
                  </ol>
                </li>
                <li>
                  <p id="_58854800-eef7-4c13-843a-1ad6eb028cc8">i</p>
                </li>
              </ol>
            </li>
            <li>
              <p id="_0227008e-aaac-4b64-8914-3c1c8a27b587">j</p>
            </li>
          </ol>
          </foreword>
        </preface>
      </bipm-standard>
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
           <br/>
           <div>
             <h1 class="ForewordTitle">Foreword</h1>
             <div class="ol_wrap">
               <ol type="A" id="_">
                 <li>
                   <p id="_">a</p>
                   <div class="ol_wrap">
                     <ol type="a" id="_" class="alphabet">
                       <li>
                         <p id="_">a1</p>
                       </li>
                     </ol>
                   </div>
                 </li>
                 <li>
                   <p id="_">a2</p>
                   <div class="ol_wrap">
                     <ol type="a" id="_" style="counter-reset: alphabet 4;" start="5" class="alphabet">
                       <li>
                         <p id="_">b</p>
                         <div class="ol_wrap">
                           <ol type="a" id="_" start="10">
                             <li>
                               <p id="_">c</p>
                             </li>
                           </ol>
                         </div>
                       </li>
                       <li>
                         <div class="ol_wrap">
                           <ol type="i" id="_" style="counter-reset: roman 1;" start="2" class="roman">
                             <li>
                               <p>c1</p>
                             </li>
                           </ol>
                         </div>
                         <p id="_">d</p>
                         <div class="ol_wrap">
                           <ol type="i" id="_" class="roman">
                             <li>
                               <p id="_">e</p>
                               <div class="ol_wrap">
                                 <ol type="i" id="_" start="12">
                                   <li>
                                     <p id="_">f</p>
                                   </li>
                                   <li>
                                     <p id="_">g</p>
                                   </li>
                                 </ol>
                               </div>
                             </li>
                             <li>
                               <p id="_">h</p>
                             </li>
                           </ol>
                         </div>
                       </li>
                       <li>
                         <p id="_">i</p>
                       </li>
                     </ol>
                   </div>
                 </li>
                 <li>
                   <p id="_">j</p>
                 </li>
               </ol>
             </div>
           </div>
         </div>
       </body>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes notes" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          <script>Latn</script>
          </bibdata>
          <preface><foreword id="A">
        <p id="B">abc</p>
        <note id="C">Hello</note>
        <ul id="D">
        <li><p id="E">List item</p>
        <note id="F">List note</note>
        </li>
        </ul>
        </foreword></preface>
        <sections><clause id="A1">
        <p id="B1">abc</p>
        <note id="C1">Hello</note>
        <ul id="D1">
        <li><p id="E1">List item</p>
        <note id="F1">List note</note>
        </li>
        </ul>
        </clause></sections>
      </iso-standard>
    INPUT

    presxml = <<~PRESXML
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <bibdata>
            <language current="true">en</language>
            <script current="true">Latn</script>
         </bibdata>
         <preface>
            <clause type="toc" id="_" displayorder="1">
               <fmt-title depth="1">Contents</fmt-title>
            </clause>
            <foreword id="A" displayorder="2">
               <title id="_">Foreword</title>
               <fmt-title depth="1">
                  <semx element="title" source="_">Foreword</semx>
               </fmt-title>
               <p id="B">abc</p>
               <note id="C" autonum="1">
                  <fmt-name>
                     <span class="fmt-caption-label">NOTE</span>
                     <span class="fmt-label-delim">
                        :
                        <tab/>
                     </span>
                  </fmt-name>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Note</span>
                     <semx element="autonum" source="C">1</semx>
                  </fmt-xref-label>
                  <fmt-xref-label container="A">
                     <span class="fmt-xref-container">
                        <semx element="foreword" source="A">Foreword</semx>
                     </span>
                     <span class="fmt-comma">,</span>
                     <span class="fmt-element-name">Note</span>
                     <semx element="autonum" source="C">1</semx>
                  </fmt-xref-label>
                  Hello
               </note>
               <ul id="D">
                  <li>
                     <fmt-name>
                        <semx element="autonum" source="">•</semx>
                     </fmt-name>
                     <p id="E">List item</p>
                     <note id="F" autonum="2">
                        <fmt-name>
                           <span class="fmt-caption-label">NOTE</span>
                           <span class="fmt-label-delim">
                              :
                              <tab/>
                           </span>
                        </fmt-name>
                        <fmt-xref-label>
                           <span class="fmt-element-name">Note</span>
                           <semx element="autonum" source="F">2</semx>
                        </fmt-xref-label>
                        <fmt-xref-label container="A">
                           <span class="fmt-xref-container">
                              <semx element="foreword" source="A">Foreword</semx>
                           </span>
                           <span class="fmt-comma">,</span>
                           <span class="fmt-element-name">Note</span>
                           <semx element="autonum" source="F">2</semx>
                        </fmt-xref-label>
                        List note
                     </note>
                  </li>
               </ul>
            </foreword>
         </preface>
         <sections>
            <clause id="A1" displayorder="3">
               <fmt-title depth="1">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="A1">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Chapter</span>
                  <semx element="autonum" source="A1">1</semx>
               </fmt-xref-label>
               <p id="B1">abc</p>
               <note id="C1" autonum="1">
                  <fmt-name>
                     <span class="fmt-caption-label">Note</span>
                     <span class="fmt-label-delim">
                        :
                        <tab/>
                     </span>
                  </fmt-name>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Note</span>
                     <semx element="autonum" source="C1">1</semx>
                  </fmt-xref-label>
                  <fmt-xref-label container="A1">
                     <span class="fmt-xref-container">
                        <span class="fmt-element-name">Chapter</span>
                        <semx element="autonum" source="A1">1</semx>
                     </span>
                     <span class="fmt-comma">,</span>
                     <span class="fmt-element-name">Note</span>
                     <semx element="autonum" source="C1">1</semx>
                  </fmt-xref-label>
                  Hello
               </note>
               <ul id="D1">
                  <li>
                     <fmt-name>
                        <semx element="autonum" source="">•</semx>
                     </fmt-name>
                     <p id="E1">List item</p>
                     <note id="F1" autonum="2">
                        <fmt-name>
                           <span class="fmt-caption-label">Note</span>
                           <span class="fmt-label-delim">
                              :
                              <tab/>
                           </span>
                        </fmt-name>
                        <fmt-xref-label>
                           <span class="fmt-element-name">Note</span>
                           <semx element="autonum" source="F1">2</semx>
                        </fmt-xref-label>
                        <fmt-xref-label container="A1">
                           <span class="fmt-xref-container">
                              <span class="fmt-element-name">Chapter</span>
                              <semx element="autonum" source="A1">1</semx>
                           </span>
                           <span class="fmt-comma">,</span>
                           <span class="fmt-element-name">Note</span>
                           <semx element="autonum" source="F1">2</semx>
                        </fmt-xref-label>
                        List note
                     </note>
                  </li>
               </ul>
            </clause>
         </sections>
      </iso-standard>
    PRESXML

    xml = Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
    .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)

    presxml = <<~PRESXML
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <bibdata>
            <language current="true">fr</language>
            <script current="true">Latn</script>
         </bibdata>
         <preface>
            <clause type="toc" id="_" displayorder="1">
               <fmt-title depth="1">Table des matières</fmt-title>
            </clause>
            <foreword id="A" displayorder="2">
               <title id="_">Avant-propos</title>
               <fmt-title depth="1">
                  <semx element="title" source="_">Avant-propos</semx>
               </fmt-title>
               <p id="B">abc</p>
               <note id="C" autonum="1">
                  <fmt-name>
                     <span class="fmt-caption-label">NOTE</span>
                     <span class="fmt-label-delim">
                         :
                        <tab/>
                     </span>
                  </fmt-name>
                  <fmt-xref-label>
                     <span class="fmt-element-name">note</span>
                     <semx element="autonum" source="C">1</semx>
                  </fmt-xref-label>
                  <fmt-xref-label container="A">
                     <span class="fmt-xref-container">
                        <semx element="foreword" source="A">Avant-propos</semx>
                     </span>
                     <span class="fmt-comma">,</span>
                     <span class="fmt-element-name">note</span>
                     <semx element="autonum" source="C">1</semx>
                  </fmt-xref-label>
                  Hello
               </note>
               <ul id="D">
                  <li>
                     <fmt-name>
                        <semx element="autonum" source="">•</semx>
                     </fmt-name>
                     <p id="E">List item</p>
                     <note id="F" autonum="2">
                        <fmt-name>
                           <span class="fmt-caption-label">NOTE</span>
                           <span class="fmt-label-delim">
                               :
                              <tab/>
                           </span>
                        </fmt-name>
                        <fmt-xref-label>
                           <span class="fmt-element-name">note</span>
                           <semx element="autonum" source="F">2</semx>
                        </fmt-xref-label>
                        <fmt-xref-label container="A">
                           <span class="fmt-xref-container">
                              <semx element="foreword" source="A">Avant-propos</semx>
                           </span>
                           <span class="fmt-comma">,</span>
                           <span class="fmt-element-name">note</span>
                           <semx element="autonum" source="F">2</semx>
                        </fmt-xref-label>
                        List note
                     </note>
                  </li>
               </ul>
            </foreword>
         </preface>
         <sections>
            <clause id="A1" displayorder="3">
               <fmt-title depth="1">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="A1">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">chapitre</span>
                  <semx element="autonum" source="A1">1</semx>
               </fmt-xref-label>
               <p id="B1">abc</p>
               <note id="C1" autonum="1">
                  <fmt-name>
                     <span class="fmt-caption-label">Note</span>
                     <span class="fmt-label-delim">
                         :
                        <tab/>
                     </span>
                  </fmt-name>
                  <fmt-xref-label>
                     <span class="fmt-element-name">note</span>
                     <semx element="autonum" source="C1">1</semx>
                  </fmt-xref-label>
                  <fmt-xref-label container="A1">
                     <span class="fmt-xref-container">
                        <span class="fmt-element-name">chapitre</span>
                        <semx element="autonum" source="A1">1</semx>
                     </span>
                     <span class="fmt-comma">,</span>
                     <span class="fmt-element-name">note</span>
                     <semx element="autonum" source="C1">1</semx>
                  </fmt-xref-label>
                  Hello
               </note>
               <ul id="D1">
                  <li>
                     <fmt-name>
                        <semx element="autonum" source="">•</semx>
                     </fmt-name>
                     <p id="E1">List item</p>
                     <note id="F1" autonum="2">
                        <fmt-name>
                           <span class="fmt-caption-label">Remarque</span>
                           <span class="fmt-label-delim">
                               :
                              <tab/>
                           </span>
                        </fmt-name>
                        <fmt-xref-label>
                           <span class="fmt-element-name">note</span>
                           <semx element="autonum" source="F1">2</semx>
                        </fmt-xref-label>
                        <fmt-xref-label container="A1">
                           <span class="fmt-xref-container">
                              <span class="fmt-element-name">chapitre</span>
                              <semx element="autonum" source="A1">1</semx>
                           </span>
                           <span class="fmt-comma">,</span>
                           <span class="fmt-element-name">note</span>
                           <semx element="autonum" source="F1">2</semx>
                        </fmt-xref-label>
                        List note
                     </note>
                  </li>
               </ul>
            </clause>
         </sections>
      </iso-standard>
    PRESXML

    xml = Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input.sub("<language>en</language>",
                                 "<language>fr</language>"), true))
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end
end
