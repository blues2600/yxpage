;include		Irvine32.inc

;.data

;new_process		process_table	<>

;.code

; 名称：	create_process 
; 功能：	新建一个进程
; 要求： 仅支持x86 32bit 处理器
; 参数：	pid:ptr dword
; 返回：	
				

;create_process proc
;				pid	equ		[ebp+8]					;参数，pid指针，pid可以看做是一个全局变量

				;get a new pid
;				mov		eax,pid
;				mov		esi,[eax]			
;				inc		esi								;esi = new pid
;				mov		[eax],esi						;更新pid的值

				;初始化进程控制块
;				mov		new_process.pid,esi				
;				mov		new_process.priority,1			;进程优先级
;				mov		
				;太难了，写不下去了，干
;				ret		4
;create_process endp
end 