defmodule PmLogin.Pointages do
 @moduledoc """
  The Pointages context.
  """
  #import Ecto.Changeset
  import Ecto.Query, warn: false
  alias PmLogin.Utilities
  alias PmLogin.Repo

  alias PmLogin.Pointages.LaunchType
  alias PmLogin.Pointages.TaskTracing
  alias PmLogin.Monitoring
  alias PmLogin.Pointages.TimeTracking
  alias PmLogin.Pointages.SaisiesValidees
  alias PmLogin.Login
  import Ecto.Changeset



   def create_task_tracing_from_list(data_list) do
    IO.inspect data_list
    [id, date, start_time, end_time, duration, is_pause, launch_type_id, task_id, user_id, is_recorded, inserted_at, updated_at] = data_list

    %TaskTracing{
      date: date,
      start_time: start_time,
      end_time: end_time,
      duration: duration,
      is_pause: is_pause,
      is_recorded: is_recorded,
      launch_type_id: launch_type_id,  # Assurez-vous que la colonne de lancement est présente dans votre requête SQL
      task_id: task_id,
      user_id: user_id ,
      inserted_at: inserted_at ,
      updated_at: updated_at,
      id: id ,

      # Vous pouvez également inclure d'autres champs en fonction de votre schéma
    }
  end



   #manomboka eto nenaa aaaaa


  #fecth all type lauch
  def get_lauch_types do
    Repo.all(LaunchType)
  end

  def play_changeset(attrs) do
    TaskTracing.play_changeset(%TaskTracing{} , attrs)
  end

  def pause_changeset(attrs) do
    TaskTracing.pause_changeset(%TaskTracing{} , attrs)
  end

  def end_changeset(task_trace , attrs) do

    TaskTracing.end_changeset(task_trace , attrs)

  end




