//
//  timer.swift
//  IOS4_HW11_MIKHAIL_BAGMET
//
//  Created by Михаил on 26.11.2021.
//

import UIKit

protocol Stopwatch {
    var isWorkTime: Bool { get set }
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
    var isWorkTime = true
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

    /*private*/ func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

        if isPaused {
            //progressBarView.resumeAnimation()
        } else {
            //progressBarView.progressAnimation(duration: timeLeft)
        }

        isStarted = true
        isPaused = false

        //setImageForButton(icon: "pause.fill", button: playButton)
    }

    /*private*/ func pauseTimer() {
        timer?.invalidate()

        isStarted = false
        isPaused = true

        //progressBarView.pauseAnimation()
        //setImageForButton(icon: "play.fill", button: playButton)
    }

    private func changeMode() {
        if isWorkTime {
            isWorkTime = false
            timeLeft = 300.00

            //timerLabel.textColor = Colors.restColor
            //playButton.tintColor = Colors.restColor
        } else {
            isWorkTime = true
            timeLeft = 1500.00

            //timerLabel.textColor = Colors.workColor
            //playButton.tintColor = Colors.workColor
        }

        isStarted = false
        //timerLabel.text = timeLeftString
        //setImageForButton(icon: "play.fill", button: playButton)
        //progressBarView.changeMode()
    }

    @objc func updateTimer() {
        timeLeft -= 0.01
        print(timeLeftString)
        //timerLabel.text = timeLeftString

        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil

            changeMode()
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

