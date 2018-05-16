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

public enum ProjectsIncluded: String {
    case onlyActive = "true"
    case onlyArchived = "false"
    case all = "both"
}

private let ListProjectsBase = "/workspaces/%@/projects"

internal class ListProjectsRequest: NetworkRequest<[Project], ListProjectsResult> {
    private let workspaceId: Int
    private let including: ProjectsIncluded
    internal init(workspaceId: Int, including: ProjectsIncluded) {
        self.workspaceId = workspaceId
        self.including = including
    }
    
    override func performRequest() {
        let path = String(format: ListProjectsBase, NSNumber(value: workspaceId))
        GET(path, params: ["active": .string(including.rawValue)])
    }
    
    override func handle(result: NetworkResult<[Project]>) {
        if let projects = result.value {
            self.result = .success(projects)
        } else if result.statusCode == 200 {
            self.result = .success([])
        } else {
            self.result = .failure(result.error ?? .unknown)
        }
    }
    
    override func credentials() -> String {
        return tokenStore.tokenFor(workspace: workspaceId) + ":api_token"
    }
}
