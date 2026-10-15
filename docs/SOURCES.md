# Sources

Official documentation used to write the tool manifests and the CLI install targets.
Plugin formats change often; re-check these pages before changing a manifest.

Last checked: 2026-10-15 (manifests rechecked before the pre-launch changes).

## Agent Skills format

| Topic | URL |
|---|---|
| Agent Skills specification (`SKILL.md` frontmatter, name rules, 1024-char description, 500-line guidance) | https://agentskills.io/specification |
| Agent Plugins specification 1.0.0 (root `plugin.json`). Not used: Agent Plugins 1.0 defines only skills and MCP servers, and Copilot CLI then ignores root `agents/` and `commands/` | https://agent-plugins.org/specification |

## Claude Code

| Topic | URL |
|---|---|
| Create a marketplace, `claude plugin validate`, local install loop | https://code.claude.com/docs/en/plugin-marketplaces.md |
| Marketplace reference (top-level fields, reserved names, relative `source`) | https://code.claude.com/docs/en/plugins/marketplace-reference.md |
| Plugin manifest reference (`.claude-plugin/plugin.json`, default `skills/` scan) | https://code.claude.com/docs/en/plugins-reference.md |

## OpenAI Codex

| Topic | URL |
|---|---|
| Build plugins (portable root `plugin.json`, `.codex-plugin/plugin.json` fallback, `.agents/plugins/marketplace.json`) | https://developers.openai.com/codex/plugins/build.md |
| Skills discovery paths (`.agents/skills`, `~/.agents/skills`) | https://learn.chatgpt.com/docs/build-skills.md (redirect target of https://developers.openai.com/codex/skills.md) |

## Gemini CLI

| Topic | URL |
|---|---|
| Extension reference (`gemini-extension.json`, `contextFileName`, `skills/` in extensions, install and link) | https://geminicli.com/docs/extensions/reference.md |
| Skills discovery (`.gemini/skills`, `.agents/skills`, `~/.gemini/skills`, `~/.agents/skills`) | https://geminicli.com/docs/cli/skills.md |

## GitHub Copilot

| Topic | URL |
|---|---|
| Copilot CLI plugin reference (manifest lookup order, Agent Plugins precedence, marketplace locations, skill paths) | https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference |
| Creating skills (`.github/skills`, `.claude/skills`, `.agents/skills`, `~/.copilot/skills`, `~/.agents/skills`) | https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/create-skills |

## Cursor

| Topic | URL |
|---|---|
| Skills (`.agents/skills`, `.cursor/skills`, `~/.cursor/skills`, compatibility directories) | https://cursor.com/docs/skills |
| Plugins reference (`.cursor-plugin/plugin.json`, multi-plugin `marketplace.json`, submission checklist) | https://cursor.com/docs/reference/plugins |
| Plugins overview (install paths, single-plugin repositories) | https://cursor.com/docs/plugins |
| Official plugin template (single plugin: keep `.cursor-plugin/plugin.json` at the root, no `marketplace.json`) | https://github.com/cursor/plugin-template |

## Google Antigravity

| Topic | URL |
|---|---|
| Skills (`.agents/skills`, `~/.gemini/config/skills`, CLI and legacy paths) | https://antigravity.google/docs/skills |

## Windsurf (Devin Desktop)

| Topic | URL |
|---|---|
| Cascade skills (`.devin/skills`, legacy `.windsurf/skills`, `.agents/skills`, `~/.codeium/windsurf/skills`) | https://docs.devin.ai/desktop/cascade/skills (redirect target of https://docs.windsurf.com/windsurf/cascade/skills) |

## Dart and pub.dev

| Topic | URL |
|---|---|
| CLI distribution (`dart install`, AOT, `executables:`) | https://dart.dev/tools/cli-distribution |
| Automated publishing from GitHub Actions (OIDC, tag pattern, environments) | https://dart.dev/tools/pub/automated-publishing |

## npm

