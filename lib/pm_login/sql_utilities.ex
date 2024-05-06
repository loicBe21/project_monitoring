defmodule PmLogin.SqlUtilities do

import Ecto.Query, warn: false
  alias PmLogin.Repo


  #module utiliser pour faciliter la relation bdd et backend en executant directement des requete sql sans passer par ecto



  #fonction qui cree une liste de map pour chaque ligne (rows) avec le cles donnes en parametre
  #dans columns
  #utile pour recuperer les resultat d'une requete sql



  defp build_result(columns, rows) do
    new_columns = Enum.map(columns, &String.to_atom/1)

    rows
    |> Enum.map(fn row ->
      Enum.zip(new_columns, row)
      |> Enum.into(%{})
    end)
  end




  #PmLogin.SqlUtilities.fetch_result
  def fetch_result(sql_query , params) do

    case Ecto.Adapters.SQL.query(Repo, sql_query, params) do
      {:ok, %Postgrex.Result{columns: columns, rows: rows}} ->
        # Construire une liste de maps où chaque map représente une ligne de résultats
        build_result(columns, rows)
        {:error, reason} ->
          IO.inspect reason
      end

  end





end
