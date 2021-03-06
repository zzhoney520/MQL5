//+------------------------------------------------------------------+
//|                                                      Test001.mq5 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "MT5盯盘助手 Copyright 2018, 蓝色♀爱琴海VX: zzhoney"
#property link      "https://www.mql5.com"
#property version   "1.00"

//+------------------------------------------------------------------+
//|Define                                                            |
//+------------------------------------------------------------------+
#define   BR      "\r\n"
#define   Space   "  "
#define   TimeMode TIME_DATE|TIME_MINUTES|TIME_SECONDS
#define   Play_Sound_Welcome       PlaySound("goodboy.wav")
#define   Play_Sound_Bye           PlaySound("byebye.wav")
#define   Play_Sound_YouGotIt      PlaySound("yougotit.wav")
#define   Play_Sound_Okay          PlaySound("okay.wav")
#define   Play_Sound               PlaySound("Alert2.wav")


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
//---自定义头文件
#include <GlobalHead.mqh>
#include <MyExpert.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
//---全局变量
ulong      Expert_MagicNumber                =14090;       //
bool       Expert_EveryTick                  =false;       //
string     Title_Array[]=
  {
   "当前盈亏:","总手数:","已用预付款:","可用预付款:","预付款比率:","本货币盈亏:",
   "本货币手数:","本货币挂单:","总挂单数量:","全平设定值:","当前结余:","当前净值:","今日盈亏:"
  };
string      Symbol_Array[]= {"EURUSD","GBPUSD","USDJPY","USDCHF","USDCAD","AUDUSD","NZDUSD","GBPJPY","EURGBP","EURJPY","EURCHF","XAUUSD"};
string      BlankSpace=" ";
int         tick_count=0;
int         EventID_HeightChanged=5000;
int         EventID_WidthChanged=5001;
long        Chart_Height=0;
long        Chart_Width=0;
string      Equity_Set_Flag="(USD)";
string      Symbol_Profit_Flag=BlankSpace;
string      ENG_FONT="Arial";
int         ENG_FONT_SIZE=20;
string      CHS_FONT="楷体";
int         CHS_FONT_SIZE=20;

string      ENG_FONT_NB="Arial";
int         ENG_FONT_SIZE_NB=20;
string      CHS_FONT_NB="楷体";
int         CHS_FONT_SIZE_NB=20;
uint        ItemLength=21;

int         btnWidth=200;
int         btnHeight=50;
string      btnFont="JetBrains Mono";
int         btnFontSize=12;
string      lblFont="楷体";
int         lblFontSize=18;

int         btnWidth_nb=200;
int         btnHeight_nb=50;
string      btnFont_nb="JetBrains Mono";
int         btnFontSize_nb=12;
string      lblFont_nb="楷体";
int         lblFontSize_nb=18;

int Title_X_SIZE=280;
int Title_Y_SIZE=60;
int Label_X_SIZE=320;
int Label_Y_SIZE=60;

int labSvrTime_X=100;
int labSvrTime_Y=100;
int labSvrTime_X_SIZE=825;
int labSvrTime_Y_SIZE=60;

int ProfitList1_X=1200;
int ProfitList1_Y=100;
int ProfitList1_X_SIZE=2000;
int ProfitList1_Y_SIZE=60;

int ProfitList2_X=1200;
int ProfitList2_Y=160;
int ProfitList2_X_SIZE=2000;
int ProfitList2_Y_SIZE=60;

int ProfitList3_X=1200;
int ProfitList3_Y=220;
int ProfitList3_X_SIZE=2000;
int ProfitList3_Y_SIZE=60;

int LocalTime_X=1100;
int LocalTime_Y=100;
int LocalTime_X_SIZE=960;
int LocalTime_Y_SIZE=60;

int AmericaTime_X=1100;
int AmericaTime_Y=160;
int AmericaTime_X_SIZE=960;
int AmericaTime_Y_SIZE=60;

int SymbolName_X=50;
int SymbolName_Y=200;
int SymbolName_X_SIZE=390;
int SymbolName_Y_SIZE=100;

//--- inputs for expert
input string             Expert_Title="==========EA参数==========";   // Document name
input bool               DesktopSetting                    =true;
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

input string             Separator_1="===========自订参数==========";
input double             StopLoss                           =150;
input double             TakeProfit                         =200;
//--- settings button
input uint               Btn_Base_X                         =380;
input uint               Btn_Base_Y                         =50;
input uint               Btn_H_Gap                          =250;
input uint               Btn_V_Gap                          =50;
//--- set set tp/sl button
input uint               Btn_Base_X_2                       =80;
input uint               Btn_Base_Y_2                       =360;
input uint               Btn_H_Gap_2                        =200;
input uint               Btn_V_Gap_2                        =90;
//--- set clr Pro+/Pro- button
input uint               Btn_Base_X_3                       =300;
input uint               Btn_Base_Y_3                       =360;
input uint               Btn_H_Gap_3                        =200;
input uint               Btn_V_Gap_3                        =90;

//--- lable settings
input uint               Label_Base_X                       =630;
input uint               Label_Base_Y                       =70;
input uint               Label_H_Gap                        =300;
input uint               Label_V_Gap                        =60;

input string             Separator_2="===========挂单设置==========";
input uint               BuyLimitOrdersCounts               =5;
input double             BuyLimitOrdersLots                 =0.05;
input uint               BuyLimitOrdersDistance             =100;
input uint               BuyLimitOrdersGap                  =30;

input uint               SellLimitOrdersCounts              =5;
input double             SellLimitOrdersLots                =0.05;
input uint               SellLimitOrdersDistance            =100;
input uint               SellLimitOrdersGap                 =30;

input uint               Symbol_Profit_Value=1000;        //单货币盈利平仓设定值
//+------------------------------------------------------------------+
//| Global expert object                                             |
//+------------------------------------------------------------------+
CMyExpert ExtExpert;
//+------------------------------------------------------------------+
//| Initialization function of the expert                            |
//+------------------------------------------------------------------+
int OnInit()
  {

//---调用定时器
   EventSetTimer(1);

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

//---Create All Control Buttons
   ButtonCreate("Button1","Clear All",Btn_Base_X,Btn_Base_Y,btnWidth,btnHeight,btnFont,btnFontSize,CORNER_LEFT_UPPER);
   ButtonCreate("Button2","Close Pos",Btn_Base_X+Btn_H_Gap,Btn_Base_Y,btnWidth,btnHeight,btnFont,btnFontSize,CORNER_LEFT_UPPER);
   ButtonCreate("Button3","BuyLimit",Btn_Base_X+Btn_H_Gap * 2,Btn_Base_Y,btnWidth,btnHeight,btnFont,btnFontSize,CORNER_LEFT_UPPER);
   ButtonCreate("Button4","SellLimit",Btn_Base_X+Btn_H_Gap * 3,Btn_Base_Y,btnWidth,btnHeight,btnFont,btnFontSize,CORNER_LEFT_UPPER);
   ButtonCreate("Button5","DelOrders",Btn_Base_X+Btn_H_Gap * 4,Btn_Base_Y,btnWidth,btnHeight,btnFont,btnFontSize,CORNER_LEFT_UPPER);
   ButtonCreate("Button6","ClrAllOrd",Btn_Base_X+Btn_H_Gap * 5,Btn_Base_Y,btnWidth,btnHeight,btnFont,btnFontSize,CORNER_LEFT_UPPER);

   ButtonCreate("SetTPSL","Set SL/TP",Btn_Base_X_2,Btn_Base_Y_2,btnWidth,btnHeight,btnFont,btnFontSize,CORNER_LEFT_LOWER);
   ButtonCreate("ClrTPSL","Clr SL/TP",Btn_Base_X_2,Btn_Base_Y_2 - Btn_V_Gap_2,btnWidth,btnHeight,btnFont,btnFontSize,CORNER_LEFT_LOWER);
   ButtonCreate("ClrPro+","Clr Pro+",Btn_Base_X_3,Btn_Base_Y_3,btnWidth,btnHeight,btnFont,btnFontSize,CORNER_RIGHT_LOWER);
   ButtonCreate("ClrPro-","Clr Pro-",Btn_Base_X_3,Btn_Base_Y_3 - Btn_V_Gap_3,btnWidth,btnHeight,btnFont,btnFontSize,CORNER_RIGHT_LOWER);

   Chart_Width=ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
   Chart_Height=ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);

   ChartRedraw();

