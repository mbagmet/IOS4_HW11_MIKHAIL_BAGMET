//
//  ProgressBarView.swift
//  IOS4_HW11_MIKHAIL_BAGMET
//
//  Created by Михаил on 25.11.2021.
//

import UIKit

class ProgressBarView: UIView {
    override func draw(_ rect: CGRect) {
        let rect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)

        drawCircular(in: rect)
        progressAnimation(duration: 5)
    }

    private func drawCircular(in rect: CGRect) {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)

        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startPoint, endAngle: endPoint, clockwise: false)

        circleLayer.path = path.cgPath
        circleLayer.lineWidth = 5
        circleLayer.lineCap = .round

        circleLayer.strokeColor = UIColor(#colorLiteral(red: 0.9921568627, green: 0.5529411765, blue: 0.5137254902, alpha: 1)).cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeEnd = 1
        layer.addSublayer(circleLayer)

        progressLayer.path = path.cgPath
        progressLayer.lineWidth = 5
        progressLayer.strokeColor = UIColor(#colorLiteral(red: 0.8196078431, green: 0.8470588235, blue: 0.8745098039, alpha: 1)).cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)

    }

    func progressAnimation(duration: TimeInterval) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }

    // MARK: - Properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private let radius = CGFloat(130)
    private var startPoint = CGFloat(3 * Double.pi / 2)
    private var endPoint = CGFloat(-Double.pi / 2)
}

