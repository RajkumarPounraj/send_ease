
import 'package:flutter/material.dart';
import 'package:send_ease/core/constants/shared_preference_const.dart';
import 'package:send_ease/core/utils/shared_preference_helper.dart';
import 'package:send_ease/repository/auth_repository.dart';
import 'package:send_ease/route/login_view/model/get_login_model.dart';

import '../../../core/view_models/base_model.dart';

class LoginViewModel extends BaseModel
{
  bool login = false;
  final loginRepository = LoginRepository();
  List<LoginDetail> loginDetail = [];

  Future<bool> callLogin(BuildContext context, String email, String password) async
  {
    login = true;
    setState(ViewState.busy);
    loginDetail  = await loginRepository.callLogin(context, email, password);
    if(loginDetail.isNotEmpty)
      {
        await PreferenceHelper.setBool(PreferenceConst.userLogin, true);
        await PreferenceHelper.setInt(PreferenceConst.userId, loginDetail[0].id);
        await PreferenceHelper.setString(PreferenceConst.userName, loginDetail[0].name);
        login = false;
        setState(ViewState.idle);
        return true;
      }
    else
      {
        login = false;
        setState(ViewState.idle);
        return false;
      }

    }
  }

