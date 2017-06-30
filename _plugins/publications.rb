# Generate data for publications page

require 'yaml'

module Publications
  class PubGen < Jekyll::Generator
    def generate(site)
      data = YAML.load_file(File.join('papers', 'reichlab-pub-list.yml'))
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

        entry['sort_date'] = get_date_key(entry)

        begin
          entry['keywords'] = entry['keywords'].split(',').map { |kw| kw.downcase.strip }
        rescue
          entry['keywords'] = []
        end

        year_map[year] << entry
      end

      year_map.each do |key, value|
        value.sort_by! { |i| i['sort_date'] }
      end

      year_list = year_map.map do |key, value|
        {
          'year' => key,
          'items' => value
        }
      end

      year_list.sort_by { |i| -i['year'] }
    end

    def get_date_key(entry)
      # month_map = {
      #   'jan' => '01',
      #   'feb' => '02',
      #   'mar' => '03',
      #   'apr' => '04',
      #   'may' => '05',
      #   'jun' => '06',
      #   'jul' => '07',
      #   'aug' => '08',
      #   'sep' => '09',
      #   'oct' => '10',
      #   'nov' => '11',
      #   'dec' => '12'
      # }
      year = begin
               entry['year'].to_s
             rescue
               # Assuming its the most recent
               '9999'
             end
      # month = begin
      #           month_map[entry['month'].to_s]
      #         rescue
      #           # Assuming its the most recent
      #           '13'
      #         end
      Integer(year)
    end
  end
end
