with off_struct; use off_struct;
with off_file; use off_file;
with tri_packet; use tri_packet;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Integer_Text_IO;

package ps_file is
	function demarrer(aFormes : in Forme_List_T) return integer;
	procedure demarrer (APoly: in pForme_List_T; Pp: in out Forme_List_Element; CaseCour : out integer);
	procedure avancer (aFormes : in Forme_List_T ; aIndice : in out integer);
	function end_tab (aFormes : in Forme_List_T; aIndice : in integer) return boolean;
	procedure crea_ps (aFile : in out File_Type);
	procedure end_ps (aFile : in out File_Type);
end ps_file;
