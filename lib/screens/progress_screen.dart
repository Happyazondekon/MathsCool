import 'package:flutter/material.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/widgets/progress_chart.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Données statiques pour la progression
    final Map<String, double> staticProgressData = {
      'Addition': 0.8,
      'Soustraction': 0.6,
      'Multiplication': 0.3,
      'Division': 0.2,
      'Géométrie': 0.5,
    };

    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ProgressChart(progressData: staticProgressData),
                        const SizedBox(height: 30),
                        const Text(
                          'Mes Badges',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: staticProgressData.entries.map((entry) {
                            final earned = entry.value >= 0.7; // Badge obtenu si progression >= 70%
                            return _buildBadge(entry.key, _getBadgeIcon(entry.key), earned);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Ma Progression',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Placeholder for alignment
        ],
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

  IconData _getBadgeIcon(String theme) {
    switch (theme.toLowerCase()) {
      case 'addition':
        return Icons.add;
      case 'soustraction':
        return Icons.remove;
      case 'multiplication':
        return Icons.close;
      case 'division':
        return Icons.percent;
      case 'géométrie':
        return Icons.square_foot;
      default:
        return Icons.star;
    }
  }
}