+++
title = "Drupal / Bitcoin BIP 70 / PKI certificates"
description = 'Originally published on jonathanpatrick.me.'
date = 2014-11-03
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

Retrieved from the [Wayback Machine](https://web.archive.org/web/20181114005103/http://jonathanpatrick.me/blog/bip70-pki-drupal).

<a href="https://web.archive.org/web/20181114005103/https://github.com/bitcoin/bips/blob/master/bip-0070.mediawiki" target="_blank">BIP 70</a> provides a mechanism so that a customer can be sure that they are sending a Bitcoin payment to the correct place. Before BIP 70, the customer would simply be presented with a Bitcoin address to send the amount to. This address could potentially be tampered with so the funds get sent to someone else. It is also not very user-friendly to be sending money to a random collection of letters and numbers.</p>
<p>Now public key infrastructure (<a href="https://web.archive.org/web/20181114005103/https://en.wikipedia.org/wiki/Public_key_infrastructure" target="_blank">PKI</a>) is used to present the customer with cryptographic proof that they are making the correct payment. The payment information that the Bitcoin wallet receives is supplied with a certificate and is digitally signed. The wallet can then present a "human-readable, secure payment destination" to the customer, i.e. the name of the company or a verified email address.</p>
<p>This functionality is now implemented in <a href="https://web.archive.org/web/20181114005103/https://www.drupal.org/project/cointools" target="_blank">Coin Tools</a>.</p>
<p>To start using it you need to obtain a certificate. The easiest way to do this is to create a free account at <a href="https://web.archive.org/web/20181114005103/https://www.startssl.com/" target="_blank">StartSSL</a>. Once they have verified that you own your email address they will put a certificate to this effect into your web browser.</p>
<p>You need to extract this certificate (and private key). Here is how to do it using Firefox, but other browsers are similar. First you need to view your certificates.</p>
<p><img src="/blog/view-certificates.png" width="648" height="332" style="width: 100%; height: auto;"></p>
<p>Then backup the certificate for your email address provided by StartCom Ltd.</p>
<p><img src="/blog/backup.png" width="656" height="322" style="width: 100%; height: auto;"></p>
<p>Make sure you save the file with .p12 extension, i.e. jbrown@bluedroplet.com.p12 - P12 is an "archive file format for storing cryptographic objects like private keys and certificates." You will be prompted for a password to encrypt this file.</p>
<p><img src="/blog/certificate-password.png" width="559" height="394" style="width: 100%; height: auto;"></p>
<p>Next you need to extract your certificate and public key from this file like so:</p>

```
openssl pkcs12 -in jbrown@bluedroplet.com.p12 -clcerts -nokeys -out publicCert.pem
openssl pkcs12 -in jbrown@bluedroplet.com.p12 -nocerts -out privateKey.pem
```

<p>Each of these commands will require you to enter the password you encrypted the P12 file with. When extracting the private key you must provide a passphrase it should be encrypted with.</p>
<p>Next you need to add the certificate to your payment type (or create a new one). With the latest version of Coin Tools 8.x-1.x there are additional fields on the payment type form for this. Paste the contents of publicCert.pem into the "Certificate" field.</p>
<p><img src="/blog/certificate-field.png" width="850" height="555" style="width: 100%; height: auto;"></p>
<p>And paste the contents of privateKey.pem into the "Private key" field. Select "Private key is encrypted" and enter the passphrase you encrypted it with.</p>
<p><img src="/blog/password-field.png" width="881" height="418" style="width: 100%; height: auto;"></p>
<p>When making a payment, the customer's wallet will now display the certificate's Common Name. In this case it is a verified email address.</p>
<p><img src="/blog/android-before-pki.png" width="270" height="480" style="width: 50%; height: auto;"><img src="/blog/android-after-pki.png" width="270" height="480" style="width: 50%; height: auto;">
