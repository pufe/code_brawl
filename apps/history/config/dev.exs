use Mix.Config

config(:history,
       History.Repo,
       [ adapter: Ecto.Adapters.Postgres,
         database: "code_brawl_dev",
         username: "root",
         password: "root",
         hostname: "localhost" ])
