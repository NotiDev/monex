import 'package:flutter/material.dart';
import '../../models/currency_data.dart';
import '../../widgets/currency_icon.dart';
import '../../services/currency_service.dart';
import '../../utils/formatters.dart';

class AllCryptosPage extends StatefulWidget {
  const AllCryptosPage({super.key});

  @override
  State<AllCryptosPage> createState() => _AllCryptosPageState();
}

class _AllCryptosPageState extends State<AllCryptosPage> {
  Map<String, double> rates = {};
  bool isLoading = true;
  late List<CryptoData> allCryptos;

  @override
  void initState() {
    super.initState();
    loadRates();
  }

  Future<void> loadRates() async {
    try {
      rates = await CurrencyService.fetchRates();
      setState(() {
        double usdToKzt = 1 / rates['USD']!;
        allCryptos = [
          CryptoData(
            symbol: 'BTC',
            name: 'Bitcoin',
            price: 1835.50 * usdToKzt,
            imagePath: 'assets/images/cryptos/btc.png',
            change: 2.5,
            color: const Color(0xFFF7931A),
          ),
          CryptoData(
            symbol: 'ETH',
            name: 'Ethereum',
            price: 2250.00 * usdToKzt,
            imagePath: 'assets/images/cryptos/eth.png',
            change: 3.2,
            color: const Color(0xFF627EEA),
          ),
          CryptoData(
            symbol: 'BNB',
            name: 'Binance Coin',
            price: 612.00 * usdToKzt,
            imagePath: 'assets/images/cryptos/bnb.png',
            change: -1.2,
            color: const Color(0xFFF3BA2F),
          ),
          CryptoData(
            symbol: 'ADA',
            name: 'Cardano',
            price: 0.98 * usdToKzt,
            imagePath: 'assets/images/cryptos/ada.png',
            change: 1.8,
            color: const Color(0xFF0033A0),
          ),
          CryptoData(
            symbol: 'SOL',
            name: 'Solana',
            price: 195.50 * usdToKzt,
            imagePath: 'assets/images/cryptos/sol.png',
            change: 4.1,
            color: const Color(0xFF14F195),
          ),
          CryptoData(
            symbol: 'DOGE',
            name: 'Dogecoin',
            price: 0.42 * usdToKzt,
            imagePath: 'assets/images/cryptos/doge.png',
            change: -2.3,
            color: const Color(0xFFC1A93F),
          ),
          CryptoData(
            symbol: 'LTC',
            name: 'Litecoin',
            price: 128.75 * usdToKzt,
            imagePath: 'assets/images/cryptos/ltc.png',
            change: 1.5,
            color: const Color(0xFF345D9D),
          ),
          CryptoData(
            symbol: 'LINK',
            name: 'Chainlink',
            price: 28.50 * usdToKzt,
            imagePath: 'assets/images/cryptos/link.png',
            change: 2.9,
            color: const Color(0xFF375BD2),
          ),
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('All Cryptocurrencies'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Cryptocurrencies'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: allCryptos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final crypto = allCryptos[index];
          Color changeColor = crypto.change >= 0 ? Colors.green : Colors.red;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100, width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CurrencyIcon(
                  imagePath: crypto.imagePath,
                  backgroundColor: crypto.color,
                  backgroundOpacity: 0.1,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crypto.symbol,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        crypto.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${Formatters.formatCryptoPrice(crypto.price)} KZT',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${crypto.change > 0 ? '+' : ''}${Formatters.formatPercentage(crypto.change)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}