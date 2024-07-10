defmodule TicTac.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TicTacWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:tic_tac, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TicTac.PubSub},
      {Registry, keys: :unique, name: TicTac.GameRegistry},
      {TicTac.MatchMaker, TicTac.GameRegistry},
      TicTacWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: TicTac.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    TicTacWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
