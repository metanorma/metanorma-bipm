Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

source "https://rubygems.org"
gem "relaton-render", "~> 3.0" # bipm_* named rules; size and page %-templates
gem "pubid", "~> 2.0" # relaton 3 pairs with pubid 2
gem "metanorma-standoc", "~> 3.5.1.pre.alpha" # Standoc::Document split + relaton 3 allowance
gem "metanorma-utils", "~> 2.0" # Metanorma::Utils::GcBudget API
gem "metanorma-plugin-lutaml", github: "metanorma/metanorma-plugin-lutaml", branch: "main" # LutamlDataPreprocessor, unreleased
gem "metanorma-iso", github: "metanorma/metanorma-iso", branch: "main" # CitationStyle port, unreleased
gem "metanorma-document", "~> 0.5.2.pre.alpha"
gem "isodoc", "~> 3.7.4.pre.alpha" # relaton-render range #846
gem "metanorma-core", github: "metanorma/metanorma-core", branch: "main" # TEMPORARY audit chain (flavor root naming)
git_source(:github) { |repo| "https://github.com/#{repo}" }

gemspec

eval_gemfile("Gemfile.devel") rescue nil
