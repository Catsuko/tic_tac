defmodule TicTacWeb.PageController do
  alias TicTac.MatchMaker
  use TicTacWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def play(conn, _params) do
    game_id = MatchMaker.find_match()
    IO.inspect(game_id)
    redirect(conn, to: ~p"/game/#{game_id}")
  end
end
