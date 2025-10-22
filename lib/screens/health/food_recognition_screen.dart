import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class FoodRecognitionScreen extends StatefulWidget {
  const FoodRecognitionScreen({super.key});

  @override
  State<FoodRecognitionScreen> createState() => _FoodRecognitionScreenState();
}

class _FoodRecognitionScreenState extends State<FoodRecognitionScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  File? _imageFile;
  bool _isProcessing = false;
  Map<String, dynamic>? _recognitionResult;
  final ImagePicker _picker = ImagePicker();

  // Mock food database
  final List<Map<String, dynamic>> _recentFoods = [
      {
    'name': 'Grilled Chicken Salad',
    'calories': 320,
    'protein': 35,
    'carbs': 12,
    'fat': 15,
    'image': 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
  },
  {
    'name': 'Avocado Toast',
    'calories': 280,
    'protein': 8,
    'carbs': 30,
    'fat': 18,
    'image': 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400',
  },
  {
    'name': 'Fruit Smoothie',
    'calories': 180,
    'protein': 5,
    'carbs': 35,
    'fat': 3,
    'image': 'https://images.unsplash.com/photo-1638176066666-ffb2f013c7dd?w=400',
  },
  {
    'name': 'Oatmeal with Berries',
    'calories': 250,
    'protein': 9,
    'carbs': 45,
    'fat': 5,
    'image': 'https://images.unsplash.com/photo-1510626176961-4b37d6af1c4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  },
  {
    'name': 'Turkey Sandwich',
    'calories': 350,
    'protein': 28,
    'carbs': 32,
    'fat': 12,
    'image': 'https://images.unsplash.com/photo-1603048297172-c92544798c73?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  },
  {
    'name': 'Quinoa Veggie Bowl',
    'calories': 400,
    'protein': 14,
    'carbs': 52,
    'fat': 14,
    'image': 'https://images.unsplash.com/photo-1625944230949-82b41f62d2e1?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  },
  {
    'name': 'Salmon with Asparagus',
    'calories': 420,
    'protein': 38,
    'carbs': 10,
    'fat': 25,
    'image': 'https://images.unsplash.com/photo-1613145993481-3a8f9aeb4e4f?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  },
  {
    'name': 'Greek Yogurt Parfait',
    'calories': 220,
    'protein': 12,
    'carbs': 28,
    'fat': 7,
    'image': 'https://images.unsplash.com/photo-1505253216365-31d7f965b6a4?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  },
  {
    'name': 'Egg and Veggie Omelette',
    'calories': 300,
    'protein': 22,
    'carbs': 8,
    'fat': 20,
    'image': 'https://images.unsplash.com/photo-1604908812448-7e78a3b1d8f3?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  },
  {
    'name': 'Tofu Stir Fry',
    'calories': 370,
    'protein': 20,
    'carbs': 25,
    'fat': 22,
    'image': 'https://images.unsplash.com/photo-1625944231249-8cbdfecda3d9?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  },
  {
    'name': 'Chicken Wrap',
    'calories': 330,
    'protein': 28,
    'carbs': 27,
    'fat': 11,
    'image': 'https://images.unsplash.com/photo-1565958011705-44a3f44a9f23?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  },
  {
    'name': 'Brown Rice with Vegetables',
    'calories': 310,
    'protein': 9,
    'carbs': 55,
    'fat': 7,
    'image': 'https://images.unsplash.com/photo-1625944230982-3159b7c408cb?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  },
  {
    'name': 'Grilled Shrimp Tacos',
    'calories': 360,
    'protein': 26,
    'carbs': 30,
    'fat': 14,
    'image': 'https://images.unsplash.com/photo-1613145993244-92d9b6a1e23c?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  },
  {
    'name': 'Peanut Butter Banana Toast',
    'calories': 290,
    'protein': 10,
    'carbs': 35,
    'fat': 13,
    'image': 'https://images.unsplash.com/photo-1625944230562-68d3f2b75f02?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
  }
    
  ];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
        );
        await _cameraController!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final XFile photo = await _cameraController!.takePicture();
        setState(() {
          _imageFile = File(photo.path);
        });
        _processImage();
      } catch (e) {
        print('Error taking picture: $e');
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        _imageFile = File(photo.path);
      });
      _processImage();
    }
  }

  Future<void> _processImage() async {
    if (_imageFile == null) return;
    
    setState(() {
      _isProcessing = true;
    });

    // Simulate AI processing
    await Future.delayed(const Duration(seconds: 2));

    // Mock recognition result
    setState(() {
      _recognitionResult = {
        'food_name': 'Grilled Chicken with Vegetables',
        'confidence': 0.92,
        'nutrition': {
          'calories': 350,
          'protein': 40,
          'carbs': 15,
          'fat': 18,
          'fiber': 5,
        },
        'ingredients': [
          'Chicken breast',
          'Broccoli',
          'Bell peppers',
          'Olive oil',
          'Garlic',
        ],
        'serving_size': '1 plate (300g)',
      };
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Recognition'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showFoodHistory();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Camera/Image Preview
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.black,
              child: _buildCameraPreview(),
            ),
            
            // Control Buttons
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onPressed: _pickFromGallery,
                  ),
                  _buildControlButton(
                    icon: Icons.camera_alt,
                    label: 'Capture',
                    onPressed: _takePicture,
                    isPrimary: true,
                  ),
                  _buildControlButton(
                    icon: Icons.search,
                    label: 'Manual',
                    onPressed: () {
                      _showManualSearch();
                    },
                  ),
                ],
              ),
            ),
            
            // Results Section
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Analyzing food...'),
                  ],
                ),
              ),
            
            if (_recognitionResult != null && !_isProcessing)
              _buildResultsSection(),
            
            // Recent Foods
            if (_recognitionResult == null && !_isProcessing)
              _buildRecentFoods(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_imageFile != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            _imageFile!,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                setState(() {
                  _imageFile = null;
                  _recognitionResult = null;
                });
              },
            ),
          ),
        ],
      );
    }
    
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      return CameraPreview(_cameraController!);
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: 64,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            'Camera Preview',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPrimary ? Theme.of(context).primaryColor : null,
            border: isPrimary ? null : Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: isPrimary ? Colors.white : Theme.of(context).primaryColor,
              size: isPrimary ? 32 : 24,
            ),
            onPressed: onPressed,
            padding: EdgeInsets.all(isPrimary ? 16 : 12),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildResultsSection() {
    final result = _recognitionResult!;
    final nutrition = result['nutrition'];
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food Name and Confidence
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          result['food_name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${(result['confidence'] * 100).toInt()}% match',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Serving: ${result['serving_size']}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Nutrition Facts
          const Text(
            'Nutrition Facts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildNutritionRow('Calories', '${nutrition['calories']}', 'kcal', Colors.orange),
                  const Divider(),
                  _buildNutritionRow('Protein', '${nutrition['protein']}', 'g', Colors.red),
                  const Divider(),
                  _buildNutritionRow('Carbs', '${nutrition['carbs']}', 'g', Colors.blue),
                  const Divider(),
                  _buildNutritionRow('Fat', '${nutrition['fat']}', 'g', Colors.purple),
                  const Divider(),
                  _buildNutritionRow('Fiber', '${nutrition['fiber']}', 'g', Colors.green),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Ingredients
          const Text(
            'Detected Ingredients',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (result['ingredients'] as List).map((ingredient) {
              return Chip(
                label: Text(ingredient),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _imageFile = null;
                      _recognitionResult = null;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Scan Again'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showConfirmDialog();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Log Food'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value, String unit, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            unit,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentFoods() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Foods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recentFoods.length,
            itemBuilder: (context, index) {
              final food = _recentFoods[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      food['image'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(food['name']),
                  subtitle: Text('${food['calories']} kcal'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () {
                      // Add to today's log
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showManualSearch() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for food...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  autofocus: true,
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: _recentFoods.map((food) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            food['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(food['name']),
                        subtitle: Text(
                          '${food['calories']} kcal • P:${food['protein']}g C:${food['carbs']}g F:${food['fat']}g',
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFoodHistory() {
    // Show food history screen
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Food'),
        content: const Text('Add this food to your daily nutrition log?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Food added to your log!'),
                  backgroundColor: Colors.green,
                ),
              );
              setState(() {
                _imageFile = null;
                _recognitionResult = null;
              });
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}