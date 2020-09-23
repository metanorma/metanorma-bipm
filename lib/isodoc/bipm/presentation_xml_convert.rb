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

      def annex1(f)
      lbl = @xrefs.anchor(f['id'], :label)
      if t = f.at(ns("./title"))
        t.children = "<strong>#{t.children.to_xml}</strong>"
      end
      prefix_name(f, ".<tab/>", lbl, "title")
    end

      include Init
    end
  end
end

