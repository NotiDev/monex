import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monex',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      ),
      home: const HomePage(),
    );
  }
}

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
  double exchangeRate = 0.0023; // 1 KZT = 0.0023 USD

  @override
  void initState() {
    super.initState();
    loadRates();
  }

  Future<void> loadRates() async {
    try {
      final response = await http.get(Uri.parse('https://open.er-api.com/v6/latest/KZT'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final Map<String, dynamic> ratesData = data['rates'];
        setState(() {
          rates = ratesData.map((k, v) => MapEntry(k, v.toDouble()));
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
          // Обновить exchangeRate
          exchangeRate = rates[toCurrency]! / rates[fromCurrency]!;
        });
      }
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
              _buildModernExchangeCard(),
              const SizedBox(height: 32),
              _buildCurrenciesSection(),
              const SizedBox(height: 32),
              _buildCryptosSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernExchangeCard() {
    double convertedAmount =
        (double.tryParse(amountController.text) ?? 100) * exchangeRate;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C5CE7),
            const Color(0xFF5F3DC4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Обмен',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 32,
              ),
              border: InputBorder.none,
              suffixText: fromCurrency,
              suffixStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.2),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildCurrencySelector(
                  fromCurrency,
                  (value) => setState(() => fromCurrency = value),
                  isFrom: true,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    String temp = fromCurrency;
                    fromCurrency = toCurrency;
                    toCurrency = temp;
                    exchangeRate = 1 / exchangeRate;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.swap_horiz,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCurrencySelector(
                  toCurrency,
                  (value) => setState(() => toCurrency = value),
                  isFrom: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Получите',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat('#,##0.00').format(convertedAmount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  toCurrency,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6C5CE7),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Обменять',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector(
    String value,
    Function(String) onChanged, {
    required bool isFrom,
  }) {
    return GestureDetector(
      onTap: () {
        showCurrencyModal(context, onChanged);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CurrencyIcon(
              imagePath: currencyMap[value]?.imagePath ?? 'assets/images/currencies/usd.png',
              backgroundColor: Colors.white,
              size: 32,
              backgroundOpacity: 0.2,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isFrom ? 'Из' : 'В',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.expand_more,
              color: Colors.white.withOpacity(0.6),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void showCurrencyModal(BuildContext context, Function(String) onChanged) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Currency',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 24),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: currencyMap.length,
                itemBuilder: (context, index) {
                  final currency = currencyMap.values.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onChanged(currency.symbol);
                      Navigator.pop(context);
                      setState(() {
                        if (fromCurrency == currency.symbol) {
                          exchangeRate = 1 / currency.rate;
                        } else {
                          exchangeRate = currency.rate / currencyMap[fromCurrency]!.rate;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          CurrencyIcon(
                            imagePath: currency.imagePath,
                            backgroundColor: currency.color,
                            size: 40,
                            backgroundOpacity: 0.1,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currency.symbol,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  currency.name,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${NumberFormat('#,##0.00').format(currency.rate)} KZT',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrenciesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Популярные валюты',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllCurrenciesPage(),
                  ),
                );
              },
              child: Text(
                'Показать все',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6C5CE7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: popularCurrencies.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) =>
              _buildCurrencyCard(popularCurrencies[index]),
        ),
      ],
    );
  }

  Widget _buildCurrencyCard(CurrencyData currency) {
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
            imagePath: currency.imagePath,
            backgroundColor: currency.color,
            backgroundOpacity: 0.1,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currency.symbol,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  currency.name,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${NumberFormat('#,##0.00').format(currency.rate)} KZT',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Популярные криптовалюты',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllCryptosPage(),
                  ),
                );
              },
              child: Text(
                'Показать все',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6C5CE7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: popularCryptos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _buildCryptoCard(popularCryptos[index]),
        ),
      ],
    );
  }

  Widget _buildCryptoCard(CryptoData crypto) {
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
                '${NumberFormat('#,##0').format(crypto.price)} KZT',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${crypto.change > 0 ? '+' : ''}${crypto.change.toStringAsFixed(1)}%',
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
  }
}

