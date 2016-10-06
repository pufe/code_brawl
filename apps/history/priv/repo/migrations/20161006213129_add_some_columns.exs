defmodule History.Repo.Migrations.AddSomeColumns do
  use Ecto.Migration

  def change do
    alter table(:challenges) do
      add :color, :string
    end
    alter table(:teams) do
      add :hidden, :boolean
    end
  end
end
