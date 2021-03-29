module BuyOrder
    def buy_order(Transaction)
        Transaction.@total=Transaction.movie.price
        Transaction.@date=Date.today
    end
end