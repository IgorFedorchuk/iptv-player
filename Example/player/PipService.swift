//
//  PipService.swift
//  player
//
//  Created by Igor Fedorchuk on 07.04.2024.
//

import Foundation

import AVFoundation
import AVKit
import Foundation

protocol IPipService {
    func set(pipModel: PipModel, channels: ([PlayerVC.Channel], Int))
    func playIfInPipMode(url: URL, channels: ([PlayerVC.Channel], Int)) -> Bool
}

final class PipService: NSObject, IPipService {
    static let shared = PipService()
    
    private var pipModel: PipModel?
    private var channels: ([PlayerVC.Channel], Int)?

    func set(pipModel: PipModel, channels: ([PlayerVC.Channel], Int)) {
        self.pipModel = pipModel
        self.channels = channels
        pipModel.pipController.delegate = self
    }

    func playIfInPipMode(url: URL, channels: ([PlayerVC.Channel], Int)) -> Bool {
        guard let pipModel = pipModel else { return false }
        pipModel.player.pause()
        pipModel.player.replaceCurrentItem(with: AVPlayerItem(url: url))
        pipModel.player.play()
        self.channels = channels
        return true
    }
}

extension PipService: AVPictureInPictureControllerDelegate {
    func pictureInPictureController(_: AVPictureInPictureController, failedToStartPictureInPictureWithError _: any Error) {
        clear()
    }

    func pictureInPictureControllerWillStopPictureInPicture(_: AVPictureInPictureController) {
        clear()
    }

    func pictureInPictureController(_: AVPictureInPictureController,
                                    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        guard let pipModel = pipModel,
              let channels = channels else {
            completionHandler(false)
            return
        }

        let playerVC = PlayerVC.create(channels: channels.0, currentIndex: channels.1, pipModel: pipModel)
        UIViewController.topViewController()?.present(playerVC, animated: false) {
            self.clear()
            completionHandler(true)
        }
    }
}

extension PipService {
    private func clear() {
        pipModel = nil
    }
}
