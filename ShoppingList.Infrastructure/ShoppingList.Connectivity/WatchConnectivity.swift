import WatchConnectivity

public final class WatchConnectivity: NSObject {
    private let session: WCSession

    public override init() {
        self.session = WCSession.default

        super.init()

        guard WCSession.isSupported() else {
            return
        }

        self.session.delegate = self
        self.session.activate()
    }

    public func sendDictionary(_ dictionary: [String: Any]) {
        guard session.activationState == .activated, session.isWatchAppInstalled else {
            return
        }

        do {
            try session.updateApplicationContext(dictionary)
        } catch {
            print("@$", Date(), self, #function, error)
        }
    }
}

extension WatchConnectivity: WCSessionDelegate {
    public func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}

    public func sessionDidBecomeInactive(_ session: WCSession) {}

    public func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
}
