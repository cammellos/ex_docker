defmodule ExDocker.Helpers.UrlHelper do

  def normalize_url("tcp://" <> rest), do: "http://" <> rest

  def normalize_url("unix://" <> rest), do: "http+unix://" <> URI.encode_www_form(rest)

  def normalize_url(anything), do: anything
end
