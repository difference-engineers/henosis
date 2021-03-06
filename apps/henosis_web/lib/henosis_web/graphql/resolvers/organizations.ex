defmodule HenosisWeb.Graphql.Resolvers.Organizations do
  @spec list(any, any, any) :: {:ok, [%Henosis.Models.Organization{}]} | {:error, any}
  def list(_parent, _arguments, _resolution) do
    {:ok, Database.Repo.all(Henosis.Models.Organization)}
  end

  @spec find(any, %{input: %{id: bitstring}}, any) ::
          {:ok, %Henosis.Models.Organization{}} | {:error, any}
  def find(_parent, %{input: %{id: id}}, _resolution) when not is_nil(id) and is_bitstring(id) do
    {:ok, Database.Repo.get(Henosis.Models.Organization, id)}
  end
  def find(_parent, _arguments, %{context: %{current_account: current_account}}) when is_nil(current_account) do
    {:error, :unauthenticated}
  end

  @spec create(any, %{input: map}, any) :: {:ok, %Henosis.Models.Organization{}} | {:error, any}
  def create(_parent, %{input: input}, _resolution) do
    %Henosis.Models.Organization{}
    |> Henosis.Models.Organization.changeset(input)
    |> case do
      %Ecto.Changeset{valid?: true} = changeset -> Database.Repo.insert(changeset)
      %Ecto.Changeset{valid?: false} = changeset -> {:error, changeset}
    end
  end
  def create(_parent, _arguments, %{context: %{current_account: current_account}}) when is_nil(current_account) do
    {:error, :unauthenticated}
  end

  @spec update(any, %{input: %{:id => bitstring, optional(atom) => any}}, any) ::
          {:ok, %Henosis.Models.Organization{}} | {:error, any}
  def update(_parent, %{input: %{id: id} = input}, _resolution) when is_bitstring(id) do
    Database.Repo.get!(Henosis.Models.Organization, id)
    |> Henosis.Models.Organization.changeset(input)
    |> case do
      %Ecto.Changeset{valid?: true} = changeset -> Database.Repo.insert(changeset)
      %Ecto.Changeset{valid?: false} = changeset -> {:error, changeset}
    end
  end
  def update(_parent, _arguments, %{context: %{current_account: current_account}}) when is_nil(current_account) do
    {:error, :unauthenticated}
  end

  @spec destroy(any, %{input: %{id: bitstring}}, any) ::
          {:ok, %Henosis.Models.Organization{}} | {:error, any}
  def destroy(_parent, %{input: %{id: id}}, _resolution)
      when not is_nil(id) and is_bitstring(id) do
    Database.Repo.get(Henosis.Models.Organization, id)
    |> Database.Repo.delete()
  end
  def destroy(_parent, _arguments, %{context: %{current_account: current_account}}) when is_nil(current_account) do
    {:error, :unauthenticated}
  end
end
