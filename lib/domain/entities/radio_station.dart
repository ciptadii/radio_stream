class RadioStation {
  final String name;
  final String streamUrl;
  final bool isPlaying;

  const RadioStation({
    required this.name,
    required this.streamUrl,
    this.isPlaying = false,
  });

  RadioStation copyWith({String? name, String? streamUrl, bool? isPlaying}) {
    return RadioStation(
      name: name ?? this.name,
      streamUrl: streamUrl ?? this.streamUrl,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
