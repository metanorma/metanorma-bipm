require "relaton-render"

module Relaton
  module Render
    module Bipm
      class General < ::Relaton::Render::IsoDoc::General
        def config_loc
          YAML.load_file(File.join(File.dirname(__FILE__), "config.yml"))
        end

        def klass_initialize(_options)
          super
          @nametemplateklass = Relaton::Render::Template::Name
          @seriestemplateklass = Relaton::Render::Template::Series
          @extenttemplateklass = Relaton::Render::Template::Extent
          @sizetemplateklass = Relaton::Render::Template::Size
          @generaltemplateklass = Relaton::Render::Template::General
          @fieldsklass = Relaton::Render::Fields
          @parseklass = Relaton::Render::Parse
        end
      end
    end
  end
end
