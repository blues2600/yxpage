include		header.inc



.data
file_handle				dword		0								;�ļ����
file_size				dword		0								;�ļ���ʵ�ʴ�С���ֽ�
table_max_size			dword		1048574							;ҳ�����������
err_msg_pointer			dword		0								;������Ϣָ��
err_msg_failed			byte		"failed.",0
err_msg_pro_too_big		byte		"the program too big.",0

.code

;					** ҳ��˵�� **
;	
;		ҳ����ÿһ��ĽṹΪ [page number] [page address]������page number �� page address��Ϊdword
;		Ҳ����˵����ҳ����һ��page number �� page addressΪ�����һ��Ԫ�أ�һ��ҳ���
;		ҳ����ҳ���а��������У�����page[0] = pagetable[0] , page[1] = pagetable[1]
;
;		page address�ṹ:	λ31		ҳ�Ƿ����ڴ棬1Ϊture��0Ϊfalse
;							λ30		ҳ�������Ƿ��Ѿ����޸ģ�1Ϊture��0Ϊfalse
;							λ29~28  ҳ��Ȩ�ޣ��ֱ�Ϊ10�ɶ���01��д��11�ɶ��ҿ�д��00���ɶ�����д
;							λ27~20  ���ã���0
;							λ19~0	 ҳ��(page frame)�������ַ


; ���ƣ�	create_page_table 
; ���ܣ�	Ϊһ��exe���̴���ҳ����֧�ֲ���ϵͳ�ķ�ҳ����
; ˵����	�����ַ�ռ��0~0xFFFFFFFF
;		�����ַ��ҳ�򲿷ֻ�û��ʵ�֣���
; Ҫ��	������x86 32bit PE32����
; ������ file_name:ptr byte			;�ļ���
;		page_table:ptr dword		;ҳ��ָ��
; ���أ�	����ɹ�eax����1�����򷵻�0

create_page_table	proc
					file_name		equ		[ebp+8]			
					page_table		equ		[ebp+12]			

					push		ebp
					mov			ebp,esp
					push		edx
					push		ecx
					push		esi

					;���ļ�
					invoke		CreateFileA, file_name, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
					cmp			eax,INVALID_HANDLE_VALUE		
					jne			open_ok										;�ļ��򿪳ɹ�
					call		GetLastError								;��ʧ�ܣ���ȡ������
					invoke		FormatMessageA,FORMAT_MESSAGE_ALLOCATE_BUFFER+FORMAT_MESSAGE_FROM_SYSTEM, NULL, eax ,NULL, ADDR err_msg_pointer, NULL, NULL
					mov			edx,err_msg_pointer							;���������Ϣ
					call		WriteString
					mov			eax,0
					jmp			failed
open_ok:		
					mov			file_handle,eax

					;��ȡ�ļ���С
					invoke		GetFileSize, file_handle,addr file_size
					cmp			eax,0
					jnz			getFileSizeok								;�ɹ�����ļ���С
					call		Crlf										;����
					mov			edx,offset err_msg_failed					;��ȡ�ļ���Сʧ��
					call		WriteString
					mov			eax,0
					jmp			failed
getFileSizeok:

					;�����ļ���С
					mov			eax,file_size								
					cmp			eax,0FFFFFFFEh								;�������Ƿ񳬹�4GB
					jbe			file_size_ok
					call		Crlf										;����
					mov			edx,offset err_msg_pro_too_big				;�����С����4GB
					call		WriteString
					mov			eax,0
					jmp			failed
file_size_ok:

					;��ʼ��ҳ���ҳ�ţ���ҳ�����е�page number���֣��ӵ�0ҳ~2��20�η�-1ҳ������1048575ҳ��
					mov			esi,page_table								;����ҳ��ָ��
					add			esi,8										;��0ҳ��ҳ�Ų���Ҫ��ʼ��
					mov			eax,1										;ҳ��
					mov			ecx,table_max_size							;ѭ��������
initialize_page_number:				
					mov			[esi],eax									;��ʼ��ҳ��
					inc			eax											;ҳ������
					add			esi,8										;ָ����һ��ҳ����
					loop		initialize_page_number

					;��ʼ��ҳ���ҳ���ַ���������ԣ���ҳ�����е�page address���֣��ӵ�0ҳ~2��20�η�-1ҳ������1048575ҳ��
					mov			esi,page_table								;����ҳ��ָ��
					add			esi,4										;ָ���0ҳ��page address
					mov			ecx,table_max_size							;ѭ��������
					mov			eax,0										
initialize_address_number:	
					mov			[esi],eax									;��ʼ��page address
					add			esi,8										;ָ����һ��page address
					loop		initialize_address_number

					mov			eax,1										;��������
failed:				

					pop			esi
					pop			ecx
					pop			edx
					mov			esp,ebp
					pop			ebp
					ret			8
create_page_table	endp
end