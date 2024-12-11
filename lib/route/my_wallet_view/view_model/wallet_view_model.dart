import 'package:flutter/material.dart';
import 'package:send_ease/core/utils/shared_preference_helper.dart';
import 'package:send_ease/core/view_models/base_model.dart';
import 'package:send_ease/repository/wallet_repository.dart';
import 'package:send_ease/route/my_wallet_view/model/get_wallet_response.dart';

class WalletViewModel extends BaseModel
{
  final walletRepository = WalletRepository();

  WalletResponseDetail? walletDetail;
  bool _isOnline = true;

  callWalletDetails(BuildContext context,bool isOnline) async
  {
    walletDetail = null;
    _isOnline = isOnline;
    notifyListeners();
    setState(ViewState.busy);
    if (_isOnline)
    {
      WalletResponseDetail? walletDetailList = await walletRepository.getWalletDetail(context);
      if (walletDetailList != null)
      {
        walletDetail = walletDetailList;
        await PreferenceHelper.clearWalletModel(); // Clear saved Wallet Model from SharedPreferences
        await PreferenceHelper.saveWalletModel(walletDetailList); // Save to SharedPreferences
        setState(ViewState.idle);
      }
      else
      {
        setState(ViewState.idle);
      }
    }
    else
    {
    _loadWalletDetail();
    }
  }

  // Load transactions from SharedPreferences
  Future<void> _loadWalletDetail() async
  {
    walletDetail = await PreferenceHelper.geWalletModel();
    setState(ViewState.idle);
  }

}

