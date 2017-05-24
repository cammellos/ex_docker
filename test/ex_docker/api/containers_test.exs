defmodule ExDocker.Api.ContainerTest do
  use ExUnit.Case

  @host ExDocker.Helpers.ConfigHelper.api_url

  setup_all do
    {:ok, _body} = create_image()

    {:ok, %{"Id" => cid, "Warnings" => _warnings}, 201} = create_container()

    {:ok, %{"Id" => stop_cid, "Warnings" => _warnings}, 201} = create_container()

    {:ok, _body, 204} = start_container(cid)

    {:ok, _body, 204} = start_container(stop_cid)

    {:ok, _} = wait_for_containers([cid, stop_cid])

    on_exit("stop_containers", fn ->
        ExDocker.Api.Container.stop(@host, cid)
        ExDocker.Api.Container.stop(@host, stop_cid)
    end)

    {:ok, [cid: cid, stop_cid: stop_cid]}
  end

  test "/containers" do
    {:ok, body, _code }  = ExDocker.Api.Container.all(@host)
    assert is_list(body)
  end

  test "/containers with options" do
    {:ok, body, _code }  = ExDocker.Api.Container.all(@host, %{all: 1, limit: 1, size: 1})
    assert is_list(body)
  end

  test "/containers/create" do
    payload = %{
      "Image": "redis:alpine",
      "AttachStdout": true,
      "AttachStderr": true,
      "Hostname": "test-redis",
      "HostConfig": %{
        "Dns": ["8.8.8.8"],
        "PortBindings": %{ "22/tcp": [%{ "HostIp": "192.168.4.4" }],
          "6379/tcp": [%{ "HostIp": "192.168.4.4" }]}},
      "ExposedPorts": %{ "22/tcp": %{}, "6379/tcp": %{}}}

    {:ok, _body, code } = ExDocker.Api.Container.create(@host, payload)

    assert code == 201
  end

  test "/containers/id delete" do
    {:ok, %{"Id" => cid}, 201} = create_container()
    {:ok, _body, code }  = ExDocker.Api.Container.delete(@host, cid, %{force: 1})
    assert code == 204
  end

  test "/containers/id/exec", context do
    payload = %{ "AttachStdin": false, "AttachStdout": true, "AttachStderr": true, "Tty": false, "Cmd": [ "date"] }
    {:ok, _body, code }  = ExDocker.Api.Container.exec(@host, context[:cid], payload)
    assert code == 201
  end

  test "/exec/id/start", context do
    {:ok, %{"Id" => exec_cid}, 201 }  = exec_container(context[:cid])

    payload = %{"Detach": false, "Tty": false}
    {:ok, body}  = ExDocker.Api.Container.exec_start(@host, exec_cid, payload)

    assert is_list(body)
  end

  test "/containers/id", context do
    {:ok, _body, code }  = ExDocker.Api.Container.find(@host, context[:cid])
    assert is_number(code)
  end

  test "/containers/id/top", context do
    { :ok, body, _code } = ExDocker.Api.Container.top(@host, context[:cid])
    assert is_map(body)
  end

  test "/containers/id/changes", context do
    { :ok, _body, code } = ExDocker.Api.Container.changes(@host, context[:cid])
    assert code == 200
  end

  test "/containers/id/stop", context do
    {:ok, _body, code } = ExDocker.Api.Container.stop(@host, context[:stop_cid])
    assert code == 204
  end

  defp create_image do
    ExDocker.Api.Image.create(@host, %{"fromImage" => "redis", "tag" => "alpine"})
  end

  defp create_container do
    ExDocker.Api.Container.create(@host, %{"image" => "redis:alpine"})
  end

  defp start_container(cid) do
    ExDocker.Api.Container.start(@host, cid)
  end

  def exec_container(cid) do
    payload = %{ "AttachStdin": false, "AttachStdout": true, "AttachStderr": true, "Tty": false, "Cmd": [ "echo", "test"] }
    ExDocker.Api.Container.exec(@host, cid, payload)
  end

  defp wait_for_containers([]), do: {:ok, []}

  defp wait_for_containers(containers) do
    {:ok, body, _status} = ExDocker.Api.Container.all(@host)
    running_ids = body
      |> Enum.map(&(Map.get(&1,"Id")))
    wait_for_containers(containers -- running_ids)
    {:ok, body}
  end

end
