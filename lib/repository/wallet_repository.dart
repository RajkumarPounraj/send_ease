import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:send_ease/core/constants/shared_preference_const.dart';
import 'package:send_ease/core/services/api/api_helper.dart';
import 'package:send_ease/core/utils/shared_preference_helper.dart';
import 'package:send_ease/core/utils/utils.dart';
import 'package:send_ease/route/my_wallet_view/model/get_wallet_response.dart';
import '../core/services/api/api_url_constant.dart';

class WalletRepository
{

  final ApiHandler _apiServices = ApiHandler();


  Future<int> get userID async => await PreferenceHelper.getInt(PreferenceConst.userId);


  getWalletDetail(BuildContext context) async
  {

    String baseUrl = dotenv.get("BASEURL");

    var  userId = await userID;
    try
    {
      if (!context.mounted) return;
      var result = await _apiServices.requestRestApi(context, {}, methodType: MethodType.get, nameSpace: '$baseUrl$getWalletEndPoint$userId');
      return compute(walletResponseDetailFromJson, result);
    }
    catch(e)
    {
      showLog("message:::::${e.toString()}");
      return WalletResponseDetail(id: null, username: '', name: '', amount: 0);
    }
  }

}

