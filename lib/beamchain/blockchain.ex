defmodule Beamchain.Blockchain do
  alias Beamchain.Block

  def init do
    [genesis_block()]
  end

  def add_block(blockchain, data) do
    previous_block = List.first(blockchain)
    index = previous_block.index + 1
    timestamp = System.system_time(:second)
    previous_hash = previous_block.hash

    block = Block.generate(index, timestamp, data, previous_hash)
    [block | blockchain]
  end

  defp genesis_block do
    Block.generate(0, 1508004991, "Genesis block", "0")
  end
end
