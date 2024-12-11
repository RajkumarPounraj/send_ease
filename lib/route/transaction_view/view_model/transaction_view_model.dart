import 'package:flutter/material.dart';
import 'package:send_ease/core/utils/shared_preference_helper.dart';
import 'package:send_ease/core/view_models/base_model.dart';
import 'package:send_ease/repository/transaction_repository.dart';
import 'package:send_ease/route/transaction_view/model/get_transaction_detail_model.dart';

class TransactionViewModel extends BaseModel {

  bool isLoading = false;
  final transactionRepository = TransactionRepository();
  bool _isOnline = true;

  List<TransactionDetail> transactionList = [];



  callTransactionDetail(BuildContext context,bool status) async
  {
    transactionList.clear();
    _isOnline = status;
    setState(ViewState.busy);
    if (_isOnline)
    {
      List<TransactionDetail> transaction = await transactionRepository.getTransactionDetail(context);
      if (transaction.isNotEmpty)
      {
        transactionList.addAll(transaction);
        await PreferenceHelper.clearTransactionDetails(); // Save to SharedPreferences
        await PreferenceHelper.saveTransactions(transactionList); // Save to SharedPreferences
        setState(ViewState.idle);
      }
      else
      {
        setState(ViewState.idle);
      }
    }
    else
    {
      _loadTransactions();
    }
  }

  // Load transactions from SharedPreferences
  Future<void> _loadTransactions() async
  {
    List<TransactionDetail> transaction = await PreferenceHelper.loadTransactions();
    transactionList.addAll(transaction);
    setState(ViewState.idle);
  }

}