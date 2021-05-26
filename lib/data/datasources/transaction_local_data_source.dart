import 'package:expensetracker/core/error/exceptions.dart';
import 'package:expensetracker/data/models/transaction_model.dart';
import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:hive/hive.dart';

abstract class TransactionLocalDataSource {
  Future<void> addNewTransaction(Transaction transaction);
  Future<List<TransactionModel>> getAllTransactions();
  Future<List<TransactionModel>> getTransactionsBetween(
      DateTime fromDate, DateTime tillDate);
}

class TransactionLocalDatabaseSourceImpl implements TransactionLocalDataSource {
  final box = Hive.box('transactions');

  @override
  Future<void> addNewTransaction(Transaction transaction) async {
    int key = -1;
    key = await box.add(transaction);
    if (key >= 0) {
      return;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return box.values.toList();
  }

  @override
  Future<List<TransactionModel>> getTransactionsBetween(
      DateTime fromDate, DateTime tillDate) async {
    return box.values
        .where((transaction) =>
            transaction.dateTime.isAfter(fromDate) &&
            transaction.dateTime.isBefore(tillDate))
        .toList();
  }
}
