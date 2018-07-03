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

internal struct ProjectSendBody: Encodable {
    let project: ProjectSendDetails
}

public struct ProjectSendDetails: Encodable {
    public let wid: Int
    public let name: String
    public let color: String
    public let active: Bool
}

public extension ProjectSendDetails {
    public static func details(wid: Int, name: String, colorHEX: String, active: Bool) -> ProjectSendDetails {
        let colorIndex = ColorCode.all.index(where: { $0.code == colorHEX }) ?? 0
        return ProjectSendDetails(wid: wid, name: name, color: String(describing: colorIndex), active: active)
    }
}
