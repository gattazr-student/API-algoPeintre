with off_struct; use off_struct;
with off_file; use off_file;
with tri_packet; use tri_packet;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Integer_Text_IO;

package body ps_file is

	-- fonction qui trouve la première liste de formes non vide du tableau de liste de formes
	function demarrer(aFormes : in Forme_List_T) return integer is -- penser a faire une proc avec return l = T[i]
															  -- ON RETOURNE QUOI ??? L'INDICE DU TABLEAU OU LA LISTE QUI SE TROUVE A L'INDICE I ??
		wI : integer;
		wBool : boolean := true;
	begin --
		wI := aFormes'First;
		while (aFormes(wI)=null) loop
			wI:=wI+1;
		end loop;

		return wI;
	end demarrer;

	procedure demarrer (APoly: in pForme_List_T; Pp: in out Forme_List_Element; CaseCour : out integer) is
		Ptab: pForme_List_T;
		i: integer:=0;
	begin
		-- TODO
		Ptab:=APoly;

		-- --if Ptab = null then
		-- --Put_Line("j'suis dans demarrer, Ptab est nulle ");
		-- --else
		-- --Put_Line("j'suis dans demarrer, Ptab est pas nulle \o/");
		-- --end if;

		-- if (Ptab /= null) then
		-- --Put_Line("j'suis dans le if du demarrer");
		-- 	Pp:= Ptab.all(i); --if Pp = null then Put_Line("Pp est nulle"); end if;
		-- 	--i:=i+1;
		-- 	if (Pp = null) then

		-- 		while (i < Ptab.all'Last and Pp = null) loop
		-- 			Pp:=Ptab.all(i);
		-- 			i:= i+1;
		-- 		end loop;
		-- 	end if;
		-- 	CaseCour:=i;
		-- end if;
	end demarrer;

	-- procédure qui permet d'avancer jusqu'à la prochaine liste de formes non vide du tableau de liste de formes
	procedure avancer (aFormes : in Forme_List_T ; aIndice : in out integer) is -- idem que précédemment ? Qu'est ce qu'on retourne ??

		wC: integer := aIndice + 1; -- compteur commençant à indice + 1, l'indice actuel étant
								  -- celui d'une cellule dans la liste est non vide.
		begin

			while (wC /= aFormes'Last and then aFormes(wC)=null) loop
				wC:=wC+1;
			end loop;

			aIndice := wC;

	end avancer;

	-- fonction qui retourne le l'indice de la dernière liste du tableau de liste de formes
	function end_tab (aFormes : in Forme_List_T; aIndice : in integer) return boolean is

		begin
			return (aIndice = aFormes'Last);

	end end_tab;

	procedure ps_print(aFile : in out File_Type; aSommets : in pSommet_T; aFormes : in pForme_List_T; aMinX, aMaxX, aMinY, aMaxY, aMinZ, aMaxZ : in Float) is
		proportionx, proportiony : float;
	begin -- ps_print

		proportionx := 590.0/(aMaxX - aMinX);
		proportiony := 840.0/(aMaxY - aMinY);


	end ps_print;


	-- procédure qui prend en paramètre un fichier (PS) et l'initialise (avec les premières lignes de chaque fichier PS)
	procedure crea_ps (aFile : in out File_Type) is
	begin
			Put(aFile,"%!PS");
			New_Line(aFile);
			Put(aFile,"0 setlinewidth");
			New_Line(aFile);
	end crea_ps;

	-- procédure qui prend en paramètre un fichier (PS) et le termine (avec les dernières lignes de chaque fichier PS)
	procedure end_ps (aFile : in out File_Type) is
	begin
		Put(aFile,"showpage");
		New_Line(aFile);
	end end_ps;

end ps_file;
