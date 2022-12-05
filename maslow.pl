% https://docs.google.com/document/d/14wHR2fvpkAaUC7LAxkjo01wc34LcOHANhJ-rULrrlFg/edit

/*
1 -Agregar hechos para completar la información de las necesidades y niveles con algunos de los ejemplos mencionados e inventando 
nuevas necesidades e incluso niveles. Se asume que los niveles son distintos y están ordenados jerárquicamente entre sí, que no hay 
niveles sin necesidades y que una misma necesidad no puede estar en dos niveles a la vez. 
*/

% necesidad(Necesidad, NivelJerarquico).

necesidad(respiracion,  fisiologico). %0
necesidad(alimentacion, fisiologico).
necesidad(descanso,  fisiologico).
necesidad(reproduccion, fisiologico).

necesidad(integridadFisica, seguridad). %1
necesidad(empleo,           seguridad).
necesidad(salud,            seguridad).

necesidad(amistad,   social). %2
necesidad(afecto,    social).
necesidad(intimidad, social).
necesidad(queLoEmpachenUnPoco, social).

necesidad(confianza, reconocimiento). %3
necesidad(respeto,   reconocimiento).
necesidad(exito,     reconocimiento).

necesidad(libertad, autorealizacion). %4

% nivelSuperior(NivelSuperior, NivelActual).

nivelSuperior(autorrealizacion, reconocimiento).
nivelSuperior(reconocimiento, social).
nivelSuperior(social, seguridad).
nivelSuperior(seguridad, fisiologico).

/*
2 -Permitir averiguar la separación de niveles que hay entre dos necesidades, es decir la cantidad de niveles que hay entre una y otra.
Por ejemplo, con los ejemplos del texto de arriba, la separación entre empleo y salud es 0, y la separación entre respiración y confianza es 3.
*/

nivelesEntreNecesidad(Necesidad1, Necesidad2, CantidadDeNiveles):-
    necesidad(Necesidad1, Nivel1),
    necesidad(Necesidad2, Nivel2),
    separacionEntreNiveles(Nivel1, Nivel2, CantidadDeNiveles).

nivelesEntreNecesidad(Necesidad1, Necesidad2, CantidadDeNiveles):-
    necesidad(Necesidad1, Nivel1),
    necesidad(Necesidad2, Nivel2),
    separacionEntreNiveles(Nivel2, Nivel1, CantidadDeNiveles).

separacionEntreNiveles(Nivel, Nivel, 0).

separacionEntreNiveles(Nivel1, Nivel2, CantidadDeNiveles):-
    nivelSuperior(NivelIntermedio, Nivel1),
    separacionEntreNiveles(NivelIntermedio, Nivel2, CantIntermedio),
    CantidadDeNiveles is CantIntermedio + 1.

/*3- Modelar las necesidades (sin satisfacer) de cada persona. 
Recuerden leer los puntos siguientes para saber cómo se va a usar y cómo modelar esta información.
Por ejemplo:
    - Carla necesita alimentarse, descansar y tener un empleo. 
    - Juan no necesita empleo pero busca alguien que le brinde afecto. Se anotó en la facu porque desea ser exitoso. 
    - Roberto quiere tener un millón de amigos. 
    - Manuel necesita una bandera para la liberación, no quiere más que España lo domine ¡no señor!.
    - Charly necesita alguien que lo emparche un poco y que limpie su cabeza.
*/

necesidadSinSatisfacerDe(carla, alimentacion).
necesidadSinSatisfacerDe(carla, empleo).
necesidadSinSatisfacerDe(carla, descanso).

necesidadSinSatisfacerDe(juan, afecto).
necesidadSinSatisfacerDe(juan, exito).

necesidadSinSatisfacerDe(roberto, amistad).

necesidadSinSatisfacerDe(manuel, libertad).

necesidadSinSatisfacerDe(charly, queLoEmpachenUnPoco).

/*
4- Encontrar la necesidad de mayor jerarquía de una persona. 
En el caso de Carla, es tener un empleo.
*/

necesidadDeMayorJerarquiaSinSatisfacer(Persona, Necesidad):-
    necesidadSinSatisfacerDe(Persona, Necesidad),
    necesidad(Necesidad, Nivel),
    forall((necesidadSinSatisfacerDe(Persona, OtraNecesidad),necesidad(OtraNecesidad, NivelDeLaOtra)), not(nivelSuperior(NivelDeLaOtra, Nivel))).

/*
5- Saber si una persona pudo satisfacer por completo algún nivel de la pirámide.
Por ejemplo, Juan pudo satisfacer por completo el nivel fisiologico.
*/

% no tiene ninguna necesidadSinSatisfacer de ese nivel y no tiene ninguna necesidad de niveles de abajo

pudoSatisfacer(Persona, Nivel1):-
    nivelBase(Nivel1),
    noTieneNingunaNecesidadDeEseNivel(Persona, Nivel1).

pudoSatisfacer(Persona, NivelNecesidad):-
    noTieneNingunaNecesidadDeEseNivel(Persona, NivelNecesidad),
    noTieneNingunaNecesidadDeNivelesInferiores(Persona, NivelNecesidad).

nivelBase(Nivel):-
    nivelSuperior(_,Nivel).
    

noTieneNingunaNecesidadDeEseNivel(Persona, NivelNecesidad):-
    forall(necesidad(Necesidad, NivelNecesidad), not(necesidadSinSatisfacerDe(Persona, Necesidad))).

noTieneNingunaNecesidadDeNivelesInferiores(Persona, NivelNecesidad):-
    nivelSuperior(NivelNecesidad, NivelInferior),
    pudoSatisfacer(Persona, NivelInferior).


/*

La teoría de Maslow plantea que la motivación de cualquier persona para actuar parte de sus necesidades y a medida que se 
satisfacen las necesidades más básicas se manifiestan otras, lo que hace que sus motivaciones también sean diferentes. 
En base a eso, uno de sus elementos centrales de es que las personas sólo atienden necesidades superiores cuando han 
satisfecho las necesidades inferiores. Por ejemplo, las necesidades de seguridad surgen cuando las necesidades 
fisiológicas están satisfechas. 

6- Definir los predicados que permitan analizar si es cierta o no la teoría de Maslow:
    - Para una persona en particular.
    - Para todas las personas.
    - Para la mayoría de las personas. 
*/

%para cada nivel satisfecho, el nivel inferior tambien está satisfecho
%maslowParaUnaPersona(Persona):-
%   forall(pudoSatisfacer(Persona, NivelSatisfecho), (nivelSuperior(NivelSatisfecho, InferiorAlNivelSatisfecho), pudoSatisfacer(Persona, InferiorAlNivelSatisfecho))).   

% maslowParaTodos:-
%   forall(necesidadSinSatisfacerDe(Persona, _), maslowParaUnaPersona(Persona)).


% maslowParaLaMayoria:-

%cantidadDePersonas(Cantidad):-
%findall(Persona, necesidadSinSatisfacerDe(Persona, _), PersonasConRepetidos),
%list_to_set(PersonasConRepetidos, PersonasSinRepetidos),
%length(PersonasSinRepetidos, Cantidad).