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

	private var topLeadingImageView = UIImageView()
	private var topTrailingImageView = UIImageView()
	private var bottomLeadingImageView = UIImageView()
	private var bottomTrailingImageView = UIImageView()

	private var selectedButton: UIButton?

	override func viewDidLoad() {
		super.viewDidLoad()
		observeOrientation()
		setImageViewForDisplayButtons()
		setImageViewsForFrameStackView()
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
				shareCollage(gesture)
			case .possible, .failed:
				break
			default:
				break
		}
	}

	// MARK: @IBActions

	@IBAction private func onOpenGallery(_ sender: UIButton) {
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.sourceType = .photoLibrary
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
	private func shareCollage(_ gesture: UIPanGestureRecognizer) {
		let translation = gesture.translation(in: frameStackView)
		let threshold: CGFloat = -400.0

		let shouldShare: Bool
		if UIDevice.current.orientation.isLandscape {
			shouldShare = translation.x < threshold
		} else {
			shouldShare = translation.y < threshold
		}

		if shouldShare {
			let renderer = UIGraphicsImageRenderer(bounds: frameStackView.bounds)
			frameStackView.clipsToBounds = true
			let image = renderer.image { context in
				frameStackView.layer.render(in: context.cgContext)
			}

			let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)

			ac.completionWithItemsHandler = { [weak self] _, _, _, _ in
				// Reset frameStackView position and visibility
				UIView.animate(withDuration: 0.4) {
					self?.frameStackView.transform = .identity
					self?.frameStackView.isHidden = false
				}
			}

			// Hide the frameStackView and present the activity view controller
			UIView.animate(withDuration: 0.4) {
				self.frameStackView.isHidden = true
			}

			present(ac, animated: true, completion: nil)
		} else {
			UIView.animate(withDuration: 0.6) {
				self.frameStackView.transform = .identity
			}
		}
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

		guard let image = info[UIImagePickerController.InfoKey.originalImage] else {
			let alertVC = UIAlertController(title: "Error", message: "No image found", preferredStyle: .alert)
			alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self.present(alertVC, animated: true, completion: nil)
			return
		}

		switch selectedButton {
			case topLeadingButton:
				topLeadingButton.setBackgroundImage(nil, for: .normal)
				topLeadingImageView.image = image as? UIImage
			case topTrailingButton:
				topTrailingButton.setBackgroundImage(nil, for: .normal)
				topTrailingImageView.image = image as? UIImage
			case bottomLeadingButton:
				bottomLeadingButton.setBackgroundImage(nil, for: .normal)
				bottomLeadingImageView.image = image as? UIImage
			case bottomTrailingButton:
				bottomTrailingButton.setBackgroundImage(nil, for: .normal)
				bottomTrailingImageView.image = image as? UIImage
			default:
				break
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

	private func setupImageViewConstraints(_ imageView: UIImageView, to button: UIButton) {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: button.topAnchor),
			imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
			imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor)
		])
	}

	private func setImageViewsForFrameStackView() {
		topLeadingButton.addSubview(topLeadingImageView)
		setupImageViewConstraints(topLeadingImageView, to: topLeadingButton)

		topTrailingButton.addSubview(topTrailingImageView)
		setupImageViewConstraints(topTrailingImageView, to: topTrailingButton)

		bottomLeadingButton.addSubview(bottomLeadingImageView)
		setupImageViewConstraints(bottomLeadingImageView, to: bottomLeadingButton)

		bottomTrailingButton.addSubview(bottomTrailingImageView)
		setupImageViewConstraints(bottomTrailingImageView, to: bottomTrailingButton)
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
