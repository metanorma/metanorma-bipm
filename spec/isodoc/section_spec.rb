require "spec_helper"

RSpec.describe IsoDoc::Bipm do
  it "processes duplicate ids between Semantic and Presentation XML titles" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
           <sections>
           <clause id="A1">
           <title>Title <bookmark id="A2"/> <index><primary>title</primary></index></title>
           </clause>
           <clause id="A2">
           <variant-title type='quoted'>Title <bookmark id="A3"/> <index><primary>title2</primary></index></variant-title>
           </clause>
           </sections>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <?xml version="1.0"?>
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
           <preface><clause type="toc" id="_" displayorder="1"><fmt-title depth="1" id="_">Contents</fmt-title></clause>
       </preface><sections>
           <clause id="A1" displayorder="2">
           <title id="_">Title <bookmark original-id="A2"/> </title><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A1">1</semx><span class="fmt-clause-delim">.</span></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_">Title <bookmark id="A2"/> <bookmark id="_"/></semx></fmt-title><fmt-xref-label><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="A1">1</semx></fmt-xref-label>
           </clause>
           <clause id="A2" displayorder="3">
           <title type="quoted" id="_">Title <bookmark original-id="A3"/> </title><fmt-title depth="1" id="_"><span class="fmt-caption-label"><span style="font-size:130%">&#x25A0;</span>&#xA0;&#xA0;</span><span class="fmt-caption-delim"/><semx element="title" source="_">Title <bookmark id="A3"/> <bookmark id="_"/></semx></fmt-title>
           </clause>
           </sections>
      <indexsect id="_" displayorder="4"><fmt-title id="_">Index</fmt-title><clause id="_"><title id="_">T</title><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>title,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="A1">1</semx></fmt-xref></semx></li><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>title2,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="A1">1</semx></fmt-xref></semx></li></ul></clause></indexsect></iso-standard>
    OUTPUT
    expect(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)))
      .to be_xml_equivalent_to output
  end

  it "generates document control text" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::Bipm::VERSION}" type="semantic">
        <bibdata type="standard">
          <title language='en' format='text/plain' type='title-main'>Main Title</title>
          <title language='en' format='text/plain' type='title-cover'>Main Title (SI)</title>
          <title language='en' format='text/plain' type='title-appendix'>Main Title (SI)</title>
            <contributor>
              <role type="author"/>
              <organization>
                <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
              </organization>
            </contributor>
              <contributor>
              <role type='author'/>
              <person>
                <name>
                  <completename>Andrew Yacoot</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NPL</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type='author'/>
              <person>
                <name>
                  <completename>Ulrich Kuetgens</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>PTB</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type='author'/>
              <person>
                <name>
                  <completename>Enrico Massa</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>INRIM</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
               <role type='editor'>WG-N co-chair</role>
              <person>
                <name>
                  <completename>Ronald Dixson</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NIST</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
             <role type='editor'>WG-N co-chair</role>
              <person>
                <name>
                  <completename>Harald Bosse</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>PTB</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
             <role type='editor'>WG-N chair</role>
              <person>
                <name>
                  <completename>Andrew Yacoot</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NPL</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
              </organization>
            </contributor>
            <edition>2</edition>
          <version>
            <revision-date>2000-01-01</revision-date>
            <draft>3.4</draft>
          </version>
            <language>en</language>
            <script>Latn</script>
            <status>
              <stage>working-draft</stage>
              <iteration>3</iteration>
            </status>
          <relation type='successorOf'>
            <bibitem>
              <date type='published'>2018-06-11</date>
              <edition>1.0</edition>
              <version>
                <draft>1.0</draft>
              </version>
            </bibitem>
          </relation>
          <relation type='successorOf'>
            <bibitem>
              <date type='published'>2019-06-11</date>
              <edition>2.0</edition>
              <version>
                <draft>2.0</draft>
              </version>
            </bibitem>
          </relation>
          <relation type='successorOf'>
            <bibitem>
              <date type='circulated'>2019-06-11</date>
              <version>
                <draft>3.0</draft>
              </version>
            </bibitem>
          </relation>
        </bibdata>
        <sections>
        <clause/>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~OUTPUT
      <?xml version="1.0"?>
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" version="#{Metanorma::Bipm::VERSION}" type="presentation">
        <bibdata type="standard">
          <title language="en" format="text/plain" type="title-main">Main Title</title>
          <title language="en" format="text/plain" type="title-cover">Main Title (SI)</title>
          <title language="en" format="text/plain" type="title-appendix">Main Title (SI)</title>
            <contributor>
              <role type="author"/>
              <organization>
                <name>Bureau International des Poids et Mesures</name>
                <abbreviation>BIPM</abbreviation>
              </organization>
            </contributor>
              <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Andrew Yacoot</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NPL</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Ulrich Kuetgens</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>PTB</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Enrico Massa</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>INRIM</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
               <role type="editor">WG-N co-chair</role>
              <person>
                <name>
                  <completename>Ronald Dixson</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NIST</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
             <role type="editor">WG-N co-chair</role>
              <person>
                <name>
                  <completename>Harald Bosse</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>PTB</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
             <role type="editor">WG-N chair</role>
              <person>
                <name>
                  <completename>Andrew Yacoot</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NPL</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>Bureau International des Poids et Mesures</name>
                <abbreviation>BIPM</abbreviation>
              <logo type="full"><image src="" mimetype="image/svg+xml"><svg xmlns="http://www.w3.org/2000/svg" id="uuid-4162b5c4-51d5-4227-8dcd-f05974f2b5f8" width="206.54mm" height="104.93mm" viewBox="0 0 585.46 297.43" preserveaspectratio="xMidYMin slice"><path d="M31.43,8h18.98c4.51,0,7.93,1.08,10.27,3.25s3.51,5.29,3.51,9.36c0,2.47-.44,4.52-1.33,6.14-.89,1.62-2.24,3-4.06,4.13,1.82.35,3.37.88,4.65,1.59,1.28.72,2.32,1.59,3.12,2.63.8,1.04,1.38,2.21,1.72,3.51.35,1.3.52,2.69.52,4.16,0,2.3-.4,4.33-1.2,6.11-.8,1.78-1.93,3.27-3.38,4.48-1.45,1.21-3.22,2.12-5.3,2.73-2.08.61-4.42.91-7.02.91h-20.48V8ZM44.17,27.23h2.34c3.99,0,5.98-1.58,5.98-4.75s-1.99-4.74-5.98-4.74h-2.34v9.49ZM44.17,47.13h2.79c3.21,0,5.5-.41,6.89-1.24,1.39-.82,2.08-2.14,2.08-3.96s-.69-3.14-2.08-3.96-3.68-1.24-6.89-1.24h-2.79v10.4Z" style="fill:#0f3c80;"/><path d="M101.63,43.93c0,4.85-.98,8.4-2.94,10.66s-5.01,3.4-9.16,3.4-7.23-1.13-9.17-3.4c-1.95-2.26-2.92-5.82-2.92-10.66v-17.27h5.21v17.08c0,3.24.52,5.59,1.57,7.05,1.05,1.46,2.82,2.19,5.32,2.19s4.26-.72,5.28-2.16c1.03-1.44,1.54-3.8,1.54-7.08v-17.08h5.27v17.27Z" style="fill:#0f3c80;"/><path d="M129.47,26.31l-1.24,5.14c-.38-.23-.79-.41-1.24-.52s-.92-.17-1.43-.17c-2.56,0-4.49,1.1-5.79,3.29-1.3,2.19-1.95,5.46-1.95,9.82v13.14h-5.17v-30.34h5.17v5.33c.74-2.18,1.81-3.77,3.21-4.76s3.26-1.49,5.59-1.49c.55,0,1.08.05,1.6.16s.94.24,1.25.41Z" style="fill:#0f3c80;"/><path d="M161.05,42.63h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM155.88,38.95c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M197.59,57.01h-5.21v-5.01c-1.04,1.95-2.49,3.43-4.36,4.46-1.87,1.03-4.08,1.54-6.62,1.54-4.23,0-7.71-1.53-10.44-4.6-2.73-3.07-4.09-6.99-4.09-11.78s1.37-8.49,4.11-11.44c2.74-2.95,6.26-4.43,10.55-4.43,2.43,0,4.58.48,6.44,1.43,1.86.95,3.33,2.32,4.41,4.09v-4.6h5.21v30.34ZM192.38,41.48c0-3.32-.92-5.95-2.75-7.89-1.83-1.94-4.27-2.9-7.32-2.9s-5.49,1.01-7.38,3.02-2.84,4.67-2.84,7.97.93,6.06,2.79,8.16c1.86,2.09,4.25,3.14,7.17,3.14s5.42-1.07,7.38-3.22c1.96-2.15,2.94-4.9,2.94-8.27Z" style="fill:#0f3c80;"/><path d="M232.19,43.93c0,4.85-.98,8.4-2.94,10.66s-5.01,3.4-9.16,3.4-7.23-1.13-9.17-3.4c-1.95-2.26-2.92-5.82-2.92-10.66v-17.27h5.21v17.08c0,3.24.52,5.59,1.57,7.05,1.05,1.46,2.82,2.19,5.32,2.19s4.26-.72,5.28-2.16c1.03-1.44,1.54-3.8,1.54-7.08v-17.08h5.27v17.27Z" style="fill:#0f3c80;"/><path d="M153.42,202.46h-12.74v-49.01h20.28c5.5,0,9.72,1.43,12.64,4.29,2.92,2.86,4.39,6.89,4.39,12.09s-1.46,9.23-4.39,12.09c-2.92,2.86-7.14,4.29-12.64,4.29h-7.54v16.25ZM153.42,175.94h4.22c4.68,0,7.02-2.04,7.02-6.11s-2.34-6.11-7.02-6.11h-4.22v12.22Z" style="fill:#0f3c80;"/><path d="M215.68,187.2c0,4.51-1.58,8.34-4.73,11.51-3.15,3.16-6.99,4.74-11.52,4.74s-8.29-1.58-11.41-4.73c-3.12-3.15-4.68-6.99-4.68-11.52s1.54-8.33,4.63-11.39c3.09-3.07,6.91-4.6,11.46-4.6s8.45,1.54,11.57,4.62c3.12,3.08,4.68,6.87,4.68,11.38ZM210.5,187.2c0-3.19-1.06-5.83-3.17-7.92-2.12-2.08-4.73-3.13-7.84-3.13s-5.75,1.04-7.84,3.13-3.14,4.72-3.14,7.92,1.06,5.9,3.19,8.06c2.13,2.16,4.72,3.24,7.79,3.24s5.75-1.08,7.85-3.24,3.16-4.84,3.16-8.06Z" style="fill:#0f3c80;"/><path d="M230.6,160.16c0,.97-.35,1.81-1.06,2.51-.71.7-1.55,1.05-2.52,1.05s-1.81-.35-2.51-1.05c-.7-.7-1.05-1.53-1.05-2.51s.35-1.81,1.05-2.52c.7-.71,1.53-1.06,2.51-1.06s1.81.35,2.52,1.06c.71.71,1.06,1.55,1.06,2.52ZM229.62,202.46h-5.21v-30.34h5.21v30.34Z" style="fill:#0f3c80;"/><path d="M269.3,202.46h-5.21v-5.01c-1.04,1.95-2.49,3.43-4.36,4.46-1.87,1.03-4.08,1.54-6.62,1.54-4.23,0-7.71-1.53-10.44-4.6-2.73-3.07-4.09-6.99-4.09-11.78s1.37-8.49,4.11-11.44c2.74-2.95,6.26-4.43,10.55-4.43,2.43,0,4.58.48,6.44,1.43,1.86.95,3.33,2.32,4.41,4.09v-27.9h5.21v53.64ZM264.09,186.94c0-3.32-.92-5.95-2.75-7.89-1.83-1.94-4.27-2.9-7.32-2.9s-5.49,1.01-7.38,3.02-2.84,4.67-2.84,7.97.93,6.06,2.79,8.16c1.86,2.09,4.25,3.14,7.17,3.14s5.42-1.07,7.38-3.22c1.96-2.15,2.94-4.9,2.94-8.27Z" style="fill:#0f3c80;"/><path d="M298.95,194.28c0,2.79-1.02,5.02-3.05,6.68s-4.8,2.49-8.32,2.49c-2.64,0-4.88-.53-6.71-1.6-1.83-1.07-3.17-2.62-4.01-4.65l4.41-2.79c.61,1.46,1.47,2.55,2.57,3.27,1.1.72,2.45,1.08,4.06,1.08,1.78,0,3.19-.37,4.25-1.11,1.06-.74,1.59-1.76,1.59-3.05,0-1.42-.48-2.5-1.44-3.24-.96-.74-2.84-1.61-5.63-2.6-2.73-1.02-4.78-2.27-6.14-3.78-1.36-1.5-2.05-3.28-2.05-5.33,0-2.62.87-4.69,2.62-6.19,1.75-1.5,4.18-2.25,7.32-2.25,2.29,0,4.19.47,5.71,1.4,1.52.93,2.74,2.37,3.65,4.32l-4.28,2.6c-.55-1.27-1.25-2.21-2.1-2.81-.85-.6-1.9-.9-3.17-.9-1.46,0-2.6.33-3.43,1-.82.67-1.24,1.57-1.24,2.71s.43,2.14,1.29,2.92c.86.78,2.42,1.54,4.68,2.29,3.34,1.08,5.75,2.37,7.22,3.86,1.47,1.49,2.21,3.39,2.21,5.7Z" style="fill:#0f3c80;"/><path d="M349.97,188.09h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM344.79,184.4c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M365.13,176.79h-4.82v25.68h-5.17v-25.68h-3.65v-4.67h3.65v-12.28h5.17v12.28h4.82v4.67Z" style="fill:#0f3c80;"/><path d="M188.58,275.07l8.32-49.01h12.61l9.81,26.13,9.75-26.13h12.61l8.32,49.01h-12.67l-4.22-28.21-11.57,28.21h-5.07l-10.98-28.21-4.23,28.21h-12.67Z" style="fill:#0f3c80;"/><path d="M284.57,260.69h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM279.39,257.01c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M310.2,266.88c0,2.79-1.02,5.02-3.05,6.68s-4.8,2.49-8.32,2.49c-2.64,0-4.88-.53-6.71-1.6-1.83-1.07-3.17-2.62-4.01-4.65l4.41-2.79c.61,1.46,1.47,2.55,2.57,3.27,1.1.72,2.45,1.08,4.06,1.08,1.78,0,3.19-.37,4.25-1.11,1.06-.74,1.59-1.76,1.59-3.05,0-1.42-.48-2.5-1.44-3.24-.96-.74-2.84-1.61-5.63-2.6-2.73-1.02-4.78-2.27-6.14-3.78-1.36-1.5-2.05-3.28-2.05-5.33,0-2.62.87-4.69,2.62-6.19,1.75-1.5,4.18-2.25,7.32-2.25,2.29,0,4.19.47,5.71,1.4,1.52.93,2.74,2.37,3.65,4.32l-4.28,2.6c-.55-1.27-1.25-2.21-2.1-2.81-.85-.6-1.9-.9-3.17-.9-1.46,0-2.6.33-3.43,1-.82.67-1.24,1.57-1.24,2.71s.43,2.14,1.29,2.92c.86.78,2.42,1.54,4.68,2.29,3.34,1.08,5.75,2.37,7.22,3.86,1.47,1.49,2.21,3.39,2.21,5.7Z" style="fill:#0f3c80;"/><path d="M342.17,261.99c0,4.85-.98,8.4-2.94,10.66s-5.01,3.4-9.16,3.4-7.23-1.13-9.17-3.4c-1.95-2.26-2.92-5.82-2.92-10.66v-17.27h5.21v17.08c0,3.24.52,5.59,1.57,7.05,1.05,1.46,2.82,2.19,5.32,2.19s4.26-.72,5.28-2.16c1.03-1.44,1.54-3.8,1.54-7.08v-17.08h5.27v17.27Z" style="fill:#0f3c80;"/><path d="M369.04,244.38l-1.24,5.14c-.38-.23-.79-.41-1.24-.52s-.92-.17-1.43-.17c-2.56,0-4.49,1.1-5.79,3.29-1.3,2.19-1.95,5.46-1.95,9.82v13.14h-5.17v-30.34h5.17v5.33c.74-2.18,1.81-3.77,3.21-4.76s3.26-1.49,5.59-1.49c.55,0,1.08.05,1.6.16s.94.24,1.25.41Z" style="fill:#0f3c80;"/><path d="M399.65,260.69h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM394.47,257.01c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M425.28,266.88c0,2.79-1.02,5.02-3.05,6.68s-4.8,2.49-8.32,2.49c-2.64,0-4.88-.53-6.71-1.6-1.83-1.07-3.17-2.62-4.01-4.65l4.41-2.79c.61,1.46,1.47,2.55,2.57,3.27,1.1.72,2.45,1.08,4.06,1.08,1.78,0,3.19-.37,4.25-1.11,1.06-.74,1.59-1.76,1.59-3.05,0-1.42-.48-2.5-1.44-3.24-.96-.74-2.84-1.61-5.63-2.6-2.73-1.02-4.78-2.27-6.14-3.78-1.36-1.5-2.05-3.28-2.05-5.33,0-2.62.87-4.69,2.62-6.19,1.75-1.5,4.18-2.25,7.32-2.25,2.29,0,4.19.47,5.71,1.4,1.52.93,2.74,2.37,3.65,4.32l-4.28,2.6c-.55-1.27-1.25-2.21-2.1-2.81-.85-.6-1.9-.9-3.17-.9-1.46,0-2.6.33-3.43,1-.82.67-1.24,1.57-1.24,2.71s.43,2.14,1.29,2.92c.86.78,2.42,1.54,4.68,2.29,3.34,1.08,5.75,2.37,7.22,3.86,1.47,1.49,2.21,3.39,2.21,5.7Z" style="fill:#0f3c80;"/><path d="M101.6,80.19v49.01h-12.74v-49.01h12.74Z" style="fill:#0f3c80;"/><path d="M138.13,129.2h-5.21v-18.12c0-2.94-.52-5.1-1.57-6.47-1.05-1.38-2.71-2.06-5-2.06-2.6,0-4.59,1.03-5.95,3.08-1.37,2.05-2.05,5.06-2.05,9.01v14.57h-5.17v-30.34h5.17v4.47c.91-1.8,2.18-3.15,3.81-4.05,1.63-.9,3.62-1.35,5.97-1.35,3.11,0,5.55,1.03,7.33,3.08s2.67,4.93,2.67,8.63v19.55Z" style="fill:#0f3c80;"/><path d="M158.93,103.52h-4.82v25.68h-5.17v-25.68h-3.65v-4.67h3.65v-12.28h5.17v12.28h4.82v4.67Z" style="fill:#0f3c80;"/><path d="M192.55,114.82h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM187.37,111.14c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M217.66,98.51l-1.24,5.14c-.38-.23-.79-.41-1.24-.52s-.92-.17-1.43-.17c-2.56,0-4.49,1.1-5.79,3.29-1.3,2.19-1.95,5.46-1.95,9.82v13.14h-5.17v-30.34h5.17v5.33c.74-2.18,1.81-3.77,3.21-4.76s3.26-1.49,5.59-1.49c.55,0,1.08.05,1.6.16s.94.24,1.25.41Z" style="fill:#0f3c80;"/><path d="M248.29,129.2h-5.21v-18.12c0-2.94-.52-5.1-1.57-6.47-1.05-1.38-2.71-2.06-5-2.06-2.6,0-4.59,1.03-5.95,3.08-1.37,2.05-2.05,5.06-2.05,9.01v14.57h-5.17v-30.34h5.17v4.47c.91-1.8,2.18-3.15,3.81-4.05,1.63-.9,3.62-1.35,5.97-1.35,3.11,0,5.55,1.03,7.33,3.08s2.67,4.93,2.67,8.63v19.55Z" style="fill:#0f3c80;"/><path d="M287.27,129.2h-5.21v-5.01c-1.04,1.95-2.49,3.43-4.36,4.46-1.87,1.03-4.08,1.54-6.62,1.54-4.23,0-7.71-1.53-10.44-4.6-2.73-3.07-4.09-6.99-4.09-11.78s1.37-8.49,4.11-11.44c2.74-2.95,6.26-4.43,10.55-4.43,2.43,0,4.58.48,6.44,1.43,1.86.95,3.33,2.32,4.41,4.09v-4.6h5.21v30.34ZM282.07,113.68c0-3.32-.92-5.95-2.75-7.89-1.83-1.94-4.27-2.9-7.32-2.9s-5.49,1.01-7.38,3.02-2.84,4.67-2.84,7.97.93,6.06,2.79,8.16c1.86,2.09,4.25,3.14,7.17,3.14s5.42-1.07,7.38-3.22c1.96-2.15,2.94-4.9,2.94-8.27Z" style="fill:#0f3c80;"/><path d="M308.54,103.52h-4.82v25.68h-5.17v-25.68h-3.65v-4.67h3.65v-12.28h5.17v12.28h4.82v4.67Z" style="fill:#0f3c80;"/><path d="M322.93,86.89c0,.97-.35,1.81-1.06,2.51-.71.7-1.55,1.05-2.52,1.05s-1.81-.35-2.51-1.05c-.7-.7-1.05-1.53-1.05-2.51s.35-1.81,1.05-2.52c.7-.71,1.53-1.06,2.51-1.06s1.81.35,2.52,1.06c.71.71,1.06,1.55,1.06,2.52ZM321.94,129.2h-5.21v-30.34h5.21v30.34Z" style="fill:#0f3c80;"/><path d="M363.05,113.93c0,4.51-1.58,8.34-4.73,11.51-3.15,3.16-6.99,4.74-11.52,4.74s-8.29-1.58-11.41-4.73c-3.12-3.15-4.68-6.99-4.68-11.52s1.54-8.33,4.63-11.39c3.09-3.07,6.91-4.6,11.46-4.6s8.45,1.54,11.57,4.62c3.12,3.08,4.68,6.87,4.68,11.38ZM357.88,113.93c0-3.19-1.06-5.83-3.17-7.92-2.12-2.08-4.73-3.13-7.84-3.13s-5.75,1.04-7.84,3.13-3.14,4.72-3.14,7.92,1.06,5.9,3.19,8.06c2.13,2.16,4.72,3.24,7.79,3.24s5.75-1.08,7.85-3.24,3.16-4.84,3.16-8.06Z" style="fill:#0f3c80;"/><path d="M396.29,129.2h-5.21v-18.12c0-2.94-.52-5.1-1.57-6.47-1.05-1.38-2.71-2.06-5-2.06-2.6,0-4.59,1.03-5.95,3.08-1.37,2.05-2.05,5.06-2.05,9.01v14.57h-5.17v-30.34h5.17v4.47c.91-1.8,2.18-3.15,3.81-4.05,1.63-.9,3.62-1.35,5.97-1.35,3.11,0,5.55,1.03,7.33,3.08s2.67,4.93,2.67,8.63v19.55Z" style="fill:#0f3c80;"/><path d="M435.27,129.2h-5.21v-5.01c-1.04,1.95-2.49,3.43-4.36,4.46-1.87,1.03-4.08,1.54-6.62,1.54-4.23,0-7.71-1.53-10.44-4.6-2.73-3.07-4.09-6.99-4.09-11.78s1.37-8.49,4.11-11.44c2.74-2.95,6.26-4.43,10.55-4.43,2.43,0,4.58.48,6.44,1.43,1.86.95,3.33,2.32,4.41,4.09v-4.6h5.21v30.34ZM430.06,113.68c0-3.32-.92-5.95-2.75-7.89-1.83-1.94-4.27-2.9-7.32-2.9s-5.49,1.01-7.38,3.02-2.84,4.67-2.84,7.97.93,6.06,2.79,8.16c1.86,2.09,4.25,3.14,7.17,3.14s5.42-1.07,7.38-3.22c1.96-2.15,2.94-4.9,2.94-8.27Z" style="fill:#0f3c80;"/><path d="M451.59,129.2h-5.17v-53.64h5.17v53.64Z" style="fill:#0f3c80;"/><path d="M507.57,129.2h-5.21v-5.01c-1.04,1.95-2.49,3.43-4.36,4.46-1.87,1.03-4.08,1.54-6.62,1.54-4.23,0-7.71-1.53-10.44-4.6-2.73-3.07-4.09-6.99-4.09-11.78s1.37-8.49,4.11-11.44c2.74-2.95,6.26-4.43,10.55-4.43,2.43,0,4.58.48,6.44,1.43,1.86.95,3.33,2.32,4.41,4.09v-27.9h5.21v53.64ZM502.36,113.68c0-3.32-.92-5.95-2.75-7.89-1.83-1.94-4.27-2.9-7.32-2.9s-5.49,1.01-7.38,3.02-2.84,4.67-2.84,7.97.93,6.06,2.79,8.16c1.86,2.09,4.25,3.14,7.17,3.14s5.42-1.07,7.38-3.22c1.96-2.15,2.94-4.9,2.94-8.27Z" style="fill:#0f3c80;"/><path d="M540.66,114.82h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM535.49,111.14c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M567.26,121.01c0,2.79-1.02,5.02-3.05,6.68s-4.8,2.49-8.32,2.49c-2.64,0-4.88-.53-6.71-1.6-1.83-1.07-3.17-2.62-4.01-4.65l4.41-2.79c.61,1.46,1.47,2.55,2.57,3.27,1.1.72,2.45,1.08,4.06,1.08,1.78,0,3.19-.37,4.25-1.11,1.06-.74,1.59-1.76,1.59-3.05,0-1.42-.48-2.5-1.44-3.24-.96-.74-2.84-1.61-5.63-2.6-2.73-1.02-4.78-2.27-6.14-3.78-1.36-1.5-2.05-3.28-2.05-5.33,0-2.62.87-4.69,2.62-6.19,1.75-1.5,4.18-2.25,7.32-2.25,2.29,0,4.19.47,5.71,1.4,1.52.93,2.74,2.37,3.65,4.32l-4.28,2.6c-.55-1.27-1.25-2.21-2.1-2.81-.85-.6-1.9-.9-3.17-.9-1.46,0-2.6.33-3.43,1-.82.67-1.24,1.57-1.24,2.71s.43,2.14,1.29,2.92c.86.78,2.42,1.54,4.68,2.29,3.34,1.08,5.75,2.37,7.22,3.86,1.47,1.49,2.21,3.39,2.21,5.7Z" style="fill:#0f3c80;"/><rect x="31.43" y="71.7" width="4.12" height="203.36" style="fill:#0f3c80;"/><rect x="26.32" y="104.96" width="14.34" height="14.34" transform="translate(89.1 9.16) rotate(45)" style="fill:#0f3c80;"/><rect x="86.8" y="144.12" width="4.12" height="130.95" style="fill:#0f3c80;"/><rect x="81.69" y="177.37" width="14.34" height="14.34" transform="translate(156.52 -8.78) rotate(45)" style="fill:#0f3c80;"/><rect x="140.91" y="216.92" width="4.12" height="58.15" style="fill:#0f3c80;"/><rect x="135.8" y="250.17" width="14.34" height="14.34" transform="translate(223.84 -25.72) rotate(45)" style="fill:#0f3c80;"/></svg></image></logo>
      <logo type="small"><image src="" mimetype="image/svg+xml"><svg xmlns="http://www.w3.org/2000/svg" id="uuid-025413ec-7b33-4cab-9252-e1a1cbcbc7d4" width="216.86mm" height="51.44mm" viewBox="0 0 614.73 145.8" preserveaspectratio="xMidYMin slice"><rect x="40.59" y="-.11" width="9.37" height="145.75" style="fill:#0f3c80;"/><rect x="84.49" y="-.11" width="9.37" height="145.75" style="fill:#0f3c80;"/><rect x="129.99" y="-.11" width="9.37" height="145.75" style="fill:#0f3c80;"/><rect x="122.95" y="101.81" width="24.05" height="24.05" transform="translate(120.03 -62.1) rotate(45)" style="fill:#0f3c80;"/><rect x="77.01" y="60.88" width="24.05" height="24.05" transform="translate(77.63 -41.61) rotate(45)" style="fill:#0f3c80;"/><rect x="33.12" y="21.55" width="24.05" height="24.05" transform="translate(36.97 -22.09) rotate(45)" style="fill:#0f3c80;"/><path d="M191.41,25.36h42.05c9.98,0,17.57,2.4,22.75,7.2,5.18,4.8,7.78,11.71,7.78,20.74,0,5.47-.99,10.01-2.95,13.61-1.97,3.6-4.97,6.65-9,9.14,4.03.77,7.46,1.94,10.3,3.53,2.83,1.58,5.13,3.53,6.91,5.83,1.78,2.3,3.05,4.9,3.82,7.78.77,2.88,1.15,5.95,1.15,9.22,0,5.09-.89,9.6-2.66,13.54-1.78,3.94-4.27,7.25-7.49,9.94-3.22,2.69-7.13,4.71-11.74,6.05-4.61,1.34-9.79,2.02-15.55,2.02h-45.36V25.36ZM219.63,67.98h5.18c8.83,0,13.25-3.5,13.25-10.51s-4.42-10.51-13.25-10.51h-5.18v21.02ZM219.63,112.05h6.19c7.1,0,12.19-.91,15.26-2.74,3.07-1.82,4.61-4.75,4.61-8.78s-1.54-6.96-4.61-8.78c-3.07-1.82-8.16-2.74-15.26-2.74h-6.19v23.04Z" style="fill:#0f3c80;"/><path d="M315.68,25.36v108.58h-28.22V25.36h28.22Z" style="fill:#0f3c80;"/><path d="M363.05,133.93h-28.22V25.36h44.93c12.19,0,21.53,3.17,28.01,9.5,6.48,6.34,9.72,15.26,9.72,26.78s-3.24,20.45-9.72,26.78c-6.48,6.34-15.82,9.5-28.01,9.5h-16.7v36ZM363.05,75.18h9.36c10.37,0,15.55-4.51,15.55-13.54s-5.18-13.54-15.55-13.54h-9.36v27.07Z" style="fill:#0f3c80;"/><path d="M423.96,133.93l18.43-108.58h27.94l21.74,57.89,21.6-57.89h27.94l18.43,108.58h-28.08l-9.36-62.5-25.63,62.5h-11.23l-24.34-62.5-9.36,62.5h-28.08Z" style="fill:#0f3c80;"/></svg></image></logo>
      </organization>
            </contributor>
            <edition language="">2</edition><edition language="en">second edition</edition>
          <version>
            <revision-date>2000-01-01</revision-date>
            <draft>3.4</draft>
          </version>
            <language current="true">en</language>
            <script current="true">Latn</script>
            <status>
              <stage>working-draft</stage>
              <iteration>3</iteration>
            </status>
          <relation type="successorOf">
            <bibitem>
              <date type="published">2018-06-11</date>
              <edition>1.0</edition>
              <version>
                <draft>1.0</draft>
              </version>
            </bibitem>
          </relation>
          <relation type="successorOf">
            <bibitem>
              <date type="published">2019-06-11</date>
              <edition>2.0</edition>
              <version>
                <draft>2.0</draft>
              </version>
            </bibitem>
          </relation>
          <relation type="successorOf">
            <bibitem>
              <date type="circulated">2019-06-11</date>
              <version>
                <draft>3.0</draft>
              </version>
            </bibitem>
          </relation>
        </bibdata>
        <preface><clause type="toc" id="_" displayorder="1"><fmt-title depth="1" id="_">Contents</fmt-title></clause>
       </preface><sections>
        <clause id="_" displayorder="2"><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="_">1</semx><span class="fmt-clause-delim">.</span></span></fmt-title><fmt-xref-label><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="_">1</semx></fmt-xref-label></clause>
        </sections>
      <colophon><clause class="doccontrol" id="_" displayorder="3">
      <fmt-title id="_" depth="1">Document Control</fmt-title>
      <table id="_" unnumbered="true"><tbody>
      <tr id="_"><th id="_">Authors:</th><td id="_"/><td id="_">Andrew Yacoot (NPL)<span class="fmt-enum-comma">,</span> Ulrich Kuetgens (PTB)<span class="fmt-enum-comma">,</span> <span class="fmt-conn">and</span> Enrico Massa (INRIM)</td></tr>
      <tr id="_"><td id="_">Draft 1.0 Version 1.0</td><td id="_">2018-06-11</td>
      <td id="_">WG-N co-chairs: Ronald Dixson (NIST) <span class="fmt-conn">and</span> Harald Bosse (PTB)</td></tr>
       <tr id="_"><td>Draft 2.0 Version 2.0</td><td>2019-06-11</td>
      <td id="_">WG-N chair: Andrew Yacoot (NPL)</td></tr>
       <tr id="_"><td id="_">Draft 3.0 </td><td id="_">2019-06-11</td> <td/></tr>
      </tbody></table></clause>
      </colophon></bipm-standard>
    OUTPUT

    output = <<~"OUTPUT"
      <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_" class="TOC"><h1 class="IntroTitle">Contents</h1></div><div id="_"><h1>1<span class="fmt-clause-delim">.</span></h1></div><br/><div class="Section3" id="_"><h1 class="IntroTitle">Document Control</h1><table id="_" class="MsoISOTable" style="border-width:1px;border-spacing:0;"><tbody><tr><th style="font-weight:bold;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;" scope="row">Authors:</th><td style="border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;"></td><td style="border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">Andrew Yacoot (NPL), Ulrich Kuetgens (PTB), and Enrico Massa (INRIM)</td></tr><tr><td style="border-top:none;border-bottom:solid windowtext 1.0pt;">Draft 1.0 Version 1.0</td><td style="border-top:none;border-bottom:solid windowtext 1.0pt;">2018-06-11</td><td style="border-top:none;border-bottom:solid windowtext 1.0pt;">WG-N co-chairs: Ronald Dixson (NIST) and Harald Bosse (PTB)</td></tr><tr><td style="border-top:none;border-bottom:solid windowtext 1.0pt;">Draft 2.0 Version 2.0</td><td style="border-top:none;border-bottom:solid windowtext 1.0pt;">2019-06-11</td><td style="border-top:none;border-bottom:solid windowtext 1.0pt;">WG-N chair: Andrew Yacoot (NPL)</td></tr><tr><td style="border-top:none;border-bottom:solid windowtext 1.5pt;">Draft 3.0 </td><td style="border-top:none;border-bottom:solid windowtext 1.5pt;">2019-06-11</td><td style="border-top:none;border-bottom:solid windowtext 1.5pt;"></td></tr></tbody></table></div></div></body>
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
      .gsub(%r{</body>.*}m, "</body>"))).to(be_xml_equivalent_to(output))
  end

  it "generates shorter document control text" do
    input = <<~"INPUT"
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm"  version="#{Metanorma::Bipm::VERSION}" type="semantic">
        <bibdata type="standard">
          <title language='en' format='text/plain' type='title-main'>Main Title</title>
          <title language='en' format='text/plain' type='title-cover'>Main Title (SI)</title>
          <title language='en' format='text/plain' type='title-appendix'>Main Title (SI)</title>
            <contributor>
              <role type="author"/>
              <organization>
                <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
              </organization>
            </contributor>
              <contributor>
              <role type='author'/>
              <person>
                <name>
                  <completename>Andrew Yacoot</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NPL</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type='author'/>
              <person>
                <name>
                  <completename>Ulrich Kuetgens</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>PTB</name>
                  </organization>
               </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
                <abbreviation>#{Metanorma::Bipm.configuration.organization_name_short}</abbreviation>
              </organization>
            </contributor>
            <edition>2</edition>
          <version>
            <revision-date>2000-01-01</revision-date>
            <draft>3.4</draft>
          </version>
            <language>en</language>
            <script>Latn</script>
            <status>
              <stage>working-draft</stage>
              <iteration>3</iteration>
            </status>
          <relation type='successorOf'>
            <bibitem>
              <date type='published'>2018-06-11</date>
              <edition>1.0</edition>
              <version>
                <draft>1.0</draft>
              </version>
            </bibitem>
          </relation>
        </bibdata>
        <sections>
        <clause/>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~PRESXML
      <?xml version="1.0"?>
      <bipm-standard xmlns="https://www.metanorma.org/ns/bipm" version="#{Metanorma::Bipm::VERSION}" type="presentation">
        <bibdata type="standard">
          <title language="en" format="text/plain" type="title-main">Main Title</title>
          <title language="en" format="text/plain" type="title-cover">Main Title (SI)</title>
          <title language="en" format="text/plain" type="title-appendix">Main Title (SI)</title>
            <contributor>
              <role type="author"/>
              <organization>
                <name>Bureau International des Poids et Mesures</name>
                <abbreviation>BIPM</abbreviation>
              </organization>
            </contributor>
              <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Andrew Yacoot</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>NPL</name>
                  </organization>
                </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Ulrich Kuetgens</completename>
                </name>
                <affiliation>
                  <organization>
                    <name>PTB</name>
                  </organization>
               </affiliation>
              </person>
            </contributor>
            <contributor>
              <role type="publisher"/>
              <organization>
                <name>Bureau International des Poids et Mesures</name>
                <abbreviation>BIPM</abbreviation>
              <logo type="full"><image src="" mimetype="image/svg+xml"><svg xmlns="http://www.w3.org/2000/svg" id="uuid-4162b5c4-51d5-4227-8dcd-f05974f2b5f8" width="206.54mm" height="104.93mm" viewBox="0 0 585.46 297.43" preserveaspectratio="xMidYMin slice"><path d="M31.43,8h18.98c4.51,0,7.93,1.08,10.27,3.25s3.51,5.29,3.51,9.36c0,2.47-.44,4.52-1.33,6.14-.89,1.62-2.24,3-4.06,4.13,1.82.35,3.37.88,4.65,1.59,1.28.72,2.32,1.59,3.12,2.63.8,1.04,1.38,2.21,1.72,3.51.35,1.3.52,2.69.52,4.16,0,2.3-.4,4.33-1.2,6.11-.8,1.78-1.93,3.27-3.38,4.48-1.45,1.21-3.22,2.12-5.3,2.73-2.08.61-4.42.91-7.02.91h-20.48V8ZM44.17,27.23h2.34c3.99,0,5.98-1.58,5.98-4.75s-1.99-4.74-5.98-4.74h-2.34v9.49ZM44.17,47.13h2.79c3.21,0,5.5-.41,6.89-1.24,1.39-.82,2.08-2.14,2.08-3.96s-.69-3.14-2.08-3.96-3.68-1.24-6.89-1.24h-2.79v10.4Z" style="fill:#0f3c80;"/><path d="M101.63,43.93c0,4.85-.98,8.4-2.94,10.66s-5.01,3.4-9.16,3.4-7.23-1.13-9.17-3.4c-1.95-2.26-2.92-5.82-2.92-10.66v-17.27h5.21v17.08c0,3.24.52,5.59,1.57,7.05,1.05,1.46,2.82,2.19,5.32,2.19s4.26-.72,5.28-2.16c1.03-1.44,1.54-3.8,1.54-7.08v-17.08h5.27v17.27Z" style="fill:#0f3c80;"/><path d="M129.47,26.31l-1.24,5.14c-.38-.23-.79-.41-1.24-.52s-.92-.17-1.43-.17c-2.56,0-4.49,1.1-5.79,3.29-1.3,2.19-1.95,5.46-1.95,9.82v13.14h-5.17v-30.34h5.17v5.33c.74-2.18,1.81-3.77,3.21-4.76s3.26-1.49,5.59-1.49c.55,0,1.08.05,1.6.16s.94.24,1.25.41Z" style="fill:#0f3c80;"/><path d="M161.05,42.63h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM155.88,38.95c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M197.59,57.01h-5.21v-5.01c-1.04,1.95-2.49,3.43-4.36,4.46-1.87,1.03-4.08,1.54-6.62,1.54-4.23,0-7.71-1.53-10.44-4.6-2.73-3.07-4.09-6.99-4.09-11.78s1.37-8.49,4.11-11.44c2.74-2.95,6.26-4.43,10.55-4.43,2.43,0,4.58.48,6.44,1.43,1.86.95,3.33,2.32,4.41,4.09v-4.6h5.21v30.34ZM192.38,41.48c0-3.32-.92-5.95-2.75-7.89-1.83-1.94-4.27-2.9-7.32-2.9s-5.49,1.01-7.38,3.02-2.84,4.67-2.84,7.97.93,6.06,2.79,8.16c1.86,2.09,4.25,3.14,7.17,3.14s5.42-1.07,7.38-3.22c1.96-2.15,2.94-4.9,2.94-8.27Z" style="fill:#0f3c80;"/><path d="M232.19,43.93c0,4.85-.98,8.4-2.94,10.66s-5.01,3.4-9.16,3.4-7.23-1.13-9.17-3.4c-1.95-2.26-2.92-5.82-2.92-10.66v-17.27h5.21v17.08c0,3.24.52,5.59,1.57,7.05,1.05,1.46,2.82,2.19,5.32,2.19s4.26-.72,5.28-2.16c1.03-1.44,1.54-3.8,1.54-7.08v-17.08h5.27v17.27Z" style="fill:#0f3c80;"/><path d="M153.42,202.46h-12.74v-49.01h20.28c5.5,0,9.72,1.43,12.64,4.29,2.92,2.86,4.39,6.89,4.39,12.09s-1.46,9.23-4.39,12.09c-2.92,2.86-7.14,4.29-12.64,4.29h-7.54v16.25ZM153.42,175.94h4.22c4.68,0,7.02-2.04,7.02-6.11s-2.34-6.11-7.02-6.11h-4.22v12.22Z" style="fill:#0f3c80;"/><path d="M215.68,187.2c0,4.51-1.58,8.34-4.73,11.51-3.15,3.16-6.99,4.74-11.52,4.74s-8.29-1.58-11.41-4.73c-3.12-3.15-4.68-6.99-4.68-11.52s1.54-8.33,4.63-11.39c3.09-3.07,6.91-4.6,11.46-4.6s8.45,1.54,11.57,4.62c3.12,3.08,4.68,6.87,4.68,11.38ZM210.5,187.2c0-3.19-1.06-5.83-3.17-7.92-2.12-2.08-4.73-3.13-7.84-3.13s-5.75,1.04-7.84,3.13-3.14,4.72-3.14,7.92,1.06,5.9,3.19,8.06c2.13,2.16,4.72,3.24,7.79,3.24s5.75-1.08,7.85-3.24,3.16-4.84,3.16-8.06Z" style="fill:#0f3c80;"/><path d="M230.6,160.16c0,.97-.35,1.81-1.06,2.51-.71.7-1.55,1.05-2.52,1.05s-1.81-.35-2.51-1.05c-.7-.7-1.05-1.53-1.05-2.51s.35-1.81,1.05-2.52c.7-.71,1.53-1.06,2.51-1.06s1.81.35,2.52,1.06c.71.71,1.06,1.55,1.06,2.52ZM229.62,202.46h-5.21v-30.34h5.21v30.34Z" style="fill:#0f3c80;"/><path d="M269.3,202.46h-5.21v-5.01c-1.04,1.95-2.49,3.43-4.36,4.46-1.87,1.03-4.08,1.54-6.62,1.54-4.23,0-7.71-1.53-10.44-4.6-2.73-3.07-4.09-6.99-4.09-11.78s1.37-8.49,4.11-11.44c2.74-2.95,6.26-4.43,10.55-4.43,2.43,0,4.58.48,6.44,1.43,1.86.95,3.33,2.32,4.41,4.09v-27.9h5.21v53.64ZM264.09,186.94c0-3.32-.92-5.95-2.75-7.89-1.83-1.94-4.27-2.9-7.32-2.9s-5.49,1.01-7.38,3.02-2.84,4.67-2.84,7.97.93,6.06,2.79,8.16c1.86,2.09,4.25,3.14,7.17,3.14s5.42-1.07,7.38-3.22c1.96-2.15,2.94-4.9,2.94-8.27Z" style="fill:#0f3c80;"/><path d="M298.95,194.28c0,2.79-1.02,5.02-3.05,6.68s-4.8,2.49-8.32,2.49c-2.64,0-4.88-.53-6.71-1.6-1.83-1.07-3.17-2.62-4.01-4.65l4.41-2.79c.61,1.46,1.47,2.55,2.57,3.27,1.1.72,2.45,1.08,4.06,1.08,1.78,0,3.19-.37,4.25-1.11,1.06-.74,1.59-1.76,1.59-3.05,0-1.42-.48-2.5-1.44-3.24-.96-.74-2.84-1.61-5.63-2.6-2.73-1.02-4.78-2.27-6.14-3.78-1.36-1.5-2.05-3.28-2.05-5.33,0-2.62.87-4.69,2.62-6.19,1.75-1.5,4.18-2.25,7.32-2.25,2.29,0,4.19.47,5.71,1.4,1.52.93,2.74,2.37,3.65,4.32l-4.28,2.6c-.55-1.27-1.25-2.21-2.1-2.81-.85-.6-1.9-.9-3.17-.9-1.46,0-2.6.33-3.43,1-.82.67-1.24,1.57-1.24,2.71s.43,2.14,1.29,2.92c.86.78,2.42,1.54,4.68,2.29,3.34,1.08,5.75,2.37,7.22,3.86,1.47,1.49,2.21,3.39,2.21,5.7Z" style="fill:#0f3c80;"/><path d="M349.97,188.09h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM344.79,184.4c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M365.13,176.79h-4.82v25.68h-5.17v-25.68h-3.65v-4.67h3.65v-12.28h5.17v12.28h4.82v4.67Z" style="fill:#0f3c80;"/><path d="M188.58,275.07l8.32-49.01h12.61l9.81,26.13,9.75-26.13h12.61l8.32,49.01h-12.67l-4.22-28.21-11.57,28.21h-5.07l-10.98-28.21-4.23,28.21h-12.67Z" style="fill:#0f3c80;"/><path d="M284.57,260.69h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM279.39,257.01c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M310.2,266.88c0,2.79-1.02,5.02-3.05,6.68s-4.8,2.49-8.32,2.49c-2.64,0-4.88-.53-6.71-1.6-1.83-1.07-3.17-2.62-4.01-4.65l4.41-2.79c.61,1.46,1.47,2.55,2.57,3.27,1.1.72,2.45,1.08,4.06,1.08,1.78,0,3.19-.37,4.25-1.11,1.06-.74,1.59-1.76,1.59-3.05,0-1.42-.48-2.5-1.44-3.24-.96-.74-2.84-1.61-5.63-2.6-2.73-1.02-4.78-2.27-6.14-3.78-1.36-1.5-2.05-3.28-2.05-5.33,0-2.62.87-4.69,2.62-6.19,1.75-1.5,4.18-2.25,7.32-2.25,2.29,0,4.19.47,5.71,1.4,1.52.93,2.74,2.37,3.65,4.32l-4.28,2.6c-.55-1.27-1.25-2.21-2.1-2.81-.85-.6-1.9-.9-3.17-.9-1.46,0-2.6.33-3.43,1-.82.67-1.24,1.57-1.24,2.71s.43,2.14,1.29,2.92c.86.78,2.42,1.54,4.68,2.29,3.34,1.08,5.75,2.37,7.22,3.86,1.47,1.49,2.21,3.39,2.21,5.7Z" style="fill:#0f3c80;"/><path d="M342.17,261.99c0,4.85-.98,8.4-2.94,10.66s-5.01,3.4-9.16,3.4-7.23-1.13-9.17-3.4c-1.95-2.26-2.92-5.82-2.92-10.66v-17.27h5.21v17.08c0,3.24.52,5.59,1.57,7.05,1.05,1.46,2.82,2.19,5.32,2.19s4.26-.72,5.28-2.16c1.03-1.44,1.54-3.8,1.54-7.08v-17.08h5.27v17.27Z" style="fill:#0f3c80;"/><path d="M369.04,244.38l-1.24,5.14c-.38-.23-.79-.41-1.24-.52s-.92-.17-1.43-.17c-2.56,0-4.49,1.1-5.79,3.29-1.3,2.19-1.95,5.46-1.95,9.82v13.14h-5.17v-30.34h5.17v5.33c.74-2.18,1.81-3.77,3.21-4.76s3.26-1.49,5.59-1.49c.55,0,1.08.05,1.6.16s.94.24,1.25.41Z" style="fill:#0f3c80;"/><path d="M399.65,260.69h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM394.47,257.01c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M425.28,266.88c0,2.79-1.02,5.02-3.05,6.68s-4.8,2.49-8.32,2.49c-2.64,0-4.88-.53-6.71-1.6-1.83-1.07-3.17-2.62-4.01-4.65l4.41-2.79c.61,1.46,1.47,2.55,2.57,3.27,1.1.72,2.45,1.08,4.06,1.08,1.78,0,3.19-.37,4.25-1.11,1.06-.74,1.59-1.76,1.59-3.05,0-1.42-.48-2.5-1.44-3.24-.96-.74-2.84-1.61-5.63-2.6-2.73-1.02-4.78-2.27-6.14-3.78-1.36-1.5-2.05-3.28-2.05-5.33,0-2.62.87-4.69,2.62-6.19,1.75-1.5,4.18-2.25,7.32-2.25,2.29,0,4.19.47,5.71,1.4,1.52.93,2.74,2.37,3.65,4.32l-4.28,2.6c-.55-1.27-1.25-2.21-2.1-2.81-.85-.6-1.9-.9-3.17-.9-1.46,0-2.6.33-3.43,1-.82.67-1.24,1.57-1.24,2.71s.43,2.14,1.29,2.92c.86.78,2.42,1.54,4.68,2.29,3.34,1.08,5.75,2.37,7.22,3.86,1.47,1.49,2.21,3.39,2.21,5.7Z" style="fill:#0f3c80;"/><path d="M101.6,80.19v49.01h-12.74v-49.01h12.74Z" style="fill:#0f3c80;"/><path d="M138.13,129.2h-5.21v-18.12c0-2.94-.52-5.1-1.57-6.47-1.05-1.38-2.71-2.06-5-2.06-2.6,0-4.59,1.03-5.95,3.08-1.37,2.05-2.05,5.06-2.05,9.01v14.57h-5.17v-30.34h5.17v4.47c.91-1.8,2.18-3.15,3.81-4.05,1.63-.9,3.62-1.35,5.97-1.35,3.11,0,5.55,1.03,7.33,3.08s2.67,4.93,2.67,8.63v19.55Z" style="fill:#0f3c80;"/><path d="M158.93,103.52h-4.82v25.68h-5.17v-25.68h-3.65v-4.67h3.65v-12.28h5.17v12.28h4.82v4.67Z" style="fill:#0f3c80;"/><path d="M192.55,114.82h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM187.37,111.14c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M217.66,98.51l-1.24,5.14c-.38-.23-.79-.41-1.24-.52s-.92-.17-1.43-.17c-2.56,0-4.49,1.1-5.79,3.29-1.3,2.19-1.95,5.46-1.95,9.82v13.14h-5.17v-30.34h5.17v5.33c.74-2.18,1.81-3.77,3.21-4.76s3.26-1.49,5.59-1.49c.55,0,1.08.05,1.6.16s.94.24,1.25.41Z" style="fill:#0f3c80;"/><path d="M248.29,129.2h-5.21v-18.12c0-2.94-.52-5.1-1.57-6.47-1.05-1.38-2.71-2.06-5-2.06-2.6,0-4.59,1.03-5.95,3.08-1.37,2.05-2.05,5.06-2.05,9.01v14.57h-5.17v-30.34h5.17v4.47c.91-1.8,2.18-3.15,3.81-4.05,1.63-.9,3.62-1.35,5.97-1.35,3.11,0,5.55,1.03,7.33,3.08s2.67,4.93,2.67,8.63v19.55Z" style="fill:#0f3c80;"/><path d="M287.27,129.2h-5.21v-5.01c-1.04,1.95-2.49,3.43-4.36,4.46-1.87,1.03-4.08,1.54-6.62,1.54-4.23,0-7.71-1.53-10.44-4.6-2.73-3.07-4.09-6.99-4.09-11.78s1.37-8.49,4.11-11.44c2.74-2.95,6.26-4.43,10.55-4.43,2.43,0,4.58.48,6.44,1.43,1.86.95,3.33,2.32,4.41,4.09v-4.6h5.21v30.34ZM282.07,113.68c0-3.32-.92-5.95-2.75-7.89-1.83-1.94-4.27-2.9-7.32-2.9s-5.49,1.01-7.38,3.02-2.84,4.67-2.84,7.97.93,6.06,2.79,8.16c1.86,2.09,4.25,3.14,7.17,3.14s5.42-1.07,7.38-3.22c1.96-2.15,2.94-4.9,2.94-8.27Z" style="fill:#0f3c80;"/><path d="M308.54,103.52h-4.82v25.68h-5.17v-25.68h-3.65v-4.67h3.65v-12.28h5.17v12.28h4.82v4.67Z" style="fill:#0f3c80;"/><path d="M322.93,86.89c0,.97-.35,1.81-1.06,2.51-.71.7-1.55,1.05-2.52,1.05s-1.81-.35-2.51-1.05c-.7-.7-1.05-1.53-1.05-2.51s.35-1.81,1.05-2.52c.7-.71,1.53-1.06,2.51-1.06s1.81.35,2.52,1.06c.71.71,1.06,1.55,1.06,2.52ZM321.94,129.2h-5.21v-30.34h5.21v30.34Z" style="fill:#0f3c80;"/><path d="M363.05,113.93c0,4.51-1.58,8.34-4.73,11.51-3.15,3.16-6.99,4.74-11.52,4.74s-8.29-1.58-11.41-4.73c-3.12-3.15-4.68-6.99-4.68-11.52s1.54-8.33,4.63-11.39c3.09-3.07,6.91-4.6,11.46-4.6s8.45,1.54,11.57,4.62c3.12,3.08,4.68,6.87,4.68,11.38ZM357.88,113.93c0-3.19-1.06-5.83-3.17-7.92-2.12-2.08-4.73-3.13-7.84-3.13s-5.75,1.04-7.84,3.13-3.14,4.72-3.14,7.92,1.06,5.9,3.19,8.06c2.13,2.16,4.72,3.24,7.79,3.24s5.75-1.08,7.85-3.24,3.16-4.84,3.16-8.06Z" style="fill:#0f3c80;"/><path d="M396.29,129.2h-5.21v-18.12c0-2.94-.52-5.1-1.57-6.47-1.05-1.38-2.71-2.06-5-2.06-2.6,0-4.59,1.03-5.95,3.08-1.37,2.05-2.05,5.06-2.05,9.01v14.57h-5.17v-30.34h5.17v4.47c.91-1.8,2.18-3.15,3.81-4.05,1.63-.9,3.62-1.35,5.97-1.35,3.11,0,5.55,1.03,7.33,3.08s2.67,4.93,2.67,8.63v19.55Z" style="fill:#0f3c80;"/><path d="M435.27,129.2h-5.21v-5.01c-1.04,1.95-2.49,3.43-4.36,4.46-1.87,1.03-4.08,1.54-6.62,1.54-4.23,0-7.71-1.53-10.44-4.6-2.73-3.07-4.09-6.99-4.09-11.78s1.37-8.49,4.11-11.44c2.74-2.95,6.26-4.43,10.55-4.43,2.43,0,4.58.48,6.44,1.43,1.86.95,3.33,2.32,4.41,4.09v-4.6h5.21v30.34ZM430.06,113.68c0-3.32-.92-5.95-2.75-7.89-1.83-1.94-4.27-2.9-7.32-2.9s-5.49,1.01-7.38,3.02-2.84,4.67-2.84,7.97.93,6.06,2.79,8.16c1.86,2.09,4.25,3.14,7.17,3.14s5.42-1.07,7.38-3.22c1.96-2.15,2.94-4.9,2.94-8.27Z" style="fill:#0f3c80;"/><path d="M451.59,129.2h-5.17v-53.64h5.17v53.64Z" style="fill:#0f3c80;"/><path d="M507.57,129.2h-5.21v-5.01c-1.04,1.95-2.49,3.43-4.36,4.46-1.87,1.03-4.08,1.54-6.62,1.54-4.23,0-7.71-1.53-10.44-4.6-2.73-3.07-4.09-6.99-4.09-11.78s1.37-8.49,4.11-11.44c2.74-2.95,6.26-4.43,10.55-4.43,2.43,0,4.58.48,6.44,1.43,1.86.95,3.33,2.32,4.41,4.09v-27.9h5.21v53.64ZM502.36,113.68c0-3.32-.92-5.95-2.75-7.89-1.83-1.94-4.27-2.9-7.32-2.9s-5.49,1.01-7.38,3.02-2.84,4.67-2.84,7.97.93,6.06,2.79,8.16c1.86,2.09,4.25,3.14,7.17,3.14s5.42-1.07,7.38-3.22c1.96-2.15,2.94-4.9,2.94-8.27Z" style="fill:#0f3c80;"/><path d="M540.66,114.82h-24.38c.19,3.28,1.16,5.82,2.9,7.63,1.75,1.81,4.08,2.71,7,2.71,2.22,0,4.11-.44,5.67-1.32,1.55-.88,2.79-2.2,3.7-3.95l4.35,2.29c-1.4,2.65-3.25,4.64-5.57,5.98-2.32,1.34-5.05,2.01-8.2,2.01-4.57,0-8.22-1.49-10.93-4.47s-4.08-6.93-4.08-11.84c0-4.57,1.44-8.37,4.32-11.39,2.88-3.03,6.42-4.54,10.63-4.54s7.83,1.39,10.54,4.16c2.71,2.77,4.06,6.41,4.06,10.92v1.81ZM535.49,111.14c-.28-2.6-1.25-4.63-2.92-6.08-1.67-1.45-3.84-2.17-6.51-2.17s-4.73.75-6.51,2.24c-1.78,1.49-2.82,3.5-3.14,6.01h19.08Z" style="fill:#0f3c80;"/><path d="M567.26,121.01c0,2.79-1.02,5.02-3.05,6.68s-4.8,2.49-8.32,2.49c-2.64,0-4.88-.53-6.71-1.6-1.83-1.07-3.17-2.62-4.01-4.65l4.41-2.79c.61,1.46,1.47,2.55,2.57,3.27,1.1.72,2.45,1.08,4.06,1.08,1.78,0,3.19-.37,4.25-1.11,1.06-.74,1.59-1.76,1.59-3.05,0-1.42-.48-2.5-1.44-3.24-.96-.74-2.84-1.61-5.63-2.6-2.73-1.02-4.78-2.27-6.14-3.78-1.36-1.5-2.05-3.28-2.05-5.33,0-2.62.87-4.69,2.62-6.19,1.75-1.5,4.18-2.25,7.32-2.25,2.29,0,4.19.47,5.71,1.4,1.52.93,2.74,2.37,3.65,4.32l-4.28,2.6c-.55-1.27-1.25-2.21-2.1-2.81-.85-.6-1.9-.9-3.17-.9-1.46,0-2.6.33-3.43,1-.82.67-1.24,1.57-1.24,2.71s.43,2.14,1.29,2.92c.86.78,2.42,1.54,4.68,2.29,3.34,1.08,5.75,2.37,7.22,3.86,1.47,1.49,2.21,3.39,2.21,5.7Z" style="fill:#0f3c80;"/><rect x="31.43" y="71.7" width="4.12" height="203.36" style="fill:#0f3c80;"/><rect x="26.32" y="104.96" width="14.34" height="14.34" transform="translate(89.1 9.16) rotate(45)" style="fill:#0f3c80;"/><rect x="86.8" y="144.12" width="4.12" height="130.95" style="fill:#0f3c80;"/><rect x="81.69" y="177.37" width="14.34" height="14.34" transform="translate(156.52 -8.78) rotate(45)" style="fill:#0f3c80;"/><rect x="140.91" y="216.92" width="4.12" height="58.15" style="fill:#0f3c80;"/><rect x="135.8" y="250.17" width="14.34" height="14.34" transform="translate(223.84 -25.72) rotate(45)" style="fill:#0f3c80;"/></svg></image></logo>
      <logo type="small"><image src="" mimetype="image/svg+xml"><svg xmlns="http://www.w3.org/2000/svg" id="uuid-025413ec-7b33-4cab-9252-e1a1cbcbc7d4" width="216.86mm" height="51.44mm" viewBox="0 0 614.73 145.8" preserveaspectratio="xMidYMin slice"><rect x="40.59" y="-.11" width="9.37" height="145.75" style="fill:#0f3c80;"/><rect x="84.49" y="-.11" width="9.37" height="145.75" style="fill:#0f3c80;"/><rect x="129.99" y="-.11" width="9.37" height="145.75" style="fill:#0f3c80;"/><rect x="122.95" y="101.81" width="24.05" height="24.05" transform="translate(120.03 -62.1) rotate(45)" style="fill:#0f3c80;"/><rect x="77.01" y="60.88" width="24.05" height="24.05" transform="translate(77.63 -41.61) rotate(45)" style="fill:#0f3c80;"/><rect x="33.12" y="21.55" width="24.05" height="24.05" transform="translate(36.97 -22.09) rotate(45)" style="fill:#0f3c80;"/><path d="M191.41,25.36h42.05c9.98,0,17.57,2.4,22.75,7.2,5.18,4.8,7.78,11.71,7.78,20.74,0,5.47-.99,10.01-2.95,13.61-1.97,3.6-4.97,6.65-9,9.14,4.03.77,7.46,1.94,10.3,3.53,2.83,1.58,5.13,3.53,6.91,5.83,1.78,2.3,3.05,4.9,3.82,7.78.77,2.88,1.15,5.95,1.15,9.22,0,5.09-.89,9.6-2.66,13.54-1.78,3.94-4.27,7.25-7.49,9.94-3.22,2.69-7.13,4.71-11.74,6.05-4.61,1.34-9.79,2.02-15.55,2.02h-45.36V25.36ZM219.63,67.98h5.18c8.83,0,13.25-3.5,13.25-10.51s-4.42-10.51-13.25-10.51h-5.18v21.02ZM219.63,112.05h6.19c7.1,0,12.19-.91,15.26-2.74,3.07-1.82,4.61-4.75,4.61-8.78s-1.54-6.96-4.61-8.78c-3.07-1.82-8.16-2.74-15.26-2.74h-6.19v23.04Z" style="fill:#0f3c80;"/><path d="M315.68,25.36v108.58h-28.22V25.36h28.22Z" style="fill:#0f3c80;"/><path d="M363.05,133.93h-28.22V25.36h44.93c12.19,0,21.53,3.17,28.01,9.5,6.48,6.34,9.72,15.26,9.72,26.78s-3.24,20.45-9.72,26.78c-6.48,6.34-15.82,9.5-28.01,9.5h-16.7v36ZM363.05,75.18h9.36c10.37,0,15.55-4.51,15.55-13.54s-5.18-13.54-15.55-13.54h-9.36v27.07Z" style="fill:#0f3c80;"/><path d="M423.96,133.93l18.43-108.58h27.94l21.74,57.89,21.6-57.89h27.94l18.43,108.58h-28.08l-9.36-62.5-25.63,62.5h-11.23l-24.34-62.5-9.36,62.5h-28.08Z" style="fill:#0f3c80;"/></svg></image></logo>
      </organization>
            </contributor>
            <edition language="">2</edition><edition language="en">second edition</edition>
          <version>
            <revision-date>2000-01-01</revision-date>
            <draft>3.4</draft>
          </version>
            <language current="true">en</language>
            <script current="true">Latn</script>
            <status>
              <stage>working-draft</stage>
              <iteration>3</iteration>
            </status>
          <relation type="successorOf">
            <bibitem>
              <date type="published">2018-06-11</date>
              <edition>1.0</edition>
              <version>
                <draft>1.0</draft>
              </version>
            </bibitem>
          </relation>
        </bibdata>
        <preface><clause type="toc" id="_" displayorder="1"><fmt-title depth="1" id="_">Contents</fmt-title></clause>
       </preface><sections>
        <clause id="_" displayorder="2"><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="_">1</semx><span class="fmt-clause-delim">.</span></span></fmt-title><fmt-xref-label><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="_">1</semx></fmt-xref-label></clause>
        </sections>
      <colophon><clause class="doccontrol" id="_" displayorder="3">
      <fmt-title id="_" depth="1">Document Control</fmt-title>
      <table id="_" unnumbered="true"><tbody>
      <tr id="_"><th id="_">Authors:</th><td id="_"/><td id="_">Andrew Yacoot (NPL) <span class="fmt-conn">and</span> Ulrich Kuetgens (PTB)</td></tr>
      <tr id="_"><td id="_">Draft 1.0 Version 1.0</td><td id="_">2018-06-11</td>
      <td id="_"/></tr>

      </tbody></table></clause>
      </colophon></bipm-standard>
    PRESXML

    output = <<~HTML
      <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_" class="TOC"><h1 class="IntroTitle">Contents</h1></div><div id="_"><h1>1<span class="fmt-clause-delim">.</span></h1></div><br/><div class="Section3" id="_"><h1 class="IntroTitle">Document Control</h1><table id="_" class="MsoISOTable" style="border-width:1px;border-spacing:0;"><tbody><tr><th style="font-weight:bold;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;" scope="row">Authors:</th><td style="border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;"></td><td style="border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">Andrew Yacoot (NPL) and Ulrich Kuetgens (PTB)</td></tr><tr><td style="border-top:none;border-bottom:solid windowtext 1.5pt;">Draft 1.0 Version 1.0</td><td style="border-top:none;border-bottom:solid windowtext 1.5pt;">2018-06-11</td><td style="border-top:none;border-bottom:solid windowtext 1.5pt;"></td></tr></tbody></table></div></div></body>
    HTML
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
      .gsub(%r{</body>.*}m, "</body>"))).to(be_xml_equivalent_to(output))
  end

  it "processes simple terms & definitions" do
    input = <<~INPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
          <terms id="H" obligation="normative">
            <title>Terms, Definitions, Symbols and Abbreviated Terms</title>
            <term id="J">
              <preferred><expression><name>Term2</name></expression></preferred>
              <source status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </source>
            </term>
            <term id="K">
              <preferred><expression><name>Term3</name></expression></preferred>
                   <termexample id="_bd57bbf1-f948-4bae-b0ce-73c00431f893">
        <ul>
        <li id="_">A</li>
        </ul>
      </termexample>
      <termnote id="_671a1994-4783-40d0-bc81-987d06ffb74e"  keep-with-next="true" keep-lines-together="true">
        <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
      </termnote>
      <termnote id="_671a1994-4783-40d0-bc81-987d06ffb74f">
      <ul><li id="_">A</li></ul>
        <p id="_19830f33-e46c-42cc-94ca-a5ef101132d5">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
      </termnote>
              <source status="identical">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.2</referenceFrom></locality></origin>
      </source>
            </term>
          </terms>
        </sections>
      </bipm-standard>
    INPUT

    presxml = <<~INPUT
