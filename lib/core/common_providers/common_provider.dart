import 'dart:core';


class CommonProvider
{
  static final CommonProvider commonProvider = CommonProvider._internal();

  factory CommonProvider()
  {
    return commonProvider;
  }

  CommonProvider._internal();


  //App Config
  static const String environment = 'Flutter';
  static const String appName = 'Send Ease';
  static const String baseUrl = 'https://api.picklersarena.com/api/';
  static const String currencyStr = '\$';

  //LoginView text content
  static const String loginViewSuccessText = "Login successful!";
  static const String loginViewWelcomeText = "Login";
  static const String loginViewFailedText = "No matching user found!";


  //SendMoneyView text content
  static const String sendMoneyViewWelcomeText = "Send Money";


  static const String loginViewFullNameText = "User name";
  static const  String loginViewPasswordText = "Password";
  static const String loginViewHintPasswordText = 'Password';
  static const String loginViewHintCurrentPasswordText = 'Current Password';
  static const String loginViewHintNewPasswordText = 'New Password';
  static const String loginViewHintConfirmPasswordText = 'Confirm Password';

  static const String loginViewErrorPasswordText = "Please enter your password";
  static const String loginViewErrorEmptyEmailText = "Please enter email address";
  static const String loginViewErrorInvalidEmailText = "Please enter valid email address";

  static const String sendMoneyViewErrorEmptyAmountText = "Please enter amount";

  //For offline or API issue text
  static const String strPleaseTryAgain = "Please try again...";
  static const String strOfflineMsg = "You are offline. Check your connection!";

  //For send money status message text
  static const String strTransactionSuccessMsg = "Transaction successful!";
  static const  String strTransactionFailedMsg = "Transaction Failed!";

  //For send money status message BottomSheet Button text
  static const strSendMoneyBottomSheetNoButtonText =  'Okay';


  //For Logout text
  static const strLogoutMsg =  'Are you sure do you want to Logout?';
  //For Logout Button text
  static const strLogoutYesButtonText =  'Yes';
  static const strLogoutNoButtonText =  'No';

}
