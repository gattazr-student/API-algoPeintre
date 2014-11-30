with off_struct; use off_struct;

package machine_seq is

	procedure Demarrer(aFormes : pForme_List_T; aSize : Integer);
	function finDeSequence return Boolean;
	procedure avancer;
	function elementCourant return Forme;

end machine_seq;