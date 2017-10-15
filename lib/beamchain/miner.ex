defmodule Beamchain.Miner do
  alias Beamchain.{Block, Miner.NonceProcessor, Miner.NonceProducer}

  @difficulty 5

  def proof_of_work(%Block{} = block) do
    {:ok, nonce_producer} = NonceProducer.start_link
    NonceProcessor.start_link(block, self())

    receive do
      {:ok, block} ->
        Process.unlink(nonce_producer)
        Process.exit(nonce_producer, :kill)
        block
    end
  end

  def test_nonces(block, nonces) do
    string_to_match = String.duplicate("0", @difficulty)

    nonces
    |> Stream.map(&({&1, calculate_hash(%{block | nonce: &1})}))
    |> Enum.find(fn({_nonce, hash}) -> String.starts_with?(hash, string_to_match) end)
  end

  defp calculate_hash(%Block{index: index, timestamp: timestamp, data: data, previous_hash: previous_hash, nonce: nonce}) do
    str = to_string(index) <> to_string(timestamp) <> data <> previous_hash <> to_string(nonce)
    :crypto.hash(:sha256, str) |> Base.encode16()
  end
end
