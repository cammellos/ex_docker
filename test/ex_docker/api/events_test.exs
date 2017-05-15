defmodule ExDocker.Api.EventsTest do
  use ExUnit.Case

  import Mock

  @host "#{Application.get_env(:ex_docker, :uri)}"

  test "/events" do
    with_mock ExDocker.Api.Events, [all: fn(_host) -> {:ok, []} end] do
      {:ok, _body }  = ExDocker.Api.Events.all(@host)
      assert called ExDocker.Api.Events.all(@host)
    end
  end

  test "/events with options" do
    with_mock ExDocker.Api.Events, [all: fn(_host, %{since: 1374067924, until: 1425227650}) -> {:ok, []} end] do
      ExDocker.Api.Events.all(@host, %{since: 1374067924, until: 1425227650})
      assert called ExDocker.Api.Events.all(@host, %{since: 1374067924, until: 1425227650})
    end
  end

end
