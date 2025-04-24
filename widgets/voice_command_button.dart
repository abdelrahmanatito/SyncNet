import 'package:flutter/material.dart';
import '../services/voice_command_service.dart';

class VoiceCommandButton extends StatefulWidget {
  final VoiceCommandService voiceService;
  final double size;
  final Color? color;

  const VoiceCommandButton({
    super.key,
    required this.voiceService,
    this.size = 60,
    this.color,
  });

  @override
  State<VoiceCommandButton> createState() => _VoiceCommandButtonState();
}

class _VoiceCommandButtonState extends State<VoiceCommandButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    widget.voiceService.addListener(_handleServiceUpdate);
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.voiceService.removeListener(_handleServiceUpdate);
    super.dispose();
  }

  void _handleServiceUpdate() {
    if (widget.voiceService.status == CommandStatus.listening) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.stop();
      _animationController.reset();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = widget.color ?? Theme.of(context).primaryColor;
    
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Pulse effect
              if (widget.voiceService.status == CommandStatus.listening)
                Opacity(
                  opacity: 1.0 - _pulseAnimation.value,
                  child: Container(
                    width: widget.size * 1.5 * _scaleAnimation.value,
                    height: widget.size * 1.5 * _scaleAnimation.value,
                    decoration: BoxDecoration(
                      color: buttonColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              
              // Main button
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: _getButtonColor(buttonColor),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: buttonColor.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  _getButtonIcon(),
                  color: Colors.white,
                  size: widget.size * 0.5,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getButtonColor(Color defaultColor) {
    switch (widget.voiceService.status) {
      case CommandStatus.listening:
        return Colors.red;
      case CommandStatus.processing:
        return Colors.orange;
      case CommandStatus.success:
        return Colors.green;
      case CommandStatus.error:
        return Colors.red.shade800;
      case CommandStatus.idle:
      default:
        return defaultColor;
    }
  }

  IconData _getButtonIcon() {
    switch (widget.voiceService.status) {
      case CommandStatus.listening:
        return Icons.mic;
      case CommandStatus.processing:
        return Icons.hourglass_top;
      case CommandStatus.success:
        return Icons.check;
      case CommandStatus.error:
        return Icons.error_outline;
      case CommandStatus.idle:
      default:
        return Icons.mic_none;
    }
  }

  void _handleTap() {
    if (widget.voiceService.status == CommandStatus.idle) {
      widget.voiceService.startListening();
    } else if (widget.voiceService.status == CommandStatus.listening) {
      widget.voiceService.stopListening();
    }
  }
}
