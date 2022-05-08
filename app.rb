require "sinatra"
require "./lib/player"
require "./lib/game"

class RPS < Sinatra::Base
  enable :sessions
  
  get '/' do
    erb :index
  end

  post "/names" do
    player1 = Player.new(params[:player_1_name])
    player2input = params[:player_2_name].empty? ? "Computer" : params[:player_2_name]
    player2 = Player.new(player2input)
    $game = Game.new(player1, player2)
    redirect '/play'
  end

  get '/play' do
    @game = $game
    erb :play
  end

  post '/result' do
    @game = $game
    @game.turn.throw(params[:throw])
    # p params[:throw]
    # p @game.turn.name
    # p @game.turn.action
    @game.calculate_outcome
    @game.switch_turns
    redirect '/play'
  end

  run! if app_file == $0
end