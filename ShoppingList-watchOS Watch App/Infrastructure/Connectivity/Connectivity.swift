import Combine
import WatchConnectivity

final class Connectivity: NSObject, WCSessionDelegate {
    var publisher: AnyPublisher<[String: Any], Never> {
        publisherSubject.eraseToAnyPublisher()
    }

    private let publisherSubject: PassthroughSubject<[String: Any], Never> = .init()

    func initialize() {
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func session(
        _ session: WCSession,
        didReceiveApplicationContext applicationContext: [String: Any]
    ) {
        publisherSubject.send(applicationContext)
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any]) {
        publisherSubject.send(userInfo)
    }

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {}
}
