defmodule TicTac.GameServer do
  use GenServer

  def init(_) do
    {:ok, :waiting_for_players}
  end

  def server_name(registry, id) do
    {:via, Registry, {registry, id}}
  end

  def start_game(registry, game_id) do
    GenServer.cast(server_name(registry, game_id), :start)
  end

  def handle_cast(:start, _state) do
    Process.send_after(self(), :heartbeat, :timer.seconds(5))
    {:noreply, :active}
  end

  def handle_call(:ping, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:heartbeat, state) do
    {:stop, :normal, state}
  end
end
