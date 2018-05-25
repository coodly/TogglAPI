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

public class WorkspaceClient: Injector {
    private let workspaceId: Int
    internal init(workspaceId: Int) {
        self.workspaceId = workspaceId
    }
    
    public func load(completion: @escaping ((WorkspaceDetailsResult) -> Void)) {
        let request = WorkspaceDetailsRequest(workspaceId: workspaceId)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
        
    public func listProjects(including: Included = .onlyActive, completion: @escaping ((ListProjectsResult) -> Void)) {
        let request = ListProjectsRequest(workspaceId: workspaceId, including: including)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }

    public func listTasks(including: Included = .onlyActive, completion: @escaping ((ListTasksResult) -> Void)) {
        let request = ListTasksRequest(workspaceId: workspaceId, including: including)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
    
    public func createProject(details: ProjectSendDetails, completion: @escaping ((ProjectDetailsResult) -> Void)) {
        let request = CreateProjectRequest(workspaceId: workspaceId, details: details)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
    
    public func updateProject(id: Int, details: ProjectSendDetails, completion: @escaping ((ProjectDetailsResult) -> Void)) {
        let request = UpdateProjectRequest(id: id, details: details)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
    
    public func deleteProject(_ projectId: Int, completion: @escaping ((DeleteProjectResult) -> Void)) {
        let request = DeleteProjectRequest(workspaceId: workspaceId, projectId: projectId)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
}
