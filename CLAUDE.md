# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

Fire Guard is a Flutter mobile app for an IoT fire and gas detection system. The README describes an ESP8266-based hardware setup that reports fire/gas sensor data to the mobile app; the app provides real-time alerts, emergency contacts/calls, map-based location features, fire news, and fire safety guidance.

The Flutter package is named `fire_guard` and targets Dart `>=3.2.4 <4.0.0`. Android uses application id `com.nguyenduc.fire_guard`, compile/target SDK 36, min SDK 24, Java/Kotlin 17, and NDK `27.0.12077973`.

## Common commands

```bash
# Install/update dependencies
flutter pub get

# Static analysis (uses analysis_options.yaml -> flutter_lints)
flutter analyze

# Format Dart code
dart format lib test

# Run all tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Run the app
flutter run

# Run with the Device Preview entrypoint
flutter run -t lib/main_preview.dart

# Build Android debug/release artifacts
flutter build apk --debug
flutter build apk --release
flutter build appbundle --release

# Regenerate JSON/Retrofit generated files if models/API annotations are added
flutter pub run build_runner build --delete-conflicting-outputs

# Regenerate launcher icons after changing flutter_icons in pubspec.yaml
flutter pub run flutter_launcher_icons:generate
```

The app loads `.env` at startup and Firebase options are read from it in `lib/main.dart`. Android release signing reads `android/key.properties` and `android/app/fire_guard_key.jks`.

## Architecture

### App startup

`lib/main.dart` is the production entrypoint. Startup initializes Flutter bindings, EasyLocalization, Hive, local storage, `.env`, geolocation permission, Firebase, Firebase App Check, ErrorStack, then runs `MyApp` inside `EasyLocalization` and a global `MultiProvider` from `ProviderSetup.getProviders()`.

`lib/main_preview.dart` is an alternate entrypoint that wraps the app with `device_preview_plus` for UI previewing. It does not perform the same Firebase initialization as `main.dart`.

`MyApp` configures `ScreenUtilInit` with design size `360x690`, a `MaterialApp`, the global `NavigationService.navigatorKey`, static routes, and `generateRoutes` from `lib/utils/routers.dart`. Initial screen is `SplashScreen`.

### State management and screen organization

State is Provider/ChangeNotifier based. `lib/providers/BaseViewModel.dart` defines shared loading/error state and an `execute` helper. Feature view models live under each screen feature directory, for example:

- `lib/screens/authen_screen/provider/`
- `lib/screens/home_screen/providers/`
- `lib/screens/fire_news_screen/providers/`
- `lib/screens/fire_safety_skills_screen/providers/`
- `lib/screens/fire_map_screen/providers/`
- `lib/screens/profile_screen/providers/`
- `lib/screens/setting_screen/providers/`
- `lib/screens/family_manager_screen/providers/`

Global providers are registered in `lib/providers/provider_setup.dart`. Some routes and tabs also wrap screens in feature-specific `ChangeNotifierProvider`s, so check provider scope before adding or moving state.

Feature code is grouped by `models/`, `providers/`, `views/`, and `widget/` directories under `lib/screens/<feature>_screen/`. `lib/screens/main_app.dart` owns the bottom navigation tabs: Home, Fire News, Fire Safety Skills, and Personal Profile.

### Navigation

Routes are centralized in `lib/utils/routers.dart`:

- `routes` maps simple named routes to widget builders.
- `generateRoutes` handles routes that need a per-route provider wrapper.

Screens generally expose a static `routeName`; use those constants rather than duplicating route strings.

### Networking and backend services

HTTP calls are centralized around Dio:

- `lib/service/base_connect.dart` creates the Dio client with the base URL from `StatusApi.BASE_API_URL`, JSON headers, timeout, and bearer token from `LocalStorageHelper.getValue('authToken')`.
- `lib/service/service_config/network_service.dart` is a singleton wrapper around `BaseConnect`; it adds Dio logging and `LoadingInterceptor`, exposes a loading `ValueNotifier`, and can update base URL or auth token.
- `lib/service/api_service/BaseApiService.dart` provides `sendRequest<T>()`, wraps responses in `BaseResponse<T>`, maps non-200/201 backend codes to a dialog, and catches connection errors with a generic server-error dialog.
- `lib/service/api_service/api_service.dart` contains app-specific endpoint methods for sensors, notifications, auth, family contacts, locations, device status, guides/news, history, and profile updates.
- Endpoint paths live in `lib/service/common/url_static.dart`; base API defaults live in `lib/service/common/status_api.dart`.

Request and response DTOs are kept under `lib/service/api_service/request/` and `lib/service/api_service/response/`. Several DTOs use `json_annotation`/generated serialization patterns; run build_runner when changing generated models.

### Firebase, Remote Config, notifications, and local data

Firebase setup is in `lib/main.dart`. `FirebaseService` in `lib/service/service_config/firebase_service.dart` mixes in `RemoteConfigService` from `remote_config_service.dart`. Remote Config reads `baseUrlServer` and updates `NetworkService.instance` when config is fetched or changed; fallback URL is `StatusApi.BASE_API_URL`.

Notifications are initialized from `NotificationService.init(context)` after the first app frame in `MyApp`.

Local persistence uses Hive via `LocalStorageHelper` (`lib/utils/core/helpers/local_storage_helper.dart`) and an older/shared-preferences helper exists at `lib/utils/share_prefer_utils.dart`. Check existing call sites before choosing one.

### Localization and assets

Localization uses `easy_localization` with supported locales `en_US` and `vi_VN`; translation files are under `assets/translations/` and registered in `pubspec.yaml`.

Assets registered in `pubspec.yaml` include:

- `assets/translations/`
- `assets/images/`
- `assets/icons/`
- `assets/sounds/alarm.wav`
- `.env`

Common constants and helpers are exported via `lib/init.dart`, including color/dimension constants, asset/image helpers, local storage, toast, and key screens.

## Notes from existing project files

- `analysis_options.yaml` only includes `package:flutter_lints/flutter.yaml`; no custom lint rules are currently enabled.
- The existing `test/widget_test.dart` is entirely commented out, so `flutter test` may report no active widget assertions until tests are added.
- `pubspec.yaml` pins dependency overrides for `app_links: 6.3.3` and `geolocator_android: 4.6.1` because newer versions used `flutter.compileSdkVersion` in a way that broke builds with the newer Flutter Gradle plugin. Preserve or re-check these overrides when upgrading dependencies.
- `pubspec.yaml` contains `false_secrets: android/app/google-services.json`, indicating that file is intentionally present despite secret-scanning concerns.
