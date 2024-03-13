defmodule PmLoginWeb.CsvController do

  use PmLoginWeb, :controller

  def download(conn, _params) do
    csv_content = ["loic" , "kaka"]
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", ~s(attachment; filename="export.csv"))
    |> send_resp(200, csv_content)
  end

end
