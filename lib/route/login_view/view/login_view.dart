
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:send_ease/core/common_providers/common_provider.dart';
import 'package:send_ease/core/constants/route_const.dart';
import 'package:send_ease/core/utils/utils.dart';
import 'package:send_ease/generated/assets.dart';
import 'package:send_ease/route/login_view/view_model/login_view_model.dart';
import 'package:send_ease/themes/app_colors.dart';

class LoginView extends StatefulWidget
{
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView>
{

  //Form key for validation
  final _keyForLogin = GlobalKey<FormState>();
  //Controller for email and password
  final _userNameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  //scaffold key for showing SnackBar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //loader for showing progress in login button
  bool loader = false;
  //show hide password suffix icon
  bool passwordVisible = false;

  //To get Internet connection status
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  //To get Internet connection status continuously
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
  void dispose()
  {
    _connectivitySubscription.cancel();
    _passwordTextController.clear();
    _userNameTextController.clear();
    super.dispose();
  }



  @override
  Widget build(BuildContext context)
  {

    final loginViewModel = Provider.of<LoginViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
          key: _scaffoldKey,
          body: Container(
            child:  buildLoginForm(context,loginViewModel),
          )),
    );
  }


  buildLoginForm(BuildContext context, LoginViewModel loginViewModel) {
    return Form(
      key: _keyForLogin,
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
                  CommonProvider.loginViewWelcomeText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: primaryColor, fontSize: 30,
                    fontFamily: "SplineSans Medium",
                  )
              ),


              const SizedBox(height: 24),

              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                style : const TextStyle(color: textColor, fontSize: 14,fontFamily: "SplineSans Regular"),
                controller: _userNameTextController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                    hintText: "Enter user name",
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
                    return CommonProvider.loginViewErrorEmptyEmailText;
                  }
                  if (!emailEx.hasMatch(value.toString().trim()))
                  {
                    return CommonProvider.loginViewErrorInvalidEmailText;
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 24.0,
              ),

              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                style : const TextStyle(color: textColor, fontSize: 14,fontFamily: "SplineSans Regular"),
                obscureText: !passwordVisible,
                obscuringCharacter: "*",
                controller: _passwordTextController,
                decoration: InputDecoration(
                    suffixIcon : GestureDetector(
                        onTap : ()
                        {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        child:  Icon(passwordVisible ? Icons.visibility : Icons.visibility_off,size: 18,color: primaryColor)),
                    contentPadding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                    hintText: CommonProvider.loginViewHintPasswordText,
                    hintStyle:   const TextStyle(color: textHintColor, fontSize: 14,fontFamily: "SplineSans Regular"),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor.withOpacity(0.8), width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: primaryColor.withOpacity(0.8),
                          width: 0.5),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never),
                validator: (value) {
                  if (value.toString().trim().isEmpty)
                  {
                    return CommonProvider.loginViewErrorPasswordText;
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
                  if (_keyForLogin.currentState!.validate())
                  {
                    FocusScope.of(context).unfocus();
                  if(_connectionStatus[0] != ConnectivityResult.none)
                  {
                    var result = await loginViewModel.callLogin(
                        context,
                        _userNameTextController.text.toString().trim(),
                        _passwordTextController.text.toString().trim());
                    if (result)
                    {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(CommonProvider.loginViewSuccessText),
                      ));
                      Navigator.popAndPushNamed(
                          context, RoutePaths.myWalletView);
                    }
                    else
                    {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(CommonProvider.loginViewFailedText),
                      ));
                    }
                  }
                  else
                  {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                      content: Text(CommonProvider.strOfflineMsg),
                    ));
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
                      child: loginViewModel.login ? const SizedBox(height: 20,width: 20,child:
                      CircularProgressIndicator(color: Colors.white,strokeWidth: 1.8,)) :  const Text(
                          "Login",
                          maxLines: 1,
                          textAlign: TextAlign.center,
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


}