# Thematic data generator for teaching page

require 'front_matter_parser'
require 'yaml'

module Teaching
  class TeachingGen < Jekyll::Generator
    def generate(site)
      repo_data = YAML.load_file(File.join('_data', 'repositories.yml'))
      teaching_files = Dir.glob(File.join('_teaching', '*.md'))
      teaching_data = teaching_files.map do |teaching_file|
        parsed = FrontMatterParser::Parser.parse_file teaching_file
        fm = parsed.front_matter
        data = {
          'content' => Kramdown::Document.new(parsed.content).to_html,
          'title' => fm['title'],
          'image' => fm['image'],
          'projects' => fm['projects'].map do |project|
            # Read from yaml if its a github project
            if project.respond_to? :to_str
              repo_data[project]
            else
              project
            end
          end
        }
        if fm.key? 'publications'
          data['publications'] = fm['publications']
        end
        data
      end

      teaching = site.pages.detect { |page| page.name == 'teaching.html' }
      teaching.data['items'] = teaching_data
    end
  end
end
