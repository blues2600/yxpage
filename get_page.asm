;
;
;
;	��������������������ʱ���ϣ�������������
;

.386
.model		flat,stdcall
.stack		1024  

include		Irvine32.inc

.data

.code


; ���ƣ�get_page_number 
; ���ܣ��������ַ�л�ȡҳ��(20λ)
; ������ VA:dword
; ���أ�EAX = ҳ��
				
				VA			equ		[ebp+8]			;�����������ַ
get_page_number proc

				push        ebp                                 
                mov         ebp,esp

				mov			eax,VA
				shr			eax,20					;���ҳ��

				mov			esp,ebp
				pop			ebp
				ret			4						
get_page_number endp
end 