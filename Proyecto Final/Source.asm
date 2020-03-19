;Programa hecho por Rafael Rosas para la impresionante
;carrera de multimedia y animacion digital de la FCFM
;simplemente amazing, esto es de clase mundial!!!!!!!!

.686p
.model flat, stdcall
.stack 4096

include Protos.inc
include Equs.inc
include Estructuras.inc

Suma macro N1, N2, Temp
	push eax
	push ebx
	mov eax, N1
	mov ebx, N2
	add eax, ebx
	mov Temp, eax
	pop eax
	pop ebx
endm 

;Imgenes
IDB_BITMAP10 equ 112 ;fondo
IDB_BITMAP11 equ 113 ;Yoshi
IDB_BITMAP12 equ 114 ;Yoshi_black
IDB_BITMAP13 equ 118 ;fondo2
IDB_BITMAP14 equ 119 ;fondo3
IDB_BITMAP15 equ 120 ;Big Yoshi
IDB_BITMAP16 equ 121 ;Big Yoshi_black
IDB_BITMAP17 equ 122 ;Fossil 
IDB_BITMAP18 equ 123 ;Life_black
IDB_BITMAP19 equ 124 ;Life
IDB_BITMAP20 equ 125 ;Gamepad
IDB_BITMAP21 equ 126 ;Keyboard
IDB_BITMAP22 equ 128 ;Gameover
IDB_BITMAP23 equ 129 ;Asteroid
IDB_BITMAP24 equ 130 ;Asteroid_black
IDB_BITMAP25 equ 131 ;Bomb
IDB_BITMAP28 equ 132 ;Bomb_black
IDB_BITMAP26 equ 133 ;Smash
IDB_BITMAP27 equ 134 ;Smash_black
IDB_BITMAP29 equ 135 ;Victory

Collision proto stdcall :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD, :DWORD

.data

;Variables
indice		dword	0
indiceslow	dword   0 ;velocidad del sprite
indicejump  dword	0 ;secuencia de salto
indiceA		dword	0 
indiceA2	dword	0
indiceA3	dword	0
indiceA4	dword	0
indiceA5	dword	0
indiceA6	dword	0
indiceA7	dword	0
indiceA8	dword	0
indiceB		dword	0
indiceB2	dword	0
indiceB3	dword	0
life		dword	3 
counter		dword	0
distance	dword	0
score		dword	0
temp		dword	0
temp2		dword	0
Time		byte	0

;Bitmaps
hInstanc	dword	?
hwnd        dword	?
hBitmap		dword	? ;Bg
hYoshi  	dword	? 
hYoshi2 	dword	? 
hBitmap4	dword	? ;Menu
hLife    	dword	? 
hLife2  	dword	?
hBitmap7	dword	? ;gamepad
hBitmap8	dword	? ;keyboard
hBitmap9	dword	? ;gameover
hBitmap10	dword	? ;victory
hAsteroid   dword   ?
hAsteroid2  dword   ?
hBomb		dword	?
hBomb2		dword	?
hSmash		dword	?
hSmash2		dword	?
hMemDC		dword	?

;Banderas
scene		byte	0
gamepad		byte    0
keyboard	byte    0
gameover    byte    0
limit		byte    0
jump		byte    0 ; salta
duck		byte    0 ; agacharse
walk		byte	0 ; camina
flag_smash  byte	0 ; colision
flag_boom	byte	0 ; explosion
good_egg    byte	0 ; huevo bueno o malo
explode		byte	0 ; Bomba -2
retry		byte	0 ; Reintento
win			byte	0 ; Victory

;Asteroid datos 
pos_A1	dword	0
flag_A1	byte	0
TimerA1 dword	0

pos_A2	dword	0
flag_A2	byte	0
TimerA2 dword	0

pos_A3	dword	0
flag_A3	byte	0
TimerA3 dword	0

pos_A4	dword	0
flag_A4	byte	0
TimerA4 dword	0

pos_A5	dword	0
flag_A5	byte	0
TimerA5 dword	0

pos_A6	dword	0
flag_A6	byte	0
TimerA6 dword	0

pos_A7	dword	0
flag_A7	byte	0
TimerA7 dword	0

pos_A8	dword	0
flag_A8	byte	0
TimerA8 dword	0

;Bomb
pos_B1	dword	625
flag_B1	byte	0
TimerB1	dword	0

pos_B2	dword	530
flag_B2 byte	0
TimerB2	dword	0

pos_B3	dword   130
flag_B3 byte	0
TimerB3 dword	0

;Eggs
posX_E1  dword   613
posY_E1  dword	 285
flag_E1  byte    1
TimerE1  dword	 0
move_E1  dword	 0

posX_E2  dword   400
posY_E2  dword	 330
flag_E2  byte    0
move_E2  dword	 0

posX_E3  dword   50
posY_E3  dword	 270
flag_E3  byte    0
TimerE3  dword	 0
move_E3  dword	 0

posX_E4  dword   140
posY_E4  dword	 300
flag_E4  byte    0
move_E4  dword	 0

posX_E5  dword   500
posY_E5  dword	 330
flag_E5  byte    0
move_E5  dword	 0

;boom
indiceBOOM	dword	0
TBOOM       dword   0


ClassName db "Clase_Simple",0
AppName db "Fossil",0
FontName db "script",0
Song	db	'MarioWorld.wav', 0

;estos datos corresponden a la fraccion del bitmap que tiene la secuencia de la animacion
;explosion.bmp, cada secuencia 

sprites		POINT		<0,304>, <72,304>, <136,304>, <200,304>, <266,304>, <326, 304>
bend		POINT		<1060,0>, <855,0>, <920,0>, <978,0>
hop			POINT		<0,100>, <70,100>, <130,100>, <950,102>, <1030,100>
asteroid	POINT		<920,120>, <920,220>, <920,630>, <920,760>
bomb		POINT		<613,840>, <574,840>, <537,840>, <498,840>, <461,840>, <424,840>
boom		POINT		<9,75>, <9, 127>, <9, 186>, <9,240>

