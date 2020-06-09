;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  Licensed under the Apache License, Version 2.0 (the "License");
;  you may not use this file except in compliance with the License.
;  You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
;
;  Copyright (c) Microsoft Corporation. All rights reserved.
;  Implementation for ARM9 Copyright (c) Uscom Ltd.
;
;  ARM9 Standard Entry Code 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This version of the "boot entry" support is used when the application is 
; loaded or otherwise started from a bootloader. (e.g. this application isn't 
; a boot loader). More specifically this version is used whenever the application
; does NOT run from the power on reset vector because some other code is already
; there.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    EXPORT  EntryPoint
    EXPORT __initial_sp
    EXPORT Reset_Handler


    EXPORT StackBottom
    EXPORT StackTop
    EXPORT HeapBegin
    EXPORT HeapEnd
    EXPORT CustomHeapBegin
    EXPORT CustomHeapEnd


    IMPORT BootEntry
    IMPORT BootstrapCode

    PRESERVE8 
    

    ;*************************************************************************

PSR_MODE_USER       EQU     0xD0
PSR_MODE_FIQ        EQU     0xD1
PSR_MODE_IRQ        EQU     0xD2
PSR_MODE_SUPERVISOR EQU     0xD3
PSR_MODE_ABORT      EQU     0xD7
PSR_MODE_UNDEF      EQU     0xDB
PSR_MODE_SYSTEM     EQU     0xDF

STACK_MODE_ABORT    EQU     16
STACK_MODE_UNDEF    EQU     16 
STACK_MODE_IRQ      EQU     2048
    IF :DEF: FIQ_SAMPLING_PROFILER
STACK_MODE_FIQ      EQU     2048
    ENDIF

    AREA SectionForStackBottom,       DATA, NOINIT
StackBottom       DCD 0
    
    AREA SectionForStackTop,          DATA, NOINIT
__initial_sp 
StackTop          DCD 0
    
    AREA SectionForHeapBegin,         DATA, NOINIT
HeapBegin         DCD 0
    
    AREA SectionForHeapEnd,           DATA, NOINIT
HeapEnd           DCD 0
    
    AREA SectionForCustomHeapBegin,   DATA, NOINIT
CustomHeapBegin   DCD 0

    AREA SectionForCustomHeapEnd,     DATA, NOINIT
CustomHeapEnd     DCD 0
    
    ; ARM directive is only valid for ARM/THUMB processor, but not CORTEX 
    IF :DEF:COMPILE_ARM :LOR: :DEF:COMPILE_THUMB  
    ARM
    ENDIF
    

    AREA ||SectionForPowerOnReset||, CODE, READONLY
    EXPORT PowerOnReset
   

	
    ; Power On Reset vector table for the device
    ; This is placed at physical address 0 by the linker
    ; FOR ARM920t, Physical Flash From $1000-0000 mapped to $0000-0000
PowerOnReset

  
    ; RESET
RESET_VECTOR


    IF TargetLocation == "RAM"
    ;*********************************************************************
    ; keep PortBooter signature the same
    ;*********************************************************************
    msr     cpsr_c, #PSR_MODE_SYSTEM    ; go into System mode, interrupts off
	ENDIF


    ; Load PC with absolute address so the code is executed at its linked address
    ; makes dubugging easier as lables are retained and it is safe to switch off MMU/TLB
    ldr      pc, RESET_Trampoline			

    ; FAULT INSTR
FAULT_VECTOR
    ldr     pc, FAULT_Trampoline
    ldr     pc, FAULT_Trampoline	; SWI_VECTOR
    ldr     pc, FAULT_Trampoline	; PREFETCH ABORT
    ldr     pc, FAULT_Trampoline	; DATA ABORT
    ldr     pc, FAULT_Trampoline	; UNUSED_VECTOR
    ldr     pc, FAULT_Trampoline	; IRQ_VECTOR
	; FIQ
    ; we place the FIQ handler where it was designed to go, immediately at the end of the vector table
    ; this saves an additional 3+ clock cycle branch to the handler
    ldr     pc, FAULT_Trampoline    
    
    ;************************************************************************************************
    ; Jump table ensures that we execute from the real location, regardless of any remapping scheme *
    ;************************************************************************************************
				  
    ; Load PC with absolute address so the code is executed at its linked address
    ; makes dubugging easier as lables are retained and it is safe to switch off MMU/TLB
