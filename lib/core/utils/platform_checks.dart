// Cross-platform platform checks.
//
// We use conditional exports to avoid importing `dart:io` on web builds.
export 'platform_checks_stub.dart' if (dart.library.io) 'platform_checks_io.dart';

