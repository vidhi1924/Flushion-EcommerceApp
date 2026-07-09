# Reviving a 6-year-old Flutter app

This document is the technical log of bringing this project back from
"doesn't compile on any current toolchain" to "fully functional, tested
end-to-end, with a rebuilt Firebase backend." Written up in more detail as
a Medium article — this is the reference version.

## Starting state

- Flutter/Dart SDK constraint: `>=2.7.0 <3.0.0` — pre-null-safety, ~2020-era.
- Firebase plugins from the same era (`firebase_auth: ^0.16.1`,
  `cloud_firestore: ^0.13.6`, `firebase_storage: ^3.1.6`) — incompatible
  with any Flutter SDK released in the last several years.
- The original Firebase project (`ecommerceapp-45238`) no longer existed —
  Spark-plan projects get reclaimed after long enough inactivity.
- Android build config on AGP 3.5.0 / Gradle 5.6.2 / compileSdk 28.
- `carousel_pro` (the home-page image carousel package) has been
  unmaintained for years and doesn't support null safety.

None of this is unusual for a personal project shelved for years — it's
just enough small, compounding staleness that "just run it" stops working
entirely.

## Modernization

- Bumped to Dart 3 / Flutter 3.44, migrated every file to null safety.
- Replaced the whole Firebase dependency set with current FlutterFire
  packages (`firebase_core`, current `firebase_auth`/`cloud_firestore`/
  `firebase_storage`), rewriting call sites for API changes that
  accumulated over 5+ years: `Firestore.instance` → `FirebaseFirestore.instance`,
  `.document()/.getDocuments()` → `.doc()/.get()`, `FirebaseUser`/`AuthResult`
  → `User`/`UserCredential`, `onAuthStateChanged` → `authStateChanges()`,
  storage's `StorageUploadTask` → `UploadTask`, `GoogleAuthProvider.getCredential`
  → `.credential`.
- Swapped `carousel_pro` for `carousel_slider`.
- Migrated Android to embedding v2, AGP 8.1.4, Gradle 8.3, compileSdk 34.
- Removed `FlatButton`/`OutlineButton` (fully removed from current Flutter)
  in favor of `TextButton`/`OutlinedButton`.

## New Firebase project

Created a fresh project (`flushion`), wired up:

- Auth providers: Email/Password, Google.
- Firestore in test mode.
- `lib/firebase_options.dart` hand-written to mirror `flutterfire configure`
  output (web + Android configs) — no Node.js/Firebase CLI needed, since
  those config values are just plain data available from the console.

## Bugs found only by actually running it

Static analysis and compiling clean doesn't mean the app *works* — these
only surfaced by clicking through the running app:

- **A pre-existing layout crash** on the cart page: an `Expanded` nested
  inside a fixed-size `Container` instead of directly inside a `Row`
  (`Incorrect use of ParentDataWidget`). Existed in the original code;
  probably never hit before because of how much less this app was used.
- **Google Sign-In on web silently failing.** The web implementation of
  `google_sign_in` deprecated the classic popup `signIn()` flow — it can
  return an OAuth access token but not an `idToken`, which
  `GoogleAuthProvider.credential()` needs to actually authenticate with
  Firebase. Fixed by rendering Google's own `renderButton()` widget on web
  (which uses the GIS credential flow and does return an `idToken`) while
  keeping the classic flow for mobile.
- **The Admin panel silently did nothing** — gated behind
  `user.email == 'admin@admin.com'`, which no real account could ever
  match. The actual gate (a security-key dialog) already existed
  underneath; the email check was just dead weight.
- **Drawer's "Home Page" item pushed a new `HomePage` instance** instead of
  just closing the drawer, growing the navigation stack every time it was
  clicked.
- **Signup collected a "Full Name" field and silently discarded it** —
  never called `updateDisplayName`.
- **Cart bug**: adding the same product twice created two separate cart
  line items instead of incrementing quantity.
- **Checkout bug**: "Buy Now" always showed "Order Placed Successfully"
  even after the cart had already been emptied by deleting items, because
  the empty-check relied on a cart count that was only computed once
  (`initState`) instead of live.
- A debug `print()` was logging the user's raw email and password to the
  console on every login attempt.

## New features

Beyond fixing what existed, added: an editable **My Account** page (name/
phone/address, persisted to Firestore + Firebase Auth), a real **My
Orders** page backed by order records actually written at checkout time
(previously "checkout" just cleared the cart and showed a static "Happy
Shopping" screen — no order was ever persisted), **Settings** and **About**
pages (previously empty `onTap: (){}` stubs), and quantity +/- controls in
the cart.

## Verifying it actually works

No Android SDK is installed on the dev machine (and Android Studio +
emulator would've meant a large, slow install), so verification targeted
Flutter web. Two non-obvious things came up:

- `flutter run`'s dev server ties the page to a live debug (DWDS)
  connection — a second, independently-opened browser (for automated
  screenshots) can't fully bootstrap against it. The fix was building a
  release bundle (`flutter build web --release`) and serving it as static
  files, which any number of browser clients can load normally.
- Flutter web's CanvasKit renderer draws the UI to a `<canvas>`, so there's
  no DOM for text-based test selectors. Screenshots/demo automation
  (`scripts/`) drive the app via coordinate clicks instead.

The [demo video](../demo/flushion_app_demo.webm) and
[mockups](../mockups/) were captured this way, at a phone-sized viewport
(390×844) so they read as mobile screens rather than a resized desktop
site.

## What's next

UI redesign per [this Canva mockup](https://canva.link/xd27feov4a6zhax) —
tracked as an open item, not yet started.
