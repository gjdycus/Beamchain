defmodule Blockchain.Block do
  defstruct [:index, :timestamp, :data, :previous_hash, :nonce, :hash]

  def generate(data, previous_block) do
    %__MODULE__{
      index: previous_block.index + 1,
      timestamp: System.system_time(:second),
      data: data,
      previous_hash: previous_block.hash
    } |> Miner.proof_of_work(&Blockchain.add_block/1)
  end

  def genesis_block do
    %__MODULE__{
      index: 0,
      timestamp: 1508004991,
      data: "Genesis block",
      previous_hash: "0",
      nonce: 9645352,
      hash: "000000ACE80A32E8D2794D2F1321994391356B8492B200946527D3153EA39ECA"
    }
  end
end
