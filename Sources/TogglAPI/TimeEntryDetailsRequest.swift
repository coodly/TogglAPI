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

private let TimeEntryDetailsPathBase = "/time_entries/%@"

internal class TimeEntryDetailsRequest: NetworkRequest<TimeEntryDetailsResponse, TimeEntryDetailsResult> {
    private let entryId: Int
    private let userId: Int
    internal init(entryId: Int, userId: Int) {
        self.entryId = entryId
        self.userId = userId
    }
    
    override func performRequest() {
        let path = String(format: TimeEntryDetailsPathBase, NSNumber(value: entryId))
        GET(path)
    }
    
    override func handle(result: NetworkResult<TimeEntryDetailsResponse>) {
        if let entry = result.value?.data {
            self.result = .success(entry)
        } else {
            self.result = .failure(result.error ?? .unknown)
        }
    }
    
    override func token() -> String {
        return tokenStore.tokenFor(user: userId)
    }
}
