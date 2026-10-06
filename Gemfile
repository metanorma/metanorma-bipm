Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
gem "relaton-render", "3.0.0.pre.alpha.12"
gem "pubid", "~> 2.0.0.pre.alpha" # relaton 3 monogem pairs with pubid 2
gem "relaton-bipm" # BIPM identifier canonicalisation (CGPM meeting citeas)
gem "relaton-bib", "~> 2.2.0.pre.alpha.1"
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "main" # Standoc::Document split + relaton 3 allowance
gem "metanorma-utils", github: "metanorma/metanorma-utils", branch: "main" # Metanorma::Utils::GcBudget API, unreleased
gem "metanorma-plugin-lutaml", github: "metanorma/metanorma-plugin-lutaml", branch: "main" # LutamlDataPreprocessor, unreleased
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main" # CitationStyle port, unreleased
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main" # TEMPORARY audit chain
gem "isodoc", github: "metanorma/isodoc", branch: "main" # relaton-render range #846
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

eval_gemfile("Gemfile.devel") rescue nil
