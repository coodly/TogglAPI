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

extension CodingUserInfoKey {
    internal static let reportPage = CodingUserInfoKey(rawValue: "report.page")!
}

public struct TimeEntriesReportPage: Codable {
    enum CodingKeys: String, CodingKey {
        case entries = "data"
        case totalCount
        case perPage
        case currentPage
    }
    
    public let entries: [TimeEntryReport]
    let totalCount: Int
    let perPage: Int
    let currentPage: Int
    
    public var hasMore: Bool {
        let loaded = currentPage * perPage
        return totalCount > loaded
    }
    public var nextPage: Int {
        currentPage + 1
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        entries = try values.decode([TimeEntryReport].self, forKey: .entries)
        totalCount = try values.decode(Int.self, forKey: .totalCount)
        perPage = try values.decode(Int.self, forKey: .perPage)
        currentPage = decoder.userInfo[.reportPage] as! Int
    }
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

public enum TimeEntriesOrder {
    case asc
    case desc
}

public class ReportsClient: Injector {
    private static let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .utility
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private let workspaceId: Int
    internal init(workspaceId: Int) {
        self.workspaceId = workspaceId
    }
    
    public func loadEntries(for projectId: Int, in range: DateInterval, page: Int = 1, order: TimeEntriesOrder = .desc, completion: @escaping ((Result<TimeEntriesReportPage, Error>) -> Void)) {
        loadEntries(for: [projectId], in: range, page: page, order: order, completion: completion)
    }

    public func loadEntries(in range: DateInterval, page: Int = 1, order: TimeEntriesOrder = .desc, completion: @escaping ((Result<TimeEntriesReportPage, Error>) -> Void)) {
        loadEntries(for: [], in: range, page: page, order: order, completion: completion)
    }

    public func loadEntries(for projectsIds: [Int], in range: DateInterval, page: Int = 1, order: TimeEntriesOrder = .desc, completion: @escaping ((Result<TimeEntriesReportPage, Error>) -> Void)) {
        let request = TimeEntriesReportPageRequest(workspace: workspaceId, projectIds: projectsIds, range: range, page: page, order: order)
        inject(into: request)
        request.resultHandler = completion
        execute(request)
    }

    private func execute<Model: Codable, Result>(_ request: NetworkRequest<Model, Result>) {
        let run = ExecuteRequestOperation(request: request)
        let delay = DelayOperation()
        delay.addDependency(run)
        
        ReportsClient.queue.addOperations([run, delay], waitUntilFinished: false)
    }
}

extension TimeEntriesReportPage {
    public func reportsAsEntries(in workspace: Int) -> [TimeEntry] {
        return entries.map() {
            report in
            
            return TimeEntry(id: report.id, wid: workspace, pid: report.pid, tid: report.tid, start: report.start, stop: report.end, description: report.description, tags: report.tags, at: report.updated)
        }
    }
}


private class ExecuteRequestOperation<Model: Codable, Result>: ConcurrentOperation {
    private let request: NetworkRequest<Model, Result>
    internal init(request: NetworkRequest<Model, Result>) {
        self.request = request
    }
    
    override func main() {
        let original = request.resultHandler
        request.resultHandler = {
            [weak self]
            
            result in
            
            original?(result)
            self?.finish()
        }
        request.execute()
    }
}

private class DelayOperation: ConcurrentOperation {
    override func main() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.finish()
        }
    }
}
