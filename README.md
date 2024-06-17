# App Audio Recorder

## Introduction

This application is designed to record, play, rename, and delete audio recordings on an iOS device. It includes a user-friendly UI with meaningful images and gradients for a better user experience.

## Architecture Overview

The application consists of the following main components:

- **RecorderViewModel**: Manages the recording process.
- **RecordingsListViewModel**: Manages the list of recordings and handles renaming and deleting.
- **PlayerViewModel**: Manages the playback of recordings.
- **Views**: Various SwiftUI views to interact with the user.

## TechStack 

The application consists of the following technologies, languages and main concepts:

- **Swift**
- **SwiftUI**
- **Combine**
- **UIKit**
- **ObjectiveC**
- **Background audio Recording**
- **Audio Crash Resistance**
- **Consise Audio file size**

## Class and Method Explanations

### RecorderViewModel
Handles audio recording functionalities.

#### Methods
- `startRecording()`: Starts a new recording.
- `pauseRecording()`: Pauses the ongoing recording.
- `resumeRecording()`: Resumes the paused recording.
- `stopRecording()`: Stops the recording and saves it.

### RecordingsListViewModel
Manages the list of recordings and provides functionalities to rename and delete recordings.

#### Methods
- `fetchRecordings()`: Fetches the list of recordings from the document directory.
- `renameRecording(at index: Int, to newName: String)`: Renames a recording.
- `deleteRecording(at index: Int)`: Deletes a recording.

### PlayerViewModel
Handles audio playback functionalities.

#### Methods
- `playAudio()`: Plays the selected audio recording.
- `pauseAudio()`: Pauses the audio playback.

### Views

#### RecorderView
A view that provides the UI for recording audio.

#### RecordingsListView
A view that displays the list of recordings and provides options to rename and delete.

#### PlayerView
A view that provides the UI for playing audio recordings.

#### VolumeMeterView
A view that visualizes the audio levels during recording.

#### RenameRecordingView
A view that allows the user to rename a recording.

## Non-Functional Requirements

### 1. Save Most of the Audio Recording if the App Crashes or is Killed

To ensure audio recordings are saved even if the app crashes or is killed, we use the following approach:
- **Periodic Saving**: The recording is periodically saved to a temporary file. In case of an unexpected termination, the last saved state can be recovered.
- **Auto-Restart**: On app launch, check for any temporary recordings and prompt the user to save or discard them.

### 2. Minimize App Space Usage for Recordings

To minimize app space usage:
- **Compression**: Recordings are saved in a compressed format (e.g., AAC).
- **File Management**: Users can delete recordings they no longer need, freeing up space.

## App Screenshots

### Recording List
<img src="https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/4ac54b92-c338-43db-a034-89eb90c89b29" width="30%" />
<img src="https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/22f9574e-a714-4e6b-a621-3a3d71bc31d1" width="30%" />
<img src="https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/2b347d40-681a-4d64-936e-385a16960c26" width="30%" />


### Recorder States
<img src="https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/c57f099d-e4a6-41ae-a2dc-5bd58bc49a9a" width="30%" />
<img src="https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/27585dd1-1107-4c05-a76c-8704c3f0c90c" width="30%" />
<img src="https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/d2b4f3ba-242a-4bdc-9b59-93e1594cf090" width="30%" />


### Player States
<img src="https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/2f77d193-2aae-4dbf-ac0f-579a27fcce76" width="30%" />
<img src="https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/e864ee8e-1664-4fcf-9f66-6db41ffc9b02" width="30%" />


## Sequence Diagrams

### Recording

![Recorder](https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/8eb39d0a-8b68-4cd7-97db-490e1f01296b)

### Playing
![Playback](https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/7cb17e88-69e2-43f2-b339-72c6168a90bb)

### Renaming
![Rename](https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/5f318930-f3f1-484f-b88a-f72448beb9f9)

### Delete
![Delete](https://github.com/pavan-kumar-arepu/AudioRecorderPavanKumar/assets/13812858/29c3aa92-b9e6-4141-b821-3c18294bb5b0)

## Bonus

- **Rename File Functionality Implemented**: Allows users to rename their recordings.
- **Delete File Functionality Implemented**: Allows users to delete their recordings.
- **Added Meaningful Images**: Enhanced UI with appropriate images.
- **Added Gradient for Better UI**: Gradient background for a visually appealing UI.

## Contact

- **Email** :  iOSDeveloper.ipa@gmail.com
- **Mobile**:  +91 8121 040 308
- **Linked-in**: https://www.linkedin.com/in/pavan-kumar-arepu-software-architect-engineer/
