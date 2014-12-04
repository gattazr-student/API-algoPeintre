with machine_seq; use machine_seq;
with Ada.Text_IO;

package body ps_file is

	-- procédure qui prend en paramètre un fichier (PS) et l'initialise (avec les premières lignes de chaque fichier PS)
	procedure write_head (aFile : in Ada.Text_IO.File_Type) is
	begin
			Ada.Text_IO.Put(aFile,"%!PS");
			Ada.Text_IO.New_Line(aFile);
			Ada.Text_IO.Put(aFile,"0 setlinewidth");
			Ada.Text_IO.New_Line(aFile);
	end write_head;

	-- procédure qui prend en paramètre un fichier (PS) et le termine (avec les dernières lignes de chaque fichier PS)
	procedure write_tail (aFile : in Ada.Text_IO.File_Type) is
	begin
		Ada.Text_IO.Put(aFile,"showpage");
		Ada.Text_IO.New_Line(aFile);
	end write_tail;

	procedure write_point(aFile : in Ada.Text_IO.File_Type; aSommet : in Sommet; aRapport, aMinX, aAddX, aMinY, aAddY : in Float; aSuffix : in String) is
		wX : float;
		wY : float;
	begin
		wX := (aSommet.x - aMinX) * aRapport + aAddX;
		wY := (aSommet.y - aMinY) * aRapport + aAddY;
		Ada.Text_IO.Put_line(aFile, Float'Image(wX) & Float'Image(wY) & " " & aSuffix);
	end write_point;

	procedure write_forme(aFile : in Ada.Text_IO.File_Type; aForme : in Forme; aSommets : in pSommet_T; aRapport, aMinX, aAddX, aMinY, aAddY : in Float) is
	begin

		if(aForme.size > 0) then
			-- ecrit "x0 y0 moveto"
			write_point(aFile, aSommets.all(aForme.sommets.all(0)), aRapport, aMinX, aAddX, aMinY, aAddY, "moveto");
			for wI in 1..(aForme.size-1) loop
				-- ecrit "xi yi lineto"
				write_point(aFile, aSommets.all(aForme.sommets.all(wI)), aRapport, aMinX, aAddX, aMinY, aAddY, "lineto");
			end loop;
			-- ecrit "x0 y0 lineto"
			write_point(aFile, aSommets.all(aForme.sommets.all(0)), aRapport, aMinX, aAddX, aMinY, aAddY, "lineto");
			-- ecrit "sauvegarde" la figure et set les couleurs de contours et remplissage
			Ada.Text_IO.Put_line(aFile, "gsave");
			Ada.Text_IO.Put_line(aFile, "1 setgray");
			Ada.Text_IO.Put_line(aFile, "fill");
			Ada.Text_IO.Put_line(aFile, "grestore");
			Ada.Text_IO.Put_line(aFile, "0 setgray");
			Ada.Text_IO.Put_line(aFile, "stroke");
		end if;

	end write_forme;

	procedure write_formes(aFile : in Ada.Text_IO.File_Type; aFormes : in pForme_List_T; aSommets : in pSommet_T; aSizeFormes : in Integer; aMinX, aMaxX, aMinY, aMaxY : in Float) is
		wRapportX : float;
		wRapportY : float;
		wRapport : float;
		wAddX : float;
		wAddY : float;
	begin
		wRapportX := 575.0 / (aMaxX - aMinX);
		wRapportY := 822.0 / (aMaxY - aMinY);

		if(wRapportX < wRapportY) then
			wRapport := wRapportX;
			wAddX := 10.0;
			wAddY := (822.0 - (aMaxY - aMinY) * wRapport) / 2.0;
		else
			wRapport := wRapportY;
			wAddX := (575.0 - (aMaxX - aMinX) * wRapport) / 2.0;
			wAddY := 10.0;
		end if;

		demarrer(aFormes, aSizeFormes);
		while not finDeSequence loop
			write_forme(aFile, elementCourant, aSommets, wRapport, aMinX, wAddX, aMinY, wAddY);
			avancer;
		end loop;
	end write_formes;

	procedure forme_list_t_to_ps (aFileName : in String; aFormes : in pForme_List_T; aSommets : in pSommet_T; aSizeFormes : in Integer; aMinX, aMaxX, aMinY, aMaxY : in Float) is
		wPS : Ada.Text_IO.File_Type;
	begin -- forme_list_t_to_ps
		Ada.Text_IO.Create(wPS, Ada.Text_IO.OUT_File, aFileName);
		-- remplace le fichier si il existe déja

		write_head(wPS);
		write_formes(wPS, aFormes, aSommets, aSizeFormes, aMinX, aMaxX, aMinY, aMaxY);
		write_tail(wPS);
	end forme_list_t_to_ps;

end ps_file;
