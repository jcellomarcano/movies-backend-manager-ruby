module BuyOrder
    def buy_order(Transaction)
        Transaction.@total=Transaction.movie.price
    end
end