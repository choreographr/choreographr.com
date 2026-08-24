+++
title = "Acuity Index"
description = 'The theory behind disintermediation is that we replace our institutions with autonomous dapps so that people can interact with each other in a transparent, rules-based framework.'
date = 2025-05-07
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

The theory behind disintermediation is that we replace our institutions with autonomous dapps so that people can interact with each other in a transparent, rules-based framework.

For example, imagine an airline that is a DAO. Token holders can discuss and vote on governance decisions. Naturally they will have many differing opinions on how the airline should be run. In order to convice others how to vote, very complex discussions will need to happen in public. This transparency will help to eradicate corruption.

A not-for-profit company can be set up with a constitution that states that it is to obey the will of the DAO. The company can own real world items (like airplanes) and make contracts with other off-chain entities (for example an airport or a catering company).

Tokens would be burnt when someone purchases a flight. The DAO could decide to expand the token supply for expenditure. For example, to pay staff or to buy another airplane.

Later, if an airline manufacturer became a DAO an airplane could be purchased by a direct DAO to DAO payment rather than company to company.

The problem is that directly querying blockchain state is very limiting. Dapps need rich functionality (like content search) to be useful and this requires a heavy backend that can provide immediate indexed data for the frontend. This inevitably leads to a *centralized* backend. The dapp gets hardcoded to the backend. The backend is then ripe for capture. Powerful entities can influence who is allowed to be visible on the dapp.

In the case of an airline DAO, those who control the backend will end up controlling the airline instead of the token holders. 

Having a truely decentralized backend is not very practical. You could try to store all transaction history in state, but this is very expensive. Full text search, content recommendation and AI queries are inheritantly centralized - they require extensive resources such that only the most committed power user could run personally.

The solution is to have a free market of rich backend providers that use a standardized API.

I received 2 grants ([1](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid.md),[2](https://github.com/w3f/Grants-Program/blob/master/applications/hybrid2.md)) from the [Web3 Foundation](https://grants.web3.foundation/) to develop an event indexer for Polkadot blockchains. This has now been renamed to [Acuity Index](/platform/) and will serve as the basis for a free market of indexing nodes for Acuity.
