defmodule PmLogin.Repo.Migrations.AddColumnStatusTimeEntries do
  use Ecto.Migration

  def change do

     alter table(:time_entries) do
      add :validation_status, :integer, default: 0
    end

  end
end
