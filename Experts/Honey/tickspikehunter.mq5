//+------------------------------------------------------------------+
//|                                              TickSpikeHunter.mq5 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   2
//--- plot TickPrice
#property indicator_label1  "TickPrice"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrGreen
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Signal
#property indicator_label2  "Signal"
#property indicator_type2   DRAW_COLOR_ARROW
#property indicator_color2  clrRed,clrBlue,C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0',C'0,0,0'
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- input parameters
input int      ticks=50;            // количество тиков в расчетах
input int      shift=200;           // кол-во сдвигаемых значений
input double   gap=3.0;             // ширина канала в сигмах
input bool     optimizeCalc=true;   // оптимизировать вычисления
//--- indicator buffers
double         TickPriceBuffer[];
double         SignalBuffer[];
double         SignalColors[];
double         DeltaTickBuffer[];
//--- counter of price changes
int ticks_counter;
//--- the first indicator call
bool first;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,TickPriceBuffer,INDICATOR_DATA);
   SetIndexBuffer(1,SignalBuffer,INDICATOR_DATA);
   SetIndexBuffer(2,SignalColors,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(3,DeltaTickBuffer,INDICATOR_CALCULATIONS);
//--- set empty values, which should be ignored when plotting  
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0);
   PlotIndexSetDouble(1,PLOT_EMPTY_VALUE,0);
//--- the signals will output as this icon
   PlotIndexSetInteger(1,PLOT_ARROW,159);
//--- initialization of global variables
   ticks_counter=0;
   first=true;
//--- program initialization succeeded
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//--- zero the indicator buffers and set the series flag during the first call
   if(first)
     {
      ZeroMemory(TickPriceBuffer);
      ZeroMemory(SignalBuffer);
      ZeroMemory(SignalColors);
      ZeroMemory(DeltaTickBuffer);
      //--- series arrays are directed backwards, it is more convenient in this case
      ArraySetAsSeries(SignalBuffer,true);
      ArraySetAsSeries(TickPriceBuffer,true);
      ArraySetAsSeries(SignalColors,true);
      ArraySetAsSeries(DeltaTickBuffer,true);
      first=false;
     }
//--- use the current Close value as the price
   double lastprice=close[rates_total-1];
//--- отладка и профилировка
   if(IS_DEBUG_MODE)
     {
      //--- второй способ получить цену Bid
      double lastpricedouble=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      //--- третий способ получить цену Bid
      MqlTick tick;
      SymbolInfoTick(_Symbol,tick);
      double lastpricetick=tick.bid;
     }
