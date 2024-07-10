defmodule TicTac.MatchMaker do
  alias TicTac.GameServer
  use GenServer

  def start_link(registry) do
    GenServer.start_link(__MODULE__, registry, name: __MODULE__)
  end

  def init(registry) do
    {:ok, {registry, :empty}}
  end

  def find_match do
    GenServer.call(__MODULE__, :find_match)
  end

  def handle_call(:find_match, _from, {registry, :empty}) do
    game_id = to_string(:rand.uniform(Integer.pow(2, 32)))
    {:ok, _} = GenServer.start_link(GameServer, [], name: GameServer.server_name(registry, game_id))
    {:reply, game_id, {registry, game_id}}
  end

  def handle_call(:find_match, _from, {registry, game_id}) do
    GameServer.start_game(registry, game_id)
    {:reply, game_id, {registry, :empty}}
  end
end
