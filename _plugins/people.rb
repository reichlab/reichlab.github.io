# Generate data for people page

require 'kramdown'
require 'yaml'

module People
  class PeopleGen < Jekyll::Generator
    def generate(site)
      team_data = YAML.load_file File.join('_data', 'team.yml')
      # split alumni and current members into separate arrays
      alumni = team_data.select {|p| p.fetch('type', '').downcase == 'alumni'}
      current_members = team_data - alumni

      people = site.pages.detect { |page| page.name == 'people.html' }
      people.data['current_members'] = current_members.shuffle!
      people.data['alumni'] = alumni
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
