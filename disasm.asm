.model small
.stack 100h
.data
pagalba                            db 'Klaida',10,13,'$'
duom                            db 255 dup(0)
rez                                db 255 dup(0)
pabaiga1							db 'Bseg ENDs',10,13,'END start','$'
pradiniai                      db '.model small',10,13,'BSeg SEGMENT',10,13,'ORG	100h',10,13,'ASSUME ds:BSeg, cs:BSeg, ss:BSeg',10,13,'start:',10,13,'$'
tarpas                            db 20h,'$'
NewLine                            db 13,10, '$'
neatpazinta                     db 'Neatpazinta', '$'
duom_deskriptorius                 dw ?
rez_deskriptorius                 dw ?
opkfile                           db "aa.txt",0
neraopkfile                       db "Nera opk failo", 10,13,'$'
OPK                               db 3000 dup (?)
kiek_perkelt                     dw ?
kokio_ilgio                        dw 0
r_AX                             db 'ax$'
r_AL							db 'al$'
s_ES                            db 'es$'
s_SS                            db 'ss$'
s_DS                            db 'ds$'
s_CS                            db 'cs$'
op_pavadinimas                     db 0,0,0,0,0,'$'
formato_nr                        db ?
perkelktiek                     dw 0
prefikso_seg                     db ?
reprep                            dw 0
prefiksas_rastas                 db 0
bitai                            db 8 dup (?)       ;cia desiu 2vejetaine baito forma
komanda                            db ?
OPK_pavadinimo_ilgis             dw 1
duomenu_buferis                    db 1000 dup (?)
nr                                dw 0
kelinta_eilute                    db 0
kiek_nuskaite                    dw 0
bitas_d                            db 0
bitas_w                            db 0
baito_mod                        db 2 dup (?)
baito_reg                        db 3 dup (?)
baito_rm                        db 3 dup (?)
lentele                            db 'al ax bx+si cl cx bx+di dl dx bp+si bl bx bp+di ah sp si ?? ch bp di ?? dh si -- ?? bh di bx ?? '
nr_lentelej                        dw 0
reg_spausdinimui                dw 0,0,0,0
kablelis                        db 2Ch,20h,'$'
mod_desimtainis                    db 0
poslinkio_dydis                    dw 0
sr_baitu_suma                    db 0
komandos_nr                        db ?
mano_si                            dw ?
mano_di                            dw ?
poslinkis							dw 0
sesioliktainis						db 'h','$'
bruksniukai						db 'ADD OR  ADC SBB AND SUB XOR CMP','$'
reg_desimtainis					db 0
k_DEC							db 'DEC', '$'
k_INC							db 'INC', '$'
ip_zenklai						db ':', ' ', '$'
ip  dw 0
ip_buff db 0,0,0,0,'$'
isplestas dw 00FFh
jmpu_ip	dw 0, '$'
.code
start:
mov dx, @data
mov ds,dx

call parametru_skaitymas
call failo_atidarymas
call rez_sukurimas_atidarymas
call skaitymas   ;;;;;gale tada cj reik rasyt perkelima
mov dx, offset pradiniai
mov cx, 80d
call Rasymas
ciklas:
mov ax, ip
call regoutip
mov prefiksas_rastas, 0
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
call skaitymas                                ;jeigu bus pasibaiges failas, tai is skaitymo jmpins i exita
jmp ciklas
;-------------------------------------------------
;komandos ikelimas is kodu buferio
;-------------------------------------------------
proc ikelimas
; push bx
mov si, nr
mov bh, [duomenu_buferis+si]
mov komanda, bh
inc ip
; pop bx
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
seven:
jmp septinta
eight:
jmp astunta
nine:
jmp devinta

lyginimas:
cmp komandos_nr, '1'
je one
cmp komandos_nr, '2'
je two
cmp komandos_nr, '3'
je three
; cmp komandos_nr, '4'
; je four
; cmp komandos_nr, 5
; je five
cmp komandos_nr, '6'
je six
cmp komandos_nr, '7'
je seven
cmp komandos_nr, '8'
je eight
cmp komandos_nr, '9'
je nine
cmp komandos_nr, 'a'
je aaaa
; cmp komandos_nr, 'b'
; je bb
cmp komandos_nr, 'c'
je cc
cmp komandos_nr, 'd'
je ddd
cmp komandos_nr, 'e'
je ee
; cmp komandos_nr, 'f'
; je ff
; cmp komandos_nr, 'g'
; je gg
cmp komandos_nr, 'j'
je jj
cmp komandos_nr, 'k'
je kk
cmp komandos_nr, 'm'
je mm
cmp komandos_nr, 'l'
je ll
jmp komanda_buvo_neatpazinta              ;jeigu neatitinka nei vieno firmato, buvo neatpazinta komanda

