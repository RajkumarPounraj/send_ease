import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:send_ease/core/common_providers/common_provider.dart';
import 'package:send_ease/core/constants/route_const.dart';
import 'package:send_ease/core/utils/bottomsheet_util.dart';
import 'package:send_ease/core/view_models/base_model.dart';
import 'package:send_ease/custom_widget/placeholders.dart';
import 'package:send_ease/route/my_wallet_view/view_model/wallet_view_model.dart';
import 'package:send_ease/themes/app_colors.dart';
import 'package:shimmer/shimmer.dart';


class MyWalletView extends StatefulWidget
{
  const MyWalletView({super.key});

  @override
  MyWalletViewState createState() => MyWalletViewState();
}

class MyWalletViewState extends State<MyWalletView>
{

  bool priceVisible = false;
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
    });
    if(_connectionStatus[0] == ConnectivityResult.none)
    {
      fetchWalletDetailList(false);
    }
    else
    {
      fetchWalletDetailList(true);
    }
  }

  fetchWalletDetailList(bool isOnline) async
  {

    if(Provider.of<WalletViewModel>(context, listen: false).state != ViewState.busy)
    {
      Provider.of<WalletViewModel>(context, listen: false).callWalletDetails(context,isOnline);
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }





  @override
  Widget build(BuildContext context)
  {
    return   Scaffold(
      body: Consumer<WalletViewModel>(
        builder: (context, model, child) {
          return SingleChildScrollView(
            child: Container(
                color: Colors.white,
                child: buildBody(model)
            ),
          );
        },
      ),
    );

  }


  buildBody(WalletViewModel walletViewModel) {
    switch (walletViewModel.state)
    {
      case ViewState.busy:
        return  _shimmerLoadingView(context);
      case ViewState.idle:
        return  buildWalletDetail(context,walletViewModel);
    }
  }





  _shimmerLoadingView(context)
  {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: const SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children:
              [
                BannerPlaceholder(),
                TitlePlaceholder(width: double.infinity),
                SizedBox(height: 16.0),
                ContentPlaceholder(lineType: ContentLineType.threeLines,),
                SizedBox(height: 16.0),
                TitlePlaceholder(width: 200.0),
                SizedBox(height: 16.0),
                ContentPlaceholder(lineType: ContentLineType.twoLines),
                SizedBox(height: 16.0),
                TitlePlaceholder(width: 200.0),
                SizedBox(height: 16.0),
                ContentPlaceholder(lineType: ContentLineType.twoLines,),
              ],
            ),
          )),
    );
  }


  buildWalletDetail(BuildContext context, WalletViewModel walletViewModel)
  {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children:
      [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color:  walletBackgroundColor
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>
              [

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children:
                    [
                      const Flexible(
                        flex: 70,
                        child: Text("Wallet",
                          style: TextStyle(
                              fontFamily: "Inter Bold",
                              fontSize: 24,
                              color: Colors.white),
                        ),
                      ),

                      Flexible(
                        flex: 30,
                        child: GestureDetector(
                          onTap: () async
                          {
                            showAskingConfirmLogoutBottomSheet(context: context);
                          },
                          child: Container(
                            decoration:  const BoxDecoration(shape: BoxShape.circle,color: toolBarBoxBackgroundColor),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                              child: Icon(Icons.login,color: walletBackgroundColor,size: 24),
                            ),
                          ),
                        ),
                      ),

                    ]
                ),

            const SizedBox(height: 14),

                  Text( walletViewModel.walletDetail != null ? "Hai, ${walletViewModel.walletDetail!.name.toString()}" : "Hai,",
                  style: const TextStyle(
                      fontFamily: "Inter Medium",
                      fontSize: 16,
                      color: buttonTextColor),
                ),

                const SizedBox(height: 8),

                const Text('Total Balance',
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Inter Bold",
                      color: buttonTextColor),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.only(left: 14.0,right: 14),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:
                      [
                         Text(
                           priceVisible ? walletViewModel.walletDetail != null ? "${CommonProvider.currencyStr}${walletViewModel.walletDetail!.amount.toString()}" : "${CommonProvider.currencyStr}0.00" : "****",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontFamily: "Inter Bold",
                            color: buttonTextColor,
                            fontSize: 40,
                          ),

                        ) ,
                        GestureDetector(
                          onTap: () async
                          {
                            setState(() {
                              priceVisible = !priceVisible;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                            child: Icon(
                                priceVisible ? Icons.visibility : Icons.visibility_off,color: Colors.white,size: 28,

                            ),
                          ),
                        ),
                      ]
                  ),
                ),

              ],
            ),
          ),
        ),

        /*
        Padding(
          padding: const EdgeInsets.only(top: 24.0,left: 14,right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children:
            [
              Expanded(
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.pushNamed(context, RoutePaths.sendMoneyView);

                  },
                  child: Container(
                    height: 48,
                    decoration:  BoxDecoration(color: walletSendMoneyButtonColor,borderRadius: BorderRadius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 7.0, 12.0, 7.0),
                      child: Center(
                        child: Text(
                          "Send Money",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Inter Bold",
                            color: buttonTextColor,
                            fontSize: 16,
                          ),

                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.pushNamed(context, RoutePaths.transactionView);

                  },
                  child: Container(
                    height: 48,
                    decoration:  BoxDecoration(color: walletBackgroundColor,borderRadius: BorderRadius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(12.0, 7.0, 12.0, 7.0),
                      child: Center(
                        child: Text(
                          "Transaction",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "SplineSans Bold",
                            color: buttonTextColor,
                            fontSize: 16,
                          ),

                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
*/

        Padding(
          padding: const EdgeInsets.only(top: 24.0,left: 14,right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children:
            [
              Expanded(
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.pushNamed(context, RoutePaths.sendMoneyView);

                  },
                  child: Container(
                    decoration:  BoxDecoration(color: walletSendMoneyButtonColor,borderRadius: BorderRadius.circular(8)),
                    child: const Column(
                      children:
                      [
                        SizedBox(height: 24),

                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.send,
                            color: walletSendMoneyButtonColor,
                            size: 28,
                          ),
                        ),

                        SizedBox(height: 24),

                        Center(
                          child: Text(
                            "Send \n Money",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Inter Bold",
                              color: buttonTextColor,
                              fontSize: 16,
                            ),

                          ),
                        ),

                        SizedBox(height: 24),

                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 24),


              Expanded(
                child: GestureDetector(
                  onTap: ()
                  {
                    Navigator.pushNamed(context, RoutePaths.transactionView);

                  },
                  child: Container(
                    decoration:  BoxDecoration(color: wallet,borderRadius: BorderRadius.circular(8)),
                    child: const Column(
                      children:
                      [
                        SizedBox(height: 24),

                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.transfer_within_a_station,
                            color: wallet,
                            size: 28,
                          ),
                        ),

                        SizedBox(height: 24),

                        Center(
                          child: Text(
                            "My \n Transaction",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Inter Bold",
                              color: buttonTextColor,
                              fontSize: 16,
                            ),

                          ),
                        ),

                        SizedBox(height: 24),

                      ],
                    ),
                  ),
                ),
              ),



            ],
          ),
        ),


      ],
    );
  }


}