RESET_Trampoline
    DCD     Reset_Handler
FAULT_Trampoline
    DCD     Fault_Handler 
      
Fault_Handler
    b       Fault_Handler  


    IF :DEF:COMPILE_THUMB  
    THUMB
    ENDIF  
    
    AREA ||EntryPoint||, CODE, READONLY

    ENTRY
EntryPoint

Reset_Handler
    

; The first word has a dual role:
; - It is the entry point of the application loaded or discovered by
;   the bootloader and therfore must be valid executable code
; - it contains a signature word used to identify application blocks
;   in TinyBooter (see: Tinybooter_ProgramWordCheck() for more details )
; * The additional entries in this table are completely ignored and
;   remain for backwards compatibility. Since the boot loader is hard
;   coded to look for the signature, half of which is an actual relative
;   branch instruction, removing the unused entries would require all
;   bootloaders to be updated as well. [sic.]
;   [ NOTE:
;     In the next major release where we can afford to break backwards
;     compatibility this will almost certainly change, as the whole
;     init/startup for NETMF is overly complex. The various tools used
;     for building the CLR have all come around to supporting simpler
;     init sequences we should leverage directly
;   ]
; The actual word used is 0xE321F0DF for ARM9
    
    ;*********************************************************************
    ; keep PortBooter signature the same
    ;*********************************************************************
    msr     cpsr_c, #PSR_MODE_SYSTEM    ; go into System mode, interrupts off

    ; allow per processor pre-stack initialization

    IF TargetLocation == "RAM"
PreStackEntry                           ; stub this if you don't want TLB/MMU reset.
    B       PreStackInit                ; define in Solution DeviceCode or stub to map  PreStackInit -> PreStackInit_Exit_Pointer
PreStackInit_Exit_Pointer
	ENDIF



    ldr     r0, =StackTop               ; new SYS stack pointer for a full decrementing stack


    msr     cpsr_c, #PSR_MODE_ABORT     ; go into ABORT mode, interrupts off
    mov     sp, r0                      ; stack top
    sub     r0, r0, #STACK_MODE_ABORT   ; ( take the size of abort stack off )
    
    msr     cpsr_c, #PSR_MODE_UNDEF     ; go into UNDEF mode, interrupts off
    mov     sp, r0                      ; stack top - abort stack 
    sub     r0, r0, #STACK_MODE_UNDEF   ; 
    
    
    IF :DEF: FIQ_SAMPLING_PROFILER
    msr     cpsr_c, #PSR_MODE_FIQ       ; go into FIQ mode, interrupts off
    mov     sp, r0                      ; stack top - abort stack - undef stack
    sub     r0, r0, #STACK_MODE_FIQ 
    ENDIF    

    msr     cpsr_c, #PSR_MODE_IRQ       ; go into IRQ mode, interrupts off
    mov     sp, r0                      ; stack top - abort stack - undef stack (- FIQ stack)
    sub     r0, r0, #STACK_MODE_IRQ
   
    msr     cpsr_c, #PSR_MODE_SYSTEM    ; go into System mode, interrupts off
    mov     sp,r0                       ; stack top - abort stack - undef stack (- FIQ stack) - IRQ stack


    ;*********************************************************************
    bl      BootstrapCode
    b       BootEntry


    ALIGN
    IF :DEF:COMPILE_THUMB  
    THUMB
    ENDIF 
    


    ;*********************************************************************
    ; simple delay loop
delay_200
    ldr     r3, =200            ;; Loop count.
delay_loop
    subs    r3, r3, #1
    bne     delay_loop
    nop
    mov     pc, lr
    ;*********************************************************************
	 
	 
    IMPORT  CPU_ARM9_FlushCaches
    IMPORT  CPU_ARM9_BootstrapCode
    IMPORT  BootstrapCode_Clocks
    IMPORT  SDCTL_PRECHARGE_COMMAND      
    IMPORT  SDCTL_AUTOREFRESH_COMMAND    
    IMPORT  SDCTL_SETMODEREGISTER_COMMAND
    IMPORT  SDCTL_MEMORY_CONFIG          
    IMPORT  SDCTL_NORMAL_COMMAND         
    
    PRESERVE8

    AREA SectionForBootstrapOperations, CODE, READONLY

    ;*************************************************************************************************************
    ;* Even if we don't use this symbol, it's required by the linker to properly include the Vector trampolines. *
    ;*************************************************************************************************************
    IMPORT  ARM_Vectors         
    DCD     ARM_Vectors
	
