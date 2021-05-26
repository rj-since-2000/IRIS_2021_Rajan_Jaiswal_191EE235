import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    @required String description,
    @required double amount,
    @required String category,
    @required Color color,
    @required DateTime dateTime,
  }) : super(
          description: description,
          amount: amount,
          category: category,
          color: color,
          dateTime: dateTime,
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