<?xml version="1.0"?>
<bipm-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
  <preface><clause type="toc" id="_" displayorder="1"><fmt-title depth="1" id="_">Contents</fmt-title></clause>
 </preface><sections>
    <terms id="H" obligation="normative" displayorder="2">
      <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="H">1</semx><span class="fmt-clause-delim">.</span></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx></fmt-title><fmt-xref-label><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="H">1</semx></fmt-xref-label>
      <term id="J"><fmt-name id="_"><span class="fmt-caption-label"><semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="J">1</semx><span class="fmt-clause-delim">.</span></span></fmt-name><fmt-xref-label><span class="fmt-element-name">Section</span> <semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="J">1</semx></fmt-xref-label>
        <preferred id="_"><expression><name id="_">Term2</name></expression></preferred><fmt-preferred><p><semx element="preferred" source="_"><strong><semx element="expression/name" source="_">Term2</semx></strong></semx></p></fmt-preferred>
        <source status="modified" id="_">
  <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
    <modification id="_">
    <p id="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
  </modification>
</source><fmt-termsource status="modified">[Modified from:  <semx element="source" source="_">
  <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin><semx element="origin" source="_"><fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality>ISO&#xA0;7301:2011,  Clause 3.1</fmt-origin></semx>
     &#x2014; <semx element="modification" source="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</semx>
</semx>]</fmt-termsource>
      </term>
      <term id="K"><fmt-name id="_"><span class="fmt-caption-label"><semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="K">2</semx><span class="fmt-clause-delim">.</span></span></fmt-name><fmt-xref-label><span class="fmt-element-name">Section</span> <semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="K">2</semx></fmt-xref-label>
        <preferred id="_"><expression><name id="_">Term3</name></expression></preferred><fmt-preferred><p><semx element="preferred" source="_"><strong><semx element="expression/name" source="_">Term3</semx></strong></semx></p></fmt-preferred>
             <termexample id="_" autonum=""><fmt-name id="_"><span class="fmt-caption-label"><span class="fmt-element-name">EXAMPLE</span></span></fmt-name><fmt-xref-label><span class="fmt-element-name">Example</span></fmt-xref-label><fmt-xref-label container="K"><span class="fmt-xref-container"><span class="fmt-element-name">Section</span> <semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="K">2</semx></span><span class="fmt-comma">,</span> <span class="fmt-element-name">Example</span></fmt-xref-label>
  <ul>
  <li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>A</li>
  </ul>
