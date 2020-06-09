using System;
using Microsoft.SPOT;
using System.Ext.Xml;
using Controls.Properties;
using Microsoft.SPOT.Platform.Test;
using Microsoft.SPOT.Presentation;
using Microsoft.SPOT.Presentation.Controls;
using Microsoft.SPOT.Presentation.Media;

using Microsoft.SPOT.Platform.Tests;

// Taken from stacyh3's code at the following URL: http://forums.netduino.com/index.php?/topic/215-ds1307-real-time-clock/
namespace System.Runtime.CompilerServices
{
    [AttributeUsageAttribute(AttributeTargets.Assembly | AttributeTargets.Class | AttributeTargets.Method)]
    sealed class ExtensionAttribute : Attribute
    {
    }
}

namespace Presentaion
{
    public static class PointExtensionMethods
    {
        public static string ToString(this Microsoft.SPOT.Platform.Tests.Master_Presentation.Point[] chkPoints)
        {
            string st = "Point["+chkPoints.Length+"]=";
            for (int i = 0; i < chkPoints.Length; i++)
            {
                st += chkPoints[i].ToString();
                st += ", ";
            }

            return st;
        }
    }
}
