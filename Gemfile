Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
gem "relaton-render", "= 3.0.0.pre.alpha.43" # bipm_* named rules; size and page %-templates
gem "pubid", "~> 2.0.0.pre.alpha" # relaton 3 monogem pairs with pubid 2
gem "relaton-bipm" # BIPM identifier canonicalisation (CGPM meeting citeas)
gem "relaton-bib", "2.2.0.pre.alpha.1"
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "main" # Standoc::Document split + relaton 3 allowance
gem "metanorma-utils", github: "metanorma/metanorma-utils", branch: "main" # Metanorma::Utils::GcBudget API, unreleased
gem "metanorma-plugin-lutaml", github: "metanorma/metanorma-plugin-lutaml", branch: "main" # LutamlDataPreprocessor, unreleased
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main" # CitationStyle port, unreleased
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "main" # TEMPORARY audit chain
gem "isodoc", github: "metanorma/isodoc", branch: "main" # relaton-render range #846
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "feat/flavor-table" # TEMPORARY audit chain (flavor root naming)
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

# TEMPORARY cross-PR pins (metanorma-core#18 wave)
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "feat/flavor-table"
gem "metanorma-standoc", github: "metanorma/metanorma-standoc", branch: "feat/move-standard-document"
gem "metanorma-document", github: "metanorma/metanorma-document", branch: "feat/model-validation-l1-declarations"
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "feat/model-validation-migration"

eval_gemfile("Gemfile.devel") rescue nil
