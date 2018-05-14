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

public class Toggl {
    private let fetch: NetworkFetch
    public init(fetch: NetworkFetch) {
        self.fetch = fetch
    }
    
    public func passwordAuthentication(_ username: String, password: String) {
        let request = MyDetailsRequest(username: username, password: password)
        inject(into: request)
        request.execute()
    }
    
    private func inject(into object: AnyObject) {
        if var consumer = object as? FetchConsumer {
            consumer.fetch = fetch
        }
    }
}
