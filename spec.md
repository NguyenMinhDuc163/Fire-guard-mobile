# SPEC: ADD PRE-RELEASE VALIDATION WORKFLOW

Repository:
NguyenMinhDuc163/Fire-guard-mobile

Goal:
Add a validation workflow that runs before mobile release to catch missing/invalid secrets and signing config before starting expensive macOS/iOS build jobs.

==================================================
1. FILES
==================================================

Add:

.github/workflows/reusable-validate-project.yml

Modify:

.github/workflows/mobile-store-release.yml

Do not change:
- reusable-ios-testflight.yml signing flow
- Android build logic
- Fastlane Match logic
- apple-signing repo

==================================================
2. VALIDATION WORKFLOW
==================================================

Use:

runs-on: ubuntu-24.04

workflow_call secrets:

APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8

IOS_TEAM_ID

MATCH_GIT_URL
MATCH_PASSWORD
MATCH_GIT_BASIC_AUTHORIZATION

ENV_FILE_CONTENTS

All required.

==================================================
3. BASIC SECRET CHECK
==================================================

Fail if any required secret is empty.

Required:

APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8
IOS_TEAM_ID
MATCH_GIT_URL
MATCH_PASSWORD
MATCH_GIT_BASIC_AUTHORIZATION
ENV_FILE_CONTENTS

Do not print secret values.

Allowed log:

✅ MATCH_PASSWORD present
❌ ENV_FILE_CONTENTS missing

==================================================
4. STATIC VALUE VALIDATION
==================================================

Validate:

IOS_TEAM_ID == Q236Z72BGN

MATCH_GIT_URL ==
https://github.com/NguyenMinhDuc163/apple-signing.git

APP_STORE_CONNECT_API_KEY_P8 contains:

BEGIN PRIVATE KEY
END PRIVATE KEY

MATCH_GIT_BASIC_AUTHORIZATION:
- valid Base64
- decodes to a string containing ":"
- do not print decoded value

==================================================
5. VALIDATE ENV_FILE_CONTENTS
==================================================

Parse ENV_FILE_CONTENTS as dotenv.

Read required env keys from the project source instead of hardcoding
a duplicated list if practical.

At minimum:
- detect keys referenced by envied / environment config used by app
- ensure each required key exists
- ensure value is not empty
- reject obvious placeholders:
  YOUR_KEY
  CHANGE_ME
  TODO
  REPLACE_ME

Do not print env values.

Log only:

✅ ENV_FILE_CONTENTS: 12/12 required keys present

or:

❌ Missing env key: IOS_ADMOB_APP_ID

==================================================
6. VALIDATE APPLE-SIGNING ACCESS
==================================================

Using:

MATCH_GIT_BASIC_AUTHORIZATION

verify that CI can read:

NguyenMinhDuc163/apple-signing

Do not use GITHUB_TOKEN for cross-repo access.

Do not modify apple-signing.

Read-only only.

==================================================
7. VALIDATE MATCH PASSWORD
==================================================

Verify MATCH_PASSWORD can actually decrypt the Match repository.

Use Fastlane Match in read-only verification mode if practical.

Required:

type: appstore
platform: ios
app_identifier: com.nguyenduc.fireGuard
readonly: true

Validation must confirm Match can access and decrypt the signing repo.

Do not:
- create certificate
- renew profile
- readonly:false
- match nuke

==================================================
8. VALIDATE FIRE GUARD PROFILE
==================================================

Verify Match provides an App Store profile for:

com.nguyenduc.fireGuard

Validate profile:

Team ID:
Q236Z72BGN

application identifier:
Q236Z72BGN.com.nguyenduc.fireGuard

aps-environment:
production

Fail validation if any value is wrong.

Do not regenerate the profile automatically.

==================================================
9. VALIDATE APP STORE CONNECT AUTH
==================================================

Create temporary:

$RUNNER_TEMP/AuthKey.p8

from:

APP_STORE_CONNECT_API_KEY_P8

Use:
- APP_STORE_CONNECT_KEY_ID
- APP_STORE_CONNECT_ISSUER_ID
- .p8

Perform a lightweight authenticated App Store Connect request through
Fastlane.

Goal:
confirm the API key is valid and not revoked.

Do not upload anything.

Do not create/edit app versions.

Delete the temporary .p8 after validation.

==================================================
10. RELEASE PIPELINE INTEGRATION
==================================================

Modify:

.github/workflows/mobile-store-release.yml

Add first job:

validate_project

using:

./.github/workflows/reusable-validate-project.yml

with:

secrets: inherit

Then make:

bump_version

depend on:

validate_project

Expected flow:

validate_project
    ↓
bump_version
    ↓
build_testflight / build_google_play

If validation fails:

- do not bump pubspec version
- do not start macOS runner
- do not build iOS
- do not upload stores

==================================================
11. IMPORTANT
==================================================

Validation must run BEFORE version bump.

Reason:
A failed secret/config check must not create useless version bump commits.

==================================================
12. SECURITY
==================================================

Never log:

MATCH_PASSWORD
MATCH_GIT_BASIC_AUTHORIZATION
APP_STORE_CONNECT_API_KEY_P8
ENV_FILE_CONTENTS
PAT

Never modify:
- apple-signing
- Apple certificates
- provisioning profiles
- App Store Connect records

Validation is read-only.

==================================================
13. OPTIONAL MANUAL RUN
==================================================

If useful, also allow:

workflow_dispatch

on reusable-validate-project.yml or create:

.github/workflows/validate-project.yml

that simply calls the reusable validation workflow.

This allows manually running:

Actions
→ Validate Project

without triggering release.

==================================================
14. EXPECTED OUTPUT
==================================================

Example success log:

✅ Required secrets: 8/8
✅ IOS_TEAM_ID valid
✅ MATCH_GIT_URL valid
✅ ASC .p8 format valid
✅ MATCH Git authorization valid
✅ apple-signing repository readable
✅ MATCH_PASSWORD decrypt successful
✅ App Store profile found: com.nguyenduc.fireGuard
✅ Profile Team ID valid
✅ aps-environment=production
✅ ENV_FILE_CONTENTS: all required keys present
✅ App Store Connect authentication successful

Validation passed.

==================================================
15. ACCEPTANCE CRITERIA
==================================================

Complete when:

[ ] reusable-validate-project.yml exists

[ ] validation runs on Ubuntu

[ ] all required secrets checked

[ ] ENV_FILE_CONTENTS keys validated

[ ] MATCH repo access verified

[ ] MATCH_PASSWORD decrypt verified

[ ] Fire Guard profile verified

[ ] aps-environment=production verified

[ ] App Store Connect auth verified

[ ] validation is read-only

[ ] no secrets printed

[ ] mobile-store-release waits for validation

[ ] version bump runs only after validation success

[ ] iOS/macOS runner does not start when validation fails

[ ] Android flow behavior remains unchanged after validation passes

==================================================
16. FINAL AGENT REPORT
==================================================

Report only:

Changed files:
- ...

Validation checks added:
- ...

Release dependency:
validate → bump_version → build

Confirm:
- no secrets printed
- apple-signing not modified
- no certificate/profile created
- no store upload triggered during validation