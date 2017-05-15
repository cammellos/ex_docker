use Mix.Config
config :ex_docker, :uri, System.get_env("DOCKER_HOST") || "http+unix://%2fvar%2frun%2fdocker.sock"
