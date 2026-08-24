+++
title = "Text publishing technologies for Ethereum dapps"
description = 'Building something like a Reddit or Twitter dapp (distributed app) on Ethereum is certainly an attractive idea, but the obvious question is "where do the messages get stored?" If an autonomous Git or Wikipedia were built on Ethereum the storage requirements would be even greater.'
date = 2016-01-18
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

*Originally published on jonathanpatrick.me. [Retrieved](https://web.archive.org/web/20190820120150/http://jonathanpatrick.me/blog/ethereum-text-publishing) from the Wayback Machine.*

<p>Building something like a Reddit or Twitter dapp (distributed app) on <a target="_blank" href="https://ethereum.org/">Ethereum</a> is certainly an attractive idea, but the obvious question is "where do the messages get stored?" If an autonomous Git or Wikipedia were built on Ethereum the storage requirements would be even greater.</p>
<p>As outlined in a <a href="/blog/ethereum-compressed-text/">previous post</a>, compressing text before storing it is a very good idea, especially if the storage medium is expensive.</p>
<p>There are many different decentralized technologies that can be used to store and share these <a target="_blank" href="https://en.wikipedia.org/wiki/Object_storage">blobs</a>. A key factor is <b>permanence</b>. I have analysed the properties of some of these technologies, ordered from most to least permanent:</p>
<ol><li>
<h2>Contract State</h2>
<p>When a <a target="_blank" href="https://en.wikipedia.org/wiki/Smart_contract">smart contract</a> executes a transaction it can modify its <a target="_blank" href="https://en.wikipedia.org/wiki/State_(computer_science)#Program_state">state</a>. The latest version of every contract's state is always available.</p>
<ul><li>
<h3>Cost</h3>
<p>Most expensive. Each non-zero byte in transaction payload costs 68 <a target="_blank" href="https://web.archive.org/web/20190820120150/https://ethereum.gitbooks.io/frontier-guide/content/costs.html">gas</a>. That's 2,176 gas for 32 bytes. The smart contract must then store the blob in its state. Using a new 32-byte state slot costs 20,000 gas. Overwriting an existing slot costs 5,000. Zeroing an existing slot gives a refund of 15,000. There is an <a target="_blank" href="https://github.com/ethereum/EIPs/issues/35">on-going discussion</a> about charging rent for state storage.</p>
<p>0.050589 USD / kB at time of writing. This would be expected to go down in the long term as Ethereum becomes more efficient.</p>
<p>It should be noted that if an external storage system is used, an identifier would probably need to be stored in contract state anyway. This should be taken into account when comparing costs.
</p></li>
<li>
<h3>Access to blob contents from a contract</h3>
<p>A contract can potentially read or write a blob stored in state, although reading may not be useful if the blob is compressed or encrypted. Autonomous bots could be written to respond to and/or create posts.
</p></li>
<li>
<h3>Max size</h3>
<p>4kB with current block gas limit, but this will increase in future.
</p></li>
<li>
<h3>Longevity</h3>
<p>Forever.
</p></li>
<li>
<h3>Propagation time</h3>
<p>Instantaneous. Blobs can be read from the state of the "pending" block if not yet mined.
</p></li>
<li>
<h3><a target="_blank" href="https://en.wikipedia.org/wiki/Data_redundancy">Redundancy</a></h3>
<p>Every full node in the network (on the correct shard), including those that are <a target="_blank" href="https://blog.ethereum.org/2015/06/26/state-tree-pruning">pruning</a>, will maintain a copy of the blob.
</p></li>
<li>
<h3><a target="_blank" href="https://en.wikipedia.org/wiki/Shard_%28database_architecture%29">Sharding</a></h3>
<p>Once Ethereum <a target="_blank" href="https://github.com/ethereum/EIPs/issues/53">becomes a sharding blockchain</a> it will be possible for contracts to be on separate shards, so only nodes syncing a contract's shard would be storing the blobs for that contract.
</p></li>
<li>
<h3>Full node read performance</h3>
<p>A full node (with the correct shard) has the whole contract state (even if it is pruning) so read is instantaneous.
</p></li>
<li>
<h3><a target="_blank" href="https://www.youtube.com/watch?v=KoEqh99U5QI">Light client</a> read performance</h3>
<p>Light clients will be able to read contract state from full nodes and each other. The performance characteristics of this looks very promising.
</p></li>
<li>
<h3>Technology maturity</h3>
<p>Operational. No sharding yet.
</p></li>
<li>
<h3>Use cases</h3>
<ul><li>Very small blobs, e.g. single line text fields.</li>
<li>Blobs that you consider to be of very high importance and for which you are prepared to pay a premium to archive for eternity.</li>
</ul></li>
</ul></li>
<li>
<h2><a target="_blank" href="https://docs.soliditylang.org/en/latest/contracts.html#events">Transaction Log</a></h2>
<p>When a smart contract executes a transaction it can emit events to the transaction log. For example, a dapp user interface could update the display when an event occurs. These transaction logs can also be used for storing blobs of data. Storing in contract state the number of the block that the log was written in is a good idea because this can make it much easier to find the log. This will become even more important with light clients and sharding nodes. Typically the block number would be stored anyway to timestamp the message.</p>
<ul><li>
<h3>Cost</h3>
<p>Expensive. Each non-zero byte of data in transaction payload costs 68 gas. Writing a blob to a log is 8 gas per byte. Typically a log would be being written anyway and the blob can just piggyback on that.</p>
<p>0.005548 USD / kB at time of writing. This would be expected to go down in the long term as Ethereum becomes more efficient.</p>
<p>A typical 195 byte comment compresses to 117 bytes with <a target="_blank" href="https://en.wikipedia.org/wiki/Brotli">Brotli</a>. This currently costs 0.000649116 USD.</p>
<p>In theory the cost could be reduced by only storing the blob in the transaction payload and not in the log, but this has a number of disadvantages:</p>
<ul><li>Every transaction in the block needs to be checked that it has been sent to the correct address and then have its payload hashed to check if it the the correct transaction. For recent transactions there would be ambiguity over which block the transaction would be in, so multiple blocks would need to be checked.</li>
<li>This technique may not work well or at all for light clients or blocks that have been pruned.</li>
<li>Unique blob searching code would would have to be written for blobs that are relayed or generated by other contracts.</li>
</ul></li>
<li>
<h3>Access to blob contents from a contract</h3>
<p>A contract can write a blob. It is not possible for a contract to read from the transaction log without an <a target="_blank" href="https://blog.ethereum.org/2014/07/22/ethereum-and-oracles">oracle</a>.
</p></li>
<li>
<h3>Max size</h3>
<p>40kB with current block gas limit, but this will increase in future.
</p></li>
<li>
<h3>Longevity</h3>
<p>Forever, although really old blobs may only be stored in archival nodes which may charge for access.
</p></li>
<li>
<h3>Propagation time</h3>
<p>Immediate. <a target="_blank" href="https://web.archive.org/web/20190820120150/https://ethereum.github.io/go-ethereum/">Geth</a> currently requires one confirmation before the log can be read, although it is possible to write code to extract a blob from transaction payload as described in the cost section above.</p>
<p>I am an advocate of being able to <a target="_blank" href="https://web.archive.org/web/20190820120150/https://github.com/ethereum/wiki/wiki/JavaScript-API#contract-events">read</a> zero-confirmation log events in Geth.
</p></li>
<li>
<h3>Redundancy</h3>
<p>Transaction logs are stored by every full node, although at some point it will be possible for full nodes to be pruning. They will not record older transactions, blocks, and logs. This means there will be less redundancy for older blobs. Very old blobs might only be stored in archival nodes that might charge for access.
</p></li>
<li>
<h3>Sharding</h3>
<p>Currently all nodes store everything. This means to synchronize with "light" contracts you also need to synchronize with "heavy" contracts such as ones storing blobs in transaction logs that you may not have any use for. This is undesirable. Once Ethereum becomes a sharding blockchain it will be possible for a contract to be on its own shard and nodes only have to synchronize with heavy shards if they want to.</p>
<p>Potentially each language could be on its own shard. Non-light client users could sync the shards of the languages they understand.
</p></li>
<li>
<h3>Full node read performance</h3>
<p>Instantaneous if the node has not pruned the block with the log. Otherwise, revert to light client behaviour.
</p></li>
<li>
<h3>Light client read performance</h3>
<p>Light clients will be able to read contract state from full nodes and other light clients. The performance characteristics of this looks very promising. Older blobs will have worse retrieval performance as fewer nodes will have the blob due to pruning.
</p></li>
<li>
<h3>Technology maturity</h3>
<p>Operational. No sharding yet.</p>
<p>Currently each blob stored in a log has to be stored twice on each node. Once in the transaction payload, and once in the log. Ideally Ethereum would have some sort of blob store built-in so that blobs could be attached to transactions and then simply referred to by an identifier. These blobs would also be able to be read and written by contracts.
</p></li>
<li>
<h3>Use cases</h3>
<p>Potentially this could be used for storing compressed Reddit messages. They would be archived in the "Reddit" shard for eternity. Anyone syncing this shard would be storing everyone's messages, although with pruning some nodes would be only storing more recent messages. Light client users would only get the messages they are interested in.</p>
<p>Of course, any links to external resources, such as Swarm or IPFS blobs, would not be guaranteed to be archived.
</p></li>
</ul></li>
<li>
<h2><a target="_blank" href="https://www.youtube.com/watch?v=VOC45AgZG5Q">Swarm</a></h2>
<p>This is the decentralized Dropbox that has been <a target="_blank" href="https://web.archive.org/web/20190820120150/https://github.com/ethereum/wiki/wiki/White-Paper#decentralized-file-storage">planned</a> since the inception of Ethereum.</p>
<ul><li>
<h3>Cost</h3>
<p>Currently unknown, but it will be an ongoing free-market fee.
</p></li>
<li>
<h3>Access to blob contents from a contract</h3>
<p>Only with an oracle.
</p></li>
<li>
<h3>Max size</h3>
<p>As much as you pay for.
</p></li>
<li>
<h3>Propagation time</h3>
<p>Immediate.
</p></li>
<li>
<h3>Longevity</h3>
<p>As much as you pay for.
</p></li>
<li>
<h3>Redundancy</h3>
<p>As much as you pay for.
</p></li>
<li>
<h3>Read performance</h3>
<p>Very fast, especially for popular content.
</p></li>
<li>
<h3>Technology maturity</h3>
<p>No <a target="_blank" href="https://en.wikipedia.org/wiki/Proof_of_concept">PoC</a> yet.</p>
<p>Other similar technologies: <a target="_blank" href="https://www.storj.io/">Storj</a>, <a target="_blank" href="https://filecoin.io/">Filecoin</a>, <a target="_blank" href="https://sia.tech/">Sia</a>, <a target="_blank" href="https://maidsafe.net/">MaidSafe</a>.
</p></li>
<li>
<h3>Use case</h3>
<p>This makes sense for large blobs, but is not good for archiving as someone has to keep paying forever if the content is not popular. A lot of older content would "go missing". For some users this would be acceptable and probably cheaper than log storage.
</p></li>
</ul></li>
<li>
<h2><a target="_blank" href="https://ipfs.tech/">IPFS</a></h2>
<p>InterPlanetary File System can be a powerful technology for sharing content between devices, but there is currently no financial incentivization scheme for the network to store your content as there is with Swarm.</p>
<ul><li>
<h3>Cost</h3>
<p>Free.
</p></li>
<li>
<h3>Access to blob contents from a contract</h3>
<p>No read or write access without an oracle.
</p></li>
<li>
<h3>Max size</h3>
<p>No maximum.
</p></li>
<li>
<h3>Propagation time</h3>
<p>Blobs do not propagate unless another party requests them. This means that whenever you post something, you need to initially stay online for other parties to be able to read the messages.
</p></li>
<li>
<h3>Longevity</h3>
<p>You're own responsibility. Popular content will have greater network longevity.
</p></li>
<li>
<h3>Redundancy</h3>
<p>You're own responsibility. Popular content will have greater network redundancy.
</p></li>
<li>
<h3>Read performance</h3>
<p>Fast, especially for popular content.
</p></li>
<li>
<h3>Technology maturity</h3>
<p>Operational.</p>
<p>Other similar technologies: <a target="_blank" href="https://en.wikipedia.org/wiki/BitTorrent">BitTorrent</a>, <a target="_blank" href="https://en.wikipedia.org/wiki/GNUnet">GNUnet</a>, <a target="_blank" href="https://en.wikipedia.org/wiki/Hyphanet">Freenet</a>, <a target="_blank" href="https://en.wikipedia.org/wiki/Retroshare">Retroshare</a>, <a target="_blank" href="https://en.wikipedia.org/wiki/Tahoe-LAFS">Tahoe-LAFS</a>.
</p></li>
<li>
<h3>Use cases</h3>
<p>Because content does not propagate until it is requested, IPFS is only really suitable for devices that are always online.</p>
<p>It would actually be possible to write a smart contract that would log the IPFS id of every blob that is associated with a specific purpose. That way any interested party could <a target="_blank" href="https://web.archive.org/web/20190820120150/https://ipfs.io/docs/commands/#ipfs-pin">pin</a> all of the IPFS files associated with a "subreddit" for example. The disadvantage is that, unlike with log storage, there is no financial penalty for instructing others to store your blobs.
</p></li>
</ul></li>
<li>
<h2><a target="_blank" href="https://web.archive.org/web/20190820120150/https://github.com/ethereum/wiki/wiki/Whisper">Whisper</a></h2>
<p>This is the intended decentralized message passing protocol for Ethereum dapps.</p>
<ul><li>
<h3>Cost</h3>
<p>Free.
</p></li>
<li>
<h3>Access to blob contents from a contract</h3>
<p>No read or write access without an oracle.
</p></li>
<li>
<h3>Max blob size</h3>
<p>No maximum, but the system is intended for messages less than 64kB, typically around 256 bytes. Bigger payloads are more likely to be ignored by other nodes.
</p></li>
<li>
<h3>Propagation time</h3>
<p>Instantaneous, but public messages with high <a target="_blank" href="https://en.wikipedia.org/wiki/Time_to_live">TTL</a> may take longer.
</p></li>
<li>
<h3>Longevity</h3>
<p>Max TTL 2 days.
</p></li>
<li>
<h3>Redundancy</h3>
<p>Message will be stored throughout the network until TTL expires.
</p></li>
<li>
<h3>Read performance</h3>
<p>Immediate once the message has been received.
</p></li>
<li>
<h3>Technology maturity</h3>
<p>Only PoC at this time. Unknown when it will be production ready, but it is to be a core Ethereum technology.</p>
<p>Other similar technologies: <a target="_blank" href="https://en.wikipedia.org/wiki/ZeroMQ">ØMQ</a>, <a target="_blank" href="https://en.wikipedia.org/wiki/Bitmessage">Bitmessage</a>, <a target="_blank" href="https://en.wikipedia.org/wiki/Telehash">Telehash</a>, <a target="_blank" href="https://en.wikipedia.org/wiki/Tox_%28protocol%29">Tox</a>.
</p></li>
<li>
<h3>Use case</h3>
<p>Building Twitter or Reddit on Whisper would be a very different sort of platform compared to building them on a more permanent storage system. However, a more ephemeral system does make more sense for a lot of use-cases. Most of what people say is not of any great importance except in the moment between the parties involved. There is no reason why it should be archived and people have a different psychological attitude to communicating when they don't have to assume that everything is being publicly archived for eternity.
</p>
