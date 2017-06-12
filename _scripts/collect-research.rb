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

  markdown_target = File.join('_data', '_research')

  sources.each do |src|
    local_path = File.join(clone_dir, src['root'])
    Git.clone(src['url'], src['repo'], :path => local_path, :depth => 1)
    metadata_file = File.join(local_path, src['repo'], 'websitemeta.md')

    if File.exist? metadata_file
      FileUtils.cp(metadata_file, File.join(markdown_target, src['root'] + '-' + src['repo'] + '.md'))
    else
      abort("Metadata file for #{src['repo']} not found")
    end
  end
end
