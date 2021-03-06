//+------------------------------------------------------------------+
//|                                                   GlobalHead.mqh |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
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
//| 创建按钮                                                          |
//+------------------------------------------------------------------+
bool ButtonCreate(string name,string text,int x,int y,int width,int height,string font,int font_size,ENUM_BASE_CORNER corner)
  {

   const long              chart_ID=0;                 // 图表 ID
   const int               sub_window=0;               // 子窗口指数
// const int               width=200;                  // 按钮宽度
// const int               height=50;                  // 按钮高度
// const string            font="JetBrains Mono";      // 字体
// const int               font_size=12;               // 字体大小
//   const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER; // 图表定位角
   const color             clr=clrWhite;               // 文本颜色
   const color             back_clr=clrRed;            // 背景色
   const color             border_clr=clrNONE;         // 边界颜色
   const bool              state=false;                // 出版/发布
   const bool              back=false;                 // 在背景中
   const bool              selection=false;            // 突出移动
   const bool              hidden=true;                // 隐藏在对象列表
   const long              z_order=0;                  // 鼠标单击优先

//--- 重置错误的值
   ResetLastError();
//--- 创建按钮
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create the button! Error code = ",GetLastError());
      return(false);
     }
//--- 设置按钮坐标
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- 设置按钮大小
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- 设置相对于定义点坐标的图表的角
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- 设置文本
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- 设置文本字体
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- 设置字体大小
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- 设置文本颜色
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- 设置背景颜色
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- 设置边界颜色
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- 显示前景 (false) 或背景 (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- 启用 (true) 或禁用 (false) 通过鼠标移动按钮的模式
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
//| 创建文本标签                                                       |
//+------------------------------------------------------------------+
bool LabelCreate(string name,string text,int x,int y,string font,int font_size,ENUM_BASE_CORNER corner,color clr)
  {

   const long              chart_ID=0;                 // 图表 ID
   const int               sub_window=0;               // 子窗口指数
// const ENUM_BASE_CORNER  corner=CORNER_RIGHT_UPPER;  // 图表定位角
// const int               font_size=18;               // 字体大小
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
//| 创建矩形标签                                                       |
//+------------------------------------------------------------------+
bool     RectLabelCreate(const long             chart_ID=0,               // 图表 ID
                     const string           name="RectLabel",         // 标签名称
                     const int              sub_window=0,             // 子窗口指数
                     const int              x=1005,                      // X 坐标
                     const int              y=165,                      // Y 坐标
                     const int              width=940,                 // 宽度
                     const int              height=60,                // 高度
                     const color            back_clr=clrBlack,  // 背景色
                     const ENUM_BORDER_TYPE border=BORDER_FLAT,     // 边框类型
                     const ENUM_BASE_CORNER corner=CORNER_RIGHT_LOWER, // 图表定位角
                     const color            clr=clrCrimson,               // 平面边框颜色 (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // 平面边框风格
                     const int              line_width=3,             // 平面边框宽度
                     const bool             back=true,               // 在背景中
                     const bool             selection=false,          // 突出移动
                     const bool             hidden=true,              // 隐藏在对象列表
                     const long             z_order=0)                // 鼠标单击优先
  {
//--- 重置错误的值
   ResetLastError();
//--- 创建矩形标签
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle label! Error code = ",GetLastError());
      return(false);
     }
//--- 设置标签坐标
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- 设置标签大小
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- 设置背景颜色
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- 设置边框类型
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
//--- 设置相对于定义点坐标的图表的角
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- 设置平面边框颜色 (在平面模式下)
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- 设置平面边框线型风格
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- 设置平面边框宽度
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
//--- 显示前景 (false) 或背景 (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- 启用 (true) 或禁用 (false) 通过鼠标移动标签的模式
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- 在对象列表隐藏(true) 或显示 (false) 图形对象名称
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- 设置在图表中优先接收鼠标点击事件
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- 设置文本
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,"美国时间");
//--- 设置文本字体
   ObjectSetString(chart_ID,name,OBJPROP_FONT,"楷体");
//--- 设置字体大小
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,18); //--- 成功执行

   return(true);
  }
//+------------------------------------------------------------------+
