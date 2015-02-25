require 'uri'
require 'ostruct'
require 'json'

module Trackobot
  module API
    def self.fetch_games(max_pages: nil, auth:)
      pages = []
      pages << fetch_json(auth: auth)
      page_count = pages.first.meta.total_pages.to_i

      (2..[page_count,max_pages.to_i].min).to_a.each do |page|
        pages << fetch_json(page: page, auth: auth)
      end

      pages.inject([]) { |all,page| all.concat(page.history) }
    end

    private

    def self.query_string(hash)
      hash.to_a.inject("") do |string, pair|
        string << "&#{pair.first.to_s}=#{pair.last}" unless pair.last.nil?
        string
      end.sub(/^&/, '')
    end

    def self.history_url(params: nil, auth:)
      params = auth.merge(params||{})

      URI::HTTPS.build(
        host: "trackobot.com",
        path: "/profile/history.json",
        query: query_string(params)
      ).to_s
    end

    def self.curl_cmd(params: nil, auth:)
      url = history_url(params: params, auth: auth)
      "curl -s \"#{url}\""
    end

    def self.fetch_json(page: nil, auth:)
      json = `#{curl_cmd(auth: auth, params: {page: page})}`
      JSON.parse(json, symbolize_names: true,
                       object_class: OpenStruct)
    end
  end
end
