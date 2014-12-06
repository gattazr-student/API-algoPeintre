with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Float_Text_IO;

package body off_file is

	--
	-- procedure read_head
	-- Utilise le fichier off ouvert aFile et récupère le nombre de sommets et de faces du fichier
	-- @param aFile in : fichier off à lire
	-- @param aNbSommets out : Nombre de sommets contenu dans le fichier off
	-- @param aNbFormes out : Nombre de Formes contenu dans le fichier off
	--
	procedure read_head(aFile : in Ada.Text_IO.File_Type; aNbSommets : out integer ; aNbFormes : out integer) is
		off : String(1..3);
		Last : integer; -- variable obligatoire pour utiliser la fonction "Get_Line"
	begin
		Ada.Text_IO.Get_Line (aFile,off,Last);
		If (off="OFF") then
			Ada.Integer_Text_IO.Get(aFile, aNbSommets);
			Ada.Integer_Text_IO.Get(aFile, aNbFormes);
			Ada.Text_IO.Skip_Line(aFile, 1);
		end if;

	end read_head;

	--
	-- procedure read_sommets
	-- Récupère la liste des sommet du fichier File(fichier off) et la stock dans un tableau de point
	-- @param aFile in : fichier off à lire
	-- @param aNbSommets in : Nombre de sommets contenu dans le fichier off
	-- @param aSommets out : Tableau des sommets lus
	--
	procedure read_sommets(aFile : in Ada.Text_IO.File_Type; aNbSommets : in integer; aSommets : out pSommet_T) is
	begin
		aSommets := new Sommet_T(0..(aNbSommets-1));
		for wI in 0..(aNbSommets-1) loop
			Ada.Float_Text_IO.Get(aFile, aSommets(wI).x);
			Ada.Float_Text_IO.Get(aFile, aSommets(wI).y);
			Ada.Float_Text_IO.Get(aFile, aSommets(wI).z);
		end loop;

	end read_sommets;

	--
	-- procedure read_formes
	-- Récupère la liste des formes du fichier aFile (fichier off) et la stoque dans une liste chainée de Formes
	-- @param aFile in : fichier off à lire
	-- @param aNbFormes in : Nombre de Formes contenu dans le fichier off
	-- @param aFormes out : Liste chainée de formes produite
	--
	procedure read_formes(aFile : in Ada.Text_IO.File_Type; aNbFormes : in integer; aFormes : out Forme_List) is
		wPred : Forme_List;
		wCourant : Forme_List;
		wSize : integer;
	begin

		aFormes := NULL;

		if (aNbFormes > 0) then

		 	-- Creation de la liste de formes par la création du 1er élement
			aFormes := new Forme_List_Element;
			Ada.Integer_Text_IO.Get(aFile, wSize);
			aFormes.all.F.sommets := new Integer_T(0..(wSize-1));
			aFormes.all.F.size := wSize;
			for wI in 0..(wSize-1) loop
				Ada.Integer_Text_IO.Get(aFile, aFormes.all.F.sommets.all(wI));
			end loop;

			wPred := aFormes;

			for wI in 1..(aNbFormes-1) loop
				-- Rajoute un élement dans la liste de formes
				wCourant := new Forme_List_Element;
				Ada.Integer_Text_IO.Get(aFile, wSize);
				wCourant.all.F.size := wSize;
				wCourant.all.F.sommets := new Integer_T(0..(wSize-1));
				for wJ in 0..(wSize-1) loop
					Ada.Integer_Text_IO.Get(aFile, wCourant.all.F.sommets(wJ));
				end loop;

				wPred.succ := wCourant;

				wPred := wCourant;
			end loop;

			wCourant.all.succ := NULL; -- La dernière formes n'a pas de successeur
		end if;

	end read_formes;


	--
	-- procedure file_to_sommets_formes
	-- Ouvre un fichier OFF, le lit et retourne un pointeur sur un tableau de point et une liste doublement chainée de formes
	-- @param aFileName in : fichier off à lire
	-- @param aNbSommets out : Nombre de sommets contenu dans le fichier off
	-- @param aNbFormes out : Nombre de Formes contenu dans le fichier off
	-- @param aSommets out : Tableau des sommets contenus dans le fichier
	-- @param aFormes out : Liste chainée des formes contenus dans le fichier off
	--
	procedure file_to_sommets_formes(aFileName : in String; aNbSommets, aNbFormes: out integer; aSommets : out pSommet_T; aFormes : out Forme_List) is
		wOFF : Ada.Text_IO.File_Type;
	begin -- lit un fichier OFF et retourne un  pointeur sur un tableau de point et une liste doublement chainée de formes

		Ada.Text_IO.Open(wOFF, Ada.Text_IO.In_File, aFileName);

		-- lit le header et la premier ligne du fichier
		read_head(wOFF, aNbSommets, aNbFormes);
		-- lit les sommets et les mets dans un tableau pointé par ptab_point
		read_sommets(wOFF, aNbSommets, aSommets);
		-- lit les formes et let mets dans le tableau tab_list_formes
		read_formes(wOFF, aNbFormes, aFormes);

		Ada.Text_IO.Close(wOff);

	end file_to_sommets_formes;
end off_file;
