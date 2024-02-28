** Progetto di reti logiche.
*** Politecnico di Milano - anno accademico 2023/2024.

* * Situazione attuale: * *
il progetto realizzato simula correttamente sul testbench fornito. La sintesi avviene correttamente così come la simulazione funzionale post-sintesi. 
Dall'analisi dei report si evince che sono stati generati 52 flip-flop e nessun latch. Inoltre, sono stati rispettati i requisiti di tempo con uno slack di 16.157ns.

* * Prossimi passi: * *
1. Sistemare alcuni controlli sui segnali di abilitazione del MUX in relazione all'aggiornamento del segnale o_mem_data. Valutare anche i fronti di abilitazione
della scrittura in memoria.

2. Individuare possibili casi critici e generare testbench che li coprano.
