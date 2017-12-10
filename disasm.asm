.model small
.stack 100h
.data	
	pagalba							db 'Klaida',10,13,'$'
	duom							db 255 dup(0)
	rez								db 255 dup(0)
	; kodas		db ?
	pradiniai1  					db '.model small',10,13,'.org 100h',10,13,'$'
	pradzia							db '.code', 10,13,'$'
	tarpas							db 20,'$'
	NewLine							db 13,10, '$'
	neatpazinta 					db 'Neatpazinta'
	duom_deskriptorius 				dw ?
	rez_deskriptorius 				dw ?
	opkfile           				db "aa.txt",0
	neraopkfile 	  				db "Nera opk failo", 10,13,'$'
	OPK 			  				db 3000 dup (?)
	kiek_perkelt     				dw ?
	r_AX 							db 'ax$'
    r_CX 							db 'cx$'
    r_DX 							db 'dx$'
    r_BX 							db 'bx$'
    r_SP 							db 'sp$'
    r_BP 							db 'bp$'
    r_SI 							db 'si$'
    r_DI 							db 'di$'
	s_ES							db 'es$'
	s_SS							db 'ss$'
	s_DS							db 'ds$'
	s_CS							db 'cs$'
	; c_REP							db 'REP$'
	; c_REPNE     					db 'REPNE$'
	op_pavadinimas 					db ?
	formato_nr    					db ?
	perkelktiek 					dw 0
	prefikso_seg 					dw ?
	reprep							dw 0
	prefiksas_rastas 				db 0
	bitai							dw 8 dup (?)       ;cia desiu 2vejetaine baito forma
	komanda							db ?
	OPK_pavadinimo_ilgis 			dw 1
	duomenu_buferis					db 1000 dup (?)
	nr								dw 0
	kelinta_eilute					db 0
	kiek_nuskaite					dw 0
	bitas_d							dw ?
	bitas_w							dw ?
	baito_mod						dw 2 dup (?)
	baito_reg						dw 3 dup (?)
	baito_rm						dw 3 dup (?)
	lentele							dw 'a','l','a','x','b','x','+','s','i',' ','c','l','c','x','b','x','+','d','i',' ','d','l','d','x','b','p','+','s','i',' ','b','l','b','x','b','p','+','d','i',' ','a','h','s','p','s','i','?','?','?',' ','c','h','b','p','d','i','?','?','?',' ','d','h','s','i','-','-','?','?','?',' ','b','h','d','i','b','x','?','?','?'
	nr_lentelej						dw 0
	reg_spausdinimui				dw 0,0,0,0
	kablelis						dw 2Ch,20h,'$'
	mod_desimtainis					dw 0
	poslinkio_dydis					dw 0
	sr_baitu_suma					dw 0
	komandos_nr						db ? 
.code
start:
	mov dx, @data
	mov ds,dx
	
	call parametru_skaitymas
	call failo_atidarymas
	call rez_sukurimas_atidarymas
	call skaitymas   ;;;;;gale tada cj reik rasyt perkelima
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;jeigu bus problemu tai ziuret ar cia ne del db ir dw kai kuriose vietose 

ciklas:
	call ikelimas
	inc nr
	mov dx, kiek_nuskaite
	cmp nr, dx
	jg buferio_pabaiga
	call ar_prefiksas
	call kokia_komanda
	call tvarkymas
	; call baitas_i_bitus
	; jmp pabaiga
	; mov dx, kiek_nuskaite
	; cmp nr, dx								
	; jne ciklas
buferio_pabaiga:	
	call skaitymas								;jeigu bus pasibaiges failas, tai is skaitymo jmpins i exita
	jmp ciklas
;-------------------------------------------------
;komandos ikelimas is kodu buferio
;-------------------------------------------------
proc ikelimas
	push bx
	mov si, nr
	mov bh, [duomenu_buferis+si]
	mov komanda, bh
	pop bx
	ret
