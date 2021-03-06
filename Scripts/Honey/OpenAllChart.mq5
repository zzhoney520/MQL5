//+------------------------------------------------------------------+
//|                                                      Test001.mq5 |
//|                                     Copyright 2018,Honey Studio. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018,蓝色♀爱琴海，微信号：zzhoney"
#property link      "https://www.mql5.com"
#property version   "1.00"

//---要开打图表的货币对
string Chart_Array[]={"EURUSD","GBPUSD","USDJPY","USDCHF","USDCAD","AUDUSD","NZDUSD","GBPJPY","EURJPY","EURGBP","XAUUSD"};
//+------------------------------------------------------------------+
//|关闭所有已经打开的图表                                            |
//+------------------------------------------------------------------+
void CloseAllChart()
  {

//--- 用于图表 ID的变量 
   long currChart,prevChart=ChartFirst();
   int i=0,limit=20;
   ChartClose(prevChart);
   while(i<limit)
     {
      currChart=ChartNext(prevChart); // 通过使用之前图表ID获得新图表ID 
      if(currChart<0)
        {
         break;
        }
      else                            // 到达了图表列表末端 
        {
         ChartClose(currChart);
         prevChart=currChart;         // 为ChartNext()保存当前图表ID 
         i++;
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteAllSymbols()
  {

   string posChartName;
   string currChartName=ChartSymbol();
   for(int pos=SymbolsTotal(true)-1;pos>=0;pos--)
     {
      posChartName=SymbolName(pos,true);
      if(posChartName!=currChartName)
         SymbolSelect(posChartName,false);
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AddAllSymbolsInArray()
  {

   int ChartArrayLength=ArraySize(Chart_Array);
   for(int i=0;i<ChartArrayLength;i++)
     {
      SymbolSelect(Chart_Array[i],true);
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckSymbolInArray(string symbol)
  {

   bool flag=false;
   int ChartArrayLength=ArraySize(Chart_Array);
   for(int i=0;i<ChartArrayLength;i++)
     {
      if(Chart_Array[i]==symbol)
         flag=true;
     }
   return flag;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void delSymbolsNotInArray()
  {

   string posSymbolName;
   for(int pos=SymbolsTotal(true)-1;pos>=0;pos--)
     {
      posSymbolName=SymbolName(pos,true);
      if(!CheckSymbolInArray(posSymbolName))
        {
         SymbolSelect(posSymbolName,false);
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void openAllSymbolsInArray()
  {

   string symbolname;
   long chartID;
   string TemplateFile="honey.tpl";
   if(FileIsExist(TemplateFile))
     {
      for(int pos=0;pos<SymbolsTotal(true);pos++)
        {
         symbolname=SymbolName(pos,true);
         if(CheckSymbolInArray(symbolname))
           {
            chartID=ChartOpen(symbolname,PERIOD_H1);
              {
               ChartApplyTemplate(chartID,"\\Files\\"+TemplateFile);
               ChartRedraw(chartID);
              }
           }
        }
     }
   else
     {
      MessageBox("模板文件不存在！");
     }
  }
//+------------------------------------------------------------------+
//|主函数                                                            |
//+------------------------------------------------------------------+
void OnStart()
  {

   CloseAllChart();
   DeleteAllSymbols();
   AddAllSymbolsInArray();
   delSymbolsNotInArray();
   openAllSymbolsInArray();

  }
//+------------------------------------------------------------------+
