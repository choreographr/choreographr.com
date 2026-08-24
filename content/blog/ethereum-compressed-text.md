+++
title = "Storing compressed text in Ethereum transaction logs"
description = 'There are a lot of good reasons to store blobs of text in Ethereum. For example, a decentralized Reddit clone could store all the messages in the blockchain. These messages would be uncensorable and archived for eternity. In theory IPFS could be used, but it does not guarantee the availability of the messages unless someone is actively storing them.'
date = 2015-10-29
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

*Originally published on jonathanpatrick.me. [Retrieved](https://web.archive.org/web/20190915000510/http://jonathanpatrick.me/blog/ethereum-compressed-text) from the Wayback Machine.*

<p>There are a lot of good reasons to store blobs of text in <a target="_blank" href="https://ethereum.org/">Ethereum</a>. For example, a decentralized Reddit clone could store all the messages in the blockchain. These messages would be uncensorable and archived for eternity. In theory <a target="_blank" href="https://ipfs.tech/">IPFS</a> could be used, but it does not guarantee the availability of the messages unless someone is actively storing them.</p>
<p><a target="_blank" href="https://web.archive.org/web/20190915000510/https://ethereum.github.io/solidity/docs/contracts/#events">Log storage</a> is the ideal place to store text in the Ethereum blockchain. Contract state could be used, but it is more expensive and doesn't really offer any advantages. There is no reason why contract logic would need to access a blob of text. Data stored in the log can only be accessed externally, but that is fine for this use-case.</p>
<p>It costs about 76 <a target="_blank" href="https://web.archive.org/web/20190915000510/https://ethereum.gitbooks.io/frontier-guide/content/costs.html">gas</a> for each byte in a transaction that needs to be written to the log, so it makes sense to compress the text as much as possible. Good old <a target="_blank" href="https://en.wikipedia.org/wiki/Deflate">DEFLATE</a> is still highly competitive, but a new algorithm called <a target="_blank" href="https://en.wikipedia.org/wiki/Brotli">Brotli</a> has been created by Google. In a <a target="_blank" href="https://cran.r-project.org/web/packages/brotli/vignettes/brotli-2015-09-22.pdf">paper</a> written by Google they claim:</p>
<blockquote>
Our results indicate that Brotli, and only Brotli out of all the benchmarked algorithms, would be a good replacement for the common use cases of the DEFLATE algorithm in all three aspects, compression ratio, compression speed, and decompression speed.
</blockquote>
<p>According to one of the tests in that paper, Brotli can compress 70MB of HTML at 6.9:1, whereas DEFLATE can only manage 5.5:1. Unfortunately the <a target="_blank" href="https://web.archive.org/web/20190915000510/https://github.com/devongovett/brotli.js">only JavaScript implementation of Brotli</a> has a 20 second startup time, which makes it unsuitable for use in a dapp. However, looking at the results it seems that <a target="_blank" href="https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Markov_chain_algorithm">LZMA</a> is second-best and can achieve 6.2:1. Because the text that is to be stored in the blockchain is typically not very large, the compression / decompression speed is not actually very important. There is a <a target="_blank" href="https://web.archive.org/web/20190915000510/https://github.com/nmrugg/LZMA-JS">high quality LZMA implementation available for JavaScript</a>.</p>
<p>I tried compressing a <a target="_blank" href="https://web.archive.org/web/20190915000510/http://jonathanpatrick.me/sites/default/files/test.txt">demo document</a> with these algorithms using the highest compression parameters available for each. Note, your web browser may not render this file correctly as it does not know it is UTF-8. Here are the results:</p>
<table style="width: auto;"><tbody><tr><th>Algorithm</th>
<th style="text-align: right;">Size (bytes)</th>
<th style="text-align: right;">Ratio</th>
</tr><tr><td>Raw</td>
<td style="text-align: right;">46,134</td>
<td style="text-align: right;">1:1</td>
</tr><tr><td>DEFLATE</td>
<td style="text-align: right;">22,323</td>
<td style="text-align: right;">2.07:1</td>
</tr><tr><td>LZMA</td>
<td style="text-align: right;">19,840</td>
<td style="text-align: right;">2.33:1</td>
</tr><tr><td>Brotli</td>
<td style="text-align: right;">18,937</td>
<td style="text-align: right;">2.44:1</td>
</tr></tbody></table><p>The reason these ratios are smaller than in the paper is probably because the source file is considerably smaller.</p>
<p>Once a better JavaScript implementation of Brotli is available I would recommend it. Brotli has a very large built-in dictionary. This means it would be even more competitive for very short texts such as those that would be stored on the blockchain.</p>
<p>I have been developing a <a target="_blank" href="https://en.wikipedia.org/wiki/Pastebin">pastebin</a> on Ethereum called <a target="_blank" href="https://web.archive.org/web/20190915000510/https://github.com/bluedroplet/etherbin">Etherbin</a>. Currently it uses LZMA to store the document body in log storage and I have designed it to be upgradable to Brotli. Using <a target="_blank" href="https://en.wikipedia.org/wiki/Node.js">Node</a> it is very easy to interact with the contract.</p>
<p>First of all the Node app must be initialized:</p>

```js
var Web3 = require('web3');
var web3 = new Web3();
var fs = require('fs');
var lzma = require('lzma');
web3.setProvider(new web3.providers.HttpProvider('http://localhost:8545'));
web3.eth.defaultAccount = web3.eth.accounts[0];
var etherbinAbi = require('./etherbin.abi.json');
var etherbinContract = web3.eth.contract(etherbinAbi);
var etherbinAddress = '0x783bfbc4ef5da1fa47045c6c3f5bf8f31781ecac';
var etherbin = etherbinContract.at(etherbinAddress);</code></div>
```

<p>How many documents are stored in the contract can be determined as follows:</p>

```js
console.log('Documents stored: ' + etherbin.getDocumentCount().toFixed());
```

<p>I published the demo document like this; I set the gas limit to 3,000,000 to ensure this large transaction would succeed.</p>

```js
var input = fs.readFileSync('test.txt');

lzma.compress(input, 9, function(result) {
  var buf = new Buffer(result);
  var compressed = '0x' + buf.toString('hex');
  etherbin.publishDocument('blogdemo', 'This is a demo for a blog post', false, 'category1', 0, compressed, {gas: 3000000});
});
```

<p>The <a target="_blank" href="http://etherscan.io/tx/0xb0ca4b2af7c6c0e4e7f92a9af8b98d918ab2bdbf8ce512737ec34f21f7b1ba1a">transaction</a> used 1,720,210 gas and cost 0.0860105 Ether. This is currently worth 0.074 USD. Reddit comments are typically much smaller than the 46kB published in this transaction. It should be noted that at the moment the most gas an Ethereum transaction can use is 3,141,592 but this will be increased in future.</p>
<p>The document can be read from Etherbin like this:</p>

```js
var codeInfo = etherbin.getCodeInfo('blogdemo');

if (!codeInfo[0]) {
  console.log('Document not found');
  return;
}

var id = codeInfo[1].toFixed();
console.log('Title: ' + etherbin.getDocumentInfo(id)[1]);

var filter = web3.eth.filter({fromBlock: 452276, toBlock: 'latest', address: etherbinAddress, topics: [web3.fromDecimal(id)]});
filter.get(function(error, result) {
  var length = parseInt(result[0].data.substr(66, 64), 16);
  var buf = new Buffer(result[0].data.substr(130, length * 2), 'hex');
  lzma.decompress(buf, function(result) {
    console.log(new Buffer(result).toString('utf8'));
  });
});
```
