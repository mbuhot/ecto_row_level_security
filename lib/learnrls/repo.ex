defmodule Learnrls.Repo do
  use Ecto.Repo, otp_app: :learnrls
  alias Ecto.Adapters.SQL

  def as_user(user_id, txn) when is_binary(user_id) and is_function(txn) do
    transaction fn ->
      secret = System.get_env("DATABASE_SECRET")
      user_id_hash = :crypto.hash(:md5, user_id <> secret) |> Base.encode16(case: :lower)
      SQL.query(Learnrls.Repo, "SELECT set_config('app.user', $1, true)", [user_id_hash])
      txn.()
    end
  end
end
