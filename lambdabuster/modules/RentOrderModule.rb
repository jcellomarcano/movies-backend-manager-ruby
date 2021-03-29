module RentOrder
    def rent_order(Transaction)
        Transaction.@total=Transaction.movie.rent_price
        Transaction.@date=Date.today+2
    end
end
