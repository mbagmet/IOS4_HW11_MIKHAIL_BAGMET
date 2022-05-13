//
//  timer.swift
//  IOS4_HW11_MIKHAIL_BAGMET
//
//  Created by Михаил on 26.11.2021.
//

import UIKit

protocol Stopwatch {

    var delegate: PomodoroTimerDelegate? { get set }
    var animationDelegate: PomodoroTimerAnimationDelegate? { get set }

    var isWorkTime: Bool { get set }
    var isStarted: Bool { get set }
    var isPaused: Bool { get set }
    var timer: Timer? { get set }
    var timeLeft: TimeInterval { get set }
    var timeLeftString: String { get }

    func startTimer()
    func pauseTimer()
    func updateTimer()
    func convertSecondsToString(timeLeft: TimeInterval) -> String
}

protocol PomodoroTimerDelegate {

    func changeTimerText(_ timeLeftString: String)
    func changeMode(_ isWorkTime: Bool)
    func changeStartPauseButtonIcon(_ isStarted: Bool)
}

protocol PomodoroTimerAnimationDelegate {

    func progressAnimation(duration: TimeInterval)
    func resumeAnimation()
    func pauseAnimation()
    func changeAnimationMode(_ isWorkTime: Bool)
}

class PomodoroTimer: Stopwatch {

    var delegate: PomodoroTimerDelegate?
    var animationDelegate: PomodoroTimerAnimationDelegate?

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

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

        if isPaused {
            animationDelegate?.resumeAnimation()
        } else {
            animationDelegate?.progressAnimation(duration: timeLeft)
        }

        isStarted = true
        isPaused = false

        delegate?.changeStartPauseButtonIcon(isStarted)
    }

    func pauseTimer() {
        timer?.invalidate()

        isStarted = false
        isPaused = true

        animationDelegate?.pauseAnimation()
        delegate?.changeStartPauseButtonIcon(isStarted)
    }

    private func changeMode() {
        if isWorkTime {
            isWorkTime = false
            timeLeft = TimerIntervals.restTime

            delegate?.changeMode(isWorkTime)
        } else {
            isWorkTime = true
            timeLeft = TimerIntervals.workTime

            delegate?.changeMode(isWorkTime)
        }

        isStarted = false
        isPaused = false

        delegate?.changeTimerText(timeLeftString)
        delegate?.changeStartPauseButtonIcon(isStarted)
        animationDelegate?.changeAnimationMode(isWorkTime)
    }

    @objc func updateTimer() {
        timeLeft -= 0.01

        delegate?.changeTimerText(timeLeftString)

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

// MARK: - Constants
extension PomodoroTimer {

    enum TimerIntervals {
        static let workTime: TimeInterval = 1500.00
        static let restTime: TimeInterval = 300.00
    }
}

