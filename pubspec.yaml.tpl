name: warp
description: A new Flutter project.

# The following line prevents the package from being accidentally published to
# pub.dev using `pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
version: 1.0.10+159

environment:
  sdk: ">=2.12.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  warp_api:
    path: packages/warp_api_ffi
  sqflite: ^2.0.0+4
  flutter_mobx: ^2.0.2
  qr_flutter: ^4.0.0
  http: ^0.13.3
  intl: ^0.17.0
  path: ^1.8.0
  material_design_icons_flutter: ^5.0.5955-rc.1
  rflutter_alert: ^2.0.4
  sprintf: ^6.0.0
  local_auth: ^1.1.7
  shared_preferences: ^2.0.7
  flutter_markdown: ^0.6.6
  package_info_plus: ^1.0.6
  velocity_x: ^3.3.0
  decimal: ^1.3.0
  flutter_form_builder: ^6.1.0+1
  url_launcher: ^6.0.10
  flex_color_scheme: ^3.0.1
  fl_chart: ^0.40.0
  grouped_list: ^4.1.0
  json_annotation: ^4.1.0
  share_plus: ^2.1.4
  path_provider: ^2.0.3
  file_picker: ^4.0.2
  mustache_template: ^2.0.0
  rate_my_app: ^1.1.1
  flutter_palette: ^1.1.0+1
  flutter_svg: ^0.22.0
  flutter_typeahead: ^3.2.0
  flutter_barcode_scanner:
    git:
      url: https://github.com/hhanh00/flutter_barcode_scanner.git
      ref: d338bdc5c0b797d81694f04bd5f52e8171939af5
  currency_text_input_formatter: ^2.1.2
  sensors_plus: ^1.1.0
  connectivity_plus: ^1.1.0
  flutter_localizations:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.1.2
  mobx_codegen: ^2.0.3
  json_serializable: ^5.0.0
  flutter_launcher_icons: any
  flutter_app_name: any
  change_app_package_name: any
  flutter_native_splash: ^1.2.3

flutter_app_name:
  name: "{{APP_TITLE}}"

flutter_icons:
  android: true
  ios: true
  remove_alpha_ios: true
  image_path: "assets/icon.png"

flutter_native_splash:
  color_dark: "#FFFFFF"
  color: "#000000"
  image: "assets/icon.png"

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/icon.png
    - assets/about.md
    - assets/wallet.svg
    - assets/contacts.svg
    - assets/multipay.svg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/assets-and-images/#resolution-aware.

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/assets-and-images/#from-packages

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/custom-fonts/#from-packages
flutter_intl:
  enabled: true