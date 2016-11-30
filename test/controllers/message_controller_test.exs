defmodule Learnrls.MessageControllerTest do
  use Learnrls.ConnCase
  alias Learnrls.Message
  require Learnrls.Repo

  @valid_attrs %{body: "some content", from: "7488a646-e31f-11e4-aace-600308960662", subject: "some content", to: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %Learnrls.User {name: "alice"}
    conn = assign(conn, :user_id, user.id)
    %{conn: conn, user: user}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, message_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing messages"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, message_path(conn, :new)
    assert html_response(conn, 200) =~ "New message"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), message: @valid_attrs
    assert redirected_to(conn) == message_path(conn, :index)
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, message_path(conn, :create), message: @invalid_attrs
    assert html_response(conn, 200) =~ "New message"
  end

  test "shows chosen resource", %{conn: conn, user: alice} do
    bob = Repo.insert! %Learnrls.User {name: "bob"}
    {:ok, message} = Repo.as_user alice.id, fn ->
      Repo.insert! %Message{
        from: alice.id,
        to: bob.id,
        subject: "test1",
        body: "The test message1"
      }
    end
    conn = get conn, message_path(conn, :show, message)
    assert html_response(conn, 200) =~ "Show message"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, message_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, user: alice} do
    bob = Repo.insert! %Learnrls.User {name: "bob"}

    {:ok, message} = Repo.as_user alice.id, fn ->
      Repo.insert! %Message{
        from: alice.id,
        to: bob.id,
        subject: "test",
        body: "The test message"
      }
    end
    conn = get(conn, message_path(conn, :edit, message))
    assert html_response(conn, 200) =~ "Edit message"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = put conn, message_path(conn, :update, message), message: @valid_attrs
    assert redirected_to(conn) == message_path(conn, :show, message)
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = put conn, message_path(conn, :update, message), message: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit message"
  end

  test "deletes chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = delete conn, message_path(conn, :delete, message)
    assert redirected_to(conn) == message_path(conn, :index)
    refute Repo.get(Message, message.id)
  end
end
