//+------------------------------------------------------------------+
//|                                                  CreateLabel.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+ 
//| 创建文本标签                                                       | 
//+------------------------------------------------------------------+ 
bool LabelCreate(string name,string text,int x,int y,string font,color clr)
  {
   const long              chart_ID=0;                 // 图表 ID 
   const int               sub_window=0;               // 子窗口指数 
   const ENUM_BASE_CORNER  corner=CORNER_RIGHT_UPPER;  // 图表定位角 
   const int               font_size=18;               // 字体大小 
   const double            angle=0.0;                  // 文本倾斜 
   const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER;   // 定位类型 
   const bool              back=false;                 // 在背景中 
   const bool              selection=false;            // 突出移动 
   const bool              hidden=true;                // 隐藏在对象列表 
   const long              z_order=0;
//--- 重置错误的值 
   ResetLastError();
//--- 创建文本标签 
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
//--- 设置标签坐标 
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- 设置相对于定义点坐标的图表的角 
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- 设置文本 
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- 设置文本字体 
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- 设置字体大小 
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- 设置文本的倾斜角 
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- 设置定位类型 
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- 设置颜色 
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- 显示前景 (false) 或背景 (true) 
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- 启用 (true) 或禁用 (false) 通过鼠标移动标签的模式 
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- 在对象列表隐藏(true) 或显示 (false) 图形对象名称 
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- 设置在图表中优先接收鼠标点击事件 
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- 成功执行 
   return(true);
  }
//+------------------------------------------------------------------+
