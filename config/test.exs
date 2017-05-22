use Mix.Config
config :ex_docker, :uri, System.get_env("DOCKER_HOST") || "unix:///var/run/docker.sock"