#PmLogin.Monitoring.get_current_record_by_user_id(94)




  def get_current_record_by_user_id(id_user) do
    sql_query = "SELECT * FROM v_current_record WHERE user_id= $1"
    params = [id_user]
    case Ecto.Adapters.SQL.query(Repo, sql_query, params) do
      {:ok, %Postgrex.Result{rows: rows} } ->
        # La requête a réussi, vous pouvez utiliser le résultat
        #Repo.all(TaskTracing, rows)
        if Enum.empty?(rows) do
          # Aucun enregistrement trouvé, peut-être renvoyer une liste vide ou un autre indicateur
          []
        else
          # Convertir les résultats en struct TaskTracing si nécessaire

           Enum.map(rows, &create_task_tracing_from_list/1)
        end
      {:error, reason} ->
        IO.inspect reason
    end
  end








  def get_details_task_in_record(id_user) do
    case get_current_record_by_user_id(id_user) do
      record_list ->
        if Enum.empty?(record_list) do
          nil
        else
          current_record = hd(record_list)
          curent_task_in_record_id = current_record
        end
    end

  end


  defp save_task_trace(task_trace_changeset) do
     case Repo.insert(task_trace_changeset) do
        {:ok, _record} ->
          IO.puts "mety eeeee"
        {:error, task_trace_changeset} ->
          task_trace_changeset
      end
  end


   defp update_task_trace(task_trace_changeset) do
     case Repo.update(task_trace_changeset) do
        {:ok, _record} ->
          IO.puts "mety eeeee"
        {:error, task_trace_changeset} ->
          task_trace_changeset
      end
  end


  defp persist_play_trace(task_trace_changest) do
    task_id = Ecto.Changeset.get_field(task_trace_changest, :task_id)
    user_id = Ecto.Changeset.get_field(task_trace_changest, :user_id)
    task =Monitoring.get_task_with_card!(task_id)
    if task.status_id == 1 do
      save_task_trace(task_trace_changest)
      Monitoring.put_task_to_ongoing(task,user_id)
    else
      save_task_trace(task_trace_changest)
    end

  end

  defp task_is_recordable(task) do
    valid_status_ids = [4, 5, 6]
    not Enum.member?(valid_status_ids, task.status_id)
  end


  def start_record(task_id , user_id) do
   #get current record_task
    task =Monitoring.get_task_with_card!(task_id)
    case task_is_recordable(task) do
      true ->
        current_task_record = get_current_record_by_user_id(user_id)
        if Enum.empty?(current_task_record) do
            persist_play_trace(play_changeset(%{task_id: task_id , user_id: user_id}))
        else
            on_record_task = hd(current_task_record)
            update_task_trace(end_changeset( on_record_task, %{end_time: NaiveDateTime.local_now()}))
            persist_play_trace(play_changeset(%{task_id: task_id , user_id: user_id}))
        end
        {:ok, "Enregistrement de tâche commencé avec succès"}
      false ->
        # La tâche ne peut pas être enregistrée, renvoyer une erreur
        {:error, "La tâche ne peut pas être enregistrée dans son état actuel"}

    end

  end




  def stop_record(task_id ,  user_id , reason_id) do

    current_task_record = get_current_record_by_user_id(user_id)
    on_record_task = hd(current_task_record)
    if task_id == on_record_task.task_id do
      IO.puts "makato zany aloha ***********"
      IO.inspect on_record_task
      val = update_task_trace(end_changeset( on_record_task, %{end_time: NaiveDateTime.local_now()}))
      IO.inspect val
      save_task_trace(pause_changeset(%{task_id: task_id , user_id: user_id , launch_type_id: reason_id}))

    else
      IO.inspect task_id
      IO.inspect on_record_task.task_id
    end
  end


  def list_my_record(user_id , today) do
    #today = NaiveDateTime.local_now() |> NaiveDateTime.to_date()
    sql_query =  "SELECT * FROM task_tracings where date=$1  and user_id= $2"
    case Ecto.Adapters.SQL.query(Repo, sql_query, [today , user_id]) do
      {:ok, %Postgrex.Result{rows: rows} } ->
        # La requête a réussi, vous pouvez utiliser le résultat
        #Repo.all(TaskTracing, rows)
        if Enum.empty?(rows) do
          # Aucun enregistrement trouvé, peut-être renvoyer une liste vide ou un autre indicateur
          []
        else
          # Convertir les résultats en struct TaskTracing si nécessaire
           Enum.map(rows, &create_task_tracing_from_list/1)
        end
      {:error, reason} ->
        IO.inspect reason
    end
  end

  def list_my_record_todays(user_id) do
      today = NaiveDateTime.local_now() |> NaiveDateTime.to_date()
      list_my_record(user_id , today)
  end


  defp time_tracking_changeset(attrs) do
    TimeTracking.changeset(%TimeTracking{} , attrs)
  end

  def save_time_tracking(attrs) do
    case time_tracking_changeset(attrs) do
      %Ecto.Changeset{valid?: true ,changes: changes} ->
        IO.inspect changes
        Repo.insert(time_tracking_changeset(attrs))
        {:ok, :saved}
      %Ecto.Changeset{valid?: false, errors: errors} ->
        IO.inspect errors
      {:error, errors}
    end
  end

 def save_time_tracking1(attrs) do
  case time_tracking_changeset(attrs) do
    %Ecto.Changeset{valid?: true, changes: changes} ->
      case get_saisie_validee(attrs["user_id"], attrs["date"]) do
        nil ->
          Repo.insert(time_tracking_changeset(attrs))
          {:ok, :saved}
        _ ->
          {:error, "Saisie déjà validée pour cette date et cet utilisateur"}
      end
    %Ecto.Changeset{valid?: false, errors: errors} ->
      {:error, "veillez verifier les information saisie"}
  end
