% RESOLUCION LOGICO %

comercioAdherido(iguazu, grandHotelIguazu).
comercioAdherido(iguazu, gargantaDelDiabloTour).
comercioAdherido(bariloche, aerolineas).
comercioAdherido(iguazu, aerolineas).
comercioAdherido(buenosAires, hilton).
valorMaximoHotel(5000).

%factura(Persona, DetalleFactura).
%Detalles de facturas posibles:
% hotel(ComercioAdherido, ImportePagado)
% excursion(ComercioAdherido, ImportePagadoTotal, CantidadPersonas)
% vuelo(NroVuelo,NombreCompleto)

%factura(Persona, DetalleFactura)
factura(estanislao, hotel(grandHotelIguazu, 2000)).
factura(antonieta, excursion(gargantaDelDiabloTour, 5000, 4)).
factura(antonieta, vuelo(1515, antonietaPerez)).

%Datos que agregué de prueba
factura(pedro, hotel(grandHotelParaguay, 6000)).
factura(pedro, hotel(grandHotelIguazu, 1000)).
factura(juan, vuelo(1514, juanPerez)).

%Solo tiene facturas truchas
factura(elGigolo, hotel(hilton, 60000)).
factura(elGigolo, excursion(elMacriBus, 10000, 3)).

%Solo tiene facturas de monto 0
factura(elEstafadorDeTinder, hotel(hilton, 0)).
factura(elEstafadorDeTinder, excursion(grandHotelIguazu, 0, 3)).

%Solo tiene facturas truchas o de monto 0
factura(elEvasorDeImpuestos, hotel(hilton, 0)).
factura(elEvasorDeImpuestos, hotel(grandHotelIguazu, 90000)).
factura(elEvasorDeImpuestos, vuelo(1513, evasorGonzales)).

%registroVuelo(NroVuelo,Destino,ComercioAdherido,Pasajeros,Precio)
registroVuelo(1515, iguazu, aerolineas, [estanislaoGarcia, antonietaPerez, danielIto], 10000).
%Dato para que exceda el tope de devolución y ver que devuelve 100000.
registroVuelo(1514, bariloche, aerolineas, [juanPerez, irinaPerez, danielPerez], 100000000000000000000000).
registroVuelo(1513, buenosAires, aerolineas, [moriaCasan, gracielaAlfano, anibalPachano], 20000).

/*De las facturas válidas se devuelve:
En caso de hoteles: un 50% del monto pagado
En caso de vuelos: un 30% del monto, excepto que el destino sea Buenos Aires en cuyo caso no se devuelve nada.
En caso de excursiones: un 80% del monto por persona (dividir por la cantidad de personas que participó)*/
devolucionFactura(Devolucion, hotel(_, Monto)):-
    Devolucion is Monto/2.
devolucionFactura(Devolucion, vuelo(NumeroVuelo, _)):-
    registroVuelo(NumeroVuelo, Destino, _, _, Monto),
    Destino \= buenosAires,
    Devolucion is Monto*30/100.
devolucionFactura(Devolucion, excursion(_, Monto, CantidadPersonas)):-
    Devolucion is (Monto/CantidadPersonas)*80/100.

%Aquellas facturas que son para un comercio que no está adherido al programa se consideran truchas. También son truchas las facturas de hotel por un monto superior al precio por habitación máximo establecido. Si una factura corresponde a un vuelo en el que no hay una persona con su nombre completo en el registro del vuelo, se considera trucha. 
facturaTrucha(hotel(Comercio, _)):-
    not(comercioAdherido(_, Comercio)).
facturaTrucha(excursion(Comercio, _, _)):-
    not(comercioAdherido(_, Comercio)).
facturaTrucha(vuelo(NumeroVuelo, _)):-
    registroVuelo(NumeroVuelo, _, Comercio, _, _),
    not(comercioAdherido(_, Comercio)).

facturaTrucha(hotel(_, Monto)):-
    valorMaximoHotel(MontoMaximo),
    Monto > MontoMaximo.
facturaTrucha(vuelo(NumeroVuelo, NombreCompleto)):-
    registroVuelo(NumeroVuelo, _, _, PersonasQueViajan, _),
    not(member(NombreCompleto, PersonasQueViajan)).

/* PUNTO 1 */
% El monto a devolver a cada persona que presentó facturas
/* El dinero que se le devuelve a una persona se calcula sumando la devolución correspondiente a cada una de las facturas válidas (que no sean truchas), más un adicional de $1000 por cada ciudad diferente en la que se alojó. Hay una penalidad de $15000 si entre todas las facturas presentadas hay alguna que sea trucha. Además, el monto máximo a devolver es de $100000. */
cantidadCiudadesDondeSeAlojo(Persona, Cantidad):-
    findall(Ciudad, (factura(Persona, hotel(Nombre, _)), comercioAdherido(Ciudad, Nombre)), Ciudades),
    length(Ciudades, Cantidad).
    
montoADevolverPorCiudades(Persona, Monto):-
    cantidadCiudadesDondeSeAlojo(Persona, Cantidad),
    Monto is Cantidad * 1000.

