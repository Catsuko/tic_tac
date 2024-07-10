defmodule TicTacWeb.GameLive do
  use TicTacWeb, :live_view

  def render(assigns) do
    ~H"""
    <p>Connected to <%= @game_id %></p>
    """
  end

  def mount(%{"game_id" => game_id}, _session, socket) do
    case Registry.lookup(TicTac.GameRegistry, game_id) do
      [] ->
        {:ok, push_navigate(socket, to: ~p"/")}
      _   ->
        ping()
        {:ok, assign(socket, :game_id, game_id)}
    end
  end

  def ping do
    Process.send_after(self(), :ping, :timer.seconds(1))
  end

  def handle_info(:ping, socket) do
    GenServer.call(server_name(socket.assigns.game_id), :ping)
    ping()
    {:noreply, socket}
  end

  defp server_name(id) do
    TicTac.GameServer.server_name(TicTac.GameRegistry, id)
  end
end
