package body machine_seq is

	PFORMES : pForme_List_T;
	TAILLE_FORMES_LIST_TAB : Integer;
	INDEX_COURANT : Integer;
	COURANT : Forme_List;

	procedure demarrer(aFormes : pForme_List_T; aSize : Integer) is
	begin -- demarrer
		PFORMES := aFormes;
		TAILLE_FORMES_LIST_TAB := aSize;
		INDEX_COURANT := 0;
		COURANT := PFORMES.all(INDEX_COURANT);

		while COURANT = NULL and INDEX_COURANT < TAILLE_FORMES_LIST_TAB-1 loop
			INDEX_COURANT := INDEX_COURANT + 1;
			COURANT := PFORMES.all(INDEX_COURANT);
		end loop;
	end demarrer;

	function finDeSequence return Boolean is
	begin -- finDeSequence
		return (COURANT = NULL);
	end finDeSequence;

	procedure avancer is
	begin -- avancer
		if(COURANT.all.succ /= NULL) then
			COURANT := COURANT.all.succ;
		else
			COURANT := NULL;
			while COURANT = NULL and INDEX_COURANT < TAILLE_FORMES_LIST_TAB-1 loop
			INDEX_COURANT := INDEX_COURANT + 1;
				COURANT := PFORMES.all(INDEX_COURANT);
			end loop;
		end if;
	end avancer;

	function elementCourant return Forme is
	begin -- elementCourant
		return COURANT.all.F;
	end elementCourant;


end machine_seq;