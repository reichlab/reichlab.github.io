# Generate data for teaching page

require 'front_matter_parser'
require 'yaml'

module Teaching
  class TeachingGen < Jekyll::Generator
    def generate(site)
      teaching_files = Dir.glob(File.join('_teaching', '*.md')) + Dir.glob(File.join('_data', '_teaching', '*.md'))
      teaching_data = teaching_files.map do |teaching_file|
        parsed = FrontMatterParser::Parser.parse_file teaching_file
        fm = parsed.front_matter
        {
          'content' => Kramdown::Document.new(parsed.content).to_html,
          'title' => fm['title'],
          'image' => get_full_url(fm['image'], site.config['baseurl']),
          'link' => get_full_url(fm['link'], site.config['baseurl']),
          'category' => fm['category']
        }
      end

      teaching = site.pages.detect { |page| page.name == 'teaching.html' }
      teaching.data['items'] = teaching_data
    end

    def get_full_url(url, base)
      url.start_with?('http') ? url : base + url
    end
  end
end
