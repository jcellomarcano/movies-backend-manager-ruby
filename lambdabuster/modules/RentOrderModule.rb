module RentOrder
    def rent_order(Transaction)
        Transaction.@total=Transaction.movie.rent_price
    end
end
