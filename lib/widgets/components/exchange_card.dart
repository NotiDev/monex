import 'package:flutter/material.dart';
import '../../models/currency_data.dart';
import '../../widgets/currency_icon.dart';
import '../../utils/formatters.dart';
import '../../constants/app_constants.dart';

class ExchangeCard extends StatefulWidget {
  final Map<String, CurrencyData> currencyMap;
  final String fromCurrency;
  final String toCurrency;
  final double exchangeRate;
  final TextEditingController amountController;
  final Function(String) onFromCurrencyChanged;
  final Function(String) onToCurrencyChanged;
  final VoidCallback onSwapCurrencies;

  const ExchangeCard({
    super.key,
    required this.currencyMap,
    required this.fromCurrency,
    required this.toCurrency,
    required this.exchangeRate,
    required this.amountController,
    required this.onFromCurrencyChanged,
    required this.onToCurrencyChanged,
    required this.onSwapCurrencies,
  });

  @override
  State<ExchangeCard> createState() => _ExchangeCardState();
}

class _ExchangeCardState extends State<ExchangeCard> {
  @override
  Widget build(BuildContext context) {
    double convertedAmount =
        (double.tryParse(widget.amountController.text) ?? 100) * widget.exchangeRate;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor,
            const Color(0xFF5F3DC4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withOpacity(0.3),
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
            controller: widget.amountController,
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
              suffixText: widget.fromCurrency,
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
                  widget.fromCurrency,
                  widget.onFromCurrencyChanged,
                  isFrom: true,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: widget.onSwapCurrencies,
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
                  widget.toCurrency,
                  widget.onToCurrencyChanged,
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
                      Formatters.formatCurrency(convertedAmount),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.toCurrency,
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
                foregroundColor: AppConstants.primaryColor,
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
      onTap: () => _showCurrencyModal(context, onChanged),
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
              imagePath: widget.currencyMap[value]?.imagePath ?? 'assets/images/currencies/usd.png',
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

  void _showCurrencyModal(BuildContext context, Function(String) onChanged) {
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
                itemCount: widget.currencyMap.length,
                itemBuilder: (context, index) {
                  final currency = widget.currencyMap.values.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      onChanged(currency.symbol);
                      Navigator.pop(context);
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
                            '${Formatters.formatCurrency(currency.rate)} KZT',
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
}