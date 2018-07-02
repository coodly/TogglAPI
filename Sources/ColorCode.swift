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
        "#4dc3ff",
        "#bc85e6",
        "#df7baa",
        "#f68d38",
        "#b27636",
        "#8ab734",
        "#14a88e",
        "#268bb5",
        "#6668b4",
        "#a4506c",
        "#67412c",
        "#3c6526",
        "#094558",
        "#bc2d07",
        "#999999"
    ]
}
