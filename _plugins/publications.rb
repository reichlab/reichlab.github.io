# Generate data for publications page

require 'bibtex-ruby'

module Publications
  class PubGen < Jekyll::Generator
    def generate(site)
      publications = site.pages.detect {|page| page.name == 'publications.html'}
      publications.data['test'] = 'hello world'
    end
  end
end
