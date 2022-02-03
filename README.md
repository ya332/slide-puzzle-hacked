# Slide Puzzle 
Live at https://slide-puzzle-hacked.web.app/ \
and https://play.google.com/store/apps/details?id=app.web.slide_puzzle_hacked \
Flutter Hackathon Project Submission by Yigit Alparslan (GitHub handle is ya332) \
Flutter Puzzle Hack: https://flutterhack.devpost.com/ \
Sample code from: https://github.com/VGVentures/slide_puzzle

![Photo Booth Header][logo]

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A slide puzzle built for [Flutter Challenge](https://flutterhack.devpost.com/).

*Built by [Very Good Ventures][very_good_ventures_link] in partnership with Google.*

*Created using [Very Good CLI][very_good_cli_link].*

## Roadmap
- [x] Add background image
- [x] Add crazy mode
- [x] Add hacker mode
- [x] Add instruction texts
- [x] Add normal mode
- [x] Make buttons highlighted on clicked
- [x] Issue: Crazy Mode doesn't update its button color and instructions
- [x] Issue: Draggables should disappear after dragged
- [x] Issue: Display buttons on a 2 by 2 grid instead of same row
- [x] Deploy to Android

---

## Development 🚀

To run the project either use the launch configuration in VSCode/Android Studio or use the following command:

```sh
$ flutter run -d chrome
```

## Deployment
For web,

```bash
$ flutter build web
$ firebase deploy
```

For Android,
```bash
$ flutter build appbundle

$ java -jar bundletool.jar build-apks --bundle=release\app-release.aab --output=apk_set.apks --mode=universal --ks=my-awesome-key-store.jks --ks-pass=pass:<password-here> --ks-key-alias=<alias-here> --key-pass=pass:<password-here>

$ java -jar bundletool.jar install-apks --apks=apk_set.apks --device-id=R28M52AHRWN
```
---

## Play Store Description
<en-US>
Play in three different game modes:
- Normal mode: Arrange pieces in order to solve the puzzle
- Crazy mode: Arrange the pieces while puzzle board rotates continuously
- Hack mode: Drag pieces into drop target to score. Finish them all before you run out of time!

There is no account required, no ads displayed, no registration prompted!
This is a free game! Have fun!
</en-US>

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:very_good_slide_puzzle/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

## Resources
- Rotating https://api.flutter.dev/flutter/widgets/AnimatedBuilder-class.html
- Dragging https://api.flutter.dev/flutter/widgets/Draggable-class.html
- Countdown https://pub.dev/packages/countdown_progress_indicator


[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[very_good_ventures_link]: https://verygood.ventures/
[logo]: art/header.png
