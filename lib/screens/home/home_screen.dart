import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/themes.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'dashboard_screen.dart';
import '../health/health_tracking_screen.dart';
import '../health/food_recognition_screen.dart';
import '../ai/chatbot_screen.dart';
import '../social/leaderboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const HealthTrackingScreen(),
    const FoodRecognitionScreen(),
    const ChatbotScreen(),
    const LeaderboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}