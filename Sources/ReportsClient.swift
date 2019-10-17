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

public struct TimeEntriesReportPage: Codable {
    enum CodingKeys: String, CodingKey {
        case entries = "data"
        case totalCount
        case perPage
    }
    
    public let entries: [TimeEntryReport]
    let totalCount: Int
    let perPage: Int
}

public struct TimeEntryReport: Codable {
    public let id: Int
    public let pid: Int
    public let tid: Int?
    public let start: Date
    public let end: Date?
    public let description: String?
    public let tags: [String]?
    public let updated: Date
}

public class ReportsClient: Injector {
    private let workspaceId: Int
    internal init(workspaceId: Int) {
        self.workspaceId = workspaceId
    }
    
    public func loadEntries(for projectId: Int, in range: DateInterval, completion: @escaping ((Result<TimeEntriesReportPage, Error>) -> Void)) {
        let request = TimeEntriesReportPageRequest(workspace: workspaceId, project: projectId, range: range)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
}
