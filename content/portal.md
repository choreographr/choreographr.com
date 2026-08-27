+++
title = "Portal"
description = "The Choreographr Portal: fund the platform with CHOR — by staking for a rolling service allowance, or by converting CHOR to USD credits — and spend a single USD balance on inference, IPFS pinning, and the Acuity Index."
template = "portal.html"
+++

<!-- The human-facing copy lives in templates/portal.html. This body is the
     plain-text version served to LLM crawlers. The Portal is not built yet:
     this page describes how it will work once it is. -->

The Choreographr Portal is a single prepaid balance, denominated in USD, that
pays for the metered services of the Choreographr platform. It is funded in its
native token, CHOR, the base token of the Choreographr blockchain — a Polkadot
NPoS parachain being rebuilt from the Acuity snapshot.

The Portal is not live. It documents how portal funding will work once the
chain relaunches and the portal pallet is built. Nothing here is usable yet.

How you fund the Portal — two ways, one balance:

1. Stake CHOR in the portal pallet. You receive a rolling free-service allowance
   proportional to the amount staked, issued at a fixed published rate. Your
   stake is never reduced by use — it is a membership right, not a drawdown. You
   can unstake at any time (with a cooldown) to recover your CHOR. The allowance
   is a recurring, yield- and revenue-funded subsidy; unused allowance does not
   carry over between periods.

2. Convert CHOR to Portal credits at deposit time, at the on-chain CHOR/USD
   rate. Credits are denominated in USD, are non-refundable, and never expire.
   There is no lockup and no position — the low-friction way to start.

Both feed the same USD-denominated credit balance. When you spend, the free
stake allowance is drawn down first, then your credits.

What the balance pays for — three metered services, all priced in USD:

- Inference. Per-token (input/output) charges for the model providers the
  Choreographr agent supports.
- IPFS pinning. Per-object and per byte-month charges to guarantee content
  generated on the platform stays available.
- Acuity Index. Per-query and per-subscription charges against the Choreographr
  chain's event index — the fast, searchable view of content, revisions, links,
  and reactions.

Pricing is published in USD, the same unit the underlying infrastructure (GPU
time, storage and bandwidth, indexer servers) is bought in. CHOR is the funding
and settlement token. The on-chain CHOR/USD rate is read at deposit time, so
every conversion is auditable on-chain.

The portal pallet is separate from the chain's consensus staking. Consensus
staking (NPoS) exists to secure the chain and pays validators and nominators
for that security. Portal access is a service entitlement, not a consensus
incentive. The two are different mechanisms and never conflated: the portal
pallet holds CHOR locked by users for an allowance receipt, while the yield
that backs the free allowance comes from running that CHOR through the chain's
NPoS system.

Credits are non-refundable by design: because the CHOR is converted or staked
at entry, the Portal does not hold user CHOR as a liability it must return. The
agent can set per-API-key spend caps so a single integration cannot exhaust a
whole balance, and requests that would exceed the remaining balance are
rejected with an insufficient-balance error.

The Portal is the payment rail the rebuild leads to: CHOR funds the platform,
and the platform's services run against it.
