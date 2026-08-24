+++
title = "Features"
description = ""
date = 2025-04-25T08:00:00+00:00
updated = 2025-04-25T08:00:00+00:00
draft = false
weight = 30
template = "platform-doc.html"

+++

All of these features have already been implemented in the Acuity Browser running on MIX Blockchain and will be ported in full to the new Acuity Substrate-based blockchain.

## Permanent

Existing centralized social media platforms are highly unreliable as an historical record. Blockchain based social media platforms solve this problem. Everytime a content item is published or updated on Acuity it is timestamped and the <a target="_blank" href="https://ipfs.io/">IPFS</a> hash is stored in contract state. This is an extremely powerful property of the system. In hundreds of years time people will be able to examine the blockchain and know who said what when and to whom.

## Content Revisioning

When an item of content is published on Acuity the actual content is stored on IPFS and the IPFS hash is written into the blockchain. If the content author wishes to create a new revison the new version will be published on IPFS and receive a new IPFS hash. This hash is then also stored on the blockchain. This means full history of content edits is preserved on the blockchian.

More sophisticated content systems, like a wiki, might not use this facility and store each revision as an Acuity individual content item.

## Comments

Any content item can be a reply to another item and the comment hierarchy is maintained in contract state. Of course which comments a user can see can be entirely controlled by the filter bubble they choose to use. See Trust Accounts below.

[video](https://www.youtube.com/watch?v=WdkBjd2bPBY)

## Feeds

One of the big problems with Twitter is that each account can only publish to one feed. This means that an account might have a broad range of accounts that are following it for different reasons. When you want to publish something you might be aware of the broadness of your audience and only publish what you think will be received well or understood by the majority audience and tailor your message to the lowest common denominator. This reduces the ability of the platform to facilitate effective discussion.

The solution is very simple: allow accounts to have more than one feed. Feeds can be subscribed to individually and Content can be published to multiple feeds simultaneously if necessary.

## Trusted Accounts

A common problem on platforms like Twitter is that it is difficult to control whose content you can see. Anyone can mention you unless you specifically block them. This is very unnatural - in the physical world only those physically near us can communicate with us. Controlling who is around us enables us to control who can communicate with us.

Acuity has a very simple system for who gets to see what: Trusted Accounts. Each account maintains a public list of other accounts that they trust. When potentially viewing any piece of content it will be filtered through Trusted Accounts. For a piece of content to be downloaded to your device and displayed on your screen it must have been published either from someone you trust directly, or someone you trust trusts that account.

This means that everyone is curating a public list of accounts they trust. If you are a poor curator of accounts then others will not add you to their list of trusted accounts.

[video](https://www.youtube.com/watch?v=j8WfGYxBERo)

## Video

Videos published on Acuity are transcoded from the source video into multiple resolutions of H.264 video. This codec is high quality, very fast to encode and highly compatible. Transcoding can occur locally on the device or on your server using <a target="_blank" href="https://www.ffmpeg.org/">FFmpeg</a>, or with a SaaS solution such as Encoding.com.

Each encoding of the video, and optionally the source video, is then stored in IPFS. Subscribers to your content will then "pin" the files to pull them to their devices. Additionally <a target="_blank" href="https://filecoin.io/">Filecoin</a> can be used to pay to make sure your videos are available. Centralized services such as <a target="_blank" href="https://pinata.cloud/">Pinata</a> can also be used.

Videos published on other services can be synchronized to Acuity using the extremely powerful <a target="_blank" href="http://ytdl-org.github.io/youtube-dl/about.html">youtube-dl</a>.

Because a video is just another Acuity content item it supports revisioning. This means videos can be updated.

[video](https://www.youtube.com/watch?v=K_NSdHzQFdk)

## Anonymous Browsing

When browsing a regular website, the operators of the website can track everything you see. For example, YouTube have a permanent record of everything you have watched.

Acuity is different. It reads data from the Acuity blockchain (as a light client), and from IPFS. Both these technologies are decentralized and do not have a controlling entity that could spy on your browsing.

## Programmatic Access

To read from or write to Acuity it is necessary to communicate with both the Acuity Blockchain and IPFS, typically via the Acuity API JavaScript library. This is how the Acuity Browser works. Unlike the APIs of other centralized platforms, no single authority has the ability to change them or regulate access.

## Creator Funding / Ungameable Metrics

To create a sustainable ecosystem on Acuity it is essential that content creators can generate revenue. Ideally this would not involve paywalls or advertising. Additionally, it is very important to determine how much each content item is appreciated by the community. Of course these are two sides of the same coin.

Here's how it works:
<ul>
  <li>Content creators get paid in their own brand token.</li>
  <li>Fans of the creator can burn the creator\'s token conspicuously to prove to their peers that they are real fans.</li>
  <li>This creates demand for the token so the content creator can sell it. The the community likes their work, the more revenue the content creator will make.</li>
  <li>Content creators can be ranked against each other based on the value of their token that is being burned.</li>
  <li>Instead of burning a creator token generally, a fan can burn it in association with a specific content item. This will encourage the fan to burn more overall and also means that the appreciation metric can be specific to the content item.</li>
</ul>

[video](https://www.youtube.com/watch?v=wY8pAahyIw4)

## Low Latency Complex Blockchain Queries

Complex dapps such as Acuity Browser need to make many blockchain queries before content can be rendered. Often these queries cannot be parallelized. If an individual query takes 200ms and 20 queries need to be made in series then it will take 4 seconds before the screen can be updated. This is far to long. The solution is to implement complex query logic in stateless smart contracts.

## Acuity Browser

The primary way to interact with the Acuity platform is via the Acuity Browser. Much like a web browser, Acuity Browser does not connect to any centralized service and it enables the user to browse any content that has been published. All of the base functionality of Acuity is available in the Browser. It is available as a web app, a desktop app and an Android app.

[video](https://www.youtube.com/watch?v=eXWDjq6pkSg)