</termexample>
<termnote id="_" keep-with-next="true" keep-lines-together="true" autonum="1"><fmt-name id="_"><span class="fmt-caption-label">Note <semx element="autonum" source="_">1</semx> to entry</span><span class="fmt-label-delim">: </span></fmt-name><fmt-xref-label><span class="fmt-element-name">Note</span> <semx element="autonum" source="_">1</semx></fmt-xref-label><fmt-xref-label container="K"><span class="fmt-xref-container"><span class="fmt-element-name">Section</span> <semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="K">2</semx></span><span class="fmt-comma">,</span> <span class="fmt-element-name">Note</span> <semx element="autonum" source="_">1</semx></fmt-xref-label>
  <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
</termnote>
<termnote id="_" autonum="2"><fmt-name id="_"><span class="fmt-caption-label">Note <semx element="autonum" source="_">2</semx> to entry</span><span class="fmt-label-delim">: </span></fmt-name><fmt-xref-label><span class="fmt-element-name">Note</span> <semx element="autonum" source="_">2</semx></fmt-xref-label><fmt-xref-label container="K"><span class="fmt-xref-container"><span class="fmt-element-name">Section</span> <semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="K">2</semx></span><span class="fmt-comma">,</span> <span class="fmt-element-name">Note</span> <semx element="autonum" source="_">2</semx></fmt-xref-label>
<ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>A</li></ul>
  <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
