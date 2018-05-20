/*
 * Copyright 2017 Coodly LLC
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

public class Toggl: Injector {
    public init(fetch: NetworkFetch, tokenStore: TokenStore) {
        Injection.sharedInstance.fetch = fetch
        Injection.sharedInstance.tokenStore = tokenStore
    }
    
    public func passwordAuthentication(_ username: String, password: String, completion: @escaping ((LoginResult) -> Void)) {
        let request = MyDetailsRequest(username: username, password: password)
        inject(into: request)
        request.resultHandler = completion
        request.execute()
    }
    
    public func clientFor(workspaceId: Int) -> WorkspaceClient {
        return WorkspaceClient(workspaceId: workspaceId)
    }
    
    public func entriesClient(userId: Int) -> TimeEntriesClient {
        return TimeEntriesClient(userId: userId)
    }
}
