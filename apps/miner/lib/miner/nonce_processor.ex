defmodule Miner.NonceProcessor do
  use GenStage

  @difficulty 6

  def start_link(block, producer, callback) do
    GenStage.start_link(__MODULE__, {block, producer, callback}, [name: __MODULE__])
  end

  def init({block, producer, callback}) do
    opts = [subscribe_to: [{producer, [max_demand: 10000]}]]
    {:consumer, {block, callback}, opts}
  end

  def handle_events(events, _from, {block, callback}) do
    [next_nonce | _tail] = events
    if rem(next_nonce, 100000) === 0 do
      IO.inspect "#{next_nonce} nonces processed", label: Node.self()
    end

    case test_nonces(block, events) do
      {nonce, hash} ->
        block = %{block | nonce: nonce, hash: hash}
        callback.(block)
        {:stop, :normal, {block, callback}}
      nil -> {:noreply, [], {block, callback}}
    end
  end

  defp test_nonces(block, nonces) do
    string_to_match = String.duplicate("0", @difficulty)

    nonces
    |> Stream.map(&({&1, calculate_hash(%{block | nonce: &1})}))
    |> Enum.find(fn({_nonce, hash}) -> String.starts_with?(hash, string_to_match) end)
  end

  defp calculate_hash(%{index: index, timestamp: timestamp, data: data, previous_hash: previous_hash, nonce: nonce}) do
    str = to_string(index) <> to_string(timestamp) <> data <> previous_hash <> to_string(nonce)
    :crypto.hash(:sha256, str) |> Base.encode16()
  end
end
