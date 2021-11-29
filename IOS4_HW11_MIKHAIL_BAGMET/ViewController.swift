//
//  ViewController.swift
//  IOS4_HW11_MIKHAIL_BAGMET
//
//  Created by Михаил on 22.11.2021.
//

import UIKit

class ViewController: UIViewController {
    private lazy var pomodoroTimer = PomodoroTimer(timeLeft: 15.00)

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

    static var timerLabel = createTimerLabel(text: Strings.timeLeft)

    private lazy var playButton: UIButton = {
        var button = UIButton()
        button = createButton(with: "play.fill", tintColor: #colorLiteral(red: 0.9921568627, green: 0.5529411765, blue: 0.5137254902, alpha: 1))
        button.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHierarchy()
        setupLayout()
        setupView()
    }

    // MARK: - Settings
    private func setupHierarchy() {
        view.addSubview(progressBarView)
        progressBarView.addSubview(parentStackView)
        parentStackView.addArrangedSubview(ViewController.timerLabel)
        parentStackView.addArrangedSubview(playButton)
    }

    private func setupLayout() {
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        parentStackView.leadingAnchor.constraint(equalTo: progressBarView.leadingAnchor, constant: 20).isActive = true
        parentStackView.topAnchor.constraint(equalTo: progressBarView.topAnchor, constant: 83).isActive = true
        parentStackView.trailingAnchor.constraint(equalTo: progressBarView.trailingAnchor, constant: -20).isActive = true
        parentStackView.heightAnchor.constraint(equalToConstant: 152).isActive = true

        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        progressBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        progressBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120).isActive = true
        progressBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        progressBarView.heightAnchor.constraint(equalToConstant: 300).isActive = true
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
        button.setImage(UIImage(systemName: icon)?
                            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 36, weight: .thin))), for: .normal)
    }

    static func createTimerLabel(text: String) -> UILabel {
        let label = UILabel()

        label.text = text
        label.font = .monospacedDigitSystemFont(ofSize: 70, weight: .thin)
        label.textColor = #colorLiteral(red: 0.9921568627, green: 0.5529411765, blue: 0.5137254902, alpha: 1)
        label.adjustsFontSizeToFitWidth = true

        return label
    }

    // MARK: - Static functions
    func changeMode() {
        playButton.tintColor = #colorLiteral(red: 0.4, green: 0.7647058824, blue: 0.6431372549, alpha: 1)
    }

    // MARK: - Actions
    @objc private func playButtonAction() {
        if pomodoroTimer.isStarted {
            pomodoroTimer.pauseTimer()
            progressBarView.pauseAnimation()
            setImageForButton(icon: "play.fill", button: playButton)
        } else if pomodoroTimer.isPaused {
            pomodoroTimer.startTimer()
            progressBarView.resumeAnimation()
            setImageForButton(icon: "pause.fill", button: playButton)
        } else {
            pomodoroTimer.startTimer()
            progressBarView.progressAnimation(duration: pomodoroTimer.timeLeft)
            setImageForButton(icon: "pause.fill", button: playButton)
        }
    }
}

// MARK: - Constants
extension ViewController {

    enum Metric {
        static let buttonHeight: CGFloat = 50
    }

    enum Strings {
        static let timeLeft: String = "00:15"
    }

    enum Colors {
        static var color: UIColor = #colorLiteral(red: 0.9921568627, green: 0.5529411765, blue: 0.5137254902, alpha: 1)
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

