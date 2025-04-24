import 'package:flutter/material.dart';
import 'device.dart';

enum TriggerType {
  time,
  device,
  location,
  voice,
  manual
}

class Trigger {
  final TriggerType type;
  final String name;
  final String description;
  final IconData icon;
  
  // Time trigger
  final TimeOfDay? time;
  final List<bool>? days; // [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
  
  // Device trigger
  final Device? device;
  final bool? deviceState;
  
  // Location trigger
  final String? location;
  final bool? entering; // true = entering, false = leaving
  
  // Voice trigger
  final String? voiceCommand;
  
  Trigger({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    this.time,
    this.days,
    this.device,
    this.deviceState,
    this.location,
    this.entering,
    this.voiceCommand,
  });
}

class Action {
  final Device device;
  final bool? newState;
  final int? brightness;
  final double? temperature;
  final int? volume;
  
  Action({
    required this.device,
    this.newState,
    this.brightness,
    this.temperature,
    this.volume,
  });
  
  String get description {
    if (newState != null) {
      return '${newState! ? 'Turn on' : 'Turn off'} ${device.name}';
    } else if (brightness != null) {
      return 'Set ${device.name} brightness to $brightness%';
    } else if (temperature != null) {
      return 'Set ${device.name} temperature to $temperature°C';
    } else if (volume != null) {
      return 'Set ${device.name} volume to $volume%';
    }
    return 'Unknown action for ${device.name}';
  }
}

class Routine {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<Trigger> triggers;
  final List<Action> actions;
  bool isEnabled;
  
  Routine({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.triggers,
    required this.actions,
    this.isEnabled = true,
  });
}

// Sample data
List<Routine> sampleRoutines = [
  Routine(
    id: '1',
    name: 'Good Morning',
    description: 'Starts at 7:00 AM on weekdays',
    icon: Icons.wb_sunny,
    color: Colors.amber,
    isEnabled: true,
    triggers: [
      Trigger(
        type: TriggerType.time,
        name: 'Weekday mornings',
        description: '7:00 AM, Mon-Fri',
        icon: Icons.access_time,
        time: const TimeOfDay(hour: 7, minute: 0),
        days: [true, true, true, true, true, false, false],
      ),
    ],
    actions: [
      Action(
        device: sampleDevices[0], // Living Room Light
        newState: true,
      ),
      Action(
        device: sampleDevices[1], // Thermostat
        temperature: 22.0,
      ),
    ],
  ),
  Routine(
    id: '2',
    name: 'Movie Night',
    description: 'Dim lights and set the mood',
    icon: Icons.movie,
    color: Colors.purple,
    isEnabled: true,
    triggers: [
      Trigger(
        type: TriggerType.voice,
        name: 'Voice command',
        description: 'When you say "Movie time"',
        icon: Icons.mic,
        voiceCommand: 'Movie time',
      ),
    ],
    actions: [
      Action(
        device: sampleDevices[0], // Living Room Light
        brightness: 30,
      ),
      Action(
        device: sampleDevices[2], // Smart Speaker
        newState: true,
        volume: 60,
      ),
    ],
  ),
  Routine(
    id: '3',
    name: 'Leaving Home',
    description: 'Turn off devices when you leave',
    icon: Icons.exit_to_app,
    color: Colors.blue,
    isEnabled: true,
    triggers: [
      Trigger(
        type: TriggerType.location,
        name: 'Leaving home',
        description: 'When you leave home',
        icon: Icons.location_on,
        location: 'Home',
        entering: false,
      ),
    ],
    actions: [
      Action(
        device: sampleDevices[0], // Living Room Light
        newState: false,
      ),
      Action(
        device: sampleDevices[4], // Bedroom Light
        newState: false,
      ),
      Action(
        device: sampleDevices[2], // Smart Speaker
        newState: false,
      ),
    ],
  ),
];
