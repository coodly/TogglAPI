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

public enum CreateProjectResult {
    case success(Project)
    case failure(TogglError)
}

private let CreateProjectPath = "/projects"

internal class CreateProjectRequest: NetworkRequest<CreateProjectResponse, CreateProjectResult> {
    private let workspaceId: Int
    private let name: String
    internal init(workspaceId: Int, name: String) {
        self.workspaceId = workspaceId
        self.name = name
    }
    
    override func performRequest() {
        let projectData = ProjectCreateData(name: name, wid: workspaceId)
        let body = CreateProjectBody(project: projectData)
        
        POST(CreateProjectPath, body: body)
    }
    
    override func handle(result: NetworkResult<CreateProjectResponse>) {
        if let project = result.value?.data {
            self.result = .success(project)
        } else {
            self.result = .failure(result.error ?? .unknown)
        }
    }
    
    override func token() -> String {
        return tokenStore.tokenFor(workspace: workspaceId)
    }
}

private struct CreateProjectBody: Encodable {
    let project: ProjectCreateData
}

private struct ProjectCreateData: Encodable {
    let name: String
    let wid: Int
}

internal struct CreateProjectResponse: Codable {
    let data: Project
}
