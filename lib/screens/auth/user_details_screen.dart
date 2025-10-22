import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home/home_screen.dart';
import '../../models/user_model.dart';

class UserDetailsScreen extends StatefulWidget {
  final String name;
  final String email;
  
  const UserDetailsScreen({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // User details
  String? _gender;
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String? _activityLevel;
  String? _goal;
  List<String> _healthConditions = [];
  
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _activityLevels = [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
    'Extra Active',
  ];
  final List<String> _goals = [
    'Lose Weight',
    'Maintain Weight',
    'Gain Weight',
    'Build Muscle',
    'Improve Health',
  ];
  final List<String> _healthConditionOptions = [
    'Diabetes',
    'Hypertension',
    'Heart Disease',
    'Asthma',
    'Allergies',
    'None',
  ];

  void _nextPage() {
    if (_validateCurrentPage()) {
      if (_currentPage < 3) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _completeSignup();
      }
    }
  }

  bool _validateCurrentPage() {
    switch (_currentPage) {
      case 0:
        return _gender != null && 
               _ageController.text.isNotEmpty;
      case 1:
        return _heightController.text.isNotEmpty && 
               _weightController.text.isNotEmpty;
      case 2:
        return _activityLevel != null;
      case 3:
        return _goal != null;
      default:
        return false;
    }
  }

  Future<void> _completeSignup() async {
    final user = UserModel(
      name: widget.name,
      email: widget.email,
      age: int.parse(_ageController.text),
      gender: _gender!,
      height: double.parse(_heightController.text),
      weight: double.parse(_weightController.text),
      activityLevel: _activityLevel!,
      goal: _goal!,
      joinedDate: DateTime.now(),
    );
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userData', user.toJson().toString());
    
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentPage + 1} of 4'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentPage + 1) / 4,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildBasicInfoPage(),
                _buildBodyMeasurementsPage(),
                _buildActivityLevelPage(),
                _buildGoalsPage(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _nextPage,
                child: Text(
                  _currentPage == 3 ? 'Complete Setup' : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tell us about yourself',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),
          const Text('Gender'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: _genderOptions.map((gender) {
              return ChoiceChip(
                label: Text(gender),
                selected: _gender == gender,
                onSelected: (selected) {
                  setState(() {
                    _gender = gender;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              suffixText: 'years',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyMeasurementsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Measurements',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your current measurements',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),
          TextFormField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Height',
              suffixText: 'cm',
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Weight',
              suffixText: 'kg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLevelPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Level',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'How active are you?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          ..._activityLevels.map((level) {
            return RadioListTile<String>(
              title: Text(level),
              subtitle: Text(_getActivityDescription(level)),
              value: level,
              groupValue: _activityLevel,
              onChanged: (value) {
                setState(() {
                  _activityLevel = value;
                });
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildGoalsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Goals',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'What would you like to achieve?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _goals.map((goal) {
              return ChoiceChip(
                label: Text(goal),
                selected: _goal == goal,
                onSelected: (selected) {
                  setState(() {
                    _goal = goal;
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          const Text('Health Conditions'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _healthConditionOptions.map((condition) {
              return FilterChip(
                label: Text(condition),
                selected: _healthConditions.contains(condition),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _healthConditions.add(condition);
                    } else {
                      _healthConditions.remove(condition);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getActivityDescription(String level) {
    switch (level) {
      case 'Sedentary':
        return 'Little or no exercise';
      case 'Lightly Active':
        return 'Exercise 1-3 days/week';
      case 'Moderately Active':
        return 'Exercise 3-5 days/week';
      case 'Very Active':
        return 'Exercise 6-7 days/week';
      case 'Extra Active':
        return 'Very hard exercise daily';
      default:
        return '';
    }
  }
}