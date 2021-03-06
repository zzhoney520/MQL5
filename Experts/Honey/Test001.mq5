//+------------------------------------------------------------------+
//|                                                      Test001.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//|Define                                                            |
//+------------------------------------------------------------------+
#define BR     "\r\n"
//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Expert\Expert.mqh>
//--- available signals
#include <Expert\Signal\SignalStoch.mqh>
#include <Expert\Signal\SignalDEMA.mqh>
//--- available trailing
#include <Expert\Trailing\TrailingMA.mqh>
//--- available money management
#include <Expert\Money\MoneySizeOptimized.mqh>
//---自定义头文件2
#include <CreateButton.mqh>
#include <CreateLabel.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
//---全局变量
ulong      Expert_MagicNumber                =14090;       // 
bool       Expert_EveryTick                  =false;       // 
string     Title_Array[]={"当前盈亏:","总手数:","保证金:","保证金比率:","平仓总利润:","挂单数量:","当前净值:"};
int        tick_count=0;

//--- inputs for expert
input string             Expert_Title="==========EA参数==========";   // Document name
//--- inputs for main signal
input int                Signal_ThresholdOpen              =10;          // Signal threshold value to open [0...100]
input int                Signal_ThresholdClose             =10;          // Signal threshold value to close [0...100]
input double             Signal_PriceLevel                 =0.0;         // Price level to execute a deal
input double             Signal_StopLevel                  =50.0;        // Stop Loss level (in points)
input double             Signal_TakeLevel                  =50.0;        // Take Profit level (in points)
input int                Signal_Expiration                 =4;           // Expiration of pending orders (in bars)
input int                Signal_Stoch_PeriodK              =8;           // Stochastic(8,3,3,...) K-period
input int                Signal_Stoch_PeriodD              =3;           // Stochastic(8,3,3,...) D-period
input int                Signal_Stoch_PeriodSlow           =3;           // Stochastic(8,3,3,...) Period of slowing
input ENUM_STO_PRICE     Signal_Stoch_Applied              =STO_LOWHIGH; // Stochastic(8,3,3,...) Prices to apply to
input double             Signal_Stoch_Weight               =1.0;         // Stochastic(8,3,3,...) Weight [0...1.0]
input int                Signal_DEMA_PeriodMA              =12;          // Double Exponential Moving Average Period of averaging
input int                Signal_DEMA_Shift                 =0;           // Double Exponential Moving Average Time shift
input ENUM_APPLIED_PRICE Signal_DEMA_Applied               =PRICE_CLOSE; // Double Exponential Moving Average Prices series
input double             Signal_DEMA_Weight                =1.0;         // Double Exponential Moving Average Weight [0...1.0]
//--- inputs for trailing
input int                Trailing_MA_Period                =12;          // Period of MA
input int                Trailing_MA_Shift                 =0;           // Shift of MA
input ENUM_MA_METHOD     Trailing_MA_Method                =MODE_SMA;    // Method of averaging
input ENUM_APPLIED_PRICE Trailing_MA_Applied               =PRICE_CLOSE; // Prices series
//--- inputs for money
input double             Money_SizeOptimized_DecreaseFactor=3.0;         // Decrease factor
input double             Money_SizeOptimized_Percent       =10.0;        // Percent