aaaa:
jmp desimta
; bb:
; jmp vienuolika
cc:
jmp dvylikta
ddd:
jmp trylikta
ee:
jmp keturiolikta
; ff:
; jmp penkiolika
; gg:
; jmp ses
jj:
jmp sept
kk:
jmp astuon
ll:
jmp devyniolikta
mm:
jmp dvid


ret

tvarkymas endp

;---------------------------------------
;ketvirtas formatas (INC arba DEC)
;-----------------------------------------
; ketvirta:
	; call baitas_i_bitus
	; call dwbitai
	; call ikelimas
	; call modregrm
	; call reg_pavertimas_desimtainiu
	; cmp reg_desimtainis, 1
	; jne komdec
	; mov dx, offset k_INC
; ikelk:
	; mov cx, 3
	; call Rasymas
	
	
	
; komdec:
	; mov dx, offset k_DEC
	; jmp ikelk
;-------------------------------------------
;devintas formatas (kodasSW mod---r/m [poslinkis] bojb [bovb])
;-------------------------------------------
devinta:
	call baitas_i_bitus
	call dwbitai    ;d bite bus s
	call ikelimas
	inc nr
	call modregrm
	call reg_pavertimas_desimtainiu
	mov al, 4
	mul reg_desimtainis
	mov cx, ax
	mov si, offset bruksniukai
cik:
	inc si
	loop cik
	mov di, offset op_pavadinimas
	mov bh, byte ptr ds:[si]
	mov byte ptr ds:[di], bh
	inc si
	inc di
	mov bh, byte ptr ds:[si]
	mov byte ptr ds:[di], bh
	inc si
	inc di
	mov bh, byte ptr ds:[si]
	mov byte ptr ds:[di], bh
	inc di
	mov byte ptr ds:[di], '$'
	
	mov dx, offset op_pavadinimas
	mov cx, 3
	call Rasymas
	call space
	call mod_pavertimas_desimtainiu
	cmp mod_desimtainis, 1
	jne dviejubaitup
	mov poslinkio_dydis, 1
poslinkel:
	call poslinkio_spausdinimas
	mov dx, offset kablelis
	mov cx, 2
	call Rasymas
	cmp bitas_d, 1
	jne nedviejubaitup
	mov poslinkio_dydis, 2
pos:
	call poslinkio_spausdinimas
	call naujaeilute
	jmp ciklas
dviejubaitup:
	mov poslinkio_dydis, 2
	jmp poslinkel
nedviejubaitup:
	mov poslinkio_dydis, 1
	jmp pos	
	
;------------------------------------------
;desimtas formatas (cmp ax(al), b.op)
;------------------------------------------
desimta:
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	call baitas_i_bitus
	call dwbitai
	cmp bitas_w, 1
	jne busal
	mov dx, offset r_AX
ras:
	mov cx, 2
	call Rasymas
	
	mov dx, offset kablelis
	mov cx, 2
	call Rasymas
	mov poslinkio_dydis, 2
	call poslinkio_spausdinimas
	mov dx, offset sesioliktainis
	mov cx, 1
	call Rasymas
	call naujaeilute
	jmp ciklas
busal:
	mov dx, offset r_AL
	jmp ras
	
;--------------------------------------------
;dvid formatas (kodas pjb pvb)
;--------------------------------------------
dvid:
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	mov poslinkio_dydis, 2
	call poslinkio_spausdinimas
	call naujaeilute
	jmp ciklas
;--------------------------------------------
;devyniolikas formatas
;-------------------------------------------
devyniolikta:
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	call baitas_i_bitus
	call dwbitai
	mov poslinkio_dydis, 2
	call poslinkio_spausdinimas
	mov dx, offset kablelis
	mov cx, 2
	call Rasymas
	cmp bitas_w, 0
	jne bus_ax1
	mov dx, offset r_AL
