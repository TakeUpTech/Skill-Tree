import 'dart:async';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skill_tree/pref_service.dart';

import 'models.dart';

void main() {
  giftDay();
  runApp(new MyApp());
}

// ignore: unused_element
late Timer _timer;

void giftDay(){
  print('start');

  _timer = Timer.periodic(Duration(seconds: 60), (timer) {
    reserve++;
    print('+1');
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skills tree',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _Home();
  }
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF183940),
      appBar: AppBar(
        backgroundColor: Color(0xFFF23D4C),
        leading: Icon(Icons.account_tree),
        title: Text('Skills tree'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () => deleteSettings(),
            icon: Icon(
              Icons.delete_forever,
              color: Colors.white
            )
          )
        ],
      ),
      body: Body(),
    );
  }

  void deleteSettings(){
    setState(() {
      descriptions = [false, false, false, false, false, false, false, false, false, false];
      level = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      reserve = 10;
    });
    _Body().commitSettings();
  }
}

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _Body();
  }
}

List<bool> descriptions = [false, false, false, false, false, false, false, false, false, false];
List<int> level = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
List<String> textTitle = [
  'Skill 1',
  'Skill 2',
  'Skill 3',
  'Skill 4',
  'Skill 5',
  'Skill 6',
  'Skill 7',
  'Skill 8',
  'Skill 9',
  'Skill 10'
];
List<String> textDescriptions = [
  'Description 1',
  'Description 2',
  'Description 3',
  'Description 4',
  'Description 5',
  'Description 6',
  'Description 7',
  'Description 8',
  'Description 9',
  'Description 10'
];
String mainText = '#N/A';
int reserve = 10;

class _Body extends State<Body> {

  final prefs = PreferencesService();

  @override
  void initState() {
    super.initState();
    updateSettings();
  }

  void updateSettings() async {
    final settings = await prefs.getSettings();
    setState(() {
      reserve = settings.reserve;
      level = settings.level;
    });
  }

  Color addButtonColor = Color(0xFFF23D4C);
  Color upgradePanelColor = Color(0xFF0CF2B1);
  Color treeLineColor = Color(0xFF0CF2B1);
  Color skillColor = Color(0xFF525252);
  Color skillMaxColor = Color(0xFFF2CB05);
  Color textColor = Colors.white;
  Color textUpgradeColor = Colors.black;

  double skillHeight = 55;
  double skillWidth = 55;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          lineSkillBox(1, 3),
          lineSkillBox(5, 2),
          lineSkillBox(8, 1),
          lineSkillBox(10, 0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (int index = 0; index < descriptions.length; index++)
                descriptionBox(index)
            ]
          )
        ]
      )
    );
  }

  Widget lineSkillBox(int indexStart, int nbSkillsBox){
    indexStart = indexStart - 1;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int index = indexStart; index <= indexStart+nbSkillsBox; index++)
          Row(
            children: <Widget>[
              skillBox(index),
              Visibility(visible: (index!=indexStart+nbSkillsBox), child: Container(height: 5, width: 30, color: treeLineColor))
            ]
          )
      ]
    );
  }

  Widget skillBox(int index) {
    return Container(
      height: skillHeight,
      width: skillWidth,
      margin: EdgeInsets.only(top: 10.0, bottom: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: treeLineColor, width: 3),
        color: (level[index] == 5) ? skillMaxColor : skillColor,
      ),
      child: TextButton(
        onPressed: () => showDescription(index, textDescriptions[index]),
        child: Text(
          textTitle[index],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: (level[index] == 5) ? textUpgradeColor : textColor,
          )
        )
      )
    );
  }

  Widget descriptionBox(int index){
    return Visibility(
      visible: descriptions[index],
      child: Container(
        height: 200,
        width: MediaQuery.of(context).size.width-60,
        margin: EdgeInsets.only(top: 10),
        color: upgradePanelColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            AutoSizeText(
              mainText,
              maxLines: 3,
              style: TextStyle(fontSize: 14.0),
            ),
            FloatingActionButton(
              onPressed: () => updateLevel(index),
              backgroundColor: addButtonColor,
              child: Icon(Icons.add)
            ),
            Text('Niveau ' + level[index].toString()),
            Text('Points disponibles : ' + reserve.toString())
          ]
        )
      )
    );
  }

  void showDescription(int index, String text){
    mainText = text;
    for(int i = 0; i < descriptions.length; i++){
      if(i != index){
        descriptions[i] = false;
      }
    }
    setState(() {
      descriptions[index] = !descriptions[index];
    });
  }

  void updateLevel(int index){
    setState(() {
      if(reserve > 0 && level[index] <= 4){
        reserve--;
        level[index]++;
      }
    });
    commitSettings();
  }

  void commitSettings(){
    final newSettings = Settings(
        reserve: reserve,
        level: level
    );
    prefs.saveSettings(newSettings);
  }
}
