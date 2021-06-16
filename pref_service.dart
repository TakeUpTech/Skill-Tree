import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class PreferencesService{
  Future saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('reserve', settings.reserve);
    await prefs.setStringList('level', settings.level.map((i) => i.toString()).toList());

    print('Saved Settings');
  }

  Future<Settings> getSettings() async {
    final prefs =  await SharedPreferences.getInstance();

    final reserve = prefs.getInt('reserve');
    final level = prefs.getStringList('level')!.map((e) => int.parse(e)).toList();

    return Settings(
        reserve: reserve!.toInt(),
        level: level
    );
  }
}