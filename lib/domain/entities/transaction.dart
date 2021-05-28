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
  final int amount;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final String colorHex;
  @HiveField(4)
  final DateTime dateTime;
  @HiveField(5)
  final int key;

  Transaction({
    @required this.description,
    @required this.amount,
    @required this.category,
    @required this.colorHex,
    @required this.dateTime,
    this.key,
  });

  @override
  // TODO: implement props
  List<Object> get props =>
      [description, amount, category, colorHex, dateTime, key];
}
