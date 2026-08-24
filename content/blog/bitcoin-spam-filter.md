+++
title = "Using Bitcoin dust transactions to prevent website spam"
description = 'Originally published on jonathanpatrick.me.'
date = 2015-01-30
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

Retrieved from the [Wayback Machine](https://web.archive.org/web/20181108185224/http://jonathanpatrick.me/blog/bitcoin-spam-filter).

<p>I quite often use <a href="https://web.archive.org/web/20181108185224/https://mollom.com/" target="_blank">Mollom</a> to prevent spam submissions on contact and comment forms. It works pretty well, but some spam still gets through.</p>
<p>An alternative anti-spam technique is to require a Bitcoin dust transaction before an unprivileged user can <a href="https://web.archive.org/web/20181108185224/https://en.wikipedia.org/wiki/POST_%28HTTP%29" target="_blank">POST</a> a form. The value of such a transaction would only be about $<span style="white-space:nowrap;"> </span>0.001 USD. For a non-spammer this cost is fine, but for a spammer this is enough to make it totally uneconomical as they need to send out millions of posts.</p>
<p>I created a Spam Filter sub-module in my <a href="https://web.archive.org/web/20181108185224/https://www.drupal.org/project/cointools" target="_blank">Coin Tools</a> project for <a href="https://web.archive.org/web/20181108185224/http://drupal.com/" target="_blank">Drupal</a>. It can be used to require a Bitcoin payment on any form on a Drupal website.</p>
<p>Coin Tools already has a Bitcoin payments system. When viewing a form, a new payment is created for the minimum amount possible. In the latest Bitcoin reference implementation the smallest output is 546 satoshis. However, many wallets still use the old value of 5460 so that is what is used.</p>
<p>The form's submit button is hidden with CSS (it still needs to be in the DOM for the form to function correctly) and a clickable QR code for the payment is put in its place. Coin Tools payments are <a href="https://web.archive.org/web/20181108185224/http://jonathanpatrick.me/blog/bip70-drupal">BIP 70</a> compatible so a payment can either be satisfied by a direct POST from the wallet to the Drupal website, or the wallet can broadcast the transaction through the Bitcoin network (slightly slower).</p>
<p>Once Coin Tools has determined that the payment has been completed it will POST the form via JavaScript. If there are any validation errors the form will reload in the normal Drupal way. In this case, the submit button is no longer replaced by a QR code as it is recorded in the form state that the payment has been made.</p>
<p>When the form is submitted it is also verified on the server that the payment has been completed.</p>
<p>Here is a <a href="https://www.youtube.com/watch?v=TlLs3jC0Kiw" target="_blank">video</a> of it in action.</p>
<p>Of course, this technique requires that the user has a small amount of bitcoin. For a website not targeting the Bitcoin community it would not only prevent spammers it would actually prevent everyone from posting. As Bitcoin usage increases this technique will be able to become more commonplace.</p>
<h2>Browser integration</h2>
<p>It has been proposed before that web browsers should have Bitcoin <a href="https://web.archive.org/web/20181108185224/https://bitcoin.org/en/developer-guide#simplified-payment-verification-spv" target="_blank">SPV</a> wallets <a href="https://web.archive.org/web/20181108185224/https://www.reddit.com/r/Bitcoin/comments/2pyhnd/demo_video_of_working_zero_click_bitcoin/" target="_blank">built-in</a>, e.g. for paywalls. If a payment is required an "HTTP 402 Payment Required" response would be generated. In that situation it would make sense for the browser to prompt the user before a payment is made. For the spam filter this could just happen automatically. The transaction could actually just be included as part of the POST to submit the form.</p>
<h2>Burning Coins</h2>
<p>Because the transactions are for such a small amount it may not be economic to spend the received funds as large miner fees would be required. It might be simpler to just generate a random Bitcoin address for each payment. This means that you don't have to have a wallet on the server and could just use <a href="https://web.archive.org/web/20181108185224/https://chain.com/" target="_blank">Chain</a> to check if the payment has completed.</p>
<h2>Double-spends</h2>
<p>If a double-spend on a comment submission was detected after it had been accepted, the post could be deleted. For email submissions, they could be delayed a few seconds to be sure there is not a contradictory transaction floating around.</p>
<p>Even without implementing these protections, double-spending wouldn't make sense for a spammer.</p>
<p>Could a spammer double spend and avoid paying the dust amount? No - double spending is extremely expensive so it would be even worse value for money than just paying the dust amount.</p>
<p>Could a spammer simultaneously broadcast many transactions that spend the same outputs to many different forms and websites? In theory this might be possible and some of the forms would accept the POST before realising the transaction is a double spend. Spamming multiple forms on the same website simultaneously would be impossible because the website would be connected to just one Bitcoin node. If this did become an issue the fee required to POST could just be increased to make it uneconomic.</p>
<h2>Greater amount?</h2>
<p>Of course, it may be desirable to actually charge a larger fee for the purpose of generating revenue. The admin interface could be extended to allow a configurable amount.</p>