| Topic | URL |
|---|---|
| Trusted publishing with GitHub Actions (OIDC, automatic provenance, npm 11.5.1+) | https://docs.npmjs.com/trusted-publishers |

## Skill zip uploads

| Topic | URL |
|---|---|
| Claude.ai skill packaging (`<skill>/SKILL.md` as the top-level folder of the zip) | https://claude.com/docs/skills/how-to.md |
| OpenAI skills bundles (one top-level folder, one `SKILL.md` per bundle) | https://developers.openai.com/api/docs/guides/tools-skills |

## EU law and standards (used by `mobile-eu-compliance`)

Texts were read from the Official Journal versions served by the EU Publications Office
(`http://publications.europa.eu/resource/celex/<CELEX>`), the same documents EUR-Lex shows.

| Act | Used for | URL |
|---|---|---|
| Regulation (EU) 2024/2847, Cyber Resilience Act (CELEX 32024R2847) | Art. 2, 3, 7, 13, 14, 32, 71; Annexes I, II, III, IV, VII | https://eur-lex.europa.eu/eli/reg/2024/2847/oj/eng |
| European Commission, Cyber Resilience Act policy page | Dates as communicated by the Commission | https://digital-strategy.ec.europa.eu/en/policies/cyber-resilience-act |
| Delegated Regulation (EU) 2022/30 (CELEX 32022R0030) | RED Art. 3(3)(d), (e), (f) scope and exclusions | https://eur-lex.europa.eu/eli/reg_del/2022/30/oj/eng |
| Delegated Regulation (EU) 2023/2444 (CELEX 32023R2444) | Application date moved to 1 August 2025 | https://eur-lex.europa.eu/eli/reg_del/2023/2444/oj/eng |
| Implementing Decision (EU) 2025/138 (CELEX 32025D0138) | EN 18031-1/-2/-3:2024 citations and restrictions | https://eur-lex.europa.eu/eli/dec_impl/2025/138/oj/eng |
| Regulation (EU) 2016/679, GDPR (CELEX 32016R0679) | Recital 30; Art. 5-9, 12-21, 25, 28, 30, 32-35, 44 | https://eur-lex.europa.eu/eli/reg/2016/679/oj/eng |
| Directive 2002/58/EC as amended, ePrivacy (consolidated CELEX 02002L0058-20091219) | Art. 5(3) | https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 |
| ETSI EN 303 645 deliverables (latest V3.1.3) | Consumer IoT baseline provisions | https://www.etsi.org/deliver/etsi_en/303600_303699/303645/ |
| ETSI TS 103 701 deliverables (latest V2.1.1) | Assessment specification for EN 303 645 | https://www.etsi.org/deliver/etsi_ts/103700_103799/103701/ |

Could not be verified from an official source: whether a BLE device that reaches the internet only through a
companion app is "internet-connected radio equipment" under Delegated Regulation (EU) 2022/30. The skill
records this as an open question.

## Bluetooth Low Energy (used by `mobile-ble`)

