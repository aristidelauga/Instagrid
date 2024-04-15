//
//  ViewController.swift
//  InstagridViewController
//
//  Created by Aristide LAUGA on 02/12/2023.
//

import UIKit

final class InstagridViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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

	var selectedTag: Int?

	override func viewDidLoad() {
		super.viewDidLoad()
		observeOrientation()
		setupTags()
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

	@IBAction private func setBackgroundImage(_ sender: UIButton) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .photoLibrary
		imagePickerController.allowsEditing = true
		imagePickerController.delegate = self
		present(imagePickerController, animated: true, completion: nil)
		self.selectedTag = sender.tag
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

	private func setupTags() {
		topLeadingButton.tag = 1
		topTrailingButton.tag = 2
		bottomLeadingButton.tag = 3
		bottomTrailingButton.tag = 4
	}

	internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

		guard let image = info[.editedImage] as? UIImage else {
			print("No image found")
			return
		}

		if let selectedTag = selectedTag, let buttonToUpdate = view.viewWithTag(selectedTag) as? UIButton {
			buttonToUpdate.setImage(image, for: .normal)
			buttonToUpdate.clipsToBounds = true
			buttonToUpdate.imageView?.contentMode = .scaleAspectFit
		}

		picker.dismiss(animated: true)
	}

}

