defmodule Learnrls.MessageTest do
  use Learnrls.ModelCase

  alias Learnrls.Message

  @valid_attrs %{body: "some content", from: "7488a646-e31f-11e4-aace-600308960662", subject: "some content", to: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end
end
