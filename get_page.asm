;
;
;
;	！！！！！！！！！暂时作废！！！！！！！
;

.386
.model		flat,stdcall
.stack		1024  

include		Irvine32.inc

.data

.code


; 名称：get_page_number 
; 功能：从虚拟地址中获取页号(20位)
; 参数： VA:dword
; 返回：EAX = 页号
				
				VA			equ		[ebp+8]			;参数，虚拟地址
get_page_number proc

				push        ebp                                 
                mov         ebp,esp

				mov			eax,VA
				shr			eax,20					;获得页号

				mov			esp,ebp
				pop			ebp
				ret			4						
get_page_number endp
end 