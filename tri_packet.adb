package body tri_packet is

	function getMinZForme(aForme : Forme; aSommets : pSommet_T) return Float is
		wMin : Float;
	begin -- retourne la valeur minimu de Z pour la forme F
		if(aForme.size > 0) then
			wMin := aSommets.all(aForme.sommets(0)).z;
			for wI in 1..(aForme.size-1) loop

				wMin := Float'min(wMin, aSommets.all(aForme.sommets(wI)).z);
			end loop;
		--else
			-- TODO : Exception Forme à 0 sommets
		end if;

		return wMin;
	end getMinZForme;

	function insertForme(aFormes : Forme_List; aSommets : pSommet_T; aForme : Forme) return Forme_List is
		wReturned : Forme_List := aFormes;
		wCourant : Forme_List := aFormes;
		wNewForme: Forme_List;
		wMinZ_courant : float;
	begin
		wNewForme := new Forme_List_Element;

		-- fait une copie complète de la forme.
		-- copie egalement tous le tableau alloué dynamiquement pour ne pas lier
		-- le cycle de vie des deux objets
		wNewForme.F.size := aForme.size;
		wNewForme.F.sommets := new Integer_T(0..(aForme.size-1));
		for wI in 0..(aForme.size-1) loop
			wNewForme.F.sommets(wI) := aForme.sommets(wI);
		end loop;

		wMinZ_courant := getMinZForme(aForme, aSommets);

		if (wReturned = NULL) then
			wNewForme.all.succ := NULL;
			wReturned := wNewForme;
		else
			while ( wCourant.all.succ /= NULL
				and then wMinZ_courant < getMinZForme(wCourant.all.succ.F, aSommets) ) loop
				wCourant := wCourant.all.succ;
			end loop;
			wNewForme.succ := wCourant.succ;
			wCourant.succ := wNewForme;
		end if;

		return wReturned;

	end insertForme;


	procedure triParPaquet(aFormesUnsorted : in Forme_List; aSommets : in pSommet_T; aNbFormes : in integer; aMinZ, aMaxZ : in Float; aFormesSorted : out pForme_List_T) is
		wCourant: Forme_List := aFormesUnsorted;
		wIndex_courant: integer;
	begin
		-- allocation du tableau tab_liste
		aFormesSorted := new Forme_List_T(0..aNbFormes);
		-- rechercher de wMaxZ et wMinZ
		--getMinMaxZ(aSommets, aNbSommets, wMinZ, wMaxZ);

		-- pour chaque forme :
		-- -- recher min_point
		-- -- calculer index pour forme
		-- -- ajouter forme dans tableau à l'indice trouvé
		while wCourant /= NULL loop
			wIndex_courant := Integer(Float'Floor(Float(aNbFormes) * ((getMinZForme(wCourant.all.F, aSommets) - aMinZ) / (aMaxZ-aMinZ))));
			if(wIndex_courant < aNbFormes + 1 ) then
				-- insere dans aFormesSorted au bon index
				aFormesSorted(wIndex_courant) := insertForme(aFormesSorted(wIndex_courant), aSommets, wCourant.all.F);
			-- else
				-- TODO: exception, index out of bonds
			end if;
			wCourant := wCourant.all.succ;
		end loop;


	end triParPaquet;
end tri_packet;
