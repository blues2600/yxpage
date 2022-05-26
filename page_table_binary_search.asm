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


; ���ƣ�page_table_binary_search
; ���ܣ���ҳ����ִ��binary search
; Ҫ��ҳ����ҳ���а��������У�����page[0] = pagetable[0] , page[1] = pagetable[1]
;		ҳ����ÿһ��ĽṹΪ [page number] [page address]������page number �� page address��Ϊdword
;		Ҳ����˵����ҳ����һ��page number �� page addressΪ�����һ��Ԫ��
; ������ pPage_table:ptr dword
;		page_number:dword
;		talbe_size:dword
; ���أ�EAX = page_number ��Ӧҳ�������ַ
				
				pPage_table				equ		[ebp+8]			;������ҳ��ָ��
				page_number				equ		[ebp+12]		;������ҳ��
				talbe_size				equ		[ebp+16]		;������ҳ��Ԫ�ظ���
				table_number_size		equ		8				;������ҳ��Ԫ�ش�С
page_table_binary_search proc

				push        ebp                                 
                mov         ebp,esp

				mov			eax,table_size				;table_size / 2
				xor			edx,edx
				div			2

				mul			table_number_size			;����ҳ��Ԫ���±�

				lea			edi,pPage_table
				add			edi,eax						;ҳ��Ԫ�ض�λ

				cmp			page_number,dword ptr[edi]
				je			find_ok						;�ҵ�ҳ��
				ja			Greater

find_ok:
				mov			eax,dword ptr[edi+4]		;����ҳ�������ַ

				mov			esp,ebp
				pop			ebp
				ret			4						
page_table_binary_search endp
end 