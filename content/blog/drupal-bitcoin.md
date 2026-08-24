+++
title = "Drupal & Bitcoin"
description = 'Originally published on jonathanpatrick.me.'
date = 2014-09-15
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

Retrieved from the [Wayback Machine](https://web.archive.org/web/20181114005136/http://jonathanpatrick.me/blog/drupal-bitcoin).

Almost everything we do on the web will work better with autonomous blockchain technologies such as <a href="https://web.archive.org/web/20181114005136/http://bitcoin.com/" target="_blank">Bitcoin</a> &amp; <a href="https://web.archive.org/web/20181114005136/https://www.ethereum.org/" target="_blank">ethereum</a> because they allow systems to be built with unbreakable rules. Unlike Facebook, Twitter, Airbnb, Uber, PayPal or eBay, no executive authority can step in and say the rules don't apply to you.</p>
<p>Of all the blockchain technologies, Bitcoin is currently the most high profile. It is a massive area of growth in the startup eco-system.</p>
<p><a href="https://web.archive.org/web/20181114005136/https://www.drupal.org/drupal-8.0" target="_blank">Drupal 8</a> is going to be a fantastic platform for building startups, but we need to make sure that it is also a fantastic platform for blockchain startups.</p>
<p>I've started by creating a Drupal 7 &amp; 8 project called <a href="https://web.archive.org/web/20181114005136/https://www.drupal.org/project/cointools" target="_blank">Coin Tools</a>. It provides various components that would be useful for building a Bitcoin web product. Many of the altcoins are very similar to Bitcoin so the project could easily be extended to accommodate them.</p>
<p>I've also created a <a href="https://web.archive.org/web/20181114005136/https://amsterdam2014.drupal.org/bof/blockchain-bitcoin-ethereum" target="_blank">Blockchain BoF</a> at <a href="https://web.archive.org/web/20181114005136/https://amsterdam2014.drupal.org/" target="_blank">DrupalCon Amsterdam</a> on the Tuesday at 10:45.</p>
<h1>Coin Tools base module</h1>
<p>Contains the following field types:</p>
<ul><li>Address</li>
<li>Amount</li>
<li>Transaction</li>
</ul><h2>Widgets</h2>
<p><img height="148" src="/blog/widgets.png" width="342"></p>
<h2>Formatters</h2>
<p><img height="280" src="/blog/formatters.png" width="222"></p>
<h1>Coin Tools Daemon</h1>
<ul><li>facilitates configuration and access to bitcoind service</li>
<li>triggers a hook when a Bitcoin transaction is detected</li>
<li>provides a full UI for browsing transactions and sending and receiving bitcoin</li>
</ul><p><img height="119" src="/blog/toolbar.png" width="269"></p>
<p><img height="399" src="/blog/transaction-browser.png" width="633" style="width: 100%; height: auto;"></p>
<p><img height="399" src="https://web.archive.org/web/20181114005136im_/http://jonathanpatrick.me/bitcoin-images/transaction.png" width="633" style="width: 100%; height: auto;"></p>
<p><img height="386" src="/blog/send-bitcoin.png" width="633" style="width: 100%; height: auto;"></p>
<p><img height="379" src="/blog/receive-bitcoin.png" width="633" style="width: 100%; height: auto;"></p>
<p>I am currently working on a full implementation of <a href="https://web.archive.org/web/20181114005136/https://github.com/bitcoin/bips/blob/master/bip-0070.mediawiki" target="_blank">BIP 70</a> which provides a much improved payment experience for the customer. Then I will add integration with <a href="https://web.archive.org/web/20181114005136/https://www.drupal.org/project/payment" target="_blank">Payment</a> / <a href="https://web.archive.org/web/20181114005136/https://www.drupal.org/project/commerce" target="_blank">Commerce</a>. This means it will be possible to receive payments in Commerce without using a third party payment processor.</p>
<h1>Coins Tools Fiat</h1>
<ul><li>obtains bitcoin exchange rates from <a href="https://web.archive.org/web/20181114005136/https://bitcoinaverage.com/" target="_blank">BitcoinAverage</a> (which I consider to be the gold standard), falling back to <a href="https://web.archive.org/web/20181114005136/https://bitpay.com/bitcoin-exchange-rates" target="_blank">BitPay BBB</a></li>
<li>facilitates rendering of fiat amounts</li>
<li>user can select preferred fiat currency</li>
<li>current bitcoin value block</li>
</ul><p><img height="352" src="/blog/exchange-rates.png" width="633" style="width: 100%; height: auto;"></p>
<p><img height="47" src="/blog/block.png" width="240"></p>
