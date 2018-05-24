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

public enum ListWorkspacesResult {
    case success([Workspace])
    case failure(TogglError)
}

private let ListWorkspacesPath = "/workspaces"

internal class ListWorkspacesRequest: NetworkRequest<[Workspace], ListWorkspacesResult> {
    private let userId: Int
    internal init(userId: Int) {
        self.userId = userId
    }
    
    override func performRequest() {
        GET(ListWorkspacesPath)
    }
    
    override func handle(result: NetworkResult<[Workspace]>) {
        if let workspaces = result.value {
            self.result = .success(workspaces)
        } else if result.statusCode == 200 {
            self.result = .success([])
        } else {
            self.result = .failure(result.error ?? .unknown)
        }
    }
    
    override func token() -> String {
        return tokenStore.tokenFor(user: userId)
    }
}
