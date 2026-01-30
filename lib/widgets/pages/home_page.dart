import 'package:flutter/material.dart';
import '../../models/currency_data.dart';
import '../../services/currency_service.dart';
import '../../constants/app_constants.dart';
import '../components/exchange_card.dart';
import '../components/currencies_section.dart';
import '../components/cryptos_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Map<String, CurrencyData> currencyMap;
  late List<CurrencyData> popularCurrencies;
  late List<CryptoData> popularCryptos;
  Map<String, double> rates = {};
  bool isLoading = true;
  String fromCurrency = 'KZT';
  String toCurrency = 'USD';
  final TextEditingController amountController = TextEditingController(text: '100');
  double exchangeRate = 0.0023;

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
        currencyMap = {
          'KZT': CurrencyData(
            symbol: 'KZT',
            name: 'Kazakhstani Tenge',
            rate: 1.0,
            imagePath: 'assets/images/currencies/kzt.png',
            color: const Color(0xFF009900),
          ),
          'USD': CurrencyData(
            symbol: 'USD',
            name: 'US Dollar',
            rate: usdToKzt,
            imagePath: 'assets/images/currencies/usd.png',
            color: const Color(0xFF00A86B),
          ),
          'EUR': CurrencyData(
            symbol: 'EUR',
            name: 'Euro',
            rate: 1 / rates['EUR']!,
            imagePath: 'assets/images/currencies/eur.png',
            color: const Color(0xFF003399),
          ),
          'GBP': CurrencyData(
            symbol: 'GBP',
            name: 'British Pound',
            rate: 1 / rates['GBP']!,
            imagePath: 'assets/images/currencies/gbp.png',
            color: const Color(0xFF012169),
          ),
          'JPY': CurrencyData(
            symbol: 'JPY',
            name: 'Japanese Yen',
            rate: 1 / rates['JPY']!,
            imagePath: 'assets/images/currencies/jpy.png',
            color: const Color(0xFFBC002D),
          ),
          'CHF': CurrencyData(
            symbol: 'CHF',
            name: 'Swiss Franc',
            rate: 1 / rates['CHF']!,
            imagePath: 'assets/images/currencies/chf.png',
            color: const Color(0xFFFF0000),
          ),
          'CNY': CurrencyData(
            symbol: 'CNY',
            name: 'Chinese Yuan',
            rate: 1 / rates['CNY']!,
            imagePath: 'assets/images/currencies/cny.png',
            color: const Color(0xFFDE2910),
          ),
          'INR': CurrencyData(
            symbol: 'INR',
            name: 'Indian Rupee',
            rate: 1 / rates['INR']!,
            imagePath: 'assets/images/currencies/inr.png',
            color: const Color(0xFFFFA500),
          ),
          'AUD': CurrencyData(
            symbol: 'AUD',
            name: 'Australian Dollar',
            rate: 1 / rates['AUD']!,
            imagePath: 'assets/images/currencies/aud.png',
            color: const Color(0xFF003399),
          ),
        };
        popularCurrencies = [
          CurrencyData(
            symbol: 'USD',
            name: 'US Dollar',
            rate: usdToKzt,
            imagePath: 'assets/images/currencies/usd.png',
            color: const Color(0xFF00A86B),
          ),
          CurrencyData(
            symbol: 'EUR',
            name: 'Euro',
            rate: 1 / rates['EUR']!,
            imagePath: 'assets/images/currencies/eur.png',
            color: const Color(0xFF003399),
          ),
          CurrencyData(
            symbol: 'GBP',
            name: 'British Pound',
            rate: 1 / rates['GBP']!,
            imagePath: 'assets/images/currencies/gbp.png',
            color: const Color(0xFF012169),
          ),
          CurrencyData(
            symbol: 'JPY',
            name: 'Japanese Yen',
            rate: 1 / rates['JPY']!,
            imagePath: 'assets/images/currencies/jpy.png',
            color: const Color(0xFFBC002D),
          ),
        ];
        popularCryptos = [
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
        ];
        isLoading = false;
        exchangeRate = rates[toCurrency]! / rates[fromCurrency]!;
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monex',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              ExchangeCard(
                currencyMap: currencyMap,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                exchangeRate: exchangeRate,
                amountController: amountController,
                onFromCurrencyChanged: (value) => setState(() => fromCurrency = value),
                onToCurrencyChanged: (value) => setState(() => toCurrency = value),
                onSwapCurrencies: () {
                  setState(() {
                    String temp = fromCurrency;
                    fromCurrency = toCurrency;
                    toCurrency = temp;
                    exchangeRate = 1 / exchangeRate;
                  });
                },
              ),
              const SizedBox(height: 32),
              CurrenciesSection(popularCurrencies: popularCurrencies),
              const SizedBox(height: 32),
              CryptosSection(popularCryptos: popularCryptos),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}