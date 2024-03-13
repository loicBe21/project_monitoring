defmodule PmLogin.Pointages.TaskTracing do
  use Ecto.Schema
  import Ecto.Changeset
  alias PmLogin.Monitoring.Task
  alias PmLogin.Login.User
  alias PmLogin.Pointages.LaunchType








  #module qui fait reference a la table task_tracings
  #utiliser pour mapper les trace de record concernant a une taches

  schema "task_tracings" do
    field :date, :date
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
    field :duration, :integer
    field :is_pause, :boolean, default: false
    field :is_recorded, :boolean, default: false
    belongs_to :launch_type, LaunchType
    belongs_to :task, Task
    belongs_to :user, User
    timestamps()
  end










  def changeset(task_trace , attrs) do
    task_trace
      |> cast(attrs , [:date, :task_id ,:user_id ,:start_time  ,:duration ,:is_pause , :is_recorded ,:launch_type_id])
  end


  #set date.now() to the field date , start_time
  #params => changeset
  defp put_default_dates(changeset) do
    changeset
    |> put_change(:date, NaiveDateTime.local_now() |> NaiveDateTime.to_date())
    |> put_change(:start_time, NaiveDateTime.local_now())
  end


  #start_time and end_time validation
  #params => changeset
  defp validate_start_end_times(changeset) do
    start_time = Ecto.Changeset.get_field(changeset, :start_time)
    end_time = Ecto.Changeset.get_field(changeset, :end_time)

    if start_time != nil && end_time != nil && start_time > end_time do
      changeset
      |>add_error( :end_time, "La fin ne peut pas être antérieure au début")
    else
      changeset
    end
  end

  # negative values of duration verification
  #params => changeset
 defp validate_non_negative_duration(changeset) do
  duration = Ecto.Changeset.get_field(changeset, :duration)

  if duration != nil && duration < 0 do
    changeset
    |> add_error(:duration, "La durée doit être supérieure ou égale à zéro")
  else
    changeset
  end
end

defp put_end_status(changeset) do
  changeset
  |>put_change(:is_recorded ,  true)
end

defp put_pause_status(changeset) do
   changeset
  |>put_change(:is_pause ,  true)
end

def convert_in_minutes(second_val) do
    div(second_val, 60)
end


defp calcule_duration(end_time , start_time) do
  second_val = NaiveDateTime.diff(end_time, start_time, :second)
  convert_in_minutes(second_val)
end

defp put_duration(changeset) do
  start = Ecto.Changeset.get_field(changeset, :start_time)
  en_d = Ecto.Changeset.get_field(changeset, :end_time)
  duration_val = calcule_duration(en_d , start)
  changeset
  |>put_change(:duration , duration_val)

end

  def create_changeset(task_trace , attrs) do
    task_trace
    |>cast(attrs , [:date , :task_id , :user_id , :start_time])
    |>put_default_dates()
  end


  def update_changeset(task_trace , attrs ) do
     task_trace
    |>cast(attrs , [:date , :task_id , :user_id , :start_time , :end_time ,:duration , :is_pause , :is_recorded , :launch_type_id ])
    |>validate_required(:task_id  , message: "task can't be null")
    |>validate_required(:user_id  , message: "user can't be null")
    |>validate_required(:start_time  , message: "start_time can't be null")
    |>validate_required(:end_time  , message: "end_time can't be null")
    |>validate_required(:duration  , message: "duration can't be empty")
    |>validate_start_end_times()
    |>validate_non_negative_duration

  end




  #changeset use for play action
  def play_changeset(task_trace , attrs) do
    task_trace
    |>cast(attrs ,[ :task_id , :user_id , :is_pause , :is_recorded ])
    |>validate_required(:task_id  , message: "task can't be null")
    |>validate_required(:user_id  , message: "user can't be null")
    |>put_default_dates()

  end

  #changeset use for pause action
  def pause_changeset(task_trace , attrs) do
    task_trace
    |>cast(attrs ,[ :task_id , :user_id , :is_pause , :is_recorded  , :launch_type_id])
    |>validate_required(:task_id  , message: "task can't be null")
    |>validate_required(:user_id  , message: "user can't be null")
    |>validate_required(:launch_type_id  , message: "lauch type can't be null")
    |>put_pause_status()
    |>put_default_dates()


  end


  def end_changeset(task_trace , attrs) do
    task_trace
    |>cast(attrs, [:end_time , :duration , :is_recorded   ])
    |>put_end_status
    |>put_duration


  end








end
