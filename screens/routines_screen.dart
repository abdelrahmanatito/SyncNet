import 'package:flutter/material.dart';
import '../models/routine.dart';
import '../theme/app_theme.dart';

class RoutinesScreen extends StatefulWidget {
  final List<Routine> routines;

  const RoutinesScreen({
    super.key,
    required this.routines,
  });

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routines'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.routines.length,
        itemBuilder: (context, index) {
          final routine = widget.routines[index];
          return _buildRoutineCard(routine);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create routine screen
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRoutineCard(Routine routine) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: routine.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                routine.icon,
                color: routine.color,
              ),
            ),
            title: Text(
              routine.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(routine.description),
            trailing: Switch(
              value: routine.isEnabled,
              activeColor: AppTheme.primaryColor,
              onChanged: (value) {
                setState(() {
                  routine.isEnabled = value;
                });
              },
            ),
            onTap: () {
              // Navigate to routine details
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Triggers:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ...routine.triggers.map((trigger) => _buildTriggerItem(trigger)),
                const SizedBox(height: 16),
                const Text(
                  'Actions:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ...routine.actions.map((action) => _buildActionItem(action)),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Run routine manually
                },
                child: const Text('Run Now'),
              ),
              TextButton(
                onPressed: () {
                  // Edit routine
                },
                child: const Text('Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerItem(Trigger trigger) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            trigger.icon,
            size: 16,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              trigger.description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(Action action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            action.device.icon,
            size: 16,
            color: Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              action.description,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
