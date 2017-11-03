defmodule Miner do
  alias Miner.{NonceProcessor, NonceProducer}

  defdelegate child_spec(opts),     to: Miner.API
  defdelegate set_problem(problem), to: Miner.API
  defdelegate current_problem(),    to: Miner.API
  defdelegate clear_problem(),      to: Miner.API

  def proof_of_work(block, callback) do
    {:ok, nonce_producer} = NonceProducer.start_link()

    start_time = System.system_time(:millisecond)

    callback = fn mined_block ->
      end_time = System.system_time(:millisecond)

      :rpc.multicall(__MODULE__, :clear_problem, [])

      Process.unlink(nonce_producer)
      Process.exit(nonce_producer, :shutdown)

      callback.(mined_block)

      seconds = ((end_time - start_time) / 1000)
      hashes_per_second = mined_block.nonce / seconds
      IO.puts "Valid nonce found in #{seconds} seconds at a rate of #{hashes_per_second} hashes per second."
      IO.puts "Generated block: #{inspect mined_block}"
    end

    :rpc.multicall(__MODULE__, :set_problem, [{block, nonce_producer, callback}])
    :rpc.multicall(__MODULE__, :start_mining, [])
  end

  def start_mining do
    case current_problem() do
      {block, producer, callback} -> NonceProcessor.start_link(block, producer, callback)
      {:empty} -> nil
    end
  end
end
