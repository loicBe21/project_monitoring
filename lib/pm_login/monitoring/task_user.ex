defmodule PmLogin.Monitoring.TaskUser do
use Ecto.Schema
  import Ecto.Changeset

  schema "task_users" do
    belongs_to :intervener, PmLogin.Login.User, foreign_key: :intervener_id
    belongs_to :task, PmLogin.Monitoring.Task, foreign_key: :task_id
    timestamps()
  end

  @doc false
  def changeset(task_user, attrs) do
    task_user
    |> cast(attrs, [:intervener_id, :task_id])
    |> validate_required([:intervener_id, :task_id])
  end
end