SDRAMC_BASE_PHYSICAL EQU 0x00221000
SDRAM_BASE_PHYSICAL  EQU 0x08000000
    
        IF TargetLocation == "RAM"
PreStackInit

    ;*************************************************************************
    ;;
    ldr     r0, =0x2001                          ;; Allow access to all coprocessors.
    mcr     p15, 0, r0, c15, c1, 0
    nop
    nop
    nop

    ldr     r0, =0x00000078                      ;; Disable MMU, caches, write buffer.
    mcr     p15, 0, r0, c1, c0, 0
    nop
    nop
    nop

    ldr     r0, =0x00000000
    mcr     p15, 0, r0, c8, c7, 0                ;; Flush TLB's.
    mcr     p15, 0, r0, c7, c7, 0                ;; Flush Caches.
    mcr     p15, 0, r0, c7, c10, 4               ;; Flush Write Buffer.
    nop
    nop
    nop

    mvn     r0, #0                               ;; Grant manager access to all domains.
    mcr     p15, 0, r0, c3, c0, 0

    IF TargetLocation != "RAM"
    
    ;; reset the SDRAM Controller
    ldr     r2, =0x80000000
    ldr     r1, =(SDRAMC_BASE_PHYSICAL + 0x18)
    str     r2,[r1]
    bl      delay_200

    ;;********************************************************************
    ;; Initialize SDRAM Controller.
    ;; Issue Precharge All.
    ldr     r2, =SDCTL_PRECHARGE_COMMAND
    ldr     r2, [r2]
    ldr     r1, =SDRAMC_BASE_PHYSICAL
    str     r2, [r1]

    ;; Read the SDRAM to make cycle occur.
    ldr     r4, =SDRAM_BASE_PHYSICAL
    ldr     r3, [r4]
    bl      delay_200

    ;; Issue AutoRefresh (x8)
    ldr     r2, =SDCTL_AUTOREFRESH_COMMAND
    ldr     r2, [r2]
    str     r2, [r1]

    ;; Read the SDRAM 8 times.
    ldr     r2, =8
cycle8M
    ldr     r3, [r4]
    subs    r2, r2, #1
    bne     cycle8M
    bl      delay_200

    ;; Issue Mode Register Set.
    ldr     r2, =SDCTL_SETMODEREGISTER_COMMAND
    ldr     r2, [r2]
    str     r2, [r1]

    ;; The given address is loaded into SDRAM Mode Register.
    ldr     r4, =SDCTL_MEMORY_CONFIG
    ldr     r4, [r4]
    ldr     r3, =0xFFFFFFFF
    str     r3, [r4]
    bl      delay_200

    ;; Set Normal Mode and enable refresh.
    ldr     r2, =SDCTL_NORMAL_COMMAND
    ldr     r2, [r2]
    str     r2, [r1]

    ;; Read the SDRAM to make cycle occur.
    ldr     r4, =SDRAM_BASE_PHYSICAL
    ldr     r3, [r4]
    bl      delay_200

    ENDIF
    
    ldr     sp, =StackTop               ; new SYS stack pointer for a full decrementing stack

    bl      CPU_ARM9_BootstrapCode		; See $\DeviceCode\Cores\arm\Processors\ARM9\Bootstrap\dotNetMf.proj
    bl      BootstrapCode_Clocks

    ;*************************************************************************
    ; DO NOT CHANGE THE FOLLOWING CODE! we can not use pop to return because we 
    ; loaded the PC register to get here (since the stack has not been initialized).  
    ; Make sure the PreStackInit_Exit_Pointer is within range and 
    ; in the SectionForBootstrapOperations
    ; go back to the firstentry(_loader) code 
    ;
PreStackEnd
    B     PreStackInit_Exit_Pointer

	ENDIF
    END
