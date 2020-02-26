/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Utility class for showing messages above the AR view.
*/

/*
import Foundation

class StatusViewController: UIViewController {

    enum MessageType {
        case trackingStateEscalation
        case contentPlacement

        static var all: [MessageType] = [
            .trackingStateEscalation,
            .contentPlacement
        ]
    }

    // MARK: - IBOutlets

    private lazy var messagePanel: UIVisualEffectView! = {
        let messagePanel = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        messagePanel.translatesAutoresizingMaskIntoConstraints = false
        return messagePanel
    }()
    
    private lazy var messageLabel: UILabel! = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        return messageLabel
    }()
    
    private lazy var restartExperienceButton: UIButton! = {
        let label = UIButton(type: .custom)
        label.setImage(#imageLiteral(resourceName: "restart"), for: .normal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Properties
    
    /// Trigerred when the "Restart Experience" button is tapped.
    var restartExperienceHandler: () -> Void = {}
    
    /// Seconds before the timer message should fade out. Adjust if the app needs longer transient messages.
    private let displayDuration: TimeInterval = 6
    
    // Timer for hiding messages.
    private var messageHideTimer: Timer?
    
    private var timers: [MessageType: Timer] = [:]
    
    
    func setupView() {
        view.addSubview(restartExperienceButton)
        restartExperienceButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        restartExperienceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        restartExperienceButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        restartExperienceButton.heightAnchor.constraint(equalToConstant: 59)
        view.addSubview(messagePanel)
        messagePanel.topAnchor.constraint(equalTo: restartExperienceButton.topAnchor).isActive = true
        messagePanel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        restartExperienceButton.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: messagePanel.trailingAnchor, multiplier: 1).isActive = true
        messagePanel.heightAnchor.constraint(equalToConstant: 59).isActive = true
        messagePanel.contentView.addSubview(messageLabel)
        messageLabel.leadingAnchor.constraint(equalTo: messagePanel.contentView.leadingAnchor, constant: 18).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: messagePanel.contentView.trailingAnchor, constant: -18).isActive = true
        messageLabel.centerYAnchor.constraint(equalTo: messagePanel.contentView.centerYAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        restartExperienceButton.addTarget(self, action: #selector(restartExperience(_:)), for: .touchUpInside)
    }
    
    // MARK: - Message Handling
	
	func showMessage(_ text: String, autoHide: Bool = true) {
        // Cancel any previous hide timer.
        messageHideTimer?.invalidate()

        messageLabel.text = text

        // Make sure status is showing.
        setMessageHidden(false, animated: true)

        if autoHide {
            messageHideTimer = Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false, block: { [weak self] _ in
                self?.setMessageHidden(true, animated: true)
            })
        }
	}
    
	func scheduleMessage(_ text: String, inSeconds seconds: TimeInterval, messageType: MessageType) {
        cancelScheduledMessage(for: messageType)

        let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [weak self] timer in
            self?.showMessage(text)
            timer.invalidate()
		})

        timers[messageType] = timer
	}
    
    func cancelScheduledMessage(for messageType: MessageType) {
        timers[messageType]?.invalidate()
        timers[messageType] = nil
    }

    func cancelAllScheduledMessages() {
        for messageType in MessageType.all {
            cancelScheduledMessage(for: messageType)
        }
    }
    
    // MARK: - ARKit
    
	func showTrackingQualityInfo(for trackingState: ARCamera.TrackingState, autoHide: Bool) {
		showMessage(trackingState.presentationString, autoHide: autoHide)
	}
	
	func escalateFeedback(for trackingState: ARCamera.TrackingState, inSeconds seconds: TimeInterval) {
        cancelScheduledMessage(for: .trackingStateEscalation)

		let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [unowned self] _ in
            self.cancelScheduledMessage(for: .trackingStateEscalation)

            var message = trackingState.presentationString
            if let recommendation = trackingState.recommendation {
                message.append(": \(recommendation)")
            }

            self.showMessage(message, autoHide: false)
		})

        timers[.trackingStateEscalation] = timer
    }
    
    // MARK: - IBActions
    
    @objc func restartExperience(_ sender: UIButton) {
        restartExperienceHandler()
    }
	
	// MARK: - Panel Visibility
    
	private func setMessageHidden(_ hide: Bool, animated: Bool) {
        // The panel starts out hidden, so show it before animating opacity.
        messagePanel.isHidden = false
        
        guard animated else {
            messagePanel.alpha = hide ? 0 : 1
            return
        }

        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
            self.messagePanel.alpha = hide ? 0 : 1
        }, completion: nil)
	}
}

extension ARCamera.TrackingState {
    var presentationString: String {
        switch self {
        case .notAvailable:
            return "TRACKING UNAVAILABLE"
        case .normal:
            return "TRACKING NORMAL"
        case .limited(.excessiveMotion):
            return "TRACKING LIMITED\nExcessive motion"
        case .limited(.insufficientFeatures):
            return "TRACKING LIMITED\nLow detail"
        case .limited(.initializing):
            return "Initializing"
        case .limited(.relocalizing):
            return "Recovering from session interruption"
        case .limited(_):
            return ""
        }
    }

    var recommendation: String? {
        switch self {
        case .limited(.excessiveMotion):
            return "Try slowing down your movement, or reset the session."
        case .limited(.insufficientFeatures):
            return "Try pointing at a flat surface, or reset the session."
        case .limited(.relocalizing):
            return "Try returning to where you were when the interruption began, or reset the session."
        default:
            return nil
        }
    }
}
**/
