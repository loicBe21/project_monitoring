defmodule PmLogin.MonitoringV2 do
   import Ecto.Query, warn: false
  alias PmLogin.Repo
  alias PmLogin.Monitoring.TaskUser
  alias PmLogin.Login.User
  alias  PmLogin.Utilities
  alias PmLogin.Monitoring.Task
   alias Ecto.Multi
  # module suite du module Monitoring
  # creer pour la maintenabilité du code


   def filter_existing_user_ids(contrib_ids) when is_list(contrib_ids) do
    # Convertir les IDs de string à integer
    integer_ids = Enum.map(contrib_ids, &String.to_integer/1)

    # Query pour obtenir les IDs existants
    from(u in User, where: u.id in ^integer_ids, select: u.id)
    |> Repo.all()
  end


  defp get_task_user_changeset(task_id , user_id)  do
    attrs = %{ "intervener_id" => user_id , "task_id" => task_id}
    %TaskUser{}
    |>TaskUser.changeset(attrs)
  end


  #user_ids => liste d'id utilisateur
 def get_task_user_changeset_by_users(task_id, user_ids) do
    Enum.map(user_ids, fn user_id ->
      get_task_user_changeset(task_id, user_id)
    end)
  end


  #methode de creation d'une taches
  #task_attrs => les attribut de taches
  #users => list des contributeurs
  def create_task(task_attrs) do
    task_users_ids = filter_existing_user_ids(task_attrs["contribs"])
    IO.inspect(task_users_ids, label: "Filtered user IDs")

    {val, _} = Float.parse(task_attrs["estimated_duration_hours"])
    estimated_duration = Utilities.hours_to_rounded_minutes(val)
    params = Map.put(task_attrs, "estimated_duration", estimated_duration)
    IO.inspect(params, label: "Task parameters")

   multi =  Ecto.Multi.new()
    |>Ecto.Multi.insert("tasks" , Task.create_changeset(%Task{},params))

   multi = Multi.run(multi, :add_contributors, fn %{task: task} ->
      add_contributors(task, task_users_ids)
    end)

    IO.inspect multi






  end

 # Helper function to insert contributors
  defp add_contributors(task_id, contributor_ids) do
    changesets = Enum.map(contributor_ids, fn id ->
      %TaskUser{}
      |> TaskUser.changeset(%{task_id: task_id, user_id: id})
    end)

    Repo.insert_all(TaskUser, changesets)
    {:ok, "Contributors added"}
  end


end
