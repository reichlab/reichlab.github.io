# Generate data for publications page

require 'yaml'

module Publications
  class PubGen < Jekyll::Generator
    def generate(site)
      data = YAML.load_file(File.join('_data', 'publications.yml'))
      publications = site.pages.detect { |page| page.name == 'publications.html' }

      publications.data['keywords'] = get_unique_keywords(data)
      publications.data['items'] = process_data(data)
    end

    def get_unique_keywords(data)
      keywords = []
      data.each do |item|
        if item.key? 'keywords'
          keywords += item['keywords'].split(',').map { |kw| kw.downcase.strip }
        end
      end
      keywords.uniq
    end

    def process_data(data)
      year_map = Hash.new

      data.each do |entry|
        year = if entry.key? 'year' then entry['year'] else 9999 end

        unless year_map.key? year
          year_map[year] = []
        end
        entry['year'] = year

        begin
          entry['keywords'] = entry['keywords'].split(',').map { |kw| kw.downcase.strip }
        rescue
          entry['keywords'] = []
        end

        entry['abstract'].strip!
        entry['authors'].strip!
        entry['title'].strip!

        # Create cite text of format /journal/, volume : pages
        if entry.key?('journal')
          text = "<em>#{entry['journal']}</em>"
          if entry.key?('volume')
            text += ', ' + entry['volume'].to_s
            if entry.key?('pages')
              text += ' : ' + entry['pages'].to_s
            end
          end
          entry['cite_text'] = text
        end
        year_map[year] << entry
      end

      year_list = year_map.map do |key, value|
        {
          'year' => key,
          'items' => value
        }
      end

      # Sort groups from latest year to oldest
      year_list.sort_by { |i| -i['year'] }
    end
  end
end
