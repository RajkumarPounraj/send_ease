

import 'package:flutter/material.dart';
import 'package:send_ease/component/bottom_sheet_modal_logout.dart';

Future<void> showAskingConfirmLogoutBottomSheet({required BuildContext context}) async
{
 await showModalBottomSheet(
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
    builder: (bc)
    {
      return StatefulBuilder(
        builder: (context, stateSetter)
        {
          return Container(
            color: Colors.white,
            child: const CustomLogoutBottomSheet(),
          );
        },
      );
    },
  );
}