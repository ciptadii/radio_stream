import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../providers/radio_viewmodel.dart';
import '../providers/theme_provider.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  Color _dominantColor = Colors.grey.shade400;
  Color _vibrantColor = Colors.grey.shade300;
  bool _colorsExtracted = false;

  @override
  void initState() {
    super.initState();
    _extractColors();
  }

  Future<void> _extractColors() async {
    final imageProvider = const AssetImage('assets/images/default.jpg');
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
      size: const Size(100, 100),
    );

    setState(() {
      _dominantColor =
          paletteGenerator.dominantColor?.color ?? Colors.grey.shade400;
      _vibrantColor =
          paletteGenerator.vibrantColor?.color ?? Colors.grey.shade300;
      _colorsExtracted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [Colors.grey.shade900, Colors.black]
                    : [Colors.grey.shade200, Colors.white],
              ),
            ),
          ),
          if (_colorsExtracted) _buildBlurredBackground(isDark),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildHeader(context, isDark),
                  const Spacer(),
                  _buildCoverArt(context),
                  const SizedBox(height: 48),
                  _buildStationInfo(context),
                  const SizedBox(height: 32),
                  _buildPlayButton(context),
                  const SizedBox(height: 24),
                  _buildVolumeSlider(context),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurredBackground(bool isDark) {
    return Stack(
      children: [
        Positioned(
          top: -150,
          right: -100,
          child: _buildAbstractBlob(
            width: 400,
            height: 400,
            color: _dominantColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(200),
              topRight: Radius.circular(100),
              bottomLeft: Radius.circular(150),
              bottomRight: Radius.circular(250),
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -200,
          child: _buildAbstractBlob(
            width: 500,
            height: 450,
            color: _vibrantColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(300),
              topRight: Radius.circular(200),
              bottomLeft: Radius.circular(100),
              bottomRight: Radius.circular(250),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          right: -150,
          child: _buildAbstractBlob(
            width: 350,
            height: 350,
            color: _dominantColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(250),
              bottomLeft: Radius.circular(200),
              bottomRight: Radius.circular(100),
            ),
          ),
        ),
        Positioned(
          top: 200,
          left: -100,
          child: _buildAbstractBlob(
            width: 300,
            height: 300,
            color: _vibrantColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(180),
              topRight: Radius.circular(250),
              bottomLeft: Radius.circular(150),
              bottomRight: Radius.circular(200),
            ),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _buildAbstractBlob({
    required double width,
    required double height,
    required Color color,
    required BorderRadius borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.5),
            color.withValues(alpha: 0.2),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.radio, color: isDark ? Colors.white70 : Colors.black54),
          Text(
            AppConstants.appName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCoverArt(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: const Image(
          image: AssetImage('assets/images/default.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStationInfo(BuildContext context) {
    return Consumer<RadioViewModel>(
      builder: (context, viewModel, _) => Column(
        children: [
          Text(
            viewModel.currentStation.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            viewModel.currentStation.description,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return Consumer<RadioViewModel>(
      builder: (context, viewModel, _) {
        return GestureDetector(
          onTap: viewModel.isBuffering ? null : viewModel.togglePlayPause,
          child: viewModel.isBuffering
              ? SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.grey.shade400,
                  ),
                )
              : Icon(
                  viewModel.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                  color: Colors.grey.shade400,
                ),
        );
      },
    );
  }

  Widget _buildVolumeSlider(BuildContext context) {
    return Consumer<RadioViewModel>(
      builder: (context, viewModel, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Icon(Icons.volume_down, color: Colors.grey, size: 20),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 18,
                  ),
                  activeTrackColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade500,
                  thumbColor: Colors.white,
                ),
                child: Slider(
                  value: viewModel.volume,
                  onChanged: viewModel.setVolume,
                ),
              ),
            ),
            Icon(Icons.volume_up, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
