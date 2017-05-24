defmodule ExDocker.Client.Containers do

  @host ExDocker.Helpers.ConfigHelper.api_url

  def run(image, opts \\ []) do
    {:ok, cid} = create(image, opts)

    ExDocker.Api.Container.start(@host, cid)

    {:ok, %{"StatusCode" => status_code}, 200} = ExDocker.Api.Container.wait(@host, cid)

    response = ExDocker.Api.Logs.fetch_logs(@host, cid, [tail: "all"])
    |> Map.put(:status_code, status_code)

    if status_code == 0 do
      {:ok, response}
    else
      {:err, response}
    end
  end

  def create(image, opts \\ []) do
    case ExDocker.Api.Container.create(@host, Enum.into(opts, %{"image" => image})) do
      {:ok, %{"Id" => cid}, 201} -> {:ok, cid}
      {:ok, _, 404} ->
        {:ok, _response} = ExDocker.Api.Image.create(@host, %{"fromImage" => image})
        {:ok, %{"Id" => cid}, 201} = ExDocker.Api.Container.create(@host, %{"image" => image, "cmd" => ["echo", "hello"]})
        {:ok, cid}
    end
  end

  def get do
  end

  def list do
  end

  def prune do
  end
end
