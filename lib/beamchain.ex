defmodule Beamchain do
  defdelegate start(),              to: Beamchain.API
  defdelegate read_blocks(pid),     to: Beamchain.API
  defdelegate add_block(pid, data), to: Beamchain.API
end
