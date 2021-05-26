import 'package:dartz/dartz.dart';
import 'package:expensetracker/core/error/failures.dart';
import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:expensetracker/domain/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';

class GetTransactionsBetween {
  final TransactionRepository repository;

  GetTransactionsBetween(this.repository);

  Future<Either<Failure, List<Transaction>>> execute({
    @required DateTime fromDate,
    @required DateTime tillDate,
  }) async {
    return await repository.getTransactionsBetween(fromDate, tillDate);
  }
}
