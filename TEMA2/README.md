Ghita Maria 311CC

TASK 1:

-se face o copie a registrului in care se afla id-urile pt a nu pierde valoarea initiala
-se shifteaza cu 24 de pozitii pt a ramane cu cei 8 biti care formeaza id-ul
-se extinde valoarea din registrul ax la eax lasand ceilalti biti pe 0
-se iau permisiunile
-se face 'and' pe biti intre permisiunile dorite si reale, iar cele care coincid raman pe 1, deci se intra in 'good' , altfel se vor face 0

TASK 3:

Criptarea:
Codul realizeaza urmatorii pasi:
-bucla rounds_for itereaza pentru nr specificat de runde
-in fiecarei runde, se intra in bucla byte_for care itereaza peste fiecare octet al textului si al cheii
-pentru fiecare octet se efectueaza urmatoarele operatii:
	-se adauga octetul cheie la octetul textului 
	-se cauta rezultatul in sbox si se stocheaza in registrul al
	-se adauga urmatorul octet din text la registrul al
	-se roteste registrul al la stanga cu 1 bit
	-se stocheaza rezultatul inapoi in urmatorul octet de text
-pentru ultimul octet se efectueaza operatia:
	-se adauga octetul cheie la ultimul octet de text simplu
	-se cauta rezultatul in sbox si se stocheaza in registrul al
	-se adauga primul octet din text la registrul al
	-se roteste la stanga cu 1 bit
	-se stocheaza rezultatul inapoi in primul octet din text
-se decrementeaza nr de runde si se sare inapoi la inceputul buclei rounds_for.


Decriptarea :
In fiecare pas al decriptarii, textul e procesat byte cu byte, iar pentru fiecare byte al textului se realizeaza urmatoarele:
-se aduna byte-ul din textul criptat cu byte-ul corespondent din cheie
-rezultatul adunarii este utilizat pentru a accesa o anumita "celula" dinn sbox
-byte-ul corespunzator din sbox este utilizat pentru a inlocui byte-ul curent al textului criptat
-se face rotatie la dreapta asupra byte-ului urmator din bloc
-see actualizeaza byte-ul de pe pozitia resp cu valoarea lui t
-se scade valoarea
Se repeta pentru fiecare byte al textului criptat si pentru fiecare runda de decriptare. 
Ultimul byte este tratat separat deoarece nu exista un byte urmator pentru a se fectua rotatia.

TASK 4:

	-pentru acest task mi am creat functiile add_ecx, add_edx, sub_ecx si sub_edx care incrementeaza/decrementeaza indexul
liniei respectiv cel al coloanei.
	-in bucla for se incepe prin a lua inceputul liniei si apoi se aduga 1 in pozitia curenta pt a nu se mai intoarce,
efitandu se creearea unei bucle infinite
 	-se verifica daca trebuie sau nu schimbata directia
	-se verifica de fiecare data in parte elementul de sub/deasupra/dreapta/stanga pozitiei curente si se avanseaza
	-la final se pun valorile la adresele specificate in cerinta 