</termnote>
        <source status="identical" id="_">
  <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.2</referenceFrom></locality></origin>
</source><fmt-termsource status="identical">[ <semx element="source" source="_">
  <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_"><locality type="clause"><referenceFrom>3.2</referenceFrom></locality></origin><semx element="origin" source="_"><fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.2</referenceFrom></locality>ISO&#xA0;7301:2011,  Clause 3.2</fmt-origin></semx>
</semx>]</fmt-termsource>
      </term>
    </terms>
  </sections>
</bipm-standard>
    INPUT

    output = <<~OUTPUT
<body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_" class="TOC"><h1 class="IntroTitle">Contents</h1></div><div id="H"><h1>1<span class="fmt-clause-delim">.</span>  Terms, Definitions, Symbols and Abbreviated Terms</h1>

      <p class="TermNum" id="J">1.1<span class="fmt-clause-delim">.</span></p>
        <p class="Terms" style="text-align:left;"><b><dfn>Term2</dfn></b></p>
        <p>[Modified from:
  ISO 7301:2011,  Clause 3.1
     — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here
]</p>

      <p class="TermNum" id="K">1.2<span class="fmt-clause-delim">.</span></p>
        <p class="Terms" style="text-align:left;"><b><dfn>Term3</dfn></b></p>
             <div id="_" class="example"><p class="example-title">EXAMPLE</p>
  <div class="ul_wrap"><ul>
  <li id="_">A</li>
  </ul></div>
