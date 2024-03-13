defmodule PmLoginWeb.SaisieTemps.AdminIndexLive do


  use Phoenix.LiveView
  alias PmLogin.Pointages
  alias PmLogin.Services
  alias PmLogin.Login
  alias PmLogin.Utilities



  def mount(_params , %{"curr_user_id" => curr_user_id} , socket) do
    Phoenix.PubSub.subscribe(PmLogin.PubSub , "fetch-new-saisie-list")
    today = Date.utc_today()
    saisies_details = Pointages.get_users_times_by_date(today)
    right_list = Login.list_rights
    right_ids_selected = [1 ,3 ,2]
    default_key_word =""
    sorted_by_h_work = false
    sorted_by_h_abs = false
    real_list = Enum.filter(saisies_details , fn(entry) ->
      Enum.member?(right_ids_selected , entry.right_id)
    end)
    socket =
      socket
        |>assign(
          sorted_by_h_work: sorted_by_h_work,
          sorted_by_h_abs: sorted_by_h_abs,
          today: today,
          fixed_liste: saisies_details,
          curr_user_id:  curr_user_id ,
          notifs: Services.list_my_notifications_with_limit(curr_user_id, 4),
          saisies_details: real_list,
          right_list: right_list ,
          right_ids_selected: right_ids_selected,
          default_key_word: default_key_word,
          show_notif: false
        )
    {:ok , socket , layout: {PmLoginWeb.LayoutView, "admin_layout_live.html"}}
  end



  def handle_event("filter_change" , %{ "status" => selected_right_ids ,"search-a" => key_word }  , socket) do
    selected_right_ids = selected_right_ids |> Enum.map(&String.to_integer/1)
    current_list = socket.assigns.fixed_liste
    key_word_lower = String.downcase(key_word)
    filter_function =
    if String.trim(key_word) == "" do
      fn entry ->
        Enum.member?(selected_right_ids, entry.right_id)
      end
    else
      fn entry ->
        username_lower = String.downcase(entry.username)
        Enum.member?(selected_right_ids, entry.right_id) && String.contains?(username_lower, key_word_lower)
      end
    end
    IO.inspect key_word
    {:noreply , socket
      |>assign(saisies_details: Enum.filter(current_list, filter_function) ,
     right_ids_selected: selected_right_ids ,default_key_word: key_word )}
  end

  def handle_event("do_filtre",params, socket) do
   IO.inspect params
   date_str = params["date_filter"]
   #saisies_details = Pointages.get_users_times_by_date(params["date_filter"])
   parsed_date = Utilities.parse_date_string(date_str)

   IO.inspect parsed_date
   {:noreply , socket |> assign(saisies_details: Pointages.get_users_times_by_date(parsed_date) , today: parsed_date)}
  end


  def handle_event("sort_by_h_work", _params, socket) do

    case socket.assigns.sorted_by_h_work do
       true ->{:noreply ,  socket |>assign(
        saisies_details: Enum.sort_by(socket.assigns.saisies_details, &(&1.h_work) , :desc),
        sorted_by_h_work: false
        )}
        _ ->{:noreply ,  socket |>assign(
        saisies_details: Enum.sort_by(socket.assigns.saisies_details, &(&1.h_work) ),
        sorted_by_h_work: true
        )}

    end
  end

  def handle_event("sort_by_h_abs", _params, socket) do
    case socket.assigns.sorted_by_h_abs do
       true ->{:noreply ,  socket |>assign(
        saisies_details: Enum.sort_by(socket.assigns.saisies_details, &(&1.h_dynamique_abs) , :desc),
        sorted_by_h_abs: false
        )}
        _ ->{:noreply ,  socket |>assign(
        saisies_details: Enum.sort_by(socket.assigns.saisies_details, &(&1.h_dynamique_abs) ),
        sorted_by_h_abs: true
        )}

    end
  end
  def handle_info(%{event: "fetch-new-saisie-list"}, socket) do
      {:noreply, assign(socket, saisies_details:  Pointages.get_users_times_by_date(socket.assigns.today))}
  end



  def handle_event("navigate_to_details", %{"user_id" => user_id, "date" => date}, socket) do
    {:noreply, socket |> redirect(to: Routes.saisie_temps_details_path(socket, :details, user_id: user_id, date: date))}
  end



  def handle_event("validate-saisie" ,  params , socket) do
    IO.inspect params
    IO.inspect Pointages.validate_saisie(params)
    case Pointages.save_saisie_validee(params) do
      {:ok ,_}
        ->  {:noreply , socket
         |>assign(saisies_details: Pointages.get_users_times_by_date(socket.assigns.today) )
         |> clear_flash()
         |>put_flash(:info , "saisie validees avec succees")}
      {:error , message}
        ->  {:noreply , socket
         |> clear_flash()
         |>put_flash(:error , message)}
    end

  end




  def render(assigns) do
    PmLoginWeb.SaisieTempsView.render("admin_index.html" , assigns)
  end

end
