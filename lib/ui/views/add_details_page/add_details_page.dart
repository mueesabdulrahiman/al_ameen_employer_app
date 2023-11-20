import 'package:al_ameen/ui/view_models/account_provider.dart';
import 'package:al_ameen/ui/views/add_details_page/components/form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddDetailsPage extends StatefulWidget {
  const AddDetailsPage(this.sharedPreference, {super.key});

  final Future<List<String>?>? sharedPreference;

  @override
  State<AddDetailsPage> createState() => _HomePageState();
}

enum CategoryType { income, expense }

String? menuError;

final formKey = GlobalKey<FormState>();
DateTime? pickedDate;
TimeOfDay? pickedTime;
DateTime? formattedDate;

class _HomePageState extends State<AddDetailsPage> {
  late TextEditingController _dateController;
  late TextEditingController _amountController;
  TextEditingController? _descriptionController;
  final _node1 = FocusNode();
  final _node2 = FocusNode();
  final _node3 = FocusNode();
  late bool isScrolled;
  bool isTablet = SizerUtil.deviceType == DeviceType.tablet;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _dateController.text =
        DateFormat('dd-MM-yyyy HH:mm a').format(DateTime.now());
    _amountController = TextEditingController();
    _descriptionController = TextEditingController();
    Provider.of<AccountProvider>(context, listen: false).displayChairs();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _descriptionController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AccountProvider>();
    provider.displayChairs();

    isScrolled = MediaQuery.of(context).viewInsets.bottom != 0;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: const Key('add_details_page'),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: SizerUtil.deviceType == DeviceType.tablet
              ? IconThemeData(size: 10.sp)
              : null,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    !isScrolled
                        ? Text(
                            'Add Details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30.sp, fontFamily: 'RobotoCondensed'),
                          )
                        : const SizedBox(),
                    SizedBox(height: 3.h),
                    buildDateField(context, _dateController, _node1),
                    SizedBox(height: 2.h),
                    buildAmountField(_amountController, _node2),
                    SizedBox(height: 2.h),
                    buildDescriptionField(_descriptionController, _node3),
                    SizedBox(height: 2.h),
                    buildDropdownWidget(context, provider),
                    provider.menuError != null
                        ? SizedBox(height: 1.h)
                        : SizedBox(height: 0.h),
                    provider.menuError != null
                        ? Padding(
                            padding: EdgeInsets.only(left: 5.sp),
                            child: Text(provider.menuError!,
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Colors.red,
                                    fontFamily: 'RobotoCondensed')),
                          )
                        : const SizedBox(),
                    SizedBox(height: isTablet ? 3.h : 2.h),
                    buildRadioButtonOption(provider),
                    isTablet ? SizedBox(height: 3.h) : const SizedBox(),
                    buildCheckBoxOption(provider),
                    SizedBox(height: isTablet ? 3.h : 2.h),
                    buildSubmitButton(
                      context,
                      provider,
                      _descriptionController,
                      _amountController,
                      _dateController,
                      formattedDate,
                      widget.sharedPreference,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
