import 'package:flutter/material.dart';
import '../services/voice_command_service.dart';

class CommandFeedbackOverlay extends StatefulWidget {
  final VoiceCommandService voiceService;

  const CommandFeedbackOverlay({
    super.key,
    required this.voiceService,
  });

  @override
  State<CommandFeedbackOverlay> createState() => _CommandFeedbackOverlayState();
}

class _CommandFeedbackOverlayState extends State<CommandFeedbackOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
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
    final status = widget.voiceService.status;
    
    if (status == CommandStatus.listening) {
      _animationController.forward();
    } else if (status == CommandStatus.idle) {
      _animationController.reverse();
    }
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: child,
          ),
        );
      },
      child: _buildFeedbackContent(),
    );
  }

  Widget _buildFeedbackContent() {
    final status = widget.voiceService.status;
    
    if (status == CommandStatus.idle) {
      return const SizedBox.shrink();
    }
    
    Color backgroundColor;
    IconData icon;
    String message;
    
    switch (status) {
      case CommandStatus.listening:
        backgroundColor = Colors.blue.withOpacity(0.9);
        icon = Icons.mic;
        message = "Listening...";
        break;
      case CommandStatus.processing:
        backgroundColor = Colors.orange.withOpacity(0.9);
        icon = Icons.hourglass_top;
        message = "Processing: \"${widget.voiceService.lastCommand}\"";
        break;
      case CommandStatus.success:
        backgroundColor = Colors.green.withOpacity(0.9);
        icon = Icons.check_circle;
        message = widget.voiceService.lastResponse;
        break;
      case CommandStatus.error:
        backgroundColor = Colors.red.withOpacity(0.9);
        icon = Icons.error;
        message = widget.voiceService.lastResponse;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.9);
        icon = Icons.info;
        message = "Ready for voice commands";
    }
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          if (status == CommandStatus.listening)
            _buildWaveformAnimation(),
        ],
      ),
    );
  }

  Widget _buildWaveformAnimation() {
    return SizedBox(
      width: 60,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          4,
          (index) => _buildWaveBar(index),
        ),
      ),
    );
  }

  Widget _buildWaveBar(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.3, end: 0.9),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 4,
          height: 30 * value,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }
}
