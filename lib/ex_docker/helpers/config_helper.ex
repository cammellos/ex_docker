defmodule ExDocker.Helpers.ConfigHelper do

  def api_url() do
    Application.get_env(:ex_docker, :uri)
    |> ExDocker.Helpers.UrlHelper.normalize_url
  end
end
