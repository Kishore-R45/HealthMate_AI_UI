import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // Predefined quick questions
  final List<String> _quickQuestions = [
    'What should I eat for breakfast?',
    'How can I lose weight?',
    'What exercises burn the most calories?',
    'How much water should I drink?',
    'What are healthy snacks?',
    'How to improve sleep quality?',
  ];

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      'Hello! I\'m your AI health assistant. How can I help you today?',
    );
  }

  void _handleSubmit(String text) {
    if (text.trim().isEmpty) return;
    
    _messageController.clear();
    
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isBot: false,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });
    
    _scrollToBottom();
    
    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      _generateBotResponse(text);
    });
  }

  void _generateBotResponse(String userMessage) {
    String response = '';
    
    // Simple keyword-based responses (in real app, this would use GPT API)
    if (userMessage.toLowerCase().contains('breakfast')) {
      response = 'For a healthy breakfast, I recommend:\n\n'
          '• Greek yogurt with berries and granola (300 cal)\n'
          '• Oatmeal with banana and nuts (350 cal)\n'
          '• Whole grain toast with avocado and eggs (400 cal)\n\n'
          'These options provide a good balance of protein, carbs, and healthy fats!';
    } else if (userMessage.toLowerCase().contains('weight') || 
               userMessage.toLowerCase().contains('lose')) {
      response = 'To lose weight healthily:\n\n'
          '1. Create a calorie deficit of 500-750 cal/day\n'
          '2. Eat protein with every meal\n'
          '3. Stay hydrated (8+ glasses of water)\n'
          '4. Exercise 30 minutes daily\n'
          '5. Get 7-8 hours of sleep\n\n'
          'Remember, sustainable weight loss is 1-2 lbs per week!';
    } else if (userMessage.toLowerCase().contains('exercise') || 
               userMessage.toLowerCase().contains('calories')) {
      response = 'Top calorie-burning exercises:\n\n'
          '• Running (600-900 cal/hour)\n'
          '• Swimming (500-700 cal/hour)\n'
          '• HIIT Training (400-600 cal/hour)\n'
          '• Cycling (400-600 cal/hour)\n'
          '• Jump Rope (600-800 cal/hour)\n\n'
          'Mix cardio with strength training for best results!';
    } else if (userMessage.toLowerCase().contains('water')) {
      response = 'Daily water intake recommendations:\n\n'
          '• Men: 15.5 cups (3.7 liters)\n'
          '• Women: 11.5 cups (2.7 liters)\n\n'
          'Increase intake if you:\n'
          '• Exercise regularly\n'
          '• Live in hot climate\n'
          '• Are pregnant/breastfeeding\n\n'
          'Tip: Drink a glass before each meal!';
    } else if (userMessage.toLowerCase().contains('snack')) {
      response = 'Healthy snack options:\n\n'
          '• Apple slices with almond butter (200 cal)\n'
          '• Mixed nuts (170 cal per oz)\n'
          '• Greek yogurt with honey (150 cal)\n'
          '• Veggies with hummus (100 cal)\n'
          '• Dark chocolate (150 cal per oz)\n\n'
          'Keep portions controlled and snack mindfully!';
    } else if (userMessage.toLowerCase().contains('sleep')) {
      response = 'Tips for better sleep:\n\n'
          '• Stick to a sleep schedule\n'
          '• Create a bedtime routine\n'
          '• Keep room cool (60-67°F)\n'
          '• Avoid screens 1 hour before bed\n'
          '• Limit caffeine after 2 PM\n'
          '• Exercise regularly (but not late)\n\n'
          'Aim for 7-9 hours of quality sleep!';
    } else {
      response = 'That\'s a great question! Based on your query, here are some general health tips:\n\n'
          '• Maintain a balanced diet with plenty of fruits and vegetables\n'
          '• Stay physically active for at least 30 minutes daily\n'
          '• Keep hydrated throughout the day\n'
          '• Get adequate sleep (7-9 hours)\n'
          '• Manage stress through meditation or yoga\n\n'
          'Is there something specific you\'d like to know about?';
    }
    
    _addBotMessage(response);
  }

  void _addBotMessage(String text) {
    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: text,
        isBot: true,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Health Assistant'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _addBotMessage(
                  'Hello! I\'m your AI health assistant. How can I help you today?',
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Questions
          if (_messages.length <= 1)
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _quickQuestions.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(_quickQuestions[index]),
                      onPressed: () {
                        _handleSubmit(_quickQuestions[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          
          // Input Field
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything about health...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: _handleSubmit,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      _handleSubmit(_messageController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.isBot) ...[
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isBot
                    ? Theme.of(context).cardColor
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(message.isBot ? 4 : 16),
                  bottomRight: Radius.circular(message.isBot ? 16 : 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isBot ? null : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isBot
                          ? Colors.grey
                          : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!message.isBot) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=400',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + (index * 200)),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3 + (value * 0.7)),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () {
        if (mounted && _isTyping) {
          setState(() {});
        }
      },
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}

class ChatMessage {
  final String text;
  final bool isBot;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isBot,
    required this.timestamp,
  });
}