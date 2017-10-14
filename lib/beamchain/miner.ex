defmodule Beamchain.Miner do
  alias Beamchain.Block

  @difficulty 5

  def mine(%Block{} = block) do
    string_to_match = String.duplicate("0", @difficulty)

    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(&({&1, calculate_hash(%{block | nonce: &1})}))
    |> Enum.find(fn({_nonce, hash}) -> String.starts_with?(hash, string_to_match) end)
  end

  defp calculate_hash(%Block{index: index, timestamp: timestamp, data: data, previous_hash: previous_hash, nonce: nonce}) do
    str = to_string(index) <> to_string(timestamp) <> data <> previous_hash <> to_string(nonce)
    :crypto.hash(:sha256, str) |> Base.encode16()
  end
end
