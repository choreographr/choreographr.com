+++
title = "Introducing Glofile"
description = 'Glofile (Global profile) is essentially a clone of Gravatar for Ethereum.'
date = 2015-09-18
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

*Originally published on jonathanpatrick.me. [Retrieved](https://web.archive.org/web/20190831080033/http://jonathanpatrick.me/blog/introducing-glofile) from the Wayback Machine.*

<p>Glofile (<b>Glo</b>bal pro<b>file</b>) is essentially a clone of <a target="_blank" href="https://gravatar.com/">Gravatar</a> for <a target="_blank" href="https://ethereum.org/">Ethereum</a>.</p>
<p>Users of Ethereum will be accessing many different <a target="_blank" href="https://web.archive.org/web/20190831080033/http://dapps.ethercasts.com/">dapps</a> with the same account. It makes sense that they should be able to associate some basic public information with their account that can then be utilized by any dapp.</p>
<p>The following information can be stored in a Glofile:</p>
<ul><li><b>dontIndex</b> - can be set as a flag that this Glofile should not be discoverable, except by direct link</li>
<li><b>glofileType</b> - one of Anon, Person, Project, Organization, Proxy, Parody, Bot</li>
<li><b>safetyLevel</b> - safe, <a target="_blank" href="https://en.wikipedia.org/wiki/Not_safe_for_work">NSFW or NSFL</a>; the account may publish content that is less safe than this, so long as it is flagged as such</li>
<li><b>fullName</b> - the full name of the account; max 128 chars. This is different from the username, which will be handled by a dedicated registry contract.</li>
<li><b>location</b> - simple string; max 128 chars.</li>
<li><b>topics</b> - space separated string of topics that this account may be publishing under on other contracts</li>
<li><b>uris</b> - space separated string of URIs. They can be anything whatsoever relating to the account, e.g. email address, website, Facebook account, Bitcoin address.</li>
<li><b>parents</b> - space separated string of usernames of accounts that this Glofile claims to be a child of, e.g. company working for or account that is being parodied</li>
<li><b>children</b> - space separated string of usernames of accounts that this Glofile claims to be a parent of, e.g. employees</li>
<li><b>foregroundColors</b> - array of RGB triplets</li>
<li><b>backgroundColors</b> - array of RGB triplets</li>
<li><b>avatars</b> - <a target="_blank" href="https://ipfs.tech/">IPFS</a> hashes of avatar images</li>
<li><b>coverImages</b> - IPFS hashes of cover images</li>
<li><b>backgroundImages</b> - IPFS hashes of background images</li>
<li><b>bio</b> - <a target="_blank" href="https://en.wikipedia.org/wiki/Markdown">Markdown</a> string; max 256 chars. Any <a target="_blank" href="https://en.wikipedia.org/wiki/ISO_639-3">ISO 639-3</a> language code can have its own translation.</li>
<li><b>publicKeys</b> - <a target="_blank" href="https://en.wikipedia.org/wiki/Public_key_certificate">public key certificates</a> for the account owner's identity</li>
</ul><p>There are many other things that could potentially be stored in a Glofile such as personal information e.g. gender, DOB, nationality, sexuality, etc; and professional information like what would be on a resume. However, these are things that people might want to be able to have access control for. This is not the purpose of Glofile. Also, Glofiles can be for different kinds of accounts, e.g. projects and organizations. These fields would not make sense in this context. Other contracts can be utilized to store more domain-specific account data.</p>
<p>I have created a <a target="_blank" href="https://github.com/ethernomad/glofile-ethereum/blob/master/glofile.sol">prototype contract</a>, although I will move the public keys to log storage so it is more economical. Please feel free to critique it!</p>
<p>The next step is to create a JavaScript API.</p>
<p>I intend to create a dapp using <a target="_blank" href="https://web.archive.org/web/20190831080033/http://gridstylesheets.org/">GSS</a>. I really despise CSS and GSS is a much more modern layout language based on the concept of constraints that can generate CSS dynamically. <a target="_blank" href="https://web.archive.org/web/20190831080033/http://gridstylesheets.org/demos/profile-card/index.html">Here</a> is an example of what a profile can look like with GSS.</p>
<p>Once <a target="_blank" href="https://web.archive.org/web/20190831080033/https://github.com/ethereum/cpp-ethereum/wiki/Swarm">Swarm</a> is live, I will release an updated version of Glofile that uses that for image storage instead of IPFS.</p>
<p>Some of the larger string fields are compressed with <a target="_blank" href="https://en.wikipedia.org/wiki/Deflate">DEFLATE</a> before being added to contract storage. The <a target="_blank" href="https://nodeca.github.io/pako/#deflateRaw">deflateRaw</a> and <a target="_blank" href="https://nodeca.github.io/pako/#inflateRaw">inflateRaw</a> methods of <a target="_blank" href="https://github.com/nodeca/pako">pako</a> can be used for this. It tends to be beneficial for human-language strings longer than about 36 characters.</p>
<p>I hope that every dapp will be pulling in basic user info from Glofile! Anyone want to make a logo?</p>
