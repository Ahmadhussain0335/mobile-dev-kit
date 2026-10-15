import Foundation

struct AccountService {
    let api: APIClient

    func signUp(email: String, password: String) async throws -> Account {
        try await api.post("/v1/accounts", body: ["email": email, "password": password])
    }

    func signIn(email: String, password: String) async throws -> Session {
        try await api.post("/v1/sessions", body: ["email": email, "password": password])
    }

    func signOut() async throws {
        try await api.delete("/v1/sessions/current")
    }
}
