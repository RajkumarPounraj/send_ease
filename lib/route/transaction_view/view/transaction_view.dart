import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:send_ease/component/transaction_card.dart';
import 'package:send_ease/core/utils/bottomsheet_util.dart';
import 'package:send_ease/core/view_models/base_model.dart';
import 'package:send_ease/custom_widget/placeholders.dart';
import 'package:send_ease/route/transaction_view/view_model/transaction_view_model.dart';
import 'package:send_ease/themes/app_colors.dart';
import 'package:shimmer/shimmer.dart';


class TransactionView extends StatefulWidget
{
  const TransactionView({super.key});

  @override
  TransactionViewState createState() => TransactionViewState();
}

class TransactionViewState extends State<TransactionView>
{


  final _notificationListKey = GlobalKey<AnimatedListState>();
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
      fetchTransactionList(false);
    }
    else
    {
      fetchTransactionList(true);
    }
  }


  fetchTransactionList(bool isOnline) async
  {
    SchedulerBinding.instance.addPostFrameCallback((_)
    {
      if(Provider.of<TransactionViewModel>(context, listen: false).state != ViewState.busy)
        {
          Provider.of<TransactionViewModel>(context, listen: false).callTransactionDetail(context,isOnline);
        }
    });
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
      appBar: AppBar(
          title:  const Text("My Transaction",style: TextStyle(
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
      ]
      ),
      body: Consumer<TransactionViewModel>(
        builder: (context, model, child)
        {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
                color: Colors.white,
                child: buildView(model)
            ),
          );
        },
      ),
    );

  }


  buildView(TransactionViewModel transactionViewModel) {
    switch (transactionViewModel.state)
    {
      case ViewState.busy:
        return  _shimmerView(context);
      case ViewState.idle:
        return transactionViewModel.transactionList.isNotEmpty ?   buildTransactionList(context,transactionViewModel) : buildEmptyView(context,transactionViewModel);
    }
  }

  _shimmerView(context)
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

  buildTransactionList(BuildContext context,TransactionViewModel transactionViewModel)
  {
        return AnimatedList(
        shrinkWrap: true,
          key: _notificationListKey,
          initialItemCount: transactionViewModel.transactionList.length,
          itemBuilder: (context, index, animation)
          {
            return SizeTransition(
              sizeFactor: animation,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0,left: 14,right: 14),
                child: transactionCard(context,transactionViewModel.transactionList[index]),
              ),
            );
          });
  }

  buildEmptyView(BuildContext context,TransactionViewModel transactionViewModel)
  {
    return   transactionViewModel.state == ViewState.idle  ?
    const Center(
    child: Text("No Transaction Available",style: TextStyle(
    color: Colors.black,fontSize: 16,fontFamily: "SplineSans Medium") ,
    )) : const SizedBox();
  }

}