//---创建全局变量
   CreateGlobalVar();
   if(!GlobalVariableCheck("Clear_All_Equity"))
     {
      Alert("请设置[Clear_All_Equity]全局变量！");
     }
   else
     {
      if(AccountInfoDouble(ACCOUNT_EQUITY)>GlobalVariableGet("Clear_All_Equity"))
         GlobalVariableSet("Clear_All_Equity",10000);
     }
//--- play sound for alert
// Play_Sound_Welcome;

//--- OK
   return(INIT_SUCCEEDED);

  }

//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

   ClearAllObjects();
   ClearComments();
   ExtExpert.Deinit();

   EventKillTimer();
   GlobalVariableSet("Exit_Equity",AccountInfoDouble(ACCOUNT_EQUITY));

  }
//+------------------------------------------------------------------+
//| "Tick" event handler function                                    |
//+------------------------------------------------------------------+
void OnTick()
  {

//ExtExpert.OnTick();


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
//---刷新服务器时间
   RefreshCurrentTime();
//---显示信息列表
   RefreshLabels();
//---显示Comments
   RefreshComments();
//---更新左下角货币Label
   CheckSymbolNameLabel();
//---重绘
   ChartRedraw();
//---检查单货币利润是否到达设定平仓值
   CheckSymbolProfitClear();
//---检查净值是否到达设定全部平仓值
   CheckReachSetEquity();
//---显示利润列表
   RefreshProfitList();

//   MakeLabelFlash("RectLabel1");


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
   ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,true);
   ChartSetInteger(0,CHART_WINDOWS_TOTAL,1);
   ChartSetInteger(0,CHART_COLOR_BACKGROUND,clrBlack);
   ChartSetDouble(0,CHART_SHIFT_SIZE,30);
//---K线颜色设置
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrRed);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrLime);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrRed);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrLime);

   ChartRedraw();

  }
