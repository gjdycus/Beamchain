defmodule Beamchain.Block do
  alias Beamchain.Miner

  defstruct [:index, :timestamp, :data, :previous_hash, :nonce, :hash]

  def generate(index, timestamp, data, previous_hash) do
    block = %__MODULE__{
      index: index,
      timestamp: timestamp,
      data: data,
      previous_hash: previous_hash
    }
    {nonce, hash} = Miner.mine(block)
    %{ block | nonce: nonce, hash: hash }
  end
end
