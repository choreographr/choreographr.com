+++
title = "Regenesis"
description = "The Choreographr regenesis: ACU balances map 1:1 to CHOR on a new Polkadot SDK chain, and the phased roadmap to connect it to the Polkadot relay chain and list CHOR on Hydration."
template = "page.html"
+++

The Choreographr blockchain is being relaunched from the Acuity blockchain. This is a regenesis: a snapshot of all ACU balances is taken from Acuity and mapped **1:1 to CHOR** on a brand-new chain. No extra CHOR is created — only the CHOR that corresponds 1:1 to ACU balances comes into existence, and it is already sitting in the accounts that held it on Acuity.

The new chain is **also a Polkadot blockchain** — built with the Polkadot SDK and running proof-of-stake consensus, just as Acuity was. What the regenesis changes is the chain's identity, and the plan to connect it to the Polkadot relay chain and to a decentralized exchange.

## The road ahead

The timeline below is the plan from the snapshot to a free market for CHOR. The steps are phased, and the time estimates indicate how long each phase is expected to take. Where a step depends on an outside party — the Polkadot relay chain or the Hydration network and its governance — the timing is an indication rather than a promise.

<ul class="timeline timeline-vertical timeline-compact">

  <li>
    <div class="timeline-start font-mono text-xs uppercase text-night-400">Phase 0<br>now</div>
    <div class="timeline-middle"><div class="h-3 w-3 rounded-full bg-brand-500"></div></div>
    <div class="timeline-end timeline-box text-base">
      <div class="font-semibold text-night-50">Choreographr regenesis</div>
      <div class="mt-1 text-night-200">The ACU snapshot maps to CHOR 1:1. Existing accounts carry over directly — no claiming step.</div>
    </div>
    <hr/>
  </li>

  <li>
    <div class="timeline-start font-mono text-xs uppercase text-night-400">Phase 1<br>~1 month</div>
    <div class="timeline-middle"><div class="h-3 w-3 rounded-full bg-brand-500"></div></div>
    <div class="timeline-end timeline-box text-base">
      <div class="font-semibold text-night-50">Connect the solo chain to Polkadot</div>
      <div class="mt-1 space-y-1 text-night-200">
        <div><span class="text-brand-400">1a ·</span> Reserve a parachain ID on the relay chain (<em>~1 week</em>).</div>
        <div><span class="text-brand-400">1b ·</span> Register the chain as a parathread — submit its genesis state and runtime under that ID (<em>~2 weeks</em>).</div>
        <div><span class="text-brand-400">1c ·</span> Acquire a core via Agile Coretime — bulk coretime up to 28 days with a price-capped renewal, or on-demand (<em>~1 week</em>).</div>
        <div><span class="text-brand-400">1d ·</span> Assign the parathread to the core and launch a collator so blocks are produced continuously (<em>~1 week</em>).</div>
      </div>
      <div class="mt-2 text-night-300 text-xs">Once this is done the chain is a fully secured NPoS parachain.</div>
    </div>
    <hr/>
  </li>

  <li>
    <div class="timeline-start font-mono text-xs uppercase text-night-400">Phase 2<br>~1 month</div>
    <div class="timeline-middle"><div class="h-3 w-3 rounded-full bg-brand-500"></div></div>
    <div class="timeline-end timeline-box text-base">
      <div class="font-semibold text-night-50">Prepare CHOR for Hydration</div>
      <div class="mt-1 space-y-1 text-night-200">
        <div><span class="text-brand-400">2a ·</span> Open a bidirectional XCM (HRMP) channel between the Choreographr chain and Hydration (<em>~1–2 weeks</em>).</div>
        <div><span class="text-brand-400">2b ·</span> Register CHOR in the Hydration asset registry so it can be transferred across (<em>~1–2 weeks</em>).</div>
        <div><span class="text-brand-400">2c ·</span> Create a permissionless Hydration Isolated Pool and deposit initial liquidity — no listing fee (<em>~1 week</em>).</div>
      </div>
      <div class="mt-2 text-night-300 text-xs">CHOR is now tradable on a decentralized exchange.</div>
    </div>
    <hr/>
  </li>

  <li>
    <div class="timeline-start font-mono text-xs uppercase text-night-400">Phase 3<br>8+ months</div>
    <div class="timeline-middle"><div class="h-3 w-3 rounded-full bg-brand-500"></div></div>
    <div class="timeline-end timeline-box text-base">
      <div class="font-semibold text-night-50">Build price discovery and liquidity</div>
      <div class="mt-1 space-y-1 text-night-200">
        <div><span class="text-brand-400">3a ·</span> Grow trading volume and liquidity in the Isolated Pool (<em>continuous</em>).</div>
        <div><span class="text-brand-400">3b ·</span> Meet the Hydration DAO's criteria for an Omnipool listing: at least 8 months of price discovery, liquidity of $100k+ on a DEX, a market cap above $1M, 40%+ of supply in circulation, active community governance, and sudo/admin control removed (<em>attained during this phase</em>).</div>
        <div><span class="text-brand-400">3c ·</span> Present the project to the Hydration community and engage its governance; automated governance alerts set up to mitigate governance attacks (<em>ongoing</em>).</div>
      </div>
    </div>
    <hr/>
  </li>

  <li>
    <div class="timeline-start font-mono text-xs uppercase text-night-400">Phase 4<br>~1 month</div>
    <div class="timeline-middle"><div class="h-3 w-3 rounded-full bg-brand-500"></div></div>
    <div class="timeline-end timeline-box text-base">
      <div class="font-semibold text-night-50">List CHOR in the Hydration Omnipool</div>
      <div class="mt-1 space-y-1 text-night-200">
        <div><span class="text-brand-400">4a ·</span> Submit the listing proposal; the Hydration DAO holds a public referendum of HDX holders to approve it and set the cap (each parachain token is capped at 5% of Omnipool TVL) (<em>~2–4 weeks of voting</em>).</div>
        <div><span class="text-brand-400">4b ·</span> Deposit the initial Omnipool liquidity — a minimum $300k–$500k worth of CHOR, depending on fully diluted valuation — and the DAO passes a motion to add it and enable trading (<em>~1–2 weeks</em>).</div>
      </div>
      <div class="mt-2 text-night-300 text-xs">CHOR now sits in the deep, single-pool AMM with the best execution on Polkadot.</div>
    </div>
    <hr/>
  </li>

  <li>
    <div class="timeline-start font-mono text-xs uppercase text-night-400">Phase 5<br>ongoing</div>
    <div class="timeline-middle"><div class="h-3 w-3 rounded-full bg-brand-500"></div></div>
    <div class="timeline-end timeline-box text-base">
      <div class="font-semibold text-night-50">Deepen and sustain the market</div>
      <div class="mt-1 space-y-1 text-night-200">
        <div><span class="text-brand-400">5a ·</span> Grow the Omnipool position over time via Hydration's DCA tooling and continuous treasury participation (<em>ongoing</em>).</div>
        <div><span class="text-brand-400">5b ·</span> Renew coretime before each lease ends (price-capped) and monitor collator performance to keep the chain live (<em>recurring every 28 days</em>).</div>
      </div>
    </div>
    <hr/>
  </li>

