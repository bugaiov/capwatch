# Capwatch

Watch you cryptoportfolio in a console

## Installation

    $ gem install capwatch

```bash
cat <<EOT > ~/.capwatch
{
  "name": "My Fund",
  "symbols": {
    "ETH": 10,
    "BTC": 10,
    "XRP": 1,
    "LTC": 1,
    "ETC": 1,
    "DASH": 1,
    "XEM": 1,
    "MIOTA": 1,
    "XMR": 1,
    "STRAT": 1,
    "BCC": 1,
    "EOS": 1,
    "USDT": 1,
    "ZEC": 1,
    "ANS": 1,
    "VERI": 1,
    "BTS": 1,
    "STEEM": 1,
    "BCN": 1
  }
}
EOT
```

    $ capwatch
