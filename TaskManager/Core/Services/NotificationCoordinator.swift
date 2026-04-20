import Foundation
import Observation
import UserNotifications

struct StudyQuestionPreview: Identifiable, Hashable {
    let id = UUID()
    let question: String
    let answer: String
    let context: String
    let examples: String?
}

@Observable
final class NotificationCoordinator: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationCoordinator()

    var pendingStudyQuestion: StudyQuestionPreview?

    override private init() {
        super.init()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .list])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let content = response.notification.request.content
        let userInfo = content.userInfo

        if (userInfo["type"] as? String) == "study_question" {
            let preview = StudyQuestionPreview(
                question: (userInfo["studyQuestionText"] as? String) ?? content.title,
                answer: (userInfo["studyAnswer"] as? String) ?? content.body,
                context: (userInfo["studyContext"] as? String) ?? content.subtitle,
                examples: userInfo["studyExamples"] as? String
            )
            DispatchQueue.main.async {
                self.pendingStudyQuestion = preview
            }
        }

        completionHandler()
    }
}
