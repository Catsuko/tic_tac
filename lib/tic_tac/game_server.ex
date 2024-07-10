defmodule TicTac.GameServer do
  use GenServer

  def init(_) do
    Process.send_after(self(), :heartbeat, :timer.seconds(5))
    {:ok, :ok}
  end

  def server_name(registry, id) do
    {:via, Registry, {registry, id}}
  end

  def handle_call(:ping, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:heartbeat, state) do
    {:stop, :normal, state}
  end
end
