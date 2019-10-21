/*
 * Copyright 2017 Coodly LLC
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

internal struct MyDetailsResponse: Codable {
    let data: MyDetails
}

private let MyDetailsPath = "/me"

public enum LoginResult {
    case success(MyDetails)
    case failure(TogglError)
}

internal class MyDetailsRequest: NetworkRequest<MyDetailsResponse, LoginResult> {
    private let username: String
    private let password: String
    internal init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    override func performRequest() {
        GET(MyDetailsPath)
    }
    
    override func handle(result: NetworkResult<MyDetailsResponse>) {
        if let details = result.value?.data {
            self.result = .success(details)
        } else {
            self.result = .failure(result.error ?? .unknown)
        }
    }
    
    override func credentials() -> String {
        return "\(username):\(password)"
    }
}
