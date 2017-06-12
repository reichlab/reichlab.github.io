# Generate data for research page

require 'front_matter_parser'
require 'yaml'

module Research
  class ResearchGen < Jekyll::Generator
    def generate(site)
      research_files = Dir.glob(File.join('_research', '*.md')) + Dir.glob(File.join('_data', '_research', '*.md'))
      research_data = research_files.map do |research_file|
        parsed = FrontMatterParser::Parser.parse_file(research_file)
        fm = parsed.front_matter
        {
          'content' => Kramdown::Document.new(parsed.content).to_html,
          'title' => fm['title'],
          'image' => get_full_url(fm['image'], site.config['baseurl']),
          'link' => {
            'name' => fm['link']['name'],
            'url' => get_full_url(fm['link']['url'], site.config['baseurl'])
          }
        }
      end

      research = site.pages.detect { |page| page.name == 'research.html' }
      research.data['items'] = research_data
    end

    def get_full_url(url, base)
      url.start_with?('http') ? url : base + url
    end
  end
end
