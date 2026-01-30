import 'package:flutter/material.dart';
import '../../models/currency_data.dart';
import '../../widgets/currency_icon.dart';
import '../../utils/formatters.dart';
import '../../constants/app_constants.dart';
import '../pages/all_cryptos_page.dart';

class CryptosSection extends StatelessWidget {
  final List<CryptoData> popularCryptos;

  const CryptosSection({
    super.key,
    required this.popularCryptos,
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
          itemCount: popularCryptos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) => CryptoCard(crypto: popularCryptos[index]),
        ),
      ],
    );
  }
}

class CryptoCard extends StatelessWidget {
  final CryptoData crypto;

  const CryptoCard({
    super.key,
    required this.crypto,
  });

  @override
  Widget build(BuildContext context) {
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
                Formatters.formatPercentage(crypto.change),
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