entrada XINPUT_STATE <>

posX	DWORD	0
posY	DWORD	0
dibuja  byte    0

.code
main proc	
	
	invoke GetModuleHandleA, NULL             
    mov hInstanc,eax                      
	invoke WinMain, hInstanc,NULL,NULL, SW_SHOWDEFAULT
	call ExitProcess@4

main endp

WinMain proc hInst:dword,hPrevInst:dword,CmdLine:dword,CmdShow:DWORD
	LOCAL wc:WNDCLASSEX
	LOCAL msge:MSG 

	mov   wc.cbSize,SIZEOF WNDCLASSEX                    
    mov   wc.style, CS_HREDRAW or CS_VREDRAW 
    mov   wc.lpfnWndProc, OFFSET WndProc 
    mov   wc.cbClsExtra,NULL 
    mov   wc.cbWndExtra,NULL 
    push  hInstanc 
    pop   wc.hInstance 
    mov   wc.hbrBackground,COLOR_WINDOW + 1 
    mov   wc.lpszMenuName,NULL 
    mov   wc.lpszClassName,OFFSET ClassName 
    invoke LoadIconA,NULL,IDI_APPLICATION 
    mov   wc.hIcon,eax 
    mov   wc.hIconSm,eax 
    invoke LoadCursorA,NULL,IDC_ARROW 
    mov   wc.hCursor,eax 

	invoke RegisterClassExA, addr wc                       
    invoke CreateWindowExA,NULL, 
                ADDR ClassName,
                ADDR AppName, 
                WS_OVERLAPPEDWINDOW, 
                300,
                50,
                700, 
                470, 
                NULL, 
                NULL, 
                hInst, 
                NULL 
    mov   hwnd,eax 
    invoke ShowWindow, hwnd,CmdShow                
    invoke UpdateWindow, hwnd  
	
	;estoy creando el timer, asociado a la ventana por el handler hwnd
	;el primer 200 es el identificador o "nombre" del timer, el segundo 40
	;es la duracion en milisegundos del timer, NULL es que no hay TIMEPROC
	                   
	invoke SetTimer, hwnd, 200, 40, NULL
	invoke SetTimer, hwnd, 101, 8700, NULL

    .WHILE TRUE                                   
                invoke GetMessageA, ADDR msge,NULL,0,0 
                .BREAK .IF (!eax) 
                invoke TranslateMessage, ADDR msge 
                invoke DispatchMessageA, ADDR msge 
   .ENDW 
    mov     eax,msge.wParam                                            ;
	ret 
WinMain endp

