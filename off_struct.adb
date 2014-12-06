with Ada.Unchecked_Deallocation;

package body off_struct is

	--
	-- procedure getMinMaxXYZ
	-- getMinMaxXYZ recherche dans un tableau de sommet donnés les valeurs minimum en X, Y et Z.
	-- @param aSommets in : Tableau de sommets à utiliser
	-- @param aNbSommets in : taille du tableau aSommets
	-- @param aMinX out : valeur minimum prise par X des sommets contenus dans aSommet
	-- @param aMinX out : valeur maximum prise par X des sommets contenus dans aSommet
	-- @param aMinY out : valeur minimum prise par Y des sommets contenus dans aSommet
	-- @param aMinY out : valeur maximum prise par Y des sommets contenus dans aSommet
	-- @param aMinZ out : valeur minimum prise par Z des sommets contenus dans aSommet
	-- @param aMinZ out : valeur maximum prise par Z des sommets contenus dans aSommet
	--
	procedure getMinMaxXYZ(aSommets : in pSommet_T; aNbSommets : in integer; aMinX, aMaxX, aMinY, aMaxY,  aMinZ, aMaxZ  : out float) is
	begin -- retourne les minimums et maximums X Y Z de la liste de sommets
		for wI in 0..(aNbSommets-1) loop
			if(wI = 0) then
				aMinX := aSommets.all(wI).x;
				aMaxX := aSommets.all(wI).x;

				aMinY := aSommets.all(wI).y;
				aMaxY := aSommets.all(wI).y;

				aMinZ := aSommets.all(wI).z;
				aMaxZ := aSommets.all(wI).z;
			else
				if(aSommets.all(wI).x < aMinX) then
					aMinX := aSommets.all(wI).x;
				end if;

				if(aSommets.all(wI).x > aMaxX) then
					aMaxX := aSommets.all(wI).x;
				end if;

				if(aSommets.all(wI).y < aMinY) then
					aMinY := aSommets.all(wI).y;
				end if;

				if(aSommets.all(wI).y > aMaxY) then
					aMaxY := aSommets.all(wI).y;
				end if;

				if(aSommets.all(wI).z < aMinZ) then
					aMinZ := aSommets.all(wI).z;
				end if;

				if(aSommets.all(wI).z > aMaxZ) then
					aMaxZ := aSommets.all(wI).z;
				end if;

			end if;
		end loop;
	end getMinMaxXYZ;

	-- Procedures de libération de mémoire
	procedure freeSommet_T is new Ada.Unchecked_Deallocation (Sommet_T, pSommet_T);
	procedure freeInteger_T is new Ada.Unchecked_Deallocation (Integer_T, pInteger_T);
	procedure freeForme_List is new Ada.Unchecked_Deallocation (Forme_List_Element, Forme_List);
	procedure freeForme_List_T is new Ada.Unchecked_Deallocation (Forme_List_T, pForme_List_T);

	--
	-- procedure libererSommet_T
	-- libererSommet_T libère un tableau de sommets
	-- @param aSommets in out : Tableau de sommets à liberer
	--
	procedure libererSommet_T (aSommets : in out pSommet_T) is
	begin
		freeSommet_T(aSommets);
	end libererSommet_T;

	--
	-- procedure libererInteger_T
	-- libererInteger_T libère un tableau d'entiers
	-- @param aIntegerArray in out : Tableau d'entiers à liberer
	--
	procedure libererInteger_T (aIntegerArray : in out pInteger_T) is
	begin
		freeInteger_T(aIntegerArray);
	end libererInteger_T;

	--
	-- procedure libererForme_List
	-- libererForme_List libère une liste de Formes
	-- @param aIntegerArray in out : Liste de formes à liberer
	--
	procedure libererForme_List (aForme_List : in out Forme_List) is
		wSuivant : Forme_List;
	begin
		while aForme_List /= NULL loop
			-- sauvegarde l'adresse du suivant
			wSuivant := aForme_List.all.succ;

			-- Libération du courant
			libererInteger_T(aForme_List.all.F.sommets);
			freeForme_List(aForme_List);

			-- mise en place du sauvegarde comme le courant
			aForme_List := wSuivant;
		end loop;
	end libererForme_List;

	--
	-- procedure libererForme_List_T
	-- libererForme_List_T libère un tableau de liste de formes
	-- @param aForme_List_T in out : Tableau de liste de formes à liberer
	--
	procedure libererForme_List_T (aForme_List_T : in out pForme_List_T; aNbFormes : in integer) is
	begin
		for wI in 0..aNbFormes loop
			libererForme_List(aForme_List_T.all(wI));
		end loop;
		freeForme_List_T(aForme_List_T);
	end libererForme_List_T;

end off_struct;
