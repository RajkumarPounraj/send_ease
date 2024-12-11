import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:send_ease/core/constants/shared_preference_const.dart';
import 'package:send_ease/core/services/api/api_helper.dart';
import 'package:send_ease/core/services/api/api_key_constant.dart';
import 'package:send_ease/core/utils/shared_preference_helper.dart';
import '../core/services/api/api_url_constant.dart';
import '../route/login_view/model/get_login_model.dart';

class LoginRepository
{

  final ApiHandler _apiServices = ApiHandler() ;


  Future<int> get userID async => await PreferenceHelper.getInt(PreferenceConst.userId);

  callLogin(BuildContext context, String userName, String password) async
  {

    String baseUrl = dotenv.get("BASEURL");

    try
    {
      var result = await _apiServices.requestRestApi(context, {}, methodType: MethodType.get, nameSpace: '$baseUrl$getLoginDetailEndPoint$userNameKey$userName$userPasswordKey$password');
      return compute(loginDetailFromJson, result);
    }
    catch(e)
    {
      return compute(loginDetailFromJson, []);
    }
  }

}