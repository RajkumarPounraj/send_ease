
import 'package:flutter/material.dart';
import 'package:send_ease/core/view_models/base_model.dart';
import 'package:send_ease/repository/send_money_repository.dart';
import 'package:send_ease/route/send_money_view/model/get_send_money_response.dart';

class SendMoneyViewModel extends BaseModel
{
  bool sendMoneyLoad = false;

  final sendMoneyRepository = SendMoneyRepository();

  Future<bool> callAddTransaction(BuildContext context,String date,double amount) async
  {
    sendMoneyLoad = true;
    setState(ViewState.busy);
    SendMoneyResponseDetail sendMoneyResponseDetail = await sendMoneyRepository.addTransactionDetail(context,date,amount);
    if(sendMoneyResponseDetail.id != null)
      {
        sendMoneyLoad = false;
        setState(ViewState.idle);
        return true;
      }
    else
      {
        sendMoneyLoad = false;
        setState(ViewState.idle);
        return false;
      }

    }
  }


