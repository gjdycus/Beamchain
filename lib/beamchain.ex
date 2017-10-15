defmodule Beamchain do
  use Application

  defdelegate read_blocks(),    to: Beamchain.API
  defdelegate mine_block(data), to: Beamchain.API

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Beamchain.API, [{:global, Beamchain.Server}])
    ]

    opts = [strategy: :one_for_one, name: Beamchain.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
