import 'package:flutter/material.dart';
import 'package:send_ease/core/common_providers/common_provider.dart';
import 'package:send_ease/core/constants/route_const.dart';
import 'package:send_ease/core/utils/shared_preference_helper.dart';
import 'package:send_ease/themes/app_colors.dart';


class CustomLogoutBottomSheet extends StatefulWidget
{

  const CustomLogoutBottomSheet({super.key});

  @override
  CustomLogoutBottomSheetState createState() => CustomLogoutBottomSheetState();
}

class CustomLogoutBottomSheetState extends State<CustomLogoutBottomSheet>
{

  @override
  Widget build(BuildContext context)
  {
    return   Padding(
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  "Confirm",
                  style: TextStyle(
                      fontSize: 21,fontFamily: "Inter Bold",color: textColor),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
                )
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                children:
                [
                   const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                     CommonProvider.strLogoutMsg,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18,color: textColor,
                          fontFamily:  "Inter Medium"),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),


                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:  const Text(
                        CommonProvider.strLogoutYesButtonText,
                        style: TextStyle(fontSize: 16,color: buttonTextColor,fontFamily: "Inter Bold"),
                      ),
                      onPressed: () async
                      {
                        await PreferenceHelper.clearPreference();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        Navigator.popAndPushNamed(context, RoutePaths.loginView);

                      },
                    ),
                  ),


                  const SizedBox(
                    height: 20,
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:  const Text(
                        CommonProvider.strLogoutNoButtonText,
                        style: TextStyle(fontSize: 16,color: buttonTextColor,fontFamily: "Inter Bold"),
                      ),
                      onPressed: () async
                      {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}