| Topic | URL |
|---|---|
| Android Bluetooth permissions | https://developer.android.com/develop/connectivity/bluetooth/bt-permissions |
| BluetoothGatt | https://developer.android.com/reference/android/bluetooth/BluetoothGatt |
| BluetoothGattCallback | https://developer.android.com/reference/android/bluetooth/BluetoothGattCallback |
| BluetoothDevice (connectGatt overloads, bonding) | https://developer.android.com/reference/android/bluetooth/BluetoothDevice |
| BluetoothStatusCodes | https://developer.android.com/reference/android/bluetooth/BluetoothStatusCodes |
| ScanSettings | https://developer.android.com/reference/android/bluetooth/le/ScanSettings |
| ScanCallback | https://developer.android.com/reference/android/bluetooth/le/ScanCallback |
| BluetoothLeScanner | https://developer.android.com/reference/android/bluetooth/le/BluetoothLeScanner |
| Find BLE devices | https://developer.android.com/develop/connectivity/bluetooth/ble/find-ble-devices |
| BLE in the background | https://developer.android.com/develop/connectivity/bluetooth/ble/background |
| CompanionDeviceManager | https://developer.android.com/reference/android/companion/CompanionDeviceManager |
| Foreground service types | https://developer.android.com/develop/background-work/services/fgs/service-types |
| Background start restrictions | https://developer.android.com/develop/background-work/services/fgs/restrictions-bg-start |
| Android 15 behavior changes | https://developer.android.com/about/versions/15/behavior-changes-15 |
| Android 16 behavior changes (all apps) | https://developer.android.com/about/versions/16/behavior-changes-all |
| Android 16 behavior changes (targeting 16) | https://developer.android.com/about/versions/16/behavior-changes-16 |
| Android 17 behavior changes (all apps) | https://developer.android.com/about/versions/17/behavior-changes-all |
| Android 17 behavior changes (targeting 17) | https://developer.android.com/about/versions/17/behavior-changes-17 |
| Emulator networking and Bluetooth | https://developer.android.com/studio/run/emulator-networking |
| CBCentralManager init (queue) | https://developer.apple.com/documentation/corebluetooth/cbcentralmanager/init(delegate:queue:options:) |
| CBCentralManager connect | https://developer.apple.com/documentation/corebluetooth/cbcentralmanager/connect(_:options:) |
| CBCentralManager scanning | https://developer.apple.com/documentation/corebluetooth/cbcentralmanager/scanforperipherals(withservices:options:) |
| retrievePeripherals(withIdentifiers:) | https://developer.apple.com/documentation/corebluetooth/cbcentralmanager/retrieveperipherals(withidentifiers:) |
| State restoration identifier | https://developer.apple.com/documentation/corebluetooth/cbcentralmanageroptionrestoreidentifierkey |
| willRestoreState | https://developer.apple.com/documentation/corebluetooth/cbcentralmanagerdelegate/centralmanager(_:willrestorestate:) |
| maximumWriteValueLength(for:) | https://developer.apple.com/documentation/corebluetooth/cbperipheral/maximumwritevaluelength(for:) |
| canSendWriteWithoutResponse | https://developer.apple.com/documentation/corebluetooth/cbperipheral/cansendwritewithoutresponse |
| Auto reconnect option (iOS 17) | https://developer.apple.com/documentation/corebluetooth/cbconnectperipheraloptionenableautoreconnect |
| CBManager authorization | https://developer.apple.com/documentation/corebluetooth/cbmanager/authorization-swift.type.property |
| NSBluetoothAlwaysUsageDescription | https://developer.apple.com/documentation/bundleresources/information-property-list/nsbluetoothalwaysusagedescription |
| UIBackgroundModes | https://developer.apple.com/documentation/bundleresources/information-property-list/uibackgroundmodes |
| AccessorySetupKit | https://developer.apple.com/documentation/accessorysetupkit |
| TN3115: Bluetooth state restoration app relaunch rules | https://developer.apple.com/documentation/technotes/tn3115-bluetooth-state-restoration-app-relaunch-rules |
| Simulator and Core Bluetooth (archived TN2295) | https://developer.apple.com/library/archive/technotes/tn2295/_index.html |
| flutter_blue_plus (licence, setup) | https://pub.dev/packages/flutter_blue_plus |
| flutter_blue_plus changelog | https://pub.dev/packages/flutter_blue_plus/changelog |
| flutter_blue_plus connect() | https://pub.dev/documentation/flutter_blue_plus/latest/flutter_blue_plus/BluetoothDevice/connect.html |
| permission_handler | https://pub.dev/packages/permission_handler |
| Bluetooth Core: ATT (512-octet attribute limit) | https://www.bluetooth.com/wp-content/uploads/Files/Specification/HTML/Core-54/out/en/host/attribute-protocol--att-.html |
| Bluetooth Core: GATT (default ATT_MTU 23) | https://www.bluetooth.com/wp-content/uploads/Files/Specification/HTML/Core-60/out/en/host/generic-attribute-profile--gatt-.html |
| Bluetooth Core: Security Manager | https://www.bluetooth.com/wp-content/uploads/Files/Specification/HTML/Core-54/out/en/host/security-manager-specification.html |
| Bluetooth pairing (LE Secure Connections) | https://www.bluetooth.com/blog/bluetooth-pairing-part-4/ |
| nRF Connect for Mobile | https://www.nordicsemi.com/Products/Development-tools/nRF-Connect-for-mobile |
| CRC-16 catalogue | https://reveng.sourceforge.io/crc-catalogue/16.htm |

