defmodule PmLoginWeb.Task.TaskNeedValidationLive do

 use Phoenix.LiveView

  alias PmLoginWeb.LiveComponent.CommentsModalLive
  alias PmLoginWeb.LiveComponent.ModifModalLive
  alias PmLoginWeb.LiveComponent.CommentsModalMenu
  alias PmLogin.Services
  alias PmLogin.Monitoring
  alias PmLogin.Login
  alias PmLogin.Kanban
  alias PmLogin.Monitoring.Comment
  alias PmLogin.Monitoring.Task
  alias PmLogin.Monitoring.Priority
  alias PmLoginWeb.Router.Helpers, as: Routes
  alias PmLogin.Login.User

 def mount(_params, %{"curr_user_id"=>curr_user_id, "id"=>id}, socket) do

   Monitoring.subscribe()

    Services.subscribe()
    Services.subscribe_to_request_topic()
    tasks_to_validate = Monitoring.get_invalid_tasks
    IO.inspect tasks_to_validate
  layout = {PmLoginWeb.LayoutView, "attributor_layout_live.html"}
   {:ok,
       socket
       |> assign(
       form: false, curr_user_id: curr_user_id, show_notif: false,id: id,
       is_admin: Monitoring.is_admin?(curr_user_id),
       is_contributor: Monitoring.is_contributor?(curr_user_id),
       is_attributor: Monitoring.is_attributor?(curr_user_id),
       tasks_to_validate: tasks_to_validate,
       notifs: Services.list_my_notifications_with_limit(curr_user_id, 4)
       ),
       layout: layout
       }

 end

 def handle_event("validate_task",%{"task_id" => task_id}, socket) do

  curr_user_id =  socket.assigns.curr_user_id
  IO.inspect task_id
  IO.inspect curr_user_id
  case Monitoring.validate_tsak(String.to_integer(task_id) , curr_user_id) do
      {:ok , task } ->
        IO.puts "nety"
      {:error , reason} ->
        IO.inspect reason
        IO.puts "tsy nety"

  end
  {:noreply , socket|>assign(tasks_to_validate: Monitoring.get_invalid_tasks)}
 end



 def render(assigns) do

  PmLoginWeb.TaskView.render("index_validation_task.html", assigns)

 end

end
