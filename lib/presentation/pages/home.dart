import 'package:expensetracker/core/utils/color_hex_formatter.dart';
import 'package:expensetracker/core/utils/date_formatter.dart';
import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:expensetracker/presentation/bloc/transactions_bloc.dart';
import 'package:expensetracker/presentation/widgets/expense_pie_chart.dart';
import 'package:expensetracker/presentation/widgets/message_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.portrait),
          color: Colors.black,
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text(
          'Expense Tracker',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0.5,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.black,
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //***********  custom input transaction  *************
          var transaction = new Transaction(
            amount: 150,
            description: 'gym',
            colorHex: Colors.red.value.toRadixString(16),
            category: 'fitness',
            dateTime: DateTime.now().subtract(Duration(days: 25)),
          );
          //****************************************************
          BlocProvider.of<TransactionsBloc>(context)
              .add(AddNewTransactionEvent(transaction));
          Future.delayed(Duration(seconds: 1)).then((_) =>
              BlocProvider.of<TransactionsBloc>(context)
                  .add(GetAllTransactionsEvent()));
        },
      ),
      body: BlocBuilder<TransactionsBloc, TransactionsState>(
        builder: (context, state) {
          if (state is Empty) {
            return MessageDisplay('Add your first transaction');
          } else if (state is Loading) {
            return Expanded(child: Center(child: CircularProgressIndicator()));
          } else if (state is Error) {
            return MessageDisplay(state.message);
          } else if (state is Loaded) {
            return ExpenseOverview(
              transactions: state.transactions,
              filtered: state.filtered,
              fromDate: state.fromDate,
              tillDate: state.tillDate,
            );
          } else if (state is Success) {
            return MessageDisplay('Added successfully');
          } else {
            return MessageDisplay('Something went wrong!');
          }
        },
      ),
    );
  }
}

class ExpenseOverview extends StatelessWidget {
  final List<Transaction> transactions;
  final bool filtered;
  final DateTime fromDate;
  final DateTime tillDate;

  ExpenseOverview({
    @required this.transactions,
    @required this.filtered,
    this.fromDate,
    this.tillDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 60,
          padding: EdgeInsets.only(left: 18, right: 0),
          width: double.infinity,
          child: StatusMenu(transactions, filtered, fromDate, tillDate),
        ),
        if (transactions.isNotEmpty)
          Expanded(
            flex: 4,
            child: ExpensePieChart(transactions),
          ),
        if (filtered)
          Container(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      width: 0.3,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Spendings from ${ddMMyyyy(fromDate)} till ${ddMMyyyy(tillDate)}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    BlocProvider.of<TransactionsBloc>(context)
                        .add(GetAllTransactionsEvent());
                  },
                  icon: Icon(Icons.clear),
                ),
              ],
            ),
          ),
        if (transactions.isNotEmpty)
          Expanded(
            flex: 8,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 500),
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (ctx, index) {
                  var transaction = transactions[index];
                  return Column(
                    children: [
                      Slidable(
                        actionPane: SlidableStrechActionPane(),
                        actions: [
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete_outline,
                            key: Key(transaction.key.toString()),
                            onTap: () async {
                              BlocProvider.of<TransactionsBloc>(context)
                                ..add(DeleteTransactionEvent(transaction.key));
                            },
                          )
                        ],
                        child: ListTile(
                          leading: Text('\$' + transaction.amount.toString()),
                          title: Text(transaction.description),
                          subtitle: Text(ddMMyyyy(transaction.dateTime)),
                          trailing: Text(
                            transaction.category,
                            style: TextStyle(
                                color: colorFromHex(transaction.colorHex)),
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class StatusMenu extends StatelessWidget {
  final List<Transaction> transactions;
  final bool filtered;
  final DateTime fromDate;
  final DateTime tillDate;

  StatusMenu(this.transactions, this.filtered, this.fromDate, this.tillDate);

  @override
  Widget build(BuildContext context) {
    int totalAmount = 0;
    transactions.forEach((transaction) {
      totalAmount += transaction.amount;
    });
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Spent',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              '\$$totalAmount',
              style: TextStyle(
                fontSize: 26,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        Spacer(),
        FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.date_range,
                    size: 14,
                  ),
                  Text(
                    'From date',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(fromDate),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              )
            ],
          ),
          onPressed: () => DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(2018, 3, 5),
            maxTime: DateTime.now(),
            onChanged: (date) {
              BlocProvider.of<TransactionsBloc>(context)
                  .add(GetTransactionsBetweenEvent(date, tillDate));
            },
            onConfirm: (date) {
              BlocProvider.of<TransactionsBloc>(context)
                  .add(GetTransactionsBetweenEvent(date, tillDate));
            },
            currentTime: DateTime.now(),
            locale: LocaleType.en,
          ),
        ),
        FlatButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.date_range,
                    size: 14,
                  ),
                  Text(
                    'Till date',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(tillDate),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              )
            ],
          ),
          onPressed: () => DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(2018, 3, 5),
            maxTime: DateTime.now(),
            onChanged: (date) {
              BlocProvider.of<TransactionsBloc>(context)
                  .add(GetTransactionsBetweenEvent(fromDate, date));
            },
            onConfirm: (date) {
              BlocProvider.of<TransactionsBloc>(context)
                  .add(GetTransactionsBetweenEvent(fromDate, date));
            },
            currentTime: DateTime.now(),
            locale: LocaleType.en,
          ),
        ),
      ],
    );
  }
}
