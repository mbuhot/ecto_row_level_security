defmodule Learnrls.User do
  use Learnrls.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :name, :string
    timestamps()

    has_many :messages, Learnrls.Message, foreign_key: :from
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
