defmodule PhoenixDynamodb.User do
  @derive [ExAws.Dynamo.Encodable]
  defstruct [:id, :email, :name, :age, :admin]

  alias ExAws.Dynamo
  alias PhoenixDynamodb.User

  def create_table do
    Dynamo.create_table("Users", "id", %{id: :string}, 1, 1)
    |> ExAws.request!
  end

  def delete_table do
    Dynamo.delete_table("Users")
    |> ExAws.request!
  end

  def get_by_id(id) do
    result = Dynamo.get_item("Users", %{id: id})
    |> ExAws.request!
    |> Map.get("Item")

    if result do
      Dynamo.Decoder.decode(result, as: PhoenixDynamodb.User)
    else
      result
    end
  end

  def put(user) do
    if user.id do
      put_request(user)
      user
    else
      new_id_user = %{user | id: generate_id}
      put_request(new_id_user)
      new_id_user
    end
  end

  defp put_request(user) do
    Dynamo.put_item("Users", user)
    |> ExAws.request!
  end

  def delete_by_id(id) do
    Dynamo.delete_item("Users", %{id: id})
    |> ExAws.request!
  end

  def generate_test_data(0) do
    IO.puts("Generated all data.")
  end
  def generate_test_data(times) when is_integer(times) do
    # user = %User{email: "#{times}@example.com", name: "#{times}", age: times, admin: false}
    # User.put(user)
    # IO.puts("Generated #{times}")
    # generate_test_data(times - 1)

    0..times - 1
    |> Enum.map(&(Task.async(fn ->
              user = %User{email: "#{&1}@example.com", name: "#{&1}", age: times, admin: false}
              User.put(user)
              IO.puts("Generated #{&1} data.")
            end)))
    |> Enum.map(&(Task.await/1))
  end

  defp generate_id do
    UUID.uuid4(:hex)
  end
end
