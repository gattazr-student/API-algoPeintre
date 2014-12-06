with off_struct; use off_struct;

package machine_seq is

	--
	-- procedure Demarrer
	-- la fonction demarer met en place les elements de la machine sequentielle
	-- @param aFormes : pointeur sur le tableau de liste de formes à utiliser
	-- @param aSize : taille du tableau aFormes
	--
	procedure Demarrer(aFormes : in pForme_List_T; aSize : in Integer);

	--
	-- fonction finDeSequence
	-- la fonction retourne vrai si la machine sequentielle à atteint le dernier élément.
	-- @return boolean : true si machine sequentielle à atteint le dernier élément, false sinon
	--
	function finDeSequence return Boolean;

	--
	-- procedure avancer
	-- la procedure avancer change l'élement courant en tant que l'element suivant. L'élement courant est, si il existe, le successeur de l'element courant, ou la prochaine case non vide du tableau.
	--
	procedure avancer;

	--
	-- fonction elementCourant
	-- la fonction retourne l'element courant de la machine sequentielle
	-- @return Forme : Element courant de la machine sequentielle
	--
	function elementCourant return Forme;

end machine_seq;