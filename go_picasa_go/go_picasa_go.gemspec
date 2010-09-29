require 'rubygems'

SPEC = Gem::Specification.new do |s|
  s.name = "GoPicasaGo"
  s.version = "0.1"
  s.author = "Pedro Capaça"
  s.email = "pedro.capaca@gmail.com"
  s.homepage = "http://www.github.com/capaca/go-picasa-go"
  s.platform = Gem::Platform::RUBY
  s.summary = "A library to manipulate picasa's albums and photos"
  candidates = Dir.glob("{bin,docs,lib,tests}/**/*")

  s.files = candidates.delete_if do |item|
    item.include?("CVS") || item.include?("rdoc")
  end
  
  s.require_path = "lib"
  s.autorequire = "picasa"
  s.test_file = "tests/ts_momlog.rb"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  s.add_dependency("Nokogiri", ">= 1.4.3.1")
end

