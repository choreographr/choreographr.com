+++
title = "Using Dapple to test Solidity with Solidity"
description = 'As the Ethereum eco-system is still very immature it can sometimes be very frustrating to develop on this platform. Gradually more tools are being developed that make it much easier, such as Browser Solidity.'
date = 2015-10-20
draft = false
template = "blog-page.html"

[taxonomies]
authors = ["Jonathan Brown"]

+++

*Originally published on jonathanpatrick.me. [Retrieved](https://web.archive.org/web/20190812051419/http://jonathanpatrick.me/blog/dapple-testing) from the Wayback Machine.*

<p>As the <a target="_blank" href="https://ethereum.org/">Ethereum</a> eco-system is still very immature it can sometimes be very frustrating to develop on this platform. Gradually more tools are being developed that make it much easier, such as <a target="_blank" href="https://web.archive.org/web/20190812051419/https://chriseth.github.io/browser-solidity/">Browser Solidity</a>.</p>
<p><a target="_blank" href="https://makerdao.com/">Maker</a> have released a new tool called <a target="_blank" href="https://github.com/NexusDevelopment/dapple">Dapple</a>. It's purpose is to provide a lot of scaffolding around dapp development. It comprises: package management, Solidity preprocessor (cog), Solidity testing, deployment and chain contexts.</p>
<p>I've been experimenting with its Solidity testing suite.</p>
<p>First of all you need to install Dapple.</p>

```
git clone https://github.com/NexusDevelopment/dapple.git
cd dapple
sudo python setup.py install
```

<p>The command `dapple` will now be available.</p>
<p>You now need to initialize your dapp as a dapple project:</p>

```
dapple init
```

<p>Then edit `.dapple/dappfile` and populate the name and version fields.</p>
<p>Now add the `.dapple` dir to your Git repo:</p>

```
git add .dapple
git commit -m "Dapplize"
```

<p>You can now start writing tests for your Solidity code. The great thing about Dapple tests is that they are written in Solidity just like the code you are testing.</p>
<p>Contracts that are tests need to inherit from the Dapple Test contract. For example:</p>

```
import "core/test.sol";

contract MyContractTest is Test {
}
```

<p>You can put your test contract in a separate file. You will then need to import the contract you are testing:</p>

```
import "my_contract.sol";
```

<p>Every function in the test contract that starts with `test` will be executed in a fresh environment. The function `setUp` will be called before each test is invoked.</p>
<p>Typically you need to instantiate the contract that you are testing:

```
MyContract myContractInstance = new MyContract();
```
  
<p>You can then make calls into the contract and use Dapple's suite of assert functions to ensure that it is operating correctly.</p>
<p>I have created a pastebin contract called Etherbin and written Dapple tests for it: <a target="_blank" href="https://web.archive.org/web/20190812051419/https://github.com/bluedroplet/etherbin-api">https://github.com/bluedroplet/etherbin-api</a></p>
<p>The tests complete in just a couple of seconds. They are run entirely in the vm and the blockchain is not utilized at all.</p>
