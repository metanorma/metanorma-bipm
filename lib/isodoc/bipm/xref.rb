module IsoDoc
  module Bipm
    class Counter < IsoDoc::XrefGen::Counter
    end

    class Xref < IsoDoc::Xref
      attr_accessor :jcgm

      def initialize(lang, script, klass, i18n, options = {})
        @iso = IsoDoc::Iso::Xref.new(lang, script, klass, i18n, options)
        super
      end

      def parse(docxml)
        @jcgm = docxml.at(ns("//bibdata/ext/editorialgroup/committee/" \
                             "@acronym"))&.value == "JCGM"
        @annexlbl =
          if @jcgm then @labels["iso_annex"]
          elsif docxml.at(ns("//bibdata/ext/structuredidentifier/appendix"))
            @labels["appendix"]
          else @labels["annex"]
          end
        super
      end

      def wrap_brackets(txt)
        /^\[.*\]$/.match?(txt) ? txt : "[#{txt}]"
      end

      def reference_names(ref)
        super
        @jcgm and
          @anchors[ref["id"]][:xref] = wrap_brackets(@anchors[ref["id"]][:xref])
      end

      UNNUM = "@unnumbered = 'true'".freeze

      def clause_order_main(docxml)
        @jcgm and return @iso.clause_order_main(docxml)
        [{ path: "//sections/clause[not(#{UNNUM})] | " \
                 "//sections/terms[not(#{UNNUM})] | " \
                 "//sections/definitions[not(#{UNNUM})] | " \
                 "//sections/references[not(#{UNNUM})]", multi: true },
         { path: "//sections/clause[#{UNNUM}] | " \
                 "//sections/terms[#{UNNUM}] | " \
                 "//sections/definitions[#{UNNUM}] | " \
                 "//sections/references[#{UNNUM}]", multi: true }]
      end

      def main_anchor_names(xml)
        @jcgm and return super
        t = clause_order_main(xml)
        n = Counter.new
        t.each_with_index do |a, i|
          xml.xpath(ns(a[:path])).each do |c|
            i.zero? ? section_names(c, n, 1) : unnumbered_section_names(c, 1)
            a[:multi] or break
          end
        end
      end

      NUMBERED_SUBCLAUSES =
        "./clause[not(#{UNNUM})] | ./references[not(#{UNNUM})] | " \
        "./term[not(#{UNNUM})] | ./terms[not(#{UNNUM})] | " \
        "./definitions[not(#{UNNUM})]".freeze

      UNNUMBERED_SUBCLAUSES =
        "./clause[#{UNNUM}] | ./references[#{UNNUM}] | " \
        "./term[#{UNNUM}] | ./terms[#{UNNUM}] | " \
        "./definitions[#{UNNUM}]".freeze

      def section_name_anchors(clause, num, lvl)
        lbl = @jcgm ? "clause_jcgm" : "clause"
        @anchors[clause["id"]] =
          { label: num.print, xref: l10n("#{@labels[lbl]} #{num.print}"),
            level: lvl, type: "clause", elem: @labels[lbl] }
      end

      def section_names(clause, num, lvl)
        clause.nil? and return num
        num.increment(clause)
        @anchors[clause["id"]] = section_name_anchors(clause, num, lvl)
        i = Counter.new(0, prefix: "#{num.print}.")
        clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
          section_names1(c, i.increment(c).print, lvl + 1)
        end
        clause.xpath(ns(UNNUMBERED_SUBCLAUSES)).each do |c|
          unnumbered_section_names1(c, lvl + 1)
        end
        num
      end

      def unnumbered_section_names(clause, lvl)
        clause.nil? and return num
        lbl = clause.at(ns("./title"))&.text || "[#{clause['id']}]"
        @anchors[clause["id"]] = { label: lbl, xref: l10n(%{"#{lbl}"}),
                                   level: lvl, type: "clause" }
        clause.xpath(ns(SUBCLAUSES)).each do |c|
          unnumbered_section_names1(c, lvl + 1)
        end
      end

      def section_name1_anchors(clause, num, level)
        lbl = @jcgm ? "" : "#{@labels['subclause']} "
        @anchors[clause["id"]] =
          { label: num, level: level, xref: l10n("#{lbl}#{num}"),
            type: "clause", elem: lbl }
      end

      def section_names1(clause, num, level)
        @anchors[clause["id"]] = section_name1_anchors(clause, num, level)
        i = Counter.new(0, prefix: "#{num}.")
        clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
          section_names1(c, i.increment(c).print, level + 1)
        end
        clause.xpath(ns(UNNUMBERED_SUBCLAUSES)).each do |c|
          unnumbered_section_names1(c, lvl + 1)
        end
      end

      def unnumbered_section_names1(clause, level)
        lbl = clause.at(ns("./title"))&.text || "[#{clause['id']}]"
        @anchors[clause["id"]] =
          { label: lbl, xref: l10n(%{"#{lbl}"}), level: level, type: "clause" }
        clause.xpath(ns(SUBCLAUSES)).each do |c|
          unnumbered_section_names1(c, level + 1)
        end
      end

      def clause_order_annex(_docxml)
        [{ path: "//annex[not(#{UNNUM})]", multi: true },
         { path: "//annex[#{UNNUM}]", multi: true }]
      end

      def annex_anchor_names(docxml)
        n = @jcgm ? Counter.new("@", skip_i: true) : Counter.new(0)
        clause_order_annex(docxml).each_with_index do |a, i|
          docxml.xpath(ns(a[:path])).each do |c|
            if i.zero?
              n.increment(c)
              annex_names(c, n.print)
            else unnumbered_annex_names(c) end
            a[:multi] or break
          end
        end
      end

      def annex_name_anchors(clause, num)
        { label: annex_name_lbl(clause, num), type: "clause", value: num.to_s,
          xref: l10n("#{@annexlbl} #{num}"), level: 1, elem: @annexlbl }
      end

      def annex_names(clause, num)
        @anchors[clause["id"]] = annex_name_anchors(clause, num)
        if @klass.single_term_clause?(clause)
          annex_names1(clause.at(ns("./references | ./terms | ./definitions")),
                       num.to_s, 1)
        else
          prefix = @jcgm ? "" : "A"
          i = Counter.new(0, prefix: "#{prefix}#{num}.")
          clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
            annex_names1(c, i.increment(c).print, 2)
          end
          clause.xpath(ns(UNNUMBERED_SUBCLAUSES))
            .each { |c| unnumbered_annex_names1(c, 2) }
        end
        hierarchical_asset_names(clause, num)
      end

      def unnumbered_annex_anchors(lbl)
        { label: lbl, type: "clause", value: "",
          xref: l10n(%{"#{lbl}"}), level: 1 }
      end

      def unnumbered_annex_names(clause)
        lbl = clause.at(ns("./title"))&.text || "[#{clause['id']}]"
        @anchors[clause["id"]] = unnumbered_annex_anchors(lbl)
        if @klass.single_term_clause?(clause)
          annex_names1(clause.at(ns("./references | ./terms | ./definitions")),
                       num.to_s, 1)
        else
          clause.xpath(ns(SUBCLAUSES))
            .each { |c| unnumbered_annex_names1(c, 2) }
        end
        hierarchical_asset_names(clause, lbl)
      end

      def annex_names1_anchors(num, level)
        lbl = @jcgm ? "" : "#{@annexlbl} "
        { label: num, xref: l10n("#{lbl}#{num}"),
          level: level, type: "clause", elem: lbl }
      end

      def annex_names1(clause, num, level)
        @anchors[clause["id"]] = annex_names1_anchors(num, level)
        i = Counter.new(0, prefix: "#{num}.")
        clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
          annex_names1(c, i.increment(c).print, level + 1)
        end
        clause.xpath(ns(UNNUMBERED_SUBCLAUSES))
          .each { |c| unnumbered_annex_names1(c, level + 1) }
      end

      def unnumbered_annex_names1(clause, level)
        lbl = clause&.at(ns("./title"))&.text || "[#{clause['id']}]"
        @anchors[clause["id"]] = { label: lbl, xref: l10n(%{"#{lbl}"}),
                                   level: level, type: "clause" }
        clause.xpath(ns(SUBCLAUSES))
          .each { |c| unnumbered_annex_names1(c, level + 1) }
      end

      def annex_name_lbl(_clause, num)
        l10n("<strong>#{@annexlbl} #{num}</strong>")
      end

      def sequential_formula_names(clause, container: false)
        c = Counter.new
        clause.xpath(ns(".//formula")).noblank.each do |t|
          @anchors[t["id"]] = anchor_struct(
            c.increment(t).print, container ? t : nil,
            t["inequality"] ? @labels["inequality"] : @labels["formula"],
            "formula", t["unnumbered"]
          )
        end
      end

      def initial_anchor_names(doc)
        super
        if (@parse_settings.empty? || @parse_settings[:clauses]) && @jcgm
          @iso.introduction_names(doc.at(ns("//introduction")))
          @anchors.merge!(@iso.get)
        end
      end

      def sequential_figure_names(clause, container: false)
        @jcgm or return super
        @iso.sequential_figure_names(clause, container: container)
        @anchors.merge!(@iso.get)
      end

      def hierarchical_figure_names(clause, num)
        @jcgm or return super
        @iso.hierarchical_figure_names(clause, num)
        @anchors.merge!(@iso.get)
      end
    end
  end
end
