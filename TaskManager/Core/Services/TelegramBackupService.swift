import Foundation

enum TelegramBackupService {
    enum Key {
        static let botToken = "telegram_bot_token"
        static let chatId = "telegram_chat_id"
        static let enabled = "telegram_backup_enabled"
    }

    enum Failure: LocalizedError {
        case missingCredentials
        case invalidResponse
        case apiError(String)

        var errorDescription: String? {
            switch self {
            case .missingCredentials:
                return "Не настроены токен бота и chat ID."
            case .invalidResponse:
                return "Некорректный ответ от Telegram API."
            case .apiError(let message):
                return "Ошибка Telegram API: \(message)"
            }
        }
    }

    // MARK: - Credentials

    static var botToken: String? {
        get { KeychainHelper.load(key: Key.botToken) }
        set {
            if let value = newValue, !value.isEmpty {
                KeychainHelper.save(value, key: Key.botToken)
            } else {
                KeychainHelper.delete(key: Key.botToken)
            }
        }
    }

    static var chatId: String? {
        get { KeychainHelper.load(key: Key.chatId) }
        set {
            if let value = newValue, !value.isEmpty {
                KeychainHelper.save(value, key: Key.chatId)
            } else {
                KeychainHelper.delete(key: Key.chatId)
            }
        }
    }

    static var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: Key.enabled) }
        set { UserDefaults.standard.set(newValue, forKey: Key.enabled) }
    }

    static var isConfigured: Bool {
        guard let token = botToken, !token.isEmpty else { return false }
        guard let chat = chatId, !chat.isEmpty else { return false }
        return true
    }

    // MARK: - Send

    static func sendBackup(data: Data, filename: String, caption: String?) async throws {
        guard let token = botToken, !token.isEmpty,
              let chat = chatId, !chat.isEmpty else {
            throw Failure.missingCredentials
        }

        let urlString = "https://api.telegram.org/bot\(token)/sendDocument"
        guard let url = URL(string: urlString) else {
            throw Failure.invalidResponse
        }

        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        body.appendField(boundary: boundary, name: "chat_id", value: chat)
        if let caption = caption, !caption.isEmpty {
            body.appendField(boundary: boundary, name: "caption", value: caption)
        }
        body.appendFile(
            boundary: boundary,
            name: "document",
            filename: filename,
            mimeType: "application/json",
            fileData: data
        )
        body.append("--\(boundary)--\r\n".data(using: .utf8) ?? Data())

        let (respData, response) = try await URLSession.shared.upload(for: request, from: body)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw Failure.invalidResponse
        }

        if httpResponse.statusCode != 200 {
            if let json = try? JSONSerialization.jsonObject(with: respData) as? [String: Any],
               let desc = json["description"] as? String {
                throw Failure.apiError(desc)
            }
            throw Failure.apiError("HTTP \(httpResponse.statusCode)")
        }
    }

    // MARK: - Test

    static func testConnection() async throws {
        guard let token = botToken, !token.isEmpty,
              let chat = chatId, !chat.isEmpty else {
            throw Failure.missingCredentials
        }

        let urlString = "https://api.telegram.org/bot\(token)/sendMessage"
        guard let url = URL(string: urlString) else {
            throw Failure.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any] = [
            "chat_id": chat,
            "text": "✅ Task Manager: бэкап подключён. Сюда будут приходить JSON-файлы с вашими данными."
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)

        let (respData, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw Failure.invalidResponse
        }

        if httpResponse.statusCode != 200 {
            if let json = try? JSONSerialization.jsonObject(with: respData) as? [String: Any],
               let desc = json["description"] as? String {
                throw Failure.apiError(desc)
            }
            throw Failure.apiError("HTTP \(httpResponse.statusCode)")
        }
    }
}

private extension Data {
    mutating func appendField(boundary: String, name: String, value: String) {
        append("--\(boundary)\r\n".data(using: .utf8) ?? Data())
        append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8) ?? Data())
        append("\(value)\r\n".data(using: .utf8) ?? Data())
    }

    mutating func appendFile(boundary: String, name: String, filename: String, mimeType: String, fileData: Data) {
        append("--\(boundary)\r\n".data(using: .utf8) ?? Data())
        append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n".data(using: .utf8) ?? Data())
        append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8) ?? Data())
        append(fileData)
        append("\r\n".data(using: .utf8) ?? Data())
    }
}
