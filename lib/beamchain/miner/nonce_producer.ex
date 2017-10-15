defmodule Beamchain.Miner.NonceProducer do
  use GenStage

  def start_link do
    case GenStage.start_link(__MODULE__, :ok, [name: {:global, __MODULE__}]) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} ->
        Process.link(pid)
        {:ok, pid}
    end
  end

  def init(:ok) do
    {:producer, 0}
  end

  def handle_demand(demand, counter) when demand > 0 do
    events = Enum.to_list(counter..(counter + demand - 1))
    {:noreply, events, counter + demand}
  end
end
