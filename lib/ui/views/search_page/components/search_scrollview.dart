import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearchScrollViewBuilder extends StatelessWidget {
  const SearchScrollViewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = SizerUtil.deviceType == DeviceType.tablet;

    final provider = context.watch<AccountProvider>();
    return Consumer<AccountProvider>(
      builder: (_, state, child) {
        if (state.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.searchedData.isNotEmpty) {
          return Material(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 10.0),
              shrinkWrap: true,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                          flex: 1,
                          icon: Icons.delete,
                          onPressed: (context) {
                            if (provider.searchedData[index].id != null) {
                              Provider.of<AccountProvider>(context,
                                      listen: false)
                                  .deleteSearchedData(
                                      provider.searchedData[index].id!);
                            }
                          })
                    ],
                  ),
                  child: isTablet
                      ? _buildTabletListTile(index, provider)
                      : _buildMobileListTile(index, provider),
                );
              },
              itemCount: provider.searchedData.length,
            ),
          );
        } else {
          if (provider.didSearch == false &&
              provider.fromDate == null &&
              provider.toDate == null) {
            return Center(
              child: Text('Search For Data',
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed', fontSize: 10.sp)),
            );
          } else {
            return Center(
              child: Text('Searched data not found',
                  style: TextStyle(
                      fontFamily: 'RobotoCondensed', fontSize: 10.sp)),
            );
          }
        }
      },
    );
  }

  ListTile _buildMobileListTile(int index, AccountProvider provider) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        tileColor: Colors.blue.shade100,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.searchedData[index].amount,
              style: provider.searchedData[index].type == 'income'
                  ? TextStyle(
                      color: Colors.green,
                      fontFamily: 'RobotoCondensed',
                      fontSize: 13.sp)
                  : TextStyle(
                      color: Colors.red,
                      fontFamily: 'RobotoCondensed',
                      fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
            if (provider.searchedData[index].description != null)
              Text(
                provider.searchedData[index].description!,
                style:
                    TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
                textAlign: TextAlign.center,
              )
          ],
        ),
        leading: CircleAvatar(
          radius: 6.w,
          child: Text(
            provider.searchedData[index].chair.substring(0, 2).toCapitalized() +
                provider.searchedData[index].chair.substring(5),
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('dd-MM-yyyy')
                  .format(provider.searchedData[index].date)
                  .substring(0, 10),
              style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 10.sp),
            ),
            Text(provider.searchedData[index].time,
                style:
                    TextStyle(fontFamily: 'RobotoCondensed', fontSize: 10.sp)),
            Text(
              provider.searchedData[index].payment == 'Money'
                  ? 'by Money'
                  : 'by UPI',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.blue.shade700,
                  fontFamily: 'RobotoCondensed',
                  fontSize: 10.sp),
            )
          ],
        ));
  }

  Widget _buildTabletListTile(int index, AccountProvider provider) {
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
                provider.searchedData[index].chair
                        .substring(0, 2)
                        .toCapitalized() +
                    provider.searchedData[index].chair.substring(5),
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
                  provider.searchedData[index].amount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: provider.searchedData[index].type == 'income'
                        ? Colors.green
                        : Colors.red,
                    fontFamily: 'RobotoCondensed',
                    fontSize: 13.sp,
                  ),
                ),
                if (provider.searchedData[index].description!.isNotEmpty)
                  Text(
                    provider.searchedData[index].description!,
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
                  DateFormat('dd-MM-yyyy')
                      .format(provider.searchedData[index].date)
                      .substring(0, 10),
                  style:
                      TextStyle(fontFamily: 'RobotoCondensed', fontSize: 10.sp),
                ),
                Text(
                  provider.searchedData[index].time,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
                Text(
                  provider.searchedData[index].payment == 'Money'
                      ? 'by Money'
                      : 'by UPI',
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
