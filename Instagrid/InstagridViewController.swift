//
//  ViewController.swift
//  InstagridViewController
//
//  Created by Aristide LAUGA on 02/12/2023.
//

import UIKit

final class InstagridViewController: UIViewController {

// Pourquoi doit-on les mettre en weak?
	@IBOutlet private weak var swipeUpLabel: UILabel!
	@IBOutlet private weak var arrowView: UIImageView!

	override func viewDidLoad() {
		super.viewDidLoad()
		observeOrientation()
	}

	private func observeOrientation() {
		NotificationCenter.default.addObserver(self, selector: #selector(orientationObserved),
											   name: UIDevice.orientationDidChangeNotification, object: nil)
	}

	@objc private func orientationObserved() {
		let orientation = UIDevice.current.orientation

		switch orientation {
			case .portrait, .unknown, .portraitUpsideDown, .faceUp, .faceDown, .landscapeRight:
				swipeUpLabel.text = "Swipe up to share"
				arrowView.transform = .identity
			case .landscapeLeft:
				swipeUpLabel.text = "Swipe left to share"
				arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
			@unknown default:
				swipeUpLabel.text = "Swipe up to share"
				arrowView.transform = .identity
		}
	}


}

