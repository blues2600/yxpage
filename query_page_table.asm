
.686P		
.MODEL flat, stdcall
.STACK 4096

.data
.code

; ���ƣ�	query_page_table 
; ���ܣ�	��ҳ���в�ѯҳ�ţ�����ҳ�������ַ
; Ҫ��	ҳ����ҳ���а��������У�����page[0] = pagetable[0] , page[1] = pagetable[1]
;		ҳ����ÿһ��ĽṹΪ [page number] [page address]������page number �� page address��Ϊdword
;		Ҳ����˵����ҳ����һ��page number �� page addressΪ�����һ��Ԫ�أ�һ��ҳ���
; ������ pPage_table:ptr dword
;		page_number:dword
;		number_size:dword
; ���أ�	EAX = ҳ��������ַ(��20λ)
				

query_page_table proc
				pPage_table		equ		[ebp+8]			;������ҳ��ָ��
				page_number		equ		[ebp+12]		;������ҳ��
				mumber_size		equ		[ebp+16]		;������ҳ�����С

				push        ebp                                 
                mov         ebp,esp
				push		esi							;����esi edi
				push		edi

				lea			esi,pPage_table				;����ҳ��
				mov			edi,[esi]
				mov			eax,page_number				;ҳ����ҳ���е��±�			

				mul			dword ptr mumber_size		;�±�*Ԫ�ش�С				

				add			edi,eax						;ҳ���ַ+Ԫ��ƫ��=ҳ�����ַ
				mov			eax,dword ptr [edi+4]		;ҳ�������ַ	
				shl			eax,12						;ҳ�������ַ�ƶ�����20λ����12λ��0

				pop			edi
				pop			esi
				mov			esp,ebp
				pop			ebp
				ret			12							;�������			
query_page_table endp
end 