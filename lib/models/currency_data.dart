import 'package:flutter/material.dart';

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