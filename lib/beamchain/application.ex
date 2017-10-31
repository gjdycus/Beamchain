defmodule Beamchain.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Beamchain.API, [Beamchain.Server])
    ]

    opts = [strategy: :one_for_one, name: Beamchain.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