tieneFacturaTrucha(Persona):-
    factura(Persona, Factura),
    facturaTrucha(Factura).

penalidadSiTieneONoFacturasTruchas(Persona, -15000):-
    tieneFacturaTrucha(Persona).

penalidadSiTieneONoFacturasTruchas(Persona, 0):-
    not(tieneFacturaTrucha(Persona)).

montoADevolverSegunTope(Monto, 100000):-
    Monto > 100000.
montoADevolverSegunTope(Monto, Monto):-
    Monto =< 100000.

montoADevolverTotal(Persona, MontoTotalConTope):-
    factura(Persona, _),
    findall(Monto, (factura(Persona, Factura),  devolucionFactura(Monto, Factura), (not(facturaTrucha(Factura)))), Montos),
    sum_list(Montos, MontoPorFacturas),
    montoADevolverPorCiudades(Persona, MontoPorCiudades),
    penalidadSiTieneONoFacturasTruchas(Persona, MontoPorFacturasTruchas),
    MontoTotal is (MontoPorFacturas + MontoPorCiudades + MontoPorFacturasTruchas),
    montoADevolverSegunTope(MontoTotal, MontoTotalConTope).

/* PUNTO 2 */
/*Qué destinos son sólo de trabajo. Son aquellos destinos que si bien tuvieron vuelos hacia ellos, no tuvieron ningún turista que se alojen allí o tienen un único hotel adherido. */
destinoDeTrabajo(Destino):-
    registroVuelo(_, Destino, _, _, _),
    noTuvoTuristasOTieneUnUnicoHotelAdherido(Destino).

noTuvoTuristasOTieneUnUnicoHotelAdherido(Destino):-
    noTuvoTuristas(Destino).
noTuvoTuristasOTieneUnUnicoHotelAdherido(Destino):-
    tieneUnUnicoHotelAdherido(Destino).

noTuvoTuristas(Destino):-
    not((factura(_, hotel(NombreHotel, _)), comercioAdherido(Destino, NombreHotel))).

tieneUnUnicoHotelAdherido(Destino):-
    findall(Hotel, (comercioAdherido(Destino, Hotel), factura(_, hotel(Hotel, _))) , HotelesConRepetidos),
    list_to_set(HotelesConRepetidos, Hoteles),    
    length(Hoteles, 1).

/* PUNTO 3 */
/*Saber quiénes son estafadores, que son aquellas personas que sólo presentaron facturas truchas o facturas de monto 0.*/
esEstafador(Persona):-
    factura(Persona, _),
    forall(factura(Persona, Factura), facturaTruchaODeMontoCero(Factura)).

facturaTruchaODeMontoCero(Factura):-
    facturaTrucha(Factura).
facturaTruchaODeMontoCero(hotel(_, 0)).
facturaTruchaODeMontoCero(excursion(_, 0, _)).
facturaTruchaODeMontoCero(vuelo(NumeroVuelo, _)):-
    registroVuelo(NumeroVuelo, _, _, _, 0).

/* PUNTO 4 */
/*Inventar un nuevo tipo de comercio adherido no trivial pero que no implique escribir mucho código nuevo, y que todo siga funcionando correctamente. Explicar el concepto que nos permite hacer eso sin reescribir otros predicados.*/

% localGastronomico(ComercioAdherido, ImportePagado, Comensales, MetodoDePago)
:- discontiguous comercioAdherido/2.
comercioAdherido(sanJuan, granRestaurante).
comercioAdherido(sanJuan, burguerKing).
:- discontiguous factura/2.
factura(florencia, localGastronomico(granRestaurant, 5000, 2, efectivo)).
factura(marcos, localGastronomico(granRestaurant, 4000, 7, tarjetaCredito)).
factura(maria, localGastronomico(burguerKing, 10001, 1, mercadoPago)).

% Como el nuevo tipo de comercio es un functor y los predicados que utilicé son polimórficos, no es necesario reescribirlo, solamente agregar nuevas reglas que consideren el nuevo functor.

%Devolución en caso de locales gastronómicos: un 40% del monto pagado si son al menos 10 comensales y un 20% si son menos.
:- discontiguous devolucionFactura/2.
devolucionFactura(Devolucion, localGastronomico(_, Monto, Comensales, _)):-
    Comensales >= 10,
    Devolucion is Monto*40/100.
devolucionFactura(Devolucion, localGastronomico(_, Monto, Comensales, _)):-
    Comensales < 10,
    Devolucion is Monto*20/100.

%Aquellas facturas que son para un comercio que no está adherido al programa se consideran truchas. También son truchas las facturas de local gastronómico si son menos de 4 personas y el monto supera los 10000.
:- discontiguous facturaTrucha/1.
facturaTrucha(localGastronomico(Comercio, _, _, _)):-
    not(comercioAdherido(_, Comercio)).
facturaTrucha(localGastronomico(_, Monto, Comensales, _)):-
    Monto > 10000,
    Comensales < 4.