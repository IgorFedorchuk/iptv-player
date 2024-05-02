# Requirements
iOS 12.0
Xcode 15.0+

# Features
- picture in picture mode
- sound off/on
- airplay
- play/pause
- full screen
- play back/forwad
- show name of channel

# Screenshot
![Simulator Screenshot - iPhone 15 - 2024-04-07 at 12 22 50](https://github.com/IgorFedorchuk/iptv-player/assets/2764603/0abc77ce-8d15-433f-941d-03536f7373d0)

# How to use
For clearer comprehension, please open the project located in the "Example" folder.

```
private var channels: [PlayerVC.Channel] {
        return [PlayerVC.Channel(url: URL(string: "https://classicarts.akamaized.net/hls/live/1024257/CAS/master.m3u8")!, name: "Channel 1"),
                PlayerVC.Channel(url: URL(string: "http://hls1.webcamera.pl/krakowsan_cam_480f1a/krakowsan_cam_480f1a.stream/chunks.m3u8")!, name: "Channel 2"),
                PlayerVC.Channel(url: URL(string: "https://live-par-2-cdn-alt.livepush.io/live/bigbuckbunnyclip/index.m3u8")!, name: "Channel 3")]
                
}
```

```
PlayerVC.Constant.hideControlsTimeInterval = 5
let playerVC = PlayerVC(channels: channels, currentIndex: 0, pipModel: nil)
playerVC.modalPresentationStyle = .overFullScreen
playerVC.needCloseOnPipPressed = false
playerVC.onViewDidLoad = {}
playerVC.onError = { url, error in
}
playerVC.onPipStarted = { pipModel, channels, currentIndex in
}
playerVC.errorText = NSLocalizedString("Video is unreachable", comment: "")
present(playerVC, animated: true)
```
