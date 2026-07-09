import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

Widget renderGoogleSignInButton() => web.renderButton(
      configuration: web.GSIButtonConfiguration(
        theme: web.GSIButtonTheme.filledBlue,
        size: web.GSIButtonSize.large,
        text: web.GSIButtonText.signinWith,
        shape: web.GSIButtonShape.pill,
      ),
    );
