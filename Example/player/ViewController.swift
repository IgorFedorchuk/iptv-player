//
//  ViewController.swift
//  player
//
//  Created by Igor Fedorchuk on 07.04.2024.
//

import UIKit

class ViewController: UIViewController {
    private var channels: [PlayerVC.Channel] {
        return [PlayerVC.Channel(url: URL(string: "https://classicarts.akamaized.net/hls/live/1024257/CAS/master.m3u8")!, name: "Channel 1"),
                PlayerVC.Channel(url: URL(string: "http://hls1.webcamera.pl/krakowsan_cam_480f1a/krakowsan_cam_480f1a.stream/chunks.m3u8")!, name: "Channel 2"),
                PlayerVC.Channel(url: URL(string: "https://live-par-2-cdn-alt.livepush.io/live/bigbuckbunnyclip/index.m3u8")!, name: "Channel 3")]
                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func link1Tapped(_ sender: UIButton) {
        show(channels: channels, currentIndex: 0, pipModel: nil)
    }

    @IBAction private func link2Tapped(_ sender: UIButton) {
        show(channels: channels, currentIndex: 1, pipModel: nil)
    }
    
    @IBAction private func link3Tapped(_ sender: UIButton) {
        show(channels: channels, currentIndex: 2, pipModel: nil)
    }
    
    private func show(channels: [PlayerVC.Channel], currentIndex: Int, pipModel: PipModel?) {
        let playerVC = PlayerVC(channels: channels, currentIndex: currentIndex, pipModel: pipModel)
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
        }
        playerVC.errorText = "Video is unreachable".localized
        show(playerVC, sender: nil)
    }

}

