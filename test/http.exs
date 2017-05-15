defmodule ExDocker.HTTPTest do
  use ExUnit.Case

  test "get" do
    url = "http://httpbin.org/get"
    {:ok, response}  = ExDocker.Api.HTTP.get(url)
    decoded = Poison.decode!(response.body)
    assert response.status_code == 200
  end

  test "get with query params" do
    url = "http://httpbin.org/get"
    {:ok, response}  = ExDocker.Api.HTTP.get(url, %{foo: 1})
    decoded = Poison.decode!(response.body)
    assert decoded["args"] == %{"foo" => "1"}
  end

  test "post without payload" do
    url = "http://httpbin.org/post"
    {:ok, response}  = ExDocker.Api.HTTP.post(url)
    decoded = Poison.decode!(response.body)
    assert response.status_code == 200
    assert decoded["args"] == %{}
    assert decoded["data"] == []
  end

  test "post with payload" do
    url = "http://httpbin.org/post"
    {:ok, response}  = ExDocker.Api.HTTP.post(url, %{baz: 1})
    decoded = Poison.decode!(response.body)
    assert response.status_code == 200
    assert decoded["args"] == %{}
    assert decoded["json"] == %{"baz" => 1}
  end

  test "delete with options" do
    url = "http://httpbin.org/delete"
    {:ok, response}  = ExDocker.Api.HTTP.delete(url, %{foo: 1})
    decoded = Poison.decode!(response.body)
    assert response.status_code == 200
    assert decoded["args"] == %{"foo" => "1"}
    assert decoded["json"] == nil
  end

  test "delete without options" do
    url = "http://httpbin.org/delete"
    {:ok, response}  = ExDocker.Api.HTTP.delete(url)
    decoded = Poison.decode!(response.body)
    assert response.status_code == 200
    assert decoded["args"] == %{}
  end

end