## Accessibility (used by `mobile-accessibility`)

| Topic | URL |
|---|---|
| European Accessibility Act, Directive (EU) 2019/882 (CELEX 32019L0882; Art. 2, 3, 4(5), 13, 14, 31, 32, 33, Annexes I and V) | https://eur-lex.europa.eu/eli/dir/2019/882/oj/eng |
| ETSI EN 301 549 deliverables (latest V4.1.1, 2026-09) | https://www.etsi.org/deliver/etsi_en/301500_301599/301549/ |
| ETSI EN 301 549 V4.1.1 (foreword, clause 11 software, mobile apps and web views) | https://www.etsi.org/deliver/etsi_en/301500_301599/301549/04.01.01_60/en_301549v040101p.pdf |
| WCAG 2.2 | https://www.w3.org/TR/WCAG22/ |
| Compose semantics | https://developer.android.com/develop/ui/compose/accessibility/semantics |
| Compose accessibility API defaults | https://developer.android.com/develop/ui/compose/accessibility/api-defaults |
| Compose accessibility testing | https://developer.android.com/develop/ui/compose/accessibility/testing |
| ui-test-junit4-accessibility | https://developer.android.com/reference/kotlin/androidx/compose/ui/test/junit4/accessibility/package-summary |
| minimumInteractiveComponentSize | https://developer.android.com/reference/kotlin/androidx/compose/material3/minimumInteractiveComponentSize.modifier |
| Compose semantics properties | https://developer.android.com/reference/kotlin/androidx/compose/ui/semantics/package-summary |
| Compose test matchers and assertions | https://developer.android.com/reference/kotlin/androidx/compose/ui/test/package-summary |
| Espresso AccessibilityChecks | https://developer.android.com/reference/androidx/test/espresso/accessibility/AccessibilityChecks |
| Android accessibility testing (Scanner, TalkBack, Switch Access) | https://developer.android.com/guide/topics/ui/accessibility/testing |
| Accessibility Scanner | https://support.google.com/accessibility/android/answer/6376570 |
| Android 14 features (nonlinear font scaling) | https://developer.android.com/about/versions/14/features |
| performAccessibilityAudit | https://developer.apple.com/documentation/xcuiautomation/xcuiapplication/performaccessibilityaudit(for:_:) |
| XCUIAccessibilityAuditType | https://developer.apple.com/documentation/xcuiautomation/xcuiaccessibilityaudittype |
| WWDC23: Perform accessibility audits | https://developer.apple.com/videos/play/wwdc2023/10035/ |
| AccessibilityNotification.Announcement | https://developer.apple.com/documentation/accessibility/accessibilitynotification/announcement |
| SwiftUI accessibility modifiers | https://developer.apple.com/documentation/swiftui/ |
| Human Interface Guidelines: Accessibility | https://developer.apple.com/design/human-interface-guidelines/accessibility |
| Flutter meetsGuideline and guideline constants | https://api.flutter.dev/flutter/flutter_test/meetsGuideline.html |
| Flutter Semantics | https://api.flutter.dev/flutter/widgets/Semantics-class.html |
| Flutter TextScaler | https://api.flutter.dev/flutter/painting/TextScaler-class.html |
| Flutter SemanticsService | https://api.flutter.dev/flutter/semantics/SemanticsService-class.html |

