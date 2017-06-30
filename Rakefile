require 'html-proofer'

task :clean do
  File.delete('_data/repositories.yml')
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
  sh 'bundle exec jekyll build'
end
