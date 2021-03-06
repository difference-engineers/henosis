defmodule HenosisWeb.Router do
  use HenosisWeb, :router

  @spec absinthe_before_send(map, map) :: map
  def absinthe_before_send(
        %Plug.Conn{method: "POST"} = connection,
        %Absinthe.Blueprint{} = blueprint
      ) do
    Enum.reduce(blueprint.execution.context[:cookies] || [], connection, fn [key, value], accumulation ->
      if value do
        Plug.Conn.put_session(accumulation, key, value)
      else
        Plug.Conn.delete_session(accumulation, key)
      end
    end)
  end

  def absinthe_before_send(connection, _), do: connection

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: ["http://localhost:9000", "http://localhost:8080"]
    plug :accepts, ["json"]
    plug :fetch_session
    plug Henosis.Plugs.GraphqlSessionContext
  end

  scope "/", HenosisWeb do
    pipe_through :browser

    get "/", PageController, :index
  end


  scope "/graphql" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
      schema: HenosisWeb.Graphql.Schema,
      analyze_complexity: true,
      max_complexity: 200,
      before_send: {__MODULE__, :absinthe_before_send}
  end
  # Other scopes may use custom stacks.
  # scope "/api", HenosisWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HenosisWeb.Telemetry
    end
  end
end
