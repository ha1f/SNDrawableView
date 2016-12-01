//
//  ViewController.swift
//  SNDrawableViewDemo
//
//  Created by はるふ on 2016/12/01.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import UIKit
import SNDrawableView

class ViewController: UIViewController {
    @IBOutlet private weak var drawView: DrawableView!
    
    private let imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawView.lineColor = UIColor.green.cgColor
        self.drawView.lineWidth = 12.0
        
        let undoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        undoButton.backgroundColor = .blue
        undoButton.addTarget(self, action: #selector(self.onPressedUndo), for: .touchUpInside)
        self.view.addSubview(undoButton)
        
        let redoButton = UIButton(frame: CGRect(x: 200, y: 0, width: 100, height: 100))
        redoButton.addTarget(self, action: #selector(self.onPressedRedo), for: .touchUpInside)
        redoButton.backgroundColor = .red
        self.view.addSubview(redoButton)
        
        imageView.backgroundColor = .lightGray
        self.view.addSubview(imageView)
    }
    
    func onPressedUndo() {
        imageView.image = self.drawView.getImage()
        self.drawView.undo()
    }
    
    func onPressedRedo() {
        imageView.image = self.drawView.getImage()
        self.drawView.redo()
    }
}
