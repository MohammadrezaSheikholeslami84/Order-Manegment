//+------------------------------------------------------------------+
//|                                                    Close Orders and Orders Management.mq4 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
#property description "> Developer       :  MohammadReza Sheikholeslami"
#property description " "
#property description "> Phone > WhatsApp > Telegram :  +98 920 322 8135"
#property version   "2.00"
#define TLevelKey 84 //T
#define PriceShow 80 //P
#define SubWindowsKey 83 //S
#define TimeShow 67 //C

enum Hotkeys
  {
   T,
   C,
   P,
   Space,
   S,
   Enter,
   Delete,
   A,
   B,
   L
  };
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input string             comment111         = "===================+ HotKeys +===============";//===================+ HotKeys +=======================

extern Hotkeys TLevel = 9;
extern Hotkeys ShowPrice  = 2;
extern Hotkeys ShowTime = 0 ;
extern Hotkeys CloseAll = 7 ;
extern Hotkeys CloseBuy = 8;
extern Hotkeys CloseSell = 4 ;

input string             comment3          = "===================+ Profit Closing +===============";//===================+ Profit Closing +=======================
extern double profit = 10000; // Profit to Close the Positions

input string             comment7         = "===================+ Profit Alarming +===============";//===================+ Profit Alarming +=======================
extern bool  AlarmNotification = false;
extern double ProfittoAlarm = 350; // Profit to Alarm
extern int Delay = 5; // Delay In Minutes

input string             comment2          = "============+ Transaction Panel +=============";//===================+ Transaction Panel +=======================
extern color colortext = clrBlack; // Text color of Transaction Panel in Dafault
extern color colorInformation_Profit = clrGreen; // Text color of Transaction Panel in Profit
extern color colorInformation_Loss = clrRed; // Text color of Transaction Panel in Loss
extern color colorInformation = clrBlue; //  Text color of Information in Transaction Panel
extern char textsizeinformation = 8; //Text size of Information in Transaction Panel
extern char textsizenumber = 7;//Text size of Numbers in Transaction Panel
extern char WindoNumber = 0;

input string             commdsfaensadf          = "=======+ VSA Alarmer +=======";//=======+ VSA Alarmer +=======
input int NumberofCandles = 10;
input int NumberofVSA = 3;
input bool AlarmVSA = False;

input int dollor_price = 55000; // Dolor Price

extern double Body_percentage = 70; // % Body

int count_buy = 0;
int count_sell = 0;

double BodyRange;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   Label(0,"a7",WindoNumber,0,20,CORNER_LEFT_LOWER,"$-All :","Arial Bold",textsizeinformation,colorInformation);
   Label(0,"a8",WindoNumber,160,20,CORNER_LEFT_LOWER,"$-Arz :","Arial Bold",textsizeinformation,colorInformation);
   Label(0,"c5",WindoNumber,310,20,CORNER_LEFT_LOWER,"$-Buy : ","Arial Bold",textsizeinformation,colorInformation);
   Label(0,"c6",WindoNumber,450,20,CORNER_LEFT_LOWER,"$-Sell : ","Arial Bold",textsizeinformation,colorInformation);
   Label(0,"c1",WindoNumber,580,20,CORNER_LEFT_LOWER,"num buy : ","Arial Bold",textsizeinformation,colorInformation);
   Label(0,"c2",WindoNumber,710,20,CORNER_LEFT_LOWER,"num sell : ","Arial Bold",textsizeinformation,colorInformation);
   Label(0,"c3",WindoNumber,840,20,CORNER_LEFT_LOWER,"Lot Buy : ","Arial Bold",textsizeinformation,colorInformation);
   Label(0,"c4",WindoNumber,1000,20,CORNER_LEFT_LOWER,"Lot Sell : ","Arial Bold",textsizeinformation,colorInformation);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete("Close All");
   ObjectDelete("Close Sell");
   ObjectDelete("Close Buy");
   ObjectDelete("T-Level");
   ObjectDelete("tEEt");
   ObjectDelete("a8");
   ObjectDelete("c1");
   ObjectDelete("c2");
   ObjectDelete("c3");
   ObjectDelete("c4");
   ObjectDelete("a4d8");
   ObjectDelete("asvff");
   ObjectDelete("vssf") ;
   ObjectDelete("vsf");
   ObjectDelete("a77");
   ObjectDelete("Profit Buy");
   ObjectDelete("Profit Sell");
   ObjectDelete("c5");
   ObjectDelete("c6");
   ObjectDelete("a7");
   ObjectDelete("a66");