ikelimas endp
;--------------------------------------------
;nukreipimas ka su kuo reikia daryti
;-----------------------------------------------
proc tvarkymas
	jmp lyginimas
one:
	jmp pirma
two:
	jmp antra
three:
	jmp trecia
; four:
	; jmp ketvirta
; five:
	; jmp penkta
six:
	jmp sesta
; seven:
	; jmp septinta
; eight:
	; jmp astunta
; nine:
	; jmp devinta
lyginimas:	
	cmp komandos_nr, '1'
	je one
	cmp komandos_nr, '2'
	je two
	cmp komandos_nr, '3'
	je three
	; cmp komandos_nr, 4
	; je four
	; cmp komandos_nr, 5
	; je five
	cmp komandos_nr, '6'
	je six
	; cmp komandos_nr, 7
	; je seven
	; cmp komandos_nr, 8
	; je eight
	; cmp komandos_nr, 9
	; je nine
	; cmp komandos_nr, 'a'
	; je aa
	; cmp komandos_nr, 'b'
	; je bb
	; cmp komandos_nr, 'c'
	; je cc
	; cmp komandos_nr, 'd'
	; je ddd
	; cmp komandos_nr, 'e'
	; je ee
	; cmp komandos_nr, 'f'
	; je ff
	; cmp komandos_nr, 'g'
	; je gg
	; cmp komandos_nr, 'j'
	; je jj
	; cmp komandos_nr, 'k'
	; je kk
	; cmp komandos_nr, 'l'
	; je ll
	; cmp komandos_nr, 'm'
	; je mm
	; cmp komandos_nr, 'n'
	; je nn
	
	jmp trecia               ;jeigu neatitinka nei vieno firmato, buvo neatpazinta komanda
	
; one:
	; jmp pirma
; two:
	; jmp antra
; three:
	; jmp trecia
; four:
	; jmp ketvirta
; five:
	; jmp penkta
; six:
	; jmp sesta
; seven:
	; jmp septinta
; eight:
	; jmp astunta
; nine:
	; jmp devinta
; aa:
	; jmp desimta
; bb:
	; jmp vienuolika
; cc:
	; jmp dvylikta
; ddd:
	; jmp trylikta
; ee:
	; jmp keturiolikta
; ff:
	; jmp penkiolika
; gg:
	; jmp ses
; jj:
	; jmp sept
; kk:
	; jmp astuon
; ll:
	; jmp devynio
; mm:
	; jmp dvid
; nn:
	; jmp dvidp
	
	ret
	
tvarkymas endp

;----------------------------------------------------------------
;pirmas formatas
;----------------------------------------------------------------
pirma:
	call baitas_i_bitus              ;turiu opk bitais buferyje [bitai]
	call dwbitai
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	call ikelimas				;kadangi turiu dw bitus,pav,formata, man jo nebereikes
	inc nr
	call baitas_i_bitus			;dabar reikia turet sekanti baita nes reikes nagrinet pagal mod reg rm
	call modregrm
	cmp bitas_d, 0
	je dbitas0
	call rm_i_reg
	jmp endas1
dbitas0:
	call reg_i_rm
endas1:
	jmp ciklas
;-----------------------------------
;antras formatas kodasW bojb [bovb]
;-----------------------------------
antra:
	call baitas_i_bitus 
	call dwbitai
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	cmp bitas_w, 1
	je ww1
	mov poslinkio_dydis, 1
ww1:
	mov poslinkio_dydis, 2
	call poslinkio_spausdinimas
	jmp ciklas
;------------------------------------
;sestas formatas kodasSRkodas
;------------------------------------
sesta:
	mov bx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	call baitas_i_bitus
	mov si, 4
	mov dx, [bitai+si] 
	add sr_baitu_suma, dx
	mov si, 3
	mov dx, [bitai+si]
	add dx,dx
	add sr_baitu_suma, dx
	cmp sr_baitu_suma, 0
	je es_segm
	cmp sr_baitu_suma, 1
	je cs_segm
	cmp sr_baitu_suma, 2
	je ss_segm
	cmp sr_baitu_suma, 3
	je ds_segm
