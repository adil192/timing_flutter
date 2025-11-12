import 'package:stow_plain/stow_plain.dart';

final stows = Stows();

class Stows {
  /// If true, stows will not save anything to disk.
  /// Useful for testing. Set to false in production.
  static bool volatile = true;

  final easyMode = PlainStow('easyMode', true, volatile: volatile);
}