//----
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   double profitprofitprofit = (ProfitHistory() / (AccountBalance() - ProfitHistory())) * 100;
   string profitintoman = DoubleToStr(((ProfitHistory() / 100) * dollor_price),1);
   Comment(DoubleToStr(profitprofitprofit,2) + " % ", "\n",FormatNumber(profitintoman), " Toman ");
//  double ind = iCustom(_Symbol,PERIOD_CURRENT,"one",calculation_setting,Bars_to_scan, indicator_period,look_back, signal_to_noise, indicator_setting, use_white_background,supply_pattern,demand_pattern,neutral_pattern,0,0);
   static datetime t1;
   if(t1 != Time[0])
     {

      double range = iHigh(NULL,0,1) - iLow(NULL,0,1);

      if(range != 0)
         BodyRange = MathAbs((iOpen(NULL, 0, 1) - iClose(NULL, 0, 1)) * 100 / range);


      int obj = ObjectsTotal();
      for(int i = 0; i <= obj; i++)
        {
         string name = ObjectName(i);
         datetime time = (datetime)ObjectGetInteger(0,name,OBJPROP_TIME);

         if(time >= Time[NumberofCandles] && time < Time[0])
           {
            if(StringFind(name,"Demand",0) >= 0)
              {
               count_buy++;

               Print(time);
              }
            if(StringFind(name,"Supply",0) >= 0)
              {
               count_sell++;

              }
           }
        }
      if(count_buy >= NumberofVSA)
        {

         if(AlarmVSA)
           {

            if(iClose(NULL, 0, 1) >  iOpen(NULL, 0, 1) &&  iClose(NULL, 0, 2) <  iOpen(NULL, 0, 2) &&  iClose(NULL, 0, 3) <  iOpen(NULL, 0, 3)
               && iClose(NULL, 0, 1) >= iHigh(NULL, 0, 2)   && iClose(NULL, 0, 1) >= iHigh(NULL, 0, 3) && BodyRange >= Body_percentage)
              {

               Alert("Buy | " + Symbol() + " | " + "TimeFrame : " + period_detector_MTF(Period()) + " | " + count_buy + " Times | In " + NumberofCandles + " Candle");
               SendNotification("Buy | " + Symbol() + " | " + "TimeFrame : " + period_detector_MTF(Period()) + " | " + count_buy + " Times | In " + NumberofCandles + " Candle");
              }
           }
        }
      if(count_sell >= NumberofVSA)
        {

         if(AlarmVSA)
           {
            if(iClose(NULL, 0, 1) <  iOpen(NULL, 0, 1) &&  iClose(NULL, 0, 2) >  iOpen(NULL, 0, 2) &&  iClose(NULL, 0, 3) >  iOpen(NULL, 0, 3)
               && iClose(NULL, 0, 1) <= iLow(NULL, 0, 2)   && iClose(NULL, 0, 1) <= iLow(NULL, 0, 3) && BodyRange >= Body_percentage)
              {

               Alert("Sell | " + Symbol() + " | " + "TimeFrame : " + period_detector_MTF(Period()) + " | " + count_sell + " Times In | " + NumberofCandles + " Candle");
               SendNotification("Sell | " + Symbol() + " | " + "TimeFrame : " + period_detector_MTF(Period()) + " | " + count_sell + " Times | In " + NumberofCandles + " Candle");
              }
           }
        }

      count_buy = 0;
      count_sell = 0;
      t1 = Time[0];
     }
   LotsProfit();
   LotsLoss();

   ProfitAlarm();
   double Profitkoli = MathRound(AccountProfit()) ;
   double ProfitArz  = ProfitOrders();
   double ProfitBuy  = ProfitOrderBuy();
   double ProfitSell  = ProfitOrderSell();
   int numbuy =  NumberOrderBuy();
   int numsell = NumberOrderSell();
   double lotbuy = LotsOrderBuy();
   double lotsell = LotsOrderSell();
