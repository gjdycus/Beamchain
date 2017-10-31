defmodule Beamchain.Miner.NonceProcessor do
  use GenStage

  alias Beamchain.Miner

  def start_link(block, requester, producer) do
    GenStage.start_link(__MODULE__, {block, requester, producer}, [name: __MODULE__])
  end

  def init({block, requester, producer}) do
    opts = [subscribe_to: [{producer, [max_demand: 10000]}]]
    {:consumer, {block, requester}, opts}
  end

  def handle_events(events, _from, {block, requester}) do
    [next_nonce | _tail] = events
    if rem(next_nonce, 10000) === 0 do
      IO.inspect "#{next_nonce} nonces processed", label: Node.self()
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
