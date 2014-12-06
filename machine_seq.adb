package body machine_seq is

	PFORMES : pForme_List_T;
	TAILLE_FORMES_LIST_TAB : Integer;
	INDEX_COURANT : Integer;
	COURANT : Forme_List;

	--
	-- procedure Demarrer
	-- la fonction demarer met en place les elements de la machine sequentielle
	-- @param aFormes : pointeur sur le tableau de liste de formes à utiliser
	-- @param aSize : taille du tableau aFormes
	--
	procedure demarrer(aFormes : in pForme_List_T; aSize : in Integer) is
	begin
		PFORMES := aFormes;
		TAILLE_FORMES_LIST_TAB := aSize;
		INDEX_COURANT := 0;
		COURANT := PFORMES.all(INDEX_COURANT);

		while COURANT = NULL and INDEX_COURANT < TAILLE_FORMES_LIST_TAB-1 loop
			INDEX_COURANT := INDEX_COURANT + 1;
			COURANT := PFORMES.all(INDEX_COURANT);
		end loop;
	end demarrer;

	--
	-- fonction finDeSequence
	-- la fonction retourne vrai si la machine sequentielle à atteint le dernier élément.
	-- @return boolean : true si machine sequentielle à atteint le dernier élément, false sinon
	--
	function finDeSequence return Boolean is
	begin -- finDeSequence
		return (COURANT = NULL);
	end finDeSequence;

	--
	-- procedure avancer
	-- la procedure avancer change l'élement courant en tant que l'element suivant. L'élement courant est, si il existe, le successeur de l'element courant, ou la prochaine case non vide du tableau.
	--
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

	--
	-- fonction elementCourant
	-- la fonction retourne l'element courant de la machine sequentielle
	-- @return Forme : Element courant de la machine sequentielle
	--
	function elementCourant return Forme is
	begin
		return COURANT.all.F;
	end elementCourant;

end machine_seq;
