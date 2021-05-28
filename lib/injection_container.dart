import 'package:expensetracker/data/datasources/transaction_local_data_source.dart';
import 'package:expensetracker/data/repositories/transaction_repository_impl.dart';
import 'package:expensetracker/domain/repositories/transaction_repository.dart';
import 'package:expensetracker/domain/usecases/add_new_transaction.dart';
import 'package:expensetracker/domain/usecases/delete_transaction.dart';
import 'package:expensetracker/domain/usecases/get_all_transactions.dart';
import 'package:expensetracker/domain/usecases/get_transactions_between.dart';
import 'package:expensetracker/presentation/bloc/transactions_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void init() {
  //bloc
  sl.registerFactory(
    () => TransactionsBloc(
      newTransaction: sl(),
      allTransactions: sl(),
      transactionsBetween: sl(),
      delete: sl(),
    ),
  );

  //use cases
  sl.registerLazySingleton(() => AddNewTransaction(sl()));
  sl.registerLazySingleton(() => GetAllTransactions(sl()));
  sl.registerLazySingleton(() => GetTransactionsBetween(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));

  //repository
  sl.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(localDataSource: sl()));

  //data sources
  sl.registerLazySingleton<TransactionLocalDataSource>(
      () => TransactionLocalDataSourceImpl());
}
