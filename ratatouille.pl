
% rata(nombre,dondeVive).

rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).

% cocina(nombre, plato, experiencia).

cocina(linguini, ratatouille, 3).
cocina(amelie, ratatouille, 10). % agregado
cocina(linguini, sopa, 5).
cocina(colette, sopa, 4). % agregado
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).

% trabajaEn(quien, donde).
% trabajaEn(Persona, Restaurante).

trabajaEn(linguini, gusteaus).
trabajaEn(colette, gusteaus).
trabajaEn(skinner, gusteaus).
trabajaEn(horst, gusteaus).
trabajaEn(amelie, cafeDes2Moulins).

% 1

restaurante(Restaurante):-
    trabajaEn(_, Restaurante).
    

inspeccionSatisfactoria(Restaurante):-
    restaurante(Restaurante),
    not(rata(_,Restaurante)).

% 2

chef(Empleado, Restaurante):-
    trabajaEn(Empleado, Restaurante),
    cocina(Empleado, _, _).


% 3

chefcito(Rata):-
    rata(Rata, Restaurante),
    trabajaEn(linguini, Restaurante).

% 4

cocinaBien(Persona, Plato):-
    cocina(Persona, Plato, Experiencia),
    Experiencia > 7.

cocinaBien(remy, Plato):-
    plato(Plato).

% 5
% el que tiene mas experiencia preparando el plato
% linguini ratatouille gusteaus /

plato(Plato):-
    cocina(_,Plato,_).

encargadoDe(Encargado, Plato, Restaurante):-
    trabajaEn(Encargado,Restaurante),
    cocina(Encargado, Plato, Experiencia),
    forall((trabajaEn(OtroCocinero,Restaurante),OtroCocinero \= Encargado, cocina(OtroCocinero, Plato, Experiencia2)), Experiencia >= Experiencia2).

% Intermedio
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 25)).
plato(frutillasConCrema, postre(265)).
plato(chocolate, postre(100)).
plato(flan, postre(74)).
% Fin Intermedio

% 6

grupo(chocolate).

saludable(Plato):-
    calorias(Plato, Calorias),
    Calorias < 75.

saludable(Plato):-
    plato(Plato, postre(_)),
    grupo(Plato).

calorias(Plato, Calorias):-
    plato(Plato, entrada(Ingredientes)),
    length(Ingredientes, Cantidad),
    Calorias is Cantidad * 15.

calorias(Plato, Calorias):-
    plato(Plato, principal(Guarnicion, MinCoccion)),
    caloriasPorGuarnicion(Guarnicion, ValorGuarnicion),
    Calorias is MinCoccion * 5 + ValorGuarnicion.

calorias(Plato, Calorias):-
    plato(Plato, postre(Calorias)).


caloriasPorGuarnicion(pure, 20).
caloriasPorGuarnicion(papasFritas, 50).
caloriasPorGuarnicion(ensalada, 0).

% 7

criticaPositiva(Restaurante,Critico):-
    inspeccionSatisfactoria(Restaurante),
    criterio(Critico, Restaurante).


criterio(antonEgo, Restaurante):-
    especialistasEn(ratatouille, Restaurante).

criterio(christophe, Restaurante):-
    trabajaEn(Persona, Restaurante),
    findall(Persona, chef(Persona, Restaurante), Chefs),
    length(Chefs, Cantidad),
    Cantidad > 3.
    

criterio(cormillot, Restaurante):-
    forall((trabajaEn(Persona, Restaurante), cocina(Persona, Plato,_)), saludable(Plato)),
    ningunaEntradaSin(zanahoria, Restaurante).

ningunaEntradaSin(Ingrediente, Restaurante):-
    forall((trabajaEn(Persona, Restaurante), cocina(Persona, Plato,_), plato(Plato, entrada(Ingredientes))), tieneIngrediente(Ingrediente, Ingredientes)).
    
tieneIngrediente(Ingrediente, Ingredientes):-
    member(Ingrediente, Ingredientes).


especialistasEn(Plato, Restaurante):-
    % se es especialista en un plato cuando todos los chef saben cocinar bien ese plato
    menu(Restaurante, Plato),
    forall((trabajaEn(Persona, Restaurante), cocina(Persona, Plato,_)), cocinaBien(Persona, Plato)).


menu(Restaurante, Plato) :-
    trabajaEn(Cocinere, Restaurante),
    cocina(Cocinere, Plato ,_).

    hago una modificacion
    awdklajwdlkajd
    awjdbwakdjhawlk