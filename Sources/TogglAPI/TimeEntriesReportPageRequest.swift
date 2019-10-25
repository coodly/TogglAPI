/*
* Copyright 2019 Coodly LLC
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

private let ReportsRequestBase = "/details"

internal class TimeEntriesReportPageRequest: NetworkRequest<TimeEntriesReportPage, Result<TimeEntriesReportPage, Error>> {
    private let workspace: Int
    private let projectIds: [Int]
    private let range: DateInterval
    private let page: Int
    internal init(workspace: Int, projectIds: [Int], range: DateInterval, page: Int) {
        self.workspace = workspace
        self.projectIds = projectIds
        self.range = range
        self.page = page
        
        super.init(basePath: "reports/api/v2")
    }
    
    override func performRequest() {
        var params: [String: ParameterValue] = [
            "workspace_id": .string(String(describing: workspace)),
            "since": .date(range.start),
            "until": .date(range.end),
            "page": .string(String(describing: page))
        ]
        if projectIds.count > 0 {
            let idsString = projectIds.map({ String(describing: $0) }).joined(separator: ",")
            params["project_ids"] = .string(idsString)
        }
        GET(ReportsRequestBase, params: params)
    }
    
    override func handle(result: NetworkResult<TimeEntriesReportPage>) {
        if let error = result.error {
            self.result = .failure(error)
        } else {
            self.result = .success(result.value!)
        }
    }
    
    override func token() -> String {
        return tokenStore.tokenFor(workspace: workspace)
    }
    
    override func modify(decoder: JSONDecoder) -> JSONDecoder {
        decoder.userInfo = [.reportPage: page]
        return decoder
    }
}