</ul>

## Why a new chain?

Acuity was built before AI existed. Choreographr is the same publishing platform, rebuilt for the agent era: an all-purpose AI agent in Rust, a sandboxed RISC-V VM, and a decentralized publishing and coordination system that any agent or human can write to.

The content pallets, the content model (deterministic item IDs, revision history, lifecycle flags) and the off-chain indexer are carried over from Acuity, so agents can participate as first-class publishers alongside humans. But the chain is relaunched fresh — under the Choreographr name — and every balance at the moment of the snapshot is carried across as CHOR.

## Why a DEX, and why the Polkadot relay chain

Listing CHOR on a decentralized exchange — Hydration — rather than a centralized one is a deliberate choice, and a key lesson from the platform's history: MIX was **debased on a centralized exchange** in the past. On a **decentralized exchange**, no single party controls the token — liquidity lives in an on-chain pool governed by the DEX's holders, there is no central counterparty holding the supply, and the price is set by the market. This means **CHOR cannot be debased** the way MIX was.

The whole point of connecting the chain to the **Polkadot relay chain** is precisely to reach that exchange. As a parachain, Choreographr can move CHOR to Hydration over **XCM** — no bridge, and no centralized exchange in the middle.

## No extra CHOR

No additional CHOR is minted by the regenesis. Only the CHOR that corresponds 1:1 to the ACU snapshot comes into existence, and it is already sitting in the accounts that held it on Acuity.
