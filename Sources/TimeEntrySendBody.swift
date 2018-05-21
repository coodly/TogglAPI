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

internal struct TimeEntrySendBody: Encodable {
    let timeEntry: TimeEntrySendDetails
}

public struct TimeEntrySendDetails: Encodable {
    public let wid: Int
    public let pid: Int?
    public let tid: Int?
    public let description: String?
    public let start: Date
    public let stop: Date?
    public let duration: Int?
    public let createdWith: String
}

public extension TimeEntrySendDetails {
    public static func details(wid: Int, pid: Int?, tid: Int?, description: String?, start: Date, stop: Date?, createdWith: String) -> TimeEntrySendDetails {
        let duration: Int?
        if let end = stop {
            duration = Int(end.timeIntervalSince(start))
        } else {
            duration = nil
        }
        return TimeEntrySendDetails(wid: wid, pid: pid, tid: tid, description: description, start: start, stop: stop, duration: duration, createdWith: createdWith)
    }
}
