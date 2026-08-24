+++
title = "Indexing the blockchain with Elastic Ethereum"
description = "One of things that can't really be done yet in a decentralized manner is search. In an Ethereum smart contract it is possible to maintain some elementary lookup tables, but more advanced features such as full text search are generally not possible due to excessive processing and storage requirements on-chain. Eventually it may be possible to use Ethereum to coordinate a network of search oracles that would profit financially if the network determines them to be operating correctly, but I am not currently aware of any such project. This sort of solution would be analogous to how Swarm is being proposed to work."
date = 2016-01-05
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

*Originally published on jonathanpatrick.me. [Retrieved](https://web.archive.org/web/20190914221126/http://jonathanpatrick.me/blog/elastic-ethereum) from the Wayback Machine.*

<p>One of things that can't really be done yet in a decentralized manner is search. In an Ethereum <a target="_blank" href="https://en.wikipedia.org/wiki/Smart_contract">smart contract</a> it is possible to maintain some elementary lookup tables, but more advanced features such as <a target="_blank" href="https://en.wikipedia.org/wiki/Full-text_search">full text search</a> are generally not possible due to excessive processing and storage requirements on-chain. Eventually it may be possible to use Ethereum to coordinate a network of search oracles that would profit financially if the network determines them to be operating correctly, but I am not currently aware of any such project. This sort of solution would be analogous to how <a target="_blank" href="https://www.youtube.com/watch?v=VOC45AgZG5Q">Swarm</a> is being proposed to work.</p>
<p>For example, imagine there was a dapp that was essentially a Yelp or TripAdvisor clone. Businesses could upload their information and customers could leave comments. Because it would be autonomous and transparent, it would avoid a lot of the criticisms levelled at these sites. Being able to search this information would be really important. Ideally the search would also be autonomous and transparent, but this is not yet possible.</p>
<p>In the mean time, there are some very mature centralized search daemons. <a target="_blank" href="https://en.wikipedia.org/wiki/Elasticsearch">Elasticsearch</a> is generally regarded as the best. <a target="_blank" href="https://github.com/NexusDevelopment/elastic-ethereum">Elastic Ethereum</a> is a Node program that I have created that waits for events on Ethereum contracts and then populates an Elasticsearch index accordingly. A dapp could connect to an external Elasticsearch daemon to provide (albeit centralized) search functionality. Potentially <a target="_blank" href="https://www.youtube.com/watch?v=IgNjs_WaFSc">Mist</a> (the Ethereum browser) could even have Elasticsearch bundled with it to provide indexing locally.</p>
<p>Elastic Ethereum could also be used for private analysis of contracts, although depending on your use-case a different database system might be more appropriate.</p>
<p>Additionally, Elastic Ethereum can extend contract objects returned by web3 with custom methods that utilize the index.</p>
<p>The <a target="_blank" href="https://github.com/NexusDevelopment/elastic-ethereum/blob/master/README.md">README.md</a> details how to configure it.</p>
<p>I created a contract to test the indexing: <a target="_blank" href="https://web.archive.org/web/20190914221126/https://github.com/bluedroplet/public-message-ethereum/blob/43f521d3d1ded9d73d21a0f41aaee3eec0b10484/public-message.sol">public-message.sol</a>.</p>
<p>My production.json looks like this:</p>

```json
{
  "ethereum": {
    "provider": "http://localhost:8545"
  },
  "elasticsearch": {
    "host": "localhost:9200"
  },
  "contracts" : {
    "public-messages": {
      "address": "0x05a74ade0dcb9c8ca8140273e66a9f455be51294",
      "index": "public-messages"
    }
  }
}
```

<p>And my public-messages.callbacks.js looks like this:</p>

```js
var onInit = function() {
}

var onCreate = function() {
}

var getDeletes = function(log) {
  return {}
}

var getDocuments = function(log) {
  var hash = log.data;
  var message = contract.getMessage(hash);
  var document = {};
  document[hash] = {body: message[2]};
  
  return {
    message: document
  };
}

module.exports = {
  onInit: onInit,
  onCreate: onCreate,
  getDeletes: getDeletes,
  getDocuments: getDocuments
};
```

<p>The daemon is invoked like this:</p>

```
node elastic-ethereum.js public-messages
```

<p>Every time someone executes the saveMessage() function Elastic Ethereum indexes the message.</p>
