with off_struct; use off_struct;

package ps_file is

	--
	-- procedure forme_list_t_to_ps
	-- Créé et écrit dans le fichier aFileName les formes qui se trouvent dans aFormes.
	-- Un facteur d'agrandissement est appliqué à toutes les formes afin que le l'ensemble des formes remplissent une feuille a4. Le ratio de l'image n'est pas modifié.
	-- @param aFileName in : Chemin vers le fichier à écrire
	-- @param aFormes in : Liste de formes à écrire
	-- @param aSommets in : Tableau contanant les sommets référencés dans les Formes
	-- @param aSizeFormes in : Taille du tableau aFormes
	-- @param aMinX in : valeur minimum en x prise par les sommets dans aSommets
	-- @param aMaxX in : valeur maximum en x prise par les sommets dans aSommets
	-- @param aMinY in : valeur minimum en y prise par les sommets dans aSommets
	-- @param aMaxY in : valeur maximum en y prise par les sommets dans aSommets
	--
	procedure forme_list_t_to_ps(aFileName : in String; aFormes : in pForme_List_T; aSommets : in pSommet_T; aSizeFormes : in Integer; aMinX, aMaxX, aMinY, aMaxY : in Float);
end ps_file;
