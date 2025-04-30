//+------------------------------------------------------------------+
//|                                          XAUUSD_MA_MACD.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024"
#property link      ""
#property version   "1.00"
#property strict

// Input parameters
extern int FastMA_Period = 8;      // Fast MA period
extern int SlowMA_Period = 21;     // Slow MA period
extern int MACD_Fast = 12;         // MACD Fast EMA
extern int MACD_Slow = 26;         // MACD Slow EMA
extern int MACD_Signal = 9;        // MACD Signal period
extern double LotSize = 0.1;       // Trading lot size
extern int StopLoss = 150;         // Stop Loss in points
extern int TakeProfit = 300;       // Take Profit in points
extern int TrailingStop = 100;     // Trailing stop in points
extern int MagicNumber = 123456;   // Magic number for orders

// Global variables
int ticket = 0;

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
   // Calculate Moving Averages
   double fastMA = iMA(NULL, 0, FastMA_Period, 0, MODE_EMA, PRICE_CLOSE, 0);
   double slowMA = iMA(NULL, 0, SlowMA_Period, 0, MODE_EMA, PRICE_CLOSE, 0);
   double fastMA_prev = iMA(NULL, 0, FastMA_Period, 0, MODE_EMA, PRICE_CLOSE, 1);
   double slowMA_prev = iMA(NULL, 0, SlowMA_Period, 0, MODE_EMA, PRICE_CLOSE, 1);
   
   // Calculate MACD
   double macd = iMACD(NULL, 0, MACD_Fast, MACD_Slow, MACD_Signal, PRICE_CLOSE, MODE_MAIN, 0);
   double signal = iMACD(NULL, 0, MACD_Fast, MACD_Slow, MACD_Signal, PRICE_CLOSE, MODE_SIGNAL, 0);
   double macd_prev = iMACD(NULL, 0, MACD_Fast, MACD_Slow, MACD_Signal, PRICE_CLOSE, MODE_MAIN, 1);
   double signal_prev = iMACD(NULL, 0, MACD_Fast, MACD_Slow, MACD_Signal, PRICE_CLOSE, MODE_SIGNAL, 1);
   
   // Check if we can trade (only during active market hours)
   if(Hour() >= 8 && Hour() <= 20) // Trading hours 8:00 - 20:00
   {
      // Check for open positions
      if(OrdersTotal() == 0)
      {
         // Buy condition
         if(fastMA > slowMA && fastMA_prev <= slowMA_prev && // MA crossover
            macd > signal && macd_prev <= signal_prev)       // MACD crossover
         {
            ticket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 3, 
                             Ask - StopLoss * Point, Ask + TakeProfit * Point, 
                             "XAUUSD_MA_MACD", MagicNumber, 0, Green);
         }
         
         // Sell condition
         if(fastMA < slowMA && fastMA_prev >= slowMA_prev && // MA crossover
            macd < signal && macd_prev >= signal_prev)       // MACD crossover
         {
            ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, 3, 
                             Bid + StopLoss * Point, Bid - TakeProfit * Point, 
                             "XAUUSD_MA_MACD", MagicNumber, 0, Red);
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