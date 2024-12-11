import 'package:flutter/material.dart';
import 'package:send_ease/core/common_providers/common_provider.dart';
import 'package:send_ease/route/transaction_view/model/get_transaction_detail_model.dart';
import 'package:send_ease/themes/app_colors.dart';



Widget transactionCard(BuildContext context,TransactionDetail transaction) {
  return InkWell(
    onTap: ()
    {
    },
    child: Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: primaryColor, width: 0.4),
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>
          [
            const CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.wallet,
                color: Colors.white,
                size: 28,
              ),
            ),

            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 4.0,
                    bottom: 4.0,
                    left: 14.0,
                    right: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    const Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        "Transaction",
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "SplineSans Medium",
                            color: Colors.black),
                      ),
                    ),
                     Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        transaction.description,
                        style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontFamily: "Inter Regular"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
             SizedBox(
              height: 80,
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>
                [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0),
                    child: Text(
                        "${CommonProvider.currencyStr}${transaction.amount.toString()}",
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: "Inter Bold")),
                  ),
                   Padding(
                    padding:
                     const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                        transaction.date.toString(),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                            fontFamily: "SplineSans Bold")),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}
