defmodule Beamchain.Server do
  use GenServer

  alias Beamchain.Block

  def init(:ok) do
    {:ok, [genesis_block()]}
  end

  def handle_call({:read}, _from, blocks) do
    {:reply, blocks, blocks}
  end

  def handle_cast({:add, data}, blocks) do
    previous_block = List.first(blocks)
    index = previous_block.index + 1
    timestamp = :erlang.monotonic_time() |> to_string()
    previous_hash = previous_block.hash

    block = generate_block(index, timestamp, data, previous_hash)
    {:noreply, [block | blocks]}
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
