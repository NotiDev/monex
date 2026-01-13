# Структура иконок для Monex

## Инструкции по добавлению иконок

### Для валют (assets/images/currencies/)
Добавьте PNG или SVG иконки с следующими именами:

```
assets/images/currencies/
├── kzt.png         # Казахстанский тенге
├── usd.png         # Доллар США
├── eur.png         # Евро
├── gbp.png         # Британский фунт
├── jpy.png         # Японская йена
├── chf.png         # Швейцарский франк
├── cny.png         # Китайский юань
├── inr.png         # Индийская рупия
├── aud.png         # Австралийский доллар
└── cad.png         # Канадский доллар
```

### Для криптовалют (assets/images/cryptos/)
Добавьте PNG или SVG иконки с следующими именами:

```
assets/images/cryptos/
├── btc.png         # Bitcoin
├── eth.png         # Ethereum
├── bnb.png         # Binance Coin
├── ada.png         # Cardano
├── sol.png         # Solana
├── doge.png        # Dogecoin
├── ltc.png         # Litecoin
└── link.png        # Chainlink
```

## Требования к иконкам:
- Формат: PNG или SVG (рекомендуется PNG для лучшей совместимости)
- Размер: 64x64px или больше
- Прозрачный фон (RGBA или ARGB)
- Единый стиль

## Рекомендуемые источники иконок:
- CoinGecko API (https://www.coingecko.com/)
- CryptoCompare (https://www.cryptocompare.com/)
- Flagicons (https://flagicons.css.in/) - для флагов валют
- Flaticon (https://www.flaticon.com/)

## Fallback
Если иконка не найдена, приложение автоматически покажет серый квадрат с "?" символом.
