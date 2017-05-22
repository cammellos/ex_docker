defmodule ExDocker.Api.ImageTest do
  use ExUnit.Case
  import PathHelpers

  @host ExDocker.Helpers.ConfigHelper.api_url

  defp parse_create_image_response(response) do
    %{"stream" => st} = List.first(response)
    case st do
      "sha256:" <> iid -> iid
      "Successfully built " <> iid -> iid
    end
    |> String.trim
  end

  defp create_image do
    {:ok, response} = ExDocker.Api.Image.build(@host, %{t: "foo", q: 1}, fixture_path("docker_image.tar.gz"))
    {:ok, [iid: parse_create_image_response(response)]}
  end

  setup do
    create_image()
  end

  test "/images" do
    {:ok, body, code } = ExDocker.Api.Image.all(@host)
    assert is_list(body)
    assert code == 200
  end

  test "/images/id", context do
    { :ok, _body, code } = ExDocker.Api.Image.find(@host, context[:iid])
    assert code == 200
  end

  test "/images/id/history", context do
    { :ok, _body, code } = ExDocker.Api.Image.history(@host, context[:iid])
    assert code == 200
  end

  test "/images/foo delete", context do
    { :ok, _body, code } = ExDocker.Api.Image.delete(@host, context[:iid], %{force: 1})
    assert code == 200
  end

  test "/images/create" do
    { :ok, body } = ExDocker.Api.Image.create(@host, %{"fromImage" => "redis", "tag" => "alpine"})
    assert is_list(body)
  end

end
