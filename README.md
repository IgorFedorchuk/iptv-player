# Requirements
iOS 12.0
Xcode 15.0+
iPhone/iPad

# Install via Swift Package Manager
You can use Swift Package Manager to add iptv-player to your Xcode project. Select File » Add Packages Dependencies... and enter the repository URL https://github.com/IgorFedorchuk/iptv-player.git into the search bar (top right). Set the Dependency Rule to Up to next major, and the version number to 2.0.0 < 3.0.0.

# Features
- picture in picture mode
- sound off/on
- airplay
- play/pause
- full screen
- play back/forwad
- show name of channel
- changing system brightness
- changing system volume
- lock rotation
- pause timer
  
# Screenshot
![Simulator Screenshot - iPad Pro (12 9-inch) (6th generation) - 2024-05-12 at 14 41 15](https://github.com/IgorFedorchuk/iptv-player/assets/2764603/df6e382f-1d22-4858-8d6a-7d98b930497c)

# How to use
For clearer comprehension, please open the project located in the "Example" folder.
```
var channels: [PlayerVC.Channel] =
                [PlayerVC.Channel(url: URL(string: "http://hls1.webcamera.pl/krakowsan_cam_480f1a/krakowsan_cam_480f1a.stream/chunks.m3u8")!, name: "Channel 1", id: "1", isFavorite: false),
                PlayerVC.Channel(url: URL(string: "https://classicarts.akamaized.net/hls/live/1024257/CAS/master.m3u8")!, name: "Channel 2", id: "2", isFavorite: false),
                PlayerVC.Channel(url: URL(string: "https://live-par-2-cdn-alt.livepush.io/live/bigbuckbunnyclip/index.m3u8")!, name: "Channel 3", id: "3", isFavorite: false)]
                
let playerVC = PlayerVC(channels: channels, currentIndex: 0, pipModel: nil)
playerVC.modalPresentationStyle = .overFullScreen
playerVC.onViewDidLoad = {}
playerVC.onError = { url, error in
}
playerVC.onPipStarted = { pipModel, channels, currentIndex in
}
playerVC.constant.errorText = NSLocalizedString("Video is unreachable", comment: "")
present(playerVC, animated: true)
```
