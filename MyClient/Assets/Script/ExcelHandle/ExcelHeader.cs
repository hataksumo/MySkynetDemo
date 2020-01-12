using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Excel = Aspose.Cells;

public class ExcelHeader
{
    protected Dictionary<string, int> m_header;
    public ExcelHeader()
    {
        m_header = new Dictionary<string, int>();
    }
    public void init(Excel.Worksheet v_sheet, int v_header_row = 0)
    {
        Excel.Cells data = v_sheet.Cells;
        for (int i = 0; i < 100; i++)
        {
            string header = Convert.ToString(data[v_header_row, i].Value);
            if (string.IsNullOrEmpty(header))
                break;
            m_header.Add(header, i);
        }
    }
    public int get_col(string v_header_name)
    {
        if (m_header.ContainsKey(v_header_name))
            return m_header[v_header_name];
        //ZFDebug.Error(string.Format("没找到名为{}的列", v_header_name));
        return -1;
    }
    public int Count { get { return m_header.Count; } }
}

