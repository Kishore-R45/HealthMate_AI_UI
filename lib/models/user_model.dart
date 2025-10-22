class UserModel {
  String? id;
  String name;
  String email;
  int age;
  String gender;
  double height; // in cm
  double weight; // in kg
  String activityLevel;
  String goal;
  String? profileImage;
  DateTime? joinedDate;
  Map<String, dynamic>? preferences;
  
  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.activityLevel,
    required this.goal,
    this.profileImage,
    this.joinedDate,
    this.preferences,
  });
  
  double get bmi => weight / ((height / 100) * (height / 100));
  
  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }
  
  int get dailyCalorieGoal {
    double bmr;
    if (gender == 'Male') {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
    
    double activityMultiplier = 1.2;
    switch (activityLevel) {
      case 'Sedentary':
        activityMultiplier = 1.2;
        break;
      case 'Lightly Active':
        activityMultiplier = 1.375;
        break;
      case 'Moderately Active':
        activityMultiplier = 1.55;
        break;
      case 'Very Active':
        activityMultiplier = 1.725;
        break;
      case 'Extra Active':
        activityMultiplier = 1.9;
        break;
    }
    
    double tdee = bmr * activityMultiplier;
    
    switch (goal) {
      case 'Lose Weight':
        return (tdee - 500).round();
      case 'Gain Weight':
        return (tdee + 500).round();
      default:
        return tdee.round();
    }
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'age': age,
    'gender': gender,
    'height': height,
    'weight': weight,
    'activityLevel': activityLevel,
    'goal': goal,
    'profileImage': profileImage,
    'joinedDate': joinedDate?.toIso8601String(),
    'preferences': preferences,
  };
  
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    age: json['age'],
    gender: json['gender'],
    height: json['height']?.toDouble(),
    weight: json['weight']?.toDouble(),
    activityLevel: json['activityLevel'],
    goal: json['goal'],
    profileImage: json['profileImage'],
    joinedDate: json['joinedDate'] != null 
        ? DateTime.parse(json['joinedDate']) 
        : null,
    preferences: json['preferences'],
  );
}