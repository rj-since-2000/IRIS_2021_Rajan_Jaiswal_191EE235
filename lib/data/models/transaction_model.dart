import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    @required String description,
    @required int amount,
    @required String category,
    @required String colorHex,
    @required DateTime dateTime,
    int key,
  }) : super(
          description: description,
          amount: amount,
          category: category,
          colorHex: colorHex,
          dateTime: dateTime,
          key: key,
        );
  // factory TransactionModel.fromHiveBox(Transaction t) {
  //   return TransactionModel(
  //     description: t.description,
  //     amount: t.amount,
  //     category: t.category,
  //     color: t.color,
  //     dateTime: t.dateTime,
  //   );
  // }
}
