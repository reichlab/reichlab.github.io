# Download bibtex entries from the specified sources and save to data

require 'http'
require 'yaml'

config = YAML.load_file('_config.yml')

if config.key? 'bibtex_sources'
  sources = config['bibtex_sources']

  unless sources.respond_to?('each')
    sources = [sources]
  end

  bibouts = sources.map { |src| HTTP.get(src).to_s }
  File.write('_data/bibliography.bib', bibouts.join("\n"))
end
