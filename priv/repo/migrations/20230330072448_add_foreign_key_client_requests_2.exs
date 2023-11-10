defmodule PmLogin.Repo.Migrations.AddForeignKeyClientRequests2 do
  use Ecto.Migration

  def change do
    alter table("clients_requests") do
      add :type_id, references("request_type")
    end
  end
end
