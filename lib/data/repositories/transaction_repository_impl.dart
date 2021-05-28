import 'package:expensetracker/core/error/exceptions.dart';
import 'package:expensetracker/data/datasources/transaction_local_data_source.dart';
import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:expensetracker/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:expensetracker/domain/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({@required this.localDataSource});

  @override
  Future<bool> addNewTransaction(Transaction transaction) async {
    try {
      await localDataSource.addNewTransaction(transaction);
      return true;
    } on CacheException {
      return false;
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions() async {
    try {
      final allTransactions = await localDataSource.getAllTransactions();
      return Right(allTransactions);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsBetween(
      DateTime fromDate, DateTime tillDate) async {
    try {
      final filteredTransactions =
          await localDataSource.getTransactionsBetween(fromDate, tillDate);
      return Right(filteredTransactions);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<void> deleteTransaction(int key) async {
    await localDataSource.deleteTransaction(key);
  }
}
