//
//  CMTime.swift
//  IUCA Tour
//
//  Created by User on 2/22/22.
//

import AVKit

extension CMTime {
    
    func toDisplayString() -> String {
        
        let totalSeconds = CMTimeGetSeconds(self)

        
        guard !(CMTimeGetSeconds(self).isNaN || totalSeconds.isInfinite) else {
            return "illegal value" // or do some error handling
        }
        
        let secondsTotal = Int(totalSeconds)
        
        let seconds = secondsTotal % 60
        let minutes = secondsTotal / 60
        
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        
        return timeFormatString
    }
    
}
