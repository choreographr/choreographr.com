+++
title = "Review of Bitcoin exchange rate APIs"
description = 'Originally published on jonathanpatrick.me.'
date = 2014-03-07
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]
+++

Retrieved from the [Wayback Machine](https://web.archive.org/web/20181108145044/http://jonathanpatrick.me/blog/bitcoin-exchange-rate-apis).

<h2><a href="https://web.archive.org/web/20181108145044/https://openexchangerates.org/documentation" target="_blank">Open Exchange Rates</a></h2>
<p>This API is more geared to government issued currencies and is very popular with startups. It is mentioned here because many of the other Bitcoin currency APIs utilise it in some form.</p>
<ul><li>fee must be paid to get frequent updates / HTTPS</li>
<li>Bitcoin exchange rate is just <a href="https://web.archive.org/web/20181108145044/https://openexchangerates.org/faq#bitcoin" target="_blank">relaying CoinDesk BPI</a></li>
</ul><h2><a href="https://web.archive.org/web/20181108145044/http://winkdex.com/" target="_blank">Winkdex</a></h2>
<p>Recently created by the Winklevoss twins.</p>
<ul><li><a href="https://web.archive.org/web/20181108145044/http://winkdex.com/formula" target="_blank">low transparency / proprietry algorithm</a> - how is the data determined?</li>
<li>only based on USD market</li>
<li><a href="https://web.archive.org/web/20181108145044/http://docs.winkdex.com/" target="_blank">API</a> not available yet</li>
</ul><h2><a href="https://web.archive.org/web/20181108145044/https://coinbase.com/api/doc/1.0/currencies/exchange_rates.html" target="_blank">Coinbase</a></h2>
<ul><li>not transparent</li>
<li>does it return the market rate or their own sell rate?</li>
<li>many currencies</li>
<li>free</li>
</ul><h2><a href="https://web.archive.org/web/20181108145044/https://blockchain.info/api/exchange_rates_api" target="_blank">Blockchain.info</a></h2>
<ul><li>not transparent</li>
<li>not many currencies</li>
<li>15 minutes delayed</li>
<li>free</li>
</ul><h2><a href="https://web.archive.org/web/20181108145044/http://www.coindesk.com/api/" target="_blank">CoinDesk BPI</a></h2>
<p>This index seems to be primarily a marketing exercise for CoinDesk.</p>
<ul><li>simple average of two exchanges</li>
<li>only based on USD market</li>
<li>Open Exchange Rates used for other currencies</li>
<li>many currencies</li>
<li>free</li>
</ul><h2><a href="https://web.archive.org/web/20181108145044/http://bitcoincharts.com/about/markets-api/" target="_blank">Bitcoin Charts</a></h2>
<p>Bitcoin Charts is possibly the oldest exchange API.</p>
<ul><li>custom certificate for HTTPS</li>
<li>transparent</li>
<li>wrong MIME type - should be application/json, not text/html</li>
<li>provides actual market data, including for low volume currencies, e.g. DKK, when available</li>
<li>not representitive of all markets simultaneously</li>
<li>other cryptocurrencies</li>
<li>wrong data for SLL - should be Sierra Leonean Leone, not Second Life Linden Dollar</li>
<li>every 15 mins max</li>
<li>free</li>
</ul><h2><a href="https://web.archive.org/web/20181108145044/https://bitpay.com/bitcoin-exchange-rates" target="_blank">BitPay BBB</a></h2>
<ul><li>not transparent - which exchanges?</li>
<li>only based on USD market</li>
<li>uses Open Exchange Rates for other exchanges</li>
<li>many currencies</li>
<li>provides data for Zimbabwaean Dollar, but the currency does not exist anymore</li>
<li>free</li>
</ul><h2><a href="https://web.archive.org/web/20181108145044/https://bitcoinaverage.com/api.htm" target="_blank">Bitcoin Average</a></h2>
<ul><li><a href="https://web.archive.org/web/20181108145044/https://bitcoinaverage.com/explain.htm" target="_blank">highly transaprent / representitive</a></li>
<li>utilises Open Exchange Rates</li>
<li>many currencies</li>
<li>tends to be lower valuation than bitpay</li>
<li>free</li>
</ul>

