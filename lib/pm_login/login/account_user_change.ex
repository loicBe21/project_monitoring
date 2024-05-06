defmodule PmLogin.Login.AccountUserChange do
  use Ecto.Schema
  import Ecto.Changeset
  alias PmLogin.Login.User

  schema "user_account_change" do
    belongs_to :user, User
    belongs_to :changed_by_user, User
    field :change_details , :string
    field :changed_at, :naive_datetime
    field :change_type , :string
    timestamps()
  end

  def changeset(account_change , attrs) do
    account_change
      |> cast(attrs , [:user_id , :changed_by_user_id , :change_details , :changed_at ,:change_type])
      |> validate_required(:user_id, message: "utilisateur ne doit pas être vide")
      |> validate_required(:changed_by_user_id, message: "utilisateur qui modifie ne doit pas être vide")
      |> validate_required(:changed_at)
      |>validate_inclusion(:change_type , ["arch" , "new_acc" , "change_role"])
  end

  def own_change_changeset(account_change , attrs) do

    account_change
      |>cast(attrs , [:user_id , :change_details , :changed_at , :change_type])
      |> validate_required(:user_id, message: "utilisateur ne doit pas être vide")
      |> validate_required(:changed_at)
      |>validate_inclusion(:change_type , ["own_modif"])
  end

end