WndProc proc hWnd2:dword, uMsg:dword, wParam:dword, lParam:dword

	LOCAL hdc:dword
    LOCAL ps:PAINTSTRUCT 
    LOCAL hfont:dword
	LOCAL rectan:RECT 
	LOCAL estado:DWORD
	

	.IF uMsg==WM_DESTROY   

	    invoke KillTimer, hwnd, 200   
		invoke DeleteObject,hBitmap                      
        invoke PostQuitMessage,NULL 

	.ELSEIF uMsg==WM_CREATE 

	    ;song
		push edx
		mov edx, 0001h
		or edx, 008h
		or edx, 20000h
		invoke Playsound, addr song, 0, edx
		pop edx

	    ;Carga
		invoke LoadBitmapA,hInstanc,IDB_BITMAP27;Smash_black
		mov hSmash,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP26 ;Smash
		mov hSmash2,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP28 ;Bomb_black
		mov hBomb,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP25 ;Bomb
		mov hBomb2,eax 
		invoke LoadBitmapA,hInstanc,IDB_BITMAP13 ;Fondo
		mov hBitmap,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP16 ;Yoshi_black
		mov hYoshi,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP15 ;Yoshi
		mov hYoshi2,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP17 ;Menu
		mov hBitmap4,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP18 ;Life_black
		mov hLife,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP19 ;Life
		mov hLife2,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP20 ;Gamepad
		mov hBitmap7,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP21 ;Keyboard
		mov hBitmap8,eax
		invoke LoadBitmapA,hInstanc,IDB_BITMAP22 ;Gameover
		mov hBitmap9,eax
		invoke LoadBitmapA,hInstanc,IDB_BITMAP24 ;Asteroid_black
		mov hAsteroid,eax  
		invoke LoadBitmapA,hInstanc,IDB_BITMAP23 ;Asteroid
		mov hAsteroid2,eax   
		invoke LoadBitmapA,hInstanc,IDB_BITMAP29 ;Asteroid
		mov hBitmap10,eax   

		mov posX, 5
		mov posY, 330

	.ELSEIF uMsg==WM_PAINT 

	    ;el begin paint siempre va cuando se imprime lo que sea en pantalla
        invoke BeginPaint,hWnd, ADDR ps 
        mov    hdc,eax 

		invoke CreateCompatibleDC,hdc 
		mov    hMemDC, eax 
	 
	.IF (scene == 0 )
	
		;aqui cargamos el menu
		invoke SelectObject,hMemDC,hBitmap4
		invoke GetClientRect,hWnd,addr rectan 		
		invoke BitBlt,hdc,0,0,rectan.right,rectan.bottom,hMemDC,0,15,SRCCOPY 

	.ELSEIF (scene == 1)
	        
			mov gameover, 0

			.IF retry == 1
				mov retry, 0
			    mov score, 0
				mov limit, 0
				mov explode, 0
				mov flag_A6, 0
				mov flag_A7, 0
				mov TIME,0

				mov posX, 5
				mov posY, 330
				mov win, 0
				mov life, 3
			.ENDIF

		    .IF (gamepad == 1)

			;aqui cargamos los controles
			mov gamepad,0
			mov good_egg, 1
			invoke SelectObject,hMemDC,hBitmap7
			invoke GetClientRect,hWnd,addr rectan 		
			invoke BitBlt,hdc,0,0,rectan.right,rectan.bottom,hMemDC,0,0,SRCCOPY 

	       .ELSEIF (keyboard == 1)

			;aqui cargamos los controles
			mov keyboard,0
			invoke SelectObject,hMemDC,hBitmap8
			invoke GetClientRect,hWnd,addr rectan 		
			invoke BitBlt,hdc,0,0,rectan.right,rectan.bottom,hMemDC,0,0,SRCCOPY 

		   .ENDIF

	.ELSEIF (scene == 2 )
		
		.IF (gameover == 0)


	    .IF (limit == 0)
		;aqui cargamos el fondo
		invoke SelectObject,hMemDC,hBitmap
		invoke GetClientRect,hWnd,addr rectan 		
		invoke BitBlt,hdc,0,0,rectan.right,rectan.bottom,hMemDC,0,0,SRCCOPY 


		.ELSEIF (limit == 1)

	    ;aqui cargamos el movimiento del fondo
		invoke SelectObject,hMemDC,hBitmap
		invoke GetClientRect,hWnd,addr rectan 		
		invoke BitBlt,hdc,0,0,rectan.right,rectan.bottom,hMemDC,657,0,SRCCOPY 


		.ENDIF

		;life
		xor ebx, ebx
		mov ebx, life
		mov ecx, life
		.WHILE counter != ebx
			invoke SelectObject,hMemDC,hLife	
			invoke BitBlt,hdc,distance,0,35,35,hMemDC,0,0,SRCAND 

			invoke SelectObject,hMemDC,hLife2
			invoke BitBlt,hdc,distance,0,35,35,hMemDC,0,0,SRCPAINT

			add distance, 30
			inc counter
		.ENDW
		mov counter, 0
		mov distance,0

		;asteroids
		.IF flag_A1 == 1
			mov esi, indiceA
			shl esi, 3

			invoke SelectObject,hMemDC,hAsteroid2
		    invoke BitBlt,hdc,70,pos_A1,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCAND

			invoke SelectObject,hMemDC,hAsteroid
			invoke BitBlt,hdc,70,pos_A1,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCPAINT

		.ENDIF

		.IF flag_A2 == 1
			mov esi, indiceA2
			shl esi, 3

			invoke SelectObject,hMemDC,hAsteroid2
		    invoke BitBlt,hdc,170,pos_A2,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCAND

			invoke SelectObject,hMemDC,hAsteroid
			invoke BitBlt,hdc,170,pos_A2,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCPAINT

		.ENDIF

		.IF flag_A3 == 1
			mov esi, indiceA3
			shl esi, 3

			invoke SelectObject,hMemDC,hAsteroid2
		    invoke BitBlt,hdc,240,pos_A3,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCAND

			invoke SelectObject,hMemDC,hAsteroid
			invoke BitBlt,hdc,240,pos_A3,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCPAINT

		.ENDIF

		.IF flag_A4 == 1
			mov esi, indiceA4
			shl esi, 3

			invoke SelectObject,hMemDC,hAsteroid2
		    invoke BitBlt,hdc,310,pos_A4,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCAND

			invoke SelectObject,hMemDC,hAsteroid
			invoke BitBlt,hdc,310,pos_A4,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCPAINT

		.ENDIF

		.IF flag_A5 == 1
			mov esi, indiceA5
			shl esi, 3

			invoke SelectObject,hMemDC,hAsteroid2
		    invoke BitBlt,hdc,520,pos_A5,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCAND

			invoke SelectObject,hMemDC,hAsteroid
			invoke BitBlt,hdc,520,pos_A5,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCPAINT

		.ENDIF

	    .IF flag_A6 == 1
			mov esi, indiceA6
			shl esi, 3

			invoke SelectObject,hMemDC,hAsteroid2
		    invoke BitBlt,hdc,470,pos_A6,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCAND

			invoke SelectObject,hMemDC,hAsteroid
			invoke BitBlt,hdc,470,pos_A6,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCPAINT

		.ENDIF

		.IF flag_A7 == 1
			mov esi, indiceA7
			shl esi, 3

			invoke SelectObject,hMemDC,hAsteroid2
		    invoke BitBlt,hdc,350,pos_A7,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCAND

			invoke SelectObject,hMemDC,hAsteroid
			invoke BitBlt,hdc,350,pos_A7,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCPAINT

		.ENDIF

		.IF flag_A8 == 1
			mov esi, indiceA8
			shl esi, 3

			invoke SelectObject,hMemDC,hAsteroid2
		    invoke BitBlt,hdc,400,pos_A8,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCAND

			invoke SelectObject,hMemDC,hAsteroid
			invoke BitBlt,hdc,400,pos_A8,70,70,hMemDC,asteroid[esi].x,asteroid[esi].y,SRCPAINT

		.ENDIF


		;bombs
		.IF flag_B1 == 1
			mov esi, indiceB
			shl esi, 3

			invoke SelectObject,hMemDC,hBomb2
		    invoke BitBlt,hdc,pos_B1,330,39,55,hMemDC,bomb[esi].x,bomb[esi].y,SRCAND 

			invoke SelectObject,hMemDC,hBomb
			invoke BitBlt,hdc,pos_B1,330,39,55,hMemDC,bomb[esi].x,bomb[esi].y,SRCPAINT

		.ENDIF

		.IF flag_B2 == 1
			mov esi, indiceB2
			shl esi, 3

			invoke SelectObject,hMemDC,hBomb2
		    invoke BitBlt,hdc,pos_B2,285,39,55,hMemDC,bomb[esi].x,bomb[esi].y,SRCAND 

			invoke SelectObject,hMemDC,hBomb
			invoke BitBlt,hdc,pos_B2,285,39,55,hMemDC,bomb[esi].x,bomb[esi].y,SRCPAINT

		.ENDIF

		.IF flag_B3 == 1
			mov esi, indiceB3
			shl esi, 3

			invoke SelectObject,hMemDC,hBomb2
		    invoke BitBlt,hdc,pos_B3,265,39,55,hMemDC,bomb[esi].x,bomb[esi].y,SRCAND 

			invoke SelectObject,hMemDC,hBomb
			invoke BitBlt,hdc,pos_B3,265,39,55,hMemDC,bomb[esi].x,bomb[esi].y,SRCPAINT

		.ENDIF

		;eggs
		.IF flag_E1 == 1
		    invoke SelectObject,hMemDC,hLife	
			invoke BitBlt,hdc,posX_E1,posY_E1,35,35,hMemDC,0,0,SRCAND 

			invoke SelectObject,hMemDC,hLife2
			invoke BitBlt,hdc,posX_E1,posY_E1,35,35,hMemDC,0,0,SRCPAINT
		.ENDIF

		.IF flag_E2 == 1
		    invoke SelectObject,hMemDC,hLife	
			invoke BitBlt,hdc,posX_E2,posY_E2,35,35,hMemDC,0,0,SRCAND 

			invoke SelectObject,hMemDC,hLife2
			invoke BitBlt,hdc,posX_E2,posY_E2,35,35,hMemDC,0,0,SRCPAINT
		.ENDIF

		.IF flag_E3 == 1
		    invoke SelectObject,hMemDC,hLife	
			invoke BitBlt,hdc,posX_E3,posY_E3,35,35,hMemDC,0,0,SRCAND 

			invoke SelectObject,hMemDC,hLife2
			invoke BitBlt,hdc,posX_E3,posY_E3,35,35,hMemDC,0,0,SRCPAINT
		.ENDIF

		.IF flag_E4 == 1
		    invoke SelectObject,hMemDC,hLife	
			invoke BitBlt,hdc,posX_E4,posY_E4,35,35,hMemDC,0,0,SRCAND 

			invoke SelectObject,hMemDC,hLife2
			invoke BitBlt,hdc,posX_E4,posY_E4,35,35,hMemDC,0,0,SRCPAINT
		.ENDIF

		.IF flag_E5 == 1
		    invoke SelectObject,hMemDC,hLife	
			invoke BitBlt,hdc,posX_E5,posY_E5,35,35,hMemDC,0,0,SRCAND 

			invoke SelectObject,hMemDC,hLife2
			invoke BitBlt,hdc,posX_E5,posY_E5,35,35,hMemDC,0,0,SRCPAINT
		.ENDIF

		;Colision ASTEROID 1
		.IF Flag_A1 == 1
        invoke Collision, posX, posY, 45, 70, 70, pos_A1, 50, 70
				.IF flag_smash == 1
					mov pos_A1, 0
				    mov flag_boom, 1
					.IF life > 0
						dec life
					.ELSE
						mov gameover,1
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision ASTEROID 6
		.IF flag_A6 == 1 && duck == 0
        invoke Collision, posX, posY, 45, 70, 470, pos_A6, 50, 70
				.IF flag_smash == 1
					mov pos_A6, 0
				    mov flag_boom, 1
					.IF life > 0
						dec life
					.ELSE
						mov gameover,1
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision ASTEROID 7
		.IF flag_A7 == 1 && duck == 0
        invoke Collision, posX, posY, 45, 70, 350, pos_A7, 50, 70
				.IF flag_smash == 1
					mov pos_A7, 0
				    mov flag_boom, 1
					.IF life > 0
						dec life
					.ELSE
						mov gameover,1
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision ASTEROID 2
		.IF FLAG_A2 == 1 && duck == 0
        invoke Collision, posX, posY, 45, 70, 170, pos_A2, 50, 70
				.IF flag_smash == 1
					mov pos_A2, 0
				    mov flag_boom, 1
					.IF life > 0
						dec life
					.ELSE
						mov gameover,1
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision ASTEROID 3
		.IF FLAG_A3 == 1
        invoke Collision, posX, posY, 45, 70, 240, pos_A3, 50, 70
				.IF flag_smash == 1
					mov pos_A3, 0
				    mov flag_boom, 1
					.IF life > 0
						dec life
					.ELSE
						mov gameover,1
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision ASTEROID 4
		.IF FLAG_A4 == 1
        invoke Collision, posX, posY, 45, 70, 310, pos_A4, 50, 70
				.IF flag_smash == 1
					mov pos_A4, 0
				    mov flag_boom, 1
					.IF life > 0
						dec life
					.ELSE
						mov gameover,1
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision ASTEROID 5
		.IF FLAG_A5 == 1
        invoke Collision, posX, posY, 45, 70, 530, pos_A5, 50, 70
				.IF flag_smash == 1
				    mov pos_A5, 0
				    mov flag_boom, 1
					.IF life > 0
						dec life
					.ELSE
						mov gameover,1
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision ASTEROID 8
		.IF FLAG_A8 == 1
        invoke Collision, posX, posY, 45, 70, 400, pos_A8, 50, 70
				.IF flag_smash == 1
					mov pos_A8, 0
				    mov flag_boom, 1
					.IF life > 0
						dec life
					.ELSE
						mov gameover,1
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision BOMB 1
		.iF flag_b1 == 1
        invoke Collision, posX, posY, 45, 70, pos_B1, 330, 39, 55
				.IF flag_smash == 1
				    mov pos_B1, 1000
					mov flag_boom, 1
					.IF life > 0
						dec life
					.ELSE
						mov gameover,1
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF


		;Colision BOMB 2
		.IF duck == 0 && flag_b2 == 1
		.IF posX != 550
        invoke Collision, posX, posY, 45, 70, pos_B2, 285, 39, 55
				.IF flag_smash == 1
     		        mov pos_B2, 1200
					mov explode, 1
					mov flag_boom, 1
					.IF life > 1
						Sub life, 2 
					.ELSE
						mov gameover,1
					.ENDIF
					
				.ENDIF
		        mov flag_smash, 0
		.ENDIF
		.ENDIF

		;Colision BOMB 3
		.IF FLAG_B3 == 1
        invoke Collision, posX, posY, 45, 70, pos_B3, 215, 39, 55
				.IF flag_smash == 1
				    mov pos_B3, 130
					mov flag_boom, 1
					.IF life > 1
						sub life, 2
					.ELSE
						mov gameover,1
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision EGG 1
		.IF FLAG_E1 == 1
        invoke Collision, posX, posY, 50, 70, posx_E1, posy_E1, 27, 27
				.IF flag_smash == 1
				    mov flag_e1, 0
					.IF move_e1 == 0
						.IF posx_E1 >= 100 
							sub posx_e1, 100
						.ELSE
							mov move_e1, 1
						.ENDIF
				    .ELSE
						.IF POSX_E1 <= 100 && posx_e1 < 625
							add posx_e1, 75
						.ELSE
							mov move_e1, 0
						.ENDIF
					.ENDIF
				    mov Flag_E2, 1

					.IF good_egg == 0
						    mov flag_boom,1
							.IF score > 20
								sub score, 20
							.ENDIF
					.ELSEIF life < 4
					    inc life
						add score, 50
					.ELSE 
						add score, 75
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision EGG 2
		.IF FLAG_E2 == 1
        invoke Collision, posX, posY, 45, 70, posx_E2, posy_E2, 27, 27
				.IF flag_smash == 1
				    mov flag_e2, 0
					.IF move_E2 == 0
				      .IF posx_E2 > 150
					   sub posx_e2, 150
					   .ElSE
					    mov move_E2, 1
					   .ENDIF
					.ELSE
						.if POSX_E2 <= 550
						add posx_e2, 80
						.else
						 mov move_e2, 0
					    .ENDIF
					.ENDIF
				    mov Flag_E3, 1

					.IF good_egg == 0
  						    mov flag_boom,1
							.IF score > 20
								sub score, 20
							.ENDIF
					.ELSEIF life < 4
					    inc life
						add score, 50
					.ELSE 
						add score, 75
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision EGG 3
	    .IF FLAG_E3 == 1
        invoke Collision, posX, posY, 45, 70, posx_E3, posy_E3, 27, 27
				.IF flag_smash == 1
				    mov flag_e3, 0
					.IF move_e3 == 0
				      .IF posx_E3 > 20
							sub posx_e3, 10
					   .else
							mov move_e3, 1
					   .endif
					.ELSE
						.if POSX_E2 < 600
						add posx_e3, 30
						.else
						mov move_e3, 0
					    .ENDIF
					.ENDIF
				    mov Flag_E4, 1

					.IF good_egg == 0
						    mov flag_boom,1
							.IF score > 20
								sub score, 20
							.ENDIF
					.ELSEIF life < 4
					    inc life
						add score, 50
					.ELSE 
						add score, 75
					.ENDIF
				.ENDIF
		 mov flag_smash, 0
		.ENDIF

		;Colision EGG 4
	    .IF FLAG_E4 == 1
        invoke Collision, posX, posY, 50, 70, posx_E4, posy_E4, 27, 27
				.IF flag_smash == 1
				    mov flag_e4, 0
					.if move_e4 == 0
						.IF posx_E4 > 60
						sub posx_e4, 50
						.else
						mov move_e4, 1
						.endif
					.ELSE
						.if POSX_E4 < 600
						add posx_e4, 15
						.else
						mov move_e4, 0
						.ENDIF
					.ENDIF
				    mov Flag_E5, 1

					.IF good_egg == 0
						    mov flag_boom,1
							.IF score > 20
								sub score, 20
							.ENDIF
					.ELSEIF life < 4
					    inc life
						add score, 50
					.ELSE 
						add score, 75
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Colision EGG 5
	    .IF FLAG_E5 == 1
        invoke Collision, posX, posY, 50, 70, posx_E5, posy_E5, 27, 27
				.IF flag_smash == 1
				    mov flag_e5, 0
					.if move_e5 == 0
						.IF posx_E5 > 70
						sub posx_e5, 80
						.else
						mov move_e5, 1
						.endif
					.ELSE
						.if POSX_E5 < 600
						add posx_e5, 35
						.else
						mov move_e5, 0
						.ENDIF
					.ENDIF
				    mov Flag_E1, 1

					.IF good_egg == 0
						    mov flag_boom,1
							.IF score > 20
								sub score, 20
							.ENDIF
					.ELSEIF life < 4
					    inc life
						add score, 50
					.ELSE 
						add score, 75
					.ENDIF
				.ENDIF
		mov flag_smash, 0
		.ENDIF

		;Yoshi moves
		.IF (duck == 1)

			.IF good_egg == 1
				mov good_egg, 0
			.ELSE
				mov good_egg, 1
			.ENDIF
		    
			mov posY, 315

			.IF (indice < 4)

				mov esi, indice
				shl esi, 3
		
				invoke SelectObject,hMemDC,hYoshi2				
				invoke BitBlt,hdc,posX,posY,55,77,hMemDC,bend[esi].x,bend[esi].y,SRCAND 

				invoke SelectObject,hMemDC,hYoshi 				
				invoke BitBlt,hdc,posX,posY,55,77,hMemDC,bend[esi].x,bend[esi].y,SRCPAINT

			.ELSEIF ( indice >= 4)

				mov esi, indice
				shl esi, 3
		
				invoke SelectObject,hMemDC,hYoshi2				
				invoke BitBlt,hdc,posX,posY,55,77,hMemDC,bend[24].x,bend[24].y,SRCAND 

				invoke SelectObject,hMemDC,hYoshi				
				invoke BitBlt,hdc,posX,posY,55,77,hMemDC,bend[24].x,bend[24].y,SRCPAINT

			.ENDIF

			.ELSEIF (jump == 1)

				.IF good_egg == 1
					mov good_egg, 0
				.ELSE
					mov good_egg, 1
				.ENDIF

				mov posY, 260

				mov esi, indicejump
				shl esi, 3


				invoke SelectObject,hMemDC,hYoshi2				
				invoke BitBlt,hdc,posX,posY,63,77,hMemDC,hop[esi].x,hop[esi].y,SRCAND 

				invoke SelectObject,hMemDC,hYoshi			
				invoke BitBlt,hdc,posX,posY,63,77,hMemDC,hop[esi].x,hop[esi].y,SRCPAINT	


			.ELSE
		   
				mov posY, 330

				mov esi, indice
				shl esi, 3
		
				invoke SelectObject,hMemDC,hYoshi2				
				invoke BitBlt,hdc,posX,posY,65,70,hMemDC,sprites[esi].x,sprites[esi].y,SRCAND 

				invoke SelectObject,hMemDC,hYoshi				
				invoke BitBlt,hdc,posX,posY,65,70,hMemDC,sprites[esi].x,sprites[esi].y,SRCPAINT


			.ENDIF

			;Smash
			.IF flag_boom == 1

				mov esi, indiceBOOM
				shl esi, 3

				invoke SelectObject,hMemDC,hSmash
				invoke BitBlt,hdc,posX,posY,50,50,hMemDC,Boom[esi].x,Boom[esi].y,SRCAND

				invoke SelectObject,hMemDC,hSmash2
				invoke BitBlt,hdc,posX,posY,50,50,hMemDC,Boom[esi].x,Boom[esi].y,SRCPAINT

			.ENDIF
		.ELSE
			
			.IF (win == 0)
			;aqui cargamos el gameover
			invoke SelectObject,hMemDC,hBitmap9
			invoke GetClientRect,hWnd,addr rectan 		
			invoke BitBlt,hdc,0,0,rectan.right,rectan.bottom,hMemDC,0,15,SRCCOPY 
			.ELSE
			;aqui cargamos win
			invoke SelectObject,hMemDC,hBitmap10
			invoke GetClientRect,hWnd,addr rectan 		
			invoke BitBlt,hdc,0,0,rectan.right,rectan.bottom,hMemDC,0,15,SRCCOPY 
			.ENDIF

	
		.ENDIF
	.ENDIF

		
	invoke DeleteDC,hMemDC 
		
	;el end paint cierra el proceso de dibujado 
    invoke EndPaint,hWnd, ADDR ps  
		
	;Se agrega el WM_TIMER a todo el proceso, aqui se atiende el movimiento del indice de
	;los sprites
	
	.ELSEIF  uMsg==WM_TIMER

	.if wParam == 101
	 .if TIME == 0
		 add score, 100
		 mov time, 1
	 .endif
	.endif

		.IF scene == 2 && limit == 0
		    mov flag_A2, 0
			mov flag_A3, 0
			mov flag_A4, 0
			mov flag_A5, 0
			mov flag_A8, 0
			mov flag_B3, 0

			inc TimerA1
			inc TimerB1
			inc TimerB2
	

			;asteroide 1
			.IF TimerA1 > 5
				;Posicion Asteroide
				add pos_A1, 10
				.IF pos_A1 > 330	
					mov flag_A1, 0
					mov pos_A1 , 0
					mov TimerA1, 0
				.ENDIF
				mov flag_A1, 1 ;Dibujar
				;Tiempo de cada dibujado de sprite de meteorito
				inc indiceA
				.IF indiceA > 3
					inc indiceA
					.IF indiceA > 2
						mov indiceA, 0
					.ENDIF
					mov indiceA, 0
				.ENDIF
			.ENDIF

			;bomba 1
			.IF TimerB1 > 10
				mov flag_B1, 1 ;dibujar
				;Mover la bomba
				sub pos_B1, 10
				.IF pos_B1 <= 5 
					mov pos_B1, 1000
					mov TimerB1, 0		
					mov flag_B1, 0
				.ENDIF
				;Tiempo de cada dibujado de sprite de bomba
				inc indiceB
				.IF indiceB > 3
					inc indiceB
					.IF indiceB > 1
						mov indiceB, 0
					.ENDIF
					mov indiceB, 0
				.ENDIF
			.ENDIF

			;bomba 2
			.IF explode == 0
			.IF TimerB2 > 30
				mov flag_B2, 1 ;dibujar
				;Mover la bomba
				sub pos_B2, 5
				.IF pos_B2 <= 300
					mov pos_B2, 530
					mov TimerB2, 0		
					mov flag_B2, 0
				.ENDIF
				;Tiempo de cada dibujado de sprite de bomba
				inc indiceB2
				.IF indiceB2 > 3
					inc indiceB2
					.IF indiceB2 > 1
						mov indiceB2, 0
					.ENDIF
					mov indiceB2, 0
				.ENDIF
			.ENDIF
			.ENDIF

			.IF explode == 1
				inc TimerA6
			.IF TimerA6 > 25
				mov flag_A6, 1 ;dibujar
				;Mover la bomba
				add pos_A6, 7
				.IF pos_A6 > 285
					mov flag_A6, 0
					mov pos_A6, 0
					mov TimerA6, 0		
				.ENDIF
				mov flag_A6, 1
				;Tiempo de cada dibujado de sprite de bomba
				inc indiceA6
				.IF indiceA6 > 3
					inc indiceA6
					.IF indiceA6 > 1
						mov indiceA6, 0
					.ENDIF
					mov indiceA6, 0
				.ENDIF
			.ENDIF
			.ENDIF

			.IF explode == 1
				inc TimerA7
			.IF TimerA7 > 15
				mov flag_A6, 1 ;dibujar
				;Mover la bomba
				add pos_A7, 7
				.IF pos_A7 > 285
					mov flag_A7, 0
					mov pos_A7, 0
					mov TimerA7, 0		
				.ENDIF
				mov flag_A7, 1
				;Tiempo de cada dibujado de sprite de bomba
				inc indiceA7
				.IF indiceA7 > 3
					inc indiceA7
					.IF indiceA7 > 1
						mov indiceA7, 0
					.ENDIF
					mov indiceA7, 0
				.ENDIF
			.ENDIF
			.ENDIF

		.ENDIF

		.IF limit == 1 && scene == 2
			mov flag_A1, 0
			mov flag_A6, 0
			mov flag_A7, 0
			mov flag_B1, 0
			mov flag_B2, 0

			inc TimerA2
			inc TimerA3
			inc TimerA4
			inc TimerA5
			inc TimerA8
			mov flag_B3, 1
			inc TimerB3

			;asteroide 2
			.IF TimerA2 > 5
				mov flag_A2, 1
				;Posicion Asteroide
				add pos_A2, 5
				.IF pos_A2 > 295	
					mov flag_A2, 0
					mov pos_A2 , 0
					mov TimerA2, 0
				.ENDIF
				mov flag_A2, 1 ;Dibujar
				;Tiempo de cada dibujado de sprite de meteorito
				inc indiceA2
				.IF indiceA2 > 3
					inc indiceA2
					.IF indiceA2 > 2
						mov indiceA2, 0
					.ENDIF
					mov indiceA2, 0
				.ENDIF
			.ENDIF

			.IF TimerA3 > 30
			    mov flag_A3, 1
				;Posicion Asteroide
				add pos_A3, 15
				.IF pos_A3 > 330	
					mov flag_A3, 0
					mov pos_A3 , 0
					mov TimerA3, 0
				.ENDIF
			mov flag_A3, 1 ;Dibujar
			;Tiempo de cada dibujado de sprite de meteorito
				inc indiceA3
				.IF indiceA3 > 3
					inc indiceA3
					.IF indiceA3 > 2
						mov indiceA3, 0
					.ENDIF
					mov indiceA3, 0
				.ENDIF
			.ENDIF

			.IF TimerA4 > 32
				mov flag_A4, 1
				;Posicion Asteroide
				add pos_A4, 10
				.IF pos_A4 > 330	
					mov flag_A4, 0
					mov pos_A4 , 0
					mov TimerA4, 0
				.ENDIF
				mov flag_A4, 1 ;Dibujar
				;Tiempo de cada dibujado de sprite de meteorito
				inc indiceA4
				.IF indiceA4 > 3
					inc indiceA4
					.IF indiceA4 > 2
						mov indiceA4, 0
					.ENDIF
					mov indiceA4, 0
				.ENDIF
			.ENDIF

			.IF TimerA5 > 3
				mov flag_A5, 1
				;Posicion Asteroide
				add pos_A5, 10
				.IF pos_A5 > 330	
					mov flag_A5, 0
					mov pos_A5 , 0
					mov TimerA5, 0
				.ENDIF
				mov flag_A5, 1 ;Dibujar
				;Tiempo de cada dibujado de sprite de meteorito
				inc indiceA5
				.IF indiceA5 > 3
					inc indiceA5
					.IF indiceA5 > 2
						mov indiceA5, 0
					.ENDIF
					mov indiceA5, 0
				.ENDIF
			.ENDIF

			.IF TimerA8 > 15
				mov flag_A8, 1
				;Posicion Asteroide
				add pos_A8, 15
				.IF pos_A8 > 330	
					mov flag_A8, 0
					mov pos_A8 , 0
					mov TimerA8, 0
				.ENDIF
				mov flag_A8, 1 ;Dibujar
				;Tiempo de cada dibujado de sprite de meteorito
				inc indiceA8
				.IF indiceA8 > 3
					inc indiceA8
					.IF indiceA8 > 2
						mov indiceA8, 0
					.ENDIF
					mov indiceA8, 0
				.ENDIF
			.ENDIF

			;bomba3
			.IF TimerB3 > 3
				mov flag_B3, 1 ;dibujar
				;Mover la bomba
				sub pos_B3, 3
				.IF pos_B3 <= 13
					mov pos_B3,  130
					mov TimerB3, 0		
					mov flag_B3, 0
				.ENDIF
				;Tiempo de cada dibujado de sprite de bomba
				inc indiceB3
				.IF indiceB3 > 3
					inc indiceB3
					.IF indiceB3 > 1
						mov indiceB3, 0
					.ENDIF
					mov indiceB3, 0
				.ENDIF
			.ENDIF


		.ENDIF


		.IF	( walk == 1)
			inc indiceslow
			.IF indiceslow > 3 ;Velocidad del dibujo del sprite
				inc indice
				.IF indice > 3
					mov indice, 0					
				.ENDIF

				mov indiceslow, 0
			.ENDIF
		.ENDIF

		.IF (jump == 1)
		   inc indiceslow
		   .IF indiceslow > 2
		   inc indicejump
		   .IF (indicejump > 4)
				mov indicejump, 0
				mov jump, 0
		   .ENDIF

		   mov indiceslow,0
		   .ENDIF
		.ENDIF

		.IF flag_boom == 1
			inc TBOOM
			.IF TBOOM > 1
				inc indiceBOOM
				.IF indiceBOOM > 2
					mov indiceBOOM, 0
					mov flag_boom, 0
				.ENDIF
				mov TBOOM,0
			.ENDIF
		.ENDIF

	    mov dibuja, 0h ; que limpie la bandera de redibujado
		invoke XInputGetState, 0, addr entrada
		mov estado, eax
		mov bl, entrada.Gamepad.bLeftTrigger


		;Right
		mov ax, entrada.Gamepad.wButtons
		test ax, XINPUT_GAMEPAD_DPAD_RIGHT
		jnz  right

		;Left
		test ax, XINPUT_GAMEPAD_DPAD_LEFT 
		jnz	left

		;Up
		test ax, XINPUT_GAMEPAD_DPAD_UP
		jnz up

		;Down
		test ax, XINPUT_GAMEPAD_DPAD_DOWN
		jnz down

		;Back
		test ax, XINPUT_GAMEPAD_BACK
		jnz back

		;Start
		test ax, XINPUT_GAMEPAD_START
		jnz	start
		jmp salta2

        right:

			mov jump, 0
			mov duck, 0
			mov walk, 1
			mov ebx, 5
			add posX, 5
			.IF posX > 625

				.IF (limit == 1)
					mov win, 1
					add score, 200
					mov gameover,1
					mov dibuja, 0ffh
					jmp salta2
				.ENDIF

				.IF (limit == 0)
					mov limit, 1
					mov posx, 0
					mov dibuja, 0ffh
					jmp salta2
				.ELSE

				sub posX, 5

				.ENDIF
			.ENDIF

			mov dibuja, 0ffh
			jmp salta2

        left:

			mov jump, 0
			mov duck, 0
			mov walk, 1
			mov ebx, 5
			sub posX, 5

			.IF (limit == 0)

				.IF posX < 5  ;es el limite de ventana internamente para que se mueva Ryu
					add posX, 5
				.ENDIF

			.ENDIF
	
			mov dibuja, 0ffh
			jmp salta2

      up:

	    mov walk, 0
		mov duck, 0
	    mov jump, 1
		mov dibuja, 0ffh	
		jmp salta2

     down:

		inc indice
		mov walk, 0
		mov jump, 0
		mov duck, 1
		mov dibuja, 0ffh	
		jmp salta2

     start:
		.IF (gameover == 1)
		   mov scene,1
		   mov gamepad,1
		   mov retry, 1
	    .ELSEIF (scene == 2 && gameover == 0)
		    mov scene,1
			mov gamepad,1
	    .ELSEIF (scene == 1)
			mov scene, 2
		.ELSEIF (scene == 0)
			mov scene,1
			mov gamepad,1
		.ENDIF

		mov dibuja, 0ffh
	    jmp salta2

	 back:
		invoke PostQuitMessage,NULL 
		
     salta2:			
		
		;con esto provocamos que se vuelva dibujar la ventana
		;esta sera la principal area de trabajo en su proyecto
		;.IF dibuja > 0
			invoke InvalidateRect, hWnd, NULL, FALSE
		;.ENDIF

	.ELSEIF uMsg == WM_KEYUP

		mov eax, wParam

		.IF (ax == 'D')

			mov walk,0

		.ENDIF

		.IF (ax == 'A')

			mov walk,0

		.ENDIF

		.IF (ax == 'S')

			.WHILE indice != 0
				dec indice
				invoke InvalidateRect, hWnd, NULL, FALSE
				invoke UpdateWindow, hWnd

			.ENDW
			mov duck,0

		.ENDIF

	.ELSEIF  uMsg==WM_KEYDOWN
		mov eax, wParam

		.IF (ax == 'D')

			mov walk,1
			mov ebx, 5
			add posX, 5


			.IF posX > 625  ;es el limite de ventana internamente para que se mueva Ryu

				.IF limit == 1
					mov win, 1
					add score, 200
					mov gameover, 1
				.ENDIF

				.IF limit == 0
					mov limit, 1
					mov posx, 0
					mov dibuja, 0ffh
					jmp salta2

				.ELSE
					sub posX, 5
				.ENDIF

			.ENDIF
			
			mov dibuja, 0ffh
			jmp salta2

		.ELSEIF (ax == 13) ; enter
			.IF (gameover == 1)
				mov scene,1
				mov keyboard,1
				mov retry, 1
			.ELSEIF (scene == 0 && gameover == 0)
				mov scene,1
			    mov keyboard,1
			.ELSEIF (scene == 1)
			    mov scene, 2
			.ENDIF
			mov dibuja, 0ffh
			jmp salta2
	   
	   .ELSEIF (ax == 27) ; esc
		    invoke PostQuitMessage,NULL 

	   ;.ELSEIF (ax == 32) ; SPACE
		    ;mov gameover,1
			;mov dibuja, 0ffh
		    ;jmp salta2
			
		.ELSEIF (ax == 'A')

			mov walk, 1
			mov ebx, 5
			sub posX, 5

			.IF (limit == 0)

				.IF posX < 3 ;es el limite de ventana internamente para que se mueva Ryu
					add posX, 5
				.ENDIF

			.ENDIF

			.IF (limit == 1)

				.IF posX < 3
					mov limit, 0
					mov posX, 625
					mov dibuja, 0ffh
					jmp salta2
				.ENDIF

			.ENDIF

			mov dibuja, 0ffh
			jmp salta2


		.ELSEIF (ax == 'W')
		    
			mov jump, 1
			mov dibuja, 0ffh	
			jmp salta2

		.ELSEIF (ax == 'S')

			inc indice
			mov duck, 1
			mov dibuja, 0ffh	
			jmp salta2

		.ENDIF
		
    .ELSE 
        invoke DefWindowProcA,hWnd2,uMsg,wParam,lParam      
        ret 
    .ENDIF
	
    xor eax,eax 
	ret 

