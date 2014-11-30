with Ada.Command_Line;
with off_struct; use off_struct;
with off_file; use off_file;
with tri_packet; use tri_packet;
with ps_file; use ps_file;

with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure algo_peintre is
	-- renomme les deux packages pour un accès simplifié
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

	-- Variables utilisé pendant la section DEBUG
	DEBUG: constant boolean := true;
	wFormeCourante : Forme_List;
	wJ : Integer;

	procedure affichage_debug is
	begin
		IO.New_Line;
		IO.Put("-- AFFICHAGE DE TESTS --");
		IO.New_Line;
		IO.Put("    Sommets : " & integer'Image(wNbSommets));
		IO.New_Line;
		IO.Put("    Formes : " & integer'Image(wNbFormes));
		IO.New_Line;
		IO.New_Line;

		IO.Put("    -- Sommets --");
		IO.New_Line;
		for wI in 0..(wNbSommets-1) loop
			IO.Put("        " & integer'Image(wI) & " : ");
			IO.Put(float'Image(wSommets(wI).x) & " -" & float'Image(wSommets(wI).y) & " -" & float'Image(wSommets(wI).z));
			IO.New_Line;
		end loop;
		IO.New_Line;

		IO.Put("    -- Formes --");
		IO.New_Line;
		wFormeCourante := wFormes;
		wJ := 0;
		if wFormeCourante /= NULL then
			loop
				IO.Put("        " & integer'Image(wJ) & " : (" & integer'Image(WFormeCourante.all.F.size) &" )");
				for i in 0..(WFormeCourante.all.F.size-1) loop
					IO.Put(integer'Image(WFormeCourante.all.F.sommets.all(i)));
				end loop;
				IO.New_Line;
				exit when WFormeCourante.all.succ = NULL;
				WFormeCourante := WFormeCourante.all.succ;
				wJ := wJ + 1;
			end loop;
		end if;

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
			IO.Put("]");
			IO.New_Line;
		end loop;

		IO.Put("-- FIN AFFICHAGE DES TESTS --");
		IO.New_Line;
	end affichage_debug;
begin

	if CLI.Argument_Count < 2 then
		IO.Put("Not enough args");
	else
		wInFileName := SU.To_Unbounded_String(CLI.argument(1));
		wOutFileName := SU.To_Unbounded_String(CLI.argument(2));
		if not file_exists(SU.To_String(wInFileName)) then
			IO.Put("No such file");
		else
			-- TODO : rajouter timer
			file_to_sommets_formes(SU.To_String(wInFileName), wNbSommets, wNbFormes, wSommets, wFormes);

			getMinMaxXYZ(wSommets, wNbSommets, wMinX, wMaxX, wMinY, wMaxY, wMinZ, wMaxZ);
			-- Tri par paquet
			-- le tri est effectué après la lecture du fichier pour permettre une meilleur séparation du problème
			-- Effectuer les deux en même temps implique une complexité de n alors qu'effectuer l'un puis l'autre
			-- implique une complexité de 2n qui est donc une complexité de n aussi.
			-- La compléxité étant la même, nous avons donc décidé de séparer le tri de la lecture du fichier.
			triParPaquet(wFormes, wSommets, wNbFormes, wMinZ, wMaxZ, wFormesSorted);

			forme_list_t_to_ps(SU.To_String(wOutFileName), wFormesSorted, wSommets, wNbFormes+1, wMinX, wMaxX, wMinY, wMaxY);


			if DEBUG then
				affichage_debug;
			end if;



			-- !!! DEALLOCATE !!!
			libererSommet_T(wSommets);
			libererForme_List(wFormes);
			libererForme_List_T(wFormesSorted, wNbFormes);
		end if;
	end if;
end algo_peintre;
