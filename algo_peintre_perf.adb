with Ada.Command_Line;
with off_struct; use off_struct;
with off_file; use off_file;
with tri_packet; use tri_packet;
with ps_file; use ps_file;
with Ada.Real_Time; use Ada.Real_Time; -- Pour calculer le temps d'execution du tri

with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure algo_peintre_perf is
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
		wFile : IO.File_Type;
	begin
		IO.Open (wFile, IO.In_File, aFileName);
		IO.Close (wFile);
	return True;
		exception
			when IO.Name_Error =>
		return False;
	end file_exists;

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

	if CLI.Argument_Count < 2 then
		IO.Put("Not enough args");
	else

		wInFileName := SU.To_Unbounded_String(CLI.argument(1));
		wOutFileName := SU.To_Unbounded_String(CLI.argument(2));
		if not file_exists(SU.To_String(wInFileName)) then
			IO.Put("No such file");
		else
			IO.Create (wPerfFile, IO.Out_File, "tests/perf.csv");
			IO.Put_line(wPerfFile, "nbSommets, nbFormes, TTotal, TLectureOff, TGetMax, TTri, TEcriturePS, TLiberation;");
			for wI in 1..10000 loop
				wTempsInit := Ada.Real_Time.Clock;

				file_to_sommets_formes(SU.To_String(wInFileName), wNbSommets, wNbFormes, wSommets, wFormes);
				wTempsInt1 := Ada.Real_Time.Clock;

				getMinMaxXYZ(wSommets, wNbSommets, wMinX, wMaxX, wMinY, wMaxY, wMinZ, wMaxZ);
				wTempsInt2 := Ada.Real_Time.Clock;

				triParPaquet(wFormes, wSommets, wNbFormes, wMinZ, wMaxZ, wFormesSorted);
				wTempsInt3 := Ada.Real_Time.Clock;

				forme_list_t_to_ps(SU.To_String(wOutFileName), wFormesSorted, wSommets, wNbFormes+1, wMinX, wMaxX, wMinY, wMaxY);
				wTempsInt4 := Ada.Real_Time.Clock;

				-- Libération de la mémoire
				libererSommet_T(wSommets);
				libererForme_List(wFormes);
				libererForme_List_T(wFormesSorted, wNbFormes);

				wTempsFin := Ada.Real_Time.Clock;

				wTempsTotal := wTempsFin - wTempsInit;
				wTempsLectureOff := wTempsInt1 - wTempsInit;
				wTempsGetMax := wTempsInt2 - wTempsInt1;
				wTempsTri := wTempsInt3 - wTempsInt2;
				wTempsEcriturePS := wTempsInt4 - wTempsInt3;
				wTempsDealloc := wTempsFin - wTempsInt4;

				IO.Put(wPerfFile, integer'image(wNbSommets) & "," & integer'image(wNbFormes)& ",");
				IO.Put(wPerfFile, Integer'image(wTempsTotal / Milliseconds(1)) & ",");
				IO.Put(wPerfFile, Integer'image(wTempsLectureOff / Milliseconds(1)) & "," );
				IO.Put(wPerfFile, Integer'image(wTempsGetMax / Milliseconds(1)) & "," );
				IO.Put(wPerfFile, Integer'image(wTempsTri / Milliseconds(1)) & "," );
				IO.Put(wPerfFile, Integer'image(wTempsEcriturePS / Milliseconds(1)) & "," );
				IO.Put_line(wPerfFile, Integer'image(wTempsDealloc / Milliseconds(1)) & ";" );
				if(wI mod 1000 = 0) then
					IO.Put(".");
				end if;
			end loop;
			IO.Close (wPerfFile);
		end if;
	end if;
end algo_peintre_perf;