//+------------------------------------------------------------------+
//|建立Label组                                                       |
//+------------------------------------------------------------------+
void CreateLabelGroup()
  {

//--- 桌面设置
   if(DesktopSetting==true)
     {

      int Count;
      Count=ArraySize(Title_Array);
      string Title="Title";
      for(int i=0; i<Count; i++)
        {
         Title="Title"+IntegerToString(i+1);
         LabelCreate(Title,Title_Array[i],Label_Base_X,Label_Base_Y+Label_V_Gap*i,lblFont,lblFontSize,CORNER_RIGHT_UPPER,clrRed);
         ObjectSetInteger(0,"Rect"+Title,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetInteger(0,"Rect"+Title,OBJPROP_XDISTANCE,Label_Base_X+5);
         ObjectSetInteger(0,"Rect"+Title,OBJPROP_YDISTANCE,Label_Base_Y+Label_V_Gap*i-3);
         ObjectSetInteger(0,"Rect"+Title,OBJPROP_XSIZE,Title_X_SIZE);
         ObjectSetInteger(0,"Rect"+Title,OBJPROP_YSIZE,Title_Y_SIZE);

        }
      string Label="Label";
      for(int i=0; i<Count; i++)
        {
         Label="Label"+IntegerToString(i+1);
         LabelCreate(Label,Label,Label_Base_X-Label_H_Gap,Label_Base_Y+Label_V_Gap*i,ENG_FONT,lblFontSize,CORNER_RIGHT_UPPER,clrWhite);
         ObjectSetInteger(0,"Rect"+Label,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetInteger(0,"Rect"+Label,OBJPROP_XDISTANCE,Label_Base_X-Label_H_Gap+5);
         ObjectSetInteger(0,"Rect"+Label,OBJPROP_YDISTANCE,Label_Base_Y+Label_V_Gap*i-3);
         ObjectSetInteger(0,"Rect"+Label,OBJPROP_XSIZE,Label_X_SIZE);
         ObjectSetInteger(0,"Rect"+Label,OBJPROP_YSIZE,Label_Y_SIZE);

        }
      //--- 当前盈亏lable设置
      ObjectSetInteger(0,"Label1",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0,"Label1",OBJPROP_FONTSIZE,22);
      ObjectSetString(0,"Label1",OBJPROP_FONT,ENG_FONT);
      long label_distance=ObjectGetInteger(0,"Label1",OBJPROP_YDISTANCE);
      ObjectSetInteger(0,"Label1",OBJPROP_YDISTANCE,long(label_distance-10));
      ObjectSetInteger(0,"RectLabel1",OBJPROP_XDISTANCE,ObjectGetInteger(0,"RectLabel1",OBJPROP_XDISTANCE));
      ObjectSetInteger(0,"RectLabel1",OBJPROP_YDISTANCE,ObjectGetInteger(0,"RectLabel1",OBJPROP_YDISTANCE)-5);
      ObjectSetInteger(0,"RectLabel1",OBJPROP_XSIZE,Label_X_SIZE);
      ObjectSetInteger(0,"RectLabel1",OBJPROP_YSIZE,Label_Y_SIZE);

      ObjectSetInteger(0,"Label1",OBJPROP_COLOR,clrMagenta);
      ObjectSetInteger(0,"Label2",OBJPROP_COLOR,clrYellow);
      ObjectSetInteger(0,"Label6",OBJPROP_COLOR,clrMagenta);
      ObjectSetInteger(0,"Label7",OBJPROP_COLOR,clrYellow);
      ObjectSetInteger(0,"Label11",OBJPROP_COLOR,clrDeepPink);
      ObjectSetInteger(0,"Label12",OBJPROP_COLOR,clrLime);

      long ChartWidth=ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
      int  xPos=int(ChartWidth * 0.45);
      LabelCreate("labSvrTime",BlankSpace,xPos,60,CHS_FONT,lblFontSize,CORNER_LEFT_UPPER,clrWhite);
      ObjectSetInteger(0,"RectlabSvrTime",OBJPROP_XDISTANCE,xPos-5);
      ObjectSetInteger(0,"RectlabSvrTime",OBJPROP_YDISTANCE,labSvrTime_Y-5);
      ObjectSetInteger(0,"RectlabSvrTime",OBJPROP_XSIZE,labSvrTime_X_SIZE);
      ObjectSetInteger(0,"RectlabSvrTime",OBJPROP_YSIZE,labSvrTime_Y_SIZE);

      LabelCreate("ProfitList1"," ",ProfitList1_X,ProfitList1_Y,ENG_FONT,lblFontSize,CORNER_LEFT_LOWER,clrWhite);
      ObjectSetInteger(0,"RectProfitList1",OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,"RectProfitList1",OBJPROP_XDISTANCE,ProfitList1_X+5);
      ObjectSetInteger(0,"RectProfitList1",OBJPROP_YDISTANCE,ProfitList1_Y-3);
      ObjectSetInteger(0,"RectProfitList1",OBJPROP_XSIZE,ProfitList1_X_SIZE);
      ObjectSetInteger(0,"RectProfitList1",OBJPROP_YSIZE,ProfitList1_Y_SIZE);
      LabelCreate("ProfitList2"," ",ProfitList2_X,ProfitList2_Y,ENG_FONT,lblFontSize,CORNER_LEFT_LOWER,clrWhite);
      ObjectSetInteger(0,"RectProfitList2",OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,"RectProfitList2",OBJPROP_XDISTANCE,ProfitList2_X+5);
      ObjectSetInteger(0,"RectProfitList2",OBJPROP_YDISTANCE,ProfitList2_Y-3);
      ObjectSetInteger(0,"RectProfitList2",OBJPROP_XSIZE,ProfitList2_X_SIZE);
      ObjectSetInteger(0,"RectProfitList2",OBJPROP_YSIZE,ProfitList2_Y_SIZE);
      LabelCreate("ProfitList3"," ",ProfitList3_X,ProfitList3_Y,ENG_FONT,lblFontSize,CORNER_LEFT_LOWER,clrWhite);
      ObjectSetInteger(0,"RectProfitList3",OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,"RectProfitList3",OBJPROP_XDISTANCE,ProfitList3_X+5);
      ObjectSetInteger(0,"RectProfitList3",OBJPROP_YDISTANCE,ProfitList3_Y-3);
      ObjectSetInteger(0,"RectProfitList3",OBJPROP_XSIZE,ProfitList3_X_SIZE);
      ObjectSetInteger(0,"RectProfitList3",OBJPROP_YSIZE,ProfitList3_Y_SIZE);

      LabelCreate("LocalTime"," ",LocalTime_X,LocalTime_Y,CHS_FONT,lblFontSize,CORNER_RIGHT_LOWER,clrWhite);
      ObjectSetInteger(0,"RectLocalTime",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
      ObjectSetInteger(0,"RectLocalTime",OBJPROP_XDISTANCE,LocalTime_X+5);
      ObjectSetInteger(0,"RectLocalTime",OBJPROP_YDISTANCE,LocalTime_Y+3);
      ObjectSetInteger(0,"RectLocalTime",OBJPROP_XSIZE,LocalTime_X_SIZE);
      ObjectSetInteger(0,"RectLocalTime",OBJPROP_YSIZE,LocalTime_Y_SIZE);

      LabelCreate("AmericaTime"," ",AmericaTime_X,AmericaTime_Y,CHS_FONT,lblFontSize,CORNER_RIGHT_LOWER,clrWhite);
      ObjectSetInteger(0,"RectAmericaTime",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
      ObjectSetInteger(0,"RectAmericaTime",OBJPROP_XDISTANCE,AmericaTime_X+5);
      ObjectSetInteger(0,"RectAmericaTime",OBJPROP_YDISTANCE,AmericaTime_Y+5);
      ObjectSetInteger(0,"RectAmericaTime",OBJPROP_XSIZE,AmericaTime_X_SIZE);
      ObjectSetInteger(0,"RectAmericaTime",OBJPROP_YSIZE,AmericaTime_Y_SIZE);

      LabelCreate("SymbolNameShow"," ",SymbolName_X,SymbolName_Y,"Stencil",lblFontSize,CORNER_LEFT_LOWER,clrAqua);
      ObjectSetInteger(0,"SymbolNameShow",OBJPROP_FONTSIZE,36);
      ObjectSetString(0,"SymbolNameShow",OBJPROP_TEXT,Symbol());
      ObjectSetInteger(0,"RectSymbolNameShow",OBJPROP_XDISTANCE,SymbolName_X-5);
      ObjectSetInteger(0,"RectSymbolNameShow",OBJPROP_YDISTANCE,SymbolName_Y-5);
      ObjectSetInteger(0,"RectSymbolNameShow",OBJPROP_XSIZE,SymbolName_X_SIZE);
      ObjectSetInteger(0,"RectSymbolNameShow",OBJPROP_YSIZE,SymbolName_Y_SIZE);

      ChartRedraw(0);

     }
//--- 笔记本设置
   else
     {

      int Count;
      Count=ArraySize(Title_Array);
      string Title="Title";
      for(int i=0; i<Count; i++)
        {
         Title="Title"+IntegerToString(i+1);
         LabelCreate(Title,Title_Array[i],Label_Base_X,Label_Base_Y+Label_V_Gap*i,lblFont,lblFontSize,CORNER_RIGHT_UPPER,clrRed);
         ObjectSetInteger(0,"Rect"+Title,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetInteger(0,"Rect"+Title,OBJPROP_XDISTANCE,Label_Base_X+5);
         ObjectSetInteger(0,"Rect"+Title,OBJPROP_YDISTANCE,Label_Base_Y+Label_V_Gap*i-3);
         ObjectSetInteger(0,"Rect"+Title,OBJPROP_XSIZE,Title_X_SIZE);
         ObjectSetInteger(0,"Rect"+Title,OBJPROP_YSIZE,Title_Y_SIZE);

        }
      string Label="Label";
      for(int i=0; i<Count; i++)
        {
         Label="Label"+IntegerToString(i+1);
         LabelCreate(Label,Label,Label_Base_X-Label_H_Gap,Label_Base_Y+Label_V_Gap*i,ENG_FONT,lblFontSize,CORNER_RIGHT_UPPER,clrWhite);
         ObjectSetInteger(0,"Rect"+Label,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
         ObjectSetInteger(0,"Rect"+Label,OBJPROP_XDISTANCE,Label_Base_X-Label_H_Gap+5);
         ObjectSetInteger(0,"Rect"+Label,OBJPROP_YDISTANCE,Label_Base_Y+Label_V_Gap*i-3);
         ObjectSetInteger(0,"Rect"+Label,OBJPROP_XSIZE,Label_X_SIZE);
         ObjectSetInteger(0,"Rect"+Label,OBJPROP_YSIZE,Label_Y_SIZE);

        }
      //--- 当前盈亏lable设置
      ObjectSetInteger(0,"Label1",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
      ObjectSetInteger(0,"Label1",OBJPROP_FONTSIZE,22);
      ObjectSetString(0,"Label1",OBJPROP_FONT,ENG_FONT);
      long label_distance=ObjectGetInteger(0,"Label1",OBJPROP_YDISTANCE);
      ObjectSetInteger(0,"Label1",OBJPROP_YDISTANCE,long(label_distance-10));
      ObjectSetInteger(0,"RectLabel1",OBJPROP_XDISTANCE,ObjectGetInteger(0,"RectLabel1",OBJPROP_XDISTANCE));
      ObjectSetInteger(0,"RectLabel1",OBJPROP_YDISTANCE,ObjectGetInteger(0,"RectLabel1",OBJPROP_YDISTANCE)-5);
      ObjectSetInteger(0,"RectLabel1",OBJPROP_XSIZE,Label_X_SIZE);
      ObjectSetInteger(0,"RectLabel1",OBJPROP_YSIZE,Label_Y_SIZE);

      ObjectSetInteger(0,"Label1",OBJPROP_COLOR,clrMagenta);
      ObjectSetInteger(0,"Label2",OBJPROP_COLOR,clrYellow);
      ObjectSetInteger(0,"Label6",OBJPROP_COLOR,clrMagenta);
      ObjectSetInteger(0,"Label7",OBJPROP_COLOR,clrYellow);
      ObjectSetInteger(0,"Label11",OBJPROP_COLOR,clrDeepPink);
      ObjectSetInteger(0,"Label12",OBJPROP_COLOR,clrLime);

      long ChartWidth=ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
      int  xPos=int(ChartWidth * 0.45);
      LabelCreate("labSvrTime",BlankSpace,xPos,60,CHS_FONT,lblFontSize,CORNER_LEFT_UPPER,clrWhite);
      ObjectSetInteger(0,"RectlabSvrTime",OBJPROP_XDISTANCE,xPos-5);
      ObjectSetInteger(0,"RectlabSvrTime",OBJPROP_YDISTANCE,labSvrTime_Y-5);
      ObjectSetInteger(0,"RectlabSvrTime",OBJPROP_XSIZE,labSvrTime_X_SIZE);
      ObjectSetInteger(0,"RectlabSvrTime",OBJPROP_YSIZE,labSvrTime_Y_SIZE);

      LabelCreate("ProfitList1"," ",ProfitList1_X,ProfitList1_Y,ENG_FONT,lblFontSize,CORNER_LEFT_LOWER,clrWhite);
      ObjectSetInteger(0,"RectProfitList1",OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,"RectProfitList1",OBJPROP_XDISTANCE,ProfitList1_X+5);
      ObjectSetInteger(0,"RectProfitList1",OBJPROP_YDISTANCE,ProfitList1_Y-3);
      ObjectSetInteger(0,"RectProfitList1",OBJPROP_XSIZE,ProfitList1_X_SIZE);
      ObjectSetInteger(0,"RectProfitList1",OBJPROP_YSIZE,ProfitList1_Y_SIZE);
      LabelCreate("ProfitList2"," ",ProfitList2_X,ProfitList2_Y,ENG_FONT,lblFontSize,CORNER_LEFT_LOWER,clrWhite);
      ObjectSetInteger(0,"RectProfitList2",OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,"RectProfitList2",OBJPROP_XDISTANCE,ProfitList2_X+5);
      ObjectSetInteger(0,"RectProfitList2",OBJPROP_YDISTANCE,ProfitList2_Y-3);
      ObjectSetInteger(0,"RectProfitList2",OBJPROP_XSIZE,ProfitList2_X_SIZE);
      ObjectSetInteger(0,"RectProfitList2",OBJPROP_YSIZE,ProfitList2_Y_SIZE);
      LabelCreate("ProfitList3"," ",ProfitList3_X,ProfitList3_Y,ENG_FONT,lblFontSize,CORNER_LEFT_LOWER,clrWhite);
      ObjectSetInteger(0,"RectProfitList3",OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,"RectProfitList3",OBJPROP_XDISTANCE,ProfitList3_X+5);
      ObjectSetInteger(0,"RectProfitList3",OBJPROP_YDISTANCE,ProfitList3_Y-3);
      ObjectSetInteger(0,"RectProfitList3",OBJPROP_XSIZE,ProfitList3_X_SIZE);
      ObjectSetInteger(0,"RectProfitList3",OBJPROP_YSIZE,ProfitList3_Y_SIZE);

      LabelCreate("LocalTime"," ",LocalTime_X,LocalTime_Y,CHS_FONT,lblFontSize,CORNER_RIGHT_LOWER,clrWhite);
      ObjectSetInteger(0,"RectLocalTime",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
      ObjectSetInteger(0,"RectLocalTime",OBJPROP_XDISTANCE,LocalTime_X+5);
      ObjectSetInteger(0,"RectLocalTime",OBJPROP_YDISTANCE,LocalTime_Y+3);
      ObjectSetInteger(0,"RectLocalTime",OBJPROP_XSIZE,LocalTime_X_SIZE);
      ObjectSetInteger(0,"RectLocalTime",OBJPROP_YSIZE,LocalTime_Y_SIZE);

      LabelCreate("AmericaTime"," ",AmericaTime_X,AmericaTime_Y,CHS_FONT,lblFontSize,CORNER_RIGHT_LOWER,clrWhite);
      ObjectSetInteger(0,"RectAmericaTime",OBJPROP_CORNER,CORNER_RIGHT_LOWER);
      ObjectSetInteger(0,"RectAmericaTime",OBJPROP_XDISTANCE,AmericaTime_X+5);
      ObjectSetInteger(0,"RectAmericaTime",OBJPROP_YDISTANCE,AmericaTime_Y+5);
      ObjectSetInteger(0,"RectAmericaTime",OBJPROP_XSIZE,AmericaTime_X_SIZE);
      ObjectSetInteger(0,"RectAmericaTime",OBJPROP_YSIZE,AmericaTime_Y_SIZE);

      LabelCreate("SymbolName"," ",SymbolName_X,SymbolName_Y,"Stencil",lblFontSize,CORNER_LEFT_LOWER,clrAqua);
      ObjectSetInteger(0,"SymbolName",OBJPROP_FONTSIZE,36);
      ObjectSetString(0,"SymbolName",OBJPROP_TEXT,Symbol());
      ObjectSetInteger(0,"RectSymbolName",OBJPROP_CORNER,CORNER_LEFT_LOWER);
      ObjectSetInteger(0,"RectSymbolName",OBJPROP_XDISTANCE,SymbolName_X-5);
      ObjectSetInteger(0,"RectSymbolName",OBJPROP_YDISTANCE,SymbolName_Y-5);
      ObjectSetInteger(0,"RectSymbolName",OBJPROP_XSIZE,SymbolName_X_SIZE);
      ObjectSetInteger(0,"RectSymbolName",OBJPROP_YSIZE,SymbolName_Y_SIZE);

      ChartRedraw(0);

     }
  }
//+------------------------------------------------------------------+
//|获取当前总利润                                                    |
//+------------------------------------------------------------------+
void RefreshLabels(void)
  {

   double CurrentProfit=AccountInfoDouble(ACCOUNT_PROFIT);
   double CurrentEquity=AccountInfoDouble(ACCOUNT_EQUITY);
   double UsedMargin=AccountInfoDouble(ACCOUNT_MARGIN);
   double FreeMagrin=AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   double MarginLevel=AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
   string CU="("+AccountInfoString(ACCOUNT_CURRENCY)+")";
   double SymbolProfit=GetSymbolProfit();
   double SymbolLots=GetSymbolLots();
   int SymbolOrdersCount=GetSymbolOrdersCount();
   double TotalOrdersLots=GetTotalOrdersLots();
   double SymbolOrdersLots=GetSymbolOrdersLots();
   int OrdersCount=OrdersTotal();
   double TodayProfit=GetTodayProfit();
   double Balance=AccountInfoDouble(ACCOUNT_BALANCE);

   ObjectSetString(0,"Label1",OBJPROP_TEXT,DoubleToString(CurrentProfit,2));
   ObjectSetString(0,"Label2",OBJPROP_TEXT,DoubleToString(GetTotalLots(),2));
   ObjectSetString(0,"Label3",OBJPROP_TEXT,DoubleToString(UsedMargin,2));
   ObjectSetString(0,"Label4",OBJPROP_TEXT,DoubleToString(FreeMagrin,2));
   ObjectSetString(0,"Label5",OBJPROP_TEXT,DoubleToString(MarginLevel,2)+"%");
   ObjectSetString(0,"Label6",OBJPROP_TEXT,DoubleToString(SymbolProfit,2)+Symbol_Profit_Flag);
   ObjectSetString(0,"Label7",OBJPROP_TEXT,DoubleToString(SymbolLots,2));
   ObjectSetString(0,"Label8",OBJPROP_TEXT,IntegerToString(SymbolOrdersCount)+"("+DoubleToString(SymbolOrdersLots,2)+")");
   ObjectSetString(0,"Label9",OBJPROP_TEXT,IntegerToString(OrdersCount)+"("+DoubleToString(TotalOrdersLots,2)+")");
   ObjectSetString(0,"Label10",OBJPROP_TEXT,DoubleToString(GlobalVariableGet("Clear_All_Equity"),0)+Equity_Set_Flag);
   ObjectSetString(0,"Label11",OBJPROP_TEXT,DoubleToString(Balance,2)+CU);
   ObjectSetString(0,"Label12",OBJPROP_TEXT,DoubleToString(CurrentEquity,2)+CU);
   ObjectSetString(0,"Label13",OBJPROP_TEXT,DoubleToString(TodayProfit,2)+CU);

  }
//+------------------------------------------------------------------+
//|删除所有物件对象                                                  |
//+------------------------------------------------------------------+
void ClearAllObjects(void)
  {

   ObjectsDeleteAll(0);

  }
//+------------------------------------------------------------------+
//|事件处理                                                          |
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
         if(MessageBox("确定要删除所有持仓头寸？","警告",MB_YESNO+MB_ICONQUESTION)==IDYES)
           {
            ClearAllPositons();
           }

        }

      if(sparam=="Button2")
        {
         if(MessageBox("确定要平仓本货币对所有订单？","警告",MB_YESNO+MB_ICONQUESTION)==IDYES)
           {
            ClearSymbolPositions();
           }
        }
      if(sparam=="Button3")
        {
         SetBuyLimitOrdersGroup();
        }
      if(sparam=="Button4")
        {
         SetSellLimitOrdersGroup();
        }
      if(sparam=="Button5")
        {
         ClearSymbolOrders();
        }
      if(sparam=="Button6")
        {
         if(MessageBox("确定要删除所有挂单吗？","警告",MB_YESNO+MB_ICONQUESTION)==IDYES)
           {
            ClearPendingOrders();
           }
        }
      if(sparam=="SetTPSL")
        {
         SetTPSL();
        }
      if(sparam=="ClrTPSL")
        {
         if(MessageBox("确定要清除本货币对所有订单SL/TP位置？","警告",MB_YESNO+MB_ICONQUESTION)==IDYES)
           {
            ClrTPSL();
           }
        }
      if(sparam=="ClrPro+")
        {
         if(MessageBox("确定要平仓本货币对所有盈利订单？","警告",MB_YESNO+MB_ICONQUESTION)==IDYES)
           {
            ClrProfitPosition();
           }
        }
      if(sparam=="ClrPro-")
        {
         if(MessageBox("确定要平仓本货币对所有亏损订单？","警告",MB_YESNO+MB_ICONQUESTION)==IDYES)
           {
            ClrLossPosition();
           }
        }
     }

   if(id==CHARTEVENT_CHART_CHANGE)
     {
      long Cur_Chart_Height=ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
      if(Cur_Chart_Height!=Chart_Height)
        {
         ushort eventID=ushort(EventID_HeightChanged-CHARTEVENT_CUSTOM);
         EventChartCustom(0,eventID,Cur_Chart_Height-60,0,"Chart_Height_Changed");
         Chart_Height=Cur_Chart_Height;
        }

      long Cur_Chart_Width=ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
      if(Cur_Chart_Width!=Chart_Width)
        {
         ushort eventID=ushort(EventID_WidthChanged-CHARTEVENT_CUSTOM);
         long LabelSize=ObjectGetInteger(0,"labSvrTime",OBJPROP_XSIZE);
         int NewX=int((Cur_Chart_Width-LabelSize)/2);
         EventChartCustom(0,eventID,NewX,0,"Chart_Width_Changed");
         Chart_Width=Cur_Chart_Width;
        }

     }

   if(id>CHARTEVENT_CUSTOM)
     {
      if(id==EventID_HeightChanged && lparam>60)
        {
         //ObjectSetInteger(0,"LocalTime",OBJPROP_YDISTANCE,lparam);
         ObjectSetInteger(0,"SymbolName",OBJPROP_YDISTANCE,20);
        }
      if(id==EventID_WidthChanged)
        {
         ObjectSetInteger(0,"labSvrTime",OBJPROP_CORNER,CORNER_LEFT_UPPER);
         ObjectSetInteger(0,"labSvrTime",OBJPROP_ANCHOR,ANCHOR_LEFT_UPPER);
         ObjectSetInteger(0,"labSvrTime",OBJPROP_XDISTANCE,lparam);
         ObjectSetInteger(0,"SymbolName",OBJPROP_XDISTANCE,30);
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
//|本货币手数                                                                  |
//+------------------------------------------------------------------+
double GetSymbolLots(void)
  {

   CPositionInfo position;
   double symbollots=0.0;
   for(int i=0; i<PositionsTotal(); i++)
     {
      if(position.SelectByIndex(i))
        {
         if(position.Symbol()==Symbol())
           {
            symbollots+=position.Volume();
           }
        }
     }
   return(symbollots);

  }
//+------------------------------------------------------------------+
//|清除所有Positions                                                 |
//+------------------------------------------------------------------+
void ClearAllPositons(void)
  {

   CPositionInfo position;
   CTrade trade;
   while(PositionsTotal()>0)
     {
      for(int i=0; i<PositionsTotal(); i++)
        {
         if(position.SelectByIndex(i))
           {
            trade.PositionClose(position.Ticket());
           }
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
      for(int i=0; i<OrdersTotal(); i++)
        {
         if(order.SelectByIndex(i))
           {
            trade.OrderDelete(order.Ticket());
           }
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
//|清除图表Comment                                                                  |
//+------------------------------------------------------------------+
void ClearComments(void)
  {

   Comment(BlankSpace);

  }
//+------------------------------------------------------------------+
//|计算总利润                                                        |
//+------------------------------------------------------------------+
double GetTotalProfit(void)
  {

   CPositionInfo position;
   double totalprofit=0;
   for(int i=0; i<PositionsTotal(); i++)
     {
      position.SelectByIndex(i);
      totalprofit+=position.Profit();
     }
   return(totalprofit);

  }
//+------------------------------------------------------------------+
//|刷新服务器时间                                                    |
//+------------------------------------------------------------------+
void RefreshCurrentTime(void)
  {

   MqlDateTime today;
   string todayname;
   TimeToStruct(TimeCurrent(),today);
   switch(today.day_of_week)
     {
      case 0:
         todayname=" (星期天)";
         break;
      case 1:
         todayname=" (星期一)";
         break;
      case 2:
         todayname=" (星期二)";
         break;
      case 3:
         todayname=" (星期三)";
         break;
      case 4:
         todayname=" (星期四)";
         break;
      case 5:
         todayname=" (星期五)";
         break;
      case 6:
         todayname=" (星期六)";
         break;
     }
   ObjectSetString(0,"labSvrTime",OBJPROP_TEXT,"[ 服务器时间:"+TimeToString(TimeCurrent(),TimeMode)+" ]");
   ObjectSetString(0,"LocalTime",OBJPROP_TEXT,"本地时间:"+TimeToString(TimeLocal(),TimeMode)+todayname);
   ObjectSetString(0,"AmericaTime",OBJPROP_TEXT,"美国时间:"+GetAmericaTime()+" "+GetMarketPeriod());
   ObjectSetInteger(0,"AmericaTime",OBJPROP_COLOR,clrTomato);


  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MakeLabelFlash(string name)
  {

//--- 显示前景 (false) 或背景 (true)
//   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrBlack);
   Sleep(100);
//   ObjectSetInteger(0,name,OBJPROP_BACK,true);
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrWhite);

  }

//+------------------------------------------------------------------+
//|计算美国当前交易时间                                                                  |
//+------------------------------------------------------------------+
string GetAmericaTime()
  {
   return TimeToString(TimeLocal()-3600*13,TIME_DATE|TIME_MINUTES|TIME_SECONDS);
  }

//+------------------------------------------------------------------+
//|计算总利润                                                        |
//+------------------------------------------------------------------+
double GetSymbolProfit(void)
  {

   CPositionInfo position;
   double symbolprofit=0;
   for(int i=0; i<PositionsTotal(); i++)
     {
      position.SelectByIndex(i);
      if(position.Symbol()==Symbol())
        {
         symbolprofit+=position.Profit();
        }
     }
   return(symbolprofit);

  }
//+------------------------------------------------------------------+
//|获取本货币对挂单数量                                              |
//+------------------------------------------------------------------+
int GetSymbolOrdersCount(void)
  {

   COrderInfo order;
   int ordercount=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(order.SelectByIndex(i))
        {
         if(order.Symbol()==Symbol())
           {
            ordercount++;
           }
        }
     }
   return(ordercount);

  }
//+------------------------------------------------------------------+
//|总挂单手数                                                        |
//+------------------------------------------------------------------+
double GetTotalOrdersLots(void)
  {

   COrderInfo order;
   double totalorderlots=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(order.SelectByIndex(i))
        {
         totalorderlots+=order.VolumeInitial();
        }
     }
   return(totalorderlots);

  }
//+------------------------------------------------------------------+
//|本货币挂单手数                                                    |
//+------------------------------------------------------------------+
double GetSymbolOrdersLots(void)
  {

   COrderInfo order;
   double symbolorderlots=0;
   for(int i=0; i<OrdersTotal(); i++)
     {
      if(order.SelectByIndex(i))
        {
         if(order.Symbol()==Symbol())
           {
            symbolorderlots+=order.VolumeInitial();
           }
        }
     }
   return(symbolorderlots);

  }
//+------------------------------------------------------------------+
//|预定净值全部平仓                                                  |
//+------------------------------------------------------------------+
void CheckReachSetEquity(void)
  {

   double CurrentEquity=0;
   double ds=0;
   double Clear_All_Equity=0;

   if(!GlobalVariableCheck("Clear_All_Equity"))
     {
      Alert("请设置预定净值全平全局变量[Clear_All_Equity]!");
      Equity_Set_Flag="(USD)";
      Sleep(10000);
      return;
     }
   else
      Clear_All_Equity=GlobalVariableGet("Clear_All_Equity");

   CurrentEquity=AccountInfoDouble(ACCOUNT_EQUITY);

   if(CurrentEquity>Clear_All_Equity && PositionsTotal()>0)
     {
      ClearAllPositons();
      Play_Sound_YouGotIt;
     }

   if(Clear_All_Equity!=10000)
     {
      ds=Clear_All_Equity-CurrentEquity;
      Equity_Set_Flag="("+DoubleToString(ds,2)+")";
      if(PositionsTotal()==0)
        {
         GlobalVariableSet("Clear_All_Equity",10000);
        }
      ObjectSetInteger(0,"Label10",OBJPROP_COLOR,clrAqua);
     }
   else
     {
      Equity_Set_Flag="(USD)";
      ObjectSetInteger(0,"Label10",OBJPROP_COLOR,clrWhite);
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckSymbolProfitClear(void)
  {

   if(GetSymbolProfit()>Symbol_Profit_Value && GetSymbolPositionsCount()>0)
     {
      ClearSymbolPositions();
      Play_Sound_Okay;
     }
   if(Symbol_Profit_Value!=1000)
     {
      Symbol_Profit_Flag="("+IntegerToString(Symbol_Profit_Value)+")";
      if(GetSymbolPositionsCount()==0)
        {
         Alert("请重新设定:["+Symbol()+"]预定利润平仓值!");
         Sleep(10000);
        }
     }
   else
      Symbol_Profit_Flag=BlankSpace;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetTodayProfit(void)
  {

   double totalprofit=0;
   ulong ticket=0;
   if(GetHistoryDeals())
     {
      for(int i=0; i<HistoryDealsTotal(); i++)
        {
         if((ticket=HistoryDealGetTicket(i))>0)
           {
            totalprofit+=HistoryDealGetDouble(ticket,DEAL_PROFIT);
           }
        }

     }
   return(totalprofit);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool GetHistoryDeals(void)
  {

   datetime  from,to=TimeCurrent();
   MqlDateTime tmp;
   TimeCurrent(tmp);
   from=TimeCurrent()-(tmp.hour*3600+tmp.min*60+tmp.sec);
   ResetLastError();
   if(!HistorySelect(from,to))
     {
      Print(__FUNCTION__," HistorySelect=false. Error code=",GetLastError());
      return false;
     }
   return true;

  }
//+------------------------------------------------------------------+
//|清除本货币对订单                                                  |
//+------------------------------------------------------------------+
void ClearSymbolPositions(void)
  {

   CSymbolInfo symbolinfo;
   CTrade trade;
   CPositionInfo position;
   while(GetSymbolPositionsCount()!=0)
     {
      for(int i=0; i<PositionsTotal(); i++)
        {
         if(position.SelectByIndex(i) && position.Symbol()==Symbol())
           {
            trade.PositionClose(position.Ticket());
           }
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint GetSymbolPositionsCount(void)
  {

   CPositionInfo positon;
   int positoncount=0;
   for(int i=0; i<PositionsTotal(); i++)
     {
      if(positon.SelectByIndex(i) && positon.Symbol()==Symbol())
         positoncount++;
     }
   return(positoncount);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckSymbolNameLabel(void)
  {

   uint symbolpositionscount=GetSymbolPositionsCount();
   string text=BlankSpace;
   if(symbolpositionscount>0)
     {
      text=Symbol()+" +"+IntegerToString(symbolpositionscount);
      ObjectSetString(0,"SymbolName",OBJPROP_TEXT,text);
     }
   else
     {
      ObjectSetString(0,"SymbolName",OBJPROP_TEXT,Symbol());
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ClearSymbolBuyLimitOrders(void)
  {

   COrderInfo order;
   CTrade     trade;

   while(GetSymbolBuyLimitOrdersCount()!=0)
     {
      for(int i=0; i<OrdersTotal(); i++)
        {
         if(order.SelectByIndex(i) && order.OrderType()==ORDER_TYPE_BUY_LIMIT && order.Symbol()==Symbol())
           {
            trade.OrderDelete(order.Ticket());
           }
        }
     }
   return(true);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ClearSymbolSellLimitOrders(void)
  {

   COrderInfo order;
   CTrade     trade;
   while(GetSymbolSellLimitOrdersCount()!=0)
     {
      for(int i=0; i<OrdersTotal(); i++)
        {
         if(order.SelectByIndex(i) && order.OrderType()==ORDER_TYPE_SELL_LIMIT && order.Symbol()==Symbol())
           {
            trade.OrderDelete(order.Ticket());
           }
        }
     }
   return(true);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint GetSymbolBuyLimitOrdersCount(void)
  {

   COrderInfo order;
   int count=0;

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(order.SelectByIndex(i) && order.OrderType()==ORDER_TYPE_BUY_LIMIT && order.Symbol()==Symbol())
        {
         count++;
        }
     }
   return(count);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint GetSymbolSellLimitOrdersCount(void)
  {

   COrderInfo order;
   int count=0;

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(order.SelectByIndex(i) && order.OrderType()==ORDER_TYPE_SELL_LIMIT && order.Symbol()==Symbol())
        {
         count++;
        }
     }
   return(count);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetBuyLimitOrdersGroup(void)
  {

   COrderInfo order;
   CTrade     trade;
   double     ask,price,point;
   long       digit;
   bool       flag=false;

   if(ClearSymbolBuyLimitOrders())
     {
      ask=SymbolInfoDouble(Symbol(),SYMBOL_ASK);
      point=SymbolInfoDouble(Symbol(),SYMBOL_POINT);
      digit=SymbolInfoInteger(Symbol(),SYMBOL_DIGITS);
      for(uint i=0; i<BuyLimitOrdersCounts; i++)
        {
         price=NormalizeDouble(ask-(BuyLimitOrdersDistance+BuyLimitOrdersGap*i)*point,(int)digit);
         while(!flag)
           {
            Sleep(100);
            price=NormalizeDouble(ask-(BuyLimitOrdersDistance+BuyLimitOrdersGap*i)*point,(int)digit);
            flag=trade.BuyLimit(BuyLimitOrdersLots,price);
           }
         flag=false;
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetSellLimitOrdersGroup(void)
  {

   COrderInfo order;
   CTrade     trade;
   double     bid,price,point;
   long       digit;
   bool       flag=false;
   if(ClearSymbolSellLimitOrders())
     {
      bid=SymbolInfoDouble(Symbol(),SYMBOL_BID);
      point=SymbolInfoDouble(Symbol(),SYMBOL_POINT);
      digit=SymbolInfoInteger(Symbol(),SYMBOL_DIGITS);
      for(uint i=0; i<SellLimitOrdersCounts; i++)
        {
         price=NormalizeDouble(bid+(SellLimitOrdersDistance+SellLimitOrdersGap*i)*point,(int)digit);
         while(!flag)
           {
            Sleep(100);
            price=NormalizeDouble(bid+(SellLimitOrdersDistance+SellLimitOrdersGap*i)*point,(int)digit);
            flag=trade.SellLimit(SellLimitOrdersLots,price);
           }
         flag=false;
        }
     }

  }
//+------------------------------------------------------------------+
//|清除当前货币对挂单                                                                  |
//+------------------------------------------------------------------+
void ClearSymbolOrders(void)
  {

   COrderInfo order;
   CTrade     trade;
   while(GetSymbolOrdersCount()!=0)
     {
      for(int i=0; i<OrdersTotal(); i++)
        {
         if(order.SelectByIndex(i) && order.Symbol()==Symbol())
           {
            trade.OrderDelete(order.Ticket());
           }
        }
     }

  }
//+------------------------------------------------------------------+
//|清除所有货币对挂单                                                                  |
//+------------------------------------------------------------------+
void ClearPendingOrders(void)
  {

   COrderInfo order;
   CTrade     trade;
   while(OrdersTotal()!=0)
     {
      for(int i=0; i<OrdersTotal(); i++)
        {
         if(order.SelectByIndex(i))
           {
            trade.OrderDelete(order.Ticket());
           }
        }
     }

  }
//+------------------------------------------------------------------+
//|设置当前货币对订单止盈止损                                                                  |
//+------------------------------------------------------------------+
void SetTPSL(void)
  {

   CSymbolInfo symbolinfo;
   CTrade trade;
   CPositionInfo position;
   double SL,TP;

   if(GetSymbolPositionsCount()==0)
      return;

   for(int i=0; i<PositionsTotal(); i++)
     {
      position.SelectByIndex(i);
      symbolinfo.Name(PositionGetString(POSITION_SYMBOL));
      symbolinfo.RefreshRates();
      if(position.Symbol()==Symbol())
        {
         switch(position.PositionType())
           {
            case POSITION_TYPE_BUY:
               SL=NormalizeDouble(symbolinfo.Bid()-StopLoss*symbolinfo.Point(),symbolinfo.Digits());
               TP=NormalizeDouble(symbolinfo.Bid()+TakeProfit*symbolinfo.Point(),symbolinfo.Digits());
               trade.PositionModify(position.Ticket(),SL,TP);
               break;
            case POSITION_TYPE_SELL:
               SL=NormalizeDouble(symbolinfo.Ask()+StopLoss*symbolinfo.Point(),symbolinfo.Digits());
               TP=NormalizeDouble(symbolinfo.Ask()-TakeProfit*symbolinfo.Point(),symbolinfo.Digits());
               trade.PositionModify(position.Ticket(),SL,TP);
               break;
           }
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClrTPSL(void)
  {

   CTrade trade;
   CPositionInfo position;

   if(GetSymbolPositionsCount()==0)
      return;

   for(int i=0; i<PositionsTotal(); i++)
     {
      position.SelectByIndex(i);
      if(position.Symbol()==Symbol())
         trade.PositionModify(position.Ticket(),0,0);
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RefreshProfitList(void)
  {

   string globalvarname=NULL;
   string profitlist1=" ";
   string profitlist2=" ";
   string profitlist3=" ";
   string str1,str2,str3;
   double symbolprofit=0;
   double symbollots=0;
   uint   flag=0;
   char list[][15]= {};
   for(int i=0; i<GlobalVariablesTotal(); i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      globalvarname=GlobalVariableName(i);
      if(globalvarname==Symbol())
        {
         symbolprofit=NormalizeDouble(GetSymbolProfit(),2);
         GlobalVariableSet(globalvarname,symbolprofit);
        }
     }
   for(int i=0; i<GlobalVariablesTotal(); i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      globalvarname=GlobalVariableName(i);
      symbollots=GetSymbolLots(globalvarname);
      if(symbollots!=0 && globalvarname!="Clear_All_Equity")
        {
         flag++;
         if(flag>0 && flag<=3)
           {
            str1=globalvarname+":"+DoubleToString(GlobalVariableGet(globalvarname),2)+"("+DoubleToString(symbollots,2)+")";
            uint count=ItemLength-StringLen(str1);
            for(uint j=0; j<count; j++)
              {
               StringAdd(str1," ");
              }
            profitlist1+=str1;
           }
         if(flag>3 && flag<=6)
           {
            str2=globalvarname+":"+DoubleToString(GlobalVariableGet(globalvarname),2)+"("+DoubleToString(symbollots,2)+")";
            uint count=ItemLength-StringLen(str2);
            for(uint j=0; j<count; j++)
              {
               StringAdd(str2," ");
              }
            profitlist2+=str2;
           }
         if(flag>6 && flag<=9)
           {
            str3=globalvarname+":"+DoubleToString(GlobalVariableGet(globalvarname),2)+"("+DoubleToString(symbollots,2)+")";
            uint count=ItemLength-StringLen(str3);
            for(uint j=0; j<count; j++)
              {
               StringAdd(str3," ");
              }
            profitlist3+=str3;
           }
        }
     }
   ObjectSetString(0,"ProfitList1",OBJPROP_TEXT,profitlist1);
   ObjectSetString(0,"ProfitList2",OBJPROP_TEXT,profitlist2);
   ObjectSetString(0,"ProfitList3",OBJPROP_TEXT,profitlist3);
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(PositionsTotal()==0)
     {
      ObjectSetString(0,"ProfitList1",OBJPROP_TEXT," ");
      ObjectSetString(0,"ProfitList2",OBJPROP_TEXT," ");
      ObjectSetString(0,"ProfitList3",OBJPROP_TEXT," ");
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetSymbolLots(const string Symbol_Name)
  {

   CPositionInfo position;
   double symbollots=0.0;
   for(int i=0; i<PositionsTotal(); i++)
      //+------------------------------------------------------------------+
      //|                                                                  |
      //+------------------------------------------------------------------+
     {
      if(position.SelectByIndex(i))
        {
         if(position.Symbol()==Symbol_Name)
           {
            symbollots+=position.Volume();
           }
        }
     }
   return(symbollots);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClrProfitPosition(void)
  {

   CTrade trade;
   CPositionInfo position;
   while(GetPositionsProfitCount()!=0)
     {
      for(int i=0; i<PositionsTotal(); i++)
        {
         if(position.SelectByIndex(i) && position.Symbol()==Symbol() && position.Profit()>0)
           {
            trade.PositionClose(position.Ticket());
           }
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClrLossPosition(void)
  {

   CTrade trade;
   CPositionInfo position;
   while(GetPositionsLossCount()!=0)
     {
      for(int i=0; i<PositionsTotal(); i++)
        {
         if(position.SelectByIndex(i) && position.Symbol()==Symbol() && position.Profit()<0)
           {
            trade.PositionClose(position.Ticket());
           }
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint GetPositionsProfitCount(void)
  {

   CPositionInfo positon;
   int positoncount=0;
   for(int i=0; i<PositionsTotal(); i++)
     {
      if(positon.SelectByIndex(i) && positon.Symbol()==Symbol() && positon.Profit()>0)
         positoncount++;
     }
   return(positoncount);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
uint GetPositionsLossCount(void)
  {

   CPositionInfo positon;
   int positoncount=0;
   for(int i=0; i<PositionsTotal(); i++)
     {
      if(positon.SelectByIndex(i) && positon.Symbol()==Symbol() && positon.Profit()<0)
         positoncount++;
     }
   return(positoncount);

  }
//+------------------------------------------------------------------+
//|建立全局变量                                                      |
//+------------------------------------------------------------------+
void CreateGlobalVar(void)
  {

   GlobalVariablesDeleteAll();
   for(int i=0; i<ArraySize(Symbol_Array); i++)
     {
      GlobalVariableSet(Symbol_Array[i],0);
     }
   GlobalVariableSet("Clear_All_Equity",10000);
   GlobalVariableSet("Exit_Equity",0);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckLessThanEquity(void)
  {

   double CurrentEquity=0;
   double Exit_Equity=0;

   if(!GlobalVariableCheck("Exit_Equity"))
     {
      Alert("请设置小于净值全平全局变量[Exit_Equity]!");
      Equity_Set_Flag="(USD)";
      Sleep(10000);
      return;
     }
   else
      Exit_Equity=GlobalVariableGet("Exit_Equity");

   CurrentEquity=AccountInfoDouble(ACCOUNT_EQUITY);

   if(CurrentEquity<Exit_Equity && PositionsTotal()>0)
     {
      ClearAllPositons();
     }

  }
//+------------------------------------------------------------------+
//|区间盘判定（美盘、欧盘、亚盘）                                                                  |
//+------------------------------------------------------------------+
string GetMarketPeriod()
  {

   string Ret;
   MqlDateTime NowTime;
   TimeToStruct(TimeLocal(),NowTime);

   switch(NowTime.hour)
     {
      case 0:
         Ret = "(伦敦收市)";
         break;
      case 1:
         Ret = "(美盘时间)";
         break;
      case 2:
         Ret = "(美盘时间)";
         break;
      case 3:
         Ret = "(美盘时间)";
         break;
      case 4:
         Ret = "(美盘尾盘)";
         break;
      case 5:
         Ret = "(纽约收市)";
         break;
      case 6:
         Ret = "(亚洲早盘)";
         break;
      case 7:
         Ret = "(威灵顿开市)";
         break;
      case 8:
         Ret = "(雪黎开市)";
         break;
      case 9:
         Ret = "(东京开市)";
         break;
      case 10:
         Ret = "(香港开市)";
         break;
      case 11:
         Ret = "(新加坡开市)";
         break;
      case 12:
         Ret = "(亚盘时间)";
         break;
      case 13:
         Ret = "(亚盘尾盘)";
         break;
      case 14:
         Ret = "(威灵顿收市)";
         break;
      case 15:
         Ret = "(法兰克福开市)";
         break;
      case 16:
         Ret = "(伦敦开市)";
         break;
      case 17:
         Ret = "(东京收市)";
         break;
      case 18:
         Ret = "(欧盘时间)";
         break;
      case 19:
         Ret = "(欧盘时间)";
         break;
      case 20:
         Ret = "(欧盘尾盘)";
         break;
      case 21:
         if(NowTime.mon >= 30)
            Ret = "(美盘开盘)";
         break;
      case 22:
         Ret = "(美盘时间)";
         break;
      case 23:
         Ret = "(美盘时间)";
         break;
      default:
         Ret = "(美盘时间)";
         break;
     }
   return Ret;

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
