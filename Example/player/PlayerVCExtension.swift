//
//  PlayerVCExtension.swift
//  player
//
//  Created by Igor Fedorchuk on 07.04.2024.
//

import Foundation

extension PlayerVC {
    class func create(channels: [PlayerVC.Channel], currentIndex: Int, pipModel: PipModel?) -> PlayerVC {
        let playerVC = PlayerVC(channels: channels, currentIndex: currentIndex, pipModel: pipModel)
        playerVC.constant.errorText = "Video is unreachable".localized
        playerVC.modalPresentationStyle = .overFullScreen
        playerVC.needCloseOnPipPressed = true
        playerVC.onError = { url, error in
            let link = url.absoluteString
            let errorString = String(describing: error)
            #if DEBUG
                print("Player error:\(errorString)")
                print(link)
            #endif
        }
        playerVC.onPipStarted = { pipModel, channels, currentIndex in
            PipService.shared.set(pipModel: pipModel, channels: (channels, currentIndex))
        }
        return playerVC
    }
}
