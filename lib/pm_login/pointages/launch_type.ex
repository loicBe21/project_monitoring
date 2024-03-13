defmodule PmLogin.Pointages.LaunchType do
 use Ecto.Schema
  import Ecto.Changeset

  schema "launch_types" do
    field :description, :string

    timestamps()
  end



  def changeset(launch_type, attrs) do
    launch_type
    |> cast(attrs, [:description])
    |> validate_required(:description)
  end
end
