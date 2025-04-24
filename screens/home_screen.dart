import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/device.dart';
import '../models/user.dart';
import '../models/notification.dart';
import '../widgets/device_card.dart';
import '../widgets/user_avatar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/voice_command_button.dart';
import '../widgets/command_feedback_overlay.dart';
import '../services/voice_command_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Device> _devices = sampleDevices;
  final List<User> _users = sampleUsers;
  int _activeDevices = 0;
  int _unreadNotifications = 0;
  
  @override
  void initState() {
    super.initState();
    _calculateActiveDevices();
    _calculateUnreadNotifications();
  }
  
  void _calculateActiveDevices() {
    _activeDevices = _devices.where((device) => device.isOn).length;
  }
  
  void _calculateUnreadNotifications() {
    _unreadNotifications = sampleNotifications.where((n) => !n.isRead).length;
  }
  
  void _toggleDevice(Device device, bool value) {
    setState(() {
      device.isOn = value;
      _calculateActiveDevices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final voiceService = Provider.of<VoiceCommandService>(context);
    
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        pinned: false,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        title: Row(
                          children: [
                            Text(
                              'Hello, ',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              'Matthew',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          Stack(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.notifications_outlined),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/notifications');
                                },
                              ),
                              if (_unreadNotifications > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      _unreadNotifications.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          UserAvatar(
                            user: _users[0],
                            size: 40,
                            onTap: () {
                              Navigator.pushNamed(context, '/settings');
                            },
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User cards section
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    for (var i = 0; i < _users.length && i < 2; i++)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: UserAvatar(
                                          user: _users[i],
                                          size: 50,
                                        ),
                                      ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '$_activeDevices Devices',
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                        Text(
                                          'Active Now',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Stats section
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      context,
                                      Icons.lightbulb_outline,
                                      'Light',
                                      '65%',
                                      Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildStatCard(
                                      context,
                                      Icons.thermostat,
                                      'Temp',
                                      '22°C',
                                      Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildStatCard(
                                      context,
                                      Icons.water_drop_outlined,
                                      'Humidity',
                                      '45%',
                                      Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Routines shortcut
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/routines');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.purple.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.purple.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.auto_awesome,
                                          color: Colors.purple,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Routines',
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            Text(
                                              'Automate your smart home',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.purple,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Settings shortcut
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/settings');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.settings,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Settings',
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            Text(
                                              'Configure your smart home',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Voice command history
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/voice_history');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.history,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Voice Command History',
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            Text(
                                              'View your recent voice commands',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Devices section
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Devices',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/devices');
                                    },
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < _devices.length) {
                                return DeviceCard(
                                  device: _devices[index],
                                  onToggle: (value) => _toggleDevice(_devices[index], value),
                                );
                              }
                              return null;
                            },
                            childCount: _devices.length,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 100), // Extra space for FAB
                      ),
                    ],
                  ),
                ),
                BottomNavBar(
                  currentIndex: 0,
                  onTap: (index) {
                    if (index == 1) {
                      Navigator.pushReplacementNamed(context, '/devices');
                    } else if (index == 2) {
                      Navigator.pushReplacementNamed(context, '/settings');
                    }
                  },
                ),
              ],
            ),
            
            // Voice command feedback overlay
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: CommandFeedbackOverlay(
                voiceService: voiceService,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: VoiceCommandButton(
        voiceService: voiceService,
        size: 60,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  
  Widget _buildStatCard(BuildContext context, IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
