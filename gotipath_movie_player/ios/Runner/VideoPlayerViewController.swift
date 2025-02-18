import UIKit
import AVFoundation

@objc class VideoPlayerViewController: NSObject {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    @objc func togglePlayPause(url: String, isPlaying: Bool) -> Bool {
        if player == nil {
            setupPlayer(with: url)
        }
        
        if isPlaying {
            player?.pause()
            return false
        } else {
            player?.play()
            return true
        }
    }
    
    private func setupPlayer(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        player = AVPlayer(url: url)
        
        if #available(iOS 13.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootViewController = window.rootViewController {
                
                playerLayer = AVPlayerLayer(player: player)
                playerLayer?.frame = rootViewController.view.bounds
                rootViewController.view.layer.addSublayer(playerLayer!)
            }
        } else {
            // Fallback on earlier versions
        }
    }
} 
