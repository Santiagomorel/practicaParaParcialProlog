
% esPersonaje(Personaje).
esPersonaje(aang).
esPersonaje(katara).
esPersonaje(zoka).
esPersonaje(appa).
esPersonaje(momo).
esPersonaje(toph).
esPersonaje(tayLee).
esPersonaje(zuko).
esPersonaje(azula).
esPersonaje(iroh).
esPersonaje(santiago).

% esElementoBasico(ElementoBasico).
esElementoBasico(fuego).
esElementoBasico(agua).
esElementoBasico(tierra).
esElementoBasico(aire).

% elementoAvanzadoDe(ElementoBasico, ElementoAvanzado)
elementoAvanzadoDe(fuego, rayo).
elementoAvanzadoDe(agua, sangre).
elementoAvanzadoDe(tierra, metal).

% controla(Personaje, Elemento)
controla(zuko, rayo).
controla(toph, metal).
controla(katara, sangre).
controla(aang, aire).
controla(aang, agua).
controla(aang, tierra).
controla(aang, fuego).
controla(azula, rayo).
controla(iroh, rayo).
controla(santiago, agua).

% visito(Persona, Lugar)

visito(aang, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo,sectorMedio])).
visito(iroh, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo,sectorMedio])).
visito(zuko, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo,sectorMedio])).
visito(toph, reinoTierra(fortalezaDeGralFong, [cuartel, dormitorios,enfermeria, salaDeGuerra, templo, zonaDeRecreo])).
visito(katara, tribuAgua(norte)).
visito(katara, tribuAgua(sur)).
visito(aang, nacionDelFuego(palacioReal, 1000)).
visito(aang, temploAire(norte)).
visito(aang, temploAire(oeste)).
visito(aang, temploAire(este)).
visito(aang, temploAire(sur)).
% agrega el personaje santiago
visito(aang, temploAire(sur)).
visito(aang, temploAire(sur)).
visito(katara, temploAire(sur)).
visito(santiago, temploAire(sur)).
visito(iroh, temploAire(sur)).
visito(toph, temploAire(sur)).


/*
1. saber qué personaje esElAvatar. El avatar es aquel personaje que controla todos los elementos básicos.
*/
esElAvatar(Personaje):-
    esPersonaje(Personaje),
    forall(esElementoBasico(Elemento), controla(Personaje, Elemento)).
    
/*
2. clasificar a los personajes en 3 grupos:
    ○ un personaje noEsMaestro si no controla ningún elemento, ni básico ni avanzado;
    ○ un personaje esMaestroPrincipiante si controla algún elemento básico pero ninguno avanzado;
    ○ un personaje esMaestroAvanzado si controla algún elemento avanzado. Es importante destacar que el avatar también es un maestro avanzado.
*/

noEsMaestro(Personaje):-
    esPersonaje(Personaje),
    not(controlaAlgunElementoBasico(Personaje)),
    not(controlaAlgunElementoAvanzado(Personaje)). 
    
controlaAlgunElementoBasico(Personaje):-
    controla(Personaje, Elemento),
    esElementoBasico(Elemento).

controlaAlgunElementoAvanzado(Personaje):-
    controla(Personaje, Elemento),
    elementoAvanzadoDe(_, Elemento).
    
esMaestroPrincipiante(Personaje):-
    esPersonaje(Personaje),
    controlaAlgunElementoBasico(Personaje),
    not(controlaAlgunElementoAvanzado(Personaje)).

esMaestroAvanzado(Personaje):-
    esPersonaje(Personaje),
    controlaAlgunElementoAvanzado(Personaje).

esMaestroAvanzado(Personaje):-
    esElAvatar(Personaje).

/*
3. saber si un personaje sigueA otro. Diremos que esto sucede si el segundo visitó
todos los lugares que visitó el primero. También sabemos que zuko sigue a aang.
*/

sigueA(UnPersonaje, OtroPersonaje):-
    esPersonaje(UnPersonaje),
    esPersonaje(OtroPersonaje),
    visito(UnPersonaje, Lugar),
    visito(OtroPersonaje, Lugar),
    UnPersonaje \= OtroPersonaje,
    elSegundoVisitoTodosLosLugaresQueElPrimero(UnPersonaje, OtroPersonaje).

sigueA(zuko, aang).

elSegundoVisitoTodosLosLugaresQueElPrimero(UnPersonaje, OtroPersonaje):-
    forall(visito(UnPersonaje, Lugar), visito(OtroPersonaje, Lugar)).

/*
4. conocer si un lugar esDignoDeConocer, para lo que sabemos que:
    ○ todos los templos aire son dignos de conocer;
    ○ la tribu agua del norte es digna de conocer;
    ○ ningún lugar de la nación del fuego es digno de ser conocido;
    ○ un lugar del reino tierra es digno de conocer si no tiene muros en su estructura.
*/

esDignoDeConocer(temploAire(_)).

esDignoDeConocer(tribuAgua(norte)).

esDignoDeConocer(reinoTierra(Reino, _)):-
    visito(_, reinoTierra(Reino, Estructuras)),
    not(member(muro, Estructuras)).

/*
5. definir si un lugar esPopular, lo cual sucede cuando fue visitado por más de 4 personajes.
*/

esPopular(Lugar):-
    visito(_, Lugar),
    fueVisitadoPorMasDeCuatroPersonas(Lugar).

fueVisitadoPorMasDeCuatroPersonas(Lugar):-
    findall(Visita, visito(Visita, Lugar), VisitasConRepetidos),
    list_to_set(VisitasConRepetidos, Visitas),
    length(Visitas, Cantidad),
    Cantidad > 4.

/*
6. Por último nos pidieron modelar la siguiente información en nuestra base de conocimientos sobre algunos personajes desbloqueables en el juego:
    ○ bumi es un personaje que controla el elemento tierra y visitó Ba Sing Se en el reino Tierra;
    ○ suki es un personaje que no controla ningún elemento y que visitó una prisión de máxima seguridad en la nación del fuego protegida por 200 soldados.
*/

esPersonaje(bumi).
esPersonaje(suki).

controla(bumi, tierra).

visito(bumi, reinoTierra(baSingSe, [muro, zonaAgraria, sectorBajo,sectorMedio])).
visito(suki, nacionDelFuego(prision, 200)).