require 'json'
require 'set'
require 'wannabe_bool'
require 'date'
require_relative 'classes'



def create_order(movies,type,user)
    if type == :rent
        my_name="rentar"
        verb_in_past="rentado"
        my_price="rent_price"
        action="rent_order"
        store="rented_movies"
    else
        my_name="comprar"
        verb_in_past="comprado"
        my_price="price"
        action="buy_order"
        store="owned_movies"
    end
    puts "¿Que pelicula quiere #{my_name}?"
    puts "Inserta el nombre de la pelicula"
    movie_name = gets.chomp.to_i
    movie=movies.scan(:name) { |x| x == movie_name}
    if movie.length < 0
        puts "\nSorry, no se encontró la pelicula :("
        while true
            puts "\nQue accion quiere realizar?"
            puts "1. Intentar con otro nombre"
            puts "2. Volver al menu inicial"
            puts "3. Consultar peliculas"
            puts "4. Salir"
            puts ""
            puts "Inserta el numero de la opcion"
            option = gets.chomp.to_i
            case option
            when 1
                resp=create_order(movies,type)
                break
            when 2
                resp=1
                break
            when 3
                puts "3. Consultar peli"
                break
            when 4
                puts "\nGracias por usar Lambdabuster"
                puts "Nos vemos en la proxima :D"
                exit(0)
            else
                puts "\nPrueba una opcion valida :3"
            end
        end
    else
        my_movie=nil
        movie.each do |x|
            puts "\nPelicula encontrada: #{x.name}"
            puts "Duracion: #{x.runtime}"
            puts "Categorias: #{x.categories}"
            puts "Fecha de lanzamiento: #{x.release_date}"
            puts "Directors: #{x.directors}"
            puts "Actores: #{x.actors}"
            puts "Precio de compra: #{x.price}"
            puts "Precio para rentar: #{x.rent_price}"
            my_movie=x
        end
        while true
            puts "\nElige el metodo de pago que mejor se adapte:"
            puts "1. Dolares"
            puts "2. Bolivares"
            puts "3. Euros"
            puts "4. Bitcoin"
            option = gets.chomp.to_i
            currency=my_movie.method(my_price).call.dolars
            case option
            when 1
                break
            when 2
                puts "Precio: #{currency.in(:bolivares).to_s}"
                break
            when 3
                puts "Precio: #{currency.in(:euros).to_s}"
                break
            when 4
                puts "Precio: #{currency.in(:bitcoin).to_s}"
                break
            else
                puts "\nPrueba una opcion valida"
            end  
        end
        puts "Precio: #{currency.to_s}"
        while true
            puts "\n1. Continuar"
            puts "2. Volver al menu inicial"
            option = gets.chomp.to_i
            case option
            when 1
                transaction=Transaction.new(my_movie,type)
                method(action).call(transaction)
                user.method(store)<<my_movie
                user.method("transactions")<<transaction
                puts "\nLa pelicula se ha #{verb_in_past} con exito!!"
                puts "Ya la tienes disponible en tu perfil"
                puts "Que la disfrutes :D"
                break
            when 2
                break
            else
                puts "\nPrueba una opcion valida"
            end

        end
    end
end

#JSON READER
def readJson(path) 
    @directorsList = {}
    @actorsList = {}
    @moviesList = SearchList.new()
    @moviesChecker = {}
    @personsList = {}
    @categories = Set.new
    begin 
    file = File.read(path)
    data_hash = JSON.parse(file)
    result = true
     # "try" block
        for director in data_hash['directors'] 
            if @directorsList.keys.include? director['name']
                throw "The Director: #{director['name']} has been registered before"
            else
                auxDir = Director.new(director['name'],Date.parse(director['birthday']), director['nationality'])
                @directorsList[director['name']] = auxDir
                @personsList[director['name']] = auxDir
            end
            
        end
        for actor in data_hash['actors']
            if  @actorsList.keys.include?actor['name']
                throw "The Actor: #{actor['name']} has been registered before"
                
            else
                auxAct = Actor.new(actor['name'],Date.parse(actor['birthday']), actor['nationality'])
                @actorsList[actor['name']] = auxAct
                if @personsList.keys.include?actor['name'] 
                    throw "The Actor: #{actor['name']} has been registered as director"
                else 
                    @personsList[actor['name']] = auxAct
                end
            end
        end
        for movie in data_hash['movies']
            # puts movie
            if @moviesChecker.keys.include?movie['name']
                throw "The Movie: #{movie['name']} has been registered before"
            else
                # puts loadMovie(movie)
                auxMov = loadMovie(movie)
                @moviesList << auxMov
                @moviesChecker[movie['name']]= auxMov
                for category in movie['categories']
                    @categories << category
                end
            end
            
        end
    rescue StandardError => e# optionally: `rescue Exception => ex`
        result =  false
        puts e
        raise "Error to load JSON"
    ensure # will always get executed
        # puts "Movies #{@moviesList}"

        if result 
            return @directorsList,@actorsList,@moviesList,@categories,@personsList
        else 
            return false
        end
    end 
    
    # puts directorsList
    
end

