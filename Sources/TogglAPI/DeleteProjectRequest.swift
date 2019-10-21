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

public enum DeleteProjectResult {
    case success
    case failure(TogglError)
}

private let DeleteProjectPathBase = "/projects/%@"

internal class DeleteProjectRequest: NetworkRequest<[Int], DeleteProjectResult> {
    private let workspaceId: Int
    private let projectId: Int
    internal init(workspaceId: Int, projectId: Int) {
        self.workspaceId = workspaceId
        self.projectId = projectId
    }
    
    override func performRequest() {
        let path = String(format: DeleteProjectPathBase, NSNumber(value: projectId))
        
        DELETE(path)
    }
    
    override func handle(result: NetworkResult<[Int]>) {
        if let deleted = result.value?.first, deleted == projectId {
            self.result = .success
        } else {
            self.result = .failure(result.error ?? .unknown)
        }
    }
    
    override func token() -> String {
        return tokenStore.tokenFor(workspace: workspaceId)
    }
}
