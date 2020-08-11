public class ReportData
{
    Reports.ReportResults Results { get; set; }
    public List<string> Columns { get; set; } 
    public List<List<string>> Rows { get; set; }
    public string DeveloperName { get; set; }
    public string filterColumn { get; set; }
    public string filterValue { get; set; }
    public ReportData()
    {
        ReportData rd = GetReportData(DeveloperName, filterColumn, filterValue);
        Results = rd.Results;
        Columns = rd.Columns;
        Rows = rd.Rows;        
    }
    public static ReportData GetReportData(string DeveloperName, string filterColumn, string filterValue)
    {
        ReportData rd = new ReportData();
        rd.Columns = new List<string>();
        rd.Rows = new List<List<string>>();
        Report report = [SELECT Id, DeveloperName FROM Report WHERE DeveloperName = :DeveloperName];
        string reportId = (string)report.Id;
        // Set the filter 
        Reports.ReportDescribeResult rdr = Reports.ReportManager.describeReport(reportId);
        Reports.ReportMetadata md = rdr.getReportMetadata();
        Reports.ReportFilter filter = new Reports.ReportFilter(filterColumn, 'equals', filterValue, Reports.ReportFilterType.fieldValue);    
        md.getReportFilters().add(filter);
        //filter.setValue(record.Name);
        system.debug('*** ' + md.getReportFilters());
        // filters: todo
        // Get the report results
        rd.Results = Reports.ReportManager.runReport(reportId, md, true);
        // Firstly, build up a list of our column labels
        Map<String, Reports.DetailColumn> columnMetadata = rd.Results.getReportExtendedMetadata().getDetailColumnInfo();
        List<string> detailColumns = rd.Results.getReportMetadata().getDetailColumns();
        system.debug(detailColumns);
        for (integer idx = 0; idx < detailColumns.size(); idx++)
        { 
            string col = detailColumns[idx];
            rd.Columns.add(columnMetadata.get(col).getLabel());                
        }
        // Then build up a list of our actual data - and process it.
        Reports.ReportFactWithDetails details = (Reports.ReportFactWithDetails)rd.Results.getFactMap().get('T!T');
        for (Reports.ReportDetailRow row : details.getRows())
        {
            List<string> dr = new List<string>();
            List<Reports.ReportDataCell> cells = row.getDataCells();
            for (integer c = 0; c < cells.size(); c++)
            {
                Reports.ReportDataCell cell = cells[c];
                dr.add(cell.getLabel());
            }
            rd.Rows.add(dr);
        }
        return rd;
    }
}

