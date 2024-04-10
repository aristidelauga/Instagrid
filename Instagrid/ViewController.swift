//
//  ViewController.swift
//  Instagrid
//
//  Created by Aristide LAUGA on 02/12/2023.
//

import UIKit

class ViewController: UIViewController {


	@IBOutlet weak var swipeUpLabel: UILabel!
	@IBOutlet weak var arrowView: UIImageView!

	override func viewDidLoad() {
    super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(orientationObserved), name: UIDevice.orientationDidChangeNotification, object: nil)
  }

	@objc func orientationObserved() {
		let orientation = UIDevice.current.orientation
		if orientation.isPortrait {
			swipeUpLabel.text = "Swipe up to share"
			arrowView.transform = CGAffineTransform(rotationAngle: 0)
		} else {
			swipeUpLabel.text = "Swipe left to share"
			arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
		}
	}

 
}

