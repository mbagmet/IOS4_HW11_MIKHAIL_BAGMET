//
//  ViewController.swift
//  IOS4_HW11_MIKHAIL_BAGMET
//
//  Created by Михаил on 22.11.2021.
//

import UIKit

class ViewController: UIViewController {
    private lazy var pomodoroTimer = PomodoroTimer(timeLeft: 15.00)

    private lazy var pomodoroTimer: PomodoroTimer = {
        let timer = PomodoroTimer(timeLeft: PomodoroTimer.TimerIntervals.workTime)
        timer.delegate = self
        timer.animationDelegate = progressBarView
        return timer
    }()

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

        label.text = pomodoroTimer.timeLeftString
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

    private lazy var parentStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 100

        return stackView
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()

        label.text = "25:00"
        label.font = .systemFont(ofSize: 70, weight: .thin)
        label.textColor = #colorLiteral(red: 0.9921568627, green: 0.5529411765, blue: 0.5137254902, alpha: 1)
        label.adjustsFontSizeToFitWidth = true

        return label
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
        if pomodoroTimer.isStarted {
            pomodoroTimer.pauseTimer()
        } else {
            pomodoroTimer.startTimer()
        }
    }
}

// MARK: - StapwatchTimer delegate functions
extension ViewController: PomodoroTimerDelegate {

    func changeTimerText(_ timeLeftString: String) {
        timerLabel.text = timeLeftString
    }

    func changeMode(_ isWorkTime: Bool) {
        if isWorkTime {
            timerLabel.textColor = Colors.workColor
            playButton.tintColor = Colors.workColor
        } else {
            timerLabel.textColor = Colors.restColor
            playButton.tintColor = Colors.restColor
        }
    }

    func changeStartPauseButtonIcon(_ isStarted: Bool) {
        if isStarted {
            setImageForButton(icon: "pause.fill", button: playButton)
        } else {
            setImageForButton(icon: "play.fill", button: playButton)
        }
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

