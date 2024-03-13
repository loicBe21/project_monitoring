defmodule PmLogin.Repo.Migrations.AddColumnStatusTimeEntriesValidee do
  use Ecto.Migration

  def change do
    alter table(:time_entries_validee) do
      add :validation_status, :integer, default: 0
    end
  end
end
