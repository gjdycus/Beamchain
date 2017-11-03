defmodule Blockchain do
  defdelegate child_spec(opts),     to: Blockchain.API
  defdelegate read_blocks(),        to: Blockchain.API
  defdelegate set_blocks(blocks),   to: Blockchain.API
  defdelegate generate_block(data), to: Blockchain.API
  defdelegate add_block(block),     to: Blockchain.API
end
