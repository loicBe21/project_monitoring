defmodule PmLogin.Repo.Migrations.CreateLaunchTypes do
  use Ecto.Migration

  def change do
    create table(:launch_types) do
      add :description, :text

      timestamps()
    end

  end
end
