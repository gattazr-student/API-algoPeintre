with off_struct; use off_struct;

package off_file is

	--
	-- procedure file_to_sommets_formes
	-- Ouvre un fichier OFF, le lit et retourne un pointeur sur un tableau de point et une liste chainée de formes
	-- @param aFileName in : fichier off à lire
	-- @param aNbSommets out : Nombre de sommets contenu dans le fichier off
	-- @param aNbFormes out : Nombre de Formes contenu dans le fichier off
	-- @param aSommets out : Tableau des sommets contenus dans le fichier
	-- @param aFormes out : Liste chainée des formes contenus dans le fichier off
	--
	procedure file_to_sommets_formes(aFileName : in String; aNbSommets, aNbFormes: out integer; aSommets : out pSommet_T; aFormes : out Forme_List);
end off_file;
