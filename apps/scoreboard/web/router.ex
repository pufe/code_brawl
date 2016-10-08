defmodule Scoreboard.Router do
  use Scoreboard.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Scoreboard do
    pipe_through :browser # Use the default browser stack

    get "/", MainController, :current_contest
    get "/balloon", MainController, :balloon_feed
    get "/:challenge", MainController, :show_challenge
    get "/old/:id", MainController, :show_contest
  end

  # Other scopes may use custom stacks.
  # scope "/api", Scoreboard do
  #   pipe_through :api
  # end
end