class CurrencyRate {
  final String symbol;
  final String name;
  final double rate;
  final String flag;

  CurrencyRate({
    required this.symbol,
    required this.name,
    required this.rate,
    required this.flag,
  });
}

class CurrencyData {
  final String symbol;
  final String name;
  final double rate;
  final String imagePath;
  final Color color;

  CurrencyData({
    required this.symbol,
    required this.name,
    required this.rate,
    required this.imagePath,
    required this.color,
  });
}

class CryptoData {
  final String symbol;
  final String name;
  final double price;
  final String imagePath;
  final double change;
  final Color color;

  CryptoData({
    required this.symbol,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.change,
    required this.color,
  });
}

// Helper widget для загрузки иконок с fallback
class CurrencyIcon extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final double size;
  final double backgroundOpacity;

  const CurrencyIcon({
    required this.imagePath,
    required this.backgroundColor,
    this.size = 50,
    this.backgroundOpacity = 0.1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(backgroundOpacity),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.asset(
          imagePath,
          width: size - 16,
          height: size - 16,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback если изображение не найдено
            return Container(
              width: size - 16,
              height: size - 16,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size / 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AllCurrenciesPage extends StatefulWidget {
  const AllCurrenciesPage({super.key});

  @override
  State<AllCurrenciesPage> createState() => _AllCurrenciesPageState();
}

class _AllCurrenciesPageState extends State<AllCurrenciesPage> {
  Map<String, double> rates = {};
  bool isLoading = true;
  late List<CurrencyData> allCurrencies;

  @override
  void initState() {
    super.initState();
    loadRates();
  }

  Future<void> loadRates() async {
    try {
      final response = await http.get(Uri.parse('https://open.er-api.com/v6/latest/KZT'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final Map<String, dynamic> ratesData = data['rates'];
        setState(() {
          rates = ratesData.map((k, v) => MapEntry(k, v.toDouble()));
          double usdToKzt = 1 / rates['USD']!;
          allCurrencies = [
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
            CurrencyData(
              symbol: 'CHF',
              name: 'Swiss Franc',
              rate: 1 / rates['CHF']!,
              imagePath: 'assets/images/currencies/chf.png',
              color: const Color(0xFFFF0000),
            ),
            CurrencyData(
              symbol: 'CNY',
              name: 'Chinese Yuan',
              rate: 1 / rates['CNY']!,
              imagePath: 'assets/images/currencies/cny.png',
              color: const Color(0xFFDE2910),
            ),
            CurrencyData(
              symbol: 'INR',
              name: 'Indian Rupee',
              rate: 1 / rates['INR']!,
              imagePath: 'assets/images/currencies/inr.png',
              color: const Color(0xFFFFA500),
            ),
            CurrencyData(
              symbol: 'AUD',
              name: 'Australian Dollar',
              rate: 1 / rates['AUD']!,
              imagePath: 'assets/images/currencies/aud.png',
              color: const Color(0xFF003399),
            ),
            CurrencyData(
              symbol: 'CAD',
              name: 'Canadian Dollar',
              rate: 1 / rates['CAD']!,
              imagePath: 'assets/images/currencies/cad.png',
              color: const Color(0xFFFF0000),
            ),
          ];
          isLoading = false;
        });
      }
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
          title: const Text('All Currencies'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Currencies'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: allCurrencies.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final currency = allCurrencies[index];
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
                  imagePath: currency.imagePath,
                  backgroundColor: currency.color,
                  backgroundOpacity: 0.1,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currency.symbol,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        currency.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${NumberFormat('#,##0.00').format(currency.rate)} KZT',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

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
      final response = await http.get(Uri.parse('https://open.er-api.com/v6/latest/KZT'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final Map<String, dynamic> ratesData = data['rates'];
        setState(() {
          rates = ratesData.map((k, v) => MapEntry(k, v.toDouble()));
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
      }
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
                      '${NumberFormat('#,##0').format(crypto.price)} KZT',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${crypto.change > 0 ? '+' : ''}${crypto.change.toStringAsFixed(1)}%',
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