</div>
<div id="_" class="Note" style="page-break-after: avoid;page-break-inside: avoid;"><p><span class="termnote_label">Note 1 to entry: </span>The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p></div>
<div id="_" class="Note"><p><span class="termnote_label">Note 2 to entry: </span></p><div class="ul_wrap"><ul><li id="_">A</li></ul></div><p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p></div>
        <p>[
  ISO 7301:2011,  Clause 3.2
]</p>

    </div></div></body>
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
      .gsub(%r{</body>.*}m, "</body>"))).to(be_xml_equivalent_to(output))

    presxml = <<~INPUT
<?xml version="1.0"?>
<bipm-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
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
       <logo><image src="" mimetype="image/svg+xml"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="uuid-07c3fb00-8fdd-4ebb-88fd-1e0cf93a9993" width="171.14mm" height="51.44mm" viewBox="0 0 485.12 145.8" preserveaspectratio="xMidYMin slice"><image width="1000" height="316" transform="translate(16.26 .51) scale(.46)" xlink:href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAA+gAAAE8CAYAAABTk5v0AAAgAElEQVR4Xuy9CZhcRbn/X3W6Z7LOdM8kgEEWcUE2N4IipHsyrIqK6wW96l+8bqh4URFkS2ZOz4QAoiJuP3G96tWr4C6KIsswPQFRgytBRJQ9YkKmO3sy3af+bycEJpOZ6dPd55xa3m8/z33kZqreet/P+9bynlOnSgr8QAAEQAAEQAAEQAAEQAAEQAAEQAAEtBOQ2jWAAiAAAiAAAiAAAiAAAiAAAiAAAiAAAgIJOoIABEAABEAABEAABEAABEAABEAABAwggATdACdABRAAARAAARAAARAAARAAARAAARBAgo4YAAEQAAEQAAEQAAEQAAEQAAEQAAEDCCBBN8AJUAEEQAAEQAAEQAAEQAAEQAAEQAAEkKAjBkAABEAABEAABEAABEAABEAABEDAAAJI0A1wAlQAARAAARAAARAAARAAARAAARAAASToiAEQAAEQAAEQAAEQAAEQAAEQAAEQMIAAEnQDnAAVQAAEQAAEQAAEQAAEQAAEQAAEQAAJOmIABEAABEAABEAABEAABEAABEAABAwggATdACdABRAAARAAARAAARAAARAAARAAARBAgo4YAAEQAAEQAAEQAAEQAAEQAAEQAAEDCCBBN8AJUAEEQAAEQAAEQAAEQAAEQAAEQAAEkKAjBkAABEAABEAABEAABEAABEAABEDAAAJI0A1wAlQAARAAARAAARAAARAAARAAARAAASToiAEQAAEQAAEQAAEQAAEQAAEQAAEQMIAAEnQDnAAVQAAEQAAEQAAEQAAEQAAEQAAEQAAJOmIABEAABEAABEAABEAABEAABEAABAwggATdACdABRAAARAAARAAARAAARAAARAAARBAgo4YAAEQAAEQAAEQAAEQAAEQAAEQAAEDCCBBN8AJUAEEQAAEQAAEQAAEQAAEQAAEQAAEkKAjBkAABEAABEAABEAABEAABEAABEDAAAJI0A1wAlQAARAAARAAARAAARAAARAAARAAASToiAEQAAEQAAEQAAEQAAEQAAEQAAEQMIAAEnQDnAAVQAAEQAAEQAAEQAAEQAAEQAAEQAAJOmIABEAABEAABEAABEAABEAABEAABAwggATdACdABRAAARAAARAAARAAARAAARAAARBAgo4YAAEQAAEQAAEQAAEQAAEQ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"/><path d="M92.85,25.36v75.31c0,3.17-.17,6.1-.5,8.78-.34,2.69-.89,4.99-1.66,6.91-1.25,3.07-2.95,5.88-5.11,8.42-2.16,2.54-4.68,4.7-7.56,6.48-2.88,1.78-6.07,3.17-9.58,4.18-3.5,1.01-7.18,1.51-11.02,1.51-11.62,0-21.07-5.33-28.37-15.98l18.43-18.86c.48,3.26,1.53,5.86,3.17,7.78,1.63,1.92,3.65,2.88,6.05,2.88,5.28,0,7.92-4.18,7.92-12.53V25.36h28.22Z" style="fill:#0f3c80;"/><path d="M190.34,61.65c-6.53-7.97-14.59-11.95-24.19-11.95-4.23,0-8.14.77-11.74,2.3-3.6,1.54-6.7,3.62-9.29,6.26-2.59,2.64-4.63,5.78-6.12,9.43-1.49,3.65-2.23,7.58-2.23,11.81s.74,8.3,2.23,11.95c1.49,3.65,3.55,6.82,6.19,9.5,2.64,2.69,5.74,4.8,9.29,6.34,3.55,1.54,7.39,2.3,11.52,2.3,9.02,0,17.14-3.84,24.34-11.52v33.41l-2.88,1.01c-4.32,1.54-8.35,2.66-12.1,3.38-3.74.72-7.44,1.08-11.09,1.08-7.49,0-14.67-1.42-21.53-4.25-6.86-2.83-12.91-6.82-18.14-11.95-5.23-5.13-9.43-11.23-12.6-18.29s-4.75-14.76-4.75-23.11,1.56-16.01,4.68-22.97c3.12-6.96,7.29-12.96,12.53-18,5.23-5.04,11.3-8.98,18.22-11.81,6.91-2.83,14.16-4.25,21.74-4.25,4.32,0,8.57.46,12.74,1.37,4.18.91,8.57,2.33,13.18,4.25v33.7Z" style="fill:#0f3c80;"/><path d="M257.44,73.17h56.02c0,5.76-.24,10.99-.72,15.7-.48,4.71-1.44,9.07-2.88,13.1-2.02,5.67-4.75,10.68-8.21,15.05-3.46,4.37-7.51,8.02-12.17,10.94-4.66,2.93-9.77,5.16-15.34,6.7-5.57,1.54-11.42,2.3-17.57,2.3-8.45,0-16.15-1.39-23.11-4.18-6.96-2.78-12.94-6.7-17.93-11.74-4.99-5.04-8.88-11.09-11.66-18.14-2.79-7.06-4.18-14.85-4.18-23.4s1.37-16.2,4.1-23.26c2.74-7.06,6.62-13.08,11.66-18.07,5.04-4.99,11.11-8.88,18.22-11.66,7.1-2.78,15.02-4.18,23.76-4.18,11.33,0,21.26,2.45,29.81,7.34,8.54,4.9,15.31,12.48,20.3,22.75l-26.78,11.09c-2.5-5.95-5.74-10.22-9.72-12.82-3.98-2.59-8.52-3.89-13.61-3.89-4.23,0-8.06.79-11.52,2.38s-6.41,3.84-8.86,6.77c-2.45,2.93-4.37,6.46-5.76,10.58-1.39,4.13-2.09,8.74-2.09,13.82,0,4.61.6,8.88,1.8,12.82,1.2,3.94,3,7.34,5.4,10.22,2.4,2.88,5.38,5.11,8.93,6.7,3.55,1.58,7.68,2.38,12.38,2.38,2.78,0,5.47-.31,8.06-.94,2.59-.62,4.92-1.63,6.98-3.02,2.06-1.39,3.77-3.19,5.11-5.4,1.34-2.21,2.25-4.9,2.74-8.06h-23.18v-21.89Z" style="fill:#0f3c80;"/><path d="M322.81,133.93l18.43-108.58h27.94l21.74,57.89,21.6-57.89h27.94l18.43,108.58h-28.08l-9.36-62.5-25.63,62.5h-11.23l-24.34-62.5-9.36,62.5h-28.08Z" style="fill:#0f3c80;"/></svg></image></logo>
