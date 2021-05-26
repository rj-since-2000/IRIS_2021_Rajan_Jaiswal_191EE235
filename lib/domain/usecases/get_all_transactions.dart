import 'package:dartz/dartz.dart';
import 'package:expensetracker/core/error/failures.dart';
import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:expensetracker/domain/repositories/transaction_repository.dart';

class GetAllTransactions {
  final TransactionRepository repository;

  GetAllTransactions(this.repository);

  Future<Either<Failure, List<Transaction>>> execute() async {
    return await repository.getAllTransactions();
  }
}
