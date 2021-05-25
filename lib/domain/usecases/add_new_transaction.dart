import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:expensetracker/domain/repositories/transaction.dart';
import 'package:flutter/material.dart';

class AddNewTransaction {
  final TransactionRepository repository;

  AddNewTransaction(this.repository);

  Future<bool> execute({
    @required Transaction transaction,
  }) async {
    return await repository.addNewTransaction(transaction);
  }
}
