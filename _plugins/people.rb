# Generate data for people page

require 'kramdown'
require 'yaml'

module People
  class PeopleGen < Jekyll::Generator
    def generate(site)
      team_data = YAML.load_file File.join('_data', 'team.yml')

      people = site.pages.detect { |page| page.name == 'people.html' }
      people.data['members'] = team_data.map { |tm| parse_member_entry(tm, site.config['baseurl']) }
      uniq_types = people.data['members'].map { |tm| tm['type'] }.uniq.sort
      # Keep 'default' at top
      uniq_types.insert(0, uniq_types.delete_at(uniq_types.index('default')))
      people.data['types'] = uniq_types
    end

    def get_full_url(url, base)
      url.start_with?('http') ? url : base + url
    end

    def parse_member_entry(entry, base)
      entry['description'] = Kramdown::Document.new(entry['description']).to_html
      entry['image'] = get_full_url(entry['image'], base)
      entry['links'] = entry['links'].map do |link|
        link['url'] = get_full_url(link['url'], base)
        link
      end
      unless entry.key?('type')
        entry['type'] = 'default'
      end
      entry
    end
  end
end
