//
//  PipModel.swift
//  m3u8player
//
//  Created by Igor Fedorchuk on 28.03.2024.
//

import AVFoundation
import AVKit
import Foundation

public struct PipModel {
    public private(set) var pipController: AVPictureInPictureController
    public private(set) var player: AVPlayer
}
