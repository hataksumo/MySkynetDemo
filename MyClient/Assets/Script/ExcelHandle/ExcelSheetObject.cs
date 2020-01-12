using LuaInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Excel = Aspose.Cells;


class CellPoint : IEquatable<CellPoint>
{
    public int row;
    public int col;
    public CellPoint()
    {

    }

    public CellPoint(int v_row,int v_col)
    {
        row = v_row;
        col = v_col;
    }

    public bool Equals(CellPoint v_other)
    {
        return (row == v_other.row) && (col == v_other.col);
    }

    public override int GetHashCode()
    {
        return row * 100 + col;
    }
}


public class ExcelSheetObject
{
    protected Excel.Worksheet m_sheet;
    protected ExcelHeader m_header;
    protected string m_sheet_name;
    Dictionary<CellPoint, List<object>> m_src_infos;
    public ExcelSheetObject(Excel.Worksheet v_worksheet,string v_sheet_name)
    {
        m_sheet = v_worksheet;
        m_sheet_name = v_sheet_name;
        init_header();
    }
    public void init_header(int v_headrow =0)
    {
        m_header = new ExcelHeader();
        m_header.init(m_sheet, v_headrow);
    }


    public object get_val(int v_row, int v_col)
    {
        return m_sheet.Cells[v_row, v_col].Value;
    }
    public object get_val(int v_row, string v_header_name)
    {
        int col = m_header.get_col(v_header_name);
        if (col < 0)
        {
            ZFDebug.Error(string.Format("{0}中没找到名为{1}的列", m_sheet_name, v_header_name));
            return null;
        }
        object val = m_sheet.Cells[v_row, col].Value;
        return m_sheet.Cells[v_row, col].Value;
    }

    public int get_vali(int v_row, string v_header_name)
    {
        int rtn = -1;
        object ortn = get_val(v_row, v_header_name);
        if (ortn == null) return rtn;
        if (ortn is double)
        {
            rtn = (int)(double)ortn;
        }
        else if (ortn is string)
        {
            if (!int.TryParse((string)ortn, out rtn))
            {
                ZFDebug.Error(string.Format("{0}不是int", (string)ortn));
            }
        }
        else
        {
            ZFDebug.Error(string.Format("{0}表{1}列的数据类型无法解析", m_sheet_name, v_header_name));
        }
        return rtn;
    }

    public double get_valf(int v_row, string v_header_name)
    {
        double rtn = -1;
        object ortn = get_val(v_row, v_header_name);
        if (ortn == null) return rtn;
        if (ortn is double)
        {
            rtn = (double)ortn;
        }
        else if (ortn is string)
        {
            if (!double.TryParse((string)ortn, out rtn))
            {
                ZFDebug.Error(string.Format("{0}不是int", (string)ortn));
            }
        }
        else
        {
            ZFDebug.Error(string.Format("{0}表{1}的列的数据类型无法解析", m_sheet_name, v_header_name));
        }
        return rtn;
    }



    public string get_vals(int v_row, string v_header_name)
    {
        string rtn = "";
        object ortn = get_val(v_row, v_header_name);
        if (ortn == null) return rtn;
        if (ortn is string)
        {
            rtn = (string)ortn;
        }
        else if (ortn is string)
        {
            rtn = ortn.ToString();
        }
        else
        {
            ZFDebug.Error(string.Format("{0}{1}的列的数据类型无法解析", m_sheet_name, v_header_name));
        }
        return rtn;
    }



    public string get_string(int v_row, int v_col)
    {
        object val = get_val(v_row, v_col) as string;
        if (val == null)
            return null;
        return Convert.ToString(val);
    }
    public int get_int(int v_row, int v_col)
    {
        object val = get_val(v_row, v_col);
        if (val == null|| !(val is int))
            return -1 ;
        return Convert.ToInt32(val);
    }
    public double get_double(int v_row, int v_col)
    {
        object val = get_val(v_row, v_col);
        if (val == null || !(val is double))
            return -1;
        return Convert.ToDouble(val);
    }
    public void set_val_by_point(int v_row, int v_col, object v_val)
    {
        m_sheet.Cells[v_row, v_col].Value = v_val;
    }
    public void set_val(string v_header_name, int v_row, object v_val)
    {
        int col = m_header.get_col(v_header_name);
        if (col < 0)
        {
            ZFDebug.Error(string.Format("{0}中没找到名为{1}的列", m_sheet_name,v_header_name));
            return;
        }
        m_sheet.Cells[v_row, col].Value = v_val;
    }
    public void set_vali(string v_header_name, int v_row, int v_val)
    {
        set_val(v_header_name, v_row, v_val);
    }
    public void set_valf(string v_header_name, int v_row, double v_val,int precision = 2)
    {
        set_val(v_header_name, v_row, Math.Round(v_val, precision));
    }
    public void set_vals(string v_header_name, int v_row, string v_val)
    {
        set_val(v_header_name, v_row, v_val);
    }
    public void set_valarr(string v_header_name, int v_row, LuaTable v_table)
    {
        LuaArrayTable arr_info = v_table.ToArrayTable();
        StringBuilder sb = new StringBuilder();
        for(int i=0;i<= arr_info.Length;i++)
        {
            if (sb.Length > 0)
                sb.Append(',');
            if(arr_info[i] != null)
                sb.Append(arr_info[i]);
        }
        set_val(v_header_name, v_row, sb.ToString());
    }

