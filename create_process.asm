;include		Irvine32.inc

;.data

;new_process		process_table	<>

;.code

; ���ƣ�	create_process 
; ���ܣ�	�½�һ������
; Ҫ�� ��֧��x86 32bit ������
; ������	pid:ptr dword
; ���أ�	
				

;create_process proc
;				pid	equ		[ebp+8]					;������pidָ�룬pid���Կ�����һ��ȫ�ֱ���

				;get a new pid
;				mov		eax,pid
;				mov		esi,[eax]			
;				inc		esi								;esi = new pid
;				mov		[eax],esi						;����pid��ֵ

				;��ʼ�����̿��ƿ�
;				mov		new_process.pid,esi				
;				mov		new_process.priority,1			;�������ȼ�
;				mov		
				;̫���ˣ�д����ȥ�ˣ���
;				ret		4
;create_process endp
end 