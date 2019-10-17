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
    private let project: Int
    private let range: DateInterval
    internal init(workspace: Int, project: Int, range: DateInterval) {
        self.workspace = workspace
        self.project = project
        self.range = range
        
        super.init(basePath: "reports/api/v2")
    }
    
    override func performRequest() {
        GET(ReportsRequestBase, params: [
            "workspace_id": .string(String(describing: workspace)),
            "project_ids": .string(String(describing: project)),
            "since": .date(range.start),
            "until": .date(range.end)
        ])
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
}
