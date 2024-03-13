defmodule PmLogin.Repo.Migrations.CreateTableSaisiesValidees do
  use Ecto.Migration

  def change do

    create table(:saisies_validees) do
      add :date, :date, null: false
      add :h_abs, :integer, null: false
      add :h_work, :integer, null: false
      add :user_id, references("users")
      add :user_validator, references("users")
      timestamps()
    end

    create index(:saisies_validees, [:user_id, :date], unique: true)

  end
end
