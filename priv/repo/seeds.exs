# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PmLogin.Repo.insert!(%PmLogin.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias PmLogin.Repo

alias Ecto.UUID
import Ecto.Query, warn: false

alias PmLogin.Services
alias PmLogin.Services.{ClientsRequest, Type, RequestType, Rights_clients, Tool, ToolGroup, Priority}
alias PmLogin.Login.ContributorFunction



############# Fill the database with the data of the type table ##############
# types = Repo.all(from t in Type)
# if length(types) < 8 or Enum.empty?(types) do
#   type =
#     [
#       %Type{
#         id: 1,
#         type: "moved"
#       },

#       %Type{
#         id: 2,
#         type: "archived"
#       },

#       %Type{
#         id: 3,
#         type: "deleted"
#       },

#       %Type{
#         id: 4,
#         type: "achieved"
#       },

#       %Type{
#         id: 5,
#         type: "created"
#       },

#       %Type{
#         id: 6,
#         type: "assigned"
#       },

#       %Type{
#         id: 7,
#         type: "updated"
#       },

#       %Type{
#         id: 8,
#         type: "requested"
#       }
#     ]

#   for t <- type do
#     Repo.insert!(t)
#   end
# end


############# Generate UUID for client request ##############
# ids = Repo.all(
#             from cr in ClientsRequest,
#             where: is_nil(cr.uuid) or cr.uuid == "",
#             select: cr.id
#           )


##################
# Generate UUIDs #
##################
# uuids =
#   for _ <- 0..length(ids) - 1 do
#     uuid = UUID.generate() |> String.split("-")

#     Enum.join([Enum.at(uuid, 0), Enum.at(uuid, 1)])
#   end


##########################################
# Set UUID for request who don't have it #
##########################################
# for id <- ids, uuid <- uuids do
#   client_request = Services.get_clients_request!(id)

#   Services.update_clients_request(client_request, %{"uuid" => "REQ#{uuid}"})
# end

# request_types = [
#   %{name: "Demande de correction de bug", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#   %{name: "Demande de réponse", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#   %{name: "Demande d’information", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#   %{name: "Demande de devis", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#   %{name: "Demande d’intervention", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#   %{name: "Demande d’une nouvelle fonctionnalité", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now}
# ]

default_contributor_functions = [
  %{id: 0, title: "Fonction indéfinie", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
  %{id: 1,  title: "Data Analyst", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
  %{id: 2, title: "Développeur", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now}
]

# Repo.insert_all(RequestType, request_types)

#Repo.insert_all(ContributorFunction, default_contributor_functions)


#
#
#
#default_tool_groups_functions = [
#  %{id: 0, name: "Développement", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now, company_id: 1},
#  %{id: 1,  name: "Comptabilité", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now, company_id: 1}
#]
#Repo.insert_all(ToolGroup, default_tool_groups_functions)

#default_tools_functions = [
#  %{id: 0, name: "Dev1", tool_group_id: 0, inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#  %{id: 1,  name: "Cpt1", tool_group_id: 1, inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now}
#]
#Repo.insert_all(Tool, default_tools_functions)

#default_rights_clients = [
#  %{id: 1, name: "Administrateur" ,inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#  %{id: 2, name: "Demandeur", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#  %{id: 3, name: "Utilisateur", inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now}
#]
#Repo.insert_all(Rights_clients, default_rights_clients)

#default_priorities = [
#   %{id: 1, title: "Faible" ,inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#   %{id: 2, title: "Moyenne" ,inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#   %{id: 3, title: "Importante" ,inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#   %{id: 4, title: "Urgente" ,inserted_at: NaiveDateTime.local_now, updated_at: NaiveDateTime.local_now},
#]
#Repo.insert_all(Priority, default_priorities)
