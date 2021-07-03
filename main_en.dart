//import 'dart:async';
// ignore: import_of_legacy_library_into_null_safe
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skill_tree/pref_service.dart';
import 'models.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //giftDay();
  runApp(new MyApp());
}

// ignore: unused_element
//late Timer _timer;

/*void giftDay(){
  _timer = Timer.periodic(Duration(minutes: 1), (timer) {
    print('+1');
    reserve++;
  });
}*/

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
            onPressed: () => showGiftDialog(),
            icon: Icon(
              Icons.card_giftcard,
              color: Colors.yellowAccent,
            )
          ),
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

  void showGiftDialog() {
    showDialog(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Daily Gift", textAlign: TextAlign.center),
          content: new Text("Each time you open the application, collect a few points for your reserve in order to acquire new skills."),
          actions: <Widget>[
            new TextButton(
              child: new Text("Take and Close"),
              onPressed: () {
                Navigator.of(context).pop();
                checkGiftValidity();
              }
            )
          ]
        );
      }
    );
  }

  void checkGiftValidity(){
    if(giftAppOpen){
      reserve = reserve + 5;
      giftAppOpen = false;
    }
    _Body().commitSettings();
  }

  void deleteSettings(){
    setState(() {
      descriptions = [false, false, false, false, false, false, false, false, false, false];
      level = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      globalLevel = 0;
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
List<int> levelMax = [2, 5, 5, 3, 5, 5, 5, 3, 3, 8];
List<String> textTitle = [
  'Life',
  'Heal',
  'Info',
  'Social',
  'Art',
  'Organ',
  'Meet',
  'Addic',
  'Sport',
  'Work'
];
List<String> textDescriptions = [
  'Tidy up, organize and sort your living space (computer, clothes, files ...) 1/2 times per week. The level is validated after a period of 1 month.',
  'Eat 1/2/3/4/5 fruits or vegetables per day. The level is validated after a period of 1 month.',
  'Find out about 1/2/3/4/5 topics or themes that you don\'t know. Information is said to be "acquired" if it has been studied for at least 4 hours.',
  'Organize outings with your friends 2/4/6 times every 2 weeks. The level is validated after a period of 1 month.',
  'Practice an artistic or literary activity for 2/3/4/5/6 hours per week. The level is validated after a period of 2 weeks.',
  'Buy organic food and cook 1/2/3/4/5 dishes with fresh and healthy food every week. The level is validated after a period of 2 weeks.',
  'Discover and discuss with 1/2/3/4/5 new people, whether or not they belong to communities. A discussion must be up to 50 messages.',
  'Reduce your smartphone use for a maximum consumption of 5/3/1 hours per day. The level is validated after a period of 1 week.',
  'Practice sport 2.5/5/7 hours per week (according to the OMS). The level is validated after a period of 1 month.',
  'Work during 1/2/3/4/5/6/7/8 hours per day. The level is validated after a period of 1 week.'
];
String mainText = '#N/A';
bool giftAppOpen = true;
int globalLevel = 0;
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
      globalLevel = settings.globalLevel;
    });
  }

  Color addButtonColor = Color(0xFFF23D4C);
  Color upgradePanelColor = Color(0xFF0CF2B1);
  Color treeLineColor = Color(0xFF0CF2B1);
  Color skillColor = Color(0xFF525252);
  Color skillMaxColor = Color(0xFFF2CB05);
  Color textColor = Colors.white;
  Color textUpgradeColor = Colors.black;

  double skillHeight = 56;
  double skillWidth = 56;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'Global Level : ' + globalLevel.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
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
        color: (level[index] == levelMax[index]) ? skillMaxColor : skillColor,
      ),
      child: TextButton(
        onPressed: () => showDescription(index, textDescriptions[index]),
        child: AutoSizeText(
          textTitle[index]+ '\n' + level[index].toString() + '/' + levelMax[index].toString(),
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            color: (level[index] == levelMax[index]) ? textUpgradeColor : textColor,
            fontSize: 14
          )
        )
      )
    );
  }

  Widget descriptionBox(int index){
    return Visibility(
      visible: descriptions[index],
      child: Container(
        height: 170,
        width: MediaQuery.of(context).size.width-20,
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(left: 10, right: 10),
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
            Text('Niveau ' + level[index].toString() + '/' + levelMax[index].toString()),
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
      if(reserve > 0 && level[index] <= levelMax[index]-1){
        reserve--;
        level[index]++;
        globalLevel++;
      }
    });
    commitSettings();
  }

  void commitSettings(){
    final newSettings = Settings(
        reserve: reserve,
        level: level,
        globalLevel: globalLevel
    );
    prefs.saveSettings(newSettings);
  }
}
