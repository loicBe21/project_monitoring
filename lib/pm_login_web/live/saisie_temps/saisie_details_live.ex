defmodule PmLoginWeb.SaisieTemps.SaisieDetailsLive do

  use Phoenix.LiveView
   alias PmLogin.Services
   alias PmLogin.Utilities
   alias PmLogin.Pointages
   alias PmLogin.Login

  def mount(_params, %{"curr_user_id" => curr_user_id , "user_id" => user_id , "date" => date , "start_date" => start_date , "end_date" => end_date , "status" => status , "right" => right }, socket) do

    date_saisie  = Utilities.parse_date_string(date)
    saisie_data = Pointages.get_details_saisie_by_date_and_user(date_saisie ,String.to_integer(user_id))
    current_user =  Login.get_user!(curr_user_id)
    IO.inspect saisie_data
    layout =
      case current_user.right_id do
        1 -> {PmLoginWeb.LayoutView, "admin_layout_live.html"}
        2 -> {PmLoginWeb.LayoutView, "attributor_layout_live.html"}
        3 -> {PmLoginWeb.LayoutView, "contributor_layout_live.html"}
        _ -> {}
      end
    socket =
      socket
        |>assign(
          current_user: current_user ,
          curr_user_id:  curr_user_id ,
          show_notif: false,
          notifs: Services.list_my_notifications_with_limit(curr_user_id, 4),
          date: date_saisie,
          user_id: user_id,
          saisie_data: saisie_data

        )
      {:ok , socket , layout: layout}

  end

  def render(assigns) do
    PmLoginWeb.SaisieTempsView.render("saisie_details.html" , assigns)
  end

end
