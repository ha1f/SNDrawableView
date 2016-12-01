## Overview
SNDrawableView is very simple view we can write on it, inherited from UIView.

![screenshot](https://raw.githubusercontent.com/ha1fha1f/SNDrawableView/master/screenshots/screenshot.png)


This project is fully dependent on [snakajima/SNDraw](https://github.com/snakajima/SNDraw).

## Requirement

Xcode 8
iOS 8.0 +

## Usage

We have three parameters to configure.

```swift
.lineColor: CGColor
.lineWidth: CGFloat
.numberOfQueuesToUndo: Int
```

`.lineColor` and `.lineWidth` is configuration about drawing line.

`.numberOfQueuesToUndo` represents the number of operations we can undo.
default value = 30

And we have 4 methods to execute.

```swift
.clear()
.redo()
.undo()
.getImage() -> UIImage!
```

By calling `.getImage()` , We can get image as UIImage.

Typically, `.undo()`, `.redo()`, and `.clear()` are associated to each button.


## Getting Started

use Carthage.

```Cartfile
github "ha1fha1f/SNDrawableView"
```

or copy framework inside your project. (like Demo project)

## Sample

You can see demo project in the `Demo` folder.

As you see, Main.storyboard is very simple. There is only one view, which class is associated to `DrawableView`.

Sample ViewController class as follows. Naturally, drawView is associated with storyboard's.

```swift
import UIKit
import SNDrawableView

class ViewController: UIViewController {
    @IBOutlet private weak var drawView: DrawableView!

    private let imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()

        // configure line. We can modify anytime.
        self.drawView.lineColor = UIColor.green.cgColor
        self.drawView.lineWidth = 12.0

        // create undo button, and associate to onPressedUndo()
        let undoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        undoButton.backgroundColor = .blue
        undoButton.addTarget(self, action: #selector(self.onPressedUndo), for: .touchUpInside)
        self.view.addSubview(undoButton)

        // create redo button, and associate to onPressedRedo()
        let redoButton = UIButton(frame: CGRect(x: 200, y: 0, width: 100, height: 100))
        redoButton.addTarget(self, action: #selector(self.onPressedRedo), for: .touchUpInside)
        redoButton.backgroundColor = .red
        self.view.addSubview(redoButton)

        // sample imageView to show usage of .getImage()
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
```
