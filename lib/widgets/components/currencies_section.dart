import 'package:flutter/material.dart';
import '../../models/currency_data.dart';
import '../../widgets/currency_icon.dart';
import '../../utils/formatters.dart';
import '../../constants/app_constants.dart';
import '../pages/all_currencies_page.dart';

class CurrenciesSection extends StatelessWidget {
  final List<CurrencyData> popularCurrencies;

  const CurrenciesSection({
    super.key,
    required this.popularCurrencies,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: AppConstants.primaryColor,
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
          itemBuilder: (context, index) => CurrencyCard(currency: popularCurrencies[index]),
        ),
      ],
    );
  }
}

class CurrencyCard extends StatelessWidget {
  final CurrencyData currency;

  const CurrencyCard({
    super.key,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
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
  }
}