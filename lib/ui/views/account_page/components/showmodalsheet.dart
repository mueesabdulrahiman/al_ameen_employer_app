import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void openModalWidget(BuildContext context,
    {required AccountProvider provider, required Widget widget}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0))),
      builder: (ctx) {
        return Stack(
          children: [
            Container(padding: EdgeInsets.all(10.sp), child: widget),
            Positioned(
              top: SizerUtil.deviceType == DeviceType.tablet ? 10 : 3,
              right: SizerUtil.deviceType == DeviceType.tablet ? 20 : 5,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 15.sp,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      });
}