</subdivision>
    </organization>
</contributor>
</bibdata><preface><clause type="toc" id="_" displayorder="1"><fmt-title depth="1" id="_">Contents</fmt-title></clause>
 </preface><sections>
    <terms id="H" obligation="normative" displayorder="2">
      <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="H">1</semx><span class="fmt-clause-delim">.</span></span><span class="fmt-caption-delim"><tab/></span><semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx></fmt-title><fmt-xref-label><span class="fmt-element-name">Clause</span> <semx element="autonum" source="H">1</semx></fmt-xref-label>
      <term id="J"><fmt-name id="_"><span class="fmt-caption-label"><semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="J">1</semx><span class="fmt-clause-delim">.</span></span></fmt-name><fmt-xref-label><semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="J">1</semx></fmt-xref-label>
        <preferred id="_"><expression><name id="_">Term2</name></expression></preferred><fmt-preferred><p><semx element="preferred" source="_"><strong><semx element="expression/name" source="_">Term2</semx></strong></semx></p></fmt-preferred>
        <source status="modified" id="_">
  <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
    <modification id="_">
    <p id="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
  </modification>
</source><fmt-termsource status="modified">[Modified from:  <semx element="source" source="_">
  <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin><semx element="origin" source="_"><fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality>ISO&#xA0;7301:2011,  <span class="citesec">3.1</span></fmt-origin></semx>
     &#x2014; <semx element="modification" source="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</semx>
</semx>]</fmt-termsource>
      </term>
      <term id="K"><fmt-name id="_"><span class="fmt-caption-label"><semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="K">2</semx><span class="fmt-clause-delim">.</span></span></fmt-name><fmt-xref-label><semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="K">2</semx></fmt-xref-label>
        <preferred id="_"><expression><name id="_">Term3</name></expression></preferred><fmt-preferred><p><semx element="preferred" source="_"><strong><semx element="expression/name" source="_">Term3</semx></strong></semx></p></fmt-preferred>
             <termexample id="_" autonum=""><fmt-name id="_"><span class="fmt-caption-label"><span class="fmt-element-name">EXAMPLE</span></span></fmt-name><fmt-xref-label><span class="fmt-element-name">Example</span></fmt-xref-label><fmt-xref-label container="K"><span class="fmt-xref-container"><semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="K">2</semx></span><span class="fmt-comma">,</span> <span class="fmt-element-name">Example</span></fmt-xref-label>
  <ul>
  <li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>A</li>
  </ul>