## Kotlin Multiplatform (used by `mobile-kmp`)

| Topic | URL |
|---|---|
| Default hierarchy template | https://kotlinlang.org/docs/multiplatform/multiplatform-hierarchy.html |
| Multiplatform Gradle DSL reference | https://kotlinlang.org/docs/multiplatform/multiplatform-dsl-reference.html |
| Kotlin/Native target support tiers | https://kotlinlang.org/docs/native-target-support.html |
| Android KMP library plugin | https://developer.android.com/kotlin/multiplatform/plugin |
| AGP 9 migration for KMP projects | https://kotlinlang.org/docs/multiplatform/multiplatform-project-agp-9-migration.html |
| Supported platforms and stability | https://kotlinlang.org/docs/multiplatform/supported-platforms.html |
| Compose Multiplatform compatibility and versions | https://kotlinlang.org/docs/multiplatform/compose-compatibility-and-versioning.html |
| What's new in Compose Multiplatform 1.10 | https://kotlinlang.org/docs/multiplatform/whats-new-compose-110.html |
| Compose and SwiftUI integration | https://kotlinlang.org/docs/multiplatform/compose-swiftui-integration.html |
| Compose Multiplatform and Jetpack Compose | https://kotlinlang.org/docs/multiplatform/compose-multiplatform-and-jetpack-compose.html |
| Common ViewModel (Compose Multiplatform) | https://kotlinlang.org/docs/multiplatform/compose-viewmodel.html |
| ViewModel for KMP (Android docs) | https://developer.android.com/kotlin/multiplatform/viewmodel |
| expect / actual | https://kotlinlang.org/docs/multiplatform/multiplatform-expect-actual.html |
| Objective-C and Swift interop | https://kotlinlang.org/docs/native-objc-interop.html |
| Swift export | https://kotlinlang.org/docs/native-swift-export.html |
| Building native binaries and XCFrameworks | https://kotlinlang.org/docs/multiplatform/multiplatform-build-native-binaries.html |
| SPM export | https://kotlinlang.org/docs/multiplatform/multiplatform-spm-export.html |
| SPM import | https://kotlinlang.org/docs/multiplatform/multiplatform-spm-import.html |
| iOS integration options | https://kotlinlang.org/docs/multiplatform/multiplatform-ios-integration-overview.html |
| Direct integration | https://kotlinlang.org/docs/multiplatform/multiplatform-direct-integration.html |
| Running multiplatform tests | https://kotlinlang.org/docs/multiplatform/multiplatform-run-tests.html |
| SKIE overview, installation, flows, suspend, sealed, default arguments | https://skie.touchlab.co/intro |
| KMP-NativeCoroutines | https://github.com/rickclephas/KMP-NativeCoroutines |
| Room KMP | https://developer.android.com/kotlin/multiplatform/room |
| Room 3 releases | https://developer.android.com/jetpack/androidx/releases/room3 |
| SQLDelight multiplatform | https://sqldelight.github.io/sqldelight/latest/multiplatform_sqlite/ |
| SQLDelight coroutines | https://sqldelight.github.io/sqldelight/latest/multiplatform_sqlite/coroutines/ |
| Ktor client engines | https://ktor.io/docs/client-engines.html |
| Turbine | https://github.com/cashapp/turbine |

## Store policies (used by `mobile-release`)

