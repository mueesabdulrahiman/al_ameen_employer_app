import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/search_page/components/search_filter_widget.dart';
import 'package:al_ameen/ui/views/search_page/components/search_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountProvider>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchFilterBuilder(provider),
              SizedBox(
                height: 2.h,
              ),
              provider.searchedData.isNotEmpty
                  ? Text(
                      'Searched Data',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'RobotoCondensed',
                          fontSize: 12.sp),
                    )
                  : const SizedBox(),
              SizedBox(
                height: 1.h,
              ),
              const Expanded(
                child: SearchScrollViewBuilder(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
