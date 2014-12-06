with Ada.Unchecked_Deallocation;

package body off_struct is

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

	procedure freeSommet_T is new Ada.Unchecked_Deallocation (Sommet_T, pSommet_T);
	procedure freeInteger_T is new Ada.Unchecked_Deallocation (Integer_T, pInteger_T);
	procedure freeForme_List is new Ada.Unchecked_Deallocation (Forme_List_Element, Forme_List);
	procedure freeForme_List_T is new Ada.Unchecked_Deallocation (Forme_List_T, pForme_List_T);

	procedure libererSommet_T (aSommets : in out pSommet_T) is
	begin
		freeSommet_T(aSommets);
	end libererSommet_T;

	procedure libererInteger_T (aIntegerArray : in out pInteger_T) is
	begin
		freeInteger_T(aIntegerArray);
	end libererInteger_T;

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

	procedure libererForme_List_T (aForme_List_T : in out pForme_List_T; aNbFormes : in integer) is
	begin
		-- TODO: comprendre pourquoi la libération des listes empèche une seconde utilisation du programme
		-- Lorsque cette boucle est effectué, l'appel à un "new" suivant va mettre le processus dans l'état S.
		-- Le programme ne plante pas, il s'arrete sans jamais redemarer.
		for wI in 0..aNbFormes loop
			libererForme_List(aForme_List_T.all(wI));
		end loop;
		freeForme_List_T(aForme_List_T);
	end libererForme_List_T;

end off_struct;
