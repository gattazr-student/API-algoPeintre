with off_struct; use off_struct;
with off_file; use off_file;
with tri_packet; use tri_packet;
with ps_file; use ps_file;
with Ada.Real_Time; use Ada.Real_Time; -- Pour calculer le temps d'execution du tri

with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure algo_peintre_mem is
	-- renomme les deux packages pour un accès simplifié
	package IO renames Ada.Text_IO;
	package SU renames Ada.Strings.Unbounded;

	-- wSommets : pSommet_T;
	-- wFormes : Forme_List;
	-- wFormesSorted : pForme_List_T;

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

begin
	IO.Put_Line("Début");
	for wI in 1..100  loop
		file_to_sommets_formes("tests/test.off", wNbSommets, wNbFormes, wSommets, wFormes);
		IO.Put(" wI("& Integer'image(wI) & " ) -> nbSommets :"& Integer'image(wNbSommets) &" | nbFormes :"& Integer'image(wNbFormes));

		getMinMaxXYZ(wSommets, wNbSommets, wMinX, wMaxX, wMinY, wMaxY, wMinZ, wMaxZ);
		triParPaquet(wFormes, wSommets, wNbFormes, wMinZ, wMaxZ, wFormesSorted);
		forme_list_t_to_ps("tests/out.ps", wFormesSorted, wSommets, wNbFormes+1, wMinX, wMaxX, wMinY, wMaxY);

		libererSommet_T(wSommets);
		libererForme_List(wFormes);
		IO.Put("|");
		libererForme_List_T(wFormesSorted, wNbFormes);
		IO.New_line;

	end loop;

	IO.Put_Line("Fin");

end algo_peintre_mem;
