import 'package:expensetracker/domain/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';

class DeleteTransaction {
  final TransactionRepository repository;

  DeleteTransaction(this.repository);

  Future<void> execute({
    @required int key,
  }) async {
    return await repository.deleteTransaction(key);
  }
}
