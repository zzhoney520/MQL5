//+------------------------------------------------------------------+
//|                                                     MyExpert.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Expert\Expert.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CMyExpert : public CExpert
  {
private:

public:
                     CMyExpert();
                    ~CMyExpert();
   bool              NewBar(void);
protected:
   virtual bool      CheckOpenLong(void);
   virtual bool      CheckOpenShort(void);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMyExpert::CMyExpert()
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMyExpert::~CMyExpert()
  {

  }
//+------------------------------------------------------------------+
//|多头开仓                                                          |
//+------------------------------------------------------------------+
bool CMyExpert::CheckOpenLong(void)
  {
   return(false);
  }
//+------------------------------------------------------------------+
//|多头平仓                                                          |
//+------------------------------------------------------------------+
bool CMyExpert::CheckOpenShort(void)
  {
   return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CMyExpert::NewBar(void)
  {

   static datetime lastbar=0;
   datetime curbar;
   curbar=(datetime)SeriesInfoInteger(Symbol(),0,SERIES_FIRSTDATE);
   if(lastbar!=curbar)
     {
      lastbar=curbar;
      return(true);
     }
   else
     {
      return(false);
     }
  }