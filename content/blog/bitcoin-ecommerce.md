+++
title = "Ensuring security of funds and preserving anonymity when using Bitcoin for e-commerce"
description = 'Originally published on jonathanpatrick.me.'
date = 2015-01-21
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

Retrieved from the [Wayback Machine](https://web.archive.org/web/20181015023339/http://jonathanpatrick.me/blog/bitcoin-ecommerce).

<img src="/blog/bitcoin-accepted-here.png" width="720" height="275" style="width: 100%; height: auto;">

<p>When configuring an e-commerce website to accept Bitcoin, it is important to be aware of the extra security considerations relating to private keys. Each payment needs its own Bitcoin address so these need to be readily available on the system providing the e-commerce functionality. This is not true of the private keys. Unless payments need to be made in an automated manner in response to user actions on the website, the wallet that holds them can be stored in a much more secure environment. This can make it significantly harder for a hacker to steal the funds.</p>
<p>There are various techniques to have a continuous supply of addresses for a wallet stored elsewhere:</p>
<h2>Immediate forwarding to fixed address</h2>
<p>Addresses are generated from a hot wallet the e-commerce system has full access to, e.g. bitcoind. Once the customer has sent the funds to a Bitcoin address for a specific payment, a subsequent transaction can be created by the system to forward the funds to an address that has its private key stored in a more secure manner. The exact outputs received from the customer can be used as the inputs for the forwarding transaction. This means that it is not necessary to wait for multiple confirmations of the original transaction, minimising the window of attack when the funds could be stolen. However, it may be prudent to wait for 1 confirmation to avoid <a href="https://web.archive.org/web/20181015023339/https://github.com/bitcoin/bips/blob/master/bip-0062.mediawiki" target="_blank">transaction malleability</a> issues.</p>
<p>The problem with this technique is that all the funds received end up in a single address. This is very bad for anonymity because it links together on the public ledger all of the payments made on your website.</p>
<h2>Extended public keys</h2>
<p>Addresses could be generated in the wallet and uploaded to the live system in bulk, however there is no standardized way for this to happen and a much more elegant system exists. As described in detail in my <a href="https://web.archive.org/web/20181015023339/http://jonathanpatrick.me/blog/hd-wallets-drupal">previous post</a>, xpubs can be used to generate endless addresses for a wallet that is maintained elsewhere. This is exactly what we need, but there are a number of problems:</p>
<ul><li>Low wallet support:<br><a href="https://web.archive.org/web/20181015023339/https://electrum.org/" target="_blank">Electrum</a>: exports an account xpub for receiving purposes for normal and <a href="https://web.archive.org/web/20181015023339/https://bitcoinmagazine.com/11108/multisig-future-bitcoin/" target="_blank">multisig</a> wallets.<br><a href="https://web.archive.org/web/20181015023339/https://play.google.com/store/apps/details?id=com.bonsai.wallet32" target="_blank">Wallet32</a>: works, but this is not a multisig wallet.<br><a href="https://web.archive.org/web/20181015023339/https://coinkite.com/fr/fce4276q" target="_blank">Coinkite</a>: will export multisig xpubs, but they actively do not support what they term <a href="https://web.archive.org/web/20181015023339/https://docs.coinkite.com/api/advanced.html" target="_blank">subkey front running</a>.
</li><li>Low e-commerce software / service support:<br>
The only e-commerce systems that I know of that will accept xpubs for generating addresses are <a href="https://web.archive.org/web/20181015023339/https://coindirect.io/" target="_blank">CoinDirect</a> and my own <a href="https://web.archive.org/web/20181015023339/https://www.drupal.org/project/cointools" target="_blank">Drupal Coin Tools</a>.
</li>
<li>Hard to setup:<br>
Even with a non-multisig arrangement, care has to be taken that the correct path prefix is used with the xpub to generate addresses that match those in the wallet software. With multisig an xpub from each key signer has to be put into the system.
</li>
</ul><h2>Obtain addresses from web wallet API</h2>
<p>Some web wallets provide API access to obtain new addresses for an account. Of course this is only available for wallets that are maintained by a third party. <a href="https://web.archive.org/web/20181015023339/https://coinkite.com/fr/fce4276q" target="_blank">Coinkite</a> and <a href="https://web.archive.org/web/20181015023339/https://www.bitgo.com/" target="_blank">BitGo</a> are examples of this. Fortunately both these services are multisig so the risk of utilising a third party is minimised.</p>
<p>This technique has a number of disadvantages. In order for the e-commerce solution to be able to retrieve addresses from your wallet, it will need some sort of credentials. If a hacker stole these they could then access the wallet and steal the funds anyway. It is necessary that these APIs are able to utilise credentials that do not have spending capability. For example, Coinkite <a href="https://web.archive.org/web/20181015023339/https://docs.coinkite.com/api/auth.html" target="_blank">has this capability</a>.</p>
<p>The APIs are not standardised so e-commerce systems will need to have a unique plugin written for each wallet service.</p>
<h2>Use third party provider for payment workflow</h2>
<p>Services such as <a href="https://web.archive.org/web/20181015023339/https://www.bitnet.io/" target="_blank">Bitnet</a>, <a href="https://web.archive.org/web/20181015023339/https://bitpay.com/" target="_blank">BitPay</a> and <a href="https://web.archive.org/web/20181015023339/https://www.coinbase.com/join/bluedroplet" target="_blank">Coinbase</a> offer a much more managed solution for Bitcoin payments. They do much more of the heavy lifting and the e-commerce system just has to do the bare minimum to integrate. This means that you do not have to have Bitcoin addresses stored on your system whatsoever.</p>
<p>Advantages:</p>
<ul><li>Easier to integrate if integration doesn't already exist.</li>
<li>Not necessary to run your own Bitcoin node or use a service such as <a href="https://web.archive.org/web/20181015023339/https://chain.com/" target="_blank">Chain</a>.</li>
<li>Customers may feel more confident using one of these trusted brands rather than a solution directly built into your web site.</li>
<li>Because these services typically just maintain a database record for how much they owe you, they effectively act as a <a href="https://web.archive.org/web/20181015023339/https://en.bitcoin.it/wiki/Mixing_service" target="_blank">mixing service</a>. This can preserve payment anonymity.</li>
<li>Built-in conversion to fiat.</li>
<li>Prevent exposure to exchange rate volatility.</li>
</ul><p>Disadvantages:</p>
<ul><li>These payment providers are subject to very strong <a href="https://web.archive.org/web/20181015023339/https://en.wikipedia.org/wiki/Know_your_customer" target="_blank">KYC</a> and <a href="https://web.archive.org/web/20181015023339/https://en.wikipedia.org/wiki/Money_laundering#Enforcement" target="_blank">AML</a> regulations.</li>
<li>Again, these APIs are not standardised so e-commerce systems will need to have a unique plugin written for each wallet service.</li>
</ul><h2>Stealth addresses</h2>
<p>At the moment <a href="https://web.archive.org/web/20181015023339/http://www.coindesk.com/stealth-addresses-secret-bitcoin-privacy/" target="_blank">stealth addresses</a> are purely theoretical, but they could be an extremely useful means of generating addresses for e-commerce.</p>
<p>A highly simplified overview of how it works is that a single address is provided by the payee (your back-end wallet). This is stored on the e-commerce platform. Endless addresses can then be generated from this address that the wallet will be able to detect and spend.</p>
<p>It has a number of advantages over xpubs:</p>
<ul><li>Much improved usability. It is a much shorter address and can even generate multisig addresses from a single address.</li>
<li>The same stealth address can be used by multiple payers while maintaining anonymity. This is useful for addresses that are publicised.</li>
<li>Has the potential to have broad wallet support.</li>
