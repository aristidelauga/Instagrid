//
//  ViewController.swift
//  InstagridViewController
//
//  Created by Aristide LAUGA on 02/12/2023.
//

import UIKit

final class InstagridViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

	// MARK: IBOutlets

	@IBOutlet private weak var swipeUpLabel: UILabel!
	@IBOutlet private weak var arrowView: UIImageView!

	@IBOutlet weak var topLeadingButton: UIButton!
	@IBOutlet weak var topTrailingButton: UIButton!
	@IBOutlet weak var bottomLeadingButton: UIButton!
	@IBOutlet weak var bottomTrailingButton: UIButton!


	@IBOutlet weak var threeFrameButton: UIButton!
	@IBOutlet weak var reversedThreeFrameButton: UIButton!
	@IBOutlet weak var fourFrameButton: UIButton!

	@IBOutlet weak var SwipeStackView: UIStackView!

	@IBOutlet weak var frameStackView: UIStackView!

	private var threeFrameImageView = UIImageView()
	private var reversedThreeFrameImageView = UIImageView()
	private var fourFrameImageView = UIImageView()
	private var frameStackImageView = UIImageView()

	private var selectedButton: UIButton?

	override func viewDidLoad() {
		super.viewDidLoad()
		observeOrientation()
		setImageViewForDisplayButtons()
		setImageViewForFrameStackView()
		setSelectedImage(fourFrameButton)
		swipeToShare()
	}

	// MARK: @Objc methods

	@objc func handleSwipe(_ sender: UITapGestureRecognizer? = nil) {
		let image = [frameStackImageView.image]
		let ac = UIActivityViewController(activityItems: image, applicationActivities: nil)
		frameStackView.isUserInteractionEnabled = true
		present(ac, animated: true)
	}

	@objc private func orientationObserved() {
		let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
		let orientation = UIDevice.current.orientation
		switch orientation {
			case .portrait, .unknown, .portraitUpsideDown, .faceUp, .faceDown, .landscapeRight:
				swipeUpLabel.text = "Swipe up to share"
				arrowView.transform = .identity
				swipeGesture.direction = .up
			case .landscapeLeft:
				swipeUpLabel.text = "Swipe left to share"
				arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
				swipeGesture.direction = .left
			@unknown default:
				swipeUpLabel.text = "Swipe up to share"
				arrowView.transform = .identity
				swipeGesture.direction = .up
		}
	}

	// MARK: @IBActions

	@IBAction private func onOpenGallery(_ sender: UIButton) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.sourceType = .photoLibrary
		imagePickerController.allowsEditing = true
		imagePickerController.delegate = self
		present(imagePickerController, animated: true, completion: nil)
		self.selectedButton = sender
	}

	@IBAction private func didTapThreeFramesButton(_ sender: UIButton) {
		displayThreeFrames()
		setSelectedImage(sender)
	}

	@IBAction private func didTapReversedThreeFramesButton(_ sender: UIButton) {
		displayReversedThreeFrames()
		setSelectedImage(sender)
	}

	@IBAction private func didTapFourFramesButton(_ sender: UIButton) {
		displayFourFramesButton()
		setSelectedImage(sender)
	}

	// MARK: other methods

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


	private func swipeToShare() {
		let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
		swipeGesture.direction = .up
		frameStackView.addGestureRecognizer(swipeGesture)
	}

	internal func imagePickerController(_ picker: UIImagePickerController,
										didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

		guard let image = info[.editedImage] as? UIImage else {
			print("No image found")
			return
		}

		if let buttonToUpdate = selectedButton {
			let buttonSize = buttonToUpdate.frame.size
			buttonToUpdate.imageView?.frame.size = buttonSize
			buttonToUpdate.clipsToBounds = true
			buttonToUpdate.imageView?.contentMode = .scaleAspectFit
			buttonToUpdate.setImage(image, for: .normal)
		}

		picker.dismiss(animated: true)
	}

	private func observeOrientation() {
		NotificationCenter.default.addObserver(self, selector: #selector(orientationObserved),
											   name: UIDevice.orientationDidChangeNotification, object: nil)
	}

	private func setImageViewForDisplayButtons() {

		threeFrameImageView.frame = threeFrameButton.bounds
		reversedThreeFrameImageView.frame = threeFrameButton.bounds
		fourFrameImageView.frame = threeFrameButton.bounds

		threeFrameImageView.image = nil
		reversedThreeFrameImageView.image = nil
		fourFrameImageView.image = nil

		threeFrameButton.addSubview(threeFrameImageView)
		reversedThreeFrameButton.addSubview(reversedThreeFrameImageView)
		fourFrameButton.addSubview(fourFrameImageView)

	}

	private func setImageViewForFrameStackView() {
		frameStackImageView.frame = frameStackView.bounds
		frameStackImageView.image = nil
		frameStackView.addSubview(frameStackImageView)
	}

	private func setSelectedImage(_ sender: UIButton) {

		if sender === threeFrameButton {
			threeFrameImageView.image = UIImage(named: "Selected")
			reversedThreeFrameImageView.image = nil
			fourFrameImageView.image = nil
		}

		if sender === reversedThreeFrameButton {
			reversedThreeFrameImageView.image = UIImage(named: "Selected")
			threeFrameImageView.image = nil
			fourFrameImageView.image = nil
		}

		if sender === fourFrameButton {
			fourFrameImageView.image = UIImage(named: "Selected")
			threeFrameImageView.image = nil
			reversedThreeFrameImageView.image = nil
		}
	}
}

