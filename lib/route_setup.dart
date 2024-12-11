import 'package:flutter/material.dart';
import 'package:send_ease/route/login_view/view/login_view.dart';
import 'package:send_ease/route/my_wallet_view/view/wallet_view.dart';
import 'package:send_ease/route/send_money_view/view/send_money_view.dart';
import 'package:send_ease/route/transaction_view/view/transaction_view.dart';
import 'core/constants/route_const.dart';


abstract class RouterViews {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name)
    {

      case RoutePaths.loginView:
        return MaterialPageRoute(builder: (_) => const LoginView());

      case RoutePaths.myWalletView:
        return MaterialPageRoute(builder: (_) => const MyWalletView());

      case RoutePaths.sendMoneyView:
        return MaterialPageRoute(builder: (_) => const SendMoneyView());

      case RoutePaths.transactionView:
        return MaterialPageRoute(builder: (_) => const TransactionView());

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
