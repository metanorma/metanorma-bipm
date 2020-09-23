require "isodoc"
require "metanorma-generic"
require_relative "init"

module IsoDoc
  module BIPM
    class PresentationXMLConvert < IsoDoc::Generic::PresentationXMLConvert
      def table1(f)
        return if labelled_ancestor(f)
        return if f["unnumbered"] && !f.at(ns("./name"))
        n = @xrefs.anchor(f['id'], :label, false)
        prefix_name(f, ".<tab/>", l10n("#{@i18n.table} #{n}"), "name")
      end

      include Init
    end
  end
end