</termexample>
<termnote id="_" keep-with-next="true" keep-lines-together="true" autonum="1"><fmt-name id="_"><span class="fmt-caption-label">Note <semx element="autonum" source="_">1</semx> to entry</span><span class="fmt-label-delim">: </span></fmt-name><fmt-xref-label><span class="fmt-element-name">Note</span> <semx element="autonum" source="_">1</semx></fmt-xref-label><fmt-xref-label container="K"><span class="fmt-xref-container"><semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="K">2</semx></span><span class="fmt-comma">,</span> <span class="fmt-element-name">Note</span> <semx element="autonum" source="_">1</semx></fmt-xref-label>
  <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
</termnote>
<termnote id="_" autonum="2"><fmt-name id="_"><span class="fmt-caption-label">Note <semx element="autonum" source="_">2</semx> to entry</span><span class="fmt-label-delim">: </span></fmt-name><fmt-xref-label><span class="fmt-element-name">Note</span> <semx element="autonum" source="_">2</semx></fmt-xref-label><fmt-xref-label container="K"><span class="fmt-xref-container"><semx element="autonum" source="H">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="K">2</semx></span><span class="fmt-comma">,</span> <span class="fmt-element-name">Note</span> <semx element="autonum" source="_">2</semx></fmt-xref-label>
<ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>A</li></ul>
  <p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p>
</termnote>
        <source status="identical" id="_">
  <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.2</referenceFrom></locality></origin>