| Topic | URL |
|---|---|
| Play target API level requirement (API 36 for new apps and updates since 31 Aug 2026; form factor exceptions; extension to 1 Nov 2026) | https://support.google.com/googleplay/android-developer/answer/11926878 |
| Target SDK requirements (developer site) | https://developer.android.com/google/play/requirements/target-sdk |
| Data safety section | https://support.google.com/googleplay/android-developer/answer/10787469 |
| Account deletion requirement | https://support.google.com/googleplay/android-developer/answer/13327111 |
| Background location access | https://support.google.com/googleplay/android-developer/answer/9799150 |
| SMS and Call Log permissions | https://support.google.com/googleplay/android-developer/answer/10208820 |
| QUERY_ALL_PACKAGES | https://support.google.com/googleplay/android-developer/answer/10158779 |
| Foreground service declaration | https://support.google.com/googleplay/android-developer/answer/13392821 |
| Foreground service types | https://developer.android.com/develop/background-work/services/fgs/service-types |
| Play App Signing | https://support.google.com/googleplay/android-developer/answer/9842756 |
| Android App Bundle requirement | https://support.google.com/googleplay/android-developer/answer/9859348 |
| Staged rollouts | https://support.google.com/googleplay/android-developer/answer/6346149 |
| Testing tracks | https://support.google.com/googleplay/android-developer/answer/9845334 |
| Testing requirements for new personal accounts | https://support.google.com/googleplay/android-developer/answer/14151465 |
| Pre-launch report | https://support.google.com/googleplay/android-developer/answer/9844487 |
| Pre-launch report settings | https://support.google.com/googleplay/android-developer/answer/9842757 |
| Android vitals and bad behavior thresholds | https://developer.android.com/topic/performance/vitals |
| Versioning (versionCode rules) | https://developer.android.com/studio/publish/versioning |
| Apple upcoming requirements (Xcode 26 SDK since 28 Apr 2026, minimum targets) | https://developer.apple.com/news/upcoming-requirements/ |
| App Store Review Guidelines | https://developer.apple.com/app-store/review/guidelines/ |
| Required reason APIs | https://developer.apple.com/documentation/bundleresources/describing-use-of-required-reason-api |
| NSPrivacyAccessedAPIType reasons | https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitype |
| Privacy manifest files | https://developer.apple.com/documentation/bundleresources/privacy-manifest-files |
| Adding a privacy manifest | https://developer.apple.com/documentation/bundleresources/adding-a-privacy-manifest-to-your-app-or-third-party-sdk |
| Third-party SDK requirements | https://developer.apple.com/support/third-party-SDK-requirements/ |
| App Privacy details | https://developer.apple.com/app-store/app-privacy-details/ |
| User privacy and data use (ATT) | https://developer.apple.com/app-store/user-privacy-and-data-use/ |
| AppTrackingTransparency | https://developer.apple.com/documentation/apptrackingtransparency |
| Offering account deletion | https://developer.apple.com/support/offering-account-deletion-in-your-app/ |
| Phased release | https://developer.apple.com/help/app-store-connect/update-your-app/release-a-version-update-in-phases |
| TestFlight overview | https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview |
| App Review and expedited review | https://developer.apple.com/distribute/app-review/ |
| CFBundleVersion | https://developer.apple.com/documentation/bundleresources/information-property-list/cfbundleversion |
| CFBundleShortVersionString | https://developer.apple.com/documentation/bundleresources/information-property-list/cfbundleshortversionstring |
| MetricKit | https://developer.apple.com/documentation/metrickit |

## Testing (used by `mobile-testing`)

