import 'package:al_ameen/ui/view_models/login_provider.dart';
import 'package:al_ameen/ui/views/navigation_page/home_page.dart';
import 'package:al_ameen/data/models/login.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:al_ameen/ui/views/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

TextFormField passwordField(BuildContext context,
    TextEditingController passwordController, FocusNode node) {
  bool isTablet = SizerUtil.deviceType == DeviceType.tablet;

  return TextFormField(
    controller: passwordController,
    focusNode: node,
    style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp),
    obscureText: context.watch<LoginProvider>().changeIcon,
    decoration: InputDecoration(
        labelText: 'password',
        labelStyle: TextStyle(
            color: Colors.blue.shade700,
            fontFamily: 'RobotoCondensed',
            fontSize: 11.sp),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Icon(Icons.lock, size: isTablet ? 12.sp : 20.sp),
        ),
        suffixIcon: GestureDetector(
          onTap: () => Provider.of<LoginProvider>(context, listen: false)
              .passwordIconChange(),
          child: Padding(
              padding: EdgeInsets.only(right: isTablet ? 3.w : 0.w),
              child: Consumer<LoginProvider>(
                  builder: (ctx, res, _) => res.changeIcon
                      ? Icon(Icons.visibility_off,
                          size: isTablet ? 12.sp : 20.sp)
                      : Icon(Icons.visibility,
                          size: isTablet ? 12.sp : 20.sp))),
        ),
        filled: true,
        fillColor: Colors.blue.shade100,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blue)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue.shade700)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue.shade700)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.red))),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'password should not be empty';
      } else {
        return null;
      }
    },
  );
}

TextFormField usernameFiled(
    TextEditingController usernameController, FocusNode node) {
  bool isTablet = SizerUtil.deviceType == DeviceType.tablet;

  return TextFormField(
    controller: usernameController,
    focusNode: node,
    style: TextStyle(fontFamily: 'RobotoCondensed', fontSize: 11.sp,),
    decoration: InputDecoration(
        labelText: 'username',
        labelStyle: TextStyle(
            color: Colors.blue.shade700,
            fontSize: 11.sp,
            fontFamily: 'RobotoCondensed'),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Icon(
            Icons.person,
            size: isTablet ? 12.sp : 20.sp,
          ),
        ),
        // prefixIconConstraints: BoxConstraints(minWidth: 40.sp),
        filled: true,
        fillColor: Colors.blue.shade100,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.blue)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue.shade700)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: Colors.blue.shade700)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.red))),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'username should not be empty';
      } else {
        return null;
      }
    },
  );
}

Future<void> login(
    BuildContext context,
    TextEditingController usernameController,
    TextEditingController passwordController,
    LoginProvider provider) async {
  FocusScope.of(context).unfocus();
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  if (formKey.currentState!.validate()) {
    final user =
        Login(usernameController.text.trim(), passwordController.text.trim());
    Provider.of<LoginProvider>(context, listen: false);

    await provider.userLogin(context, user);
    final currentUser = provider.loggedUser;
    final error = provider.errorText;
    if (currentUser != null) {
      Navigator.pushAndRemoveUntil(
          scaffoldKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
          (route) => false);
      SharedPreferencesServices.setLoggedIn(
          usernameController.text, passwordController.text);
      provider.resetLog();
    } else if (error != null) {
      scaffoldMessenger.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        duration: const Duration(seconds: 3),
        content: Text(
          error,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
    usernameController.clear();
    passwordController.clear();
  }
}
