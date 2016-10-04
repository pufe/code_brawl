defmodule History.Repo.Migrations.CreateContest do
  use Ecto.Migration

  def change do
    create table(:contests) do
      add :name, :string
      add :start, :timestamp
      add :finish, :timestamp
    end

    create table(:challenges) do
      add :name, :string
      add :description, :text
      add :time_limit, :integer
      add :test_count, :integer
      add :contest_id, references(:contests)
    end

    create table(:teams) do
      add :name, :string
      add :password, :string
    end

    create table(:attempts) do
      add :time, :timestamp
      add :team_id, references(:teams)
      add :challenge_id, references(:challenges)
      add :status, :string
      add :source, :text
    end
  end
end