//  if(ProfitArz >= profit)
//   closeAll(0);
   if(Profitkoli > 0)
      Label(0,"a66",WindoNumber,50,19,CORNER_LEFT_LOWER,DoubleToString(Profitkoli,0),"Arial Bold",textsizenumber,colorInformation_Profit);  //dollar
   if(Profitkoli < 0)
      Label(0,"a66",WindoNumber,50,19,CORNER_LEFT_LOWER, DoubleToString(Profitkoli,0),"Arial Bold",textsizenumber,colorInformation_Loss);  //dollar
   if(Profitkoli == 0)
      Label(0,"a66",WindoNumber,50,19,CORNER_LEFT_LOWER,DoubleToString(Profitkoli,0),"Arial Bold",textsizenumber,colortext);  //dollar
   if(ProfitArz > 0)
      Label(0,"a77",WindoNumber,210,19,CORNER_LEFT_LOWER,DoubleToStr(ProfitArz,0),"Arial Bold",textsizenumber,colorInformation_Profit);  //dollar
   if(ProfitArz < 0)
      Label(0,"a77",WindoNumber,210,19,CORNER_LEFT_LOWER,DoubleToStr(ProfitArz,0),"Arial Bold",textsizenumber,colorInformation_Loss);  //dollar
   if(ProfitArz == 0)
      Label(0,"a77",WindoNumber,210,19,CORNER_LEFT_LOWER,DoubleToStr(ProfitArz,0),"Arial Bold",textsizenumber,colortext);  //dollar
   if(ProfitBuy > 0)
      Label(0,"Profit Buy",WindoNumber,360,19,CORNER_LEFT_LOWER,DoubleToStr(ProfitBuy,0),"Arial Bold",textsizenumber,colorInformation_Profit);  //dollar buy
   if(ProfitBuy < 0)
      Label(0,"Profit Buy",WindoNumber,360,19,CORNER_LEFT_LOWER,DoubleToStr(ProfitBuy,0),"Arial Bold",textsizenumber,colorInformation_Loss);  //dollar buy
   if(ProfitBuy == 0)
      Label(0,"Profit Buy",WindoNumber,360,19,CORNER_LEFT_LOWER,DoubleToStr(ProfitBuy,0),"Arial Bold",textsizenumber,colortext);  //dollar buy
   if(ProfitSell > 0)
      Label(0,"Profit Sell",WindoNumber,500,19,CORNER_LEFT_LOWER,DoubleToStr(ProfitSell,0),"Arial Bold",textsizenumber,colorInformation_Profit);  //dollar Sell
   if(ProfitSell < 0)
      Label(0,"Profit Sell",WindoNumber,500,19,CORNER_LEFT_LOWER,DoubleToStr(ProfitSell,0),"Arial Bold",textsizenumber,colorInformation_Loss);  //dollar Sell
   if(ProfitSell == 0)
      Label(0,"Profit Sell",WindoNumber,500,19,CORNER_LEFT_LOWER,DoubleToStr(ProfitSell,0),"Arial Bold",textsizenumber,colortext);  //dollar Sell
   Label(0,"a4d8",WindoNumber,650,19,CORNER_LEFT_LOWER,(string)(numbuy),"Arial Bold",textsizenumber,colortext); // num buy
   Label(0,"asvff",WindoNumber,780,19,CORNER_LEFT_LOWER,(string)(numsell),"Arial Bold",textsizenumber,colortext); // num sell
   Label(0,"vssf",WindoNumber,900,19,CORNER_LEFT_LOWER,DoubleToStr(lotbuy,2),"Arial Bold",textsizenumber,colortext); // lot buy
   Label(0,"vsf",WindoNumber,1060,19,CORNER_LEFT_LOWER,DoubleToStr(lotsell,2),"Arial Bold",textsizenumber,colortext); // lot sell
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
   if(id == CHARTEVENT_KEYDOWN)
     {
      if(Converter_Hotkey(EnumToString(TLevel)) == int(lparam))
        {
         if(ChartGetInteger(0,CHART_SHOW_TRADE_LEVELS,0))
            ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,False);
         else
            ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,True);
        }
      ChartRedraw();
     }
   if(id == CHARTEVENT_KEYDOWN)
     {
      if(Converter_Hotkey(EnumToString(ShowPrice)) == int(lparam))
        {
         if(ChartGetInteger(0,CHART_SHOW_PRICE_SCALE,0))
            ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,False);
         else
            ChartSetInteger(0,CHART_SHOW_PRICE_SCALE,True);
        }
      ChartRedraw();
     }
   if(id == CHARTEVENT_KEYDOWN)
     {
      if(Converter_Hotkey(EnumToString(ShowTime)) == int(lparam))
        {
         if(ChartGetInteger(0,CHART_SHOW_DATE_SCALE,0))
            ChartSetInteger(0,CHART_SHOW_DATE_SCALE,False);
         else
            ChartSetInteger(0,CHART_SHOW_DATE_SCALE,True);
        }
      ChartRedraw();
     }
   if(id == CHARTEVENT_KEYDOWN)
     {
      if(Converter_Hotkey(EnumToString(CloseAll)) == int(lparam))
        {
         int    returncodepositionAll = MessageBox("Do you want to Close All the Positions ? ", " Closing ", MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2);
         if(returncodepositionAll == 6)
            closeAll(0);
        }
      ChartRedraw();
     }
   if(id == CHARTEVENT_KEYDOWN)
     {
      if(Converter_Hotkey(EnumToString(CloseBuy)) == int(lparam))
        {
         int    returncodepositionBuy = MessageBox("Do you want to Close Buy Positions ? ", " Closing ", MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2);
         if(returncodepositionBuy == 6)
            closeBuy(0);
        }
      ChartRedraw();
     }
   if(id == CHARTEVENT_KEYDOWN)
     {
      if(Converter_Hotkey(EnumToString(CloseSell)) == int(lparam))
        {
         int    returncodepositionSell = MessageBox("Do you want to Close Sell Positions ? ", " Closing ", MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2);
         if(returncodepositionSell == 6)
            closeSell(0);
        }
      ChartRedraw();
     }
   if(sparam == "Close All" && ObjectGetInteger(0,"Close All",OBJPROP_STATE) == TRUE)
     {
      ObjectSetInteger(0,"Close All",OBJPROP_STATE,False);
      int    returncodepositionAll = MessageBox("Do you want to Close All the Positions ? ", " Closing ", MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2);
      if(returncodepositionAll == 6)
         closeAll(0);
     }
   if(sparam == "Close Sell" && ObjectGetInteger(0,"Close Sell",OBJPROP_STATE) == TRUE)
     {
      ObjectSetInteger(0,"Close Sell",OBJPROP_STATE,False);
      int    returncodepositionSell = MessageBox("Do you want to Close Sell Positions ? ", " Closing ", MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2);
      if(returncodepositionSell == 6)
         closeSell(0);
     }
   if(sparam == "Close Buy" && ObjectGetInteger(0,"Close Buy",OBJPROP_STATE) == TRUE)
     {
      ObjectSetInteger(0,"Close Buy",OBJPROP_STATE,False);
      int    returncodepositionBuy = MessageBox("Do you want to Close Buy Positions ? ", " Closing ", MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2);
      if(returncodepositionBuy == 6)
         closeBuy(0);
     }
   if(sparam == "T-Level" && ObjectGetInteger(0,"T-Level",OBJPROP_STATE) == TRUE)
     {
      ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,False);
     }
   if(sparam == "T-Level" && ObjectGetInteger(0,"T-Level",OBJPROP_STATE) == False)
     {
      ChartSetInteger(0,CHART_SHOW_TRADE_LEVELS,True);
     }
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Button(const long                    chart_ID = 0,             // ای دی چارت
            const string            name = "Button",          // اسم
            const int               sub_window = 0,           // شماره پنجره
            const int               x = 0,                    // X فاصله محور
            const int               y = 0,                    // Y فاصله محور
            const int               width = 50,               // عرض دکمه
            const int               height = 18,              // ارتفاع دکمه
            const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // انتخاب گوشه چارت
            const string            text = "Button",          // نوشته درون دکمه
            const string            font = "Arial",           // فونت
            const int               font_size = 10,           // سایز فونت
            const color             clr = clrBlack,           // رنگ نوشته
            const color             back_clr = C'236,233,216', // رنگ دکمه
            const color             border_clr = clrNONE,     // رنگ کادر دکمه
            const bool              state = false,            // حالت دکمه ،کلیک شده / کلیک نشده
            const bool              back = false,             // قرار گرفتن در پشت
            const bool              selection = false,        // قابلیت حرکت
            const bool              hidden = true,            // مخفی شدن از لیست
            const long              z_order = 0)              // اولویت برای کلیک ماوس
  {
   ResetLastError();
   if(ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
      ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ChartRedraw();
      return(true);
     }
   else
     {
      Print(__FUNCTION__,
            ": failed to create => ",name," object! Error code = ",GetLastError());
      return(false);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Label(const char              chart_ID = 0, // ای دی چارت
           const string            name = "Label",           // اسم
           const char               sub_window = 0,           // شماره پنجره
           const short               x = 0,                    // X فاصله محور
           const short               y = 0,                    // Y فاصله محور
           const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // انتخاب گوشه چارت
           const string            text = "Label",           // متن
           const string            font = "Arial",           // فونت
           const char               font_size = 10,           // اندازه فونت
           const color             clr = clrRed,             // رنگ
           const double            angle = 0.0,              // زاویه نوشته
           const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER, // نقطه اتکا نوشته
           const bool              back = false,             // قرار گرفتن در پشت
           const bool              selection = false,        // قابلیت حرکت
           const bool              hidden = true,            // مخفی شدن از لیست
           const char              z_order = 0)              // اولویت برای کلیک ماوس
  {
   ResetLastError();
   if(ObjectFind(name) == sub_window) // در صورت وجود داشتن ابجیکت
     {
      ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
      ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
      ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      ChartRedraw();
      return(true);
     }
   else
     {
      if(ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
        {
         ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
         ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
         ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
         ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
         ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
         ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
         ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
         ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
         ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
         ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
         ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
         ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
         ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
         ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
         ChartRedraw();
         return(true);
        }
      else
        {
         Print(__FUNCTION__,
               ": failed to create => ",name," object! Error code = ",GetLastError());
         return(false);
        }
     }
  }






//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeAll(int Magic)
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber() == Magic && OrderSymbol() == Symbol())
            bool yccb = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrGreen);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeSell(int Magic)
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber() == Magic && OrderSymbol() == Symbol() && OrderType() == OP_SELL)
            bool yccb = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrGreen);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void closeBuy(int Magic)
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderMagicNumber() == Magic && OrderSymbol() == Symbol() && OrderType() == OP_BUY)
            bool yccb = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),0,clrGreen);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ProfitAlarm()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit() >= ProfittoAlarm)
           {
            if(AlarmNotification == True)
              {
               string profit = DoubleToStr(OrderProfit(),2);
               SendNotification((string)OrderSymbol() + " is More than " + DoubleToStr(ProfittoAlarm,0) + "$" "Profit : " + (string)profit);
               Alert(OrderSymbol() + " is More than " + DoubleToStr(ProfittoAlarm,0) + "$" "Profit : " +   DoubleToStr(OrderProfit()),2);
              }
           }
        }
     }
   AlertDelay();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool AlertDelay()
  {
   static datetime last_time;
   if(TimeCurrent() - last_time < Delay * 60)
     {
      return(false);
     }
   else
     {
      last_time = TimeCurrent();
      return(true);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ProfitProfit()
  {
   double profitprofit = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit() > 0)
            profitprofit += OrderProfit();
        }
     }
   return(profitprofit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LossLoss()
  {
   double lossloss = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit() < 0)
            lossloss += OrderProfit();
        }
     }
   return(lossloss);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ProfitOrders()
  {
   double profitOrders = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol())
            profitOrders += OrderProfit();
        }
     }
   return(profitOrders);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotsProfit()
  {
   double LotsProfit = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit() > 0)
           {
            LotsProfit += OrderLots();
           }
        }
     }
   return(LotsProfit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotsLoss()
  {
   double LotsLoss = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderProfit() < 0)
           {
            LotsLoss += OrderLots();
           }
        }
     }
   return(LotsLoss);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotsOrderBuy()
  {
   double Lotsizebuy = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType() == OP_BUY && OrderSymbol() == Symbol())
           {
            Lotsizebuy += OrderLots();
           }
        }
     }
   return(Lotsizebuy);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int NumberOrderBuy()
  {
   int numbuy = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType() == OP_BUY && OrderSymbol() == Symbol())
           {
            numbuy++;
           }
        }
     }
   return(numbuy);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ProfitOrderBuy()
  {
   double profitbuy = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType() == OP_BUY && OrderSymbol() == Symbol())
            profitbuy += OrderProfit();
        }
     }
   return(profitbuy);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LotsOrderSell()
  {
   double Lotsizesell = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType() == OP_SELL && OrderSymbol() == Symbol())
           {
            Lotsizesell += OrderLots();
           }
        }
     }
   return(Lotsizesell);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int NumberOrderSell()
  {
   int numsell = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType() == OP_SELL && OrderSymbol() == Symbol())
           {
            numsell++;
           }
        }
     }
   return(numsell);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ProfitOrderSell()
  {
   double profitsell = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType() == OP_SELL && OrderSymbol() == Symbol())
            profitsell += OrderProfit();
        }
     }
   return(profitsell);
  }


