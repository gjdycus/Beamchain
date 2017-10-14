defmodule Beamchain.Blockchain do
  alias Beamchain.Block

  def init do
    [genesis_block()]
  end

  def add_block(blockchain, data) do
    previous_block = List.first(blockchain)
    index = previous_block.index + 1
    timestamp = :erlang.monotonic_time() |> to_string()
    previous_hash = previous_block.hash

    block = generate_block(index, timestamp, data, previous_hash)
    [block | blockchain]
  end

  defp genesis_block do
    generate_block(0, "-576460034007939099", "Genesis block", "0")
  end

  defp generate_block(index, timestamp, data, previous_hash) do
    block = %Block{
      index: index,
      timestamp: timestamp,
      data: data,
      previous_hash: previous_hash
    }
    %{ block | hash: generate_hash(block) }
  end

  defp generate_hash(%Block{index: index, timestamp: timestamp, data: data, previous_hash: previous_hash}) do
    str = to_string(index) <> timestamp <> data <> previous_hash
    :crypto.hash(:sha256, str) |> Base.encode16()
  end
end
