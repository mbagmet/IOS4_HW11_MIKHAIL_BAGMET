//
//  ViewController.swift
//  IOS4_HW11_MIKHAIL_BAGMET
//
//  Created by Михаил on 22.11.2021.
//

import UIKit

class ViewController: UIViewController {
    private lazy var pomodoroTimer = PomodoroTimer(timeLeft: 15.00)

    private var pomodoroTimer: Timer?

    private lazy var progressBarView: ProgressBarView = {
        let progressBar = ProgressBarView()
        progressBar.backgroundColor = .white
        return progressBar
    }()

    private lazy var parentStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        return stackView
    }()

    private lazy var timerLabel: UILabel = {
        var label = UILabel()

        label.text = timeLeftString
        label.font = .monospacedDigitSystemFont(ofSize: Metric.timeLabelFontSize, weight: .thin)
        label.textColor = Colors.workColor
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var playButton: UIButton = {
        var button = UIButton()
        button = createButton(with: "play.fill", tintColor: Colors.workColor)
        button.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
    }

    // MARK: - Settings
    private func setupHierarchy() {
        view.addSubview(progressBarView)
        progressBarView.addSubview(parentStackView)
        parentStackView.addArrangedSubview(ViewController.timerLabel)
        parentStackView.addArrangedSubview(playButton)
    }

    private func setupLayout() {
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        progressBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Metric.progressBarViewLeading).isActive = true
        progressBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.progressBarViewTop).isActive = true
        progressBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Metric.progressBarViewTrailing).isActive = true
        progressBarView.heightAnchor.constraint(equalToConstant: Metric.progressBarViewHeight).isActive = true

        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        parentStackView.leadingAnchor.constraint(equalTo: progressBarView.leadingAnchor, constant: Metric.progressBarViewLeading).isActive = true
        parentStackView.topAnchor.constraint(equalTo: progressBarView.topAnchor, constant: Metric.parentStackViewTop).isActive = true
        parentStackView.trailingAnchor.constraint(equalTo: progressBarView.trailingAnchor, constant: Metric.progressBarViewTrailing).isActive = true
        parentStackView.heightAnchor.constraint(equalToConstant: Metric.parentStackViewHeight).isActive = true
    }

    private func setupView() {

    }

    // MARK: - Private functions
    private func createButton(with icon: String, tintColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        setImageForButton(icon: icon, button: button)
        button.tintColor = tintColor

        button.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true

        return button
    }

    private func setImageForButton(icon: String, button: UIButton) {
        button.setImage(UIImage(systemName: icon)?.applyingSymbolConfiguration(UIImage
            .SymbolConfiguration(font: .systemFont(ofSize: Metric.buttonImageSize, weight: .thin))), for: .normal)
    }

    // MARK: - Actions
    @objc private func playButtonAction() {
        if Mode.isStarted {
            pauseTimer()
        } else {
            startTimer()
        }
    }
}

// MARK: - StapwatchTimer
extension ViewController {

    enum Mode {
        static var isWorkTime = true
        static var isStarted = false
        static var isPaused = false
    }

    enum Parameters {
        static var timeLeft: TimeInterval = 1500.00
    }

    private var timeLeftString: String {
        return convertSecondsToString(timeLeft: Parameters.timeLeft)
    }

    private func startTimer() {
        pomodoroTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

        if Mode.isPaused {
            progressBarView.resumeAnimation()
        } else {
            progressBarView.progressAnimation(duration: Parameters.timeLeft)
        }

        Mode.isStarted = true
        Mode.isPaused = false

        setImageForButton(icon: "pause.fill", button: playButton)
    }

    private func pauseTimer() {
        pomodoroTimer?.invalidate()

        Mode.isStarted = false
        Mode.isPaused = true

        progressBarView.pauseAnimation()
        setImageForButton(icon: "play.fill", button: playButton)
    }

    private func changeMode() {
        if Mode.isWorkTime {
            Mode.isWorkTime = false
            Parameters.timeLeft = 300.00

            timerLabel.textColor = Colors.restColor
            playButton.tintColor = Colors.restColor
        } else {
            Mode.isWorkTime = true
            Parameters.timeLeft = 1500.00

            timerLabel.textColor = Colors.workColor
            playButton.tintColor = Colors.workColor
        }

        Mode.isStarted = false
        timerLabel.text = timeLeftString
        setImageForButton(icon: "play.fill", button: playButton)
        progressBarView.changeMode()
    }

    @objc func updateTimer() {
        Parameters.timeLeft -= 0.01

        timerLabel.text = timeLeftString

        if Parameters.timeLeft <= 0 {
            pomodoroTimer?.invalidate()
            pomodoroTimer = nil

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
extension ViewController {

    enum Metric {
        static let buttonHeight: CGFloat = 50
        static let buttonImageSize: CGFloat = 36
        static let timeLabelFontSize: CGFloat = 70

        static let progressBarViewLeading: CGFloat = 20
        static let progressBarViewTop: CGFloat = 120
        static let progressBarViewTrailing: CGFloat = -20
        static let progressBarViewHeight: CGFloat = 300

        static let parentStackViewTop: CGFloat = 83
        static let parentStackViewHeight: CGFloat = 152
    }

    enum Colors {
        static let workColor: UIColor = #colorLiteral(red: 0.9921568627, green: 0.5529411765, blue: 0.5137254902, alpha: 1)
        static let restColor: UIColor = #colorLiteral(red: 0.3882352941, green: 0.768627451, blue: 0.6431372549, alpha: 1)
    }

    enum Modes {
        var isWorkTime: Bool {
            get {
                return PomodoroTimer.isWorkTime
            }
            set {
                print(newValue)
            }
        }
    }
}

