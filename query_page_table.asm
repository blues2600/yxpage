
.686P		
.MODEL flat, stdcall
.STACK 4096

.data
.code

; 名称：	query_page_table 
; 功能：	从页表中查询页号，返回页的物理地址
; 要求：	页号在页表中按升序排列，例如page[0] = pagetable[0] , page[1] = pagetable[1]
;		页表中每一项的结构为 [page number] [page address]，其中page number 和 page address都为dword
;		也就是说，在页表中一对page number 和 page address为数组的一个元素（一个页表项）
; 参数： pPage_table:ptr dword
;		page_number:dword
;		number_size:dword
; 返回：	EAX = 页框的物理地址(高20位)
				

query_page_table proc
				pPage_table		equ		[ebp+8]			;参数，页表指针
				page_number		equ		[ebp+12]		;参数，页号
				mumber_size		equ		[ebp+16]		;参数，页表项大小

				push        ebp                                 
                mov         ebp,esp
				push		esi							;保存esi edi
				push		edi

				lea			esi,pPage_table				;加载页表
				mov			edi,[esi]
				mov			eax,page_number				;页号在页表中的下标			

				mul			dword ptr mumber_size		;下标*元素大小				

				add			edi,eax						;页表地址+元素偏移=页表项地址
				mov			eax,dword ptr [edi+4]		;页的物理地址	
				shl			eax,12						;页的物理地址移动到高20位，低12位置0

				pop			edi
				pop			esi
				mov			esp,ebp
				pop			ebp
				ret			12							;清除参数			
query_page_table endp
end 