require 'html-proofer'

task :clean do
  File.delete('_data/repositories.yml')
end

desc "Generate a thematic page plugin in _plugins"
task :ggen, [:page] do |t, args|
  sh "bundle exec ruby ./_scripts/ribosome.rb ./_scripts/theme-gen-gen.rb.dna "\
     "#{args["page"]} > ./_plugins/#{args["page"]}.rb"
end

desc "Generate a thematic page html in root"
task :tpgen, [:page, :divider] do |t, args|
  sh "bundle exec ruby ./_scripts/ribosome.rb ./_scripts/theme-page.html.dna "\
     "#{args["page"]} #{args["divider"]} > #{args["page"]}.html"
end

task test: [:build] do
  sh 'bundle exec jekyll build'
  options = { :assume_extension => true }
  HTMLProofer.check_directory('./_site', options).run
end

task :collect do
  sh 'bundle exec ruby ./_scripts/collect-repos.rb'
end

task :build do
  sh 'bundle exec jekyll build --trace'
end
