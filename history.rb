require_relative './trackobot'

class History
  attr_accessor :games

  def initialize(username:, token:)
    auth = { username: username, token: token }
    #only first few pages while debugging
    @games = Trackobot::API.fetch_games(max_pages: 2, auth: auth)
  end

  def games_for_month(month:)
    @games.select do |g|
      added_date = Date.parse(g.added)
      added_date.month == month.month &&
        added_date.year == month.year
    end
  end
end
