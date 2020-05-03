defmodule ExampleWeb.Router do
  use ExampleWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "http://localhost:9000"
    plug :accepts, ["json"]
    plug :fetch_session
    plug Example.Plugs.GraphqlSessionContext
  end

  scope "/" do
    pipe_through :api

    forward "/", Absinthe.Plug,
      schema: ExampleWeb.Graphql.Schema,
      before_send: {__MODULE__, :absinthe_before_send}
  end

  @spec absinthe_before_send(any, any) :: any
  def absinthe_before_send(
        %Plug.Conn{method: "POST"} = connection,
        %Absinthe.Blueprint{} = blueprint
      ) do
    Enum.reduce(blueprint.execution.context[:cookies] || [], connection, fn [key, value],
                                                                            accumulation ->
      if value do
        Plug.Conn.put_session(accumulation, key, value)
      else
        Plug.Conn.delete_session(accumulation, key)
      end
    end)
  end

  def absinthe_before_send(connection, _), do: connection
end
