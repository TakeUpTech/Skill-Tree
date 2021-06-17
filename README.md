# Skill Tree
## Context:
This personal project is a Skill Tree in real life. It is a test to learn how to code in Flutter/Dart a programming language used for mobile apps. Here a list of apps coded with flutter : https://flutter.dev/showcase.
## Required:
This project only includes the .dart scripts that have been coded because entire file was too large. You can directly implement this code in your Flutter folder and modify it. You must also have imported these libraries :
```
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
```
Using (terminal):
```
flutter pub add [package name]
```
## Characteristics:
Characteristics of the app are the following:
- Fill daily missions and keep track in the form of skills acquired,
- Climb up and challenge your friends,
- A simple and easy-to-use interface to gain maximum time for activities.
## Set-up:
If you want to know how to set-up Flutter and Dart: plugins, SDK, import libraries with the terminal... this video explains everything :

Or you can also read this little guide to help you to configure your environment :
### 1) Global setup
- Install Intellij --> install plugins Flutter and Dart (auto), 
- Install flutter zip file on the flutter web site,
- Install Java and JDK,
- Install Android studio.

### 2) Import lib and use flutter commands in terminal :
Add in Path in Environment variable : C:\Users\yourName\flutter\bin
### 3) Fix error lib import on Intellij :
Open 'Edit Configuration' --> 'Additionnal run args' and add :
```
--no-sound-null-safety
```
### 4) Update flutter dependencies (pubspec.yaml) :
```
flutter pub get
```
### 5) Modify laucher icon and app name :
a) In pubspec.yaml, add :
```
dependencies:
	flutter_launcher_icons: "^0.8.0"
flutter_icons:
	android: true
	ios: true
	image_path: "path/image.png"
```
b) In Android --> app --> src --> main --> AndroidManifest.xml, modify :

android:label="Your app name"

c) Save and update in terminal with :
```
flutter pub get
flutter pub run flutter_launcher_icons:main
```
### 6) Build your app
```
flutter build apk --no-sound-null-safety
flutter install 
```
## State:
- [x] Work in progress
- [ ] Work completed
