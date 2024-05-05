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
		addGestureRecognizer()
	}

	// MARK: @Objc methods

	// Observes and updates the SwipeStackView according to device's orientation
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

	// Observes and updates the gesture to trigger the right method
	@objc private func observeSwipe(_ gesture: UIPanGestureRecognizer) {
		switch gesture.state {
			case .began, .changed:
				swipeToShare(gesture: gesture)
			case .ended, .cancelled:
				sharingImage(gesture)
			default:
				break
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

	private func addGestureRecognizer() {
		var swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(observeSwipe(_:)))
		frameStackView.addGestureRecognizer(swipeGesture)
	}


	// Allows the frameStackView to follow the finger's movement on screen
	private func swipeToShare(gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: frameStackView)
		if UIDevice.current.orientation.isLandscape {
			frameStackView.transform = CGAffineTransform(translationX: translation.x, y: 0)
		} else {
			frameStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
		}
	}

	// The very action of sharing an image via the UIActivityViewController
	private func sharingImage(_ gesture: UIPanGestureRecognizer) {
		if (gesture.translation(in: frameStackView).y < 0 || gesture.translation(in: frameStackView).x < 0) {
			let renderer = UIGraphicsImageRenderer(bounds: frameStackView.bounds)
			frameStackView.clipsToBounds = true
			let image = renderer.image { context in
				frameStackView.layer.render(in: context.cgContext)
			}

			let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
			print(image.size)

			present(ac, animated: true)

			UIView.animate(withDuration: 0.4) {
				self.frameStackView.transform = CGAffineTransformIdentity
			}
		}
	}

	private func combineButtonImages(_ view: UIView) -> UIImage? {
		let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
		view.clipsToBounds = true
		let image = renderer.image { context in
			view.layer.render(in: context.cgContext)
		}
		return image
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
											   name: UIDevice.orientationDidChangeNotification,
											   object: nil)
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
		frameStackImageView.clipsToBounds = true
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

