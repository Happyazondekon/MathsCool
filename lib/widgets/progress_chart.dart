import 'package:flutter/material.dart';
import 'package:mathscool/utils/colors.dart';

class ProgressChart extends StatelessWidget {
  final Map<String, double> progressData;
  final String title;

  const ProgressChart({
    required this.progressData,
    this.title = 'Ma progression',
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'Comic Sans MS',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...progressData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getCategoryIcon(entry.key),
                              color: _getProgressColor(entry.value),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Comic Sans MS',
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getProgressColor(entry.value).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${(entry.value * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getProgressColor(entry.value),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        // Background track
                        Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        // Progress indicator
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 18,
                            width: MediaQuery.of(context).size.width * 0.7 * entry.value,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _getProgressGradient(entry.value),
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        // Fun decoration elements
                        if (entry.value > 0.5)
                          ...List.generate(
                            (entry.value * 5).toInt().clamp(0, 5),
                                (index) => Positioned(
                              left: MediaQuery.of(context).size.width * 0.7 * entry.value * (index / 5),
                              top: 2,
                              child: Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.yellow[700],
                              ),
                            ),
                          ),

                        // Fun character at the end of progress bar
                        if (entry.value > 0)
                          Positioned(
                            left: (MediaQuery.of(context).size.width * 0.7 * entry.value) - 15,
                            top: -2,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _getProgressColor(entry.value),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  _getProgressIcon(entry.value),
                                  size: 12,
                                  color: _getProgressColor(entry.value),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double value) {
    if (value < 0.4) return Colors.red[400]!;
    if (value < 0.7) return Colors.orange[400]!;
    return Colors.green[400]!;
  }

  List<Color> _getProgressGradient(double value) {
    if (value < 0.4) {
      return [Colors.red[300]!, Colors.red[500]!];
    } else if (value < 0.7) {
      return [Colors.orange[300]!, Colors.orange[500]!];
    } else {
      return [Colors.green[300]!, Colors.green[500]!];
    }
  }

  IconData _getProgressIcon(double value) {
    if (value < 0.4) return Icons.sentiment_dissatisfied;
    if (value < 0.7) return Icons.sentiment_satisfied;
    return Icons.sentiment_very_satisfied;
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'addition':
        return Icons.exposure_plus_1;
      case 'soustraction':
        return Icons.exposure_minus_1;
      case 'multiplication':
        return Icons.close;
      case 'division':
        return Icons.functions;
      case 'géométrie':
        return Icons.category;
      case 'cp':
        return Icons.looks_one;
      case 'ce1':
        return Icons.looks_two;
      case 'ce2':
        return Icons.looks_3;
      case 'cm1':
        return Icons.looks_4;
      case 'cm2':
        return Icons.looks_5;
      default:
        return Icons.star;
    }
  }
}