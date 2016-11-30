defmodule Learnrls.Repo.Migrations.AddMessagesTable do
  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :text, null: false
      timestamps
    end

    create table(:messages) do
      add :from, references(:users, column: :id, type: :uuid)
      add :to, references(:users, column: :id, type: :uuid)
      add :subject, :text, null: false
      add :body, :text, null: false
      timestamps
    end

    execute "ALTER TABLE messages ENABLE ROW LEVEL SECURITY"

    execute """
    CREATE OR REPLACE FUNCTION is_current_user(user_id UUID) RETURNS BOOLEAN AS $$
      BEGIN
        RETURN (md5(user_id::TEXT || '#{System.get_env("DATABASE_SECRET")}') = current_setting('app.user'));
      END;
    $$ LANGUAGE plpgsql
    """

    execute """
    CREATE POLICY messages_rls_policy ON messages
    USING (is_current_user("from"))
    """
  end

  def down do
    drop table(:messages)
    drop table(:users)
  end
end
