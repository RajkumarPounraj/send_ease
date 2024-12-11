import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:send_ease/core/constants/shared_preference_const.dart';
import 'package:send_ease/core/utils/shared_preference_helper.dart';
import 'package:send_ease/core/utils/utils.dart';
import 'package:send_ease/generated/assets.dart';
import 'package:send_ease/route/login_view/view/login_view.dart';
import 'package:send_ease/route/login_view/view_model/login_view_model.dart';
import 'package:send_ease/route/my_wallet_view/view/wallet_view.dart';
import 'package:send_ease/route/my_wallet_view/view_model/wallet_view_model.dart';
import 'package:send_ease/route/send_money_view/view_model/send_money_view_model.dart';
import 'package:send_ease/route/transaction_view/view_model/transaction_view_model.dart';
import 'package:send_ease/route_setup.dart';
import 'package:send_ease/themes/app_colors.dart';
import 'package:send_ease/themes/theme.dart';
import 'core/common_providers/common_provider.dart';
import 'core/services/api/api_helper.dart';


Future<void> main() async
{
   // Ensure Flutter binding is initialized before calling any Flutter operations
  // This is necessary when you need to interact with the platform channels or perform asynchronous operations before the UI is rendered.
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables from the .env file asynchronously
  // This is used to securely store sensitive data like API keys, credentials, etc.
  try
  {
    await dotenv.load(fileName: ".env");
  }
  catch(e)
  {
    // If loading the .env file fails, catch the error and log it for debugging
    showLog("Error loading .env file: $e");
  }
  // If loading the .env file fails, catch the error and log it for debugging
  runApp(MultiProvider(
    providers: [
      Provider.value(value: ApiHandler()),
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => WalletViewModel()),
      ChangeNotifierProvider(create: (_) => SendMoneyViewModel()),
      ChangeNotifierProvider(create: (_) => TransactionViewModel()),
    ],
    child: const MyApp(),
  ));}


class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "",
    theme: CustomAppTheme.lightAppTheme,
    themeMode: ThemeMode.light,
    onGenerateRoute: RouterViews.generateRoute,
    home: const SplashScreen(),
        );

  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin
{
  CommonProvider commonProvider = CommonProvider();
  bool ifUserLogin = false;

  late AnimationController _animationController;
  late Animation<double> _animation;


  @override
  void initState()
  {
    super.initState();
    _animationController = AnimationController(vsync: this,duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.5,end: 1,).animate(_animationController);
    _animationController.forward();
    getUserLogin();
    Future.delayed(Duration.zero, () {
      startTime();
    });
  }

  startTime() async
  {
    var duration = const Duration(seconds: 4);
    return Timer(duration, _navigationPage);
  }

  _navigationPage()
  {
    ifUserLogin
        ? Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) =>  const MyWalletView()))
        : Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) =>   const LoginView()));
  }

  getUserLogin() async
  {
    bool userLogin = await PreferenceHelper.getBool(PreferenceConst.userLogin);
    setState(()
    {
      ifUserLogin = userLogin;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        color: toolbarBookColor,
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              width: 160,
              height: 160,
              Assets.imagesAppLogo,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }


  @override
  void dispose()
  {
    _animationController.dispose();
    super.dispose();
  }

}

