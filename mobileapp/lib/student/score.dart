import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import '../components/header.dart';
import '../components/footer.dart';

class ViewScores extends StatefulWidget {
  @override
  State<ViewScores> createState() => _ScorePageState();
}

class _ScorePageState extends State<ViewScores> {
  int _selectedIndex = 0;
  List<dynamic> _scores = [];
  Map<String, List<dynamic>> _subjectScores = {};

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  void _loadScores() async {
    final String response =
        await rootBundle.loadString('lib/assets/data/scores.json');
    final data = await json.decode(response);
    setState(() {
      _scores = data;
      _subjectScores = {};
      for (var score in _scores) {
        String subjectName = score['subjectName'];
        if (_subjectScores.containsKey(subjectName)) {
          _subjectScores[subjectName]!.add(score);
        } else {
          _subjectScores[subjectName] = [score];
        }
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/assignment');
        break;
      case 2:
        Navigator.pushNamed(context, '/community');
        break;
      case 3:
        Navigator.pushNamed(context, '/aibot');
        break;
      case 4:
        Navigator.pushNamed(context, '/resources');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 73, 171, 176),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Header(
                  onProfileTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  onNotificationTap: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                  profileImage: 'assets/images/image3.png',
                  welcomeText: "WELCOME HASHIM",
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                padding: const EdgeInsets.fromLTRB(4.0, 12.0, 4.0, 12.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 236, 231, 202),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    ..._subjectScores.keys.map((subjectName) {
                      return _buildScoreContainer(
                          subjectName, _subjectScores[subjectName]!);
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildScoreContainer(String title, List<dynamic> scores) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 245, 245, 221),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          ...scores
              .map((score) => _scoreTile(
                  score['CratedAt'],
                  score['assignmentCode'],
                  score['score'],
                  score['MaximumMarks']))
              .toList(),
        ],
      ),
    );
  }

  Widget _scoreTile(
      String date, String assignmentCode, int score, int maxScore) {
    final DateTime parsedDate = DateTime.parse(date);
    final String formattedDate =
        DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(formattedDate,
                style: const TextStyle(fontWeight: FontWeight.normal)),
            Text(assignmentCode),
            Text('$score/$maxScore',
                style: const TextStyle(fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
