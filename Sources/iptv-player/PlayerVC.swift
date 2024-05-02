//
//  PlayerVC.swift
//  m3u8player
//
//  Created by Igor Fedorchuk on 27.03.2024.
//

import AVFoundation
import AVKit
import Foundation
import MediaPlayer

open class PlayerVC: UIViewController {
    open var controlStackView: UIStackView = {
        let view = UIStackView(frame: CGRect.zero)
        view.backgroundColor = .clear
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    open var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect.zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    open var backVideoView: UIView = {
        let view = UIView(frame: CGRect.zero)
        return view
    }()

    open var playControlView: UIView = {
        let view = UIView(frame: CGRect.zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    open var closeButtonTopConstraint: NSLayoutConstraint?
    open var volumeTrailingConstraint: NSLayoutConstraint?
    open var brightnessLeadingConstraint: NSLayoutConstraint?
    
    open var volumeSlider: UISlider = {
        let slider = UISlider(frame: CGRect.zero)
        slider.tintColor = UIColor.white
        slider.backgroundColor = .clear
        slider.minimumTrackTintColor = UIColor.white
        slider.maximumTrackTintColor = UIColor.color(r: 0, g: 0, b: 0, a: 0.4)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.value = AVAudioSession.sharedInstance().outputVolume
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.setThumbImage(UIImage(imageName: "volume")?.withRenderingMode(.alwaysTemplate), for: .normal)
        slider.transform = CGAffineTransform(rotationAngle: .pi / -2)
        return slider
    }()
    
    open var brightnessSlider: UISlider = {
        let slider = UISlider(frame: CGRect.zero)
        slider.tintColor = UIColor.white
        slider.backgroundColor = .clear
        slider.minimumTrackTintColor = UIColor.white
        slider.maximumTrackTintColor = UIColor.color(r: 0, g: 0, b: 0, a: 0.4)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.setThumbImage(UIImage(imageName: "brightness")?.withRenderingMode(.alwaysTemplate), for: .normal)
        slider.value = Float(UIScreen.main.brightness)
        slider.transform = CGAffineTransform(rotationAngle: .pi / -2)
        return slider
    }()
    
    open var closeButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.backgroundColor = .clear
        button.setImage(UIImage(imageName: "close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    open var playForwardButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.setImage(UIImage(imageName: "play-forward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    open var playBackButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.setImage(UIImage(imageName: "play-back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    open var soundButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.setImage(UIImage(imageName: Constant.soundOnImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(8)
        button.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return button
    }()

    open var playPauseButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.setImage(UIImage(imageName: Constant.pauseImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    open var airplayButton: AVRoutePickerView = {
        let button = AVRoutePickerView(frame: CGRect.zero)
        button.tintColor = UIColor.white
        if #available(iOS 13.0, *) {
            button.prioritizesVideoDevices = true
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    open var pipButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.setImage(UIImage(imageName: "picture-in-picture")?.withRenderingMode(.alwaysTemplate), for: .normal)
        let inset = CGFloat(8)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: inset, bottom: inset, right: inset)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    open var fullScreenButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.backgroundColor = .clear
        button.tintColor = .white
        button.setImage(UIImage(imageName: "full-screen")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let inset = CGFloat(8)
        button.imageEdgeInsets = UIEdgeInsets(top: 6, left: inset, bottom: 6, right: inset)
        return button
    }()

    open var errorLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.isHidden = true
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    open var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    open var errorText = ""
    open var needCloseOnPipPressed = false
    
    public var onViewDidLoad: (() -> Void)?
    public var onError: ((URL, Error?) -> Void)?
    public var onNextChannel: ((URL) -> Void)?
    public var onPreviousChannel: ((URL) -> Void)?

    public var onPipStarted: ((PipModel, [PlayerVC.Channel], Int) -> Void)?

    private var isFullScreenMode = false
    private var isPlayControlHidden = false

    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var pipController: AVPictureInPictureController?
    private var pipModel: PipModel?

    private var hideControlsTimer: Timer?
    private let channels: [PlayerVC.Channel]
    private var currentIndex: Int
    private var isObservingPlayer = false
    
    open var windowInterfaceOrientation: UIInterfaceOrientation? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }

    public init(channels: [PlayerVC.Channel], currentIndex: Int, pipModel: PipModel?) {
        self.channels = channels
        self.currentIndex = currentIndex
        self.pipModel = pipModel
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        invalidateTimer()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setupControls()
        subscribeToNotifications()
        if let windowInterfaceOrientation = windowInterfaceOrientation {
            updateIndents(isLandscape: windowInterfaceOrientation.isLandscape)
        }
        onViewDidLoad?()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPlayer()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removePlayerObservers()
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.allButUpsideDown
    }

    override open var shouldAutorotate: Bool {
        return true
    }

    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self, let windowInterfaceOrientation = self.windowInterfaceOrientation else {
                return
            }
            updateIndents(isLandscape: windowInterfaceOrientation.isLandscape)
            setupVideoGravity()
        })
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayer.timeControlStatus), let change = change,
           let newValue = change[NSKeyValueChangeKey.newKey] as? Int {
            let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)

            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                if newStatus == .playing || newStatus == .paused {
                    loader.stopAnimating()
                } else {
                    loader.startAnimating()
                }
            }
        } else if let playerItem = object as? AVPlayerItem, keyPath == #keyPath(AVPlayerItem.status), playerItem.status == .failed {
            loader.stopAnimating()
            proccessError()
        } else if keyPath == #keyPath(AVAudioSession.outputVolume) {
            updateBrighnessAndVolume()
        }
    }
}

