import yfinance as yf   
from random import choice

STOCK_TICKERS = [
    "NRGU",
    "UBER",
    "NFLX",
    "BABA"
]

def get_stock_price(sym) -> float:
    stock_info = yf.Ticker(sym).info
    curr_price = stock_info["regularMarketPrice"]

    return curr_price


def get_random_stock_price() -> str:
    sym = choice(STOCK_TICKERS)
    price = get_stock_price(sym)

    return f"{sym}: ${price}"


def main():
    print(get_random_stock_price())


if __name__ == "__main__":
    main()