| Topic | URL |
|---|---|
| Roborazzi (plugin, tasks, properties, rendering notes) | https://github.com/takahirom/roborazzi |
| Paparazzi | https://github.com/cashapp/paparazzi |
| Paparazzi docs | https://cashapp.github.io/paparazzi/ |
| Paparazzi DeviceConfig (locale default) | https://raw.githubusercontent.com/cashapp/paparazzi/master/paparazzi/src/main/java/app/cash/paparazzi/DeviceConfig.kt |
| swift-snapshot-testing (API, record modes, SNAPSHOT_TESTING_RECORD) | https://github.com/pointfreeco/swift-snapshot-testing |
| Flutter matchesGoldenFile | https://api.flutter.dev/flutter/flutter_test/matchesGoldenFile.html |
| flutter_test library (flutter_test_config.dart) | https://api.flutter.dev/flutter/flutter_test/ |
| pumpAndSettle | https://api.flutter.dev/flutter/flutter_test/WidgetTester/pumpAndSettle.html |
| TestFlutterView | https://api.flutter.dev/flutter/flutter_test/TestFlutterView-class.html |
| flutter test flags (shards, tags, goldens) | https://raw.githubusercontent.com/flutter/flutter/master/packages/flutter_tools/lib/src/commands/test.dart |
| Flutter integration tests | https://docs.flutter.dev/testing/integration-tests |
| Compose testing | https://developer.android.com/develop/ui/compose/testing |
| Compose testing v2 migration | https://developer.android.com/develop/ui/compose/testing/migrate-v2 |
| Compose UI releases | https://developer.android.com/jetpack/androidx/releases/compose-ui |
| Compose test synchronization | https://developer.android.com/develop/ui/compose/testing/synchronization |
| Compose test common patterns | https://developer.android.com/develop/ui/compose/testing/common-patterns |
| ComposeContentTestRule | https://developer.android.com/reference/kotlin/androidx/compose/ui/test/junit4/ComposeContentTestRule |
| AndroidJUnitRunner (sharding, Orchestrator) | https://developer.android.com/training/testing/instrumented-tests/androidx-test-libraries/runner |
| Gradle managed devices | https://developer.android.com/studio/test/gradle-managed-devices |
| Test from the command line | https://developer.android.com/studio/test/command-line |
| Testing strategies | https://developer.android.com/training/testing/fundamentals/strategies |
| Compose Preview Screenshot Testing | https://developer.android.com/studio/preview/compose-screenshot-testing |
| Robolectric device configuration | https://robolectric.org/device-configuration/ |
| Kover | https://github.com/Kotlin/kotlinx-kover |
| Kover Gradle plugin | https://kotlin.github.io/kotlinx-kover/gradle-plugin/ |
| Gradle test-retry plugin | https://github.com/gradle/test-retry-gradle-plugin |
| xcodebuild test options, XCTest and XCUIAutomation headers | `man xcodebuild` and the Xcode SDK headers (local, Xcode 16.3) |

## Performance (used by `mobile-performance`)

Apple documentation pages were read through their JSON endpoints
(`https://developer.apple.com/tutorials/data/documentation/<path>.json`) because the HTML renders client-side.

