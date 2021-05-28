import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:expensetracker/domain/usecases/add_new_transaction.dart';
import 'package:expensetracker/domain/usecases/get_all_transactions.dart';
import 'package:expensetracker/domain/usecases/get_transactions_between.dart';
import 'package:expensetracker/domain/usecases/delete_transaction.dart';

import 'package:flutter/material.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

const String CACHE_FAILURE_MESSAGE = 'Cache Failure';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final AddNewTransaction addNewTransaction;
  final GetAllTransactions getAllTransactions;
  final GetTransactionsBetween getTransactionsBetween;
  final DeleteTransaction deleteTransaction;

  TransactionsBloc({
    @required AddNewTransaction newTransaction,
    @required GetAllTransactions allTransactions,
    @required GetTransactionsBetween transactionsBetween,
    @required DeleteTransaction delete,
  })  : assert(newTransaction != null),
        addNewTransaction = newTransaction,
        getAllTransactions = allTransactions,
        getTransactionsBetween = transactionsBetween,
        deleteTransaction = delete;

  @override
  TransactionsState get initialState {
    return InitialTransactionsState(transactions: []);
  }

  @override
  Stream<TransactionsState> mapEventToState(
    TransactionsEvent event,
  ) async* {
    if (event is AddNewTransactionEvent) {
      yield Loading();
      final success =
          await addNewTransaction.execute(transaction: event.transaction);
      if (success)
        yield Success();
      else
        yield Error(message: CACHE_FAILURE_MESSAGE);
    } else if (event is GetAllTransactionsEvent) {
      yield Loading();
      final failureOrTransactions = await getAllTransactions.execute();
      yield failureOrTransactions.fold(
        (failure) {
          return Error(message: CACHE_FAILURE_MESSAGE);
        },
        (transactions) {
          if (transactions.isNotEmpty)
            return Loaded(
              transactions: transactions,
              filtered: false,
              fromDate: DateTime.now().subtract(Duration(days: 30)),
              tillDate: DateTime.now(),
            );
          else
            return Empty();
        },
      );
    } else if (event is GetTransactionsBetweenEvent) {
      yield Loading();
      final failureOrTransactions = await getTransactionsBetween.execute(
          fromDate: event.fromDate, tillDate: event.tillDate);
      yield failureOrTransactions.fold(
        (failure) => Error(message: CACHE_FAILURE_MESSAGE),
        (transactions) => Loaded(
          transactions: transactions,
          filtered: true,
          fromDate: event.fromDate,
          tillDate: event.tillDate,
        ),
      );
    } else if (event is DeleteTransactionEvent) {
      yield Loading();
      await deleteTransaction.execute(key: event.key);
      final failureOrTransactions = await getAllTransactions.execute();
      yield failureOrTransactions.fold(
        (failure) {
          return Error(message: CACHE_FAILURE_MESSAGE);
        },
        (transactions) {
          if (transactions.isNotEmpty)
            return Loaded(
              transactions: transactions,
              filtered: false,
              fromDate: DateTime.now().subtract(Duration(days: 30)),
              tillDate: DateTime.now(),
            );
          else
            return Empty();
        },
      );
    }
  }
}
