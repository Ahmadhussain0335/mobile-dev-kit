import Foundation

struct LoginService {
    let session: URLSession
    let store: SessionStore

    func login(email: String, password: String) async throws {
        var request = URLRequest(url: URL(string: "https://auth.example.com/token")!)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(["email": email, "password": password])
        let (data, _) = try await session.data(for: request)
        let tokens = try JSONDecoder().decode(Tokens.self, from: data)
        store.save(accessToken: tokens.access, refreshToken: tokens.refresh)
    }
}

struct Tokens: Decodable {
    let access: String
    let refresh: String
}
