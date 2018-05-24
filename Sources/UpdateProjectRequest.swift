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

public enum ProjectDetailsResult {
    case success(Project)
    case failure(TogglError)
}


private let UpdateProjectPathBase = "/projects/%@"

internal class UpdateProjectRequest: NetworkRequest<ProjectDetailsResponse, ProjectDetailsResult> {
    private let id: Int
    private let details: ProjectSendDetails
    internal init(id: Int, details: ProjectSendDetails) {
        self.id = id
        self.details = details
    }
    
    override func performRequest() {
        let path = String(format: UpdateProjectPathBase, NSNumber(value: id))
        let body = ProjectSendBody(project: details)
        PUT(path, body: body)
    }
    
    override func handle(result: NetworkResult<ProjectDetailsResponse>) {
        if let project = result.value?.data {
            self.result = .success(project)
        } else {
            self.result = .failure(result.error ?? .unknown)
        }
    }
    
    override func token() -> String {
        return tokenStore.tokenFor(workspace: details.wid)
    }
}

internal struct ProjectDetailsResponse: Codable {
    let data: Project
}
