import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/voice_command_service.dart';

class VoiceCommandHistoryScreen extends StatelessWidget {
  final VoiceCommandService voiceService;

  const VoiceCommandHistoryScreen({
    super.key,
    required this.voiceService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Command History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: voiceService.commandHistory.isEmpty
                ? null
                : () => _showClearHistoryDialog(context),
          ),
        ],
      ),
      body: voiceService.commandHistory.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No voice commands yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your voice command history will appear here',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    // Sort by most recent first
    final sortedHistory = List.of(voiceService.commandHistory)
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedHistory.length,
      itemBuilder: (context, index) {
        final command = sortedHistory[index];
        return _buildCommandItem(command);
      },
    );
  }

  Widget _buildCommandItem(VoiceCommand command) {
    final dateFormat = DateFormat('MMM d, h:mm a');
    final formattedDate = dateFormat.format(command.timestamp);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  command.successful ? Icons.check_circle : Icons.error,
                  color: command.successful ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '"${command.text}"',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              command.response ?? '',
              style: TextStyle(
                color: command.successful ? Colors.black87 : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all voice command history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              voiceService.clearHistory();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