def loadMovie(movieObj)
    # puts "We are in load"
    # puts movieObj
    begin
        movie = Movie.new(
            movieObj['name'],
            Integer(movieObj['runtime']),
            movieObj['categories'],
            Date.parse(movieObj['release_date']), 
            movieObj['directors'],
            movieObj['actors'],
            Float(movieObj['price']),
            Float(movieObj['rent_price']),
            movieObj['premiere'],
            Integer(movieObj['discount'])
        )
        if Integer(movieObj['discount']) > 0
            movie = Discount.new(movie)
        end
    
        if movieObj['premiere'] == true
            movie = Premiere.new(movie)
        end
    rescue StandardError => e
        puts e
    ensure
        return movie
    end  
    
    movie
end

# CONSULT MOVIES
def create_comparison_condition()
    while true
        puts "\n¿Con qué comparación?"
        puts "1. Menor"
        puts "2. Menor o igual"
        puts "3. Igual"
        puts "4. Mayor o igual"
        puts "5. Mayor"
        puts ""
        puts "Inserta el numero de la opcion"
        option = gets.chomp.to_i
        case option
        when 1
            resp="<"
            break
        when 2
            resp="<="
            break
        when 3
            resp="=="
            break
        when 4
            resp=">="
            break
        when 5
            resp=">"
            break
        else
            puts "\nPrueba una opcion valida :S"
        end
    end
    resp
end

def create_coincidence_condition()
    while true
        puts "\n¿Con qué comparación?"
        puts "1. Coincidencia exacta"
        puts "2. Coincidencia pacial"
        puts ""
        puts "Inserta el numero de la opcion"
        option = gets.chomp.to_i
        case option
        when 1
        when 2
        else
            puts "\nPrueba una opcion valida"
        end
    end
end

def create_result_menu()
    while true
        puts "\n1. Aplicar otro filtro"
        puts "2. Buscar"
        puts ""
        puts "Inserta el numero de la opcion"
        option = gets.chomp.to_i
        case option
        when 1
        when 2
        else
            puts "\nPrueba una opcion valida :3"
        end
    end
end

def consult_movies(movies):
    while true
        puts "\nQue accion quiere realizar?"
        puts "1. Mostrar todas las peliculas"
        puts "2. Filtrar"
        puts ""
        puts "Inserta el numero de la opcion"
        option = gets.chomp.to_i
        case option
        when 1
            movies.each do |x|
                x.to_s
            end
        when 2
            while true
                puts "\n¿Que filtro quieres aplicar?"
                puts "1. Nombre"
                puts "2. Año"
                puts "3. Nombre del director"
                puts "4. Nombre del actor"
                puts "5. Duracion"
                puts "6. Categorias"
                puts "7. Precio de compra"
                puts "8. Precio de alquiler"
                puts ""
                puts "Inserta el numero de la opcion"
                option = gets.chomp.to_i

                case option
                when 1
                    resp=create_order(movies,type)
                    break
                when 2
                    resp=1
                    break
                when 3
                    puts "3. Consultar peli"
                    break
                when 4
                    break
                else
                    puts "\nPrueba una opcion valida :3"
                end
            end
        else
            puts "\nPrueba una opcion valida"
        end
    end
end








class Main
    # FUNCTIONS
    def self.get_path
        puts "\nPor favor ingrese la direccion desde donde se cargaran los archivo"
        path = gets.chomp
    end
    @user = User.new

    #myUser
    def myUser 
        if @user.owned_movies.empty? && @user.rented_movies.empty?
            self.clear()
            puts "No has realizado transacciones en #{"Lambdabuster".bold()}"
        end

        puts "Listado de Peliculas alquiladas: " + "\n" + "#{@user.rented_movies}" 
        puts "Listado de Peliculas compradas: " + "\n" + "#{@user.owned_movies}" 

    end

    # MAIN
    

    puts "**************************"
    puts "Bienvenido a Lambdabuster\n"

    while true
        path = self.get_path()
        charge_data = readJson(path) #Funcion que carga los datos
        if charge_data == false
            puts "\nLo sentimos, no pudimos cargar los datos :("
            puts "\nAsegurate de haber colocado la ruta retaliva"
            puts "y la estructura del archivo correcta para el programa"
            puts "\nOpciones:"
            puts "1. Reintentar"
            puts "2. Salir"
            option = gets.chomp.to_i
            if option != 1
                exit(0)
            end
        else
            puts "\nDatos cargados con exito :D"
            break
        end
    end

    while true
        puts "\nQue accion quiere realizar?"
        puts "1. Crear nueva orden de alquiler"
        puts "2. Crear nueva orden de compra"
        puts "3. Mi Usuario"
        puts "4. Consultar catálogo"
        puts "5. Salir"
        puts ""
        puts "Inserta el numero de la opcion"
        option = gets.chomp.to_i

        case option
        when 1
            puts "1. Crear nueva orden de alquiler"
        when 2
            puts "2. Crear nueva orden de compra"
        when 3
            puts "3. Mi Usuario"
        when 4
            puts "4. Consultar catálogo"
        when 5
            puts "\nGracias por usar Lambdabuster"
            puts "Nos vemos en la proxima :D"
            exit(0)
        else
            puts "\nPrueba una opcion valida :3"
        end

    end



    
end