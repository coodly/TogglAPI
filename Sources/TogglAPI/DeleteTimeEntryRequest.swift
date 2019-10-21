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

public enum DeleteTimeEntryResult {
    case success
    case failure(TogglError)
}

private let DeleteEntryPathBase = "/time_entries/%@"

internal class DeleteTimeEntryRequest: NetworkRequest<[Int], DeleteTimeEntryResult> {
    private let userId: Int
    private let entryId: Int
    internal init(userId: Int, entryId: Int) {
        self.userId = userId
        self.entryId = entryId
    }
    
    override func performRequest() {
        let path = String(format: DeleteEntryPathBase, NSNumber(value: entryId))
        
        DELETE(path)
    }
    
    override func handle(result: NetworkResult<[Int]>) {
        if let deleted = result.value?.first, deleted == entryId {
            self.result = .success
        } else {
            self.result = .failure(result.error ?? .unknown)
        }
    }
    
    override func token() -> String {
        return tokenStore.tokenFor(user: userId)
    }
}
