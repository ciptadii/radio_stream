import '../../domain/entities/radio_station.dart';

class RadioStationModel extends RadioStation {
  const RadioStationModel({
    required super.name,
    required super.streamUrl,
    super.isPlaying,
  });

  factory RadioStationModel.fromEntity(RadioStation entity) {
    return RadioStationModel(
      name: entity.name,
      streamUrl: entity.streamUrl,
      isPlaying: entity.isPlaying,
    );
  }
}
