/*
 * Copyright 2018 Coodly LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

internal enum Method: String {
    case POST
    case GET
    case PUT
    case DELETE
}

public enum TogglError: Error {
    case noData
    case network(Error)
    case server(String)
    case invalidCredentials
    case invalidJSON
    case unknown
}

internal struct NetworkResult<T: Codable> {
    var value: T?
    let statusCode: Int
    let error: TogglError?
}

public enum ParameterValue {
    case string(String)
    case date(Date)
}

private extension DateFormatter {
    static let paramDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}

internal struct EmptyBody: Encodable {
    
}

private let ServerAPIV8URLString = "https://api.track.toggl.com"

private typealias Dependencies = FetchConsumer & TokenConsumer

internal class NetworkRequest<Model: Codable, Result>: Dependencies {
    var fetch: NetworkFetch!
    var apiKey: String!
    var accessToken: String!
    
    var tokenStore: TokenStore!
    
    internal var result: Result? {
        didSet {
            guard let value = result else {
                return
            }
            
            resultHandler?(value)
        }
    }
    internal var resultHandler: ((Result) -> Void)?
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()
    private lazy var dateFormatter = ISO8601DateFormatter()
    
    private let baseURL: URL
    internal init(baseURL: URL = URL(string: ServerAPIV8URLString)!, basePath: String = "api/v8") {
        self.baseURL = baseURL.appendingPathComponent(basePath)
    }
    
    final func execute() {
        performRequest()
    }
    
    func GET(_ path: String, params: [String: ParameterValue]? = nil) {
        executeMethod(.GET, path: path, body: nil, params: params)
    }
    
    func POST<Body: Encodable>(_ path: String, body: Body) {
        executeWithBody(.POST, path: path, body: body)
    }
    
    func PUT<Body: Encodable>(_ path: String, body: Body? = nil) {
        executeWithBody(.PUT, path: path, body: body)
    }
    
    func DELETE(_ path: String) {
        executeMethod(.DELETE, path: path, body: nil)
    }
    
    private func executeWithBody<Body: Encodable>(_ method: Method, path: String, body: Body?, params: [String: ParameterValue]? = nil) {
        var dataSent: Data? = nil
        defer {
            executeMethod(method, path: path, body: dataSent, params: params)
        }
        
        guard let sentBody = body else {
            return
        }
        
        if sentBody is EmptyBody {
            return
        }
        
        do {
            dataSent = try encoder.encode(sentBody)
        } catch {
            Logging.log("Encode error: \(error)")
        }
    }
    
    internal func executeMethod(_ method: Method, path: String, body: Data?, params: [String: ParameterValue]? = nil) {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        components.path = components.path + path
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in params ?? [:] {
            let encoded: String
            switch value {
            case .string(let wrapped):
                encoded = wrapped
            case .date(let date):
                encoded = dateFormatter.string(from: date)
            }
            queryItems.append(URLQueryItem(name: key, value: encoded))
        }
        queryItems.append(URLQueryItem(name: "user_agent", value: Injection.sharedInstance.userAgent))
        
        components.queryItems = queryItems
        
        let requestURL = components.url!
        let request = NSMutableURLRequest(url: requestURL)
        request.httpShouldHandleCookies = false
        
        request.httpMethod = method.rawValue
        
        Logging.log("\(method) to \(requestURL.absoluteString)")
        
        if let base64 = credentials().data(using: .utf8)?.base64EncodedString() {
            request.addValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let jsonData = body {
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            if let string = String(data: jsonData, encoding: .utf8) {
                Logging.log("Body\n\(string)")
            }
        }
        
        fetch.fetch(request: request as URLRequest) {
            data, response, networkError in
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            Logging.log("Status code: \(statusCode)")
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                Logging.log("Response:\n\(string)")
            }
            
            var value: Model?
            var togglError: TogglError?
            
            defer {
                self.handle(result: NetworkResult(value: value, statusCode: statusCode, error: togglError))
            }
            
            if let remoteError = networkError  {
                togglError = .network(remoteError)
                return
            }
            
            if statusCode == 403 {
                togglError = .invalidCredentials
                return
            }
            
            if statusCode == 200, data == nil {
                togglError = .noData
                return
            }
            
            guard let data = data else {
                togglError = .noData
                return
            }
            
            do {
                value = try self.modify(decoder: self.decoder).decode(Model.self, from: data)
            } catch {
                togglError = .invalidJSON
            }
        }
    }
    
    internal func handle(result: NetworkResult<Model>) {
        Logging.log("Handle \(result)")
    }
    
    internal func performRequest() {
        fatalError("Override \(#function)")
    }
    
    internal func credentials() -> String {
        return token() + ":api_token"
    }
    
    internal func token() -> String {
        return ""
    }
    
    internal func modify(decoder: JSONDecoder) -> JSONDecoder {
        decoder
    }
}
