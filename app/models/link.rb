# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
                            message: 'Invalid format url' }

  def gist?
    URI(url).host == 'gist.github.com'
  end

  def gist_contents
    client = Octokit::Client.new(access_token: ENV['GISTS_TOKEN'])
    gist = client.gist(gist_id)
    files = {}

    gist.files.each do |k, v|
      files[k] = v[:content]
    end

    files.values
  end

  private

  def gist_id
    url.split('/').last
  end
end
