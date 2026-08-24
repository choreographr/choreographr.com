+++
title = "Bitcoin transaction forwarding"
description = 'Originally published on jonathanpatrick.me.'
date = 2015-02-10
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

Retrieved from the [Wayback Machine](https://web.archive.org/web/20181108133559/http://jonathanpatrick.me/blog/transaction-forwarding).

<p>Forwarding of individual Bitcoin transactions to one or more addresses is a new feature in <a target="_blank" href="https://web.archive.org/web/20181108133559/https://www.drupal.org/project/cointools">Coin Tools</a>.</p>
<p>Because it spends the outputs from the transaction that is being forwarded instead of making a regular payment from the wallet pool of unspent outputs it is not necessary to wait for confirmations before sending the new transaction. If the original transaction did not ultimately make it onto the blockchain then the forwarding transaction would also not make it onto the blockchain.</p>
<p>However, it is prudent to wait for 1 confirmation due to a problem called <a target="_blank" href="https://web.archive.org/web/20181108133559/http://www.coindesk.com/bitcoin-bug-guide-transaction-malleability/">transaction malleability</a>. When a transaction is broadcast to the Bitcoin network it has a txid to uniquely identify it. However, a mischievous actor could take the transaction and change something that wouldn't affect the digital signature but would change the txid. If this altered transaction made it onto the blockchain instead of the original version, any subsequent transactions that were referring to the original txid would be invalid.</p>
<p>If this were to occur it wouldn't cause money loss and it could be overcome my detecting it and then reissuing the subsequent transactions. A cleaner solution is to wait for one confirmation before spending the outputs. Once the transaction is on the blockchain it is extremely unlikely that the block would be replaced by one with an altered version of the transaction.</p>
<p>Transaction malleability is due to a bug in the design of Bitcoin. While it cannot now be solved completely, <a target="_blank" href="https://web.archive.org/web/20181108133559/https://github.com/bitcoin/bips/blob/master/bip-0062.mediawiki">changes</a> to the Bitcoin software have been made to lessen the impact of this problem.</p>
<p>The \Drupal\cointools_daemon\Client::forwardTransaction() method in Coin Tools allows for transactions to be forwarded to multiple addresses. Output addresses have quantities attached to them to define what ratio of the input amount is sent to each address. This is similar to how <a target="_blank" href="https://web.archive.org/web/20181108133559/https://coinsplit.io/">Coinsplit</a> operates, although they wait for 3 confirmations and may do a general wallet spend instead of forwarding the specific transaction.</p>


```php
<?php
  /**
   * Forwards a bitcoin transaction to one or more addresses with defined
   * proportionality.
   *
   * @param $txid
   *   txid of transaction to forward.
   * @param array $addresses
   *   List of addresses that can be spent from.
   * @param array $outputs
   *   Where to forward the bitcoin to.
   *   Keys are destinations addresses.
   *   Values are proportional quantities.
   * @param bool $tx_confirm_target
   *   The fee should be calculated for the transaction to reach the blockchain
   *   after this many blocks. default = 1
   *
   * @return string
   *   txid of the forwarding transaction.
   */
  public function forwardTransaction($txid, array $addresses, array $outputs, $tx_confirm_target = 1) {
    $transaction_in = $this->transactionLoad($txid);
    // Find inputs and amount for new transaction.
    $inputs = [];
    $transaction_amount = 0;
    foreach ($transaction_in['vout'] as $vout) {
      // Is this output for one of our addresses?
      if (in_array($vout['scriptPubKey']['addresses'][0], $addresses)) {
        // Has this output been spent yet?
        try {
          $this->request('gettxout', [$txid, $vout['n']]);
          $inputs[] = [
            'txid' => $txid,
            'vout' => $vout['n'],
          ];
          $transaction_amount += CoinTools::bitcoinToSatoshi($vout['value']);
        }
        catch (\Exception $e) {}
      }
    }
    // Remove the miner fee from the transaction amount.
    $transaction_amount -= $this->transactionEstimateFee(count($inputs), count($outputs));
    // Divide up the pie according to the correct proportions.
    $ratio = $transaction_amount / array_sum($outputs);
    foreach ($outputs as $address => &$amount) {
      $amount *= $ratio;
      // Eliminate dust outputs.
      if ($amount < 546) {
        unset($outputs[$address]);
        continue;
      }
      $amount = CoinTools::satoshiToBitcoin($amount);
    }
    // Make sure there is something to send.
    if (empty($outputs)) {
      throw new \Exception("No bitcoin to send.");
    }
    // Send the transaction.
    return $this->transactionSendNew($inputs, $outputs);
  }
?>
```

<p>What are the use cases of transaction forwarding?</p>
<h2>Splitting donations among different parties</h2>
<p>If a band was getting paid in Bitcoin it could be configured what percentage each band member would receive. </p>
<h2>Affiliate marketing</h2>
<p>When a sale is made, a third party who provided the lead for the sale could receive part of the funds spent.</p>
<h2>Donate percent of revenue to charity</h2>
<p>A company could provably show that they are donating a certain percentage of their revenue to a charity. If the funds are always forwarded to the same address for the charity, then a customer can observe the blockchain and check that the correct proportion of their money went to the right place.</p>
<h2>Getting funds off an insecure platform</h2>
<p>As I mentioned in an <a href="https://web.archive.org/web/20181108133559/http://jonathanpatrick.me/blog/bitcoin-ecommerce">earlier blog post</a>, holding funds in a hot-wallet on a server is not very secure. Immediately forwarding the transactions out of harms way alleviates this problem.</p>
<p>I have added support for this to Coin Tools payments. If the forwarding address is set in the payment type, payments will be forwarded to it after 1 confirmation.</p>
<p><img src="https://web.archive.org/web/20181108133559im_/http://jonathanpatrick.me/sites/default/files/forwarding-address.png" width="627" height="206" style="width: 100%; height: auto"></p>
<p>An example of this can be <a target="_blank" href="https://web.archive.org/web/20181108133559/https://www.blocktrail.com/BTC/address/1H8QNmg2KkfYt4pwm1JsQxNnyURKjUnh4L/transactions">seen on the blockchain</a>.</p>
