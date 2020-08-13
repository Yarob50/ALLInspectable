//
//  SwiftShadowView.swift
//  SwiftShadow
//
//  Created by يعرب المصطفى on 6/21/20.
//  Copyright © 2020 yarob. All rights reserved.
//

import UIKit


@IBDesignable
class AllInspectableView: UIView {
    
    // MARK: VARS
    var shadowRange: Float = 100
    private var shadowPath = UIBezierPath()
    private var rect = CGRect()
    override var frame: CGRect{
        didSet{
            applyShadow()
            if self.circuledCorners {
                applyCirculedCorners()
            }
        }
    }
    
    // MARK: SHADOW INSPECTABLES
    @IBInspectable var shadowColor: UIColor = UIColor.black{
        didSet{
            applyShadow()
        }
    }
    
    @IBInspectable var shrinkFactor: CGFloat = 0.05 {
        didSet{
            applyShadow()
        }
    }
    
    
    @IBInspectable var shadowOpacity: Float = 50 {
        didSet{
            applyShadow()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 7 {
        didSet{
            applyShadow()
        }
    }
    
    @IBInspectable var yOffset:CGFloat = 15
        {
        didSet{
            applyShadow()
        }
    }

    @IBInspectable var xOffset:CGFloat = 0
        {
        didSet{
            applyShadow()
        }
    }
    
    @IBInspectable var coloredShadow: Bool = true {
        didSet{
            if coloredShadow == true {
                self.shadowColor = self.startColor
            }else {
                self.shadowColor = UIColor.black
            }
        }
    }
    
     func applyShadow(){
        let factor:CGFloat = shrinkFactor
        let horizontalOffset = self.frame.width * factor
        rect = CGRect(x: horizontalOffset + xOffset, y: 0 + yOffset, width: self.frame.width - 2*horizontalOffset, height: self.frame.height)
        shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity/shadowRange
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
    }
    
    func applyColor(style: ColorStyle){
        if let startColor = style.startColor {
            self.startColor = startColor
        }
        
        if let endColor = style.endColor {
            self.endColor = endColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow()
        if self.circuledCorners {
            self.applyCirculedCorners()
        }
    }
    
    // MARK: BORDER & CORNERS INSPECTABLES
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            applyShadow()
        }
    }
    
    @IBInspectable var circuledCorners: Bool = false{
        didSet {
            if circuledCorners == true {
                    self.layer.cornerRadius = self.frame.width/2
                    applyShadow()
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    // MARK: GRADIENT INSPECTABLES
    @IBInspectable var startColor:   UIColor = .systemOrange { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .systemOrange { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    func updateColors() {
        if endColor == UIColor.clear {
            gradientLayer.colors = [startColor.cgColor, startColor.cgColor]
        }else {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
        
        if self.coloredShadow {
            self.shadowColor = startColor
        }
    }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
    
    func applyShadow(forShadowValues values: ShadowStyle){
        if let opacity = values.shadowOpacity {
            self.shadowOpacity = opacity
        }
        if let radius = values.shadowRadius {
            self.shadowRadius = radius
        }
        if let colored = values.coloredShadow {
            self.coloredShadow = colored
        }
        
        if let factor = values.shadowShrinkFactor {
            self.shrinkFactor = factor
        }
    }
    
    func applyCirculedCorners() {
        var constant:CGFloat = 0
        if self.frame.height >= self.frame.width {
            constant = self.frame.height
        }else {
            constant = self.frame.width
        }
        self.layer.cornerRadius = constant/2
    }
    
    func applyShapeStyle(style: ShapeStyle){
        self.applyShadow(forShadowValues: style.shadowStyle)
        self.applyColor(style: style.colorStyle)
    }
}


