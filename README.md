# my-cryptos-cli

![Imgur](https://i.imgur.com/G7cBm5b.png)

CLI for your tracking cryptos prices

# Installation

Either through cloning with git or by using [yarn](https://yarnpkg.com/en/docs/install) (the recommended way):

```bash
yarn global add my-cryptos-cli
```

And my-cryptos-cli will be installed globally to your system path.

# Usage

my-cryptos-cli displays your cryptos prices, so you can pass all the cryptos to coins argument:

```bash
my-cryptos --coins=BTC,ETH,XRP
```

For pricing in your fav currencies:

```bash
my-cryptos --coins=BTC,ETH --currs=INR,USD
```

For continuous price updates:

```bash
my-cryptos --coins=BTC,ETH --currs=INR --watch
```

## Development Guide

#### NOTE : Please make sure you have yarn :: [Installing yarn](https://yarnpkg.com/en/docs/install)

* Initial setup

```bash
$ yarn install && yarn setup
```

* To run project

```bash
$ yarn start
```