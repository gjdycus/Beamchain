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
    %Block{
      index: 0,
      timestamp: 1508004991,
      data: "Genesis block",
      previous_hash: "0",
      nonce: 268731,
      hash: "00000E6BD724E993F81C288688C738D2BC5CF74FF72A6145E29C91BCEAE14833"
    }
  end
end
