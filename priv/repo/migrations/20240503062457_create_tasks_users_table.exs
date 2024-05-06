defmodule PmLogin.Repo.Migrations.CreateTasksUsersTable do
  use Ecto.Migration

   def change do
    create table(:task_users) do
      add :intervener_id, references("users"), null: false
      add :task_id, references("tasks"), null: false
      timestamps()
    end

    # Créer un index unique pour s'assurer que la paire (intervener_id, task_id) est unique
    create unique_index(:task_users, [:intervener_id, :task_id])
  end
end
