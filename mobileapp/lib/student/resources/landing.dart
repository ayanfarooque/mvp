import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../components/header.dart';
import '../../components/footer.dart';
import '../../components/news_card.dart';

class ResourceLanding extends StatefulWidget {
  @override
  State<ResourceLanding> createState() => _LandingPageState();
}

class _LandingPageState extends State<ResourceLanding> {
  int _selectedIndex = 0;
  List<dynamic> _news = [];
  List<dynamic> _filteredNews = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _showRecommended = true;

  @override
  void initState() {
    super.initState();
    _loadNews();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _loadNews() async {
    final String response =
        await rootBundle.loadString('lib/assets/data/news.json');
    final data = await json.decode(response);
    setState(() {
      _news = data;
      _filteredNews = _news;
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filteredNews = _news
          .where((news) => news['newsHeading']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
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

  void _showRecommendedCards() {
    setState(() {
      _showRecommended = true;
      _filteredNews = _news.where((news) => news['stared'] == true).toList();
    });
  }

  void _showAllResources() {
    setState(() {
      _showRecommended = false;
      _filteredNews = _news;
    });
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
                width: 400,
                margin: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 236, 231, 202),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(30.0, 10.0, 0.0, 0.0),
                      decoration: BoxDecoration(),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(0.0),
                            child: Column(
                              children: [
                                Text(
                                  "RESOURCES",
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "Recommended for you",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 30),
                          Container(
                            width: 180,
                            height: 33,
                            padding: EdgeInsets.fromLTRB(12.0, 2.0, 4.0, 2.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: "Search",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Icon(Icons.search, size: 25),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 236, 231, 202),
                      ),
                      child: Row(
                        children: [
                          _showRecommended
                              ? ElevatedButton(
                                  onPressed: _showRecommendedCards,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF49ABB0),
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                  ),
                                  child: const Text(
                                    "Recommended",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              : OutlinedButton(
                                  onPressed: _showRecommendedCards,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: const Color(0xFF49ABB0)),
                                  ),
                                  child: const Text(
                                    "Recommended",
                                    style: TextStyle(
                                        color: const Color(0xFF49ABB0)),
                                  ),
                                ),
                          const SizedBox(width: 8.9),
                          !_showRecommended
                              ? ElevatedButton(
                                  onPressed: _showAllResources,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF49ABB0),
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                  ),
                                  child: const Text(
                                    "Resources",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              : OutlinedButton(
                                  onPressed: _showAllResources,
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        color: const Color(0xFF49ABB0)),
                                  ),
                                  child: const Text(
                                    "Resources",
                                    style: TextStyle(
                                        color: const Color(0xFF49ABB0)),
                                  ),
                                ),
                          const SizedBox(width: 8.8),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: const Color(0xFF49ABB0)),
                            ),
                            child: const Text(
                              "News",
                              style: TextStyle(color: const Color(0xFF49ABB0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_showRecommended)
                      ..._filteredNews
                          .where((news) => news['stared'] == true)
                          .map((news) => NewsCard(news: news))
                          .toList()
                    else
                      ..._filteredNews
                          .map((news) => NewsCard(news: news))
                          .toList(),
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
}
