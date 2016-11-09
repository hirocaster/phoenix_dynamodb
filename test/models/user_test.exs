defmodule PhoenixDynamodb.UserTest do
  use PhoenixDynamodb.ModelCase

  alias PhoenixDynamodb.User

  alias ExAws.Dynamo

  setup_all do
    User.delete_table
    :ok
  end

  test "Create table" do
    User.create_table

    user = %User{email: "bubba@foo.com", name: "Bubba", age: 23, admin: false}
    Dynamo.put_item("Users", user) |> ExAws.request!

    result = Dynamo.get_item("Users", %{email: user.email})
    |> ExAws.request!

    decoded_result = result["Item"]
    |> Dynamo.Decoder.decode(as: PhoenixDynamodb.User)

    assert user == decoded_result
  end
end
