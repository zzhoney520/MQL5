//+------------------------------------------------------------------+
//|                                         HistogramChartSample.mq5 |
//|                   Copyright 2009-2017, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright   "2009-2017, MetaQuotes Software Corp."
#property link        "http://www.mql5.com"
#property description "Example of using histogram"
//+------------------------------------------------------------------+
//| 脚本程序起始函数                                                   |
//+------------------------------------------------------------------+
void OnStart(void)
  {
//ChartClose();
//int totals=SymbolsTotal(true);
//SymbolSelect(SymbolName(2,true),false);
//for(int i=0;i<totals;i++)
//  {
//   SymbolSelect(SymbolName(totals-i,true),false);
//  }
//int symboltatols=SymbolsTotal(true);
//string symbolName;
//for(int i=symboltatols-1;i>=0;i--)
//  {
//   symbolName=SymbolName(i,true);
//   if(symbolName!="EURUSD")
//     {
//      SymbolSelect(symbolName,false);
//     }
//  }
   ChartApplyTemplate(SymbolName(0,true),"\\Files\\honey.tpl");

  }
//+------------------------------------------------------------------+
