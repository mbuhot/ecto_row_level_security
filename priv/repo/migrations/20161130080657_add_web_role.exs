defmodule Learnrls.Repo.Migrations.AddWebRole do
  use Ecto.Migration

  def up do
    execute "DROP ROLE IF EXISTS web"
    execute "CREATE USER web WITH PASSWORD '#{System.get_env("WEB_PASSWORD")}'"
    execute "GRANT SELECT, INSERT, UPDATE, DELETE on messages, users TO web"
    execute "GRANT USAGE ON messages_id_seq TO web"
  end

  def down do
    execute "DROP OWNED BY web CASCADE"
    execute "DROP ROLE web"
  end
end
