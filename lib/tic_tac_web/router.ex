defmodule TicTacWeb.Router do
  use TicTacWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TicTacWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", TicTacWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/play", PageController, :play
    live "/game/:game_id", GameLive, as: :game
  end

  if Application.compile_env(:tic_tac, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TicTacWeb.Telemetry
    end
  end
end
