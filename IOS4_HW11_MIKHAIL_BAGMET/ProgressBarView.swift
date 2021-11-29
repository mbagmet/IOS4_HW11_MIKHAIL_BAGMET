//
//  ProgressBarView.swift
//  IOS4_HW11_MIKHAIL_BAGMET
//
//  Created by Михаил on 29.11.2021.
//

import UIKit

class ProgressBarView: UIView {

    override func draw(_ rect: CGRect) {
        let rect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)

        drawTimer(in: rect)
    }

    // MARK: - Draw timer circles and pointer
    private func drawTimer(in rect: CGRect) {
        // Timer Circles
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startPoint, endAngle: endPoint, clockwise: false)

        circleLayer.path = path.cgPath
        circleLayer.lineWidth = timerLineWidth
        circleLayer.lineCap = .round

        circleLayer.strokeColor = ViewController.Colors.workColor.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeEnd = 1
        layer.addSublayer(circleLayer)

        progressLayer.path = path.cgPath
        progressLayer.lineWidth = timerLineWidth
        progressLayer.strokeColor = UIColor(#colorLiteral(red: 0.8196078431, green: 0.8470588235, blue: 0.8745098039, alpha: 1)).cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)

        // Pointer
        let pointerCenter = path.currentPoint
        let pointerPath = UIBezierPath(arcCenter: pointerCenter, radius: pointerRadius, startAngle: startPoint, endAngle: endPoint, clockwise: false)

        pointerLayer.path = pointerPath.cgPath
        pointerLayer.lineWidth = pointerLineWidth
        pointerLayer.strokeColor = ViewController.Colors.workColor.cgColor
        pointerLayer.fillColor = UIColor.white.cgColor
        pointerLayer.strokeEnd = 1
        layer.addSublayer(pointerLayer)

        // Layer position for animation
        let pointerPosition = UIBezierPath(arcCenter: CGPoint(x: 0, y: rect.height / 2 - pointerRadius * 2),
                                           radius: radius, startAngle: startPoint, endAngle: endPoint, clockwise: false)
        pointerPositionLayer.path = pointerPosition.cgPath
    }

    // MARK: - Animations
    func progressAnimation(duration: TimeInterval) {
        let pointerProgressAnimation = CAKeyframeAnimation(keyPath: "position")
        pointerProgressAnimation.duration = duration
        pointerProgressAnimation.fillMode = CAMediaTimingFillMode.forwards;
        pointerProgressAnimation.path = pointerPositionLayer.path
        pointerLayer.add(pointerProgressAnimation, forKey: "progressAnim")

        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1
        circularProgressAnimation.fillMode = .forwards
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }

    func pauseAnimation(){
        let pausedTime = pointerLayer.convertTime(CACurrentMediaTime(), from: nil)
        pointerLayer.speed = 0
        pointerLayer.timeOffset = pausedTime
        progressLayer.speed = 0
        progressLayer.timeOffset = pausedTime
    }

    func resumeAnimation(){
        let pausedTime = pointerLayer.timeOffset
        pointerLayer.speed = 1
        pointerLayer.timeOffset = 0
        pointerLayer.beginTime = 0
        progressLayer.speed = 1
        progressLayer.timeOffset = 0
        progressLayer.beginTime = 0
        let timeSincePause = pointerLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        pointerLayer.beginTime = timeSincePause
        progressLayer.beginTime = timeSincePause
    }

    func changeMode() {
        if ViewController.Mode.isWorkTime {
            circleLayer.strokeColor = ViewController.Colors.workColor.cgColor
            pointerLayer.strokeColor = ViewController.Colors.workColor.cgColor
        } else {
            circleLayer.strokeColor = ViewController.Colors.restColor.cgColor
            pointerLayer.strokeColor = ViewController.Colors.restColor.cgColor
        }
    }

    // MARK: - Properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var pointerLayer = CAShapeLayer()
    private var pointerPositionLayer = CAShapeLayer()

    private let radius = CGFloat(130)
    private let pointerRadius = CGFloat(10)
    private let startPoint = CGFloat(3 * Double.pi / 2)
    private let endPoint = CGFloat(-Double.pi / 2)

    private let timerLineWidth = CGFloat(5)
    private let pointerLineWidth = CGFloat(2)
}