</source><fmt-termsource status="identical">[ <semx element="source" source="_">
  <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_"><locality type="clause"><referenceFrom>3.2</referenceFrom></locality></origin><semx element="origin" source="_"><fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.2</referenceFrom></locality>ISO&#xA0;7301:2011,  <span class="citesec">3.2</span></fmt-origin></semx>
</semx>]</fmt-termsource>
      </term>
    </terms>
  </sections>
</bipm-standard>
    INPUT

    output = <<~OUTPUT
<body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section"><br/><div id="_" class="TOC"><h1 class="IntroTitle">Contents</h1></div><div id="H"><h1>1<span class="fmt-clause-delim">.</span>  Terms, Definitions, Symbols and Abbreviated Terms</h1>

      <p class="TermNum" id="J">1.1<span class="fmt-clause-delim">.</span></p>
        <p class="Terms" style="text-align:left;"><b><dfn>Term2</dfn></b></p>
        <p>[Modified from:
  ISO 7301:2011,  <span class="citesec">3.1</span>
     — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here
]</p>

      <p class="TermNum" id="K">1.2<span class="fmt-clause-delim">.</span></p>
        <p class="Terms" style="text-align:left;"><b><dfn>Term3</dfn></b></p>
             <div id="_" class="example"><p class="example-title">EXAMPLE</p>
  <div class="ul_wrap"><ul>
  <li id="_">A</li>
  </ul></div>
</div>
<div id="_" class="Note" style="page-break-after: avoid;page-break-inside: avoid;"><p><span class="termnote_label">Note 1 to entry: </span>The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p></div>
<div id="_" class="Note"><p><span class="termnote_label">Note 2 to entry: </span></p><div class="ul_wrap"><ul><li id="_">A</li></ul></div><p id="_">The starch of waxy rice consists almost entirely of amylopectin. The kernels have a tendency to stick together after cooking.</p></div>
        <p>[
  ISO 7301:2011,  <span class="citesec">3.2</span>
]</p>

    </div></div></body>
    OUTPUT
    pres_output =
      IsoDoc::Bipm::PresentationXMLConvert
        .new(presxml_options)
        .convert("test", input.sub("<sections>",
                                   "<bibdata>#{jcgm_ext}</bibdata><sections>"), true)
    expect(strip_guid(pres_output
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
      .to(be_xml_equivalent_to(presxml))
    expect(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"))).to(be_xml_equivalent_to(output))
  end

  it "generates an index in English" do
    input = <<~INPUT
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <bibdata>
          <language>en</language>
          <script>Latn</script>
        </bibdata>
        <sections>
          <clause id="A">
            <index><primary>&#xE9;long&#xE9;</primary></index>
            <index><primary>&#xEA;tre</primary><secondary>Husserl</secondary><tertiary>en allemand</tertiary></index>
            <index><primary><em>Eman</em>cipation</primary></index>
            <index><primary><em>Eman</em>cipation</primary><secondary>dans la France</secondary></index>
            <index><primary><em>Eman</em>cipation</primary><secondary>dans la France</secondary><tertiary>en Bretagne</tertiary></index>
            <clause id="B">
              <index><primary><em>Eman</em>cipation</primary></index>
              <index><primary>zebra</primary></index>
              <index><primary><em>Eman</em>cipation</primary><secondary>dans les &#xC9;tats-Unis</secondary></index>
              <index><primary><em>Eman</em>cipation</primary><secondary>dans la France</secondary><tertiary>&#xE0; Paris</tertiary></index>
              <index-xref also="true"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target>zebra</target></index-xref>
              <index-xref also="true"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target><em>Eman</em>cipation</target></index-xref>
              <index-xref also="false"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target>zebra</target></index-xref>
              <index-xref also="false"><primary><em>Dasein</em></primary><target>&#xEA;tre</target></index-xref>
              <index-xref also="false"><primary><em>Dasein</em></primary><target><em>Eman</em>cipation</target></index-xref>
            </clause>
          </clause>
        </sections>
      </bipm-standard>
    INPUT
    expect(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
      .to be_xml_equivalent_to <<~OUTPUT
      <?xml version="1.0"?>
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
        <bibdata>
          <language current="true">en</language>
          <script current="true">Latn</script>
        </bibdata>
        <preface><clause type="toc" id="_" displayorder="1"><fmt-title depth="1" id="_">Contents</fmt-title></clause>
       </preface><sections>
          <clause id="A" displayorder="2"><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A">1</semx><span class="fmt-clause-delim">.</span></span></fmt-title><fmt-xref-label><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="A">1</semx></fmt-xref-label>
            <bookmark id="_"/>
            <bookmark id="_"/>
            <bookmark id="_"/>
            <bookmark id="_"/>
            <bookmark id="_"/>
            <clause id="B"><fmt-title depth="2" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx><span class="fmt-clause-delim">.</span></span></fmt-title><fmt-xref-label><span class="fmt-element-name">Section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx></fmt-xref-label>
              <bookmark id="_"/>
              <bookmark id="_"/>
              <bookmark id="_"/>
              <bookmark id="_"/>
              
              
              
              
              
            </clause>
          </clause>
        </sections>
      <indexsect id="_" displayorder="3"><fmt-title id="_">Index</fmt-title><clause id="_"><title id="_">D</title><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name><em>Dasein</em>, see <em>Eman</em>cipation, &#xEA;tre</li></ul></clause><clause id="_"><title id="_">E</title><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>&#xE9;long&#xE9;,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="A">1</semx></fmt-xref></semx></li><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name><em>Eman</em>cipation,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="A">1</semx></fmt-xref></semx>, <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx></fmt-xref></semx><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2212;</semx></fmt-name>dans la France,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="A">1</semx></fmt-xref></semx><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">o</semx></fmt-name>&#xE0; Paris,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx></fmt-xref></semx></li><li id="_"><fmt-name id="_"><semx element="autonum" source="_">o</semx></fmt-name>en Bretagne,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="A">1</semx></fmt-xref></semx></li></ul></li><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2212;</semx></fmt-name>dans les &#xC9;tats-Unis,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx></fmt-xref></semx></li></ul></li><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>&#xEA;tre<ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2212;</semx></fmt-name>Husserl, see zebra, see also <em>Eman</em>cipation, zebra<ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">o</semx></fmt-name>en allemand,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Chapter</span> <semx element="autonum" source="A">1</semx></fmt-xref></semx></li></ul></li></ul></li></ul></clause><clause id="_"><title id="_">Z</title><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>zebra,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">Section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx></fmt-xref></semx></li></ul></clause></indexsect></bipm-standard>
      OUTPUT
  end

  it "generates an index in French" do
    input = <<~INPUT
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm">
        <bibdata>
          <language>fr</language>
          <script>Latn</script>
        </bibdata>
        <sections>
          <clause id="A">
            <xref target="I"/>
            <index to="End"><primary>&#xE9;long&#xE9;</primary></index>
            <index><primary>&#xEA;tre</primary><secondary>Husserl</secondary><tertiary>en allemand</tertiary></index>
            <index><primary>Emancipation</primary></index>
            <index><primary>Emancipation</primary><secondary>dans la France</secondary></index>
            <index><primary>Emancipation</primary><secondary>dans la France</secondary><tertiary>en Bretagne</tertiary></index>
            <clause id="B">
              <index><primary>Emancipation</primary></index>
              <index><primary>zebra</primary></index>
              <index><primary>Emancipation</primary><secondary>dans les &#xC9;tats-Unis</secondary></index>
              <index><primary>Emancipation</primary><secondary>dans la France</secondary><tertiary>&#xE0; Paris</tertiary></index>
              <index-xref also="true"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target>zebra</target></index-xref>
              <index-xref also="true"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target>Emancipation</target></index-xref>
              <index-xref also="false"><primary>&#xEA;tre</primary><secondary>Husserl</secondary><target>zebra</target></index-xref>
              <index-xref also="false"><primary><em>Dasein</em></primary><target>&#xEA;tre</target></index-xref>
              <index-xref also="false"><primary><em>Dasein</em></primary><target>Emancipation</target></index-xref>
              <bookmark id="End"/>
            </clause>
          </clause>
        </sections>
        <indexsect id="I">
          <title>Index</title>
          <p>Voici un index</p>
        </indexsect>
      </bipm-standard>
    INPUT
    expect(strip_guid(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{<localized-strings>.*</localized-strings>}m, "")))
      .to be_xml_equivalent_to <<~OUTPUT
      <?xml version="1.0"?>
      <bipm-standard xmlns="https://open.ribose.com/standards/bipm" type="presentation">
        <bibdata>
          <language current="true">fr</language>
          <script current="true">Latn</script>
        </bibdata>
        <preface><clause type="toc" id="_" displayorder="1"><fmt-title depth="1" id="_">Table des mati&#xE8;res</fmt-title></clause>
       </preface><sections>
          <clause id="A" displayorder="2"><fmt-title depth="1" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A">1</semx><span class="fmt-clause-delim">.</span></span></fmt-title><fmt-xref-label><span class="fmt-element-name">chapitre</span> <semx element="autonum" source="A">1</semx></fmt-xref-label>
            <xref target="I" id="_"/><semx element="xref" source="_"><fmt-xref target="I"><semx element="indexsect" source="I">Index</semx></fmt-xref></semx>
            <bookmark id="_"/>
            <bookmark id="_"/>
            <bookmark id="_"/>
            <bookmark id="_"/>
            <bookmark id="_"/>
            <clause id="B"><fmt-title depth="2" id="_"><span class="fmt-caption-label"><semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx><span class="fmt-clause-delim">.</span></span></fmt-title><fmt-xref-label><span class="fmt-element-name">section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx></fmt-xref-label>
              <bookmark id="_"/>
              <bookmark id="_"/>
              <bookmark id="_"/>
              <bookmark id="_"/>





              <bookmark id="End"/>
            </clause>
          </clause>
        </sections>
        <indexsect id="I" displayorder="3">
          <title id="_">Index</title><fmt-title depth="1" id="_"><semx element="title" source="_">Index</semx></fmt-title>
          <p>Voici un index</p>
        <clause id="_"><title id="_">D</title><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name><em>Dasein</em>, <em>voir</em> Emancipation, &#xEA;tre</li></ul></clause><clause id="_"><title id="_">E</title><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>&#xE9;long&#xE9;,  <xref target="_" to="End" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" to="End" pagenumber="true"><span class="fmt-element-name">chapitre</span> <semx element="autonum" source="A">1</semx></fmt-xref></semx></li><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>Emancipation,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">chapitre</span> <semx element="autonum" source="A">1</semx></fmt-xref></semx>, <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx></fmt-xref></semx><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2212;</semx></fmt-name>dans la France,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">chapitre</span> <semx element="autonum" source="A">1</semx></fmt-xref></semx><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">o</semx></fmt-name>&#xE0; Paris,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx></fmt-xref></semx></li><li id="_"><fmt-name id="_"><semx element="autonum" source="_">o</semx></fmt-name>en Bretagne,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">chapitre</span> <semx element="autonum" source="A">1</semx></fmt-xref></semx></li></ul></li><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2212;</semx></fmt-name>dans les &#xC9;tats-Unis,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx></fmt-xref></semx></li></ul></li><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>&#xEA;tre<ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2212;</semx></fmt-name>Husserl, <em>voir</em> zebra, <em>voir aussi</em> Emancipation, zebra<ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">o</semx></fmt-name>en allemand,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">chapitre</span> <semx element="autonum" source="A">1</semx></fmt-xref></semx></li></ul></li></ul></li></ul></clause><clause id="_"><title id="_">Z</title><ul><li id="_"><fmt-name id="_"><semx element="autonum" source="_">&#x2022;</semx></fmt-name>zebra,  <xref target="_" pagenumber="true" id="_"/><semx element="xref" source="_"><fmt-xref target="_" pagenumber="true"><span class="fmt-element-name">section</span> <semx element="autonum" source="A">1</semx><span class="fmt-autonum-delim">.</span><semx element="autonum" source="B">1</semx></fmt-xref></semx></li></ul></clause></indexsect>
      </bipm-standard>
      OUTPUT
  end
end
