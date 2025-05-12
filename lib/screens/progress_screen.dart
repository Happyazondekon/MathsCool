import 'package:flutter/material.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/widgets/progress_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ma Progression'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const ProgressChart(),
              const SizedBox(height: 30),
              const Text(
                'Mes Badges',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildBadge('Addition', Icons.add, true),
                  _buildBadge('Soustraction', Icons.remove, true),
                  _buildBadge('Multiplication', Icons.close, false),
                  _buildBadge('Division', Icons.percent, false),
                  _buildBadge('Géométrie', Icons.shape_line, true),
                  _buildBadge('Champion', Icons.star, false),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String title, IconData icon, bool earned) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: earned ? AppColors.primary : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30, color: earned ? Colors.white : Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: earned ? Colors.black : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}