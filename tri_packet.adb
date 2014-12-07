package body tri_packet is

	--
	-- function getMinZForme
	-- retourne la valeur minimum en z prise par les sommets de la forme passé en paramètre
	-- @param aForme : Forme à utiliser
	-- @param aSommets : Tableau contenant les sommets référencés dans la Formes
	-- @return Float : Tableau contenant les sommets référencés dans les Formes
	--
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

	--
	-- function insertForme
	-- Insere une forme dans une liste de forme trié selon leur valeurs minimum en z
	-- @param aFormes : Liste de Formes à utiliser
	-- @param aSommets : Tableau contenant les sommets référencés dans la Formes
	-- @param aForme : Forme à insérer dans la liste
	-- @return Forme_List : Liste trié aFormes contenant l'élement supplémentaire aForme
	--
	function insertForme(aFormes : Forme_List; aSommets : pSommet_T; aForme : Forme) return Forme_List is
		wReturned : Forme_List := aFormes;
		wCourant : Forme_List := aFormes;
		wNewForme: Forme_List;
		wMinZ_courant : float;
	begin
		wNewForme := new Forme_List_Element;

		-- fait une copie complète de la forme.
		-- copie egalement tous le tableau de sommets qui à été alloué dynamiquement pour ne pas lier le cycle de vie des deux objets
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


	--
	-- procedure triParPaquet
	-- trie selon l'algorithme du tri par paquet la liste aFormesUnsorted. Le retour de la fonction est un tableau de liste.
	-- @param aFormesUnsorted in : Liste de Formes à trier
	-- @param aSommets in : Tableau contenant les sommets référencés dans la Formes
	-- @param aNbFormes in : nombre de Formes contenu dans la liste aFormesUnsorted
	-- @param aMinZ in : Valeur minimum prise en z par les sommets dans aSommets
	-- @param aMaxZ in : Valeur maximum prise en z par les sommets dans aSommets
	-- @param aFormesSorted out : Tableau trié de liste trié
	--
	procedure triParPaquet(aFormesUnsorted : in Forme_List; aSommets : in pSommet_T; aNbFormes : in integer; aMinZ, aMaxZ : in Float; aFormesSorted : out pForme_List_T) is
		wCourant: Forme_List := aFormesUnsorted;
		wIndex_courant: integer;
	begin
		-- allocation du tableau de liste
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
