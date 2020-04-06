defmodule Blank.Models.OrganizationPermission do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organization_permissions" do
    belongs_to :organization_membership, Blank.Models.OrganizationMembership, primary_key: true
    belongs_to :permission, Blank.Models.Permission, primary_key: true
    has_one :account, through: [:organization_membership, :account]
    has_one :organization, through: [:organization_membership, :organization]

    timestamps()
  end

  @doc false
  def changeset(record, attributes) do
    record
    |> cast(attributes, [])
    |> validate_required([])
    |> assoc_constraint(:organization_membership)
    |> assoc_constraint(:permission)
    |> put_assoc(:organization_membership, attributes.organization_membership)
    |> put_assoc(:permission, attributes.permission)
  end
end
