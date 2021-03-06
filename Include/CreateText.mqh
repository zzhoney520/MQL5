//+------------------------------------------------------------------+
//|                                                   CreateText.mqh |
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
//+------------------------------------------------------------------+ 
//| 创建文本对象                                                       | 
//+------------------------------------------------------------------+ 
bool TextCreate(const long              chart_ID=0,               // 图表 ID 
                const string            name="Text",              // 对象名称 
                const int               sub_window=0,             // 子窗口指数 
                datetime                time=0,                   // 定位点时间 
                double                  price=0,                  // 定位点价格 
                const string            text="净值：",// 文本本身 
                const string            font="黑体",// 字体 
                const int               font_size=16,             // 字体大小 
                const color             clr=clrRed,               // 颜色 
                const double            angle=0.0,                // 文本倾斜 
                const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // 定位类型 
                const bool              back=false,               // 在背景中 
                const bool              selection=false,          // 突出移动 
                const bool              hidden=true,              // 隐藏在对象列表 
                const long              z_order=0)                // 鼠标单击优先 
  {
//--- 如果点的时间没有设置，它将位于当前柱 
   if(!time)
      time=TimeCurrent();
//--- 如果点的价格没有设置，则它将用卖价值 
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- 重置错误的值 
   ResetLastError();
//--- 创建文本对象 
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create \"Text\" object! Error code = ",GetLastError());
      return(false);
     }
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
//--- 启用 (true) 或禁用 (false) 通过鼠标移动对象的模式 
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
