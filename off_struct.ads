package off_struct is

	type Sommet is record -- type Point contenant 3 floats
		x : float;
		y : float;
		z : float;
	end record;

	type Sommet_T is array(integer range <>) of Sommet; -- tableau de sommets
	type pSommet_T is access Sommet_T; -- pointeur sur tableau de sommets

	type Integer_T is array(integer range <>) of Integer; -- pointeur sur tableau d'entiers
	type pInteger_T is access Integer_T; -- pointeur sur tableau d'entiers

	type Forme is record -- type forme contenant un entier et un tableau
		sommets : pInteger_T; -- tableau contenant dans chaque case un de ses sommets
		size : integer; -- taille du tableau de sommets
	end record;

	type Forme_List_Element; -- déclaration incomplète pour faire une liste de Triangle

	type Forme_List is access Forme_List_Element; -- type pointeur Triangle suivant

	type Forme_List_Element is record -- fin de la décalration de la liste de Triangle
		F : Forme; -- type des éléments
		Succ : Forme_List; -- pointeur sur le Triangle suivant de la liste
	end record;

	type Forme_List_T is array(integer range <>) of Forme_List; -- tableau de liste de forme
	type pForme_List_T is access Forme_List_T; -- pointeur sur tableau de liste de forme

	procedure getMinMaxXYZ(aSommets : in pSommet_T; aNbSommets : in integer; aMinX, aMaxX, aMinY, aMaxY, aMinZ, aMaxZ : out float);

	procedure libererSommet_T (aSommets : in out pSommet_T);
	procedure libererInteger_T (aIntegerArray : in out pInteger_T);
	procedure libererForme_List (aForme_List : in out Forme_List);
	procedure libererForme_List_T (aForme_List_T : in out pForme_List_T; aNbFormes : in integer);

end off_struct;
