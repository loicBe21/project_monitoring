defmodule PmLogin.Repo.Migrations.CreateTimeEntriesValidee do
  use Ecto.Migration

  def change do

     create table(:time_entries_validee) do
      add :date, :date, null: false
      add :time_value, :decimal, null: false
      add :user_id, references("users")
      add :user_validator_id, references("users")
      timestamps()
    end

  end
end
