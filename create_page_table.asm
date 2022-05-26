include		header.inc



.data
file_handle				dword		0								;文件句柄
file_size				dword		0								;文件的实际大小，字节
table_max_size			dword		1048575							;页表项最大数量
err_msg_pointer			dword		0								;错误消息指针
err_msg_failed			byte		"failed.",0
err_msg_pro_too_big		byte		"the program too big.",0

.code

;					** 页表说明 **
;	
;		页表中每一项的结构为 [page number] [page address]，其中page number 和 page address都为dword
;		也就是说，在页表中一对page number 和 page address为数组的一个元素（一个页表项）
;		页号在页表中按升序排列，例如page[0] = pagetable[0] , page[1] = pagetable[1]
;
;		page address结构:	位31		页是否在内存，1为ture，0为false
;							位30		页的内容是否已经被修改，1为ture，0为false
;							位29~28  页的权限，分别为10可读、01可写、11可读且可写、00不可读不可写
;							位27~20  备用，置0
;							位19~0	 页框(page frame)的物理地址


; 名称：	create_page_table 
; 功能：	为一个exe进程创建页表，以支持操作系统的分页机制
; 说明：	虚拟地址空间从0~0xFFFFFFFF
;		物理地址的页框部分还没有实现！！
; 要求：	必须是x86 32bit PE32程序
; 参数： file_name:ptr byte			;文件名
;		page_table:ptr dword		;页表指针
; 返回：	如果成功eax返回1，否则返回0

create_page_table	proc
					file_name		equ		[ebp+8]			
					page_table		equ		[ebp+12]			

					push		ebp
					mov			ebp,esp
					push		edx
					push		ecx
					push		esi

					;打开文件
					invoke		CreateFileA, file_name, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
					cmp			eax,INVALID_HANDLE_VALUE		
					jne			open_ok										;文件打开成功
					call		GetLastError								;打开失败，获取错误编号
					invoke		FormatMessageA,FORMAT_MESSAGE_ALLOCATE_BUFFER+FORMAT_MESSAGE_FROM_SYSTEM, NULL, eax ,NULL, ADDR err_msg_pointer, NULL, NULL
					mov			edx,err_msg_pointer							;输出错误信息
					call		WriteString
					mov			eax,0
					jmp			failed
open_ok:		
					mov			file_handle,eax

					;获取文件大小
					invoke		GetFileSize, file_handle,addr file_size
					cmp			eax,0
					jnz			getFileSizeok								;成功获得文件大小
					call		Crlf										;换行
					mov			edx,offset err_msg_failed					;获取文件大小失败
					call		WriteString
					mov			eax,0
					jmp			failed
getFileSizeok:

					;评估文件大小
					mov			eax,file_size								
					cmp			eax,0FFFFFFFEh								;检查程序是否超过4GB
					jbe			file_size_ok
					call		Crlf										;换行
					mov			edx,offset err_msg_pro_too_big				;程序大小超出4GB
					call		WriteString
					mov			eax,0
					jmp			failed
file_size_ok:

					;初始化页表的页号，即页表项中的page number部分，从第0页~2的20次方-1页（即第1048575页）
					mov			esi,page_table								;加载页表指针
					add			esi,8										;第0页的页号不需要初始化
					mov			eax,1										;页号
					mov			ecx,table_max_size							;循环计数器
initialize_page_number:				
					mov			[esi],eax									;初始化页号
					inc			eax											;页号自增
					add			esi,8										;指向下一个页表项
					loop		initialize_page_number

					;初始化页表的页框地址和数据属性，即页表项中的page address部分，从第0页~2的20次方-1页（即第1048575页）
					mov			esi,page_table								;加载页表指针
					add			esi,4										;指向第0页的page address
					mov			ecx,table_max_size							;循环计数器
					mov			eax,0										
initialize_address_number:	
					mov			[esi],eax									;初始化page address
					add			esi,8										;指向下一个page address
					loop		initialize_address_number

					mov			eax,1										;正常返回
failed:				

					pop			esi
					pop			ecx
					pop			edx
					mov			esp,ebp
					pop			ebp
					ret			8
create_page_table	endp
end