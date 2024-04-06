# How to use
```
        let playerVC = PlayerVC(channels: channels, currentIndex: currentIndex, pipModel: pipModel)
        playerVC.modalPresentationStyle = .overFullScreen
        playerVC.needCloseOnPipPressed = true
        playerVC.onError = { url, error in
        }
        playerVC.onPipStarted = { pipModel, channels, currentIndex in
        }
        playerVC.errorText = NSLocalizedString("Video is unreachable", comment: "")
```
