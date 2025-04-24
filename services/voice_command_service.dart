import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/device.dart';

enum CommandStatus {
  idle,
  listening,
  processing,
  success,
  error,
}

class VoiceCommand {
  final String text;
  final DateTime timestamp;
  final bool successful;
  final String? response;

  VoiceCommand({
    required this.text,
    required this.timestamp,
    required this.successful,
    this.response,
  });
}

class VoiceCommandService extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;
  CommandStatus _status = CommandStatus.idle;
  String _lastCommand = '';
  String _lastResponse = '';
  List<VoiceCommand> _commandHistory = [];
  final List<Device> _devices;
  
  // Command keywords
  final Map<String, List<String>> _commandKeywords = {
    'turn_on': ['turn on', 'switch on', 'activate', 'enable'],
    'turn_off': ['turn off', 'switch off', 'deactivate', 'disable'],
    'set': ['set', 'change', 'adjust', 'make'],
    'increase': ['increase', 'raise', 'boost', 'up'],
    'decrease': ['decrease', 'lower', 'reduce', 'down'],
  };

  VoiceCommandService(this._devices);

  CommandStatus get status => _status;
  String get lastCommand => _lastCommand;
  String get lastResponse => _lastResponse;
  List<VoiceCommand> get commandHistory => _commandHistory;

  Future<bool> initialize() async {
    if (!_isInitialized) {
      _isInitialized = await _speech.initialize(
        onError: (error) => _handleError(error.errorMsg),
        onStatus: (status) {
          if (status == 'done') {
            _status = CommandStatus.processing;
            notifyListeners();
          }
        },
      );
    }
    return _isInitialized;
  }

  Future<void> startListening() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isInitialized) {
      _status = CommandStatus.listening;
      notifyListeners();
      
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            _lastCommand = result.recognizedWords;
            _processCommand(_lastCommand);
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        localeId: 'en_US',
      );
    } else {
      _handleError('Speech recognition not available');
    }
  }

  void stopListening() {
    _speech.stop();
  }

  void _processCommand(String command) {
    _status = CommandStatus.processing;
    notifyListeners();
    
    // Convert to lowercase for easier matching
    final lowerCommand = command.toLowerCase();
    
    try {
      // Find device in command
      Device? targetDevice;
      for (final device in _devices) {
        if (lowerCommand.contains(device.name.toLowerCase())) {
          targetDevice = device;
          break;
        }
      }
      
      if (targetDevice == null) {
        _handleError('No device found in command: "$command"');
        return;
      }
      
      // Determine command type
      if (_containsAny(lowerCommand, _commandKeywords['turn_on']!)) {
        targetDevice.isOn = true;
        _handleSuccess('Turned on ${targetDevice.name}');
      } 
      else if (_containsAny(lowerCommand, _commandKeywords['turn_off']!)) {
        targetDevice.isOn = false;
        _handleSuccess('Turned off ${targetDevice.name}');
      }
      else if (_containsAny(lowerCommand, _commandKeywords['set']!)) {
        // Handle setting specific values
        if (targetDevice.type == DeviceType.light && lowerCommand.contains('brightness')) {
          // Extract percentage
          final percentage = _extractPercentage(lowerCommand);
          if (percentage != null) {
            targetDevice.brightness = percentage;
            _handleSuccess('Set ${targetDevice.name} brightness to $percentage%');
          } else {
            _handleError('Could not determine brightness level');
          }
        }
        else if (targetDevice.type == DeviceType.thermostat && 
                (lowerCommand.contains('temperature') || lowerCommand.contains('temp'))) {
          // Extract temperature
          final temperature = _extractTemperature(lowerCommand);
          if (temperature != null) {
            targetDevice.temperature = temperature;
            _handleSuccess('Set ${targetDevice.name} temperature to $temperature°C');
          } else {
            _handleError('Could not determine temperature');
          }
        }
        else if (targetDevice.type == DeviceType.speaker && lowerCommand.contains('volume')) {
          // Extract percentage
          final percentage = _extractPercentage(lowerCommand);
          if (percentage != null) {
            targetDevice.volume = percentage;
            _handleSuccess('Set ${targetDevice.name} volume to $percentage%');
          } else {
            _handleError('Could not determine volume level');
          }
        }
        else {
          _handleError('Unsupported setting for ${targetDevice.name}');
        }
      }
      else if (_containsAny(lowerCommand, _commandKeywords['increase']!)) {
        // Handle increasing values
        if (targetDevice.type == DeviceType.light && lowerCommand.contains('brightness')) {
          targetDevice.brightness = _increaseValue(targetDevice.brightness!, 10, 100);
          _handleSuccess('Increased ${targetDevice.name} brightness to ${targetDevice.brightness}%');
        }
        else if (targetDevice.type == DeviceType.thermostat && 
                (lowerCommand.contains('temperature') || lowerCommand.contains('temp'))) {
          targetDevice.temperature = _increaseValue(targetDevice.temperature!, 1, 30).toDouble();
          _handleSuccess('Increased ${targetDevice.name} temperature to ${targetDevice.temperature}°C');
        }
        else if (targetDevice.type == DeviceType.speaker && lowerCommand.contains('volume')) {
          targetDevice.volume = _increaseValue(targetDevice.volume!, 10, 100);
          _handleSuccess('Increased ${targetDevice.name} volume to ${targetDevice.volume}%');
        }
        else {
          _handleError('Cannot increase that property for ${targetDevice.name}');
        }
      }
      else if (_containsAny(lowerCommand, _commandKeywords['decrease']!)) {
        // Handle decreasing values
        if (targetDevice.type == DeviceType.light && lowerCommand.contains('brightness')) {
          targetDevice.brightness = _decreaseValue(targetDevice.brightness!, 10, 0);
          _handleSuccess('Decreased ${targetDevice.name} brightness to ${targetDevice.brightness}%');
        }
        else if (targetDevice.type == DeviceType.thermostat && 
                (lowerCommand.contains('temperature') || lowerCommand.contains('temp'))) {
          targetDevice.temperature = _decreaseValue(targetDevice.temperature!, 1, 16).toDouble();
          _handleSuccess('Decreased ${targetDevice.name} temperature to ${targetDevice.temperature}°C');
        }
        else if (targetDevice.type == DeviceType.speaker && lowerCommand.contains('volume')) {
          targetDevice.volume = _decreaseValue(targetDevice.volume!, 10, 0);
          _handleSuccess('Decreased ${targetDevice.name} volume to ${targetDevice.volume}%');
        }
        else {
          _handleError('Cannot decrease that property for ${targetDevice.name}');
        }
      }
      else {
        _handleError('Unrecognized command for ${targetDevice.name}');
      }
    } catch (e) {
      _handleError('Error processing command: $e');
    }
  }

  bool _containsAny(String text, List<String> keywords) {
    for (final keyword in keywords) {
      if (text.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  int? _extractPercentage(String text) {
    // Match patterns like "50 percent", "50%"
    final percentRegex = RegExp(r'(\d+)(?:\s*%|\s*percent)');
    final match = percentRegex.firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  double? _extractTemperature(String text) {
    // Match patterns like "22 degrees", "22.5 degrees", "22°C"
    final tempRegex = RegExp(r'(\d+\.?\d*)(?:\s*degrees|\s*°C|\s*celsius)');
    final match = tempRegex.firstMatch(text);
    if (match != null) {
      return double.tryParse(match.group(1)!);
    }
    return null;
  }

  int _increaseValue(int current, int step, int max) {
    return (current + step) > max ? max : current + step;
  }

  int _decreaseValue(int current, int step, int min) {
    return (current - step) < min ? min : current - step;
  }

  void _handleSuccess(String response) {
    _status = CommandStatus.success;
    _lastResponse = response;
    _commandHistory.add(VoiceCommand(
      text: _lastCommand,
      timestamp: DateTime.now(),
      successful: true,
      response: response,
    ));
    notifyListeners();
    
    // Reset status after a delay
    Timer(const Duration(seconds: 3), () {
      _status = CommandStatus.idle;
      notifyListeners();
    });
  }

  void _handleError(String error) {
    _status = CommandStatus.error;
    _lastResponse = error;
    _commandHistory.add(VoiceCommand(
      text: _lastCommand,
      timestamp: DateTime.now(),
      successful: false,
      response: error,
    ));
    notifyListeners();
    
    // Reset status after a delay
    Timer(const Duration(seconds: 3), () {
      _status = CommandStatus.idle;
      notifyListeners();
    });
  }

  void clearHistory() {
    _commandHistory = [];
    notifyListeners();
  }
}
