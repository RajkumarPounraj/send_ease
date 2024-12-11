import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:send_ease/core/services/api/api_helper.dart';
import 'package:send_ease/route/transaction_view/model/get_transaction_detail_model.dart';
import '../core/services/api/api_url_constant.dart';

class TransactionRepository
{

  final ApiHandler _apiServices = ApiHandler() ;


  getTransactionDetail(BuildContext context) async
  {

    String baseUrl = dotenv.get("BASEURL");

    try
    {
      var result = await _apiServices.requestRestApi(context, {}, methodType: MethodType.get, nameSpace: '$baseUrl$getTransactionEndPoint');
      return compute(transactionDetailFromJson, result);
    }
    catch(e)
    {
      return compute(transactionDetailFromJson, []);
    }
  }

}