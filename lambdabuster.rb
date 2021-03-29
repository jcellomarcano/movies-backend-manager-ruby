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
    movie_name = gets.chomp
    # puts movie_name
    # puts movies
    movie=movies.scan(:name) { |x| x == movie_name}
    puts "Movie length #{movie.length}"
    if movie.length == 0
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
                resp=create_order(movies,type,user)
                break
            when 2
                resp=1
                break
            when 3
                consult_movies(movies)
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
        # puts movie
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
            # puts my_movie
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
                transaction.method(action).call(transaction)
                if type == :rent
                    user.rented_movies << my_movie
                else
                    user.owned_movies << my_movie
                end
                    user.transactions<<transaction
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
            resp = "=="
            break
        when 2
            resp = "include?"
            break
        else
            puts "\nPrueba una opcion valida"
        end
        resp
    end
end

def create_result_menu(searchlist)
    while true
        puts "\n1. Aplicar otro filtro"
        puts "2. Buscar"
        puts ""
        puts "Inserta el numero de la opcion"
        option = gets.chomp.to_i
        case option
        when 1
            movies=resp
            break
        when 2
            resp.to_s
            break
        else
            puts "\nPrueba una opcion valida :3"
        end
    end
    option
end

def consult_movies(movies)
    while true
        puts "\nQue accion quiere realizar?"
        puts "1. Mostrar todas las peliculas"
        puts "2. Filtrar"
        puts ""
        puts "Inserta el numero de la opcion"
        option = gets.chomp.to_i
        puts "Movies consult: #{movies}"
        case option
        when 1
            movies.each do |x|
                puts x
            end
            break
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
                    puts "\nInserte el nombre:"
                    my_name = gets.chomp
                    my_method=create_coincidence_condition()
                    resp=movies.scan(:name) { |x| x.method(my_method).call my_name }
                    op=create_result_menu(resp)
                    if op == 2
                        break
                    end
                when 2
                    puts "\nInserte el año:"
                    my_year = gets.chomp.to_i
                    my_method=create_comparison_condition()
                    resp=movies.scan(:date) { |x| x.year.method(my_method).call my_year }
                    op=create_result_menu(resp)
                    if op == 2
                        break
                    end
                when 3
                    puts "\nInserte el nombre del director:"
                    my_name = gets.chomp
                    my_method=create_coincidence_condition()
                    if my_method == "=="
                        resp=movies.scan(:directors) { |x| x.include? my_name }
                    else
                        resp=movies.scan(:directors) { |x| x.any? { |s| s.include? my_name } }
                    end
                    op=create_result_menu(resp)
                    if op == 2
                        break
                    end
                when 4
                    puts "\nInserte el nombre del actor:"
                    my_name = gets.chomp
                    my_method=create_coincidence_condition()
                    if my_method == "=="
                        resp=movies.scan(:directors) { |x| x.include? my_name }
                    else
                        resp=movies.scan(:directors) { |x| x.any? { |s| s.include? my_name } }
                    end
                    op=create_result_menu(resp)
                    if op == 2
                        break
                    end
                when 5
                    puts "\nInserte la duracion:"
                    duration = gets.chomp.to_i
                    my_method=create_comparison_condition()
                    resp=movies.scan(:date) { |x| x.method(my_method).call duration }
                    op=create_result_menu(resp)
                    if op == 2
                        break
                    end
                when 6
                    filter_categories=Set.new()
                    while true
                        puts "\nSeleccione una categoria:"
                        counter=1
                        my_categories.each do |x|
                            puts "#{counter}. #{x}"
                            my_list_of_categies<<x
                            counter=counter+1
                        end
                        option = gets.chomp.to_i
                        if option > my_categories.length
                            puts "\nElige una opcion valida"
                        else
                            my_category=my_list_of_categies[option-1]
                            resp=movies.scan(:categories).select {|x| x.include? my_category}
                            while true
                                puts "\nQuieres seleccionar otra categoria?"
                                puts "1. Si"
                                puts "2. No"
                                puts ""
                                puts "Inserta el numero de la opcion"
                                option = gets.chomp.to_i
                                case option
                                when 1
                                    op=1
                                    break
                                when 2
                                    op=2
                                    break
                                else
                                    puts "\nElige una opcion valida"
                                end
                            end
                            if op == 2
                                op2=create_result_menu(resp)
                                if op2 == 2
                                    break
                                end
                            end
                        end
                    end
                    op=create_result_menu(resp)
                    if op == 2
                        break
                    end
                when 7
                    puts "\nInserte el precio de compra:"
                    my_price = gets.chomp.to_i
                    my_method=create_comparison_condition()
                    resp=movies.scan(:price) { |x| x.method(my_method).call my_price }
                    op=create_result_menu(resp)
                    if op == 2
                        break
                    end
                when 8
                    puts "\nInserte el precio de renta:"
                    my_price = gets.chomp.to_i
                    my_method=create_comparison_condition()
                    resp=movies.scan(:rent_price) { |x| x.method(my_method).call my_price }
                    op=create_result_menu(resp)
                    if op == 2
                        break
                    end
                else
                    puts "\nPrueba una opcion valida :3"
                end
                #movies=resp
            end
            
        else
            puts "\nPrueba una opcion valida"
        end
    end
