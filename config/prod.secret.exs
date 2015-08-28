use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :officetournament, Officetournament.Endpoint,
  secret_key_base: "tBHe4cQjWWvp7Ql85aXB59bY7BpI7vTGXALgbhnRgO17IDzKnp6bDNrqP+TjhLQg"

# Configure your database
config :officetournament, Officetournament.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "officetournament_prod",
  pool_size: 20
