defmodule PmLogin.Repo.Migrations.UsersAddPhoneNumber do
  use Ecto.Migration

  def change do

    alter table(:users) do
      add :phone_number, :string, default: nil
    end

  end
end
