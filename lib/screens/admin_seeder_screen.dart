// lib/screens/admin/admin_seeder_screen.dart
import 'package:flutter/material.dart';
import '../../utils/firestore_daily_challenges_seeder.dart';

/// Écran d'administration pour gérer les défis quotidiens
/// ⚠️ À utiliser UNIQUEMENT en développement
class AdminSeederScreen extends StatefulWidget {
  const AdminSeederScreen({Key? key}) : super(key: key);

  @override
  State<AdminSeederScreen> createState() => _AdminSeederScreenState();
}

class _AdminSeederScreenState extends State<AdminSeederScreen> {
  final FirestoreDailyChallengesSeeder _seeder = FirestoreDailyChallengesSeeder();

  bool _isLoading = false;
  String _statusMessage = '';
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await _seeder.getChallengeStats();
    setState(() {
      _stats = stats;
    });
  }

  Future<void> _seedUntilJanuary() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Génération en cours...';
    });

    try {
      await _seeder.seedDailyChallenges(
        startDate: DateTime.now(),
        endDate: DateTime(2026, 1, 1),
      );

      setState(() {
        _statusMessage = '✅ Défis créés avec succès !';
      });

      await _loadStats();
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _seedMonth() async {
    final now = DateTime.now();

    setState(() {
      _isLoading = true;
      _statusMessage = 'Génération du mois en cours...';
    });

    try {
      await _seeder.seedMonth(now.year, now.month);

      setState(() {
        _statusMessage = '✅ Mois généré avec succès !';
      });

      await _loadStats();
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _seedYear() async {
    final now = DateTime.now();

    setState(() {
      _isLoading = true;
      _statusMessage = 'Génération de l\'année en cours...';
    });

    try {
      await _seeder.seedYear(now.year);

      setState(() {
        _statusMessage = '✅ Année générée avec succès !';
      });

      await _loadStats();
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Attention'),
        content: const Text('Voulez-vous vraiment supprimer TOUS les défis ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Suppression en cours...';
    });

    try {
      await _seeder.deleteAllChallenges();

      setState(() {
        _statusMessage = '✅ Tous les défis ont été supprimés';
      });

      await _loadStats();
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Erreur: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin - Défis Quotidiens'),
        backgroundColor: const Color(0xFFD32F2F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats
            _buildStatsCard(),
            const SizedBox(height: 20),

            // Actions
            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildActionButton(
              'Générer jusqu\'au 1er Janvier 2026',
              Icons.calendar_month,
              Colors.green,
              _seedUntilJanuary,
            ),
            const SizedBox(height: 12),

            _buildActionButton(
              'Générer le mois actuel',
              Icons.today,
              Colors.blue,
              _seedMonth,
            ),
            const SizedBox(height: 12),

            _buildActionButton(
              'Générer l\'année actuelle',
              Icons.date_range,
              Colors.orange,
              _seedYear,
            ),
            const SizedBox(height: 12),

            _buildActionButton(
              'Supprimer tous les défis',
              Icons.delete_forever,
              Colors.red,
              _deleteAll,
            ),

            const SizedBox(height: 30),

            // Status
            if (_statusMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _statusMessage.contains('❌')
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _statusMessage.contains('❌')
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage.contains('❌')
                        ? Colors.red.shade900
                        : Colors.green.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    final total = _stats['total'] ?? 0;
    final byLevel = _stats['byLevel'] as Map<String, dynamic>? ?? {};
    final byTheme = _stats['byTheme'] as Map<String, dynamic>? ?? {};

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Total de défis: $total',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            if (byLevel.isNotEmpty) ...[
              const Text(
                'Par niveau:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...byLevel.entries.map((e) => Text('  ${e.key}: ${e.value}')),
            ],
            const SizedBox(height: 12),
            if (byTheme.isNotEmpty) ...[
              const Text(
                'Par thème:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...byTheme.entries.map((e) => Text('  ${e.key}: ${e.value}')),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}