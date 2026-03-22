import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../providers/radio_viewmodel.dart';
import '../providers/theme_provider.dart';
import '../widgets/theme_switch.dart';

class RadioScreen extends StatelessWidget {
  const RadioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(AppConstants.appName),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => ThemeSwitch(
              isDark: themeProvider.isDark,
              onChanged: themeProvider.toggleTheme,
            ),
          ),
        ],
      ),
      body: Consumer<RadioViewModel>(
        builder: (context, viewModel, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.radio, size: 100, color: Colors.deepPurple),
              const SizedBox(height: 24),
              Text(
                viewModel.isPlaying ? 'Now Playing' : 'Paused',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (viewModel.errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  viewModel.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: viewModel.isBuffering
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        viewModel.isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                label: Text(
                  viewModel.isBuffering
                      ? 'Buffering...'
                      : viewModel.isPlaying
                      ? 'Pause'
                      : 'Play',
                ),
                onPressed: viewModel.togglePlayPause,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
