+++
title = "SMTP can be replaced by a 19 line Ethereum contract"
description = 'One of the advantages of the blockchain is that, unlike conventional Internet services, you do not have to maintain a backend in order to offer a service. You do however need to pay to write a transaction onto the blockchain.'
date = 2015-09-12
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]
+++

*Originally published on jonathanpatrick.me. [Retrieved](https://web.archive.org/web/20190917035626/http://jonathanpatrick.me/blog/ethereum-smtp) from the Wayback Machine.*

<p>One of the advantages of the blockchain is that, unlike conventional Internet services, you do not have to maintain a backend in order to offer a service. You do however need to pay to write a transaction onto the blockchain.</p>
<p>Message delivery is certainly something that can benefit hugely from the blockchain. Note that in this blog post I am talking about delivering messages to a mailbox for retrieval, not direct device to device messaging.</p>
<p>In order to implement a mailbox on <a target="_blank" href="https://ethereum.org/">Ethereum</a> in the <a target="_blank" href="https://docs.soliditylang.org/en/latest/">Solidity</a> language, this is all the code that is required:</p>

```
/**
* @title Mailbox
* @author Jonathan Brown <jbrown@bluedroplet.com>
*/
contract Mailbox {

  event Message(address indexed recipient, bytes message);

  /**
   * @notice Send message to account `recipient`.
   * @param to The address of the account to send the message to.
   * @param message The message in MIME type application/pkcs7-mime.
   */
  function send(address recipient, bytes message) {
    // Store the message in the transaction log.
    Message(recipient, message);
  }

}
```

<p>When a message is to be delivered to a specific account, it simply writes it onto the transaction log via an event. This is an order of magnitude cheaper than storing the message in contract storage.</p>
<p>As an experiment I <a target="_blank" href="http://etherscan.io/tx/0x2ddbc3c57d419cacf18fb4fd5abd8d3ac57ee2bb0c341e0814636795e7a11879">sent</a> a 5kB email using this technique.</p>
<p>It cost 0.02 ether which is currently worth ~ 0.02 USD.</p>
<p>Once <a target="_blank" href="https://www.youtube.com/watch?v=VOC45AgZG5Q">Swarm</a> is live, it will be possible to reduce storage costs even further.</p>
<p>It should be noted that many emails sent today are really just push notifications and are better suited to other Ethereum technologies such as <a target="_blank" href="https://web.archive.org/web/20190917035626/https://github.com/ethereum/wiki/wiki/Whisper">Whisper</a>.</p>
<p>The transaction ID can be considered as the unique identifier for the message.</p>
<p>The recipient can simply watch the transaction log for messages intended for them. Of course, just like with email, the messages need to be encrypted otherwise anyone can read them. <a target="_blank" href="https://en.wikipedia.org/wiki/S/MIME">S/MIME</a> can be used for this purpose in the same way as it is used for email.</p>
<p>The sender of the transaction could be considered as the sender as the message, but this leads to a loss of privacy. The sender is recorded in the message using S/MIME digital signatures. This means the transaction can originate from any address.</p>
<p>A further advantage of emailing via the blockchain is that the small fee must be paid to the network. This greatly reduces the economic incentive of spam. Client software could implement any kind of spam filter / whitelisting as normal.</p>
<p>Also, because the blockchain is decentralized, you never have to worry about the service being unavailable.</p>
