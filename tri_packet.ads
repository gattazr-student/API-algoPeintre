with off_struct; use off_struct;

package tri_packet is

	--
	-- procedure triParPaquet
	-- trie selon l'algorithme du tri par paquet la liste aFormesUnsorted. Le retour de la fonction est un tableau de liste.
	-- @param aFormesUnsorted in : Liste de Formes à trier
	-- @param aSommets in : Tableau contenant les sommets référencés dans la Formes
	-- @param aNbFormes in : nombre de Formes contenu dans la liste aFormesUnsorted
	-- @param aMinZ in : Valeur minimum prise en z par les sommets dans aSommets
	-- @param aMaxZ in : Valeur maximum prise en z par les sommets dans aSommets
	-- @param aFormesSorted out : Tableau trié de liste trié
	--
	procedure triParPaquet(aFormesUnsorted : in Forme_List; aSommets : in pSommet_T; aNbFormes : in integer; aMinZ, aMaxZ : in Float; aFormesSorted : out pForme_List_T);
end tri_packet;
