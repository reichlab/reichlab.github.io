# Generate data for publications page

require 'bibtex'

module Publications
  class PubGen < Jekyll::Generator
    def generate(site)
      bib_file = File.join('_data', '_bibliography.bib')
      if File.exist? bib_file
        bib_entries = BibTeX.open bib_file

        publications = site.pages.detect { |page| page.name == 'publications.html' }
        publications.data['bib_entries'] = bib_entries.map { |e| parse_entry e }
      end
    end

    def parse_entry(entry)
      parsed = Hash.new
      parsed['bibtex'] = entry.to_s
      parsed['title'] = entry.title.to_s
      parsed['authors'] = entry.authors.to_s
      parsed['journal'] = entry.journal.to_s

      # Trim title
      parsed['title']['{'] = '' if parsed['title'].start_with? '{'
      parsed['title']['}'] = '' if parsed['title'].end_with? '}'

      parsed
    end
  end
end
