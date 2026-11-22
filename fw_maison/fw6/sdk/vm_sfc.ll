; ModuleID = 'vm_sfc.c.o'
source_filename = "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/cpu/wl82/vm/vm_sfc.c"
target datalayout = "e-m:e-p:32:32-i1:32-i64:32:32-f64:32:32-n8:16:32-a:0:32"
target triple = "pi32v2"

%struct.flash_info = type { [16 x i8], i8, i8, i32, i32, i32, %struct.vm_info, %struct.sfc_info, i32, i32, i32, i32, i32, i8* }
%struct.vm_info = type { i8, i32, i32, i32 }
%struct.sfc_info = type { i32, i32 }
%struct.lp_target = type { i8*, i8 ()* }
%struct.xSTATIC_QUEUE = type { [3 x i8*], %union.anon, [2 x %struct.xSTATIC_LIST], [3 x i32], [2 x i8], i8, i32, i8 }
%union.anon = type { i8* }
%struct.xSTATIC_LIST = type { i32, i8*, %struct.xSTATIC_MINI_LIST_ITEM }
%struct.xSTATIC_MINI_LIST_ITEM = type { i32, [2 x i8*] }
%struct.dev_node = type { i8*, %struct.device_operations*, i8* }
%struct.device_operations = type { i8 (%struct.dev_node*)*, {}*, i32 (i8*, %struct.device**, i8*)*, i32 (%struct.device*, i8*, i32, i32)*, i32 (%struct.device*, i8*, i32, i32)*, i32 (%struct.device*, i32, i32)*, i32 (%struct.device*, i32, i32)*, i32 (%struct.device*)* }
%struct.device = type { %struct.atomic_t, i8*, %struct.device_operations* }
%struct.atomic_t = type { i32 }

@cpu1_run_flag = external global i8, align 1
@cpu_do_in_irq_func = internal unnamed_addr global void (i8*)* null, section ".volatile_ram", align 4, !dbg !0
@cpu_do_in_irq_priv = internal unnamed_addr global i8* null, section ".volatile_ram", align 4, !dbg !422
@cpu_wait_flag = internal global i8 0, section ".volatile_ram", align 1, !dbg !424
@is4byte_mode = internal global i8 0, section ".sram", align 1, !dbg !330
@flash_info = internal global %struct.flash_info zeroinitializer, section ".sram", align 4, !dbg !352
@sfc_is_busy = internal global i8 0, align 1, !dbg !346
@.str = private unnamed_addr constant [9 x i8] c"norflash\00", align 1
@norflash_lp_target = constant %struct.lp_target { i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i32 0, i32 0), i8 ()* @norflash_idle_query }, section ".lp_target", align 4, !dbg !333
@sfc_norflash_mutex = internal global %struct.xSTATIC_QUEUE zeroinitializer, align 4, !dbg !373
@sfc_mutex_enter_cnt = internal unnamed_addr global i8 0, align 1, !dbg !348
@spi_is_no_cmd = internal unnamed_addr global i32 0, align 4, !dbg !350
@norflash_write_cpu_unhold = external local_unnamed_addr constant i32, align 4
@norflash_write_readback_check_en = external local_unnamed_addr constant i32, align 4
@log_tag_const_i_VM = external local_unnamed_addr constant i8, align 1
@.str.1 = private unnamed_addr constant [51 x i8] c"[Info]: [VM]readback check enabled. buf len = %d\0D\0A\00", align 1
@log_tag_const_e_VM = external local_unnamed_addr constant i8, align 1
@.str.2 = private unnamed_addr constant [42 x i8] c"<Error>: [VM]readback check enable fail\0D\0A\00", align 1
@readback_chk_ctl_en = internal unnamed_addr global i8 1, align 1, !dbg !426
@.str.3 = private unnamed_addr constant [77 x i8] c"<Error>: [VM]err norflash_write over cap_size, offset=0x%x, cap_size=0x%x\0A\0D\0A\00", align 1
@.str.4 = private unnamed_addr constant [39 x i8] c"<Error>: [VM]%s() input value error\0A\0D\0A\00", align 1
@__FUNCTION__.norflash_read_otp_general = private unnamed_addr constant [26 x i8] c"norflash_read_otp_general\00", align 1
@_SPI_CODE_END = external global i32, align 4
@_SPI_CODE_START = external global i32, align 4
@.str.5 = private unnamed_addr constant [53 x i8] c"<Error>: [VM]norflash_data_check fail. addr = 0x%x\0D\0A\00", align 1
@.str.6 = private unnamed_addr constant [28 x i8] c"<Error>: [VM]write data :\0D\0A\00", align 1
@.str.7 = private unnamed_addr constant [28 x i8] c"<Error>: [VM]flash data :\0D\0A\00", align 1
@config_asser = external local_unnamed_addr constant i32, align 4
@.str.8 = private unnamed_addr constant [26 x i8] c"file:%s, line:%d, task:%s\00", align 1
@.str.9 = private unnamed_addr constant [83 x i8] c"/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/cpu/wl82/vm/vm_sfc.c\00", align 1
@.str.10 = private unnamed_addr constant [28 x i8] c"ASSERT-FAILD: _arg != NULL \00", align 1
@.str.11 = private unnamed_addr constant [34 x i8] c"[Info]: [VM]SPI_SCLK_H_UPH_SMPL\0D\0A\00", align 1
@.str.12 = private unnamed_addr constant [34 x i8] c"[Info]: [VM]SPI_SCLK_H_UPL_SMPH\0D\0A\00", align 1
@.str.13 = private unnamed_addr constant [34 x i8] c"[Info]: [VM]SPI_SCLK_H_UPH_SMPH\0D\0A\00", align 1
@.str.14 = private unnamed_addr constant [34 x i8] c"[Info]: [VM]SPI_SCLK_H_UPL_SMPL\0D\0A\00", align 1
@.str.15 = private unnamed_addr constant [34 x i8] c"[Info]: [VM]SPI_SCLK_L_UPH_SMPL\0D\0A\00", align 1
@.str.16 = private unnamed_addr constant [34 x i8] c"[Info]: [VM]SPI_SCLK_L_UPL_SMPH\0D\0A\00", align 1
@.str.17 = private unnamed_addr constant [34 x i8] c"[Info]: [VM]SPI_SCLK_L_UPH_SMPH\0D\0A\00", align 1
@.str.18 = private unnamed_addr constant [34 x i8] c"[Info]: [VM]SPI_SCLK_L_UPL_SMPL\0D\0A\00", align 1
@.str.19 = private unnamed_addr constant [53 x i8] c"[Info]: [VM]warn : use default SPI_SCLK_L_UPL_SMPL\0D\0A\00", align 1
@.str.20 = private unnamed_addr constant [45 x i8] c"[Info]: [VM]norflash_set_spi_con_attr=0x%x\0D\0A\00", align 1
@llvm.used = appending global [54 x i8*] [i8* bitcast (i32 (i8*, i32, i16, i32)* @__norflash_read to i8*), i8* bitcast (i32 (i8*, i32, i32)* @_norflash_read to i8*), i8* bitcast (i32 (i8*, i32, i32)* @_norflash_write to i8*), i8* bitcast (i32 (i32)* @cpu_addr2flash_addr to i8*), i8* bitcast (void ()* @enter_continue_mode to i8*), i8* bitcast (void ()* @enter_spi_code to i8*), i8* bitcast (i32 ()* @exit_continue_mode to i8*), i8* bitcast (void (i32)* @exit_spi_code to i8*), i8* bitcast (i32 (i32)* @flash_addr2cpu_addr to i8*), i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 0, i32 0), i8* bitcast (i32 (i32)* @flash_write_protect to i8*), i8* bitcast (void ()* @flash_write_protect_init to i8*), i8* bitcast (void (i32, i32)* @flushinv_dcache_api to i8*), i8* bitcast (void (i8*, i32)* @icache_flush to i8*), i8* @is4byte_mode, i8* bitcast (i32 (i32)* @norflash_calc_capacity to i8*), i8* bitcast (void ()* @norflash_enter_spi_code to i8*), i8* bitcast (void (%struct.device*)* @norflash_entry_sleep to i8*), i8* bitcast (i32 (i32, i32)* @norflash_erase to i8*), i8* bitcast (i32 ()* @norflash_eraser_otp to i8*), i8* bitcast (void (%struct.device*)* @norflash_exit_sleep to i8*), i8* bitcast (void ()* @norflash_exit_spi_code to i8*), i8* bitcast (i32 ()* @norflash_is_busy to i8*), i8* bitcast (%struct.lp_target* @norflash_lp_target to i8*), i8* bitcast (i32 (i8*, i32, i32)* @norflash_read_otp to i8*), i8* bitcast (i32 (i8, i32, i8*, i32)* @norflash_read_otp_general to i8*), i8* bitcast (i16 ()* @norflash_read_sr to i8*), i8* bitcast (void ()* @norflash_resume to i8*), i8* bitcast (void (i32)* @norflash_send_addr to i8*), i8* bitcast (void (i8)* @norflash_spi_cs to i8*), i8* bitcast (i8 ()* @norflash_spi_read_byte to i8*), i8* bitcast (void (i8)* @norflash_spi_write_byte to i8*), i8* bitcast (void ()* @norflash_suspend to i8*), i8* bitcast (i32 ()* @norflash_wait_busy to i8*), i8* bitcast (i32 ()* @norflash_wait_ok to i8*), i8* bitcast (void ()* @norflash_write_enable to i8*), i8* bitcast (i32 (i8*, i32, i32)* @norflash_write_otp to i8*), i8* bitcast (i32 (i32)* @norflash_write_sr to i8*), i8* bitcast (void ()* @read_flash_id to i8*), i8* bitcast (void (i8*, i32)* @sfc_drop_cache to i8*), i8* bitcast (void (i32)* @sfc_nop_delay to i8*), i8* bitcast (void (i8)* @sfc_protect to i8*), i8* bitcast (void (i32)* @sfc_resume to i8*), i8* bitcast (void (i32)* @sfc_suspend to i8*), i8* bitcast (void (i8)* @spi_cs to i8*), i8* bitcast (i32 (i8*, i16)* @spi_read_dma to i8*), i8* bitcast (i8 ()* @spi_readbyte to i8*), i8* bitcast (i8 ()* @spi_readbyte_dma to i8*), i8* bitcast (i32 ()* @spi_wait_ok to i8*), i8* bitcast (i32 (i8*, i16)* @spi_write_dma to i8*), i8* bitcast (void (i8)* @spi_writebyte to i8*), i8* bitcast (void (i8)* @spi_writebyte_dma to i8*), i8* bitcast (void (i32)* @spiflash_enter_4byte_addr to i8*), i8* bitcast (void (i32)* @spiflash_exit_4byte_addr to i8*)], section "llvm.metadata"

; Function Attrs: minsize nounwind optsize
define void @icache_flush(i8*, i32) #0 section ".flushinv_icache" !dbg !434 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !440, metadata !442), !dbg !443
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !441, metadata !442), !dbg !444
  br label %3, !dbg !445

; <label>:3:                                      ; preds = %3, %2
  %4 = load volatile i32, i32* inttoptr (i32 32432136 to i32*), align 8, !dbg !446, !tbaa !448
  %5 = and i32 %4, 16384, !dbg !453
  %6 = icmp eq i32 %5, 0, !dbg !454
  br i1 %6, label %3, label %7, !dbg !455, !llvm.loop !456

; <label>:7:                                      ; preds = %3
  %8 = ptrtoint i8* %0 to i32, !dbg !458
  %9 = and i32 %8, -32, !dbg !459
  %10 = inttoptr i32 %9 to i8*, !dbg !460
  tail call void @llvm.dbg.value(metadata i8* %10, i64 0, metadata !440, metadata !442), !dbg !443
  %11 = add nsw i32 %1, 31, !dbg !461
  %12 = sdiv i32 %11, 32, !dbg !462
  %13 = shl nsw i32 %12, 5, !dbg !463
  tail call void @llvm.dbg.value(metadata i32 %13, i64 0, metadata !441, metadata !442), !dbg !444
  br label %14, !dbg !464

; <label>:14:                                     ; preds = %23, %7
  %15 = phi i8* [ %10, %7 ], [ %25, %23 ]
  %16 = phi i32 [ %13, %7 ], [ %24, %23 ]
  tail call void @llvm.dbg.value(metadata i32 %16, i64 0, metadata !441, metadata !442), !dbg !444
  tail call void @llvm.dbg.value(metadata i8* %15, i64 0, metadata !440, metadata !442), !dbg !443
  %17 = icmp sgt i32 %16, 0, !dbg !465
  br i1 %17, label %18, label %26, !dbg !466

; <label>:18:                                     ; preds = %14
  tail call void asm sideeffect "csync \0A\09 flushinv [$0]", "r"(i8* %15) #13, !dbg !467, !srcloc !469
  tail call void asm sideeffect "csync ;", ""() #13, !dbg !470, !srcloc !471
  br label %19, !dbg !472

; <label>:19:                                     ; preds = %19, %18
  %20 = load volatile i32, i32* inttoptr (i32 32432136 to i32*), align 8, !dbg !473, !tbaa !448
  %21 = and i32 %20, 16384, !dbg !475
  %22 = icmp eq i32 %21, 0, !dbg !476
  br i1 %22, label %19, label %23, !dbg !477, !llvm.loop !478

; <label>:23:                                     ; preds = %19
  %24 = add nsw i32 %16, -32, !dbg !480
  tail call void @llvm.dbg.value(metadata i32 %24, i64 0, metadata !441, metadata !442), !dbg !444
  %25 = getelementptr inbounds i8, i8* %15, i32 32, !dbg !481
  tail call void @llvm.dbg.value(metadata i8* %25, i64 0, metadata !440, metadata !442), !dbg !443
  br label %14, !dbg !482, !llvm.loop !484

; <label>:26:                                     ; preds = %14
  ret void, !dbg !486
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: minsize nounwind optsize
define void @dsp_corex_enter_hold(i8 signext) local_unnamed_addr #0 section ".volatile_ram_code" !dbg !487 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !491, metadata !442), !dbg !492
  %2 = icmp eq i8 %0, 0, !dbg !493
  br i1 %2, label %3, label %10, !dbg !495

; <label>:3:                                      ; preds = %1
  %4 = load volatile i32, i32* inttoptr (i32 32432128 to i32*), align 8192, !dbg !496, !tbaa !498
  %5 = or i32 %4, 4, !dbg !496
  store volatile i32 %5, i32* inttoptr (i32 32432128 to i32*), align 8192, !dbg !496, !tbaa !498
  tail call void asm sideeffect "csync;", ""() #13, !dbg !499, !srcloc !502
  br label %6, !dbg !503

; <label>:6:                                      ; preds = %6, %3
  %7 = load volatile i32, i32* inttoptr (i32 32432128 to i32*), align 8192, !dbg !504, !tbaa !498
  %8 = and i32 %7, 16, !dbg !506
  %9 = icmp eq i32 %8, 0, !dbg !507
  br i1 %9, label %6, label %17, !dbg !508, !llvm.loop !509

; <label>:10:                                     ; preds = %1
  %11 = load volatile i32, i32* inttoptr (i32 32432132 to i32*), align 4, !dbg !511, !tbaa !513
  %12 = or i32 %11, 4, !dbg !511
  store volatile i32 %12, i32* inttoptr (i32 32432132 to i32*), align 4, !dbg !511, !tbaa !513
  tail call void asm sideeffect "csync;", ""() #13, !dbg !514, !srcloc !517
  br label %13, !dbg !518

; <label>:13:                                     ; preds = %13, %10
  %14 = load volatile i32, i32* inttoptr (i32 32432132 to i32*), align 4, !dbg !519, !tbaa !513
  %15 = and i32 %14, 16, !dbg !521
  %16 = icmp eq i32 %15, 0, !dbg !522
  br i1 %16, label %13, label %18, !dbg !523, !llvm.loop !524

; <label>:17:                                     ; preds = %6
  br label %19, !dbg !526

; <label>:18:                                     ; preds = %13
  br label %19, !dbg !527

; <label>:19:                                     ; preds = %18, %17
  ret void, !dbg !529
}

; Function Attrs: minsize nounwind optsize
define void @dsp_corex_exit_hold(i8 signext) local_unnamed_addr #0 section ".volatile_ram_code" !dbg !531 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !533, metadata !442), !dbg !534
  %2 = icmp eq i8 %0, 0, !dbg !535
  %3 = select i1 %2, i32* inttoptr (i32 32432128 to i32*), i32* inttoptr (i32 32432132 to i32*), !dbg !537
  %4 = load volatile i32, i32* %3, align 4, !tbaa !538
  %5 = or i32 %4, 8
  store volatile i32 %5, i32* %3, align 4, !tbaa !538
  tail call void asm sideeffect "csync;", ""() #13, !dbg !539, !srcloc !542
  ret void, !dbg !543
}

; Function Attrs: minsize nounwind optsize
define void @cpu_enter_sfc_critical(void (i8*)*, i8*) local_unnamed_addr #0 section ".volatile_ram_code" !dbg !544 {
  tail call void @llvm.dbg.value(metadata void (i8*)* %0, i64 0, metadata !548, metadata !442), !dbg !550
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !549, metadata !442), !dbg !551
  %3 = load volatile i8, i8* @cpu1_run_flag, align 1, !dbg !552, !tbaa !554
  %4 = icmp eq i8 %3, 0, !dbg !552
  br i1 %4, label %5, label %17, !dbg !555

; <label>:5:                                      ; preds = %2
  tail call void asm sideeffect "csync;", ""() #13, !dbg !556, !srcloc !560
  br label %6, !dbg !561

; <label>:6:                                      ; preds = %6, %5
  %7 = load volatile i32, i32* inttoptr (i32 32432136 to i32*), align 8, !dbg !562, !tbaa !448
  %8 = and i32 %7, 16384, !dbg !564
  %9 = icmp eq i32 %8, 0, !dbg !565
  br i1 %9, label %6, label %10, !dbg !566, !llvm.loop !567

; <label>:10:                                     ; preds = %6
  tail call void @sys_local_irq_disable() #14, !dbg !569
  store void (i8*)* %0, void (i8*)** @cpu_do_in_irq_func, align 4, !dbg !572, !tbaa !573
  store i8* %1, i8** @cpu_do_in_irq_priv, align 4, !dbg !575, !tbaa !573
  tail call void asm sideeffect "csync;", ""() #13, !dbg !576, !srcloc !579
  %11 = load void (i8*)*, void (i8*)** @cpu_do_in_irq_func, align 4, !dbg !580, !tbaa !573
  %12 = icmp eq void (i8*)* %11, null, !dbg !580
  br i1 %12, label %42, label %13, !dbg !582

; <label>:13:                                     ; preds = %10
  %14 = tail call i32 asm sideeffect "$0 = cnum", "=r"() #13, !dbg !583, !srcloc !592
  tail call void @llvm.dbg.value(metadata i32 %14, i64 0, metadata !588, metadata !442) #13, !dbg !593
  %15 = icmp eq i32 %14, 0, !dbg !594
  %16 = select i1 %15, i32 32, i32 16, !dbg !595
  store volatile i32 %16, i32* inttoptr (i32 32436640 to i32*), align 32, !tbaa !596
  br label %42, !dbg !598

; <label>:17:                                     ; preds = %2
  tail call void @__local_irq_disable() #14, !dbg !599
  br label %18, !dbg !601

; <label>:18:                                     ; preds = %21, %17
  %19 = load volatile i8, i8* @cpu_wait_flag, align 1, !dbg !602, !tbaa !554
  %20 = icmp eq i8 %19, 1, !dbg !602
  br i1 %20, label %21, label %22, !dbg !602

; <label>:21:                                     ; preds = %18
  tail call void asm sideeffect "csync;", ""() #13, !dbg !604, !srcloc !608
  br label %18, !dbg !609, !llvm.loop !611

; <label>:22:                                     ; preds = %18
  store volatile i8 0, i8* @cpu_wait_flag, align 1, !dbg !612, !tbaa !554
  tail call void asm sideeffect "csync;", ""() #13, !dbg !615, !srcloc !618
  tail call void asm sideeffect "csync;", ""() #13, !dbg !619, !srcloc !622
  store void (i8*)* %0, void (i8*)** @cpu_do_in_irq_func, align 4, !dbg !623, !tbaa !573
  store i8* %1, i8** @cpu_do_in_irq_priv, align 4, !dbg !624, !tbaa !573
  tail call void asm sideeffect "csync;", ""() #13, !dbg !625, !srcloc !628
  %23 = tail call i32 asm sideeffect "$0 = cnum", "=r"() #13, !dbg !629, !srcloc !592
  tail call void @llvm.dbg.value(metadata i32 %23, i64 0, metadata !588, metadata !442) #13, !dbg !633
  %24 = icmp eq i32 %23, 0, !dbg !634
  %25 = select i1 %24, i32 16, i32 32, !dbg !635
  store volatile i32 %25, i32* inttoptr (i32 32436640 to i32*), align 32, !tbaa !596
  tail call void asm sideeffect "csync;", ""() #13, !dbg !636, !srcloc !639
  br label %26, !dbg !640

; <label>:26:                                     ; preds = %26, %22
  %27 = load volatile i32, i32* inttoptr (i32 32432136 to i32*), align 8, !dbg !641, !tbaa !448
  %28 = and i32 %27, 16384, !dbg !642
  %29 = icmp eq i32 %28, 0, !dbg !643
  br i1 %29, label %26, label %30, !dbg !644, !llvm.loop !645

; <label>:30:                                     ; preds = %26
  br label %31, !dbg !647

; <label>:31:                                     ; preds = %34, %30
  %32 = load volatile i8, i8* @cpu_wait_flag, align 1, !dbg !647, !tbaa !554
  %33 = icmp eq i8 %32, 0, !dbg !647
  br i1 %33, label %34, label %35, !dbg !647

; <label>:34:                                     ; preds = %31
  tail call void asm sideeffect "csync;", ""() #13, !dbg !648, !srcloc !652
  br label %31, !dbg !653, !llvm.loop !654

; <label>:35:                                     ; preds = %31
  %36 = load void (i8*)*, void (i8*)** @cpu_do_in_irq_func, align 4, !dbg !656, !tbaa !573
  %37 = icmp eq void (i8*)* %36, null, !dbg !656
  br i1 %37, label %38, label %42, !dbg !658

; <label>:38:                                     ; preds = %35
  %39 = tail call i32 asm sideeffect "$0 = cnum", "=r"() #13, !dbg !659, !srcloc !592
  tail call void @llvm.dbg.value(metadata i32 %39, i64 0, metadata !588, metadata !442) #13, !dbg !663
  %40 = icmp eq i32 %39, 0, !dbg !664
  %41 = zext i1 %40 to i8, !dbg !664
  tail call void @dsp_corex_enter_hold(i8 signext %41) #15, !dbg !665
  br label %42, !dbg !667

; <label>:42:                                     ; preds = %38, %35, %13, %10
  ret void, !dbg !668
}

; Function Attrs: minsize optsize
declare void @sys_local_irq_disable() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare void @__local_irq_disable() local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define void @cpu_exit_sfc_critical() local_unnamed_addr #0 section ".volatile_ram_code" !dbg !669 {
  %1 = load volatile i8, i8* @cpu1_run_flag, align 1, !dbg !672, !tbaa !554
  %2 = icmp eq i8 %1, 0, !dbg !672
  br i1 %2, label %3, label %4, !dbg !674

; <label>:3:                                      ; preds = %0
  store void (i8*)* null, void (i8*)** @cpu_do_in_irq_func, align 4, !dbg !675, !tbaa !573
  tail call void @sys_local_irq_enable() #14, !dbg !677
  br label %12, !dbg !680

; <label>:4:                                      ; preds = %0
  tail call void asm sideeffect "csync;", ""() #13, !dbg !681, !srcloc !685
  store volatile i8 0, i8* @cpu_wait_flag, align 1, !dbg !686, !tbaa !554
  tail call void asm sideeffect "csync;", ""() #13, !dbg !689, !srcloc !692
  %5 = load void (i8*)*, void (i8*)** @cpu_do_in_irq_func, align 4, !dbg !693, !tbaa !573
  %6 = icmp eq void (i8*)* %5, null, !dbg !693
  br i1 %6, label %7, label %11, !dbg !695

; <label>:7:                                      ; preds = %4
  %8 = tail call i32 asm sideeffect "$0 = cnum", "=r"() #13, !dbg !696, !srcloc !592
  tail call void @llvm.dbg.value(metadata i32 %8, i64 0, metadata !588, metadata !442) #13, !dbg !699
  %9 = icmp eq i32 %8, 0, !dbg !700
  %10 = zext i1 %9 to i8, !dbg !700
  tail call void @dsp_corex_exit_hold(i8 signext %10) #15, !dbg !701
  br label %11, !dbg !703

; <label>:11:                                     ; preds = %7, %4
  store void (i8*)* null, void (i8*)** @cpu_do_in_irq_func, align 4, !dbg !704, !tbaa !573
  tail call void @__local_irq_enable() #14, !dbg !705
  br label %12

; <label>:12:                                     ; preds = %11, %3
  tail call void asm sideeffect "csync;", ""() #13, !dbg !706, !srcloc !709
  ret void, !dbg !710
}

; Function Attrs: minsize optsize
declare void @sys_local_irq_enable() local_unnamed_addr #2

; Function Attrs: minsize optsize
declare void @__local_irq_enable() local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define internal void @sfc_nop_delay(i32) #0 section ".spi_code" !dbg !711 {
  %2 = alloca i32, align 4
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !716, metadata !442), !dbg !717
  store volatile i32 %0, i32* %2, align 4
  br label %3, !dbg !718

; <label>:3:                                      ; preds = %7, %1
  %4 = load volatile i32, i32* %2, align 4, !dbg !719
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !716, metadata !442), !dbg !717
  %5 = add i32 %4, -1, !dbg !719
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !716, metadata !442), !dbg !717
  store volatile i32 %5, i32* %2, align 4, !dbg !719
  %6 = icmp eq i32 %4, 0, !dbg !721
  br i1 %6, label %8, label %7, !dbg !721

; <label>:7:                                      ; preds = %3
  tail call void asm sideeffect "nop", ""() #13, !dbg !722, !srcloc !724
  br label %3, !dbg !725, !llvm.loop !727

; <label>:8:                                      ; preds = %3
  ret void, !dbg !729
}

; Function Attrs: minsize nounwind optsize
define internal void @spi_cs(i8 zeroext) #0 section ".spi_code" !dbg !730 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !734, metadata !442), !dbg !735
  %2 = load volatile i32, i32* inttoptr (i32 327880 to i32*), align 8, !dbg !736, !tbaa !739
  %3 = and i32 %2, -2, !dbg !736
  store volatile i32 %3, i32* inttoptr (i32 327880 to i32*), align 8, !dbg !736, !tbaa !739
  %4 = icmp eq i8 %0, 0, !dbg !741
  %5 = load volatile i32, i32* inttoptr (i32 327872 to i32*), align 64, !tbaa !742
  %6 = and i32 %5, -2, !dbg !743
  %7 = or i32 %5, 1, !dbg !745
  %8 = select i1 %4, i32 %6, i32 %7, !dbg !741
  store volatile i32 %8, i32* inttoptr (i32 327872 to i32*), align 64, !tbaa !742
  tail call void @sfc_nop_delay(i32 10) #15, !dbg !747
  ret void, !dbg !748
}

; Function Attrs: minsize nounwind optsize
define internal i32 @spi_wait_ok() #0 section ".spi_code" !dbg !749 {
  %1 = alloca i32, align 4
  %2 = bitcast i32* %1 to i8*, !dbg !752
  call void @llvm.lifetime.start(i64 4, i8* nonnull %2), !dbg !752
  tail call void @llvm.dbg.value(metadata i32 50000000, i64 0, metadata !751, metadata !442), !dbg !753
  store volatile i32 200000, i32* %1, align 4, !dbg !753
  tail call void asm sideeffect "csync;", ""() #13, !dbg !754, !srcloc !757
  br label %3, !dbg !758

; <label>:3:                                      ; preds = %7, %0
  %4 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !759, !tbaa !761
  %5 = trunc i32 %4 to i16, !dbg !763
  %6 = icmp slt i16 %5, 0, !dbg !763
  br i1 %6, label %11, label %7, !dbg !764

; <label>:7:                                      ; preds = %3
  %8 = load volatile i32, i32* %1, align 4, !dbg !765
  tail call void @llvm.dbg.value(metadata i32 %8, i64 0, metadata !751, metadata !442), !dbg !753
  %9 = add i32 %8, -1, !dbg !765
  tail call void @llvm.dbg.value(metadata i32 %9, i64 0, metadata !751, metadata !442), !dbg !753
  store volatile i32 %9, i32* %1, align 4, !dbg !765
  %10 = icmp eq i32 %9, 0, !dbg !767
  br i1 %10, label %11, label %3, !dbg !768, !llvm.loop !769

; <label>:11:                                     ; preds = %7, %3
  %12 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !771, !tbaa !761
  %13 = or i32 %12, 16384, !dbg !771
  store volatile i32 %13, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !771, !tbaa !761
  %14 = load volatile i32, i32* %1, align 4, !dbg !772
  tail call void @llvm.dbg.value(metadata i32 %14, i64 0, metadata !751, metadata !442), !dbg !753
  %15 = icmp eq i32 %14, 0, !dbg !772
  br i1 %15, label %16, label %17, !dbg !774

; <label>:16:                                     ; preds = %11
  tail call void @putbyte(i8 signext 101) #14, !dbg !775
  tail call void @putbyte(i8 signext 114) #14, !dbg !777
  tail call void @putbyte(i8 signext 114) #14, !dbg !778
  tail call void @putbyte(i8 signext 32) #14, !dbg !779
  tail call void @putbyte(i8 signext 115) #14, !dbg !780
  tail call void @putbyte(i8 signext 112) #14, !dbg !781
  tail call void @putbyte(i8 signext 105) #14, !dbg !782
  tail call void @putbyte(i8 signext 119) #14, !dbg !783
  tail call void @putbyte(i8 signext 97) #14, !dbg !784
  tail call void @putbyte(i8 signext 105) #14, !dbg !785
  tail call void @putbyte(i8 signext 32) #14, !dbg !786
  tail call void @putbyte(i8 signext 116) #14, !dbg !787
  tail call void @putbyte(i8 signext 111) #14, !dbg !788
  tail call void @putbyte(i8 signext 13) #14, !dbg !789
  tail call void @putbyte(i8 signext 10) #14, !dbg !790
  br label %17, !dbg !791

; <label>:17:                                     ; preds = %16, %11
  %18 = phi i32 [ -1, %16 ], [ 0, %11 ]
  call void @llvm.lifetime.end(i64 4, i8* nonnull %2), !dbg !792
  ret i32 %18, !dbg !792
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #3

; Function Attrs: minsize optsize
declare void @putbyte(i8 signext) local_unnamed_addr #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #3

; Function Attrs: minsize nounwind optsize
define internal void @spi_writebyte(i8 zeroext) #0 section ".spi_code" !dbg !793 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !795, metadata !442), !dbg !796
  %2 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !797, !tbaa !761
  %3 = or i32 %2, 8, !dbg !797
  store volatile i32 %3, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !797, !tbaa !761
  %4 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !798, !tbaa !761
  %5 = and i32 %4, -4097, !dbg !798
  store volatile i32 %5, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !798, !tbaa !761
  %6 = zext i8 %0 to i32, !dbg !799
  store volatile i32 %6, i32* inttoptr (i32 72712 to i32*), align 8, !dbg !800, !tbaa !801
  %7 = tail call i32 @spi_wait_ok() #15, !dbg !802
  %8 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !803, !tbaa !761
  %9 = and i32 %8, -9, !dbg !803
  store volatile i32 %9, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !803, !tbaa !761
  ret void, !dbg !804
}

; Function Attrs: minsize nounwind optsize
define internal void @spi_writebyte_dma(i8 zeroext) #0 section ".spi_code" !dbg !805 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !807, metadata !442), !dbg !808
  %2 = zext i8 %0 to i32, !dbg !809
  store volatile i32 %2, i32* inttoptr (i32 72712 to i32*), align 8, !dbg !810, !tbaa !801
  %3 = tail call i32 @spi_wait_ok() #15, !dbg !811
  ret void, !dbg !812
}

; Function Attrs: minsize nounwind optsize
define internal zeroext i8 @spi_readbyte() #0 section ".spi_code" !dbg !813 {
  %1 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !816, !tbaa !761
  %2 = or i32 %1, 8, !dbg !816
  store volatile i32 %2, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !816, !tbaa !761
  %3 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !817, !tbaa !761
  %4 = or i32 %3, 4096, !dbg !817
  store volatile i32 %4, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !817, !tbaa !761
  store volatile i32 255, i32* inttoptr (i32 72712 to i32*), align 8, !dbg !818, !tbaa !801
  %5 = tail call i32 @spi_wait_ok() #15, !dbg !819
  %6 = load volatile i32, i32* inttoptr (i32 72712 to i32*), align 8, !dbg !820, !tbaa !801
  %7 = trunc i32 %6 to i8, !dbg !821
  tail call void @llvm.dbg.value(metadata i8 %7, i64 0, metadata !815, metadata !442), !dbg !822
  %8 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !823, !tbaa !761
  %9 = and i32 %8, -9, !dbg !823
  store volatile i32 %9, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !823, !tbaa !761
  ret i8 %7, !dbg !824
}

; Function Attrs: minsize nounwind optsize
define internal zeroext i8 @spi_readbyte_dma() #0 section ".spi_code" !dbg !825 {
  store volatile i32 255, i32* inttoptr (i32 72712 to i32*), align 8, !dbg !828, !tbaa !801
  %1 = tail call i32 @spi_wait_ok() #15, !dbg !829
  %2 = load volatile i32, i32* inttoptr (i32 72712 to i32*), align 8, !dbg !830, !tbaa !801
  %3 = trunc i32 %2 to i8, !dbg !831
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !827, metadata !442), !dbg !832
  ret i8 %3, !dbg !833
}

; Function Attrs: minsize nounwind optsize
define internal void @spiflash_enter_4byte_addr(i32) #0 section ".spi_code" !dbg !834 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !838, metadata !442), !dbg !840
  %2 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !841, !tbaa !842
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !839, metadata !442), !dbg !846
  %3 = icmp ugt i32 %2, 16777216, !dbg !847
  br i1 %3, label %4, label %10, !dbg !849

; <label>:4:                                      ; preds = %1
  %5 = load volatile i8, i8* @is4byte_mode, align 1, !dbg !850, !tbaa !554
  %6 = icmp eq i8 %5, 0, !dbg !850
  %7 = icmp ugt i32 %0, 16777215, !dbg !852
  %8 = and i1 %7, %6, !dbg !853
  br i1 %8, label %9, label %10, !dbg !853

; <label>:9:                                      ; preds = %4
  store volatile i8 1, i8* @is4byte_mode, align 1, !dbg !854, !tbaa !554
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !856
  tail call void @spi_writebyte(i8 zeroext -73) #15, !dbg !857
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !858
  br label %10, !dbg !859

; <label>:10:                                     ; preds = %9, %4, %1
  ret void, !dbg !860
}

; Function Attrs: minsize nounwind optsize
define internal void @spiflash_exit_4byte_addr(i32) #0 section ".spi_code" !dbg !861 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !863, metadata !442), !dbg !865
  %2 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !866, !tbaa !842
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !864, metadata !442), !dbg !867
  %3 = icmp ugt i32 %2, 16777216, !dbg !868
  br i1 %3, label %4, label %10, !dbg !870

; <label>:4:                                      ; preds = %1
  %5 = load volatile i8, i8* @is4byte_mode, align 1, !dbg !871, !tbaa !554
  %6 = icmp ne i8 %5, 0, !dbg !871
  %7 = icmp ugt i32 %0, 16777215, !dbg !873
  %8 = and i1 %7, %6, !dbg !874
  br i1 %8, label %9, label %10, !dbg !874

; <label>:9:                                      ; preds = %4
  store volatile i8 0, i8* @is4byte_mode, align 1, !dbg !875, !tbaa !554
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !877
  tail call void @spi_writebyte(i8 zeroext -23) #15, !dbg !878
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !879
  br label %10, !dbg !880

; <label>:10:                                     ; preds = %9, %4, %1
  ret void, !dbg !881
}

; Function Attrs: minsize nounwind optsize
define internal i32 @spi_write_dma(i8* nocapture readonly, i16 zeroext) #0 section ".spi_code" !dbg !882 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !887, metadata !442), !dbg !891
  tail call void @llvm.dbg.value(metadata i16 %1, i64 0, metadata !888, metadata !442), !dbg !892
  %3 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 8), align 4, !dbg !893, !tbaa !894
  %4 = icmp eq i32 %3, 0, !dbg !895
  br i1 %4, label %5, label %7, !dbg !895

; <label>:5:                                      ; preds = %2
  %6 = load volatile i32, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !896, !tbaa !898
  br label %7, !dbg !900

; <label>:7:                                      ; preds = %5, %2
  %8 = phi i32 [ %6, %5 ], [ %3, %2 ], !dbg !901
  %9 = lshr i32 %8, 8, !dbg !903
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !890, metadata !442), !dbg !904
  %10 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !905, !tbaa !761
  %11 = and i32 %10, -4097, !dbg !905
  store volatile i32 %11, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !905, !tbaa !761
  %12 = trunc i32 %9 to i4, !dbg !906
  switch i4 %12, label %23 [
    i4 3, label %13
    i4 5, label %13
    i4 7, label %13
    i4 -7, label %13
    i4 2, label %18
    i4 4, label %18
    i4 6, label %18
    i4 -8, label %18
  ], !dbg !906

; <label>:13:                                     ; preds = %7, %7, %7, %7
  %14 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !907, !tbaa !761
  %15 = and i32 %14, -1545, !dbg !907
  store volatile i32 %15, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !907, !tbaa !761
  %16 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !909, !tbaa !761
  %17 = or i32 %16, 2304, !dbg !909
  tail call void @llvm.dbg.value(metadata i8 4, i64 0, metadata !890, metadata !442), !dbg !904
  br label %28, !dbg !910

; <label>:18:                                     ; preds = %7, %7, %7, %7
  %19 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !911, !tbaa !761
  %20 = and i32 %19, -2825, !dbg !911
  store volatile i32 %20, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !911, !tbaa !761
  %21 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !912, !tbaa !761
  %22 = or i32 %21, 1024, !dbg !912
  tail call void @llvm.dbg.value(metadata i8 2, i64 0, metadata !890, metadata !442), !dbg !904
  br label %28, !dbg !913

; <label>:23:                                     ; preds = %7
  %24 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !914, !tbaa !761
  %25 = or i32 %24, 8, !dbg !914
  store volatile i32 %25, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !914, !tbaa !761
  %26 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !915, !tbaa !761
  %27 = and i32 %26, -3841, !dbg !915
  br label %28, !dbg !916

; <label>:28:                                     ; preds = %23, %18, %13
  %29 = phi i32 [ %27, %23 ], [ %22, %18 ], [ %17, %13 ]
  %30 = phi i8 [ 0, %23 ], [ 4, %18 ], [ 4, %13 ]
  store volatile i32 %29, i32* inttoptr (i32 72704 to i32*), align 1024, !tbaa !761
  br label %31, !dbg !904

; <label>:31:                                     ; preds = %35, %28
  %32 = phi i16 [ %36, %35 ], [ %1, %28 ]
  %33 = phi i8* [ %37, %35 ], [ %0, %28 ]
  tail call void @llvm.dbg.value(metadata i8 %30, i64 0, metadata !890, metadata !442), !dbg !904
  tail call void @llvm.dbg.value(metadata i8* %33, i64 0, metadata !887, metadata !442), !dbg !891
  tail call void @llvm.dbg.value(metadata i16 %32, i64 0, metadata !888, metadata !442), !dbg !892
  tail call void @llvm.dbg.value(metadata i16 %36, i64 0, metadata !888, metadata !442), !dbg !892
  %34 = icmp eq i16 %32, 0, !dbg !917
  br i1 %34, label %39, label %35, !dbg !917

; <label>:35:                                     ; preds = %31
  %36 = add i16 %32, -1, !dbg !918
  %37 = getelementptr inbounds i8, i8* %33, i32 1, !dbg !919
  tail call void @llvm.dbg.value(metadata i8* %37, i64 0, metadata !887, metadata !442), !dbg !891
  %38 = load i8, i8* %33, align 1, !dbg !921, !tbaa !554
  tail call void @spi_writebyte_dma(i8 zeroext %38) #15, !dbg !922
  br label %31, !dbg !917, !llvm.loop !923

; <label>:39:                                     ; preds = %31
  %40 = icmp eq i8 %30, 0, !dbg !926
  br i1 %40, label %44, label %41, !dbg !928

; <label>:41:                                     ; preds = %39
  %42 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !929, !tbaa !761
  %43 = and i32 %42, -3841, !dbg !929
  store volatile i32 %43, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !929, !tbaa !761
  br label %44, !dbg !931

; <label>:44:                                     ; preds = %41, %39
  ret i32 0, !dbg !932
}

; Function Attrs: minsize nounwind optsize
define internal i32 @spi_read_dma(i8* nocapture, i16 zeroext) #0 section ".spi_code" !dbg !933 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !935, metadata !442), !dbg !939
  tail call void @llvm.dbg.value(metadata i16 %1, i64 0, metadata !936, metadata !442), !dbg !940
  %3 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 8), align 4, !dbg !941, !tbaa !894
  %4 = icmp eq i32 %3, 0, !dbg !942
  br i1 %4, label %5, label %7, !dbg !942

; <label>:5:                                      ; preds = %2
  %6 = load volatile i32, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !943, !tbaa !898
  br label %7, !dbg !945

; <label>:7:                                      ; preds = %5, %2
  %8 = phi i32 [ %6, %5 ], [ %3, %2 ], !dbg !946
  %9 = lshr i32 %8, 8, !dbg !948
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !938, metadata !442), !dbg !949
  %10 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !950, !tbaa !761
  %11 = or i32 %10, 4096, !dbg !950
  store volatile i32 %11, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !950, !tbaa !761
  %12 = trunc i32 %9 to i4, !dbg !951
  switch i4 %12, label %23 [
    i4 3, label %13
    i4 5, label %13
    i4 7, label %13
    i4 -7, label %13
    i4 2, label %18
    i4 4, label %18
    i4 6, label %18
    i4 -8, label %18
  ], !dbg !951

; <label>:13:                                     ; preds = %7, %7, %7, %7
  %14 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !952, !tbaa !761
  %15 = and i32 %14, -1545, !dbg !952
  store volatile i32 %15, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !952, !tbaa !761
  %16 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !954, !tbaa !761
  %17 = or i32 %16, 2304, !dbg !954
  tail call void @llvm.dbg.value(metadata i8 4, i64 0, metadata !938, metadata !442), !dbg !949
  br label %28, !dbg !955

; <label>:18:                                     ; preds = %7, %7, %7, %7
  %19 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !956, !tbaa !761
  %20 = and i32 %19, -2825, !dbg !956
  store volatile i32 %20, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !956, !tbaa !761
  %21 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !957, !tbaa !761
  %22 = or i32 %21, 1024, !dbg !957
  tail call void @llvm.dbg.value(metadata i8 2, i64 0, metadata !938, metadata !442), !dbg !949
  br label %28, !dbg !958

; <label>:23:                                     ; preds = %7
  %24 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !959, !tbaa !761
  %25 = or i32 %24, 8, !dbg !959
  store volatile i32 %25, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !959, !tbaa !761
  %26 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !960, !tbaa !761
  %27 = and i32 %26, -3841, !dbg !960
  br label %28, !dbg !961

; <label>:28:                                     ; preds = %23, %18, %13
  %29 = phi i32 [ %27, %23 ], [ %22, %18 ], [ %17, %13 ]
  %30 = phi i8 [ 0, %23 ], [ 4, %18 ], [ 4, %13 ]
  store volatile i32 %29, i32* inttoptr (i32 72704 to i32*), align 1024, !tbaa !761
  br label %31, !dbg !949

; <label>:31:                                     ; preds = %35, %28
  %32 = phi i16 [ %36, %35 ], [ %1, %28 ]
  %33 = phi i8* [ %38, %35 ], [ %0, %28 ]
  tail call void @llvm.dbg.value(metadata i8 %30, i64 0, metadata !938, metadata !442), !dbg !949
  tail call void @llvm.dbg.value(metadata i8* %33, i64 0, metadata !935, metadata !442), !dbg !939
  tail call void @llvm.dbg.value(metadata i16 %32, i64 0, metadata !936, metadata !442), !dbg !940
  tail call void @llvm.dbg.value(metadata i16 %36, i64 0, metadata !936, metadata !442), !dbg !940
  %34 = icmp eq i16 %32, 0, !dbg !962
  br i1 %34, label %39, label %35, !dbg !962

; <label>:35:                                     ; preds = %31
  %36 = add i16 %32, -1, !dbg !963
  %37 = tail call zeroext i8 @spi_readbyte_dma() #15, !dbg !964
  store i8 %37, i8* %33, align 1, !dbg !966, !tbaa !554
  %38 = getelementptr inbounds i8, i8* %33, i32 1, !dbg !967
  tail call void @llvm.dbg.value(metadata i8* %38, i64 0, metadata !935, metadata !442), !dbg !939
  br label %31, !dbg !962, !llvm.loop !968

; <label>:39:                                     ; preds = %31
  %40 = icmp eq i8 %30, 0, !dbg !971
  br i1 %40, label %46, label %41, !dbg !973

; <label>:41:                                     ; preds = %39
  %42 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !974, !tbaa !761
  %43 = and i32 %42, -3841, !dbg !974
  store volatile i32 %43, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !974, !tbaa !761
  %44 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !976, !tbaa !761
  %45 = or i32 %44, 8, !dbg !976
  store volatile i32 %45, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !976, !tbaa !761
  br label %46, !dbg !977

; <label>:46:                                     ; preds = %41, %39
  ret i32 0, !dbg !978
}

; Function Attrs: minsize nounwind optsize readonly
define i32 @flash_addr2cpu_addr(i32) #4 section ".spi_code" !dbg !979 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !983, metadata !442), !dbg !984
  %2 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 7, i32 0), align 4, !dbg !985, !tbaa !986
  %3 = sub i32 %0, %2, !dbg !987
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !983, metadata !442), !dbg !984
  %4 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 7, i32 1), align 4, !dbg !988, !tbaa !989
  %5 = add i32 %3, %4, !dbg !990
  ret i32 %5, !dbg !991
}

; Function Attrs: minsize nounwind optsize readonly
define i32 @cpu_addr2flash_addr(i32) #4 section ".spi_code" !dbg !992 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !994, metadata !442), !dbg !995
  %2 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 7, i32 0), align 4, !dbg !996, !tbaa !986
  %3 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 7, i32 1), align 4, !dbg !997, !tbaa !989
  %4 = add i32 %2, %0, !dbg !998
  %5 = sub i32 %4, %3, !dbg !999
  ret i32 %5, !dbg !1000
}

; Function Attrs: alwaysinline minsize norecurse nounwind optsize
define i32 @get_sfc_status() local_unnamed_addr #5 !dbg !1001 {
  %1 = load volatile i8, i8* @sfc_is_busy, align 1, !dbg !1004, !tbaa !554
  %2 = zext i8 %1 to i32, !dbg !1004
  ret i32 %2, !dbg !1005
}

; Function Attrs: alwaysinline minsize nounwind optsize
define void @sfc_protect(i8 zeroext) #6 section ".spi_code" !dbg !1006 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1008, metadata !442), !dbg !1009
  store volatile i8 %0, i8* @sfc_is_busy, align 1, !dbg !1010, !tbaa !554
  ret void, !dbg !1011
}

; Function Attrs: minsize norecurse nounwind optsize readonly
define internal zeroext i8 @norflash_idle_query() #7 !dbg !1012 {
  %1 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1013, !tbaa !554
  %2 = icmp eq i8 %1, 0, !dbg !1014
  %3 = zext i1 %2 to i8, !dbg !1014
  ret i8 %3, !dbg !1015
}

; Function Attrs: minsize nounwind optsize
define void @sfc_drop_cache(i8*, i32) #0 section ".spi_code" !dbg !1016 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !1020, metadata !442), !dbg !1022
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1021, metadata !442), !dbg !1023
  tail call void @icache_flush(i8* %0, i32 %1) #15, !dbg !1024
  ret void, !dbg !1025
}

; Function Attrs: minsize nounwind optsize readnone
define void @sfc_suspend(i32) #8 section ".spi_code" !dbg !1026 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !1028, metadata !442), !dbg !1029
  ret void, !dbg !1030
}

; Function Attrs: minsize nounwind optsize readnone
define void @sfc_resume(i32) #8 section ".spi_code" !dbg !1031 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !1033, metadata !442), !dbg !1034
  ret void, !dbg !1035
}

; Function Attrs: minsize nounwind optsize
define internal void @enter_spi_code() #0 section ".spi_code" !dbg !1036 {
  %1 = tail call i32 @os_mutex_pend(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex, i32 0) #14, !dbg !1039
  %2 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1039, !tbaa !554
  %3 = add i8 %2, 1, !dbg !1039
  store i8 %3, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1039, !tbaa !554
  %4 = load i8, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 2), align 1, !dbg !1041, !tbaa !1043
  %5 = icmp eq i8 %4, 0, !dbg !1044
  br i1 %5, label %6, label %7, !dbg !1045

; <label>:6:                                      ; preds = %0
  tail call void @cpu_enter_sfc_critical(void (i8*)* null, i8* null) #15, !dbg !1046
  br label %7, !dbg !1048

; <label>:7:                                      ; preds = %6, %0
  tail call void @llvm.dbg.value(metadata i8 1, i64 0, metadata !1008, metadata !442), !dbg !1049
  store volatile i8 1, i8* @sfc_is_busy, align 1, !dbg !1051, !tbaa !554
  %8 = load volatile i32, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !1052, !tbaa !898
  store i32 %8, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 8), align 4, !dbg !1053, !tbaa !894
  %9 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !1054, !tbaa !761
  store i32 %9, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 9), align 4, !dbg !1055, !tbaa !1056
  %10 = load volatile i32, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !1057, !tbaa !898
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !1038, metadata !442), !dbg !1058
  tail call void asm sideeffect "csync;", ""() #13, !dbg !1059, !srcloc !1062
  br label %11, !dbg !1063

; <label>:11:                                     ; preds = %11, %7
  %12 = load volatile i32, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !1064, !tbaa !898
  %13 = icmp slt i32 %12, 0, !dbg !1066
  br i1 %13, label %11, label %14, !dbg !1066, !llvm.loop !1067

; <label>:14:                                     ; preds = %11
  store volatile i32 0, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !1069, !tbaa !898
  %15 = load volatile i32, i32* inttoptr (i32 331804 to i32*), align 4, !dbg !1070, !tbaa !742
  %16 = and i32 %15, -33, !dbg !1070
  store volatile i32 %16, i32* inttoptr (i32 331804 to i32*), align 4, !dbg !1070, !tbaa !742
  store volatile i32 0, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !1071, !tbaa !761
  %17 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !1072, !tbaa !1073
  %18 = icmp ne i32 %17, 0, !dbg !1074
  %19 = select i1 %18, i32 %17, i32 4137, !dbg !1074
  store volatile i32 %19, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !1075, !tbaa !761
  tail call void asm sideeffect "csync;", ""() #13, !dbg !1077, !srcloc !1080
  ret void, !dbg !1081
}

; Function Attrs: minsize optsize
declare i32 @os_mutex_pend(%struct.xSTATIC_QUEUE*, i32) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define internal void @exit_spi_code(i32) #0 section ".spi_code" !dbg !1082 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !1084, metadata !442), !dbg !1086
  %2 = trunc i32 %0 to i8, !dbg !1087
  tail call void @llvm.dbg.value(metadata i8 %2, i64 0, metadata !1008, metadata !442), !dbg !1088
  store volatile i8 %2, i8* @sfc_is_busy, align 1, !dbg !1090, !tbaa !554
  %3 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 8), align 4, !dbg !1091, !tbaa !894
  %4 = icmp eq i32 %3, 0, !dbg !1092
  br i1 %4, label %5, label %7, !dbg !1092

; <label>:5:                                      ; preds = %1
  %6 = load volatile i32, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !1093, !tbaa !898
  br label %7, !dbg !1095

; <label>:7:                                      ; preds = %5, %1
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !1085, metadata !442), !dbg !1096
  %8 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 9), align 4, !dbg !1097, !tbaa !1056
  store volatile i32 %8, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !1098, !tbaa !761
  %9 = load volatile i32, i32* inttoptr (i32 331804 to i32*), align 4, !dbg !1099, !tbaa !742
  %10 = or i32 %9, 32, !dbg !1099
  store volatile i32 %10, i32* inttoptr (i32 331804 to i32*), align 4, !dbg !1099, !tbaa !742
  tail call void asm sideeffect "csync;", ""() #13, !dbg !1100, !srcloc !1103
  br label %11, !dbg !1104

; <label>:11:                                     ; preds = %11, %7
  %12 = load volatile i32, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !1105, !tbaa !898
  %13 = icmp slt i32 %12, 0, !dbg !1106
  br i1 %13, label %11, label %14, !dbg !1106, !llvm.loop !1107

; <label>:14:                                     ; preds = %11
  %15 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 8), align 4, !dbg !1109, !tbaa !894
  store volatile i32 %15, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !1110, !tbaa !898
  store i32 0, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 8), align 4, !dbg !1111, !tbaa !894
  tail call void asm sideeffect "csync;", ""() #13, !dbg !1112, !srcloc !1115
  %16 = load i8, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 2), align 1, !dbg !1116, !tbaa !1043
  %17 = icmp eq i8 %16, 0, !dbg !1118
  br i1 %17, label %18, label %19, !dbg !1119

; <label>:18:                                     ; preds = %14
  tail call void @cpu_exit_sfc_critical() #15, !dbg !1120
  br label %19, !dbg !1122

; <label>:19:                                     ; preds = %18, %14
  %20 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1123, !tbaa !554
  %21 = add i8 %20, -1, !dbg !1123
  store i8 %21, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1123, !tbaa !554
  %22 = tail call i32 @os_mutex_post(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex) #14, !dbg !1123
  ret void, !dbg !1125
}

; Function Attrs: minsize optsize
declare i32 @os_mutex_post(%struct.xSTATIC_QUEUE*) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define internal void @norflash_write_enable() #0 section ".spi_code" !dbg !1126 {
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1127
  tail call void @spi_writebyte(i8 zeroext 6) #15, !dbg !1128
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1129
  ret void, !dbg !1130
}

; Function Attrs: minsize nounwind optsize
define internal void @norflash_send_addr(i32) #0 section ".spi_code" !dbg !1131 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !1133, metadata !442), !dbg !1134
  %2 = load volatile i8, i8* @is4byte_mode, align 1, !dbg !1135, !tbaa !554
  %3 = icmp eq i8 %2, 0, !dbg !1135
  br i1 %3, label %7, label %4, !dbg !1137

; <label>:4:                                      ; preds = %1
  %5 = lshr i32 %0, 24, !dbg !1138
  %6 = trunc i32 %5 to i8, !dbg !1140
  tail call void @spi_writebyte(i8 zeroext %6) #15, !dbg !1141
  br label %7, !dbg !1142

; <label>:7:                                      ; preds = %4, %1
  %8 = lshr i32 %0, 16, !dbg !1143
  %9 = trunc i32 %8 to i8, !dbg !1144
  tail call void @spi_writebyte(i8 zeroext %9) #15, !dbg !1145
  %10 = lshr i32 %0, 8, !dbg !1146
  %11 = trunc i32 %10 to i8, !dbg !1147
  tail call void @spi_writebyte(i8 zeroext %11) #15, !dbg !1148
  %12 = trunc i32 %0 to i8, !dbg !1149
  tail call void @spi_writebyte(i8 zeroext %12) #15, !dbg !1150
  ret void, !dbg !1151
}

; Function Attrs: minsize nounwind optsize
define internal i32 @norflash_is_busy() #0 section ".spi_code" !dbg !1152 {
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1155
  tail call void @spi_writebyte(i8 zeroext 5) #15, !dbg !1156
  %1 = tail call zeroext i8 @spi_readbyte() #15, !dbg !1157
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1158
  %2 = and i8 %1, 1, !dbg !1159
  %3 = zext i8 %2 to i32, !dbg !1159
  ret i32 %3, !dbg !1160
}

; Function Attrs: minsize nounwind optsize
define internal void @norflash_suspend() #0 section ".spi_code" !dbg !1161 {
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1162
  tail call void @spi_writebyte(i8 zeroext 117) #15, !dbg !1163
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1164
  ret void, !dbg !1165
}

; Function Attrs: minsize nounwind optsize
define internal void @norflash_resume() #0 section ".spi_code" !dbg !1166 {
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1167
  tail call void @spi_writebyte(i8 zeroext 122) #15, !dbg !1168
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1169
  ret void, !dbg !1170
}

; Function Attrs: minsize nounwind optsize
define internal i32 @norflash_wait_ok() #0 section ".spi_code" !dbg !1171 {
  %1 = alloca i32, align 4
  %2 = bitcast i32* %1 to i8*, !dbg !1176
  call void @llvm.lifetime.start(i64 4, i8* nonnull %2), !dbg !1176
  tail call void @llvm.dbg.value(metadata i32 5000000, i64 0, metadata !1173, metadata !442), !dbg !1177
  store volatile i32 300000, i32* %1, align 4, !dbg !1177
  br label %3, !dbg !1178

; <label>:3:                                      ; preds = %10, %0
  %4 = load volatile i32, i32* %1, align 4, !dbg !1179
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !1173, metadata !442), !dbg !1177
  %5 = icmp eq i32 %4, 0, !dbg !1181
  br i1 %5, label %13, label %6, !dbg !1181

; <label>:6:                                      ; preds = %3
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1182
  tail call void @spi_writebyte(i8 zeroext 5) #15, !dbg !1183
  %7 = tail call zeroext i8 @spi_readbyte() #15, !dbg !1184
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1185
  %8 = and i8 %7, 1, !dbg !1186
  %9 = icmp eq i8 %8, 0, !dbg !1186
  br i1 %9, label %13, label %10, !dbg !1188

; <label>:10:                                     ; preds = %6
  %11 = load volatile i32, i32* %1, align 4, !dbg !1189
  tail call void @llvm.dbg.value(metadata i32 %11, i64 0, metadata !1173, metadata !442), !dbg !1177
  %12 = add i32 %11, -1, !dbg !1189
  tail call void @llvm.dbg.value(metadata i32 %12, i64 0, metadata !1173, metadata !442), !dbg !1177
  store volatile i32 %12, i32* %1, align 4, !dbg !1189
  br label %3

; <label>:13:                                     ; preds = %6, %3
  %14 = load volatile i32, i32* %1, align 4, !dbg !1190
  tail call void @llvm.dbg.value(metadata i32 %14, i64 0, metadata !1173, metadata !442), !dbg !1177
  %15 = icmp eq i32 %14, 0, !dbg !1192
  br i1 %15, label %16, label %17, !dbg !1193

; <label>:16:                                     ; preds = %13
  tail call void @putbyte(i8 signext 101) #14, !dbg !1194
  tail call void @putbyte(i8 signext 114) #14, !dbg !1196
  tail call void @putbyte(i8 signext 114) #14, !dbg !1197
  tail call void @putbyte(i8 signext 32) #14, !dbg !1198
  tail call void @putbyte(i8 signext 115) #14, !dbg !1199
  tail call void @putbyte(i8 signext 112) #14, !dbg !1200
  tail call void @putbyte(i8 signext 105) #14, !dbg !1201
  tail call void @putbyte(i8 signext 32) #14, !dbg !1202
  tail call void @putbyte(i8 signext 116) #14, !dbg !1203
  tail call void @putbyte(i8 signext 111) #14, !dbg !1204
  tail call void @putbyte(i8 signext 13) #14, !dbg !1205
  tail call void @putbyte(i8 signext 10) #14, !dbg !1206
  br label %17, !dbg !1207

; <label>:17:                                     ; preds = %16, %13
  %18 = phi i32 [ -1, %16 ], [ 0, %13 ]
  call void @llvm.lifetime.end(i64 4, i8* nonnull %2), !dbg !1208
  ret i32 %18, !dbg !1208
}

; Function Attrs: minsize nounwind optsize
define internal i32 @__norflash_read(i8* nocapture, i32, i16 zeroext, i32) #0 section ".spi_code" !dbg !1209 {
  %5 = alloca [4 x i8], align 1
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !1213, metadata !442), !dbg !1222
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1214, metadata !442), !dbg !1223
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !1215, metadata !442), !dbg !1224
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !1216, metadata !442), !dbg !1225
  %6 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 8), align 4, !dbg !1226, !tbaa !894
  %7 = icmp eq i32 %6, 0, !dbg !1227
  br i1 %7, label %8, label %10, !dbg !1227

; <label>:8:                                      ; preds = %4
  %9 = load volatile i32, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !1228, !tbaa !898
  br label %10, !dbg !1230

; <label>:10:                                     ; preds = %8, %4
  %11 = phi i32 [ %9, %8 ], [ %6, %4 ], !dbg !1231
  %12 = lshr i32 %11, 8, !dbg !1233
  %13 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 0, !dbg !1234
  call void @llvm.lifetime.start(i64 4, i8* nonnull %13) #13, !dbg !1234
  tail call void @llvm.dbg.declare(metadata [4 x i8]* %5, metadata !1218, metadata !442), !dbg !1235
  %14 = trunc i32 %12 to i4, !dbg !1236
  switch i4 %14, label %80 [
    i4 0, label %15
    i4 1, label %17
    i4 4, label %20
    i4 6, label %31
    i4 2, label %45
    i4 3, label %48
    i4 5, label %51
    i4 7, label %63
  ], !dbg !1236

; <label>:15:                                     ; preds = %10
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1237
  tail call void @spi_writebyte(i8 zeroext 3) #15, !dbg !1239
  tail call void @norflash_send_addr(i32 %1) #15, !dbg !1240
  %16 = tail call i32 @spi_read_dma(i8* %0, i16 zeroext %2) #15, !dbg !1241
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1242
  br label %78, !dbg !1243

; <label>:17:                                     ; preds = %10
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1244
  tail call void @spi_writebyte(i8 zeroext 11) #15, !dbg !1245
  tail call void @norflash_send_addr(i32 %1) #15, !dbg !1246
  %18 = tail call zeroext i8 @spi_readbyte() #15, !dbg !1247
  %19 = tail call i32 @spi_read_dma(i8* %0, i16 zeroext %2) #15, !dbg !1248
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1249
  br label %78, !dbg !1250

; <label>:20:                                     ; preds = %10
  %21 = lshr i32 %1, 16, !dbg !1251
  %22 = trunc i32 %21 to i8, !dbg !1252
  store i8 %22, i8* %13, align 1, !dbg !1253, !tbaa !554
  %23 = lshr i32 %1, 8, !dbg !1254
  %24 = trunc i32 %23 to i8, !dbg !1255
  %25 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 1, !dbg !1256
  store i8 %24, i8* %25, align 1, !dbg !1257, !tbaa !554
  %26 = trunc i32 %1 to i8, !dbg !1258
  %27 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 2, !dbg !1259
  store i8 %26, i8* %27, align 1, !dbg !1260, !tbaa !554
  %28 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 3, !dbg !1261
  store i8 0, i8* %28, align 1, !dbg !1262, !tbaa !554
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1263
  tail call void @spi_writebyte(i8 zeroext -69) #15, !dbg !1264
  %29 = call i32 @spi_write_dma(i8* nonnull %13, i16 zeroext 4) #15, !dbg !1265
  %30 = tail call i32 @spi_read_dma(i8* %0, i16 zeroext %2) #15, !dbg !1266
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1267
  br label %78, !dbg !1268

; <label>:31:                                     ; preds = %10
  %32 = lshr i32 %1, 16, !dbg !1269
  %33 = trunc i32 %32 to i8, !dbg !1270
  store i8 %33, i8* %13, align 1, !dbg !1271, !tbaa !554
  %34 = lshr i32 %1, 8, !dbg !1272
  %35 = trunc i32 %34 to i8, !dbg !1273
  %36 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 1, !dbg !1274
  store i8 %35, i8* %36, align 1, !dbg !1275, !tbaa !554
  %37 = trunc i32 %1 to i8, !dbg !1276
  %38 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 2, !dbg !1277
  store i8 %37, i8* %38, align 1, !dbg !1278, !tbaa !554
  %39 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 3, !dbg !1279
  store i8 -96, i8* %39, align 1, !dbg !1280, !tbaa !554
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1281
  %40 = icmp eq i32 %3, 0, !dbg !1282
  br i1 %40, label %42, label %41, !dbg !1284

; <label>:41:                                     ; preds = %31
  tail call void @spi_writebyte(i8 zeroext -69) #15, !dbg !1285
  br label %42, !dbg !1287

; <label>:42:                                     ; preds = %41, %31
  %43 = call i32 @spi_write_dma(i8* nonnull %13, i16 zeroext 4) #15, !dbg !1288
  %44 = tail call i32 @spi_read_dma(i8* %0, i16 zeroext %2) #15, !dbg !1289
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1290
  br label %78, !dbg !1291

; <label>:45:                                     ; preds = %10
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1292
  tail call void @spi_writebyte(i8 zeroext 59) #15, !dbg !1293
  tail call void @norflash_send_addr(i32 %1) #15, !dbg !1294
  %46 = call i32 @spi_read_dma(i8* nonnull %13, i16 zeroext 2) #15, !dbg !1295
  %47 = tail call i32 @spi_read_dma(i8* %0, i16 zeroext %2) #15, !dbg !1296
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1297
  br label %78, !dbg !1298

; <label>:48:                                     ; preds = %10
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1299
  tail call void @spi_writebyte(i8 zeroext 107) #15, !dbg !1300
  tail call void @norflash_send_addr(i32 %1) #15, !dbg !1301
  %49 = call i32 @spi_read_dma(i8* nonnull %13, i16 zeroext 4) #15, !dbg !1302
  %50 = tail call i32 @spi_read_dma(i8* %0, i16 zeroext %2) #15, !dbg !1303
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1304
  br label %78, !dbg !1305

; <label>:51:                                     ; preds = %10
  %52 = lshr i32 %1, 16, !dbg !1306
  %53 = trunc i32 %52 to i8, !dbg !1307
  store i8 %53, i8* %13, align 1, !dbg !1308, !tbaa !554
  %54 = lshr i32 %1, 8, !dbg !1309
  %55 = trunc i32 %54 to i8, !dbg !1310
  %56 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 1, !dbg !1311
  store i8 %55, i8* %56, align 1, !dbg !1312, !tbaa !554
  %57 = trunc i32 %1 to i8, !dbg !1313
  %58 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 2, !dbg !1314
  store i8 %57, i8* %58, align 1, !dbg !1315, !tbaa !554
  %59 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 3, !dbg !1316
  store i8 0, i8* %59, align 1, !dbg !1317, !tbaa !554
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1318
  tail call void @spi_writebyte(i8 zeroext -21) #15, !dbg !1319
  %60 = call i32 @spi_write_dma(i8* nonnull %13, i16 zeroext 4) #15, !dbg !1320
  %61 = call i32 @spi_read_dma(i8* nonnull %13, i16 zeroext 2) #15, !dbg !1321
  %62 = tail call i32 @spi_read_dma(i8* %0, i16 zeroext %2) #15, !dbg !1322
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1323
  br label %78, !dbg !1324

; <label>:63:                                     ; preds = %10
  %64 = lshr i32 %1, 16, !dbg !1325
  %65 = trunc i32 %64 to i8, !dbg !1326
  store i8 %65, i8* %13, align 1, !dbg !1327, !tbaa !554
  %66 = lshr i32 %1, 8, !dbg !1328
  %67 = trunc i32 %66 to i8, !dbg !1329
  %68 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 1, !dbg !1330
  store i8 %67, i8* %68, align 1, !dbg !1331, !tbaa !554
  %69 = trunc i32 %1 to i8, !dbg !1332
  %70 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 2, !dbg !1333
  store i8 %69, i8* %70, align 1, !dbg !1334, !tbaa !554
  %71 = getelementptr inbounds [4 x i8], [4 x i8]* %5, i32 0, i32 3, !dbg !1335
  store i8 -96, i8* %71, align 1, !dbg !1336, !tbaa !554
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1337
  %72 = icmp eq i32 %3, 0, !dbg !1338
  br i1 %72, label %74, label %73, !dbg !1340

; <label>:73:                                     ; preds = %63
  tail call void @spi_writebyte(i8 zeroext -21) #15, !dbg !1341
  br label %74, !dbg !1343

; <label>:74:                                     ; preds = %73, %63
  %75 = call i32 @spi_write_dma(i8* nonnull %13, i16 zeroext 4) #15, !dbg !1344
  %76 = call i32 @spi_read_dma(i8* nonnull %13, i16 zeroext 2) #15, !dbg !1345
  %77 = tail call i32 @spi_read_dma(i8* %0, i16 zeroext %2) #15, !dbg !1346
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1347
  br label %78, !dbg !1348

; <label>:78:                                     ; preds = %74, %51, %48, %45, %42, %20, %17, %15
  %79 = zext i16 %2 to i32, !dbg !1349
  br label %80, !dbg !1350

; <label>:80:                                     ; preds = %78, %10
  %81 = phi i32 [ %79, %78 ], [ -1, %10 ]
  call void @llvm.lifetime.end(i64 4, i8* nonnull %13) #13, !dbg !1351
  ret i32 %81, !dbg !1351
}

; Function Attrs: minsize nounwind optsize
define internal i32 @exit_continue_mode() #0 section ".spi_code" !dbg !1352 {
  %1 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 8), align 4, !dbg !1356, !tbaa !894
  %2 = icmp eq i32 %1, 0, !dbg !1357
  br i1 %2, label %3, label %5, !dbg !1357

; <label>:3:                                      ; preds = %0
  %4 = load volatile i32, i32* inttoptr (i32 262656 to i32*), align 512, !dbg !1358, !tbaa !898
  br label %5, !dbg !1360

; <label>:5:                                      ; preds = %3, %0
  %6 = phi i32 [ %4, %3 ], [ %1, %0 ], !dbg !1361
  %7 = lshr i32 %6, 8, !dbg !1363
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !1355, metadata !442), !dbg !1364
  %8 = trunc i32 %7 to i4, !dbg !1365
  switch i4 %8, label %11 [
    i4 7, label %9
    i4 6, label %10
  ], !dbg !1365

; <label>:9:                                      ; preds = %5
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1366
  tail call void @spi_writebyte(i8 zeroext -1) #15, !dbg !1369
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1370
  tail call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !1355, metadata !442), !dbg !1364
  br label %11, !dbg !1371

; <label>:10:                                     ; preds = %5
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1372
  tail call void @spi_writebyte(i8 zeroext -1) #15, !dbg !1375
  tail call void @spi_writebyte(i8 zeroext -1) #15, !dbg !1376
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1377
  tail call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !1355, metadata !442), !dbg !1364
  br label %11, !dbg !1378

; <label>:11:                                     ; preds = %10, %9, %5
  %12 = phi i32 [ 1, %9 ], [ 1, %10 ], [ 0, %5 ]
  tail call void @llvm.dbg.value(metadata i32 %12, i64 0, metadata !1355, metadata !442), !dbg !1364
  ret i32 %12, !dbg !1379
}

; Function Attrs: minsize nounwind optsize
define internal void @enter_continue_mode() #0 section ".spi_code" !dbg !1380 {
  %1 = alloca i32, align 4
  %2 = bitcast i32* %1 to i8*, !dbg !1383
  call void @llvm.lifetime.start(i64 4, i8* nonnull %2) #13, !dbg !1383
  %3 = call i32 @__norflash_read(i8* nonnull %2, i32 0, i16 zeroext 1, i32 1) #15, !dbg !1384
  call void @llvm.lifetime.end(i64 4, i8* nonnull %2) #13, !dbg !1385
  ret void, !dbg !1385
}

; Function Attrs: minsize nounwind optsize
define void @norflash_enter_spi_code() #0 section ".spi_code" !dbg !1386 {
  tail call void @enter_spi_code() #15, !dbg !1387
  %1 = tail call i32 @exit_continue_mode() #15, !dbg !1388
  store i32 %1, i32* @spi_is_no_cmd, align 4, !dbg !1389, !tbaa !538
  ret void, !dbg !1390
}

; Function Attrs: minsize nounwind optsize
define void @norflash_exit_spi_code() #0 section ".spi_code" !dbg !1391 {
  %1 = load i32, i32* @spi_is_no_cmd, align 4, !dbg !1392, !tbaa !538
  %2 = icmp eq i32 %1, 0, !dbg !1392
  br i1 %2, label %4, label %3, !dbg !1394

; <label>:3:                                      ; preds = %0
  tail call void @enter_continue_mode() #15, !dbg !1395
  br label %4, !dbg !1397

; <label>:4:                                      ; preds = %3, %0
  tail call void @exit_spi_code(i32 0) #15, !dbg !1398
  ret void, !dbg !1399
}

; Function Attrs: minsize nounwind optsize
define void @norflash_spi_cs(i8 signext) #0 section ".spi_code" !dbg !1400 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1402, metadata !442), !dbg !1403
  tail call void @spi_cs(i8 zeroext %0) #15, !dbg !1404
  ret void, !dbg !1405
}

; Function Attrs: minsize nounwind optsize
define void @norflash_spi_write_byte(i8 zeroext) #0 section ".spi_code" !dbg !1406 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1410, metadata !442), !dbg !1411
  tail call void @spi_writebyte(i8 zeroext %0) #15, !dbg !1412
  ret void, !dbg !1413
}

; Function Attrs: minsize nounwind optsize
define zeroext i8 @norflash_spi_read_byte() #0 section ".spi_code" !dbg !1414 {
  %1 = tail call zeroext i8 @spi_readbyte() #15, !dbg !1415
  ret i8 %1, !dbg !1416
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_wait_busy() #0 section ".spi_code" !dbg !1417 {
  %1 = tail call i32 @norflash_wait_ok() #15, !dbg !1418
  ret i32 %1, !dbg !1419
}

; Function Attrs: minsize nounwind optsize
define internal i32 @_norflash_read(i8* nocapture, i32, i32 returned) #0 section ".spi_code" !dbg !1420 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !1424, metadata !442), !dbg !1427
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1425, metadata !442), !dbg !1428
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1426, metadata !442), !dbg !1429
  tail call void @enter_spi_code() #15, !dbg !1430
  %4 = add i32 %2, %1, !dbg !1431
  tail call void @spiflash_enter_4byte_addr(i32 %4) #15, !dbg !1432
  %5 = trunc i32 %2 to i16, !dbg !1433
  %6 = tail call i32 @__norflash_read(i8* %0, i32 %1, i16 zeroext %5, i32 0) #15, !dbg !1434
  tail call void @spiflash_exit_4byte_addr(i32 %4) #15, !dbg !1435
  tail call void @exit_spi_code(i32 0) #15, !dbg !1436
  ret i32 %2, !dbg !1437
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_origin_read(i8* nocapture, i32, i32) local_unnamed_addr #0 !dbg !1438 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !1440, metadata !442), !dbg !1443
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1441, metadata !442), !dbg !1444
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1442, metadata !442), !dbg !1445
  %4 = tail call i32 @_norflash_read(i8* %0, i32 %1, i32 %2) #15, !dbg !1446
  ret i32 %4, !dbg !1447
}

; Function Attrs: minsize nounwind optsize
define void @norflash_set_write_cpu_hold(i8 zeroext) local_unnamed_addr #0 !dbg !1448 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1450, metadata !442), !dbg !1451
  %2 = icmp eq i8 %0, 0, !dbg !1452
  %3 = zext i1 %2 to i8, !dbg !1452
  store i8 %3, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 2), align 1, !dbg !1453, !tbaa !1043
  ret void, !dbg !1454
}

; Function Attrs: minsize nounwind optsize
define weak i32 @norflash_calc_capacity(i32) #0 section ".spi_code" !dbg !1455 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !1457, metadata !442), !dbg !1459
  %2 = and i32 %0, 255, !dbg !1460
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1458, metadata !442), !dbg !1461
  %3 = icmp ugt i32 %2, 47, !dbg !1462
  br i1 %3, label %4, label %6, !dbg !1464

; <label>:4:                                      ; preds = %1
  %5 = add nsw i32 %2, -32, !dbg !1465
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !1458, metadata !442), !dbg !1461
  br label %10, !dbg !1467

; <label>:6:                                      ; preds = %1
  %7 = icmp ugt i32 %2, 31, !dbg !1468
  %8 = add nsw i32 %2, -6, !dbg !1471
  tail call void @llvm.dbg.value(metadata i32 %8, i64 0, metadata !1458, metadata !442), !dbg !1461
  %9 = select i1 %7, i32 %8, i32 %2, !dbg !1473
  br label %10, !dbg !1473

; <label>:10:                                     ; preds = %6, %4
  %11 = phi i32 [ %5, %4 ], [ %9, %6 ]
  tail call void @llvm.dbg.value(metadata i32 %11, i64 0, metadata !1458, metadata !442), !dbg !1461
  %12 = add nsw i32 %11, -16, !dbg !1475
  %13 = shl i32 65536, %12, !dbg !1476
  ret i32 %13, !dbg !1477
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_init(%struct.dev_node* nocapture readnone, i8* nocapture readnone) local_unnamed_addr #0 !dbg !1478 {
  tail call void @llvm.dbg.value(metadata %struct.dev_node* %0, i64 0, metadata !1536, metadata !442), !dbg !1538
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !1537, metadata !442), !dbg !1539
  %3 = load i8, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 1), align 4, !dbg !1540, !tbaa !1542
  %4 = icmp eq i8 %3, 0, !dbg !1543
  br i1 %4, label %5, label %36, !dbg !1544

; <label>:5:                                      ; preds = %2
  %6 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !1545, !tbaa !761
  %7 = and i32 %6, -9, !dbg !1545
  store volatile i32 %7, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !1545, !tbaa !761
  %8 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !1546, !tbaa !761
  %9 = and i32 %8, -3073, !dbg !1546
  store volatile i32 %9, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !1546, !tbaa !761
  %10 = load volatile i32, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !1547, !tbaa !761
  %11 = or i32 %10, 24576, !dbg !1547
  store volatile i32 %11, i32* inttoptr (i32 72704 to i32*), align 1024, !dbg !1547, !tbaa !761
  %12 = load volatile i32, i32* inttoptr (i32 331804 to i32*), align 4, !dbg !1548, !tbaa !742
  %13 = and i32 %12, -524289, !dbg !1548
  store volatile i32 %13, i32* inttoptr (i32 331804 to i32*), align 4, !dbg !1548, !tbaa !742
  tail call void @request_irq(i8 zeroext 125, i8 zeroext 7, void ()* nonnull @another_cpu_irq, i8 zeroext 0) #14, !dbg !1549
  tail call void @request_irq(i8 zeroext 124, i8 zeroext 7, void ()* nonnull @another_cpu_irq, i8 zeroext 1) #14, !dbg !1552
  %14 = tail call i32 @os_mutex_create(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex) #14, !dbg !1553
  %15 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !1554, !tbaa !842
  %16 = icmp eq i32 %15, 0, !dbg !1556
  br i1 %16, label %17, label %20, !dbg !1557

; <label>:17:                                     ; preds = %5
  tail call void @read_flash_id() #15, !dbg !1558
  %18 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !1560, !tbaa !1561
  %19 = tail call i32 @norflash_calc_capacity(i32 %18) #15, !dbg !1562
  store i32 %19, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !1563, !tbaa !842
  br label %20, !dbg !1564

; <label>:20:                                     ; preds = %17, %5
  store i8 1, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 1), align 4, !dbg !1565, !tbaa !1542
  %21 = load i32, i32* @norflash_write_cpu_unhold, align 4, !dbg !1566, !tbaa !538
  %22 = trunc i32 %21 to i8, !dbg !1566
  store i8 %22, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 2), align 1, !dbg !1567, !tbaa !1043
  tail call void @flash_write_protect_init() #15, !dbg !1568
  %23 = load i32, i32* @norflash_write_readback_check_en, align 4, !dbg !1569, !tbaa !538
  %24 = icmp eq i32 %23, 0, !dbg !1569
  br i1 %24, label %36, label %25, !dbg !1571

; <label>:25:                                     ; preds = %20
  %26 = tail call i8* @malloc(i32 512) #15, !dbg !1572
  store i8* %26, i8** getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 13), align 4, !dbg !1574, !tbaa !1575
  %27 = icmp eq i8* %26, null, !dbg !1576
  br i1 %27, label %32, label %28, !dbg !1578

; <label>:28:                                     ; preds = %25
  %29 = load i8, i8* @log_tag_const_i_VM, align 1, !dbg !1579, !tbaa !554
  %30 = icmp eq i8 %29, 0, !dbg !1579
  br i1 %30, label %36, label %31, !dbg !1582

; <label>:31:                                     ; preds = %28
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([51 x i8], [51 x i8]* @.str.1, i32 0, i32 0), i32 512) #14, !dbg !1583
  br label %36, !dbg !1583

; <label>:32:                                     ; preds = %25
  %33 = load i8, i8* @log_tag_const_e_VM, align 1, !dbg !1585, !tbaa !554
  %34 = icmp eq i8 %33, 0, !dbg !1585
  br i1 %34, label %36, label %35, !dbg !1588

; <label>:35:                                     ; preds = %32
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.2, i32 0, i32 0)) #14, !dbg !1589
  br label %36, !dbg !1589

; <label>:36:                                     ; preds = %35, %32, %31, %28, %20, %2
  %37 = phi i32 [ 0, %2 ], [ select (i1 icmp ugt (i32 sub (i32 ptrtoint (i32* @_SPI_CODE_END to i32), i32 ptrtoint (i32* @_SPI_CODE_START to i32)), i32 4096), i32 1, i32 0), %28 ], [ select (i1 icmp ugt (i32 sub (i32 ptrtoint (i32* @_SPI_CODE_END to i32), i32 ptrtoint (i32* @_SPI_CODE_START to i32)), i32 4096), i32 1, i32 0), %32 ], [ select (i1 icmp ugt (i32 sub (i32 ptrtoint (i32* @_SPI_CODE_END to i32), i32 ptrtoint (i32* @_SPI_CODE_START to i32)), i32 4096), i32 1, i32 0), %20 ], [ select (i1 icmp ugt (i32 sub (i32 ptrtoint (i32* @_SPI_CODE_END to i32), i32 ptrtoint (i32* @_SPI_CODE_START to i32)), i32 4096), i32 1, i32 0), %31 ], [ select (i1 icmp ugt (i32 sub (i32 ptrtoint (i32* @_SPI_CODE_END to i32), i32 ptrtoint (i32* @_SPI_CODE_START to i32)), i32 4096), i32 1, i32 0), %35 ]
  ret i32 %37, !dbg !1591
}

; Function Attrs: minsize optsize
declare i32 @os_mutex_create(%struct.xSTATIC_QUEUE*) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define void @flash_write_protect_init() #0 section ".spi_code" !dbg !1592 {
  tail call void @enter_spi_code() #15, !dbg !1596
  %1 = tail call i32 @exit_continue_mode() #15, !dbg !1597
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1594, metadata !442), !dbg !1598
  %2 = tail call zeroext i16 @norflash_read_sr() #15, !dbg !1599
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !1595, metadata !442), !dbg !1600
  %3 = and i16 %2, 16892, !dbg !1601
  %4 = zext i16 %3 to i32, !dbg !1601
  store i32 %4, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 11), align 4, !dbg !1602, !tbaa !1603
  %5 = icmp eq i32 %1, 0, !dbg !1604
  br i1 %5, label %7, label %6, !dbg !1606

; <label>:6:                                      ; preds = %0
  tail call void @enter_continue_mode() #15, !dbg !1607
  br label %7, !dbg !1609

; <label>:7:                                      ; preds = %6, %0
  tail call void @exit_spi_code(i32 0) #15, !dbg !1610
  ret void, !dbg !1611
}

; Function Attrs: minsize nounwind optsize
declare noalias i8* @malloc(i32) local_unnamed_addr #9

; Function Attrs: minsize optsize
declare void @log_print(i32, i8*, i8*, ...) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define i32 @norflash_open(i8* nocapture readnone, %struct.device** nocapture readnone, i8* nocapture readnone) local_unnamed_addr #0 !dbg !1612 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !1614, metadata !442), !dbg !1617
  tail call void @llvm.dbg.value(metadata %struct.device** %1, i64 0, metadata !1615, metadata !442), !dbg !1618
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !1616, metadata !442), !dbg !1619
  %4 = load i8, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 1), align 4, !dbg !1620, !tbaa !1542
  %5 = icmp eq i8 %4, 0, !dbg !1622
  br i1 %5, label %6, label %8, !dbg !1623

; <label>:6:                                      ; preds = %3
  %7 = tail call i32 @norflash_init(%struct.dev_node* undef, i8* undef) #15, !dbg !1624
  br label %8, !dbg !1626

; <label>:8:                                      ; preds = %6, %3
  ret i32 select (i1 icmp ugt (i32 sub (i32 ptrtoint (i32* @_SPI_CODE_END to i32), i32 ptrtoint (i32* @_SPI_CODE_START to i32)), i32 4096), i32 1, i32 0), !dbg !1627
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_read(%struct.device* nocapture readnone, i8*, i32 returned, i32) local_unnamed_addr #0 !dbg !1628 {
  tail call void @llvm.dbg.value(metadata %struct.device* %0, i64 0, metadata !1630, metadata !442), !dbg !1634
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !1631, metadata !442), !dbg !1635
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1632, metadata !442), !dbg !1636
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !1633, metadata !442), !dbg !1637
  %5 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 7, i32 0), align 4, !dbg !1638, !tbaa !986
  %6 = icmp ugt i32 %5, %3, !dbg !1640
  br i1 %6, label %7, label %9, !dbg !1641

; <label>:7:                                      ; preds = %4
  %8 = add i32 %3, %2, !dbg !1642
  br label %15, !dbg !1645

; <label>:9:                                      ; preds = %4
  %10 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !1647, !tbaa !842
  %11 = icmp ugt i32 %10, 16777216, !dbg !1648
  %12 = add i32 %3, %2, !dbg !1649
  %13 = icmp ugt i32 %12, 16773120, !dbg !1650
  %14 = and i1 %13, %11, !dbg !1651
  br i1 %14, label %15, label %30, !dbg !1651

; <label>:15:                                     ; preds = %9, %7
  %16 = phi i32 [ %8, %7 ], [ %12, %9 ], !dbg !1652
  %17 = tail call i32 @os_mutex_pend(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex, i32 0) #14, !dbg !1654
  %18 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1654, !tbaa !554
  %19 = add i8 %18, 1, !dbg !1654
  store i8 %19, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1654, !tbaa !554
  %20 = tail call i32 @_norflash_read(i8* %1, i32 %3, i32 %2) #15, !dbg !1656
  %21 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 6, i32 1), align 4, !dbg !1657, !tbaa !1658
  %22 = icmp ugt i32 %16, %21, !dbg !1659
  br i1 %22, label %26, label %23, !dbg !1660

; <label>:23:                                     ; preds = %15
  %24 = tail call i32 @get_system_enc_key() #14, !dbg !1662
  %25 = trunc i32 %24 to i16, !dbg !1662
  tail call void @doe(i16 zeroext %25, i8* %1, i32 %2, i32 0) #14, !dbg !1664
  br label %26, !dbg !1666

; <label>:26:                                     ; preds = %23, %15
  %27 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1667, !tbaa !554
  %28 = add i8 %27, -1, !dbg !1667
  store i8 %28, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1667, !tbaa !554
  %29 = tail call i32 @os_mutex_post(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex) #14, !dbg !1667
  br label %50, !dbg !1669

; <label>:30:                                     ; preds = %9
  %31 = load i32, i32* @norflash_write_cpu_unhold, align 4, !dbg !1670, !tbaa !538
  %32 = icmp eq i32 %31, 0, !dbg !1670
  %33 = load i8, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 1), align 4, !dbg !1673
  %34 = icmp eq i8 %33, 0, !dbg !1675
  %35 = or i1 %32, %34, !dbg !1676
  br i1 %35, label %40, label %36, !dbg !1676

; <label>:36:                                     ; preds = %30
  %37 = tail call i32 @os_mutex_pend(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex, i32 0) #14, !dbg !1677
  %38 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1677, !tbaa !554
  %39 = add i8 %38, 1, !dbg !1677
  store i8 %39, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1677, !tbaa !554
  br label %40, !dbg !1680

; <label>:40:                                     ; preds = %36, %30
  %41 = tail call i32 @flash_addr2cpu_addr(i32 %3) #15, !dbg !1681
  %42 = inttoptr i32 %41 to i8*, !dbg !1682
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %1, i8* %42, i32 %2, i32 1, i1 false), !dbg !1683
  %43 = load i8, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 1), align 4, !dbg !1684
  %44 = icmp eq i8 %43, 0, !dbg !1687
  %45 = or i1 %32, %44, !dbg !1688
  br i1 %45, label %50, label %46, !dbg !1688

; <label>:46:                                     ; preds = %40
  %47 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1689, !tbaa !554
  %48 = add i8 %47, -1, !dbg !1689
  store i8 %48, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1689, !tbaa !554
  %49 = tail call i32 @os_mutex_post(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex) #14, !dbg !1689
  br label %50, !dbg !1692

; <label>:50:                                     ; preds = %46, %40, %26
  ret i32 %2, !dbg !1693
}

; Function Attrs: minsize optsize
declare void @doe(i16 zeroext, i8*, i32, i32) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare i32 @get_system_enc_key() local_unnamed_addr #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i32, i1) #3

; Function Attrs: minsize nounwind optsize
define void @norflash_readback_check_control(i8 zeroext) local_unnamed_addr #0 !dbg !1694 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1696, metadata !442), !dbg !1697
  %2 = icmp ne i8 %0, 0, !dbg !1698
  %3 = zext i1 %2 to i8, !dbg !1699
  store i8 %3, i8* @readback_chk_ctl_en, align 1, !dbg !1700, !tbaa !554
  ret void, !dbg !1701
}

; Function Attrs: minsize nounwind optsize
define internal i32 @_norflash_write(i8* nocapture readonly, i32, i32) #0 section ".spi_code" !dbg !1702 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !1704, metadata !442), !dbg !1709
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1705, metadata !442), !dbg !1710
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1706, metadata !442), !dbg !1711
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1707, metadata !442), !dbg !1712
  %4 = icmp eq i32 %2, 0, !dbg !1713
  br i1 %4, label %23, label %5, !dbg !1715

; <label>:5:                                      ; preds = %3
  tail call void @enter_spi_code() #15, !dbg !1716
  %6 = add i32 %2, %1, !dbg !1717
  tail call void @spiflash_enter_4byte_addr(i32 %6) #15, !dbg !1718
  %7 = tail call i32 @exit_continue_mode() #15, !dbg !1719
  tail call void @llvm.dbg.value(metadata i32 %7, i64 0, metadata !1708, metadata !442), !dbg !1720
  tail call void @norflash_write_enable() #15, !dbg !1721
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1722
  tail call void @spi_writebyte(i8 zeroext 2) #15, !dbg !1723
  tail call void @norflash_send_addr(i32 %1) #15, !dbg !1724
  br label %8, !dbg !1725

; <label>:8:                                      ; preds = %12, %5
  %9 = phi i32 [ %2, %5 ], [ %13, %12 ]
  %10 = phi i8* [ %0, %5 ], [ %14, %12 ]
  tail call void @llvm.dbg.value(metadata i8* %10, i64 0, metadata !1704, metadata !442), !dbg !1709
  tail call void @llvm.dbg.value(metadata i32 %9, i64 0, metadata !1706, metadata !442), !dbg !1711
  tail call void @llvm.dbg.value(metadata i32 %13, i64 0, metadata !1706, metadata !442), !dbg !1711
  %11 = icmp eq i32 %9, 0, !dbg !1726
  br i1 %11, label %16, label %12, !dbg !1726

; <label>:12:                                     ; preds = %8
  %13 = add i32 %9, -1, !dbg !1728
  %14 = getelementptr inbounds i8, i8* %10, i32 1, !dbg !1730
  tail call void @llvm.dbg.value(metadata i8* %14, i64 0, metadata !1704, metadata !442), !dbg !1709
  %15 = load i8, i8* %10, align 1, !dbg !1732, !tbaa !554
  tail call void @spi_writebyte(i8 zeroext %15) #15, !dbg !1733
  br label %8, !dbg !1734, !llvm.loop !1735

; <label>:16:                                     ; preds = %8
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1737
  %17 = tail call i32 @flash_addr2cpu_addr(i32 %1) #15, !dbg !1738
  %18 = inttoptr i32 %17 to i8*, !dbg !1739
  tail call void @sfc_drop_cache(i8* %18, i32 %2) #15, !dbg !1740
  %19 = tail call i32 @norflash_wait_ok() #15, !dbg !1741
  %20 = icmp eq i32 %7, 0, !dbg !1742
  br i1 %20, label %22, label %21, !dbg !1744

; <label>:21:                                     ; preds = %16
  tail call void @enter_continue_mode() #15, !dbg !1745
  br label %22, !dbg !1747

; <label>:22:                                     ; preds = %21, %16
  tail call void @spiflash_exit_4byte_addr(i32 %6) #15, !dbg !1748
  tail call void @exit_spi_code(i32 0) #15, !dbg !1749
  br label %23

; <label>:23:                                     ; preds = %22, %3
  ret i32 0, !dbg !1750
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_write(%struct.device* nocapture readnone, i8*, i32, i32) local_unnamed_addr #0 !dbg !1751 {
  tail call void @llvm.dbg.value(metadata %struct.device* %0, i64 0, metadata !1753, metadata !442), !dbg !1764
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !1754, metadata !442), !dbg !1765
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1755, metadata !442), !dbg !1766
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !1756, metadata !442), !dbg !1767
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !1757, metadata !442), !dbg !1768
  %5 = add i32 %3, %2, !dbg !1769
  %6 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !1771, !tbaa !842
  %7 = icmp ugt i32 %5, %6, !dbg !1772
  br i1 %7, label %8, label %12, !dbg !1773

; <label>:8:                                      ; preds = %4
  %9 = load i8, i8* @log_tag_const_e_VM, align 1, !dbg !1774, !tbaa !554
  %10 = icmp eq i8 %9, 0, !dbg !1774
  br i1 %10, label %73, label %11, !dbg !1777

; <label>:11:                                     ; preds = %8
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([77 x i8], [77 x i8]* @.str.3, i32 0, i32 0), i32 %5, i32 %6) #14, !dbg !1778
  br label %73, !dbg !1778

; <label>:12:                                     ; preds = %4
  %13 = tail call i32 @os_mutex_pend(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex, i32 0) #14, !dbg !1780
  %14 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1780, !tbaa !554
  %15 = add i8 %14, 1, !dbg !1780
  store i8 %15, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1780, !tbaa !554
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1758, metadata !442), !dbg !1782
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !1759, metadata !442), !dbg !1783
  %16 = and i32 %3, 255, !dbg !1784
  %17 = sub nsw i32 256, %16, !dbg !1785
  tail call void @llvm.dbg.value(metadata i32 %17, i64 0, metadata !1760, metadata !442), !dbg !1786
  %18 = icmp ult i32 %17, %2, !dbg !1787
  %19 = select i1 %18, i32 %17, i32 %2, !dbg !1788
  tail call void @llvm.dbg.value(metadata i32 %19, i64 0, metadata !1760, metadata !442), !dbg !1786
  %20 = tail call i32 @_norflash_write(i8* %1, i32 %3, i32 %19) #15, !dbg !1789
  %21 = sub i32 %2, %19, !dbg !1790
  tail call void @llvm.dbg.value(metadata i32 %21, i64 0, metadata !1758, metadata !442), !dbg !1782
  %22 = getelementptr inbounds i8, i8* %1, i32 %19, !dbg !1791
  tail call void @llvm.dbg.value(metadata i8* %22, i64 0, metadata !1759, metadata !442), !dbg !1783
  %23 = add i32 %19, %3, !dbg !1792
  tail call void @llvm.dbg.value(metadata i32 %23, i64 0, metadata !1756, metadata !442), !dbg !1767
  br label %24, !dbg !1793

; <label>:24:                                     ; preds = %29, %12
  %25 = phi i32 [ %21, %12 ], [ %33, %29 ]
  %26 = phi i8* [ %22, %12 ], [ %35, %29 ]
  %27 = phi i32 [ %23, %12 ], [ %34, %29 ]
  tail call void @llvm.dbg.value(metadata i32 %27, i64 0, metadata !1756, metadata !442), !dbg !1767
  tail call void @llvm.dbg.value(metadata i8* %26, i64 0, metadata !1759, metadata !442), !dbg !1783
  tail call void @llvm.dbg.value(metadata i32 %25, i64 0, metadata !1758, metadata !442), !dbg !1782
  %28 = icmp eq i32 %25, 0, !dbg !1794
  br i1 %28, label %36, label %29, !dbg !1794

; <label>:29:                                     ; preds = %24
  %30 = icmp slt i32 %25, 256, !dbg !1796
  %31 = select i1 %30, i32 %25, i32 256, !dbg !1796
  tail call void @llvm.dbg.value(metadata i32 %31, i64 0, metadata !1761, metadata !442), !dbg !1797
  %32 = tail call i32 @_norflash_write(i8* %26, i32 %27, i32 %31) #15, !dbg !1798
  %33 = sub i32 %25, %31, !dbg !1799
  tail call void @llvm.dbg.value(metadata i32 %33, i64 0, metadata !1758, metadata !442), !dbg !1782
  %34 = add i32 %27, %31, !dbg !1800
  tail call void @llvm.dbg.value(metadata i32 %34, i64 0, metadata !1756, metadata !442), !dbg !1767
  %35 = getelementptr inbounds i8, i8* %26, i32 %31, !dbg !1801
  tail call void @llvm.dbg.value(metadata i8* %35, i64 0, metadata !1759, metadata !442), !dbg !1783
  br label %24, !dbg !1802, !llvm.loop !1804

; <label>:36:                                     ; preds = %24
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !1763, metadata !442), !dbg !1806
  %37 = load i32, i32* @norflash_write_readback_check_en, align 4, !dbg !1807, !tbaa !538
  %38 = load i8*, i8** getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 13), align 4, !dbg !1809
  %39 = icmp eq i32 %37, 0, !dbg !1811
  %40 = icmp eq i8* %38, null, !dbg !1811
  %41 = or i1 %40, %39, !dbg !1811
  %42 = load i8, i8* @readback_chk_ctl_en, align 1, !dbg !1812
  %43 = icmp eq i8 %42, 0, !dbg !1812
  %44 = or i1 %41, %43, !dbg !1811
  tail call void @llvm.dbg.value(metadata i32 512, i64 0, metadata !1821, metadata !442) #13, !dbg !1828
  br i1 %44, label %65, label %45, !dbg !1811

; <label>:45:                                     ; preds = %36
  br label %46, !dbg !1829

; <label>:46:                                     ; preds = %62, %45
  %47 = phi i32 [ %63, %62 ], [ 0, %45 ]
  tail call void @llvm.dbg.value(metadata i32 %47, i64 0, metadata !1823, metadata !442) #13, !dbg !1829
  %48 = icmp eq i32 %47, %2, !dbg !1830
  br i1 %48, label %64, label %49, !dbg !1832

; <label>:49:                                     ; preds = %46
  tail call void @llvm.memset.p0i8.i32(i8* nonnull %38, i8 102, i32 512, i32 1, i1 false) #13, !dbg !1833
  %50 = add i32 %47, %3, !dbg !1835
  tail call void @llvm.dbg.value(metadata i32 %50, i64 0, metadata !1825, metadata !442) #13, !dbg !1836
  %51 = sub i32 %2, %47, !dbg !1837
  %52 = icmp ult i32 %51, 512, !dbg !1838
  %53 = select i1 %52, i32 %51, i32 512, !dbg !1838
  tail call void @llvm.dbg.value(metadata i32 %53, i64 0, metadata !1824, metadata !442) #13, !dbg !1840
  %54 = tail call i32 @_norflash_read(i8* nonnull %38, i32 %50, i32 %53) #14, !dbg !1841
  %55 = getelementptr i8, i8* %1, i32 %47, !dbg !1842
  %56 = tail call i32 @memcmp(i8* %55, i8* nonnull %38, i32 %53) #14, !dbg !1844
  %57 = icmp eq i32 %56, 0, !dbg !1844
  br i1 %57, label %62, label %58, !dbg !1845

; <label>:58:                                     ; preds = %49
  %59 = load i8, i8* @log_tag_const_e_VM, align 1, !dbg !1846, !tbaa !554
  %60 = icmp eq i8 %59, 0, !dbg !1846
  br i1 %60, label %65, label %61, !dbg !1849

; <label>:61:                                     ; preds = %58
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([53 x i8], [53 x i8]* @.str.5, i32 0, i32 0), i32 %50) #14, !dbg !1850
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.6, i32 0, i32 0)) #14, !dbg !1852
  tail call void @printf_buf(i8* %55, i32 %53) #14, !dbg !1855
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.7, i32 0, i32 0)) #14, !dbg !1858
  tail call void @printf_buf(i8* nonnull %38, i32 %53) #14, !dbg !1861
  br label %65, !dbg !1861

; <label>:62:                                     ; preds = %49
  %63 = add i32 %53, %47, !dbg !1864
  tail call void @llvm.dbg.value(metadata i32 %63, i64 0, metadata !1823, metadata !442) #13, !dbg !1829
  br label %46, !dbg !1832, !llvm.loop !1865

; <label>:64:                                     ; preds = %46
  br label %65, !dbg !1868

; <label>:65:                                     ; preds = %64, %61, %58, %36
  %66 = phi i1 [ false, %36 ], [ true, %61 ], [ true, %58 ], [ false, %64 ]
  %67 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1870, !tbaa !554
  %68 = add i8 %67, -1, !dbg !1870
  store i8 %68, i8* @sfc_mutex_enter_cnt, align 1, !dbg !1870, !tbaa !554
  %69 = tail call i32 @os_mutex_post(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex) #14, !dbg !1870
  %70 = icmp ne i32 %37, 0, !dbg !1872
  %71 = and i1 %66, %70, !dbg !1874
  %72 = select i1 %71, i32 0, i32 %2, !dbg !1875
  br label %73

; <label>:73:                                     ; preds = %65, %11, %8
  %74 = phi i32 [ %72, %65 ], [ 0, %8 ], [ 0, %11 ]
  ret i32 %74, !dbg !1877
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_erase(i32, i32) #0 section ".spi_code" !dbg !1878 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !1882, metadata !442), !dbg !1887
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1883, metadata !442), !dbg !1888
  switch i32 %0, label %23 [
    i32 200, label %7
    i32 201, label %3
    i32 204, label %4
    i32 202, label %5
  ], !dbg !1889

; <label>:3:                                      ; preds = %2
  tail call void @llvm.dbg.value(metadata i32 216, i64 0, metadata !1882, metadata !442), !dbg !1887
  tail call void @llvm.dbg.value(metadata i32 65536, i64 0, metadata !1884, metadata !442), !dbg !1890
  br label %7, !dbg !1891

; <label>:4:                                      ; preds = %2
  tail call void @llvm.dbg.value(metadata i32 129, i64 0, metadata !1882, metadata !442), !dbg !1887
  tail call void @llvm.dbg.value(metadata i32 256, i64 0, metadata !1884, metadata !442), !dbg !1890
  br label %7, !dbg !1895

; <label>:5:                                      ; preds = %2
  tail call void @llvm.dbg.value(metadata i32 199, i64 0, metadata !1882, metadata !442), !dbg !1887
  %6 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !1898, !tbaa !842
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !1884, metadata !442), !dbg !1890
  br label %7

; <label>:7:                                      ; preds = %5, %4, %3, %2
  %8 = phi i32 [ 65536, %3 ], [ 256, %4 ], [ %6, %5 ], [ 4096, %2 ]
  %9 = phi i8 [ -40, %3 ], [ -127, %4 ], [ -57, %5 ], [ 32, %2 ]
  tail call void @llvm.dbg.value(metadata i32 %8, i64 0, metadata !1884, metadata !442), !dbg !1890
  %10 = sub i32 0, %8, !dbg !1901
  %11 = and i32 %10, %1, !dbg !1902
  tail call void @llvm.dbg.value(metadata i32 %11, i64 0, metadata !1883, metadata !442), !dbg !1888
  %12 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !1903, !tbaa !842
  %13 = and i32 %12, %10, !dbg !1904
  tail call void @llvm.dbg.value(metadata i32 %13, i64 0, metadata !1885, metadata !442), !dbg !1905
  %14 = icmp eq i32 %11, %13, !dbg !1906
  br i1 %14, label %23, label %15, !dbg !1908

; <label>:15:                                     ; preds = %7
  tail call void @enter_spi_code() #15, !dbg !1909
  tail call void @spiflash_enter_4byte_addr(i32 %11) #15, !dbg !1910
  %16 = tail call i32 @exit_continue_mode() #15, !dbg !1911
  tail call void @llvm.dbg.value(metadata i32 %16, i64 0, metadata !1886, metadata !442), !dbg !1912
  tail call void @norflash_write_enable() #15, !dbg !1913
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1914
  tail call void @spi_writebyte(i8 zeroext %9) #15, !dbg !1915
  tail call void @norflash_send_addr(i32 %11) #15, !dbg !1916
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1917
  %17 = tail call i32 @flash_addr2cpu_addr(i32 %11) #15, !dbg !1918
  %18 = inttoptr i32 %17 to i8*, !dbg !1919
  tail call void @sfc_drop_cache(i8* %18, i32 %8) #15, !dbg !1920
  %19 = tail call i32 @norflash_wait_ok() #15, !dbg !1922
  %20 = icmp eq i32 %16, 0, !dbg !1923
  br i1 %20, label %22, label %21, !dbg !1925

; <label>:21:                                     ; preds = %15
  tail call void @enter_continue_mode() #15, !dbg !1926
  br label %22, !dbg !1928

; <label>:22:                                     ; preds = %21, %15
  tail call void @spiflash_exit_4byte_addr(i32 %11) #15, !dbg !1929
  tail call void @exit_spi_code(i32 0) #15, !dbg !1930
  br label %23

; <label>:23:                                     ; preds = %22, %7, %2
  %24 = phi i32 [ -1, %2 ], [ 0, %22 ], [ -1, %7 ]
  ret i32 %24, !dbg !1931
}

; Function Attrs: minsize nounwind optsize
define internal void @flushinv_dcache_api(i32, i32) #0 section ".spi_code" !dbg !1933 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !1937, metadata !442), !dbg !1939
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1938, metadata !442), !dbg !1940
  tail call void @enter_spi_code() #15, !dbg !1941
  %3 = tail call i32 @flash_addr2cpu_addr(i32 %0) #15, !dbg !1942
  %4 = inttoptr i32 %3 to i8*, !dbg !1943
  tail call void @sfc_drop_cache(i8* %4, i32 %1) #15, !dbg !1944
  tail call void @exit_spi_code(i32 0) #15, !dbg !1946
  ret void, !dbg !1947
}

; Function Attrs: minsize nounwind optsize
define void @read_flash_id() #0 section ".spi_code" !dbg !1948 {
  tail call void @enter_spi_code() #15, !dbg !1952
  %1 = tail call i32 @exit_continue_mode() #15, !dbg !1953
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1950, metadata !442), !dbg !1954
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1955
  tail call void @spi_writebyte(i8 zeroext -97) #15, !dbg !1956
  store i32 0, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !1957, !tbaa !1561
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !1951, metadata !442), !dbg !1958
  br label %2, !dbg !1959

; <label>:2:                                      ; preds = %5, %0
  %3 = phi i32 [ 0, %0 ], [ %11, %5 ]
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !1951, metadata !442), !dbg !1958
  %4 = icmp eq i32 %3, 3, !dbg !1961
  br i1 %4, label %12, label %5, !dbg !1964

; <label>:5:                                      ; preds = %2
  %6 = tail call zeroext i8 @spi_readbyte() #15, !dbg !1966
  %7 = zext i8 %6 to i32, !dbg !1966
  %8 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !1968, !tbaa !1561
  %9 = or i32 %8, %7, !dbg !1968
  %10 = shl i32 %9, 8, !dbg !1969
  store i32 %10, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !1969, !tbaa !1561
  %11 = add nuw nsw i32 %3, 1, !dbg !1970
  tail call void @llvm.dbg.value(metadata i32 %11, i64 0, metadata !1951, metadata !442), !dbg !1958
  br label %2, !dbg !1972, !llvm.loop !1973

; <label>:12:                                     ; preds = %2
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !1976
  tail call void @llvm.dbg.value(metadata i32 1000, i64 0, metadata !1951, metadata !442), !dbg !1958
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !1977
  tail call void @spi_writebyte(i8 zeroext 75) #15, !dbg !1978
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !1979
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !1980
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !1981
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !1982
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !1951, metadata !442), !dbg !1958
  br label %13, !dbg !1983

; <label>:13:                                     ; preds = %16, %12
  %14 = phi i32 [ 0, %12 ], [ %19, %16 ]
  tail call void @llvm.dbg.value(metadata i32 %14, i64 0, metadata !1951, metadata !442), !dbg !1958
  %15 = icmp eq i32 %14, 16, !dbg !1985
  br i1 %15, label %20, label %16, !dbg !1988

; <label>:16:                                     ; preds = %13
  %17 = tail call zeroext i8 @spi_readbyte() #15, !dbg !1990
  %18 = getelementptr inbounds %struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 0, i32 %14, !dbg !1992
  store i8 %17, i8* %18, align 1, !dbg !1993, !tbaa !554
  %19 = add nuw nsw i32 %14, 1, !dbg !1994
  tail call void @llvm.dbg.value(metadata i32 %19, i64 0, metadata !1951, metadata !442), !dbg !1958
  br label %13, !dbg !1996, !llvm.loop !1997

; <label>:20:                                     ; preds = %13
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2000
  %21 = icmp eq i32 %1, 0, !dbg !2001
  br i1 %21, label %23, label %22, !dbg !2003

; <label>:22:                                     ; preds = %20
  tail call void @enter_continue_mode() #15, !dbg !2004
  br label %23, !dbg !2006

; <label>:23:                                     ; preds = %22, %20
  %24 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !2007, !tbaa !1561
  %25 = lshr i32 %24, 8, !dbg !2007
  store i32 %25, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !2007, !tbaa !1561
  tail call void @exit_spi_code(i32 0) #15, !dbg !2008
  ret void, !dbg !2009
}

; Function Attrs: minsize norecurse nounwind optsize readnone
define i8* @get_norflash_uuid() local_unnamed_addr #10 !dbg !2010 {
  ret i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 0, i32 0), !dbg !2013
}

; Function Attrs: minsize nounwind optsize
define internal void @norflash_entry_sleep(%struct.device* nocapture readnone) #0 section ".spi_code" !dbg !2014 {
  tail call void @llvm.dbg.value(metadata %struct.device* %0, i64 0, metadata !2018, metadata !442), !dbg !2020
  tail call void @enter_spi_code() #15, !dbg !2021
  %2 = tail call i32 @exit_continue_mode() #15, !dbg !2022
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2019, metadata !442), !dbg !2023
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2024
  tail call void @spi_writebyte(i8 zeroext -71) #15, !dbg !2025
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2026
  %3 = icmp eq i32 %2, 0, !dbg !2027
  br i1 %3, label %5, label %4, !dbg !2029

; <label>:4:                                      ; preds = %1
  tail call void @enter_continue_mode() #15, !dbg !2030
  br label %5, !dbg !2032

; <label>:5:                                      ; preds = %4, %1
  tail call void @exit_spi_code(i32 0) #15, !dbg !2033
  ret void, !dbg !2034
}

; Function Attrs: minsize nounwind optsize
define internal void @norflash_exit_sleep(%struct.device* nocapture readnone) #0 section ".spi_code" !dbg !2035 {
  tail call void @llvm.dbg.value(metadata %struct.device* %0, i64 0, metadata !2037, metadata !442), !dbg !2039
  tail call void @enter_spi_code() #15, !dbg !2040
  %2 = tail call i32 @exit_continue_mode() #15, !dbg !2041
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2038, metadata !442), !dbg !2042
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2043
  tail call void @spi_writebyte(i8 zeroext -85) #15, !dbg !2044
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2045
  %3 = icmp eq i32 %2, 0, !dbg !2046
  br i1 %3, label %5, label %4, !dbg !2048

; <label>:4:                                      ; preds = %1
  tail call void @enter_continue_mode() #15, !dbg !2049
  br label %5, !dbg !2051

; <label>:5:                                      ; preds = %4, %1
  tail call void @exit_spi_code(i32 0) #15, !dbg !2052
  ret void, !dbg !2053
}

; Function Attrs: minsize nounwind optsize
define void @set_vm_addr_info(i32, i32) local_unnamed_addr #0 !dbg !2054 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !2056, metadata !442), !dbg !2058
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2057, metadata !442), !dbg !2059
  store i32 %0, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 6, i32 1), align 4, !dbg !2060, !tbaa !1658
  store i32 %1, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 6, i32 3), align 4, !dbg !2061, !tbaa !2062
  ret void, !dbg !2063
}

; Function Attrs: minsize nounwind optsize
define internal zeroext i16 @norflash_read_sr() #0 section ".spi_code" !dbg !2064 {
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !2068, metadata !442), !dbg !2070
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !2069, metadata !442), !dbg !2071
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2072
  tail call void @spi_writebyte(i8 zeroext 5) #15, !dbg !2073
  %1 = tail call zeroext i8 @spi_readbyte() #15, !dbg !2074
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !2068, metadata !442), !dbg !2070
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2075
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2076
  tail call void @spi_writebyte(i8 zeroext 53) #15, !dbg !2077
  %2 = tail call zeroext i8 @spi_readbyte() #15, !dbg !2078
  tail call void @llvm.dbg.value(metadata i8 %2, i64 0, metadata !2069, metadata !442), !dbg !2071
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2079
  %3 = zext i8 %2 to i16, !dbg !2080
  %4 = shl nuw i16 %3, 8, !dbg !2081
  %5 = zext i8 %1 to i16, !dbg !2082
  %6 = or i16 %4, %5, !dbg !2083
  ret i16 %6, !dbg !2084
}

; Function Attrs: minsize nounwind optsize
define internal i32 @norflash_write_sr(i32) #0 section ".spi_code" !dbg !2085 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !2089, metadata !442), !dbg !2098
  %2 = and i32 %0, 262144, !dbg !2099
  %3 = icmp eq i32 %2, 0, !dbg !2100
  %4 = and i32 %0, 131072, !dbg !2101
  %5 = icmp ne i32 %4, 0, !dbg !2102
  %6 = and i32 %0, 65536, !dbg !2103
  %7 = icmp ne i32 %6, 0, !dbg !2104
  %8 = trunc i32 %0 to i8, !dbg !2105
  tail call void @llvm.dbg.value(metadata i8 %8, i64 0, metadata !2095, metadata !442), !dbg !2106
  %9 = lshr i32 %0, 8, !dbg !2107
  %10 = trunc i32 %9 to i8, !dbg !2108
  tail call void @llvm.dbg.value(metadata i8 %10, i64 0, metadata !2097, metadata !442), !dbg !2109
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2110
  br i1 %3, label %24, label %11, !dbg !2115

; <label>:11:                                     ; preds = %1
  br i1 %5, label %12, label %13, !dbg !2116

; <label>:12:                                     ; preds = %11
  tail call void @spi_writebyte(i8 zeroext 80) #15, !dbg !2117
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2118
  br label %14, !dbg !2119

; <label>:13:                                     ; preds = %11
  tail call void @spi_writebyte(i8 zeroext 6) #15, !dbg !2120
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2122
  br label %14

; <label>:14:                                     ; preds = %13, %12
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2123
  tail call void @spi_writebyte(i8 zeroext 1) #15, !dbg !2124
  tail call void @spi_writebyte(i8 zeroext %8) #15, !dbg !2125
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2126
  %15 = tail call i32 @norflash_wait_ok() #15, !dbg !2127
  tail call void @llvm.dbg.value(metadata i32 %15, i64 0, metadata !2090, metadata !442), !dbg !2128
  %16 = icmp eq i32 %15, 0, !dbg !2129
  br i1 %16, label %17, label %33, !dbg !2131

; <label>:17:                                     ; preds = %14
  br i1 %7, label %18, label %32, !dbg !2132

; <label>:18:                                     ; preds = %17
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2133
  br i1 %5, label %19, label %20, !dbg !2138

; <label>:19:                                     ; preds = %18
  tail call void @spi_writebyte(i8 zeroext 80) #15, !dbg !2139
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2140
  br label %21, !dbg !2141

; <label>:20:                                     ; preds = %18
  tail call void @spi_writebyte(i8 zeroext 6) #15, !dbg !2142
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2144
  br label %21

; <label>:21:                                     ; preds = %20, %19
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2145
  tail call void @spi_writebyte(i8 zeroext 49) #15, !dbg !2146
  tail call void @spi_writebyte(i8 zeroext %10) #15, !dbg !2147
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2148
  %22 = tail call i32 @norflash_wait_ok() #15, !dbg !2149
  tail call void @llvm.dbg.value(metadata i32 %22, i64 0, metadata !2090, metadata !442), !dbg !2128
  %23 = icmp eq i32 %22, 0, !dbg !2150
  br i1 %23, label %32, label %33, !dbg !2152

; <label>:24:                                     ; preds = %1
  br i1 %5, label %25, label %26, !dbg !2153

; <label>:25:                                     ; preds = %24
  tail call void @spi_writebyte(i8 zeroext 80) #15, !dbg !2155
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2158
  br label %27, !dbg !2159

; <label>:26:                                     ; preds = %24
  tail call void @spi_writebyte(i8 zeroext 6) #15, !dbg !2160
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2162
  br label %27

; <label>:27:                                     ; preds = %26, %25
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2163
  tail call void @spi_writebyte(i8 zeroext 1) #15, !dbg !2164
  tail call void @spi_writebyte(i8 zeroext %8) #15, !dbg !2165
  br i1 %7, label %28, label %29, !dbg !2166

; <label>:28:                                     ; preds = %27
  tail call void @spi_writebyte(i8 zeroext %10) #15, !dbg !2167
  br label %29, !dbg !2170

; <label>:29:                                     ; preds = %28, %27
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2171
  %30 = tail call i32 @norflash_wait_ok() #15, !dbg !2172
  tail call void @llvm.dbg.value(metadata i32 %30, i64 0, metadata !2090, metadata !442), !dbg !2128
  %31 = icmp eq i32 %30, 0, !dbg !2173
  br i1 %31, label %32, label %33, !dbg !2175

; <label>:32:                                     ; preds = %29, %21, %17
  br label %33, !dbg !2176

; <label>:33:                                     ; preds = %32, %29, %21, %14
  %34 = phi i32 [ 0, %32 ], [ 1, %14 ], [ 2, %21 ], [ 3, %29 ]
  ret i32 %34, !dbg !2177
}

; Function Attrs: minsize nounwind optsize
define internal i32 @flash_write_protect(i32) #0 section ".spi_code" !dbg !2178 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !2180, metadata !442), !dbg !2188
  %2 = and i32 %0, 262144, !dbg !2189
  %3 = icmp eq i32 %2, 0, !dbg !2190
  %4 = and i32 %0, 65536, !dbg !2191
  %5 = icmp eq i32 %4, 0, !dbg !2192
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2184, metadata !442), !dbg !2193
  tail call void @llvm.dbg.value(metadata i16 0, i64 0, metadata !2185, metadata !442), !dbg !2194
  tail call void @llvm.dbg.value(metadata i16 0, i64 0, metadata !2186, metadata !442), !dbg !2195
  tail call void @enter_spi_code() #15, !dbg !2196
  store i32 %0, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 11), align 4, !dbg !2197, !tbaa !1603
  %6 = tail call i32 @exit_continue_mode() #15, !dbg !2198
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !2187, metadata !442), !dbg !2199
  br label %7, !dbg !2200

; <label>:7:                                      ; preds = %29, %1
  %8 = phi i32 [ undef, %1 ], [ %40, %29 ]
  %9 = phi i16 [ 0, %1 ], [ %36, %29 ]
  %10 = phi i32 [ %0, %1 ], [ %35, %29 ]
  tail call void @llvm.dbg.value(metadata i32 %10, i64 0, metadata !2180, metadata !442), !dbg !2188
  tail call void @llvm.dbg.value(metadata i16 %9, i64 0, metadata !2186, metadata !442), !dbg !2195
  tail call void @llvm.dbg.value(metadata i32 %8, i64 0, metadata !2181, metadata !442), !dbg !2201
  %11 = tail call zeroext i16 @norflash_read_sr() #15, !dbg !2202
  tail call void @llvm.dbg.value(metadata i16 %11, i64 0, metadata !2185, metadata !442), !dbg !2194
  br i1 %5, label %12, label %18, !dbg !2204

; <label>:12:                                     ; preds = %7
  %13 = and i16 %11, 255, !dbg !2205
  %14 = zext i16 %13 to i32, !dbg !2205
  %15 = and i32 %10, 65280, !dbg !2208
  %16 = or i32 %14, %15, !dbg !2209
  %17 = trunc i32 %16 to i16, !dbg !2210
  tail call void @llvm.dbg.value(metadata i16 %17, i64 0, metadata !2185, metadata !442), !dbg !2194
  br label %18, !dbg !2211

; <label>:18:                                     ; preds = %12, %7
  %19 = phi i16 [ %17, %12 ], [ %11, %7 ]
  tail call void @llvm.dbg.value(metadata i16 %19, i64 0, metadata !2185, metadata !442), !dbg !2194
  %20 = zext i16 %19 to i32, !dbg !2212
  %21 = xor i32 %20, %10, !dbg !2214
  %22 = and i32 %21, 16892, !dbg !2214
  %23 = icmp eq i32 %22, 0, !dbg !2214
  br i1 %23, label %41, label %24, !dbg !2215

; <label>:24:                                     ; preds = %18
  %25 = icmp ugt i16 %9, 2, !dbg !2216
  br i1 %25, label %26, label %29, !dbg !2219

; <label>:26:                                     ; preds = %24
  %27 = icmp ne i32 %8, 0, !dbg !2220
  %28 = select i1 %27, i32 %8, i32 -1, !dbg !2220
  tail call void @llvm.dbg.value(metadata i32 %28, i64 0, metadata !2181, metadata !442), !dbg !2201
  br label %42, !dbg !2222

; <label>:29:                                     ; preds = %24
  %30 = and i16 %9, 1, !dbg !2223
  %31 = icmp eq i16 %30, 0, !dbg !2223
  %32 = and i1 %3, %31, !dbg !2225
  %33 = or i32 %10, 262144, !dbg !2226
  tail call void @llvm.dbg.value(metadata i32 %33, i64 0, metadata !2180, metadata !442), !dbg !2188
  %34 = and i32 %10, -262145, !dbg !2228
  tail call void @llvm.dbg.value(metadata i32 %34, i64 0, metadata !2180, metadata !442), !dbg !2188
  %35 = select i1 %32, i32 %34, i32 %33, !dbg !2225
  tail call void @llvm.dbg.value(metadata i32 %35, i64 0, metadata !2180, metadata !442), !dbg !2188
  %36 = add i16 %9, 1, !dbg !2230
  tail call void @llvm.dbg.value(metadata i16 %36, i64 0, metadata !2186, metadata !442), !dbg !2195
  %37 = and i32 %35, 475644, !dbg !2231
  %38 = and i32 %20, 48640, !dbg !2232
  %39 = or i32 %38, %37, !dbg !2233
  tail call void @llvm.dbg.value(metadata i32 %39, i64 0, metadata !2184, metadata !442), !dbg !2193
  %40 = tail call i32 @norflash_write_sr(i32 %39) #15, !dbg !2234
  tail call void @llvm.dbg.value(metadata i32 %40, i64 0, metadata !2181, metadata !442), !dbg !2201
  br label %7, !dbg !2235, !llvm.loop !2237

; <label>:41:                                     ; preds = %18
  br label %42, !dbg !2201

; <label>:42:                                     ; preds = %41, %26
  %43 = phi i32 [ %28, %26 ], [ 0, %41 ]
  tail call void @llvm.dbg.value(metadata i32 %43, i64 0, metadata !2181, metadata !442), !dbg !2201
  %44 = icmp eq i32 %6, 0, !dbg !2239
  br i1 %44, label %46, label %45, !dbg !2241

; <label>:45:                                     ; preds = %42
  tail call void @enter_continue_mode() #15, !dbg !2242
  br label %46, !dbg !2244

; <label>:46:                                     ; preds = %45, %42
  tail call void @exit_spi_code(i32 0) #15, !dbg !2245
  ret i32 %43, !dbg !2246
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_ioctl(%struct.device* nocapture readnone, i32, i32) local_unnamed_addr #0 !dbg !2247 {
  tail call void @llvm.dbg.value(metadata %struct.device* %0, i64 0, metadata !2249, metadata !442), !dbg !2253
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2250, metadata !442), !dbg !2254
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2251, metadata !442), !dbg !2255
  %4 = tail call i32 @os_mutex_pend(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex, i32 0) #14, !dbg !2256
  %5 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !2256, !tbaa !554
  %6 = add i8 %5, 1, !dbg !2256
  store i8 %6, i8* @sfc_mutex_enter_cnt, align 1, !dbg !2256, !tbaa !554
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2252, metadata !442), !dbg !2258
  switch i32 %1, label %150 [
    i32 101, label %7
    i32 102, label %9
    i32 103, label %11
    i32 100, label %20
    i32 402, label %30
    i32 204, label %38
    i32 200, label %38
    i32 201, label %38
    i32 13, label %40
    i32 47, label %44
    i32 203, label %151
    i32 205, label %49
    i32 206, label %75
    i32 11, label %77
  ], !dbg !2259

; <label>:7:                                      ; preds = %3
  %8 = inttoptr i32 %2 to i32*, !dbg !2260
  store i32 256, i32* %8, align 4, !dbg !2262, !tbaa !538
  br label %151, !dbg !2263

; <label>:9:                                      ; preds = %3
  %10 = inttoptr i32 %2 to i32*, !dbg !2264
  store i32 65536, i32* %10, align 4, !dbg !2265, !tbaa !538
  br label %151, !dbg !2266

; <label>:11:                                     ; preds = %3
  %12 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !2267, !tbaa !842
  %13 = icmp eq i32 %12, 0, !dbg !2269
  br i1 %13, label %14, label %17, !dbg !2270

; <label>:14:                                     ; preds = %11
  tail call void @read_flash_id() #15, !dbg !2271
  %15 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !2273, !tbaa !1561
  %16 = tail call i32 @norflash_calc_capacity(i32 %15) #15, !dbg !2274
  store i32 %16, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !2275, !tbaa !842
  br label %17, !dbg !2276

; <label>:17:                                     ; preds = %14, %11
  %18 = phi i32 [ %16, %14 ], [ %12, %11 ], !dbg !2277
  %19 = inttoptr i32 %2 to i32*, !dbg !2278
  store i32 %18, i32* %19, align 4, !dbg !2279, !tbaa !538
  br label %151, !dbg !2280

; <label>:20:                                     ; preds = %3
  %21 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !2281, !tbaa !1561
  %22 = icmp eq i32 %21, 0, !dbg !2283
  br i1 %22, label %23, label %27, !dbg !2284

; <label>:23:                                     ; preds = %20
  tail call void @read_flash_id() #15, !dbg !2285
  %24 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !2287, !tbaa !1561
  %25 = tail call i32 @norflash_calc_capacity(i32 %24) #15, !dbg !2288
  store i32 %25, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !2289, !tbaa !842
  %26 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !tbaa !1561
  br label %27, !dbg !2290

; <label>:27:                                     ; preds = %23, %20
  %28 = phi i32 [ %26, %23 ], [ %21, %20 ], !dbg !2291
  %29 = inttoptr i32 %2 to i32*, !dbg !2292
  store i32 %28, i32* %29, align 4, !dbg !2293, !tbaa !538
  br label %151, !dbg !2294

; <label>:30:                                     ; preds = %3
  %31 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !2295, !tbaa !1561
  %32 = icmp eq i32 %31, 0, !dbg !2297
  br i1 %32, label %33, label %36, !dbg !2298

; <label>:33:                                     ; preds = %30
  tail call void @read_flash_id() #15, !dbg !2299
  %34 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 5), align 4, !dbg !2301, !tbaa !1561
  %35 = tail call i32 @norflash_calc_capacity(i32 %34) #15, !dbg !2302
  store i32 %35, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 4), align 4, !dbg !2303, !tbaa !842
  br label %36, !dbg !2304

; <label>:36:                                     ; preds = %33, %30
  %37 = inttoptr i32 %2 to i8*, !dbg !2305
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %37, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 0, i32 0), i32 16, i32 1, i1 false), !dbg !2306
  br label %151, !dbg !2307

; <label>:38:                                     ; preds = %3, %3, %3
  %39 = tail call i32 @norflash_erase(i32 %1, i32 %2) #15, !dbg !2308
  tail call void @llvm.dbg.value(metadata i32 %39, i64 0, metadata !2252, metadata !442), !dbg !2258
  br label %151, !dbg !2309

; <label>:40:                                     ; preds = %3
  %41 = icmp eq i32 %2, 0, !dbg !2310
  tail call void @llvm.dbg.value(metadata i32 65536, i64 0, metadata !2251, metadata !442), !dbg !2255
  %42 = select i1 %41, i32 65536, i32 %2, !dbg !2312
  tail call void @llvm.dbg.value(metadata i32 %42, i64 0, metadata !2251, metadata !442), !dbg !2255
  %43 = tail call i32 @flash_write_protect(i32 %42) #15, !dbg !2313
  tail call void @llvm.dbg.value(metadata i32 %43, i64 0, metadata !2252, metadata !442), !dbg !2258
  br label %151, !dbg !2314

; <label>:44:                                     ; preds = %3
  %45 = icmp eq i32 %2, 0, !dbg !2315
  br i1 %45, label %151, label %46, !dbg !2317

; <label>:46:                                     ; preds = %44
  %47 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 11), align 4, !dbg !2318, !tbaa !1603
  %48 = inttoptr i32 %2 to i32*, !dbg !2320
  store i32 %47, i32* %48, align 4, !dbg !2321, !tbaa !538
  br label %151, !dbg !2322

; <label>:49:                                     ; preds = %3
  %50 = inttoptr i32 %2 to i8*, !dbg !2323
  tail call void @llvm.dbg.value(metadata i8* %50, i64 0, metadata !2324, metadata !442) #13, !dbg !2328
  %51 = load i32, i32* @config_asser, align 4, !dbg !2330, !tbaa !538
  %52 = icmp eq i32 %51, 0, !dbg !2330
  %53 = icmp ne i32 %2, 0
  br i1 %52, label %59, label %54, !dbg !2334

; <label>:54:                                     ; preds = %49
  br i1 %53, label %62, label %55, !dbg !2336

; <label>:55:                                     ; preds = %54
  %56 = tail call i8* bitcast (i8* (...)* @os_current_task_rom to i8* ()*)() #14, !dbg !2339
  %57 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.8, i32 0, i32 0), i8* getelementptr inbounds ([83 x i8], [83 x i8]* @.str.9, i32 0, i32 0), i32 1326, i8* %56) #14, !dbg !2343
  %58 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.10, i32 0, i32 0)) #14, !dbg !2345
  tail call void bitcast (void (...)* @cpu_assert_debug to void ()*)() #14, !dbg !2347
  br label %62, !dbg !2339

; <label>:59:                                     ; preds = %49
  br i1 %53, label %62, label %60, !dbg !2349

; <label>:60:                                     ; preds = %59
  tail call void @P33_SYSTEM_RESET() #14, !dbg !2352
  br label %61, !dbg !2358

; <label>:61:                                     ; preds = %61, %60
  br label %61, !dbg !2359, !llvm.loop !2361

; <label>:62:                                     ; preds = %59, %55, %54
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 6, i32 0), i8* %50, i32 16, i32 4, i1 false) #13, !dbg !2364
  %63 = getelementptr inbounds i8, i8* %50, i32 16, !dbg !2365
  %64 = bitcast i8* %63 to i64*, !dbg !2366
  %65 = load i64, i64* %64, align 4, !dbg !2366
  store i64 %65, i64* bitcast (%struct.sfc_info* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 7) to i64*), align 4, !dbg !2366
  %66 = getelementptr inbounds i8, i8* %50, i32 24, !dbg !2367
  %67 = bitcast i8* %66 to i32*, !dbg !2367
  %68 = load i32, i32* %67, align 4, !dbg !2367, !tbaa !2368
  store i32 %68, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 3), align 4, !dbg !2372, !tbaa !2373
  %69 = load volatile i8, i8* inttoptr (i32 262912 to i8*), align 256, !dbg !2374, !tbaa !2375
  %70 = and i8 %69, -3, !dbg !2374
  store volatile i8 %70, i8* inttoptr (i32 262912 to i8*), align 256, !dbg !2374, !tbaa !2375
  %71 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 6, i32 1), align 4, !dbg !2377, !tbaa !1658
  %72 = tail call i32 @flash_addr2cpu_addr(i32 %71) #14, !dbg !2378
  store volatile i32 %72, i32* inttoptr (i32 262924 to i32*), align 4, !dbg !2379, !tbaa !2380
  store volatile i32 134217727, i32* inttoptr (i32 262920 to i32*), align 8, !dbg !2381, !tbaa !2382
  %73 = load volatile i8, i8* inttoptr (i32 262912 to i8*), align 256, !dbg !2383, !tbaa !2375
  %74 = or i8 %73, 2, !dbg !2383
  store volatile i8 %74, i8* inttoptr (i32 262912 to i8*), align 256, !dbg !2383, !tbaa !2375
  tail call void @flushinv_dcache_api(i32 %71, i32 32) #14, !dbg !2384
  br label %151, !dbg !2385

; <label>:75:                                     ; preds = %3
  %76 = inttoptr i32 %2 to i8*, !dbg !2386
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %76, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 6, i32 0), i32 16, i32 1, i1 false), !dbg !2387
  br label %151, !dbg !2388

; <label>:77:                                     ; preds = %3
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2389, metadata !442) #13, !dbg !2392
  store i32 4105, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !2394, !tbaa !1073
  %78 = and i32 %2, 4, !dbg !2395
  %79 = icmp eq i32 %78, 0, !dbg !2395
  br i1 %79, label %84, label %80, !dbg !2397

; <label>:80:                                     ; preds = %77
  store i32 4185, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !2398, !tbaa !1073
  %81 = load i8, i8* @log_tag_const_i_VM, align 1, !dbg !2400, !tbaa !554
  %82 = icmp eq i8 %81, 0, !dbg !2400
  br i1 %82, label %135, label %83, !dbg !2402

; <label>:83:                                     ; preds = %80
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.11, i32 0, i32 0)) #14, !dbg !2403
  br label %135, !dbg !2403

; <label>:84:                                     ; preds = %77
  %85 = and i32 %2, 8, !dbg !2405
  %86 = icmp eq i32 %85, 0, !dbg !2405
  br i1 %86, label %91, label %87, !dbg !2408

; <label>:87:                                     ; preds = %84
  store i32 4201, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !2410, !tbaa !1073
  %88 = load i8, i8* @log_tag_const_i_VM, align 1, !dbg !2412, !tbaa !554
  %89 = icmp eq i8 %88, 0, !dbg !2412
  br i1 %89, label %135, label %90, !dbg !2414

; <label>:90:                                     ; preds = %87
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.12, i32 0, i32 0)) #14, !dbg !2415
  br label %135, !dbg !2415

; <label>:91:                                     ; preds = %84
  %92 = and i32 %2, 16, !dbg !2417
  %93 = icmp eq i32 %92, 0, !dbg !2417
  br i1 %93, label %98, label %94, !dbg !2420

; <label>:94:                                     ; preds = %91
  store i32 4169, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !2421, !tbaa !1073
  %95 = load i8, i8* @log_tag_const_i_VM, align 1, !dbg !2423, !tbaa !554
  %96 = icmp eq i8 %95, 0, !dbg !2423
  br i1 %96, label %135, label %97, !dbg !2425

; <label>:97:                                     ; preds = %94
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.13, i32 0, i32 0)) #14, !dbg !2426
  br label %135, !dbg !2426

; <label>:98:                                     ; preds = %91
  %99 = and i32 %2, 32, !dbg !2428
  %100 = icmp eq i32 %99, 0, !dbg !2428
  br i1 %100, label %105, label %101, !dbg !2431

; <label>:101:                                    ; preds = %98
  store i32 4217, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !2432, !tbaa !1073
  %102 = load i8, i8* @log_tag_const_i_VM, align 1, !dbg !2434, !tbaa !554
  %103 = icmp eq i8 %102, 0, !dbg !2434
  br i1 %103, label %135, label %104, !dbg !2436

; <label>:104:                                    ; preds = %101
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.14, i32 0, i32 0)) #14, !dbg !2437
  br label %135, !dbg !2437

; <label>:105:                                    ; preds = %98
  %106 = and i32 %2, 64, !dbg !2439
  %107 = icmp eq i32 %106, 0, !dbg !2439
  br i1 %107, label %112, label %108, !dbg !2442

; <label>:108:                                    ; preds = %105
  store i32 4121, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !2443, !tbaa !1073
  %109 = load i8, i8* @log_tag_const_i_VM, align 1, !dbg !2445, !tbaa !554
  %110 = icmp eq i8 %109, 0, !dbg !2445
  br i1 %110, label %135, label %111, !dbg !2447

; <label>:111:                                    ; preds = %108
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.15, i32 0, i32 0)) #14, !dbg !2448
  br label %135, !dbg !2448

; <label>:112:                                    ; preds = %105
  %113 = trunc i32 %2 to i8, !dbg !2450
  %114 = icmp slt i8 %113, 0, !dbg !2450
  br i1 %114, label %115, label %119, !dbg !2453

; <label>:115:                                    ; preds = %112
  store i32 4137, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !2454, !tbaa !1073
  %116 = load i8, i8* @log_tag_const_i_VM, align 1, !dbg !2456, !tbaa !554
  %117 = icmp eq i8 %116, 0, !dbg !2456
  br i1 %117, label %135, label %118, !dbg !2458

; <label>:118:                                    ; preds = %115
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.16, i32 0, i32 0)) #14, !dbg !2459
  br label %135, !dbg !2459

; <label>:119:                                    ; preds = %112
  %120 = and i32 %2, 256, !dbg !2461
  %121 = icmp eq i32 %120, 0, !dbg !2461
  br i1 %121, label %126, label %122, !dbg !2464

; <label>:122:                                    ; preds = %119
  store i32 4105, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !2465, !tbaa !1073
  %123 = load i8, i8* @log_tag_const_i_VM, align 1, !dbg !2467, !tbaa !554
  %124 = icmp eq i8 %123, 0, !dbg !2467
  br i1 %124, label %135, label %125, !dbg !2469

; <label>:125:                                    ; preds = %122
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.17, i32 0, i32 0)) #14, !dbg !2470
  br label %135, !dbg !2470

; <label>:126:                                    ; preds = %119
  %127 = and i32 %2, 512, !dbg !2472
  %128 = icmp eq i32 %127, 0, !dbg !2472
  store i32 4153, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !tbaa !1073
  %129 = load i8, i8* @log_tag_const_i_VM, align 1, !tbaa !554
  %130 = icmp ne i8 %129, 0
  br i1 %128, label %133, label %131, !dbg !2475

; <label>:131:                                    ; preds = %126
  br i1 %130, label %132, label %135, !dbg !2476

; <label>:132:                                    ; preds = %131
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.18, i32 0, i32 0)) #14, !dbg !2478
  br label %135, !dbg !2478

; <label>:133:                                    ; preds = %126
  br i1 %130, label %134, label %135, !dbg !2481

; <label>:134:                                    ; preds = %133
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([53 x i8], [53 x i8]* @.str.19, i32 0, i32 0)) #14, !dbg !2483
  br label %135, !dbg !2483

; <label>:135:                                    ; preds = %134, %133, %132, %131, %125, %122, %118, %115, %111, %108, %104, %101, %97, %94, %90, %87, %83, %80
  %136 = phi i8 [ 0, %80 ], [ 0, %87 ], [ 0, %94 ], [ 0, %101 ], [ 0, %108 ], [ 0, %115 ], [ 0, %122 ], [ %88, %90 ], [ %102, %104 ], [ %116, %118 ], [ %129, %132 ], [ 0, %131 ], [ %129, %134 ], [ 0, %133 ], [ %123, %125 ], [ %109, %111 ], [ %95, %97 ], [ %81, %83 ], !dbg !2486
  %137 = and i32 %2, 2, !dbg !2488
  %138 = icmp eq i32 %137, 0, !dbg !2488
  br i1 %138, label %146, label %139, !dbg !2490

; <label>:139:                                    ; preds = %135
  %140 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !2491, !tbaa !1073
  %141 = and i32 %140, 32, !dbg !2494
  %142 = icmp ne i32 %141, 0, !dbg !2494
  %143 = and i32 %140, -17, !dbg !2495
  %144 = or i32 %140, 16, !dbg !2497
  %145 = select i1 %142, i32 %144, i32 %143, !dbg !2499
  store i32 %145, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !tbaa !1073
  br label %146, !dbg !2500

; <label>:146:                                    ; preds = %139, %135
  %147 = icmp eq i8 %136, 0, !dbg !2501
  br i1 %147, label %151, label %148, !dbg !2503

; <label>:148:                                    ; preds = %146
  %149 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 10), align 4, !dbg !2505, !tbaa !1073
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.20, i32 0, i32 0), i32 %149) #14, !dbg !2505
  br label %151, !dbg !2505

; <label>:150:                                    ; preds = %3
  tail call void @llvm.dbg.value(metadata i32 -25, i64 0, metadata !2252, metadata !442), !dbg !2258
  br label %151, !dbg !2507

; <label>:151:                                    ; preds = %150, %148, %146, %75, %62, %46, %44, %40, %38, %36, %27, %17, %9, %7, %3
  %152 = phi i32 [ -25, %150 ], [ 0, %75 ], [ 0, %62 ], [ 0, %3 ], [ 0, %46 ], [ 0, %44 ], [ %43, %40 ], [ %39, %38 ], [ 0, %36 ], [ 0, %27 ], [ 0, %17 ], [ 0, %9 ], [ 0, %7 ], [ 0, %146 ], [ 0, %148 ]
  tail call void @llvm.dbg.value(metadata i32 %152, i64 0, metadata !2252, metadata !442), !dbg !2258
  %153 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !2508, !tbaa !554
  %154 = add i8 %153, -1, !dbg !2508
  store i8 %154, i8* @sfc_mutex_enter_cnt, align 1, !dbg !2508, !tbaa !554
  %155 = tail call i32 @os_mutex_post(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex) #14, !dbg !2508
  ret i32 %152, !dbg !2510
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_protect_resume() local_unnamed_addr #0 !dbg !2511 {
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2513, metadata !442), !dbg !2514
  %1 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 12), align 4, !dbg !2515, !tbaa !2517
  %2 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 11), align 4, !dbg !2518, !tbaa !1603
  %3 = icmp eq i32 %1, %2, !dbg !2519
  br i1 %3, label %6, label %4, !dbg !2520

; <label>:4:                                      ; preds = %0
  %5 = tail call i32 @norflash_ioctl(%struct.device* undef, i32 13, i32 %1) #15, !dbg !2521
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !2513, metadata !442), !dbg !2514
  store i32 0, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 12), align 4, !dbg !2523, !tbaa !2517
  br label %6, !dbg !2524

; <label>:6:                                      ; preds = %4, %0
  %7 = phi i32 [ %5, %4 ], [ 0, %0 ]
  ret i32 %7, !dbg !2525
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_protect_suspend() local_unnamed_addr #0 !dbg !2526 {
  %1 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 12), align 4, !dbg !2527, !tbaa !2517
  %2 = load i32, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 11), align 4, !dbg !2529, !tbaa !1603
  %3 = icmp eq i32 %1, %2, !dbg !2530
  br i1 %3, label %6, label %4, !dbg !2531

; <label>:4:                                      ; preds = %0
  store i32 %2, i32* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 12), align 4, !dbg !2532, !tbaa !2517
  %5 = tail call i32 @norflash_ioctl(%struct.device* undef, i32 13, i32 0) #15, !dbg !2534
  br label %6, !dbg !2535

; <label>:6:                                      ; preds = %4, %0
  %7 = phi i32 [ %5, %4 ], [ 0, %0 ]
  ret i32 %7, !dbg !2536
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_write_protect(i32) local_unnamed_addr #0 !dbg !2537 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !2539, metadata !442), !dbg !2540
  %2 = tail call i32 @norflash_ioctl(%struct.device* undef, i32 13, i32 %0) #15, !dbg !2541
  ret i32 %2, !dbg !2542
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_eraser_otp() #0 section ".spi_code" !dbg !2543 {
  tail call void @enter_spi_code() #15, !dbg !2544
  tail call void @norflash_write_enable() #15, !dbg !2545
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2546
  tail call void @spi_writebyte(i8 zeroext 68) #15, !dbg !2547
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !2548
  tail call void @spi_writebyte(i8 zeroext 16) #15, !dbg !2549
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !2550
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2551
  %1 = tail call i32 @norflash_wait_ok() #15, !dbg !2552
  tail call void asm sideeffect "csync;", ""() #13, !dbg !2553, !srcloc !2556
  tail call void @norflash_write_enable() #15, !dbg !2557
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2558
  tail call void @spi_writebyte(i8 zeroext 68) #15, !dbg !2559
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !2560
  tail call void @spi_writebyte(i8 zeroext 32) #15, !dbg !2561
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !2562
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2563
  %2 = tail call i32 @norflash_wait_ok() #15, !dbg !2564
  tail call void asm sideeffect "csync;", ""() #13, !dbg !2565, !srcloc !2568
  tail call void @norflash_write_enable() #15, !dbg !2569
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2570
  tail call void @spi_writebyte(i8 zeroext 68) #15, !dbg !2571
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !2572
  tail call void @spi_writebyte(i8 zeroext 48) #15, !dbg !2573
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !2574
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2575
  %3 = tail call i32 @norflash_wait_ok() #15, !dbg !2576
  tail call void asm sideeffect "csync;", ""() #13, !dbg !2577, !srcloc !2580
  tail call void @exit_spi_code(i32 0) #15, !dbg !2581
  ret i32 0, !dbg !2582
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_write_otp(i8* nocapture readonly, i32, i32) #0 section ".spi_code" !dbg !2583 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !2588, metadata !442), !dbg !2597
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2589, metadata !442), !dbg !2598
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2590, metadata !442), !dbg !2599
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2592, metadata !442), !dbg !2600
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2593, metadata !442), !dbg !2601
  tail call void @enter_spi_code() #15, !dbg !2602
  br label %4, !dbg !2603

; <label>:4:                                      ; preds = %24, %3
  %5 = phi i32 [ 0, %3 ], [ %16, %24 ]
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !2593, metadata !442), !dbg !2601
  %6 = icmp slt i32 %5, %1, !dbg !2604
  br i1 %6, label %7, label %26, !dbg !2606

; <label>:7:                                      ; preds = %4
  tail call void @norflash_write_enable() #15, !dbg !2607
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2609
  tail call void @spi_writebyte(i8 zeroext 66) #15, !dbg !2610
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !2611
  %8 = lshr i32 %5, 8, !dbg !2612
  %9 = trunc i32 %5 to i8, !dbg !2613
  tail call void @llvm.dbg.value(metadata i8 %9, i64 0, metadata !2595, metadata !442), !dbg !2614
  %10 = sdiv i32 %5, %2, !dbg !2615
  %11 = shl i32 %10, 4, !dbg !2616
  %12 = add nsw i32 %11, 16, !dbg !2617
  %13 = or i32 %12, %8, !dbg !2618
  %14 = trunc i32 %13 to i8, !dbg !2619
  tail call void @llvm.dbg.value(metadata i8 %14, i64 0, metadata !2596, metadata !442), !dbg !2620
  tail call void @spi_writebyte(i8 zeroext %14) #15, !dbg !2621
  tail call void @spi_writebyte(i8 zeroext %9) #15, !dbg !2622
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2591, metadata !442), !dbg !2623
  br label %15, !dbg !2624

; <label>:15:                                     ; preds = %19, %7
  %16 = phi i32 [ %5, %7 ], [ %22, %19 ]
  %17 = phi i32 [ 0, %7 ], [ %23, %19 ]
  tail call void @llvm.dbg.value(metadata i32 %17, i64 0, metadata !2591, metadata !442), !dbg !2623
  tail call void @llvm.dbg.value(metadata i32 %16, i64 0, metadata !2593, metadata !442), !dbg !2601
  %18 = icmp slt i32 %17, %2, !dbg !2626
  br i1 %18, label %19, label %24, !dbg !2629

; <label>:19:                                     ; preds = %15
  %20 = getelementptr inbounds i8, i8* %0, i32 %16, !dbg !2631
  %21 = load i8, i8* %20, align 1, !dbg !2631, !tbaa !554
  tail call void @spi_writebyte(i8 zeroext %21) #15, !dbg !2633
  %22 = add nsw i32 %16, 1, !dbg !2634
  tail call void @llvm.dbg.value(metadata i32 %22, i64 0, metadata !2593, metadata !442), !dbg !2601
  %23 = add nuw nsw i32 %17, 1, !dbg !2635
  tail call void @llvm.dbg.value(metadata i32 %23, i64 0, metadata !2591, metadata !442), !dbg !2623
  br label %15, !dbg !2637, !llvm.loop !2638

; <label>:24:                                     ; preds = %15
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2641
  %25 = tail call i32 @norflash_wait_ok() #15, !dbg !2642
  tail call void asm sideeffect "csync;", ""() #13, !dbg !2643, !srcloc !2646
  br label %4, !dbg !2647, !llvm.loop !2649

; <label>:26:                                     ; preds = %4
  tail call void @exit_spi_code(i32 0) #15, !dbg !2651
  ret i32 0, !dbg !2652
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_read_otp(i8* nocapture, i32, i32) #0 section ".spi_code" !dbg !2653 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !2655, metadata !442), !dbg !2662
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2656, metadata !442), !dbg !2663
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2657, metadata !442), !dbg !2664
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2659, metadata !442), !dbg !2665
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2660, metadata !442), !dbg !2666
  tail call void @enter_spi_code() #15, !dbg !2667
  br label %4, !dbg !2668

; <label>:4:                                      ; preds = %21, %3
  %5 = phi i32 [ 0, %3 ], [ %13, %21 ]
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !2660, metadata !442), !dbg !2666
  %6 = icmp slt i32 %5, %1, !dbg !2669
  br i1 %6, label %7, label %22, !dbg !2671

; <label>:7:                                      ; preds = %4
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2672
  tail call void @spi_writebyte(i8 zeroext 72) #15, !dbg !2674
  %8 = sdiv i32 %5, %2, !dbg !2675
  %9 = shl i32 %8, 4, !dbg !2676
  %10 = add nsw i32 %9, 16, !dbg !2677
  %11 = trunc i32 %10 to i8, !dbg !2678
  tail call void @llvm.dbg.value(metadata i8 %11, i64 0, metadata !2661, metadata !442), !dbg !2679
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !2680
  tail call void @spi_writebyte(i8 zeroext %11) #15, !dbg !2681
  tail call void @spi_writebyte(i8 zeroext 0) #15, !dbg !2682
  tail call void @spi_writebyte(i8 zeroext -1) #15, !dbg !2683
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2658, metadata !442), !dbg !2684
  br label %12, !dbg !2685

; <label>:12:                                     ; preds = %16, %7
  %13 = phi i32 [ %5, %7 ], [ %19, %16 ]
  %14 = phi i32 [ 0, %7 ], [ %20, %16 ]
  tail call void @llvm.dbg.value(metadata i32 %14, i64 0, metadata !2658, metadata !442), !dbg !2684
  tail call void @llvm.dbg.value(metadata i32 %13, i64 0, metadata !2660, metadata !442), !dbg !2666
  %15 = icmp slt i32 %14, %2, !dbg !2687
  br i1 %15, label %16, label %21, !dbg !2690

; <label>:16:                                     ; preds = %12
  %17 = tail call zeroext i8 @spi_readbyte() #15, !dbg !2692
  %18 = getelementptr inbounds i8, i8* %0, i32 %13, !dbg !2694
  store i8 %17, i8* %18, align 1, !dbg !2695, !tbaa !554
  %19 = add nsw i32 %13, 1, !dbg !2696
  tail call void @llvm.dbg.value(metadata i32 %19, i64 0, metadata !2660, metadata !442), !dbg !2666
  %20 = add nuw nsw i32 %14, 1, !dbg !2697
  tail call void @llvm.dbg.value(metadata i32 %20, i64 0, metadata !2658, metadata !442), !dbg !2684
  br label %12, !dbg !2699, !llvm.loop !2700

; <label>:21:                                     ; preds = %12
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2703
  br label %4, !dbg !2704, !llvm.loop !2706

; <label>:22:                                     ; preds = %4
  tail call void @exit_spi_code(i32 0) #15, !dbg !2708
  ret i32 0, !dbg !2709
}

; Function Attrs: minsize nounwind optsize
define i32 @norflash_read_otp_general(i8 zeroext, i32, i8*, i32) #0 section ".spi_code" !dbg !2710 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2714, metadata !442), !dbg !2720
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2715, metadata !442), !dbg !2721
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !2716, metadata !442), !dbg !2722
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !2717, metadata !442), !dbg !2723
  %5 = icmp eq i8* %2, null, !dbg !2724
  %6 = icmp eq i32 %3, 0, !dbg !2726
  %7 = or i1 %5, %6, !dbg !2728
  br i1 %7, label %8, label %12, !dbg !2728

; <label>:8:                                      ; preds = %4
  %9 = load i8, i8* @log_tag_const_e_VM, align 1, !dbg !2729, !tbaa !554
  %10 = icmp eq i8 %9, 0, !dbg !2729
  br i1 %10, label %21, label %11, !dbg !2732

; <label>:11:                                     ; preds = %8
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @__FUNCTION__.norflash_read_otp_general, i32 0, i32 0)) #14, !dbg !2733
  br label %21, !dbg !2733

; <label>:12:                                     ; preds = %4
  tail call void @enter_spi_code() #15, !dbg !2735
  tail call void @spi_cs(i8 zeroext 0) #15, !dbg !2736
  tail call void @spi_writebyte(i8 zeroext %0) #15, !dbg !2737
  tail call void @norflash_send_addr(i32 %1) #15, !dbg !2738
  tail call void @spi_writebyte(i8 zeroext -1) #15, !dbg !2739
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2718, metadata !442), !dbg !2740
  br label %13, !dbg !2741

; <label>:13:                                     ; preds = %17, %12
  %14 = phi i32 [ 0, %12 ], [ %20, %17 ]
  tail call void @llvm.dbg.value(metadata i32 %14, i64 0, metadata !2718, metadata !442), !dbg !2740
  %15 = icmp eq i32 %14, %3, !dbg !2742
  br i1 %15, label %16, label %17, !dbg !2745

; <label>:16:                                     ; preds = %13
  tail call void @spi_cs(i8 zeroext 1) #15, !dbg !2747
  tail call void @exit_spi_code(i32 0) #15, !dbg !2748
  br label %21, !dbg !2749

; <label>:17:                                     ; preds = %13
  %18 = tail call zeroext i8 @spi_readbyte() #15, !dbg !2750
  %19 = getelementptr inbounds i8, i8* %2, i32 %14, !dbg !2752
  store i8 %18, i8* %19, align 1, !dbg !2753, !tbaa !554
  %20 = add i32 %14, 1, !dbg !2754
  tail call void @llvm.dbg.value(metadata i32 %20, i64 0, metadata !2718, metadata !442), !dbg !2740
  br label %13, !dbg !2756, !llvm.loop !2757

; <label>:21:                                     ; preds = %16, %11, %8
  %22 = phi i32 [ 0, %16 ], [ -22, %8 ], [ -22, %11 ]
  ret i32 %22, !dbg !2760
}

; Function Attrs: minsize nounwind optsize
define void @MEMCPY_FLASH(i8*, i8*, i32) local_unnamed_addr #0 !dbg !2761 {
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !2765, metadata !442), !dbg !2768
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !2766, metadata !442), !dbg !2769
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2767, metadata !442), !dbg !2770
  %4 = load i32, i32* @norflash_write_cpu_unhold, align 4, !dbg !2771, !tbaa !538
  %5 = icmp eq i32 %4, 0, !dbg !2773
  br i1 %5, label %6, label %12, !dbg !2774

; <label>:6:                                      ; preds = %3
  %7 = getelementptr i8, i8* %1, i32 %2, !dbg !2775
  %8 = ptrtoint i8* %7 to i32, !dbg !2776
  %9 = tail call i32 @cpu_addr2flash_addr(i32 %8) #15, !dbg !2777
  %10 = icmp ult i32 %9, 16777216, !dbg !2778
  br i1 %10, label %11, label %12, !dbg !2779

; <label>:11:                                     ; preds = %6
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %0, i8* %1, i32 %2, i32 1, i1 false), !dbg !2781
  br label %34, !dbg !2783

; <label>:12:                                     ; preds = %6, %3
  %13 = icmp ugt i8* %1, inttoptr (i32 33554431 to i8*), !dbg !2784
  %14 = icmp ult i8* %1, inttoptr (i32 67108864 to i8*), !dbg !2787
  %15 = and i1 %13, %14, !dbg !2788
  br i1 %15, label %16, label %20, !dbg !2788

; <label>:16:                                     ; preds = %12
  %17 = ptrtoint i8* %1 to i32, !dbg !2789
  %18 = tail call i32 @cpu_addr2flash_addr(i32 %17) #15, !dbg !2791
  %19 = tail call i32 @norflash_read(%struct.device* undef, i8* %0, i32 %2, i32 %18) #15, !dbg !2793
  br label %34, !dbg !2795

; <label>:20:                                     ; preds = %12
  %21 = load i8, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 1), align 4, !dbg !2796, !tbaa !1542
  %22 = icmp eq i8 %21, 0, !dbg !2799
  br i1 %22, label %27, label %23, !dbg !2800

; <label>:23:                                     ; preds = %20
  %24 = tail call i32 @os_mutex_pend(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex, i32 0) #14, !dbg !2801
  %25 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !2801, !tbaa !554
  %26 = add i8 %25, 1, !dbg !2801
  store i8 %26, i8* @sfc_mutex_enter_cnt, align 1, !dbg !2801, !tbaa !554
  br label %27, !dbg !2804

; <label>:27:                                     ; preds = %23, %20
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %0, i8* %1, i32 %2, i32 1, i1 false), !dbg !2805
  %28 = load i8, i8* getelementptr inbounds (%struct.flash_info, %struct.flash_info* @flash_info, i32 0, i32 1), align 4, !dbg !2806, !tbaa !1542
  %29 = icmp eq i8 %28, 0, !dbg !2808
  br i1 %29, label %34, label %30, !dbg !2809

; <label>:30:                                     ; preds = %27
  %31 = load i8, i8* @sfc_mutex_enter_cnt, align 1, !dbg !2810, !tbaa !554
  %32 = add i8 %31, -1, !dbg !2810
  store i8 %32, i8* @sfc_mutex_enter_cnt, align 1, !dbg !2810, !tbaa !554
  %33 = tail call i32 @os_mutex_post(%struct.xSTATIC_QUEUE* nonnull @sfc_norflash_mutex) #14, !dbg !2810
  br label %34, !dbg !2813

; <label>:34:                                     ; preds = %30, %27, %16, %11
  ret void, !dbg !2814
}

; Function Attrs: minsize optsize
declare void @request_irq(i8 zeroext, i8 zeroext, void ()*, i8 zeroext) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
define internal void @another_cpu_irq() #11 section ".volatile_ram_code" !dbg !2815 {
  %1 = tail call i32 asm sideeffect "$0 = cnum", "=r"() #13, !dbg !2816, !srcloc !592
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !588, metadata !442) #13, !dbg !2819
  %2 = icmp eq i32 %1, 0, !dbg !2820
  %3 = select i1 %2, i32 32, i32 16, !dbg !2821
  store volatile i32 %3, i32* inttoptr (i32 32436644 to i32*), align 4, !tbaa !2822
  tail call void @__local_irq_disable() #14, !dbg !2823
  tail call void asm sideeffect "csync;", ""() #13, !dbg !2824, !srcloc !2827
  br label %4, !dbg !2828

; <label>:4:                                      ; preds = %4, %0
  %5 = load volatile i32, i32* inttoptr (i32 32432136 to i32*), align 8, !dbg !2829, !tbaa !448
  %6 = and i32 %5, 16384, !dbg !2831
  %7 = icmp eq i32 %6, 0, !dbg !2832
  br i1 %7, label %4, label %8, !dbg !2833, !llvm.loop !2834

; <label>:8:                                      ; preds = %4
  %9 = load volatile i8, i8* @cpu1_run_flag, align 1, !dbg !2836, !tbaa !554
  %10 = icmp eq i8 %9, 0, !dbg !2836
  br i1 %10, label %11, label %16, !dbg !2838

; <label>:11:                                     ; preds = %8
  %12 = load void (i8*)*, void (i8*)** @cpu_do_in_irq_func, align 4, !dbg !2839, !tbaa !573
  %13 = icmp eq void (i8*)* %12, null, !dbg !2839
  br i1 %13, label %27, label %14, !dbg !2842

; <label>:14:                                     ; preds = %11
  %15 = load i8*, i8** @cpu_do_in_irq_priv, align 4, !dbg !2843, !tbaa !573
  tail call void %12(i8* %15) #14, !dbg !2845
  br label %27, !dbg !2846

; <label>:16:                                     ; preds = %8
  store volatile i8 1, i8* @cpu_wait_flag, align 1, !dbg !2847, !tbaa !554
  tail call void asm sideeffect "csync;", ""() #13, !dbg !2851, !srcloc !2854
  tail call void asm sideeffect "csync;", ""() #13, !dbg !2855, !srcloc !2858
  %17 = load void (i8*)*, void (i8*)** @cpu_do_in_irq_func, align 4, !dbg !2859, !tbaa !573
  %18 = icmp eq void (i8*)* %17, null, !dbg !2859
  br i1 %18, label %21, label %19, !dbg !2861

; <label>:19:                                     ; preds = %16
  %20 = load i8*, i8** @cpu_do_in_irq_priv, align 4, !dbg !2862, !tbaa !573
  tail call void %17(i8* %20) #14, !dbg !2864
  br label %21, !dbg !2865

; <label>:21:                                     ; preds = %19, %16
  br label %22, !dbg !2866

; <label>:22:                                     ; preds = %25, %21
  %23 = load volatile i8, i8* @cpu_wait_flag, align 1, !dbg !2866, !tbaa !554
  %24 = icmp eq i8 %23, 0, !dbg !2866
  br i1 %24, label %26, label %25, !dbg !2866

; <label>:25:                                     ; preds = %22
  tail call void asm sideeffect "csync;", ""() #13, !dbg !2868, !srcloc !2872
  br label %22, !dbg !2873, !llvm.loop !2875

; <label>:26:                                     ; preds = %22
  store volatile i8 0, i8* @cpu_wait_flag, align 1, !dbg !2877, !tbaa !554
  tail call void asm sideeffect "csync;", ""() #13, !dbg !2880, !srcloc !2883
  br label %27

; <label>:27:                                     ; preds = %26, %14, %11
  tail call void @__local_irq_enable() #14, !dbg !2884
  ret void, !dbg !2885
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i32, i1) #3

; Function Attrs: minsize nounwind optsize readonly
declare i32 @memcmp(i8* nocapture, i8* nocapture, i32) local_unnamed_addr #12

; Function Attrs: minsize optsize
declare void @printf_buf(i8*, i32) local_unnamed_addr #2

; Function Attrs: minsize nounwind optsize
declare i32 @printf(i8* nocapture readonly, ...) local_unnamed_addr #9

; Function Attrs: minsize optsize
declare i8* @os_current_task_rom(...) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare void @cpu_assert_debug(...) local_unnamed_addr #2

; Function Attrs: minsize optsize
declare void @P33_SYSTEM_RESET() local_unnamed_addr #2

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #1

attributes #0 = { minsize nounwind optsize "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { minsize optsize "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { minsize nounwind optsize readonly "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { alwaysinline minsize norecurse nounwind optsize "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { alwaysinline minsize nounwind optsize "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { minsize norecurse nounwind optsize readonly "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { minsize nounwind optsize readnone "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { minsize nounwind optsize "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #10 = { minsize norecurse nounwind optsize readnone "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #11 = { minsize nounwind optsize "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "interrupt" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #12 = { minsize nounwind optsize readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #13 = { nounwind }
attributes #14 = { minsize nounwind optsize }
attributes #15 = { minsize optsize }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!431, !432}
!llvm.ident = !{!433}

!0 = !DIGlobalVariableExpression(var: !1)
!1 = distinct !DIGlobalVariable(name: "cpu_do_in_irq_func", scope: !2, file: !3, line: 21, type: !428, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 4.0.1 () ()", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !329)
!3 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/cpu/wl82/vm/vm_sfc.c", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!4 = !{}
!5 = !{!6, !104, !108, !109, !235, !249, !258, !266, !267, !105, !280, !282, !283, !313}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 32)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "JL_TypeDef_corex2", file: !8, line: 195, baseType: !9)
!8 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/csfr.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !8, line: 110, size: 7296, elements: !10)
!10 = !{!11, !14, !15, !16, !17, !18, !19, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !47, !48, !49, !50, !51, !52, !53, !54, !55, !59, !60, !61, !62, !63, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !84, !88, !89, !90, !91, !92, !93, !94, !95, !96, !100, !101, !102, !103}
!11 = !DIDerivedType(tag: DW_TAG_member, name: "C0_CON", scope: !9, file: !8, line: 111, baseType: !12, size: 32)
!12 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !13)
!13 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!14 = !DIDerivedType(tag: DW_TAG_member, name: "C1_CON", scope: !9, file: !8, line: 112, baseType: !12, size: 32, offset: 32)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "CACHE_CON", scope: !9, file: !8, line: 113, baseType: !12, size: 32, offset: 64)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "DCACHE_WAY", scope: !9, file: !8, line: 114, baseType: !12, size: 32, offset: 96)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "ICACHE_WAY", scope: !9, file: !8, line: 115, baseType: !12, size: 32, offset: 128)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "RING_OSC", scope: !9, file: !8, line: 116, baseType: !12, size: 32, offset: 160)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "REV_80_3", scope: !9, file: !8, line: 117, baseType: !20, size: 3904, offset: 192)
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 3904, elements: !22)
!21 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !12)
!22 = !{!23}
!23 = !DISubrange(count: 122)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "C0_IF_UACNTL", scope: !9, file: !8, line: 119, baseType: !12, size: 32, offset: 4096)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "C0_IF_UACNTH", scope: !9, file: !8, line: 120, baseType: !12, size: 32, offset: 4128)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "C0_RD_UACNTL", scope: !9, file: !8, line: 121, baseType: !12, size: 32, offset: 4160)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "C0_RD_UACNTH", scope: !9, file: !8, line: 122, baseType: !12, size: 32, offset: 4192)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "C0_WR_UACNTL", scope: !9, file: !8, line: 123, baseType: !12, size: 32, offset: 4224)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "C0_WR_UACNTH", scope: !9, file: !8, line: 124, baseType: !12, size: 32, offset: 4256)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "C0_TL_CKCNTL", scope: !9, file: !8, line: 125, baseType: !12, size: 32, offset: 4288)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "C0_TL_CKCNTH", scope: !9, file: !8, line: 126, baseType: !12, size: 32, offset: 4320)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "C1_IF_UACNTL", scope: !9, file: !8, line: 127, baseType: !12, size: 32, offset: 4352)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "C1_IF_UACNTH", scope: !9, file: !8, line: 128, baseType: !12, size: 32, offset: 4384)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "C1_RD_UACNTL", scope: !9, file: !8, line: 129, baseType: !12, size: 32, offset: 4416)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "C1_RD_UACNTH", scope: !9, file: !8, line: 130, baseType: !12, size: 32, offset: 4448)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "C1_WR_UACNTL", scope: !9, file: !8, line: 131, baseType: !12, size: 32, offset: 4480)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "C1_WR_UACNTH", scope: !9, file: !8, line: 132, baseType: !12, size: 32, offset: 4512)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "C1_TL_CKCNTL", scope: !9, file: !8, line: 133, baseType: !12, size: 32, offset: 4544)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "C1_TL_CKCNTH", scope: !9, file: !8, line: 134, baseType: !12, size: 32, offset: 4576)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "DBG_WR_EN", scope: !9, file: !8, line: 136, baseType: !12, size: 32, offset: 4608)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "DBG_MSG", scope: !9, file: !8, line: 137, baseType: !21, size: 32, offset: 4640)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "DBG_MSG_CLR", scope: !9, file: !8, line: 138, baseType: !12, size: 32, offset: 4672)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "REV_9c_92", scope: !9, file: !8, line: 139, baseType: !44, size: 416, offset: 4704)
!44 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 416, elements: !45)
!45 = !{!46}
!46 = !DISubrange(count: 13)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT0_H", scope: !9, file: !8, line: 141, baseType: !12, size: 32, offset: 5120)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT1_H", scope: !9, file: !8, line: 142, baseType: !12, size: 32, offset: 5152)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT2_H", scope: !9, file: !8, line: 143, baseType: !12, size: 32, offset: 5184)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT3_H", scope: !9, file: !8, line: 144, baseType: !12, size: 32, offset: 5216)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT4_H", scope: !9, file: !8, line: 145, baseType: !12, size: 32, offset: 5248)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT5_H", scope: !9, file: !8, line: 146, baseType: !12, size: 32, offset: 5280)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT6_H", scope: !9, file: !8, line: 147, baseType: !12, size: 32, offset: 5312)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT7_H", scope: !9, file: !8, line: 148, baseType: !12, size: 32, offset: 5344)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "REV_b0_a7", scope: !9, file: !8, line: 149, baseType: !56, size: 256, offset: 5376)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 256, elements: !57)
!57 = !{!58}
!58 = !DISubrange(count: 8)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT0_L", scope: !9, file: !8, line: 151, baseType: !12, size: 32, offset: 5632)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT1_L", scope: !9, file: !8, line: 152, baseType: !12, size: 32, offset: 5664)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT2_L", scope: !9, file: !8, line: 153, baseType: !12, size: 32, offset: 5696)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT3_L", scope: !9, file: !8, line: 154, baseType: !12, size: 32, offset: 5728)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT4_L", scope: !9, file: !8, line: 155, baseType: !12, size: 32, offset: 5760)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT5_L", scope: !9, file: !8, line: 156, baseType: !12, size: 32, offset: 5792)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT6_L", scope: !9, file: !8, line: 157, baseType: !12, size: 32, offset: 5824)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "WR_LIMIT7_L", scope: !9, file: !8, line: 158, baseType: !12, size: 32, offset: 5856)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "REV_c0_b7", scope: !9, file: !8, line: 159, baseType: !56, size: 256, offset: 5888)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "WR_ALLOW_ID0", scope: !9, file: !8, line: 161, baseType: !12, size: 32, offset: 6144)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "WR_ALLOW_ID1", scope: !9, file: !8, line: 162, baseType: !12, size: 32, offset: 6176)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "WR_ALLOW_ID2", scope: !9, file: !8, line: 163, baseType: !12, size: 32, offset: 6208)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "WR_ALLOW_ID3", scope: !9, file: !8, line: 164, baseType: !12, size: 32, offset: 6240)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "WR_ALLOW_ID4", scope: !9, file: !8, line: 165, baseType: !12, size: 32, offset: 6272)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "WR_ALLOW_ID5", scope: !9, file: !8, line: 166, baseType: !12, size: 32, offset: 6304)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "WR_ALLOW_ID6", scope: !9, file: !8, line: 167, baseType: !12, size: 32, offset: 6336)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "WR_ALLOW_ID7", scope: !9, file: !8, line: 168, baseType: !12, size: 32, offset: 6368)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "REV_d0_c7", scope: !9, file: !8, line: 169, baseType: !56, size: 256, offset: 6400)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "DBG_EN", scope: !9, file: !8, line: 171, baseType: !12, size: 32, offset: 6656)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "DBG_CON", scope: !9, file: !8, line: 172, baseType: !12, size: 32, offset: 6688)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "C0_WR_LIMIT_EN", scope: !9, file: !8, line: 173, baseType: !12, size: 32, offset: 6720)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "C1_WR_LIMIT_EN", scope: !9, file: !8, line: 174, baseType: !12, size: 32, offset: 6752)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "PRP_WR_LIMIT_EN", scope: !9, file: !8, line: 175, baseType: !12, size: 32, offset: 6784)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "PRP_WR_ALLOW_EN", scope: !9, file: !8, line: 176, baseType: !12, size: 32, offset: 6816)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "PRP_OUTLIM_ERR_EN", scope: !9, file: !8, line: 177, baseType: !12, size: 32, offset: 6848)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "REV_d8_d5", scope: !9, file: !8, line: 178, baseType: !85, size: 32, offset: 6880)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 32, elements: !86)
!86 = !{!87}
!87 = !DISubrange(count: 1)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "C0_WR_LIMIT_ERR_NUM", scope: !9, file: !8, line: 180, baseType: !21, size: 32, offset: 6912)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "C1_WR_LIMIT_ERR_NUM", scope: !9, file: !8, line: 181, baseType: !21, size: 32, offset: 6944)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "PRP_WR_LIMIT_ERR_NUM", scope: !9, file: !8, line: 182, baseType: !21, size: 32, offset: 6976)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "PRP_WR_LIMIT_ID", scope: !9, file: !8, line: 183, baseType: !21, size: 32, offset: 7008)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "AXI_RD_INV_ID", scope: !9, file: !8, line: 184, baseType: !21, size: 32, offset: 7040)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "AXI_WR_INV_ID", scope: !9, file: !8, line: 185, baseType: !21, size: 32, offset: 7072)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "PRP_MMU_ERR_WID", scope: !9, file: !8, line: 186, baseType: !21, size: 32, offset: 7104)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "PRP_MMU_ERR_RID", scope: !9, file: !8, line: 187, baseType: !21, size: 32, offset: 7136)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "REV_e0_de", scope: !9, file: !8, line: 188, baseType: !97, offset: 7168)
!97 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, elements: !98)
!98 = !{!99}
!99 = !DISubrange(count: 0)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "PC_LIMIT0_H", scope: !9, file: !8, line: 190, baseType: !12, size: 32, offset: 7168)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "PC_LIMIT0_L", scope: !9, file: !8, line: 191, baseType: !12, size: 32, offset: 7200)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "PC_LIMIT1_H", scope: !9, file: !8, line: 192, baseType: !12, size: 32, offset: 7232)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "PC_LIMIT1_L", scope: !9, file: !8, line: 193, baseType: !12, size: 32, offset: 7264)
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !105, size: 32)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "u8", file: !106, line: 14, baseType: !107)
!106 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/cpu.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!107 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!108 = !DIDerivedType(tag: DW_TAG_typedef, name: "u32", file: !106, line: 19, baseType: !13)
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !110, size: 32)
!110 = !DIDerivedType(tag: DW_TAG_typedef, name: "JL_TypeDef_q32DSP", file: !8, line: 337, baseType: !111)
!111 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !8, line: 221, size: 3904, elements: !112)
!112 = !{!113, !114, !115, !116, !117, !118, !119, !120, !121, !122, !123, !124, !125, !126, !127, !128, !129, !130, !131, !132, !133, !134, !135, !136, !137, !138, !139, !140, !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151, !152, !156, !157, !161, !162, !163, !164, !165, !166, !167, !168, !170, !172, !173, !174, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194, !195, !196, !197, !198, !199, !200, !201, !202, !203, !204, !205, !206, !207, !208, !209, !210, !211, !212, !213, !214, !215, !216, !217, !218, !219, !220, !221, !225, !226, !227, !228, !229, !230, !231, !232, !233, !234}
!113 = !DIDerivedType(tag: DW_TAG_member, name: "DR00", scope: !111, file: !8, line: 222, baseType: !21, size: 32)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "DR01", scope: !111, file: !8, line: 223, baseType: !21, size: 32, offset: 32)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "DR02", scope: !111, file: !8, line: 224, baseType: !21, size: 32, offset: 64)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "DR03", scope: !111, file: !8, line: 225, baseType: !21, size: 32, offset: 96)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "DR04", scope: !111, file: !8, line: 226, baseType: !21, size: 32, offset: 128)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "DR05", scope: !111, file: !8, line: 227, baseType: !21, size: 32, offset: 160)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "DR06", scope: !111, file: !8, line: 228, baseType: !21, size: 32, offset: 192)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "DR07", scope: !111, file: !8, line: 229, baseType: !21, size: 32, offset: 224)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "DR08", scope: !111, file: !8, line: 230, baseType: !21, size: 32, offset: 256)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "DR09", scope: !111, file: !8, line: 231, baseType: !21, size: 32, offset: 288)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "DR10", scope: !111, file: !8, line: 232, baseType: !21, size: 32, offset: 320)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "DR11", scope: !111, file: !8, line: 233, baseType: !21, size: 32, offset: 352)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "DR12", scope: !111, file: !8, line: 234, baseType: !21, size: 32, offset: 384)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "DR13", scope: !111, file: !8, line: 235, baseType: !21, size: 32, offset: 416)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "DR14", scope: !111, file: !8, line: 236, baseType: !21, size: 32, offset: 448)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "DR15", scope: !111, file: !8, line: 237, baseType: !21, size: 32, offset: 480)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "RETI", scope: !111, file: !8, line: 239, baseType: !21, size: 32, offset: 512)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "RETE", scope: !111, file: !8, line: 240, baseType: !21, size: 32, offset: 544)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "RETX", scope: !111, file: !8, line: 241, baseType: !21, size: 32, offset: 576)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "RETS", scope: !111, file: !8, line: 242, baseType: !21, size: 32, offset: 608)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "SR04", scope: !111, file: !8, line: 243, baseType: !21, size: 32, offset: 640)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "PSR", scope: !111, file: !8, line: 244, baseType: !21, size: 32, offset: 672)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "CNUM", scope: !111, file: !8, line: 245, baseType: !21, size: 32, offset: 704)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "SR07", scope: !111, file: !8, line: 246, baseType: !21, size: 32, offset: 736)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "SR08", scope: !111, file: !8, line: 247, baseType: !21, size: 32, offset: 768)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "SR09", scope: !111, file: !8, line: 248, baseType: !21, size: 32, offset: 800)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "SR10", scope: !111, file: !8, line: 249, baseType: !21, size: 32, offset: 832)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG", scope: !111, file: !8, line: 250, baseType: !21, size: 32, offset: 864)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "USP", scope: !111, file: !8, line: 251, baseType: !21, size: 32, offset: 896)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "SSP", scope: !111, file: !8, line: 252, baseType: !21, size: 32, offset: 928)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "SP", scope: !111, file: !8, line: 253, baseType: !21, size: 32, offset: 960)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "PCRS", scope: !111, file: !8, line: 254, baseType: !21, size: 32, offset: 992)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "BPCON", scope: !111, file: !8, line: 256, baseType: !12, size: 32, offset: 1024)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "BSP", scope: !111, file: !8, line: 257, baseType: !12, size: 32, offset: 1056)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "BP0", scope: !111, file: !8, line: 258, baseType: !12, size: 32, offset: 1088)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "BP1", scope: !111, file: !8, line: 259, baseType: !12, size: 32, offset: 1120)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "BP2", scope: !111, file: !8, line: 260, baseType: !12, size: 32, offset: 1152)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "BP3", scope: !111, file: !8, line: 261, baseType: !12, size: 32, offset: 1184)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "CMD_PAUSE", scope: !111, file: !8, line: 262, baseType: !12, size: 32, offset: 1216)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "REV_30_26", scope: !111, file: !8, line: 263, baseType: !153, size: 288, offset: 1248)
!153 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 288, elements: !154)
!154 = !{!155}
!155 = !DISubrange(count: 9)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "PMU_CON", scope: !111, file: !8, line: 265, baseType: !12, size: 32, offset: 1536)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "REV_34_30", scope: !111, file: !8, line: 266, baseType: !158, size: 96, offset: 1568)
!158 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 96, elements: !159)
!159 = !{!160}
!160 = !DISubrange(count: 3)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "EMU_CON", scope: !111, file: !8, line: 267, baseType: !12, size: 32, offset: 1664)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "EMU_MSG", scope: !111, file: !8, line: 268, baseType: !12, size: 32, offset: 1696)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "EMU_SSP_H", scope: !111, file: !8, line: 269, baseType: !12, size: 32, offset: 1728)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "EMU_SSP_L", scope: !111, file: !8, line: 270, baseType: !12, size: 32, offset: 1760)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "EMU_USP_H", scope: !111, file: !8, line: 271, baseType: !12, size: 32, offset: 1792)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "EMU_USP_L", scope: !111, file: !8, line: 272, baseType: !12, size: 32, offset: 1824)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "REV_3b_39", scope: !111, file: !8, line: 273, baseType: !85, size: 32, offset: 1856)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "TTMR_CON", scope: !111, file: !8, line: 274, baseType: !169, size: 8, offset: 1888)
!169 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !107)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "reserved_1_TTMR_CON", scope: !111, file: !8, line: 274, baseType: !171, size: 8, offset: 1896)
!171 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "reserved_2_TTMR_CON", scope: !111, file: !8, line: 274, baseType: !171, size: 8, offset: 1904)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "reserved_3_TTMR_CON", scope: !111, file: !8, line: 274, baseType: !171, size: 8, offset: 1912)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "TTMR_CNT", scope: !111, file: !8, line: 275, baseType: !12, size: 32, offset: 1920)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "TTMR_PRD", scope: !111, file: !8, line: 276, baseType: !12, size: 32, offset: 1952)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "BANK_CON", scope: !111, file: !8, line: 277, baseType: !12, size: 32, offset: 1984)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "BANK_NUM", scope: !111, file: !8, line: 278, baseType: !12, size: 32, offset: 2016)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG00", scope: !111, file: !8, line: 280, baseType: !12, size: 32, offset: 2048)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG01", scope: !111, file: !8, line: 281, baseType: !12, size: 32, offset: 2080)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG02", scope: !111, file: !8, line: 282, baseType: !12, size: 32, offset: 2112)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG03", scope: !111, file: !8, line: 283, baseType: !12, size: 32, offset: 2144)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG04", scope: !111, file: !8, line: 284, baseType: !12, size: 32, offset: 2176)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG05", scope: !111, file: !8, line: 285, baseType: !12, size: 32, offset: 2208)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG06", scope: !111, file: !8, line: 286, baseType: !12, size: 32, offset: 2240)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG07", scope: !111, file: !8, line: 287, baseType: !12, size: 32, offset: 2272)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG08", scope: !111, file: !8, line: 288, baseType: !12, size: 32, offset: 2304)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG09", scope: !111, file: !8, line: 289, baseType: !12, size: 32, offset: 2336)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG10", scope: !111, file: !8, line: 290, baseType: !12, size: 32, offset: 2368)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG11", scope: !111, file: !8, line: 291, baseType: !12, size: 32, offset: 2400)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG12", scope: !111, file: !8, line: 292, baseType: !12, size: 32, offset: 2432)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG13", scope: !111, file: !8, line: 293, baseType: !12, size: 32, offset: 2464)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG14", scope: !111, file: !8, line: 294, baseType: !12, size: 32, offset: 2496)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG15", scope: !111, file: !8, line: 295, baseType: !12, size: 32, offset: 2528)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG16", scope: !111, file: !8, line: 297, baseType: !12, size: 32, offset: 2560)
!195 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG17", scope: !111, file: !8, line: 298, baseType: !12, size: 32, offset: 2592)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG18", scope: !111, file: !8, line: 299, baseType: !12, size: 32, offset: 2624)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG19", scope: !111, file: !8, line: 300, baseType: !12, size: 32, offset: 2656)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG20", scope: !111, file: !8, line: 301, baseType: !12, size: 32, offset: 2688)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG21", scope: !111, file: !8, line: 302, baseType: !12, size: 32, offset: 2720)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG22", scope: !111, file: !8, line: 303, baseType: !12, size: 32, offset: 2752)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG23", scope: !111, file: !8, line: 304, baseType: !12, size: 32, offset: 2784)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG24", scope: !111, file: !8, line: 305, baseType: !12, size: 32, offset: 2816)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG25", scope: !111, file: !8, line: 306, baseType: !12, size: 32, offset: 2848)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG26", scope: !111, file: !8, line: 307, baseType: !12, size: 32, offset: 2880)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG27", scope: !111, file: !8, line: 308, baseType: !12, size: 32, offset: 2912)
!206 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG28", scope: !111, file: !8, line: 309, baseType: !12, size: 32, offset: 2944)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG29", scope: !111, file: !8, line: 310, baseType: !12, size: 32, offset: 2976)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG30", scope: !111, file: !8, line: 311, baseType: !12, size: 32, offset: 3008)
!209 = !DIDerivedType(tag: DW_TAG_member, name: "ICFG31", scope: !111, file: !8, line: 312, baseType: !12, size: 32, offset: 3040)
!210 = !DIDerivedType(tag: DW_TAG_member, name: "IPND0", scope: !111, file: !8, line: 314, baseType: !21, size: 32, offset: 3072)
!211 = !DIDerivedType(tag: DW_TAG_member, name: "IPND1", scope: !111, file: !8, line: 315, baseType: !21, size: 32, offset: 3104)
!212 = !DIDerivedType(tag: DW_TAG_member, name: "IPND2", scope: !111, file: !8, line: 316, baseType: !21, size: 32, offset: 3136)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "IPND3", scope: !111, file: !8, line: 317, baseType: !21, size: 32, offset: 3168)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "IPND4", scope: !111, file: !8, line: 318, baseType: !21, size: 32, offset: 3200)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "IPND5", scope: !111, file: !8, line: 319, baseType: !21, size: 32, offset: 3232)
!216 = !DIDerivedType(tag: DW_TAG_member, name: "IPND6", scope: !111, file: !8, line: 320, baseType: !21, size: 32, offset: 3264)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "IPND7", scope: !111, file: !8, line: 321, baseType: !21, size: 32, offset: 3296)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "ILAT_SET", scope: !111, file: !8, line: 322, baseType: !12, size: 32, offset: 3328)
!219 = !DIDerivedType(tag: DW_TAG_member, name: "ILAT_CLR", scope: !111, file: !8, line: 323, baseType: !12, size: 32, offset: 3360)
!220 = !DIDerivedType(tag: DW_TAG_member, name: "IPMASK", scope: !111, file: !8, line: 324, baseType: !12, size: 32, offset: 3392)
!221 = !DIDerivedType(tag: DW_TAG_member, name: "REV_70_6a", scope: !111, file: !8, line: 325, baseType: !222, size: 160, offset: 3424)
!222 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 160, elements: !223)
!223 = !{!224}
!224 = !DISubrange(count: 5)
!225 = !DIDerivedType(tag: DW_TAG_member, name: "ETM_CON", scope: !111, file: !8, line: 327, baseType: !12, size: 32, offset: 3584)
!226 = !DIDerivedType(tag: DW_TAG_member, name: "ETM_PC0", scope: !111, file: !8, line: 328, baseType: !21, size: 32, offset: 3616)
!227 = !DIDerivedType(tag: DW_TAG_member, name: "ETM_PC1", scope: !111, file: !8, line: 329, baseType: !21, size: 32, offset: 3648)
!228 = !DIDerivedType(tag: DW_TAG_member, name: "ETM_PC2", scope: !111, file: !8, line: 330, baseType: !21, size: 32, offset: 3680)
!229 = !DIDerivedType(tag: DW_TAG_member, name: "ETM_PC3", scope: !111, file: !8, line: 331, baseType: !21, size: 32, offset: 3712)
!230 = !DIDerivedType(tag: DW_TAG_member, name: "WP0_ADRH", scope: !111, file: !8, line: 332, baseType: !12, size: 32, offset: 3744)
!231 = !DIDerivedType(tag: DW_TAG_member, name: "WP0_ADRL", scope: !111, file: !8, line: 333, baseType: !12, size: 32, offset: 3776)
!232 = !DIDerivedType(tag: DW_TAG_member, name: "WP0_DATH", scope: !111, file: !8, line: 334, baseType: !12, size: 32, offset: 3808)
!233 = !DIDerivedType(tag: DW_TAG_member, name: "WP0_DATL", scope: !111, file: !8, line: 335, baseType: !12, size: 32, offset: 3840)
!234 = !DIDerivedType(tag: DW_TAG_member, name: "WP0_PC", scope: !111, file: !8, line: 336, baseType: !12, size: 32, offset: 3872)
!235 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !236, size: 32)
!236 = !DIDerivedType(tag: DW_TAG_typedef, name: "JL_PORT_FLASH_TypeDef", file: !237, line: 261, baseType: !238)
!237 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/WL82.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!238 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !237, line: 251, size: 288, elements: !239)
!239 = !{!240, !241, !242, !243, !244, !245, !246, !247, !248}
!240 = !DIDerivedType(tag: DW_TAG_member, name: "OUT", scope: !238, file: !237, line: 252, baseType: !12, size: 32)
!241 = !DIDerivedType(tag: DW_TAG_member, name: "IN", scope: !238, file: !237, line: 253, baseType: !21, size: 32, offset: 32)
!242 = !DIDerivedType(tag: DW_TAG_member, name: "DIR", scope: !238, file: !237, line: 254, baseType: !12, size: 32, offset: 64)
!243 = !DIDerivedType(tag: DW_TAG_member, name: "DIE", scope: !238, file: !237, line: 255, baseType: !12, size: 32, offset: 96)
!244 = !DIDerivedType(tag: DW_TAG_member, name: "PU", scope: !238, file: !237, line: 256, baseType: !12, size: 32, offset: 128)
!245 = !DIDerivedType(tag: DW_TAG_member, name: "PD", scope: !238, file: !237, line: 257, baseType: !12, size: 32, offset: 160)
!246 = !DIDerivedType(tag: DW_TAG_member, name: "HD0", scope: !238, file: !237, line: 258, baseType: !12, size: 32, offset: 192)
!247 = !DIDerivedType(tag: DW_TAG_member, name: "HD", scope: !238, file: !237, line: 259, baseType: !12, size: 32, offset: 224)
!248 = !DIDerivedType(tag: DW_TAG_member, name: "DIEH", scope: !238, file: !237, line: 260, baseType: !12, size: 32, offset: 256)
!249 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !250, size: 32)
!250 = !DIDerivedType(tag: DW_TAG_typedef, name: "JL_SPI_TypeDef", file: !237, line: 555, baseType: !251)
!251 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !237, line: 549, size: 160, elements: !252)
!252 = !{!253, !254, !255, !256, !257}
!253 = !DIDerivedType(tag: DW_TAG_member, name: "CON", scope: !251, file: !237, line: 550, baseType: !12, size: 32)
!254 = !DIDerivedType(tag: DW_TAG_member, name: "BAUD", scope: !251, file: !237, line: 551, baseType: !12, size: 32, offset: 32)
!255 = !DIDerivedType(tag: DW_TAG_member, name: "BUF", scope: !251, file: !237, line: 552, baseType: !12, size: 32, offset: 64)
!256 = !DIDerivedType(tag: DW_TAG_member, name: "ADR", scope: !251, file: !237, line: 553, baseType: !12, size: 32, offset: 96)
!257 = !DIDerivedType(tag: DW_TAG_member, name: "CNT", scope: !251, file: !237, line: 554, baseType: !12, size: 32, offset: 128)
!258 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !259, size: 32)
!259 = !DIDerivedType(tag: DW_TAG_typedef, name: "JL_SFC_TypeDef", file: !237, line: 44, baseType: !260)
!260 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !237, line: 39, size: 128, elements: !261)
!261 = !{!262, !263, !264, !265}
!262 = !DIDerivedType(tag: DW_TAG_member, name: "CON", scope: !260, file: !237, line: 40, baseType: !12, size: 32)
!263 = !DIDerivedType(tag: DW_TAG_member, name: "BAUD", scope: !260, file: !237, line: 41, baseType: !12, size: 32, offset: 32)
!264 = !DIDerivedType(tag: DW_TAG_member, name: "CODE", scope: !260, file: !237, line: 42, baseType: !12, size: 32, offset: 64)
!265 = !DIDerivedType(tag: DW_TAG_member, name: "BASE_ADR", scope: !260, file: !237, line: 43, baseType: !12, size: 32, offset: 96)
!266 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!267 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !268, size: 32)
!268 = !DIDerivedType(tag: DW_TAG_typedef, name: "JL_IOMAP_TypeDef", file: !237, line: 317, baseType: !269)
!269 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !237, line: 307, size: 288, elements: !270)
!270 = !{!271, !272, !273, !274, !275, !276, !277, !278, !279}
!271 = !DIDerivedType(tag: DW_TAG_member, name: "CON0", scope: !269, file: !237, line: 308, baseType: !12, size: 32)
!272 = !DIDerivedType(tag: DW_TAG_member, name: "CON1", scope: !269, file: !237, line: 309, baseType: !12, size: 32, offset: 32)
!273 = !DIDerivedType(tag: DW_TAG_member, name: "CON2", scope: !269, file: !237, line: 310, baseType: !12, size: 32, offset: 64)
!274 = !DIDerivedType(tag: DW_TAG_member, name: "CON3", scope: !269, file: !237, line: 311, baseType: !12, size: 32, offset: 96)
!275 = !DIDerivedType(tag: DW_TAG_member, name: "CON4", scope: !269, file: !237, line: 312, baseType: !12, size: 32, offset: 128)
!276 = !DIDerivedType(tag: DW_TAG_member, name: "CON5", scope: !269, file: !237, line: 313, baseType: !12, size: 32, offset: 160)
!277 = !DIDerivedType(tag: DW_TAG_member, name: "CON6", scope: !269, file: !237, line: 314, baseType: !12, size: 32, offset: 192)
!278 = !DIDerivedType(tag: DW_TAG_member, name: "CON7", scope: !269, file: !237, line: 315, baseType: !12, size: 32, offset: 224)
!279 = !DIDerivedType(tag: DW_TAG_member, name: "CON8", scope: !269, file: !237, line: 316, baseType: !12, size: 32, offset: 256)
!280 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !281, size: 32)
!281 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!282 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 32)
!283 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !284, size: 32)
!284 = !DIDerivedType(tag: DW_TAG_typedef, name: "BOOT_INFO", file: !285, line: 34, baseType: !286)
!285 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/system/boot.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!286 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_boot_info", file: !285, line: 27, size: 320, elements: !287)
!287 = !{!288, !295, !300, !301, !304, !305}
!288 = !DIDerivedType(tag: DW_TAG_member, name: "vm", scope: !286, file: !285, line: 28, baseType: !289, size: 128)
!289 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vm_info", file: !285, line: 6, size: 128, elements: !290)
!290 = !{!291, !292, !293, !294}
!291 = !DIDerivedType(tag: DW_TAG_member, name: "align", scope: !289, file: !285, line: 8, baseType: !105, size: 8)
!292 = !DIDerivedType(tag: DW_TAG_member, name: "vm_saddr", scope: !289, file: !285, line: 10, baseType: !108, size: 32, offset: 32)
!293 = !DIDerivedType(tag: DW_TAG_member, name: "vm_res", scope: !289, file: !285, line: 11, baseType: !108, size: 32, offset: 64)
!294 = !DIDerivedType(tag: DW_TAG_member, name: "vm_size", scope: !289, file: !285, line: 12, baseType: !108, size: 32, offset: 96)
!295 = !DIDerivedType(tag: DW_TAG_member, name: "sfc", scope: !286, file: !285, line: 29, baseType: !296, size: 64, offset: 128)
!296 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "sfc_info", file: !285, line: 15, size: 64, elements: !297)
!297 = !{!298, !299}
!298 = !DIDerivedType(tag: DW_TAG_member, name: "sfc_base_addr", scope: !296, file: !285, line: 16, baseType: !108, size: 32)
!299 = !DIDerivedType(tag: DW_TAG_member, name: "app_addr", scope: !296, file: !285, line: 17, baseType: !108, size: 32, offset: 32)
!300 = !DIDerivedType(tag: DW_TAG_member, name: "flash_size", scope: !286, file: !285, line: 30, baseType: !108, size: 32, offset: 192)
!301 = !DIDerivedType(tag: DW_TAG_member, name: "chip_id", scope: !286, file: !285, line: 31, baseType: !302, size: 16, offset: 224)
!302 = !DIDerivedType(tag: DW_TAG_typedef, name: "u16", file: !106, line: 17, baseType: !303)
!303 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!304 = !DIDerivedType(tag: DW_TAG_member, name: "trim_value", scope: !286, file: !285, line: 32, baseType: !302, size: 16, offset: 240)
!305 = !DIDerivedType(tag: DW_TAG_member, name: "mac", scope: !286, file: !285, line: 33, baseType: !306, size: 64, offset: 256)
!306 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bt_mac_addr", file: !285, line: 22, size: 64, elements: !307)
!307 = !{!308, !312}
!308 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !306, file: !285, line: 23, baseType: !309, size: 48)
!309 = !DICompositeType(tag: DW_TAG_array_type, baseType: !105, size: 48, elements: !310)
!310 = !{!311}
!311 = !DISubrange(count: 6)
!312 = !DIDerivedType(tag: DW_TAG_member, name: "value_crc", scope: !306, file: !285, line: 24, baseType: !302, size: 16, offset: 48)
!313 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !314, size: 32)
!314 = !DIDerivedType(tag: DW_TAG_typedef, name: "JL_SFCENC_TypeDef", file: !237, line: 57, baseType: !315)
!315 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !237, line: 50, size: 192, elements: !316)
!316 = !{!317, !318, !319, !320, !321, !323, !325, !326, !327, !328}
!317 = !DIDerivedType(tag: DW_TAG_member, name: "CON", scope: !315, file: !237, line: 51, baseType: !169, size: 8)
!318 = !DIDerivedType(tag: DW_TAG_member, name: "reserved_1_CON", scope: !315, file: !237, line: 51, baseType: !171, size: 8, offset: 8)
!319 = !DIDerivedType(tag: DW_TAG_member, name: "reserved_2_CON", scope: !315, file: !237, line: 51, baseType: !171, size: 8, offset: 16)
!320 = !DIDerivedType(tag: DW_TAG_member, name: "reserved_3_CON", scope: !315, file: !237, line: 51, baseType: !171, size: 8, offset: 24)
!321 = !DIDerivedType(tag: DW_TAG_member, name: "KEY", scope: !315, file: !237, line: 52, baseType: !322, size: 16, offset: 32)
!322 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !303)
!323 = !DIDerivedType(tag: DW_TAG_member, name: "reserved_1_KEY", scope: !315, file: !237, line: 52, baseType: !324, size: 16, offset: 48)
!324 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!325 = !DIDerivedType(tag: DW_TAG_member, name: "UNENC_ADRH", scope: !315, file: !237, line: 53, baseType: !12, size: 32, offset: 64)
!326 = !DIDerivedType(tag: DW_TAG_member, name: "UNENC_ADRL", scope: !315, file: !237, line: 54, baseType: !12, size: 32, offset: 96)
!327 = !DIDerivedType(tag: DW_TAG_member, name: "LENC_ADRH", scope: !315, file: !237, line: 55, baseType: !12, size: 32, offset: 128)
!328 = !DIDerivedType(tag: DW_TAG_member, name: "LENC_ADRL", scope: !315, file: !237, line: 56, baseType: !12, size: 32, offset: 160)
!329 = !{!330, !333, !346, !348, !350, !352, !373, !0, !422, !424, !426}
!330 = !DIGlobalVariableExpression(var: !331)
!331 = distinct !DIGlobalVariable(name: "is4byte_mode", scope: !2, file: !3, line: 276, type: !332, isLocal: true, isDefinition: true)
!332 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !105)
!333 = !DIGlobalVariableExpression(var: !334)
!334 = distinct !DIGlobalVariable(name: "norflash_lp_target", scope: !2, file: !3, line: 534, type: !335, isLocal: false, isDefinition: true)
!335 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !336)
!336 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "lp_target", file: !337, line: 279, size: 64, elements: !338)
!337 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/power_interface.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!338 = !{!339, !341}
!339 = !DIDerivedType(tag: DW_TAG_member, name: "name", scope: !336, file: !337, line: 280, baseType: !340, size: 32)
!340 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !171, size: 32)
!341 = !DIDerivedType(tag: DW_TAG_member, name: "is_idle", scope: !336, file: !337, line: 281, baseType: !342, size: 32, offset: 32)
!342 = !DIDerivedType(tag: DW_TAG_typedef, name: "idle_handler_t", file: !337, line: 277, baseType: !343)
!343 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !344, size: 32)
!344 = !DISubroutineType(types: !345)
!345 = !{!105}
!346 = !DIGlobalVariableExpression(var: !347)
!347 = distinct !DIGlobalVariable(name: "sfc_is_busy", scope: !2, file: !3, line: 251, type: !332, isLocal: true, isDefinition: true)
!348 = !DIGlobalVariableExpression(var: !349)
!349 = distinct !DIGlobalVariable(name: "sfc_mutex_enter_cnt", scope: !2, file: !3, line: 252, type: !105, isLocal: true, isDefinition: true)
!350 = !DIGlobalVariableExpression(var: !351)
!351 = distinct !DIGlobalVariable(name: "spi_is_no_cmd", scope: !2, file: !3, line: 253, type: !108, isLocal: true, isDefinition: true)
!352 = !DIGlobalVariableExpression(var: !353)
!353 = distinct !DIGlobalVariable(name: "flash_info", scope: !2, file: !3, line: 275, type: !354, isLocal: true, isDefinition: true)
!354 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "flash_info", file: !3, line: 258, size: 640, elements: !355)
!355 = !{!356, !360, !361, !362, !363, !364, !365, !366, !367, !368, !369, !370, !371, !372}
!356 = !DIDerivedType(tag: DW_TAG_member, name: "flash_uuid", scope: !354, file: !3, line: 259, baseType: !357, size: 128)
!357 = !DICompositeType(tag: DW_TAG_array_type, baseType: !105, size: 128, elements: !358)
!358 = !{!359}
!359 = !DISubrange(count: 16)
!360 = !DIDerivedType(tag: DW_TAG_member, name: "init", scope: !354, file: !3, line: 260, baseType: !105, size: 8, offset: 128)
!361 = !DIDerivedType(tag: DW_TAG_member, name: "unhold_cpu", scope: !354, file: !3, line: 261, baseType: !105, size: 8, offset: 136)
!362 = !DIDerivedType(tag: DW_TAG_member, name: "flash_size", scope: !354, file: !3, line: 262, baseType: !108, size: 32, offset: 160)
!363 = !DIDerivedType(tag: DW_TAG_member, name: "flash_capacity", scope: !354, file: !3, line: 263, baseType: !108, size: 32, offset: 192)
!364 = !DIDerivedType(tag: DW_TAG_member, name: "flash_id", scope: !354, file: !3, line: 264, baseType: !108, size: 32, offset: 224)
!365 = !DIDerivedType(tag: DW_TAG_member, name: "vm", scope: !354, file: !3, line: 265, baseType: !289, size: 128, offset: 256)
!366 = !DIDerivedType(tag: DW_TAG_member, name: "sfc", scope: !354, file: !3, line: 266, baseType: !296, size: 64, offset: 384)
!367 = !DIDerivedType(tag: DW_TAG_member, name: "sfc_con", scope: !354, file: !3, line: 267, baseType: !108, size: 32, offset: 448)
!368 = !DIDerivedType(tag: DW_TAG_member, name: "spi_con", scope: !354, file: !3, line: 268, baseType: !108, size: 32, offset: 480)
!369 = !DIDerivedType(tag: DW_TAG_member, name: "spi_con_set", scope: !354, file: !3, line: 269, baseType: !108, size: 32, offset: 512)
!370 = !DIDerivedType(tag: DW_TAG_member, name: "protect_con", scope: !354, file: !3, line: 270, baseType: !108, size: 32, offset: 544)
!371 = !DIDerivedType(tag: DW_TAG_member, name: "protect_con_back", scope: !354, file: !3, line: 271, baseType: !108, size: 32, offset: 576)
!372 = !DIDerivedType(tag: DW_TAG_member, name: "readback_chk_buf", scope: !354, file: !3, line: 272, baseType: !104, size: 32, offset: 608)
!373 = !DIGlobalVariableExpression(var: !374)
!374 = distinct !DIGlobalVariable(name: "sfc_norflash_mutex", scope: !2, file: !3, line: 524, type: !375, isLocal: true, isDefinition: true)
!375 = !DIDerivedType(tag: DW_TAG_typedef, name: "OS_MUTEX", file: !376, line: 59, baseType: !377)
!376 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/system/os/os_type.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!377 = !DIDerivedType(tag: DW_TAG_typedef, name: "StaticSemaphore_t", file: !378, line: 1000, baseType: !379)
!378 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/system/os/FreeRTOS/FreeRTOS.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!379 = !DIDerivedType(tag: DW_TAG_typedef, name: "StaticQueue_t", file: !378, line: 999, baseType: !380)
!380 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xSTATIC_QUEUE", file: !378, line: 974, size: 640, elements: !381)
!381 = !{!382, !384, !392, !413, !415, !419, !420, !421}
!382 = !DIDerivedType(tag: DW_TAG_member, name: "pvDummy1", scope: !380, file: !378, line: 975, baseType: !383, size: 96)
!383 = !DICompositeType(tag: DW_TAG_array_type, baseType: !266, size: 96, elements: !159)
!384 = !DIDerivedType(tag: DW_TAG_member, name: "u", scope: !380, file: !378, line: 980, baseType: !385, size: 32, offset: 96)
!385 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !380, file: !378, line: 977, size: 32, elements: !386)
!386 = !{!387, !388}
!387 = !DIDerivedType(tag: DW_TAG_member, name: "pvDummy2", scope: !385, file: !378, line: 978, baseType: !266, size: 32)
!388 = !DIDerivedType(tag: DW_TAG_member, name: "uxDummy2", scope: !385, file: !378, line: 979, baseType: !389, size: 32)
!389 = !DIDerivedType(tag: DW_TAG_typedef, name: "UBaseType_t", file: !390, line: 89, baseType: !391)
!390 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/system/os/FreeRTOS/pi32v2/portmacro.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!391 = !DIBasicType(name: "long unsigned int", size: 32, encoding: DW_ATE_unsigned)
!392 = !DIDerivedType(tag: DW_TAG_member, name: "xDummy3", scope: !380, file: !378, line: 982, baseType: !393, size: 320, offset: 128)
!393 = !DICompositeType(tag: DW_TAG_array_type, baseType: !394, size: 320, elements: !411)
!394 = !DIDerivedType(tag: DW_TAG_typedef, name: "StaticList_t", file: !378, line: 892, baseType: !395)
!395 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xSTATIC_LIST", file: !378, line: 888, size: 160, elements: !396)
!396 = !{!397, !398, !399}
!397 = !DIDerivedType(tag: DW_TAG_member, name: "uxDummy1", scope: !395, file: !378, line: 889, baseType: !389, size: 32)
!398 = !DIDerivedType(tag: DW_TAG_member, name: "pvDummy2", scope: !395, file: !378, line: 890, baseType: !266, size: 32, offset: 32)
!399 = !DIDerivedType(tag: DW_TAG_member, name: "xDummy3", scope: !395, file: !378, line: 891, baseType: !400, size: 96, offset: 64)
!400 = !DIDerivedType(tag: DW_TAG_typedef, name: "StaticMiniListItem_t", file: !378, line: 885, baseType: !401)
!401 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xSTATIC_MINI_LIST_ITEM", file: !378, line: 881, size: 96, elements: !402)
!402 = !{!403, !409}
!403 = !DIDerivedType(tag: DW_TAG_member, name: "xDummy1", scope: !401, file: !378, line: 882, baseType: !404, size: 32)
!404 = !DIDerivedType(tag: DW_TAG_typedef, name: "TickType_t", file: !390, line: 96, baseType: !405)
!405 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !406, line: 32, baseType: !407)
!406 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/newlib/include/sys/_stdint.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!407 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !408, line: 65, baseType: !13)
!408 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/newlib/include/machine/_default_types.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!409 = !DIDerivedType(tag: DW_TAG_member, name: "pvDummy2", scope: !401, file: !378, line: 883, baseType: !410, size: 64, offset: 32)
!410 = !DICompositeType(tag: DW_TAG_array_type, baseType: !266, size: 64, elements: !411)
!411 = !{!412}
!412 = !DISubrange(count: 2)
!413 = !DIDerivedType(tag: DW_TAG_member, name: "uxDummy4", scope: !380, file: !378, line: 983, baseType: !414, size: 96, offset: 448)
!414 = !DICompositeType(tag: DW_TAG_array_type, baseType: !389, size: 96, elements: !159)
!415 = !DIDerivedType(tag: DW_TAG_member, name: "ucDummy5", scope: !380, file: !378, line: 984, baseType: !416, size: 16, offset: 544)
!416 = !DICompositeType(tag: DW_TAG_array_type, baseType: !417, size: 16, elements: !411)
!417 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !406, line: 20, baseType: !418)
!418 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !408, line: 29, baseType: !107)
!419 = !DIDerivedType(tag: DW_TAG_member, name: "ucDummy6", scope: !380, file: !378, line: 987, baseType: !417, size: 8, offset: 560)
!420 = !DIDerivedType(tag: DW_TAG_member, name: "uxDummy8", scope: !380, file: !378, line: 995, baseType: !389, size: 32, offset: 576)
!421 = !DIDerivedType(tag: DW_TAG_member, name: "ucDummy9", scope: !380, file: !378, line: 996, baseType: !417, size: 8, offset: 608)
!422 = !DIGlobalVariableExpression(var: !423)
!423 = distinct !DIGlobalVariable(name: "cpu_do_in_irq_priv", scope: !2, file: !3, line: 22, type: !266, isLocal: true, isDefinition: true)
!424 = !DIGlobalVariableExpression(var: !425)
!425 = distinct !DIGlobalVariable(name: "cpu_wait_flag", scope: !2, file: !3, line: 20, type: !332, isLocal: true, isDefinition: true)
!426 = !DIGlobalVariableExpression(var: !427)
!427 = distinct !DIGlobalVariable(name: "readback_chk_ctl_en", scope: !2, file: !3, line: 256, type: !105, isLocal: true, isDefinition: true)
!428 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !429, size: 32)
!429 = !DISubroutineType(types: !430)
!430 = !{null, !266}
!431 = !{i32 2, !"Dwarf Version", i32 4}
!432 = !{i32 2, !"Debug Info Version", i32 3}
!433 = !{!"clang version 4.0.1 () ()"}
!434 = distinct !DISubprogram(name: "icache_flush", scope: !435, file: !435, line: 8, type: !436, isLocal: false, isDefinition: true, scopeLine: 9, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !439)
!435 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/cpu/wl82/vm/vm_cache.c", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!436 = !DISubroutineType(types: !437)
!437 = !{null, !104, !438}
!438 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!439 = !{!440, !441}
!440 = !DILocalVariable(name: "p", arg: 1, scope: !434, file: !435, line: 8, type: !104)
!441 = !DILocalVariable(name: "len", arg: 2, scope: !434, file: !435, line: 8, type: !438)
!442 = !DIExpression()
!443 = !DILocation(line: 8, column: 50, scope: !434)
!444 = !DILocation(line: 8, column: 57, scope: !434)
!445 = !DILocation(line: 10, column: 5, scope: !434)
!446 = !DILocation(line: 10, column: 25, scope: !447)
!447 = !DILexicalBlockFile(scope: !434, file: !435, discriminator: 1)
!448 = !{!449, !450, i64 8}
!449 = !{!"", !450, i64 0, !450, i64 4, !450, i64 8, !450, i64 12, !450, i64 16, !450, i64 20, !451, i64 24, !450, i64 512, !450, i64 516, !450, i64 520, !450, i64 524, !450, i64 528, !450, i64 532, !450, i64 536, !450, i64 540, !450, i64 544, !450, i64 548, !450, i64 552, !450, i64 556, !450, i64 560, !450, i64 564, !450, i64 568, !450, i64 572, !450, i64 576, !450, i64 580, !450, i64 584, !451, i64 588, !450, i64 640, !450, i64 644, !450, i64 648, !450, i64 652, !450, i64 656, !450, i64 660, !450, i64 664, !450, i64 668, !451, i64 672, !450, i64 704, !450, i64 708, !450, i64 712, !450, i64 716, !450, i64 720, !450, i64 724, !450, i64 728, !450, i64 732, !451, i64 736, !450, i64 768, !450, i64 772, !450, i64 776, !450, i64 780, !450, i64 784, !450, i64 788, !450, i64 792, !450, i64 796, !451, i64 800, !450, i64 832, !450, i64 836, !450, i64 840, !450, i64 844, !450, i64 848, !450, i64 852, !450, i64 856, !451, i64 860, !450, i64 864, !450, i64 868, !450, i64 872, !450, i64 876, !450, i64 880, !450, i64 884, !450, i64 888, !450, i64 892, !451, i64 896, !450, i64 896, !450, i64 900, !450, i64 904, !450, i64 908}
!450 = !{!"int", !451, i64 0}
!451 = !{!"omnipotent char", !452, i64 0}
!452 = !{!"Simple C/C++ TBAA"}
!453 = !DILocation(line: 10, column: 35, scope: !447)
!454 = !DILocation(line: 10, column: 12, scope: !447)
!455 = !DILocation(line: 10, column: 5, scope: !447)
!456 = distinct !{!456, !445, !457}
!457 = !DILocation(line: 10, column: 46, scope: !434)
!458 = !DILocation(line: 11, column: 16, scope: !434)
!459 = !DILocation(line: 11, column: 28, scope: !434)
!460 = !DILocation(line: 11, column: 9, scope: !434)
!461 = !DILocation(line: 12, column: 16, scope: !434)
!462 = !DILocation(line: 12, column: 22, scope: !434)
!463 = !DILocation(line: 12, column: 27, scope: !434)
!464 = !DILocation(line: 13, column: 5, scope: !434)
!465 = !DILocation(line: 13, column: 16, scope: !447)
!466 = !DILocation(line: 13, column: 5, scope: !447)
!467 = !DILocation(line: 15, column: 9, scope: !468)
!468 = distinct !DILexicalBlock(scope: !434, file: !435, line: 13, column: 21)
!469 = !{i32 1007735, i32 1007744}
!470 = !DILocation(line: 16, column: 9, scope: !468)
!471 = !{i32 1007795}
!472 = !DILocation(line: 17, column: 9, scope: !468)
!473 = !DILocation(line: 17, column: 29, scope: !474)
!474 = !DILexicalBlockFile(scope: !468, file: !435, discriminator: 1)
!475 = !DILocation(line: 17, column: 39, scope: !474)
!476 = !DILocation(line: 17, column: 16, scope: !474)
!477 = !DILocation(line: 17, column: 9, scope: !474)
!478 = distinct !{!478, !472, !479}
!479 = !DILocation(line: 17, column: 50, scope: !468)
!480 = !DILocation(line: 19, column: 13, scope: !468)
!481 = !DILocation(line: 20, column: 11, scope: !468)
!482 = !DILocation(line: 13, column: 5, scope: !483)
!483 = !DILexicalBlockFile(scope: !434, file: !435, discriminator: 2)
!484 = distinct !{!484, !464, !485}
!485 = !DILocation(line: 21, column: 5, scope: !434)
!486 = !DILocation(line: 22, column: 1, scope: !434)
!487 = distinct !DISubprogram(name: "dsp_corex_enter_hold", scope: !3, file: !3, line: 33, type: !488, isLocal: false, isDefinition: true, scopeLine: 34, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !490)
!488 = !DISubroutineType(types: !489)
!489 = !{null, !171}
!490 = !{!491}
!491 = !DILocalVariable(name: "cpu_id", arg: 1, scope: !487, file: !3, line: 33, type: !171)
!492 = !DILocation(line: 33, column: 32, scope: !487)
!493 = !DILocation(line: 35, column: 16, scope: !494)
!494 = distinct !DILexicalBlock(scope: !487, file: !3, line: 35, column: 9)
!495 = !DILocation(line: 35, column: 9, scope: !487)
!496 = !DILocation(line: 36, column: 27, scope: !497)
!497 = distinct !DILexicalBlock(scope: !494, file: !3, line: 35, column: 22)
!498 = !{!449, !450, i64 0}
!499 = !DILocation(line: 37, column: 9, scope: !500)
!500 = !DILexicalBlockFile(scope: !501, file: !3, discriminator: 1)
!501 = distinct !DILexicalBlock(scope: !497, file: !3, line: 37, column: 9)
!502 = !{i32 -2146461635}
!503 = !DILocation(line: 38, column: 9, scope: !497)
!504 = !DILocation(line: 38, column: 29, scope: !505)
!505 = !DILexicalBlockFile(scope: !497, file: !3, discriminator: 1)
!506 = !DILocation(line: 38, column: 36, scope: !505)
!507 = !DILocation(line: 38, column: 16, scope: !505)
!508 = !DILocation(line: 38, column: 9, scope: !505)
!509 = distinct !{!509, !503, !510}
!510 = !DILocation(line: 38, column: 46, scope: !497)
!511 = !DILocation(line: 40, column: 27, scope: !512)
!512 = distinct !DILexicalBlock(scope: !494, file: !3, line: 39, column: 12)
!513 = !{!449, !450, i64 4}
!514 = !DILocation(line: 41, column: 9, scope: !515)
!515 = !DILexicalBlockFile(scope: !516, file: !3, discriminator: 1)
!516 = distinct !DILexicalBlock(scope: !512, file: !3, line: 41, column: 9)
!517 = !{i32 -2146461342}
!518 = !DILocation(line: 42, column: 9, scope: !512)
!519 = !DILocation(line: 42, column: 29, scope: !520)
!520 = !DILexicalBlockFile(scope: !512, file: !3, discriminator: 1)
!521 = !DILocation(line: 42, column: 36, scope: !520)
!522 = !DILocation(line: 42, column: 16, scope: !520)
!523 = !DILocation(line: 42, column: 9, scope: !520)
!524 = distinct !{!524, !518, !525}
!525 = !DILocation(line: 42, column: 46, scope: !512)
!526 = !DILocation(line: 44, column: 1, scope: !487)
!527 = !DILocation(line: 44, column: 1, scope: !528)
!528 = !DILexicalBlockFile(scope: !487, file: !3, discriminator: 1)
!529 = !DILocation(line: 44, column: 1, scope: !530)
!530 = !DILexicalBlockFile(scope: !487, file: !3, discriminator: 2)
!531 = distinct !DISubprogram(name: "dsp_corex_exit_hold", scope: !3, file: !3, line: 46, type: !488, isLocal: false, isDefinition: true, scopeLine: 47, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !532)
!532 = !{!533}
!533 = !DILocalVariable(name: "cpu_id", arg: 1, scope: !531, file: !3, line: 46, type: !171)
!534 = !DILocation(line: 46, column: 31, scope: !531)
!535 = !DILocation(line: 48, column: 16, scope: !536)
!536 = distinct !DILexicalBlock(scope: !531, file: !3, line: 48, column: 9)
!537 = !DILocation(line: 48, column: 9, scope: !531)
!538 = !{!450, !450, i64 0}
!539 = !DILocation(line: 53, column: 5, scope: !540)
!540 = !DILexicalBlockFile(scope: !541, file: !3, discriminator: 1)
!541 = distinct !DILexicalBlock(scope: !531, file: !3, line: 53, column: 5)
!542 = !{i32 -2146460854}
!543 = !DILocation(line: 54, column: 1, scope: !531)
!544 = distinct !DISubprogram(name: "cpu_enter_sfc_critical", scope: !3, file: !3, line: 82, type: !545, isLocal: false, isDefinition: true, scopeLine: 83, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !547)
!545 = !DISubroutineType(types: !546)
!546 = !{null, !428, !266}
!547 = !{!548, !549}
!548 = !DILocalVariable(name: "cb", arg: 1, scope: !544, file: !3, line: 82, type: !428)
!549 = !DILocalVariable(name: "priv", arg: 2, scope: !544, file: !3, line: 82, type: !266)
!550 = !DILocation(line: 82, column: 43, scope: !544)
!551 = !DILocation(line: 82, column: 62, scope: !544)
!552 = !DILocation(line: 84, column: 10, scope: !553)
!553 = distinct !DILexicalBlock(scope: !544, file: !3, line: 84, column: 9)
!554 = !{!451, !451, i64 0}
!555 = !DILocation(line: 84, column: 9, scope: !544)
!556 = !DILocation(line: 85, column: 9, scope: !557)
!557 = !DILexicalBlockFile(scope: !558, file: !3, discriminator: 1)
!558 = distinct !DILexicalBlock(scope: !559, file: !3, line: 85, column: 9)
!559 = distinct !DILexicalBlock(scope: !553, file: !3, line: 84, column: 46)
!560 = !{i32 -2146459852}
!561 = !DILocation(line: 86, column: 9, scope: !559)
!562 = !DILocation(line: 86, column: 29, scope: !563)
!563 = !DILexicalBlockFile(scope: !559, file: !3, discriminator: 1)
!564 = !DILocation(line: 86, column: 39, scope: !563)
!565 = !DILocation(line: 86, column: 16, scope: !563)
!566 = !DILocation(line: 86, column: 9, scope: !563)
!567 = distinct !{!567, !561, !568}
!568 = !DILocation(line: 86, column: 50, scope: !559)
!569 = !DILocation(line: 87, column: 9, scope: !570)
!570 = !DILexicalBlockFile(scope: !571, file: !3, discriminator: 1)
!571 = distinct !DILexicalBlock(scope: !559, file: !3, line: 87, column: 9)
!572 = !DILocation(line: 88, column: 28, scope: !559)
!573 = !{!574, !574, i64 0}
!574 = !{!"any pointer", !451, i64 0}
!575 = !DILocation(line: 89, column: 28, scope: !559)
!576 = !DILocation(line: 90, column: 9, scope: !577)
!577 = !DILexicalBlockFile(scope: !578, file: !3, discriminator: 1)
!578 = distinct !DILexicalBlock(scope: !559, file: !3, line: 90, column: 9)
!579 = !{i32 -2146459632}
!580 = !DILocation(line: 91, column: 13, scope: !581)
!581 = distinct !DILexicalBlock(scope: !559, file: !3, line: 91, column: 13)
!582 = !DILocation(line: 91, column: 13, scope: !559)
!583 = !DILocation(line: 82, column: 5, scope: !584, inlinedAt: !589)
!584 = distinct !DISubprogram(name: "current_cpu_id", scope: !106, file: !106, line: 79, type: !585, isLocal: true, isDefinition: true, scopeLine: 80, isOptimized: true, unit: !2, variables: !587)
!585 = !DISubroutineType(types: !586)
!586 = !{!438}
!587 = !{!588}
!588 = !DILocalVariable(name: "id", scope: !584, file: !106, line: 81, type: !13)
!589 = distinct !DILocation(line: 92, column: 17, scope: !590)
!590 = distinct !DILexicalBlock(scope: !591, file: !3, line: 92, column: 17)
!591 = distinct !DILexicalBlock(scope: !581, file: !3, line: 91, column: 33)
!592 = !{i32 62879}
!593 = !DILocation(line: 81, column: 14, scope: !584, inlinedAt: !589)
!594 = !DILocation(line: 92, column: 27, scope: !590)
!595 = !DILocation(line: 92, column: 17, scope: !591)
!596 = !{!597, !450, i64 416}
!597 = !{!"", !450, i64 0, !450, i64 4, !450, i64 8, !450, i64 12, !450, i64 16, !450, i64 20, !450, i64 24, !450, i64 28, !450, i64 32, !450, i64 36, !450, i64 40, !450, i64 44, !450, i64 48, !450, i64 52, !450, i64 56, !450, i64 60, !450, i64 64, !450, i64 68, !450, i64 72, !450, i64 76, !450, i64 80, !450, i64 84, !450, i64 88, !450, i64 92, !450, i64 96, !450, i64 100, !450, i64 104, !450, i64 108, !450, i64 112, !450, i64 116, !450, i64 120, !450, i64 124, !450, i64 128, !450, i64 132, !450, i64 136, !450, i64 140, !450, i64 144, !450, i64 148, !450, i64 152, !451, i64 156, !450, i64 192, !451, i64 196, !450, i64 208, !450, i64 212, !450, i64 216, !450, i64 220, !450, i64 224, !450, i64 228, !451, i64 232, !451, i64 236, !451, i64 237, !451, i64 238, !451, i64 239, !450, i64 240, !450, i64 244, !450, i64 248, !450, i64 252, !450, i64 256, !450, i64 260, !450, i64 264, !450, i64 268, !450, i64 272, !450, i64 276, !450, i64 280, !450, i64 284, !450, i64 288, !450, i64 292, !450, i64 296, !450, i64 300, !450, i64 304, !450, i64 308, !450, i64 312, !450, i64 316, !450, i64 320, !450, i64 324, !450, i64 328, !450, i64 332, !450, i64 336, !450, i64 340, !450, i64 344, !450, i64 348, !450, i64 352, !450, i64 356, !450, i64 360, !450, i64 364, !450, i64 368, !450, i64 372, !450, i64 376, !450, i64 380, !450, i64 384, !450, i64 388, !450, i64 392, !450, i64 396, !450, i64 400, !450, i64 404, !450, i64 408, !450, i64 412, !450, i64 416, !450, i64 420, !450, i64 424, !451, i64 428, !450, i64 448, !450, i64 452, !450, i64 456, !450, i64 460, !450, i64 464, !450, i64 468, !450, i64 472, !450, i64 476, !450, i64 480, !450, i64 484}
!598 = !DILocation(line: 97, column: 9, scope: !591)
!599 = !DILocation(line: 99, column: 9, scope: !600)
!600 = distinct !DILexicalBlock(scope: !553, file: !3, line: 98, column: 12)
!601 = !DILocation(line: 100, column: 9, scope: !600)
!602 = !DILocation(line: 100, column: 9, scope: !603)
!603 = !DILexicalBlockFile(scope: !600, file: !3, discriminator: 1)
!604 = !DILocation(line: 100, column: 9, scope: !605)
!605 = !DILexicalBlockFile(scope: !606, file: !3, discriminator: 2)
!606 = distinct !DILexicalBlock(scope: !607, file: !3, line: 100, column: 9)
!607 = distinct !DILexicalBlock(scope: !600, file: !3, line: 100, column: 9)
!608 = !{i32 -2146459279}
!609 = !DILocation(line: 100, column: 9, scope: !610)
!610 = !DILexicalBlockFile(scope: !600, file: !3, discriminator: 2)
!611 = distinct !{!611, !601, !601}
!612 = !DILocation(line: 101, column: 9, scope: !613)
!613 = !DILexicalBlockFile(scope: !614, file: !3, discriminator: 1)
!614 = distinct !DILexicalBlock(scope: !600, file: !3, line: 101, column: 9)
!615 = !DILocation(line: 101, column: 9, scope: !616)
!616 = !DILexicalBlockFile(scope: !617, file: !3, discriminator: 2)
!617 = distinct !DILexicalBlock(scope: !614, file: !3, line: 101, column: 9)
!618 = !{i32 -2146459181}
!619 = !DILocation(line: 102, column: 9, scope: !620)
!620 = !DILexicalBlockFile(scope: !621, file: !3, discriminator: 1)
!621 = distinct !DILexicalBlock(scope: !600, file: !3, line: 102, column: 9)
!622 = !{i32 -2146459130}
!623 = !DILocation(line: 103, column: 28, scope: !600)
!624 = !DILocation(line: 104, column: 28, scope: !600)
!625 = !DILocation(line: 105, column: 9, scope: !626)
!626 = !DILexicalBlockFile(scope: !627, file: !3, discriminator: 1)
!627 = distinct !DILexicalBlock(scope: !600, file: !3, line: 105, column: 9)
!628 = !{i32 -2146459079}
!629 = !DILocation(line: 82, column: 5, scope: !630, inlinedAt: !631)
!630 = !DILexicalBlockFile(scope: !584, file: !106, discriminator: 1)
!631 = distinct !DILocation(line: 106, column: 13, scope: !632)
!632 = distinct !DILexicalBlock(scope: !600, file: !3, line: 106, column: 13)
!633 = !DILocation(line: 81, column: 14, scope: !584, inlinedAt: !631)
!634 = !DILocation(line: 106, column: 23, scope: !632)
!635 = !DILocation(line: 106, column: 13, scope: !600)
!636 = !DILocation(line: 111, column: 9, scope: !637)
!637 = !DILexicalBlockFile(scope: !638, file: !3, discriminator: 1)
!638 = distinct !DILexicalBlock(scope: !600, file: !3, line: 111, column: 9)
!639 = !{i32 -2146458769}
!640 = !DILocation(line: 112, column: 9, scope: !600)
!641 = !DILocation(line: 112, column: 29, scope: !603)
!642 = !DILocation(line: 112, column: 39, scope: !603)
!643 = !DILocation(line: 112, column: 16, scope: !603)
!644 = !DILocation(line: 112, column: 9, scope: !603)
!645 = distinct !{!645, !640, !646}
!646 = !DILocation(line: 112, column: 50, scope: !600)
!647 = !DILocation(line: 113, column: 9, scope: !603)
!648 = !DILocation(line: 113, column: 9, scope: !649)
!649 = !DILexicalBlockFile(scope: !650, file: !3, discriminator: 2)
!650 = distinct !DILexicalBlock(scope: !651, file: !3, line: 113, column: 9)
!651 = distinct !DILexicalBlock(scope: !600, file: !3, line: 113, column: 9)
!652 = !{i32 -2146458557}
!653 = !DILocation(line: 113, column: 9, scope: !610)
!654 = distinct !{!654, !655, !655}
!655 = !DILocation(line: 113, column: 9, scope: !600)
!656 = !DILocation(line: 114, column: 14, scope: !657)
!657 = distinct !DILexicalBlock(scope: !600, file: !3, line: 114, column: 13)
!658 = !DILocation(line: 114, column: 13, scope: !600)
!659 = !DILocation(line: 82, column: 5, scope: !660, inlinedAt: !661)
!660 = !DILexicalBlockFile(scope: !584, file: !106, discriminator: 2)
!661 = distinct !DILocation(line: 115, column: 35, scope: !662)
!662 = distinct !DILexicalBlock(scope: !657, file: !3, line: 114, column: 34)
!663 = !DILocation(line: 81, column: 14, scope: !584, inlinedAt: !661)
!664 = !DILocation(line: 115, column: 34, scope: !662)
!665 = !DILocation(line: 115, column: 13, scope: !666)
!666 = !DILexicalBlockFile(scope: !662, file: !3, discriminator: 1)
!667 = !DILocation(line: 116, column: 9, scope: !662)
!668 = !DILocation(line: 118, column: 1, scope: !544)
!669 = distinct !DISubprogram(name: "cpu_exit_sfc_critical", scope: !3, file: !3, line: 119, type: !670, isLocal: false, isDefinition: true, scopeLine: 120, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!670 = !DISubroutineType(types: !671)
!671 = !{null}
!672 = !DILocation(line: 121, column: 10, scope: !673)
!673 = distinct !DILexicalBlock(scope: !669, file: !3, line: 121, column: 9)
!674 = !DILocation(line: 121, column: 9, scope: !669)
!675 = !DILocation(line: 122, column: 28, scope: !676)
!676 = distinct !DILexicalBlock(scope: !673, file: !3, line: 121, column: 46)
!677 = !DILocation(line: 123, column: 9, scope: !678)
!678 = !DILexicalBlockFile(scope: !679, file: !3, discriminator: 1)
!679 = distinct !DILexicalBlock(scope: !676, file: !3, line: 123, column: 9)
!680 = !DILocation(line: 124, column: 5, scope: !676)
!681 = !DILocation(line: 125, column: 9, scope: !682)
!682 = !DILexicalBlockFile(scope: !683, file: !3, discriminator: 1)
!683 = distinct !DILexicalBlock(scope: !684, file: !3, line: 125, column: 9)
!684 = distinct !DILexicalBlock(scope: !673, file: !3, line: 124, column: 12)
!685 = !{i32 -2146458356}
!686 = !DILocation(line: 126, column: 9, scope: !687)
!687 = !DILexicalBlockFile(scope: !688, file: !3, discriminator: 1)
!688 = distinct !DILexicalBlock(scope: !684, file: !3, line: 126, column: 9)
!689 = !DILocation(line: 126, column: 9, scope: !690)
!690 = !DILexicalBlockFile(scope: !691, file: !3, discriminator: 2)
!691 = distinct !DILexicalBlock(scope: !688, file: !3, line: 126, column: 9)
!692 = !{i32 -2146458258}
!693 = !DILocation(line: 127, column: 14, scope: !694)
!694 = distinct !DILexicalBlock(scope: !684, file: !3, line: 127, column: 13)
!695 = !DILocation(line: 127, column: 13, scope: !684)
!696 = !DILocation(line: 82, column: 5, scope: !584, inlinedAt: !697)
!697 = distinct !DILocation(line: 128, column: 34, scope: !698)
!698 = distinct !DILexicalBlock(scope: !694, file: !3, line: 127, column: 34)
!699 = !DILocation(line: 81, column: 14, scope: !584, inlinedAt: !697)
!700 = !DILocation(line: 128, column: 33, scope: !698)
!701 = !DILocation(line: 128, column: 13, scope: !702)
!702 = !DILexicalBlockFile(scope: !698, file: !3, discriminator: 1)
!703 = !DILocation(line: 129, column: 9, scope: !698)
!704 = !DILocation(line: 130, column: 28, scope: !684)
!705 = !DILocation(line: 131, column: 9, scope: !684)
!706 = !DILocation(line: 133, column: 5, scope: !707)
!707 = !DILexicalBlockFile(scope: !708, file: !3, discriminator: 1)
!708 = distinct !DILexicalBlock(scope: !669, file: !3, line: 133, column: 5)
!709 = !{i32 -2146458179}
!710 = !DILocation(line: 134, column: 1, scope: !669)
!711 = distinct !DISubprogram(name: "sfc_nop_delay", scope: !3, file: !3, line: 282, type: !712, isLocal: true, isDefinition: true, scopeLine: 283, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !715)
!712 = !DISubroutineType(types: !713)
!713 = !{null, !714}
!714 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !108)
!715 = !{!716}
!716 = !DILocalVariable(name: "t", arg: 1, scope: !711, file: !3, line: 282, type: !714)
!717 = !DILocation(line: 282, column: 40, scope: !711)
!718 = !DILocation(line: 284, column: 5, scope: !711)
!719 = !DILocation(line: 284, column: 13, scope: !720)
!720 = !DILexicalBlockFile(scope: !711, file: !3, discriminator: 1)
!721 = !DILocation(line: 284, column: 5, scope: !720)
!722 = !DILocation(line: 285, column: 9, scope: !723)
!723 = distinct !DILexicalBlock(scope: !711, file: !3, line: 284, column: 17)
!724 = !{i32 11192}
!725 = !DILocation(line: 284, column: 5, scope: !726)
!726 = !DILexicalBlockFile(scope: !711, file: !3, discriminator: 2)
!727 = distinct !{!727, !718, !728}
!728 = !DILocation(line: 286, column: 5, scope: !711)
!729 = !DILocation(line: 287, column: 1, scope: !711)
!730 = distinct !DISubprogram(name: "spi_cs", scope: !3, file: !3, line: 290, type: !731, isLocal: true, isDefinition: true, scopeLine: 291, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !733)
!731 = !DISubroutineType(types: !732)
!732 = !{null, !105}
!733 = !{!734}
!734 = !DILocalVariable(name: "cs", arg: 1, scope: !730, file: !3, line: 290, type: !105)
!735 = !DILocation(line: 290, column: 23, scope: !730)
!736 = !DILocation(line: 293, column: 23, scope: !737)
!737 = distinct !DILexicalBlock(scope: !738, file: !3, line: 292, column: 26)
!738 = distinct !DILexicalBlock(scope: !730, file: !3, line: 292, column: 9)
!739 = !{!740, !450, i64 8}
!740 = !{!"", !450, i64 0, !450, i64 4, !450, i64 8, !450, i64 12, !450, i64 16, !450, i64 20, !450, i64 24, !450, i64 28, !450, i64 32}
!741 = !DILocation(line: 294, column: 9, scope: !737)
!742 = !{!740, !450, i64 0}
!743 = !DILocation(line: 294, column: 57, scope: !744)
!744 = !DILexicalBlockFile(scope: !737, file: !3, discriminator: 2)
!745 = !DILocation(line: 294, column: 29, scope: !746)
!746 = !DILexicalBlockFile(scope: !737, file: !3, discriminator: 1)
!747 = !DILocation(line: 300, column: 5, scope: !730)
!748 = !DILocation(line: 301, column: 1, scope: !730)
!749 = distinct !DISubprogram(name: "spi_wait_ok", scope: !3, file: !3, line: 304, type: !585, isLocal: true, isDefinition: true, scopeLine: 305, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !750)
!750 = !{!751}
!751 = !DILocalVariable(name: "to", scope: !749, file: !3, line: 306, type: !714)
!752 = !DILocation(line: 306, column: 5, scope: !749)
!753 = !DILocation(line: 306, column: 18, scope: !749)
!754 = !DILocation(line: 307, column: 5, scope: !755)
!755 = !DILexicalBlockFile(scope: !756, file: !3, discriminator: 1)
!756 = distinct !DILexicalBlock(scope: !749, file: !3, line: 307, column: 5)
!757 = !{i32 -2146457048}
!758 = !DILocation(line: 308, column: 5, scope: !749)
!759 = !DILocation(line: 308, column: 23, scope: !760)
!760 = !DILexicalBlockFile(scope: !749, file: !3, discriminator: 1)
!761 = !{!762, !450, i64 0}
!762 = !{!"", !450, i64 0, !450, i64 4, !450, i64 8, !450, i64 12, !450, i64 16}
!763 = !DILocation(line: 308, column: 27, scope: !760)
!764 = !DILocation(line: 308, column: 38, scope: !760)
!765 = !DILocation(line: 308, column: 41, scope: !766)
!766 = !DILexicalBlockFile(scope: !749, file: !3, discriminator: 2)
!767 = !DILocation(line: 308, column: 38, scope: !766)
!768 = !DILocation(line: 308, column: 5, scope: !766)
!769 = distinct !{!769, !758, !770}
!770 = !DILocation(line: 308, column: 46, scope: !749)
!771 = !DILocation(line: 309, column: 18, scope: !749)
!772 = !DILocation(line: 310, column: 10, scope: !773)
!773 = distinct !DILexicalBlock(scope: !749, file: !3, line: 310, column: 9)
!774 = !DILocation(line: 310, column: 9, scope: !749)
!775 = !DILocation(line: 311, column: 9, scope: !776)
!776 = distinct !DILexicalBlock(scope: !773, file: !3, line: 310, column: 14)
!777 = !DILocation(line: 312, column: 9, scope: !776)
!778 = !DILocation(line: 313, column: 9, scope: !776)
!779 = !DILocation(line: 314, column: 9, scope: !776)
!780 = !DILocation(line: 315, column: 9, scope: !776)
!781 = !DILocation(line: 316, column: 9, scope: !776)
!782 = !DILocation(line: 317, column: 9, scope: !776)
!783 = !DILocation(line: 318, column: 9, scope: !776)
!784 = !DILocation(line: 319, column: 9, scope: !776)
!785 = !DILocation(line: 320, column: 9, scope: !776)
!786 = !DILocation(line: 321, column: 9, scope: !776)
!787 = !DILocation(line: 322, column: 9, scope: !776)
!788 = !DILocation(line: 323, column: 9, scope: !776)
!789 = !DILocation(line: 324, column: 9, scope: !776)
!790 = !DILocation(line: 325, column: 9, scope: !776)
!791 = !DILocation(line: 326, column: 9, scope: !776)
!792 = !DILocation(line: 329, column: 1, scope: !749)
!793 = distinct !DISubprogram(name: "spi_writebyte", scope: !3, file: !3, line: 332, type: !731, isLocal: true, isDefinition: true, scopeLine: 333, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !794)
!794 = !{!795}
!795 = !DILocalVariable(name: "dat", arg: 1, scope: !793, file: !3, line: 332, type: !105)
!796 = !DILocation(line: 332, column: 30, scope: !793)
!797 = !DILocation(line: 334, column: 18, scope: !793)
!798 = !DILocation(line: 335, column: 18, scope: !793)
!799 = !DILocation(line: 336, column: 20, scope: !793)
!800 = !DILocation(line: 336, column: 18, scope: !793)
!801 = !{!762, !450, i64 8}
!802 = !DILocation(line: 337, column: 5, scope: !793)
!803 = !DILocation(line: 338, column: 18, scope: !793)
!804 = !DILocation(line: 339, column: 1, scope: !793)
!805 = distinct !DISubprogram(name: "spi_writebyte_dma", scope: !3, file: !3, line: 342, type: !731, isLocal: true, isDefinition: true, scopeLine: 343, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !806)
!806 = !{!807}
!807 = !DILocalVariable(name: "dat", arg: 1, scope: !805, file: !3, line: 342, type: !105)
!808 = !DILocation(line: 342, column: 34, scope: !805)
!809 = !DILocation(line: 344, column: 20, scope: !805)
!810 = !DILocation(line: 344, column: 18, scope: !805)
!811 = !DILocation(line: 345, column: 5, scope: !805)
!812 = !DILocation(line: 346, column: 1, scope: !805)
!813 = distinct !DISubprogram(name: "spi_readbyte", scope: !3, file: !3, line: 349, type: !344, isLocal: true, isDefinition: true, scopeLine: 350, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !814)
!814 = !{!815}
!815 = !DILocalVariable(name: "ret_byte", scope: !813, file: !3, line: 351, type: !105)
!816 = !DILocation(line: 353, column: 18, scope: !813)
!817 = !DILocation(line: 354, column: 18, scope: !813)
!818 = !DILocation(line: 355, column: 18, scope: !813)
!819 = !DILocation(line: 356, column: 5, scope: !813)
!820 = !DILocation(line: 357, column: 25, scope: !813)
!821 = !DILocation(line: 357, column: 16, scope: !813)
!822 = !DILocation(line: 351, column: 8, scope: !813)
!823 = !DILocation(line: 358, column: 18, scope: !813)
!824 = !DILocation(line: 360, column: 5, scope: !813)
!825 = distinct !DISubprogram(name: "spi_readbyte_dma", scope: !3, file: !3, line: 364, type: !344, isLocal: true, isDefinition: true, scopeLine: 365, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !826)
!826 = !{!827}
!827 = !DILocalVariable(name: "ret_byte", scope: !825, file: !3, line: 366, type: !105)
!828 = !DILocation(line: 368, column: 18, scope: !825)
!829 = !DILocation(line: 369, column: 5, scope: !825)
!830 = !DILocation(line: 370, column: 25, scope: !825)
!831 = !DILocation(line: 370, column: 16, scope: !825)
!832 = !DILocation(line: 366, column: 8, scope: !825)
!833 = !DILocation(line: 372, column: 5, scope: !825)
!834 = distinct !DISubprogram(name: "spiflash_enter_4byte_addr", scope: !3, file: !3, line: 375, type: !835, isLocal: true, isDefinition: true, scopeLine: 376, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !837)
!835 = !DISubroutineType(types: !836)
!836 = !{null, !108}
!837 = !{!838, !839}
!838 = !DILocalVariable(name: "addr", arg: 1, scope: !834, file: !3, line: 375, type: !108)
!839 = !DILocalVariable(name: "chip_size", scope: !834, file: !3, line: 377, type: !108)
!840 = !DILocation(line: 375, column: 43, scope: !834)
!841 = !DILocation(line: 377, column: 32, scope: !834)
!842 = !{!843, !450, i64 24}
!843 = !{!"flash_info", !451, i64 0, !451, i64 16, !451, i64 17, !450, i64 20, !450, i64 24, !450, i64 28, !844, i64 32, !845, i64 48, !450, i64 56, !450, i64 60, !450, i64 64, !450, i64 68, !450, i64 72, !574, i64 76}
!844 = !{!"vm_info", !451, i64 0, !450, i64 4, !450, i64 8, !450, i64 12}
!845 = !{!"sfc_info", !450, i64 0, !450, i64 4}
!846 = !DILocation(line: 377, column: 9, scope: !834)
!847 = !DILocation(line: 378, column: 19, scope: !848)
!848 = distinct !DILexicalBlock(scope: !834, file: !3, line: 378, column: 9)
!849 = !DILocation(line: 378, column: 38, scope: !848)
!850 = !DILocation(line: 378, column: 42, scope: !851)
!851 = !DILexicalBlockFile(scope: !848, file: !3, discriminator: 1)
!852 = !DILocation(line: 378, column: 63, scope: !851)
!853 = !DILocation(line: 378, column: 55, scope: !851)
!854 = !DILocation(line: 379, column: 22, scope: !855)
!855 = distinct !DILexicalBlock(scope: !848, file: !3, line: 378, column: 84)
!856 = !DILocation(line: 380, column: 9, scope: !855)
!857 = !DILocation(line: 381, column: 9, scope: !855)
!858 = !DILocation(line: 382, column: 9, scope: !855)
!859 = !DILocation(line: 383, column: 5, scope: !855)
!860 = !DILocation(line: 384, column: 1, scope: !834)
!861 = distinct !DISubprogram(name: "spiflash_exit_4byte_addr", scope: !3, file: !3, line: 386, type: !835, isLocal: true, isDefinition: true, scopeLine: 387, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !862)
!862 = !{!863, !864}
!863 = !DILocalVariable(name: "addr", arg: 1, scope: !861, file: !3, line: 386, type: !108)
!864 = !DILocalVariable(name: "chip_size", scope: !861, file: !3, line: 388, type: !108)
!865 = !DILocation(line: 386, column: 42, scope: !861)
!866 = !DILocation(line: 388, column: 32, scope: !861)
!867 = !DILocation(line: 388, column: 9, scope: !861)
!868 = !DILocation(line: 389, column: 19, scope: !869)
!869 = distinct !DILexicalBlock(scope: !861, file: !3, line: 389, column: 9)
!870 = !DILocation(line: 389, column: 38, scope: !869)
!871 = !DILocation(line: 389, column: 41, scope: !872)
!872 = !DILexicalBlockFile(scope: !869, file: !3, discriminator: 1)
!873 = !DILocation(line: 389, column: 62, scope: !872)
!874 = !DILocation(line: 389, column: 54, scope: !872)
!875 = !DILocation(line: 390, column: 22, scope: !876)
!876 = distinct !DILexicalBlock(scope: !869, file: !3, line: 389, column: 83)
!877 = !DILocation(line: 391, column: 9, scope: !876)
!878 = !DILocation(line: 392, column: 9, scope: !876)
!879 = !DILocation(line: 393, column: 9, scope: !876)
!880 = !DILocation(line: 394, column: 5, scope: !876)
!881 = !DILocation(line: 395, column: 1, scope: !861)
!882 = distinct !DISubprogram(name: "spi_write_dma", scope: !3, file: !3, line: 398, type: !883, isLocal: true, isDefinition: true, scopeLine: 399, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !886)
!883 = !DISubroutineType(types: !884)
!884 = !{!885, !104, !302}
!885 = !DIDerivedType(tag: DW_TAG_typedef, name: "s32", file: !106, line: 20, baseType: !438)
!886 = !{!887, !888, !889, !890}
!887 = !DILocalVariable(name: "buf", arg: 1, scope: !882, file: !3, line: 398, type: !104)
!888 = !DILocalVariable(name: "len", arg: 2, scope: !882, file: !3, line: 398, type: !302)
!889 = !DILocalVariable(name: "spi_mode", scope: !882, file: !3, line: 400, type: !108)
!890 = !DILocalVariable(name: "bits_mode", scope: !882, file: !3, line: 401, type: !105)
!891 = !DILocation(line: 398, column: 30, scope: !882)
!892 = !DILocation(line: 398, column: 39, scope: !882)
!893 = !DILocation(line: 400, column: 33, scope: !882)
!894 = !{!843, !450, i64 56}
!895 = !DILocation(line: 400, column: 22, scope: !882)
!896 = !DILocation(line: 400, column: 72, scope: !897)
!897 = !DILexicalBlockFile(scope: !882, file: !3, discriminator: 1)
!898 = !{!899, !450, i64 0}
!899 = !{!"", !450, i64 0, !450, i64 4, !450, i64 8, !450, i64 12}
!900 = !DILocation(line: 400, column: 22, scope: !897)
!901 = !DILocation(line: 400, column: 22, scope: !902)
!902 = !DILexicalBlockFile(scope: !882, file: !3, discriminator: 2)
!903 = !DILocation(line: 400, column: 77, scope: !902)
!904 = !DILocation(line: 401, column: 8, scope: !882)
!905 = !DILocation(line: 408, column: 18, scope: !882)
!906 = !DILocation(line: 410, column: 5, scope: !882)
!907 = !DILocation(line: 415, column: 22, scope: !908)
!908 = distinct !DILexicalBlock(scope: !882, file: !3, line: 410, column: 23)
!909 = !DILocation(line: 416, column: 22, scope: !908)
!910 = !DILocation(line: 418, column: 9, scope: !908)
!911 = !DILocation(line: 423, column: 22, scope: !908)
!912 = !DILocation(line: 424, column: 22, scope: !908)
!913 = !DILocation(line: 426, column: 9, scope: !908)
!914 = !DILocation(line: 428, column: 22, scope: !908)
!915 = !DILocation(line: 429, column: 22, scope: !908)
!916 = !DILocation(line: 431, column: 9, scope: !908)
!917 = !DILocation(line: 434, column: 5, scope: !897)
!918 = !DILocation(line: 434, column: 15, scope: !897)
!919 = !DILocation(line: 435, column: 31, scope: !920)
!920 = distinct !DILexicalBlock(scope: !882, file: !3, line: 434, column: 19)
!921 = !DILocation(line: 435, column: 27, scope: !920)
!922 = !DILocation(line: 435, column: 9, scope: !920)
!923 = distinct !{!923, !924, !925}
!924 = !DILocation(line: 434, column: 5, scope: !882)
!925 = !DILocation(line: 436, column: 5, scope: !882)
!926 = !DILocation(line: 438, column: 9, scope: !927)
!927 = distinct !DILexicalBlock(scope: !882, file: !3, line: 438, column: 9)
!928 = !DILocation(line: 438, column: 9, scope: !882)
!929 = !DILocation(line: 439, column: 22, scope: !930)
!930 = distinct !DILexicalBlock(scope: !927, file: !3, line: 438, column: 20)
!931 = !DILocation(line: 440, column: 5, scope: !930)
!932 = !DILocation(line: 441, column: 5, scope: !882)
!933 = distinct !DISubprogram(name: "spi_read_dma", scope: !3, file: !3, line: 445, type: !883, isLocal: true, isDefinition: true, scopeLine: 446, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !934)
!934 = !{!935, !936, !937, !938}
!935 = !DILocalVariable(name: "buf", arg: 1, scope: !933, file: !3, line: 445, type: !104)
!936 = !DILocalVariable(name: "len", arg: 2, scope: !933, file: !3, line: 445, type: !302)
!937 = !DILocalVariable(name: "spi_mode", scope: !933, file: !3, line: 447, type: !108)
!938 = !DILocalVariable(name: "bits_mode", scope: !933, file: !3, line: 448, type: !105)
!939 = !DILocation(line: 445, column: 29, scope: !933)
!940 = !DILocation(line: 445, column: 38, scope: !933)
!941 = !DILocation(line: 447, column: 33, scope: !933)
!942 = !DILocation(line: 447, column: 22, scope: !933)
!943 = !DILocation(line: 447, column: 72, scope: !944)
!944 = !DILexicalBlockFile(scope: !933, file: !3, discriminator: 1)
!945 = !DILocation(line: 447, column: 22, scope: !944)
!946 = !DILocation(line: 447, column: 22, scope: !947)
!947 = !DILexicalBlockFile(scope: !933, file: !3, discriminator: 2)
!948 = !DILocation(line: 447, column: 77, scope: !947)
!949 = !DILocation(line: 448, column: 8, scope: !933)
!950 = !DILocation(line: 455, column: 18, scope: !933)
!951 = !DILocation(line: 457, column: 5, scope: !933)
!952 = !DILocation(line: 462, column: 22, scope: !953)
!953 = distinct !DILexicalBlock(scope: !933, file: !3, line: 457, column: 23)
!954 = !DILocation(line: 463, column: 22, scope: !953)
!955 = !DILocation(line: 465, column: 9, scope: !953)
!956 = !DILocation(line: 470, column: 22, scope: !953)
!957 = !DILocation(line: 471, column: 22, scope: !953)
!958 = !DILocation(line: 473, column: 9, scope: !953)
!959 = !DILocation(line: 475, column: 22, scope: !953)
!960 = !DILocation(line: 476, column: 22, scope: !953)
!961 = !DILocation(line: 478, column: 9, scope: !953)
!962 = !DILocation(line: 481, column: 5, scope: !944)
!963 = !DILocation(line: 481, column: 15, scope: !944)
!964 = !DILocation(line: 482, column: 16, scope: !965)
!965 = distinct !DILexicalBlock(scope: !933, file: !3, line: 481, column: 19)
!966 = !DILocation(line: 482, column: 14, scope: !965)
!967 = !DILocation(line: 483, column: 12, scope: !965)
!968 = distinct !{!968, !969, !970}
!969 = !DILocation(line: 481, column: 5, scope: !933)
!970 = !DILocation(line: 484, column: 5, scope: !933)
!971 = !DILocation(line: 485, column: 9, scope: !972)
!972 = distinct !DILexicalBlock(scope: !933, file: !3, line: 485, column: 9)
!973 = !DILocation(line: 485, column: 9, scope: !933)
!974 = !DILocation(line: 486, column: 22, scope: !975)
!975 = distinct !DILexicalBlock(scope: !972, file: !3, line: 485, column: 20)
!976 = !DILocation(line: 487, column: 22, scope: !975)
!977 = !DILocation(line: 488, column: 5, scope: !975)
!978 = !DILocation(line: 489, column: 5, scope: !933)
!979 = distinct !DISubprogram(name: "flash_addr2cpu_addr", scope: !3, file: !3, line: 496, type: !980, isLocal: false, isDefinition: true, scopeLine: 497, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !982)
!980 = !DISubroutineType(types: !981)
!981 = !{!108, !108}
!982 = !{!983}
!983 = !DILocalVariable(name: "offset", arg: 1, scope: !979, file: !3, line: 496, type: !108)
!984 = !DILocation(line: 496, column: 29, scope: !979)
!985 = !DILocation(line: 499, column: 30, scope: !979)
!986 = !{!843, !450, i64 48}
!987 = !DILocation(line: 499, column: 12, scope: !979)
!988 = !DILocation(line: 501, column: 27, scope: !979)
!989 = !{!843, !450, i64 52}
!990 = !DILocation(line: 501, column: 36, scope: !979)
!991 = !DILocation(line: 501, column: 5, scope: !979)
!992 = distinct !DISubprogram(name: "cpu_addr2flash_addr", scope: !3, file: !3, line: 505, type: !980, isLocal: false, isDefinition: true, scopeLine: 506, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !993)
!993 = !{!994}
!994 = !DILocalVariable(name: "offset", arg: 1, scope: !992, file: !3, line: 505, type: !108)
!995 = !DILocation(line: 505, column: 29, scope: !992)
!996 = !DILocation(line: 509, column: 27, scope: !992)
!997 = !DILocation(line: 509, column: 68, scope: !992)
!998 = !DILocation(line: 509, column: 51, scope: !992)
!999 = !DILocation(line: 509, column: 41, scope: !992)
!1000 = !DILocation(line: 509, column: 5, scope: !992)
!1001 = distinct !DISubprogram(name: "get_sfc_status", scope: !3, file: !3, line: 513, type: !1002, isLocal: false, isDefinition: true, scopeLine: 514, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!1002 = !DISubroutineType(types: !1003)
!1003 = !{!108}
!1004 = !DILocation(line: 515, column: 12, scope: !1001)
!1005 = !DILocation(line: 515, column: 5, scope: !1001)
!1006 = distinct !DISubprogram(name: "sfc_protect", scope: !3, file: !3, line: 519, type: !731, isLocal: false, isDefinition: true, scopeLine: 520, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1007)
!1007 = !{!1008}
!1008 = !DILocalVariable(name: "mode", arg: 1, scope: !1006, file: !3, line: 519, type: !105)
!1009 = !DILocation(line: 519, column: 30, scope: !1006)
!1010 = !DILocation(line: 521, column: 17, scope: !1006)
!1011 = !DILocation(line: 522, column: 1, scope: !1006)
!1012 = distinct !DISubprogram(name: "norflash_idle_query", scope: !3, file: !3, line: 529, type: !344, isLocal: true, isDefinition: true, scopeLine: 530, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!1013 = !DILocation(line: 531, column: 13, scope: !1012)
!1014 = !DILocation(line: 531, column: 12, scope: !1012)
!1015 = !DILocation(line: 531, column: 5, scope: !1012)
!1016 = distinct !DISubprogram(name: "sfc_drop_cache", scope: !3, file: !3, line: 541, type: !1017, isLocal: false, isDefinition: true, scopeLine: 542, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1019)
!1017 = !DISubroutineType(types: !1018)
!1018 = !{null, !266, !108}
!1019 = !{!1020, !1021}
!1020 = !DILocalVariable(name: "ptr", arg: 1, scope: !1016, file: !3, line: 541, type: !266)
!1021 = !DILocalVariable(name: "len", arg: 2, scope: !1016, file: !3, line: 541, type: !108)
!1022 = !DILocation(line: 541, column: 27, scope: !1016)
!1023 = !DILocation(line: 541, column: 36, scope: !1016)
!1024 = !DILocation(line: 543, column: 5, scope: !1016)
!1025 = !DILocation(line: 544, column: 1, scope: !1016)
!1026 = distinct !DISubprogram(name: "sfc_suspend", scope: !3, file: !3, line: 546, type: !835, isLocal: false, isDefinition: true, scopeLine: 547, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1027)
!1027 = !{!1028}
!1028 = !DILocalVariable(name: "enable_spi", arg: 1, scope: !1026, file: !3, line: 546, type: !108)
!1029 = !DILocation(line: 546, column: 22, scope: !1026)
!1030 = !DILocation(line: 548, column: 1, scope: !1026)
!1031 = distinct !DISubprogram(name: "sfc_resume", scope: !3, file: !3, line: 550, type: !835, isLocal: false, isDefinition: true, scopeLine: 551, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1032)
!1032 = !{!1033}
!1033 = !DILocalVariable(name: "disable_spi", arg: 1, scope: !1031, file: !3, line: 550, type: !108)
!1034 = !DILocation(line: 550, column: 21, scope: !1031)
!1035 = !DILocation(line: 552, column: 1, scope: !1031)
!1036 = distinct !DISubprogram(name: "enter_spi_code", scope: !3, file: !3, line: 560, type: !670, isLocal: true, isDefinition: true, scopeLine: 561, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1037)
!1037 = !{!1038}
!1038 = !DILocalVariable(name: "spi_mode", scope: !1036, file: !3, line: 574, type: !108)
!1039 = !DILocation(line: 562, column: 5, scope: !1040)
!1040 = distinct !DILexicalBlock(scope: !1036, file: !3, line: 562, column: 5)
!1041 = !DILocation(line: 564, column: 21, scope: !1042)
!1042 = distinct !DILexicalBlock(scope: !1036, file: !3, line: 564, column: 9)
!1043 = !{!843, !451, i64 17}
!1044 = !DILocation(line: 564, column: 10, scope: !1042)
!1045 = !DILocation(line: 564, column: 9, scope: !1036)
!1046 = !DILocation(line: 565, column: 9, scope: !1047)
!1047 = distinct !DILexicalBlock(scope: !1042, file: !3, line: 564, column: 33)
!1048 = !DILocation(line: 566, column: 5, scope: !1047)
!1049 = !DILocation(line: 519, column: 30, scope: !1006, inlinedAt: !1050)
!1050 = distinct !DILocation(line: 568, column: 5, scope: !1036)
!1051 = !DILocation(line: 521, column: 17, scope: !1006, inlinedAt: !1050)
!1052 = !DILocation(line: 572, column: 34, scope: !1036)
!1053 = !DILocation(line: 572, column: 24, scope: !1036)
!1054 = !DILocation(line: 573, column: 35, scope: !1036)
!1055 = !DILocation(line: 573, column: 24, scope: !1036)
!1056 = !{!843, !450, i64 60}
!1057 = !DILocation(line: 574, column: 29, scope: !1036)
!1058 = !DILocation(line: 574, column: 9, scope: !1036)
!1059 = !DILocation(line: 585, column: 5, scope: !1060)
!1060 = !DILexicalBlockFile(scope: !1061, file: !3, discriminator: 1)
!1061 = distinct !DILexicalBlock(scope: !1036, file: !3, line: 585, column: 5)
!1062 = !{i32 -2146450814}
!1063 = !DILocation(line: 586, column: 5, scope: !1036)
!1064 = !DILocation(line: 586, column: 20, scope: !1065)
!1065 = !DILexicalBlockFile(scope: !1036, file: !3, discriminator: 1)
!1066 = !DILocation(line: 586, column: 5, scope: !1065)
!1067 = distinct !{!1067, !1063, !1068}
!1068 = !DILocation(line: 586, column: 34, scope: !1036)
!1069 = !DILocation(line: 587, column: 17, scope: !1036)
!1070 = !DILocation(line: 588, column: 20, scope: !1036)
!1071 = !DILocation(line: 589, column: 18, scope: !1036)
!1072 = !DILocation(line: 590, column: 31, scope: !1036)
!1073 = !{!843, !450, i64 64}
!1074 = !DILocation(line: 590, column: 20, scope: !1036)
!1075 = !DILocation(line: 590, column: 18, scope: !1076)
!1076 = !DILexicalBlockFile(scope: !1036, file: !3, discriminator: 3)
!1077 = !DILocation(line: 591, column: 5, scope: !1078)
!1078 = !DILexicalBlockFile(scope: !1079, file: !3, discriminator: 1)
!1079 = distinct !DILexicalBlock(scope: !1036, file: !3, line: 591, column: 5)
!1080 = !{i32 -2146450170}
!1081 = !DILocation(line: 592, column: 1, scope: !1036)
!1082 = distinct !DISubprogram(name: "exit_spi_code", scope: !3, file: !3, line: 595, type: !835, isLocal: true, isDefinition: true, scopeLine: 596, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1083)
!1083 = !{!1084, !1085}
!1084 = !DILocalVariable(name: "lock", arg: 1, scope: !1082, file: !3, line: 595, type: !108)
!1085 = !DILocalVariable(name: "spi_mode", scope: !1082, file: !3, line: 601, type: !108)
!1086 = !DILocation(line: 595, column: 31, scope: !1082)
!1087 = !DILocation(line: 599, column: 17, scope: !1082)
!1088 = !DILocation(line: 519, column: 30, scope: !1006, inlinedAt: !1089)
!1089 = distinct !DILocation(line: 599, column: 5, scope: !1082)
!1090 = !DILocation(line: 521, column: 17, scope: !1006, inlinedAt: !1089)
!1091 = !DILocation(line: 601, column: 33, scope: !1082)
!1092 = !DILocation(line: 601, column: 22, scope: !1082)
!1093 = !DILocation(line: 601, column: 72, scope: !1094)
!1094 = !DILexicalBlockFile(scope: !1082, file: !3, discriminator: 1)
!1095 = !DILocation(line: 601, column: 22, scope: !1094)
!1096 = !DILocation(line: 601, column: 9, scope: !1082)
!1097 = !DILocation(line: 612, column: 31, scope: !1082)
!1098 = !DILocation(line: 612, column: 18, scope: !1082)
!1099 = !DILocation(line: 613, column: 20, scope: !1082)
!1100 = !DILocation(line: 614, column: 5, scope: !1101)
!1101 = !DILexicalBlockFile(scope: !1102, file: !3, discriminator: 1)
!1102 = distinct !DILexicalBlock(scope: !1082, file: !3, line: 614, column: 5)
!1103 = !{i32 -2146449678}
!1104 = !DILocation(line: 615, column: 5, scope: !1082)
!1105 = !DILocation(line: 615, column: 20, scope: !1094)
!1106 = !DILocation(line: 615, column: 5, scope: !1094)
!1107 = distinct !{!1107, !1104, !1108}
!1108 = !DILocation(line: 615, column: 34, scope: !1082)
!1109 = !DILocation(line: 616, column: 30, scope: !1082)
!1110 = !DILocation(line: 616, column: 17, scope: !1082)
!1111 = !DILocation(line: 617, column: 24, scope: !1082)
!1112 = !DILocation(line: 618, column: 5, scope: !1113)
!1113 = !DILexicalBlockFile(scope: !1114, file: !3, discriminator: 1)
!1114 = distinct !DILexicalBlock(scope: !1082, file: !3, line: 618, column: 5)
!1115 = !{i32 -2146449391}
!1116 = !DILocation(line: 621, column: 21, scope: !1117)
!1117 = distinct !DILexicalBlock(scope: !1082, file: !3, line: 621, column: 9)
!1118 = !DILocation(line: 621, column: 10, scope: !1117)
!1119 = !DILocation(line: 621, column: 9, scope: !1082)
!1120 = !DILocation(line: 622, column: 9, scope: !1121)
!1121 = distinct !DILexicalBlock(scope: !1117, file: !3, line: 621, column: 33)
!1122 = !DILocation(line: 623, column: 5, scope: !1121)
!1123 = !DILocation(line: 625, column: 5, scope: !1124)
!1124 = distinct !DILexicalBlock(scope: !1082, file: !3, line: 625, column: 5)
!1125 = !DILocation(line: 626, column: 1, scope: !1082)
!1126 = distinct !DISubprogram(name: "norflash_write_enable", scope: !3, file: !3, line: 629, type: !670, isLocal: true, isDefinition: true, scopeLine: 630, isOptimized: true, unit: !2, variables: !4)
!1127 = !DILocation(line: 631, column: 5, scope: !1126)
!1128 = !DILocation(line: 632, column: 5, scope: !1126)
!1129 = !DILocation(line: 633, column: 5, scope: !1126)
!1130 = !DILocation(line: 635, column: 1, scope: !1126)
!1131 = distinct !DISubprogram(name: "norflash_send_addr", scope: !3, file: !3, line: 638, type: !835, isLocal: true, isDefinition: true, scopeLine: 639, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1132)
!1132 = !{!1133}
!1133 = !DILocalVariable(name: "addr", arg: 1, scope: !1131, file: !3, line: 638, type: !108)
!1134 = !DILocation(line: 638, column: 36, scope: !1131)
!1135 = !DILocation(line: 640, column: 9, scope: !1136)
!1136 = distinct !DILexicalBlock(scope: !1131, file: !3, line: 640, column: 9)
!1137 = !DILocation(line: 640, column: 9, scope: !1131)
!1138 = !DILocation(line: 641, column: 28, scope: !1139)
!1139 = distinct !DILexicalBlock(scope: !1136, file: !3, line: 640, column: 23)
!1140 = !DILocation(line: 641, column: 23, scope: !1139)
!1141 = !DILocation(line: 641, column: 9, scope: !1139)
!1142 = !DILocation(line: 642, column: 5, scope: !1139)
!1143 = !DILocation(line: 643, column: 24, scope: !1131)
!1144 = !DILocation(line: 643, column: 19, scope: !1131)
!1145 = !DILocation(line: 643, column: 5, scope: !1131)
!1146 = !DILocation(line: 644, column: 24, scope: !1131)
!1147 = !DILocation(line: 644, column: 19, scope: !1131)
!1148 = !DILocation(line: 644, column: 5, scope: !1131)
!1149 = !DILocation(line: 645, column: 19, scope: !1131)
!1150 = !DILocation(line: 645, column: 5, scope: !1131)
!1151 = !DILocation(line: 646, column: 1, scope: !1131)
!1152 = distinct !DISubprogram(name: "norflash_is_busy", scope: !3, file: !3, line: 649, type: !1002, isLocal: true, isDefinition: true, scopeLine: 650, isOptimized: true, unit: !2, variables: !1153)
!1153 = !{!1154}
!1154 = !DILocalVariable(name: "st", scope: !1152, file: !3, line: 653, type: !108)
!1155 = !DILocation(line: 651, column: 5, scope: !1152)
!1156 = !DILocation(line: 652, column: 5, scope: !1152)
!1157 = !DILocation(line: 653, column: 14, scope: !1152)
!1158 = !DILocation(line: 654, column: 5, scope: !1152)
!1159 = !DILocation(line: 655, column: 15, scope: !1152)
!1160 = !DILocation(line: 655, column: 5, scope: !1152)
!1161 = distinct !DISubprogram(name: "norflash_suspend", scope: !3, file: !3, line: 659, type: !670, isLocal: true, isDefinition: true, scopeLine: 660, isOptimized: true, unit: !2, variables: !4)
!1162 = !DILocation(line: 661, column: 5, scope: !1161)
!1163 = !DILocation(line: 662, column: 5, scope: !1161)
!1164 = !DILocation(line: 663, column: 5, scope: !1161)
!1165 = !DILocation(line: 664, column: 1, scope: !1161)
!1166 = distinct !DISubprogram(name: "norflash_resume", scope: !3, file: !3, line: 667, type: !670, isLocal: true, isDefinition: true, scopeLine: 668, isOptimized: true, unit: !2, variables: !4)
!1167 = !DILocation(line: 669, column: 5, scope: !1166)
!1168 = !DILocation(line: 670, column: 5, scope: !1166)
!1169 = !DILocation(line: 671, column: 5, scope: !1166)
!1170 = !DILocation(line: 672, column: 1, scope: !1166)
!1171 = distinct !DISubprogram(name: "norflash_wait_ok", scope: !3, file: !3, line: 675, type: !585, isLocal: true, isDefinition: true, scopeLine: 676, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1172)
!1172 = !{!1173, !1174}
!1173 = !DILocalVariable(name: "timeout", scope: !1171, file: !3, line: 677, type: !714)
!1174 = !DILocalVariable(name: "reg", scope: !1175, file: !3, line: 681, type: !108)
!1175 = distinct !DILexicalBlock(scope: !1171, file: !3, line: 678, column: 21)
!1176 = !DILocation(line: 677, column: 5, scope: !1171)
!1177 = !DILocation(line: 677, column: 18, scope: !1171)
!1178 = !DILocation(line: 678, column: 5, scope: !1171)
!1179 = !DILocation(line: 678, column: 12, scope: !1180)
!1180 = !DILexicalBlockFile(scope: !1171, file: !3, discriminator: 1)
!1181 = !DILocation(line: 678, column: 5, scope: !1180)
!1182 = !DILocation(line: 679, column: 9, scope: !1175)
!1183 = !DILocation(line: 680, column: 9, scope: !1175)
!1184 = !DILocation(line: 681, column: 19, scope: !1175)
!1185 = !DILocation(line: 682, column: 9, scope: !1175)
!1186 = !DILocation(line: 683, column: 19, scope: !1187)
!1187 = distinct !DILexicalBlock(scope: !1175, file: !3, line: 683, column: 13)
!1188 = !DILocation(line: 683, column: 13, scope: !1175)
!1189 = !DILocation(line: 686, column: 17, scope: !1175)
!1190 = !DILocation(line: 688, column: 9, scope: !1191)
!1191 = distinct !DILexicalBlock(scope: !1171, file: !3, line: 688, column: 9)
!1192 = !DILocation(line: 688, column: 17, scope: !1191)
!1193 = !DILocation(line: 688, column: 9, scope: !1171)
!1194 = !DILocation(line: 689, column: 9, scope: !1195)
!1195 = distinct !DILexicalBlock(scope: !1191, file: !3, line: 688, column: 23)
!1196 = !DILocation(line: 690, column: 9, scope: !1195)
!1197 = !DILocation(line: 691, column: 9, scope: !1195)
!1198 = !DILocation(line: 692, column: 9, scope: !1195)
!1199 = !DILocation(line: 693, column: 9, scope: !1195)
!1200 = !DILocation(line: 694, column: 9, scope: !1195)
!1201 = !DILocation(line: 695, column: 9, scope: !1195)
!1202 = !DILocation(line: 696, column: 9, scope: !1195)
!1203 = !DILocation(line: 697, column: 9, scope: !1195)
!1204 = !DILocation(line: 698, column: 9, scope: !1195)
!1205 = !DILocation(line: 699, column: 9, scope: !1195)
!1206 = !DILocation(line: 700, column: 9, scope: !1195)
!1207 = !DILocation(line: 701, column: 9, scope: !1195)
!1208 = !DILocation(line: 704, column: 1, scope: !1171)
!1209 = distinct !DISubprogram(name: "__norflash_read", scope: !3, file: !3, line: 707, type: !1210, isLocal: true, isDefinition: true, scopeLine: 708, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1212)
!1210 = !DISubroutineType(types: !1211)
!1211 = !{!885, !104, !108, !302, !108}
!1212 = !{!1213, !1214, !1215, !1216, !1217, !1218}
!1213 = !DILocalVariable(name: "buf", arg: 1, scope: !1209, file: !3, line: 707, type: !104)
!1214 = !DILocalVariable(name: "addr", arg: 2, scope: !1209, file: !3, line: 707, type: !108)
!1215 = !DILocalVariable(name: "len", arg: 3, scope: !1209, file: !3, line: 707, type: !302)
!1216 = !DILocalVariable(name: "is_continue_mode", arg: 4, scope: !1209, file: !3, line: 707, type: !108)
!1217 = !DILocalVariable(name: "spi_mode", scope: !1209, file: !3, line: 709, type: !108)
!1218 = !DILocalVariable(name: "addr_and_mode", scope: !1209, file: !3, line: 715, type: !1219)
!1219 = !DICompositeType(tag: DW_TAG_array_type, baseType: !105, size: 32, elements: !1220)
!1220 = !{!1221}
!1221 = !DISubrange(count: 4)
!1222 = !DILocation(line: 707, column: 32, scope: !1209)
!1223 = !DILocation(line: 707, column: 41, scope: !1209)
!1224 = !DILocation(line: 707, column: 51, scope: !1209)
!1225 = !DILocation(line: 707, column: 60, scope: !1209)
!1226 = !DILocation(line: 709, column: 33, scope: !1209)
!1227 = !DILocation(line: 709, column: 22, scope: !1209)
!1228 = !DILocation(line: 709, column: 72, scope: !1229)
!1229 = !DILexicalBlockFile(scope: !1209, file: !3, discriminator: 1)
!1230 = !DILocation(line: 709, column: 22, scope: !1229)
!1231 = !DILocation(line: 709, column: 22, scope: !1232)
!1232 = !DILexicalBlockFile(scope: !1209, file: !3, discriminator: 2)
!1233 = !DILocation(line: 709, column: 77, scope: !1232)
!1234 = !DILocation(line: 715, column: 5, scope: !1209)
!1235 = !DILocation(line: 715, column: 8, scope: !1209)
!1236 = !DILocation(line: 717, column: 5, scope: !1209)
!1237 = !DILocation(line: 719, column: 9, scope: !1238)
!1238 = distinct !DILexicalBlock(scope: !1209, file: !3, line: 717, column: 23)
!1239 = !DILocation(line: 721, column: 9, scope: !1238)
!1240 = !DILocation(line: 722, column: 9, scope: !1238)
!1241 = !DILocation(line: 723, column: 9, scope: !1238)
!1242 = !DILocation(line: 724, column: 9, scope: !1238)
!1243 = !DILocation(line: 725, column: 9, scope: !1238)
!1244 = !DILocation(line: 728, column: 9, scope: !1238)
!1245 = !DILocation(line: 730, column: 9, scope: !1238)
!1246 = !DILocation(line: 731, column: 9, scope: !1238)
!1247 = !DILocation(line: 732, column: 9, scope: !1238)
!1248 = !DILocation(line: 733, column: 9, scope: !1238)
!1249 = !DILocation(line: 734, column: 9, scope: !1238)
!1250 = !DILocation(line: 735, column: 9, scope: !1238)
!1251 = !DILocation(line: 738, column: 38, scope: !1238)
!1252 = !DILocation(line: 738, column: 28, scope: !1238)
!1253 = !DILocation(line: 738, column: 26, scope: !1238)
!1254 = !DILocation(line: 739, column: 38, scope: !1238)
!1255 = !DILocation(line: 739, column: 28, scope: !1238)
!1256 = !DILocation(line: 739, column: 9, scope: !1238)
!1257 = !DILocation(line: 739, column: 26, scope: !1238)
!1258 = !DILocation(line: 740, column: 28, scope: !1238)
!1259 = !DILocation(line: 740, column: 9, scope: !1238)
!1260 = !DILocation(line: 740, column: 26, scope: !1238)
!1261 = !DILocation(line: 741, column: 9, scope: !1238)
!1262 = !DILocation(line: 741, column: 26, scope: !1238)
!1263 = !DILocation(line: 742, column: 9, scope: !1238)
!1264 = !DILocation(line: 744, column: 9, scope: !1238)
!1265 = !DILocation(line: 745, column: 9, scope: !1238)
!1266 = !DILocation(line: 746, column: 9, scope: !1238)
!1267 = !DILocation(line: 747, column: 9, scope: !1238)
!1268 = !DILocation(line: 748, column: 9, scope: !1238)
!1269 = !DILocation(line: 751, column: 38, scope: !1238)
!1270 = !DILocation(line: 751, column: 28, scope: !1238)
!1271 = !DILocation(line: 751, column: 26, scope: !1238)
!1272 = !DILocation(line: 752, column: 38, scope: !1238)
!1273 = !DILocation(line: 752, column: 28, scope: !1238)
!1274 = !DILocation(line: 752, column: 9, scope: !1238)
!1275 = !DILocation(line: 752, column: 26, scope: !1238)
!1276 = !DILocation(line: 753, column: 28, scope: !1238)
!1277 = !DILocation(line: 753, column: 9, scope: !1238)
!1278 = !DILocation(line: 753, column: 26, scope: !1238)
!1279 = !DILocation(line: 754, column: 9, scope: !1238)
!1280 = !DILocation(line: 754, column: 26, scope: !1238)
!1281 = !DILocation(line: 755, column: 9, scope: !1238)
!1282 = !DILocation(line: 756, column: 13, scope: !1283)
!1283 = distinct !DILexicalBlock(scope: !1238, file: !3, line: 756, column: 13)
!1284 = !DILocation(line: 756, column: 13, scope: !1238)
!1285 = !DILocation(line: 758, column: 13, scope: !1286)
!1286 = distinct !DILexicalBlock(scope: !1283, file: !3, line: 756, column: 31)
!1287 = !DILocation(line: 759, column: 9, scope: !1286)
!1288 = !DILocation(line: 760, column: 9, scope: !1238)
!1289 = !DILocation(line: 761, column: 9, scope: !1238)
!1290 = !DILocation(line: 762, column: 9, scope: !1238)
!1291 = !DILocation(line: 763, column: 9, scope: !1238)
!1292 = !DILocation(line: 766, column: 9, scope: !1238)
!1293 = !DILocation(line: 768, column: 9, scope: !1238)
!1294 = !DILocation(line: 769, column: 9, scope: !1238)
!1295 = !DILocation(line: 770, column: 9, scope: !1238)
!1296 = !DILocation(line: 771, column: 9, scope: !1238)
!1297 = !DILocation(line: 772, column: 9, scope: !1238)
!1298 = !DILocation(line: 773, column: 9, scope: !1238)
!1299 = !DILocation(line: 776, column: 9, scope: !1238)
!1300 = !DILocation(line: 778, column: 9, scope: !1238)
!1301 = !DILocation(line: 779, column: 9, scope: !1238)
!1302 = !DILocation(line: 780, column: 9, scope: !1238)
!1303 = !DILocation(line: 781, column: 9, scope: !1238)
!1304 = !DILocation(line: 782, column: 9, scope: !1238)
!1305 = !DILocation(line: 783, column: 9, scope: !1238)
!1306 = !DILocation(line: 786, column: 38, scope: !1238)
!1307 = !DILocation(line: 786, column: 28, scope: !1238)
!1308 = !DILocation(line: 786, column: 26, scope: !1238)
!1309 = !DILocation(line: 787, column: 38, scope: !1238)
!1310 = !DILocation(line: 787, column: 28, scope: !1238)
!1311 = !DILocation(line: 787, column: 9, scope: !1238)
!1312 = !DILocation(line: 787, column: 26, scope: !1238)
!1313 = !DILocation(line: 788, column: 28, scope: !1238)
!1314 = !DILocation(line: 788, column: 9, scope: !1238)
!1315 = !DILocation(line: 788, column: 26, scope: !1238)
!1316 = !DILocation(line: 789, column: 9, scope: !1238)
!1317 = !DILocation(line: 789, column: 26, scope: !1238)
!1318 = !DILocation(line: 790, column: 9, scope: !1238)
!1319 = !DILocation(line: 792, column: 9, scope: !1238)
!1320 = !DILocation(line: 793, column: 9, scope: !1238)
!1321 = !DILocation(line: 794, column: 9, scope: !1238)
!1322 = !DILocation(line: 795, column: 9, scope: !1238)
!1323 = !DILocation(line: 796, column: 9, scope: !1238)
!1324 = !DILocation(line: 797, column: 9, scope: !1238)
!1325 = !DILocation(line: 800, column: 38, scope: !1238)
!1326 = !DILocation(line: 800, column: 28, scope: !1238)
!1327 = !DILocation(line: 800, column: 26, scope: !1238)
!1328 = !DILocation(line: 801, column: 38, scope: !1238)
!1329 = !DILocation(line: 801, column: 28, scope: !1238)
!1330 = !DILocation(line: 801, column: 9, scope: !1238)
!1331 = !DILocation(line: 801, column: 26, scope: !1238)
!1332 = !DILocation(line: 802, column: 28, scope: !1238)
!1333 = !DILocation(line: 802, column: 9, scope: !1238)
!1334 = !DILocation(line: 802, column: 26, scope: !1238)
!1335 = !DILocation(line: 803, column: 9, scope: !1238)
!1336 = !DILocation(line: 803, column: 26, scope: !1238)
!1337 = !DILocation(line: 804, column: 9, scope: !1238)
!1338 = !DILocation(line: 805, column: 13, scope: !1339)
!1339 = distinct !DILexicalBlock(scope: !1238, file: !3, line: 805, column: 13)
!1340 = !DILocation(line: 805, column: 13, scope: !1238)
!1341 = !DILocation(line: 807, column: 13, scope: !1342)
!1342 = distinct !DILexicalBlock(scope: !1339, file: !3, line: 805, column: 31)
!1343 = !DILocation(line: 808, column: 9, scope: !1342)
!1344 = !DILocation(line: 809, column: 9, scope: !1238)
!1345 = !DILocation(line: 810, column: 9, scope: !1238)
!1346 = !DILocation(line: 811, column: 9, scope: !1238)
!1347 = !DILocation(line: 812, column: 9, scope: !1238)
!1348 = !DILocation(line: 813, column: 9, scope: !1238)
!1349 = !DILocation(line: 818, column: 12, scope: !1209)
!1350 = !DILocation(line: 818, column: 5, scope: !1209)
!1351 = !DILocation(line: 819, column: 1, scope: !1209)
!1352 = distinct !DISubprogram(name: "exit_continue_mode", scope: !3, file: !3, line: 822, type: !585, isLocal: true, isDefinition: true, scopeLine: 823, isOptimized: true, unit: !2, variables: !1353)
!1353 = !{!1354, !1355}
!1354 = !DILocalVariable(name: "spi_mode", scope: !1352, file: !3, line: 824, type: !108)
!1355 = !DILocalVariable(name: "ret", scope: !1352, file: !3, line: 825, type: !108)
!1356 = !DILocation(line: 824, column: 33, scope: !1352)
!1357 = !DILocation(line: 824, column: 22, scope: !1352)
!1358 = !DILocation(line: 824, column: 72, scope: !1359)
!1359 = !DILexicalBlockFile(scope: !1352, file: !3, discriminator: 1)
!1360 = !DILocation(line: 824, column: 22, scope: !1359)
!1361 = !DILocation(line: 824, column: 22, scope: !1362)
!1362 = !DILexicalBlockFile(scope: !1352, file: !3, discriminator: 2)
!1363 = !DILocation(line: 824, column: 77, scope: !1362)
!1364 = !DILocation(line: 825, column: 9, scope: !1352)
!1365 = !DILocation(line: 827, column: 9, scope: !1352)
!1366 = !DILocation(line: 828, column: 9, scope: !1367)
!1367 = distinct !DILexicalBlock(scope: !1368, file: !3, line: 827, column: 29)
!1368 = distinct !DILexicalBlock(scope: !1352, file: !3, line: 827, column: 9)
!1369 = !DILocation(line: 829, column: 9, scope: !1367)
!1370 = !DILocation(line: 830, column: 9, scope: !1367)
!1371 = !DILocation(line: 832, column: 5, scope: !1367)
!1372 = !DILocation(line: 833, column: 9, scope: !1373)
!1373 = distinct !DILexicalBlock(scope: !1374, file: !3, line: 832, column: 36)
!1374 = distinct !DILexicalBlock(scope: !1368, file: !3, line: 832, column: 16)
!1375 = !DILocation(line: 834, column: 9, scope: !1373)
!1376 = !DILocation(line: 835, column: 9, scope: !1373)
!1377 = !DILocation(line: 836, column: 9, scope: !1373)
!1378 = !DILocation(line: 838, column: 5, scope: !1373)
!1379 = !DILocation(line: 839, column: 5, scope: !1352)
!1380 = distinct !DISubprogram(name: "enter_continue_mode", scope: !3, file: !3, line: 842, type: !670, isLocal: true, isDefinition: true, scopeLine: 843, isOptimized: true, unit: !2, variables: !1381)
!1381 = !{!1382}
!1382 = !DILocalVariable(name: "tmp", scope: !1380, file: !3, line: 844, type: !108)
!1383 = !DILocation(line: 844, column: 5, scope: !1380)
!1384 = !DILocation(line: 845, column: 5, scope: !1380)
!1385 = !DILocation(line: 846, column: 1, scope: !1380)
!1386 = distinct !DISubprogram(name: "norflash_enter_spi_code", scope: !3, file: !3, line: 849, type: !670, isLocal: false, isDefinition: true, scopeLine: 850, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!1387 = !DILocation(line: 851, column: 5, scope: !1386)
!1388 = !DILocation(line: 852, column: 21, scope: !1386)
!1389 = !DILocation(line: 852, column: 19, scope: !1386)
!1390 = !DILocation(line: 853, column: 1, scope: !1386)
!1391 = distinct !DISubprogram(name: "norflash_exit_spi_code", scope: !3, file: !3, line: 855, type: !670, isLocal: false, isDefinition: true, scopeLine: 856, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!1392 = !DILocation(line: 857, column: 9, scope: !1393)
!1393 = distinct !DILexicalBlock(scope: !1391, file: !3, line: 857, column: 9)
!1394 = !DILocation(line: 857, column: 9, scope: !1391)
!1395 = !DILocation(line: 858, column: 9, scope: !1396)
!1396 = distinct !DILexicalBlock(scope: !1393, file: !3, line: 857, column: 24)
!1397 = !DILocation(line: 859, column: 5, scope: !1396)
!1398 = !DILocation(line: 860, column: 5, scope: !1391)
!1399 = !DILocation(line: 861, column: 1, scope: !1391)
!1400 = distinct !DISubprogram(name: "norflash_spi_cs", scope: !3, file: !3, line: 863, type: !488, isLocal: false, isDefinition: true, scopeLine: 864, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1401)
!1401 = !{!1402}
!1402 = !DILocalVariable(name: "cs", arg: 1, scope: !1400, file: !3, line: 863, type: !171)
!1403 = !DILocation(line: 863, column: 27, scope: !1400)
!1404 = !DILocation(line: 865, column: 5, scope: !1400)
!1405 = !DILocation(line: 866, column: 1, scope: !1400)
!1406 = distinct !DISubprogram(name: "norflash_spi_write_byte", scope: !3, file: !3, line: 868, type: !1407, isLocal: false, isDefinition: true, scopeLine: 869, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1409)
!1407 = !DISubroutineType(types: !1408)
!1408 = !{null, !107}
!1409 = !{!1410}
!1410 = !DILocalVariable(name: "data", arg: 1, scope: !1406, file: !3, line: 868, type: !107)
!1411 = !DILocation(line: 868, column: 44, scope: !1406)
!1412 = !DILocation(line: 870, column: 5, scope: !1406)
!1413 = !DILocation(line: 871, column: 1, scope: !1406)
!1414 = distinct !DISubprogram(name: "norflash_spi_read_byte", scope: !3, file: !3, line: 873, type: !344, isLocal: false, isDefinition: true, scopeLine: 874, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!1415 = !DILocation(line: 875, column: 12, scope: !1414)
!1416 = !DILocation(line: 875, column: 5, scope: !1414)
!1417 = distinct !DISubprogram(name: "norflash_wait_busy", scope: !3, file: !3, line: 878, type: !585, isLocal: false, isDefinition: true, scopeLine: 879, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!1418 = !DILocation(line: 880, column: 12, scope: !1417)
!1419 = !DILocation(line: 880, column: 5, scope: !1417)
!1420 = distinct !DISubprogram(name: "_norflash_read", scope: !3, file: !3, line: 884, type: !1421, isLocal: true, isDefinition: true, scopeLine: 885, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1423)
!1421 = !DISubroutineType(types: !1422)
!1422 = !{!438, !104, !108, !108}
!1423 = !{!1424, !1425, !1426}
!1424 = !DILocalVariable(name: "buf", arg: 1, scope: !1420, file: !3, line: 884, type: !104)
!1425 = !DILocalVariable(name: "offset", arg: 2, scope: !1420, file: !3, line: 884, type: !108)
!1426 = !DILocalVariable(name: "len", arg: 3, scope: !1420, file: !3, line: 884, type: !108)
!1427 = !DILocation(line: 884, column: 31, scope: !1420)
!1428 = !DILocation(line: 884, column: 40, scope: !1420)
!1429 = !DILocation(line: 884, column: 52, scope: !1420)
!1430 = !DILocation(line: 886, column: 5, scope: !1420)
!1431 = !DILocation(line: 887, column: 38, scope: !1420)
!1432 = !DILocation(line: 887, column: 5, scope: !1420)
!1433 = !DILocation(line: 888, column: 34, scope: !1420)
!1434 = !DILocation(line: 888, column: 5, scope: !1420)
!1435 = !DILocation(line: 889, column: 5, scope: !1420)
!1436 = !DILocation(line: 890, column: 5, scope: !1420)
!1437 = !DILocation(line: 891, column: 5, scope: !1420)
!1438 = distinct !DISubprogram(name: "norflash_origin_read", scope: !3, file: !3, line: 894, type: !1421, isLocal: false, isDefinition: true, scopeLine: 895, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1439)
!1439 = !{!1440, !1441, !1442}
!1440 = !DILocalVariable(name: "buf", arg: 1, scope: !1438, file: !3, line: 894, type: !104)
!1441 = !DILocalVariable(name: "offset", arg: 2, scope: !1438, file: !3, line: 894, type: !108)
!1442 = !DILocalVariable(name: "len", arg: 3, scope: !1438, file: !3, line: 894, type: !108)
!1443 = !DILocation(line: 894, column: 30, scope: !1438)
!1444 = !DILocation(line: 894, column: 39, scope: !1438)
!1445 = !DILocation(line: 894, column: 51, scope: !1438)
!1446 = !DILocation(line: 896, column: 12, scope: !1438)
!1447 = !DILocation(line: 896, column: 5, scope: !1438)
!1448 = distinct !DISubprogram(name: "norflash_set_write_cpu_hold", scope: !3, file: !3, line: 953, type: !731, isLocal: false, isDefinition: true, scopeLine: 954, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1449)
!1449 = !{!1450}
!1450 = !DILocalVariable(name: "hold_en", arg: 1, scope: !1448, file: !3, line: 953, type: !105)
!1451 = !DILocation(line: 953, column: 37, scope: !1448)
!1452 = !DILocation(line: 955, column: 29, scope: !1448)
!1453 = !DILocation(line: 955, column: 27, scope: !1448)
!1454 = !DILocation(line: 956, column: 1, scope: !1448)
!1455 = distinct !DISubprogram(name: "norflash_calc_capacity", scope: !3, file: !3, line: 959, type: !980, isLocal: false, isDefinition: true, scopeLine: 960, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1456)
!1456 = !{!1457, !1458}
!1457 = !DILocalVariable(name: "flash_id", arg: 1, scope: !1455, file: !3, line: 959, type: !108)
!1458 = !DILocalVariable(name: "capacity_id", scope: !1455, file: !3, line: 961, type: !108)
!1459 = !DILocation(line: 959, column: 39, scope: !1455)
!1460 = !DILocation(line: 961, column: 32, scope: !1455)
!1461 = !DILocation(line: 961, column: 9, scope: !1455)
!1462 = !DILocation(line: 962, column: 21, scope: !1463)
!1463 = distinct !DILexicalBlock(scope: !1455, file: !3, line: 962, column: 9)
!1464 = !DILocation(line: 962, column: 9, scope: !1455)
!1465 = !DILocation(line: 963, column: 42, scope: !1466)
!1466 = distinct !DILexicalBlock(scope: !1463, file: !3, line: 962, column: 30)
!1467 = !DILocation(line: 964, column: 5, scope: !1466)
!1468 = !DILocation(line: 964, column: 28, scope: !1469)
!1469 = !DILexicalBlockFile(scope: !1470, file: !3, discriminator: 1)
!1470 = distinct !DILexicalBlock(scope: !1463, file: !3, line: 964, column: 16)
!1471 = !DILocation(line: 965, column: 42, scope: !1472)
!1472 = distinct !DILexicalBlock(scope: !1470, file: !3, line: 964, column: 37)
!1473 = !DILocation(line: 964, column: 16, scope: !1474)
!1474 = !DILexicalBlockFile(scope: !1463, file: !3, discriminator: 1)
!1475 = !DILocation(line: 967, column: 39, scope: !1455)
!1476 = !DILocation(line: 967, column: 23, scope: !1455)
!1477 = !DILocation(line: 967, column: 5, scope: !1455)
!1478 = distinct !DISubprogram(name: "norflash_init", scope: !3, file: !3, line: 970, type: !1479, isLocal: false, isDefinition: true, scopeLine: 971, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1535)
!1479 = !DISubroutineType(types: !1480)
!1480 = !{!438, !1481, !266}
!1481 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1482, size: 32)
!1482 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1483)
!1483 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "dev_node", file: !1484, line: 25, size: 96, elements: !1485)
!1484 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/device/device.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!1485 = !{!1486, !1489, !1534}
!1486 = !DIDerivedType(tag: DW_TAG_member, name: "name", scope: !1483, file: !1484, line: 26, baseType: !1487, size: 32)
!1487 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1488, size: 32)
!1488 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !171)
!1489 = !DIDerivedType(tag: DW_TAG_member, name: "ops", scope: !1483, file: !1484, line: 27, baseType: !1490, size: 32, offset: 32)
!1490 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1491, size: 32)
!1491 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1492)
!1492 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "device_operations", file: !1484, line: 14, size: 256, elements: !1493)
!1493 = !{!1494, !1499, !1501, !1517, !1521, !1522, !1526, !1530}
!1494 = !DIDerivedType(tag: DW_TAG_member, name: "online", scope: !1492, file: !1484, line: 15, baseType: !1495, size: 32)
!1495 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1496, size: 32)
!1496 = !DISubroutineType(types: !1497)
!1497 = !{!1498, !1481}
!1498 = !DIDerivedType(tag: DW_TAG_typedef, name: "bool", file: !106, line: 12, baseType: !107)
!1499 = !DIDerivedType(tag: DW_TAG_member, name: "init", scope: !1492, file: !1484, line: 16, baseType: !1500, size: 32, offset: 32)
!1500 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1479, size: 32)
!1501 = !DIDerivedType(tag: DW_TAG_member, name: "open", scope: !1492, file: !1484, line: 17, baseType: !1502, size: 32, offset: 64)
!1502 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1503, size: 32)
!1503 = !DISubroutineType(types: !1504)
!1504 = !{!438, !1487, !1505, !266}
!1505 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1506, size: 32)
!1506 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1507, size: 32)
!1507 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "device", file: !1484, line: 31, size: 96, elements: !1508)
!1508 = !{!1509, !1515, !1516}
!1509 = !DIDerivedType(tag: DW_TAG_member, name: "ref", scope: !1507, file: !1484, line: 32, baseType: !1510, size: 32)
!1510 = !DIDerivedType(tag: DW_TAG_typedef, name: "atomic_t", file: !1511, line: 9, baseType: !1512)
!1511 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/system/generic/atomic.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!1512 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !1511, line: 7, size: 32, elements: !1513)
!1513 = !{!1514}
!1514 = !DIDerivedType(tag: DW_TAG_member, name: "counter", scope: !1512, file: !1511, line: 8, baseType: !438, size: 32)
!1515 = !DIDerivedType(tag: DW_TAG_member, name: "private_data", scope: !1507, file: !1484, line: 33, baseType: !266, size: 32, offset: 32)
!1516 = !DIDerivedType(tag: DW_TAG_member, name: "ops", scope: !1507, file: !1484, line: 34, baseType: !1490, size: 32, offset: 64)
!1517 = !DIDerivedType(tag: DW_TAG_member, name: "read", scope: !1492, file: !1484, line: 18, baseType: !1518, size: 32, offset: 96)
!1518 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1519, size: 32)
!1519 = !DISubroutineType(types: !1520)
!1520 = !{!438, !1506, !266, !108, !108}
!1521 = !DIDerivedType(tag: DW_TAG_member, name: "write", scope: !1492, file: !1484, line: 19, baseType: !1518, size: 32, offset: 128)
!1522 = !DIDerivedType(tag: DW_TAG_member, name: "seek", scope: !1492, file: !1484, line: 20, baseType: !1523, size: 32, offset: 160)
!1523 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1524, size: 32)
!1524 = !DISubroutineType(types: !1525)
!1525 = !{!438, !1506, !108, !438}
!1526 = !DIDerivedType(tag: DW_TAG_member, name: "ioctl", scope: !1492, file: !1484, line: 21, baseType: !1527, size: 32, offset: 192)
!1527 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1528, size: 32)
!1528 = !DISubroutineType(types: !1529)
!1529 = !{!438, !1506, !108, !108}
!1530 = !DIDerivedType(tag: DW_TAG_member, name: "close", scope: !1492, file: !1484, line: 22, baseType: !1531, size: 32, offset: 224)
!1531 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1532, size: 32)
!1532 = !DISubroutineType(types: !1533)
!1533 = !{!438, !1506}
!1534 = !DIDerivedType(tag: DW_TAG_member, name: "priv_data", scope: !1483, file: !1484, line: 28, baseType: !266, size: 32, offset: 64)
!1535 = !{!1536, !1537}
!1536 = !DILocalVariable(name: "node", arg: 1, scope: !1478, file: !3, line: 970, type: !1481)
!1537 = !DILocalVariable(name: "arg", arg: 2, scope: !1478, file: !3, line: 970, type: !266)
!1538 = !DILocation(line: 970, column: 42, scope: !1478)
!1539 = !DILocation(line: 970, column: 54, scope: !1478)
!1540 = !DILocation(line: 973, column: 20, scope: !1541)
!1541 = distinct !DILexicalBlock(scope: !1478, file: !3, line: 973, column: 9)
!1542 = !{!843, !451, i64 16}
!1543 = !DILocation(line: 973, column: 9, scope: !1541)
!1544 = !DILocation(line: 973, column: 9, scope: !1478)
!1545 = !DILocation(line: 977, column: 18, scope: !1478)
!1546 = !DILocation(line: 978, column: 18, scope: !1478)
!1547 = !DILocation(line: 979, column: 18, scope: !1478)
!1548 = !DILocation(line: 980, column: 20, scope: !1478)
!1549 = !DILocation(line: 137, column: 5, scope: !1550, inlinedAt: !1551)
!1550 = distinct !DISubprogram(name: "cpu_sfc_critical_irq_init", scope: !3, file: !3, line: 135, type: !670, isLocal: true, isDefinition: true, scopeLine: 136, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!1551 = distinct !DILocation(line: 982, column: 5, scope: !1478)
!1552 = !DILocation(line: 138, column: 5, scope: !1550, inlinedAt: !1551)
!1553 = !DILocation(line: 983, column: 5, scope: !1478)
!1554 = !DILocation(line: 984, column: 20, scope: !1555)
!1555 = distinct !DILexicalBlock(scope: !1478, file: !3, line: 984, column: 9)
!1556 = !DILocation(line: 984, column: 35, scope: !1555)
!1557 = !DILocation(line: 984, column: 9, scope: !1478)
!1558 = !DILocation(line: 985, column: 9, scope: !1559)
!1559 = distinct !DILexicalBlock(scope: !1555, file: !3, line: 984, column: 41)
!1560 = !DILocation(line: 986, column: 71, scope: !1559)
!1561 = !{!843, !450, i64 28}
!1562 = !DILocation(line: 986, column: 37, scope: !1559)
!1563 = !DILocation(line: 986, column: 35, scope: !1559)
!1564 = !DILocation(line: 987, column: 5, scope: !1559)
!1565 = !DILocation(line: 988, column: 21, scope: !1478)
!1566 = !DILocation(line: 989, column: 29, scope: !1478)
!1567 = !DILocation(line: 989, column: 27, scope: !1478)
!1568 = !DILocation(line: 993, column: 5, scope: !1478)
!1569 = !DILocation(line: 995, column: 9, scope: !1570)
!1570 = distinct !DILexicalBlock(scope: !1478, file: !3, line: 995, column: 9)
!1571 = !DILocation(line: 995, column: 9, scope: !1478)
!1572 = !DILocation(line: 996, column: 39, scope: !1573)
!1573 = distinct !DILexicalBlock(scope: !1570, file: !3, line: 995, column: 43)
!1574 = !DILocation(line: 996, column: 37, scope: !1573)
!1575 = !{!843, !574, i64 76}
!1576 = !DILocation(line: 997, column: 13, scope: !1577)
!1577 = distinct !DILexicalBlock(scope: !1573, file: !3, line: 997, column: 13)
!1578 = !DILocation(line: 997, column: 13, scope: !1573)
!1579 = !DILocation(line: 998, column: 13, scope: !1580)
!1580 = distinct !DILexicalBlock(scope: !1581, file: !3, line: 998, column: 13)
!1581 = distinct !DILexicalBlock(scope: !1577, file: !3, line: 997, column: 42)
!1582 = !DILocation(line: 998, column: 13, scope: !1581)
!1583 = !DILocation(line: 998, column: 13, scope: !1584)
!1584 = !DILexicalBlockFile(scope: !1580, file: !3, discriminator: 1)
!1585 = !DILocation(line: 1000, column: 13, scope: !1586)
!1586 = distinct !DILexicalBlock(scope: !1587, file: !3, line: 1000, column: 13)
!1587 = distinct !DILexicalBlock(scope: !1577, file: !3, line: 999, column: 16)
!1588 = !DILocation(line: 1000, column: 13, scope: !1587)
!1589 = !DILocation(line: 1000, column: 13, scope: !1590)
!1590 = !DILexicalBlockFile(scope: !1586, file: !3, discriminator: 1)
!1591 = !DILocation(line: 1005, column: 1, scope: !1478)
!1592 = distinct !DISubprogram(name: "flash_write_protect_init", scope: !3, file: !3, line: 1438, type: !670, isLocal: false, isDefinition: true, scopeLine: 1439, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1593)
!1593 = !{!1594, !1595}
!1594 = !DILocalVariable(name: "is_no_cmd", scope: !1592, file: !3, line: 1441, type: !108)
!1595 = !DILocalVariable(name: "sr", scope: !1592, file: !3, line: 1442, type: !302)
!1596 = !DILocation(line: 1440, column: 5, scope: !1592)
!1597 = !DILocation(line: 1441, column: 21, scope: !1592)
!1598 = !DILocation(line: 1441, column: 9, scope: !1592)
!1599 = !DILocation(line: 1442, column: 14, scope: !1592)
!1600 = !DILocation(line: 1442, column: 9, scope: !1592)
!1601 = !DILocation(line: 1443, column: 33, scope: !1592)
!1602 = !DILocation(line: 1443, column: 28, scope: !1592)
!1603 = !{!843, !450, i64 68}
!1604 = !DILocation(line: 1444, column: 9, scope: !1605)
!1605 = distinct !DILexicalBlock(scope: !1592, file: !3, line: 1444, column: 9)
!1606 = !DILocation(line: 1444, column: 9, scope: !1592)
!1607 = !DILocation(line: 1445, column: 9, scope: !1608)
!1608 = distinct !DILexicalBlock(scope: !1605, file: !3, line: 1444, column: 20)
!1609 = !DILocation(line: 1446, column: 5, scope: !1608)
!1610 = !DILocation(line: 1447, column: 5, scope: !1592)
!1611 = !DILocation(line: 1448, column: 1, scope: !1592)
!1612 = distinct !DISubprogram(name: "norflash_open", scope: !3, file: !3, line: 1007, type: !1503, isLocal: false, isDefinition: true, scopeLine: 1008, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1613)
!1613 = !{!1614, !1615, !1616}
!1614 = !DILocalVariable(name: "name", arg: 1, scope: !1612, file: !3, line: 1007, type: !1487)
!1615 = !DILocalVariable(name: "device", arg: 2, scope: !1612, file: !3, line: 1007, type: !1505)
!1616 = !DILocalVariable(name: "arg", arg: 3, scope: !1612, file: !3, line: 1007, type: !266)
!1617 = !DILocation(line: 1007, column: 31, scope: !1612)
!1618 = !DILocation(line: 1007, column: 53, scope: !1612)
!1619 = !DILocation(line: 1007, column: 67, scope: !1612)
!1620 = !DILocation(line: 1009, column: 21, scope: !1621)
!1621 = distinct !DILexicalBlock(scope: !1612, file: !3, line: 1009, column: 9)
!1622 = !DILocation(line: 1009, column: 10, scope: !1621)
!1623 = !DILocation(line: 1009, column: 9, scope: !1612)
!1624 = !DILocation(line: 1010, column: 9, scope: !1625)
!1625 = distinct !DILexicalBlock(scope: !1621, file: !3, line: 1009, column: 27)
!1626 = !DILocation(line: 1011, column: 5, scope: !1625)
!1627 = !DILocation(line: 1020, column: 5, scope: !1612)
!1628 = distinct !DISubprogram(name: "norflash_read", scope: !3, file: !3, line: 1023, type: !1519, isLocal: false, isDefinition: true, scopeLine: 1024, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1629)
!1629 = !{!1630, !1631, !1632, !1633}
!1630 = !DILocalVariable(name: "device", arg: 1, scope: !1628, file: !3, line: 1023, type: !1506)
!1631 = !DILocalVariable(name: "buf", arg: 2, scope: !1628, file: !3, line: 1023, type: !266)
!1632 = !DILocalVariable(name: "len", arg: 3, scope: !1628, file: !3, line: 1023, type: !108)
!1633 = !DILocalVariable(name: "offset", arg: 4, scope: !1628, file: !3, line: 1023, type: !108)
!1634 = !DILocation(line: 1023, column: 34, scope: !1628)
!1635 = !DILocation(line: 1023, column: 48, scope: !1628)
!1636 = !DILocation(line: 1023, column: 57, scope: !1628)
!1637 = !DILocation(line: 1023, column: 66, scope: !1628)
!1638 = !DILocation(line: 1025, column: 33, scope: !1639)
!1639 = distinct !DILexicalBlock(scope: !1628, file: !3, line: 1025, column: 9)
!1640 = !DILocation(line: 1025, column: 16, scope: !1639)
!1641 = !DILocation(line: 1025, column: 47, scope: !1639)
!1642 = !DILocation(line: 1029, column: 21, scope: !1643)
!1643 = distinct !DILexicalBlock(scope: !1644, file: !3, line: 1029, column: 13)
!1644 = distinct !DILexicalBlock(scope: !1639, file: !3, line: 1026, column: 105)
!1645 = !DILocation(line: 1025, column: 47, scope: !1646)
!1646 = !DILexicalBlockFile(scope: !1639, file: !3, discriminator: 1)
!1647 = !DILocation(line: 1026, column: 21, scope: !1639)
!1648 = !DILocation(line: 1026, column: 36, scope: !1639)
!1649 = !DILocation(line: 1026, column: 66, scope: !1646)
!1650 = !DILocation(line: 1026, column: 72, scope: !1646)
!1651 = !DILocation(line: 1026, column: 55, scope: !1639)
!1652 = !DILocation(line: 1029, column: 21, scope: !1653)
!1653 = !DILexicalBlockFile(scope: !1643, file: !3, discriminator: 1)
!1654 = !DILocation(line: 1027, column: 9, scope: !1655)
!1655 = distinct !DILexicalBlock(scope: !1644, file: !3, line: 1027, column: 9)
!1656 = !DILocation(line: 1028, column: 9, scope: !1644)
!1657 = !DILocation(line: 1029, column: 45, scope: !1653)
!1658 = !{!843, !450, i64 36}
!1659 = !DILocation(line: 1029, column: 28, scope: !1653)
!1660 = !DILocation(line: 1029, column: 13, scope: !1661)
!1661 = !DILexicalBlockFile(scope: !1644, file: !3, discriminator: 1)
!1662 = !DILocation(line: 1030, column: 17, scope: !1663)
!1663 = distinct !DILexicalBlock(scope: !1643, file: !3, line: 1029, column: 55)
!1664 = !DILocation(line: 1030, column: 13, scope: !1665)
!1665 = !DILexicalBlockFile(scope: !1663, file: !3, discriminator: 1)
!1666 = !DILocation(line: 1031, column: 9, scope: !1663)
!1667 = !DILocation(line: 1032, column: 9, scope: !1668)
!1668 = distinct !DILexicalBlock(scope: !1644, file: !3, line: 1032, column: 9)
!1669 = !DILocation(line: 1033, column: 5, scope: !1644)
!1670 = !DILocation(line: 1034, column: 13, scope: !1671)
!1671 = distinct !DILexicalBlock(scope: !1672, file: !3, line: 1034, column: 13)
!1672 = distinct !DILexicalBlock(scope: !1639, file: !3, line: 1033, column: 12)
!1673 = !DILocation(line: 1034, column: 53, scope: !1674)
!1674 = !DILexicalBlockFile(scope: !1671, file: !3, discriminator: 1)
!1675 = !DILocation(line: 1034, column: 42, scope: !1674)
!1676 = !DILocation(line: 1034, column: 39, scope: !1671)
!1677 = !DILocation(line: 1035, column: 13, scope: !1678)
!1678 = distinct !DILexicalBlock(scope: !1679, file: !3, line: 1035, column: 13)
!1679 = distinct !DILexicalBlock(scope: !1671, file: !3, line: 1034, column: 59)
!1680 = !DILocation(line: 1036, column: 9, scope: !1679)
!1681 = !DILocation(line: 1037, column: 35, scope: !1672)
!1682 = !DILocation(line: 1037, column: 21, scope: !1672)
!1683 = !DILocation(line: 1037, column: 9, scope: !1672)
!1684 = !DILocation(line: 1038, column: 53, scope: !1685)
!1685 = !DILexicalBlockFile(scope: !1686, file: !3, discriminator: 1)
!1686 = distinct !DILexicalBlock(scope: !1672, file: !3, line: 1038, column: 13)
!1687 = !DILocation(line: 1038, column: 42, scope: !1685)
!1688 = !DILocation(line: 1038, column: 39, scope: !1686)
!1689 = !DILocation(line: 1039, column: 13, scope: !1690)
!1690 = distinct !DILexicalBlock(scope: !1691, file: !3, line: 1039, column: 13)
!1691 = distinct !DILexicalBlock(scope: !1686, file: !3, line: 1038, column: 59)
!1692 = !DILocation(line: 1040, column: 9, scope: !1691)
!1693 = !DILocation(line: 1042, column: 5, scope: !1628)
!1694 = distinct !DISubprogram(name: "norflash_readback_check_control", scope: !3, file: !3, line: 1045, type: !731, isLocal: false, isDefinition: true, scopeLine: 1046, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1695)
!1695 = !{!1696}
!1696 = !DILocalVariable(name: "enable", arg: 1, scope: !1694, file: !3, line: 1045, type: !105)
!1697 = !DILocation(line: 1045, column: 41, scope: !1694)
!1698 = !DILocation(line: 1047, column: 28, scope: !1694)
!1699 = !DILocation(line: 1047, column: 27, scope: !1694)
!1700 = !DILocation(line: 1047, column: 25, scope: !1694)
!1701 = !DILocation(line: 1048, column: 1, scope: !1694)
!1702 = distinct !DISubprogram(name: "_norflash_write", scope: !3, file: !3, line: 1100, type: !1421, isLocal: true, isDefinition: true, scopeLine: 1101, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1703)
!1703 = !{!1704, !1705, !1706, !1707, !1708}
!1704 = !DILocalVariable(name: "buf", arg: 1, scope: !1702, file: !3, line: 1100, type: !104)
!1705 = !DILocalVariable(name: "offset", arg: 2, scope: !1702, file: !3, line: 1100, type: !108)
!1706 = !DILocalVariable(name: "len", arg: 3, scope: !1702, file: !3, line: 1100, type: !108)
!1707 = !DILocalVariable(name: "_len", scope: !1702, file: !3, line: 1102, type: !108)
!1708 = !DILocalVariable(name: "is_no_cmd", scope: !1702, file: !3, line: 1109, type: !108)
!1709 = !DILocation(line: 1100, column: 32, scope: !1702)
!1710 = !DILocation(line: 1100, column: 41, scope: !1702)
!1711 = !DILocation(line: 1100, column: 53, scope: !1702)
!1712 = !DILocation(line: 1102, column: 9, scope: !1702)
!1713 = !DILocation(line: 1104, column: 13, scope: !1714)
!1714 = distinct !DILexicalBlock(scope: !1702, file: !3, line: 1104, column: 9)
!1715 = !DILocation(line: 1104, column: 9, scope: !1702)
!1716 = !DILocation(line: 1107, column: 5, scope: !1702)
!1717 = !DILocation(line: 1108, column: 38, scope: !1702)
!1718 = !DILocation(line: 1108, column: 5, scope: !1702)
!1719 = !DILocation(line: 1109, column: 21, scope: !1702)
!1720 = !DILocation(line: 1109, column: 9, scope: !1702)
!1721 = !DILocation(line: 1110, column: 5, scope: !1702)
!1722 = !DILocation(line: 1111, column: 5, scope: !1702)
!1723 = !DILocation(line: 1113, column: 5, scope: !1702)
!1724 = !DILocation(line: 1114, column: 5, scope: !1702)
!1725 = !DILocation(line: 1116, column: 5, scope: !1702)
!1726 = !DILocation(line: 1116, column: 5, scope: !1727)
!1727 = !DILexicalBlockFile(scope: !1702, file: !3, discriminator: 1)
!1728 = !DILocation(line: 1116, column: 15, scope: !1729)
!1729 = !DILexicalBlockFile(scope: !1702, file: !3, discriminator: 2)
!1730 = !DILocation(line: 1117, column: 27, scope: !1731)
!1731 = distinct !DILexicalBlock(scope: !1702, file: !3, line: 1116, column: 19)
!1732 = !DILocation(line: 1117, column: 23, scope: !1731)
!1733 = !DILocation(line: 1117, column: 9, scope: !1731)
!1734 = !DILocation(line: 1116, column: 5, scope: !1729)
!1735 = distinct !{!1735, !1725, !1736}
!1736 = !DILocation(line: 1118, column: 5, scope: !1702)
!1737 = !DILocation(line: 1119, column: 5, scope: !1702)
!1738 = !DILocation(line: 1120, column: 26, scope: !1702)
!1739 = !DILocation(line: 1120, column: 20, scope: !1702)
!1740 = !DILocation(line: 1120, column: 5, scope: !1727)
!1741 = !DILocation(line: 1121, column: 5, scope: !1702)
!1742 = !DILocation(line: 1122, column: 9, scope: !1743)
!1743 = distinct !DILexicalBlock(scope: !1702, file: !3, line: 1122, column: 9)
!1744 = !DILocation(line: 1122, column: 9, scope: !1702)
!1745 = !DILocation(line: 1123, column: 9, scope: !1746)
!1746 = distinct !DILexicalBlock(scope: !1743, file: !3, line: 1122, column: 20)
!1747 = !DILocation(line: 1124, column: 5, scope: !1746)
!1748 = !DILocation(line: 1125, column: 5, scope: !1702)
!1749 = !DILocation(line: 1126, column: 5, scope: !1702)
!1750 = !DILocation(line: 1128, column: 1, scope: !1727)
!1751 = distinct !DISubprogram(name: "norflash_write", scope: !3, file: !3, line: 1130, type: !1519, isLocal: false, isDefinition: true, scopeLine: 1131, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1752)
!1752 = !{!1753, !1754, !1755, !1756, !1757, !1758, !1759, !1760, !1761, !1763}
!1753 = !DILocalVariable(name: "device", arg: 1, scope: !1751, file: !3, line: 1130, type: !1506)
!1754 = !DILocalVariable(name: "buf", arg: 2, scope: !1751, file: !3, line: 1130, type: !266)
!1755 = !DILocalVariable(name: "len", arg: 3, scope: !1751, file: !3, line: 1130, type: !108)
!1756 = !DILocalVariable(name: "offset", arg: 4, scope: !1751, file: !3, line: 1130, type: !108)
!1757 = !DILocalVariable(name: "wr_addr", scope: !1751, file: !3, line: 1132, type: !108)
!1758 = !DILocalVariable(name: "_len", scope: !1751, file: !3, line: 1149, type: !438)
!1759 = !DILocalVariable(name: "_buf", scope: !1751, file: !3, line: 1150, type: !104)
!1760 = !DILocalVariable(name: "first_page_len", scope: !1751, file: !3, line: 1151, type: !108)
!1761 = !DILocalVariable(name: "cnt", scope: !1762, file: !3, line: 1158, type: !108)
!1762 = distinct !DILexicalBlock(scope: !1751, file: !3, line: 1157, column: 18)
!1763 = !DILocalVariable(name: "check", scope: !1751, file: !3, line: 1165, type: !438)
!1764 = !DILocation(line: 1130, column: 35, scope: !1751)
!1765 = !DILocation(line: 1130, column: 49, scope: !1751)
!1766 = !DILocation(line: 1130, column: 58, scope: !1751)
!1767 = !DILocation(line: 1130, column: 67, scope: !1751)
!1768 = !DILocation(line: 1132, column: 9, scope: !1751)
!1769 = !DILocation(line: 1136, column: 17, scope: !1770)
!1770 = distinct !DILexicalBlock(scope: !1751, file: !3, line: 1136, column: 9)
!1771 = !DILocation(line: 1136, column: 37, scope: !1770)
!1772 = !DILocation(line: 1136, column: 24, scope: !1770)
!1773 = !DILocation(line: 1136, column: 9, scope: !1751)
!1774 = !DILocation(line: 1137, column: 9, scope: !1775)
!1775 = distinct !DILexicalBlock(scope: !1776, file: !3, line: 1137, column: 9)
!1776 = distinct !DILexicalBlock(scope: !1770, file: !3, line: 1136, column: 53)
!1777 = !DILocation(line: 1137, column: 9, scope: !1776)
!1778 = !DILocation(line: 1137, column: 9, scope: !1779)
!1779 = !DILexicalBlockFile(scope: !1775, file: !3, discriminator: 1)
!1780 = !DILocation(line: 1148, column: 5, scope: !1781)
!1781 = distinct !DILexicalBlock(scope: !1751, file: !3, line: 1148, column: 5)
!1782 = !DILocation(line: 1149, column: 9, scope: !1751)
!1783 = !DILocation(line: 1150, column: 9, scope: !1751)
!1784 = !DILocation(line: 1151, column: 40, scope: !1751)
!1785 = !DILocation(line: 1151, column: 30, scope: !1751)
!1786 = !DILocation(line: 1151, column: 9, scope: !1751)
!1787 = !DILocation(line: 1152, column: 27, scope: !1751)
!1788 = !DILocation(line: 1152, column: 22, scope: !1751)
!1789 = !DILocation(line: 1153, column: 5, scope: !1751)
!1790 = !DILocation(line: 1154, column: 10, scope: !1751)
!1791 = !DILocation(line: 1155, column: 10, scope: !1751)
!1792 = !DILocation(line: 1156, column: 12, scope: !1751)
!1793 = !DILocation(line: 1157, column: 5, scope: !1751)
!1794 = !DILocation(line: 1157, column: 5, scope: !1795)
!1795 = !DILexicalBlockFile(scope: !1751, file: !3, discriminator: 1)
!1796 = !DILocation(line: 1158, column: 19, scope: !1762)
!1797 = !DILocation(line: 1158, column: 13, scope: !1762)
!1798 = !DILocation(line: 1159, column: 9, scope: !1762)
!1799 = !DILocation(line: 1160, column: 14, scope: !1762)
!1800 = !DILocation(line: 1161, column: 16, scope: !1762)
!1801 = !DILocation(line: 1162, column: 14, scope: !1762)
!1802 = !DILocation(line: 1157, column: 5, scope: !1803)
!1803 = !DILexicalBlockFile(scope: !1751, file: !3, discriminator: 2)
!1804 = distinct !{!1804, !1793, !1805}
!1805 = !DILocation(line: 1163, column: 5, scope: !1751)
!1806 = !DILocation(line: 1165, column: 9, scope: !1751)
!1807 = !DILocation(line: 1166, column: 9, scope: !1808)
!1808 = distinct !DILexicalBlock(scope: !1751, file: !3, line: 1166, column: 9)
!1809 = !DILocation(line: 1166, column: 56, scope: !1810)
!1810 = !DILexicalBlockFile(scope: !1808, file: !3, discriminator: 1)
!1811 = !DILocation(line: 1166, column: 42, scope: !1808)
!1812 = !DILocation(line: 1054, column: 10, scope: !1813, inlinedAt: !1826)
!1813 = distinct !DILexicalBlock(scope: !1814, file: !3, line: 1054, column: 9)
!1814 = distinct !DISubprogram(name: "norflash_data_check", scope: !3, file: !3, line: 1051, type: !1815, isLocal: true, isDefinition: true, scopeLine: 1053, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1817)
!1815 = !DISubroutineType(types: !1816)
!1816 = !{!438, !266, !108, !266, !108, !108}
!1817 = !{!1818, !1819, !1820, !1821, !1822, !1823, !1824, !1825}
!1818 = !DILocalVariable(name: "data", arg: 1, scope: !1814, file: !3, line: 1051, type: !266)
!1819 = !DILocalVariable(name: "data_len", arg: 2, scope: !1814, file: !3, line: 1051, type: !108)
!1820 = !DILocalVariable(name: "buf", arg: 3, scope: !1814, file: !3, line: 1052, type: !266)
!1821 = !DILocalVariable(name: "buf_len", arg: 4, scope: !1814, file: !3, line: 1052, type: !108)
!1822 = !DILocalVariable(name: "offset", arg: 5, scope: !1814, file: !3, line: 1052, type: !108)
!1823 = !DILocalVariable(name: "already_check_len", scope: !1814, file: !3, line: 1058, type: !108)
!1824 = !DILocalVariable(name: "read_len", scope: !1814, file: !3, line: 1059, type: !108)
!1825 = !DILocalVariable(name: "read_addr", scope: !1814, file: !3, line: 1060, type: !108)
!1826 = distinct !DILocation(line: 1167, column: 17, scope: !1827)
!1827 = distinct !DILexicalBlock(scope: !1808, file: !3, line: 1166, column: 74)
!1828 = !DILocation(line: 1052, column: 47, scope: !1814, inlinedAt: !1826)
!1829 = !DILocation(line: 1058, column: 9, scope: !1814, inlinedAt: !1826)
!1830 = !DILocation(line: 1062, column: 30, scope: !1831, inlinedAt: !1826)
!1831 = !DILexicalBlockFile(scope: !1814, file: !3, discriminator: 1)
!1832 = !DILocation(line: 1062, column: 5, scope: !1831, inlinedAt: !1826)
!1833 = !DILocation(line: 1063, column: 9, scope: !1834, inlinedAt: !1826)
!1834 = distinct !DILexicalBlock(scope: !1814, file: !3, line: 1062, column: 43)
!1835 = !DILocation(line: 1065, column: 28, scope: !1834, inlinedAt: !1826)
!1836 = !DILocation(line: 1060, column: 9, scope: !1814, inlinedAt: !1826)
!1837 = !DILocation(line: 1066, column: 31, scope: !1834, inlinedAt: !1826)
!1838 = !DILocation(line: 1066, column: 20, scope: !1839, inlinedAt: !1826)
!1839 = !DILexicalBlockFile(scope: !1834, file: !3, discriminator: 1)
!1840 = !DILocation(line: 1059, column: 9, scope: !1814, inlinedAt: !1826)
!1841 = !DILocation(line: 1076, column: 9, scope: !1834, inlinedAt: !1826)
!1842 = !DILocation(line: 1084, column: 25, scope: !1843, inlinedAt: !1826)
!1843 = distinct !DILexicalBlock(scope: !1834, file: !3, line: 1084, column: 13)
!1844 = !DILocation(line: 1084, column: 13, scope: !1843, inlinedAt: !1826)
!1845 = !DILocation(line: 1084, column: 13, scope: !1834, inlinedAt: !1826)
!1846 = !DILocation(line: 1085, column: 13, scope: !1847, inlinedAt: !1826)
!1847 = distinct !DILexicalBlock(scope: !1848, file: !3, line: 1085, column: 13)
!1848 = distinct !DILexicalBlock(scope: !1843, file: !3, line: 1084, column: 62)
!1849 = !DILocation(line: 1085, column: 13, scope: !1848, inlinedAt: !1826)
!1850 = !DILocation(line: 1085, column: 13, scope: !1851, inlinedAt: !1826)
!1851 = !DILexicalBlockFile(scope: !1847, file: !3, discriminator: 1)
!1852 = !DILocation(line: 1086, column: 13, scope: !1853, inlinedAt: !1826)
!1853 = !DILexicalBlockFile(scope: !1854, file: !3, discriminator: 1)
!1854 = distinct !DILexicalBlock(scope: !1848, file: !3, line: 1086, column: 13)
!1855 = !DILocation(line: 1087, column: 13, scope: !1856, inlinedAt: !1826)
!1856 = !DILexicalBlockFile(scope: !1857, file: !3, discriminator: 1)
!1857 = distinct !DILexicalBlock(scope: !1848, file: !3, line: 1087, column: 13)
!1858 = !DILocation(line: 1088, column: 13, scope: !1859, inlinedAt: !1826)
!1859 = !DILexicalBlockFile(scope: !1860, file: !3, discriminator: 1)
!1860 = distinct !DILexicalBlock(scope: !1848, file: !3, line: 1088, column: 13)
!1861 = !DILocation(line: 1089, column: 13, scope: !1862, inlinedAt: !1826)
!1862 = !DILexicalBlockFile(scope: !1863, file: !3, discriminator: 1)
!1863 = distinct !DILexicalBlock(scope: !1848, file: !3, line: 1089, column: 13)
!1864 = !DILocation(line: 1093, column: 27, scope: !1834, inlinedAt: !1826)
!1865 = distinct !{!1865, !1866, !1867}
!1866 = !DILocation(line: 1062, column: 5, scope: !1814)
!1867 = !DILocation(line: 1094, column: 5, scope: !1814)
!1868 = !DILocation(line: 1171, column: 5, scope: !1869)
!1869 = distinct !DILexicalBlock(scope: !1751, file: !3, line: 1171, column: 5)
!1870 = !DILocation(line: 1171, column: 5, scope: !1871)
!1871 = !DILexicalBlockFile(scope: !1869, file: !3, discriminator: 1)
!1872 = !DILocation(line: 1173, column: 9, scope: !1873)
!1873 = distinct !DILexicalBlock(scope: !1751, file: !3, line: 1173, column: 9)
!1874 = !DILocation(line: 1173, column: 42, scope: !1873)
!1875 = !DILocation(line: 1174, column: 9, scope: !1876)
!1876 = distinct !DILexicalBlock(scope: !1873, file: !3, line: 1173, column: 58)
!1877 = !DILocation(line: 1178, column: 1, scope: !1795)
!1878 = distinct !DISubprogram(name: "norflash_erase", scope: !3, file: !3, line: 1181, type: !1879, isLocal: false, isDefinition: true, scopeLine: 1182, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1881)
!1879 = !DISubroutineType(types: !1880)
!1880 = !{!438, !108, !108}
!1881 = !{!1882, !1883, !1884, !1885, !1886}
!1882 = !DILocalVariable(name: "cmd", arg: 1, scope: !1878, file: !3, line: 1181, type: !108)
!1883 = !DILocalVariable(name: "addr", arg: 2, scope: !1878, file: !3, line: 1181, type: !108)
!1884 = !DILocalVariable(name: "len", scope: !1878, file: !3, line: 1183, type: !108)
!1885 = !DILocalVariable(name: "protect_addr", scope: !1878, file: !3, line: 1202, type: !108)
!1886 = !DILocalVariable(name: "is_no_cmd", scope: !1878, file: !3, line: 1230, type: !108)
!1887 = !DILocation(line: 1181, column: 24, scope: !1878)
!1888 = !DILocation(line: 1181, column: 33, scope: !1878)
!1889 = !DILocation(line: 1184, column: 9, scope: !1878)
!1890 = !DILocation(line: 1183, column: 9, scope: !1878)
!1891 = !DILocation(line: 1190, column: 5, scope: !1892)
!1892 = distinct !DILexicalBlock(scope: !1893, file: !3, line: 1187, column: 42)
!1893 = distinct !DILexicalBlock(scope: !1894, file: !3, line: 1187, column: 16)
!1894 = distinct !DILexicalBlock(scope: !1878, file: !3, line: 1184, column: 9)
!1895 = !DILocation(line: 1193, column: 5, scope: !1896)
!1896 = distinct !DILexicalBlock(scope: !1897, file: !3, line: 1190, column: 41)
!1897 = distinct !DILexicalBlock(scope: !1893, file: !3, line: 1190, column: 16)
!1898 = !DILocation(line: 1195, column: 26, scope: !1899)
!1899 = distinct !DILexicalBlock(scope: !1900, file: !3, line: 1193, column: 41)
!1900 = distinct !DILexicalBlock(scope: !1897, file: !3, line: 1193, column: 16)
!1901 = !DILocation(line: 1199, column: 13, scope: !1878)
!1902 = !DILocation(line: 1199, column: 10, scope: !1878)
!1903 = !DILocation(line: 1202, column: 35, scope: !1878)
!1904 = !DILocation(line: 1202, column: 50, scope: !1878)
!1905 = !DILocation(line: 1202, column: 9, scope: !1878)
!1906 = !DILocation(line: 1203, column: 14, scope: !1907)
!1907 = distinct !DILexicalBlock(scope: !1878, file: !3, line: 1203, column: 9)
!1908 = !DILocation(line: 1203, column: 9, scope: !1878)
!1909 = !DILocation(line: 1217, column: 5, scope: !1878)
!1910 = !DILocation(line: 1218, column: 5, scope: !1878)
!1911 = !DILocation(line: 1230, column: 21, scope: !1878)
!1912 = !DILocation(line: 1230, column: 9, scope: !1878)
!1913 = !DILocation(line: 1231, column: 5, scope: !1878)
!1914 = !DILocation(line: 1232, column: 5, scope: !1878)
!1915 = !DILocation(line: 1233, column: 5, scope: !1878)
!1916 = !DILocation(line: 1234, column: 5, scope: !1878)
!1917 = !DILocation(line: 1235, column: 5, scope: !1878)
!1918 = !DILocation(line: 1236, column: 26, scope: !1878)
!1919 = !DILocation(line: 1236, column: 20, scope: !1878)
!1920 = !DILocation(line: 1236, column: 5, scope: !1921)
!1921 = !DILexicalBlockFile(scope: !1878, file: !3, discriminator: 1)
!1922 = !DILocation(line: 1237, column: 5, scope: !1878)
!1923 = !DILocation(line: 1238, column: 9, scope: !1924)
!1924 = distinct !DILexicalBlock(scope: !1878, file: !3, line: 1238, column: 9)
!1925 = !DILocation(line: 1238, column: 9, scope: !1878)
!1926 = !DILocation(line: 1239, column: 9, scope: !1927)
!1927 = distinct !DILexicalBlock(scope: !1924, file: !3, line: 1238, column: 20)
!1928 = !DILocation(line: 1240, column: 5, scope: !1927)
!1929 = !DILocation(line: 1241, column: 5, scope: !1878)
!1930 = !DILocation(line: 1242, column: 5, scope: !1878)
!1931 = !DILocation(line: 1244, column: 1, scope: !1932)
!1932 = !DILexicalBlockFile(scope: !1878, file: !3, discriminator: 2)
!1933 = distinct !DISubprogram(name: "flushinv_dcache_api", scope: !3, file: !3, line: 1247, type: !1934, isLocal: true, isDefinition: true, scopeLine: 1248, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1936)
!1934 = !DISubroutineType(types: !1935)
!1935 = !{null, !108, !108}
!1936 = !{!1937, !1938}
!1937 = !DILocalVariable(name: "addr", arg: 1, scope: !1933, file: !3, line: 1247, type: !108)
!1938 = !DILocalVariable(name: "len", arg: 2, scope: !1933, file: !3, line: 1247, type: !108)
!1939 = !DILocation(line: 1247, column: 37, scope: !1933)
!1940 = !DILocation(line: 1247, column: 47, scope: !1933)
!1941 = !DILocation(line: 1249, column: 5, scope: !1933)
!1942 = !DILocation(line: 1250, column: 28, scope: !1933)
!1943 = !DILocation(line: 1250, column: 20, scope: !1933)
!1944 = !DILocation(line: 1250, column: 5, scope: !1945)
!1945 = !DILexicalBlockFile(scope: !1933, file: !3, discriminator: 1)
!1946 = !DILocation(line: 1251, column: 5, scope: !1933)
!1947 = !DILocation(line: 1252, column: 1, scope: !1933)
!1948 = distinct !DISubprogram(name: "read_flash_id", scope: !3, file: !3, line: 1255, type: !670, isLocal: false, isDefinition: true, scopeLine: 1256, isOptimized: true, unit: !2, variables: !1949)
!1949 = !{!1950, !1951}
!1950 = !DILocalVariable(name: "is_no_cmd", scope: !1948, file: !3, line: 1258, type: !108)
!1951 = !DILocalVariable(name: "i", scope: !1948, file: !3, line: 1259, type: !108)
!1952 = !DILocation(line: 1257, column: 5, scope: !1948)
!1953 = !DILocation(line: 1258, column: 21, scope: !1948)
!1954 = !DILocation(line: 1258, column: 9, scope: !1948)
!1955 = !DILocation(line: 1260, column: 5, scope: !1948)
!1956 = !DILocation(line: 1261, column: 5, scope: !1948)
!1957 = !DILocation(line: 1262, column: 25, scope: !1948)
!1958 = !DILocation(line: 1259, column: 9, scope: !1948)
!1959 = !DILocation(line: 1263, column: 10, scope: !1960)
!1960 = distinct !DILexicalBlock(scope: !1948, file: !3, line: 1263, column: 5)
!1961 = !DILocation(line: 1263, column: 19, scope: !1962)
!1962 = !DILexicalBlockFile(scope: !1963, file: !3, discriminator: 1)
!1963 = distinct !DILexicalBlock(scope: !1960, file: !3, line: 1263, column: 5)
!1964 = !DILocation(line: 1263, column: 5, scope: !1965)
!1965 = !DILexicalBlockFile(scope: !1960, file: !3, discriminator: 1)
!1966 = !DILocation(line: 1264, column: 32, scope: !1967)
!1967 = distinct !DILexicalBlock(scope: !1963, file: !3, line: 1263, column: 29)
!1968 = !DILocation(line: 1264, column: 29, scope: !1967)
!1969 = !DILocation(line: 1265, column: 29, scope: !1967)
!1970 = !DILocation(line: 1263, column: 25, scope: !1971)
!1971 = !DILexicalBlockFile(scope: !1963, file: !3, discriminator: 2)
!1972 = !DILocation(line: 1263, column: 5, scope: !1971)
!1973 = distinct !{!1973, !1974, !1975}
!1974 = !DILocation(line: 1263, column: 5, scope: !1960)
!1975 = !DILocation(line: 1266, column: 5, scope: !1960)
!1976 = !DILocation(line: 1267, column: 5, scope: !1948)
!1977 = !DILocation(line: 1272, column: 5, scope: !1948)
!1978 = !DILocation(line: 1273, column: 5, scope: !1948)
!1979 = !DILocation(line: 1274, column: 5, scope: !1948)
!1980 = !DILocation(line: 1275, column: 5, scope: !1948)
!1981 = !DILocation(line: 1276, column: 5, scope: !1948)
!1982 = !DILocation(line: 1277, column: 5, scope: !1948)
!1983 = !DILocation(line: 1278, column: 10, scope: !1984)
!1984 = distinct !DILexicalBlock(scope: !1948, file: !3, line: 1278, column: 5)
!1985 = !DILocation(line: 1278, column: 19, scope: !1986)
!1986 = !DILexicalBlockFile(scope: !1987, file: !3, discriminator: 1)
!1987 = distinct !DILexicalBlock(scope: !1984, file: !3, line: 1278, column: 5)
!1988 = !DILocation(line: 1278, column: 5, scope: !1989)
!1989 = !DILexicalBlockFile(scope: !1984, file: !3, discriminator: 1)
!1990 = !DILocation(line: 1279, column: 36, scope: !1991)
!1991 = distinct !DILexicalBlock(scope: !1987, file: !3, line: 1278, column: 31)
!1992 = !DILocation(line: 1279, column: 9, scope: !1991)
!1993 = !DILocation(line: 1279, column: 34, scope: !1991)
!1994 = !DILocation(line: 1278, column: 27, scope: !1995)
!1995 = !DILexicalBlockFile(scope: !1987, file: !3, discriminator: 2)
!1996 = !DILocation(line: 1278, column: 5, scope: !1995)
!1997 = distinct !{!1997, !1998, !1999}
!1998 = !DILocation(line: 1278, column: 5, scope: !1984)
!1999 = !DILocation(line: 1280, column: 5, scope: !1984)
!2000 = !DILocation(line: 1281, column: 5, scope: !1948)
!2001 = !DILocation(line: 1283, column: 9, scope: !2002)
!2002 = distinct !DILexicalBlock(scope: !1948, file: !3, line: 1283, column: 9)
!2003 = !DILocation(line: 1283, column: 9, scope: !1948)
!2004 = !DILocation(line: 1284, column: 9, scope: !2005)
!2005 = distinct !DILexicalBlock(scope: !2002, file: !3, line: 1283, column: 20)
!2006 = !DILocation(line: 1285, column: 5, scope: !2005)
!2007 = !DILocation(line: 1286, column: 25, scope: !1948)
!2008 = !DILocation(line: 1287, column: 5, scope: !1948)
!2009 = !DILocation(line: 1288, column: 1, scope: !1948)
!2010 = distinct !DISubprogram(name: "get_norflash_uuid", scope: !3, file: !3, line: 1290, type: !2011, isLocal: false, isDefinition: true, scopeLine: 1291, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!2011 = !DISubroutineType(types: !2012)
!2012 = !{!104}
!2013 = !DILocation(line: 1292, column: 5, scope: !2010)
!2014 = distinct !DISubprogram(name: "norflash_entry_sleep", scope: !3, file: !3, line: 1296, type: !2015, isLocal: true, isDefinition: true, scopeLine: 1297, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2017)
!2015 = !DISubroutineType(types: !2016)
!2016 = !{null, !1506}
!2017 = !{!2018, !2019}
!2018 = !DILocalVariable(name: "device", arg: 1, scope: !2014, file: !3, line: 1296, type: !1506)
!2019 = !DILocalVariable(name: "is_no_cmd", scope: !2014, file: !3, line: 1299, type: !108)
!2020 = !DILocation(line: 1296, column: 49, scope: !2014)
!2021 = !DILocation(line: 1298, column: 5, scope: !2014)
!2022 = !DILocation(line: 1299, column: 21, scope: !2014)
!2023 = !DILocation(line: 1299, column: 9, scope: !2014)
!2024 = !DILocation(line: 1301, column: 5, scope: !2014)
!2025 = !DILocation(line: 1302, column: 5, scope: !2014)
!2026 = !DILocation(line: 1303, column: 5, scope: !2014)
!2027 = !DILocation(line: 1305, column: 9, scope: !2028)
!2028 = distinct !DILexicalBlock(scope: !2014, file: !3, line: 1305, column: 9)
!2029 = !DILocation(line: 1305, column: 9, scope: !2014)
!2030 = !DILocation(line: 1306, column: 9, scope: !2031)
!2031 = distinct !DILexicalBlock(scope: !2028, file: !3, line: 1305, column: 20)
!2032 = !DILocation(line: 1307, column: 5, scope: !2031)
!2033 = !DILocation(line: 1308, column: 5, scope: !2014)
!2034 = !DILocation(line: 1309, column: 1, scope: !2014)
!2035 = distinct !DISubprogram(name: "norflash_exit_sleep", scope: !3, file: !3, line: 1311, type: !2015, isLocal: true, isDefinition: true, scopeLine: 1312, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2036)
!2036 = !{!2037, !2038}
!2037 = !DILocalVariable(name: "device", arg: 1, scope: !2035, file: !3, line: 1311, type: !1506)
!2038 = !DILocalVariable(name: "is_no_cmd", scope: !2035, file: !3, line: 1314, type: !108)
!2039 = !DILocation(line: 1311, column: 48, scope: !2035)
!2040 = !DILocation(line: 1313, column: 5, scope: !2035)
!2041 = !DILocation(line: 1314, column: 21, scope: !2035)
!2042 = !DILocation(line: 1314, column: 9, scope: !2035)
!2043 = !DILocation(line: 1315, column: 5, scope: !2035)
!2044 = !DILocation(line: 1316, column: 5, scope: !2035)
!2045 = !DILocation(line: 1317, column: 5, scope: !2035)
!2046 = !DILocation(line: 1318, column: 9, scope: !2047)
!2047 = distinct !DILexicalBlock(scope: !2035, file: !3, line: 1318, column: 9)
!2048 = !DILocation(line: 1318, column: 9, scope: !2035)
!2049 = !DILocation(line: 1319, column: 9, scope: !2050)
!2050 = distinct !DILexicalBlock(scope: !2047, file: !3, line: 1318, column: 20)
!2051 = !DILocation(line: 1320, column: 5, scope: !2050)
!2052 = !DILocation(line: 1321, column: 5, scope: !2035)
!2053 = !DILocation(line: 1322, column: 1, scope: !2035)
!2054 = distinct !DISubprogram(name: "set_vm_addr_info", scope: !3, file: !3, line: 1343, type: !1934, isLocal: false, isDefinition: true, scopeLine: 1344, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2055)
!2055 = !{!2056, !2057}
!2056 = !DILocalVariable(name: "addr", arg: 1, scope: !2054, file: !3, line: 1343, type: !108)
!2057 = !DILocalVariable(name: "size", arg: 2, scope: !2054, file: !3, line: 1343, type: !108)
!2058 = !DILocation(line: 1343, column: 27, scope: !2054)
!2059 = !DILocation(line: 1343, column: 37, scope: !2054)
!2060 = !DILocation(line: 1345, column: 28, scope: !2054)
!2061 = !DILocation(line: 1346, column: 27, scope: !2054)
!2062 = !{!843, !450, i64 44}
!2063 = !DILocation(line: 1347, column: 1, scope: !2054)
!2064 = distinct !DISubprogram(name: "norflash_read_sr", scope: !3, file: !3, line: 1350, type: !2065, isLocal: true, isDefinition: true, scopeLine: 1351, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2067)
!2065 = !DISubroutineType(types: !2066)
!2066 = !{!302}
!2067 = !{!2068, !2069}
!2068 = !DILocalVariable(name: "sr1", scope: !2064, file: !3, line: 1352, type: !105)
!2069 = !DILocalVariable(name: "sr2", scope: !2064, file: !3, line: 1352, type: !105)
!2070 = !DILocation(line: 1352, column: 8, scope: !2064)
!2071 = !DILocation(line: 1352, column: 17, scope: !2064)
!2072 = !DILocation(line: 1354, column: 5, scope: !2064)
!2073 = !DILocation(line: 1355, column: 5, scope: !2064)
!2074 = !DILocation(line: 1356, column: 11, scope: !2064)
!2075 = !DILocation(line: 1357, column: 5, scope: !2064)
!2076 = !DILocation(line: 1359, column: 5, scope: !2064)
!2077 = !DILocation(line: 1360, column: 5, scope: !2064)
!2078 = !DILocation(line: 1361, column: 11, scope: !2064)
!2079 = !DILocation(line: 1362, column: 5, scope: !2064)
!2080 = !DILocation(line: 1364, column: 12, scope: !2064)
!2081 = !DILocation(line: 1364, column: 16, scope: !2064)
!2082 = !DILocation(line: 1364, column: 23, scope: !2064)
!2083 = !DILocation(line: 1364, column: 21, scope: !2064)
!2084 = !DILocation(line: 1364, column: 5, scope: !2064)
!2085 = distinct !DISubprogram(name: "norflash_write_sr", scope: !3, file: !3, line: 1367, type: !2086, isLocal: true, isDefinition: true, scopeLine: 1368, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2088)
!2086 = !DISubroutineType(types: !2087)
!2087 = !{!438, !108}
!2088 = !{!2089, !2090, !2091, !2093, !2094, !2095, !2097}
!2089 = !DILocalVariable(name: "value", arg: 1, scope: !2085, file: !3, line: 1367, type: !108)
!2090 = !DILocalVariable(name: "err", scope: !2085, file: !3, line: 1369, type: !438)
!2091 = !DILocalVariable(name: "sr2_mode", scope: !2085, file: !3, line: 1370, type: !2092)
!2092 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !108)
!2093 = !DILocalVariable(name: "write_enable_is_50h", scope: !2085, file: !3, line: 1371, type: !2092)
!2094 = !DILocalVariable(name: "sr2_write_en", scope: !2085, file: !3, line: 1372, type: !2092)
!2095 = !DILocalVariable(name: "w_reg1", scope: !2085, file: !3, line: 1373, type: !2096)
!2096 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !105)
!2097 = !DILocalVariable(name: "w_reg2", scope: !2085, file: !3, line: 1374, type: !2096)
!2098 = !DILocation(line: 1367, column: 34, scope: !2085)
!2099 = !DILocation(line: 1370, column: 36, scope: !2085)
!2100 = !DILocation(line: 1370, column: 28, scope: !2085)
!2101 = !DILocation(line: 1371, column: 46, scope: !2085)
!2102 = !DILocation(line: 1371, column: 38, scope: !2085)
!2103 = !DILocation(line: 1372, column: 39, scope: !2085)
!2104 = !DILocation(line: 1372, column: 31, scope: !2085)
!2105 = !DILocation(line: 1373, column: 23, scope: !2085)
!2106 = !DILocation(line: 1373, column: 14, scope: !2085)
!2107 = !DILocation(line: 1374, column: 30, scope: !2085)
!2108 = !DILocation(line: 1374, column: 23, scope: !2085)
!2109 = !DILocation(line: 1374, column: 14, scope: !2085)
!2110 = !DILocation(line: 1377, column: 13, scope: !2111)
!2111 = distinct !DILexicalBlock(scope: !2112, file: !3, line: 1376, column: 34)
!2112 = distinct !DILexicalBlock(scope: !2113, file: !3, line: 1376, column: 13)
!2113 = distinct !DILexicalBlock(scope: !2114, file: !3, line: 1375, column: 19)
!2114 = distinct !DILexicalBlock(scope: !2085, file: !3, line: 1375, column: 9)
!2115 = !DILocation(line: 1375, column: 9, scope: !2085)
!2116 = !DILocation(line: 1376, column: 13, scope: !2113)
!2117 = !DILocation(line: 1378, column: 13, scope: !2111)
!2118 = !DILocation(line: 1379, column: 13, scope: !2111)
!2119 = !DILocation(line: 1380, column: 9, scope: !2111)
!2120 = !DILocation(line: 1382, column: 13, scope: !2121)
!2121 = distinct !DILexicalBlock(scope: !2112, file: !3, line: 1380, column: 16)
!2122 = !DILocation(line: 1383, column: 13, scope: !2121)
!2123 = !DILocation(line: 1385, column: 9, scope: !2113)
!2124 = !DILocation(line: 1386, column: 9, scope: !2113)
!2125 = !DILocation(line: 1387, column: 9, scope: !2113)
!2126 = !DILocation(line: 1388, column: 9, scope: !2113)
!2127 = !DILocation(line: 1389, column: 15, scope: !2113)
!2128 = !DILocation(line: 1369, column: 9, scope: !2085)
!2129 = !DILocation(line: 1390, column: 13, scope: !2130)
!2130 = distinct !DILexicalBlock(scope: !2113, file: !3, line: 1390, column: 13)
!2131 = !DILocation(line: 1390, column: 13, scope: !2113)
!2132 = !DILocation(line: 1393, column: 13, scope: !2113)
!2133 = !DILocation(line: 1395, column: 17, scope: !2134)
!2134 = distinct !DILexicalBlock(scope: !2135, file: !3, line: 1394, column: 38)
!2135 = distinct !DILexicalBlock(scope: !2136, file: !3, line: 1394, column: 17)
!2136 = distinct !DILexicalBlock(scope: !2137, file: !3, line: 1393, column: 27)
!2137 = distinct !DILexicalBlock(scope: !2113, file: !3, line: 1393, column: 13)
!2138 = !DILocation(line: 1394, column: 17, scope: !2136)
!2139 = !DILocation(line: 1396, column: 17, scope: !2134)
!2140 = !DILocation(line: 1397, column: 17, scope: !2134)
!2141 = !DILocation(line: 1398, column: 13, scope: !2134)
!2142 = !DILocation(line: 1400, column: 17, scope: !2143)
!2143 = distinct !DILexicalBlock(scope: !2135, file: !3, line: 1398, column: 20)
!2144 = !DILocation(line: 1401, column: 17, scope: !2143)
!2145 = !DILocation(line: 1403, column: 13, scope: !2136)
!2146 = !DILocation(line: 1404, column: 13, scope: !2136)
!2147 = !DILocation(line: 1405, column: 13, scope: !2136)
!2148 = !DILocation(line: 1406, column: 13, scope: !2136)
!2149 = !DILocation(line: 1407, column: 19, scope: !2136)
!2150 = !DILocation(line: 1408, column: 17, scope: !2151)
!2151 = distinct !DILexicalBlock(scope: !2136, file: !3, line: 1408, column: 17)
!2152 = !DILocation(line: 1408, column: 17, scope: !2136)
!2153 = !DILocation(line: 1413, column: 13, scope: !2154)
!2154 = distinct !DILexicalBlock(scope: !2114, file: !3, line: 1412, column: 12)
!2155 = !DILocation(line: 1415, column: 13, scope: !2156)
!2156 = distinct !DILexicalBlock(scope: !2157, file: !3, line: 1413, column: 34)
!2157 = distinct !DILexicalBlock(scope: !2154, file: !3, line: 1413, column: 13)
!2158 = !DILocation(line: 1416, column: 13, scope: !2156)
!2159 = !DILocation(line: 1417, column: 9, scope: !2156)
!2160 = !DILocation(line: 1419, column: 13, scope: !2161)
!2161 = distinct !DILexicalBlock(scope: !2157, file: !3, line: 1417, column: 16)
!2162 = !DILocation(line: 1420, column: 13, scope: !2161)
!2163 = !DILocation(line: 1422, column: 9, scope: !2154)
!2164 = !DILocation(line: 1423, column: 9, scope: !2154)
!2165 = !DILocation(line: 1424, column: 9, scope: !2154)
!2166 = !DILocation(line: 1425, column: 13, scope: !2154)
!2167 = !DILocation(line: 1426, column: 13, scope: !2168)
!2168 = distinct !DILexicalBlock(scope: !2169, file: !3, line: 1425, column: 27)
!2169 = distinct !DILexicalBlock(scope: !2154, file: !3, line: 1425, column: 13)
!2170 = !DILocation(line: 1427, column: 9, scope: !2168)
!2171 = !DILocation(line: 1428, column: 9, scope: !2154)
!2172 = !DILocation(line: 1429, column: 15, scope: !2154)
!2173 = !DILocation(line: 1430, column: 13, scope: !2174)
!2174 = distinct !DILexicalBlock(scope: !2154, file: !3, line: 1430, column: 13)
!2175 = !DILocation(line: 1430, column: 13, scope: !2154)
!2176 = !DILocation(line: 1434, column: 5, scope: !2085)
!2177 = !DILocation(line: 1435, column: 1, scope: !2085)
!2178 = distinct !DISubprogram(name: "flash_write_protect", scope: !3, file: !3, line: 1451, type: !2086, isLocal: true, isDefinition: true, scopeLine: 1452, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2179)
!2179 = !{!2180, !2181, !2182, !2183, !2184, !2185, !2186, !2187}
!2180 = !DILocalVariable(name: "value", arg: 1, scope: !2178, file: !3, line: 1451, type: !108)
!2181 = !DILocalVariable(name: "err", scope: !2178, file: !3, line: 1453, type: !438)
!2182 = !DILocalVariable(name: "sr2_mode", scope: !2178, file: !3, line: 1454, type: !2092)
!2183 = !DILocalVariable(name: "sr2_write_dis", scope: !2178, file: !3, line: 1455, type: !2092)
!2184 = !DILocalVariable(name: "w_reg", scope: !2178, file: !3, line: 1456, type: !108)
!2185 = !DILocalVariable(name: "r_reg", scope: !2178, file: !3, line: 1457, type: !302)
!2186 = !DILocalVariable(name: "w_cnt", scope: !2178, file: !3, line: 1458, type: !302)
!2187 = !DILocalVariable(name: "is_no_cmd", scope: !2178, file: !3, line: 1461, type: !108)
!2188 = !DILocation(line: 1451, column: 36, scope: !2178)
!2189 = !DILocation(line: 1454, column: 36, scope: !2178)
!2190 = !DILocation(line: 1454, column: 28, scope: !2178)
!2191 = !DILocation(line: 1455, column: 39, scope: !2178)
!2192 = !DILocation(line: 1455, column: 31, scope: !2178)
!2193 = !DILocation(line: 1456, column: 9, scope: !2178)
!2194 = !DILocation(line: 1457, column: 9, scope: !2178)
!2195 = !DILocation(line: 1458, column: 9, scope: !2178)
!2196 = !DILocation(line: 1459, column: 5, scope: !2178)
!2197 = !DILocation(line: 1460, column: 28, scope: !2178)
!2198 = !DILocation(line: 1461, column: 21, scope: !2178)
!2199 = !DILocation(line: 1461, column: 9, scope: !2178)
!2200 = !DILocation(line: 1462, column: 5, scope: !2178)
!2201 = !DILocation(line: 1453, column: 9, scope: !2178)
!2202 = !DILocation(line: 1463, column: 17, scope: !2203)
!2203 = distinct !DILexicalBlock(scope: !2178, file: !3, line: 1462, column: 15)
!2204 = !DILocation(line: 1464, column: 13, scope: !2203)
!2205 = !DILocation(line: 1465, column: 28, scope: !2206)
!2206 = distinct !DILexicalBlock(scope: !2207, file: !3, line: 1464, column: 28)
!2207 = distinct !DILexicalBlock(scope: !2203, file: !3, line: 1464, column: 13)
!2208 = !DILocation(line: 1465, column: 45, scope: !2206)
!2209 = !DILocation(line: 1465, column: 36, scope: !2206)
!2210 = !DILocation(line: 1465, column: 21, scope: !2206)
!2211 = !DILocation(line: 1466, column: 9, scope: !2206)
!2212 = !DILocation(line: 1467, column: 14, scope: !2213)
!2213 = distinct !DILexicalBlock(scope: !2203, file: !3, line: 1467, column: 13)
!2214 = !DILocation(line: 1467, column: 30, scope: !2213)
!2215 = !DILocation(line: 1467, column: 13, scope: !2203)
!2216 = !DILocation(line: 1471, column: 23, scope: !2217)
!2217 = distinct !DILexicalBlock(scope: !2218, file: !3, line: 1471, column: 17)
!2218 = distinct !DILexicalBlock(scope: !2213, file: !3, line: 1470, column: 16)
!2219 = !DILocation(line: 1471, column: 17, scope: !2218)
!2220 = !DILocation(line: 1472, column: 23, scope: !2221)
!2221 = distinct !DILexicalBlock(scope: !2217, file: !3, line: 1471, column: 28)
!2222 = !DILocation(line: 1473, column: 17, scope: !2221)
!2223 = !DILocation(line: 1475, column: 35, scope: !2224)
!2224 = !DILexicalBlockFile(scope: !2218, file: !3, discriminator: 1)
!2225 = !DILocation(line: 1475, column: 25, scope: !2218)
!2226 = !DILocation(line: 1475, column: 50, scope: !2227)
!2227 = !DILexicalBlockFile(scope: !2218, file: !3, discriminator: 2)
!2228 = !DILocation(line: 1475, column: 71, scope: !2229)
!2229 = !DILexicalBlockFile(scope: !2218, file: !3, discriminator: 3)
!2230 = !DILocation(line: 1476, column: 19, scope: !2218)
!2231 = !DILocation(line: 1478, column: 24, scope: !2203)
!2232 = !DILocation(line: 1478, column: 44, scope: !2203)
!2233 = !DILocation(line: 1478, column: 35, scope: !2203)
!2234 = !DILocation(line: 1479, column: 15, scope: !2203)
!2235 = !DILocation(line: 1462, column: 5, scope: !2236)
!2236 = !DILexicalBlockFile(scope: !2178, file: !3, discriminator: 1)
!2237 = distinct !{!2237, !2200, !2238}
!2238 = !DILocation(line: 1480, column: 5, scope: !2178)
!2239 = !DILocation(line: 1481, column: 9, scope: !2240)
!2240 = distinct !DILexicalBlock(scope: !2178, file: !3, line: 1481, column: 9)
!2241 = !DILocation(line: 1481, column: 9, scope: !2178)
!2242 = !DILocation(line: 1482, column: 9, scope: !2243)
!2243 = distinct !DILexicalBlock(scope: !2240, file: !3, line: 1481, column: 20)
!2244 = !DILocation(line: 1483, column: 5, scope: !2243)
!2245 = !DILocation(line: 1484, column: 5, scope: !2178)
!2246 = !DILocation(line: 1485, column: 5, scope: !2178)
!2247 = distinct !DISubprogram(name: "norflash_ioctl", scope: !3, file: !3, line: 1488, type: !1528, isLocal: false, isDefinition: true, scopeLine: 1489, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2248)
!2248 = !{!2249, !2250, !2251, !2252}
!2249 = !DILocalVariable(name: "device", arg: 1, scope: !2247, file: !3, line: 1488, type: !1506)
!2250 = !DILocalVariable(name: "cmd", arg: 2, scope: !2247, file: !3, line: 1488, type: !108)
!2251 = !DILocalVariable(name: "arg", arg: 3, scope: !2247, file: !3, line: 1488, type: !108)
!2252 = !DILocalVariable(name: "ret", scope: !2247, file: !3, line: 1491, type: !438)
!2253 = !DILocation(line: 1488, column: 35, scope: !2247)
!2254 = !DILocation(line: 1488, column: 47, scope: !2247)
!2255 = !DILocation(line: 1488, column: 56, scope: !2247)
!2256 = !DILocation(line: 1490, column: 5, scope: !2257)
!2257 = distinct !DILexicalBlock(scope: !2247, file: !3, line: 1490, column: 5)
!2258 = !DILocation(line: 1491, column: 9, scope: !2247)
!2259 = !DILocation(line: 1493, column: 5, scope: !2247)
!2260 = !DILocation(line: 1495, column: 11, scope: !2261)
!2261 = distinct !DILexicalBlock(scope: !2247, file: !3, line: 1493, column: 18)
!2262 = !DILocation(line: 1495, column: 23, scope: !2261)
!2263 = !DILocation(line: 1496, column: 9, scope: !2261)
!2264 = !DILocation(line: 1498, column: 11, scope: !2261)
!2265 = !DILocation(line: 1498, column: 23, scope: !2261)
!2266 = !DILocation(line: 1499, column: 9, scope: !2261)
!2267 = !DILocation(line: 1501, column: 24, scope: !2268)
!2268 = distinct !DILexicalBlock(scope: !2261, file: !3, line: 1501, column: 13)
!2269 = !DILocation(line: 1501, column: 39, scope: !2268)
!2270 = !DILocation(line: 1501, column: 13, scope: !2261)
!2271 = !DILocation(line: 1502, column: 13, scope: !2272)
!2272 = distinct !DILexicalBlock(scope: !2268, file: !3, line: 1501, column: 45)
!2273 = !DILocation(line: 1503, column: 75, scope: !2272)
!2274 = !DILocation(line: 1503, column: 41, scope: !2272)
!2275 = !DILocation(line: 1503, column: 39, scope: !2272)
!2276 = !DILocation(line: 1504, column: 9, scope: !2272)
!2277 = !DILocation(line: 1505, column: 36, scope: !2261)
!2278 = !DILocation(line: 1505, column: 11, scope: !2261)
!2279 = !DILocation(line: 1505, column: 23, scope: !2261)
!2280 = !DILocation(line: 1506, column: 9, scope: !2261)
!2281 = !DILocation(line: 1508, column: 24, scope: !2282)
!2282 = distinct !DILexicalBlock(scope: !2261, file: !3, line: 1508, column: 13)
!2283 = !DILocation(line: 1508, column: 33, scope: !2282)
!2284 = !DILocation(line: 1508, column: 13, scope: !2261)
!2285 = !DILocation(line: 1509, column: 13, scope: !2286)
!2286 = distinct !DILexicalBlock(scope: !2282, file: !3, line: 1508, column: 39)
!2287 = !DILocation(line: 1510, column: 75, scope: !2286)
!2288 = !DILocation(line: 1510, column: 41, scope: !2286)
!2289 = !DILocation(line: 1510, column: 39, scope: !2286)
!2290 = !DILocation(line: 1511, column: 9, scope: !2286)
!2291 = !DILocation(line: 1512, column: 36, scope: !2261)
!2292 = !DILocation(line: 1512, column: 11, scope: !2261)
!2293 = !DILocation(line: 1512, column: 23, scope: !2261)
!2294 = !DILocation(line: 1513, column: 9, scope: !2261)
!2295 = !DILocation(line: 1515, column: 24, scope: !2296)
!2296 = distinct !DILexicalBlock(scope: !2261, file: !3, line: 1515, column: 13)
!2297 = !DILocation(line: 1515, column: 33, scope: !2296)
!2298 = !DILocation(line: 1515, column: 13, scope: !2261)
!2299 = !DILocation(line: 1516, column: 13, scope: !2300)
!2300 = distinct !DILexicalBlock(scope: !2296, file: !3, line: 1515, column: 39)
!2301 = !DILocation(line: 1517, column: 75, scope: !2300)
!2302 = !DILocation(line: 1517, column: 41, scope: !2300)
!2303 = !DILocation(line: 1517, column: 39, scope: !2300)
!2304 = !DILocation(line: 1518, column: 9, scope: !2300)
!2305 = !DILocation(line: 1519, column: 16, scope: !2261)
!2306 = !DILocation(line: 1519, column: 9, scope: !2261)
!2307 = !DILocation(line: 1520, column: 9, scope: !2261)
!2308 = !DILocation(line: 1524, column: 15, scope: !2261)
!2309 = !DILocation(line: 1525, column: 9, scope: !2261)
!2310 = !DILocation(line: 1527, column: 14, scope: !2311)
!2311 = distinct !DILexicalBlock(scope: !2261, file: !3, line: 1527, column: 13)
!2312 = !DILocation(line: 1527, column: 13, scope: !2261)
!2313 = !DILocation(line: 1530, column: 15, scope: !2261)
!2314 = !DILocation(line: 1531, column: 9, scope: !2261)
!2315 = !DILocation(line: 1533, column: 13, scope: !2316)
!2316 = distinct !DILexicalBlock(scope: !2261, file: !3, line: 1533, column: 13)
!2317 = !DILocation(line: 1533, column: 13, scope: !2261)
!2318 = !DILocation(line: 1534, column: 40, scope: !2319)
!2319 = distinct !DILexicalBlock(scope: !2316, file: !3, line: 1533, column: 18)
!2320 = !DILocation(line: 1534, column: 15, scope: !2319)
!2321 = !DILocation(line: 1534, column: 27, scope: !2319)
!2322 = !DILocation(line: 1535, column: 9, scope: !2319)
!2323 = !DILocation(line: 1540, column: 30, scope: !2261)
!2324 = !DILocalVariable(name: "_arg", arg: 1, scope: !2325, file: !3, line: 1324, type: !266)
!2325 = distinct !DISubprogram(name: "sfcflash_vm_info_set", scope: !3, file: !3, line: 1324, type: !429, isLocal: true, isDefinition: true, scopeLine: 1325, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2326)
!2326 = !{!2324, !2327}
!2327 = !DILocalVariable(name: "info", scope: !2325, file: !3, line: 1328, type: !283)
!2328 = !DILocation(line: 1324, column: 40, scope: !2325, inlinedAt: !2329)
!2329 = distinct !DILocation(line: 1540, column: 9, scope: !2261)
!2330 = !DILocation(line: 1326, column: 5, scope: !2331, inlinedAt: !2329)
!2331 = !DILexicalBlockFile(scope: !2332, file: !3, discriminator: 1)
!2332 = distinct !DILexicalBlock(scope: !2333, file: !3, line: 1326, column: 5)
!2333 = distinct !DILexicalBlock(scope: !2325, file: !3, line: 1326, column: 5)
!2334 = !DILocation(line: 1326, column: 5, scope: !2335, inlinedAt: !2329)
!2335 = !DILexicalBlockFile(scope: !2333, file: !3, discriminator: 1)
!2336 = !DILocation(line: 1326, column: 5, scope: !2337, inlinedAt: !2329)
!2337 = !DILexicalBlockFile(scope: !2338, file: !3, discriminator: 1)
!2338 = distinct !DILexicalBlock(scope: !2332, file: !3, line: 1326, column: 5)
!2339 = !DILocation(line: 1326, column: 5, scope: !2340, inlinedAt: !2329)
!2340 = !DILexicalBlockFile(scope: !2341, file: !3, discriminator: 2)
!2341 = distinct !DILexicalBlock(scope: !2342, file: !3, line: 1326, column: 5)
!2342 = distinct !DILexicalBlock(scope: !2338, file: !3, line: 1326, column: 5)
!2343 = !DILocation(line: 1326, column: 5, scope: !2344, inlinedAt: !2329)
!2344 = !DILexicalBlockFile(scope: !2341, file: !3, discriminator: 4)
!2345 = !DILocation(line: 1326, column: 5, scope: !2346, inlinedAt: !2329)
!2346 = !DILexicalBlockFile(scope: !2341, file: !3, discriminator: 5)
!2347 = !DILocation(line: 1326, column: 5, scope: !2348, inlinedAt: !2329)
!2348 = !DILexicalBlockFile(scope: !2341, file: !3, discriminator: 6)
!2349 = !DILocation(line: 1326, column: 5, scope: !2350, inlinedAt: !2329)
!2350 = !DILexicalBlockFile(scope: !2351, file: !3, discriminator: 3)
!2351 = distinct !DILexicalBlock(scope: !2332, file: !3, line: 1326, column: 5)
!2352 = !DILocation(line: 216, column: 5, scope: !2353, inlinedAt: !2354)
!2353 = distinct !DISubprogram(name: "cpu_reset", scope: !106, file: !106, line: 210, type: !670, isLocal: true, isDefinition: true, scopeLine: 211, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!2354 = distinct !DILocation(line: 1326, column: 5, scope: !2355, inlinedAt: !2329)
!2355 = !DILexicalBlockFile(scope: !2356, file: !3, discriminator: 6)
!2356 = distinct !DILexicalBlock(scope: !2357, file: !3, line: 1326, column: 5)
!2357 = distinct !DILexicalBlock(scope: !2351, file: !3, line: 1326, column: 5)
!2358 = !DILocation(line: 217, column: 5, scope: !2353, inlinedAt: !2354)
!2359 = !DILocation(line: 217, column: 5, scope: !2360, inlinedAt: !2354)
!2360 = !DILexicalBlockFile(scope: !2353, file: !106, discriminator: 1)
!2361 = distinct !{!2361, !2362, !2363}
!2362 = !DILocation(line: 217, column: 5, scope: !2353)
!2363 = !DILocation(line: 217, column: 14, scope: !2353)
!2364 = !DILocation(line: 1330, column: 5, scope: !2325, inlinedAt: !2329)
!2365 = !DILocation(line: 1331, column: 39, scope: !2325, inlinedAt: !2329)
!2366 = !DILocation(line: 1331, column: 5, scope: !2325, inlinedAt: !2329)
!2367 = !DILocation(line: 1333, column: 35, scope: !2325, inlinedAt: !2329)
!2368 = !{!2369, !450, i64 24}
!2369 = !{!"_boot_info", !844, i64 0, !845, i64 16, !450, i64 24, !2370, i64 28, !2370, i64 30, !2371, i64 32}
!2370 = !{!"short", !451, i64 0}
!2371 = !{!"bt_mac_addr", !451, i64 0, !2370, i64 6}
!2372 = !DILocation(line: 1333, column: 27, scope: !2325, inlinedAt: !2329)
!2373 = !{!843, !450, i64 20}
!2374 = !DILocation(line: 1335, column: 20, scope: !2325, inlinedAt: !2329)
!2375 = !{!2376, !451, i64 0}
!2376 = !{!"", !451, i64 0, !451, i64 1, !451, i64 2, !451, i64 3, !2370, i64 4, !2370, i64 6, !450, i64 8, !450, i64 12, !450, i64 16, !450, i64 20}
!2377 = !DILocation(line: 1336, column: 63, scope: !2325, inlinedAt: !2329)
!2378 = !DILocation(line: 1336, column: 29, scope: !2325, inlinedAt: !2329)
!2379 = !DILocation(line: 1336, column: 27, scope: !2325, inlinedAt: !2329)
!2380 = !{!2376, !450, i64 12}
!2381 = !DILocation(line: 1337, column: 27, scope: !2325, inlinedAt: !2329)
!2382 = !{!2376, !450, i64 8}
!2383 = !DILocation(line: 1338, column: 20, scope: !2325, inlinedAt: !2329)
!2384 = !DILocation(line: 1340, column: 5, scope: !2325, inlinedAt: !2329)
!2385 = !DILocation(line: 1541, column: 9, scope: !2261)
!2386 = !DILocation(line: 1543, column: 16, scope: !2261)
!2387 = !DILocation(line: 1543, column: 9, scope: !2261)
!2388 = !DILocation(line: 1544, column: 9, scope: !2261)
!2389 = !DILocalVariable(name: "attr", arg: 1, scope: !2390, file: !3, line: 908, type: !108)
!2390 = distinct !DISubprogram(name: "norflash_set_spi_con_attr", scope: !3, file: !3, line: 908, type: !835, isLocal: true, isDefinition: true, scopeLine: 909, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2391)
!2391 = !{!2389}
!2392 = !DILocation(line: 908, column: 43, scope: !2390, inlinedAt: !2393)
!2393 = distinct !DILocation(line: 1546, column: 9, scope: !2261)
!2394 = !DILocation(line: 912, column: 28, scope: !2390, inlinedAt: !2393)
!2395 = !DILocation(line: 913, column: 14, scope: !2396, inlinedAt: !2393)
!2396 = distinct !DILexicalBlock(scope: !2390, file: !3, line: 913, column: 9)
!2397 = !DILocation(line: 913, column: 9, scope: !2390, inlinedAt: !2393)
!2398 = !DILocation(line: 914, column: 32, scope: !2399, inlinedAt: !2393)
!2399 = distinct !DILexicalBlock(scope: !2396, file: !3, line: 913, column: 37)
!2400 = !DILocation(line: 915, column: 9, scope: !2401, inlinedAt: !2393)
!2401 = distinct !DILexicalBlock(scope: !2399, file: !3, line: 915, column: 9)
!2402 = !DILocation(line: 915, column: 9, scope: !2399, inlinedAt: !2393)
!2403 = !DILocation(line: 915, column: 9, scope: !2404, inlinedAt: !2393)
!2404 = !DILexicalBlockFile(scope: !2401, file: !3, discriminator: 1)
!2405 = !DILocation(line: 916, column: 21, scope: !2406, inlinedAt: !2393)
!2406 = !DILexicalBlockFile(scope: !2407, file: !3, discriminator: 1)
!2407 = distinct !DILexicalBlock(scope: !2396, file: !3, line: 916, column: 16)
!2408 = !DILocation(line: 916, column: 16, scope: !2409, inlinedAt: !2393)
!2409 = !DILexicalBlockFile(scope: !2396, file: !3, discriminator: 1)
!2410 = !DILocation(line: 917, column: 32, scope: !2411, inlinedAt: !2393)
!2411 = distinct !DILexicalBlock(scope: !2407, file: !3, line: 916, column: 44)
!2412 = !DILocation(line: 918, column: 9, scope: !2413, inlinedAt: !2393)
!2413 = distinct !DILexicalBlock(scope: !2411, file: !3, line: 918, column: 9)
!2414 = !DILocation(line: 918, column: 9, scope: !2411, inlinedAt: !2393)
!2415 = !DILocation(line: 918, column: 9, scope: !2416, inlinedAt: !2393)
!2416 = !DILexicalBlockFile(scope: !2413, file: !3, discriminator: 1)
!2417 = !DILocation(line: 919, column: 21, scope: !2418, inlinedAt: !2393)
!2418 = !DILexicalBlockFile(scope: !2419, file: !3, discriminator: 1)
!2419 = distinct !DILexicalBlock(scope: !2407, file: !3, line: 919, column: 16)
!2420 = !DILocation(line: 919, column: 16, scope: !2406, inlinedAt: !2393)
!2421 = !DILocation(line: 920, column: 32, scope: !2422, inlinedAt: !2393)
!2422 = distinct !DILexicalBlock(scope: !2419, file: !3, line: 919, column: 44)
!2423 = !DILocation(line: 921, column: 9, scope: !2424, inlinedAt: !2393)
!2424 = distinct !DILexicalBlock(scope: !2422, file: !3, line: 921, column: 9)
!2425 = !DILocation(line: 921, column: 9, scope: !2422, inlinedAt: !2393)
!2426 = !DILocation(line: 921, column: 9, scope: !2427, inlinedAt: !2393)
!2427 = !DILexicalBlockFile(scope: !2424, file: !3, discriminator: 1)
!2428 = !DILocation(line: 922, column: 21, scope: !2429, inlinedAt: !2393)
!2429 = !DILexicalBlockFile(scope: !2430, file: !3, discriminator: 1)
!2430 = distinct !DILexicalBlock(scope: !2419, file: !3, line: 922, column: 16)
!2431 = !DILocation(line: 922, column: 16, scope: !2418, inlinedAt: !2393)
!2432 = !DILocation(line: 923, column: 32, scope: !2433, inlinedAt: !2393)
!2433 = distinct !DILexicalBlock(scope: !2430, file: !3, line: 922, column: 44)
!2434 = !DILocation(line: 924, column: 9, scope: !2435, inlinedAt: !2393)
!2435 = distinct !DILexicalBlock(scope: !2433, file: !3, line: 924, column: 9)
!2436 = !DILocation(line: 924, column: 9, scope: !2433, inlinedAt: !2393)
!2437 = !DILocation(line: 924, column: 9, scope: !2438, inlinedAt: !2393)
!2438 = !DILexicalBlockFile(scope: !2435, file: !3, discriminator: 1)
!2439 = !DILocation(line: 925, column: 21, scope: !2440, inlinedAt: !2393)
!2440 = !DILexicalBlockFile(scope: !2441, file: !3, discriminator: 1)
!2441 = distinct !DILexicalBlock(scope: !2430, file: !3, line: 925, column: 16)
!2442 = !DILocation(line: 925, column: 16, scope: !2429, inlinedAt: !2393)
!2443 = !DILocation(line: 926, column: 32, scope: !2444, inlinedAt: !2393)
!2444 = distinct !DILexicalBlock(scope: !2441, file: !3, line: 925, column: 44)
!2445 = !DILocation(line: 927, column: 9, scope: !2446, inlinedAt: !2393)
!2446 = distinct !DILexicalBlock(scope: !2444, file: !3, line: 927, column: 9)
!2447 = !DILocation(line: 927, column: 9, scope: !2444, inlinedAt: !2393)
!2448 = !DILocation(line: 927, column: 9, scope: !2449, inlinedAt: !2393)
!2449 = !DILexicalBlockFile(scope: !2446, file: !3, discriminator: 1)
!2450 = !DILocation(line: 928, column: 21, scope: !2451, inlinedAt: !2393)
!2451 = !DILexicalBlockFile(scope: !2452, file: !3, discriminator: 1)
!2452 = distinct !DILexicalBlock(scope: !2441, file: !3, line: 928, column: 16)
!2453 = !DILocation(line: 928, column: 16, scope: !2440, inlinedAt: !2393)
!2454 = !DILocation(line: 929, column: 32, scope: !2455, inlinedAt: !2393)
!2455 = distinct !DILexicalBlock(scope: !2452, file: !3, line: 928, column: 44)
!2456 = !DILocation(line: 930, column: 9, scope: !2457, inlinedAt: !2393)
!2457 = distinct !DILexicalBlock(scope: !2455, file: !3, line: 930, column: 9)
!2458 = !DILocation(line: 930, column: 9, scope: !2455, inlinedAt: !2393)
!2459 = !DILocation(line: 930, column: 9, scope: !2460, inlinedAt: !2393)
!2460 = !DILexicalBlockFile(scope: !2457, file: !3, discriminator: 1)
!2461 = !DILocation(line: 931, column: 21, scope: !2462, inlinedAt: !2393)
!2462 = !DILexicalBlockFile(scope: !2463, file: !3, discriminator: 1)
!2463 = distinct !DILexicalBlock(scope: !2452, file: !3, line: 931, column: 16)
!2464 = !DILocation(line: 931, column: 16, scope: !2451, inlinedAt: !2393)
!2465 = !DILocation(line: 932, column: 32, scope: !2466, inlinedAt: !2393)
!2466 = distinct !DILexicalBlock(scope: !2463, file: !3, line: 931, column: 44)
!2467 = !DILocation(line: 933, column: 9, scope: !2468, inlinedAt: !2393)
!2468 = distinct !DILexicalBlock(scope: !2466, file: !3, line: 933, column: 9)
!2469 = !DILocation(line: 933, column: 9, scope: !2466, inlinedAt: !2393)
!2470 = !DILocation(line: 933, column: 9, scope: !2471, inlinedAt: !2393)
!2471 = !DILexicalBlockFile(scope: !2468, file: !3, discriminator: 1)
!2472 = !DILocation(line: 934, column: 21, scope: !2473, inlinedAt: !2393)
!2473 = !DILexicalBlockFile(scope: !2474, file: !3, discriminator: 1)
!2474 = distinct !DILexicalBlock(scope: !2463, file: !3, line: 934, column: 16)
!2475 = !DILocation(line: 934, column: 16, scope: !2462, inlinedAt: !2393)
!2476 = !DILocation(line: 936, column: 9, scope: !2477, inlinedAt: !2393)
!2477 = distinct !DILexicalBlock(scope: !2474, file: !3, line: 934, column: 44)
!2478 = !DILocation(line: 936, column: 9, scope: !2479, inlinedAt: !2393)
!2479 = !DILexicalBlockFile(scope: !2480, file: !3, discriminator: 1)
!2480 = distinct !DILexicalBlock(scope: !2477, file: !3, line: 936, column: 9)
!2481 = !DILocation(line: 939, column: 9, scope: !2482, inlinedAt: !2393)
!2482 = distinct !DILexicalBlock(scope: !2474, file: !3, line: 937, column: 12)
!2483 = !DILocation(line: 939, column: 9, scope: !2484, inlinedAt: !2393)
!2484 = !DILexicalBlockFile(scope: !2485, file: !3, discriminator: 1)
!2485 = distinct !DILexicalBlock(scope: !2482, file: !3, line: 939, column: 9)
!2486 = !DILocation(line: 950, column: 5, scope: !2487, inlinedAt: !2393)
!2487 = distinct !DILexicalBlock(scope: !2390, file: !3, line: 950, column: 5)
!2488 = !DILocation(line: 942, column: 14, scope: !2489, inlinedAt: !2393)
!2489 = distinct !DILexicalBlock(scope: !2390, file: !3, line: 942, column: 9)
!2490 = !DILocation(line: 942, column: 9, scope: !2390, inlinedAt: !2393)
!2491 = !DILocation(line: 943, column: 24, scope: !2492, inlinedAt: !2393)
!2492 = distinct !DILexicalBlock(scope: !2493, file: !3, line: 943, column: 13)
!2493 = distinct !DILexicalBlock(scope: !2489, file: !3, line: 942, column: 40)
!2494 = !DILocation(line: 943, column: 36, scope: !2492, inlinedAt: !2393)
!2495 = !DILocation(line: 946, column: 36, scope: !2496, inlinedAt: !2393)
!2496 = distinct !DILexicalBlock(scope: !2492, file: !3, line: 945, column: 16)
!2497 = !DILocation(line: 944, column: 36, scope: !2498, inlinedAt: !2393)
!2498 = distinct !DILexicalBlock(scope: !2492, file: !3, line: 943, column: 46)
!2499 = !DILocation(line: 943, column: 13, scope: !2493, inlinedAt: !2393)
!2500 = !DILocation(line: 948, column: 5, scope: !2493, inlinedAt: !2393)
!2501 = !DILocation(line: 950, column: 5, scope: !2502, inlinedAt: !2393)
!2502 = !DILexicalBlockFile(scope: !2487, file: !3, discriminator: 1)
!2503 = !DILocation(line: 950, column: 5, scope: !2504, inlinedAt: !2393)
!2504 = !DILexicalBlockFile(scope: !2390, file: !3, discriminator: 1)
!2505 = !DILocation(line: 950, column: 5, scope: !2506, inlinedAt: !2393)
!2506 = !DILexicalBlockFile(scope: !2487, file: !3, discriminator: 2)
!2507 = !DILocation(line: 1550, column: 9, scope: !2261)
!2508 = !DILocation(line: 1553, column: 5, scope: !2509)
!2509 = distinct !DILexicalBlock(scope: !2247, file: !3, line: 1553, column: 5)
!2510 = !DILocation(line: 1554, column: 5, scope: !2247)
!2511 = distinct !DISubprogram(name: "norflash_protect_resume", scope: !3, file: !3, line: 1557, type: !585, isLocal: false, isDefinition: true, scopeLine: 1558, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2512)
!2512 = !{!2513}
!2513 = !DILocalVariable(name: "ret", scope: !2511, file: !3, line: 1559, type: !438)
!2514 = !DILocation(line: 1559, column: 9, scope: !2511)
!2515 = !DILocation(line: 1560, column: 20, scope: !2516)
!2516 = distinct !DILexicalBlock(scope: !2511, file: !3, line: 1560, column: 9)
!2517 = !{!843, !450, i64 72}
!2518 = !DILocation(line: 1560, column: 51, scope: !2516)
!2519 = !DILocation(line: 1560, column: 37, scope: !2516)
!2520 = !DILocation(line: 1560, column: 9, scope: !2511)
!2521 = !DILocation(line: 1561, column: 15, scope: !2522)
!2522 = distinct !DILexicalBlock(scope: !2516, file: !3, line: 1560, column: 64)
!2523 = !DILocation(line: 1562, column: 37, scope: !2522)
!2524 = !DILocation(line: 1563, column: 9, scope: !2522)
!2525 = !DILocation(line: 1566, column: 1, scope: !2511)
!2526 = distinct !DISubprogram(name: "norflash_protect_suspend", scope: !3, file: !3, line: 1567, type: !585, isLocal: false, isDefinition: true, scopeLine: 1568, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!2527 = !DILocation(line: 1569, column: 20, scope: !2528)
!2528 = distinct !DILexicalBlock(scope: !2526, file: !3, line: 1569, column: 9)
!2529 = !DILocation(line: 1569, column: 51, scope: !2528)
!2530 = !DILocation(line: 1569, column: 37, scope: !2528)
!2531 = !DILocation(line: 1569, column: 9, scope: !2526)
!2532 = !DILocation(line: 1570, column: 37, scope: !2533)
!2533 = distinct !DILexicalBlock(scope: !2528, file: !3, line: 1569, column: 64)
!2534 = !DILocation(line: 1571, column: 16, scope: !2533)
!2535 = !DILocation(line: 1571, column: 9, scope: !2533)
!2536 = !DILocation(line: 1574, column: 1, scope: !2526)
!2537 = distinct !DISubprogram(name: "norflash_write_protect", scope: !3, file: !3, line: 1575, type: !2086, isLocal: false, isDefinition: true, scopeLine: 1576, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2538)
!2538 = !{!2539}
!2539 = !DILocalVariable(name: "cmd", arg: 1, scope: !2537, file: !3, line: 1575, type: !108)
!2540 = !DILocation(line: 1575, column: 32, scope: !2537)
!2541 = !DILocation(line: 1577, column: 12, scope: !2537)
!2542 = !DILocation(line: 1577, column: 5, scope: !2537)
!2543 = distinct !DISubprogram(name: "norflash_eraser_otp", scope: !3, file: !3, line: 1581, type: !585, isLocal: false, isDefinition: true, scopeLine: 1582, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!2544 = !DILocation(line: 1583, column: 5, scope: !2543)
!2545 = !DILocation(line: 1584, column: 5, scope: !2543)
!2546 = !DILocation(line: 1585, column: 5, scope: !2543)
!2547 = !DILocation(line: 1586, column: 5, scope: !2543)
!2548 = !DILocation(line: 1587, column: 5, scope: !2543)
!2549 = !DILocation(line: 1588, column: 5, scope: !2543)
!2550 = !DILocation(line: 1589, column: 5, scope: !2543)
!2551 = !DILocation(line: 1590, column: 5, scope: !2543)
!2552 = !DILocation(line: 1591, column: 5, scope: !2543)
!2553 = !DILocation(line: 1592, column: 5, scope: !2554)
!2554 = !DILexicalBlockFile(scope: !2555, file: !3, discriminator: 1)
!2555 = distinct !DILexicalBlock(scope: !2543, file: !3, line: 1592, column: 5)
!2556 = !{i32 -2146437672}
!2557 = !DILocation(line: 1593, column: 5, scope: !2543)
!2558 = !DILocation(line: 1595, column: 5, scope: !2543)
!2559 = !DILocation(line: 1596, column: 5, scope: !2543)
!2560 = !DILocation(line: 1597, column: 5, scope: !2543)
!2561 = !DILocation(line: 1598, column: 5, scope: !2543)
!2562 = !DILocation(line: 1599, column: 5, scope: !2543)
!2563 = !DILocation(line: 1600, column: 5, scope: !2543)
!2564 = !DILocation(line: 1601, column: 5, scope: !2543)
!2565 = !DILocation(line: 1602, column: 5, scope: !2566)
!2566 = !DILexicalBlockFile(scope: !2567, file: !3, discriminator: 1)
!2567 = distinct !DILexicalBlock(scope: !2543, file: !3, line: 1602, column: 5)
!2568 = !{i32 -2146437616}
!2569 = !DILocation(line: 1603, column: 5, scope: !2543)
!2570 = !DILocation(line: 1605, column: 5, scope: !2543)
!2571 = !DILocation(line: 1606, column: 5, scope: !2543)
!2572 = !DILocation(line: 1607, column: 5, scope: !2543)
!2573 = !DILocation(line: 1608, column: 5, scope: !2543)
!2574 = !DILocation(line: 1609, column: 5, scope: !2543)
!2575 = !DILocation(line: 1610, column: 5, scope: !2543)
!2576 = !DILocation(line: 1611, column: 5, scope: !2543)
!2577 = !DILocation(line: 1612, column: 5, scope: !2578)
!2578 = !DILexicalBlockFile(scope: !2579, file: !3, discriminator: 1)
!2579 = distinct !DILexicalBlock(scope: !2543, file: !3, line: 1612, column: 5)
!2580 = !{i32 -2146437560}
!2581 = !DILocation(line: 1613, column: 5, scope: !2543)
!2582 = !DILocation(line: 1614, column: 5, scope: !2543)
!2583 = distinct !DISubprogram(name: "norflash_write_otp", scope: !3, file: !3, line: 1618, type: !2584, isLocal: false, isDefinition: true, scopeLine: 1619, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2587)
!2584 = !DISubroutineType(types: !2585)
!2585 = !{!438, !104, !2586, !2586}
!2586 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !438)
!2587 = !{!2588, !2589, !2590, !2591, !2592, !2593, !2594, !2595, !2596}
!2588 = !DILocalVariable(name: "buf", arg: 1, scope: !2583, file: !3, line: 1618, type: !104)
!2589 = !DILocalVariable(name: "len", arg: 2, scope: !2583, file: !3, line: 1618, type: !2586)
!2590 = !DILocalVariable(name: "zone_len", arg: 3, scope: !2583, file: !3, line: 1618, type: !2586)
!2591 = !DILocalVariable(name: "i", scope: !2583, file: !3, line: 1620, type: !438)
!2592 = !DILocalVariable(name: "ret", scope: !2583, file: !3, line: 1620, type: !438)
!2593 = !DILocalVariable(name: "offset", scope: !2583, file: !3, line: 1621, type: !438)
!2594 = !DILocalVariable(name: "data_h", scope: !2583, file: !3, line: 1622, type: !105)
!2595 = !DILocalVariable(name: "data_l", scope: !2583, file: !3, line: 1623, type: !105)
!2596 = !DILocalVariable(name: "otp_index", scope: !2583, file: !3, line: 1624, type: !105)
!2597 = !DILocation(line: 1618, column: 28, scope: !2583)
!2598 = !DILocation(line: 1618, column: 43, scope: !2583)
!2599 = !DILocation(line: 1618, column: 58, scope: !2583)
!2600 = !DILocation(line: 1620, column: 12, scope: !2583)
!2601 = !DILocation(line: 1621, column: 9, scope: !2583)
!2602 = !DILocation(line: 1625, column: 5, scope: !2583)
!2603 = !DILocation(line: 1626, column: 5, scope: !2583)
!2604 = !DILocation(line: 1626, column: 19, scope: !2605)
!2605 = !DILexicalBlockFile(scope: !2583, file: !3, discriminator: 1)
!2606 = !DILocation(line: 1626, column: 5, scope: !2605)
!2607 = !DILocation(line: 1627, column: 9, scope: !2608)
!2608 = distinct !DILexicalBlock(scope: !2583, file: !3, line: 1626, column: 26)
!2609 = !DILocation(line: 1628, column: 9, scope: !2608)
!2610 = !DILocation(line: 1629, column: 9, scope: !2608)
!2611 = !DILocation(line: 1630, column: 9, scope: !2608)
!2612 = !DILocation(line: 1631, column: 25, scope: !2608)
!2613 = !DILocation(line: 1632, column: 18, scope: !2608)
!2614 = !DILocation(line: 1623, column: 8, scope: !2583)
!2615 = !DILocation(line: 1633, column: 38, scope: !2608)
!2616 = !DILocation(line: 1633, column: 50, scope: !2608)
!2617 = !DILocation(line: 1633, column: 27, scope: !2608)
!2618 = !DILocation(line: 1633, column: 57, scope: !2608)
!2619 = !DILocation(line: 1633, column: 21, scope: !2608)
!2620 = !DILocation(line: 1624, column: 8, scope: !2583)
!2621 = !DILocation(line: 1634, column: 9, scope: !2608)
!2622 = !DILocation(line: 1635, column: 9, scope: !2608)
!2623 = !DILocation(line: 1620, column: 9, scope: !2583)
!2624 = !DILocation(line: 1636, column: 14, scope: !2625)
!2625 = distinct !DILexicalBlock(scope: !2608, file: !3, line: 1636, column: 9)
!2626 = !DILocation(line: 1636, column: 23, scope: !2627)
!2627 = !DILexicalBlockFile(scope: !2628, file: !3, discriminator: 1)
!2628 = distinct !DILexicalBlock(scope: !2625, file: !3, line: 1636, column: 9)
!2629 = !DILocation(line: 1636, column: 9, scope: !2630)
!2630 = !DILexicalBlockFile(scope: !2625, file: !3, discriminator: 1)
!2631 = !DILocation(line: 1637, column: 27, scope: !2632)
!2632 = distinct !DILexicalBlock(scope: !2628, file: !3, line: 1636, column: 40)
!2633 = !DILocation(line: 1637, column: 13, scope: !2632)
!2634 = !DILocation(line: 1638, column: 20, scope: !2632)
!2635 = !DILocation(line: 1636, column: 36, scope: !2636)
!2636 = !DILexicalBlockFile(scope: !2628, file: !3, discriminator: 2)
!2637 = !DILocation(line: 1636, column: 9, scope: !2636)
!2638 = distinct !{!2638, !2639, !2640}
!2639 = !DILocation(line: 1636, column: 9, scope: !2625)
!2640 = !DILocation(line: 1639, column: 9, scope: !2625)
!2641 = !DILocation(line: 1640, column: 9, scope: !2608)
!2642 = !DILocation(line: 1641, column: 9, scope: !2608)
!2643 = !DILocation(line: 1642, column: 9, scope: !2644)
!2644 = !DILexicalBlockFile(scope: !2645, file: !3, discriminator: 1)
!2645 = distinct !DILexicalBlock(scope: !2608, file: !3, line: 1642, column: 9)
!2646 = !{i32 -2146437438}
!2647 = !DILocation(line: 1626, column: 5, scope: !2648)
!2648 = !DILexicalBlockFile(scope: !2583, file: !3, discriminator: 2)
!2649 = distinct !{!2649, !2603, !2650}
!2650 = !DILocation(line: 1644, column: 5, scope: !2583)
!2651 = !DILocation(line: 1645, column: 5, scope: !2583)
!2652 = !DILocation(line: 1646, column: 5, scope: !2583)
!2653 = distinct !DISubprogram(name: "norflash_read_otp", scope: !3, file: !3, line: 1650, type: !2584, isLocal: false, isDefinition: true, scopeLine: 1651, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2654)
!2654 = !{!2655, !2656, !2657, !2658, !2659, !2660, !2661}
!2655 = !DILocalVariable(name: "buf", arg: 1, scope: !2653, file: !3, line: 1650, type: !104)
!2656 = !DILocalVariable(name: "len", arg: 2, scope: !2653, file: !3, line: 1650, type: !2586)
!2657 = !DILocalVariable(name: "zone_len", arg: 3, scope: !2653, file: !3, line: 1650, type: !2586)
!2658 = !DILocalVariable(name: "i", scope: !2653, file: !3, line: 1652, type: !438)
!2659 = !DILocalVariable(name: "ret", scope: !2653, file: !3, line: 1652, type: !438)
!2660 = !DILocalVariable(name: "offset", scope: !2653, file: !3, line: 1653, type: !438)
!2661 = !DILocalVariable(name: "otp_index", scope: !2653, file: !3, line: 1654, type: !105)
!2662 = !DILocation(line: 1650, column: 27, scope: !2653)
!2663 = !DILocation(line: 1650, column: 42, scope: !2653)
!2664 = !DILocation(line: 1650, column: 57, scope: !2653)
!2665 = !DILocation(line: 1652, column: 12, scope: !2653)
!2666 = !DILocation(line: 1653, column: 9, scope: !2653)
!2667 = !DILocation(line: 1656, column: 5, scope: !2653)
!2668 = !DILocation(line: 1658, column: 5, scope: !2653)
!2669 = !DILocation(line: 1658, column: 19, scope: !2670)
!2670 = !DILexicalBlockFile(scope: !2653, file: !3, discriminator: 1)
!2671 = !DILocation(line: 1658, column: 5, scope: !2670)
!2672 = !DILocation(line: 1659, column: 9, scope: !2673)
!2673 = distinct !DILexicalBlock(scope: !2653, file: !3, line: 1658, column: 26)
!2674 = !DILocation(line: 1660, column: 9, scope: !2673)
!2675 = !DILocation(line: 1662, column: 38, scope: !2673)
!2676 = !DILocation(line: 1662, column: 50, scope: !2673)
!2677 = !DILocation(line: 1662, column: 27, scope: !2673)
!2678 = !DILocation(line: 1662, column: 21, scope: !2673)
!2679 = !DILocation(line: 1654, column: 8, scope: !2653)
!2680 = !DILocation(line: 1663, column: 9, scope: !2673)
!2681 = !DILocation(line: 1664, column: 9, scope: !2673)
!2682 = !DILocation(line: 1665, column: 9, scope: !2673)
!2683 = !DILocation(line: 1666, column: 9, scope: !2673)
!2684 = !DILocation(line: 1652, column: 9, scope: !2653)
!2685 = !DILocation(line: 1667, column: 14, scope: !2686)
!2686 = distinct !DILexicalBlock(scope: !2673, file: !3, line: 1667, column: 9)
!2687 = !DILocation(line: 1667, column: 23, scope: !2688)
!2688 = !DILexicalBlockFile(scope: !2689, file: !3, discriminator: 1)
!2689 = distinct !DILexicalBlock(scope: !2686, file: !3, line: 1667, column: 9)
!2690 = !DILocation(line: 1667, column: 9, scope: !2691)
!2691 = !DILexicalBlockFile(scope: !2686, file: !3, discriminator: 1)
!2692 = !DILocation(line: 1668, column: 27, scope: !2693)
!2693 = distinct !DILexicalBlock(scope: !2689, file: !3, line: 1667, column: 40)
!2694 = !DILocation(line: 1668, column: 13, scope: !2693)
!2695 = !DILocation(line: 1668, column: 25, scope: !2693)
!2696 = !DILocation(line: 1669, column: 19, scope: !2693)
!2697 = !DILocation(line: 1667, column: 36, scope: !2698)
!2698 = !DILexicalBlockFile(scope: !2689, file: !3, discriminator: 2)
!2699 = !DILocation(line: 1667, column: 9, scope: !2698)
!2700 = distinct !{!2700, !2701, !2702}
!2701 = !DILocation(line: 1667, column: 9, scope: !2686)
!2702 = !DILocation(line: 1670, column: 9, scope: !2686)
!2703 = !DILocation(line: 1671, column: 9, scope: !2673)
!2704 = !DILocation(line: 1658, column: 5, scope: !2705)
!2705 = !DILexicalBlockFile(scope: !2653, file: !3, discriminator: 2)
!2706 = distinct !{!2706, !2668, !2707}
!2707 = !DILocation(line: 1672, column: 5, scope: !2653)
!2708 = !DILocation(line: 1673, column: 5, scope: !2653)
!2709 = !DILocation(line: 1674, column: 5, scope: !2653)
!2710 = distinct !DISubprogram(name: "norflash_read_otp_general", scope: !3, file: !3, line: 1678, type: !2711, isLocal: false, isDefinition: true, scopeLine: 1679, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2713)
!2711 = !DISubroutineType(types: !2712)
!2712 = !{!438, !105, !108, !104, !108}
!2713 = !{!2714, !2715, !2716, !2717, !2718}
!2714 = !DILocalVariable(name: "cmd", arg: 1, scope: !2710, file: !3, line: 1678, type: !105)
!2715 = !DILocalVariable(name: "addr", arg: 2, scope: !2710, file: !3, line: 1678, type: !108)
!2716 = !DILocalVariable(name: "buf", arg: 3, scope: !2710, file: !3, line: 1678, type: !104)
!2717 = !DILocalVariable(name: "len", arg: 4, scope: !2710, file: !3, line: 1678, type: !108)
!2718 = !DILocalVariable(name: "i", scope: !2719, file: !3, line: 1692, type: !108)
!2719 = distinct !DILexicalBlock(scope: !2710, file: !3, line: 1692, column: 5)
!2720 = !DILocation(line: 1678, column: 34, scope: !2710)
!2721 = !DILocation(line: 1678, column: 43, scope: !2710)
!2722 = !DILocation(line: 1678, column: 53, scope: !2710)
!2723 = !DILocation(line: 1678, column: 62, scope: !2710)
!2724 = !DILocation(line: 1680, column: 13, scope: !2725)
!2725 = distinct !DILexicalBlock(scope: !2710, file: !3, line: 1680, column: 9)
!2726 = !DILocation(line: 1680, column: 28, scope: !2727)
!2727 = !DILexicalBlockFile(scope: !2725, file: !3, discriminator: 1)
!2728 = !DILocation(line: 1680, column: 21, scope: !2725)
!2729 = !DILocation(line: 1681, column: 9, scope: !2730)
!2730 = distinct !DILexicalBlock(scope: !2731, file: !3, line: 1681, column: 9)
!2731 = distinct !DILexicalBlock(scope: !2725, file: !3, line: 1680, column: 34)
!2732 = !DILocation(line: 1681, column: 9, scope: !2731)
!2733 = !DILocation(line: 1681, column: 9, scope: !2734)
!2734 = !DILexicalBlockFile(scope: !2730, file: !3, discriminator: 1)
!2735 = !DILocation(line: 1685, column: 5, scope: !2710)
!2736 = !DILocation(line: 1688, column: 5, scope: !2710)
!2737 = !DILocation(line: 1689, column: 5, scope: !2710)
!2738 = !DILocation(line: 1690, column: 5, scope: !2710)
!2739 = !DILocation(line: 1691, column: 5, scope: !2710)
!2740 = !DILocation(line: 1692, column: 14, scope: !2719)
!2741 = !DILocation(line: 1692, column: 10, scope: !2719)
!2742 = !DILocation(line: 1692, column: 23, scope: !2743)
!2743 = !DILexicalBlockFile(scope: !2744, file: !3, discriminator: 1)
!2744 = distinct !DILexicalBlock(scope: !2719, file: !3, line: 1692, column: 5)
!2745 = !DILocation(line: 1692, column: 5, scope: !2746)
!2746 = !DILexicalBlockFile(scope: !2719, file: !3, discriminator: 1)
!2747 = !DILocation(line: 1695, column: 5, scope: !2710)
!2748 = !DILocation(line: 1698, column: 5, scope: !2710)
!2749 = !DILocation(line: 1700, column: 5, scope: !2710)
!2750 = !DILocation(line: 1693, column: 18, scope: !2751)
!2751 = distinct !DILexicalBlock(scope: !2744, file: !3, line: 1692, column: 35)
!2752 = !DILocation(line: 1693, column: 9, scope: !2751)
!2753 = !DILocation(line: 1693, column: 16, scope: !2751)
!2754 = !DILocation(line: 1692, column: 31, scope: !2755)
!2755 = !DILexicalBlockFile(scope: !2744, file: !3, discriminator: 2)
!2756 = !DILocation(line: 1692, column: 5, scope: !2755)
!2757 = distinct !{!2757, !2758, !2759}
!2758 = !DILocation(line: 1692, column: 5, scope: !2719)
!2759 = !DILocation(line: 1694, column: 5, scope: !2719)
!2760 = !DILocation(line: 1701, column: 1, scope: !2710)
!2761 = distinct !DISubprogram(name: "MEMCPY_FLASH", scope: !3, file: !3, line: 1703, type: !2762, isLocal: false, isDefinition: true, scopeLine: 1704, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2764)
!2762 = !DISubroutineType(types: !2763)
!2763 = !{null, !266, !266, !108}
!2764 = !{!2765, !2766, !2767}
!2765 = !DILocalVariable(name: "buf", arg: 1, scope: !2761, file: !3, line: 1703, type: !266)
!2766 = !DILocalVariable(name: "read_addr", arg: 2, scope: !2761, file: !3, line: 1703, type: !266)
!2767 = !DILocalVariable(name: "size", arg: 3, scope: !2761, file: !3, line: 1703, type: !108)
!2768 = !DILocation(line: 1703, column: 25, scope: !2761)
!2769 = !DILocation(line: 1703, column: 36, scope: !2761)
!2770 = !DILocation(line: 1703, column: 51, scope: !2761)
!2771 = !DILocation(line: 1705, column: 9, scope: !2772)
!2772 = distinct !DILexicalBlock(scope: !2761, file: !3, line: 1705, column: 9)
!2773 = !DILocation(line: 1705, column: 35, scope: !2772)
!2774 = !DILocation(line: 1705, column: 40, scope: !2772)
!2775 = !DILocation(line: 1706, column: 39, scope: !2772)
!2776 = !DILocation(line: 1706, column: 29, scope: !2772)
!2777 = !DILocation(line: 1706, column: 9, scope: !2772)
!2778 = !DILocation(line: 1706, column: 47, scope: !2772)
!2779 = !DILocation(line: 1705, column: 9, scope: !2780)
!2780 = !DILexicalBlockFile(scope: !2761, file: !3, discriminator: 1)
!2781 = !DILocation(line: 1708, column: 9, scope: !2782)
!2782 = distinct !DILexicalBlock(scope: !2772, file: !3, line: 1706, column: 69)
!2783 = !DILocation(line: 1709, column: 5, scope: !2782)
!2784 = !DILocation(line: 1709, column: 31, scope: !2785)
!2785 = !DILexicalBlockFile(scope: !2786, file: !3, discriminator: 1)
!2786 = distinct !DILexicalBlock(scope: !2772, file: !3, line: 1709, column: 16)
!2787 = !DILocation(line: 1709, column: 71, scope: !2785)
!2788 = !DILocation(line: 1709, column: 53, scope: !2785)
!2789 = !DILocation(line: 1709, column: 16, scope: !2790)
!2790 = !DILexicalBlockFile(scope: !2786, file: !3, discriminator: 2)
!2791 = !DILocation(line: 1711, column: 40, scope: !2792)
!2792 = distinct !DILexicalBlock(scope: !2786, file: !3, line: 1709, column: 91)
!2793 = !DILocation(line: 1711, column: 9, scope: !2794)
!2794 = !DILexicalBlockFile(scope: !2792, file: !3, discriminator: 1)
!2795 = !DILocation(line: 1712, column: 5, scope: !2792)
!2796 = !DILocation(line: 1713, column: 24, scope: !2797)
!2797 = distinct !DILexicalBlock(scope: !2798, file: !3, line: 1713, column: 13)
!2798 = distinct !DILexicalBlock(scope: !2786, file: !3, line: 1712, column: 12)
!2799 = !DILocation(line: 1713, column: 13, scope: !2797)
!2800 = !DILocation(line: 1713, column: 13, scope: !2798)
!2801 = !DILocation(line: 1714, column: 13, scope: !2802)
!2802 = distinct !DILexicalBlock(scope: !2803, file: !3, line: 1714, column: 13)
!2803 = distinct !DILexicalBlock(scope: !2797, file: !3, line: 1713, column: 30)
!2804 = !DILocation(line: 1715, column: 9, scope: !2803)
!2805 = !DILocation(line: 1716, column: 9, scope: !2798)
!2806 = !DILocation(line: 1717, column: 24, scope: !2807)
!2807 = distinct !DILexicalBlock(scope: !2798, file: !3, line: 1717, column: 13)
!2808 = !DILocation(line: 1717, column: 13, scope: !2807)
!2809 = !DILocation(line: 1717, column: 13, scope: !2798)
!2810 = !DILocation(line: 1718, column: 13, scope: !2811)
!2811 = distinct !DILexicalBlock(scope: !2812, file: !3, line: 1718, column: 13)
!2812 = distinct !DILexicalBlock(scope: !2807, file: !3, line: 1717, column: 30)
!2813 = !DILocation(line: 1719, column: 9, scope: !2812)
!2814 = !DILocation(line: 1721, column: 1, scope: !2761)
!2815 = distinct !DISubprogram(name: "another_cpu_irq", scope: !3, file: !3, line: 57, type: !670, isLocal: true, isDefinition: true, scopeLine: 58, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4)
!2816 = !DILocation(line: 82, column: 5, scope: !584, inlinedAt: !2817)
!2817 = distinct !DILocation(line: 59, column: 9, scope: !2818)
!2818 = distinct !DILexicalBlock(scope: !2815, file: !3, line: 59, column: 9)
!2819 = !DILocation(line: 81, column: 14, scope: !584, inlinedAt: !2817)
!2820 = !DILocation(line: 59, column: 19, scope: !2818)
!2821 = !DILocation(line: 59, column: 9, scope: !2815)
!2822 = !{!597, !450, i64 420}
!2823 = !DILocation(line: 64, column: 5, scope: !2815)
!2824 = !DILocation(line: 65, column: 5, scope: !2825)
!2825 = !DILexicalBlockFile(scope: !2826, file: !3, discriminator: 1)
!2826 = distinct !DILexicalBlock(scope: !2815, file: !3, line: 65, column: 5)
!2827 = !{i32 -2146460439}
!2828 = !DILocation(line: 66, column: 5, scope: !2815)
!2829 = !DILocation(line: 66, column: 25, scope: !2830)
!2830 = !DILexicalBlockFile(scope: !2815, file: !3, discriminator: 1)
!2831 = !DILocation(line: 66, column: 35, scope: !2830)
!2832 = !DILocation(line: 66, column: 12, scope: !2830)
!2833 = !DILocation(line: 66, column: 5, scope: !2830)
!2834 = distinct !{!2834, !2828, !2835}
!2835 = !DILocation(line: 66, column: 46, scope: !2815)
!2836 = !DILocation(line: 67, column: 10, scope: !2837)
!2837 = distinct !DILexicalBlock(scope: !2815, file: !3, line: 67, column: 9)
!2838 = !DILocation(line: 67, column: 9, scope: !2815)
!2839 = !DILocation(line: 68, column: 13, scope: !2840)
!2840 = distinct !DILexicalBlock(scope: !2841, file: !3, line: 68, column: 13)
!2841 = distinct !DILexicalBlock(scope: !2837, file: !3, line: 67, column: 46)
!2842 = !DILocation(line: 68, column: 13, scope: !2841)
!2843 = !DILocation(line: 69, column: 32, scope: !2844)
!2844 = distinct !DILexicalBlock(scope: !2840, file: !3, line: 68, column: 33)
!2845 = !DILocation(line: 69, column: 13, scope: !2844)
!2846 = !DILocation(line: 70, column: 9, scope: !2844)
!2847 = !DILocation(line: 72, column: 9, scope: !2848)
!2848 = !DILexicalBlockFile(scope: !2849, file: !3, discriminator: 1)
!2849 = distinct !DILexicalBlock(scope: !2850, file: !3, line: 72, column: 9)
!2850 = distinct !DILexicalBlock(scope: !2837, file: !3, line: 71, column: 12)
!2851 = !DILocation(line: 72, column: 9, scope: !2852)
!2852 = !DILexicalBlockFile(scope: !2853, file: !3, discriminator: 2)
!2853 = distinct !DILexicalBlock(scope: !2849, file: !3, line: 72, column: 9)
!2854 = !{i32 -2146460217}
!2855 = !DILocation(line: 73, column: 9, scope: !2856)
!2856 = !DILexicalBlockFile(scope: !2857, file: !3, discriminator: 1)
!2857 = distinct !DILexicalBlock(scope: !2850, file: !3, line: 73, column: 9)
!2858 = !{i32 -2146460166}
!2859 = !DILocation(line: 74, column: 13, scope: !2860)
!2860 = distinct !DILexicalBlock(scope: !2850, file: !3, line: 74, column: 13)
!2861 = !DILocation(line: 74, column: 13, scope: !2850)
!2862 = !DILocation(line: 75, column: 32, scope: !2863)
!2863 = distinct !DILexicalBlock(scope: !2860, file: !3, line: 74, column: 33)
!2864 = !DILocation(line: 75, column: 13, scope: !2863)
!2865 = !DILocation(line: 76, column: 9, scope: !2863)
!2866 = !DILocation(line: 77, column: 9, scope: !2867)
!2867 = !DILexicalBlockFile(scope: !2850, file: !3, discriminator: 1)
!2868 = !DILocation(line: 77, column: 9, scope: !2869)
!2869 = !DILexicalBlockFile(scope: !2870, file: !3, discriminator: 2)
!2870 = distinct !DILexicalBlock(scope: !2871, file: !3, line: 77, column: 9)
!2871 = distinct !DILexicalBlock(scope: !2850, file: !3, line: 77, column: 9)
!2872 = !{i32 -2146460077}
!2873 = !DILocation(line: 77, column: 9, scope: !2874)
!2874 = !DILexicalBlockFile(scope: !2850, file: !3, discriminator: 2)
!2875 = distinct !{!2875, !2876, !2876}
!2876 = !DILocation(line: 77, column: 9, scope: !2850)
!2877 = !DILocation(line: 78, column: 9, scope: !2878)
!2878 = !DILexicalBlockFile(scope: !2879, file: !3, discriminator: 1)
!2879 = distinct !DILexicalBlock(scope: !2850, file: !3, line: 78, column: 9)
!2880 = !DILocation(line: 78, column: 9, scope: !2881)
!2881 = !DILexicalBlockFile(scope: !2882, file: !3, discriminator: 2)
!2882 = distinct !DILexicalBlock(scope: !2879, file: !3, line: 78, column: 9)
!2883 = !{i32 -2146459979}
!2884 = !DILocation(line: 80, column: 5, scope: !2815)
!2885 = !DILocation(line: 81, column: 1, scope: !2815)
