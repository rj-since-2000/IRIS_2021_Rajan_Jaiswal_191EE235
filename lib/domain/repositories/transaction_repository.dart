import 'package:dartz/dartz.dart';
import 'package:expensetracker/core/error/failures.dart';
import 'package:expensetracker/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<bool> addNewTransaction(Transaction transaction);
  Future<Either<Failure, List<Transaction>>> getAllTransactions();
  Future<Either<Failure, List<Transaction>>> getTransactionsBetween(
      DateTime fromDate, DateTime tillDate);
  Future<void> deleteTransaction(int key);
}
