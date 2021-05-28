import 'package:expensetracker/core/error/exceptions.dart';
import 'package:expensetracker/data/models/transaction_model.dart';
import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:hive/hive.dart';

abstract class TransactionLocalDataSource {
  Future<void> addNewTransaction(Transaction transaction);
  Future<List<Transaction>> getAllTransactions();
  Future<List<Transaction>> getTransactionsBetween(
      DateTime fromDate, DateTime tillDate);
  Future<void> deleteTransaction(int key);
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final box = Hive.box<Transaction>('transactions');

  @override
  Future<void> addNewTransaction(Transaction transaction) async {
    int key = -1;
    key = await box.add(null);
    box.put(
      key,
      Transaction(
        description: transaction.description,
        amount: transaction.amount,
        category: transaction.category,
        colorHex: transaction.colorHex,
        dateTime: transaction.dateTime,
        key: key,
      ),
    );
    print(key);
    if (key < 0) {
      throw CacheException();
    }
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    final transactions = box.values.toList();
    return transactions;
  }

  @override
  Future<List<Transaction>> getTransactionsBetween(
      DateTime fromDate, DateTime tillDate) async {
    return box.values
        .where((transaction) =>
            transaction.dateTime
                .isAfter(fromDate.subtract(Duration(days: 1))) &&
            transaction.dateTime.isBefore(tillDate.add(Duration(days: 1))))
        .toList();
  }

  @override
  Future<void> deleteTransaction(int key) async {
    return await box.delete(key);
  }
}
