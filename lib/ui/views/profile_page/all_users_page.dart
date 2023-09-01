import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AllUsersPage extends StatelessWidget {
  const AllUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AccountProvider>(context, listen: false);
      provider.getAllUsersList();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: SizerUtil.deviceType == DeviceType.tablet
            ? IconThemeData(size: 10.sp)
            : null,
        title: Text(
          'All Users',
          style: TextStyle(
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.w600,
              fontSize: 13.sp),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Consumer<AccountProvider>(builder: (context, state, _) {
            if (state.allUsersList.isEmpty) {
              return Text(
                'No Users',
                style:
                    TextStyle(fontFamily: 'RobotoCondensed', fontSize: 12.sp),
              );
            } else if (state.loading) {
              return const CircularProgressIndicator();
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 5.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: state.allUsersList.map((data) {
                    final formattedData = data.split("-");

                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: SizerUtil.deviceType == DeviceType.tablet
                              ? 3.h
                              : 0.h),
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: SizerUtil.deviceType == DeviceType.mobile
                                ? 5.w
                                : 5.w,
                            child: Center(
                              child: Icon(
                                Icons.person,
                                size: SizerUtil.deviceType == DeviceType.mobile
                                    ? 6.w
                                    : 3.w,
                              ),
                            )),
                        title: Text(formattedData[0],
                            style: TextStyle(
                                fontFamily: 'RobotoCondensed',
                                fontSize: 12.sp)),
                        subtitle: Text(
                          formattedData[1],
                          style: TextStyle(
                            fontFamily: 'RobotoCondensed',
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
