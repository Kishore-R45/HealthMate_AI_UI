import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'Week';
  DateTime _selectedDate = DateTime.now();
  
  // Mock data for reports
  final Map<String, dynamic> weeklyData = {
    'calories': [1800, 2100, 1950, 2200, 1850, 2000, 1900],
    'steps': [8000, 10500, 7500, 12000, 9000, 11000, 6500],
    'water': [7, 8, 6, 8, 7, 9, 5],
    'sleep': [7.5, 8, 6.5, 7, 8.5, 7, 6],
    'weight': [68.5, 68.3, 68.4, 68.2, 68.1, 68.0, 67.9],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Reports'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareReport,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadReport,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Period Selector
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Week', label: Text('Week')),
                        ButtonSegment(value: 'Month', label: Text('Month')),
                        ButtonSegment(value: 'Year', label: Text('Year')),
                      ],
                      selected: {_selectedPeriod},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          _selectedPeriod = newSelection.first;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Date Range Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(_getDateRangeText()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _selectDateRange,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Summary Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    children: [
                      _buildSummaryCard(
                        'Avg Calories',
                        '1,957',
                        'kcal/day',
                        Icons.local_fire_department,
                        Colors.orange,
                        '+5%',
                        true,
                      ),
                      _buildSummaryCard(
                        'Avg Steps',
                        '9,214',
                        'steps/day',
                        Icons.directions_walk,
                        Colors.green,
                        '+12%',
                        true,
                      ),
                      _buildSummaryCard(
                        'Weight Change',
                        '-0.6',
                        'kg',
                        Icons.monitor_weight,
                        Colors.purple,
                        '-0.8%',
                        true,
                      ),
                      _buildSummaryCard(
                        'Avg Sleep',
                        '7.2',
                        'hours/night',
                        Icons.bedtime,
                        Colors.indigo,
                        '-3%',
                        false,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Charts Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detailed Analysis',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Calories Chart
                  _buildChartCard(
                    'Calories Trend',
                    'Daily calorie intake',
                    _buildCaloriesChart(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Steps Chart
                  _buildChartCard(
                    'Steps Progress',
                    'Daily step count',
                    _buildStepsChart(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Weight Chart
                  _buildChartCard(
                    'Weight Tracking',
                    'Weight changes over time',
                    _buildWeightChart(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Sleep Pattern
                  _buildChartCard(
                    'Sleep Pattern',
                    'Hours of sleep per night',
                    _buildSleepChart(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Insights Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Insights',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInsightCard(
                    Icons.trending_up,
                    'Great Progress!',
                    'You\'ve exceeded your step goal 5 out of 7 days this week. Keep up the excellent work!',
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    Icons.water_drop,
                    'Hydration Alert',
                    'Your water intake has been below target for 3 days. Try setting reminders to drink more water.',
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    Icons.bedtime,
                    'Sleep Improvement',
                    'Your average sleep duration is 7.2 hours. Consider going to bed 30 minutes earlier for optimal rest.',
                    Colors.purple,
                  ),
                  const SizedBox(height: 12),
                  _buildInsightCard(
                    Icons.restaurant,
                    'Nutrition Tip',
                    'Your protein intake could be higher. Consider adding more lean meats, fish, or legumes to your meals.',
                    Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Export Options
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Export Report',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('PDF'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.table_chart),
                              label: const Text('Excel'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.email),
                              label: const Text('Email'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    String change,
    bool isPositive,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      Text(
                        change,
                        style: TextStyle(
                          fontSize: 12,
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard(String title, String subtitle, Widget chart) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() < days.length) {
                  return Text(days[value.toInt()], style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: weeklyData['calories']!.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.toDouble());
            }).toList(),
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.orange.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 15000,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                if (value.toInt() < days.length) {
                  return Text(days[value.toInt()], style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: weeklyData['steps']!.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: entry.value >= 10000 ? Colors.green : Colors.grey,
                width: 22,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeightChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() < days.length) {
                  return Text(days[value.toInt()], style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: weeklyData['weight']!.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.toDouble());
            }).toList(),
            isCurved: true,
            color: Colors.purple,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.purple.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 10,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                if (value.toInt() < days.length) {
                  return Text(days[value.toInt()], style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: weeklyData['sleep']!.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: entry.value >= 7 ? Colors.indigo : Colors.grey,
                width: 22,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInsightCard(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDateRangeText() {
    final now = DateTime.now();
    final formatter = DateFormat('MMM d');
    
    switch (_selectedPeriod) {
      case 'Week':
        final start = now.subtract(const Duration(days: 6));
        return '${formatter.format(start)} - ${formatter.format(now)}';
      case 'Month':
        final start = DateTime(now.year, now.month, 1);
        return '${formatter.format(start)} - ${formatter.format(now)}';
      case 'Year':
        return '${now.year}';
      default:
        return '';
    }
  }

  void _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _selectedDate.subtract(const Duration(days: 6)),
        end: _selectedDate,
      ),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked.end;
      });
    }
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparing report to share...')),
    );
  }

  void _downloadReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Downloading report...')),
    );
  }
}