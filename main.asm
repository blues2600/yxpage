


;******************************************************************

;			功能：支持分页机制的虚拟内存管理程序
;			说明：1.每页4KB，那么偏移量为12位，虚拟地址低12位表示偏移量
;			     2.剩余的高20位用来表示页号，即最高支持4GB的地址空间

;******************************************************************



include		header.inc
include		my_proc.inc



.data
pid							dword	0								;进程id
virtual_address				dword	123456							;虚拟地址
physic_address				dword	0								;物理地址
file_name					byte	"c:\\od.exe",0
size_of_mumber	= 8													;页表项大小
.data?
page_table					qword	1048574		dup(?)				;页表




.code
main proc
	
	mov		eax,offset page_table			
	push	eax
	mov		eax,offset file_name
	push	eax
	call	create_page_table				;创建进程页表

	mov		eax,virtual_address
	shr		eax,12							;获取虚拟地址的页号字段

	push	size_of_mumber					;查询页表，获得页的物理地址
	push	eax								;页号 page_number
	push	offset page_table
	call	query_page_table

	mov		ecx,virtual_address
	and		ecx,0FFFh						;虚拟地址的页号（高20位）置0，获得数据的偏移量
	add		eax,ecx							;页的物理地址+偏移量=数据物理地址
	mov		physic_address,eax				;ok

	
	mov		eax,physic_address				;输出物理地址
	call	WriteHex

	invoke	ExitProcess,0
main endp
end main
