defmodule PmLogin.Repo.Migrations.CreateTaskTracings do
  use Ecto.Migration

  def change do

    create table(:task_tracings) do
      add :date, :date
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime
      add :duration, :integer
      add :is_pause, :boolean, default: false
      add :launch_type_id, references("launch_types")
      add :task_id, references("tasks")
      add :user_id, references("users")
      add :is_recorded, :boolean ,default: false
      timestamps()
    end

  end
end
