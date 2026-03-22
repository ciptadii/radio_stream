class RadioStation {
  final String name;
  final String description;
  final String streamUrl;
  final bool isPlaying;

  const RadioStation({
    required this.name,
    required this.description,
    required this.streamUrl,
    this.isPlaying = false,
  });

  RadioStation copyWith({
    String? name,
    String? description,
    String? streamUrl,
    bool? isPlaying,
  }) {
    return RadioStation(
      name: name ?? this.name,
      description: description ?? this.description,
      streamUrl: streamUrl ?? this.streamUrl,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
