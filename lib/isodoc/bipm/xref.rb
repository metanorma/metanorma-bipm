module IsoDoc
  module BIPM
    class Counter < IsoDoc::XrefGen::Counter
    end

    class Xref < IsoDoc::Xref
      def initialize(lang, script, klass, i18n, options = {})
        super
      end

      def parse(docxml)
        @jcgm = docxml&.at(ns("//bibdata/ext/editorialgroup/committee/"\
                              "@acronym"))&.value == "JCGM"
        @annexlbl =
          if docxml.at(ns("//bibdata/ext/structuredidentifier/appendix"))
            @labels["appendix"]
          else
            @labels["annex"]
          end
        super
      end

      def wrap_brackets(txt)
        return txt if /^\[.*\]$/.match?(txt)

        "[#{txt}]"
      end

      def reference_names(ref)
        super
        if @jcgm
          @anchors[ref["id"]][:xref] = wrap_brackets(@anchors[ref["id"]][:xref])
        end
      end

      def clause_names(docxml, sect_num)
        if @jcgm
          clause_names_jcgm(docxml, sect_num)
        else
          clause_names_bipm(docxml, sect_num)
        end
      end

      def clause_names_jcgm(docxml, sect_num)
        docxml.xpath(ns("//clause[parent::sections][not(@type = 'scope')]"\
                        "[not(descendant::terms)]")).each do |c|
          section_names(c, sect_num, 1)
        end
      end

      def clause_names_bipm(docxml, _sect_num)
        n = Counter.new
        docxml.xpath(ns("//sections/clause[not(@unnumbered = 'true')] | "\
                        "//sections/terms[not(@unnumbered = 'true')] | "\
                        "//sections/definitions[not(@unnumbered = 'true')]"))
          .each { |c| section_names(c, n, 1) }
        docxml.xpath(ns("//sections/clause[@unnumbered = 'true'] | "\
                        "//sections/terms[@unnumbered = 'true'] | "\
                        "//sections/definitions[@unnumbered = 'true']"))
          .each { |c| unnumbered_section_names(c, 1) }
      end

      NUMBERED_SUBCLAUSES = "./clause[not(@unnumbered = 'true')] | "\
        "./references[not(@unnumbered = 'true')] | "\
        "./term[not(@unnumbered = 'true')] | "\
        "./terms[not(@unnumbered = 'true')] | "\
        "./definitions[not(@unnumbered = 'true')]".freeze

      UNNUMBERED_SUBCLAUSES = "./clause[@unnumbered = 'true'] | "\
        "./references[@unnumbered = 'true'] | "\
        "./term[@unnumbered = 'true'] | "\
        "./terms[@unnumbered = 'true'] | "\
        "./definitions[@unnumbered = 'true']".freeze

      def section_name_anchors(clause, num, lvl)
        lbl = @jcgm ? "clause_jcgm" : "clause"
        @anchors[clause["id"]] =
          { label: num.print, xref: l10n("#{@labels[lbl]} #{num.print}"),
            level: lvl, type: "clause" }
      end

      def section_names(clause, num, lvl)
        return num if clause.nil?

        num.increment(clause)
        @anchors[clause["id"]] = section_name_anchors(clause, num, lvl)
        i = Counter.new
        clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
          i.increment(c)
          section_names1(c, "#{num.print}.#{i.print}", lvl + 1)
        end
        clause.xpath(ns(UNNUMBERED_SUBCLAUSES)).each do |c|
          unnumbered_section_names1(c, lvl + 1)
        end
        num
      end

      def unnumbered_section_names(clause, lvl)
        return if clause.nil?

        lbl = clause&.at(ns("./title"))&.text || "[#{clause['id']}]"
        @anchors[clause["id"]] = { label: lbl, xref: l10n(%{"#{lbl}"}),
                                   level: lvl, type: "clause" }
        clause.xpath(ns(SUBCLAUSES)).each do |c|
          unnumbered_section_names1(c, lvl + 1)
        end
      end

      def section_name1_anchors(clause, num, level)
        lbl = @jcgm ? "" : "#{@labels['subclause']} "
        @anchors[clause["id"]] =
          { label: num, level: level,
            xref: l10n("#{lbl}#{num}"),
            type: "clause" }
      end

      def section_names1(clause, num, level)
        @anchors[clause["id"]] = section_name1_anchors(clause, num, level)
        i = Counter.new
        clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
          i.increment(c)
          section_names1(c, "#{num}.#{i.print}", level + 1)
        end
        clause.xpath(ns(UNNUMBERED_SUBCLAUSES)).each do |c|
          unnumbered_section_names1(c, lvl + 1)
        end
      end

      def unnumbered_section_names1(clause, level)
        lbl = clause&.at(ns("./title"))&.text || "[#{clause['id']}]"
        @anchors[clause["id"]] =
          { label: lbl, xref: l10n(%{"#{lbl}"}), level: level, type: "clause" }
        clause.xpath(ns(SUBCLAUSES)).each do |c|
          unnumbered_section_names1(c, level + 1)
        end
      end

      def back_anchor_names(docxml)
        super
        i = @jcgm ? Counter.new("@", skip_i: true) : Counter.new(0)
        docxml.xpath(ns("//annex[not(@unnumbered = 'true')]")).each do |c|
          i.increment(c)
          annex_names(c, i.print)
        end
        docxml.xpath(ns("//annex[@unnumbered = 'true']"))
          .each { |c| unnumbered_annex_names(c) }
        docxml.xpath(ns("//indexsect")).each { |b| preface_names(b) }
      end

      def annex_name_anchors(clause, num)
        { label: annex_name_lbl(clause, num), type: "clause", value: num.to_s,
          xref: l10n("#{@annexlbl} #{num}"), level: 1 }
      end

      def annex_names(clause, num)
        @anchors[clause["id"]] = annex_name_anchors(clause, num)
        if a = single_annex_special_section(clause)
          annex_names1(a, num.to_s, 1)
        else
          i = Counter.new
          clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
            i.increment(c)
            annex_names1(c, "#{num}.#{i.print}", 2)
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
        lbl = clause&.at(ns("./title"))&.text || "[#{clause['id']}]"
        @anchors[clause["id"]] = unnumbered_annex_anchors(lbl)
        if a = single_annex_special_section(clause)
          annex_names1(a, num.to_s, 1)
        else
          clause.xpath(ns(SUBCLAUSES))
            .each { |c| unnumbered_annex_names1(c, 2) }
        end
        hierarchical_asset_names(clause, lbl)
      end

      def annex_names1_anchors(num, level)
        lbl = @jcgm ? "" : "#{@annexlbl} "
        { label: num, xref: l10n("#{lbl}#{num}"),
          level: level, type: "clause" }
      end

      def annex_names1(clause, num, level)
        @anchors[clause["id"]] = annex_names1_anchors(num, level)
        i = Counter.new
        clause.xpath(ns(NUMBERED_SUBCLAUSES)).each do |c|
          i.increment(c)
          annex_names1(c, "#{num}.#{i.print}", level + 1)
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

      def sequential_formula_names(clause)
        c = Counter.new
        clause.xpath(ns(".//formula")).each do |t|
          next if t["id"].nil? || t["id"].empty?

          @anchors[t["id"]] = anchor_struct(
            c.increment(t).print, nil,
            t["inequality"] ? @labels["inequality"] : @labels["formula"],
            "formula", t["unnumbered"]
          )
        end
      end
    end
  end
end
