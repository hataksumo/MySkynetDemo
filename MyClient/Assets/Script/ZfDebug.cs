using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;


public static class ZFDebug
{
    public static void Info(string v_msg)
    {
        UnityEngine.Debug.Log(v_msg);
    }
    public static void Error(string v_msg)
    {
        UnityEngine.Debug.LogError(v_msg);
    }

    public static void Warning(string v_msg)
    {
        UnityEngine.Debug.LogWarning(v_msg);
    }

    public static void Koid(string v_msg)
    {
        UnityEngine.Debug.Log("<color=green>" + v_msg + "</color>"); 
    }
}