tesimas1:
	mov cx, 2
	call Rasymas
	jmp ciklas
bus_ax1:
	mov dx, offset r_AX
	jmp tesimas1
;----------------------------------------------
;tryliktas formatas
;----------------------------------------------
trylikta:
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	call baitas_i_bitus
	call dwbitai
	cmp bitas_w, 0
	jne bus_ax
	mov dx, offset r_AL
tesimas:
	mov cx, 2
	call Rasymas
	mov dx, offset kablelis
	mov cx, 2
	call Rasymas
	mov poslinkio_dydis, 2
	call poslinkio_spausdinimas
	call naujaeilute
	jmp ciklas
bus_ax:
	mov dx, offset r_AX
	jmp tesimas
;---------------------------------------------
;septintas formatas (kodasREG)
;-----------------------------------------------
septinta:
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	call baitas_i_bitus
	call modregrm
	mov di, offset baito_reg
	mov si, offset baito_rm
	mov bh, byte ptr ds:[si]
	mov byte ptr ds:[di],bh
	inc si
	inc di
	mov bh, byte ptr ds:[si]
	mov byte ptr ds:[di],bh
	inc si
	inc di
	mov bh, byte ptr ds:[si]
	mov byte ptr ds:[di],bh
	mov bitas_w, 1
	call reg_sutvarkymas
	call naujaeilute
	jmp ciklas
;------------------------------------------
;opk opk
;------------------------------------------
astuon:
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	inc nr
	call naujaeilute
	jmp ciklas
;-----------------------------------------
;keturioliktas (kodas wREG bojb [bovb])
;------------------------------------------
keturiolikta:
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	call baitas_i_bitus
	mov di, offset baito_reg
	mov si, offset bitai
	inc si
	inc si
	inc si
	inc si
	mov bh, byte ptr ds:[si]
	mov bitas_w, bh
	inc si
	mov bh, byte ptr ds:[si]
	mov byte ptr ds:[di], bh
	inc di
	inc si
	mov bh, byte ptr ds:[si]
	mov byte ptr ds:[di], bh
	inc di
	inc si
	mov bh, byte ptr ds:[si]
	mov byte ptr ds:[di], bh
	call reg_sutvarkymas
	mov dx, offset kablelis
	mov cx, 2
	call Rasymas
	cmp bitas_w, 1
	jne vienas
	mov poslinkio_dydis, 2
icia:
	call poslinkio_spausdinimas
	mov dx, offset sesioliktainis
	mov cx, 1
	call Rasymas
	call naujaeilute
	; cmp bitas_w, 1
	; je praleisti
	; inc nr
	jmp ciklas
; praleisti:
vienas:
	mov poslinkio_dydis, 1
	jmp icia
	
;------------------------------------------
;dvylikta
;------------------------------------------
dvylikta:
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	inc nr
	inc nr
	mov poslinkio_dydis, 2
	call poslinkio_spausdinimas
	mov dx, offset kablelis
	mov cx, 2
	call Rasymas
	dec nr
	dec nr
	dec nr
	dec nr
	mov poslinkio_dydis, 2
	call poslinkio_spausdinimas
	inc nr
	inc nr
	call naujaeilute
	jmp ciklas
	
;-------------------------------------------
;pletimas pgal zenkla
;-------------------------------------------
proc pletimas_pagal_zenkla
	xor dx,dx
	cmp bitai, 1
	jne pletimas0
	mov ax, 100h
	mul isplestas
	mov isplestas, ax
	jmp abiem
pletimas0:
	mov isplestas, 0
abiem:
	mov al, 1
	mul komanda
	add isplestas, ax
	ret
pletimas_pagal_zenkla endp
;-------------------------------------------
;astuntas formatas 8 (zymes)
;-------------------------------------------
astunta:                                          ;blogai spausdina
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	call space
	mov poslinkio_dydis, 1
	call ikelimas
	inc nr
	call baitas_i_bitus
	call pletimas_pagal_zenkla
	mov ax,ip
	mov jmpu_ip, ax
	add jmpu_ip, 0100h
	mov ax, isplestas
	add jmpu_ip, ax
	; mov dx, jmpu_ip ;;;;;;;;;;;sito nereik siaip
	mov cx, 4
	mov ax, 1000h
