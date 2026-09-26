# frozen_string_literal: true

require "metanorma/html"

module Metanorma
  module Bipm
    # HTML format adapter slice for the BIPM flavor: binds the flavor's
    # document root to the standard document rendering.
    module Html
      class Renderer < Metanorma::Html::StandardRenderer
        register_render "Metanorma::Bipm::Document::Root", :render_standard_document
      end
    end
  end
end
