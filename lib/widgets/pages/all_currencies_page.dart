import 'package:flutter/material.dart';
import '../../models/currency_data.dart';
import '../../widgets/currency_icon.dart';
import '../../services/currency_service.dart';
import '../../utils/formatters.dart';

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
      rates = await CurrencyService.fetchRates();
      setState(() {
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
                  '${Formatters.formatCurrency(currency.rate)} KZT',
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