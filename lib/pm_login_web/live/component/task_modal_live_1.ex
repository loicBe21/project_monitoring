defmodule PmLoginWeb.LiveComponent.TaskModalLive1 do

use Phoenix.LiveComponent

def render(assigns) do
  ~H"""
   <div id={"modal-#{@id}"} phx-hook="newTask">
      <!-- Modal Background -->
      <div id="task_modal_container" class="modal-container" style={"visibility: #{ if @show_task_modal, do: "visible", else: "hidden" }; opacity: #{ if @show_task_modal, do: "1 !important", else: "0" };"}>
        <div class="modal-inner-container">
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
                <form phx-submit="save_task">
                  <input type="hidden" name="project_id" value={@pro_id}>
                  <input type="hidden" name="attributor_id" value={@curr_user_id}>
                  <div class="column">
                    <label class="zoom-out">Tâche</label>
                    <input type="text" name="title" id="title_i">
                   <label id="title_error" style="visibility: hidden;">Error</label>

                  </div>

                  <div class="column">
                    <label class="zoom-out">Description</label>
                    <div class="zoom-out">
                      <!--<textarea id="task_description" name="task[description]" value=""> </textarea>!-->
                      <textarea name="description" id="description"></textarea>
                      <label id="description_error" style="visibility: hidden;">Error</label>

                    </div>
                  </div>

                  <div class="column">
                    <label class="zoom-out">Durée estimée</label>
                    <input type="number" name="estimated_duration_hours" id="estimation_val" step="any">
                    <div class="zoom-out">

                    </div>
                  </div>

                  <div class="row">

                    <div class="column">
                      <label class="zoom-out">Date du début</label>
                      <input type="date" name="date_start" id="start_date">
                       <label id="start_date_error" style="color: red;font-size: 13px;font-weight: 600; visibility: hidden;">La date d'échéance ne peut pas être antérieure à la date de début</label>
                    </div>


                    <div class="column">
                      <label class="zoom-out">Date echeance</label>
                      <input type="date" name="deadline" id="due_date">
                       <label id="due_date_error" style="color: red;font-size: 13px;font-weight: 600; visibility: hidden;">La date d'échéance ne peut pas être antérieure à la date de début</label>
                    </div>

                  </div>

                  <div class="row">
                    <div class="column">
                      <label class="zoom-out">Assigner intervenant</label>
                        <select id="contributorSelect" name="contribs[]" multiple placeholder="Selectionez des intervenant" autocomplete="off">
                        <%= if @is_admin or @is_contributor do %>
                            <%= if @is_admin do %>

                                <%= for {username, id} <- @list_for_admin do %>
                                    <option value={id} ><%= username %></option>
                                <% end %>
                            <% else %>
                                <%= for {username, id} <- @list_for_attributeur do %>
                                      <option value={id}><%= username %></option>
                                <% end %>
                            <% end %>
                        <% end %>
                        </select>
                      <div class="zoom-out">

                      </div>
                    </div>
                  </div>

                  <div class="row">
                      <div class="column">
                          <input type="radio" value="true" name="is_major">
                          <label class="zoom-out btn btn-danger" style="font-size: 80%;">TÂCHE MAJEURE</label>
                          <input type="radio" value="false" name="is_major" checked>
                          <label class="zoom-out btn btn-outline-secondary" style="font-size: 90%;">Tâche mineure</label>
                      </div>
                  </div>

                  <div class="row">
                    <div class="column">
                      <label class="zoom-out">Sans contrôle</label>
                      <input type="checkbox" value="true" name="without_control">
                    </div>
                  </div>

                  <!-- Buttons -->
                  <div class="modal-buttons">
                      <!-- Left Button -->
                      <a
                        href="#" class="button button-outline"
                        type="button"
                        phx-click="left-button-click"
                        phx-target={"#modal-#{@id}"}
                        style="margin-bottom: 1.5rem;
                      ">
                        <div>
                         <p>Annuler</p>
                        </div>
                      </a>

                      <div class="right-button">
                        <input type="submit" value="Créer tâche">
                      </div>

                  </div>

                </form>






              </div>


            </div>
          </div>
        </div>
      </div>
    </div>
  """
end

end
