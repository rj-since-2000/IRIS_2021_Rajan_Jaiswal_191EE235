import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Transaction extends Equatable {
  final String description;
  final double amount;
  final String category;
  final Color color;
  final DateTime dateTime;

  Transaction({
    @required this.description,
    @required this.amount,
    @required this.category,
    @required this.color,
    @required this.dateTime,
  }) : super([description, amount, category, color, dateTime]);
}
