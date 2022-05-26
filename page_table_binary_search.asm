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


; 名称：page_table_binary_search
; 功能：在页表中执行binary search
; 要求：页号在页表中按升序排列，例如page[0] = pagetable[0] , page[1] = pagetable[1]
;		页表中每一项的结构为 [page number] [page address]，其中page number 和 page address都为dword
;		也就是说，在页表中一对page number 和 page address为数组的一个元素
; 参数： pPage_table:ptr dword
;		page_number:dword
;		talbe_size:dword
; 返回：EAX = page_number 对应页的物理地址
				
				pPage_table				equ		[ebp+8]			;参数，页表指针
				page_number				equ		[ebp+12]		;参数，页号
				talbe_size				equ		[ebp+16]		;参数，页表元素个数
				table_number_size		equ		8				;常量，页表元素大小
page_table_binary_search proc

				push        ebp                                 
                mov         ebp,esp

				mov			eax,table_size				;table_size / 2
				xor			edx,edx
				div			2

				mul			table_number_size			;计算页表元素下标

				lea			edi,pPage_table
				add			edi,eax						;页表元素定位

				cmp			page_number,dword ptr[edi]
				je			find_ok						;找到页号
				ja			Greater

find_ok:
				mov			eax,dword ptr[edi+4]		;返回页的物理地址

				mov			esp,ebp
				pop			ebp
				ret			4						
page_table_binary_search endp
end 