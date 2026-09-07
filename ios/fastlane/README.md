# iOS Fastlane/TestFlight

Run from `ios/`:

```sh
bundle install
bundle exec fastlane ios build
bundle exec fastlane ios beta
```

Bundle identifier:

```text
com.nguyenduc.fireGuard
```

Version comes from `pubspec.yaml`:

```yaml
version: 1.0.0+35
```

Use `APP_STORE_CONNECT_API_KEY_KEY_FILEPATH` for a raw `.p8` file. Do not use `APP_STORE_CONNECT_API_KEY_PATH` for `.p8`.

Local `.env` shape:

```env
APP_STORE_CONNECT_KEY_ID=
APP_STORE_CONNECT_ISSUER_ID=
APP_STORE_CONNECT_API_KEY_KEY_FILEPATH=
```

GitHub Actions secrets:

```text
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8
IOS_TEAM_ID
MATCH_GIT_URL
MATCH_PASSWORD
MATCH_GIT_BASIC_AUTHORIZATION
ENV_FILE_CONTENTS
```

The reusable iOS workflow uses `setup_ci` and Fastlane Match in read-only mode
to install the existing Apple Distribution certificate and App Store profile.
`MATCH_GIT_BASIC_AUTHORIZATION` is Base64(`NguyenMinhDuc163:PAT`), not a raw
PAT; the PAT needs read-only Contents access to `NguyenMinhDuc163/apple-signing`.

The Match profile must validate:

```text
Team ID: Q236Z72BGN
Application identifier: Q236Z72BGN.com.nguyenduc.fireGuard
aps-environment: production
```

The workflow fails before build if this profile validation fails, and fails
before TestFlight upload if the archive version/build number or signed Push
Notifications entitlement differs from the expected production values. Do not
use `readonly: false`, `force`, or `match nuke` in routine CI.