//--- calculate only if the price changed
   if(lastprice!=TickPriceBuffer[0])
     {
      //--- Count ticks
      ticks_counter++;
      ApplyTick(lastprice); // проведем вычисления и сдвиг в буферах         
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| применяет тик для вычислений                                     |
//+------------------------------------------------------------------+
void ApplyTick(double price)
  {
//--- store the size of the TickPriceBuffer array - it is equal to the number of bars on the chart
   static int prev_size=-1;
   int size=ArraySize(TickPriceBuffer);
//--- if the size of the indicator buffers did not change, shift all elements backwards by 1 position
   if(size==prev_size)
     {
      //--- the number of elements to be shifted in the indicator buffers on each tick
      int move=size-1;
      if(shift!=0) move=shift;
      ArrayCopy(TickPriceBuffer,TickPriceBuffer,1,0,move);
      ArrayCopy(SignalBuffer,SignalBuffer,1,0,move);
      ArrayCopy(SignalColors,SignalColors,1,0,move);
      ArrayCopy(DeltaTickBuffer,DeltaTickBuffer,1,0,move);
     }
   else
      prev_size=size;
//--- store the latest price value
   TickPriceBuffer[0]=price;
//--- calculate the difference with the previous value
   DeltaTickBuffer[0]=TickPriceBuffer[0]-TickPriceBuffer[1];
//--- получим ср. square. deviation
   double stddev;
   if(optimizeCalc)
      stddev=getStdDevOptimized(ticks);
   else
      stddev=getStdDev(ticks);
//--- если  изменение цены превысило заданный порог
   if(MathAbs(DeltaTickBuffer[0])>gap*stddev) // при первом тике будет показан сигнал, оставим как фичу
     {
      SignalBuffer[0]=price;     // place a dot
      string col="Red";          // the dot is red by default
      if(DeltaTickBuffer[0]>0)   // price rose sharply
        {
         SignalColors[0]=1;      // then the dot is blue
         col="Blue";             // store for logging
        }
      else                       // price fell sharply
      SignalColors[0]=0;         // the dot is red
      //--- output the message to the Experts journal
      PrintFormat("tick=%G change=%.1f pts, trigger=%.3f pts,  stddev=%.3f pts %s",
                  TickPriceBuffer[0],DeltaTickBuffer[0]/_Point,gap*stddev/_Point,stddev/_Point,col);
     }
   else SignalBuffer[0]=0;       // no signal   
  }
//+------------------------------------------------------------------+
//| calculates the standard deviation with "brute-force"             |
//+------------------------------------------------------------------+
double getStdDev(int number)
  {
   double summ=0,sum2=0,average,stddev;
//--- count the sum of changes and calculate the expected payoff
   for(int i=0;i<ticks;i++)
      summ+=DeltaTickBuffer[i];
   average=summ/ticks;
//--- now calculate the standard deviation
   sum2=0;
   for(int i=0;i<ticks;i++)
      sum2+=(DeltaTickBuffer[i]-average)*(DeltaTickBuffer[i]-average);
   stddev=MathSqrt(sum2/(number-1));
//--- debugging
   if(IS_DEBUG_MODE)
     {
      if(ticks_counter==1)
        {
         PrintFormat("summ=%G  average=%G  sum2=%G",summ,average,sum2);
         for(int i=0;i<ticks;i++)
           {
            PrintFormat("TickPriceBuffer[%d]=%G DeltaTickBuffer[%d]=%G",
                        i,TickPriceBuffer[i],i,DeltaTickBuffer[i]);
           }
        }
     }
//--- debugging example
   if(IS_DEBUG_MODE)
     {
      if(ticks_counter==1)
        {
         PrintFormat("summ=%G  average=%G  sum2=%G",summ,average,sum2);
         for(int i=0;i<ticks;i++)
           {
            PrintFormat("TickPriceBuffer[%d]=%G DeltaTickBuffer[%d]=%G",
                        i,TickPriceBuffer[i],i,DeltaTickBuffer[i]);
           }
        }
     }
//---
   return (stddev);
  }
//+------------------------------------------------------------------+
//| calculates the standard deviation based on formulas              |
//+------------------------------------------------------------------+
double getStdDevOptimized(int number)
  {
//---
   static double X2[],X[],X2sum=0,Xsum=0;
   static bool firstcall=true;
//--- the first call
   if(firstcall)
     {
      //--- set the sizes of dynamic arrays as greater than the number of ticks by 1
      ArrayResize(X2,ticks+1);
      ArrayResize(X,ticks+1);
      //--- guarantees non-zero values at the beginning of calculations
      ZeroMemory(X2);
      ZeroMemory(X);

      firstcall=false;
     }
//--- shift arrays
   ArrayCopy(X,X,1,0,ticks);
   ArrayCopy(X2,X2,1,0,ticks);
//--- calculates the new incoming values of sums
   X[0]=DeltaTickBuffer[0];
   X2[0]=DeltaTickBuffer[0]*DeltaTickBuffer[0];
//--- calculate the new sums
   Xsum=Xsum+X[0]-X[ticks];
   X2sum=X2sum+X2[0]-X2[ticks];
//--- squared standard deviation
   double S2=(1.0/(ticks-1))*(X2sum-Xsum*Xsum/ticks);
//--- count the sum of ticks and calculate the expected payoff
   double stddev=MathSqrt(S2);
//---
   return (stddev);
  }
//+------------------------------------------------------------------+
