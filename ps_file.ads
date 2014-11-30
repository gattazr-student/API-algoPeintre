with off_struct; use off_struct;

package ps_file is
	procedure forme_list_t_to_ps(aFileName : in String; aFormes : in pForme_List_T; aSommets : in pSommet_T; aSizeFormes : in Integer; aMinX, aMaxX, aMinY, aMaxY : in Float);
end ps_file;