ciklelis:	
	xor dx,dx
	mov bx, ax
	mov ax, jmpu_ip
	div bx   ;ah turiu liekana = mano paskutinis skaiciavimas
	
	cmp ax, 9
	jbe skaicius1  ;kitu atveju bus raide
	mov jmpu_ip, dx
	add jmpu_ip, 31h
spausd:
	push cx
	push bx
	mov dx, offset jmpu_ip
	mov cx, 1
	call Rasymas
	pop bx
	pop cx
	
	xor dx,dx
	mov ax,bx
	mov bx, 10h
	div bx
	
	; mov bx, ax
	loop ciklelis
	
	call naujaeilute
	jmp ciklas
	
skaicius1:
	mov jmpu_ip, ax
	add jmpu_ip, 30h
	jmp spausd
;-----------------------------------------------
;sept formatas (INT'eruptai)
;-----------------------------------------------
sept:
	mov dx, offset op_pavadinimas
	mov cx, OPK_pavadinimo_ilgis
	call Rasymas
	; call space
	mov poslinkio_dydis, 1
	call poslinkio_spausdinimas
	mov dx, offset sesioliktainis
	mov cx, 1
	call Rasymas
	call naujaeilute
	jmp ciklas
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
call ikelimas                ;kadangi turiu dw bitus,pav,formata, man jo nebereikes
inc nr
call baitas_i_bitus            ;dabar reikia turet sekanti baita nes reikes nagrinet pagal mod reg rm
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
; jc klaida1
call space
cmp bitas_w, 1
je ww1
mov poslinkio_dydis, 1
ww1:
mov poslinkio_dydis, 2
call poslinkio_spausdinimas
jmp ciklas
klaida1:
jmp klaida
;------------------------------------
;sestas formatas kodasSRkodas
;------------------------------------
sesta:
mov dx, offset op_pavadinimas
mov cx, OPK_pavadinimo_ilgis
call Rasymas
mov dx, offset tarpas
mov cx, 1
call Rasymas
call baitas_i_bitus
; mov si, 4
mov si, offset [bitai]
inc si
inc si
inc si
mov dl, byte ptr ds:[si]
add sr_baitu_suma, dl
inc si
mov dl, byte ptr ds:[si]
add dl,dl
add sr_baitu_suma, dl
cmp sr_baitu_suma, 0
je es_segm
cmp sr_baitu_suma, 1
je cs_segm
cmp sr_baitu_suma, 2
je ss_segm
cmp sr_baitu_suma, 3
je ds_segm
es_segm:
mov dx, offset s_ES
jmp spaus
cs_segm:
mov dx, offset s_CS
jmp spaus
ss_segm:
mov dx, offset s_SS
jmp spaus
ds_segm:
mov dx, offset s_DS
jmp spaus
spaus:
; mov bx, offset op_pavadinimas
; mov cx, OPK_pavadinimo_ilgis
; call Rasymas
; call space
; mov bx, offset prefikso_seg
mov cx, 2
call Rasymas
call naujaeilute
jmp ciklas
klaida2:
jmp klaida
;------------------------------------
;reg pavertimas desimtainiu
;------------------------------------
proc reg_pavertimas_desimtainiu
	mov di, offset baito_reg
	mov al, 4
	mov bh, byte ptr ds:[di]
	mul bh
	mov reg_desimtainis, al
	inc di
	mov al, 2
	mov bh, byte ptr ds:[di]
	mul bh
	add reg_desimtainis, al
	inc di
	mov bh, byte ptr ds:[di]
	add reg_desimtainis, bh
	ret
reg_pavertimas_desimtainiu endp
;-------------------------------------
;kai d bitas =0, saltinis reg, rezultatas rm
;----------------------------------------
proc reg_i_rm
; push dx
call rm_sutvarkymas
mov dx, offset kablelis
mov cx, 2
call Rasymas
cmp prefiksas_rastas, 1                ;spausdinu prefikso segmenta, po jo seks rm
jne toliau
mov dx, offset prefikso_seg
mov cx, 2                       ;;;;;;;;;;;;;;;;;;;;;
call Rasymas
toliau:
call reg_sutvarkymas
call naujaeilute
; pop dx
; mov nr_lentelej,0
ret
reg_i_rm endp
;-------------------------------------
;kai d bitas =1, saltinis rm, rezultatas reg
;----------------------------------------
proc rm_i_reg
; mov nr_lentelej, 0
; push dx
call reg_sutvarkymas                ;atspausdinu reg
mov dx, offset kablelis
mov cx, 2
call Rasymas
cmp prefiksas_rastas, 1                ;spausdinu prefikso segmenta, po jo seks rm
jne toliauu
mov dx, offset prefikso_seg
mov cx, 2
call Rasymas
toliauu:
call rm_sutvarkymas
call naujaeilute
; mov nr_lentelej, 0
; pop dx
ret
rm_i_reg endp
;----------------------------------------
;reg radimas ir spausdinimas
;----------------------------------------
proc reg_sutvarkymas
mov nr_lentelej, 0
mov dx, 1         ;jeigu skaiciavimo funkcijoj rasiu dx=1, vadinasi reikia imti baito_reg
call skaiciavimas
cmp bitas_w, 1
jne nelygu1
add nr_lentelej, 3d
nelygu1:
mov si, offset [lentele]
mov bx, nr_lentelej
sdas:
cmp bx, 0
je nelygu
dec bx
inc si
jmp sdas
nelygu:
mov di, offset [reg_spausdinimui]
mov dh, byte ptr ds:[si]
mov byte ptr ds:[di], dh
inc si
inc di
mov dh, byte ptr ds:[si]
mov byte ptr ds:[di], dh
inc di
mov byte ptr ds:[di], '$'
mov dx, offset reg_spausdinimui
mov cx, 2
call Rasymas
ret
reg_sutvarkymas endp
;-------------------------------------
;rm isnagrinejimas ir spausdinimas
;---------------------------------------
proc rm_sutvarkymas
mov nr_lentelej, 0
; push nr_lentelej
mov dx, 0     ;jeigu skaiciavimo funkcijoj rasiu dx=o, vadinasi reikia imti baito_rm
call skaiciavimas      ;turiu nr_lentelej kuris rodo i pati pirma elementa pagal rm, dabar reik, kad pridetu pagal mod
call mod_pavertimas_desimtainiu
cmp mod_desimtainis, 3
je modtrys
add nr_lentelej, 6d                        ;cia bus mod 00 arba 01 arba 10
hoho:
mov si, offset [lentele]
mov bx, nr_lentelej
sdas1:
cmp bx, 0
je reikalinga
dec bx
inc si
jmp sdas1

reikalinga:
; mov si, nr_lentelej
; xor di,di
; mov si, offset [lentele+si]
mov di, offset [reg_spausdinimui]
mov kokio_ilgio, 0
ciklelio:
mov bh, byte ptr ds:[si]
cmp bh, 20h
je nuskaityta
; mov di, offset [reg_spausdinimui+di]
mov byte ptr ds:[di], bh
inc di
inc si
inc kokio_ilgio
jmp ciklelio
nuskaityta:
mov byte ptr ds:[di], '$'
cmp reg_spausdinimui, 2Dh     ;ziuriu ar ne tiesioginis adresas, nes jis uzpildytas ---
je tiesioginisadresas
; dec di
mov dx, offset reg_spausdinimui
mov cx, kokio_ilgio
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
jmp hoho
w1:
add nr_lentelej,3
jmp hoho
theend:
; mov nr_lentelej, 0
ret
rm_sutvarkymas endp
tiesioginisadresas:
mov poslinkio_dydis, 2
call poslinkio_spausdinimas
jmp theend

;---------------------------------------------
;poslinkio tikrinimas
;----------------------------------------------------
proc poslinkio_skaiciavimas     ;paskaiciu0oja viena baita
	call baitas_i_bitus
	mov si, offset bitai
	mov mano_si, 0
simbolis:
	inc mano_si
	cmp mano_si, 3    ;vadinasi jau apskaiciavau visus 8 bitus
	je skaiciavimopab
	mov bh, byte ptr ds:[si]
	mov al, 8d
	mul bh
	mov poslinkis, ax
	inc si
	mov bh, byte ptr ds:[si]
	mov al, 4d
	mul bh
	add poslinkis, ax
	inc si
	mov bh, byte ptr ds:[si]
	mov al, 2d
	mul bh
	add poslinkis, ax
	inc si
	mov bh, byte ptr ds:[si]
	mov al, 1d
	mul bh
	add poslinkis, ax
	inc si
	
	cmp poslinkis, 0Ah
	jge galraide
	
;kitu atveju tai bus skaicius, jei ne raide tokia kuria patikrinau
	add poslinkis, 30h
	mov dx, offset poslinkis
	mov cx,1
	call Rasymas
	mov poslinkis, 0
	jmp simbolis
	
galraide:
	cmp poslinkis, 0Fh
	jle raide
	
raide:
	add poslinkis, 37h
	mov dx, offset poslinkis
	mov cx, 1
	call Rasymas
	mov poslinkis, 0
	jmp simbolis
	
skaiciavimopab:
	mov poslinkis, 0
	ret
poslinkio_skaiciavimas endp
	
;--------------------------------------
;poslinkis
;---------------------------------------
proc poslinkio_spausdinimas
; push cx
; push bx
cmp poslinkio_dydis, 1
jne baitu2poslinkis

call ikelimas
call space
call poslinkio_skaiciavimas
; call space
inc nr
jmp endas

baitu2poslinkis:
inc nr
call ikelimas
call space
; add komanda, 30h
call poslinkio_skaiciavimas
dec nr
call ikelimas
call poslinkio_skaiciavimas
; call space
inc nr
inc nr
endas:
; pop bx
; pop cx
ret
poslinkio_spausdinimas endp
;---------------------------------------
;eiles skaiciavimas lentelej
;---------------------------------------
proc skaiciavimas    ;grazina pirmo elemento toje eileje vieta
; mov dx, offset baito_rm

xor si, si
cmp dx, 1
je regreg

mov si, offset [baito_rm]
tesiuu:

mov dh, byte ptr ds:[si]
mov al, 4d
mul dh
; sub ax, 30h
mov nr_lentelej, ax
inc si
mov al, 2d                                ;2 reg bitas, kurio svoris = 2
mov dh, byte ptr ds:[si]
mul dh
add nr_lentelej, ax
inc si                                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;dec si
mov dh, byte ptr ds:[si]
mov al, 1d
mul dh
add nr_lentelej, ax
mov al,12d
mul nr_lentelej                            ;dabar rodo i pirma raide jei w=0
mov nr_lentelej, ax
ret
skaiciavimas endp
regreg:
; mov si,2                                ;paskutinis reg bitas, kurio svoris = 1
mov si, offset [baito_reg]
jmp tesiuu
;------------------------------------
;mod pavertimas desimtainiu skaiciu
;--------------------------------------
proc mod_pavertimas_desimtainiu
mov al, 2d
mov si,offset baito_mod
mov dh, byte ptr ds:[si]
mul dh
add mod_desimtainis, al
inc si
mov dh, byte ptr ds:[si]
add mod_desimtainis, dh
ret
mod_pavertimas_desimtainiu endp
;--------------------------------------
;tvarkymasis su mod reg rm
;--------------------------------------
proc modregrm
xor di,di
; mov si,0
mov si, offset bitai
mov dl, byte ptr ds:[si]
mov di, offset baito_mod
mov byte ptr ds:[di], dl        ;du mod bitai
; mov si, 1
inc di
inc si         ;si su bitais
; mov di, offset [bitai+di]
mov dl, byte ptr ds:[si]
; mov di, 1
; mov di, offset [baito_mod]
mov byte ptr ds:[di], dl
; xor di,di
; mov mano_si, 2
; mov si, 2
; mov mano_di, 0
; mov di, 0
mov cx, 3
; mov di, offset [baito_reg]

; inc si
mov di, offset [baito_reg]
keliu_reg:
inc si
; mov si, mano_si
; mov si,offset [bitai+si]
mov dh, byte ptr ds:[si]
; mov di, mano_di
; mov di, offset [baito_reg]
mov byte ptr ds:[di], dh
; cmp mano_si, 5d
; je keliu_rm
; inc mano_di
; inc mano_si
; inc si
inc di
loop keliu_reg
; keliu_rm:
; mov mano_di, 0
mov cx, 3
mov di, offset [baito_rm]
rmrm:
; mov si, mano_si
; mov si, offset [bitai+si]
inc si
mov dh, byte ptr ds:[si]
; mov di, mano_di
; mov di, offset [bitai+di]
mov byte ptr ds:[di], dh
; cmp mano_si, 7d
; je kelimas_baigtas
; inc mano_si
inc di
loop rmrm
kelimas_baigtas:
ret
modregrm endp
;-------------------------------------------------------
;d ir w bitu radimas
;--------------------------------------------------------
proc dwbitai
mov si, offset [bitai]
inc si
inc si
inc si
inc si
inc si
inc si
mov dh, byte ptr ds:[si]
mov bitas_d, dh
inc si
mov dh, byte ptr ds:[si]
mov bitas_w, dh
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
add kiek_perkelt, 0ch    ;0ch
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

;-----------------------------------------------------------
;ip spausdinimas
;-----------------------------------------------------------
proc regoutip
	mov [ip_buff + 0], 30h
	mov [ip_buff + 1], 31h
	mov [ip_buff + 2], 30h
	mov [ip_buff + 3], 30h
	mov si, 3h
back2:
	mov cx, 10h
	xor dx, dx
	div cx
	add dx, 30h
	mov [ip_buff + si], dl
	dec si
	cmp ax, 0h
	jne back2
	xor si, si
	mov cx, 4h
loopas4:
	cmp [ip_buff + si], 39h
	jbe toliau5
	add [ip_buff + si], 7h
toliau5:
	inc si
	loop loopas4
	mov dx, offset ip_buff
	mov cx, 4h
	call Rasymas
	mov dx, offset ip_zenklai
	mov cx, 2h
	call Rasymas
	ret
endp regoutip
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
mov al, 0ch
mov OPK_pavadinimo_ilgis, 0
mul komanda
mov kiek_perkelt, ax
call tikrinuOPK
sub kiek_perkelt, 0ch
mov si, kiek_perkelt
xor di,di
; xor bh,bh
pav:
mov bh, [OPK+si]
cmp bh, 32d                            ;jeigu tarpas, tai reiskia jau bus gaunamas formato kodas
je fo
mov [op_pavadinimas+di], bh
inc OPK_pavadinimo_ilgis
inc di
inc si
jmp pav
fo:
; inc di
mov [op_pavadinimas+di], '$'
inc si
mov bl, [OPK+si]
mov komandos_nr, bl
ret
kokia_komanda endp
;------------------------------------------
baito_isvalymas proc
mov cx, 0008h
clearloop:
mov byte ptr ds:[di], 0
inc di
loop clearloop
ret
baito_isvalymas endp
;------------------------------------------------------------------
;baito konvertavimas i bitus
;-------------------------------------------------------------------
baitas_i_bitus proc
; mov bitas_d,0
; mov bitas_w,0
mov di, offset bitai
call baito_isvalymas
mov di, offset bitai
mov bl, 02h
add di, 8      ;;; pasiuret cia atidziau
mov al, komanda
; mov mano_si,0
divloop:
; inc mano_si
xor ah, ah
div bl
dec di
; add ah, 30h
mov byte ptr ds:[di], ah
; cmp mano_si, 1
; je wbitas
; cmp mano_si, 2
; je dbitas
; tikrinimas:
cmp al, 0
jne divloop
ret
baitas_i_bitus endp

; wbitas:
; mov bitas_w, ah
; jmp tikrinimas
; dbitas:
; mov bitas_d, ah
; jmp tikrinimas
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
mov dl, s_ES
mov prefikso_seg, dl
jmp skait
cs_seg:
mov dl, s_CS
mov prefikso_seg, dl
jmp skait
ss_seg:
mov dl, s_SS
mov prefikso_seg, dl
jmp skait
ds_seg:
mov dl, s_DS
mov prefikso_seg, dl
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
mov ah, 3Ch                    ;sukuriamas failas
xor cx,cx
mov dx, offset rez
int 21h
jc RezSukurimoKlaida        ;jei kuriant faila meta errora
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
mov al, 00                    ;failas atidaromas skaitymui
mov dx, offset duom
int 21h
jc DuomAtidarymoKlaida        ;jei atidarant faila skaitymui ivyko klaida, CF=1
mov duom_deskriptorius, ax                ;issaugau duom failo dekriptoriaus nr
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
cmp al, 13d                ;jei nieko neivede tai klaida1
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
inc si                        ;duomenu pabaiga
mov dx, '$'
mov [duom+si], dl
xor si,si
mov al, es:[bx]                ;jeigu po duom failo parasymo yra enteris, vadinasi nera rez failo pavadinimo
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