input string             Separator="===========系统参数==========";
input int                Label_Base_X                      =320;
input int                Label_Base_Y                      =80;
input int                Label_H_Gap                       =180;
input int                Label_V_Gap                       =40;
//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
CExpert ExtExpert;
//+------------------------------------------------------------------+
//| Initialization function of the expert                            |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- Initializing expert
   if(!ExtExpert.Init(Symbol(),Period(),Expert_EveryTick,Expert_MagicNumber))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing expert");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Creating signal
   CExpertSignal *signal=new CExpertSignal;
   if(signal==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating signal");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//---
   ExtExpert.InitSignal(signal);
   signal.ThresholdOpen(Signal_ThresholdOpen);
   signal.ThresholdClose(Signal_ThresholdClose);
   signal.PriceLevel(Signal_PriceLevel);
   signal.StopLevel(Signal_StopLevel);
   signal.TakeLevel(Signal_TakeLevel);
   signal.Expiration(Signal_Expiration);
//--- Creating filter CSignalStoch
   CSignalStoch *filter0=new CSignalStoch;
   if(filter0==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter0");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter0);
//--- Set filter parameters
   filter0.PeriodK(Signal_Stoch_PeriodK);
   filter0.PeriodD(Signal_Stoch_PeriodD);
   filter0.PeriodSlow(Signal_Stoch_PeriodSlow);
   filter0.Applied(Signal_Stoch_Applied);
   filter0.Weight(Signal_Stoch_Weight);
//--- Creating filter CSignalDEMA
   CSignalDEMA *filter1=new CSignalDEMA;
   if(filter1==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating filter1");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
   signal.AddFilter(filter1);
//--- Set filter parameters
   filter1.PeriodMA(Signal_DEMA_PeriodMA);
   filter1.Shift(Signal_DEMA_Shift);
   filter1.Applied(Signal_DEMA_Applied);
   filter1.Weight(Signal_DEMA_Weight);
//--- Creation of trailing object
   CTrailingMA *trailing=new CTrailingMA;
   if(trailing==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating trailing");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Add trailing to expert (will be deleted automatically))
   if(!ExtExpert.InitTrailing(trailing))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing trailing");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Set trailing parameters
   trailing.Period(Trailing_MA_Period);
   trailing.Shift(Trailing_MA_Shift);
   trailing.Method(Trailing_MA_Method);
   trailing.Applied(Trailing_MA_Applied);
//--- Creation of money object
   CMoneySizeOptimized *money=new CMoneySizeOptimized;
   if(money==NULL)
     {
      //--- failed
      printf(__FUNCTION__+": error creating money");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Add money to expert (will be deleted automatically))
   if(!ExtExpert.InitMoney(money))
     {
      //--- failed
      printf(__FUNCTION__+": error initializing money");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Set money parameters
   money.DecreaseFactor(Money_SizeOptimized_DecreaseFactor);
   money.Percent(Money_SizeOptimized_Percent);
//--- Check all trading objects parameters
   if(!ExtExpert.ValidationSettings())
     {
      //--- failed
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//--- Tuning of all necessary indicators
   if(!ExtExpert.InitIndicators())
     {
      //--- failed
      printf(__FUNCTION__+": error initializing indicators");
      ExtExpert.Deinit();
      return(INIT_FAILED);
     }
//---初始化图表
   InitialChart();
   ClearAllObjects();
   CreateLabelGroup();
   ButtonCreate("Button1","一键全平",260,50);

//--- OK
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

   ClearAllObjects();
   ExtExpert.Deinit();

  }
//+------------------------------------------------------------------+
//| "Tick" event handler function                                    |
//+------------------------------------------------------------------+
void OnTick()
  {

   ExtExpert.OnTick();
//---显示信息列表
   RefreshLabels();
//---显示Comments
   RefreshComments();

  }
//+------------------------------------------------------------------+
//| "Trade" event handler function                                   |
//+------------------------------------------------------------------+
void OnTrade()
  {
   ExtExpert.OnTrade();
  }
//+------------------------------------------------------------------+
//| "Timer" event handler function                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
   ExtExpert.OnTimer();
  }
//+------------------------------------------------------------------+
//| 初始化图表                                                                 |
//+------------------------------------------------------------------+
void InitialChart(void)
  {

   ChartSetInteger(0,CHART_AUTOSCROLL,true);
   ChartSetInteger(0,CHART_SHIFT,true);
   ChartSetInteger(0,CHART_MODE,CHART_CANDLES);
   ChartSetInteger(0,CHART_SCALE,3);
   ChartSetInteger(0,CHART_SHOW_GRID,false);
   ChartSetInteger(0,CHART_SHOW_VOLUMES,false);
   ChartSetInteger(0,CHART_SHOW_BID_LINE,true);
   ChartSetInteger(0,CHART_SHOW_ASK_LINE,false);
   ChartSetInteger(0,CHART_SHOW_PERIOD_SEP,false);
   ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,false);
   ChartSetInteger(0,CHART_WINDOWS_TOTAL,1);
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrBlack);
   ChartSetDouble(0,CHART_SHIFT_SIZE,20);
   ChartRedraw();

  }
//+------------------------------------------------------------------+
//|建立Label组                                                       |
//+------------------------------------------------------------------+
void CreateLabelGroup()
  {

   int Count;
   Count=ArraySize(Title_Array);
   string Title="Title";
   for(int i=0;i<Count;i++)
     {
      Title="Title"+IntegerToString(i+1);
      LabelCreate(Title,Title_Array[i],Label_Base_X,Label_Base_Y+Label_V_Gap*i,"楷体",clrRed);
     }
   string Label="Label";
   for(int i=0;i<Count;i++)
     {
      Label="Label"+IntegerToString(i+1);
      LabelCreate(Label,Label,Label_Base_X-Label_H_Gap,Label_Base_Y+Label_V_Gap*i,"Times New Roman",clrWhite);
     }
   ChartRedraw();

  }
//+------------------------------------------------------------------+
//|获取当前总利润                                                    |
//+------------------------------------------------------------------+
void RefreshLabels(void)
  {
   double CurrentProfit=AccountInfoDouble(ACCOUNT_PROFIT);
   double CurrentEquity=AccountInfoDouble(ACCOUNT_EQUITY);

   ObjectSetString(0,"Label1",OBJPROP_TEXT,DoubleToString(CurrentProfit,2));
   ObjectSetString(0,"Label2",OBJPROP_TEXT,DoubleToString(GetTotalLots(),2));
   ObjectSetString(0,"Label7",OBJPROP_TEXT,DoubleToString(CurrentEquity,2));

  }
//+------------------------------------------------------------------+
//|删除所有物件对象                                                  |
//+------------------------------------------------------------------+
void ClearAllObjects(void)
  {

   ObjectsDeleteAll(0);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(sparam=="Button1")
        {
         if(MessageBox("确定要删除所有订单？","警告",MB_YESNO+MB_ICONQUESTION)==IDYES)
           {
            ClearAllPositons();
            ClearAllOrders();
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|获得总手数                                                        |
//+------------------------------------------------------------------+
double GetTotalLots(void)
  {

   CPositionInfo position;
   double totallots=0.0;
   uint total=PositionsTotal();
   for(uint i=0; i<total; i++)
     {
      position.SelectByIndex(i);
      totallots+=position.Volume();
     }
   return(totallots);

  }
//+------------------------------------------------------------------+
//|清除所有Positions                                                 |
//+------------------------------------------------------------------+
void ClearAllPositons(void)
  {

   CPositionInfo position;
   CTrade trade;
   while(PositionsTotal()!=0)
     {
      for(int i=0;i<PositionsTotal(); i++)
        {
         position.SelectByIndex(i);
         trade.PositionClose(position.Ticket());
        }
     }

  }
//+------------------------------------------------------------------+
//|清除所有挂单                                                      |
//+------------------------------------------------------------------+
void ClearAllOrders(void)
  {

   COrderInfo order;
   CTrade trade;
   while(OrdersTotal()!=0)
     {
      for(int i=0;i<OrdersTotal(); i++)
        {
         order.SelectByIndex(i);
         trade.OrderDelete(order.Ticket());
        }
     }

  }
//+------------------------------------------------------------------+
//|显示账户信息                                                      |
//+------------------------------------------------------------------+
void RefreshComments(void)
  {

   CAccountInfo account;
   CPositionInfo position;
   string account_info;
   account_info="账号: "+IntegerToString(account.Login());
   account_info+=BR;
   account_info+="用户名: "+account.Name();
   account_info+=BR;
   account_info+="服务器: "+account.Server();
   account_info+=BR;
   account_info+="交易商: "+account.Company();
   account_info+=BR;
   ENUM_ACCOUNT_TRADE_MODE account_type=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
   string trade_mode;
   switch(account_type)
     {
      case  ACCOUNT_TRADE_MODE_DEMO:
         trade_mode="模拟账户";
         break;
      case  ACCOUNT_TRADE_MODE_CONTEST:
         trade_mode="竞赛账户";
         break;
      default:
         trade_mode="真实账户";
         break;
     }
   account_info+="账户类型: "+trade_mode;
   account_info+=BR;
   account_info+="杠杆大小: "+IntegerToString(account.Leverage());
   account_info+=BR;
   account_info+="总订单数量: "+IntegerToString(PositionsTotal());
   Comment(account_info);

  }
//+------------------------------------------------------------------+
