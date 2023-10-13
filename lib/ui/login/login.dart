import 'package:another_flushbar/flushbar_helper.dart';
import 'package:second_opinion_app/constants/assets.dart';
import 'package:second_opinion_app/data/sharedpref/constants/preferences.dart';
import 'package:second_opinion_app/utils/routes/routes.dart';
import 'package:second_opinion_app/stores/form/form_store.dart';
import 'package:second_opinion_app/stores/theme/theme_store.dart';
import 'package:second_opinion_app/utils/device/device_utils.dart';
import 'package:second_opinion_app/utils/locale/app_localization.dart';
import 'package:second_opinion_app/widgets/app_icon_widget.dart';
import 'package:second_opinion_app/widgets/empty_app_bar_widget.dart';
import 'package:second_opinion_app/widgets/progress_indicator_widget.dart';
import 'package:second_opinion_app/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //stores:---------------------------------------------------------------------
  late ThemeStore _themeStore;

  //focus node:-----------------------------------------------------------------
  late FocusNode _passwordFocusNode;

  //stores:---------------------------------------------------------------------
  final _store = FormStore();

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _themeStore = Provider.of<ThemeStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      appBar: EmptyAppBar(),
      body: _buildBody(),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Material(
      child: Stack(
        children: <Widget>[
          MediaQuery.of(context).orientation == Orientation.landscape
              ? Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildLeftSide(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildRightSide(),
                    ),
                  ],
                )
              : _buildRightSide(),
          Observer(
            builder: (context) {
              return _store.success ? navigate(context) : _showErrorMessage(_store.errorStore.errorMessage);
            },
          ),
          Observer(
            builder: (context) {
              return Visibility(
                visible: _store.loading,
                child: CustomProgressIndicatorWidget(),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildLeftSide() {
    return SizedBox.expand(
      child: Image.asset(
        Assets.carBackground,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRightSide() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: DeviceUtils.getScaledHeight(context, 0.5),
            child: CustomPaint(
                painter: LoginScreenCustomPainter(baseColor: Theme.of(context).scaffoldBackgroundColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    AppIconWidget(image: 'assets/icons/ic_appicon.png'),
                    Spacer(
                      flex: 3,
                    )
                  ],
                )),
          ),
          SizedBox(height: 24.0),
          SizedBox(
            height: DeviceUtils.getScaledHeight(context, 0.4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildUserIdField(),
                  _buildPasswordField(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildForgotPasswordButton(),
                  SizedBox(
                    height: 10,
                  ),
                  _buildSignInButton(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUserIdField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          onTap: () {
            Future.delayed(Duration(milliseconds: 400)).then((value) => _scrollController
                .animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeInOut));
          },
          hint: AppLocalizations.of(context).translate('login_et_user_email'),
          inputType: TextInputType.emailAddress,
          icon: Icons.person,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _userEmailController,
          inputAction: TextInputAction.next,
          autoFocus: false,
          onChanged: (value) {
            _store.setUserId(_userEmailController.text);
          },
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          errorText: _store.formErrorStore.userEmail,
        );
      },
    );
  }

  Widget _buildPasswordField() {
    return Observer(
      builder: (context) {
        return TextFieldWidget(
          hint: AppLocalizations.of(context).translate('login_et_user_password'),
          isObscure: true,
          padding: EdgeInsets.only(top: 16.0),
          icon: Icons.lock,
          iconColor: _themeStore.darkMode ? Colors.white70 : Colors.black54,
          textController: _passwordController,
          focusNode: _passwordFocusNode,
          errorText: _store.formErrorStore.password,
          onChanged: (value) {
            _store.setPassword(_passwordController.text);
          },
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: FractionalOffset.centerRight,
      child: TextButton(
        // padding: EdgeInsets.all(0.0),
        child: Text(
          AppLocalizations.of(context).translate('login_btn_forgot_password'),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      child: Text(AppLocalizations.of(context).translate('login_btn_sign_in')),
      onPressed: () async {
        if (_store.canLogin) {
          DeviceUtils.hideKeyboard(context);
          _store.login();
        } else {
          _showErrorMessage('Please fill in all fields');
        }
      },
    );
  }

  Widget navigate(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(Preferences.is_logged_in, true);
    });

    Future.delayed(Duration(milliseconds: 0), () {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.auth, (Route<dynamic> route) => false);
    });

    return Container();
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    if (message.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (message.isNotEmpty) {
          FlushbarHelper.createError(
            message: message,
            title: AppLocalizations.of(context).translate('home_tv_error'),
            duration: Duration(seconds: 3),
          )..show(context);
        }
      });
    }

    return SizedBox.shrink();
  }

  // dispose:-------------------------------------------------------------------
  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _userEmailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class LoginScreenCustomPainter extends CustomPainter {
  final Color baseColor; // Add a parameter for the base color

  LoginScreenCustomPainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 50.0; // Adjust this value for the desired curve radius

    // Calculate the shades based on the base color
    final List<Color> lineColors = [
      Color.lerp(baseColor, Colors.blueGrey, 0.03 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.06 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.09 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.12 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.15 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.18 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.21 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.24 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.27 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.3 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.33 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.36 * 2)!,
      Color.lerp(baseColor, Colors.blueGrey, 0.39 * 2)!,
    ];

    for (int i = 0; i < lineColors.length; i++) {
      final linePaint = Paint()..color = lineColors[i];
      double spacing = 1.0; // Adjust this value for the desired spacing between lines

      double yPos = size.height - (radius * 0.75 * (i + 1)) - (spacing * (i + 1));

      Path linePath = Path()
        ..lineTo(50, size.width)
        ..moveTo(0, yPos)
        ..quadraticBezierTo(size.width / 2, yPos - 50, size.width, yPos)
        ..lineTo(size.width, 0)
        ..lineTo(0, 0)
        ..close();

      canvas.drawPath(linePath, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
