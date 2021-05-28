part of 'transactions_bloc.dart';

abstract class TransactionsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddNewTransactionEvent extends TransactionsEvent {
  final Transaction transaction;

  AddNewTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class GetAllTransactionsEvent extends TransactionsEvent {}

class GetTransactionsBetweenEvent extends TransactionsEvent {
  final DateTime fromDate;
  final DateTime tillDate;

  GetTransactionsBetweenEvent(this.fromDate, this.tillDate);

  @override
  List<Object> get props => [fromDate, tillDate];
}

class DeleteTransactionEvent extends TransactionsEvent {
  final int key;

  DeleteTransactionEvent(this.key);

  @override
  List<Object> get props => [key];
}