//+------------------------------------------------------------------+
double ProfitHistory()
  {
   double pp;
   for(int i = OrdersHistoryTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY) == true)
        {
         pp += OrderProfit();
        }
     }
   return (pp);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string FormatNumber(string numb, string delim = ",",string dec = ".")
  {
   string enumb, nnumb ;
   int pos = StringFind(numb,dec);
   if(pos == -1)
     {
      string nnumb = numb;
      string enumb = "";
     }
   else
     {
      nnumb = StringSubstr(numb,0,pos);
      enumb = StringSubstr(numb,pos);
     }
   int cnt = StringLen(nnumb);
   if(cnt < 4)
      return(numb);
   int x = MathFloor(cnt / 3);
   int y = cnt - x * 3;
   string forma = "";
   if(y != 0)
      forma = StringConcatenate(StringSubstr(nnumb,0,y),delim);
   for(int i = 0; i < x; i++)
     {
      if(i != x - 1)
         forma = StringConcatenate(forma,StringSubstr(nnumb,y + i * 3,3),delim);
      else
         forma = StringConcatenate(forma,StringSubstr(nnumb,y + i * 3,3));
     }
   forma = StringConcatenate(forma,enumb);

   return(forma);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Converter_Hotkey(string Hotkey)
  {
   if(Hotkey == "T" || Hotkey == "t")
      return(84);
   else
      if(Hotkey == "C" || Hotkey == "c")
         return(67);
      else
         if(Hotkey == "P" || Hotkey == "p")
            return(80);
         else
            if(Hotkey == "Space")
               return(32);
            else
               if(Hotkey == "S" || Hotkey == "s")
                  return(83);
               else
                  if(Hotkey == "Enter")
                     return(13);
                  else
                     if(Hotkey == "Delete")
                        return(46);
                     else
                        if(Hotkey == "B")
                           return(66);
                        else
                           if(Hotkey == "A")
                              return(65);
                           else
                              if(Hotkey == "L")
                                 return(76);
                              /* else  if(Hotkey == "T" || Hotkey == "t")
                                    return(84);
                               else  if(Hotkey == "T" || Hotkey == "t")
                                    return(84);
                               else  if(Hotkey == "T" || Hotkey == "t")
                                    return(84);
                               else    if(Hotkey == "T" || Hotkey == "t")
                                    return(84);
                               else    if(Hotkey == "T" || Hotkey == "t")
                                    return(84);
                               else    if(Hotkey == "T" || Hotkey == "t")
                                    return(84);
                               else    if(Hotkey == "T" || Hotkey == "t")
                                    return(84);
                               else    if(Hotkey == "T" || Hotkey == "t")
                                    return(84);
                               else    if(Hotkey == "T" || Hotkey == "t")
                                    return(84); */
                              else
                                 return(0);
  }
//+------------------------------------------------------------------+
string period_detector_MTF(int MTF)
  {
   if(MTF == 0)
      MTF = Period();
   if(MTF == 1)
      return("M1");
   if(MTF == 5)
      return("M5");
   if(MTF == 15)
      return("M15");
   if(MTF == 30)
      return("M30");
   if(MTF == 60)
      return("H1");
   if(MTF == 240)
      return("H4");
   if(MTF == 1440)
      return("D1");
   if(MTF == 10080)
      return("W1");
   if(MTF == 43200)
      return("MN1");
   return("NULL");
  }
//+------------------------------------------------------------------+
