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

public class TimeEntriesClient: Injector {
    private let userId: Int
    internal init(userId: Int) {
        self.userId = userId
    }
    
    public func loadEntries(in range: DateInterval, completion: @escaping ((ListEntriesResult) -> Void)) {
        Logging.log("Load entries in \(range)")
        
        let request = LoadTimeEntriesRequest(userId: userId, range: range)
        request.resultHandler = completion
        inject(into: request)
        request.execute()
    }
    
    public func start(entry: TimeEntrySendDetails, completion: @escaping ((TimeEntryDetailsResult) -> Void)) {
        let request = StartTimeEntryRequest(details: entry)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
    
    public func update(entry: TimeEntrySendDetails, id entryId: Int, completion: @escaping ((TimeEntryDetailsResult) -> Void)) {
        let request = UpdateTimeEntryRequest(id: entryId, details: entry)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }

    public func stop(entry entryId: Int, completion: @escaping ((TimeEntryDetailsResult) -> Void)) {
        let request = StopTimeEntryRequest(id: entryId, userId: userId)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
    
    public func delete(entry entryId: Int, completion: @escaping ((DeleteTimeEntryResult) -> Void)) {
        let request = DeleteTimeEntryRequest(userId: userId, entryId: entryId)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
    
    public func create(entry: TimeEntrySendDetails, completion: @escaping ((TimeEntryDetailsResult) -> Void)) {
        let request = CreateTimeEntryRequest(details: entry)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
    
    public func detailsFor(entry entryId: Int, completion: @escaping ((TimeEntryDetailsResult) -> Void)) {
        let request = TimeEntryDetailsRequest(entryId: entryId, userId: userId)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
}