end

def myUser (user, moviesList, personsList)
    puts "RentedList #{user.rented_movies.length}"
    if user.owned_movies.length == 0 && user.rented_movies.length == 0
        puts "No has realizado transacciones en #{"Lambdabuster"}"
        puts "Listado de Peliculas alquiladas: " + "\n" + "#{user.rented_movies}" 
        puts "Listado de Peliculas compradas: " + "\n" + "#{user.owned_movies}" 
        puts "Vuela a consultar despues de haber rentado o adquirido una"
        return
    end

    

    #menu for select option 
    while true
        puts "\n¿Quieres consultar alguna de tus películas?"
        puts "1. Si"
        puts "2. No"
        option = gets.chomp.to_i   
        case option 
        when 1
            while true 
                puts "\nIngresa el nombre de la película: \n"
                puts "Si deseas salir, escribe: salir"
                movie = gets.chomp
                case movie
                when "salir"
                    break
                else
                    if user.owned_movies.length != 0 && user.rented_movies.length != 0
                        a = user.owned_movies.scan(:name) {|x| x == movie}
                        b = user.rented_movies.scan(:name) {|x| x == movie}
                        if ( a.length == 0 ) && (b.length == 0)
                            puts "Lo siento, no tienes esta pelicula, puedes intentar buscar otra"
                            break
                        else
                            userMovie = (moviesList.scan(:name) {|name| name == movie}).first
                            puts "\n#{userMovie}\n"
                            while true
                                puts "\n¿Quieres conocer acerca de algun actor o director de esta peli?"
                                puts "Si"
                                puts "No"
                                response = gets.chomp
    
                                case response
                                when "Si"
                                    while true 
                                        puts "Ingrese nombre de actor o director"
                                        response2 = gets.chomp
                                        aux = false
                                        while (! movie.actors.include? response2) && (! movie.directors.include? response2)
                                            aux = true
                                            puts "Persona no encontrada"
                                        end
                                        if not aux
                                            puts "\n #{personsList[response2]}"
                                            break
                                        else
                                            break
                                        end
    
                                    end
                                when "No"
                                    break
                                else
                                    puts "Ingresa una seleccion válida"
                                end    
                            end
                        end
                    else
                        puts "No tienes peliculas rentadas o compradas"
                    end
                    
                end
            end
        when 2
            break
        else 
            puts "Porfavor, escoge una selección válida"
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
    @directorsList = {}
    @actorsList = {}
    @moviesList = SearchList.new()
    @moviesChecker = {}
    @personsList = {}
    @categories = Set.new
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
            @directorsList = charge_data[0] 
            @actorsList = charge_data[1]
            @moviesList = charge_data[2] 
            @personsList = charge_data[4] 
            @categories = charge_data[3]
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
            #puts "1. Crear nueva orden de alquiler"
            create_order(@moviesList,:rent,@user)
        when 2
            #puts "2. Crear nueva orden de compra"
            create_order(@moviesList,:buy,@user)

        when 3
            #puts "3. Mi Usuario"
            myUser(@user,@moviesList,@personsList)
        when 4
            #puts "4. Consultar catálogo"
            consult_movies(@moviesList)
        when 5
            puts "\nGracias por usar Lambdabuster"
            puts "Nos vemos en la proxima :D"
            exit(0)
        else
            puts "\nPrueba una opcion valida :3"
        end

    end
    
end