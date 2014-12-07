with off_struct; use off_struct;
with off_file; use off_file;
with tri_packet; use tri_packet;
with ps_file; use ps_file;
with Ada.Real_Time; use Ada.Real_Time; -- Pour calculer le temps d'execution du tri

with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Strings.Unbounded;
with Ada.Directories;

--
-- procedure algo_peintre_perf
-- Procedure principale du programme algo_peintre_perf. Au cours de cette procédure, un fichier off va être lu, son contenu trié et un fichier ps sera crée 1000 fois. Les temps d'executions de chaque execution sera ensuite logué dans un fichier cvs
--
procedure algo_peintre_perf is
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
		wFile : IO.File_Type;
	begin
		IO.Open (wFile, IO.In_File, aFileName);
		IO.Close (wFile);
	return True;
		exception
			when IO.Name_Error =>
		return False;
	end file_exists;

	-- Variables utilisés pour évaluer le temps passé dans chaque fonction
	wTempsTotal: Ada.Real_Time.Time_Span;
	wTempsLectureOff: Ada.Real_Time.Time_Span;
	wTempsGetMax: Ada.Real_Time.Time_Span;
	wTempsTri: Ada.Real_Time.Time_Span;
	wTempsEcriturePS: Ada.Real_Time.Time_Span;
	wTempsDealloc: Ada.Real_Time.Time_Span;

	wTempsInit: Ada.Real_Time.Time;
	wTempsInt1: Ada.Real_Time.Time;
	wTempsInt2: Ada.Real_Time.Time;
	wTempsInt3: Ada.Real_Time.Time;
	wTempsInt4: Ada.Real_Time.Time;
	wTempsFin: Ada.Real_Time.Time;

	wPerfFile : IO.File_Type;

begin
	-- si le programme est lancé avec moins de 2 arguments
	if CLI.Argument_Count < 2 then
		IO.Put_Line("Le programme doit être lancé avec 2 arguments");
		IO.Put_Line("Usage: algo_peintre path/to/OffFile path/to/CSVFile");
	else

		wInFileName := SU.To_Unbounded_String(CLI.argument(1));
		wOutFileName := SU.To_Unbounded_String(CLI.argument(2));
		if not file_exists(SU.To_String(wInFileName)) then
			IO.Put_Line("Le fichier " & SU.To_String(wInFileName) & " n'existe pas");
			IO.Put_Line("Usage: algo_peintre path/to/OffFile path/to/CSVFile");
		else
			IO.Create (wPerfFile, IO.Out_File, SU.To_String(wOutFileName));
			IO.Put_line(wPerfFile, "nbSommets, nbFormes, TTotal, TLectureOff, TGetMax, TTri, TEcriturePS, TLiberation;");
			for wI in 1..1000 loop
				wTempsInit := Ada.Real_Time.Clock;

				-- lecture du fichier off
				file_to_sommets_formes(SU.To_String(wInFileName), wNbSommets, wNbFormes, wSommets, wFormes);
				wTempsInt1 := Ada.Real_Time.Clock;

				-- récupère les mins et maxs sur tous les axes
				getMinMaxXYZ(wSommets, wNbSommets, wMinX, wMaxX, wMinY, wMaxY, wMinZ, wMaxZ);
				wTempsInt2 := Ada.Real_Time.Clock;

				-- Tri par paquet
				triParPaquet(wFormes, wSommets, wNbFormes, wMinZ, wMaxZ, wFormesSorted);
				wTempsInt3 := Ada.Real_Time.Clock;

				-- Ecriture du fichier ps
				forme_list_t_to_ps("temp.ps", wFormesSorted, wSommets, wNbFormes+1, wMinX, wMaxX, wMinY, wMaxY);
				wTempsInt4 := Ada.Real_Time.Clock;

				-- Libération de la mémoire alloué
				libererSommet_T(wSommets);
				libererForme_List(wFormes);
				libererForme_List_T(wFormesSorted, wNbFormes);
				wTempsFin := Ada.Real_Time.Clock;

				-- Calcul des temps d'executions de chaque fonction
				wTempsTotal := wTempsFin - wTempsInit;
				wTempsLectureOff := wTempsInt1 - wTempsInit;
				wTempsGetMax := wTempsInt2 - wTempsInt1;
				wTempsTri := wTempsInt3 - wTempsInt2;
				wTempsEcriturePS := wTempsInt4 - wTempsInt3;
				wTempsDealloc := wTempsFin - wTempsInt4;

				-- Affichage des temps d'executions
				IO.Put(wPerfFile, integer'image(wNbSommets) & "," & integer'image(wNbFormes)& ",");
				IO.Put(wPerfFile, Integer'image(wTempsTotal / Milliseconds(1)) & ",");
				IO.Put(wPerfFile, Integer'image(wTempsLectureOff / Milliseconds(1)) & "," );
				IO.Put(wPerfFile, Integer'image(wTempsGetMax / Milliseconds(1)) & "," );
				IO.Put(wPerfFile, Integer'image(wTempsTri / Milliseconds(1)) & "," );
				IO.Put(wPerfFile, Integer'image(wTempsEcriturePS / Milliseconds(1)) & "," );
				IO.Put_line(wPerfFile, Integer'image(wTempsDealloc / Milliseconds(1)) & ";" );
				-- affiche un . toutes les 100 executions. Ainsi, si le programme est lent, on voit que son execution est en cours
				if(wI mod 100 = 0) then
					IO.Put(".");
				end if;
			end loop;
			IO.Close (wPerfFile);
			-- suppression du fichier ps temporaire
			Ada.Directories.Delete_File ("temp.ps");
		end if;
	end if;
end algo_peintre_perf;
