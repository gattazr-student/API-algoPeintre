with off_struct; use off_struct;

package off_file is
	procedure file_to_sommets_formes(aFileName : in String; aNbSommets, aNbFormes: out integer; aSommets : out pSommet_T; aFormes : out Forme_List);
end off_file;
