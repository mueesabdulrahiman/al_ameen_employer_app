import 'package:al_ameen/ui/view_models/login_provider.dart';
import 'package:al_ameen/ui/views/login_page/components/form_widgets.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage(this.sharedPref, {super.key});
  final SharedPreferencesServices sharedPref;

  @override
  State<LoginPage> createState() => _MyWidgetState();
}

final loginScaffoldKey = GlobalKey<ScaffoldState>();
final formKey = GlobalKey<FormState>();

class _MyWidgetState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _node1 = FocusNode();
  final _node2 = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _node1.dispose();
    _node2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: loginScaffoldKey,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                reverse: true,
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          'assets/images/al-ameen-logo.png',
                          scale: 1,
                        ),
                        usernameFiled(_usernameController, _node1),
                        SizedBox(height: 2.h),
                        passwordField(context, _passwordController, _node2),
                        SizedBox(height: 2.h),
                        ElevatedButton(
                            key: const Key('login-button'),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 1.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            onPressed: () async {
                              await login(
                                  context,
                                  _usernameController,
                                  _passwordController,
                                  provider,
                                  widget.sharedPref);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  fontFamily: 'RobotoCondensed'),
                            )),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
