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

public enum ListEntriesResult {
    case success([TimeEntry])
    case failure(TogglError)
}

private let ListTimeEntriesPath = "/time_entries"

internal class LoadTimeEntriesRequest: NetworkRequest<[TimeEntry], ListEntriesResult> {
    private let userId: Int
    private let range: DateInterval
    internal init(userId: Int, range: DateInterval) {
        self.userId = userId
        self.range = range
    }
    
    override func performRequest() {
        let params: [String: ParameterValue] = [
            "start_date": .date(range.start),
            "end_date": .date(range.end)
        ]
        
        GET(ListTimeEntriesPath, params: params)
    }
    
    override func handle(result: NetworkResult<[TimeEntry]>) {
        if let tasks = result.value {
            self.result = .success(tasks)
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