es_segm:
	mov bx, offset s_ES
	jmp spaus
cs_segm:
	mov bx, offset s_CS
	jmp spaus
ss_segm:
	mov bx, offset s_SS
	jmp spaus
ds_segm:
	mov bx, offset s_DS
	jmp spaus
spaus:
	; mov bx, offset op_pavadinimas
	; mov cx, OPK_pavadinimo_ilgis
	; call Rasymas
	; call space
	; mov bx, offset prefikso_seg
	mov cx, 1
	call Rasymas
	call naujaeilute
jmp ciklas		
;-------------------------------------
;kai d bitas =0, saltinis reg, rezultatas rm
;----------------------------------------
proc reg_i_rm
	push dx
	call rm_sutvarkymas
	mov bx, offset kablelis
	mov cx, 2
	call Rasymas
	cmp prefiksas_rastas, 1				;spausdinu prefikso segmenta, po jo seks rm
	jne toliau
	mov bx, offset prefikso_seg
	mov cx, 2                       ;;;;;;;;;;;;;;;;;;;;;
	call Rasymas
toliau:
	call reg_sutvarkymas
	call naujaeilute
	pop dx
	ret
reg_i_rm endp	
;-------------------------------------
;kai d bitas =1, saltinis rm, rezultatas reg
;----------------------------------------
proc rm_i_reg
	push dx
	call reg_sutvarkymas				;atspausdinu reg
	mov bx, offset kablelis
	mov cx, 2
	call Rasymas
	cmp prefiksas_rastas, 1				;spausdinu prefikso segmenta, po jo seks rm
	jne toliauu
	mov bx, offset prefikso_seg
	mov cx, 2
	call Rasymas
toliauu:
	call rm_sutvarkymas
	call naujaeilute
	pop dx
	ret
rm_i_reg endp
;----------------------------------------
;reg radimas ir spausdinimas
;----------------------------------------
proc reg_sutvarkymas
	mov bx, [baito_reg]
	call skaiciavimas
	cmp bitas_w, 1
	jne nelygu
	add nr_lentelej, 2
nelygu:
	xor di,di
	mov si, nr_lentelej
	mov dx, [lentele+si]
	mov [reg_spausdinimui+di], dx
	inc si
	inc di
	mov dx, [lentele+si]
	mov [reg_spausdinimui+di], dx
	mov bx, offset reg_spausdinimui
	mov cx, 2
	call Rasymas
	; mov si, 2s
	mov nr_lentelej, 0
	ret
reg_sutvarkymas endp
;-------------------------------------
;rm isnagrinejimas ir spausdinimas
;---------------------------------------
proc rm_sutvarkymas  
	mov bx, [baito_rm] 
	call skaiciavimas      ;turiu nr_lentelej kuris rodo i pati pirma elementa pagal rm, dabar reik, kad pridetu pagal mod
	call mod_pavertimas_desimtainiu
	cmp mod_desimtainis, 3
	je modtrys
	add nr_lentelej, 4                        ;cia bus mod 00 arba 01
reikalinga:
	mov si, nr_lentelej
	xor di,di
ciklelio:
	mov bx, [lentele+si]
	cmp bx, 20h
	je nuskaityta 
	mov [reg_spausdinimui+di], bx
	inc di
	inc si
	jmp ciklelio
nuskaityta:
	cmp [reg_spausdinimui], 2Dh     ;ziuriu ar ne tiesioginis adresas, nes jis uzpildytas ---
	je tiesioginisadresas
	inc di
	mov bx, offset reg_spausdinimui
	mov cx, di
	call Rasymas
	cmp mod_desimtainis, 3
	je theend
	cmp mod_desimtainis, 1
	je modvienas
	cmp mod_desimtainis, 2
	je moddu
	jmp theend
