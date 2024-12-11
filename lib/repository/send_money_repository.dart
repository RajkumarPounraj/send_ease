import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:send_ease/core/services/api/api_helper.dart';
import 'package:send_ease/core/services/api/api_key_constant.dart';
import 'package:send_ease/core/utils/utils.dart';
import 'package:send_ease/route/send_money_view/model/get_send_money_response.dart';
import '../core/services/api/api_url_constant.dart';


class SendMoneyRepository
{

  final ApiHandler _apiServices = ApiHandler() ;


  addTransactionDetail(BuildContext context,String date,double amount) async
  {

    String baseUrl = dotenv.get("BASEURL");

    var map =
    {
      dateKey : date,
      descriptionKey : "Transfer",
      amountKey: amount,
    };

    try
    {
      var result = await _apiServices.requestRestApi(context, map, methodType: MethodType.post, nameSpace: '$baseUrl$getTransactionEndPoint');
      return compute(sendMoneyResponseDetailFromJson, result);
    }
    catch(e)
    {
      showLog("message");
      return SendMoneyResponseDetail(date: '', description: '', amount: null, id: null);
    }
  }

}