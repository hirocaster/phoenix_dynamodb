use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :phoenix_dynamodb, PhoenixDynamodb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :phoenix_dynamodb, PhoenixDynamodb.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "",
  database: "phoenix_dynamodb_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :ex_aws,
  debug_requests: true,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "us-east-1"

config :ex_aws, :dynamodb,
  scheme: "http://",
  host: "localhost",
  port: 8000,
  region: "us-east-1"
