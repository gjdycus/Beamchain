# Beamchain

A proof-of-concept blockchain implementation demonstrating the distributed-computing capabilities of Elixir/Erlang and the demand-management capabilities of GenStage.

## TODO

This implementation is far from finished and was thrown together to prove a concept. Therefore, it could benefit from a bit of refactoring. Besides that, here's what I would like to get done on it:

- [x] Basic reading/writing of data to the blockchain on a local network
- [x] Proof-of-work system
- [x] Enable cluster computing for proof of work
- [x] Allow nodes to gracefully leave the network while mining
- [x] Get rid of global processes across nodes
- [x] Consensus protocol for synchronizing blockchain within cluster
- [ ] Decouple the blockchain from the mining mechanism
- [ ] Allow nodes to gracefully enter the network and pick up in the middle of a proof-of-work problem
- [ ] Simplify the process of clustering nodes (there are libraries which do this)
- [ ] Basic P2P blockchain network & validating incoming blocks
- [ ] Dynamic proof-of-work difficulty based on (?)
- [ ] Enable grid computing for proof of work
- [ ] (Very large in scope) allow smartphones to participate in distributed computing

## Setup

1. Clone this repository
2. Within the directory, run `mix deps.get`

## Usage

#### Clustering nodes within a local network

To connect two or more Elixir nodes together within a local network, we must:

* Use the `--name 'name@local.ip'` flag to identify each node
* Use the same `--cookie 'value'` when starting each node
* Tell Mix to start the application with the `-S mix` flag

```
# node @ 10.1.10.145
> iex --name 'worker@10.1.10.145' --cookie monster -S mix

# node @ 10.1.10.213
> iex --name 'worker@10.1.10.213' --cookie monster -S mix
iex(worker@10.1.10.213)1> Beamchain.Node.connect(:"worker@10.1.10.145")

# node @ 10.1.10.198
> iex --name 'worker@10.1.10.198' --cookie monster -S mix
iex(worker@10.1.10.198)1> Beamchain.Node.connect(:"worker@10.1.10.145")

# node @ 10.1.10.254
> iex --name 'worker@10.1.10.254' --cookie monster -S mix
iex(worker@10.1.10.254)1> Beamchain.Node.connect(:"worker@10.1.10.145")
```

After this, all 4 nodes will be connected.

```
iex(worker@10.1.10.213)2> Node.list()
[:"worker@10.1.10.145", :"worker@10.1.10.198", :"worker@10.1.10.254"]
```

#### Viewing the local network's blockchain

To get the current state of the blockchain on any node, run `Beamchain.read_blocks()`:

```
iex(worker@10.1.10.213)3> Beamchain.read_blocks()
[%Beamchain.Block{data: "Genesis block",
  hash: "00000E6BD724E993F81C288688C738D2BC5CF74FF72A6145E29C91BCEAE14833",
  index: 0, nonce: 268731, previous_hash: "0", timestamp: 1508004991}]
```

#### Mining new blocks of data

When you want to add data to the blockchain, the cluster will recruit all connected nodes to help mine the new block. The mining mechanism uses Elixir's GenStage and a single "nonce" producer process to handle demand and ensure that:

* Each node only takes on as much work as it can handle.
* Slow nodes are not performance bottlenecks.
* The same work is not done twice.

```
iex(worker@10.1.10.213)4> Beamchain.generate_block("arbitrary data")
```

While the nodes are working together to find a solution, you'll be able to watch the output and see that the work is being distributed among nodes and not duplicated.

```bash
worker@10.1.10.213: "10550000 nonces processed"
worker@10.1.10.145: "10560000 nonces processed"
worker@10.1.10.254: "10570000 nonces processed"
worker@10.1.10.213: "10580000 nonces processed"
worker@10.1.10.254: "10590000 nonces processed"
worker@10.1.10.145: "10600000 nonces processed"
worker@10.1.10.198: "10610000 nonces processed"
worker@10.1.10.254: "10620000 nonces processed"
worker@10.1.10.198: "10630000 nonces processed"
worker@10.1.10.213: "10640000 nonces processed"
worker@10.1.10.145: "10650000 nonces processed"
worker@10.1.10.198: "10660000 nonces processed"
worker@10.1.10.198: "10670000 nonces processed"
worker@10.1.10.254: "10680000 nonces processed"
worker@10.1.10.213: "10690000 nonces processed"
worker@10.1.10.198: "10700000 nonces processed"
worker@10.1.10.145: "10710000 nonces processed"
worker@10.1.10.254: "10720000 nonces processed"
worker@10.1.10.213: "10730000 nonces processed"
worker@10.1.10.145: "10740000 nonces processed"
worker@10.1.10.198: "10750000 nonces processed"
worker@10.1.10.145: "10760000 nonces processed"
worker@10.1.10.213: "10770000 nonces processed"
worker@10.1.10.254: "10780000 nonces processed"
```

If you want to have some fun, you can even shut down one or more of the nodes and watch the mining output slow down.
