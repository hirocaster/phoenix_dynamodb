defmodule PhoenixDynamodb.UserTest do
  use PhoenixDynamodb.ModelCase

  alias PhoenixDynamodb.User

  alias ExAws.Dynamo

  setup_all do
    tables_list = Dynamo.list_tables |> ExAws.request! |> Map.get("TableNames")

    if Enum.member?(tables_list, "Users") do
      User.delete_table
    end

    :ok
  end

  test "Operation Users table" do
    User.create_table

    user = %User{email: "bubba@foo.com", name: "Bubba", age: 23, admin: false}

    user = User.put(user)

    result = User.get_by_id(user.id)

    assert result.id

    # id以外は同一値
    assert %{user | id: result.id} == result

    update_age_user = %{result | age: 24}

    User.put(update_age_user)

    update_user = User.get_by_id(update_age_user.id)

    assert update_user == update_age_user

    User.delete_by_id(update_age_user.id)

    assert nil == User.get_by_id(update_age_user.id)

    # User.generate_test_data(10000)
  end
end
