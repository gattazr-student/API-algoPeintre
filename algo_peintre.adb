with off_struct; use off_struct;
with off_file; use off_file;
with tri_packet; use tri_packet;
with ps_file; use ps_file;

with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Strings.Unbounded;

--
-- procedure algo_peintre
-- Procedure principale du programme algo_peintre. Au cours de cette procédure, un fichier off va être lu, son contenu trié et un fichier ps contenant une représentation 2D du fichier off sera crée.
--
procedure algo_peintre is
	-- renomme les trois packages pour un accès simplifié
	package CLI renames Ada.Command_Line;
	package IO renames Ada.Text_IO;
	package SU renames Ada.Strings.Unbounded;

	wInFileName : SU.Unbounded_String;
	wOutFileName : SU.Unbounded_String;
	wNbSommets : Integer;
	wNbFormes : Integer;
	wSommets : pSommet_T;
	wFormes : Forme_List;
	wFormesSorted : pForme_List_T;

	wMinX : Float;
	wMaxX : Float;
	wMinY : Float;
	wMaxY : Float;
	wMinZ : Float;
	wMaxZ : Float;

	--
	-- fonction file_exists
	-- la fonction retourne vrai si le fichier donnée en paramètre existe.
	-- @param aFileName : chemin vers le fichier à tester
	-- @return boolean : true si fichier aFileName existe, false sinon
	--
	function file_exists (aFileName : String) return Boolean is
		wFile : Ada.Text_IO.File_Type;
	begin
		IO.Open (wFile, IO.In_File, aFileName);
		IO.Close (wFile);
	return True;
		exception
			when IO.Name_Error =>
		return False;
	end file_exists;

	-- Variables utilisés pendant la section DEBUG
	DEBUG: constant boolean := true;
	wFormeCourante : Forme_List;
	wJ : Integer;

	--
	-- procedure affichage_debug
	-- fait un affichage dans stdout de toutes les structures de données utlisés pendant le programme principale
	--
	procedure affichage_debug is
	begin
		IO.New_Line;
		IO.Put_Line("-- AFFICHAGE DE TESTS --");
		IO.Put_Line("    Sommets : " & integer'Image(wNbSommets));
		IO.Put_Line("    Formes : " & integer'Image(wNbFormes));
		IO.New_Line;

		-- Affiche les sommets
		IO.Put_Line("    -- Sommets --");
		for wI in 0..(wNbSommets-1) loop
			IO.Put("        " & integer'Image(wI) & " : ");
			IO.Put_Line(float'Image(wSommets(wI).x) & " -" & float'Image(wSommets(wI).y) & " -" & float'Image(wSommets(wI).z));
		end loop;
		IO.New_Line;

		-- Affiche les fomes
		IO.Put_Line("    -- Formes --");
		wFormeCourante := wFormes;
		wJ := 0;
		while wFormeCourante /= NULL loop
			IO.Put("        " & integer'Image(wJ) & " : (" & integer'Image(WFormeCourante.all.F.size) &" )");
			for i in 0..(WFormeCourante.all.F.size-1) loop
				IO.Put(integer'Image(WFormeCourante.all.F.sommets.all(i)));
			end loop;
			IO.New_Line;
			WFormeCourante := WFormeCourante.all.succ;
			wJ := wJ + 1;
		end loop;

		-- Affiche le tableau de liste
		IO.Put("    -- Tableau trié --");
		IO.New_Line;
		wJ := 0;
		for wI in 0..wNbFormes loop
			IO.Put("        " & integer'Image(wI));
			wFormeCourante := wFormesSorted.all(wI);
			IO.Put("[ ");
			if wFormeCourante /= NULL then
				loop
					IO.Put("(");
					for i in 0..(WFormeCourante.all.F.size-1) loop
						IO.Put(integer'Image(WFormeCourante.all.F.sommets.all(i)));
					end loop;
					IO.Put(" ) ");
					exit when WFormeCourante.all.succ = NULL;
					WFormeCourante := WFormeCourante.all.succ;
					wJ := wJ + 1;
				end loop;
			end if;
			IO.Put_Line("]");
		end loop;

		IO.Put_Line("-- FIN AFFICHAGE DES TESTS --");
	end affichage_debug;
begin
	-- si le programme est lancé avec moins de 2 arguments
	if CLI.Argument_Count < 2 then
		IO.Put_Line("Le programme doit être lancé avec 2 arguments");
		IO.Put_Line("Usage: algo_peintre path/to/OffFile path/to/PSFile");
	else

		wInFileName := SU.To_Unbounded_String(CLI.argument(1));
		wOutFileName := SU.To_Unbounded_String(CLI.argument(2));
		if not file_exists(SU.To_String(wInFileName)) then
			IO.Put_Line("Le fichier " & SU.To_String(wInFileName) & " n'existe pas");
			IO.Put_Line("Usage: algo_peintre path/to/OffFile path/to/PSFile");
		else
			-- lecture du fichier off
			file_to_sommets_formes(SU.To_String(wInFileName), wNbSommets, wNbFormes, wSommets, wFormes);

			-- récupère les mins et maxs sur tous les axes
			getMinMaxXYZ(wSommets, wNbSommets, wMinX, wMaxX, wMinY, wMaxY, wMinZ, wMaxZ);

			-- Tri par paquet
			triParPaquet(wFormes, wSommets, wNbFormes, wMinZ, wMaxZ, wFormesSorted);

			-- Ecriture du fichier ps
			forme_list_t_to_ps(SU.To_String(wOutFileName), wFormesSorted, wSommets, wNbFormes+1, wMinX, wMaxX, wMinY, wMaxY);

			-- affichage de debug
			if DEBUG then
				affichage_debug;
			end if;

			-- Libération de la mémoire alloué
			libererSommet_T(wSommets);
			libererForme_List(wFormes);
			libererForme_List_T(wFormesSorted, wNbFormes);
		end if;
	end if;
end algo_peintre;
