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

	@IBOutlet weak var topLeadingButton: UIButton!
	@IBOutlet weak var topTrailingButton: UIButton!
	@IBOutlet weak var bottomLeadingButton: UIButton!
	@IBOutlet weak var bottomTrailingButton: UIButton!
	

	@IBOutlet weak var threeFrameButton: UIButton!
	
	@IBOutlet weak var reversedThreeFrameButton: UIButton!
	
	@IBOutlet weak var fourFrameButton: UIButton!


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


	@IBAction private func didTapThreeFramesButton() {
		displayThreeFrames()
	}
	
	@IBAction private func didTapReversedThreeFramesButton() {
		displayReversedThreeFrames()
	}
	

	@IBAction private func didTapFourFramesButton() {
		displayFourFramesButton()
	}
	
	private func displayThreeFrames() {
		bottomTrailingButton.isHidden = false
		topTrailingButton.isHidden = true
	}

	private func displayReversedThreeFrames() {
		topTrailingButton.isHidden = false
		bottomTrailingButton.isHidden = true
	}

	private func displayFourFramesButton() {
		topTrailingButton.isHidden = false
		bottomTrailingButton.isHidden = false
	}

}

