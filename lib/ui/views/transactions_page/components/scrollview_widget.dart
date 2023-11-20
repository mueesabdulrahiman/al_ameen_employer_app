import 'package:al_ameen/data/models/data.dart';
import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ScrollViewBuilder extends StatelessWidget {
  const ScrollViewBuilder(
      {super.key, required this.data, required this.constraints});
  final List<Data> data;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    bool isTablet = SizerUtil.deviceType == DeviceType.tablet;

    return ListView.builder(
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Slidable(
                startActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    SliderTheme(
                        data: SliderThemeData(
                            valueIndicatorTextStyle:
                                TextStyle(fontSize: 20.sp)),
                        child: SlidableAction(
                            key: const Key('delete'),
                            icon: Icons.delete,
                            onPressed: (context) {
                              if (data[index].id != null) {
                                Provider.of<AccountProvider>(context,
                                        listen: false)
                                    .deleteAccountsData(data[index].id!);
                              }
                            })),
                  ],
                ),
                child: isTablet ? _buildTile(index) : _buildListTile(index),
              ),
            ),
          );
        },
        itemCount: data.length);
  }

  // listTile widget
  ListTile _buildListTile(int index) {
    return ListTile(
        key: const Key('list-tile'),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 2.w,
          vertical: 1.h,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        tileColor: Colors.blue.shade100,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data[index].amount,
              style: TextStyle(
                color: data[index].type == 'income' ? Colors.green : Colors.red,
                fontFamily: 'RobotoCondensed',
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
            if (data[index].description!.isNotEmpty)
              Text(data[index].description!,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp))
          ],
        ),
        leading: CircleAvatar(
          radius: 6.w,
          child: Text(
            data[index].chair.substring(0, 2).toCapitalized() +
                data[index].chair.substring(5),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, fontFamily: 'RobotoCondensed'),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data[index].time,
                style:
                    TextStyle(fontSize: 10.sp, fontFamily: 'RobotoCondensed')),
            Text(
              data[index].payment == 'Money' ? 'by Money' : 'by UPI',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.blue.shade700,
                  fontFamily: 'RobotoCondensed',
                  fontSize: 10.sp),
            )
          ],
        ));
  }

  Widget _buildTile(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 5.w,
              child: Text(
                data[index].chair.substring(0, 2).toCapitalized() +
                    data[index].chair.substring(5),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontFamily: 'RobotoCondensed',
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data[index].amount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: data[index].type == 'income'
                        ? Colors.green
                        : Colors.red,
                    fontFamily: 'RobotoCondensed',
                    fontSize: 13.sp,
                  ),
                ),
                if (data[index].description!.isNotEmpty)
                  Text(
                    data[index].description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 11.sp,
                    ),
                  ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data[index].time,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
                Text(
                  data[index].payment == 'Money' ? 'by Money' : 'by UPI',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.blue.shade700,
                    fontFamily: 'RobotoCondensed',
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
