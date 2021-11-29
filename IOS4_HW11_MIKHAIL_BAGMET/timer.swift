//
//  timer.swift
//  IOS4_HW11_MIKHAIL_BAGMET
//
//  Created by Михаил on 26.11.2021.
//

import UIKit

protocol Stopwatch {
    static var isWorkTime: Bool { get set }
    var isStarted: Bool { get set }
    var isPaused: Bool { get set }
    var timer: Timer? { get set }
    var timeLeft: TimeInterval { get set }
    var timeLeftString: String { get }

    func startTimer()
    func pauseTimer()
    //func updateTimer()
    func convertSecondsToString(timeLeft: TimeInterval) -> String
}

class PomodoroTimer: Stopwatch {
    static var isWorkTime = true
    var isStarted = false
    var isPaused = false
    var timer: Timer?
    var timeLeft: TimeInterval
    var timeLeftString: String {
        return convertSecondsToString(timeLeft: timeLeft)
    }

    init(timeLeft: TimeInterval) {
        self.timeLeft = timeLeft
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        //RunLoop.current.add(timer?, forMode: .commonModes)
        isStarted = true
        isPaused = false
    }

    func pauseTimer() {
        timer?.invalidate()
        isStarted = false
        isPaused = true
    }

    @objc func updateTimer() {
        timeLeft -= 0.01
        print(timeLeftString)
        ViewController.timerLabel.text = timeLeftString

        if timeLeft <= 0 {
            isStarted = false
            timer?.invalidate()
            timer = nil
            if PomodoroTimer.isWorkTime {
                PomodoroTimer.isWorkTime = false
            } else {
                PomodoroTimer.isWorkTime = true
            }
        }
    }

    func convertSecondsToString(timeLeft: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]

        return formatter.string(from: timeLeft) ?? "00:00"
    }
}

