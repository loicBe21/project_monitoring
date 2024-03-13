defmodule PmLogin.Repo.Migrations.AddIsValidToTasks do
  use Ecto.Migration

  def change do

    alter table(:tasks) do
      add :is_valid, :boolean, default: true
    end

  end
end
