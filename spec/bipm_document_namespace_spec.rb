# frozen_string_literal: true

# Self-contained: avoids pulling in the gem's full spec_helper (which
# may load unrelated code with pre-existing pubid-* dependency issues).
require "bundler/setup"
require "metanorma/bipm/document"

RSpec.describe "Metanorma::Bipm::Document namespace" do
  describe "canonical namespace" do
    it "exposes Metanorma::Bipm::Document as a Module" do
      expect(Metanorma::Bipm::Document).to be_a(Module)
    end

    it "exposes Root with the canonical name" do
      expect(Metanorma::Bipm::Document::Root.name)
        .to eq("Metanorma::Bipm::Document::Root")
    end

    it "Root is a lutaml Serializable" do
      expect(Metanorma::Bipm::Document::Root < Lutaml::Model::Serializable).to be(true)
    end
  end

  describe "backwards-compat alias" do
    it "Metanorma::BipmDocument aliases to the new namespace" do
      expect(Metanorma::BipmDocument).to eq(Metanorma::Bipm::Document)
    end

    it "the alias preserves class identity" do
      expect(Metanorma::BipmDocument::Root.equal?(
               Metanorma::Bipm::Document::Root)).to be(true)
    end
  end

  describe "parent namespace" do
    it "Metanorma::Standoc::Document is available" do
      expect(Metanorma::Standoc::Document).to be_a(Module)
    end

    it "Metanorma::StandardDocument alias is available" do
      expect(Metanorma::StandardDocument).to eq(Metanorma::Standoc::Document)
    end
  end
end
