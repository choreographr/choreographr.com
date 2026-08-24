+++
title = "Building a private blockchain on the Ethereum public blockchain"
description = 'Originally published on jonathanpatrick.me.'
date = 2015-08-14
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

Retrieved from the [Wayback Machine](https://web.archive.org/web/20181117235557/http://jonathanpatrick.me/blog/private-on-public).
<p>I first became aware of the concept of private blockchains several months ago when I watched a <a target="_blank" href="https://web.archive.org/web/20181117235557/https://www.youtube.com/watch?v=zgkmQ-jQJHk">presentation</a> by Preston Byrne of <a target="_blank" href="https://web.archive.org/web/20181117235557/https://erisindustries.com/">Iris Industries</a>. <a target="_blank" href="https://web.archive.org/web/20181117235557/https://en.wikipedia.org/wiki/Vitalik_Buterin">Vitalik Buterin</a> (inventor of <a target="_blank" href="https://web.archive.org/web/20181117235557/https://ethereum.org/">Ethereum</a>) was also presenting in that session, although not about private blockchains. I must admit I was very sceptical of the whole concept. The entire purpose of having a blockchain is so that no one can be prevented from putting a valid transaction on the ledger. With a private blockchain only an agreed list of people can create transactions. The problem, unlike on a public blockchain, is that it is very easy for a majority of participants to get together and prevent another from creating a transaction. The participants and the verifiers are the same people.</p>
<p>A few days ago it was announced that <a target="_blank" href="https://web.archive.org/web/20181117235557/https://blog.erisindustries.com/hiring/2015/08/03/brian-is-a-marmot/">Brian Fabian Crain would be joining Iris Industries</a>, so I decided to spend some time re-evaluating the whole concept of private blockchains.</p>
<p>I realized there is value in having a private blockchain instead of just using some other message passing / database technology. People want to be able to interact with a fixed set of people they don't trust with fixed, known rules, and in private. With an Ethereum smart contract it is possible to have access control so only specific accounts can change the state, the rules are defined in the contract, and as it is on the public blockchain it is imposible to prevent another participant from creating a transaction. The disadvantage is that a smart contract on a public blockchain can only operate on public data. This is the primary reason why it is attractive to have a private blockchain. Another advantage of a private chain is that a transaction fee doesn't have to be paid.</p>
<p>A few days later, Vitalik published a fantastic blog post <a target="_blank" href="https://web.archive.org/web/20181117235557/https://blog.ethereum.org/2015/08/07/on-public-and-private-blockchains/">On Public and Private Blockchains</a>.</p>
<p>In his list of advantages of private blockchains he says "The validators are known, so any risk of a 51% attack arising from some miner collusion in China does not apply". I think the opposite risk is true. If the participants and the validators are the same people, they can (and will) collude. On the public blockchain, collusion is much harder.</p>
<p>I came up with a hybrid solution that could be the best of both worlds.</p>
<p>The idea is to have a contract on the public Ethereum blockchain that serializes encrypted transactions for a private blockchain. It has a permissions system so only permitted users can add a transaction.</p>
<p>Any participant who needs to know the current state can download any transactions from the blockchain that they do not have yet, decrypt them and apply them to their copy of the private blockchain.</p>
<p>This hybrid technique removes the problem of participants colluding to prevent transactions being confirmed. The smart contract on the public ledger is the authority of what transactions are on the private ledger. Previously, participants could have colluded and created the longest chain. This is no longer possible. The disadvantage is participants need to pay a transaction fee.</p>
<p>I have implemented this <a target="_blank" href="https://web.archive.org/web/20181117235557/https://github.com/drupalnomad/ethereum-contracts/blob/master/private_ledger.sol">private ledger</a> in <a target="_blank" href="https://web.archive.org/web/20181117235557/https://github.com/ethereum/wiki/wiki/Solidity-Tutorial">Solidity</a>.</p>
