require 'html-proofer'

task :clean do
  Dir.glob('_data/clones/*').map { |f| FileUtils.rm_r f }
  Dir.glob('_data/_teaching/*').map { |f| FileUtils.rm_r f }
  Dir.glob('_data/_research/*').map { |f| FileUtils.rm_r f }
  Dir.glob('images/git/*').map { |f| FileUtils.rm_r f }
  File.delete('_data/_bibliography.bib')
end

task test: [:build] do
  sh 'bundle exec jekyll build'
  options = { :assume_extension => true }
  HTMLProofer.check_directory('./_site', options).run
end

task :collect do
  sh 'bundle exec ruby ./_scripts/collect-bibtex.rb'
  sh 'bundle exec ruby ./_scripts/collect-repos.rb'
end

task :build do
  sh 'bundle exec jekyll build'
end
