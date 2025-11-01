module Relaton
  module Render
    class Citations
      # TODO different behaviour for JCGM = ISO
      def use_terminator?(ref, final, cit)
        !ref || ref.empty? and return false
        cit[:data][:home_standard] and return false
        !ref.end_with?(final)
      end
    end
  end
end
