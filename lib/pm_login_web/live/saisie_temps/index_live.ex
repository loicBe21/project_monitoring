defmodule PmLoginWeb.SaisieTemps.IndexLive do


  use Phoenix.LiveView
  alias PmLogin.Services
  alias PmLogin.Monitoring
  alias PmLogin.Utilities
  alias PmLogin.Pointages
  alias PmLogin.Login

  def mount(_params, %{"curr_user_id" => curr_user_id}, socket) do

    today = NaiveDateTime.local_now()
    current_user =  Login.get_user!(curr_user_id)
    layout =
      case current_user.right_id do
        1 -> {PmLoginWeb.LayoutView, "admin_layout_live.html"}
        2 -> {PmLoginWeb.LayoutView, "attributor_layout_live.html"}
        3 -> {PmLoginWeb.LayoutView, "contributor_layout_live.html"}
        _ -> {}
      end
      IO.inspect socket
    socket =
      socket
        |>assign(
          current_user: current_user ,
          curr_user_id:  curr_user_id ,
          notifs: Services.list_my_notifications_with_limit(curr_user_id, 4),
          tasks: Monitoring.get_my_task_active(curr_user_id),
          today: Utilities.simple_date_format1(today),
          date_today: today,
          show_notif: false
        )
    {:ok, socket , layout: layout}
  end

   def handle_event("submit_time", %{"task_id" => task_id, "user_id" => user_id, "hours" => hours, "minutes" => minutes,"date" => date} = attrs, socket) do
      # Inspecter les données reçues
      h_work = (String.to_integer(hours) * 60) + String.to_integer(minutes)
      IO.inspect attrs
      attrs = Map.put(attrs, "h_work", h_work)
      case Pointages.save_time_tracking1(attrs) do
        {:ok, _} ->
         broadcast_new_saisie()
         {:noreply , socket|>put_flash(:info , "saisie de temps enregistrer") }
        {:error,error} ->
          IO.inspect error
         {:noreply , socket
         |> clear_flash()
         |>put_flash(:error , error)}
      end
      # Traitement supplémentaire de vos données, comme enregistrement en base de données, etc.

  end



  defp broadcast_new_saisie() do

    Phoenix.PubSub.broadcast(PmLogin.PubSub, "fetch-new-saisie-list" , %{})

  end
  def render(assigns) do
    PmLoginWeb.SaisieTempsView.render("index.html" , assigns)
  end



end
