# Instagrid - iOS Photo Layout Application

## Overview

Instagrid is an iOS application designed to allow users to combine photos into a square layout, offering several arrangement options. Users can easily share their creations with friends through a swipe gesture. The application is developed using Swift and supports a range of iPhone models.

## Features

### Photo Layout Selection
Users can choose from three different layout options for arranging their photos. By tapping on one of the available layouts:
1. The previously selected layout will be deselected.
2. The tapped layout will be highlighted as the current selection.
3. The central grid will adjust to match the newly selected layout.

### Adding Photos
Users can add photos to the grid by tapping a plus button, which opens the photo library. Once a photo is selected, it is added to the corresponding grid cell. Photos are centered, maintain their original proportions, and fill the entire grid cell without any empty space.

### Swipe to Share
Users can share their photo creation with a simple swipe. In portrait mode (holding the phone upright), swipe up. In landscape mode (holding the phone sideways), swipe left. This will move the photo grid off the screen and show a menu where users can pick their favorite app to share the photo. After sharing or if you decide not to share, the photo grid will automatically come back to its original position.

## Design
 The application uses the Delm and ThirstySoft fonts.

- App icon: [View Icon](https://drive.google.com/file/d/0B_KmXeIzvfCsb2tSWDhOZ0c0M2M/view?usp=sharing)
- Portrait and landscape views: [View Design](https://drive.google.com/file/d/0B_KmXeIzvfCsVF9XcTM3RnlxYjQ/view?usp=sharing)
- Fonts: 
  - [Delm](https://s3-eu-west-1.amazonaws.com/course.oc-static.com/projects/DAiOS_P5/Delm-Medium.otf)
  - [ThirstySoft](https://s3-eu-west-1.amazonaws.com/course.oc-static.com/projects/DAiOS_P5/ThirstySoftRegular.otf)

## Technical Requirements

- **Programming Language**: Swift 4 or higher.
- **iOS Version**: The application supports iOS 16.2 and above.
- **Device Compatibility**: The app is designed for all iPhone sizes.
- **Orientation**: Both portrait and landscape orientations are supported.

## Getting Started

To get started with the Instagrid project, follow these steps:

1. Clone the repository: `git clone https://github.com/yourusername/instagrid.git`
2. Open the project in Xcode.
3. Run the project on a compatible iPhone simulator or device.

---

Feel free to customize further as needed.
