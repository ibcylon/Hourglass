//
//  TimerManager.swift
//  Hourglass
//
//  Created by Kanghos on 2022/02/06.
//

import Foundation

class TimerManager {
    
    static let shared = TimerManager()
    
    var timer: Timer?
    var timeLeft: Double = 0
    var timeString: String {
        return secondsToString(sec: timeLeft)
    }
    var isTimerRunning: Bool {
        return timer != nil
    }
    var targetTime: Date = Date()
    
    private init(){}
    
    private func secondsToString(sec: Double) -> String {
        guard sec.isNaN == false else { return "00 : 00" }
        let totalSeconds = Int(sec)
        let min = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d : %02d", min, seconds)
    }
    
    func startTimer(duration: TimeInterval ,completion: @escaping (String, TimeInterval) -> Void) {
        
        targetTime = Date(timeInterval: duration, since: Date())
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [unowned self] timer in
            print("Fire")
            let remaining = self.targetTime.timeIntervalSince(Date())
            if remaining <= 0 {
                completion("00 : 00", remaining)
                timer.invalidate()
            } else {
                let timeString = self.secondsToString(sec: remaining)
                completion(timeString, remaining)
            }
        }
        timer?.fire()
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
        timeLeft = 0
    }
    
    func resetTimer(){
        timer?.invalidate()
        timeLeft = 0
    }
}
