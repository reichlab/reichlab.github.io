# Generate data for publications page

require 'bibtex'
require 'citeproc'
require 'csl/styles'

module Publications
  class PubGen < Jekyll::Generator
    def generate(site)
      bib_file = File.join('_data', '_bibliography.bib')
      if File.exist? bib_file
        bib_entries = BibTeX.open bib_file
        cp = CiteProc::Processor.new style: 'apa', format: 'html'
        cp.import bib_entries.to_citeproc

        publications = site.pages.detect { |page| page.name == 'publications.html' }
        publications.data['bib_tags'] = get_tags(bib_entries)
        publications.data['bib_entries'] = bib_entries.map { |e| parse_entry e, cp }
      end
    end

    def get_tags(bib_entries)
      tags = Set.new
      bib_entries.each do |entry|
        begin
          tags.merge entry['keywords'].split(',').map { |kw| kw.downcase.strip }
        rescue
        end
      end
      Array(tags)
    end

    def parse_entry(entry, cp)
      parsed = Hash.new
      parsed['bibtex'] = entry.to_s

      parsed['cite_text'] = cp.render(:bibliography, id: entry.key)[0].to_s
      parsed['cite_text'].gsub! '{', ''
      parsed['cite_text'].gsub! '}', ''

      parsed['sort'] = {
        'author' => entry.authors.to_s,
        'date' => get_date_key(entry)
      }

      parsed
    end

    def get_date_key(entry)
      month_map = {
        'jan' => '01',
        'feb' => '02',
        'mar' => '03',
        'apr' => '04',
        'may' => '05',
        'jun' => '06',
        'jul' => '07',
        'aug' => '08',
        'sep' => '09',
        'oct' => '10',
        'nov' => '11',
        'dec' => '12'
      }
      year = begin
               entry.year.to_s
             rescue
               # Assuming its the most recent
               '9999'
             end
      month = begin
                month_map[entry.month.to_s]
              rescue
                # Assuming its the most recent
                '13'
              end
      year + month
    end
  end
end
