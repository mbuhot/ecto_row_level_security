defmodule Learnrls.Message do
  use Learnrls.Web, :model

  schema "messages" do
    field :subject, :string
    field :body, :string

    belongs_to :user_from, Learnrls.User, foreign_key: :from, type: :binary_id
    belongs_to :user_to, Learnrls.User, foreign_key: :to, type: :binary_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:from, :to, :subject, :body])
    |> validate_required([:from, :to, :subject, :body])
  end
end
