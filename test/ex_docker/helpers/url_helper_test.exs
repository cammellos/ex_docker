defmodule ExDocker.Helpers.UrlHelperTest do
  use ExUnit.Case

  test "normalize_url when using a tcp format" do
    actual = ExDocker.Helpers.UrlHelper.normalize_url("tcp://127.0.0.1")
    expected = "http://127.0.0.1"
    assert actual == expected
  end

  test "normalize_url when using a unix socket format" do
    actual = ExDocker.Helpers.UrlHelper.normalize_url("unix:///var/run/docker.sock")
    expected = "http+unix://%2Fvar%2Frun%2Fdocker.sock"
    assert actual == expected
  end

  test "normalize_url when using an http url" do
    actual = ExDocker.Helpers.UrlHelper.normalize_url("http://127.0.0.1")
    expected = "http://127.0.0.1"
    assert actual == expected
  end
end
