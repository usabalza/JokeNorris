//
//  NetworkManager.swift
//  JokeNorris
//
//  Created by Uziel Sabalza on 9/9/26.
//

import SwiftUI

enum NetworkError: Error {
    case invalidURL
    case serializationError
    case invalidResponse
    case decodingError
    case apiLimitReached
}

enum HTTPMethod {
    case get
    case post(body: Encodable?)
    case put(body: Encodable?)
    case delete
    
    // Retorna el string que requiere URLRequest
    var name: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
}

struct NetworkManager {
    
    func request<T:Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil) async throws -> T {
            guard let url = URL(string: endpoint) else {
                throw NetworkError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.name
            
            // Configuración por defecto para JSON
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")

            
            // Inyectar encabezados personalizados si existen (ej. Tokens de autenticación)
            headers?.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
            
            // Configurar el cuerpo según el método HTTP elegido
            switch method {
            case .post(let body), .put(let body):
                if let body = body {
                    do {
                        // Codifica cualquier objeto Encodable a datos binarios JSON
                        request.httpBody = try JSONEncoder().encode(body)
                    } catch {
                        throw NetworkError.serializationError
                    }
                }
            default:
                break
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 429 {
                    print("Demasiadas peticiones. Por favor, intenta de nuevo en un momento.")
                    throw NetworkError.apiLimitReached
                }
                throw NetworkError.invalidResponse
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
            
        }
}
