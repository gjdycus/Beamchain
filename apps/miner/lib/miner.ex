defmodule Miner do
  alias Miner.{NonceProcessor, NonceProducer}

  def proof_of_work(block) do
    {:ok, nonce_producer} = NonceProducer.start_link()

    {microseconds, block} = :timer.tc fn ->
      requester = self()
      :rpc.multicall(NonceProcessor, :start_link, [block, requester, nonce_producer])

      receive do
        {:ok, block} ->
          Process.unlink(nonce_producer)
          Process.exit(nonce_producer, :shutdown)
          block
      end
    end

    seconds = (microseconds / 1_000_000)
    hashes_per_second = block.nonce / seconds
    IO.puts "Valid nonce found in #{seconds} seconds at a rate of #{hashes_per_second} hashes per second."
    IO.puts "Generated block: #{inspect block}"

    block
  end
end
