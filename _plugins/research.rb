# Thematic data generator for research page

require 'front_matter_parser'
require 'yaml'

module Research
  class ResearchGen < Jekyll::Generator
    def generate(site)
      repo_data = YAML.load_file(File.join('_data', 'repositories.yml'))
      research_files = Dir.glob(File.join('_research', '*.md'))
      research_data = research_files.map do |research_file|
        parsed = FrontMatterParser::Parser.parse_file research_file
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

      research = site.pages.detect { |page| page.name == 'research.html' }
      research.data['items'] = research_data
    end
  end
end
