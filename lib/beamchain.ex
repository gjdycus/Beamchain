defmodule Beamchain do
  defdelegate read_blocks(),        to: Beamchain.API
  defdelegate set_blocks(blocks),   to: Beamchain.API
  defdelegate generate_block(data), to: Beamchain.API
  defdelegate add_block(block),     to: Beamchain.API
end
