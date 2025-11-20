module Metanorma
  module Bipm
    class Converter
      BIPM_LOG_MESSAGES = {
        # rubocop:disable Naming/VariableNumber
        "BIPM_1": { category: "Document Attributes",
                    error: "%s is not a recognised committee",
                    severity: 1 },

        "BIPM_2": { category: "Document Attributes",
                    error: "%s is not a recognised si-aspect",
                    severity: 1 },
      }.freeze
      # rubocop:enable Naming/VariableNumber

      def log_messages
        super.merge(BIPM_LOG_MESSAGES)
      end
    end
  end
end
