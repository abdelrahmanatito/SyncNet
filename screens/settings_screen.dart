import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/user_avatar.dart';
import '../widgets/bottom_nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      UserAvatar(
                        user: sampleUsers[0],
                        size: 60,
                        showStatus: false,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sampleUsers[0].name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              sampleUsers[0].email,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Account settings
                Text(
                  'Account',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSettingItem(
                  context,
                  Icons.person_outline,
                  'Personal Information',
                  'Update your personal details',
                ),
                _buildSettingItem(
                  context,
                  Icons.lock_outline,
                  'Security',
                  'Change password and security settings',
                ),
                _buildSettingItem(
                  context,
                  Icons.notifications_outlined,
                  'Notifications',
                  'Manage notification preferences',
                ),
                
                const SizedBox(height: 24),
                
                // Home settings
                Text(
                  'Home',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSettingItem(
                  context,
                  Icons.home_outlined,
                  'Home Settings',
                  'Manage your home details',
                ),
                _buildSettingItem(
                  context,
                  Icons.people_outline,
                  'Family Members',
                  'Manage access for family members',
                ),
                _buildSettingItem(
                  context,
                  Icons.room_outlined,
                  'Rooms',
                  'Customize rooms and locations',
                ),
                
                const SizedBox(height: 24),
                
                // Voice commands settings
                Text(
                  'Voice Commands',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSettingItem(
                  context,
                  Icons.mic_outlined,
                  'Voice Assistant',
                  'Configure voice assistant settings',
                ),
                _buildSettingItem(
                  context,
                  Icons.history,
                  'Command History',
                  'View and manage voice command history',
                  onTap: () => Navigator.pushNamed(context, '/voice_history'),
                ),
                
                const SizedBox(height: 24),
                
                // System settings
                Text(
                  'System',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSettingItem(
                  context,
                  Icons.language_outlined,
                  'Language',
                  'Change app language',
                ),
                _buildSettingItem(
                  context,
                  Icons.dark_mode_outlined,
                  'Theme',
                  'Change app theme',
                ),
                _buildSettingItem(
                  context,
                  Icons.help_outline,
                  'Help & Support',
                  'Get help and contact support',
                ),
                _buildSettingItem(
                  context,
                  Icons.info_outline,
                  'About',
                  'App information and version',
                ),
                
                const SizedBox(height: 24),
                
                // Logout button
                ElevatedButton(
                  onPressed: () {
                    // Logout functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade800,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
          BottomNavBar(
            currentIndex: 2,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacementNamed(context, '/home');
              } else if (index == 1) {
                Navigator.pushReplacementNamed(context, '/devices');
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingItem(
    BuildContext context, 
    IconData icon, 
    String title, 
    String subtitle, 
    {VoidCallback? onTap}
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap ?? () {
        // Navigate to respective setting screen
      },
    );
  }
}
