//
//  ViewController.swift
//  IOS4_HW11_MIKHAIL_BAGMET
//
//  Created by Михаил on 22.11.2021.
//

import UIKit

class ViewController: UIViewController {

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
        let label = UILabel()

        label.text = "25:00"
        label.font =  .systemFont(ofSize: 70, weight: .thin)
        label.textColor = #colorLiteral(red: 0.9921568627, green: 0.5529411765, blue: 0.5137254902, alpha: 1)
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var playButton = createButton(with: "play", tintColor: #colorLiteral(red: 0.9921568627, green: 0.5529411765, blue: 0.5137254902, alpha: 1))

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
        parentStackView.addArrangedSubview(timerLabel)
        parentStackView.addArrangedSubview(playButton)
    }

    private func setupLayout() {
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        parentStackView.leadingAnchor.constraint(equalTo: progressBarView.leadingAnchor, constant: 20).isActive = true
        parentStackView.topAnchor.constraint(equalTo: progressBarView.topAnchor, constant: 85).isActive = true
        parentStackView.trailingAnchor.constraint(equalTo: progressBarView.trailingAnchor, constant: -20).isActive = true
        parentStackView.heightAnchor.constraint(equalToConstant: 153).isActive = true

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
        button.setImage(UIImage(systemName: icon)?
                            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 36, weight: .thin))), for: .normal)
        button.tintColor = tintColor

        button.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1).isActive = true

        return button
    }
}

// MARK: - Constants
extension ViewController {

    enum Metric {
        static let buttonHeight: CGFloat = 50
    }

    enum Strings {

    }
}

