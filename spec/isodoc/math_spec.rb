require "spec_helper"

RSpec.describe IsoDoc::Bipm do
  it "localises numbers in MathML" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml">
        <bibdata>
          <title language="en">test</title>
          <language>en</language>
        </bibdata>
        <preface>
          <p>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mn>30000</mn>
              </math>
            </stem>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mn>3000.0003</mn>
              </math>
            </stem>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mn>3000000.0000003</mn>
              </math>
            </stem>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mn>.0003</mn>
              </math>
            </stem>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mn>.0000003</mn>
              </math>
            </stem>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mn>3000</mn>
              </math>
            </stem>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mn>3000000</mn>
              </math>
            </stem>
            <stem type="MathML">
              <math xmlns="http://www.w3.org/1998/Math/MathML">
                <mi>P</mi>
                <mfenced close=")" open="(">
                  <mrow>
                    <mi>X</mi>
                    <mo>≥</mo>
                    <msub>
                      <mrow>
                        <mi>X</mi>
                      </mrow>
                      <mrow>
                        <mo>max</mo>
                      </mrow>
                    </msub>
                  </mrow>
                </mfenced>
                <mo>=</mo>
                <munderover>
                  <mrow>
                    <mo>∑</mo>
                  </mrow>
                  <mrow>
                    <mrow>
                      <mi>j</mi>
                      <mo>=</mo>
                      <msub>
                        <mrow>
                          <mi>X</mi>
                        </mrow>
                        <mrow>
                          <mo>max</mo>
                        </mrow>
                      </msub>
                    </mrow>
                  </mrow>
                  <mrow>
                    <mn>1000</mn>
                  </mrow>
                </munderover>
                <mfenced close=")" open="(">
                  <mtable>
                    <mtr>
                      <mtd>
                        <mn>0.0001</mn>
                      </mtd>
                    </mtr>
                    <mtr>
                      <mtd>
                        <mi>j</mi>
                      </mtd>
                    </mtr>
                  </mtable>
                </mfenced>
                <msup>
                  <mrow>
                    <mi>p</mi>
                  </mrow>
                  <mrow>
                    <mi>j</mi>
                  </mrow>
                </msup>
                <msup>
                  <mrow>
                    <mfenced close=")" open="(">
                      <mrow>
                        <mn>1000.00001</mn>
                        <mo>−</mo>
                        <mi>p</mi>
                      </mrow>
                    </mfenced>
                  </mrow>
                  <mrow>
                    <mrow>
                      <mn>1.003</mn>
                      <mo>−</mo>
                      <mi>j</mi>
                    </mrow>
                  </mrow>
                </msup>
              </math>
            </stem>
          </p>
        </preface>
      </iso-standard>
    INPUT

    output = <<~OUTPUT
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <bibdata>
             <title language="en">test</title>
             <language current="true">en</language>
          </bibdata>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title id="_" depth="1">Contents</fmt-title>
             </clause>
             <p displayorder="2">
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>30000</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               30 000
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>3000.0003</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               3000.0003
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>3000000.0000003</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               3 000 000.000 000 3
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>.0003</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               0.0003
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>.0000003</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               0.000 000 3
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>3000</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               3000
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>3000000</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               3 000 000
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mi>P</mi>
                      <mfenced close=")" open="(">
                         <mrow>
                            <mi>X</mi>
                            <mo>≥</mo>
                            <msub>
                               <mrow>
                                  <mi>X</mi>
                               </mrow>
                               <mrow>
                                  <mo>max</mo>
                               </mrow>
                            </msub>
                         </mrow>
                      </mfenced>
                      <mo>=</mo>
                      <munderover>
                         <mrow>
                            <mo>∑</mo>
                         </mrow>
                         <mrow>
                            <mrow>
                               <mi>j</mi>
                               <mo>=</mo>
                               <msub>
                                  <mrow>
                                     <mi>X</mi>
                                  </mrow>
                                  <mrow>
                                     <mo>max</mo>
                                  </mrow>
                               </msub>
                            </mrow>
                         </mrow>
                         <mrow>
                            <mn>1000</mn>
                         </mrow>
                      </munderover>
                      <mfenced close=")" open="(">
                         <mtable>
                            <mtr>
                               <mtd>
                                  <mn>0.0001</mn>
                               </mtd>
                            </mtr>
                            <mtr>
                               <mtd>
                                  <mi>j</mi>
                               </mtd>
                            </mtr>
                         </mtable>
                      </mfenced>
                      <msup>
                         <mrow>
                            <mi>p</mi>
                         </mrow>
                         <mrow>
                            <mi>j</mi>
                         </mrow>
                      </msup>
                      <msup>
                         <mrow>
                            <mfenced close=")" open="(">
                               <mrow>
                                  <mn>1000.00001</mn>
                                  <mo>−</mo>
                                  <mi>p</mi>
                               </mrow>
                            </mfenced>
                         </mrow>
                         <mrow>
                            <mrow>
                               <mn>1.003</mn>
                               <mo>−</mo>
                               <mi>j</mi>
                            </mrow>
                         </mrow>
                      </msup>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
                      <math xmlns="http://www.w3.org/1998/Math/MathML">
                         <mi>P</mi>
                         <mfenced close=")" open="(">
                            <mrow>
                               <mi>X</mi>
                               <mo>≥</mo>
                               <msub>
                                  <mrow>
                                     <mi>X</mi>
                                  </mrow>
                                  <mrow>
                                     <mo>max</mo>
                                  </mrow>
                               </msub>
                            </mrow>
                         </mfenced>
                         <mo>=</mo>
                         <munderover>
                            <mrow>
                               <mo>∑</mo>
                            </mrow>
                            <mrow>
                               <mrow>
                                  <mi>j</mi>
                                  <mo>=</mo>
                                  <msub>
                                     <mrow>
                                        <mi>X</mi>
                                     </mrow>
                                     <mrow>
                                        <mo>max</mo>
                                     </mrow>
                                  </msub>
                               </mrow>
                            </mrow>
                            <mrow>
                               <mn>1000</mn>
                            </mrow>
                         </munderover>
                         <mfenced close=")" open="(">
                            <mtable>
                               <mtr>
                                  <mtd>
                                     <mn>0.0001</mn>
                                  </mtd>
                               </mtr>
                               <mtr>
                                  <mtd>
                                     <mi>j</mi>
                                  </mtd>
                               </mtr>
                            </mtable>
                         </mfenced>
                         <msup>
                            <mrow>
                               <mi>p</mi>
                            </mrow>
                            <mrow>
                               <mi>j</mi>
                            </mrow>
                         </msup>
                         <msup>
                            <mrow>
                               <mfenced close=")" open="(">
                                  <mrow>
                                     <mn>1000.000 01</mn>
                                     <mo>−</mo>
                                     <mi>p</mi>
                                  </mrow>
                               </mfenced>
                            </mrow>
                            <mrow>
                               <mrow>
                                  <mn>1.003</mn>
                                  <mo>−</mo>
                                  <mi>j</mi>
                               </mrow>
                            </mrow>
                         </msup>
                      </math>
                      <asciimath>P (X ge X_(max)) = sum_(j = X_(max))^(1000) ([[0.0001], [j]]) p^(j) (1000.00001 - p)^(1.003 - j)</asciimath>
                   </semx>
                </fmt-stem>
             </p>
          </preface>
       </iso-standard>
    OUTPUT
    expect(Canon.format_xml(strip_guid(IsoDoc::Bipm::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .sub(%r{<localized-strings>.*</localized-strings>}m, "")))
      .to be_equivalent_to Canon.format_xml(output)

    output = <<~OUTPUT
       <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
          <bibdata>
             <title language="en">test</title>
             <language current="true">fr</language>
          </bibdata>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title id="_" depth="1">Table des matières</fmt-title>
             </clause>
             <p displayorder="2">
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>30000</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               30 000
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>3000.0003</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               3000,0003
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>3000000.0000003</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               3 000 000,000 000 3
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>.0003</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               0,0003
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>.0000003</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               0,000 000 3
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>3000</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               3000
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mn>3000000</mn>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
               3 000 000
             </semx>
                </fmt-stem>
                <stem type="MathML" id="_">
                   <math xmlns="http://www.w3.org/1998/Math/MathML">
                      <mi>P</mi>
                      <mfenced close=")" open="(">
                         <mrow>
                            <mi>X</mi>
                            <mo>≥</mo>
                            <msub>
                               <mrow>
                                  <mi>X</mi>
                               </mrow>
                               <mrow>
                                  <mo>max</mo>
                               </mrow>
                            </msub>
                         </mrow>
                      </mfenced>
                      <mo>=</mo>
                      <munderover>
                         <mrow>
                            <mo>∑</mo>
                         </mrow>
                         <mrow>
                            <mrow>
                               <mi>j</mi>
                               <mo>=</mo>
                               <msub>
                                  <mrow>
                                     <mi>X</mi>
                                  </mrow>
                                  <mrow>
                                     <mo>max</mo>
                                  </mrow>
                               </msub>
                            </mrow>
                         </mrow>
                         <mrow>
                            <mn>1000</mn>
                         </mrow>
                      </munderover>
                      <mfenced close=")" open="(">
                         <mtable>
                            <mtr>
                               <mtd>
                                  <mn>0.0001</mn>
                               </mtd>
                            </mtr>
                            <mtr>
                               <mtd>
                                  <mi>j</mi>
                               </mtd>
                            </mtr>
                         </mtable>
                      </mfenced>
                      <msup>
                         <mrow>
                            <mi>p</mi>
                         </mrow>
                         <mrow>
                            <mi>j</mi>
                         </mrow>
                      </msup>
                      <msup>
                         <mrow>
                            <mfenced close=")" open="(">
                               <mrow>
                                  <mn>1000.00001</mn>
                                  <mo>−</mo>
                                  <mi>p</mi>
                               </mrow>
                            </mfenced>
                         </mrow>
                         <mrow>
                            <mrow>
                               <mn>1.003</mn>
                               <mo>−</mo>
                               <mi>j</mi>
                            </mrow>
                         </mrow>
                      </msup>
                   </math>
                </stem>
                <fmt-stem type="MathML">
                   <semx element="stem" source="_">
                      <math xmlns="http://www.w3.org/1998/Math/MathML">
                         <mi>P</mi>
                         <mfenced close=")" open="(">
                            <mrow>
                               <mi>X</mi>
                               <mo>≥</mo>
                               <msub>
                                  <mrow>
                                     <mi>X</mi>
                                  </mrow>
                                  <mrow>
                                     <mo>max</mo>
                                  </mrow>
                               </msub>
                            </mrow>
                         </mfenced>
                         <mo>=</mo>
                         <munderover>
                            <mrow>
                               <mo>∑</mo>
                            </mrow>
                            <mrow>
                               <mrow>
                                  <mi>j</mi>
                                  <mo>=</mo>
                                  <msub>
                                     <mrow>
                                        <mi>X</mi>
                                     </mrow>
                                     <mrow>
                                        <mo>max</mo>
                                     </mrow>
                                  </msub>
                               </mrow>
                            </mrow>
                            <mrow>
                               <mn>1000</mn>
                            </mrow>
                         </munderover>
                         <mfenced close=")" open="(">
                            <mtable>
                               <mtr>
                                  <mtd>
                                     <mn>0,0001</mn>
                                  </mtd>
                               </mtr>
                               <mtr>
                                  <mtd>
                                     <mi>j</mi>
                                  </mtd>
                               </mtr>
                            </mtable>
                         </mfenced>
                         <msup>
                            <mrow>
                               <mi>p</mi>
                            </mrow>
                            <mrow>
                               <mi>j</mi>
                            </mrow>
                         </msup>
                         <msup>
                            <mrow>
                               <mfenced close=")" open="(">
                                  <mrow>
                                     <mn>1000,000 01</mn>
                                     <mo>−</mo>
                                     <mi>p</mi>
                                  </mrow>
                               </mfenced>
                            </mrow>
                            <mrow>
                               <mrow>
                                  <mn>1,003</mn>
                                  <mo>−</mo>
                                  <mi>j</mi>
                               </mrow>
                            </mrow>
                         </msup>
                      </math>
                      <asciimath>P (X ge X_(max)) = sum_(j = X_(max))^(1000) ([[0.0001], [j]]) p^(j) (1000.00001 - p)^(1.003 - j)</asciimath>
                   </semx>
                </fmt-stem>
             </p>
          </preface>
       </iso-standard>
    OUTPUT
    expect(Canon.format_xml(strip_guid(IsoDoc::Bipm::PresentationXMLConvert.new(presxml_options)
      .convert("test", input.sub(">en<", ">fr<"), true))
      .sub(%r{<localized-strings>.*</localized-strings>}m, "")))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "duplicates MathML with AsciiMath" do
    input = <<~INPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml" xmlns:m='http://www.w3.org/1998/Math/MathML'>
      <preface><foreword>
      <p>
      <stem type="MathML"><m:math>
        <m:msup> <m:mrow> <m:mo>(</m:mo> <m:mrow> <m:mi>x</m:mi> <m:mo>+</m:mo> <m:mi>y</m:mi> </m:mrow> <m:mo>)</m:mo> </m:mrow> <m:mn>2</m:mn> </m:msup>
      </m:math></stem>
      </p>
      </foreword></preface>
      <sections>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
       <iso-standard xmlns="http://riboseinc.com/isoxml" xmlns:m="http://www.w3.org/1998/Math/MathML" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title id="_" depth="1">Contents</fmt-title>
             </clause>
             <foreword id="_" displayorder="2">
                <title id="_">Foreword</title>
                <fmt-title id="_" depth="1">
                   <semx element="title" source="_">Foreword</semx>
                </fmt-title>
                <p>
                   <stem type="MathML" id="_">
                      <m:math>
                         <m:msup>
                            <m:mrow>
                               <m:mo>(</m:mo>
                               <m:mrow>
                                  <m:mi>x</m:mi>
                                  <m:mo>+</m:mo>
                                  <m:mi>y</m:mi>
                               </m:mrow>
                               <m:mo>)</m:mo>
                            </m:mrow>
                            <m:mn>2</m:mn>
                         </m:msup>
                      </m:math>
                   </stem>
                   <fmt-stem type="MathML">
                      <semx element="stem" source="_">
                         <m:math>
                            <m:msup>
                               <m:mrow>
                                  <m:mo>(</m:mo>
                                  <m:mrow>
                                     <m:mi>x</m:mi>
                                     <m:mo>+</m:mo>
                                     <m:mi>y</m:mi>
                                  </m:mrow>
                                  <m:mo>)</m:mo>
                               </m:mrow>
                               <m:mn>2</m:mn>
                            </m:msup>
                         </m:math>
                         <asciimath>(x + y)^(2)</asciimath>
                      </semx>
                   </fmt-stem>
                </p>
             </foreword>
          </preface>
          <sections>
       </sections>
       </iso-standard>
    OUTPUT
    expect(Canon.format_xml(strip_guid(IsoDoc::Bipm::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))))
      .to be_equivalent_to Canon.format_xml(output)
  end
end
