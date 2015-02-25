require 'dotenv'
require 'date'
require_relative './history'

Dotenv.load

history = History.new(username: ENV['TRACKOBOT_API_USERNAME'],
                      token: ENV['TRACKOBOT_API_TOKEN'])

games = history.games #_for_month(month: Date.new(2015, 2))
wins = games.select { |g| g.result == "win" }.size
pct = "%.2f\%" % (wins.fdiv(games.size) * 100)
puts "#{wins}/#{games.size} (#{pct})"

# TODO: task to download data & put it into sqlite via activerecord
# TODO: how many
#         - games
#         - wins
#       did I have for a given
#         - month
#         - class
#         - deck
