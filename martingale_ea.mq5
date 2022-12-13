// Martingale trading strategy for forex
// This is a simple program that illustrates the Martingale strategy

#include <Trade/Trade.mqh>

// Basic parameters
double lots = 0.1;  // Initial trade size
double multiplier = 2;  // Multiplier for increasing trade size after a loss
double stopLoss = 50;  // Stop loss in pips
double takeProfit = 50;  // Take profit in pips

// Variables for managing the trades
int ticket = 0;  // ID of the current trade
double initialPrice = 0;  // Price at the time the trade was opened
double tradeSize = 0;  // Current trade size

// This function is called when a new tick arrives
void OnTick()
{
  // Check if we have an open trade
  if (ticket > 0)
  {
    // Check if the trade has reached the stop loss or take profit
    if (OrderProfit() < -stopLoss * Point || OrderProfit() > takeProfit * Point)
    {
      // Close the trade
      Print("Closing trade ", ticket);
      OrderClose(ticket);
      
      // Reset variables
      ticket = 0;
      initialPrice = 0;
      tradeSize = 0;
    }
  }
  else
  {
    // We don't have an open trade, so open one
    tradeSize = lots;
    initialPrice = Ask;
    
    // Use the Martingale strategy to increase the trade size after a loss
    if (tradeSize < AccountFreeMargin() / stopLoss / Point)
    {
      tradeSize *= multiplier;
    }
    
    // Open a trade with the calculated trade size
    ticket = OrderSend(Symbol(), OP_BUY, tradeSize, Ask, 3, 0, 0, "Martingale trade", 0, 0, clrNONE);
    if (ticket > 0)
    {
      Print("Opened trade ", ticket);
    }
    else
    {
      Print("Failed to open trade");
    }
  }
}
