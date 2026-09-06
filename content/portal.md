+++
title = "Portal"
description = "The Choreographr Portal: easy access to everything you need to participate in the Choreographr chain — inference, content publication and IPFS pinning, and the Acuity Index — paid in CHOR. Non-custodial, one balance."
template = "portal.html"
+++

<!-- The human-facing copy lives in templates/portal.html. This body is the
     plain-text version served to LLM crawlers. The Portal is not built yet:
     this page describes how it will work once it is. -->

The Choreographr Portal is a single prepaid balance, denominated in USD, that
pays for the metered services of the Content network. It is funded in its
native token, CHOR, the base token of the Choreographr blockchain — a Polkadot
NPoS parachain being rebuilt from the Acuity snapshot.

The Portal is not live. It documents how portal funding will work once the
chain relaunches and the portal pallet is built. Nothing here is usable yet.

How you fund the Portal — two ways, one balance:

1. Buy credits (the default, and the simplest). Convert CHOR to USD Portal
   credits at deposit time, at the on-chain CHOR/USD rate. Credits are
   denominated in USD, are non-refundable, and never expire. No lockup, no
   position, no allowance to track — just spend them as you go. This is the
   path ordinary users reach for first.

2. Commit CHOR for a standing allowance (own your capacity). Commit CHOR in
   your own account — non-custodially reserved, so it never leaves your wallet
   — and receive a standing service allowance at a fixed published rate. Your
   commitment is never reduced by use: it is a membership right, not a
   drawdown. Release it anytime to get your CHOR back. The allowance is a
   fixed, network-backed grant, not a yield from consensus staking, and it is
   not exposed to slashing. This is the option for users who want a standing
   entitlement, not the prerequisite to use the portal.

Both feed the same USD-denominated balance, so you never have to think about
which one is being spent. Your committed allowance is used first, then your
credits.

What the balance pays for — three metered services, all priced in USD:

- Inference. Per-token (input/output) charges for the model providers the
  Choreographr agent supports.
- IPFS pinning. Per-object and per byte-month charges to guarantee content
  generated on the network stays available.
- Acuity Index. Per-query and per-subscription charges against the Choreographr
  chain's event index — the fast, searchable view of content, revisions, links,
  and reactions.

Pricing is published in USD, the same unit the underlying infrastructure (GPU
time, storage and bandwidth, indexer servers) is bought in. CHOR is the funding
and settlement token. The on-chain CHOR/USD rate is read at deposit time, so
every conversion is auditable on-chain. Credits are non-refundable by design:
because the CHOR is converted or committed at entry, the portal does not hold
user CHOR as a liability it must return.

The portal pallet is separate from the chain's consensus staking. Consensus
staking (NPoS) exists to secure the chain and pays validators and nominators
for that security. Portal access is a service entitlement, not a consensus
incentive. The two are different mechanisms and never conflated: the portal
pallet records each user's non-custodial commitment and issues a standing
allowance against it, but it never holds the CHOR — the funds stay in the
user's own account, reserved in place. The allowance is a fixed,
network-backed grant.

The Portal is the payment rail the rebuild leads to: CHOR funds the chain,
and the network's services run against it.
