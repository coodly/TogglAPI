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

public enum ListProjectsResult {
    case success([Project])
    case failure(TogglError)
}

private let ListProjectsBase = "/workspaces/%@/projects"

internal class ListProjectsRequest: NetworkRequest<[Project], ListProjectsResult> {
    private let workspaceId: Int
    internal init(workspaceId: Int) {
        self.workspaceId = workspaceId
    }
    
    override func performRequest() {
        let path = String(format: ListProjectsBase, NSNumber(value: workspaceId))
        GET(path)
    }
    
    override func handle(result: NetworkResult<[Project]>) {
        if let projects = result.value {
            self.result = .success(projects)
        } else {
            self.result = .failure(result.error ?? .unknown)
        }
    }
    
    override func credentials() -> String {
        return tokenStore.tokenFor(workspace: workspaceId) + ":api_token"
    }
}
