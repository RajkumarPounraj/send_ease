import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:send_ease/core/utils/utils.dart';
import 'package:send_ease/route/my_wallet_view/model/get_wallet_response.dart';
import 'package:send_ease/route/transaction_view/model/get_transaction_detail_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/shared_preference_const.dart';

class PreferenceHelper
{
  static Future<SharedPreferences> get _preference =>
      SharedPreferences.getInstance();

  static Future<bool> getBool(String key) async =>
      (await _preference).getBool(key) ?? false;

  static Future setBool(String key, bool value) async =>
      (await _preference).setBool(key, value);

  static Future<int> getInt(String key) async =>
      (await _preference).getInt(key) ?? 0;

  static Future setInt(String key, int value) async =>
      (await _preference).setInt(key, value);

  static Future<String> getString(String key) async =>
      (await _preference).getString(key) ?? '';

  static Future setString(String key, String value) async =>
      (await _preference).setString(key, value);

  static Future<double> getDouble(String key) async =>
      (await _preference).getDouble(key) ?? 0.0;

  static Future setDouble(String key, double value) async =>
      (await _preference).setDouble(key, value);

  static Future setStringList(String key, List<String> value) async =>
      (await _preference).setStringList(key, value);

  static Future<List<String>> getStringList(String key) async =>
      (await _preference).getStringList(key) ?? [];


  // Save transactions to SharedPreferences
  static Future<void> saveTransactions(List<TransactionDetail> transactions)
  async
  {
    final List<String> transactionsJson = transactions
        .map((transaction) => jsonEncode(transaction.toJson()))
        .toList();
  (await _preference).setStringList(PreferenceConst.transactionDetail, transactionsJson);
  }

  // Load transactions from SharedPreferences
  static Future<List<TransactionDetail>> loadTransactions() async
  {
    final List<String>? transactionsJson = (await _preference).getStringList(PreferenceConst.transactionDetail);

    if (transactionsJson == null) {
      return [];
    }

    return transactionsJson
        .map((jsonStr) => TransactionDetail.fromJson(jsonDecode(jsonStr)))
        .toList();
  }


    static Future<void> clearTransactionDetails() async
  {
    showLog("DATA:::REMOVE");
    var pref = await _preference;
    await pref.remove(PreferenceConst.transactionDetail);
  }

  static Future<void> saveWalletModel(WalletResponseDetail? model) async
  {
    (await _preference).setString(PreferenceConst.walletDetail, jsonEncode(model!.toJson()));
  }

  static Future<WalletResponseDetail?> geWalletModel() async
  {
    final jsonString = (await _preference).getString(PreferenceConst.walletDetail);

    if (jsonString != null)
    {
      return WalletResponseDetail?.fromJson(jsonDecode(jsonString));
    }
    return null; // Return null if no data is found
  }

  static Future<void> clearWalletModel() async
  {
    var pref = await _preference;
    await pref.remove(PreferenceConst.walletDetail);
  }


  static clearPreference() async
  {
    try {
      var pref = await _preference;
      pref.remove(PreferenceConst.userName);
      pref.remove(PreferenceConst.userLogin);
      pref.remove(PreferenceConst.transactionDetail);
      pref.remove(PreferenceConst.walletDetail);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
