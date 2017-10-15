defmodule Beamchain.Miner.NonceProcessor do
  use GenStage

  alias Beamchain.{Miner, Miner.NonceProducer}

  def start_link(block, requester) do
    GenStage.start_link(__MODULE__, {block, requester}, [name: __MODULE__])
  end

  def init(state) do
    opts = [subscribe_to: [{{:global, NonceProducer}, [max_demand: 10000]}]]
    {:consumer, state, opts}
  end

  def handle_events(events, _from, {block, requester}) do
    [next_nonce | _tail] = events
    if rem(next_nonce, 10000) === 0 do
      IO.puts "#{next_nonce} nonces tested"
    end

    case Miner.test_nonces(block, events) do
      {nonce, hash} ->
        block = %{block | nonce: nonce, hash: hash}
        send requester, {:ok, block}
        {:stop, :normal, {block, requester}}
      nil -> {:noreply, [], {block, requester}}
    end
  end
end
