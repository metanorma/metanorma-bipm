module Metanorma
  module Bipm
    class Converter < Metanorma::Generic::Converter
      COMMITTEE_XPATH =
        "//bibdata/contributor[role/description = 'committee']/organization/" \
        "subdivision[@type = 'Committee']".freeze

      def committee_validate(xml)
        committees = committees_list or return
        xml.xpath("#{COMMITTEE_XPATH}/name").each do |c|
          committees.include? c.text or
            @log.add("BIPM_1", nil, params: [c.text])
        end
        xml.xpath("#{COMMITTEE_XPATH}/identifier[not(@type = 'full')]")
          .each do |c|
          committees.include? c.text or
            @log.add("BIPM_1", nil, params: [c.text])
        end
      end

      def committees_list
        committees = Array(configuration&.committees) or return
        committees.empty? and return
        committees
      end

      def bibdata_validate(doc)
        super
        si_aspect_validate(doc)
      end

      SI_ASPECT_VALUES = %w(
        A_e_deltanu
        A_e
        cd_Kcd_h_deltanu
        cd_Kcd
        full
        K_k_deltanu_h
        K_k
        kg_h_c_deltanu
        kg_h
        m_c_deltanu
        m_c
        mol_NA
        units_A
        units_cd
        units_full
        units_K
        units_kg
        units_m
        units_mol
        units_s
      ).freeze

      def si_aspect_validate(doc)
        doc.xpath("//bibdata/ext/si-aspect").each do |x|
          SI_ASPECT_VALUES.include?(x.text) or
            @log.add("BIPM_2", nil, params: [x.text])
        end
      end
    end
  end
end
