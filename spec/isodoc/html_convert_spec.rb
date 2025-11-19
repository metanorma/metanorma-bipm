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

    output = Canon.format_xml(<<~"OUTPUT")
      #{BLANK_HDR}
        <sections/>
      </bipm-standard>
    OUTPUT

    expect(Canon.format_xml(strip_guid(Asciidoctor
      .convert(input, backend: :bipm, header_footer: true))))
      .to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Times New Roman})
  end

  it "processes si-aspect" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <bibdata type="standard">
          <title type="title-main" language="en" format="plain">Main Title</title>
          <docidentifier>1000</docidentifier>
          <date type="published">2021-04</date>
          <contributor>
            <role type="author"/>
            <person>
              <name>
                <completename>Gustavo Martos</completename>
              </name>
              <affiliation>
                <organization>
                  <name>BIPM</name>
                </organization>
              </affiliation>
            </person>
          </contributor>
          <contributor>
            <role type="author"/>
            <organization>
              <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
            </organization>
          </contributor>
          <language>en</language>
          <script>Latn</script>
          <copyright>
            <from>2001</from>
            <owner>
              <organization>
                <name>#{Metanorma::Bipm.configuration.organization_name_long['en']}</name>
              </organization>
            </owner>
          </copyright>
          <ext>
            <si-aspect>A_e_deltanu</si-aspect>
            <structuredidentifier>
              <docnumber>1000</docnumber>
              <part>2.1</part>
              <appendix>ABC</appendix>
              <annexid>DEF</annexid>
            </structuredidentifier>
          </ext>
        </bibdata>
      </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <bibdata type="standard">
          <title type="title-main" language="en" format="plain">Main Title</title>
          <docidentifier>1000</docidentifier>
          <date type="published">2021-04</date>
          <date type="published" format="ddMMMyyyy">April 2021</date>
          <contributor>
             <role type="author"/>
             <person>
                <name>
                   <completename>Gustavo Martos</completename>
                </name>
                <affiliation>
                   <organization>
                      <name>BIPM</name>
                   </organization>
                </affiliation>
             </person>
          </contributor>
          <contributor>
             <role type="author"/>
             <organization>
                <name>Bureau International des Poids et Mesures</name>
             </organization>
          </contributor>
          <language current="true">en</language>
          <script current="true">Latn</script>
          <copyright>
             <from>2001</from>
             <owner>
                <organization>
                   <name>Bureau International des Poids et Mesures</name>
                </organization>
             </owner>
          </copyright>
          <depiction type="si-aspect">
             <image src="" mimetype="image/svg+xml">
                <svg xmlns="http://www.w3.org/2000/svg" id="uuid-9b612d48-83ef-48e4-af28-57e2d765c350" width="210mm" height="210mm" viewBox="0 0 595.28 595.28" preserveaspectratio="xMidYMin slice">
                   <path d="M220.05,146.34l-49.23-102.23C97.33,80.93,42.09,148.75,22.22,230.43l110.58,25.24c12.12-47.7,44.41-87.33,87.25-109.34Z" style="fill:#bcbec0;"/>
                   <path d="M467.72,297.67c0,38.58-12.86,74.14-34.5,102.67l88.67,70.72c37.11-47.93,59.22-108.07,59.22-173.38,0-20.21-2.13-39.93-6.16-58.95l-110.58,25.24c2.19,10.9,3.35,22.16,3.35,33.71Z" style="fill:#bcbec0;"/>
                   <path d="M297.64,14.2c-42.57,0-82.93,9.4-119.16,26.21l49.23,102.23c21.34-9.64,45-15.05,69.93-15.05s48.59,5.41,69.93,15.05l49.23-102.23c-36.23-16.81-76.59-26.21-119.16-26.21" style="fill:#bcbec0;"/>
                   <path d="M462.48,255.67l110.58-25.24c-19.87-81.68-75.12-149.5-148.6-186.32l-49.23,102.23c42.84,22.01,75.13,61.63,87.25,109.34Z" style="fill:#bcbec0;"/>
                   <path d="M127.56,297.67c0-11.54,1.16-22.81,3.35-33.7l-110.58-25.24c-4.02,19.02-6.15,38.73-6.15,58.94,0,65.31,22.1,125.45,59.21,173.38l88.67-70.71c-21.64-28.53-34.5-64.09-34.5-102.67Z" style="fill:#bcbec0;"/>
                   <path d="M293.39,581.08v-113.44c-50.58-1.25-95.66-24.53-126.01-60.66l-88.69,70.73c51.15,62.14,128.24,102.1,214.7,103.37" style="fill:#bcbec0;"/>
                   <path d="M301.89,581.08c86.46-1.27,163.55-41.24,214.7-103.37l-88.69-70.73c-30.35,36.13-75.44,59.42-126.02,60.66v113.44" style="fill:#61a60e;"/>
                   <path d="M367.57,142.64c-21.34-9.64-44.99-15.05-69.93-15.05s-48.6,5.41-69.93,15.05l69.93,145.21,69.93-145.21Z" style="fill:#dcddde;"/>
                   <path d="M130.91,263.96c-2.19,10.9-3.35,22.16-3.35,33.7,0,38.57,12.86,74.13,34.5,102.67l126.02-100.5-157.17-35.87Z" style="fill:#dcddde;"/>
                   <path d="M301.89,467.64c50.58-1.24,95.67-24.53,126.02-60.66l-126.02-100.49v161.15Z" style="fill:#b2d28e;"/>
                   <path d="M464.37,263.96l-157.17,35.87,126.02,100.5c21.64-28.53,34.5-64.09,34.5-102.67,0-11.54-1.16-22.81-3.35-33.71Z" style="fill:#ffd28b;"/>
                   <path d="M220.05,146.34c-42.84,22.01-75.13,61.63-87.25,109.34l157.18,35.87-69.93-145.21Z" style="fill:#dcddde;"/>
                   <path d="M462.48,255.67c-12.12-47.71-44.41-87.33-87.25-109.34l-69.93,145.21,157.18-35.88Z" style="fill:#dcddde;"/>
                   <path d="M167.37,406.98c30.35,36.13,75.44,59.42,126.01,60.66v-161.15l-126.01,100.49Z" style="fill:#dcddde;"/>
                   <path d="M78.69,477.7c-1.8-2.19-3.56-4.41-5.3-6.65" style="fill:#ec008c;"/>
                   <circle cx="297.64" cy="297.67" r="99.21" style="fill:#fff;"/>
                   <path d="M242.81,336.72l7.48-8.68c7.03,7.33,16.9,12.27,27.07,12.27,12.86,0,20.49-6.43,20.49-16.01s-7.03-13.16-16.3-17.35l-14.06-6.13c-9.27-3.89-19.89-10.92-19.89-25.28s13.01-26.03,30.81-26.03c11.67,0,21.99,4.94,29.02,12.12l-6.73,8.08c-5.98-5.68-13.16-9.27-22.29-9.27-10.92,0-18.25,5.53-18.25,14.36,0,9.42,8.53,13.01,16.3,16.3l13.91,5.98c11.37,4.94,20.19,11.67,20.19,26.18,0,15.56-12.71,27.97-33.36,27.97-13.76,0-25.88-5.68-34.4-14.51Z" style="fill:#414042;"/>
                   <path d="M329.87,251.31h12.42v98.13h-12.42v-98.13Z" style="fill:#414042;"/>
                   <path d="M105.39,177.82c-8.1-5.59-8.81-14.48-4.35-20.94,2.15-3.11,4.87-4.51,7.62-5.23l1.79,5.32c-2.02.5-3.52,1.29-4.57,2.82-2.69,3.9-1.36,8.83,3.53,12.21,4.84,3.34,9.89,2.89,12.51-.91,1.3-1.88,1.55-4.25,1.37-6.42l5.36.27c.4,3.64-.59,7.18-2.5,9.94-4.57,6.61-12.72,8.49-20.77,2.93Z" style="fill:#fff;"/>
                   <path d="M120.84,155.62c-7.11-6.45-7.39-14.89-3.08-19.64,2.26-2.49,4.6-3.2,7.6-3.56l-3.67-3.01-7.91-7.18,4.63-5.11,31.37,28.46-3.83,4.22-2.68-1.78-.16.18c.15,3.05-.58,6.44-2.72,8.8-4.96,5.47-12.36,5.15-19.56-1.39ZM139.02,145.14l-10.18-9.23c-2.7.3-4.52,1.32-5.85,2.79-2.54,2.8-1.97,7.44,2.6,11.6,4.71,4.27,8.85,4.79,11.72,1.64,1.53-1.69,2.07-3.8,1.71-6.79Z" style="fill:#fff;"/>
                   <path d="M269.57,44.26l6.77-.43,1.69,26.41h.18s10.03-14.24,10.03-14.24l7.54-.48-9.29,12.62,12.19,16.72-7.48.48-8.36-12.27-4.27,5.56.48,7.48-6.77.43-2.7-42.27Z" style="fill:#fff;"/>
                   <path d="M299.26,90.31c.18-2.45,1.84-4.5,4.66-5.97l.02-.24c-1.42-1.07-2.45-2.71-2.27-5.1.17-2.27,1.87-4.13,3.64-5.2l.02-.24c-1.86-1.64-3.51-4.59-3.25-8.06.51-6.76,6.23-10.12,12.39-9.66,1.62.12,3.09.53,4.26,1.04l10.53.79-.38,5.09-5.39-.4c.87,1.21,1.46,3.06,1.3,5.09-.49,6.52-5.65,9.62-11.88,9.16-1.26-.09-2.67-.44-3.95-1.08-.96.71-1.55,1.39-1.65,2.71-.12,1.68.99,2.78,4.58,3.05l5.21.39c7.06.53,10.61,2.96,10.23,8.05-.43,5.8-6.88,9.89-16.45,9.18-7-.52-12.02-3.43-11.63-8.57ZM320.62,90.35c.17-2.27-1.64-3.07-4.99-3.32l-4.01-.3c-1.62-.12-2.86-.33-3.98-.72-1.65,1.08-2.46,2.34-2.56,3.72-.2,2.63,2.56,4.4,7.23,4.75,4.73.35,8.12-1.62,8.31-4.13ZM318.77,66.74c.27-3.65-1.78-5.97-4.65-6.18-2.87-.22-5.3,1.71-5.58,5.42-.28,3.77,1.83,6.09,4.7,6.31,2.81.21,5.25-1.77,5.53-5.54Z" style="fill:#fff;"/>
                   <path d="M473.05,130.69l3.52,4.48-2.86,2.86.15.19c3.6.3,7.03,1.27,9.29,4.15,2.67,3.4,2.63,6.55.89,9.68,4.1.36,7.71,1.26,10.01,4.19,3.86,4.9,2.29,9.8-3.56,14.4l-14.53,11.42-4.3-5.47,13.82-10.87c3.82-3,4.35-5.25,2.46-7.65-1.15-1.46-3.36-2.32-6.7-2.6l-16.18,12.72-4.26-5.42,13.82-10.86c3.82-3,4.35-5.25,2.42-7.7-1.11-1.41-3.35-2.32-6.7-2.6l-16.18,12.72-4.26-5.42,23.16-18.21Z" style="fill:#fff;"/>
                   <path d="M508.69,333.11l3.58,4.17c-2.59,2.1-4.39,4.27-5.08,7.19-.73,3.09.39,4.9,2.38,5.36,2.39.56,4.17-2.29,6.05-5.05,2.29-3.47,5.46-7.22,10.24-6.1,5.02,1.18,7.64,6.04,6.13,12.47-.93,3.97-3.32,6.8-5.68,8.71l-3.36-4.06c1.93-1.64,3.4-3.45,3.93-5.73.67-2.86-.36-4.52-2.17-4.95-2.28-.54-3.82,2.12-5.66,4.96-2.38,3.57-5.26,7.45-10.63,6.19-4.91-1.15-7.96-6-6.26-13.24.92-3.91,3.59-7.66,6.52-9.93Z" style="fill:#fff;"/>
                   <path d="M77.49,394.23l-1.85-5.39,3.65-1.76-.08-.23c-3.29-1.47-6.21-3.52-7.4-6.98-1.4-4.09-.32-7.06,2.35-9.43-3.75-1.7-6.86-3.74-8.07-7.26-2.02-5.9,1.08-10.01,8.11-12.42l17.48-5.99,2.25,6.58-16.63,5.7c-4.6,1.57-5.83,3.52-4.84,6.41.6,1.76,2.4,3.3,5.46,4.66l19.47-6.67,2.23,6.53-16.63,5.7c-4.6,1.57-5.83,3.52-4.82,6.47.58,1.7,2.4,3.3,5.46,4.66l19.47-6.67,2.24,6.53-27.87,9.54Z" style="fill:#fff;"/>
                   <path d="M76.7,342.13c-9.74,1.39-16.27-4.41-17.3-11.66-1.04-7.31,3.6-14.7,13.34-16.09,9.68-1.38,16.21,4.42,17.25,11.72,1.03,7.25-3.61,14.64-13.29,16.02ZM73.74,321.4c-5.88.84-9.37,4-8.76,8.28.61,4.28,4.84,6.28,10.72,5.44,5.82-.83,9.32-3.94,8.71-8.21-.61-4.28-4.84-6.34-10.67-5.51Z" style="fill:#fff;"/>
                   <path d="M79.81,306.78l-34.78,1.07-.21-6.9,35.14-1.08c1.68-.05,2.25-.85,2.23-1.57,0-.3-.02-.54-.15-1.08l5.13-1.06c.39.83.66,2.02.71,3.64.15,4.92-2.97,6.81-8.07,6.97Z" style="fill:#fff;"/>
                   <path d="M198.95,476.39l6.25,3.05-7.82,16.01.16.08,20.38-9.88,6.96,3.4-17.55,8.45,2.16,27.7-6.9-3.37-1.43-21.27-8.15,3.83-5.03,10.3-6.25-3.05,17.22-35.26Z" style="fill:#fff;"/>
                   <path d="M382.32,481.97l7.38-3.49,28.34,30-6.62,3.13-7.31-8.29-11.93,5.65,1.78,10.91-6.4,3.03-5.24-40.93ZM391.3,503.34l9.06-4.29-3.3-3.75c-2.91-3.2-5.87-6.78-8.74-10.2l-.22.1c.9,4.42,1.77,8.92,2.4,13.2l.8,4.93Z" style="fill:#fff;"/>
                   <path d="M169.77,218.68l2.4-3.59,8.54,8.54.09-.13-3.5-16.09,2.64-3.96,3.3,13.79,16.38,3.86-2.49,3.73-13.4-3.41,1.38,6.59,5.95,5.94-2.4,3.59-18.88-18.85Z" style="fill:#414042;"/>
                   <path d="M207.03,224.42c-2.88-2.52-2.77-5.98-.76-8.28.97-1.11,2.08-1.53,3.18-1.69l.46,2.14c-.8.1-1.42.34-1.89.89-1.21,1.39-.92,3.35.82,4.87,1.72,1.5,3.69,1.55,4.88.2.58-.67.79-1.57.81-2.42l2.06.34c0,1.42-.54,2.75-1.4,3.73-2.06,2.35-5.29,2.72-8.15.22Z" style="fill:#414042;"/>
                   <path d="M212.95,217.58c-2.59-2.69-2.47-5.97-.67-7.7.94-.9,1.87-1.12,3.04-1.18l-1.34-1.26-2.88-2.99,1.93-1.86,11.41,11.87-1.6,1.54-.99-.76-.07.06c-.02,1.19-.39,2.48-1.29,3.34-2.07,1.99-4.93,1.67-7.55-1.06ZM220.28,214l-3.7-3.85c-1.06.04-1.79.39-2.35.93-1.06,1.02-.96,2.83.7,4.57,1.71,1.78,3.31,2.09,4.5.95.64-.61.9-1.42.84-2.59Z" style="fill:#414042;"/>
                   <path d="M294.02,145.21l4.28.02-1.76,8.31-.77,2.83h.16c2.01-1.71,4.13-3.02,6.49-3.01,3.28.02,4.63,1.82,4.61,4.98,0,.92-.09,1.72-.33,2.76l-2.54,12.39-4.28-.02,2.46-11.83c.16-.92.33-1.48.33-2.08,0-1.68-.79-2.52-2.47-2.53-1.36,0-2.88.9-4.97,3.01l-2.71,13.38-4.32-.02,5.82-28.21Z" style="fill:#414042;"/>
                   <path d="M396.15,209.98c5.53-4.35,13.09-3.73,16.88,1.08,1.48,1.89,1.64,3.9,1.3,5.54l-3.53-.28c.25-1.37.13-2.29-.68-3.33-2.18-2.77-7.29-2.67-11.12.35-2.33,1.83-2.86,3.93-1.23,6,.94,1.19,2.25,1.69,3.49,1.98l-1,3.13c-1.76-.5-3.94-1.33-5.77-3.65-2.67-3.4-2.33-7.68,1.66-10.82Z" style="fill:#414042;"/>
                   <path d="M424.58,306.48l21.72,11.93-.88,5.41-24.38,4.37-2.76-.45,3.54-21.72,2.76.45ZM422.96,323.36l10.77-1.69,8.42-1.18.03-.16-7.62-3.76-9.69-4.98-1.92,11.77Z" style="fill:#414042;"/>
                   <path d="M414.97,335.43h13.52c.89-.01,1.8-.1,2.73-.29.93-.18,1.52-.66,1.78-1.44.12-.37.18-.8.17-1.3l.74-.04.34,5.24-.27.81-15.87.09,5.15,5.09c.92.93,1.7,1.5,2.33,1.71.51.17,1.25.3,2.23.4.72.06,1.25.15,1.58.26,1.22.41,1.61,1.28,1.17,2.6-.39,1.17-1.15,1.57-2.26,1.2-1.1-.37-2.92-1.89-5.47-4.56l-8.24-8.66.38-1.11Z" style="fill:#414042; stroke:#414042; stroke-miterlimit:10; stroke-width:.5px;"/>
                   <path d="M154.77,343.48l-1.13-4.09,13.26-8.96,5.03-2.96-.04-.15c-2.67.4-6.01,1.07-8.91,1.25l-12.08.88-1.1-4.01,26.61-1.89,1.12,4.05-13.23,8.91-5.11,2.98.04.15c2.78-.44,5.95-.98,8.85-1.15l12.2-.91,1.09,3.97-26.6,1.93Z" style="fill:#414042;"/>
                   <path d="M173.1,314.62l-.39-3.15,14.53-6.8.35,2.82-3.95,1.69.63,5.09,4.24.68.34,2.73-15.74-3.06ZM182.08,313.91l-.48-3.86-1.79.76c-1.54.68-3.22,1.34-4.83,1.98v.09c1.75.21,3.52.44,5.18.73l1.92.3Z" style="fill:#414042;"/>
                   <path d="M243.26,403.51l3.85,1.88-11,14.39.14.07,11.82-4.42,4.31,2.11-10.8,4.07-.73,12.15-3.88-1.9.81-9.31-5.15,1.8-2.99,3.93-3.88-1.9,17.5-22.88Z" style="fill:#414042;"/>
                   <path d="M353.94,411.68c4.12-1.95,6.99.19,8.74,3.88.74,1.55,1,3.42,1.02,4.12l-10.81,5.12c1.38,3.95,4.23,4.55,6.91,3.28,1.27-.6,2.31-1.94,2.95-3.12l2.63,1.81c-.97,1.7-2.65,3.56-5.19,4.75-4.23,2-8.42.62-10.68-4.15-3.13-6.62-.23-13.48,4.44-15.69ZM359.89,418.47c-.11-.52-.28-1.06-.55-1.64-.82-1.74-2.28-2.95-4.45-1.92-2.13,1.01-3.41,3.83-2.84,7.27l7.85-3.71Z" style="fill:#414042;"/>
                </svg>
             </image>
          </depiction>
          <ext>
             <si-aspect>A_e_deltanu</si-aspect>
             <structuredidentifier>
                <docnumber>1000</docnumber>
                <part>2.1</part>
                <appendix>ABC</appendix>
                <annexid>DEF</annexid>
             </structuredidentifier>
          </ext>
       </bibdata>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
    .convert("test", input, true))
    xml = xml.at("//xmlns:bibdata")
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(presxml)
  end

  it "processes unordered lists" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface>
          <clause type="toc" id="_" displayorder="1"> <fmt-title id="_" depth="1">Table of contents</fmt-title> </clause>
          <foreword displayorder="2" id="fwd"><fmt-title id="_">Foreword</fmt-title>
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
               <fmt-title id="_" depth="1">Foreword</fmt-title>
               <ul id="_" keep-with-next="true" keep-lines-together="true">
                  <name id="_">Caption</name>
                  <fmt-name id="_">
                     <semx element="name" source="_">Caption</semx>
                  </fmt-name>
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">•</semx>
                     </fmt-name>
                     <p id="_">Level 1</p>
                  </li>
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">•</semx>
                     </fmt-name>
                     <p id="_">deletion of 4.3.</p>
                     <ul id="_" keep-with-next="true" keep-lines-together="true">
                        <li id="_">
                           <fmt-name id="_">
                              <semx element="autonum" source="_">−</semx>
                           </fmt-name>
                           <p id="_">Level 2</p>
                           <ul id="_" keep-with-next="true" keep-lines-together="true">
                              <li id="_">
                                 <fmt-name id="_">
                                    <semx element="autonum" source="_">o</semx>
                                 </fmt-name>
                                 <p id="_">Level 3</p>
                                 <ul id="_" keep-with-next="true" keep-lines-together="true">
                                    <li id="_">
                                       <fmt-name id="_">
                                          <semx element="autonum" source="_">•</semx>
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
               <fmt-title id="_" depth="1">Table of contents</fmt-title>
            </clause>
         </preface>
      </iso-standard>
    INPUT
    xml = Nokogiri::XML(IsoDoc::Bipm::PresentationXMLConvert
      .new(presxml_options)
    .convert("test", input, true))
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(presxml)
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
               <fmt-title id="_" depth="1">Contents</fmt-title>
            </clause>
            <foreword id="_" displayorder="2">
               <title id="_">Foreword</title>
               <fmt-title id="_" depth="1">
                  <semx element="title" source="_">Foreword</semx>
               </fmt-title>
               <ol id="_" type="alphabet" keep-with-next="true" keep-lines-together="true" autonum="1">
                  <name id="_">Caption</name>
                  <fmt-name id="_">
                     <semx element="name" source="_">Caption</semx>
                  </fmt-name>
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">a</semx>
                        <span class="fmt-label-delim">)</span>
                     </fmt-name>
                     <p id="_">Level 1</p>
                  </li>
               </ol>
               <ol id="A" type="alphabet">
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">a</semx>
                        <span class="fmt-label-delim">)</span>
                     </fmt-name>
                     <p id="_">Level 1</p>
                  </li>
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">b</semx>
                        <span class="fmt-label-delim">)</span>
                     </fmt-name>
                     <p id="_">Level 1</p>
                     <ol type="arabic">
                        <li id="_">
                           <fmt-name id="_">
                              <semx element="autonum" source="_">1</semx>
                              <span class="fmt-label-delim">.</span>
                           </fmt-name>
                           <p id="_">Level 2</p>
                           <ol type="roman">
                              <li id="_">
                                 <fmt-name id="_">
                                    <span class="fmt-label-delim">(</span>
                                    <semx element="autonum" source="_">i</semx>
                                    <span class="fmt-label-delim">)</span>
                                 </fmt-name>
                                 <p id="_">Level 3</p>
                                 <ol type="alphabet_upper">
                                    <li id="_">
                                       <fmt-name id="_">
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
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(presxml)
  end

  it "processes ordered lists, #2" do
    input = <<~INPUT
      <bipm-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
          <clause id="A" displayorder="1">
            <fmt-title id="_">Clause</fmt-title>
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

    output = Canon.format_xml(<<~"OUTPUT")
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
    stripped_html = Canon.format_xml(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
    expect(stripped_html).to(be_equivalent_to(output))
  end

  it "processes nested roman and alphabetic lists" do
    input = <<~"INPUT"
      <bipm-standard type="semantic" version="#{Metanorma::Bipm::VERSION}" xmlns="https://www.metanorma.org/ns/bipm">
        <preface>
        <foreword displayorder="1"><fmt-title id="_">Foreword</fmt-title>
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
    expect(Canon.format_xml(strip_guid(IsoDoc::Bipm::HtmlConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"))))
      .to be_equivalent_to Canon.format_xml(output)
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
               <fmt-title id="_" depth="1">Contents</fmt-title>
            </clause>
            <foreword id="A" displayorder="2">
               <title id="_">Foreword</title>
               <fmt-title id="_" depth="1">
                  <semx element="title" source="_">Foreword</semx>
               </fmt-title>
               <p id="B">abc</p>
               <note id="C" autonum="1">
                  <fmt-name id="_">
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
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">•</semx>
                     </fmt-name>
                     <p id="E">List item</p>
                     <note id="F" autonum="2">
                        <fmt-name id="_">
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
               <fmt-title id="_" depth="1">
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
                  <fmt-name id="_">
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
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">•</semx>
                     </fmt-name>
                     <p id="E1">List item</p>
                     <note id="F1" autonum="2">
                        <fmt-name id="_">
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
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(presxml)

    presxml = <<~PRESXML
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <bibdata>
            <language current="true">fr</language>
            <script current="true">Latn</script>
         </bibdata>
         <preface>
            <clause type="toc" id="_" displayorder="1">
               <fmt-title id="_" depth="1">Table des matières</fmt-title>
            </clause>
            <foreword id="A" displayorder="2">
               <title id="_">Avant-propos</title>
               <fmt-title id="_" depth="1">
                  <semx element="title" source="_">Avant-propos</semx>
               </fmt-title>
               <p id="B">abc</p>
               <note id="C" autonum="1">
                  <fmt-name id="_">
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
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">•</semx>
                     </fmt-name>
                     <p id="E">List item</p>
                     <note id="F" autonum="2">
                        <fmt-name id="_">
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
               <fmt-title id="_" depth="1">
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
                  <fmt-name id="_">
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
                  <li id="_">
                     <fmt-name id="_">
                        <semx element="autonum" source="_">•</semx>
                     </fmt-name>
                     <p id="E1">List item</p>
                     <note id="F1" autonum="2">
                        <fmt-name id="_">
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
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(presxml)
  end
end
