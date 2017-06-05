# Generate data for people page

require 'kramdown'
require 'yaml'

module People
  class PeopleGen < Jekyll::Generator
    def generate(site)
      team_data = YAML.load_file '_data/team.yml'

      people = site.pages.detect { |page| page.name == 'people.html' }
      people.data['members'] = team_data.map { |tm| parse_member_entry tm }
    end

    def parse_member_entry(entry)
      entry['description'] = Kramdown::Document.new(entry['description']).to_html
      entry
    end
  end
end
