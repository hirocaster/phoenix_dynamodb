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
end
