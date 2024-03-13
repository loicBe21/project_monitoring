defmodule PmLoginWeb.Live.ConfirmLaunchLiveComponent do

  use Phoenix.LiveComponent


   @defaults %{
    left_button: "Cancel",
    left_button_action: nil,
    left_button_param: nil,

  }


  def render(assigns) do

    ~H"""
    <div id={"modal-#{@id}"}>
     <!-- Modal Background -->
      <div id="task_modal_container" class="modal-container" style={"visibility: #{ if @show_launch_modal, do: "visible", else: "hidden" }; opacity: #{ if @show_launch_modal, do: "1 !important", else: "0" };"}>
        <div class="modal-inner-container" phx-window-keydown="modal_close">
          <div class="modal-card-task">
            <div class="modal-inner-card">
              <!-- Title -->
              <%= if @title != nil do %>
              <div class="modal-title">
                <%= @title %>
                <a href="#" class="x__close" style="position: relative; left: 0; margin-top: -5px" title="Fermer" phx-click="left-button-click" phx-target={"#modal-#{@id}"}><i class="bi bi-x"></i></a>
              </div>
              <% end %>

              <!-- Body -->
              <%= if @body != nil do %>
              <div class="modal-body">
                <%= @body %>
              </div>
              <% end %>

              <!-- MY FORM -->
              <div class="modal-body">

                  <div class="column">
                    <p>haha</p>
                  </div>


              </div>


            </div>
          </div>
        </div>

      </div>
    </div>

    """


  end


  def mount(socket) do
    {:ok, socket}
  end

  def update(%{id: _id} = assigns, socket) do
    {:ok, assign(socket, Map.merge(@defaults, assigns))}
  end

  def handle_event(
        "left-button-click",
        _params,
        %{
          assigns: %{
            left_button_action: left_button_action,
            left_button_param: left_button_param
          }
        } = socket
      ) do
    send(
      self(),
      {__MODULE__, :button_clicked, %{action: left_button_action, param: left_button_param}}
    )

    {:noreply, socket}
  end



end
