defmodule HenosisWeb.Graphql.Queries.Permission do
  use Absinthe.Schema.Notation

  object :permission_queries do
    @desc "Get all permissions"
    field :permissions, list_of(:permission) do
      resolve(&HenosisWeb.Graphql.Resolvers.Permissions.list/3)
    end

    @desc "Get an permission by id"
    field :permission, :permission do
      arg(:id, non_null(:id))

      resolve(&HenosisWeb.Graphql.Resolvers.Permissions.find/3)
    end
  end
end
