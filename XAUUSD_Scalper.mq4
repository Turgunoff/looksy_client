//+------------------------------------------------------------------+
//|                                            XAUUSD_Scalper.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024"
#property link      ""
#property version   "1.00"
#property strict

// Input parameters
extern int RSI_Period = 14;        // RSI period
extern int RSI_UpperLevel = 70;    // RSI upper level
extern int RSI_LowerLevel = 30;    // RSI lower level
extern double LotSize = 0.1;       // Trading lot size
extern int StopLoss = 100;         // Stop Loss in points
extern int TakeProfit = 200;       // Take Profit in points
extern int TrailingStop = 50;      // Trailing stop in points
extern int MagicNumber = 123456;   // Magic number for orders

// Global variables
int ticket = 0;
datetime lastTradeTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Check if symbol is XAUUSD
   if(Symbol() != "XAUUSD")
   {
      Print("This EA is designed for XAUUSD only!");
      return(INIT_FAILED);
   }
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
   // Calculate RSI
   double rsi = iRSI(NULL, 0, RSI_Period, PRICE_CLOSE, 0);
   double rsi_prev = iRSI(NULL, 0, RSI_Period, PRICE_CLOSE, 1);
   
   // Get current time
   datetime currentTime = TimeCurrent();
   
   // Check if we can trade (only during active market hours)
   if(Hour() >= 8 && Hour() <= 20) // Trading hours 8:00 - 20:00
   {
      // Check for open positions
      if(OrdersTotal() == 0)
      {
         // Buy condition
         if(rsi < RSI_LowerLevel && rsi > rsi_prev)
         {
            ticket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 3, 
                             Ask - StopLoss * Point, Ask + TakeProfit * Point, 
                             "XAUUSD_Scalper", MagicNumber, 0, Green);
         }
         
         // Sell condition
         if(rsi > RSI_UpperLevel && rsi < rsi_prev)
         {
            ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 3, 
                             Bid + StopLoss * Point, Bid - TakeProfit * Point, 
                             "XAUUSD_Scalper", MagicNumber, 0, Red);
         }
      }
      
      // Trailing stop for open positions
      for(int i = 0; i < OrdersTotal(); i++)
      {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
            {
               if(OrderType() == OP_BUY)
               {
                  if(Bid - OrderOpenPrice() > Point * TrailingStop)
                  {
                     if(OrderStopLoss() < Bid - Point * TrailingStop)
                     {
                        OrderModify(OrderTicket(), OrderOpenPrice(), 
                                  Bid - Point * TrailingStop, OrderTakeProfit(), 0, Green);
                     }
                  }
               }
               else if(OrderType() == OP_SELL)
               {
                  if(OrderOpenPrice() - Ask > Point * TrailingStop)
                  {
                     if(OrderStopLoss() > Ask + Point * TrailingStop)
                     {
                        OrderModify(OrderTicket(), OrderOpenPrice(), 
                                  Ask + Point * TrailingStop, OrderTakeProfit(), 0, Red);
                     }
                  }
               }
            }
         }
      }
   }
} 