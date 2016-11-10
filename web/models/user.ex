defmodule PhoenixDynamodb.User do
  @derive [ExAws.Dynamo.Encodable]
  defstruct [:email, :name, :age, :admin]

  alias ExAws.Dynamo

  def create_table do
    Dynamo.create_table("Users", "email", %{email: :string}, 1, 1)
    |> ExAws.request!
  end

  def delete_table do
    Dynamo.delete_table("Users")
    |> ExAws.request!
  end

  def get_by_email(email) do
    result = Dynamo.get_item("Users", %{email: email})
    |> ExAws.request!
    |> Map.get("Item")

    if result do
      Dynamo.Decoder.decode(result, as: PhoenixDynamodb.User)
    else
      result
    end
  end

  def put(user) do
    Dynamo.put_item("Users", user)
    |> ExAws.request!
  end

  def delete_by_email(email) do
    Dynamo.delete_item("Users", %{email: email})
    |> ExAws.request!
  end
end
