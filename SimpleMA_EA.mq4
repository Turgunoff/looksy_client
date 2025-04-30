//+------------------------------------------------------------------+
//|                                              SimpleMA_EA.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024"
#property link      ""
#property version   "1.00"
#property strict

// Input parameters
extern int MA_Period = 20;        // Moving Average period
extern int MA_Shift = 0;          // Moving Average shift
extern int MA_Method = 0;         // Moving Average method (0=SMA, 1=EMA, 2=SMMA, 3=LWMA)
extern int MA_Applied_Price = 0;  // Applied price (0=Close, 1=Open, 2=High, 3=Low, 4=Median, 5=Typical, 6=Weighted)
extern double LotSize = 0.1;      // Trading lot size
extern int StopLoss = 50;         // Stop Loss in points
extern int TakeProfit = 100;      // Take Profit in points

// Global variables
int ticket = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Calculate Moving Average
   double ma = iMA(NULL, 0, MA_Period, MA_Shift, MA_Method, MA_Applied_Price, 0);
   double ma_prev = iMA(NULL, 0, MA_Period, MA_Shift, MA_Method, MA_Applied_Price, 1);
   
   // Get current price
   double current_price = Bid;
   
   // Check for open positions
   if(OrdersTotal() == 0)
   {
      // Buy condition
      if(current_price > ma && ma > ma_prev)
      {
         ticket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 3, 
                          Ask - StopLoss * Point, Ask + TakeProfit * Point, 
                          "SimpleMA_EA", 0, 0, Green);
      }
      
      // Sell condition
      if(current_price < ma && ma < ma_prev)
      {
         ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 3, 
                          Bid + StopLoss * Point, Bid - TakeProfit * Point, 
                          "SimpleMA_EA", 0, 0, Red);
      }
   }
} 