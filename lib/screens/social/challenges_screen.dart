import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Challenge> activeChallenges = [
    Challenge(
      id: '1',
      title: '30-Day Fitness Challenge',
      description: 'Complete daily workouts for 30 days straight',
      category: 'Fitness',
      difficulty: 'Medium',
      participants: 1234,
      daysTotal: 30,
      daysCompleted: 15,
      reward: 500,
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      tasks: [
        'Complete 30 minutes of cardio',
        'Do 50 push-ups',
        'Stretch for 10 minutes',
      ],
    ),
    Challenge(
      id: '2',
      title: 'Hydration Hero',
      description: 'Drink 8 glasses of water daily for a week',
      category: 'Hydration',
      difficulty: 'Easy',
      participants: 856,
      daysTotal: 7,
      daysCompleted: 3,
      reward: 100,
      imageUrl: 'https://images.unsplash.com/photo-1609099910696-94af86c7fd20?w=400',
      tasks: [
        'Drink 8 glasses of water',
        'Log water intake',
        'Set hydration reminders',
      ],
    ),
    Challenge(
      id: '3',
      title: 'Plant-Based Week',
      description: 'Eat only plant-based meals for 7 days',
      category: 'Nutrition',
      difficulty: 'Hard',
      participants: 432,
      daysTotal: 7,
      daysCompleted: 2,
      reward: 250,
      imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400',
      tasks: [
        'Eat 5 servings of vegetables',
        'No meat or dairy',
        'Try a new plant-based recipe',
      ],
    ),
  ];

  final List<Challenge> availableChallenges = [
    Challenge(
      id: '4',
      title: 'Sleep Better',
      description: 'Get 8 hours of quality sleep every night',
      category: 'Sleep',
      difficulty: 'Medium',
      participants: 2103,
      daysTotal: 14,
      daysCompleted: 0,
      reward: 300,
      imageUrl: 'https://images.unsplash.com/photo-1541480601022-2308c0f02487?w=400',
      tasks: [
        'Sleep 8 hours',
        'No screens before bed',
        'Maintain sleep schedule',
      ],
    ),
    Challenge(
      id: '5',
      title: '10K Steps Daily',
      description: 'Walk 10,000 steps every day for 2 weeks',
      category: 'Activity',
      difficulty: 'Medium',
      participants: 3421,
      daysTotal: 14,
      daysCompleted: 0,
      reward: 200,
      imageUrl: 'https://images.unsplash.com/photo-1571008887538-b36bb32f4571?w=400',
      tasks: [
        'Walk 10,000 steps',
        'Take stairs instead of elevator',
        'Go for evening walk',
      ],
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
        title: const Text('Challenges'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Available'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveChallenges(),
          _buildAvailableChallenges(),
          _buildCompletedChallenges(),
        ],
      ),
    );
  }

  Widget _buildActiveChallenges() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeChallenges.length,
      itemBuilder: (context, index) {
        final challenge = activeChallenges[index];
        return _buildActiveChallengeCard(challenge);
      },
    );
  }

  Widget _buildActiveChallengeCard(Challenge challenge) {
    final progress = challenge.daysCompleted / challenge.daysTotal;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Header
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              image: DecorationImage(
                image: NetworkImage(challenge.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  _getCategoryChip(challenge.category),
                  const SizedBox(width: 8),
                  _getDifficultyChip(challenge.difficulty),
                ],
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  challenge.description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Day ${challenge.daysCompleted} of ${challenge.daysTotal}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearPercentIndicator(
                  lineHeight: 8.0,
                  percent: progress,
                  backgroundColor: Colors.grey.shade200,
                  progressColor: Theme.of(context).primaryColor,
                  barRadius: const Radius.circular(4),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                
                // Today's Tasks
                const Text(
                  'Today\'s Tasks',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...challenge.tasks.map((task) => _buildTaskItem(task, false)),
                const SizedBox(height: 16),
                
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${challenge.participants} participants',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.emoji_events, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${challenge.reward} points',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableChallenges() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: availableChallenges.length,
      itemBuilder: (context, index) {
        final challenge = availableChallenges[index];
        return _buildAvailableChallengeCard(challenge);
      },
    );
  }

  Widget _buildAvailableChallengeCard(Challenge challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _showChallengeDetails(challenge);
        },
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Image
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: NetworkImage(challenge.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            challenge.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _getDifficultyChip(challenge.difficulty),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${challenge.daysTotal} days',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.people, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${challenge.participants}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.emoji_events, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${challenge.reward}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Arrow
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedChallenges() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No completed challenges yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your first challenge to see it here!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String task, bool completed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: completed ? Colors.green : Colors.grey.shade400,
                width: 2,
              ),
              color: completed ? Colors.green : Colors.transparent,
            ),
            child: completed
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task,
              style: TextStyle(
                decoration: completed ? TextDecoration.lineThrough : null,
                color: completed ? Colors.grey : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryChip(String category) {
    Color color;
    IconData icon;
    
    switch (category) {
      case 'Fitness':
        color = Colors.orange;
        icon = Icons.fitness_center;
        break;
      case 'Nutrition':
        color = Colors.green;
        icon = Icons.restaurant;
        break;
      case 'Hydration':
        color = Colors.blue;
        icon = Icons.water_drop;
        break;
      case 'Sleep':
        color = Colors.purple;
        icon = Icons.bedtime;
        break;
      case 'Activity':
        color = Colors.red;
        icon = Icons.directions_walk;
        break;
      default:
        color = Colors.grey;
        icon = Icons.category;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDifficultyChip(String difficulty) {
    Color color;
    switch (difficulty) {
      case 'Easy':
        color = Colors.green;
        break;
      case 'Medium':
        color = Colors.orange;
        break;
      case 'Hard':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showChallengeDetails(Challenge challenge) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    challenge.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _getCategoryChip(challenge.category),
                    const SizedBox(width: 8),
                    _getDifficultyChip(challenge.difficulty),
                  ],
                ),
                const SizedBox(height: 16),
                Text(challenge.description),
                const SizedBox(height: 20),
                const Text(
                  'Challenge Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.schedule, 'Duration', '${challenge.daysTotal} days'),
                _buildDetailRow(Icons.people, 'Participants', '${challenge.participants} joined'),
                _buildDetailRow(Icons.emoji_events, 'Reward', '${challenge.reward} points'),
                const SizedBox(height: 20),
                const Text(
                  'Daily Tasks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...challenge.tasks.map((task) => _buildTaskItem(task, false)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _joinChallenge(challenge);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Join Challenge',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _joinChallenge(Challenge challenge) {
    setState(() {
      availableChallenges.remove(challenge);
      activeChallenges.add(challenge);
      _tabController.animateTo(0);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joined "${challenge.title}" challenge!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final int participants;
  final int daysTotal;
  final int daysCompleted;
  final int reward;
  final String imageUrl;
  final List<String> tasks;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.participants,
    required this.daysTotal,
    required this.daysCompleted,
    required this.reward,
    required this.imageUrl,
    required this.tasks,
  });
}