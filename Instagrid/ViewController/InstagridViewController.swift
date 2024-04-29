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
	private var swipeGesture = UISwipeGestureRecognizer(target: InstagridViewController.self, action: #selector(handleSwipe))

	override func viewDidLoad() {
		super.viewDidLoad()
		observeOrientation()
		setImageViewForDisplayButtons()
		setImageViewForFrameStackView()
		setSelectedImage(fourFrameButton)

	}

	// MARK: @Objc methods

	@objc private func handleSwipe(_ sender: UISwipeGestureRecognizer? = nil) {

//		guard let image = combineButtonImages(frameStackView) else {
//			return
//		}

		let renderer = UIGraphicsImageRenderer(bounds: frameStackView.bounds)
		frameStackView.clipsToBounds = true
		let image = renderer.image { context in
			frameStackView.layer.render(in: context.cgContext)
		}
		let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		print(image ?? "pas de frame")

		present(ac, animated: true)
	}

	// methode update StackView

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

	@objc private func swipeToShare() {
		let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
		let screenHeight = UIScreen.main.bounds.height
		let finalPosition = -screenHeight - 10
		if UIDevice.current.orientation == .landscapeLeft {
			swipeGesture.direction = .left
			//			self.SwipeStackView.frame.origin.y = finalPosition
			UIStackView.animate(withDuration: 0.5) {
				self.SwipeStackView.frame.origin.y = finalPosition
			}
		} else {
			swipeGesture.direction = .up
			self.SwipeStackView.frame.origin.y = finalPosition
			UIStackView.animate(withDuration: 0.5) {
				self.SwipeStackView.frame.origin.y = finalPosition
			}
		}
		frameStackView.isUserInteractionEnabled = true
		frameStackView.addGestureRecognizer(swipeGesture)
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

	private func combineButtonImages(_ view: UIView) -> UIImage? {
//		UIGraphicsBeginImageContextWithOptions(frameStackImageView.frame.size, false, 0.0)
//		frameStackView.drawHierarchy(in: frameStackImageView.bounds, afterScreenUpdates: true)
//		let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
//		UIGraphicsEndImageContext()
//		return capturedImage
		let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
		view.clipsToBounds = true
		let image = renderer.image { context in
			view.layer.render(in: context.cgContext)
		}

		return image
//
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
		NotificationCenter.default.addObserver(self, selector: #selector(swipeToShare),
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