modvienas:
	mov poslinkio_dydis, 1
	call poslinkio_spausdinimas
	jmp theend
moddu:
	mov poslinkio_dydis, 2
	call poslinkio_spausdinimas
	jmp theend
modtrys:
	cmp bitas_w, 1
	je w1
	jmp reikalinga
w1:
	add nr_lentelej,2
	jmp reikalinga
theend:
	ret
rm_sutvarkymas endp
tiesioginisadresas:
	mov poslinkio_dydis, 2
	call poslinkio_spausdinimas
	jmp theend
;--------------------------------------
;poslinkis
;---------------------------------------
proc poslinkio_spausdinimas
push cx
push bx
	cmp poslinkio_dydis, 1
	jne baitu2poslinkis
	call ikelimas
	mov bx, offset komanda
	mov cx, 1
	jmp endas
baitu2poslinkis:
	inc nr 
	call ikelimas
	mov bx, offset komanda
	mov cx,1
	dec nr
	call ikelimas
	mov bx, offset komanda
	mov cx,1
	inc nr
	inc nr
endas:
	pop bx
	pop cx
	ret
poslinkio_spausdinimas endp
;---------------------------------------
;eiles skaiciavimas lentelej
;---------------------------------------
proc skaiciavimas	
	push dx ;;;;;;;;;;;;;;;;gal ir nereik
	mov si,2								;paskutinis reg bitas, kurio svoris = 1
	mov dx, [bx+si]
	mov nr_lentelej, dx
	dec si
	mov al, 2d								;2 reg bitas, kurio svoris = 2
	mov dx, [bx+si]
	mul dx
	add nr_lentelej, ax
	mov al, 4d
	mul bx
	add nr_lentelej, ax
	mov al,10d
	mul nr_lentelej							;dabar rodo i pirma raide jei w=0
	pop dx      ;;;;;;;gal ir nereik
	ret
skaiciavimas endp
;------------------------------------
;mod pavertimas desimtainiu skaiciu
;--------------------------------------
proc mod_pavertimas_desimtainiu
push ax
push bx
	mov al, 2d
	mov si,0
	mul [baito_mod+si]
	add mod_desimtainis, ax
	inc si
	mov bx, [baito_mod+si]
	add mod_desimtainis, bx
pop bx
pop ax
	ret
mod_pavertimas_desimtainiu endp
;--------------------------------------
;tvarkymasis su mod reg rm
;--------------------------------------
proc modregrm
	xor di,di
	mov si,0
	mov dx, [bitai+si]
	mov [baito_mod+di], dx		;du mod bitai
	inc si
	inc di
	mov dx, [bitai+si]
	mov [baito_mod+di], dx
	xor di,di
keliu_reg:
	inc si
	mov dx, [bitai+si]
	mov [baito_reg+di], dx
	cmp si, 5d
	je keliu_rm
	inc di
	jmp keliu_reg
keliu_rm:
	xor di,di
rmrm:
	inc si
	mov dx, [bitai+si]
	mov [baito_reg+di], dx
	cmp si, 8d
	je kelimas_baigtas
	jmp rmrm
kelimas_baigtas:
	ret
modregrm endp
;-------------------------------------------------------
;d ir w bitu radimas
;--------------------------------------------------------
proc dwbitai
	mov si, 7
	mov di, 8
	mov dx,  [bitai+si]
	mov bitas_d, dx
	mov dx,  [bitai+di]
	mov bitas_w, dx
	ret
dwbitai endp	
;-----------------------------------------------------------------
;kai komanda neatpazinta
;-----------------------------------------------------------------
komanda_buvo_neatpazinta:
	mov dx, offset neatpazinta
	mov cx, 11
	call Rasymas
	call naujaeilute
	jmp ciklas
;--------------------------------------------
;trecias formatas
;--------------------------------------------
trecia:
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call naujaeilute
	jmp ciklas
	; jmp pabaiga
