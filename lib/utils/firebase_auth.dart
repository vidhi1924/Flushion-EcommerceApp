import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

const String _webGoogleClientId =
    '642464103399-mv4gs9mgdb96a57pudncau2ou6hm1iol.apps.googleusercontent.com';

class AuthProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Shared across every AuthProvider() instance so the underlying GIS client
  // (and its onCurrentUserChanged listener, set up once below) isn't
  // re-initialized on every button press.
  static final GoogleSignIn googleSignIn =
      GoogleSignIn(clientId: kIsWeb ? _webGoogleClientId : null);

  static bool _webListenerAttached = false;

  AuthProvider() {
    // On web, `signIn()` can't reliably return an idToken (see loginWithGoogle
    // below), so sign-in there is driven by the GIS `renderButton` widget,
    // which reports the signed-in user through this stream instead.
    if (kIsWeb && !_webListenerAttached) {
      _webListenerAttached = true;
      googleSignIn.onCurrentUserChanged
          .listen((GoogleSignInAccount? account) async {
        if (account == null) return;
        final GoogleSignInAuthentication auth = await account.authentication;
        if (auth.idToken == null) return;
        try {
          await _auth.signInWithCredential(GoogleAuthProvider.credential(
              idToken: auth.idToken, accessToken: auth.accessToken));
        } catch (e) {
          print("Error logging in with Google");
        }
      });
    }
  }

  Future<bool> getCurrentUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null && user.email == 'admin@admin.com')
      return true;
    else
      return false;
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      User? user = result.user;
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> signUp(String email, String password, [String? name]) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      User? user = result.user;
      if (user != null) {
        if (name != null && name.trim().isNotEmpty) {
          await user.updateDisplayName(name.trim());
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("error logging out");
    }
  }

  /// Only used on mobile: on web, sign-in is driven by the rendered Google
  /// button (see google_signin_button.dart) instead of this imperative call.
  Future<bool> loginWithGoogle() async {
    if (kIsWeb) return false;
    try {
      GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) return false;
      final GoogleSignInAuthentication auth = await account.authentication;
      UserCredential res = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: auth.idToken, accessToken: auth.accessToken));
      if (res.user == null) return false;
      return true;
    } catch (e) {
      print("Error logging in with Google");
      return false;
    }
  }
}
