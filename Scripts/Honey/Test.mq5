//--- 描述 
#property description "Script creates the button on the chart." 
//--- 启动脚本期间显示输入参数的窗口 
#property script_show_inputs 
//--- 脚本的输入参数 
input string           InpName="Button";            // 按钮名称 
input ENUM_BASE_CORNER InpCorner=CORNER_LEFT_UPPER; // 图表定位角 
input string           InpFont="Arial";             // 字体 
input int              InpFontSize=14;              // 字体大小 
input color            InpColor=clrBlack;           // 文本颜色 
input color            InpBackColor=C'236,233,216'; // 背景色 
input color            InpBorderColor=clrNONE;      // 边界颜色 
input bool             InpState=false;              // 出版/发布 
input bool             InpBack=false;               // 背景对象 
input bool             InpSelection=false;          // 突出移动 
input bool             InpHidden=true;              // 隐藏在对象列表 
input long             InpZOrder=0;                 // 鼠标单击优先 
//+------------------------------------------------------------------+ 
//| 创建按钮                                                          | 
//+------------------------------------------------------------------+ 
bool ButtonCreate(const long              chart_ID=0,               // 图表 ID 
                  const string            name="Button",            // 按钮名称 
                  const int               sub_window=0,             // 子窗口指数 
                  const int               x=0,                      // X 坐标 
                  const int               y=0,                      // Y 坐标 
                  const int               width=50,                 // 按钮宽度 
                  const int               height=18,                // 按钮高度 
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // 图表定位角 
                  const string            text="Button",            // 文本 
                  const string            font="Arial",             // 字体 
                  const int               font_size=10,             // 字体大小 
                  const color             clr=clrBlack,             // 文本颜色 
                  const color             back_clr=C'236,233,216',  // 背景色 
                  const color             border_clr=clrNONE,       // 边界颜色 
                  const bool              state=false,              // 出版/发布 
                  const bool              back=false,               // 在背景中 
                  const bool              selection=false,          // 突出移动 
                  const bool              hidden=true,              // 隐藏在对象列表 
                  const long              z_order=0)                // 鼠标单击优先 
  {
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
//| 移动按钮                                                          | 
//+------------------------------------------------------------------+ 
bool ButtonMove(const long   chart_ID=0,    // 图表 ID 
                const string name="Button", // 按钮名称 
                const int    x=0,           // X 坐标 
                const int    y=0)           // Y 坐标 
  {
//--- 重置错误的值 
   ResetLastError();
//--- 移动按钮 
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the button! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the button! Error code = ",GetLastError());
      return(false);
     }
//--- 成功执行 
   return(true);
  }
//+------------------------------------------------------------------+ 
//| 改变按钮大小                                                       | 
//+------------------------------------------------------------------+ 
bool ButtonChangeSize(const long   chart_ID=0,    // 图表 ID 
                      const string name="Button", // 按钮名称 
                      const int    width=50,      // 按钮宽度 
                      const int    height=18)     // 按钮高度 
  {
//--- 重置错误的值 
   ResetLastError();
//--- 改变按钮大小 
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width))
     {
      Print(__FUNCTION__,
            ": failed to change the button width! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height))
     {
      Print(__FUNCTION__,
            ": failed to change the button height! Error code = ",GetLastError());
      return(false);
     }
//--- 成功执行 
   return(true);
  }
//+------------------------------------------------------------------+ 
//| 改变绑定按钮的图表角落                                              | 
//+------------------------------------------------------------------+ 
bool ButtonChangeCorner(const long             chart_ID=0,               // 图表 ID 
                        const string           name="Button",            // 按钮名称 
                        const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER) // 图表定位角 
  {
//--- 重置错误的值 
   ResetLastError();
//--- 改变定位角 
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner))
     {
      Print(__FUNCTION__,
            ": failed to change the anchor corner! Error code = ",GetLastError());
      return(false);
     }
//--- 成功执行 
   return(true);
  }
//+------------------------------------------------------------------+ 
//| 改变按钮文本                                                       | 
//+------------------------------------------------------------------+ 
bool ButtonTextChange(const long   chart_ID=0,    // 图表 ID 
                      const string name="Button", // 按钮名称 
                      const string text="Text")   // 文本 
  {
//--- 重置错误的值 
   ResetLastError();
//--- 改变对象文本 
   if(!ObjectSetString(chart_ID,name,OBJPROP_TEXT,text))
     {
      Print(__FUNCTION__,
            ": failed to change the text! Error code = ",GetLastError());
      return(false);
     }
//--- 成功执行 
   return(true);
  }
//+------------------------------------------------------------------+ 
//| 删除按钮                                                          | 
//+------------------------------------------------------------------+ 
bool ButtonDelete(const long   chart_ID=0,    // 图表 ID 
                  const string name="Button") // 按钮名称 
  {
//--- 重置错误的值 
   ResetLastError();
//---删除按钮 
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete the button! Error code = ",GetLastError());
      return(false);
     }
//--- 成功执行 
   return(true);
  }
//+------------------------------------------------------------------+ 
//| 脚本程序起始函数                                                   | 
//+------------------------------------------------------------------+ 
void OnStart()
  {
//--- 图表窗口大小 
   long x_distance;
   long y_distance;
//--- 设置窗口大小 
   if(!ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,x_distance))
     {
      Print("Failed to get the chart width! Error code = ",GetLastError());
      return;
     }
   if(!ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0,y_distance))
     {
      Print("Failed to get the chart height! Error code = ",GetLastError());
      return;
     }
//--- 定义改变按钮大小的步骤 
   int x_step=(int)x_distance/32;
   int y_step=(int)y_distance/32;
//--- 设置按钮坐标及其大小 
   int x=(int)x_distance/32;
   int y=(int)y_distance/32;
   int x_size=(int)x_distance*15/16;
   int y_size=(int)y_distance*15/16;
//--- 创建按钮 
   if(!ButtonCreate(0,InpName,0,x,y,x_size,y_size,InpCorner,"Press",InpFont,InpFontSize,
      InpColor,InpBackColor,InpBorderColor,InpState,InpBack,InpSelection,InpHidden,InpZOrder))
     {
      return;
     }
//--- 重画图表 
   ChartRedraw();
//--- 减少循环中的按钮 
   int i=0;
   while(i<13)
     {
      //--- 延迟半秒 
      Sleep(500);
      //--- 转换按钮到出版状态 
      ObjectSetInteger(0,InpName,OBJPROP_STATE,true);
      //--- 重绘图表，等候0.2 秒 
      ChartRedraw();
      Sleep(200);
      //--- 重新定义坐标和按钮大小 
      x+=x_step;
      y+=y_step;
      x_size-=x_step*2;
      y_size-=y_step*2;
      //--- 减少按钮 
      ButtonMove(0,InpName,x,y);
      ButtonChangeSize(0,InpName,x_size,y_size);
      //--- 按钮返回发布状态 
      ObjectSetInteger(0,InpName,OBJPROP_STATE,false);
      //--- 重画图表 
      ChartRedraw();
      //--- 检查脚本操作是否已经强制禁用 
      if(IsStopped())
         return;
      //--- 增加循环计数器 
      i++;
     }
//--- 半秒延迟 
   Sleep(500);
//---删除按钮 
   ButtonDelete(0,InpName);
   ChartRedraw();
//--- 等待1秒 
   Sleep(1000);
//---
  }
//+------------------------------------------------------------------+
