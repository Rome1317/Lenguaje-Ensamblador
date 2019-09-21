ExitProcess Proto
.data ;variables

variable dw 11

.code
main proc ;procedimiento

xor rax, rax ;limpia los registros
xor rbx, rbx
xor rcx, rcx
xor rdx, rdx

mov ax, 10
mov bx, 11

mov cx,ax
mov dx,bx

lea rsi, variable ;cambia la direccio de rsi
mov[rsi], ax ;asigna el valor de ax a la direccion

inc ax ;aumenta en 1 la direccion
dec ax ;disminuye en 1 la direccion

inc dword ptr [rsi] ;aumenta el valor

nop ;no operation

call ExitProcess
main endp
end
