with off_struct; use off_struct;

package tri_packet is
	procedure triParPaquet(aFormesUnsorted : in Forme_List; aSommets : in pSommet_T; aNbFormes : in integer; aMinZ, aMaxZ : in Float; aFormesSorted : out pForme_List_T);
end tri_packet;
