using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Excel = Aspose.Cells;


public class ExcelBookObject
{
    protected Excel.Workbook m_workbook = null;
    public ExcelBookObject()
    {
    }
    public void open(string v_path)
    {
        m_workbook = new Excel.Workbook(MyTools.ExcelPath +   v_path);
    }
    public ExcelSheetObject get_sheet(string v_sheet)
    {
        if (m_workbook != null)
        {
            var sheet = m_workbook.Worksheets[v_sheet];
            if (sheet == null)
            {
                ZFDebug.Error(string.Format("没找到名为{0}的sheet", v_sheet));
                return null;
            }

            return new ExcelSheetObject(sheet, v_sheet);
        }
        return null;
    }
    public void save(string v_optpath) 
    {
        m_workbook.Save(v_optpath);
    }
}
