import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:expensetracker/injection_container.dart' as dependencyInjection;
import 'package:expensetracker/injection_container.dart';
import 'package:expensetracker/presentation/bloc/transactions_bloc.dart';
import 'package:expensetracker/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('transactions');
  dependencyInjection.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<TransactionsBloc>(
        create: (context) =>
            sl<TransactionsBloc>()..add(GetAllTransactionsEvent()),
        child: Home(),
      ),
    );
  }
}
