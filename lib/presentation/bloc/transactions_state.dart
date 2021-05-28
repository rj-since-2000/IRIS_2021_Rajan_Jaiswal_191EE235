part of 'transactions_bloc.dart';

abstract class TransactionsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialTransactionsState extends TransactionsState {
  final List<Transaction> transactions;

  InitialTransactionsState({@required this.transactions});

  @override
  List<Object> get props => [transactions];
}

class Empty extends TransactionsState {}

class Loading extends TransactionsState {}

class Loaded extends TransactionsState {
  final List<Transaction> transactions;
  final bool filtered;
  final DateTime fromDate;
  final DateTime tillDate;

  Loaded({
    @required this.transactions,
    @required this.filtered,
    this.fromDate,
    this.tillDate,
  });

  @override
  List<Object> get props => [transactions, filtered, fromDate, tillDate];
}

class Error extends TransactionsState {
  final String message;

  Error({@required this.message});

  @override
  List<Object> get props => [message];
}

class Success extends TransactionsState {}