extension PlayerVC {
    private func addPlayerObservers() {
        guard !isObservingPlayer else { return }
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus), options: [.old, .new], context: nil)
        AVAudioSession.sharedInstance().addObserver(self, forKeyPath: #keyPath(AVAudioSession.outputVolume), options: NSKeyValueObservingOptions.new, context: nil)
        isObservingPlayer = true
    }

    private func removePlayerObservers() {
        guard isObservingPlayer else { return }
        player?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.timeControlStatus))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: #keyPath(AVAudioSession.outputVolume))
        isObservingPlayer = false
    }
    
    private func proccessError() {
        errorLabel.text = errorText
        errorLabel.isHidden = false
        playPauseButton.setImage(UIImage(imageName: Constant.playImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        onError?(channels[currentIndex].url, player?.currentItem?.error)
    }

    private func setupCloseButton() {
        playControlView.addSubview(closeButton)
        closeButton.heightAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
        closeButton.leftAnchor.constraint(equalTo: playControlView.leftAnchor, constant: 16).isActive = true
        closeButtonTopConstraint = closeButton.topAnchor.constraint(equalTo: playControlView.topAnchor, constant: Constant.buttonsTopIndentPortrait)
        closeButtonTopConstraint?.isActive = true
        closeButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    }

    @objc private func closeButtonPressed() {
        player?.pause()
        dismiss(animated: true)
    }

    private func setupPlayPauseButton() {
        playControlView.addSubview(playPauseButton)
        playPauseButton.widthAnchor.constraint(equalToConstant: Constant.playButtonWidth).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: Constant.playButtonWidth).isActive = true
        playPauseButton.centerXAnchor.constraint(equalTo: playControlView.centerXAnchor, constant: 0).isActive = true
        playPauseButton.centerYAnchor.constraint(equalTo: playControlView.centerYAnchor, constant: 0).isActive = true
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPressed), for: .touchUpInside)
    }

    @objc private func playPauseButtonPressed() {
        startTimer()
        guard errorLabel.isHidden else {
            errorLabel.isHidden = true
            setupPlayer()
            return
        }
        
        let isPlaying = player?.rate != 0
        setupPlayPauseImage(isPlaying)
        if player?.rate == 0 {
            player?.play()
        } else {
            player?.pause()
        }
    }

    private func setupPlayPauseImage(_ isPlaying: Bool) {
        let imageName: String
        if isPlaying {
            imageName = Constant.playImageName
        } else {
            imageName = Constant.pauseImageName
        }
        playPauseButton.setImage(UIImage(imageName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    private func setupPlayAirplayButton() {
        controlStackView.addArrangedSubview(airplayButton)
        airplayButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
    }

    private func setupPlayPipButton() {
        pipButton.addTarget(self, action: #selector(playPipButtonPressed), for: .touchUpInside)
        if AVPictureInPictureController.isPictureInPictureSupported() {
            controlStackView.addArrangedSubview(pipButton)
        }

        pipButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
    }

    @objc private func playPipButtonPressed() {
        guard let pipController = pipController, let player = player, pipController.isPictureInPicturePossible else { return }
        if pipController.isPictureInPictureActive {
            pipController.stopPictureInPicture()
        } else {
            onPipStarted?(PipModel(pipController: pipController, player: player), channels, currentIndex)
            pipController.startPictureInPicture()
            if needCloseOnPipPressed {
                dismiss(animated: true)
            }
        }
    }

    private func setupFullScreenButton() {
        fullScreenButton.addTarget(self, action: #selector(fullScreenButtonPressed), for: .touchUpInside)
        controlStackView.addArrangedSubview(fullScreenButton)
        fullScreenButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
    }

    @objc private func fullScreenButtonPressed() {
        isFullScreenMode = !isFullScreenMode
        setupVideoGravity()
        startTimer()
    }

    private func setupSoundButtonImage() {
        let player = player ?? pipModel?.player
        guard let player = player else { return }
        let imageName = player.volume == 0 ? Constant.soundOffImageName : Constant.soundOnImageName
        soundButton.setImage(UIImage(imageName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
    }

    private func setupSoundButton() {
        setupSoundButtonImage()
        soundButton.addTarget(self, action: #selector(soundButtonPressed), for: .touchUpInside)
        playControlView.addSubview(soundButton)
        soundButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
        soundButton.heightAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
        soundButton.rightAnchor.constraint(equalTo: playControlView.rightAnchor, constant: -16).isActive = true
        soundButton.topAnchor.constraint(equalTo: closeButton.topAnchor, constant: 0).isActive = true
    }

    @objc private func soundButtonPressed() {
        startTimer()
        player?.volume = player?.volume == 0 ? 1 : 0
        setupSoundButtonImage()
    }

    private func setupPlayControlViewColor() {
        playControlView.backgroundColor = isPlayControlHidden ? UIColor.clear : Constant.backColor
    }

    private func setupPlayControlView() {
        view.addSubview(playControlView)
        playControlView.fillSuperview()
        setupPlayControlViewColor()
        let tapGesture = UITapGestureRecognizer()
        playControlView.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(playControlViewPressed))
        startTimer()
    }

    @objc private func playControlViewPressed() {
        isPlayControlHidden = !isPlayControlHidden
        setupPlayControlViewColor()
        updateBrighnessAndVolume()
        manageControls()
        invalidateTimer()
        if !isPlayControlHidden {
            startTimer()
        }
    }

    private func startTimer() {
        invalidateTimer()
        hideControlsTimer = Timer.scheduledTimer(withTimeInterval: Constant.hideControlsTimeInterval, repeats: false) { [weak self] _ in
            self?.isPlayControlHidden = true
            self?.manageControls()
            self?.invalidateTimer()
        }
    }

    private func manageControls() {
        for subview in playControlView.subviews where subview != errorLabel {
            subview.isHidden = isPlayControlHidden
        }
    }

    private func invalidateTimer() {
        hideControlsTimer?.invalidate()
        hideControlsTimer = nil
    }

    private func setupControlStackView() {
        playControlView.addSubview(controlStackView)
        controlStackView.heightAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
        controlStackView.topAnchor.constraint(equalTo: closeButton.topAnchor, constant: 0).isActive = true
        controlStackView.centerXAnchor.constraint(equalTo: playControlView.centerXAnchor, constant: 0).isActive = true
    }

    private func setupErrorLabel() {
        playControlView.addSubview(errorLabel)
        errorLabel.centerXAnchor.constraint(equalTo: playControlView.centerXAnchor, constant: 0).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: playControlView.centerYAnchor, constant: 80).isActive = true
    }

    @objc private func playForwardButtonPressed() {
        startTimer()
        let nextIndex = currentIndex + 1
        if nextIndex < channels.count {
            currentIndex = nextIndex
            setupPlayer()
        }
        setupPlayBackForwardButtonColor()
        onNextChannel?(channels[currentIndex].url)
    }

    @objc private func playBackButtonPressed() {
        startTimer()
        let nextIndex = currentIndex - 1
        if nextIndex >= 0, nextIndex < channels.count {
            currentIndex = nextIndex
            setupPlayer()
        }
        setupPlayBackForwardButtonColor()
        onPreviousChannel?(channels[currentIndex].url)
    }

    private func setupPlayBackForwardButtonColor() {
        playForwardButton.tintColor = currentIndex == channels.count - 1 ? UIColor.gray : UIColor.white
        playBackButton.tintColor = currentIndex == 0 ? UIColor.gray : UIColor.white
    }

    private func setupPlayForwardButton() {
        setupPlayBackForwardButtonColor()
        playControlView.addSubview(playForwardButton)
        playForwardButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
        playForwardButton.heightAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
        playForwardButton.centerXAnchor.constraint(equalTo: playControlView.centerXAnchor, constant: Constant.playButtonIndent).isActive = true
        playForwardButton.centerYAnchor.constraint(equalTo: playControlView.centerYAnchor, constant: 0).isActive = true
        playForwardButton.addTarget(self, action: #selector(playForwardButtonPressed), for: .touchUpInside)
    }

    private func setupPlayBackButton() {
        setupPlayBackForwardButtonColor()
        playControlView.addSubview(playBackButton)
        playBackButton.widthAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
        playBackButton.heightAnchor.constraint(equalToConstant: Constant.buttonWidth).isActive = true
        playBackButton.centerXAnchor.constraint(equalTo: playControlView.centerXAnchor, constant: -Constant.playButtonIndent).isActive = true
        playBackButton.centerYAnchor.constraint(equalTo: playControlView.centerYAnchor, constant: 0).isActive = true
        playBackButton.addTarget(self, action: #selector(playBackButtonPressed), for: .touchUpInside)
    }

    private func setupNameLabel() {
        playControlView.addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: playControlView.centerXAnchor, constant: 0).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: playControlView.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: playControlView.trailingAnchor, constant: -20).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: playControlView.bottomAnchor, constant: -40).isActive = true
    }

    private func setupLoader() {
        loader.color = .white
        view.addSubview(loader)
        loader.startAnimating()
        loader.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        loader.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
    }
    
    private func recreateBackVideoView() {
        backVideoView.removeFromSuperview()
        backVideoView = UIView(frame: CGRect.zero)
        backVideoView.backgroundColor = .clear
        backVideoView.isUserInteractionEnabled = false
        backVideoView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backVideoView, at: 0)
        backVideoView.fillSuperview()
    }

    private func setupControls() {
        recreateBackVideoView()
        setupLoader()
        setupPlayControlView()
        setupCloseButton()
        setupControlStackView()
        setupPlayPauseButton()
        setupPlayAirplayButton()
        setupPlayPipButton()
        setupFullScreenButton()
        setupSoundButton()
        setupErrorLabel()
        setupPlayForwardButton()
        setupPlayBackButton()
        setupNameLabel()
        setupBrightnessSlider()
        setupVolumeSlider()
    }

    private func setupVideoGravity() {
        playerLayer?.videoGravity = isFullScreenMode ? .resizeAspectFill : .resizeAspect
    }

    private func setupPlayer() {
        let urlString = channels[currentIndex].url.absoluteString.replacingSuffixIfCan(of: ".ts", with: ".m3u8")
        guard let url = URL(string: urlString) else {
            proccessError()
            return
        }
        
        removePlayerObservers()
        player?.pause()
        player = nil
        playerItem = nil
        playerLayer?.removeFromSuperlayer()
        recreateBackVideoView()
        
        pipButton.isEnabled = true
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: nil)
        player = pipModel?.player ?? AVPlayer(playerItem: playerItem)
        self.playerItem = pipModel?.player.currentItem ?? playerItem
        addPlayerObservers()
        let playerLayer = pipModel?.pipController.playerLayer ?? AVPlayerLayer(player: player)
        playerLayer.frame = backVideoView.bounds
        backVideoView.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer
        setupVideoGravity()
        if AVPictureInPictureController.isPictureInPictureSupported() {
            pipController = AVPictureInPictureController(playerLayer: playerLayer)
        }
        player?.play()
        
        errorLabel.isHidden = true
        playPauseButton.setImage(UIImage(imageName: Constant.pauseImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        pipModel = nil
        nameLabel.text = channels[currentIndex].name
    }
    
    private func setupBrightnessSlider() {
        brightnessSlider.addTarget(self, action: #selector(brightnessSliderValueDidChange(_:)), for: .valueChanged)
        playControlView.addSubview(brightnessSlider)
        brightnessSlider.centerYAnchor.constraint(equalTo: playControlView.centerYAnchor, constant: 0).isActive = true
        brightnessLeadingConstraint = brightnessSlider.leadingAnchor.constraint(equalTo: playControlView.leadingAnchor, constant: -Constant.sliderIndentPortrait)
        brightnessLeadingConstraint?.isActive = true
        brightnessSlider.widthAnchor.constraint(equalToConstant: 250).isActive = true
        brightnessSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
       
   @objc private func brightnessSliderValueDidChange(_ sender: UISlider) {
       UIScreen.main.brightness = CGFloat(sender.value)
   }
    
    private func setupVolumeSlider() {
        volumeSlider.addTarget(self, action: #selector(volumeSliderValueDidChange(_:)), for: .valueChanged)
        playControlView.addSubview(volumeSlider)
        volumeSlider.centerYAnchor.constraint(equalTo: playControlView.centerYAnchor, constant: 0).isActive = true
        volumeTrailingConstraint = volumeSlider.trailingAnchor.constraint(equalTo: playControlView.trailingAnchor, constant: Constant.sliderIndentPortrait)
        volumeTrailingConstraint?.isActive = true
        volumeSlider.widthAnchor.constraint(equalToConstant: 250).isActive = true
        volumeSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateBrighnessAndVolume()
        })
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main, using: { [weak self] _ in
            if let player = self?.player {
                let isPlaying = player.rate > 0
                self?.setupPlayPauseImage(!isPlaying)
            }
        })

    }
    
    private func updateBrighnessAndVolume() {
        brightnessSlider.value = Float(UIScreen.main.brightness)
        volumeSlider.value = AVAudioSession.sharedInstance().outputVolume
    }
       
   @objc private func volumeSliderValueDidChange(_ sender: UISlider) {
       MPVolumeView.setVolume(sender.value)
       player?.volume = 1
       setupSoundButtonImage()
   }

    private func updateIndents(isLandscape: Bool) {
        closeButtonTopConstraint?.constant = isLandscape ? Constant.buttonsTopIndentLandscape : Constant.buttonsTopIndentPortrait
        brightnessLeadingConstraint?.constant = isLandscape ? -Constant.sliderIndentLandscape : -Constant.sliderIndentPortrait
        volumeTrailingConstraint?.constant = isLandscape ? Constant.sliderIndentLandscape : Constant.sliderIndentPortrait
    }
}

extension PlayerVC {
    public enum Constant {
        public static var hideControlsTimeInterval: CGFloat = 10.0
        public static var playButtonWidth: CGFloat = 60
        public static var buttonWidth: CGFloat = 40
        public static var buttonsIndent: CGFloat = 10
        public static var playButtonIndent: CGFloat = 80
        public static var buttonsTopIndentPortrait: CGFloat = 50
        public static var buttonsTopIndentLandscape: CGFloat = 10
        public static var sliderIndentPortrait: CGFloat = 90
        public static var sliderIndentLandscape: CGFloat = 0
        public static var pauseImageName = "pause"
        public static var playImageName = "play"
        public static var soundOnImageName = "sound-on"
        public static var soundOffImageName = "sound-off"
        public static var outputVolume = "outputVolume"
        public static var backColor = UIColor.color(r: 0, g: 0, b: 0, a: 0.2)
    }

    public struct Channel {
        public let url: URL
        public let name: String

        public init(url: URL, name: String) {
            self.url = url
            self.name = name
        }
    }
}
