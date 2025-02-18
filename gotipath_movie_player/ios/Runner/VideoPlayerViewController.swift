import UIKit
import AVFoundation

@objc class VideoPlayerViewController: NSObject {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var currentURL: String?
    
    @objc func togglePlayPause(url: String, isPlaying: Bool) -> Bool {
        // If URL changed, create new player
        if currentURL != url {
            currentURL = url
            setupPlayer(with: url)
        }
        
        if isPlaying {
            player?.pause()
            return false
        } else {
            // Check if playback is at the end
            if let player = player, 
               player.currentTime() >= player.currentItem?.duration ?? CMTime.zero {
                player.seek(to: CMTime.zero)
            }
            player?.play()
            return true
        }
    }
    
    private func setupPlayer(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        // Remove existing player and layer
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        
        // Create new player and item
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        // Add end of playback observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootViewController = window.rootViewController {
                setupPlayerLayer(in: rootViewController.view)
            }
        } else {
            if let keyWindow = UIApplication.shared.keyWindow,
               let rootViewController = keyWindow.rootViewController {
                setupPlayerLayer(in: rootViewController.view)
            }
        }
        
        // Observe device orientation changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    @objc private func playerItemDidReachEnd(notification: Notification) {
        // Reset player to start when playback ends
        player?.seek(to: CMTime.zero)
        player?.pause()
    }
    
    private func setupPlayerLayer(in view: UIView) {
        // Remove existing player layer if any
        playerLayer?.removeFromSuperlayer()
        
        // Create new player layer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect  // Changed to resizeAspect for better video display
        
        // Calculate frame to maintain aspect ratio
        let screenSize = view.bounds.size
        let videoSize = CGSize(width: 16, height: 9) // Assuming 16:9 aspect ratio
        
        let aspectRatio = videoSize.width / videoSize.height
        let height = screenSize.width / aspectRatio
        let y = (screenSize.height - height) / 2
        
        playerLayer?.frame = CGRect(x: 0, y: y, width: screenSize.width, height: height)
        
        // Add player layer to view
        if let playerLayer = playerLayer {
            view.layer.addSublayer(playerLayer)
        }
    }
    
    @objc private func orientationChanged() {
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootViewController = window.rootViewController {
                setupPlayerLayer(in: rootViewController.view)
            }
        } else {
            if let keyWindow = UIApplication.shared.keyWindow,
               let rootViewController = keyWindow.rootViewController {
                setupPlayerLayer(in: rootViewController.view)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
} 
