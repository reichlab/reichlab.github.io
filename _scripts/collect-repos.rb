# Collect research and teaching items from github sources

require 'yaml'
require 'git'
require 'front_matter_parser'

config = YAML.load_file('_config.yml')


# Add given github sources meta files to target directory
def add_sources(sources, target)
  sources.each do |src|
    local_path = File.join('_data', 'clones', src['root'])

    Git.clone(src['url'], src['repo'], :path => local_path, :depth => 1)
    metadata_file = File.join(local_path, src['repo'], 'websitemeta.md')

    if File.exist? metadata_file
      metadata_content = File.read(metadata_file)
      parsed = FrontMatterParser::Parser.new(:md).call(metadata_content)

      # Resolve image urls local to repo
      # NOTE; Not working on link urls since they are hard to reason about,
      # e.g. should it go relative to project's web page or is it just a file
      image_url = parsed.front_matter['image']
      if image_url.start_with? '/'
        source_image = File.join(local_path, src['repo'], image_url)
        target_image = File.join('images', 'git', src['root'] + '-' + src['repo'] + '-' + image_url[1..-1])
        FileUtils.cp(source_image, target_image)

        # Change path in metadata
        metadata_content.sub!(image_url, '/' + target_image.to_s)
      end

      # Write to new location
      File.write(File.join(target, src['root'] + '-' + src['repo'] + '.md'), metadata_content)
    else
      abort("Metadata file for #{src['repo']} not found")
    end
  end
end

def get_source_hash(source_list)
  source_list.map do |src|
    root, repo = src.split('/')
    {
      'url' => 'https://github.com/' + src,
      'root' => root,
      'repo' => repo
    }
  end
end


if config.key? 'research_sources'
  sources = get_source_hash config['research_sources']
  markdown_target = File.join('_data', '_research')

  add_sources sources, markdown_target
end

if config.key? 'teaching_sources'
  sources = get_source_hash config['teaching_sources']

  markdown_target = File.join('_data', '_teaching')
  add_sources sources, markdown_target
end

