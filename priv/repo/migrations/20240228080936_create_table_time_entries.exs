defmodule PmLogin.Repo.Migrations.CreateTableTimeEntries do
  use Ecto.Migration

  def change do


    create table(:time_entries) do

      add :date_entries, :naive_datetime
      add :user_id, references("users")
      add :task_id, references("tasks")
      add :project_id, references("projects")
      add :libele, :string
      add :time_value, :decimal
      timestamps()

    end

  end
end