;-----------------------------------------------------------------------
;Nauja eilute
;------------------------------------------------------------------------
PROC naujaeilute
	mov bx, rez_deskriptorius
	mov cx, 2d
	mov ah, 40h
	mov dx, offset newLine
	int 21h
RET															
ENDP naujaeilute 
;-------------------------------------------
;kreipimasis i opk faila
;--------------------------------------------
tikrinuOPK proc

   mov ah, 03Dh
   xor al, al
   mov dx, offset opkfile
   int 21h
   push ax    ;ax saugo failo deskr nr
   jc klaidaa
   add kiek_perkelt, 0Ch
   mov ah, 03Fh
   pop bx
   mov dx, offset OPK    ;dx-skaitymo buferio adresas
   mov cx, kiek_perkelt    
   int 21h
   mov ah, 03Eh
   int 21h
   jc klaidaa
   ret
tikrinuOPK endp
klaidaa:
jmp klaida

;-----------------
;tarpas
;---------------
proc space
	mov bx, rez_deskriptorius
	mov cx, 1
	mov ah, 40h
	mov dx, offset tarpas
	int 21h
RET		
space endp	
;----------------------------------------
;kokia komanda
;----------------------------------------
proc kokia_komanda
	mov al, 0Ch
	mov OPK_pavadinimo_ilgis, 0
	mul komanda
	mov kiek_perkelt, ax
	call tikrinuOPK
	sub kiek_perkelt, 0Ch
	mov si, kiek_perkelt
	xor di,di
	xor bh,bh
pav:
	mov bh, [OPK+si]
	cmp bh, 32d							;jeigu tarpas, tai reiskia jau bus gaunamas formato kodas
	je fo
	mov [op_pavadinimas+di], bh
	inc OPK_pavadinimo_ilgis
	inc di
	inc si
	jmp pav
fo:
	inc di
	mov [op_pavadinimas+di], '$'
	inc si
	mov bl, [OPK+si]
	mov komandos_nr, bl
	ret
kokia_komanda endp
;------------------------------------------
;konvertavimas i bitus
;-----------------------------------------
proc baitas_i_bitus
	; xor di,di
	mov di, 8d
; valau:
	; cmp di, 9d
	; je isvalyta
	; mov [bitai+di], 0
	; inc di
; isvalyta:
   mov bl, 02h
   mov al, komanda
   mov di, 08h
 divloop:
   xor ah, ah
   div bl
   dec di
   add ah, 30h
   mov [bitai+di], ax
   cmp al, 0
   jne divloop
   cmp di, 0
   je bye
keliunulius:
	dec di
	mov ax, 30h
	mov [bitai+di], ax
	cmp di, 0
   jne keliunulius
 bye:
   ret
 endp baitas_i_bitus
;-------------------------------------
;ar prefiksas
;------------------------------------
proc ar_prefiksas
	mov dh, komanda
	cmp dh, 26h
	je es_seg
	cmp dh, 2Eh
	je cs_seg
	cmp dh, 36h
	je ss_seg
	cmp dh, 3Eh
	je ds_seg
nerastas:
	jmp next
es_seg:
	mov prefikso_seg, 'es'
	jmp skait
cs_seg:
	mov prefikso_seg, 'cs'
	jmp skait
ss_seg:
	mov prefikso_seg, 'ss'
	jmp skait
ds_seg:
	mov prefikso_seg, 'ds'
	jmp skait
skait:
	mov prefiksas_rastas, 1        ;JEI REIKSME 1, tai kai spausdinsiu patikrinsiu ar buvo toks ir pridesiu prie reg arba r/m
	; call perkelimas
	; inc nr
	; jmp ciklas
next:
	ret
endp ar_prefiksas
;------------------------------------
;rasymas i faila
;-------------------------------------
Rasymas proc

	; inc kelinta_eilute
	; push dx
	; push cx
	
	; mov ah, 40h
	; mov bx, rez_deskriptorius
	; mov dx, offset nr
	; mov cx, 1
	; int 21h
	
	; pop cx
	; pop dx
	
   mov ah, 40h
   mov bx, rez_deskriptorius
   int 21h
   ret
