defmodule PmLogin.Pointages.TimeTracking do

  @moduledoc """
   module de gestion de saisie de temps , qui fait reference a la table time_tracking

  """

  use Ecto.Schema
  import Ecto.Changeset

  alias PmLogin.Monitoring.Task
  alias PmLogin.Login.User

  schema "time_tracking" do

    field :date, :date
    field :h_work, :integer
    field :h_abs, :integer
    belongs_to :task, Task
    belongs_to :user, User
    timestamps()
  end


  def changeset(time_tracking , attrs) do
    time_tracking
      |>cast(attrs , [:date, :h_work , :h_abs , :task_id , :user_id])
      |>validate_required(:date , message: "date requis")
      |>validate_required(:user_id, message: "utilisateur requis")
      |>validate_date()
      |>validate_h_work()
      |>validate_h_abs()
  end

  defp validate_h_work(changeset) do
    h_work =  get_field(changeset, :h_work)
    if h_work != nil && h_work < 0 do
      changeset
        |> add_error(:h_work, "cannot be negative")
    else
      changeset
    end

  end

  defp validate_h_abs(changeset) do
    h_abs = get_field(changeset, :h_abs)
    if h_abs != nil && h_abs < 0 do
      changeset
        |> add_error(:h_abs, "cannot be negative")
    else
      changeset
    end

  end

  defp validate_date(changeset) do
    date = get_field(changeset, :date)
    now = NaiveDateTime.utc_now()
    case Date.compare(now, date) do
      :lt ->
        changeset
        |>add_error(:date , "veuillez verifier la date")

      _ -> changeset
    end
  end




end
