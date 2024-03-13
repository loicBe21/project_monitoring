defmodule PmLogin.Repo.Migrations.CreateTimeTracking do
  use Ecto.Migration

  def change do

    create table (:time_tracking) do
      add :date, :date, null: false
      add :h_work, :integer , null: false , default: 0
      add :h_abs, :integer , null: false , default: 0
      add :task_id, references("tasks")
      add :user_id, references("users")

      timestamps()
    end

  end
end
