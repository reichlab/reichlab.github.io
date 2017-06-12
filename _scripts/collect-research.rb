# Collect research items from github sources

require 'yaml'
require 'git'

config = YAML.load_file('_config.yml')
clone_dir = File.join('_data', 'clones')

if config.key? 'research_sources'
  sources = config['research_sources'].map do |src|
    root, repo = src.split('/')
    {
      'url' => 'https://github.com/' + src,
      'root' => root,
      'repo' => repo
    }
  end

  sources.each do |src|
    Git.clone(src['url'], src['repo'], :path => File.join(clone_dir, src['root']), :depth => 1)
  end
end
