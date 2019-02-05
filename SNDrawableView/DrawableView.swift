//
//  DrawableView.swift
//  DrawableView
//
//  Created by はるふ on 2016/12/01.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit

public class DrawableView: SNDrawView {
    
    fileprivate var layers = [CALayer]()
    fileprivate var undoLayers = [CALayer]()
    
    public var numberOfQueuesToUndo = 30
    
    public var lineWidth: CGFloat = 10.0 {
        didSet {
            shapeLayer.lineWidth = lineWidth
        }
    }
    public var lineColor: CGColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.3).cgColor {
        didSet {
            shapeLayer.strokeColor = lineColor
        }
    }
    
    public func clear() {
        for layer in layers {
            layer.removeFromSuperlayer()
        }
        layers.removeAll()
    }
    
    public func redo() {
        if let layer = undoLayers.popLast() {
            layers.append(layer)
            self.layer.addSublayer(layer)
        }
    }
    
    public func undo() {
        if let layer = layers.popLast() {
            layer.removeFromSuperlayer()
            undoLayers.append(layer)
            // 数が増えすぎないように
            if undoLayers.count > numberOfQueuesToUndo {
                undoLayers.removeFirst()
            }
        }
    }
    
    public func getImage() -> UIImage! {
        let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return capturedImage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
}

extension DrawableView: SNDrawViewDelegate {
    public func didComplete(_ elements: [SNPathElement]) -> Bool {
        
        // 書いたらもうredoできない
        undoLayers.removeAll()
        
        let layerCurve = CAShapeLayer()
        
        // Extra round-trips to SVG and CGPath
        let svg = SNPath.svg(from: elements)
        let es = SNPath.elements(from: svg)
        let path = SNPath.path(from: es)
        let es2 = SNPath.elements(from: path)
        
        layerCurve.path = SNPath.path(from: es2)
        layerCurve.lineWidth = lineWidth
        layerCurve.fillColor = UIColor.clear.cgColor
        layerCurve.strokeColor = lineColor
        layerCurve.lineCap = convertToCAShapeLayerLineCap("round")
        layerCurve.lineJoin = convertToCAShapeLayerLineJoin("round")
        self.layer.addSublayer(layerCurve)
        layers.append(layerCurve)
        
        return true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineCap(_ input: String) -> CAShapeLayerLineCap {
	return CAShapeLayerLineCap(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineJoin(_ input: String) -> CAShapeLayerLineJoin {
	return CAShapeLayerLineJoin(rawValue: input)
}
