# Audio Assets for Sebha App

## Directory Structure

```
assets/audio/
├── dhikr/           # Dhikr pronunciation audio files
│   ├── subhan_allah.mp3
│   ├── alhamdulillah.mp3
│   ├── allahu_akbar.mp3
│   └── ...
├── notification.mp3  # General notification sound
└── completion.mp3    # Session completion sound
```

## Audio File Requirements

### Dhikr Audio Files
- **Format**: MP3 or WAV
- **Quality**: 44.1kHz, 128kbps minimum
- **Duration**: 2-5 seconds per dhikr
- **Naming**: Use dhikr ID as filename (e.g., `subhan_allah.mp3`)

### Notification Sounds
- **notification.mp3**: General notification/reminder sound
- **completion.mp3**: Celebration sound for completed sessions

## How to Add Audio Files

1. Record or obtain pronunciation audio for each dhikr
2. Convert to MP3 format
3. Name files according to dhikr IDs
4. Place in appropriate directories
5. Update pubspec.yaml if needed

## Current Status

The audio system is implemented but audio files are not included.
Users can add their own audio files following the structure above.

## Alternative Solutions

If audio files are not available:
- The app will work silently
- Users can enable vibration feedback instead
- Text-to-speech could be added as fallback