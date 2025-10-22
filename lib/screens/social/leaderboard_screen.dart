import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Week';
  String _selectedMetric = 'Points';

  // Mock leaderboard data
  final List<LeaderboardEntry> _globalLeaders = [
    LeaderboardEntry(
      rank: 1,
      name: 'Kishore R',
      avatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
      points: 2450,
      badges: 12,
      streak: 30,
      change: 2,
    ),
    LeaderboardEntry(
      rank: 2,
      name: 'Pavithran AG',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      points: 2380,
      badges: 10,
      streak: 25,
      change: -1,
    ),
    LeaderboardEntry(
      rank: 3,
      name: 'Kadhir',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      points: 2290,
      badges: 11,
      streak: 28,
      change: 1,
    ),
    LeaderboardEntry(
      rank: 4,
      name: 'Pranav',
      avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      points: 2150,
      badges: 9,
      streak: 20,
      change: 0,
    ),
    LeaderboardEntry(
      rank: 5,
      name: 'Naga',
      avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400',
      points: 2100,
      badges: 8,
      streak: 18,
      change: 3,
    ),
  ];

  final List<Achievement> _recentAchievements = [
    Achievement(
      title: 'Marathon Runner - Chennai',
      description: 'Ran 42km in a month',
      icon: Icons.directions_run,
      color: Colors.orange,
      unlockedBy: 'Kishore R',
      unlockedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Achievement(
      title: 'Hydration Hero',
      description: 'Drank 8 glasses daily for 30 days',
      icon: Icons.water_drop,
      color: Colors.blue,
      unlockedBy: 'Kadhir',
      unlockedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Achievement(
      title: 'Sleep Master',
      description: 'Maintained 8hrs sleep for 2 weeks',
      icon: Icons.bedtime,
      color: Colors.purple,
      unlockedBy: 'Pavithran AG',
      unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Global'),
            Tab(text: 'Friends'),
            Tab(text: 'Local'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPeriod,
                        items: ['Day', 'Week', 'Month', 'All Time']
                            .map((period) => DropdownMenuItem(
                                  value: period,
                                  child: Text(period),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPeriod = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMetric,
                        items: ['Points', 'Steps', 'Calories', 'Streak']
                            .map((metric) => DropdownMenuItem(
                                  value: metric,
                                  child: Text(metric),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMetric = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Your Position Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=400',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Position',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'You',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.trending_up,
                                color: Colors.greenAccent,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '1,850 points',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '#8',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rank',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Leaderboard List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardList(_globalLeaders),
                _buildLeaderboardList(_globalLeaders.take(3).toList()),
                _buildLeaderboardList(_globalLeaders.reversed.toList()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAchievementsBottomSheet();
        },
        icon: const Icon(Icons.emoji_events),
        label: const Text('Achievements'),
      ),
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(entry.avatar),
                ),
                if (entry.rank <= 3)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _getRankColor(entry.rank),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          '${entry.rank}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: Row(
              children: [
                Text(
                  entry.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                if (entry.change > 0)
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.green,
                    size: 16,
                  )
                else if (entry.change < 0)
                  Icon(
                    Icons.arrow_downward,
                    color: Colors.red,
                    size: 16,
                  ),
              ],
            ),
            subtitle: Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${entry.points} pts'),
                const SizedBox(width: 12),
                Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text('${entry.streak} days'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.military_tech,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${entry.badges}',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade400;
      case 3:
        return Colors.brown.shade300;
      default:
        return Colors.blue;
    }
  }

  void _showAchievementsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Achievements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _recentAchievements.length,
                itemBuilder: (context, index) {
                  final achievement = _recentAchievements[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: achievement.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          achievement.icon,
                          color: achievement.color,
                        ),
                      ),
                      title: Text(achievement.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(achievement.description),
                          const SizedBox(height: 4),
                          Text(
                            'Unlocked by ${achievement.unlockedBy}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        _getTimeAgo(achievement.unlockedAt),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

class LeaderboardEntry {
  final int rank;
  final String name;
  final String avatar;
  final int points;
  final int badges;
  final int streak;
  final int change;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.avatar,
    required this.points,
    required this.badges,
    required this.streak,
    required this.change,
  });
}

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String unlockedBy;
  final DateTime unlockedAt;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.unlockedBy,
    required this.unlockedAt,
  });
}