end











  def test_changeset() do
     attrs = %{task_id: 789, user_id: 101}
     attrs_1 = %{task_id: 789, user_id: 101 ,duration: -99 ,is_pause: false ,is_recorded: true , launch_type_id: 2 , start_time: NaiveDateTime.utc_now , end_time: NaiveDateTime.add(NaiveDateTime.utc_now , 30) }
     TaskTracing.play_changeset(%TaskTracing{} , attrs)
     TaskTracing.update_changeset(%TaskTracing{} , attrs_1)
  end


  #PmLogin.Pointages.test_changeset2()
  def test_changeset2() do
    attrs =  %{h_work: -360, h_abs: 0}
    TimeTracking.changeset(%TimeTracking{} , attrs)
  end

  def get_users_times_by_date(date) do
    #sql_query = "select users.id ,users.username, auth.right_id  ,coalesce(8 * 60 - sum(h_work), 8 * 60) as h_dynamique_abs, coalesce(sum(h_work),0) as h_work ,coalesce(sum(h_abs),0) as h_abs from users left join  time_tracking ON users.id = time_tracking.user_id AND time_tracking.date = $1 join auth ON auth.id = users.id   group by time_tracking.user_id , users.username , users.id , auth.right_id"
    sql_query = "SELECT
    users.id,
    users.username,
    auth.right_id,
    COALESCE(8 * 60 - SUM(time_tracking.h_work), 8 * 60) AS h_dynamique_abs,
    COALESCE(SUM(time_tracking.h_work), 0) AS h_work,
    COALESCE(SUM(time_tracking.h_abs), 0) AS h_abs,
    saisies_validees.inserted_at AS date_validation
    FROM
    users
    LEFT JOIN
    time_tracking ON users.id = time_tracking.user_id AND time_tracking.date = $1
    LEFT JOIN
    saisies_validees ON users.id = saisies_validees.user_id AND saisies_validees.date = $1
    JOIN
    auth ON auth.id = users.id
    GROUP BY
    users.id, users.username, auth.right_id, saisies_validees.inserted_at"
    params = [date]
    case Ecto.Adapters.SQL.query(Repo, sql_query, params) do
     {:ok, %Postgrex.Result{columns: columns, rows: rows}} ->
      # Construire une liste de maps où chaque map représente une ligne de résultats
      Utilities.build_result(columns, rows)
      {:error, reason} ->
        IO.inspect reason
    end

  end

  def get_details_saisie_by_date_and_user(date , user_id) do
    sql_query = "select time_tracking.task_id,tasks.title as task_title ,projects.title as project_title,sum(time_tracking.h_work) as h_works ,
    time_tracking.user_id , users.username  from time_tracking join tasks on time_tracking.task_id = tasks.id and time_tracking.date=$1 and time_tracking.user_id = $2
    join projects on projects.id = tasks.project_id
    join users on users.id = time_tracking.user_id
    group by time_tracking.task_id ,time_tracking.user_id , tasks.title  ,projects.title,users.username"
    params = [date , user_id]
    case Ecto.Adapters.SQL.query(Repo, sql_query, params) do
     {:ok, %Postgrex.Result{columns: columns, rows: rows}} ->
      # Construire une liste de maps où chaque map représente une ligne de résultats
      Utilities.build_result(columns, rows)
      {:error, reason} ->
        IO.inspect reason
    end

  end


defp can_validate_saisie?(changeset) do
  case changeset.changes.user_validator_id do
    nil ->
      # L'utilisateur n'a pas été spécifié
      false
    user_validator_id ->
      case Login.get_user!(user_validator_id).right_id do
        1 ->
          true
        _ ->
          false
      end
  end
end

def validate_saisie(saisie_attrs) do
  changeset = SaisiesValidees.changeset(%SaisiesValidees{}, saisie_attrs)
  case changeset.valid? do
    true ->
      case can_validate_saisie?(changeset) do
        true ->
          {:ok, changeset}

        false ->
          {:error, "Droit refusé"}
      end

    false ->
      {:error, "Erreur lors de la validation"}
  end
end

def save_saisie_validee(saisie_attrs) do
  case validate_saisie(saisie_attrs) do
    {:ok , changeset}
      ->
        Repo.insert(changeset)
        {:ok, "Saisie validée avec succès"}
    {:error , message}
      ->
        {:error , message}
  end
end

 def get_saisie_validee(user_id, date) do
    Repo.one(from s in SaisiesValidees, where: s.user_id == ^user_id and s.date == ^date)
 end





end
