# Requirements
iOS 12.0
Xcode 15.0+
iPhone/iPad

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
  
# Screenshot
![Simulator Screenshot - iPad Pro (12 9-inch) (2nd generation) - 2024-05-02 at 09 58 52](https://github.com/IgorFedorchuk/iptv-player/assets/2764603/43bf8936-719b-48be-bc7a-5523030f4040)


# How to use
For clearer comprehension, please open the project located in the "Example" folder.
```
var channels: [PlayerVC.Channel] =
                [PlayerVC.Channel(url: URL(string: "https://classicarts.akamaized.net/hls/live/1024257/CAS/master.m3u8")!, name: "Channel 1"),
                PlayerVC.Channel(url: URL(string: "http://hls1.webcamera.pl/krakowsan_cam_480f1a/krakowsan_cam_480f1a.stream/chunks.m3u8")!, name: "Channel 2"),
                PlayerVC.Channel(url: URL(string: "https://live-par-2-cdn-alt.livepush.io/live/bigbuckbunnyclip/index.m3u8")!, name: "Channel 3")]
                
PlayerVC.Constant.hideControlsTimeInterval = 5
let playerVC = PlayerVC(channels: channels, currentIndex: 0, pipModel: nil)
playerVC.modalPresentationStyle = .overFullScreen
playerVC.onViewDidLoad = {}
playerVC.onError = { url, error in
}
playerVC.onPipStarted = { pipModel, channels, currentIndex in
}
playerVC.errorText = NSLocalizedString("Video is unreachable", comment: "")
present(playerVC, animated: true)
```
