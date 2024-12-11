
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:send_ease/core/common_providers/common_provider.dart';
import 'package:send_ease/core/constants/route_const.dart';
import 'package:send_ease/core/utils/bottomsheet_util.dart';
import 'package:send_ease/core/utils/utils.dart';
import 'package:send_ease/generated/assets.dart';
import 'package:send_ease/route/send_money_view/view_model/send_money_view_model.dart';
import 'package:send_ease/themes/app_colors.dart';

class SendMoneyView extends StatefulWidget
{
  const SendMoneyView({super.key});

  @override
  SendMoneyViewState createState() => SendMoneyViewState();
}

class SendMoneyViewState extends State<SendMoneyView>
{

  //Form key for validation
  final _keyForSendMoney = GlobalKey<FormState>();
  //Controller for amount
  final _userAmountTextController = TextEditingController();
  //loader for showing progress in send money button
  bool loader = false;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState()
  {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async
  {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try
    {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (_)
    {

      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async
  {
    setState(()
    {
      _connectionStatus = result;
      showLog("connectionStatus[0]:::${_connectionStatus[0]}");
    });
  }



  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _userAmountTextController.clear();
    super.dispose();
  }




  @override
  Widget build(BuildContext context)
  {

    final sendMoneyViewModel = Provider.of<SendMoneyViewModel>(context);

    return Scaffold(
        appBar: AppBar(
            title:  const Text("Send Money",style: TextStyle(
                color: Colors.black,fontSize: 18,fontFamily: "Inter Bold")),
            actions: [
          GestureDetector(
            onTap: () async
            {
              showAskingConfirmLogoutBottomSheet(context: context);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(shape: BoxShape.circle,color: dividerColor),
                child: const Center(child: Icon(Icons.exit_to_app,size: 25,color: Colors.black)),
              ),
            ),
          )
        ]),

        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            color: Colors.white,
            child:  _sendMoneyForm(context,sendMoneyViewModel),
          ),
        ));
  }


  _sendMoneyForm(BuildContext context, SendMoneyViewModel sendMoneyViewModel) {
    return Form(
      key: _keyForSendMoney,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: <Widget>
            [

             Image.asset(
                  Assets.imagesAppLogo,
                  height: 100,
                  width: 100, fit: BoxFit.contain),

              const SizedBox(height: 24),


              const Text(
                  CommonProvider.sendMoneyViewWelcomeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: primaryColor, fontSize: 30,
                    fontFamily: "SplineSans Medium",
                  )
              ),


              const SizedBox(height: 24),

              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                style : const TextStyle(color: textColor, fontSize: 14,fontFamily: "SplineSans Regular"),
                controller: _userAmountTextController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                    hintText: "Enter amount",
                    hintStyle:   const TextStyle(color: textHintColor, fontSize: 14,fontFamily: "SplineSans Regular"),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.8), width: 0.7),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                          Colors.grey.withOpacity(0.8),
                          width: 0.7),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never),
                validator: (value) {
                  if (value.toString().trim().isEmpty)
                  {
                    return CommonProvider.sendMoneyViewErrorEmptyAmountText;
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 24.0,
              ),

              GestureDetector(
                onTap: () async
                {
                  if (_keyForSendMoney.currentState!.validate())
                  {

                    FocusScope.of(context).unfocus();
                    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
                    final double amount = double.tryParse(_userAmountTextController.text.toString().trim()) ?? 0.0;
                    if(_connectionStatus[0] != ConnectivityResult.none)
                    {
                      var result = await sendMoneyViewModel.callAddTransaction(
                          context,
                          formattedDate.toString(),
                          amount);
                      if (result)
                      {
                        await Future.delayed(const Duration(seconds: 1));
                        if (!context.mounted) return;
                        FocusScope.of(context).unfocus();
                        showBottomSheetForStatus(context,result,CommonProvider.strTransactionSuccessMsg);
                      }
                      else
                      {
                        if (!context.mounted) return;
                        FocusScope.of(context).unfocus();
                        showBottomSheetForStatus(context,result,CommonProvider.strTransactionFailedMsg);
                      }
                    }
                    else
                      {
                        if (!context.mounted) return;
                        FocusScope.of(context).unfocus();
                        showBottomSheetForStatus(context,false,CommonProvider.strOfflineMsg);
                      }


                  }
                },
                child: Container(
                  height: 48,
                  decoration: const BoxDecoration(
                      color: primaryColor,borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child:  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 7.0, 12.0, 7.0),
                    child: Center(
                      child: sendMoneyViewModel.sendMoneyLoad ? const SizedBox(height: 20,width: 20,child:
                      CircularProgressIndicator(color: Colors.white,strokeWidth: 1.8,)) :  const Text(
                          "Send Now",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(color: buttonTextColor, fontSize: 16,fontFamily: "Inter Bold")
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 24.0,
              ),


              GestureDetector(
                onTap: () async
                {
                  Navigator.pushNamed(context, RoutePaths.transactionView);

                },
                child: Container(
                  height: 48,
                  decoration: const BoxDecoration(
                      color: primaryColor,borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child:  const Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 7.0, 12.0, 7.0),
                    child: Center(
                      child:   Text(
                          "My Transaction",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(color: buttonTextColor, fontSize: 16,fontFamily: "Inter Bold")
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 24.0,
              ),

            ],
          ),
        ),
      ),
    );
  }


  showBottomSheetForStatus(BuildContext context, bool result, String statusMsg) async
  {

    await showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      isScrollControlled:true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      showDragHandle: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context)
      {
        return StatefulBuilder(builder: (context, state)
        {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>
                [

                  const SizedBox(
                    height: 4,
                  ),

                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,border: Border.all(color: borderColor,width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:
                        [

                          Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: Container(
                              alignment: Alignment.center,
                              child:  CircleAvatar(radius: 30, backgroundColor: result ? Colors.green :  Colors.red,child: result ? const Icon(Icons.check) : const Icon(Icons.close)),
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(statusMsg,textAlign: TextAlign.center,style: const TextStyle(fontFamily: "SplineSans Bold",fontSize: 20,color: toolbarBookColor)),

                          const SizedBox(height: 24),

                          GestureDetector(
                            onTap: () async
                            {
                              Navigator.pop(context);
                              if(result)
                                {
                                  Navigator.pop(context);
                                }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: primaryColor,
                              ),
                              height: 48,
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(12.0, 7.0, 12.0, 7.0),
                                child: Center(
                                  child: Text(CommonProvider.strSendMoneyBottomSheetNoButtonText,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: "Inter Bold",
                                        color: buttonTextColor),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );

  }

}