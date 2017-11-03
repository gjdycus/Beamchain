defmodule Blockchain.Server do
  use GenServer

  alias Blockchain.Block

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
    [previous_block | _tail] = blockchain
    spawn(Block, :generate, [data, previous_block])

    {:noreply, blockchain}
  end

  def handle_cast({:add_block, block}, blockchain) do
    {:noreply, [block | blockchain]}
  end
end
