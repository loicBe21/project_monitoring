defmodule PmLoginWeb.LiveComponent.TaskTimeDetailsComponent do
 use Phoenix.LiveComponent

 def render(assigns) do
  ~H"""

    <div id="task_time_details"}>
      <!-- Modal Background -->
      <div id="task_modal_container" class="modal-container" style={"visibility: #{ if @show_modal_details, do: "visible", else: "hidden" }; opacity: #{ if @show_modal_details, do: "1 !important", else: "0" };"}>
        <div class="modal-inner-container" >

          <div class="modal-card-task">
            <div class="modal-inner-card">

              <!-- Title -->
              <%= if @title != nil do %>
              <div class="modal-title">
                <%= @title %>
                <a href="#" class="x__close" style="position: relative; left: 0; margin-top: -5px" title="Fermer" phx-click="close_time_details_modal" ><i class="bi bi-x"></i></a>
              </div>
              <% end %>

              <!-- Body -->
              <%= if @body != nil do %>
              <div class="modal-body">
                <%= @body %>
              </div>
              <% end %>
              <table id="tb-auth" class="table-sortable" style="/*margin-top: 30px;*/ font-size: 13px" phx-hook="tableHover">  <!--  Fixed the header - Ravo -->
                  <tbody>
                    <tr>
                      <td>
                        Estimation originale
                      </td>
                      <td style="padding-right: 15.8vh;">
                      <%= @task_estimation_in_hours %>
                      </td>
                    </tr>
                  </tbody>
                </table>

              <div id="table-container" style="max-height: 75vh; overflow-y: scroll; width: 100%; margin-top: 20px;">  <!--  Fixed the header - Ravo -->
                <table id="tb-auth" class="table-sortable" style="/*margin-top: 30px;*/ font-size: 13px" phx-hook="tableHover">  <!--  Fixed the header - Ravo -->
                  <thead style="position: sticky; top: 0; z-index: 1; background-color: #f9f9f9;">  <!--  Fixed the header - Ravo -->
                    <tr style="font-weight: 900; text-transform: uppercase;">
                      <th>Nom</th>
                      <th>Temps Passé (Heures)</th>
                    </tr>
                  </thead>

                  <tbody>
                      <%= for t_detail <- @time_details do %>
                      <tr>
                        <td>
                          <%= t_detail.username %>
                        </td>
                        <td>
                          <%= t_detail.time_value %>
                        </td>
                      </tr>
                      <% end %>
                      <tr style="font-weight: 900; text-transform: uppercase;">
                        <td>Temps Total</td>
                        <td>
                          <%= @time_spent.time_spent %>
                        </td>
                      </tr>
                  </tbody>
                </table>

              </div> <!--  Fixed the header - Ravo -->

            </div>
          </div>

        </div>

      </div>
    </div>

  """
 end


end
