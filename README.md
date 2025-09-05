# Photostream

Photostream is an iOS application that showcases a beautiful photo gallery using [Lorem Picsum](https://picsum.photos/) API. Built with SwiftUI. It offers a seamless photo browsing experience with features like grid view, detail view, and photo download and zoom in zoom out.

## Features
- Browse photos in grid layout
- View full screen photo
- Download jpeg photos
- pagination and pull refresh
- image caching
- zoom (pinch-in/pinch-out/double-tap)

## Setup & Build Instructions

1. **Prerequisites:**
   - Xcode 16.0 or newer
   - iOS 18.0+ deployment target

2. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/Photostream.git
   cd Photostream
   ```

3. **Configuration Setup:**
   - Project includes configuration files for different environments
   - Create the following config files inside Photostream/Config and add BASE_URL:
     - Photostream-dev.xcconfig
     - Photostream-qa.xcconfig
     - Photostream-prod.xcconfig

4. **Build & Run:**
   - Open `Photostream.xcodeproj` in Xcode
   - Select your target device/simulator
   - Build and run

## Technical Architecture

The application follows MVVM architecture pattern with repository to manage the remote data, ensuring separation of concerns and maintainability.

### Architecture Components

1. **View Layer**
   - SwiftUI views for modern UI development
   - Custom reusable components
   - Skeleton view for loading states
   - Grid layouts
   - Full screen image view

2. **ViewModel Layer**
   - Handles business logic and state management
   - Communicates with repository layer
   - Manages data flow to views

3. **Model Layer**
   - Data models and DTOs

4. **Network Layer**
   - API service class to handle API requests


### Project Structure

```
Photostream/
├── Config/                 # Environment configurations
├── DTO/                   # Data Transfer Objects
├── Model/                 # Data models
├── Network/              # API services
├── Repository/           # Data repositories
├── Utils/                # Helper utilities
├── View/                 # UI components
└── ViewModel/            # View models
```

### Key Area

- **APIService**: Handles network requests to Picsum API
- **PhotoRepository**: Manages photo data operations
- **NetworkMonitor**: Monitors network connectivity
- **HomeViewModel**: Manages home screen business logic

## Current Limitations

### Data Management
- No local persistence implementation
- Limited offline capabilities

### Performance
- Image cache optimization
- Network sate monitoring
- Consume high memory when image are cached 
## Future Improvements

1. **Data Management**
   - Implement most viewed photo section
   - efficient image caching
   - Improve offline support

2. **Features**
   - Most viewed category
   - Favorite section
   - App theme customization

3. **Performance**
   - Implement advanced image caching
   - Optimize memory usage for cached image

## Screenshots & Video
### Demo Video
You can watch a demo of the app in action here: [Demo Video](https://drive.google.com/file/d/1ALjAM_RBpZY75npzqlKK9QeEsJqotKfE/view?usp=sharing)
