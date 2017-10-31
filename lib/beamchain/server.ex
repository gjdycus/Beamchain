defmodule Beamchain.Server do
  use GenServer

  alias Beamchain.Block

  def init(:ok) do
    {:ok, [Block.genesis_block()]}
  end

  def handle_call({:read_blocks}, _from, blockchain) do
    {:reply, blockchain, blockchain}
  end

  def handle_cast({:set_blocks, blockchain}, _blockchain) do
    {:noreply, blockchain}
  end

  def handle_cast({:generate_block, data}, blockchain) do
    spawn_link fn ->
      [previous_block | _tail] = blockchain
      Block.generate(data, previous_block)
    end

    {:noreply, blockchain}
  end

  def handle_cast({:add_block, block}, blockchain) do
    {:noreply, [block | blockchain]}
  end
end
