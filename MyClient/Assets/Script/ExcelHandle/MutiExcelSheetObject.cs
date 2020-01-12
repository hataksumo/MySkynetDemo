using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Excel = Aspose.Cells;

public class MutiExcelSheetObject
{
    struct _PmLoc
    {
        public int row;
        public int sheetIdx;
        public _PmLoc(int v_row, int v_sheetIdx)
        {
            row = v_row;
            sheetIdx = v_sheetIdx;
        }
    }


    protected List<ExcelSheetObject> _sheets;
    private Dictionary<string, _PmLoc> pm_index;

    public MutiExcelSheetObject()
    {
        _sheets = new List<ExcelSheetObject>();
    }

    //private Dictionary<CellPoint, List<object>> m_src_infos;
    public void addSheet(ExcelSheetObject v_esobj)
    {
        _sheets.Add(v_esobj);
    }
    public void init_data(string v_pmkey = "id", int v_row_begin = 3)
    {
        pm_index = new Dictionary<string, _PmLoc>();
        for (int i = 0; i < _sheets.Count; i++)
        {
            Excel.Worksheet theSheet = _sheets[i].Sheet;
            ExcelHeader theHeader = _sheets[i].Header;
            //m_src_infos = new Dictionary<CellPoint, List<object>>();
            Excel.Cells data = theSheet.Cells;
            int col = theHeader.get_col(v_pmkey);
            if (col < 0)
            {
                ZFDebug.Error(string.Format("{0}中没找到名为{1}的列", theSheet.Name, v_pmkey));
                return;
            }
            for (int row = v_row_begin; row < 100000; row++)
            {
                object test_obj = data[row, col].Value;
                if (test_obj == null)
                {
                    break;
                }
                if (!pm_index.ContainsKey(test_obj.ToString()))
                    pm_index.Add(test_obj.ToString(), new _PmLoc(row, i));
            }
        }
    }

    public bool set_val_by_pmid(string v_pmkey, string v_col_name, object v_val)
    {
        if (pm_index.ContainsKey(v_pmkey))
        {
            _PmLoc point = pm_index[v_pmkey];
            ExcelSheetObject theSheet = _sheets[point.sheetIdx];
            ExcelHeader theHeader = theSheet.Header;
            int col = theHeader.get_col(v_col_name);
            if (col < 0)
            {
                ZFDebug.Error(string.Format("{0}中没找到名为{1}的列", theSheet, v_col_name));
                return false;
            }
            int row = pm_index[v_pmkey].row;
            theSheet.Sheet.Cells[row, col].Value = v_val;
            return true;
        }
        return false; 
    }





}
