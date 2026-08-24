+++
title = "Update on Drupal / Bitcoin Payment Protocol (BIP 70) integration"
description = 'Originally published on jonathanpatrick.me.'
date = 2014-10-30
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

Retrieved from the [Wayback Machine](https://web.archive.org/web/20181114005114/http://jonathanpatrick.me/blog/bip70-drupal).

<a href="https://web.archive.org/web/20181114005114/https://github.com/bitcoin/bips/blob/master/bip-0070.mediawiki" target="_blank">BIP 70</a> describes a high-level payment system for Bitcoin. It uses <a href="https://web.archive.org/web/20181114005114/https://en.wikipedia.org/wiki/Protocol_Buffers" target="_blank">Protocol Buffers</a> and <a href="https://web.archive.org/web/20181114005114/https://en.wikipedia.org/wiki/X.509" target="_blank">X.509</a> certificates for the following major improvements:</p>
<ul><li>Human-readable payment destinations instead of Bitcoin addresses</li>
<li>Resistance from man-in-the-middle attacks</li>
<li>Payment received messages sent back to the wallet</li>
<li>Refund addresses</li>
</ul><p><img src="/blog/protocol-sequence.png" width="766" height="482" style="width: 100%; height: auto;"></p>
<p>I <a href="https://web.archive.org/web/20181114005114/https://github.com/bluedroplet/bitcoin-payment-protoc-php" target="_blank">compiled</a> the <a href="https://web.archive.org/web/20181114005114/https://github.com/bitcoin/bips/blob/master/bip-0070/paymentrequest.proto" target="_blank">BIP 70 Protocol Buffers definition file</a> into PHP using <a href="https://web.archive.org/web/20181114005114/https://github.com/drslump/Protobuf-PHP" target="_blank">ProtobufPHP</a>.</p>
<p>I have implemented most of BIP 70 in the <a href="https://web.archive.org/web/20181114005114/https://www.drupal.org/project/cointools" target="_blank">Coin Tools</a> Drupal project. It contains a new Bitcoin payment entity class that contains all the specified fields in its base table. Bundles can be created to add additional fields to payments.</p>
<p>Payments can currently be created through an admin interface, although this would typically happen in an automated process on a real website.</p>
<p>When viewing an unfulfilled payment in the admin interface the QR code for the payment will be present. It decodes to a <a href="https://web.archive.org/web/20181114005114/https://github.com/bitcoin/bips/blob/master/bip-0072.mediawiki" target="_blank">backward-compatible payment protocol URI</a>.</p>
<p><img src="/blog/drupal-before.png" width="617" height="674" style="width: 100%; height: auto;"></p>
<p><img src="/blog/android-before.png" width="270" height="480" style="width: 50%; height: auto;"><img src="/blog/android-after.png" width="270" height="480" style="width: 50%; height: auto;"></p>
<p><img src="/blog/drupal-after.png" width="617" height="674" style="width: 100%; height: auto;"></p>
<p>Currently the module is unable to detect Bitcoin payments not sent using the payment protocol, i.e. the payment is sent to the address but the website is not notified. This will be quite easy to implement though.</p>
<p>For payments made using the new protocol, Coin Tools is able to complete the transaction and has been tested with both the original <a href="https://web.archive.org/web/20181114005114/https://en.bitcoin.it/wiki/Bitcoin-Qt" target="_blank">QT client</a> and <a href="https://web.archive.org/web/20181114005114/https://play.google.com/store/apps/details?id=de.schildbach.wallet" target="_blank">Andreas Schildbach's Android Wallet</a>. Interestingly Andreas's wallet does not display the status message returned by the merchant.</p>
<p>The specification does not seem to have any method for the merchant to inform the app that the payment was not satisfactory, other than setting the human readable status message (the wallet would not know there was a problem), or returning an HTTP error code (resulting in unpleasant error message for customer).</p>
<p>Coin Tools will check the transactions provided by the wallet are sending enough bitcoins to the payment address. It then broadcasts the transactions via bitcoind. Currently Coin Tools is relying on bitcoind rejecting transactions that have not been signed correctly. This assumption needs to be verified.</p>
<p>When the payment protocol QR code is displayed, Coin Tools enables a small Javascript program to poll the website to determine if the payment has been made, reloading the page once this has happened. Ideally this would be implemented as a long-running AJAX request.</p>
<p>The X.509 certificate part of the payment protocol specification has not yet been implemented in Coin Tools. This is a critical component.</p>
<p>The implementation of the payment protocol in Coin Tools only permits a single Bitcoin address per payment. The specification does support having more than one and in theory this could be used to increase payment anonymity by each address only being spent into by a single output in a single transaction. In practise this is not so effective as all the transactions would be broadcast simultaneously.</p>
<p>Coin Tools will also store a single refund address provided by the wallet making the payment. The wallet actually provides payment scripts, but Coin Tools will determine if the script is a standard payment and extract the address. Multiple refund addresses are also supported by the standard, but Coin Tools will only store one.</p>
<p>According to the specification the wallet can allow the customer to provide a note to the vendor. Coin Tools will store this note, however I do not know of any wallets that support this feature.</p>
<p>The HTTP responses for PaymentRequest and Payment need to be implemented as Symfony response handlers. Currently they are implemented in a simplistic manner setting their own HTTP headers and and calling exit().</p>
<p>It is currently only possible to make payments from the admin interface. A template needs to be provided so the payments can be made from elsewhere on a website, e.g. integration with Drupal Commerce.</p>
<p>For a standard ecommerce website that wants to accept bitcoins it may make more sense to use a provider such as <a href="https://web.archive.org/web/20181114005114/https://bitpay.com/" target="_blank">BitPay</a> or <a href="https://web.archive.org/web/20181114005114/https://www.coinbase.com/join/bluedroplet" target="_blank">Coinbase</a>. Accepting payments natively on a website means that a hacker could steal funds. One solution to this problem would be to use <a href="https://web.archive.org/web/20181114005114/https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki" target="_blank">Hierarchical Deterministic Wallets</a> so that private keys are only stored on backend systems.</p>
<p>For a project that is doing something more interesting than just accepting Bitcoin as a payment method and is already running bitcoind, it may be advantageous to have a native implementation on BIP 70 on the website rather than relying on a third-party provider.</p>
<p>No tests have yet been written for Coin Tools. It is essential that Payment and PaymentRequest routes are fully tested including the edge cases defined in the specification.</p>
<p>A few limitations of Drupal 8 have been encountered during the creation of this functionality. In Drupal 8 it is now possible to have fields in entity base tables. This is really great, but unfortunately when these fields are present in a view it is <a href="https://web.archive.org/web/20181114005114/https://www.drupal.org/node/2342045" target="_blank">not possible to use their formatters</a>. I discussed this with Daniel Wehner at Amsterdam and he didn't seem very optimistic about this being able to be fixed so some sort of workaround will need to be found as this functionality is critical to the module.</p>
<p>Date field is now in D8 core, but unfortunately it <a href="https://web.archive.org/web/20181114005114/https://www.drupal.org/node/2366213" target="_blank">stores the date as a varchar</a> in the database. This means that it is not possible to sort or filter on date - a major limitation. If core is not changed to use database-native date storage Coin Tools will have to use another date field.</p>
<p>The Payment Protocol functionality needs to be backported to Drupal 7 Coin Tools and integrated with <a href="https://web.archive.org/web/20181114005114/https://www.drupal.org/project/payment" target="_blank">Payment</a> / <a href="https://web.archive.org/web/20181114005114/https://www.drupal.org/project/commerce" target="_blank">Commerce</a>.</p>
