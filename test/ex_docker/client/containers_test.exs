defmodule ExDocker.Client.ContainersTest do
  use ExUnit.Case

  test "#run a container" do
    {:ok,
      %{
        status_code: status_code,
        stderr: stderr,
        stdout: stdout
      }
    } = ExDocker.Client.Containers.run("cogniteev/echo", cmd: ["echo", "hello"])

    assert status_code == 0
    assert stderr == ""
    assert stdout == "hello\n"
  end

  test "#create a container" do
    {:ok, cid} = ExDocker.Client.Containers.create("cogniteev/echo")
    assert is_binary(cid) == true
  end
end
