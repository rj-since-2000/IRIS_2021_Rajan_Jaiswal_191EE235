import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends Equatable {
  @HiveField(0)
  final String description;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final Color color;
  @HiveField(4)
  final DateTime dateTime;

  Transaction({
    @required this.description,
    @required this.amount,
    @required this.category,
    @required this.color,
    @required this.dateTime,
  }) : super([description, amount, category, color, dateTime]);
}
