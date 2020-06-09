;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; This file is part of the Microsoft .NET Micro Framework Porting Kit Code Samples and is unsupported. 
;; Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
;; 
;; Licensed under the Apache License, Version 2.0 (the "License"); you may not use these files except in compliance with the License.
;; You may obtain a copy of the License at:
;; 
;; http://www.apache.org/licenses/LICENSE-2.0
;; 
;; Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing
;; permissions and limitations under the License.
;; 
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; NOTE:
;; This is only an example for use as a template in creating SoC specific versions and is not intended to be used directly
;; for any particular SoC. Each SoC must provide a version of these handlers (and the corresponding VectorTables) that is
;; specific to the SoC.
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    IMPORT  Reset_Handler
    IMPORT  UNDEF_SubHandler
    IMPORT  ABORTP_SubHandler
    IMPORT  ABORTD_SubHandler  

    IMPORT  IRQ_Handler      ; from stubs.cpp 

    EXPORT  ARM_Vectors

; Vector Table For the application
;
; bootloaders place this at offset 0 and the hardware uses
; it from there at power on reset. Applications (or the boot
;  loader itself) can place a copy in RAM to allow dynamically
; "hooking" interrupts at run-time
;
; It is expected ,though not required, that the imported handlers
; have a default empty implementation declared with WEAK linkage
; thus allowing applications to override the default by simply
; defining a function with the same name and proper behavior
; [ NOTE:
;   This standardized handler naming is an essential part of the
;   CMSIS-Core specification. It is relied upon by the CMSIS-RTX
;   implementation as well as much of the mbed framework.
; ]
    AREA SectionForArmVectors, CODE, READONLY

    
    ; ARM directive is only valid for ARM/THUMB processor, but not CORTEX 
    IF :DEF:COMPILE_ARM :LOR: :DEF:COMPILE_THUMB
    ARM
    ENDIF
   	    
    ; The first 8 entries are all architecturally defined by ARM
ARM_Vectors

    ; RESET
RESET_VECTOR

    ; Load PC with absolute address so the code is executed at its linked address
    ; makes dubugging easier as lables are retained and it is safe to switch off MMU/TLB
    ldr      pc, RESET_SubHandler_Trampoline			

    ; UNDEF INSTR
UNDEF_VECTOR
    ldr     pc, UNDEF_SubHandler_Trampoline

    ; SWI
SWI_VECTOR
    DCD     0xbaadf00d

    ; PREFETCH ABORT
PREFETCH_VECTOR
    ldr     pc, ABORTP_SubHandler_Trampoline

    ; DATA ABORT
DATA_VECTOR
    ldr     pc, ABORTD_SubHandler_Trampoline

    ; unused
USED_VECTOR
    DCD     0xbaadf00d

    ; IRQ
IRQ_VECTOR
    ldr     pc, IRQ_SubHandler_Trampoline


	IF :DEF: FIQ_SAMPLING_PROFILER  
    IMPORT  FIQ_SubHandler   
    ; FIQ
    ; we place the FIQ handler where it was designed to go, immediately at the end of the vector table
    ; this saves an additional 3+ clock cycle branch to the handler
FIQ_Handler		 
    ldr     pc, FIQ_SubHandler_Trampoline    
    
FIQ_SubHandler_Trampoline    
    DCD     FIQ_SubHandler
	ELSE
	DCD     0xbaadf00d
    ENDIF
    
	;************************************************************************************************
    ; Jump table ensures that we execute from the real location, regardless of any remapping scheme *
	;************************************************************************************************
	
   ; AREA    |VectorTable|, CODE, READONLY, ALIGN=9	
RESET_SubHandler_Trampoline
    DCD    Reset_Handler
UNDEF_SubHandler_Trampoline
    DCD     UNDEF_SubHandler
ABORTP_SubHandler_Trampoline
    DCD     ABORTP_SubHandler
ABORTD_SubHandler_Trampoline
    DCD     ABORTD_SubHandler
    ; route the normal interupt handler to the proper lowest level driver
IRQ_SubHandler_Trampoline
    DCD  	IRQ_Handler
	IF :DEF: FIQ_SAMPLING_PROFILER  
FIQ_SubHandler_Trampoline    
    DCD     FIQ_SubHandler
    ENDIF


    IF :DEF:COMPILE_THUMB  
    THUMB
    ENDIF

    END

