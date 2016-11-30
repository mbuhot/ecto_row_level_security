# Ecto Row Level Security

This repo demonstrates a very simple application of Postgres Row Level Security.
The goal is to ensure that contents of the `messages` table are only visible to the creator of the message.
This should also limit the impact of SQL injection attacks.

# Database Roles

The postgres superuser role is used for database migrations.
The actual web application uses a limited privilege user.
The username and password are switched simply by setting environment variables:

```bash
DATABASE_USER=postgres DATABASE_PASSWORD=postgres mix ecto.migrate
DATABASE_USER=web DATABASE_PASSWORD=passw0rd mix phoenix.server
```

This limits any possible damage caused by a SQL injection attack to only access data in the specific tables granted to the web user.


# Database Schema

The database contains tables for `users` and `messages`.
Row Level Security policy enforces that only the sender of a message is able to query it in the database.

```elixir
create table(:messages) do
  add :from, references(:users, column: :id, type: :uuid)
  add :to, references(:users, column: :id, type: :uuid)
  add :subject, :text, null: false
  add :body, :text, null: false
  timestamps
end
```

```SQL
CREATE POLICY messages_rls_policy ON messages for web
USING (is_current_user("from"))
```

The `is_current_user` function takes a user id, and checks that it matches a salted hashed value stored in the `app.user` setting.

```SQL
CREATE FUNCTION is_current_user(user_id UUID) RETURNS BOOLEAN AS $$
  BEGIN
    RETURN (md5(user_id::TEXT || 'super_secret') = current_setting('app.user'));
  END;
$$ LANGUAGE plpgsql
```

This process makes it resistant to SQL injection attacks, since the attacker won't know the salt, they won't be able to easily set the 'app.user' session variable to any meaningful value.

# Repo

The repo provides a function that will act as the given user for the duration of a transaction:

```elixir
def as_user(user_id, txn) when is_binary(user_id) and is_function(txn) do
  transaction fn ->
    secret = "super_secret"
    user_id_hash = :crypto.hash(:md5, user_id <> secret) |> Base.encode16(case: :lower)
    SQL.query(Learnrls.Repo, "SELECT set_config('app.user', $1, true)", [user_id_hash])
    txn.()
  end
end
```

The 3rd parameter to `set_config` ensures that the variable will automatically be cleared at the end of the transaction, allowing the connection to be safely returned to the connection pool and reused.

# Controller

The `MessageController` module overrides the default phoenix `action/2` plug, running the controller action in a transaction with the user_id from `conn.assigns.user_id`.

```elixir
def action(conn, _) do
  {:ok, conn} = Repo.as_user conn.assigns.user_id, fn ->
    args = [conn, conn.params]
    apply(__MODULE__, action_name(conn), args)
  end
  conn
end
```

# License

MIT, see LICENSE file for full details.
