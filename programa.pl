vuelo(arg845, 30, [escala(rosario,0), tramo(2), escala(buenosAires,0)]).
vuelo(mh101, 95, [escala(kualaLumpur,0), tramo(9), escala(capeTown,2), tramo(15), escala(buenosAires,0)]).
vuelo(dlh470, 60, [escala(berlin,0), tramo(9), escala(washington,2), tramo(2), escala(nuevaYork,0)]).
vuelo(aal1803, 250, [escala(nuevaYork,0), tramo(1), escala(washington,2), tramo(3), escala(ottawa,3),
    tramo(15), escala(londres,4), tramo(1), escala(paris,0)]).
vuelo(ble849, 175, [escala(paris,0), tramo(2), escala(berlin,1), tramo(3), escala(kiev,2), tramo(2),
    escala(moscu,4), tramo(5), escala(seul,2), tramo(3), escala(tokyo,0)]).
vuelo(npo556, 150, [escala(kiev,0), tramo(1), escala(moscu,3), tramo(5),
    escala(nuevaDelhi,6), tramo(2), escala(hongKong,4), tramo(2), escala(shanghai,5), tramo(3), escala(tokyo,0)]).
vuelo(dsm3450, 75, [escala(santiagoDeChile,0), tramo(1), escala(buenosAires,2), tramo(7), escala(washington,4),
    tramo(15), escala(berlin,3), tramo(15), escala(tokyo,0)]).

vuelo(lento123, 30, [escala(rosario,4), tramo(1), escala(buenosAires,4)]).

%%% PUNTO 1
tiempoTotalVuelo(Vuelo,TiempoTotal):-
    vuelo(Vuelo,_,Destinos),
    findall(Tiempo,(member(Destino,Destinos),tiempoDestino(Tiempo,Destino)),Tiempos),
    sum_list(Tiempos,TiempoTotal).

tiempoDestino(Tiempo,escala(_,Tiempo)).
tiempoDestino(Tiempo,tramo(Tiempo)).   

%%% PUNTO 2
escalaAburrida(Vuelo,Destino):-
    vuelo(Vuelo,_,Destinos),
    member(Destino,Destinos),
    esEscalaAburrida(Destino).

esEscalaAburrida(escala(_,Tiempo)):-
    Tiempo>3.

%%% PUNTO 3
ciudadesAburridas(Vuelo,CiudadesAburridas):-
    vuelo(Vuelo,_,Destinos),
    findall(Ciudad,ciudadAburrida(Ciudad,Destinos),CiudadesAburridas).

ciudadAburrida(Ciudad,Destinos):-
    member(Destino,Destinos),
    esEscalaAburrida(Destino),
    ciudad(Ciudad,Destino).

ciudad(Ciudad,escala(Ciudad,_)).

%%% PUNTO 4
vueloLargo(Vuelo):-
    tiempoEnElAire(Vuelo,Tiempo),
    Tiempo>=10.

tiempoEnElAire(Vuelo,TiempoAire):-
    vuelo(Vuelo,_,Destinos),
    findall(Tiempo, member((tramo(Tiempo)),Destinos),Tiempos),
    sum_list(Tiempos,TiempoAire).

conectados(Vuelo,OtroVuelo):-
    vuelo(Vuelo,_,Destinos),
    vuelo(OtroVuelo,_,OtrosDestinos),
    Vuelo\=OtroVuelo,
    compartenCiudad(Destinos,OtrosDestinos).

compartenCiudad(Destinos,OtrosDestinos):-
    member(Destino,Destinos),
    member(OtroDestino,OtrosDestinos),
    ciudad(Ciudad,Destino),
    ciudad(Ciudad,OtroDestino).
    
%%% PUNTO 5
bandaDeTres(Vuelo1,Vuelo2,Vuelo3):-
    conectados(Vuelo1,Vuelo2),
    conectados(Vuelo2,Vuelo3).

%%% PUNTO 6
distanciaEnEscalas(Ciudad1,Ciudad2,Distancia):-
    vuelo(_,_,Destinos),
    posicion(Ciudad1,Posicion1,Destinos),
    posicion(Ciudad2,Posicion2,Destinos),
    Ciudad1\=Ciudad2,
    distancia(Distancia,Posicion1,Posicion2).

posicion(Ciudad,Posicion,Destinos):-
    member(Destino,Destinos),
    ciudad(Ciudad,Destino),
    nth1(Posicion,Destinos,Destino).

distancia(Distancia,Posicion1,Posicion2):-
    Posicion1>Posicion2,
    cantidadDeTramos(Posicion1,Posicion2,Tramos),
    is(Distancia,Posicion1-Posicion2-Tramos).

distancia(Distancia,Posicion1,Posicion2):-
    Posicion1<Posicion2,
    cantidadDeTramos(Posicion2,Posicion1,Tramos),
    is(Distancia,Posicion2-Posicion1-Tramos).

cantidadDeTramos(Posicion1,Posicion2,Tramos):-
    is(Tramos,(Posicion1-Posicion2)/2).

%%% PUNTO 7
vueloLento(Vuelo):-
    vuelo(Vuelo,_,Destinos),
    not(vueloLargo(Vuelo)),
    forall(escalaDelViaje(Destino,Destinos),esEscalaAburrida(Destino)).

escalaDelViaje(escala(A,B),Destinos):-
    member(escala(A,B),Destinos).


/*
vueloLento/1: Un vuelo es lento si no es largo, y además cada escala es aburrida.
*/
