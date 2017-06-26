# Merge bibtex sources in a single file

bibfiles = Dir.glob(File.join('_data', 'bibtex_sources', '*.bib'))

bibouts = bibfiles.map { |src| File.read(src) }
File.write(File.join('_data', '_bibliography.bib'), bibouts.join("\n"))