    public void set_valarri(string v_header_name, int v_row, LuaTable v_table)
    {
        LuaArrayTable arr_info = v_table.ToArrayTable();
        StringBuilder sb = new StringBuilder();
        int idx = 1;
        for (int i = 1; i < arr_info.Length; i++)
        {
            var data = arr_info[i];
            if (sb.Length > 0)
                sb.Append(',');
            if (data != null)
            {
                if (data is double || data is int)
                    sb.Append((int)Convert.ToDouble(data));
                else
                    ZFDebug.Info(string.Format("v_table[{0}] is not number", idx));
            }
            else
                ZFDebug.Info(string.Format("v_table[{0}] = nil", idx));
            idx = idx + 1;
        }
        set_val(v_header_name, v_row, sb.ToString());
    }

    public void set_valarrf(string v_header_name, int v_row, LuaTable v_table, int precision = 2)
    {
        LuaArrayTable arr_info = v_table.ToArrayTable();
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i < arr_info.Length; i++)
        {
            var data = arr_info[i];
            if (sb.Length > 0)
                sb.Append(',');
            if (data != null)
            {
                if(data is double)
                    sb.Append( Math.Round(Convert.ToDouble(data), precision));
                else
                    ZFDebug.Info(string.Format("v_table[{0}] is not double", i));
            }
            else
                ZFDebug.Info(string.Format("v_table[{0}] = nil", i));
        }
        set_val(v_header_name, v_row, sb.ToString());
    }

    public void set_valarrs(string v_header_name, int v_row, LuaTable v_table)
    {
        LuaArrayTable arr_info = v_table.ToArrayTable();
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i < arr_info.Length; i++)
        {
            var data = arr_info[i];
            if (sb.Length > 0)
                sb.Append(',');
            if (data != null)
            {
                if (data is string)
                    sb.Append(Convert.ToString(data));
                else
                    ZFDebug.Info(string.Format("v_table[{0}] is not string", i));
            }
            else
                ZFDebug.Info(string.Format("v_table[{0}] = nil", i));
        }
        set_val(v_header_name, v_row, sb.ToString());
    }


    public void set_valb(string v_header_name, int v_row, bool v_b)
    {
        int col = m_header.get_col(v_header_name);
        if (col < 0)
        {
            ZFDebug.Error(string.Format("{0}中没找到名为{1}的列", m_sheet_name, v_header_name));
            return;
        }
        m_sheet.Cells[v_row, col].Value = v_b ?true:false;
    }

    public void clear_cell(string v_header_name, int v_row)
    {
        int col = m_header.get_col(v_header_name);
        if (col < 0)
        {
            ZFDebug.Error(string.Format("{0}中没找到名为{1}的列", m_sheet_name, v_header_name));
            return;
        }
        m_sheet.Cells[v_row, col].Value = null;
    }
    public void clear_row(int v_row)
    {
        int cols = m_header.Count;
        for(int i=0;i< cols;i++)
            m_sheet.Cells[v_row, i].Value = null;
    }
    Dictionary<string, int> pm_index;
    public void init_data(string v_pmkey = "id", int v_row_begin = 3)
    {
        m_src_infos = new Dictionary<CellPoint, List<object>>();
        Excel.Cells data = m_sheet.Cells;
        int col = m_header.get_col(v_pmkey);
        if (col < 0)
        {
            ZFDebug.Error(string.Format("{0}中没找到名为{1}的列", m_sheet_name, v_pmkey));
            return;
        }
        pm_index = new Dictionary<string, int>();
        for (int i = v_row_begin; i < 100000; i++)
        {
            object test_obj = data[i, col].Value;
            if (test_obj == null)
            {
                break;
            }
            if(!pm_index.ContainsKey(test_obj.ToString()))
                pm_index.Add(test_obj.ToString(), i);
        }
    }

    public void set_val_by_pmid(string v_pmkey, string v_col_name, object v_val)
    {
        int col = m_header.get_col(v_col_name);
        if (col < 0)
        {
            ZFDebug.Error(string.Format("{0}中没找到名为{1}的列", m_sheet_name, v_col_name));
            return;
        }
        if (!pm_index.ContainsKey(v_pmkey))
        {
            ZFDebug.Error(string.Format("{0}中没找到名为{1}的主键", m_sheet_name, v_pmkey));
            return;
        }
        int row = pm_index[v_pmkey];
        m_sheet.Cells[row, col].Value = v_val;
    }

    public void Add_val_by_pmid(string v_pmkey, string v_col_name, object v_val)
    {
        int col = m_header.get_col(v_col_name);
        if (col < 0)
        {
            ZFDebug.Error(string.Format("{0}中没找到名为{1}的列", m_sheet_name, v_col_name));
            return;
        }
        if (!pm_index.ContainsKey(v_pmkey))
        {
            ZFDebug.Error(string.Format("{0}中没找到名为{1}的主键", m_sheet_name, v_pmkey));
            return;
        }
        int row = pm_index[v_pmkey];
        CellPoint cp = new CellPoint(row,col);
        if (!m_src_infos.ContainsKey(cp))
        {
            m_src_infos.Add(cp, new List<object>());
        }
        m_src_infos[cp].Add(v_val);
    }
    public void flush_src_infos()
    {
        foreach (var data in m_src_infos)
        {
            CellPoint p = data.Key;
            List<object> src_info = data.Value;
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < src_info.Count; i++)
            {
                if (i > 0)
                    sb.Append(',');
                sb.Append(src_info[i]);
            }
            m_sheet.Cells[p.row,p.col].Value = sb.ToString();
        }
    }

    public Excel.Worksheet Sheet {
        get { return m_sheet; }
    }

    public ExcelHeader Header {
        get { return m_header; }
    }



}
