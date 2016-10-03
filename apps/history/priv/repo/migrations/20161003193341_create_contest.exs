defmodule History.Repo.Migrations.CreateContest do
  use Ecto.Migration

  def change do
    create table(:contests) do
      add :name, :string
      add :start, Ecto.DateTime
      add :finish, Ecto.DateTime
    end

    create table(:challenges) do
      add :name, :string
      add :description, :text
      add :time_limit, :integer
      add :test_count, :integer
    end

    create table(:selections) do
      add :contest_id, references(:contest)
      add :challenge_id, references(:challenge)
    end

    create table(:attempts) do
      add :time, Ecto.DateTime
      add :team_id, references(:teams)
      add :challenge_id, references(:challenges)
      add :status, :string
      add :source, :text
    end

    create table(:teams) do
      add :name, :string
      add :password_hash, :string
    end
  end
end