WndProc endp

Collision proc p1x:DWORD, p1y:DWORD, ancho1:DWORD, alto1:DWORD, p2x:DWORD, p2y:DWORD, ancho2:DWORD, alto2:DWORD

	Suma p1x, ancho1, temp
	Suma p1y, alto1, temp2

	xor eax, eax
	xor ebx, ebx

	mov eax, p2x
	mov ebx, p2y


	.IF eax >= p1x && eax < temp && ebx >= p1y && ebx < temp2
		mov flag_smash, 1	
		ret
	.ENDIF

	Suma p2x, ancho2, temp
	Suma p2y, alto2, temp2

	xor eax, eax
	xor ebx, ebx

	mov eax, p1x
	mov ebx, p1y

	.IF eax >= p2x && eax < temp && ebx >= p2y && ebx < temp2
    	mov flag_smash, 1
		ret
	.ENDIF

	Suma p2x, ancho2, temp
	Suma p1y, alto1, temp2

	xor eax, eax
	xor ebx, ebx

	mov eax, p1x
	mov ebx, p2y

	.IF eax >= p2x && eax < temp && ebx >= p1y && ebx < temp2
		mov flag_smash, 1
		ret
	.ENDIF

	Suma p1x, ancho1, temp
	Suma p2y, alto2, temp2

	xor eax, eax
	xor ebx, ebx

	mov eax, p2x
	mov ebx, p1y

	.IF eax >= p1x && eax < temp && ebx >= p2y && ebx < temp2
		mov flag_smash, 1
		ret
	.ENDIF


	ret
Collision endp


end main