Rasymas endp
;------------------------------------
;klaida
;------------------------------------
mistake:
	mov ah, 09h
	mov dx, offset pagalba
	int 21h
	jmp pabaiga
	
;--------------------------------------
;skaitymas is duom failo
;--------------------------------------
proc skaitymas

	; push cx
	; push dx
	
	mov ah, 3Fh
	mov bx, duom_deskriptorius
	mov cx, 1000d
	mov dx, offset duomenu_buferis
	int 21h
	
	; inc perkelktiek
	mov kiek_nuskaite, ax

	cmp ax,0
	je end_as   ;jei nieko nenuskaite vadinas pabaiga
	
	ret
skaitymas endp

end_as:
	jmp exitas   ;;;;;;;;;;;;;;;parasyk exita kad parasytu failo gale tuos reikalingus duomenis pabaigos
;----------------------------------------------
;duom failo uzdarymas
;------------------------------------------------
duomf_uzdarymas:
	mov ah,3Eh
	mov bx, duom_deskriptorius
	int 21h
	jmp pabaiga
	
;-------------------------------------------------------------------------------
;Rez failo uzdarymas
;-------------------------------------------------------------------------------
rezf_uzdarymas:
	mov ah,3Eh
	mov bx, rez_deskriptorius
	int 21h
	jmp pabaiga
;-------------------------------------------
;rez failo sukurimas ir atidarymas rasymui
;-------------------------------------------
proc rez_sukurimas_atidarymas
	mov ah, 3Ch					;sukuriamas failas
	xor cx,cx
	mov dx, offset rez
	int 21h
	jc RezSukurimoKlaida		;jei kuriant faila meta errora
	mov rez_deskriptorius, ax
	
	ret
rez_sukurimas_atidarymas endp

RezSukurimoKlaida:
	jmp mistake
	
;----------------------------------
;failo atidarymas skaitymui
;----------------------------------
proc failo_atidarymas
	mov ah, 3Dh
	mov al, 00					;failas atidaromas skaitymui
	mov dx, offset duom
	int 21h
	jc DuomAtidarymoKlaida		;jei atidarant faila skaitymui ivyko klaida, CF=1
	mov duom_deskriptorius, ax				;issaugau duom failo dekriptoriaus nr
	ret
failo_atidarymas endp
	
DuomAtidarymoKlaida:
	jmp mistake

;--------------------------------
;Parametru skaitymas
;--------------------------------
proc parametru_skaitymas
	xor cx,cx
	xor bx,bx
	xor ax,ax
	xor si,si
	mov bx,0082h
Duomenys:
	mov al,es:[bx]
	inc bx
	cmp al, 13d				;jei nieko neivede tai klaida1
	je klaida
	cmp al, ' '
	je DuomenysRasti
	cmp al, '/'
	je slash
tesiu:
	mov [duom+si],al
	inc si
	JMP duomenys
DuomenysRasti:	
	inc si						;duomenu pabaiga
	mov dx, '$'
	mov [duom+si], dl
	xor si,si
	mov al, es:[bx]				;jeigu po duom failo parasymo yra enteris, vadinasi nera rez failo pavadinimo
	cmp al,13d
	je klaida
Rezultatai:
	mov al,es:[bx]
	inc bx
	cmp al,13d
	je RezultatasRastas
	mov [rez+si],al
	inc si
	JMP Rezultatai
RezultatasRastas:
	inc si
	mov dx, '$'
	mov [rez+si], dl
	jmp baigta
klaida:
	jmp mistake
slash:
	mov al,es:[bx]
	cmp al, '?'
	jne tesiu
	jmp mistake
baigta:	
	ret

parametru_skaitymas endp
;----------------------------------------------
exitas:

pabaiga:
	mov ah, 4ch
	mov al, 0
	int 21h
end start