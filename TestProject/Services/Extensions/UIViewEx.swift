//
//  UIViewEx.swift
//  Skeleton
//
//  Created by Woxapp on 21.11.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit
import AudioToolbox

extension UIView {


    func complexAnimation(_ duration: Double = 0.3, _ option: UIView.AnimationOptions = .transitionCrossDissolve, block: @escaping (() -> Void), _ handler: ((Bool) -> Void)? = nil) {
        UIView.transition(with: self, duration: duration, options: option, animations: block, completion: handler)
    }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }

    func addHole(rect: CGRect) {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        let path = UIBezierPath(rect: bounds)
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        path.append(UIBezierPath(rect: rect))
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }

    func addGradient(colors: [CGColor], horizontal: Bool) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        if horizontal == true {
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        layer.insertSublayer(gradient, at: 0)
    }

    func showIndicator(color: UIColor) {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: (frame.size.width - 27) / 2, y: (frame.size.height - 27) / 2, width: 27, height: 27))
        activityIndicator.color = color
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        isUserInteractionEnabled = false
    }

    func hideIndicator() {
        isUserInteractionEnabled = true
        for subview in subviews {
            if subview is UIActivityIndicatorView {
                subview.removeFromSuperview()
                break
            }
        }
    }

    var snapShot: UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot ?? UIImage()
    }

    // TODO: - create selection for each corner

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
    }

    @IBInspectable var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }

    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }

    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }

    @IBInspectable var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue?.cgColor
        }
        get {
            return UIColor(cgColor: layer.shadowColor!)
        }
    }

}

enum GradientDirection: Int {

    case fromLeftToRight = 0
    case fromRightToLeft = 1
    case fromBottomToTop = 2
    case fromTopToBottom = 3

    var startPoint: CGPoint {
        switch self {
        case .fromLeftToRight: return CGPoint(x: 0, y: 0)
        case .fromRightToLeft: return CGPoint(x: 1, y: 0)
        case .fromBottomToTop: return CGPoint(x: 0, y: 1)
        case .fromTopToBottom: return CGPoint(x: 0, y: 0)
        }
    }

    var endpoint: CGPoint {
        switch self {
        case .fromLeftToRight: return GradientDirection.fromRightToLeft.startPoint
        case .fromRightToLeft: return GradientDirection.fromLeftToRight.startPoint
        case .fromBottomToTop: return GradientDirection.fromTopToBottom.startPoint
        case .fromTopToBottom: return GradientDirection.fromBottomToTop.startPoint
        }
    }

}

@IBDesignable class GradientView: UIView {

    @IBInspectable var topColor: UIColor = .white
    @IBInspectable var bottomColor: UIColor = .black
    @IBInspectable var gradientDirection: Int = GradientDirection.fromLeftToRight.rawValue

    var direction: GradientDirection {
        return GradientDirection(rawValue: gradientDirection) ?? .fromLeftToRight
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        guard let currentLayer = layer as? CAGradientLayer
            else {
                return
        }
        currentLayer.startPoint = direction.startPoint
        currentLayer.endPoint = direction.endpoint
        currentLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        isUserInteractionEnabled = false
    }

}
