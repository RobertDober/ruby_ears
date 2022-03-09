require_relative "lib/ears/version"
version = Ears::VERSION

description = <<~DESCRIPTION
  An Abstract Syntax Tree generating Markdown Parser in Ruby

  Inspired by [EarmarkParser](https://github.com/RobertDober/earmark_parser)

  Feature Rich, close to GFM with some common extensions like IAL, but
  also annotations like in EarmarkParser
DESCRIPTION

Gem::Specification.new do |s|
  s.name        = 'ruby_ears'
  s.version     = version
  s.summary     = 'In: Markdown, Out: AST'
  s.description = description
  s.authors     = ["Robert Dober"]
  s.email       = 'robert.dober@gmail.com'
  s.files       = Dir.glob("lib/**/*.rb")
  s.files      += %w[LICENSE README.md]
  s.homepage    = "https://github.com/robertdober/ruby_ears"
  s.licenses    = %w[Apache-2.0]

  s.add_dependency 'lab42_data_class', '~> 0.8.3'
  s.add_dependency 'zeitwerk', '~> 2.5.4'

  s.required_ruby_version = '>= 3.1.0'
end
# SPDX-License-Identifier: Apache-2.0