| Topic | URL |
|---|---|
| Android vitals and thresholds | https://developer.android.com/topic/performance/vitals |
| Play Console vitals metrics (startup, frames, Wi-Fi scans, background network) | https://support.google.com/googleplay/android-developer/answer/9844486 |
| App startup time (TTID, TTFD, reportFullyDrawn) | https://developer.android.com/topic/performance/vitals/launch-time |
| App Startup library | https://developer.android.com/topic/libraries/app-startup |
| WorkManager: define work | https://developer.android.com/develop/background-work/background-tasks/persistent/getting-started/define-work |
| WorkManager: manage work | https://developer.android.com/develop/background-work/background-tasks/persistent/how-to/manage-work |
| Foreground service timeouts | https://developer.android.com/develop/background-work/services/fgs/timeout |
| Android 16 behavior changes (job quotas) | https://developer.android.com/about/versions/16/behavior-changes-all |
| Doze and App Standby | https://developer.android.com/training/monitoring-device-state/doze-standby |
| Create Baseline Profiles | https://developer.android.com/topic/performance/baselineprofiles/create-baselineprofile |
| Measure Baseline Profiles | https://developer.android.com/topic/performance/baselineprofiles/measure-baselineprofile |
| Baseline Profiles overview | https://developer.android.com/topic/performance/baselineprofiles/overview |
| DEX layout optimizations and startup profiles | https://developer.android.com/topic/performance/baselineprofiles/dex-layout-optimizations |
| Macrobenchmark overview | https://developer.android.com/topic/performance/benchmarking/macrobenchmark-overview |
| Macrobenchmark metrics | https://developer.android.com/topic/performance/benchmarking/macrobenchmark-metrics |
| Macrobenchmark instrumentation arguments | https://developer.android.com/topic/performance/benchmarking/macrobenchmark-instrumentation-args |
| On-device system tracing (Perfetto) | https://developer.android.com/topic/performance/tracing/on-device |
| Custom trace events | https://developer.android.com/topic/performance/tracing/custom-events |
| Compose composition tracing | https://developer.android.com/develop/ui/compose/tooling/tracing |
| Diagnose Compose stability issues | https://developer.android.com/develop/ui/compose/performance/stability/diagnose |
| Power Profiler | https://developer.android.com/studio/profile/power-profiler |
| APK Analyzer | https://developer.android.com/studio/build/apk-analyzer |
| Reduce app size | https://developer.android.com/topic/performance/reduce-apk-size |
| LeakCanary | https://square.github.io/leakcanary/getting_started/ |
| Reducing your app's launch time | https://developer.apple.com/documentation/xcode/reducing-your-app-s-launch-time |
| Improving app responsiveness (hangs) | https://developer.apple.com/documentation/xcode/improving-app-responsiveness |
| Understanding hitches | https://developer.apple.com/documentation/xcode/understanding-hitches-in-your-app |
| Understanding user interface responsiveness | https://developer.apple.com/documentation/xcode/understanding-user-interface-responsiveness |
| Understanding and improving SwiftUI performance | https://developer.apple.com/documentation/xcode/understanding-and-improving-swiftui-performance |
| Gathering information about memory use | https://developer.apple.com/documentation/xcode/gathering-information-about-memory-use |
| Reducing your app's size | https://developer.apple.com/documentation/xcode/reducing-your-app-s-size |
| MetricKit: MXMetricManager, MXAppLaunchMetric, MXHangDiagnostic, payloads | https://developer.apple.com/documentation/metrickit/mxmetricmanager |
| XCTest performance metrics (XCTApplicationLaunchMetric, XCTOSSignpostMetric, XCTHitchMetric, XCTMeasureOptions) | https://developer.apple.com/documentation/xctest/xctapplicationlaunchmetric |
| BGProcessingTaskRequest | https://developer.apple.com/documentation/backgroundtasks/bgprocessingtaskrequest |
| URLSessionConfiguration discretionary and constrained networking | https://developer.apple.com/documentation/foundation/urlsessionconfiguration |
| Flutter UI performance | https://docs.flutter.dev/perf/ui-performance |
| DevTools performance view | https://docs.flutter.dev/tools/devtools/performance |
| DevTools memory view | https://docs.flutter.dev/tools/devtools/memory |
| Flutter app size | https://docs.flutter.dev/perf/app-size |
| Impeller | https://docs.flutter.dev/perf/impeller |
| Profiling with integration tests | https://docs.flutter.dev/cookbook/testing/integration/profiling |
| Flutter code debugging (performance overlay) | https://docs.flutter.dev/testing/code-debugging |

## Plugin agents and commands

| Topic | URL |
|---|---|
| Claude Code plugin components (commands, agents, agent frontmatter) | https://code.claude.com/docs/en/plugins/components.md |
| Claude Code skills and commands (arguments, `!` injection, allowed-tools) | https://code.claude.com/docs/en/skills.md |
| Claude Code subagents (tools, skills, invocation) | https://code.claude.com/docs/en/sub-agents.md |
| Copilot CLI plugin reference (legacy vs Agent Plugins components, `.agent.md`) | https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference |
| Copilot custom agents configuration (frontmatter, tool aliases Read/Grep/Glob) | https://docs.github.com/en/copilot/reference/custom-agents-configuration |
| Cursor plugin agents and commands | https://cursor.com/docs/reference/plugins |
| Gemini CLI custom commands (TOML, `{{args}}`, `!{...}`, namespacing) | https://geminicli.com/docs/cli/custom-commands.md |
| Gemini CLI extension commands (`commands/` in an extension, `/a:b` names) | https://geminicli.com/docs/extensions/reference.md |
