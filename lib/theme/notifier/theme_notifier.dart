import 'package:equatable/equatable.dart';
import '../../core/app_export.dart';
part 'theme_state.dart';

final StateNotifierProvider<ThemeNotifier, ThemeState> themeNotifier =
    StateNotifierProvider<ThemeNotifier, ThemeState>(
  (ref) => ThemeNotifier(ThemeState(themeType: PrefUtils().getThemeData())),
);

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier(super.state);

  Future<void> changeTheme(String themeType) async {
    PrefUtils().setThemeData(themeType);
    state = state.copyWith(themeType: PrefUtils().getThemeData());
  }
}
