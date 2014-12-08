with machine_seq; use machine_seq;
with Ada.Text_IO;

package body ps_file is

	cRapport : Float;
	cAddX : Float;
	cAddY : Float;
	cMinX : Float;
	cMaxX : Float;
	cMinY : Float;
	cMaxY : Float;

	--
	-- procedure write_head
	-- Ecrit dans le fichier passé en paramètres les premières ligne que l'on trouve dans tous les fichier ps
	-- @param aFile in : Ficher ouvert en écriture à utiliser
	--
	procedure write_head (aFile : in Ada.Text_IO.File_Type) is
	begin
		Ada.Text_IO.Put(aFile,"%!PS");
		Ada.Text_IO.New_Line(aFile);
		Ada.Text_IO.Put(aFile,"0 setlinewidth");
		Ada.Text_IO.New_Line(aFile);
	end write_head;

	--
	-- procedure write_tail
	-- Ecrit dans le fichier passé en paramètres les dernières ligne que l'on trouve dans tous les fichier ps
	-- @param aFile in : Ficher ouvert en écriture à utiliser
	--
	procedure write_tail (aFile : in Ada.Text_IO.File_Type) is
	begin
		Ada.Text_IO.Put(aFile,"showpage");
		Ada.Text_IO.New_Line(aFile);
	end write_tail;

	--
	-- procedure write_point
	-- Ecrit dans le fichier passé en paramètres le sommet passé en paramètre avec l'action donnée
	-- @param aFile in : Ficher ouvert en écriture à utiliser
	-- @param aSommet in : Sommet à écrire
	-- @param aAction in : Action associé à ce point (moveto, lineto...)
	--
	procedure write_point(aFile : in Ada.Text_IO.File_Type; aSommet : in Sommet; aAction : in String) is
		wX : float;
		wY : float;
	begin
		-- calcul des coordonnée x et y du point à ecrire
		wX := (aSommet.x - cMinX) * cRapport + cAddX;
		wY := (aSommet.y - cMinY) * cRapport + cAddY;

		Ada.Text_IO.Put_line(aFile, Float'Image(wX) & Float'Image(wY) & " " & aAction);
	end write_point;

	--
	-- procedure write_forme
	-- Ecrit dans le fichier passé en paramètres la forme passé en paramètre
	-- @param aFile in : Ficher ouvert en écriture à utiliser
	-- @param aForme in : Forme a écrire
	-- @param aSommets in : Tableau contanant les sommets référencés dans la Forme
	--
	procedure write_forme(aFile : in Ada.Text_IO.File_Type; aForme : in Forme; aSommets : in pSommet_T) is
	begin
		if(aForme.size > 0) then
			-- ecrit "x0 y0 moveto"
			write_point(aFile, aSommets.all(aForme.sommets.all(0)), "moveto");
			for wI in 1..(aForme.size-1) loop
				-- ecrit "xi yi lineto"
				write_point(aFile, aSommets.all(aForme.sommets.all(wI)), "lineto");
			end loop;
			-- ecrit "x0 y0 lineto"
			write_point(aFile, aSommets.all(aForme.sommets.all(0)), "lineto");
			-- ecrit "sauvegarde" la figure et set les couleurs de contours et remplissage
			Ada.Text_IO.Put_line(aFile, "gsave");
			Ada.Text_IO.Put_line(aFile, "1 setgray");
			Ada.Text_IO.Put_line(aFile, "fill");
			Ada.Text_IO.Put_line(aFile, "grestore");
			Ada.Text_IO.Put_line(aFile, "0 setgray");
			Ada.Text_IO.Put_line(aFile, "stroke");
		end if;
	end write_forme;

	--
	-- procedure write_formes
	-- Ecrit dans le fichier passé en paramètres les formes contenus dans le tableau de listes passé en paramètres
	-- @param aFile in : Ficher ouvert en écriture à utiliser
	-- @param aFormes in : Formes à écrire
	-- @param aSommets in : Tableau contanant les sommets référencés dans les Formes
	-- @param aSizeFormes in : Taille du tableau aFormes
	--
	procedure write_formes(aFile : in Ada.Text_IO.File_Type; aFormes : in pForme_List_T; aSommets : in pSommet_T; aSizeFormes : in Integer) is
		wRapportX : float;
		wRapportY : float;
	begin
		-- calcul des rapports d'agrandissement maximum pour les axes x et y
		wRapportX := 575.0 / (cMaxX - cMinX);
		wRapportY := 822.0 / (cMaxY - cMinY);

		-- Selection du rapport mimum et calcul des offsets en x et en y
		if(wRapportX < wRapportY) then
			cRapport := wRapportX;
			cAddX := 10.0;
			cAddY := (822.0 - (cMaxY - cMinY) * cRapport) / 2.0;
		else
			cRapport := wRapportY;
			cAddX := (575.0 - (cMaxX - cMinX) * cRapport) / 2.0;
			cAddY := 10.0;
		end if;

		-- utilisation de la machine séquentielle pour parcourir le tableau de liste
		demarrer(aFormes, aSizeFormes);
		while not finDeSequence loop
			-- ecriture de chaque element trouvé
			write_forme(aFile, elementCourant, aSommets);
			avancer;
		end loop;
	end write_formes;

	--
	-- procedure forme_list_t_to_ps
	-- Créé et écrit dans le fichier aFileName les formes qui se trouvent dans aFormes.
	-- Un facteur d'agrandissement est appliqué à toutes les formes afin que le l'ensemble des formes remplissent une feuille a4. Le ratio de l'image n'est pas modifié.
	-- @param aFileName in : Chemin vers le fichier à écrire
	-- @param aFormes in : Liste de formes à écrire
	-- @param aSommets in : Tableau contanant les sommets référencés dans les Formes
	-- @param aSizeFormes in : Taille de la liste aFormes
	-- @param aMinX in : valeur minimum en x prise par les sommets dans aSommets
	-- @param aMaxX in : valeur maximum en x prise par les sommets dans aSommets
	-- @param aMinY in : valeur minimum en y prise par les sommets dans aSommets
	-- @param aMaxY in : valeur maximum en y prise par les sommets dans aSommets
	--
	procedure forme_list_t_to_ps (aFileName : in String; aFormes : in pForme_List_T; aSommets : in pSommet_T; aSizeFormes : in Integer; aMinX, aMaxX, aMinY, aMaxY : in Float) is
		wPS : Ada.Text_IO.File_Type;
	begin
		-- Ouvert le fichier aFileName en ecriture.
		-- Si le fichier existe, le fichier est remplacé
		Ada.Text_IO.Create(wPS, Ada.Text_IO.OUT_File, aFileName);

		-- ces 4 valeurs sont utilisé dans presque toutes les fonctions dans ce package. Pour ne pas avoir à les donner en paramètres à chaque fonctions, on les déclare donc comme variable statique de package.
		cMinX := aMinX;
		cMaxX := aMaxX;
		cMinY := aMinY;
		cMaxY := aMaxY;

		-- ecriture de l'entête du fichier ps
		write_head(wPS);

		-- ecriture des formes dans le fichier ps
		write_formes(wPS, aFormes, aSommets, aSizeFormes);

		-- ecriture de la fin du fichier ps
		write_tail(wPS);

		Ada.Text_IO.Close(wPS);
	end forme_list_t_to_ps;

end ps_file;
