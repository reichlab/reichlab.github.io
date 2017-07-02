# Collect details from github repositories involved in the theme pages

require 'octokit'
require 'yaml'
require 'front_matter_parser'

# Return details from github using octokit client
def get_github_details(identifier, client)
  repo = client.repo(identifier)
  last_commit = client.commits(identifier)[0]
  repo_data = {
    'url' => repo.html_url,
    'title' => repo.name,
    'description' => repo.description,
    'commit' => {
      'date' => last_commit.commit.author.date.strftime('%b %d, %Y'),
      'string' => last_commit.commit.message,
      'author' => last_commit.commit.author.name,
      'url' => last_commit.html_url
    }
  }

  # Authors might now always have urls
  begin
    repo_data['commit']['author_url'] = last_commit.author.html_url
  rescue
  end

  repo_data
end

# Get a list of github repositories to parse
def get_repositories()
  mds = Dir.glob(File.join('_teaching', '*.md')) + Dir.glob(File.join('_research', '*.md'))
  repos = []
  mds.each do |md|
    content = File.read(md)
    front = FrontMatterParser::Parser.new(:md).call(content).front_matter
    front['projects'].each do |project|
      if project.respond_to? :to_str
        repos << project
      end
    end
  end
  repos.uniq
end

# Get API key from environment
client = Octokit::Client.new(:access_token => ENV['GH_TOKEN'])
data = Hash.new
get_repositories().each do |repo|
  data[repo] = get_github_details(repo, client)
end

# Write to yaml
File.write(File.join('_data', 'repositories.yml'), data.to_yaml)
