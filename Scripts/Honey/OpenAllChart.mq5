//+------------------------------------------------------------------+
//|                                                      Test001.mq5 |
//|                                     Copyright 2018,Honey Studio. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018,蓝色♀爱琴海，微信号：zzhoney"
#property link      "https://www.mql5.com"
#property version   "1.00"

//---要开打图表的货币对
string Chart_Array[]={"EURUSD","GBPUSD","USDJPY","USDCHF","USDCAD","AUDUSD","NZDUSD","XAUUSD","GBPJPY","EURJPY","EURGBP"};
//+------------------------------------------------------------------+
//|关闭所有已经打开的图表                                            |
//+------------------------------------------------------------------+
void CloseAllChart()
  {

   int i=0,limit=20;
   long currChart,prevChart=ChartFirst();
   ChartClose(prevChart);
   while(i<limit)
     {
      currChart=ChartNext(prevChart);
      if(currChart<0) break;
      else ChartClose(currChart);
      prevChart=currChart;
      i++;
     }

  }
//+------------------------------------------------------------------+
//|主函数                                                            |
//+------------------------------------------------------------------+
void OnStart()
  {

   long tmpID;
   bool tmp;
   int ChartArrayLength=ArraySize(Chart_Array);
   string TemplateFile="honey.tpl";
   if(!FileIsExist(TemplateFile))
     {
      MessageBox("模板文件不存在！");
      return;
     }
   CloseAllChart();

   for(int i=0;i<ChartArrayLength;i++)
     {
      if(SymbolExist(Chart_Array[i],tmp))
        {
         tmpID=ChartOpen(Chart_Array[i],PERIOD_H1);
         ChartApplyTemplate(tmpID,"honey.tpl");
        }
     }
   ChartRedraw();

  }
//+------------------------------------------------------------------+
