defmodule PmLogin.Pointages.SaisiesValidees do
  use Ecto.Schema
  import Ecto.Changeset
  alias PmLogin.Login.User

   schema "saisies_validees" do
    belongs_to :user, User
    belongs_to :user_validator , User
    field :date, :date
    field :h_abs, :integer
    field :h_work, :integer

    timestamps()
  end

  @doc false
  def changeset(saisie_validee, attrs) do
    saisie_validee
    |> cast(attrs, [:user_id, :user_validator_id, :date, :h_abs, :h_work])
    |> validate_required([:user_id, :user_validator_id, :date, :h_abs, :h_work])
  end

end
