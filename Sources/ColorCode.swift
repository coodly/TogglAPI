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

public struct ColorCode {
    public let index: Int
    public let code: String
    
    public static let all = ColorCode.codes.enumerated().map({ ColorCode(index: $0.offset, code: $0.element) })
    
    
    private static let codes = [
        "#06aaf5",
        "#c56bff",
        "#ea468d",
        "#fb8b14",
        "#c7741c",
        "#4bc800",
        "#04bb9b",
        "#e19a86",
        "#3750b5",
        "#a01aa5",
        "#f1c33f",
        "#205500",
        "#890000",
        "#e20505",
        "#000000"
    ]
}
