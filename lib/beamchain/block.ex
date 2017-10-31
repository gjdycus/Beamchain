defmodule Beamchain.Block do
  alias Beamchain.Miner

  defstruct [:index, :timestamp, :data, :previous_hash, :nonce, :hash]

  def generate(data, previous_block) do
    %__MODULE__{
      index: previous_block.index + 1,
      timestamp: System.system_time(:second),
      data: data,
      previous_hash: previous_block.hash
    }
    |> Miner.proof_of_work()
    |> Beamchain.add_block()
  end

  def genesis_block do
    %__MODULE__{
      index: 0,
      timestamp: 1508004991,
      data: "Genesis block",
      previous_hash: "0",
      nonce: 268731,
      hash: "00000E6BD724E993F81C288688C738D2BC5CF74FF72A6145E29C91BCEAE14833"
    }
  end
end
