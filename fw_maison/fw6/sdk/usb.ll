; ModuleID = 'usb.c.o'
source_filename = "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/cpu/wl82/usb.c"
target datalayout = "e-m:e-p:32:32-i1:32-i64:32:32-f64:32:32-n8:16:32-a:0:32"
target triple = "pi32v2"

%struct.usb_ep_addr_t = type { i32, i32, [4 x i32], [4 x i32], [4 x i32], [4 x i32], [4 x i32], [4 x i32] }
%struct.JL_USB_TypeDef = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.JL_USB_IO_TypeDef = type { i32, i32, i32 }
%struct.husb_ep_reg_t = type { i16, i16, i16, i16, i16, i8, i8, i8, i8, i8, i8 }
%struct.husb_func_reg_t = type { i8, i8, i8, i8, i8, i8, i8, i8 }

@usb_ep_addr = local_unnamed_addr global [2 x %struct.usb_ep_addr_t*] zeroinitializer, align 4, !dbg !0
@nvram_set_boot_state.usb_flag = internal unnamed_addr constant [16 x i8] c"usb_update_mode\00", align 1, !dbg !108
@jiffies = external global i32, align 4
@config_asser = external local_unnamed_addr constant i32, align 4
@.str = private unnamed_addr constant [26 x i8] c"file:%s, line:%d, task:%s\00", align 1
@.str.1 = private unnamed_addr constant [77 x i8] c"/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/cpu/wl82/usb.c\00", align 1
@.str.2 = private unnamed_addr constant [23 x i8] c"ASSERT-FAILD: id == 0 \00", align 1
@usb_regs = internal unnamed_addr constant [2 x %struct.JL_USB_TypeDef*] [%struct.JL_USB_TypeDef* inttoptr (i32 71680 to %struct.JL_USB_TypeDef*), %struct.JL_USB_TypeDef* null], align 4, !dbg !126
@usb_io_regs = internal unnamed_addr constant [2 x %struct.JL_USB_IO_TypeDef*] [%struct.JL_USB_IO_TypeDef* inttoptr (i32 331776 to %struct.JL_USB_IO_TypeDef*), %struct.JL_USB_IO_TypeDef* null], align 4, !dbg !152
@.str.3 = private unnamed_addr constant [29 x i8] c"<Error>: [USB]g_readram ot\0D\0A\00", align 1
@.str.4 = private unnamed_addr constant [26 x i8] c"<Error>: [USB]g_read ot\0D\0A\00", align 1
@.str.5 = private unnamed_addr constant [27 x i8] c"<Error>: [USB]g_write ot\0D\0A\00", align 1
@.str.6 = private unnamed_addr constant [40 x i8] c"<Error>: [USB]USB_ERR_STALL_BULK_SEND\0D\0A\00", align 1
@.str.7 = private unnamed_addr constant [29 x i8] c"<Error>: [USB]TXCSRH_Error\0D\0A\00", align 1
@.str.8 = private unnamed_addr constant [34 x i8] c"<Error>: [USB]exit host mode %d\0D\0A\00", align 1
@speed_table = internal unnamed_addr constant [3 x i8] c"\03\02\01", align 1, !dbg !163
@host_speed = internal unnamed_addr global [2 x i8] zeroinitializer, align 1, !dbg !121
@.str.9 = private unnamed_addr constant [28 x i8] c"<Error>: [USB]h_write ot \0D\0A\00", align 1
@.str.10 = private unnamed_addr constant [46 x i8] c"<Error>: [USB]---USB_ERR_STALL_BULK_RECEIVE\0D\0A\00", align 1
@.str.11 = private unnamed_addr constant [36 x i8] c"<Error>: [USB]---RXCSRH_DataError\0D\0A\00", align 1
@.str.12 = private unnamed_addr constant [49 x i8] c"<Error>: [USB]---RXCSRH_Error Request In again\0D\0A\00", align 1
@.str.13 = private unnamed_addr constant [26 x i8] c"<Error>: [USB]h_read ot\0D\0A\00", align 1
@.str.14 = private unnamed_addr constant [46 x i8] c"<Error>: [USB]DEV_ERR_READ_TIMEOUT reg = %x\0D\0A\00", align 1
@.str.15 = private unnamed_addr constant [27 x i8] c"[Info]: [USB]wait sie...\0D\0A\00", align 1
@.str.16 = private unnamed_addr constant [28 x i8] c"<Error>: [USB]time out %x\0D\0A\00", align 1
@.str.17 = private unnamed_addr constant [32 x i8] c"<Error>: [USB]exit host mode\0A\0D\0A\00", align 1
@.str.18 = private unnamed_addr constant [27 x i8] c"[Debug]: [USB]full speed\0D\0A\00", align 1
@.str.19 = private unnamed_addr constant [26 x i8] c"[Debug]: [USB]low speed\0D\0A\00", align 1
@.str.20 = private unnamed_addr constant [26 x i8] c"<Error>: [USB]time out\0A\0D\0A\00", align 1
@.str.21 = private unnamed_addr constant [27 x i8] c"[Debug]: [USB]high speed\0D\0A\00", align 1
@otg_prevent_detect = external local_unnamed_addr global i8, align 1

; Function Attrs: minsize noreturn nounwind optsize
define void @nvram_set_boot_state(i32) local_unnamed_addr #0 !dbg !110 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !114, metadata !173), !dbg !174
  tail call void @llvm.dbg.value(metadata i8* inttoptr (i32 29883776 to i8*), i64 0, metadata !115, metadata !173), !dbg !175
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* inttoptr (i32 29883776 to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @nvram_set_boot_state.usb_flag, i32 0, i32 0), i32 16, i32 1, i1 false), !dbg !176
  tail call void @P33_SYSTEM_RESET() #9, !dbg !177
  br label %2, !dbg !183

; <label>:2:                                      ; preds = %2, %1
  br label %2, !dbg !184, !llvm.loop !186
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i32, i1) #1

; Function Attrs: minsize norecurse nounwind optsize
define i32 @usb_get_jiffies() local_unnamed_addr #2 !dbg !189 {
  %1 = load volatile i32, i32* @jiffies, align 4, !dbg !192, !tbaa !193
  ret i32 %1, !dbg !197
}

; Function Attrs: minsize nounwind optsize
define i32 @musb_read_usb(i8 zeroext, i32) local_unnamed_addr #3 !dbg !198 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !204, metadata !173), !dbg !208
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !205, metadata !173), !dbg !209
  %3 = load i32, i32* @config_asser, align 4, !dbg !210, !tbaa !214
  %4 = icmp eq i32 %3, 0, !dbg !210
  %5 = zext i8 %0 to i32
  %6 = icmp eq i8 %0, 0
  br i1 %4, label %12, label %7, !dbg !216

; <label>:7:                                      ; preds = %2
  br i1 %6, label %15, label %8, !dbg !218

; <label>:8:                                      ; preds = %7
  %9 = tail call i8* bitcast (i8* (...)* @os_current_task_rom to i8* ()*)() #9, !dbg !221
  %10 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([77 x i8], [77 x i8]* @.str.1, i32 0, i32 0), i32 99, i8* %9) #10, !dbg !225
  %11 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.2, i32 0, i32 0)) #10, !dbg !227
  tail call void bitcast (void (...)* @cpu_assert_debug to void ()*)() #9, !dbg !229
  br label %15, !dbg !221

; <label>:12:                                     ; preds = %2
  br i1 %6, label %15, label %13, !dbg !231

; <label>:13:                                     ; preds = %12
  tail call void @P33_SYSTEM_RESET() #9, !dbg !234
  br label %14, !dbg !239

; <label>:14:                                     ; preds = %14, %13
  br label %14, !dbg !240, !llvm.loop !186

; <label>:15:                                     ; preds = %12, %8, %7
  tail call void @llvm.dbg.value(metadata i32 20000, i64 0, metadata !206, metadata !173), !dbg !241
  %16 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %5, !dbg !242
  %17 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %16, align 4, !dbg !242, !tbaa !244
  %18 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %17, i32 0, i32 0, !dbg !242
  %19 = load volatile i32, i32* %18, align 4, !dbg !242, !tbaa !246
  %20 = and i32 %19, 4, !dbg !248
  %21 = icmp eq i32 %20, 0, !dbg !248
  br i1 %21, label %39, label %22, !dbg !249

; <label>:22:                                     ; preds = %15
  %23 = shl i32 %1, 8, !dbg !250
  %24 = and i32 %23, 16760576, !dbg !250
  %25 = or i32 %24, 16384, !dbg !251
  %26 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %17, i32 0, i32 1, !dbg !252
  store volatile i32 %25, i32* %26, align 4, !dbg !253, !tbaa !254
  tail call void asm sideeffect "csync", ""() #7, !dbg !255, !srcloc !256
  br label %27, !dbg !257

; <label>:27:                                     ; preds = %32, %22
  %28 = phi i32 [ 20000, %22 ], [ %33, %32 ]
  tail call void @llvm.dbg.value(metadata i32 %28, i64 0, metadata !206, metadata !173), !dbg !241
  %29 = load volatile i32, i32* %26, align 4, !dbg !258, !tbaa !254
  %30 = trunc i32 %29 to i16, !dbg !260
  %31 = icmp sgt i16 %30, -1, !dbg !260
  br i1 %31, label %32, label %35, !dbg !261

; <label>:32:                                     ; preds = %27
  %33 = add nsw i32 %28, -1, !dbg !262
  tail call void @llvm.dbg.value(metadata i32 %33, i64 0, metadata !206, metadata !173), !dbg !241
  %34 = icmp eq i32 %28, 0, !dbg !262
  br i1 %34, label %38, label %27, !dbg !265, !llvm.loop !266

; <label>:35:                                     ; preds = %27
  %36 = load volatile i32, i32* %26, align 4, !dbg !268, !tbaa !254
  %37 = and i32 %36, 255, !dbg !269
  tail call void @llvm.dbg.value(metadata i32 %37, i64 0, metadata !207, metadata !173), !dbg !270
  br label %39, !dbg !271

; <label>:38:                                     ; preds = %32
  br label %39, !dbg !272

; <label>:39:                                     ; preds = %38, %35, %15
  %40 = phi i32 [ %37, %35 ], [ 0, %15 ], [ 0, %38 ]
  ret i32 %40, !dbg !273
}

; Function Attrs: minsize nounwind optsize
declare i32 @printf(i8* nocapture readonly, ...) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare i8* @os_current_task_rom(...) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare void @cpu_assert_debug(...) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define void @musb_write_usb(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !274 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !278, metadata !173), !dbg !282
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !279, metadata !173), !dbg !283
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !280, metadata !173), !dbg !284
  %4 = load i32, i32* @config_asser, align 4, !dbg !285, !tbaa !214
  %5 = icmp eq i32 %4, 0, !dbg !285
  %6 = zext i8 %0 to i32
  %7 = icmp eq i8 %0, 0
  br i1 %5, label %13, label %8, !dbg !289

; <label>:8:                                      ; preds = %3
  br i1 %7, label %16, label %9, !dbg !291

; <label>:9:                                      ; preds = %8
  %10 = tail call i8* bitcast (i8* (...)* @os_current_task_rom to i8* ()*)() #9, !dbg !294
  %11 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([77 x i8], [77 x i8]* @.str.1, i32 0, i32 0), i32 119, i8* %10) #10, !dbg !298
  %12 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.2, i32 0, i32 0)) #10, !dbg !300
  tail call void bitcast (void (...)* @cpu_assert_debug to void ()*)() #9, !dbg !302
  br label %16, !dbg !294

; <label>:13:                                     ; preds = %3
  br i1 %7, label %16, label %14, !dbg !304

; <label>:14:                                     ; preds = %13
  tail call void @P33_SYSTEM_RESET() #9, !dbg !307
  br label %15, !dbg !312

; <label>:15:                                     ; preds = %15, %14
  br label %15, !dbg !313, !llvm.loop !186

; <label>:16:                                     ; preds = %13, %9, %8
  tail call void @llvm.dbg.value(metadata i32 20000, i64 0, metadata !281, metadata !173), !dbg !314
  %17 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %6, !dbg !315
  %18 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %17, align 4, !dbg !315, !tbaa !244
  %19 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %18, i32 0, i32 0, !dbg !315
  %20 = load volatile i32, i32* %19, align 4, !dbg !315, !tbaa !246
  %21 = and i32 %20, 4, !dbg !317
  %22 = icmp eq i32 %21, 0, !dbg !317
  br i1 %22, label %38, label %23, !dbg !318

; <label>:23:                                     ; preds = %16
  %24 = shl i32 %1, 8, !dbg !319
  %25 = and i32 %24, 16776960, !dbg !319
  %26 = and i32 %2, 255, !dbg !320
  %27 = or i32 %25, %26, !dbg !321
  %28 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %18, i32 0, i32 1, !dbg !322
  store volatile i32 %27, i32* %28, align 4, !dbg !323, !tbaa !254
  tail call void asm sideeffect "csync", ""() #7, !dbg !324, !srcloc !325
  br label %29, !dbg !326

; <label>:29:                                     ; preds = %34, %23
  %30 = phi i32 [ 20000, %23 ], [ %35, %34 ]
  tail call void @llvm.dbg.value(metadata i32 %30, i64 0, metadata !281, metadata !173), !dbg !314
  %31 = load volatile i32, i32* %28, align 4, !dbg !327, !tbaa !254
  %32 = trunc i32 %31 to i16, !dbg !329
  %33 = icmp sgt i16 %32, -1, !dbg !329
  br i1 %33, label %34, label %37, !dbg !330

; <label>:34:                                     ; preds = %29
  %35 = add nsw i32 %30, -1, !dbg !331
  tail call void @llvm.dbg.value(metadata i32 %35, i64 0, metadata !281, metadata !173), !dbg !314
  %36 = icmp eq i32 %30, 0, !dbg !331
  br i1 %36, label %37, label %29, !dbg !334, !llvm.loop !335

; <label>:37:                                     ; preds = %34, %29
  br label %38, !dbg !337

; <label>:38:                                     ; preds = %37, %16
  ret void, !dbg !339
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_dev_con0(i8 zeroext) local_unnamed_addr #3 !dbg !340 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !344, metadata !173), !dbg !345
  %2 = icmp eq i8 %0, 0, !dbg !346
  br i1 %2, label %3, label %5, !dbg !348

; <label>:3:                                      ; preds = %1
  %4 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !349, !tbaa !246
  br label %5, !dbg !351

; <label>:5:                                      ; preds = %3, %1
  %6 = phi i32 [ %4, %3 ], [ 0, %1 ]
  ret i32 %6, !dbg !352
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_check_dpo(i8 zeroext) local_unnamed_addr #3 !dbg !353 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !355, metadata !173), !dbg !356
  %2 = icmp eq i8 %0, 0, !dbg !357
  br i1 %2, label %3, label %6, !dbg !359

; <label>:3:                                      ; preds = %1
  %4 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !360, !tbaa !246
  %5 = lshr i32 %4, 15, !dbg !362
  br label %9, !dbg !363

; <label>:6:                                      ; preds = %1
  %7 = load volatile i32, i32* inttoptr (i32 92688 to i32*), align 16, !dbg !364, !tbaa !214
  %8 = lshr i32 %7, 17, !dbg !366
  br label %9, !dbg !367

; <label>:9:                                      ; preds = %6, %3
  %10 = phi i32 [ %5, %3 ], [ %8, %6 ]
  %11 = and i32 %10, 1
  ret i32 %11, !dbg !368
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_check_dmo(i8 zeroext) local_unnamed_addr #3 !dbg !369 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !371, metadata !173), !dbg !372
  %2 = icmp eq i8 %0, 0, !dbg !373
  br i1 %2, label %7, label %3, !dbg !375

; <label>:3:                                      ; preds = %1
  %4 = load volatile i32, i32* inttoptr (i32 92688 to i32*), align 16, !dbg !376, !tbaa !214
  %5 = lshr i32 %4, 18, !dbg !378
  %6 = and i32 %5, 1, !dbg !378
  br label %7, !dbg !379

; <label>:7:                                      ; preds = %3, %1
  %8 = phi i32 [ %6, %3 ], [ 1, %1 ]
  ret i32 %8, !dbg !380
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_read_dp_se(i8 zeroext) local_unnamed_addr #3 !dbg !381 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !383, metadata !173), !dbg !384
  %2 = icmp eq i8 %0, 0, !dbg !385
  br i1 %2, label %3, label %6, !dbg !387

; <label>:3:                                      ; preds = %1
  %4 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !388, !tbaa !246
  %5 = lshr i32 %4, 17, !dbg !390
  br label %9, !dbg !391

; <label>:6:                                      ; preds = %1
  %7 = load volatile i32, i32* inttoptr (i32 92688 to i32*), align 16, !dbg !392, !tbaa !214
  %8 = lshr i32 %7, 15, !dbg !394
  br label %9, !dbg !395

; <label>:9:                                      ; preds = %6, %3
  %10 = phi i32 [ %5, %3 ], [ %8, %6 ]
  %11 = and i32 %10, 1
  ret i32 %11, !dbg !396
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_read_dm_se(i8 zeroext) local_unnamed_addr #3 !dbg !397 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !399, metadata !173), !dbg !400
  %2 = icmp eq i8 %0, 0, !dbg !401
  %3 = select i1 %2, i32* inttoptr (i32 71680 to i32*), i32* inttoptr (i32 92688 to i32*), !dbg !403
  %4 = load volatile i32, i32* %3, align 16, !tbaa !214
  %5 = lshr i32 %4, 16
  %6 = and i32 %5, 1
  ret i32 %6, !dbg !404
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_read_sofpnd(i8 zeroext) local_unnamed_addr #3 !dbg !405 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !407, metadata !173), !dbg !408
  %2 = icmp eq i8 %0, 0, !dbg !409
  %3 = select i1 %2, i32* inttoptr (i32 71680 to i32*), i32* inttoptr (i32 92160 to i32*), !dbg !411
  %4 = select i1 %2, i32 13, i32 7, !dbg !411
  %5 = load volatile i32, i32* %3, align 2048, !tbaa !214
  %6 = lshr i32 %5, %4
  %7 = and i32 %6, 1
  ret i32 %7, !dbg !412
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_phy_status(i8 zeroext) local_unnamed_addr #3 !dbg !413 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !415, metadata !173), !dbg !416
  %2 = icmp eq i8 %0, 0, !dbg !417
  %3 = select i1 %2, i32* inttoptr (i32 71680 to i32*), i32* inttoptr (i32 92684 to i32*), !dbg !419
  %4 = load volatile i32, i32* %3, align 4, !tbaa !214
  %5 = and i32 %4, 1
  ret i32 %5, !dbg !420
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_sie_status(i8 zeroext) local_unnamed_addr #3 !dbg !421 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !423, metadata !173), !dbg !425
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !424, metadata !173), !dbg !426
  %2 = icmp eq i8 %0, 0, !dbg !427
  br i1 %2, label %3, label %7, !dbg !429

; <label>:3:                                      ; preds = %1
  %4 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !430, !tbaa !246
  %5 = lshr i32 %4, 11, !dbg !432
  %6 = and i32 %5, 1, !dbg !432
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !424, metadata !173), !dbg !426
  br label %19, !dbg !433

; <label>:7:                                      ; preds = %1
  %8 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !434, !tbaa !214
  %9 = and i32 %8, 1, !dbg !437
  %10 = icmp eq i32 %9, 0, !dbg !437
  br i1 %10, label %19, label %11, !dbg !438

; <label>:11:                                     ; preds = %7
  %12 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !439, !tbaa !214
  %13 = and i32 %12, 2, !dbg !440
  %14 = icmp eq i32 %13, 0, !dbg !440
  br i1 %14, label %19, label %15, !dbg !441

; <label>:15:                                     ; preds = %11
  %16 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !442, !tbaa !214
  tail call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !424, metadata !173), !dbg !426
  %17 = lshr i32 %16, 4, !dbg !443
  %18 = and i32 %17, 1, !dbg !443
  ret i32 %18, !dbg !443

; <label>:19:                                     ; preds = %11, %7, %3
  %20 = phi i32 [ %6, %3 ], [ 0, %11 ], [ 0, %7 ]
  tail call void @llvm.dbg.value(metadata i32 %20, i64 0, metadata !424, metadata !173), !dbg !426
  ret i32 %20, !dbg !445
}

; Function Attrs: minsize nounwind optsize
define void @usb_sie_enable(i8 zeroext) local_unnamed_addr #3 !dbg !446 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !450, metadata !173), !dbg !451
  %2 = icmp eq i8 %0, 0, !dbg !452
  %3 = select i1 %2, i32* inttoptr (i32 71680 to i32*), i32* inttoptr (i32 92160 to i32*), !dbg !454
  %4 = select i1 %2, i32 2048, i32 2, !dbg !454
  %5 = load volatile i32, i32* %3, align 2048, !tbaa !214
  %6 = or i32 %5, %4
  store volatile i32 %6, i32* %3, align 2048, !tbaa !214
  ret void, !dbg !455
}

; Function Attrs: minsize nounwind optsize
define void @usb_sie_disable(i8 zeroext) local_unnamed_addr #3 !dbg !456 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !458, metadata !173), !dbg !459
  %2 = icmp eq i8 %0, 0, !dbg !460
  %3 = select i1 %2, i32* inttoptr (i32 71680 to i32*), i32* inttoptr (i32 92160 to i32*), !dbg !462
  %4 = select i1 %2, i32 -2049, i32 -3, !dbg !462
  %5 = load volatile i32, i32* %3, align 2048, !tbaa !214
  %6 = and i32 %5, %4
  store volatile i32 %6, i32* %3, align 2048, !tbaa !214
  ret void, !dbg !463
}

; Function Attrs: minsize nounwind optsize
define void @usb_sofie_enable(i8 zeroext) local_unnamed_addr #3 !dbg !464 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !466, metadata !173), !dbg !467
  %2 = icmp eq i8 %0, 0, !dbg !468
  %3 = select i1 %2, i32* inttoptr (i32 71680 to i32*), i32* inttoptr (i32 92160 to i32*), !dbg !470
  %4 = load volatile i32, i32* %3, align 2048, !tbaa !214
  %5 = or i32 %4, 1024
  store volatile i32 %5, i32* %3, align 2048, !tbaa !214
  ret void, !dbg !471
}

; Function Attrs: minsize nounwind optsize
define void @usb_sofie_disable(i8 zeroext) local_unnamed_addr #3 !dbg !472 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !474, metadata !173), !dbg !475
  %2 = icmp eq i8 %0, 0, !dbg !476
  %3 = select i1 %2, i32* inttoptr (i32 71680 to i32*), i32* inttoptr (i32 92160 to i32*), !dbg !478
  %4 = load volatile i32, i32* %3, align 2048, !tbaa !214
  %5 = and i32 %4, -1025
  store volatile i32 %5, i32* %3, align 2048, !tbaa !214
  ret void, !dbg !479
}

; Function Attrs: minsize nounwind optsize
define void @usb_sof_clr_pnd(i8 zeroext) local_unnamed_addr #3 !dbg !480 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !482, metadata !173), !dbg !483
  %2 = icmp eq i8 %0, 0, !dbg !484
  br i1 %2, label %3, label %6, !dbg !486

; <label>:3:                                      ; preds = %1
  tail call void @sys_local_irq_disable() #9, !dbg !487
  %4 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !491, !tbaa !246
  %5 = or i32 %4, 4096, !dbg !491
  store volatile i32 %5, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !491, !tbaa !246
  tail call void @sys_local_irq_enable() #9, !dbg !492
  br label %9, !dbg !495

; <label>:6:                                      ; preds = %1
  %7 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !496, !tbaa !214
  %8 = or i32 %7, 64, !dbg !496
  store volatile i32 %8, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !496, !tbaa !214
  br label %9

; <label>:9:                                      ; preds = %6, %3
  ret void, !dbg !498
}

; Function Attrs: minsize optsize
declare void @sys_local_irq_disable() local_unnamed_addr #5

; Function Attrs: minsize optsize
declare void @sys_local_irq_enable() local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define void @usb_write_ep_cnt(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !499 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !501, metadata !173), !dbg !512
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !502, metadata !173), !dbg !513
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !503, metadata !173), !dbg !514
  %4 = icmp eq i8 %0, 0, !dbg !515
  br i1 %4, label %5, label %10, !dbg !516

; <label>:5:                                      ; preds = %3
  tail call void @sys_local_irq_disable() #9, !dbg !517
  %6 = icmp eq i32 %1, 4, !dbg !520
  br i1 %6, label %7, label %8, !dbg !522

; <label>:7:                                      ; preds = %5
  store volatile i32 %2, i32* inttoptr (i32 71732 to i32*), align 4, !dbg !523, !tbaa !525
  tail call void asm sideeffect "csync", ""() #7, !dbg !526, !srcloc !527
  tail call void @sys_local_irq_enable() #9, !dbg !528
  br label %26, !dbg !531

; <label>:8:                                      ; preds = %5
  tail call void @llvm.dbg.value(metadata i32* getelementptr (%struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* inttoptr (i32 71680 to %struct.JL_USB_TypeDef*), i32 0, i32 2), i64 0, metadata !504, metadata !173), !dbg !532
  %9 = getelementptr inbounds i32, i32* inttoptr (i32 71688 to i32*), i32 %1, !dbg !533
  tail call void @llvm.dbg.value(metadata i32* %9, i64 0, metadata !504, metadata !173), !dbg !532
  store volatile i32 %2, i32* %9, align 4, !dbg !534, !tbaa !214
  tail call void @sys_local_irq_enable() #9, !dbg !535
  br label %25, !dbg !538

; <label>:10:                                     ; preds = %3
  tail call void @llvm.dbg.value(metadata i32* inttoptr (i32 92164 to i32*), i64 0, metadata !507, metadata !173), !dbg !539
  %11 = getelementptr inbounds i32, i32* inttoptr (i32 92164 to i32*), i32 %1, !dbg !540
  tail call void @llvm.dbg.value(metadata i32* %11, i64 0, metadata !507, metadata !173), !dbg !539
  %12 = add i32 %1, -3, !dbg !541
  %13 = icmp ult i32 %12, 2, !dbg !541
  br i1 %13, label %14, label %23, !dbg !541

; <label>:14:                                     ; preds = %10
  %15 = tail call i32 @usb_read_txcsr(i8 zeroext %0, i32 %1) #10, !dbg !542
  %16 = and i32 %15, 16384, !dbg !544
  %17 = icmp eq i32 %16, 0, !dbg !544
  br i1 %17, label %23, label %18, !dbg !545

; <label>:18:                                     ; preds = %14
  %19 = tail call i32 @usb_get_dma_size(i8 zeroext %0, i32 %1) #10, !dbg !547
  tail call void @llvm.dbg.value(metadata i32 %19, i64 0, metadata !509, metadata !173), !dbg !548
  %20 = shl i32 %19, 16, !dbg !549
  %21 = or i32 %20, %2, !dbg !550
  %22 = or i32 %21, -2147483648, !dbg !550
  br label %23, !dbg !551

; <label>:23:                                     ; preds = %18, %14, %10
  %24 = phi i32 [ %22, %18 ], [ %2, %14 ], [ %2, %10 ]
  store volatile i32 %24, i32* %11, align 4, !tbaa !214
  br label %25

; <label>:25:                                     ; preds = %23, %8
  tail call void asm sideeffect "csync", ""() #7, !dbg !552, !srcloc !553
  tail call void asm sideeffect "ssync", ""() #7, !dbg !554, !srcloc !555
  br label %26, !dbg !556

; <label>:26:                                     ; preds = %25, %7
  ret void, !dbg !557
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_read_txcsr(i8 zeroext, i32) local_unnamed_addr #3 !dbg !559 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !561, metadata !173), !dbg !568
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !562, metadata !173), !dbg !569
  %3 = icmp eq i8 %0, 0, !dbg !570
  br i1 %3, label %4, label %9, !dbg !571

; <label>:4:                                      ; preds = %2
  tail call void @sys_local_irq_disable() #9, !dbg !572
  tail call void @musb_write_index(i8 zeroext 0, i32 %1) #10, !dbg !575
  %5 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 17) #10, !dbg !576
  %6 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 18) #10, !dbg !577
  %7 = shl i32 %6, 8, !dbg !579
  %8 = or i32 %7, %5, !dbg !580
  tail call void @llvm.dbg.value(metadata i32 %8, i64 0, metadata !563, metadata !173), !dbg !581
  tail call void @sys_local_irq_enable() #9, !dbg !582
  br label %14

; <label>:9:                                      ; preds = %2
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !566, metadata !173), !dbg !585
  %10 = add i32 %1, -1, !dbg !586
  tail call void asm sideeffect "ssync", ""() #7, !dbg !587, !srcloc !588
  %11 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %10, i32 1, !dbg !589
  %12 = load volatile i16, i16* %11, align 2, !dbg !589, !tbaa !590
  %13 = zext i16 %12 to i32, !dbg !593
  br label %14

; <label>:14:                                     ; preds = %9, %4
  %15 = phi i32 [ %8, %4 ], [ %13, %9 ]
  ret i32 %15, !dbg !594
}

; Function Attrs: minsize nounwind optsize readonly
define i32 @usb_get_dma_size(i8 zeroext, i32) local_unnamed_addr #6 !dbg !595 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !597, metadata !173), !dbg !599
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !598, metadata !173), !dbg !600
  %3 = zext i8 %0 to i32, !dbg !601
  %4 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %3, !dbg !601
  %5 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %4, align 4, !dbg !601, !tbaa !244
  %6 = icmp eq %struct.usb_ep_addr_t* %5, null, !dbg !603
  br i1 %6, label %11, label %7, !dbg !604

; <label>:7:                                      ; preds = %2
  %8 = add i32 %1, -1, !dbg !605
  %9 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %5, i32 0, i32 6, i32 %8, !dbg !606
  %10 = load i32, i32* %9, align 4, !dbg !606, !tbaa !214
  br label %11, !dbg !607

; <label>:11:                                     ; preds = %7, %2
  %12 = phi i32 [ %10, %7 ], [ 0, %2 ]
  ret i32 %12, !dbg !608
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_dev_status(i8 zeroext) local_unnamed_addr #3 !dbg !609 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !611, metadata !173), !dbg !612
  %2 = icmp eq i8 %0, 0, !dbg !613
  br i1 %2, label %3, label %8, !dbg !615

; <label>:3:                                      ; preds = %1
  %4 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !616, !tbaa !246
  %5 = and i32 %4, 196608, !dbg !618
  %6 = icmp eq i32 %5, 196608, !dbg !619
  %7 = zext i1 %6 to i32, !dbg !619
  br label %8, !dbg !620

; <label>:8:                                      ; preds = %3, %1
  %9 = phi i32 [ %7, %3 ], [ 0, %1 ]
  ret i32 %9, !dbg !621
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_dev_status(i8 zeroext) local_unnamed_addr #3 !dbg !622 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !624, metadata !173), !dbg !627
  %2 = tail call i32 @usb_read_dp_se(i8 zeroext %0) #10, !dbg !628
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !625, metadata !173), !dbg !629
  %3 = tail call i32 @usb_read_dm_se(i8 zeroext %0) #10, !dbg !630
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !626, metadata !173), !dbg !631
  %4 = or i32 %3, %2, !dbg !632
  %5 = icmp eq i32 %4, 0, !dbg !632
  %6 = zext i1 %5 to i32, !dbg !633
  ret i32 %6, !dbg !635
}

; Function Attrs: minsize nounwind optsize
define void @usb_set_low_speed(i8 zeroext, i8 zeroext) local_unnamed_addr #3 !dbg !636 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !640, metadata !173), !dbg !642
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !641, metadata !173), !dbg !643
  %3 = icmp eq i8 %0, 0, !dbg !644
  br i1 %3, label %4, label %10, !dbg !646

; <label>:4:                                      ; preds = %2
  %5 = icmp ne i8 %1, 0, !dbg !647
  %6 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !tbaa !246
  %7 = and i32 %6, -3, !dbg !650
  %8 = or i32 %6, 2, !dbg !652
  %9 = select i1 %5, i32 %8, i32 %7, !dbg !654
  store volatile i32 %9, i32* inttoptr (i32 71680 to i32*), align 2048, !tbaa !246
  br label %10, !dbg !655

; <label>:10:                                     ; preds = %4, %2
  ret void, !dbg !656
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_ep0(i8 zeroext, i8* nocapture readonly, i32) local_unnamed_addr #3 !dbg !657 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !662, metadata !173), !dbg !665
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !663, metadata !173), !dbg !666
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !664, metadata !173), !dbg !667
  %4 = zext i8 %0 to i32, !dbg !668
  %5 = icmp eq i8 %0, 0, !dbg !670
  br i1 %5, label %7, label %6, !dbg !671

; <label>:6:                                      ; preds = %3
  br label %17, !dbg !667

; <label>:7:                                      ; preds = %3
  %8 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %4, !dbg !672
  %9 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %8, align 4, !dbg !672, !tbaa !244
  %10 = icmp eq %struct.usb_ep_addr_t* %9, null, !dbg !672
  br i1 %10, label %26, label %11, !dbg !675

; <label>:11:                                     ; preds = %7
  %12 = bitcast %struct.usb_ep_addr_t* %9 to i8**, !dbg !676
  %13 = load i8*, i8** %12, align 4, !dbg !676, !tbaa !678
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %13, i8* %1, i32 %2, i32 1, i1 false), !dbg !680
  %14 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %4, !dbg !681
  %15 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %14, align 4, !dbg !681, !tbaa !244
  %16 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %15, i32 0, i32 2, !dbg !681
  store volatile i32 %2, i32* %16, align 4, !dbg !682, !tbaa !683
  br label %26, !dbg !684

; <label>:17:                                     ; preds = %21, %6
  %18 = phi i8* [ %23, %21 ], [ %1, %6 ]
  %19 = phi i32 [ %22, %21 ], [ %2, %6 ]
  tail call void @llvm.dbg.value(metadata i32 %19, i64 0, metadata !664, metadata !173), !dbg !667
  tail call void @llvm.dbg.value(metadata i8* %18, i64 0, metadata !663, metadata !173), !dbg !666
  tail call void @llvm.dbg.value(metadata i32 %22, i64 0, metadata !664, metadata !173), !dbg !667
  %20 = icmp eq i32 %19, 0, !dbg !685
  br i1 %20, label %25, label %21, !dbg !685

; <label>:21:                                     ; preds = %17
  %22 = add i32 %19, -1, !dbg !688
  %23 = getelementptr inbounds i8, i8* %18, i32 1, !dbg !689
  tail call void @llvm.dbg.value(metadata i8* %23, i64 0, metadata !663, metadata !173), !dbg !666
  %24 = load i8, i8* %18, align 1, !dbg !691, !tbaa !692
  store volatile i8 %24, i8* inttoptr (i32 90144 to i8*), align 32, !dbg !693, !tbaa !692
  br label %17, !dbg !685, !llvm.loop !694

; <label>:25:                                     ; preds = %17
  br label %26, !dbg !697

; <label>:26:                                     ; preds = %25, %11, %7
  ret void, !dbg !698
}

; Function Attrs: minsize nounwind optsize
define void @usb_read_ep0(i8 zeroext, i8* nocapture, i32) local_unnamed_addr #3 !dbg !700 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !704, metadata !173), !dbg !707
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !705, metadata !173), !dbg !708
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !706, metadata !173), !dbg !709
  %4 = icmp eq i8 %0, 0, !dbg !710
  br i1 %4, label %5, label %11, !dbg !712

; <label>:5:                                      ; preds = %3
  %6 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** getelementptr inbounds ([2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 0), align 4, !dbg !713, !tbaa !244
  %7 = icmp eq %struct.usb_ep_addr_t* %6, null, !dbg !713
  br i1 %7, label %25, label %8, !dbg !716

; <label>:8:                                      ; preds = %5
  %9 = bitcast %struct.usb_ep_addr_t* %6 to i8**, !dbg !717
  %10 = load i8*, i8** %9, align 4, !dbg !717, !tbaa !678
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %1, i8* %10, i32 %2, i32 1, i1 false), !dbg !719
  br label %25, !dbg !720

; <label>:11:                                     ; preds = %3
  tail call void @sys_local_irq_disable() #9, !dbg !721
  %12 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !725, !tbaa !214
  %13 = and i32 %12, -2049, !dbg !725
  store volatile i32 %13, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !725, !tbaa !214
  tail call void asm sideeffect "csync", ""() #7, !dbg !726, !srcloc !727
  tail call void asm sideeffect "ssync", ""() #7, !dbg !728, !srcloc !729
  br label %14, !dbg !730

; <label>:14:                                     ; preds = %18, %11
  %15 = phi i8* [ %1, %11 ], [ %21, %18 ]
  %16 = phi i32 [ %2, %11 ], [ %19, %18 ]
  tail call void @llvm.dbg.value(metadata i32 %16, i64 0, metadata !706, metadata !173), !dbg !709
  tail call void @llvm.dbg.value(metadata i8* %15, i64 0, metadata !705, metadata !173), !dbg !708
  tail call void @llvm.dbg.value(metadata i32 %19, i64 0, metadata !706, metadata !173), !dbg !709
  %17 = icmp eq i32 %16, 0, !dbg !731
  br i1 %17, label %22, label %18, !dbg !731

; <label>:18:                                     ; preds = %14
  %19 = add i32 %16, -1, !dbg !733
  %20 = load volatile i8, i8* inttoptr (i32 90144 to i8*), align 32, !dbg !735, !tbaa !692
  %21 = getelementptr inbounds i8, i8* %15, i32 1, !dbg !737
  tail call void @llvm.dbg.value(metadata i8* %21, i64 0, metadata !705, metadata !173), !dbg !708
  store i8 %20, i8* %15, align 1, !dbg !738, !tbaa !692
  br label %14, !dbg !739, !llvm.loop !740

; <label>:22:                                     ; preds = %14
  %23 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !742, !tbaa !214
  %24 = or i32 %23, 2048, !dbg !742
  store volatile i32 %24, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !742, !tbaa !214
  tail call void @sys_local_irq_enable() #9, !dbg !743
  br label %25

; <label>:25:                                     ; preds = %22, %8, %5
  ret void, !dbg !746
}

; Function Attrs: minsize nounwind optsize readonly
define i8* @usb_get_dma_taddr(i8 zeroext, i32) local_unnamed_addr #6 !dbg !747 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !751, metadata !173), !dbg !753
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !752, metadata !173), !dbg !754
  %3 = zext i8 %0 to i32, !dbg !755
  %4 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %3, !dbg !755
  %5 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %4, align 4, !dbg !755, !tbaa !244
  %6 = icmp eq %struct.usb_ep_addr_t* %5, null, !dbg !757
  br i1 %6, label %15, label %7, !dbg !758

; <label>:7:                                      ; preds = %2
  %8 = icmp eq i32 %1, 0, !dbg !759
  %9 = add i32 %1, -1, !dbg !761
  %10 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %5, i32 0, i32 2, i32 %9, !dbg !762
  %11 = bitcast i32* %10 to i8**, !dbg !762
  %12 = bitcast %struct.usb_ep_addr_t* %5 to i8**, !dbg !763
  %13 = select i1 %8, i8** %12, i8** %11, !dbg !765
  %14 = load i8*, i8** %13, align 4, !tbaa !214
  br label %15, !dbg !766

; <label>:15:                                     ; preds = %7, %2
  %16 = phi i8* [ null, %2 ], [ %14, %7 ]
  ret i8* %16, !dbg !767
}

; Function Attrs: minsize nounwind optsize
define void @usb_set_dma_tsize(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !769 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !771, metadata !173), !dbg !774
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !772, metadata !173), !dbg !775
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !773, metadata !173), !dbg !776
  %4 = zext i8 %0 to i32, !dbg !777
  %5 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %4, !dbg !777
  %6 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %5, align 4, !dbg !777, !tbaa !244
  %7 = icmp eq %struct.usb_ep_addr_t* %6, null, !dbg !779
  br i1 %7, label %11, label %8, !dbg !780

; <label>:8:                                      ; preds = %3
  %9 = add i32 %1, -1, !dbg !781
  %10 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %6, i32 0, i32 6, i32 %9, !dbg !782
  store i32 %2, i32* %10, align 4, !dbg !783, !tbaa !214
  br label %11, !dbg !784

; <label>:11:                                     ; preds = %8, %3
  ret void, !dbg !785
}

; Function Attrs: minsize nounwind optsize
define void @usb_set_dma_rsize(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !787 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !789, metadata !173), !dbg !792
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !790, metadata !173), !dbg !793
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !791, metadata !173), !dbg !794
  %4 = zext i8 %0 to i32, !dbg !795
  %5 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %4, !dbg !795
  %6 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %5, align 4, !dbg !795, !tbaa !244
  %7 = icmp eq %struct.usb_ep_addr_t* %6, null, !dbg !797
  br i1 %7, label %11, label %8, !dbg !798

; <label>:8:                                      ; preds = %3
  %9 = add i32 %1, -1, !dbg !799
  %10 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %6, i32 0, i32 7, i32 %9, !dbg !800
  store i32 %2, i32* %10, align 4, !dbg !801, !tbaa !214
  br label %11, !dbg !802

; <label>:11:                                     ; preds = %8, %3
  ret void, !dbg !803
}

; Function Attrs: minsize nounwind optsize
define void @usb_set_dma_taddr(i8 zeroext, i32, i8*) local_unnamed_addr #3 !dbg !805 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !809, metadata !173), !dbg !817
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !810, metadata !173), !dbg !818
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !811, metadata !173), !dbg !819
  %4 = zext i8 %0 to i32, !dbg !820
  %5 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %4, !dbg !820
  %6 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %5, align 4, !dbg !820, !tbaa !244
  %7 = icmp eq %struct.usb_ep_addr_t* %6, null, !dbg !822
  br i1 %7, label %47, label %8, !dbg !823

; <label>:8:                                      ; preds = %3
  %9 = icmp eq i8 %0, 0, !dbg !824
  %10 = icmp eq i32 %1, 0
  br i1 %9, label %11, label %36, !dbg !825

; <label>:11:                                     ; preds = %8
  br i1 %10, label %12, label %19, !dbg !826

; <label>:12:                                     ; preds = %11
  %13 = ptrtoint i8* %2 to i32, !dbg !827
  %14 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %4, !dbg !830
  %15 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %14, align 4, !dbg !830, !tbaa !244
  %16 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %15, i32 0, i32 6, !dbg !830
  store volatile i32 %13, i32* %16, align 4, !dbg !831, !tbaa !832
  tail call void asm sideeffect "csync", ""() #7, !dbg !833, !srcloc !834
  tail call void asm sideeffect "ssync", ""() #7, !dbg !835, !srcloc !836
  %17 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %5, align 4, !dbg !837, !tbaa !244
  %18 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %17, i32 0, i32 0, !dbg !838
  store i32 %13, i32* %18, align 4, !dbg !839, !tbaa !678
  br label %47, !dbg !840

; <label>:19:                                     ; preds = %11
  %20 = icmp eq i32 %1, 4, !dbg !841
  %21 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %4, !dbg !843
  %22 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %21, align 4, !dbg !843
  br i1 %20, label %23, label %28, !dbg !845

; <label>:23:                                     ; preds = %19
  %24 = ptrtoint i8* %2 to i32, !dbg !846
  %25 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %22, i32 0, i32 14, !dbg !848
  store volatile i32 %24, i32* %25, align 4, !dbg !849, !tbaa !850
  tail call void asm sideeffect "csync", ""() #7, !dbg !851, !srcloc !852
  tail call void asm sideeffect "ssync", ""() #7, !dbg !853, !srcloc !854
  %26 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %5, align 4, !dbg !855, !tbaa !244
  %27 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %26, i32 0, i32 2, i32 3, !dbg !855
  store i32 %24, i32* %27, align 4, !dbg !856, !tbaa !214
  br label %47, !dbg !857

; <label>:28:                                     ; preds = %19
  %29 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %22, i32 0, i32 7, !dbg !858
  tail call void @llvm.dbg.value(metadata i32* %29, i64 0, metadata !812, metadata !173), !dbg !859
  %30 = add i32 %1, -1, !dbg !860
  %31 = shl i32 %30, 1, !dbg !861
  %32 = getelementptr inbounds i32, i32* %29, i32 %31, !dbg !862
  tail call void @llvm.dbg.value(metadata i32* %32, i64 0, metadata !812, metadata !173), !dbg !859
  %33 = ptrtoint i8* %2 to i32, !dbg !863
  store volatile i32 %33, i32* %32, align 4, !dbg !864, !tbaa !214
  tail call void asm sideeffect "csync", ""() #7, !dbg !865, !srcloc !866
  tail call void asm sideeffect "ssync", ""() #7, !dbg !867, !srcloc !868
  %34 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %5, align 4, !dbg !869, !tbaa !244
  %35 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %34, i32 0, i32 2, i32 %30, !dbg !869
  store i32 %33, i32* %35, align 4, !dbg !870, !tbaa !214
  br label %47, !dbg !871

; <label>:36:                                     ; preds = %8
  br i1 %10, label %37, label %40, !dbg !872

; <label>:37:                                     ; preds = %36
  %38 = ptrtoint i8* %2 to i32, !dbg !873
  %39 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %6, i32 0, i32 0, !dbg !876
  store i32 %38, i32* %39, align 4, !dbg !877, !tbaa !678
  br label %47, !dbg !878

; <label>:40:                                     ; preds = %36
  tail call void @llvm.dbg.value(metadata i32* inttoptr (i32 92192 to i32*), i64 0, metadata !815, metadata !173), !dbg !879
  %41 = add i32 %1, -1, !dbg !880
  %42 = shl i32 %41, 1, !dbg !881
  %43 = getelementptr inbounds i32, i32* inttoptr (i32 92192 to i32*), i32 %42, !dbg !882
  tail call void @llvm.dbg.value(metadata i32* %43, i64 0, metadata !815, metadata !173), !dbg !879
  %44 = ptrtoint i8* %2 to i32, !dbg !883
  store volatile i32 %44, i32* %43, align 8, !dbg !884, !tbaa !214
  tail call void asm sideeffect "csync", ""() #7, !dbg !885, !srcloc !886
  tail call void asm sideeffect "ssync", ""() #7, !dbg !887, !srcloc !888
  %45 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %5, align 4, !dbg !889, !tbaa !244
  %46 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %45, i32 0, i32 2, i32 %41, !dbg !889
  store i32 %44, i32* %46, align 4, !dbg !890, !tbaa !214
  br label %47

; <label>:47:                                     ; preds = %40, %37, %28, %23, %12, %3
  ret void, !dbg !891
}

; Function Attrs: minsize nounwind optsize
define i8* @usb_get_dma_raddr(i8 zeroext, i32) local_unnamed_addr #3 !dbg !892 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !894, metadata !173), !dbg !896
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !895, metadata !173), !dbg !897
  %3 = zext i8 %0 to i32, !dbg !898
  %4 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %3, !dbg !898
  %5 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %4, align 4, !dbg !898, !tbaa !244
  %6 = icmp eq %struct.usb_ep_addr_t* %5, null, !dbg !900
  br i1 %6, label %52, label %7, !dbg !901

; <label>:7:                                      ; preds = %2
  %8 = icmp eq i32 %1, 0, !dbg !902
  br i1 %8, label %9, label %12, !dbg !904

; <label>:9:                                      ; preds = %7
  %10 = bitcast %struct.usb_ep_addr_t* %5 to i8**, !dbg !905
  %11 = load i8*, i8** %10, align 4, !dbg !905, !tbaa !678
  br label %52, !dbg !907

; <label>:12:                                     ; preds = %7
  %13 = add i32 %1, -1, !dbg !908
  %14 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %5, i32 0, i32 5, i32 %13, !dbg !910
  %15 = load i32, i32* %14, align 4, !dbg !910, !tbaa !214
  %16 = icmp eq i32 %15, 0, !dbg !911
  %17 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %5, i32 0, i32 4, i32 %13
  br i1 %16, label %45, label %18, !dbg !912

; <label>:18:                                     ; preds = %12
  %19 = load i32, i32* %17, align 4, !dbg !913, !tbaa !214
  %20 = icmp eq i32 %19, %15, !dbg !916
  br i1 %20, label %21, label %33, !dbg !917

; <label>:21:                                     ; preds = %18
  %22 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %5, i32 0, i32 7, i32 %13, !dbg !918
  %23 = load i32, i32* %22, align 4, !dbg !918, !tbaa !214
  %24 = icmp eq i8 %0, 0, !dbg !920
  %25 = select i1 %24, i32 4, i32 0, !dbg !921
  %26 = add i32 %15, %25, !dbg !922
  %27 = add i32 %26, %23, !dbg !923
  %28 = inttoptr i32 %27 to i8*, !dbg !924
  tail call void @usb_set_dma_raddr(i8 zeroext %0, i32 %1, i8* %28) #10, !dbg !925
  %29 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %4, align 4, !dbg !926, !tbaa !244
  %30 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %29, i32 0, i32 5, i32 %13, !dbg !926
  %31 = bitcast i32* %30 to i8**, !dbg !926
  %32 = load i8*, i8** %31, align 4, !dbg !926, !tbaa !214
  br label %52, !dbg !927

; <label>:33:                                     ; preds = %18
  %34 = inttoptr i32 %15 to i8*, !dbg !928
  tail call void @usb_set_dma_raddr(i8 zeroext %0, i32 %1, i8* %34) #10, !dbg !930
  %35 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %4, align 4, !dbg !931, !tbaa !244
  %36 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %35, i32 0, i32 5, i32 %13, !dbg !931
  %37 = load i32, i32* %36, align 4, !dbg !931, !tbaa !214
  %38 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %35, i32 0, i32 7, i32 %13, !dbg !932
  %39 = load i32, i32* %38, align 4, !dbg !932, !tbaa !214
  %40 = icmp eq i8 %0, 0, !dbg !933
  %41 = select i1 %40, i32 4, i32 0, !dbg !934
  %42 = add i32 %37, %41, !dbg !935
  %43 = add i32 %42, %39, !dbg !936
  %44 = inttoptr i32 %43 to i8*, !dbg !937
  br label %52, !dbg !938

; <label>:45:                                     ; preds = %12
  %46 = bitcast i32* %17 to i8**, !dbg !939
  %47 = load i8*, i8** %46, align 4, !dbg !939, !tbaa !214
  tail call void @usb_set_dma_raddr(i8 zeroext %0, i32 %1, i8* %47) #10, !dbg !940
  %48 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %4, align 4, !dbg !941, !tbaa !244
  %49 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %48, i32 0, i32 4, i32 %13, !dbg !941
  %50 = bitcast i32* %49 to i8**, !dbg !941
  %51 = load i8*, i8** %50, align 4, !dbg !941, !tbaa !214
  br label %52, !dbg !942

; <label>:52:                                     ; preds = %45, %33, %21, %9, %2
  %53 = phi i8* [ %11, %9 ], [ %32, %21 ], [ %44, %33 ], [ %51, %45 ], [ null, %2 ]
  ret i8* %53, !dbg !943
}

; Function Attrs: minsize nounwind optsize
define void @usb_set_dma_raddr(i8 zeroext, i32, i8*) local_unnamed_addr #3 !dbg !944 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !946, metadata !173), !dbg !954
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !947, metadata !173), !dbg !955
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !948, metadata !173), !dbg !956
  %4 = zext i8 %0 to i32, !dbg !957
  %5 = icmp eq i8 %0, 0, !dbg !958
  br i1 %5, label %6, label %39, !dbg !959

; <label>:6:                                      ; preds = %3
  %7 = icmp eq i32 %1, 0, !dbg !960
  br i1 %7, label %8, label %18, !dbg !962

; <label>:8:                                      ; preds = %6
  %9 = ptrtoint i8* %2 to i32, !dbg !963
  %10 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %4, !dbg !965
  %11 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %10, align 4, !dbg !965, !tbaa !244
  %12 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %11, i32 0, i32 6, !dbg !965
  store volatile i32 %9, i32* %12, align 4, !dbg !966, !tbaa !832
  tail call void asm sideeffect "csync", ""() #7, !dbg !967, !srcloc !968
  tail call void asm sideeffect "ssync", ""() #7, !dbg !969, !srcloc !970
  %13 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %4, !dbg !971
  %14 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %13, align 4, !dbg !971, !tbaa !244
  %15 = icmp eq %struct.usb_ep_addr_t* %14, null, !dbg !971
  br i1 %15, label %55, label %16, !dbg !973

; <label>:16:                                     ; preds = %8
  %17 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %14, i32 0, i32 0, !dbg !974
  store i32 %9, i32* %17, align 4, !dbg !976, !tbaa !678
  br label %55, !dbg !977

; <label>:18:                                     ; preds = %6
  %19 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %4, !dbg !978
  %20 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %19, align 4, !dbg !978, !tbaa !244
  %21 = icmp eq %struct.usb_ep_addr_t* %20, null, !dbg !980
  br i1 %21, label %55, label %22, !dbg !981

; <label>:22:                                     ; preds = %18
  %23 = icmp eq i32 %1, 4, !dbg !982
  %24 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %4, !dbg !984
  %25 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %24, align 4, !dbg !984
  br i1 %23, label %26, label %31, !dbg !986

; <label>:26:                                     ; preds = %22
  %27 = ptrtoint i8* %2 to i32, !dbg !987
  %28 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %25, i32 0, i32 15, !dbg !989
  store volatile i32 %27, i32* %28, align 4, !dbg !990, !tbaa !991
  tail call void asm sideeffect "csync", ""() #7, !dbg !992, !srcloc !993
  tail call void asm sideeffect "ssync", ""() #7, !dbg !994, !srcloc !995
  %29 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %19, align 4, !dbg !996, !tbaa !244
  %30 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %29, i32 0, i32 4, i32 3, !dbg !996
  store i32 %27, i32* %30, align 4, !dbg !997, !tbaa !214
  br label %55, !dbg !998

; <label>:31:                                     ; preds = %22
  %32 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %25, i32 0, i32 8, !dbg !999
  tail call void @llvm.dbg.value(metadata i32* %32, i64 0, metadata !949, metadata !173), !dbg !1000
  %33 = add i32 %1, -1, !dbg !1001
  %34 = shl i32 %33, 1, !dbg !1002
  %35 = getelementptr inbounds i32, i32* %32, i32 %34, !dbg !1003
  tail call void @llvm.dbg.value(metadata i32* %35, i64 0, metadata !949, metadata !173), !dbg !1000
  %36 = ptrtoint i8* %2 to i32, !dbg !1004
  store volatile i32 %36, i32* %35, align 4, !dbg !1005, !tbaa !214
  tail call void asm sideeffect "csync", ""() #7, !dbg !1006, !srcloc !1007
  tail call void asm sideeffect "ssync", ""() #7, !dbg !1008, !srcloc !1009
  %37 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %19, align 4, !dbg !1010, !tbaa !244
  %38 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %37, i32 0, i32 4, i32 %33, !dbg !1010
  store i32 %36, i32* %38, align 4, !dbg !1011, !tbaa !214
  br label %55, !dbg !1012

; <label>:39:                                     ; preds = %3
  %40 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %4, !dbg !1013
  %41 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %40, align 4, !dbg !1013, !tbaa !244
  %42 = icmp eq %struct.usb_ep_addr_t* %41, null, !dbg !1015
  br i1 %42, label %55, label %43, !dbg !1016

; <label>:43:                                     ; preds = %39
  %44 = icmp eq i32 %1, 0, !dbg !1017
  br i1 %44, label %45, label %48, !dbg !1019

; <label>:45:                                     ; preds = %43
  %46 = ptrtoint i8* %2 to i32, !dbg !1020
  %47 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %41, i32 0, i32 0, !dbg !1022
  store i32 %46, i32* %47, align 4, !dbg !1023, !tbaa !678
  br label %55, !dbg !1024

; <label>:48:                                     ; preds = %43
  tail call void @llvm.dbg.value(metadata i32* inttoptr (i32 92196 to i32*), i64 0, metadata !952, metadata !173), !dbg !1025
  %49 = add i32 %1, -1, !dbg !1026
  %50 = shl i32 %49, 1, !dbg !1027
  %51 = getelementptr inbounds i32, i32* inttoptr (i32 92196 to i32*), i32 %50, !dbg !1028
  tail call void @llvm.dbg.value(metadata i32* %51, i64 0, metadata !952, metadata !173), !dbg !1025
  %52 = ptrtoint i8* %2 to i32, !dbg !1029
  store volatile i32 %52, i32* %51, align 4, !dbg !1030, !tbaa !214
  tail call void asm sideeffect "csync", ""() #7, !dbg !1031, !srcloc !1032
  tail call void asm sideeffect "ssync", ""() #7, !dbg !1033, !srcloc !1034
  %53 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %40, align 4, !dbg !1035, !tbaa !244
  %54 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %53, i32 0, i32 4, i32 %49, !dbg !1035
  store i32 %52, i32* %54, align 4, !dbg !1036, !tbaa !214
  br label %55

; <label>:55:                                     ; preds = %48, %45, %39, %31, %26, %18, %16, %8
  ret void, !dbg !1037
}

; Function Attrs: minsize nounwind optsize
define void @usb_set_dma_dual_raddr(i8 zeroext, i32, i8*) local_unnamed_addr #3 !dbg !1038 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1040, metadata !173), !dbg !1043
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1041, metadata !173), !dbg !1044
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !1042, metadata !173), !dbg !1045
  %4 = zext i8 %0 to i32, !dbg !1046
  %5 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %4, !dbg !1046
  %6 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %5, align 4, !dbg !1046, !tbaa !244
  %7 = icmp eq %struct.usb_ep_addr_t* %6, null, !dbg !1048
  br i1 %7, label %12, label %8, !dbg !1049

; <label>:8:                                      ; preds = %3
  %9 = ptrtoint i8* %2 to i32, !dbg !1050
  %10 = add i32 %1, -1, !dbg !1051
  %11 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %6, i32 0, i32 5, i32 %10, !dbg !1052
  store i32 %9, i32* %11, align 4, !dbg !1053, !tbaa !214
  br label %12, !dbg !1054

; <label>:12:                                     ; preds = %8, %3
  ret void, !dbg !1055
}

; Function Attrs: minsize nounwind optsize
define void @musb_write_index(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1057 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1061, metadata !173), !dbg !1063
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1062, metadata !173), !dbg !1064
  %3 = load i32, i32* @config_asser, align 4, !dbg !1065, !tbaa !214
  %4 = icmp eq i32 %3, 0, !dbg !1065
  %5 = icmp eq i8 %0, 0
  br i1 %4, label %11, label %6, !dbg !1069

; <label>:6:                                      ; preds = %2
  br i1 %5, label %14, label %7, !dbg !1071

; <label>:7:                                      ; preds = %6
  %8 = tail call i8* bitcast (i8* (...)* @os_current_task_rom to i8* ()*)() #9, !dbg !1074
  %9 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([77 x i8], [77 x i8]* @.str.1, i32 0, i32 0), i32 491, i8* %8) #10, !dbg !1078
  %10 = tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.2, i32 0, i32 0)) #10, !dbg !1080
  tail call void bitcast (void (...)* @cpu_assert_debug to void ()*)() #9, !dbg !1082
  br label %14, !dbg !1074

; <label>:11:                                     ; preds = %2
  br i1 %5, label %14, label %12, !dbg !1084

; <label>:12:                                     ; preds = %11
  tail call void @P33_SYSTEM_RESET() #9, !dbg !1087
  br label %13, !dbg !1092

; <label>:13:                                     ; preds = %13, %12
  br label %13, !dbg !1093, !llvm.loop !186

; <label>:14:                                     ; preds = %11, %7, %6
  tail call void @musb_write_usb(i8 zeroext %0, i32 14, i32 %1) #10, !dbg !1094
  ret void, !dbg !1095
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_power(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1096 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1098, metadata !173), !dbg !1100
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1099, metadata !173), !dbg !1101
  %3 = icmp eq i8 %0, 0, !dbg !1102
  br i1 %3, label %4, label %5, !dbg !1104

; <label>:4:                                      ; preds = %2
  tail call void @sys_local_irq_disable() #9, !dbg !1105
  tail call void @musb_write_usb(i8 zeroext 0, i32 1, i32 %1) #10, !dbg !1109
  tail call void @sys_local_irq_enable() #9, !dbg !1110
  br label %7, !dbg !1113

; <label>:5:                                      ; preds = %2
  %6 = trunc i32 %1 to i8, !dbg !1114
  store volatile i8 %6, i8* inttoptr (i32 90113 to i8*), align 1, !dbg !1116, !tbaa !692
  br label %7

; <label>:7:                                      ; preds = %5, %4
  ret void, !dbg !1117
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_read_power(i8 zeroext) local_unnamed_addr #3 !dbg !1118 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1122, metadata !173), !dbg !1126
  %2 = icmp eq i8 %0, 0, !dbg !1127
  br i1 %2, label %3, label %6, !dbg !1128

; <label>:3:                                      ; preds = %1
  tail call void @sys_local_irq_disable() #9, !dbg !1129
  %4 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 1) #10, !dbg !1132
  %5 = trunc i32 %4 to i8, !dbg !1132
  tail call void @llvm.dbg.value(metadata i8 %5, i64 0, metadata !1123, metadata !173), !dbg !1133
  tail call void @sys_local_irq_enable() #9, !dbg !1134
  br label %8

; <label>:6:                                      ; preds = %1
  %7 = load volatile i8, i8* inttoptr (i32 90113 to i8*), align 1, !dbg !1137, !tbaa !692
  br label %8, !dbg !1139

; <label>:8:                                      ; preds = %6, %3
  %9 = phi i8 [ %5, %3 ], [ %7, %6 ]
  %10 = zext i8 %9 to i32
  ret i32 %10, !dbg !1140
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_read_devctl(i8 zeroext) local_unnamed_addr #3 !dbg !1141 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1143, metadata !173), !dbg !1147
  %2 = icmp eq i8 %0, 0, !dbg !1148
  br i1 %2, label %3, label %6, !dbg !1149

; <label>:3:                                      ; preds = %1
  tail call void @sys_local_irq_disable() #9, !dbg !1150
  %4 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 15) #10, !dbg !1153
  %5 = trunc i32 %4 to i8, !dbg !1153
  tail call void @llvm.dbg.value(metadata i8 %5, i64 0, metadata !1144, metadata !173), !dbg !1154
  tail call void @sys_local_irq_enable() #9, !dbg !1155
  br label %8

; <label>:6:                                      ; preds = %1
  %7 = load volatile i8, i8* inttoptr (i32 90208 to i8*), align 32, !dbg !1158, !tbaa !692
  br label %8, !dbg !1160

; <label>:8:                                      ; preds = %6, %3
  %9 = phi i8 [ %5, %3 ], [ %7, %6 ]
  %10 = zext i8 %9 to i32
  ret i32 %10, !dbg !1161
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_devctl(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1162 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1164, metadata !173), !dbg !1166
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1165, metadata !173), !dbg !1167
  %3 = icmp eq i8 %0, 0, !dbg !1168
  br i1 %3, label %4, label %5, !dbg !1170

; <label>:4:                                      ; preds = %2
  tail call void @sys_local_irq_disable() #9, !dbg !1171
  tail call void @musb_write_usb(i8 zeroext 0, i32 15, i32 %1) #10, !dbg !1175
  tail call void @sys_local_irq_enable() #9, !dbg !1176
  br label %7, !dbg !1179

; <label>:5:                                      ; preds = %2
  %6 = trunc i32 %1 to i8, !dbg !1180
  store volatile i8 %6, i8* inttoptr (i32 90208 to i8*), align 32, !dbg !1182, !tbaa !692
  br label %7

; <label>:7:                                      ; preds = %5, %4
  ret void, !dbg !1183
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_read_csr0(i8 zeroext) local_unnamed_addr #3 !dbg !1184 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1186, metadata !173), !dbg !1190
  %2 = icmp eq i8 %0, 0, !dbg !1191
  br i1 %2, label %3, label %5, !dbg !1192

; <label>:3:                                      ; preds = %1
  tail call void @sys_local_irq_disable() #9, !dbg !1193
  tail call void @musb_write_index(i8 zeroext 0, i32 0) #10, !dbg !1196
  %4 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 17) #10, !dbg !1197
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !1187, metadata !173), !dbg !1198
  tail call void @sys_local_irq_enable() #9, !dbg !1199
  br label %8

; <label>:5:                                      ; preds = %1
  tail call void asm sideeffect "ssync", ""() #7, !dbg !1202, !srcloc !1204
  %6 = load volatile i16, i16* inttoptr (i32 90370 to i16*), align 2, !dbg !1205, !tbaa !1206
  %7 = zext i16 %6 to i32, !dbg !1205
  br label %8, !dbg !1207

; <label>:8:                                      ; preds = %5, %3
  %9 = phi i32 [ %4, %3 ], [ %7, %5 ]
  ret i32 %9, !dbg !1208
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_csr0(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1209 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1211, metadata !173), !dbg !1213
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1212, metadata !173), !dbg !1214
  %3 = icmp eq i8 %0, 0, !dbg !1215
  br i1 %3, label %4, label %5, !dbg !1217

; <label>:4:                                      ; preds = %2
  tail call void @sys_local_irq_disable() #9, !dbg !1218
  tail call void @musb_write_index(i8 zeroext 0, i32 0) #10, !dbg !1222
  tail call void @musb_write_usb(i8 zeroext 0, i32 17, i32 %1) #10, !dbg !1223
  tail call void @sys_local_irq_enable() #9, !dbg !1224
  br label %7, !dbg !1227

; <label>:5:                                      ; preds = %2
  %6 = trunc i32 %1 to i16, !dbg !1228
  store volatile i16 %6, i16* inttoptr (i32 90370 to i16*), align 2, !dbg !1230, !tbaa !1206
  tail call void asm sideeffect "csync", ""() #7, !dbg !1231, !srcloc !1232
  tail call void asm sideeffect "ssync", ""() #7, !dbg !1233, !srcloc !1234
  br label %7

; <label>:7:                                      ; preds = %5, %4
  ret void, !dbg !1235
}

; Function Attrs: minsize nounwind optsize
define zeroext i16 @musb_read_sofframe(i8 zeroext) local_unnamed_addr #3 !dbg !1236 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1240, metadata !173), !dbg !1244
  %2 = icmp eq i8 %0, 0, !dbg !1245
  br i1 %2, label %3, label %9, !dbg !1246

; <label>:3:                                      ; preds = %1
  tail call void @sys_local_irq_disable() #9, !dbg !1247
  %4 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 12) #10, !dbg !1250
  %5 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 13) #10, !dbg !1251
  %6 = shl i32 %5, 8, !dbg !1253
  %7 = add i32 %6, %4, !dbg !1254
  %8 = trunc i32 %7 to i16, !dbg !1250
  tail call void @llvm.dbg.value(metadata i16 %8, i64 0, metadata !1241, metadata !173), !dbg !1255
  tail call void @sys_local_irq_enable() #9, !dbg !1256
  br label %11

; <label>:9:                                      ; preds = %1
  %10 = load volatile i16, i16* inttoptr (i32 90124 to i16*), align 4, !dbg !1259, !tbaa !1206
  br label %11, !dbg !1261

; <label>:11:                                     ; preds = %9, %3
  %12 = phi i16 [ %8, %3 ], [ %10, %9 ]
  ret i16 %12, !dbg !1262
}

; Function Attrs: minsize nounwind optsize
define void @usb_ep0_ClrRxPktRdy(i8 zeroext) local_unnamed_addr #3 !dbg !1263 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1265, metadata !173), !dbg !1266
  tail call void @usb_write_csr0(i8 zeroext %0, i32 64) #10, !dbg !1267
  ret void, !dbg !1268
}

; Function Attrs: minsize nounwind optsize
define void @usb_ep0_TxPktEnd(i8 zeroext) local_unnamed_addr #3 !dbg !1269 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1271, metadata !173), !dbg !1272
  tail call void @usb_write_csr0(i8 zeroext %0, i32 10) #10, !dbg !1273
  ret void, !dbg !1274
}

; Function Attrs: minsize nounwind optsize
define void @usb_ep0_RxPktEnd(i8 zeroext) local_unnamed_addr #3 !dbg !1275 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1277, metadata !173), !dbg !1278
  tail call void @usb_write_csr0(i8 zeroext %0, i32 72) #10, !dbg !1279
  ret void, !dbg !1280
}

; Function Attrs: minsize nounwind optsize
define void @usb_ep0_Set_Stall(i8 zeroext) local_unnamed_addr #3 !dbg !1281 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1283, metadata !173), !dbg !1284
  tail call void @usb_write_csr0(i8 zeroext %0, i32 96) #10, !dbg !1285
  ret void, !dbg !1286
}

; Function Attrs: minsize nounwind optsize
define void @usb_ep0_Set_ignore(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1287 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1291, metadata !173), !dbg !1297
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1292, metadata !173), !dbg !1298
  %3 = zext i8 %0 to i32, !dbg !1299
  %4 = icmp eq i8 %0, 0, !dbg !1300
  br i1 %4, label %5, label %24, !dbg !1301

; <label>:5:                                      ; preds = %2
  tail call void @usb_ep0_Set_Stall(i8 zeroext 0) #10, !dbg !1302
  br label %6, !dbg !1303

; <label>:6:                                      ; preds = %6, %5
  %7 = tail call i32 @usb_read_csr0(i8 zeroext 0) #10, !dbg !1304
  %8 = and i32 %7, 4, !dbg !1305
  %9 = icmp eq i32 %8, 0, !dbg !1305
  br i1 %9, label %6, label %10, !dbg !1307

; <label>:10:                                     ; preds = %6
  %11 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %3
  br label %12, !dbg !1308

; <label>:12:                                     ; preds = %12, %10
  %13 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %11, align 4, !dbg !1312, !tbaa !244
  %14 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %13, i32 0, i32 0, !dbg !1312
  %15 = load volatile i32, i32* %14, align 4, !dbg !1312, !tbaa !246
  %16 = and i32 %15, 196608, !dbg !1314
  %17 = icmp eq i32 %16, 0, !dbg !1315
  br i1 %17, label %18, label %12, !dbg !1316, !llvm.loop !1318

; <label>:18:                                     ; preds = %12
  %19 = getelementptr inbounds [2 x %struct.JL_USB_IO_TypeDef*], [2 x %struct.JL_USB_IO_TypeDef*]* @usb_io_regs, i32 0, i32 %3, !dbg !1321
  %20 = load %struct.JL_USB_IO_TypeDef*, %struct.JL_USB_IO_TypeDef** %19, align 4, !dbg !1321, !tbaa !244
  %21 = getelementptr inbounds %struct.JL_USB_IO_TypeDef, %struct.JL_USB_IO_TypeDef* %20, i32 0, i32 0, !dbg !1321
  %22 = load volatile i32, i32* %21, align 4, !dbg !1322, !tbaa !1323
  %23 = or i32 %22, 2316, !dbg !1322
  store volatile i32 %23, i32* %21, align 4, !dbg !1322, !tbaa !1323
  tail call void @usb_write_faddr(i8 zeroext 0, i32 %1) #10, !dbg !1325
  br label %24

; <label>:24:                                     ; preds = %18, %2
  ret void, !dbg !1326
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_faddr(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1327 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1329, metadata !173), !dbg !1331
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1330, metadata !173), !dbg !1332
  %3 = icmp eq i8 %0, 0, !dbg !1333
  br i1 %3, label %4, label %5, !dbg !1335

; <label>:4:                                      ; preds = %2
  tail call void @sys_local_irq_disable() #9, !dbg !1336
  tail call void @musb_write_usb(i8 zeroext 0, i32 0, i32 %1) #10, !dbg !1340
  tail call void @sys_local_irq_enable() #9, !dbg !1341
  br label %7, !dbg !1344

; <label>:5:                                      ; preds = %2
  %6 = trunc i32 %1 to i8, !dbg !1345
  store volatile i8 %6, i8* inttoptr (i32 90112 to i8*), align 8192, !dbg !1347, !tbaa !692
  br label %7

; <label>:7:                                      ; preds = %5, %4
  ret void, !dbg !1348
}

; Function Attrs: minsize nounwind optsize
define void @usb_recover_io_status(i8 zeroext) local_unnamed_addr #3 !dbg !1349 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1351, metadata !173), !dbg !1352
  %2 = icmp eq i8 %0, 0, !dbg !1353
  br i1 %2, label %3, label %6, !dbg !1355

; <label>:3:                                      ; preds = %1
  tail call void @usb_write_faddr(i8 zeroext 0, i32 0) #10, !dbg !1356
  %4 = load volatile i32, i32* inttoptr (i32 331776 to i32*), align 4096, !dbg !1358, !tbaa !1323
  %5 = and i32 %4, -2305, !dbg !1358
  store volatile i32 %5, i32* inttoptr (i32 331776 to i32*), align 4096, !dbg !1358, !tbaa !1323
  br label %6, !dbg !1359

; <label>:6:                                      ; preds = %3, %1
  ret void, !dbg !1360
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_read_count0(i8 zeroext) local_unnamed_addr #3 !dbg !1361 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1363, metadata !173), !dbg !1367
  %2 = icmp eq i8 %0, 0, !dbg !1368
  br i1 %2, label %3, label %5, !dbg !1369

; <label>:3:                                      ; preds = %1
  tail call void @sys_local_irq_disable() #9, !dbg !1370
  tail call void @musb_write_index(i8 zeroext 0, i32 0) #10, !dbg !1373
  %4 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 22) #10, !dbg !1374
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !1364, metadata !173), !dbg !1375
  tail call void @sys_local_irq_enable() #9, !dbg !1376
  br label %8

; <label>:5:                                      ; preds = %1
  %6 = load volatile i16, i16* inttoptr (i32 90376 to i16*), align 8, !dbg !1379, !tbaa !1206
  %7 = zext i16 %6 to i32, !dbg !1379
  br label %8, !dbg !1381

; <label>:8:                                      ; preds = %5, %3
  %9 = phi i32 [ %4, %3 ], [ %7, %5 ]
  ret i32 %9, !dbg !1382
}

; Function Attrs: minsize nounwind optsize
define void @usb_read_intr(i8 zeroext, i32* nocapture, i32* nocapture, i32* nocapture) local_unnamed_addr #3 !dbg !1383 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1389, metadata !173), !dbg !1393
  tail call void @llvm.dbg.value(metadata i32* %1, i64 0, metadata !1390, metadata !173), !dbg !1394
  tail call void @llvm.dbg.value(metadata i32* %2, i64 0, metadata !1391, metadata !173), !dbg !1395
  tail call void @llvm.dbg.value(metadata i32* %3, i64 0, metadata !1392, metadata !173), !dbg !1396
  tail call void @sys_local_irq_disable() #9, !dbg !1397
  %5 = icmp eq i8 %0, 0, !dbg !1400
  br i1 %5, label %6, label %16, !dbg !1402

; <label>:6:                                      ; preds = %4
  %7 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 6) #10, !dbg !1403
  store i32 %7, i32* %1, align 4, !dbg !1405, !tbaa !214
  %8 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 2) #10, !dbg !1406
  %9 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 3) #10, !dbg !1407
  %10 = shl i32 %9, 8, !dbg !1409
  %11 = or i32 %10, %8, !dbg !1410
  store i32 %11, i32* %2, align 4, !dbg !1411, !tbaa !214
  %12 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 4) #10, !dbg !1412
  %13 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 5) #10, !dbg !1413
  %14 = shl i32 %13, 8, !dbg !1414
  %15 = or i32 %14, %12, !dbg !1415
  store i32 %15, i32* %3, align 4, !dbg !1416, !tbaa !214
  br label %27, !dbg !1417

; <label>:16:                                     ; preds = %4
  %17 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !1418, !tbaa !214
  %18 = and i32 %17, -4097, !dbg !1418
  store volatile i32 %18, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !1418, !tbaa !214
  tail call void asm sideeffect "csync", ""() #7, !dbg !1420, !srcloc !1421
  tail call void asm sideeffect "ssync", ""() #7, !dbg !1422, !srcloc !1423
  %19 = load volatile i8, i8* inttoptr (i32 90122 to i8*), align 2, !dbg !1424, !tbaa !692
  %20 = zext i8 %19 to i32, !dbg !1424
  store i32 %20, i32* %1, align 4, !dbg !1425, !tbaa !214
  %21 = load volatile i16, i16* inttoptr (i32 90114 to i16*), align 2, !dbg !1426, !tbaa !1206
  %22 = zext i16 %21 to i32, !dbg !1426
  store i32 %22, i32* %2, align 4, !dbg !1427, !tbaa !214
  %23 = load volatile i16, i16* inttoptr (i32 90116 to i16*), align 4, !dbg !1428, !tbaa !1206
  %24 = zext i16 %23 to i32, !dbg !1428
  store i32 %24, i32* %3, align 4, !dbg !1429, !tbaa !214
  %25 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !1430, !tbaa !214
  %26 = or i32 %25, 4096, !dbg !1430
  store volatile i32 %26, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !1430, !tbaa !214
  br label %27

; <label>:27:                                     ; preds = %16, %6
  tail call void @sys_local_irq_enable() #9, !dbg !1431
  ret void, !dbg !1434
}

; Function Attrs: minsize nounwind optsize
define void @usb_read_intre(i8 zeroext, i32* nocapture, i32* nocapture, i32* nocapture) local_unnamed_addr #3 !dbg !1435 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1437, metadata !173), !dbg !1441
  tail call void @llvm.dbg.value(metadata i32* %1, i64 0, metadata !1438, metadata !173), !dbg !1442
  tail call void @llvm.dbg.value(metadata i32* %2, i64 0, metadata !1439, metadata !173), !dbg !1443
  tail call void @llvm.dbg.value(metadata i32* %3, i64 0, metadata !1440, metadata !173), !dbg !1444
  tail call void @sys_local_irq_disable() #9, !dbg !1445
  %5 = icmp eq i8 %0, 0, !dbg !1448
  br i1 %5, label %6, label %16, !dbg !1450

; <label>:6:                                      ; preds = %4
  %7 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 11) #10, !dbg !1451
  store i32 %7, i32* %1, align 4, !dbg !1453, !tbaa !214
  %8 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 7) #10, !dbg !1454
  %9 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 8) #10, !dbg !1455
  %10 = shl i32 %9, 8, !dbg !1457
  %11 = or i32 %10, %8, !dbg !1458
  store i32 %11, i32* %2, align 4, !dbg !1459, !tbaa !214
  %12 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 9) #10, !dbg !1460
  %13 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 10) #10, !dbg !1461
  %14 = shl i32 %13, 8, !dbg !1463
  %15 = or i32 %14, %12, !dbg !1464
  br label %23, !dbg !1465

; <label>:16:                                     ; preds = %4
  %17 = load volatile i8, i8* inttoptr (i32 90123 to i8*), align 1, !dbg !1466, !tbaa !692
  %18 = zext i8 %17 to i32, !dbg !1466
  store i32 %18, i32* %1, align 4, !dbg !1468, !tbaa !214
  %19 = load volatile i16, i16* inttoptr (i32 90118 to i16*), align 2, !dbg !1469, !tbaa !1206
  %20 = zext i16 %19 to i32, !dbg !1469
  store i32 %20, i32* %2, align 4, !dbg !1470, !tbaa !214
  %21 = load volatile i16, i16* inttoptr (i32 90120 to i16*), align 8, !dbg !1471, !tbaa !1206
  %22 = zext i16 %21 to i32, !dbg !1471
  br label %23

; <label>:23:                                     ; preds = %16, %6
  %24 = phi i32 [ %22, %16 ], [ %15, %6 ]
  store i32 %24, i32* %3, align 4, !dbg !1472, !tbaa !214
  tail call void @sys_local_irq_enable() #9, !dbg !1473
  ret void, !dbg !1476
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_intr_usbe(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1477 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1479, metadata !173), !dbg !1481
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1480, metadata !173), !dbg !1482
  tail call void @sys_local_irq_disable() #9, !dbg !1483
  %3 = icmp eq i8 %0, 0, !dbg !1486
  br i1 %3, label %4, label %5, !dbg !1488

; <label>:4:                                      ; preds = %2
  tail call void @musb_write_usb(i8 zeroext 0, i32 11, i32 %1) #10, !dbg !1489
  br label %7, !dbg !1491

; <label>:5:                                      ; preds = %2
  %6 = trunc i32 %1 to i8, !dbg !1492
  store volatile i8 %6, i8* inttoptr (i32 90123 to i8*), align 1, !dbg !1494, !tbaa !692
  br label %7

; <label>:7:                                      ; preds = %5, %4
  tail call void @sys_local_irq_enable() #9, !dbg !1495
  ret void, !dbg !1498
}

; Function Attrs: minsize nounwind optsize
define void @usb_set_intr_txe(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1499 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1501, metadata !173), !dbg !1504
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1502, metadata !173), !dbg !1505
  tail call void @sys_local_irq_disable() #9, !dbg !1506
  tail call void @llvm.dbg.value(metadata i16 0, i64 0, metadata !1503, metadata !173), !dbg !1509
  %3 = icmp eq i8 %0, 0, !dbg !1510
  br i1 %3, label %4, label %14, !dbg !1512

; <label>:4:                                      ; preds = %2
  %5 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 7) #10, !dbg !1513
  %6 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 8) #10, !dbg !1515
  %7 = shl i32 %6, 8, !dbg !1517
  %8 = shl i32 1, %1, !dbg !1518
  %9 = or i32 %5, %8, !dbg !1519
  %10 = or i32 %9, %7, !dbg !1520
  %11 = and i32 %9, 255, !dbg !1521
  tail call void @musb_write_usb(i8 zeroext 0, i32 7, i32 %11) #10, !dbg !1522
  %12 = lshr i32 %10, 8, !dbg !1523
  %13 = and i32 %12, 255, !dbg !1523
  tail call void @musb_write_usb(i8 zeroext 0, i32 8, i32 %13) #10, !dbg !1524
  br label %20, !dbg !1525

; <label>:14:                                     ; preds = %2
  %15 = load volatile i16, i16* inttoptr (i32 90118 to i16*), align 2, !dbg !1526, !tbaa !1206
  tail call void @llvm.dbg.value(metadata i16 %15, i64 0, metadata !1503, metadata !173), !dbg !1509
  %16 = shl i32 1, %1, !dbg !1528
  %17 = zext i16 %15 to i32, !dbg !1529
  %18 = or i32 %17, %16, !dbg !1529
  %19 = trunc i32 %18 to i16, !dbg !1529
  tail call void @llvm.dbg.value(metadata i16 %19, i64 0, metadata !1503, metadata !173), !dbg !1509
  store volatile i16 %19, i16* inttoptr (i32 90118 to i16*), align 2, !dbg !1530, !tbaa !1206
  br label %20

; <label>:20:                                     ; preds = %14, %4
  tail call void @sys_local_irq_enable() #9, !dbg !1531
  ret void, !dbg !1534
}

; Function Attrs: minsize nounwind optsize
define void @usb_clr_intr_txe(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1535 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1537, metadata !173), !dbg !1540
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1538, metadata !173), !dbg !1541
  tail call void @sys_local_irq_disable() #9, !dbg !1542
  tail call void @llvm.dbg.value(metadata i16 0, i64 0, metadata !1539, metadata !173), !dbg !1545
  %3 = icmp eq i8 %0, 0, !dbg !1546
  br i1 %3, label %4, label %19, !dbg !1548

; <label>:4:                                      ; preds = %2
  %5 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 7) #10, !dbg !1549
  %6 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 8) #10, !dbg !1551
  %7 = icmp eq i32 %1, -1, !dbg !1553
  br i1 %7, label %15, label %8, !dbg !1555

; <label>:8:                                      ; preds = %4
  %9 = shl i32 %6, 8, !dbg !1556
  %10 = or i32 %9, %5, !dbg !1558
  %11 = shl i32 1, %1, !dbg !1559
  %12 = and i32 %11, 65535, !dbg !1561
  %13 = xor i32 %12, 65535, !dbg !1561
  %14 = and i32 %13, %10
  br label %15

; <label>:15:                                     ; preds = %8, %4
  %16 = phi i32 [ %14, %8 ], [ 0, %4 ]
  %17 = and i32 %16, 255, !dbg !1562
  tail call void @musb_write_usb(i8 zeroext 0, i32 7, i32 %17) #10, !dbg !1563
  %18 = lshr i32 %16, 8, !dbg !1564
  tail call void @musb_write_usb(i8 zeroext 0, i32 8, i32 %18) #10, !dbg !1565
  br label %30, !dbg !1566

; <label>:19:                                     ; preds = %2
  %20 = load volatile i16, i16* inttoptr (i32 90118 to i16*), align 2, !dbg !1567, !tbaa !1206
  tail call void @llvm.dbg.value(metadata i16 %20, i64 0, metadata !1539, metadata !173), !dbg !1545
  %21 = icmp eq i32 %1, -1, !dbg !1569
  br i1 %21, label %28, label %22, !dbg !1571

; <label>:22:                                     ; preds = %19
  %23 = shl i32 1, %1, !dbg !1572
  %24 = xor i32 %23, 65535, !dbg !1574
  %25 = zext i16 %20 to i32, !dbg !1575
  %26 = and i32 %25, %24, !dbg !1575
  %27 = trunc i32 %26 to i16, !dbg !1575
  tail call void @llvm.dbg.value(metadata i16 %27, i64 0, metadata !1539, metadata !173), !dbg !1545
  br label %28

; <label>:28:                                     ; preds = %22, %19
  %29 = phi i16 [ %27, %22 ], [ 0, %19 ]
  tail call void @llvm.dbg.value(metadata i16 %29, i64 0, metadata !1539, metadata !173), !dbg !1545
  store volatile i16 %29, i16* inttoptr (i32 90118 to i16*), align 2, !dbg !1576, !tbaa !1206
  br label %30

; <label>:30:                                     ; preds = %28, %15
  tail call void @sys_local_irq_enable() #9, !dbg !1577
  ret void, !dbg !1580
}

; Function Attrs: minsize nounwind optsize
define void @usb_set_intr_rxe(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1581 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1583, metadata !173), !dbg !1586
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1584, metadata !173), !dbg !1587
  tail call void @sys_local_irq_disable() #9, !dbg !1588
  %3 = icmp eq i8 %0, 0, !dbg !1591
  br i1 %3, label %4, label %14, !dbg !1593

; <label>:4:                                      ; preds = %2
  %5 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 9) #10, !dbg !1594
  %6 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 10) #10, !dbg !1596
  %7 = shl i32 %6, 8, !dbg !1598
  %8 = shl i32 1, %1, !dbg !1599
  %9 = or i32 %5, %8, !dbg !1600
  %10 = or i32 %9, %7, !dbg !1601
  %11 = and i32 %9, 255, !dbg !1602
  tail call void @musb_write_usb(i8 zeroext 0, i32 9, i32 %11) #10, !dbg !1603
  %12 = lshr i32 %10, 8, !dbg !1604
  %13 = and i32 %12, 255, !dbg !1604
  tail call void @musb_write_usb(i8 zeroext 0, i32 10, i32 %13) #10, !dbg !1605
  br label %20, !dbg !1606

; <label>:14:                                     ; preds = %2
  %15 = load volatile i16, i16* inttoptr (i32 90120 to i16*), align 8, !dbg !1607, !tbaa !1206
  tail call void @llvm.dbg.value(metadata i16 %15, i64 0, metadata !1585, metadata !173), !dbg !1609
  %16 = shl i32 1, %1, !dbg !1610
  %17 = zext i16 %15 to i32, !dbg !1611
  %18 = or i32 %17, %16, !dbg !1611
  %19 = trunc i32 %18 to i16, !dbg !1611
  tail call void @llvm.dbg.value(metadata i16 %19, i64 0, metadata !1585, metadata !173), !dbg !1609
  store volatile i16 %19, i16* inttoptr (i32 90120 to i16*), align 8, !dbg !1612, !tbaa !1206
  br label %20

; <label>:20:                                     ; preds = %14, %4
  tail call void @sys_local_irq_enable() #9, !dbg !1613
  ret void, !dbg !1616
}

; Function Attrs: minsize nounwind optsize
define void @usb_clr_intr_rxe(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1617 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1619, metadata !173), !dbg !1622
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1620, metadata !173), !dbg !1623
  tail call void @llvm.dbg.value(metadata i16 0, i64 0, metadata !1621, metadata !173), !dbg !1624
  tail call void @sys_local_irq_disable() #9, !dbg !1625
  %3 = icmp eq i8 %0, 0, !dbg !1628
  br i1 %3, label %4, label %19, !dbg !1630

; <label>:4:                                      ; preds = %2
  %5 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 9) #10, !dbg !1631
  %6 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 10) #10, !dbg !1633
  %7 = icmp eq i32 %1, -1, !dbg !1635
  br i1 %7, label %15, label %8, !dbg !1637

; <label>:8:                                      ; preds = %4
  %9 = shl i32 %6, 8, !dbg !1638
  %10 = or i32 %9, %5, !dbg !1640
  %11 = shl i32 1, %1, !dbg !1641
  %12 = and i32 %11, 65535, !dbg !1643
  %13 = xor i32 %12, 65535, !dbg !1643
  %14 = and i32 %13, %10
  br label %15

; <label>:15:                                     ; preds = %8, %4
  %16 = phi i32 [ %14, %8 ], [ 0, %4 ]
  %17 = and i32 %16, 255, !dbg !1644
  tail call void @musb_write_usb(i8 zeroext 0, i32 9, i32 %17) #10, !dbg !1645
  %18 = lshr i32 %16, 8, !dbg !1646
  tail call void @musb_write_usb(i8 zeroext 0, i32 10, i32 %18) #10, !dbg !1647
  br label %30, !dbg !1648

; <label>:19:                                     ; preds = %2
  %20 = load volatile i16, i16* inttoptr (i32 90120 to i16*), align 8, !dbg !1649, !tbaa !1206
  tail call void @llvm.dbg.value(metadata i16 %20, i64 0, metadata !1621, metadata !173), !dbg !1624
  %21 = icmp eq i32 %1, -1, !dbg !1651
  br i1 %21, label %28, label %22, !dbg !1653

; <label>:22:                                     ; preds = %19
  %23 = shl i32 1, %1, !dbg !1654
  %24 = xor i32 %23, 65535, !dbg !1656
  %25 = zext i16 %20 to i32, !dbg !1657
  %26 = and i32 %25, %24, !dbg !1657
  %27 = trunc i32 %26 to i16, !dbg !1657
  tail call void @llvm.dbg.value(metadata i16 %27, i64 0, metadata !1621, metadata !173), !dbg !1624
  br label %28

; <label>:28:                                     ; preds = %22, %19
  %29 = phi i16 [ %27, %22 ], [ 0, %19 ]
  tail call void @llvm.dbg.value(metadata i16 %29, i64 0, metadata !1621, metadata !173), !dbg !1624
  store volatile i16 %29, i16* inttoptr (i32 90120 to i16*), align 8, !dbg !1658, !tbaa !1206
  br label %30

; <label>:30:                                     ; preds = %28, %15
  tail call void @sys_local_irq_enable() #9, !dbg !1659
  ret void, !dbg !1662
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_txcsr(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !1663 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1665, metadata !173), !dbg !1671
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1666, metadata !173), !dbg !1672
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1667, metadata !173), !dbg !1673
  %4 = icmp eq i8 %0, 0, !dbg !1674
  br i1 %4, label %5, label %8, !dbg !1675

; <label>:5:                                      ; preds = %3
  tail call void @sys_local_irq_disable() #9, !dbg !1676
  tail call void @musb_write_index(i8 zeroext 0, i32 %1) #10, !dbg !1680
  %6 = and i32 %2, 255, !dbg !1681
  tail call void @musb_write_usb(i8 zeroext 0, i32 17, i32 %6) #10, !dbg !1682
  %7 = lshr i32 %2, 8, !dbg !1683
  tail call void @musb_write_usb(i8 zeroext 0, i32 18, i32 %7) #10, !dbg !1684
  tail call void @sys_local_irq_enable() #9, !dbg !1685
  br label %12, !dbg !1688

; <label>:8:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !1668, metadata !173), !dbg !1689
  %9 = add i32 %1, -1, !dbg !1690
  %10 = trunc i32 %2 to i16, !dbg !1691
  %11 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %9, i32 1, !dbg !1692
  store volatile i16 %10, i16* %11, align 2, !dbg !1693, !tbaa !590
  tail call void asm sideeffect "csync", ""() #7, !dbg !1694, !srcloc !1695
  tail call void asm sideeffect "ssync", ""() #7, !dbg !1696, !srcloc !1697
  br label %12

; <label>:12:                                     ; preds = %8, %5
  ret void, !dbg !1698
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_rxcsr(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !1699 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1701, metadata !173), !dbg !1707
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1702, metadata !173), !dbg !1708
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1703, metadata !173), !dbg !1709
  %4 = icmp eq i8 %0, 0, !dbg !1710
  br i1 %4, label %5, label %8, !dbg !1711

; <label>:5:                                      ; preds = %3
  tail call void @sys_local_irq_disable() #9, !dbg !1712
  tail call void @musb_write_index(i8 zeroext 0, i32 %1) #10, !dbg !1716
  %6 = and i32 %2, 255, !dbg !1717
  tail call void @musb_write_usb(i8 zeroext 0, i32 20, i32 %6) #10, !dbg !1718
  %7 = lshr i32 %2, 8, !dbg !1719
  tail call void @musb_write_usb(i8 zeroext 0, i32 21, i32 %7) #10, !dbg !1720
  tail call void @sys_local_irq_enable() #9, !dbg !1721
  br label %12, !dbg !1724

; <label>:8:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !1704, metadata !173), !dbg !1725
  %9 = add i32 %1, -1, !dbg !1726
  %10 = trunc i32 %2 to i16, !dbg !1727
  %11 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %9, i32 3, !dbg !1728
  store volatile i16 %10, i16* %11, align 2, !dbg !1729, !tbaa !1730
  tail call void asm sideeffect "csync", ""() #7, !dbg !1731, !srcloc !1732
  tail call void asm sideeffect "ssync", ""() #7, !dbg !1733, !srcloc !1734
  br label %12

; <label>:12:                                     ; preds = %8, %5
  ret void, !dbg !1735
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_read_rxcsr(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1736 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1738, metadata !173), !dbg !1745
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1739, metadata !173), !dbg !1746
  %3 = icmp eq i8 %0, 0, !dbg !1747
  br i1 %3, label %4, label %9, !dbg !1748

; <label>:4:                                      ; preds = %2
  tail call void @sys_local_irq_disable() #9, !dbg !1749
  tail call void @musb_write_index(i8 zeroext 0, i32 %1) #10, !dbg !1752
  %5 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 20) #10, !dbg !1753
  %6 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 21) #10, !dbg !1754
  %7 = shl i32 %6, 8, !dbg !1756
  %8 = or i32 %7, %5, !dbg !1757
  tail call void @llvm.dbg.value(metadata i32 %8, i64 0, metadata !1740, metadata !173), !dbg !1758
  tail call void @sys_local_irq_enable() #9, !dbg !1759
  br label %14

; <label>:9:                                      ; preds = %2
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !1743, metadata !173), !dbg !1762
  %10 = add i32 %1, -1, !dbg !1763
  tail call void asm sideeffect "ssync", ""() #7, !dbg !1764, !srcloc !1765
  %11 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %10, i32 3, !dbg !1766
  %12 = load volatile i16, i16* %11, align 2, !dbg !1766, !tbaa !1730
  %13 = zext i16 %12 to i32, !dbg !1767
  br label %14

; <label>:14:                                     ; preds = %9, %4
  %15 = phi i32 [ %8, %4 ], [ %13, %9 ]
  ret i32 %15, !dbg !1768
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_rxmaxp(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !1769 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1771, metadata !173), !dbg !1777
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1772, metadata !173), !dbg !1778
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1773, metadata !173), !dbg !1779
  %4 = icmp eq i8 %0, 0, !dbg !1780
  br i1 %4, label %5, label %6, !dbg !1781

; <label>:5:                                      ; preds = %3
  tail call void @sys_local_irq_disable() #9, !dbg !1782
  tail call void @musb_write_index(i8 zeroext 0, i32 %1) #10, !dbg !1786
  tail call void @musb_write_usb(i8 zeroext 0, i32 19, i32 %2) #10, !dbg !1787
  tail call void @sys_local_irq_enable() #9, !dbg !1788
  br label %10, !dbg !1791

; <label>:6:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !1774, metadata !173), !dbg !1792
  %7 = add i32 %1, -1, !dbg !1793
  %8 = trunc i32 %2 to i16, !dbg !1794
  %9 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %7, i32 2, !dbg !1795
  store volatile i16 %8, i16* %9, align 4, !dbg !1796, !tbaa !1797
  tail call void asm sideeffect "csync", ""() #7, !dbg !1798, !srcloc !1799
  tail call void asm sideeffect "ssync", ""() #7, !dbg !1800, !srcloc !1801
  br label %10

; <label>:10:                                     ; preds = %6, %5
  ret void, !dbg !1802
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_txmaxp(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !1803 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1805, metadata !173), !dbg !1811
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1806, metadata !173), !dbg !1812
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1807, metadata !173), !dbg !1813
  %4 = icmp eq i8 %0, 0, !dbg !1814
  br i1 %4, label %5, label %6, !dbg !1815

; <label>:5:                                      ; preds = %3
  tail call void @sys_local_irq_disable() #9, !dbg !1816
  tail call void @musb_write_index(i8 zeroext 0, i32 %1) #10, !dbg !1820
  tail call void @musb_write_usb(i8 zeroext 0, i32 16, i32 %2) #10, !dbg !1821
  tail call void @sys_local_irq_enable() #9, !dbg !1822
  br label %10, !dbg !1825

; <label>:6:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !1808, metadata !173), !dbg !1826
  %7 = add i32 %1, -1, !dbg !1827
  %8 = trunc i32 %2 to i16, !dbg !1828
  %9 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %7, i32 0, !dbg !1829
  store volatile i16 %8, i16* %9, align 16, !dbg !1830, !tbaa !1831
  tail call void asm sideeffect "csync", ""() #7, !dbg !1832, !srcloc !1833
  tail call void asm sideeffect "ssync", ""() #7, !dbg !1834, !srcloc !1835
  br label %10

; <label>:10:                                     ; preds = %6, %5
  ret void, !dbg !1836
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_txtype(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !1837 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1842, metadata !173), !dbg !1848
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1843, metadata !173), !dbg !1849
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1844, metadata !173), !dbg !1850
  %4 = icmp eq i8 %0, 0, !dbg !1851
  br i1 %4, label %5, label %6, !dbg !1852

; <label>:5:                                      ; preds = %3
  tail call void @sys_local_irq_disable() #9, !dbg !1853
  tail call void @musb_write_index(i8 zeroext 0, i32 %1) #10, !dbg !1857
  tail call void @musb_write_usb(i8 zeroext 0, i32 24, i32 %2) #10, !dbg !1858
  tail call void @sys_local_irq_enable() #9, !dbg !1859
  br label %10, !dbg !1862

; <label>:6:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !1845, metadata !173), !dbg !1863
  %7 = add i32 %1, -1, !dbg !1864
  %8 = trunc i32 %2 to i8, !dbg !1865
  %9 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %7, i32 5, !dbg !1866
  store volatile i8 %8, i8* %9, align 2, !dbg !1867, !tbaa !1868
  tail call void asm sideeffect "csync", ""() #7, !dbg !1869, !srcloc !1870
  br label %10

; <label>:10:                                     ; preds = %6, %5
  ret void, !dbg !1871
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_rxtype(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !1872 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1876, metadata !173), !dbg !1882
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1877, metadata !173), !dbg !1883
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1878, metadata !173), !dbg !1884
  %4 = icmp eq i8 %0, 0, !dbg !1885
  br i1 %4, label %5, label %6, !dbg !1886

; <label>:5:                                      ; preds = %3
  tail call void @sys_local_irq_disable() #9, !dbg !1887
  tail call void @musb_write_index(i8 zeroext 0, i32 %1) #10, !dbg !1891
  tail call void @musb_write_usb(i8 zeroext 0, i32 26, i32 %2) #10, !dbg !1892
  tail call void @sys_local_irq_enable() #9, !dbg !1893
  br label %10, !dbg !1896

; <label>:6:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !1879, metadata !173), !dbg !1897
  %7 = add i32 %1, -1, !dbg !1898
  %8 = trunc i32 %2 to i8, !dbg !1899
  %9 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %7, i32 7, !dbg !1900
  store volatile i8 %8, i8* %9, align 4, !dbg !1901, !tbaa !1902
  tail call void asm sideeffect "csync", ""() #7, !dbg !1903, !srcloc !1904
  br label %10

; <label>:10:                                     ; preds = %6, %5
  ret void, !dbg !1905
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_txinterval(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !1906 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1908, metadata !173), !dbg !1914
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1909, metadata !173), !dbg !1915
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1910, metadata !173), !dbg !1916
  %4 = icmp eq i8 %0, 0, !dbg !1917
  br i1 %4, label %5, label %6, !dbg !1918

; <label>:5:                                      ; preds = %3
  tail call void @sys_local_irq_disable() #9, !dbg !1919
  tail call void @musb_write_usb(i8 zeroext 0, i32 14, i32 %1) #10, !dbg !1923
  tail call void @musb_write_usb(i8 zeroext 0, i32 25, i32 %2) #10, !dbg !1924
  tail call void @sys_local_irq_enable() #9, !dbg !1925
  br label %10, !dbg !1928

; <label>:6:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !1911, metadata !173), !dbg !1929
  %7 = add i32 %1, -1, !dbg !1930
  %8 = trunc i32 %2 to i8, !dbg !1931
  %9 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %7, i32 6, !dbg !1932
  store volatile i8 %8, i8* %9, align 1, !dbg !1933, !tbaa !1934
  tail call void asm sideeffect "csync", ""() #7, !dbg !1935, !srcloc !1936
  br label %10

; <label>:10:                                     ; preds = %6, %5
  ret void, !dbg !1937
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_rxinterval(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !1938 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1940, metadata !173), !dbg !1946
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1941, metadata !173), !dbg !1947
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !1942, metadata !173), !dbg !1948
  %4 = icmp eq i8 %0, 0, !dbg !1949
  br i1 %4, label %5, label %6, !dbg !1950

; <label>:5:                                      ; preds = %3
  tail call void @sys_local_irq_disable() #9, !dbg !1951
  tail call void @musb_write_usb(i8 zeroext 0, i32 14, i32 %1) #10, !dbg !1955
  tail call void @musb_write_usb(i8 zeroext 0, i32 27, i32 %2) #10, !dbg !1956
  tail call void @sys_local_irq_enable() #9, !dbg !1957
  br label %10, !dbg !1960

; <label>:6:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !1943, metadata !173), !dbg !1961
  %7 = add i32 %1, -1, !dbg !1962
  %8 = trunc i32 %2 to i8, !dbg !1963
  %9 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %7, i32 8, !dbg !1964
  store volatile i8 %8, i8* %9, align 1, !dbg !1965, !tbaa !1966
  tail call void asm sideeffect "csync", ""() #7, !dbg !1967, !srcloc !1968
  br label %10

; <label>:10:                                     ; preds = %6, %5
  ret void, !dbg !1969
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_read_rxcount(i8 zeroext, i32) local_unnamed_addr #3 !dbg !1970 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1972, metadata !173), !dbg !1980
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1973, metadata !173), !dbg !1981
  %3 = icmp eq i8 %0, 0, !dbg !1982
  br i1 %3, label %4, label %15, !dbg !1983

; <label>:4:                                      ; preds = %2
  tail call void @sys_local_irq_disable() #9, !dbg !1984
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !1974, metadata !173), !dbg !1987
  tail call void @musb_write_index(i8 zeroext 0, i32 %1) #10, !dbg !1988
  %5 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 20) #10, !dbg !1989
  %6 = and i32 %5, 1, !dbg !1991
  %7 = icmp eq i32 %6, 0, !dbg !1991
  br i1 %7, label %13, label %8, !dbg !1992

; <label>:8:                                      ; preds = %4
  %9 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 22) #10, !dbg !1993
  %10 = tail call i32 @musb_read_usb(i8 zeroext 0, i32 23) #10, !dbg !1995
  %11 = shl i32 %10, 8, !dbg !1997
  %12 = or i32 %11, %9, !dbg !1998
  tail call void @llvm.dbg.value(metadata i32 %12, i64 0, metadata !1974, metadata !173), !dbg !1987
  br label %13, !dbg !1999

; <label>:13:                                     ; preds = %8, %4
  %14 = phi i32 [ %12, %8 ], [ 0, %4 ]
  tail call void @llvm.dbg.value(metadata i32 %14, i64 0, metadata !1974, metadata !173), !dbg !1987
  tail call void @sys_local_irq_enable() #9, !dbg !2000
  br label %25

; <label>:15:                                     ; preds = %2
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !1977, metadata !173), !dbg !2003
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !1979, metadata !173), !dbg !2004
  %16 = add i32 %1, -1, !dbg !2005
  tail call void asm sideeffect "ssync", ""() #7, !dbg !2006, !srcloc !2007
  %17 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %16, i32 3, !dbg !2008
  %18 = load volatile i16, i16* %17, align 2, !dbg !2008, !tbaa !1730
  %19 = and i16 %18, 1, !dbg !2010
  %20 = icmp eq i16 %19, 0, !dbg !2010
  br i1 %20, label %25, label %21, !dbg !2011

; <label>:21:                                     ; preds = %15
  %22 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %16, i32 4, !dbg !2012
  %23 = load volatile i16, i16* %22, align 8, !dbg !2012, !tbaa !2014
  %24 = zext i16 %23 to i32, !dbg !2015
  tail call void @llvm.dbg.value(metadata i32 %24, i64 0, metadata !1977, metadata !173), !dbg !2003
  br label %25, !dbg !2016

; <label>:25:                                     ; preds = %21, %15, %13
  %26 = phi i32 [ %14, %13 ], [ %24, %21 ], [ 0, %15 ]
  ret i32 %26, !dbg !2017
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_txfuncaddr(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !2018 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2022, metadata !173), !dbg !2028
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2023, metadata !173), !dbg !2029
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2024, metadata !173), !dbg !2030
  %4 = icmp eq i8 %0, 1, !dbg !2031
  br i1 %4, label %5, label %8, !dbg !2032

; <label>:5:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_func_reg_t* inttoptr (i32 90240 to %struct.husb_func_reg_t*), i64 0, metadata !2025, metadata !173), !dbg !2033
  %6 = trunc i32 %2 to i8, !dbg !2034
  %7 = getelementptr inbounds %struct.husb_func_reg_t, %struct.husb_func_reg_t* inttoptr (i32 90240 to %struct.husb_func_reg_t*), i32 %1, i32 0, !dbg !2035
  store volatile i8 %6, i8* %7, align 8, !dbg !2036, !tbaa !2037
  tail call void asm sideeffect "csync", ""() #7, !dbg !2039, !srcloc !2040
  br label %8, !dbg !2041

; <label>:8:                                      ; preds = %5, %3
  ret void, !dbg !2042
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_rxfuncaddr(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !2043 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2045, metadata !173), !dbg !2051
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2046, metadata !173), !dbg !2052
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2047, metadata !173), !dbg !2053
  %4 = icmp eq i8 %0, 1, !dbg !2054
  br i1 %4, label %5, label %8, !dbg !2055

; <label>:5:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_func_reg_t* inttoptr (i32 90240 to %struct.husb_func_reg_t*), i64 0, metadata !2048, metadata !173), !dbg !2056
  %6 = trunc i32 %2 to i8, !dbg !2057
  %7 = getelementptr inbounds %struct.husb_func_reg_t, %struct.husb_func_reg_t* inttoptr (i32 90240 to %struct.husb_func_reg_t*), i32 %1, i32 4, !dbg !2058
  store volatile i8 %6, i8* %7, align 4, !dbg !2059, !tbaa !2060
  tail call void asm sideeffect "csync", ""() #7, !dbg !2061, !srcloc !2062
  br label %8, !dbg !2063

; <label>:8:                                      ; preds = %5, %3
  ret void, !dbg !2064
}

; Function Attrs: minsize nounwind optsize
define void @usb_write_fifosize(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !2065 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2067, metadata !173), !dbg !2073
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2068, metadata !173), !dbg !2074
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2069, metadata !173), !dbg !2075
  %4 = icmp eq i8 %0, 1, !dbg !2076
  br i1 %4, label %5, label %9, !dbg !2077

; <label>:5:                                      ; preds = %3
  tail call void @llvm.dbg.value(metadata %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i64 0, metadata !2070, metadata !173), !dbg !2078
  %6 = add i32 %1, -1, !dbg !2079
  %7 = trunc i32 %2 to i8, !dbg !2080
  %8 = getelementptr inbounds %struct.husb_ep_reg_t, %struct.husb_ep_reg_t* inttoptr (i32 90384 to %struct.husb_ep_reg_t*), i32 %6, i32 10, !dbg !2081
  store volatile i8 %7, i8* %8, align 1, !dbg !2082, !tbaa !2083
  br label %9, !dbg !2084

; <label>:9:                                      ; preds = %5, %3
  ret void, !dbg !2085
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_ep_read64byte_fast(i8 zeroext, i32, i8*, i32) local_unnamed_addr #3 !dbg !2086 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2090, metadata !173), !dbg !2100
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2091, metadata !173), !dbg !2101
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !2092, metadata !173), !dbg !2102
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !2093, metadata !173), !dbg !2103
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2094, metadata !173), !dbg !2104
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2095, metadata !173), !dbg !2105
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2097, metadata !173), !dbg !2106
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2098, metadata !173), !dbg !2107
  %5 = load volatile i32, i32* @jiffies, align 4, !dbg !2108, !tbaa !193
  %6 = lshr i32 %3, 6, !dbg !2110
  tail call void @llvm.dbg.value(metadata i32 %7, i64 0, metadata !2099, metadata !173), !dbg !2111
  %7 = add nuw nsw i32 %6, 201, !dbg !2112
  %8 = add i32 %7, %5, !dbg !2113
  tail call void @llvm.dbg.value(metadata i32 %8, i64 0, metadata !2099, metadata !173), !dbg !2111
  br label %9, !dbg !2114

; <label>:9:                                      ; preds = %31, %4
  %10 = phi i32 [ %33, %31 ], [ %3, %4 ]
  %11 = phi i32 [ %34, %31 ], [ 0, %4 ]
  %12 = phi i8* [ %32, %31 ], [ %2, %4 ]
  %13 = icmp eq i32 %10, 0
  br label %14, !dbg !2102

; <label>:14:                                     ; preds = %28, %9
  tail call void @llvm.dbg.value(metadata i8* %12, i64 0, metadata !2092, metadata !173), !dbg !2102
  tail call void @llvm.dbg.value(metadata i32 %11, i64 0, metadata !2094, metadata !173), !dbg !2104
  tail call void @llvm.dbg.value(metadata i32 %10, i64 0, metadata !2093, metadata !173), !dbg !2103
  br i1 %13, label %35, label %15, !dbg !2115

; <label>:15:                                     ; preds = %14
  %16 = load volatile i32, i32* @jiffies, align 4, !dbg !2117, !tbaa !193
  %17 = icmp slt i32 %8, %16, !dbg !2122
  br i1 %17, label %18, label %19, !dbg !2123

; <label>:18:                                     ; preds = %15
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.3, i32 0, i32 0)) #9, !dbg !2124
  br label %36, !dbg !2127

; <label>:19:                                     ; preds = %15
  tail call void @sys_local_irq_disable() #9, !dbg !2128
  tail call void @musb_write_index(i8 zeroext %0, i32 %1) #10, !dbg !2131
  %20 = tail call i32 @musb_read_usb(i8 zeroext %0, i32 20) #10, !dbg !2132
  tail call void @llvm.dbg.value(metadata i32 %20, i64 0, metadata !2098, metadata !173), !dbg !2107
  %21 = and i32 %20, 1, !dbg !2133
  %22 = icmp eq i32 %21, 0, !dbg !2133
  br i1 %22, label %28, label %23, !dbg !2135

; <label>:23:                                     ; preds = %19
  tail call void @llvm.dbg.value(metadata i32 64, i64 0, metadata !2097, metadata !173), !dbg !2106
  %24 = tail call i8* @usb_get_dma_raddr(i8 zeroext %0, i32 %1) #10, !dbg !2136
  tail call void @llvm.dbg.value(metadata i8* %24, i64 0, metadata !2096, metadata !173), !dbg !2137
  %25 = and i32 %20, 139, !dbg !2138
  %26 = or i32 %25, 16, !dbg !2138
  tail call void @musb_write_usb(i8 zeroext %0, i32 20, i32 %26) #10, !dbg !2139
  tail call void @sys_local_irq_enable() #9, !dbg !2140
  %27 = icmp eq i8* %12, null, !dbg !2143
  br i1 %27, label %31, label %29, !dbg !2145

; <label>:28:                                     ; preds = %19
  tail call void @sys_local_irq_enable() #9, !dbg !2146
  br label %14, !dbg !2150, !llvm.loop !2151

; <label>:29:                                     ; preds = %23
  tail call void asm sideeffect "ssync", ""() #7, !dbg !2153, !srcloc !2155
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull %12, i8* %24, i32 64, i32 1, i1 false), !dbg !2156
  %30 = getelementptr inbounds i8, i8* %12, i32 64, !dbg !2157
  tail call void @llvm.dbg.value(metadata i8* %30, i64 0, metadata !2092, metadata !173), !dbg !2102
  br label %31, !dbg !2158

; <label>:31:                                     ; preds = %29, %23
  %32 = phi i8* [ %30, %29 ], [ null, %23 ]
  tail call void @llvm.dbg.value(metadata i8* %32, i64 0, metadata !2092, metadata !173), !dbg !2102
  %33 = add i32 %10, -64, !dbg !2159
  tail call void @llvm.dbg.value(metadata i32 %33, i64 0, metadata !2093, metadata !173), !dbg !2103
  %34 = add i32 %11, 64, !dbg !2160
  tail call void @llvm.dbg.value(metadata i32 %34, i64 0, metadata !2094, metadata !173), !dbg !2104
  br label %9, !dbg !2161, !llvm.loop !2151

; <label>:35:                                     ; preds = %14
  br label %36, !dbg !2163

; <label>:36:                                     ; preds = %35, %18
  %37 = phi i32 [ 0, %18 ], [ %11, %35 ]
  ret i32 %37, !dbg !2164
}

; Function Attrs: minsize optsize
declare void @log_print(i32, i8*, i8*, ...) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_ep_read(i8 zeroext, i32, i8*, i32, i32) local_unnamed_addr #3 !dbg !2165 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2169, metadata !173), !dbg !2189
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2170, metadata !173), !dbg !2190
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !2171, metadata !173), !dbg !2191
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !2172, metadata !173), !dbg !2192
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !2173, metadata !173), !dbg !2193
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2174, metadata !173), !dbg !2194
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2175, metadata !173), !dbg !2195
  tail call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !2177, metadata !173), !dbg !2196
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !2178, metadata !173), !dbg !2197
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2179, metadata !173), !dbg !2198
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2180, metadata !173), !dbg !2199
  %6 = zext i8 %0 to i32, !dbg !2200
  %7 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %6, !dbg !2200
  %8 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %7, align 4, !dbg !2200, !tbaa !244
  %9 = icmp eq %struct.usb_ep_addr_t* %8, null, !dbg !2200
  br i1 %9, label %10, label %13, !dbg !2202

; <label>:10:                                     ; preds = %5
  %11 = load volatile i32, i32* @jiffies, align 4, !dbg !2203, !tbaa !193
  %12 = add i32 %11, 20, !dbg !2206
  tail call void @llvm.dbg.value(metadata i32 %12, i64 0, metadata !2179, metadata !173), !dbg !2198
  tail call void @llvm.dbg.value(metadata i32 %21, i64 0, metadata !2179, metadata !173), !dbg !2198
  br label %27, !dbg !2207

; <label>:13:                                     ; preds = %5
  %14 = add i32 %1, -1, !dbg !2208
  %15 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %8, i32 0, i32 7, i32 %14, !dbg !2210
  %16 = load i32, i32* %15, align 4, !dbg !2210, !tbaa !214
  tail call void @llvm.dbg.value(metadata i32 %16, i64 0, metadata !2180, metadata !173), !dbg !2199
  %17 = load volatile i32, i32* @jiffies, align 4, !dbg !2211, !tbaa !193
  %18 = udiv i32 %3, %16, !dbg !2213
  %19 = shl i32 %18, 1, !dbg !2214
  tail call void @llvm.dbg.value(metadata i32 %20, i64 0, metadata !2179, metadata !173), !dbg !2198
  %20 = add i32 %17, 200, !dbg !2215
  %21 = add i32 %20, %19, !dbg !2216
  tail call void @llvm.dbg.value(metadata i32 %21, i64 0, metadata !2179, metadata !173), !dbg !2198
  tail call void @llvm.dbg.value(metadata i32 %21, i64 0, metadata !2179, metadata !173), !dbg !2198
  %22 = add i32 %1, -1, !dbg !2217
  %23 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %8, i32 0, i32 5, i32 %22, !dbg !2221
  %24 = load i32, i32* %23, align 4, !dbg !2221, !tbaa !214
  %25 = icmp ne i32 %24, 0
  %26 = zext i1 %25 to i8
  br label %27

; <label>:27:                                     ; preds = %13, %10
  %28 = phi i32 [ %21, %13 ], [ %12, %10 ]
  %29 = phi i8 [ %26, %13 ], [ 0, %10 ]
  tail call void @llvm.dbg.value(metadata i8 %29, i64 0, metadata !2178, metadata !173), !dbg !2197
  %30 = icmp eq i32 %3, 0, !dbg !2222
  br i1 %30, label %73, label %31, !dbg !2222

; <label>:31:                                     ; preds = %27
  %32 = icmp eq i32 %4, 0
  %33 = icmp ne i8 %29, 0
  br label %34, !dbg !2191

; <label>:34:                                     ; preds = %68, %31
  %35 = phi i32 [ 0, %31 ], [ %70, %68 ]
  %36 = phi i32 [ %3, %31 ], [ %69, %68 ]
  %37 = phi i8* [ %2, %31 ], [ %65, %68 ]
  br label %38, !dbg !2224

; <label>:38:                                     ; preds = %45, %34
  tail call void @llvm.dbg.value(metadata i8* %37, i64 0, metadata !2171, metadata !173), !dbg !2191
  tail call void @llvm.dbg.value(metadata i32 %36, i64 0, metadata !2172, metadata !173), !dbg !2192
  tail call void @llvm.dbg.value(metadata i32 %35, i64 0, metadata !2174, metadata !173), !dbg !2194
  %39 = load volatile i32, i32* @jiffies, align 4, !dbg !2225, !tbaa !193
  %40 = icmp slt i32 %28, %39, !dbg !2229
  br i1 %40, label %41, label %42, !dbg !2230

; <label>:41:                                     ; preds = %38
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.4, i32 0, i32 0)) #9, !dbg !2231
  br label %73, !dbg !2234

; <label>:42:                                     ; preds = %38
  %43 = tail call i32 @usb_read_rxcount(i8 zeroext %0, i32 %1) #10, !dbg !2235
  tail call void @llvm.dbg.value(metadata i32 %43, i64 0, metadata !2181, metadata !173), !dbg !2236
  %44 = icmp eq i32 %43, 0, !dbg !2237
  br i1 %44, label %45, label %52, !dbg !2238

; <label>:45:                                     ; preds = %42
  br i1 %32, label %46, label %38, !dbg !2239, !llvm.loop !2240

; <label>:46:                                     ; preds = %45
  %47 = tail call i32 @usb_read_rxcsr(i8 zeroext %0, i32 %1) #10, !dbg !2243
  tail call void @llvm.dbg.value(metadata i32 %47, i64 0, metadata !2183, metadata !173), !dbg !2244
  %48 = and i32 %47, 16384, !dbg !2245
  %49 = icmp eq i32 %48, 0, !dbg !2245
  br i1 %49, label %73, label %50, !dbg !2247

; <label>:50:                                     ; preds = %46
  %51 = or i32 %47, 16, !dbg !2248
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %1, i32 %51) #10, !dbg !2250
  br label %73, !dbg !2251

; <label>:52:                                     ; preds = %42
  %53 = icmp ugt i32 %43, %36, !dbg !2252
  tail call void @llvm.dbg.value(metadata i32 %36, i64 0, metadata !2181, metadata !173), !dbg !2236
  %54 = select i1 %53, i32 %36, i32 %43, !dbg !2254
  tail call void @llvm.dbg.value(metadata i32 %54, i64 0, metadata !2181, metadata !173), !dbg !2236
  %55 = tail call i32 @usb_read_rxcsr(i8 zeroext %0, i32 %1) #10, !dbg !2255
  tail call void @llvm.dbg.value(metadata i32 %55, i64 0, metadata !2188, metadata !173), !dbg !2256
  %56 = tail call i8* @usb_get_dma_raddr(i8 zeroext %0, i32 %1) #10, !dbg !2257
  tail call void @llvm.dbg.value(metadata i8* %56, i64 0, metadata !2176, metadata !173), !dbg !2258
  %57 = and i32 %55, -357, !dbg !2259
  tail call void @llvm.dbg.value(metadata i32 %57, i64 0, metadata !2188, metadata !173), !dbg !2256
  tail call void @llvm.dbg.value(metadata i32 %57, i64 0, metadata !2188, metadata !173), !dbg !2256
  br i1 %33, label %58, label %60, !dbg !2262

; <label>:58:                                     ; preds = %52
  %59 = or i32 %57, 16, !dbg !2263
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %1, i32 %59) #10, !dbg !2266
  br label %60, !dbg !2267

; <label>:60:                                     ; preds = %58, %52
  %61 = icmp eq i8* %37, null, !dbg !2268
  br i1 %61, label %64, label %62, !dbg !2270

; <label>:62:                                     ; preds = %60
  tail call void asm sideeffect "ssync", ""() #7, !dbg !2271, !srcloc !2273
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull %37, i8* %56, i32 %54, i32 1, i1 false), !dbg !2274
  %63 = getelementptr inbounds i8, i8* %37, i32 %54, !dbg !2275
  tail call void @llvm.dbg.value(metadata i8* %63, i64 0, metadata !2171, metadata !173), !dbg !2191
  br label %64, !dbg !2276

; <label>:64:                                     ; preds = %62, %60
  %65 = phi i8* [ %63, %62 ], [ null, %60 ]
  tail call void @llvm.dbg.value(metadata i8* %65, i64 0, metadata !2171, metadata !173), !dbg !2191
  br i1 %33, label %68, label %66, !dbg !2277

; <label>:66:                                     ; preds = %64
  %67 = or i32 %57, 16, !dbg !2278
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %1, i32 %67) #10, !dbg !2281
  br label %68, !dbg !2282

; <label>:68:                                     ; preds = %66, %64
  %69 = sub i32 %36, %54, !dbg !2283
  tail call void @llvm.dbg.value(metadata i32 %69, i64 0, metadata !2172, metadata !173), !dbg !2192
  %70 = add i32 %54, %35, !dbg !2284
  tail call void @llvm.dbg.value(metadata i32 %70, i64 0, metadata !2174, metadata !173), !dbg !2194
  tail call void @llvm.dbg.value(metadata i8* %65, i64 0, metadata !2171, metadata !173), !dbg !2191
  tail call void @llvm.dbg.value(metadata i32 %69, i64 0, metadata !2172, metadata !173), !dbg !2192
  tail call void @llvm.dbg.value(metadata i32 %70, i64 0, metadata !2174, metadata !173), !dbg !2194
  %71 = icmp eq i32 %69, 0, !dbg !2222
  br i1 %71, label %72, label %34

; <label>:72:                                     ; preds = %68
  br label %73, !dbg !2285

; <label>:73:                                     ; preds = %72, %50, %46, %41, %27
  %74 = phi i32 [ 0, %41 ], [ 0, %27 ], [ %35, %46 ], [ %35, %50 ], [ %70, %72 ]
  ret i32 %74, !dbg !2286
}

; Function Attrs: minsize nounwind optsize
define void @usb_g_tx_flushfifo(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !2287 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2289, metadata !173), !dbg !2293
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2290, metadata !173), !dbg !2294
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2291, metadata !173), !dbg !2295
  tail call void @usb_write_ep_cnt(i8 zeroext %0, i32 %1, i32 %2) #10, !dbg !2296
  %4 = tail call i32 @usb_read_txcsr(i8 zeroext %0, i32 %1) #10, !dbg !2297
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !2292, metadata !173), !dbg !2298
  %5 = or i32 %4, 1, !dbg !2299
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !2292, metadata !173), !dbg !2298
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %1, i32 %5) #10, !dbg !2300
  ret void, !dbg !2301
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_ep_write(i8 zeroext, i32, i8* readonly, i32) local_unnamed_addr #3 !dbg !2302 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2306, metadata !173), !dbg !2319
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2307, metadata !173), !dbg !2320
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !2308, metadata !173), !dbg !2321
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !2309, metadata !173), !dbg !2322
  %5 = tail call i8* @usb_get_dma_taddr(i8 zeroext %0, i32 %1) #10, !dbg !2323
  tail call void @llvm.dbg.value(metadata i8* %5, i64 0, metadata !2310, metadata !173), !dbg !2324
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !2312, metadata !173), !dbg !2325
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2313, metadata !173), !dbg !2326
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2314, metadata !173), !dbg !2327
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !2315, metadata !173), !dbg !2328
  %6 = tail call i32 @usb_get_dma_size(i8 zeroext %0, i32 %1) #10, !dbg !2329
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !2316, metadata !173), !dbg !2330
  %7 = zext i8 %0 to i32, !dbg !2331
  %8 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %7, !dbg !2331
  %9 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %8, align 4, !dbg !2331, !tbaa !244
  %10 = icmp eq %struct.usb_ep_addr_t* %9, null, !dbg !2331
  br i1 %10, label %20, label %11, !dbg !2333

; <label>:11:                                     ; preds = %4
  %12 = add i32 %1, -1, !dbg !2334
  %13 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %9, i32 0, i32 6, i32 %12, !dbg !2336
  %14 = load i32, i32* %13, align 4, !dbg !2336, !tbaa !214
  tail call void @llvm.dbg.value(metadata i32 %14, i64 0, metadata !2314, metadata !173), !dbg !2327
  %15 = load volatile i32, i32* @jiffies, align 4, !dbg !2337, !tbaa !193
  %16 = udiv i32 %3, %14, !dbg !2339
  %17 = shl i32 %16, 1, !dbg !2340
  tail call void @llvm.dbg.value(metadata i32 %18, i64 0, metadata !2313, metadata !173), !dbg !2326
  %18 = add i32 %15, 200, !dbg !2341
  %19 = add i32 %18, %17, !dbg !2342
  tail call void @llvm.dbg.value(metadata i32 %19, i64 0, metadata !2313, metadata !173), !dbg !2326
  br label %23, !dbg !2343, !llvm.loop !2344

; <label>:20:                                     ; preds = %4
  %21 = load volatile i32, i32* @jiffies, align 4, !dbg !2347, !tbaa !193
  %22 = add i32 %21, 20, !dbg !2350
  tail call void @llvm.dbg.value(metadata i32 %22, i64 0, metadata !2313, metadata !173), !dbg !2326
  br label %23, !llvm.loop !2344

; <label>:23:                                     ; preds = %20, %11
  %24 = phi i32 [ %22, %20 ], [ %19, %11 ]
  br label %25, !dbg !2321

; <label>:25:                                     ; preds = %56, %23
  %26 = phi i32 [ %58, %56 ], [ %3, %23 ]
  %27 = phi i8* [ %57, %56 ], [ %2, %23 ]
  tail call void @llvm.dbg.value(metadata i8* %27, i64 0, metadata !2308, metadata !173), !dbg !2321
  tail call void @llvm.dbg.value(metadata i32 %26, i64 0, metadata !2309, metadata !173), !dbg !2322
  tail call void @llvm.dbg.value(metadata i32 %24, i64 0, metadata !2313, metadata !173), !dbg !2326
  br label %28, !dbg !2351

; <label>:28:                                     ; preds = %44, %25
  %29 = load volatile i32, i32* @jiffies, align 4, !dbg !2352, !tbaa !193
  %30 = icmp slt i32 %24, %29, !dbg !2356
  br i1 %30, label %31, label %32, !dbg !2357

; <label>:31:                                     ; preds = %28
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.5, i32 0, i32 0)) #9, !dbg !2358
  br label %62, !dbg !2361

; <label>:32:                                     ; preds = %28
  %33 = tail call i32 @usb_read_txcsr(i8 zeroext %0, i32 %1) #10, !dbg !2362
  tail call void @llvm.dbg.value(metadata i32 %33, i64 0, metadata !2311, metadata !173), !dbg !2363
  %34 = and i32 %33, 1, !dbg !2364
  %35 = icmp eq i32 %34, 0, !dbg !2366
  br i1 %35, label %50, label %36, !dbg !2367

; <label>:36:                                     ; preds = %32
  %37 = and i32 %33, 16384, !dbg !2368
  %38 = icmp eq i32 %37, 0, !dbg !2368
  %39 = and i32 %33, 16386, !dbg !2372
  %40 = icmp eq i32 %39, 16386, !dbg !2372
  br i1 %40, label %60, label %41, !dbg !2372

; <label>:41:                                     ; preds = %36
  %42 = trunc i32 %33 to i8, !dbg !2373
  %43 = icmp slt i8 %42, 0, !dbg !2373
  br i1 %43, label %45, label %44, !dbg !2375

; <label>:44:                                     ; preds = %45, %41
  br label %28, !dbg !2376, !llvm.loop !2378

; <label>:45:                                     ; preds = %41
  %46 = tail call i32 @putchar(i32 116) #10, !dbg !2380
  %47 = and i32 %33, -129, !dbg !2382
  tail call void @llvm.dbg.value(metadata i32 %47, i64 0, metadata !2311, metadata !173), !dbg !2363
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %1, i32 %47) #10, !dbg !2383
  br i1 %38, label %44, label %48, !dbg !2384

; <label>:48:                                     ; preds = %45
  %49 = or i32 %47, 1, !dbg !2385
  tail call void @llvm.dbg.value(metadata i32 %49, i64 0, metadata !2311, metadata !173), !dbg !2363
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %1, i32 %49) #10, !dbg !2388
  br label %62, !dbg !2389

; <label>:50:                                     ; preds = %32
  %51 = icmp ult i32 %6, %26, !dbg !2390
  %52 = select i1 %51, i32 %6, i32 %26, !dbg !2390
  tail call void @llvm.dbg.value(metadata i32 %52, i64 0, metadata !2317, metadata !173), !dbg !2391
  %53 = icmp eq i8* %27, null, !dbg !2392
  br i1 %53, label %56, label %54, !dbg !2394

; <label>:54:                                     ; preds = %50
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %5, i8* nonnull %27, i32 %52, i32 1, i1 false), !dbg !2395
  tail call void asm sideeffect "csync", ""() #7, !dbg !2397, !srcloc !2398
  %55 = getelementptr inbounds i8, i8* %27, i32 %52, !dbg !2399
  tail call void @llvm.dbg.value(metadata i8* %55, i64 0, metadata !2308, metadata !173), !dbg !2321
  br label %56, !dbg !2400

; <label>:56:                                     ; preds = %54, %50
  %57 = phi i8* [ %55, %54 ], [ null, %50 ]
  tail call void @llvm.dbg.value(metadata i8* %57, i64 0, metadata !2308, metadata !173), !dbg !2321
  tail call void @usb_set_dma_taddr(i8 zeroext %0, i32 %1, i8* %5) #10, !dbg !2401
  tail call void @usb_g_tx_flushfifo(i8 zeroext %0, i32 %1, i32 %52) #10, !dbg !2402
  %58 = sub i32 %26, %52, !dbg !2403
  tail call void @llvm.dbg.value(metadata i32 %58, i64 0, metadata !2309, metadata !173), !dbg !2322
  %59 = icmp eq i32 %58, 0, !dbg !2404
  br i1 %59, label %61, label %25, !dbg !2404, !llvm.loop !2344

; <label>:60:                                     ; preds = %36
  br label %62, !dbg !2406

; <label>:61:                                     ; preds = %56
  br label %62, !dbg !2407

; <label>:62:                                     ; preds = %61, %60, %48, %31
  %63 = phi i32 [ 0, %31 ], [ 0, %48 ], [ 0, %60 ], [ %3, %61 ]
  ret i32 %63, !dbg !2409
}

; Function Attrs: minsize nounwind optsize
declare i32 @putchar(i32) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_ep_config(i8 zeroext, i32, i32, i32, i8*, i32) local_unnamed_addr #3 !dbg !2411 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2415, metadata !173), !dbg !2435
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2416, metadata !173), !dbg !2436
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2417, metadata !173), !dbg !2437
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !2418, metadata !173), !dbg !2438
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !2419, metadata !173), !dbg !2439
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !2420, metadata !173), !dbg !2440
  %7 = trunc i32 %1 to i8, !dbg !2441
  %8 = icmp slt i8 %7, 0, !dbg !2441
  br i1 %8, label %9, label %31, !dbg !2442

; <label>:9:                                      ; preds = %6
  %10 = and i32 %1, 15, !dbg !2443
  tail call void @llvm.dbg.value(metadata i32 %10, i64 0, metadata !2416, metadata !173), !dbg !2436
  tail call void @usb_set_dma_taddr(i8 zeroext %0, i32 %10, i8* %4) #10, !dbg !2444
  tail call void @usb_set_dma_tsize(i8 zeroext %0, i32 %10, i32 %5) #10, !dbg !2445
  tail call void @usb_write_txmaxp(i8 zeroext %0, i32 %10, i32 1023) #10, !dbg !2446
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %10, i32 72) #10, !dbg !2447
  %11 = icmp eq i32 %2, 1, !dbg !2448
  br i1 %11, label %12, label %27, !dbg !2449

; <label>:12:                                     ; preds = %9
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %10, i32 16384) #10, !dbg !2450
  %13 = icmp ne i8 %0, 0, !dbg !2451
  %14 = add nsw i32 %10, -3, !dbg !2452
  %15 = icmp ult i32 %14, 2, !dbg !2452
  %16 = and i1 %13, %15, !dbg !2454
  br i1 %16, label %17, label %27, !dbg !2454

; <label>:17:                                     ; preds = %12
  %18 = icmp eq i32 %10, 3, !dbg !2455
  %19 = and i32 %5, 2047, !dbg !2456
  %20 = lshr i32 %5, 11, !dbg !2457
  %21 = and i32 %20, 3, !dbg !2458
  %22 = add nuw nsw i32 %21, 1, !dbg !2459
  %23 = mul nuw nsw i32 %22, %19, !dbg !2460
  tail call void @llvm.dbg.value(metadata i32 %23, i64 0, metadata !2421, metadata !173), !dbg !2461
  tail call void @usb_set_dma_tsize(i8 zeroext %0, i32 %10, i32 %23) #10, !dbg !2462
  tail call void @usb_write_txmaxp(i8 zeroext %0, i32 %10, i32 %5) #10, !dbg !2463
  %24 = select i1 %18, i32* inttoptr (i32 92240 to i32*), i32* inttoptr (i32 92244 to i32*), !dbg !2464
  %25 = load volatile i32, i32* %24, align 4, !tbaa !214
  %26 = or i32 %25, 1
  store volatile i32 %26, i32* %24, align 4, !tbaa !214
  br label %27, !dbg !2465

; <label>:27:                                     ; preds = %17, %12, %9
  %28 = icmp eq i32 %3, 0, !dbg !2466
  br i1 %28, label %30, label %29, !dbg !2468

; <label>:29:                                     ; preds = %27
  tail call void @usb_set_intr_txe(i8 zeroext %0, i32 %10) #10, !dbg !2469
  br label %55, !dbg !2471

; <label>:30:                                     ; preds = %27
  tail call void @usb_clr_intr_txe(i8 zeroext %0, i32 %10) #10, !dbg !2472
  br label %55

; <label>:31:                                     ; preds = %6
  tail call void @usb_set_dma_raddr(i8 zeroext %0, i32 %1, i8* %4) #10, !dbg !2474
  tail call void @usb_set_dma_rsize(i8 zeroext %0, i32 %1, i32 %5) #10, !dbg !2475
  tail call void @usb_write_rxmaxp(i8 zeroext %0, i32 %1, i32 1023) #10, !dbg !2476
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %1, i32 144) #10, !dbg !2477
  %32 = icmp eq i32 %2, 2, !dbg !2478
  br i1 %32, label %33, label %34, !dbg !2479

; <label>:33:                                     ; preds = %31
  tail call void @usb_set_dma_dual_raddr(i8 zeroext %0, i32 %1, i8* %4) #10, !dbg !2480
  br label %51, !dbg !2482

; <label>:34:                                     ; preds = %31
  %35 = icmp eq i32 %2, 1, !dbg !2483
  tail call void @usb_set_dma_dual_raddr(i8 zeroext %0, i32 %1, i8* null) #10, !dbg !2485
  br i1 %35, label %36, label %51, !dbg !2486

; <label>:36:                                     ; preds = %34
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %1, i32 16384) #10, !dbg !2488
  %37 = icmp ne i8 %0, 0, !dbg !2489
  %38 = add i32 %1, -3, !dbg !2490
  %39 = icmp ult i32 %38, 2, !dbg !2490
  %40 = and i1 %37, %39, !dbg !2492
  br i1 %40, label %41, label %51, !dbg !2492

; <label>:41:                                     ; preds = %36
  %42 = icmp eq i32 %1, 3, !dbg !2493
  %43 = and i32 %5, 2047, !dbg !2494
  %44 = lshr i32 %5, 11, !dbg !2495
  %45 = and i32 %44, 3, !dbg !2496
  %46 = add nuw nsw i32 %45, 1, !dbg !2497
  %47 = mul nuw nsw i32 %46, %43, !dbg !2498
  tail call void @llvm.dbg.value(metadata i32 %47, i64 0, metadata !2428, metadata !173), !dbg !2499
  tail call void @usb_set_dma_rsize(i8 zeroext %0, i32 %1, i32 %47) #10, !dbg !2500
  tail call void @usb_write_rxmaxp(i8 zeroext %0, i32 %1, i32 %5) #10, !dbg !2501
  %48 = select i1 %42, i32* inttoptr (i32 92240 to i32*), i32* inttoptr (i32 92244 to i32*), !dbg !2502
  %49 = load volatile i32, i32* %48, align 4, !tbaa !214
  %50 = or i32 %49, 2
  store volatile i32 %50, i32* %48, align 4, !tbaa !214
  br label %51, !dbg !2503

; <label>:51:                                     ; preds = %41, %36, %34, %33
  %52 = icmp eq i32 %3, 0, !dbg !2504
  br i1 %52, label %54, label %53, !dbg !2506

; <label>:53:                                     ; preds = %51
  tail call void @usb_set_intr_rxe(i8 zeroext %0, i32 %1) #10, !dbg !2507
  br label %55, !dbg !2509

; <label>:54:                                     ; preds = %51
  tail call void @usb_clr_intr_rxe(i8 zeroext %0, i32 %1) #10, !dbg !2510
  br label %55

; <label>:55:                                     ; preds = %54, %53, %30, %29
  ret i32 0, !dbg !2512
}

; Function Attrs: minsize nounwind optsize
define void @usb_pll_init() local_unnamed_addr #3 !dbg !2513 {
  %1 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2514, !tbaa !214
  %2 = and i32 %1, 2, !dbg !2516
  %3 = icmp eq i32 %2, 0, !dbg !2516
  br i1 %3, label %4, label %34, !dbg !2517

; <label>:4:                                      ; preds = %0
  store volatile i32 0, i32* inttoptr (i32 92680 to i32*), align 8, !dbg !2518, !tbaa !214
  %5 = load volatile i32, i32* inttoptr (i32 92680 to i32*), align 8, !dbg !2520, !tbaa !214
  %6 = and i32 %5, -8, !dbg !2520
  %7 = or i32 %6, 4, !dbg !2520
  store volatile i32 %7, i32* inttoptr (i32 92680 to i32*), align 8, !dbg !2520, !tbaa !214
  store volatile i32 0, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2521, !tbaa !214
  %8 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2522, !tbaa !214
  %9 = or i32 %8, 1, !dbg !2522
  store volatile i32 %9, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2522, !tbaa !214
  %10 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2523, !tbaa !214
  %11 = and i32 %10, -25, !dbg !2523
  %12 = or i32 %11, 16, !dbg !2523
  store volatile i32 %12, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2523, !tbaa !214
  %13 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2524, !tbaa !214
  %14 = and i32 %13, -97, !dbg !2524
  %15 = or i32 %14, 32, !dbg !2524
  store volatile i32 %15, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2524, !tbaa !214
  %16 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2525, !tbaa !214
  %17 = and i32 %16, -385, !dbg !2525
  %18 = or i32 %17, 128, !dbg !2525
  store volatile i32 %18, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2525, !tbaa !214
  %19 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2526, !tbaa !214
  %20 = and i32 %19, -1537, !dbg !2526
  %21 = or i32 %20, 1024, !dbg !2526
  store volatile i32 %21, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2526, !tbaa !214
  %22 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2527, !tbaa !214
  %23 = or i32 %22, 2048, !dbg !2527
  store volatile i32 %23, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2527, !tbaa !214
  %24 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2528, !tbaa !214
  %25 = or i32 %24, 90112, !dbg !2528
  store volatile i32 %25, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2528, !tbaa !214
  %26 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2529, !tbaa !214
  %27 = or i32 %26, 125304832, !dbg !2529
  store volatile i32 %27, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2529, !tbaa !214
  %28 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2530, !tbaa !214
  %29 = or i32 %28, 4, !dbg !2530
  store volatile i32 %29, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2530, !tbaa !214
  tail call void @delay(i32 1000) #9, !dbg !2531
  %30 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2532, !tbaa !214
  %31 = or i32 %30, 2, !dbg !2532
  store volatile i32 %31, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2532, !tbaa !214
  tail call void @delay(i32 1000) #9, !dbg !2533
  %32 = load volatile i32, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2534, !tbaa !214
  %33 = and i32 %32, -5, !dbg !2534
  store volatile i32 %33, i32* inttoptr (i32 92672 to i32*), align 512, !dbg !2534, !tbaa !214
  tail call void @delay(i32 100000) #9, !dbg !2535
  br label %34, !dbg !2536

; <label>:34:                                     ; preds = %4, %0
  ret void, !dbg !2537
}

; Function Attrs: minsize optsize
declare void @delay(i32) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define void @usb_g_sie_init(i8 zeroext) local_unnamed_addr #3 !dbg !2538 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2540, metadata !173), !dbg !2541
  %2 = zext i8 %0 to i32, !dbg !2542
  %3 = icmp eq i8 %0, 0, !dbg !2544
  br i1 %3, label %4, label %33, !dbg !2545

; <label>:4:                                      ; preds = %1
  %5 = shl nuw nsw i32 %2, 1, !dbg !2546
  %6 = add nuw nsw i32 %5, 149, !dbg !2548
  %7 = tail call i32 @gpio_set_die(i32 %6, i32 1) #9, !dbg !2549
  %8 = add nuw nsw i32 %5, 148, !dbg !2550
  %9 = tail call i32 @gpio_set_die(i32 %8, i32 1) #9, !dbg !2551
  %10 = getelementptr inbounds [2 x %struct.JL_USB_IO_TypeDef*], [2 x %struct.JL_USB_IO_TypeDef*]* @usb_io_regs, i32 0, i32 %2, !dbg !2552
  %11 = load %struct.JL_USB_IO_TypeDef*, %struct.JL_USB_IO_TypeDef** %10, align 4, !dbg !2552, !tbaa !244
  %12 = getelementptr inbounds %struct.JL_USB_IO_TypeDef, %struct.JL_USB_IO_TypeDef* %11, i32 0, i32 0, !dbg !2552
  %13 = load volatile i32, i32* %12, align 4, !dbg !2553, !tbaa !1323
  %14 = and i32 %13, -2049, !dbg !2553
  store volatile i32 %14, i32* %12, align 4, !dbg !2553, !tbaa !1323
  %15 = load volatile i32, i32* %12, align 4, !dbg !2554, !tbaa !1323
  %16 = or i32 %15, 4096, !dbg !2554
  store volatile i32 %16, i32* %12, align 4, !dbg !2554, !tbaa !1323
  %17 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %2, !dbg !2555
  %18 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %17, align 4, !dbg !2555, !tbaa !244
  %19 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %18, i32 0, i32 0, !dbg !2555
  %20 = load volatile i32, i32* %19, align 4, !dbg !2556, !tbaa !246
  %21 = and i32 %20, -16437, !dbg !2556
  store volatile i32 %21, i32* %19, align 4, !dbg !2556, !tbaa !246
  %22 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %18, i32 0, i32 1, !dbg !2557
  store volatile i32 0, i32* %22, align 4, !dbg !2558, !tbaa !254
  %23 = load volatile i32, i32* %19, align 4, !dbg !2559, !tbaa !246
  %24 = or i32 %23, 1, !dbg !2559
  store volatile i32 %24, i32* %19, align 4, !dbg !2559, !tbaa !246
  %25 = load volatile i32, i32* %12, align 4, !dbg !2560, !tbaa !1323
  %26 = and i32 %25, -49, !dbg !2560
  store volatile i32 %26, i32* %12, align 4, !dbg !2560, !tbaa !1323
  %27 = load volatile i32, i32* %12, align 4, !dbg !2561, !tbaa !1323
  %28 = and i32 %27, -193, !dbg !2561
  store volatile i32 %28, i32* %12, align 4, !dbg !2561, !tbaa !1323
  %29 = load volatile i32, i32* %12, align 4, !dbg !2562, !tbaa !1323
  %30 = or i32 %29, 64, !dbg !2562
  store volatile i32 %30, i32* %12, align 4, !dbg !2562, !tbaa !1323
  %31 = load volatile i32, i32* %19, align 4, !dbg !2563, !tbaa !246
  %32 = or i32 %31, 60, !dbg !2563
  store volatile i32 %32, i32* %19, align 4, !dbg !2563, !tbaa !246
  br label %61, !dbg !2564

; <label>:33:                                     ; preds = %1
  store volatile i8 0, i8* inttoptr (i32 90113 to i8*), align 1, !dbg !2565, !tbaa !692
  store volatile i32 0, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !2567, !tbaa !214
  %34 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2568, !tbaa !214
  %35 = and i32 %34, -33, !dbg !2568
  store volatile i32 %35, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2568, !tbaa !214
  %36 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2569, !tbaa !214
  %37 = and i32 %36, -769, !dbg !2569
  store volatile i32 %37, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2569, !tbaa !214
  %38 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2570, !tbaa !214
  %39 = or i32 %38, 28, !dbg !2570
  store volatile i32 %39, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2570, !tbaa !214
  %40 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2571, !tbaa !214
  %41 = or i32 %40, 1, !dbg !2571
  store volatile i32 %41, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2571, !tbaa !214
  tail call void @delay(i32 1000) #9, !dbg !2572
  %42 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2573, !tbaa !214
  %43 = or i32 %42, 2, !dbg !2573
  store volatile i32 %43, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2573, !tbaa !214
  %44 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !2574, !tbaa !214
  %45 = or i32 %44, 3, !dbg !2574
  store volatile i32 %45, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !2574, !tbaa !214
  br label %46, !dbg !2575

; <label>:46:                                     ; preds = %46, %33
  %47 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !2576, !tbaa !214
  %48 = and i32 %47, 16, !dbg !2578
  %49 = icmp eq i32 %48, 0, !dbg !2579
  br i1 %49, label %46, label %50, !dbg !2580, !llvm.loop !2581

; <label>:50:                                     ; preds = %46
  %51 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2583, !tbaa !214
  %52 = and i32 %51, -33554433, !dbg !2583
  store volatile i32 %52, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2583, !tbaa !214
  %53 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2584, !tbaa !214
  %54 = and i32 %53, -16777217, !dbg !2584
  store volatile i32 %54, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2584, !tbaa !214
  %55 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2585, !tbaa !214
  %56 = or i32 %55, 4194304, !dbg !2585
  store volatile i32 %56, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2585, !tbaa !214
  %57 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2586, !tbaa !214
  %58 = or i32 %57, 8388608, !dbg !2586
  store volatile i32 %58, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !2586, !tbaa !214
  %59 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !2587, !tbaa !214
  %60 = or i32 %59, 6144, !dbg !2587
  store volatile i32 %60, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !2587, !tbaa !214
  store volatile i16 -1, i16* inttoptr (i32 90946 to i16*), align 2, !dbg !2588, !tbaa !1206
  store volatile i16 -1, i16* inttoptr (i32 90944 to i16*), align 64, !dbg !2589, !tbaa !1206
  br label %61

; <label>:61:                                     ; preds = %50, %4
  ret void, !dbg !2590
}

; Function Attrs: minsize optsize
declare i32 @gpio_set_die(i32, i32) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define void @usb_enable_ep(i8 zeroext, i32) local_unnamed_addr #3 !dbg !2591 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2593, metadata !173), !dbg !2595
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2594, metadata !173), !dbg !2596
  %3 = icmp eq i8 %0, 0, !dbg !2597
  br i1 %3, label %4, label %10, !dbg !2599

; <label>:4:                                      ; preds = %2
  %5 = add i32 %1, 19, !dbg !2600
  %6 = shl i32 1, %5, !dbg !2602
  %7 = xor i32 %6, -1, !dbg !2603
  %8 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !2604, !tbaa !246
  %9 = and i32 %8, %7, !dbg !2604
  store volatile i32 %9, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !2604, !tbaa !246
  br label %10, !dbg !2605

; <label>:10:                                     ; preds = %4, %2
  ret void, !dbg !2606
}

; Function Attrs: minsize nounwind optsize
define void @usb_disable_ep(i8 zeroext, i32) local_unnamed_addr #3 !dbg !2607 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2609, metadata !173), !dbg !2611
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2610, metadata !173), !dbg !2612
  %3 = icmp eq i8 %0, 0, !dbg !2613
  br i1 %3, label %4, label %9, !dbg !2615

; <label>:4:                                      ; preds = %2
  %5 = add i32 %1, 19, !dbg !2616
  %6 = shl i32 1, %5, !dbg !2618
  %7 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !2619, !tbaa !246
  %8 = or i32 %7, %6, !dbg !2619
  store volatile i32 %8, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !2619, !tbaa !246
  br label %9, !dbg !2620

; <label>:9:                                      ; preds = %4, %2
  ret void, !dbg !2621
}

; Function Attrs: minsize nounwind optsize
define void @usb_g_hold(i8 zeroext) local_unnamed_addr #3 !dbg !2622 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2624, metadata !173), !dbg !2625
  %2 = zext i8 %0 to i32, !dbg !2626
  %3 = icmp eq i8 %0, 0, !dbg !2628
  br i1 %3, label %4, label %22, !dbg !2629

; <label>:4:                                      ; preds = %1
  %5 = shl nuw nsw i32 %2, 1, !dbg !2630
  %6 = add nuw nsw i32 %5, 149, !dbg !2632
  %7 = tail call i32 @gpio_set_die(i32 %6, i32 1) #9, !dbg !2633
  %8 = add nuw nsw i32 %5, 148, !dbg !2634
  %9 = tail call i32 @gpio_set_die(i32 %8, i32 1) #9, !dbg !2635
  %10 = getelementptr inbounds [2 x %struct.JL_USB_IO_TypeDef*], [2 x %struct.JL_USB_IO_TypeDef*]* @usb_io_regs, i32 0, i32 %2, !dbg !2636
  %11 = load %struct.JL_USB_IO_TypeDef*, %struct.JL_USB_IO_TypeDef** %10, align 4, !dbg !2636, !tbaa !244
  %12 = getelementptr inbounds %struct.JL_USB_IO_TypeDef, %struct.JL_USB_IO_TypeDef* %11, i32 0, i32 0, !dbg !2636
  %13 = load volatile i32, i32* %12, align 4, !dbg !2637, !tbaa !1323
  %14 = and i32 %13, -33, !dbg !2637
  store volatile i32 %14, i32* %12, align 4, !dbg !2637, !tbaa !1323
  %15 = load volatile i32, i32* %12, align 4, !dbg !2638, !tbaa !1323
  %16 = and i32 %15, -193, !dbg !2638
  store volatile i32 %16, i32* %12, align 4, !dbg !2638, !tbaa !1323
  %17 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %2, !dbg !2639
  %18 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %17, align 4, !dbg !2639, !tbaa !244
  %19 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %18, i32 0, i32 0, !dbg !2639
  %20 = load volatile i32, i32* %19, align 4, !dbg !2640, !tbaa !246
  %21 = or i32 %20, 513, !dbg !2640
  store volatile i32 %21, i32* %19, align 4, !dbg !2640, !tbaa !246
  br label %25, !dbg !2641

; <label>:22:                                     ; preds = %1
  %23 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !2642, !tbaa !214
  %24 = and i32 %23, -4, !dbg !2642
  store volatile i32 %24, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !2642, !tbaa !214
  br label %25

; <label>:25:                                     ; preds = %22, %4
  %26 = phi i32* [ inttoptr (i32 92684 to i32*), %22 ], [ %19, %4 ]
  %27 = phi i32 [ -4, %22 ], [ -2049, %4 ]
  %28 = load volatile i32, i32* %26, align 4, !tbaa !214
  %29 = and i32 %28, %27
  store volatile i32 %29, i32* %26, align 4, !tbaa !214
  ret void, !dbg !2644
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_get_ep_num(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !2645 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2649, metadata !173), !dbg !2653
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2650, metadata !173), !dbg !2654
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2651, metadata !173), !dbg !2655
  tail call void @llvm.dbg.value(metadata i8 1, i64 0, metadata !2652, metadata !173), !dbg !2656
  tail call void @llvm.dbg.value(metadata i8 5, i64 0, metadata !2652, metadata !173), !dbg !2656
  %4 = icmp eq i32 %1, 128, !dbg !2657
  br i1 %4, label %5, label %51, !dbg !2659

; <label>:5:                                      ; preds = %3
  switch i32 %2, label %97 [
    i32 2, label %6
    i32 3, label %21
    i32 1, label %36
  ], !dbg !2660

; <label>:6:                                      ; preds = %5
  %7 = zext i8 %0 to i32, !dbg !2662
  %8 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %7, !dbg !2662
  %9 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %8, align 4, !dbg !2662, !tbaa !244
  %10 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %9, i32 0, i32 1, !dbg !2665
  %11 = load i32, i32* %10, align 4, !dbg !2665, !tbaa !2666
  %12 = and i32 %11, 2, !dbg !2667
  %13 = icmp eq i32 %12, 0, !dbg !2668
  br i1 %13, label %14, label %16, !dbg !2669

; <label>:14:                                     ; preds = %6
  %15 = or i32 %11, 2, !dbg !2670
  store i32 %15, i32* %10, align 4, !dbg !2670, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 1, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2672

; <label>:16:                                     ; preds = %6
  %17 = and i32 %11, 4, !dbg !2673
  %18 = icmp eq i32 %17, 0, !dbg !2676
  br i1 %18, label %19, label %97, !dbg !2677

; <label>:19:                                     ; preds = %16
  %20 = or i32 %11, 4, !dbg !2679
  store i32 %20, i32* %10, align 4, !dbg !2679, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 2, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2681

; <label>:21:                                     ; preds = %5
  %22 = zext i8 %0 to i32, !dbg !2682
  %23 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %22, !dbg !2682
  %24 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %23, align 4, !dbg !2682, !tbaa !244
  %25 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %24, i32 0, i32 1, !dbg !2684
  %26 = load i32, i32* %25, align 4, !dbg !2684, !tbaa !2666
  %27 = and i32 %26, 4, !dbg !2685
  %28 = icmp eq i32 %27, 0, !dbg !2686
  br i1 %28, label %29, label %31, !dbg !2687

; <label>:29:                                     ; preds = %21
  %30 = or i32 %26, 4, !dbg !2688
  store i32 %30, i32* %25, align 4, !dbg !2688, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 2, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2690

; <label>:31:                                     ; preds = %21
  %32 = and i32 %26, 2, !dbg !2691
  %33 = icmp eq i32 %32, 0, !dbg !2694
  br i1 %33, label %34, label %97, !dbg !2695

; <label>:34:                                     ; preds = %31
  %35 = or i32 %26, 2, !dbg !2697
  store i32 %35, i32* %25, align 4, !dbg !2697, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 1, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2699

; <label>:36:                                     ; preds = %5
  %37 = zext i8 %0 to i32, !dbg !2700
  %38 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %37, !dbg !2700
  %39 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %38, align 4, !dbg !2700, !tbaa !244
  %40 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %39, i32 0, i32 1, !dbg !2702
  %41 = load i32, i32* %40, align 4, !dbg !2702, !tbaa !2666
  %42 = and i32 %41, 8, !dbg !2703
  %43 = icmp eq i32 %42, 0, !dbg !2704
  br i1 %43, label %44, label %46, !dbg !2705

; <label>:44:                                     ; preds = %36
  %45 = or i32 %41, 8, !dbg !2706
  store i32 %45, i32* %40, align 4, !dbg !2706, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 3, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2708

; <label>:46:                                     ; preds = %36
  %47 = and i32 %41, 16, !dbg !2709
  %48 = icmp eq i32 %47, 0, !dbg !2712
  br i1 %48, label %49, label %97, !dbg !2713

; <label>:49:                                     ; preds = %46
  %50 = or i32 %41, 16, !dbg !2715
  store i32 %50, i32* %40, align 4, !dbg !2715, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 4, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2717

; <label>:51:                                     ; preds = %3
  switch i32 %2, label %97 [
    i32 2, label %52
    i32 3, label %67
    i32 1, label %82
  ], !dbg !2718

; <label>:52:                                     ; preds = %51
  %53 = zext i8 %0 to i32, !dbg !2720
  %54 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %53, !dbg !2720
  %55 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %54, align 4, !dbg !2720, !tbaa !244
  %56 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %55, i32 0, i32 1, !dbg !2723
  %57 = load i32, i32* %56, align 4, !dbg !2723, !tbaa !2666
  %58 = and i32 %57, 131072, !dbg !2724
  %59 = icmp eq i32 %58, 0, !dbg !2725
  br i1 %59, label %60, label %62, !dbg !2726

; <label>:60:                                     ; preds = %52
  %61 = or i32 %57, 131072, !dbg !2727
  store i32 %61, i32* %56, align 4, !dbg !2727, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 1, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2729

; <label>:62:                                     ; preds = %52
  %63 = and i32 %57, 262144, !dbg !2730
  %64 = icmp eq i32 %63, 0, !dbg !2733
  br i1 %64, label %65, label %97, !dbg !2734

; <label>:65:                                     ; preds = %62
  %66 = or i32 %57, 262144, !dbg !2736
  store i32 %66, i32* %56, align 4, !dbg !2736, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 2, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2738

; <label>:67:                                     ; preds = %51
  %68 = zext i8 %0 to i32, !dbg !2739
  %69 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %68, !dbg !2739
  %70 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %69, align 4, !dbg !2739, !tbaa !244
  %71 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %70, i32 0, i32 1, !dbg !2741
  %72 = load i32, i32* %71, align 4, !dbg !2741, !tbaa !2666
  %73 = and i32 %72, 262144, !dbg !2742
  %74 = icmp eq i32 %73, 0, !dbg !2743
  br i1 %74, label %75, label %77, !dbg !2744

; <label>:75:                                     ; preds = %67
  %76 = or i32 %72, 262144, !dbg !2745
  store i32 %76, i32* %71, align 4, !dbg !2745, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 2, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2747

; <label>:77:                                     ; preds = %67
  %78 = and i32 %72, 131072, !dbg !2748
  %79 = icmp eq i32 %78, 0, !dbg !2751
  br i1 %79, label %80, label %97, !dbg !2752

; <label>:80:                                     ; preds = %77
  %81 = or i32 %72, 131072, !dbg !2754
  store i32 %81, i32* %71, align 4, !dbg !2754, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 1, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2756

; <label>:82:                                     ; preds = %51
  %83 = zext i8 %0 to i32, !dbg !2757
  %84 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %83, !dbg !2757
  %85 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %84, align 4, !dbg !2757, !tbaa !244
  %86 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %85, i32 0, i32 1, !dbg !2759
  %87 = load i32, i32* %86, align 4, !dbg !2759, !tbaa !2666
  %88 = and i32 %87, 524288, !dbg !2760
  %89 = icmp eq i32 %88, 0, !dbg !2761
  br i1 %89, label %90, label %92, !dbg !2762

; <label>:90:                                     ; preds = %82
  %91 = or i32 %87, 524288, !dbg !2763
  store i32 %91, i32* %86, align 4, !dbg !2763, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 3, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2765

; <label>:92:                                     ; preds = %82
  %93 = and i32 %87, 1048576, !dbg !2766
  %94 = icmp eq i32 %93, 0, !dbg !2769
  br i1 %94, label %95, label %97, !dbg !2770

; <label>:95:                                     ; preds = %92
  %96 = or i32 %87, 1048576, !dbg !2772
  store i32 %96, i32* %86, align 4, !dbg !2772, !tbaa !2666
  tail call void @llvm.dbg.value(metadata i8 4, i64 0, metadata !2652, metadata !173), !dbg !2656
  br label %97, !dbg !2774

; <label>:97:                                     ; preds = %95, %92, %90, %80, %77, %75, %65, %62, %60, %51, %49, %46, %44, %34, %31, %29, %19, %16, %14, %5
  %98 = phi i32 [ 5, %5 ], [ 3, %44 ], [ 4, %49 ], [ 5, %46 ], [ 2, %29 ], [ 1, %34 ], [ 5, %31 ], [ 1, %14 ], [ 2, %19 ], [ 5, %16 ], [ 5, %51 ], [ 3, %90 ], [ 4, %95 ], [ 5, %92 ], [ 2, %75 ], [ 1, %80 ], [ 5, %77 ], [ 1, %60 ], [ 2, %65 ], [ 5, %62 ]
  %99 = icmp ult i32 %98, 5, !dbg !2775
  %100 = select i1 %99, i32 %98, i32 -1, !dbg !2777
  ret i32 %100, !dbg !2779
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_ep_config(i8 zeroext, i32, i32, i32, i32, i8*, i32) local_unnamed_addr #3 !dbg !2780 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2784, metadata !173), !dbg !2792
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !2785, metadata !173), !dbg !2793
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !2786, metadata !173), !dbg !2794
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !2787, metadata !173), !dbg !2795
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !2788, metadata !173), !dbg !2796
  tail call void @llvm.dbg.value(metadata i8* %5, i64 0, metadata !2789, metadata !173), !dbg !2797
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !2790, metadata !173), !dbg !2798
  %8 = trunc i32 %1 to i8, !dbg !2799
  %9 = icmp slt i8 %8, 0, !dbg !2799
  %10 = and i32 %1, 15
  tail call void @llvm.dbg.value(metadata i32 %10, i64 0, metadata !2785, metadata !173), !dbg !2793
  br i1 %9, label %11, label %33, !dbg !2801

; <label>:11:                                     ; preds = %7
  tail call void @usb_set_dma_raddr(i8 zeroext %0, i32 %10, i8* %5) #10, !dbg !2802
  tail call void @usb_set_dma_rsize(i8 zeroext %0, i32 %10, i32 %6) #10, !dbg !2804
  tail call void @usb_write_rxmaxp(i8 zeroext %0, i32 %10, i32 1023) #10, !dbg !2805
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %10, i32 144) #10, !dbg !2806
  switch i32 %2, label %29 [
    i32 2, label %12
    i32 1, label %13
    i32 3, label %28
  ], !dbg !2807

; <label>:12:                                     ; preds = %11
  tail call void @usb_set_dma_dual_raddr(i8 zeroext %0, i32 %10, i8* %5) #10, !dbg !2808
  br label %29, !dbg !2811

; <label>:13:                                     ; preds = %11
  tail call void @usb_set_dma_dual_raddr(i8 zeroext %0, i32 %10, i8* null) #10, !dbg !2812
  tail call void @usb_write_rxinterval(i8 zeroext %0, i32 %10, i32 %4) #10, !dbg !2815
  %14 = icmp ne i8 %0, 0, !dbg !2816
  %15 = add nsw i32 %10, -3, !dbg !2818
  %16 = icmp ult i32 %15, 2, !dbg !2818
  %17 = and i1 %14, %16, !dbg !2820
  br i1 %17, label %18, label %29, !dbg !2820

; <label>:18:                                     ; preds = %13
  %19 = icmp eq i32 %10, 3, !dbg !2821
  %20 = and i32 %6, 2047, !dbg !2822
  %21 = lshr i32 %6, 11, !dbg !2824
  %22 = and i32 %21, 3, !dbg !2825
  %23 = add nuw nsw i32 %22, 1, !dbg !2826
  %24 = mul nuw nsw i32 %23, %20, !dbg !2827
  tail call void @llvm.dbg.value(metadata i32 %24, i64 0, metadata !2791, metadata !173), !dbg !2828
  tail call void @usb_set_dma_rsize(i8 zeroext %0, i32 %10, i32 %24) #10, !dbg !2829
  tail call void @usb_write_rxmaxp(i8 zeroext %0, i32 %10, i32 %6) #10, !dbg !2830
  %25 = select i1 %19, i32* inttoptr (i32 92240 to i32*), i32* inttoptr (i32 92244 to i32*), !dbg !2831
  %26 = load volatile i32, i32* %25, align 4, !tbaa !214
  %27 = or i32 %26, 2
  store volatile i32 %27, i32* %25, align 4, !tbaa !214
  br label %29, !dbg !2832

; <label>:28:                                     ; preds = %11
  tail call void @usb_set_dma_dual_raddr(i8 zeroext %0, i32 %10, i8* null) #10, !dbg !2833
  tail call void @usb_write_rxinterval(i8 zeroext %0, i32 %10, i32 %4) #10, !dbg !2836
  br label %29, !dbg !2837

; <label>:29:                                     ; preds = %28, %18, %13, %12, %11
  %30 = icmp eq i32 %3, 0, !dbg !2838
  br i1 %30, label %32, label %31, !dbg !2840

; <label>:31:                                     ; preds = %29
  tail call void @usb_set_intr_rxe(i8 zeroext %0, i32 %10) #10, !dbg !2841
  br label %54, !dbg !2843

; <label>:32:                                     ; preds = %29
  tail call void @usb_clr_intr_rxe(i8 zeroext %0, i32 %10) #10, !dbg !2844
  br label %54

; <label>:33:                                     ; preds = %7
  tail call void @usb_set_dma_taddr(i8 zeroext %0, i32 %10, i8* %5) #10, !dbg !2846
  tail call void @usb_set_dma_tsize(i8 zeroext %0, i32 %10, i32 %6) #10, !dbg !2848
  tail call void @usb_write_txmaxp(i8 zeroext %0, i32 %10, i32 1023) #10, !dbg !2849
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %10, i32 72) #10, !dbg !2850
  switch i32 %2, label %50 [
    i32 3, label %49
    i32 1, label %34
  ], !dbg !2851

; <label>:34:                                     ; preds = %33
  tail call void @usb_write_txinterval(i8 zeroext %0, i32 %10, i32 %4) #10, !dbg !2852
  %35 = icmp ne i8 %0, 0, !dbg !2856
  %36 = add nsw i32 %10, -3, !dbg !2858
  %37 = icmp ult i32 %36, 2, !dbg !2858
  %38 = and i1 %35, %37, !dbg !2860
  br i1 %38, label %39, label %50, !dbg !2860

; <label>:39:                                     ; preds = %34
  %40 = icmp eq i32 %10, 3, !dbg !2861
  %41 = and i32 %6, 2047, !dbg !2862
  %42 = lshr i32 %6, 11, !dbg !2864
  %43 = and i32 %42, 3, !dbg !2865
  %44 = add nuw nsw i32 %43, 1, !dbg !2866
  %45 = mul nuw nsw i32 %44, %41, !dbg !2867
  tail call void @llvm.dbg.value(metadata i32 %45, i64 0, metadata !2791, metadata !173), !dbg !2828
  tail call void @usb_set_dma_tsize(i8 zeroext %0, i32 %10, i32 %45) #10, !dbg !2868
  tail call void @usb_write_txmaxp(i8 zeroext %0, i32 %10, i32 %6) #10, !dbg !2869
  %46 = select i1 %40, i32* inttoptr (i32 92240 to i32*), i32* inttoptr (i32 92244 to i32*), !dbg !2870
  %47 = load volatile i32, i32* %46, align 4, !tbaa !214
  %48 = or i32 %47, 1
  store volatile i32 %48, i32* %46, align 4, !tbaa !214
  br label %50, !dbg !2871

; <label>:49:                                     ; preds = %33
  tail call void @usb_write_txinterval(i8 zeroext %0, i32 %10, i32 %4) #10, !dbg !2872
  br label %50, !dbg !2875

; <label>:50:                                     ; preds = %49, %39, %34, %33
  %51 = icmp eq i32 %3, 0, !dbg !2876
  br i1 %51, label %53, label %52, !dbg !2878

; <label>:52:                                     ; preds = %50
  tail call void @usb_set_intr_txe(i8 zeroext %0, i32 %10) #10, !dbg !2879
  br label %54, !dbg !2881

; <label>:53:                                     ; preds = %50
  tail call void @usb_clr_intr_txe(i8 zeroext %0, i32 %10) #10, !dbg !2882
  br label %54

; <label>:54:                                     ; preds = %53, %52, %32, %31
  ret i32 0, !dbg !2884
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_ep_write_async(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8* readonly, i32, i32, i32) local_unnamed_addr #3 !dbg !2885 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !2890, metadata !173), !dbg !2905
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !2891, metadata !173), !dbg !2906
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !2892, metadata !173), !dbg !2907
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !2893, metadata !173), !dbg !2908
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !2894, metadata !173), !dbg !2909
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !2895, metadata !173), !dbg !2910
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !2896, metadata !173), !dbg !2911
  tail call void @llvm.dbg.value(metadata i32 %7, i64 0, metadata !2897, metadata !173), !dbg !2912
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !2898, metadata !173), !dbg !2913
  %9 = icmp eq i32 %7, 0, !dbg !2914
  br i1 %9, label %10, label %30, !dbg !2915

; <label>:10:                                     ; preds = %8
  %11 = zext i8 %1 to i32, !dbg !2916
  %12 = tail call i32 @usb_read_txcsr(i8 zeroext %0, i32 %11) #10, !dbg !2917
  tail call void @llvm.dbg.value(metadata i32 %12, i64 0, metadata !2899, metadata !173), !dbg !2918
  %13 = trunc i32 %12 to i8, !dbg !2919
  %14 = icmp slt i8 %13, 0, !dbg !2919
  br i1 %14, label %15, label %17, !dbg !2921

; <label>:15:                                     ; preds = %10
  %16 = and i32 %12, -129, !dbg !2922
  tail call void @llvm.dbg.value(metadata i32 %16, i64 0, metadata !2899, metadata !173), !dbg !2918
  br label %27, !dbg !2924

; <label>:17:                                     ; preds = %10
  %18 = and i32 %12, 32, !dbg !2925
  %19 = icmp eq i32 %18, 0, !dbg !2925
  br i1 %19, label %22, label %20, !dbg !2928

; <label>:20:                                     ; preds = %17
  %21 = and i32 %12, -33, !dbg !2930
  tail call void @llvm.dbg.value(metadata i32 %21, i64 0, metadata !2899, metadata !173), !dbg !2918
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.6, i32 0, i32 0)) #9, !dbg !2932
  tail call void @llvm.dbg.value(metadata i32 -16, i64 0, metadata !2898, metadata !173), !dbg !2913
  br label %27, !dbg !2934

; <label>:22:                                     ; preds = %17
  %23 = and i32 %12, 4, !dbg !2935
  %24 = icmp eq i32 %23, 0, !dbg !2935
  br i1 %24, label %27, label %25, !dbg !2938

; <label>:25:                                     ; preds = %22
  %26 = and i32 %12, -5, !dbg !2939
  tail call void @llvm.dbg.value(metadata i32 %26, i64 0, metadata !2899, metadata !173), !dbg !2918
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.7, i32 0, i32 0)) #9, !dbg !2941
  tail call void @llvm.dbg.value(metadata i32 -17, i64 0, metadata !2898, metadata !173), !dbg !2913
  br label %27, !dbg !2943

; <label>:27:                                     ; preds = %25, %22, %20, %15
  %28 = phi i32 [ %5, %15 ], [ -16, %20 ], [ -17, %25 ], [ %5, %22 ]
  %29 = phi i32 [ %16, %15 ], [ %21, %20 ], [ %26, %25 ], [ %12, %22 ]
  tail call void @llvm.dbg.value(metadata i32 %29, i64 0, metadata !2899, metadata !173), !dbg !2918
  tail call void @llvm.dbg.value(metadata i32 %28, i64 0, metadata !2898, metadata !173), !dbg !2913
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %11, i32 %29) #10, !dbg !2944
  br label %35, !dbg !2945

; <label>:30:                                     ; preds = %8
  %31 = tail call i32 @usb_read_devctl(i8 zeroext %0) #10, !dbg !2946
  %32 = and i32 %31, 4, !dbg !2949
  %33 = icmp eq i32 %32, 0, !dbg !2950
  br i1 %33, label %34, label %35, !dbg !2951

; <label>:34:                                     ; preds = %30
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.8, i32 0, i32 0), i32 1570) #9, !dbg !2952
  br label %64, !dbg !2955

; <label>:35:                                     ; preds = %30, %27
  %36 = phi i32 [ %5, %30 ], [ %28, %27 ]
  tail call void @llvm.dbg.value(metadata i32 %36, i64 0, metadata !2898, metadata !173), !dbg !2913
  %37 = or i32 %7, %5, !dbg !2956
  %38 = icmp eq i32 %37, 0, !dbg !2956
  br i1 %38, label %64, label %39, !dbg !2956

; <label>:39:                                     ; preds = %35
  %40 = zext i8 %1 to i32, !dbg !2957
  %41 = tail call i8* @usb_get_dma_taddr(i8 zeroext %0, i32 %40) #10, !dbg !2958
  tail call void @llvm.dbg.value(metadata i8* %41, i64 0, metadata !2902, metadata !173), !dbg !2959
  tail call void @usb_set_dma_taddr(i8 zeroext %0, i32 %40, i8* %41) #10, !dbg !2960
  %42 = icmp eq i8* %4, null, !dbg !2961
  br i1 %42, label %44, label %43, !dbg !2963

; <label>:43:                                     ; preds = %39
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %41, i8* nonnull %4, i32 %5, i32 1, i1 false), !dbg !2964
  tail call void asm sideeffect "csync", ""() #7, !dbg !2966, !srcloc !2967
  br label %44, !dbg !2968

; <label>:44:                                     ; preds = %43, %39
  %45 = icmp eq i8 %0, 0, !dbg !2969
  br i1 %45, label %46, label %50, !dbg !2971

; <label>:46:                                     ; preds = %44
  tail call void @sys_local_irq_disable() #9, !dbg !2972
  tail call void @usb_write_ep_cnt(i8 zeroext 0, i32 %40, i32 %5) #10, !dbg !2976
  tail call void @musb_write_index(i8 zeroext 0, i32 %40) #10, !dbg !2977
  %47 = shl i32 %6, 4, !dbg !2978
  %48 = zext i8 %3 to i32, !dbg !2979
  %49 = or i32 %47, %48, !dbg !2980
  tail call void @musb_write_usb(i8 zeroext 0, i32 24, i32 %49) #10, !dbg !2981
  tail call void @musb_write_usb(i8 zeroext 0, i32 17, i32 1) #10, !dbg !2982
  tail call void @sys_local_irq_enable() #9, !dbg !2983
  br label %64, !dbg !2986

; <label>:50:                                     ; preds = %44
  %51 = zext i8 %0 to i32, !dbg !2987
  tail call void @usb_write_ep_cnt(i8 zeroext %0, i32 %40, i32 %5) #10, !dbg !2989
  %52 = getelementptr inbounds [2 x i8], [2 x i8]* @host_speed, i32 0, i32 %51, !dbg !2991
  %53 = load i8, i8* %52, align 1, !dbg !2991, !tbaa !692
  %54 = zext i8 %53 to i32, !dbg !2991
  %55 = add nsw i32 %54, -1, !dbg !2992
  %56 = getelementptr inbounds [3 x i8], [3 x i8]* @speed_table, i32 0, i32 %55, !dbg !2993
  %57 = load i8, i8* %56, align 1, !dbg !2993, !tbaa !692
  %58 = zext i8 %57 to i32, !dbg !2993
  %59 = shl nuw nsw i32 %58, 6, !dbg !2994
  %60 = shl i32 %6, 4, !dbg !2995
  %61 = zext i8 %3 to i32, !dbg !2996
  %62 = or i32 %60, %61, !dbg !2997
  %63 = or i32 %62, %59, !dbg !2998
  tail call void @usb_write_txtype(i8 zeroext %0, i32 %40, i32 %63) #10, !dbg !2999
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %40, i32 1) #10, !dbg !3000
  br label %64

; <label>:64:                                     ; preds = %50, %46, %35, %34
  %65 = phi i32 [ -10, %34 ], [ %36, %46 ], [ %36, %50 ], [ %36, %35 ]
  ret i32 %65, !dbg !3001
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_ep_write(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8* readonly, i32, i32) local_unnamed_addr #3 !dbg !3002 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !3006, metadata !173), !dbg !3023
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !3007, metadata !173), !dbg !3024
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !3008, metadata !173), !dbg !3025
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !3009, metadata !173), !dbg !3026
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !3010, metadata !173), !dbg !3027
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !3011, metadata !173), !dbg !3028
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !3012, metadata !173), !dbg !3029
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !3013, metadata !173), !dbg !3030
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3014, metadata !173), !dbg !3031
  %8 = zext i8 %1 to i32, !dbg !3032
  %9 = tail call i8* @usb_get_dma_taddr(i8 zeroext %0, i32 %8) #10, !dbg !3033
  tail call void @llvm.dbg.value(metadata i8* %9, i64 0, metadata !3015, metadata !173), !dbg !3034
  %10 = icmp eq i8* %9, null, !dbg !3035
  br i1 %10, label %128, label %11, !dbg !3037

; <label>:11:                                     ; preds = %7
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3016, metadata !173), !dbg !3038
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3017, metadata !173), !dbg !3039
  %12 = zext i8 %0 to i32, !dbg !3040
  %13 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %12, !dbg !3040
  %14 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %13, align 4, !dbg !3040, !tbaa !244
  %15 = icmp eq %struct.usb_ep_addr_t* %14, null, !dbg !3040
  br i1 %15, label %25, label %16, !dbg !3042

; <label>:16:                                     ; preds = %11
  %17 = add nsw i32 %8, -1, !dbg !3043
  %18 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %14, i32 0, i32 6, i32 %17, !dbg !3045
  %19 = load i32, i32* %18, align 4, !dbg !3045, !tbaa !214
  tail call void @llvm.dbg.value(metadata i32 %19, i64 0, metadata !3018, metadata !173), !dbg !3046
  %20 = load volatile i32, i32* @jiffies, align 4, !dbg !3047, !tbaa !193
  %21 = udiv i32 %5, %19, !dbg !3049
  %22 = shl i32 %21, 1, !dbg !3050
  tail call void @llvm.dbg.value(metadata i32 %23, i64 0, metadata !3016, metadata !173), !dbg !3038
  %23 = add i32 %20, 200, !dbg !3051
  %24 = add i32 %23, %22, !dbg !3052
  tail call void @llvm.dbg.value(metadata i32 %24, i64 0, metadata !3016, metadata !173), !dbg !3038
  br label %29, !dbg !3053, !llvm.loop !3054

; <label>:25:                                     ; preds = %11
  %26 = load volatile i32, i32* @jiffies, align 4, !dbg !3057, !tbaa !193
  %27 = add i32 %26, 20, !dbg !3060
  tail call void @llvm.dbg.value(metadata i32 %27, i64 0, metadata !3016, metadata !173), !dbg !3038
  %28 = add nsw i32 %8, -1
  br label %29, !llvm.loop !3054

; <label>:29:                                     ; preds = %25, %16
  %30 = phi i32 [ %28, %25 ], [ %17, %16 ]
  %31 = phi i32 [ %27, %25 ], [ %24, %16 ]
  %32 = zext i16 %2 to i32
  %33 = icmp eq i8 %0, 0
  %34 = shl i32 %6, 4
  %35 = zext i8 %3 to i32
  %36 = or i32 %34, %35
  %37 = getelementptr inbounds [2 x i8], [2 x i8]* @host_speed, i32 0, i32 %12
  br label %38, !dbg !3039

; <label>:38:                                     ; preds = %122, %29
  %39 = phi i32 [ %123, %122 ], [ %5, %29 ]
  %40 = phi i32 [ %92, %122 ], [ 0, %29 ]
  %41 = phi i8* [ %124, %122 ], [ %4, %29 ]
  %42 = phi i32 [ %93, %122 ], [ %31, %29 ]
  %43 = phi i32 [ %94, %122 ], [ 0, %29 ]
  tail call void @llvm.dbg.value(metadata i32 %43, i64 0, metadata !3017, metadata !173), !dbg !3039
  tail call void @llvm.dbg.value(metadata i32 %42, i64 0, metadata !3016, metadata !173), !dbg !3038
  tail call void @llvm.dbg.value(metadata i8* %41, i64 0, metadata !3010, metadata !173), !dbg !3027
  tail call void @llvm.dbg.value(metadata i32 %40, i64 0, metadata !3014, metadata !173), !dbg !3031
  tail call void @llvm.dbg.value(metadata i32 %39, i64 0, metadata !3011, metadata !173), !dbg !3028
  %44 = icmp ult i32 %32, %39, !dbg !3061
  %45 = select i1 %44, i32 %32, i32 %39, !dbg !3061
  tail call void @llvm.dbg.value(metadata i32 %45, i64 0, metadata !3019, metadata !173), !dbg !3062
  %46 = icmp eq i8* %41, null, !dbg !3063
  br i1 %46, label %48, label %47, !dbg !3065

; <label>:47:                                     ; preds = %38
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull %9, i8* nonnull %41, i32 %45, i32 1, i1 false), !dbg !3066
  tail call void asm sideeffect "csync", ""() #7, !dbg !3068, !srcloc !3069
  br label %48, !dbg !3070

; <label>:48:                                     ; preds = %47, %38
  br i1 %33, label %49, label %50, !dbg !3071

; <label>:49:                                     ; preds = %48
  tail call void @usb_write_txtype(i8 zeroext 0, i32 %8, i32 %36) #10, !dbg !3072
  tail call void @usb_write_ep_cnt(i8 zeroext 0, i32 %8, i32 %45) #10, !dbg !3075
  tail call void @usb_write_txcsr(i8 zeroext 0, i32 %8, i32 1) #10, !dbg !3076
  br label %59, !dbg !3077

; <label>:50:                                     ; preds = %48
  tail call void @usb_set_dma_taddr(i8 zeroext %0, i32 %8, i8* nonnull %9) #10, !dbg !3078
  %51 = load i8, i8* %37, align 1, !dbg !3080, !tbaa !692
  %52 = zext i8 %51 to i32, !dbg !3080
  %53 = add nsw i32 %52, -1, !dbg !3081
  %54 = getelementptr inbounds [3 x i8], [3 x i8]* @speed_table, i32 0, i32 %53, !dbg !3082
  %55 = load i8, i8* %54, align 1, !dbg !3082, !tbaa !692
  %56 = zext i8 %55 to i32, !dbg !3082
  %57 = shl nuw nsw i32 %56, 6, !dbg !3083
  %58 = or i32 %36, %57, !dbg !3084
  tail call void @usb_write_txtype(i8 zeroext %0, i32 %8, i32 %58) #10, !dbg !3085
  tail call void @usb_write_ep_cnt(i8 zeroext %0, i32 %8, i32 %45) #10, !dbg !3086
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %8, i32 1) #10, !dbg !3087
  br label %59

; <label>:59:                                     ; preds = %50, %49
  br label %60, !dbg !3088

; <label>:60:                                     ; preds = %115, %59
  %61 = phi i32 [ %92, %115 ], [ %40, %59 ]
  %62 = phi i32 [ %93, %115 ], [ %42, %59 ]
  %63 = phi i32 [ %94, %115 ], [ %43, %59 ]
  tail call void @llvm.dbg.value(metadata i32 %63, i64 0, metadata !3017, metadata !173), !dbg !3039
  tail call void @llvm.dbg.value(metadata i32 %62, i64 0, metadata !3016, metadata !173), !dbg !3038
  tail call void @llvm.dbg.value(metadata i8* %41, i64 0, metadata !3010, metadata !173), !dbg !3027
  tail call void @llvm.dbg.value(metadata i32 %61, i64 0, metadata !3014, metadata !173), !dbg !3031
  tail call void @llvm.dbg.value(metadata i32 %39, i64 0, metadata !3011, metadata !173), !dbg !3028
  %64 = load volatile i32, i32* @jiffies, align 4, !dbg !3090, !tbaa !193
  %65 = icmp slt i32 %62, %64, !dbg !3093
  br i1 %65, label %66, label %91, !dbg !3094

; <label>:66:                                     ; preds = %60
  %67 = add i32 %63, 1, !dbg !3095
  tail call void @llvm.dbg.value(metadata i32 %67, i64 0, metadata !3017, metadata !173), !dbg !3039
  %68 = icmp ugt i32 %67, 10, !dbg !3097
  br i1 %68, label %69, label %70, !dbg !3099

; <label>:69:                                     ; preds = %66
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.9, i32 0, i32 0)) #9, !dbg !3100
  br label %128, !dbg !3103

; <label>:70:                                     ; preds = %66
  %71 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %13, align 4, !dbg !3104, !tbaa !244
  %72 = icmp eq %struct.usb_ep_addr_t* %71, null, !dbg !3104
  br i1 %72, label %81, label %73, !dbg !3106

; <label>:73:                                     ; preds = %70
  %74 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %71, i32 0, i32 6, i32 %30, !dbg !3107
  %75 = load i32, i32* %74, align 4, !dbg !3107, !tbaa !214
  tail call void @llvm.dbg.value(metadata i32 %75, i64 0, metadata !3018, metadata !173), !dbg !3046
  %76 = load volatile i32, i32* @jiffies, align 4, !dbg !3109, !tbaa !193
  %77 = udiv i32 %39, %75, !dbg !3111
  %78 = shl i32 %77, 1, !dbg !3112
  tail call void @llvm.dbg.value(metadata i32 %79, i64 0, metadata !3016, metadata !173), !dbg !3038
  %79 = add i32 %76, 200, !dbg !3113
  %80 = add i32 %79, %78, !dbg !3114
  tail call void @llvm.dbg.value(metadata i32 %80, i64 0, metadata !3016, metadata !173), !dbg !3038
  br label %84, !dbg !3115

; <label>:81:                                     ; preds = %70
  %82 = load volatile i32, i32* @jiffies, align 4, !dbg !3116, !tbaa !193
  %83 = add i32 %82, 20, !dbg !3120
  tail call void @llvm.dbg.value(metadata i32 %83, i64 0, metadata !3016, metadata !173), !dbg !3038
  br label %84

; <label>:84:                                     ; preds = %81, %73
  %85 = phi i32 [ %80, %73 ], [ %83, %81 ]
  tail call void @llvm.dbg.value(metadata i32 %85, i64 0, metadata !3016, metadata !173), !dbg !3038
  %86 = tail call i32 @usb_h_dev_status(i8 zeroext %0) #10, !dbg !3121
  %87 = icmp eq i32 %86, 0, !dbg !3121
  %88 = add i32 %61, 1, !dbg !3123
  tail call void @llvm.dbg.value(metadata i32 %88, i64 0, metadata !3014, metadata !173), !dbg !3031
  %89 = select i1 %87, i32 0, i32 %88, !dbg !3125
  tail call void @llvm.dbg.value(metadata i32 %89, i64 0, metadata !3014, metadata !173), !dbg !3031
  %90 = icmp ugt i32 %89, 5, !dbg !3126
  br i1 %90, label %127, label %91, !dbg !3128

; <label>:91:                                     ; preds = %84, %60
  %92 = phi i32 [ %89, %84 ], [ %61, %60 ]
  %93 = phi i32 [ %85, %84 ], [ %62, %60 ]
  %94 = phi i32 [ %67, %84 ], [ %63, %60 ]
  tail call void @llvm.dbg.value(metadata i32 %94, i64 0, metadata !3017, metadata !173), !dbg !3039
  tail call void @llvm.dbg.value(metadata i32 %93, i64 0, metadata !3016, metadata !173), !dbg !3038
  tail call void @llvm.dbg.value(metadata i32 %92, i64 0, metadata !3014, metadata !173), !dbg !3031
  %95 = tail call i32 @usb_read_devctl(i8 zeroext %0) #10, !dbg !3129
  %96 = and i32 %95, 4, !dbg !3131
  %97 = icmp eq i32 %96, 0, !dbg !3132
  br i1 %97, label %98, label %99, !dbg !3133

; <label>:98:                                     ; preds = %91
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.8, i32 0, i32 0), i32 1658) #9, !dbg !3134
  br label %128, !dbg !3137

; <label>:99:                                     ; preds = %91
  %100 = tail call i32 @usb_read_txcsr(i8 zeroext %0, i32 %8) #10, !dbg !3138
  tail call void @llvm.dbg.value(metadata i32 %100, i64 0, metadata !3021, metadata !173), !dbg !3139
  %101 = trunc i32 %100 to i8, !dbg !3140
  %102 = icmp slt i8 %101, 0, !dbg !3140
  br i1 %102, label %103, label %105, !dbg !3142

; <label>:103:                                    ; preds = %99
  %104 = and i32 %100, -129, !dbg !3143
  tail call void @llvm.dbg.value(metadata i32 %104, i64 0, metadata !3021, metadata !173), !dbg !3139
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %8, i32 %104) #10, !dbg !3145
  br label %122, !dbg !3146

; <label>:105:                                    ; preds = %99
  %106 = and i32 %100, 32, !dbg !3147
  %107 = icmp eq i32 %106, 0, !dbg !3147
  br i1 %107, label %110, label %108, !dbg !3149

; <label>:108:                                    ; preds = %105
  %109 = and i32 %100, -33, !dbg !3150
  tail call void @llvm.dbg.value(metadata i32 %109, i64 0, metadata !3021, metadata !173), !dbg !3139
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %8, i32 %109) #10, !dbg !3152
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.6, i32 0, i32 0)) #9, !dbg !3153
  br label %128

; <label>:110:                                    ; preds = %105
  %111 = and i32 %100, 4, !dbg !3155
  %112 = icmp eq i32 %111, 0, !dbg !3155
  br i1 %112, label %115, label %113, !dbg !3157

; <label>:113:                                    ; preds = %110
  %114 = and i32 %100, -5, !dbg !3158
  tail call void @llvm.dbg.value(metadata i32 %114, i64 0, metadata !3021, metadata !173), !dbg !3139
  tail call void @usb_write_txcsr(i8 zeroext %0, i32 %8, i32 %114) #10, !dbg !3160
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.7, i32 0, i32 0)) #9, !dbg !3161
  br label %122, !dbg !3163

; <label>:115:                                    ; preds = %110
  %116 = and i32 %100, 1, !dbg !3164
  %117 = icmp eq i32 %116, 0, !dbg !3164
  br i1 %117, label %118, label %60, !dbg !3166, !llvm.loop !3167

; <label>:118:                                    ; preds = %115
  %119 = getelementptr inbounds i8, i8* %41, i32 %45, !dbg !3170
  tail call void @llvm.dbg.value(metadata i8* %119, i64 0, metadata !3010, metadata !173), !dbg !3027
  %120 = select i1 %46, i8* null, i8* %119, !dbg !3174
  tail call void @llvm.dbg.value(metadata i8* %120, i64 0, metadata !3010, metadata !173), !dbg !3027
  %121 = sub i32 %39, %45, !dbg !3175
  tail call void @llvm.dbg.value(metadata i32 %121, i64 0, metadata !3011, metadata !173), !dbg !3028
  br label %122, !dbg !3176

; <label>:122:                                    ; preds = %118, %113, %103
  %123 = phi i32 [ %121, %118 ], [ %39, %113 ], [ %39, %103 ]
  %124 = phi i8* [ %120, %118 ], [ %41, %113 ], [ %41, %103 ]
  tail call void @llvm.dbg.value(metadata i32 %94, i64 0, metadata !3017, metadata !173), !dbg !3039
  tail call void @llvm.dbg.value(metadata i32 %93, i64 0, metadata !3016, metadata !173), !dbg !3038
  tail call void @llvm.dbg.value(metadata i8* %124, i64 0, metadata !3010, metadata !173), !dbg !3027
  tail call void @llvm.dbg.value(metadata i32 %92, i64 0, metadata !3014, metadata !173), !dbg !3031
  tail call void @llvm.dbg.value(metadata i32 %123, i64 0, metadata !3011, metadata !173), !dbg !3028
  %125 = icmp eq i32 %123, 0, !dbg !3177
  br i1 %125, label %126, label %38, !dbg !3177, !llvm.loop !3054

; <label>:126:                                    ; preds = %122
  tail call void @delay(i32 100) #9, !dbg !3179
  br label %128, !dbg !3180

; <label>:127:                                    ; preds = %84
  br label %128, !dbg !3181

; <label>:128:                                    ; preds = %127, %126, %108, %98, %69, %7
  %129 = phi i32 [ -1, %7 ], [ %5, %126 ], [ -16, %108 ], [ -10, %98 ], [ -9, %69 ], [ -10, %127 ]
  ret i32 %129, !dbg !3181
}

; Function Attrs: minsize nounwind optsize
define i32 @usb0_h_ep_read_async(i8 zeroext, i8 zeroext, i8 zeroext, i8*, i32, i32, i32) local_unnamed_addr #3 !dbg !3182 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !3186, metadata !173), !dbg !3202
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !3187, metadata !173), !dbg !3203
  tail call void @llvm.dbg.value(metadata i8 %2, i64 0, metadata !3188, metadata !173), !dbg !3204
  tail call void @llvm.dbg.value(metadata i8* %3, i64 0, metadata !3189, metadata !173), !dbg !3205
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !3190, metadata !173), !dbg !3206
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !3191, metadata !173), !dbg !3207
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !3192, metadata !173), !dbg !3208
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3193, metadata !173), !dbg !3209
  %8 = icmp eq i32 %6, 0, !dbg !3210
  %9 = zext i8 %1 to i32
  %10 = tail call i8* @usb_get_dma_raddr(i8 zeroext %0, i32 %9) #10, !dbg !3211
  br i1 %8, label %22, label %11, !dbg !3212

; <label>:11:                                     ; preds = %7
  tail call void @llvm.dbg.value(metadata i8* %10, i64 0, metadata !3194, metadata !173), !dbg !3213
  %12 = icmp eq i8* %10, null, !dbg !3214
  br i1 %12, label %51, label %13, !dbg !3216

; <label>:13:                                     ; preds = %11
  %14 = tail call i32 @usb_read_devctl(i8 zeroext %0) #10, !dbg !3217
  %15 = and i32 %14, 4, !dbg !3219
  %16 = icmp eq i32 %15, 0, !dbg !3220
  br i1 %16, label %17, label %18, !dbg !3221

; <label>:17:                                     ; preds = %13
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.8, i32 0, i32 0), i32 1702) #9, !dbg !3222
  br label %51, !dbg !3225

; <label>:18:                                     ; preds = %13
  tail call void @sys_local_irq_disable() #9, !dbg !3226
  tail call void @musb_write_index(i8 zeroext %0, i32 %9) #10, !dbg !3229
  %19 = shl i32 %5, 4, !dbg !3230
  %20 = zext i8 %2 to i32, !dbg !3231
  %21 = or i32 %19, %20, !dbg !3232
  tail call void @musb_write_usb(i8 zeroext %0, i32 26, i32 %21) #10, !dbg !3233
  tail call void @musb_write_usb(i8 zeroext %0, i32 20, i32 32) #10, !dbg !3234
  tail call void @sys_local_irq_enable() #9, !dbg !3235
  br label %51, !dbg !3238

; <label>:22:                                     ; preds = %7
  tail call void @llvm.dbg.value(metadata i8* %10, i64 0, metadata !3197, metadata !173), !dbg !3239
  tail call void @sys_local_irq_disable() #9, !dbg !3240
  tail call void @musb_write_index(i8 zeroext %0, i32 %9) #10, !dbg !3243
  %23 = tail call i32 @musb_read_usb(i8 zeroext %0, i32 20) #10, !dbg !3244
  tail call void @llvm.dbg.value(metadata i32 %23, i64 0, metadata !3201, metadata !173), !dbg !3245
  %24 = and i32 %23, 1, !dbg !3246
  %25 = icmp eq i32 %24, 0, !dbg !3246
  br i1 %25, label %35, label %26, !dbg !3248

; <label>:26:                                     ; preds = %22
  %27 = tail call i32 @musb_read_usb(i8 zeroext %0, i32 22) #10, !dbg !3249
  %28 = tail call i32 @musb_read_usb(i8 zeroext %0, i32 23) #10, !dbg !3251
  %29 = shl i32 %28, 8, !dbg !3253
  %30 = or i32 %29, %27, !dbg !3254
  tail call void @llvm.dbg.value(metadata i32 %30, i64 0, metadata !3193, metadata !173), !dbg !3209
  %31 = icmp ult i32 %30, %4, !dbg !3255
  %32 = select i1 %31, i32 %30, i32 %4, !dbg !3255
  tail call void @llvm.dbg.value(metadata i32 %32, i64 0, metadata !3193, metadata !173), !dbg !3209
  %33 = icmp eq i8* %3, null, !dbg !3256
  br i1 %33, label %48, label %34, !dbg !3258

; <label>:34:                                     ; preds = %26
  tail call void asm sideeffect "ssync", ""() #7, !dbg !3259, !srcloc !3261
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull %3, i8* %10, i32 %32, i32 1, i1 false), !dbg !3262
  br label %48, !dbg !3263

; <label>:35:                                     ; preds = %22
  %36 = and i32 %23, 64, !dbg !3264
  %37 = icmp eq i32 %36, 0, !dbg !3264
  br i1 %37, label %40, label %38, !dbg !3267

; <label>:38:                                     ; preds = %35
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.10, i32 0, i32 0)) #9, !dbg !3269
  %39 = and i32 %23, -65, !dbg !3272
  tail call void @llvm.dbg.value(metadata i32 %39, i64 0, metadata !3201, metadata !173), !dbg !3245
  tail call void @llvm.dbg.value(metadata i32 -16, i64 0, metadata !3193, metadata !173), !dbg !3209
  br label %48, !dbg !3273

; <label>:40:                                     ; preds = %35
  %41 = and i32 %23, 8, !dbg !3274
  %42 = icmp eq i32 %41, 0, !dbg !3274
  br i1 %42, label %44, label %43, !dbg !3277

; <label>:43:                                     ; preds = %40
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.11, i32 0, i32 0)) #9, !dbg !3278
  tail call void @llvm.dbg.value(metadata i32 128, i64 0, metadata !3201, metadata !173), !dbg !3245
  tail call void @llvm.dbg.value(metadata i32 -11, i64 0, metadata !3193, metadata !173), !dbg !3209
  br label %48, !dbg !3281

; <label>:44:                                     ; preds = %40
  %45 = and i32 %23, 4, !dbg !3282
  %46 = icmp eq i32 %45, 0, !dbg !3282
  br i1 %46, label %48, label %47, !dbg !3285

; <label>:47:                                     ; preds = %44
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.12, i32 0, i32 0)) #9, !dbg !3286
  tail call void @llvm.dbg.value(metadata i32 128, i64 0, metadata !3201, metadata !173), !dbg !3245
  tail call void @llvm.dbg.value(metadata i32 -6, i64 0, metadata !3193, metadata !173), !dbg !3209
  br label %48, !dbg !3289

; <label>:48:                                     ; preds = %47, %44, %43, %38, %34, %26
  %49 = phi i32 [ -16, %38 ], [ -11, %43 ], [ -6, %47 ], [ 0, %44 ], [ %32, %26 ], [ %32, %34 ]
  %50 = phi i32 [ %39, %38 ], [ 128, %43 ], [ 128, %47 ], [ %23, %44 ], [ 16, %26 ], [ 16, %34 ]
  tail call void @llvm.dbg.value(metadata i32 %50, i64 0, metadata !3201, metadata !173), !dbg !3245
  tail call void @llvm.dbg.value(metadata i32 %49, i64 0, metadata !3193, metadata !173), !dbg !3209
  tail call void @musb_write_usb(i8 zeroext %0, i32 20, i32 %50) #10, !dbg !3290
  tail call void @sys_local_irq_enable() #9, !dbg !3291
  tail call void @llvm.dbg.value(metadata i32 %49, i64 0, metadata !3193, metadata !173), !dbg !3209
  br label %51, !dbg !3294

; <label>:51:                                     ; preds = %48, %18, %17, %11
  %52 = phi i32 [ %49, %48 ], [ -10, %17 ], [ 0, %18 ], [ -1, %11 ]
  ret i32 %52, !dbg !3295
}

; Function Attrs: minsize nounwind optsize
define weak i32 @usb1_rx_err_handle(i32) local_unnamed_addr #3 !dbg !3296 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !3300, metadata !173), !dbg !3301
  ret i32 undef, !dbg !3302
}

; Function Attrs: minsize nounwind optsize
define i32 @usb1_h_ep_read_async(i8 zeroext, i8 zeroext, i8 zeroext, i8*, i32, i32, i32) local_unnamed_addr #3 !dbg !3303 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !3305, metadata !173), !dbg !3321
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !3306, metadata !173), !dbg !3322
  tail call void @llvm.dbg.value(metadata i8 %2, i64 0, metadata !3307, metadata !173), !dbg !3323
  tail call void @llvm.dbg.value(metadata i8* %3, i64 0, metadata !3308, metadata !173), !dbg !3324
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !3309, metadata !173), !dbg !3325
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !3310, metadata !173), !dbg !3326
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !3311, metadata !173), !dbg !3327
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3312, metadata !173), !dbg !3328
  %8 = icmp eq i32 %6, 0, !dbg !3329
  %9 = zext i8 %1 to i32
  %10 = tail call i8* @usb_get_dma_raddr(i8 zeroext %0, i32 %9) #10, !dbg !3330
  br i1 %8, label %32, label %11, !dbg !3331

; <label>:11:                                     ; preds = %7
  tail call void @llvm.dbg.value(metadata i8* %10, i64 0, metadata !3313, metadata !173), !dbg !3332
  %12 = icmp eq i8* %10, null, !dbg !3333
  br i1 %12, label %59, label %13, !dbg !3335

; <label>:13:                                     ; preds = %11
  %14 = tail call i32 @usb_read_devctl(i8 zeroext %0) #10, !dbg !3336
  %15 = and i32 %14, 4, !dbg !3338
  %16 = icmp eq i32 %15, 0, !dbg !3339
  br i1 %16, label %17, label %18, !dbg !3340

; <label>:17:                                     ; preds = %13
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.8, i32 0, i32 0), i32 1763) #9, !dbg !3341
  br label %59, !dbg !3344

; <label>:18:                                     ; preds = %13
  %19 = zext i8 %0 to i32, !dbg !3345
  %20 = getelementptr inbounds [2 x i8], [2 x i8]* @host_speed, i32 0, i32 %19, !dbg !3345
  %21 = load i8, i8* %20, align 1, !dbg !3345, !tbaa !692
  %22 = zext i8 %21 to i32, !dbg !3345
  %23 = add nsw i32 %22, -1, !dbg !3346
  %24 = getelementptr inbounds [3 x i8], [3 x i8]* @speed_table, i32 0, i32 %23, !dbg !3347
  %25 = load i8, i8* %24, align 1, !dbg !3347, !tbaa !692
  %26 = zext i8 %25 to i32, !dbg !3347
  %27 = shl nuw nsw i32 %26, 6, !dbg !3348
  %28 = shl i32 %5, 4, !dbg !3349
  %29 = zext i8 %2 to i32, !dbg !3350
  %30 = or i32 %28, %29, !dbg !3351
  %31 = or i32 %30, %27, !dbg !3352
  tail call void @usb_write_rxtype(i8 zeroext %0, i32 %9, i32 %31) #10, !dbg !3353
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %9, i32 32) #10, !dbg !3354
  br label %59, !dbg !3355

; <label>:32:                                     ; preds = %7
  tail call void @llvm.dbg.value(metadata i8* %10, i64 0, metadata !3316, metadata !173), !dbg !3356
  %33 = tail call i32 @usb_read_rxcsr(i8 zeroext %0, i32 %9) #10, !dbg !3357
  tail call void @llvm.dbg.value(metadata i32 %33, i64 0, metadata !3320, metadata !173), !dbg !3358
  %34 = and i32 %33, 1, !dbg !3359
  %35 = icmp eq i32 %34, 0, !dbg !3359
  br i1 %35, label %42, label %36, !dbg !3361

; <label>:36:                                     ; preds = %32
  %37 = tail call i32 @usb_read_rxcount(i8 zeroext %0, i32 %9) #10, !dbg !3362
  tail call void @llvm.dbg.value(metadata i32 %37, i64 0, metadata !3312, metadata !173), !dbg !3328
  %38 = icmp ult i32 %37, %4, !dbg !3364
  %39 = select i1 %38, i32 %37, i32 %4, !dbg !3364
  tail call void @llvm.dbg.value(metadata i32 %39, i64 0, metadata !3312, metadata !173), !dbg !3328
  %40 = icmp eq i8* %3, null, !dbg !3365
  br i1 %40, label %56, label %41, !dbg !3367

; <label>:41:                                     ; preds = %36
  tail call void asm sideeffect "ssync", ""() #7, !dbg !3368, !srcloc !3370
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull %3, i8* %10, i32 %39, i32 1, i1 false), !dbg !3371
  br label %56, !dbg !3372

; <label>:42:                                     ; preds = %32
  %43 = and i32 %33, 64, !dbg !3373
  %44 = icmp eq i32 %43, 0, !dbg !3373
  br i1 %44, label %47, label %45, !dbg !3376

; <label>:45:                                     ; preds = %42
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.10, i32 0, i32 0)) #9, !dbg !3378
  %46 = and i32 %33, -65, !dbg !3381
  tail call void @llvm.dbg.value(metadata i32 %46, i64 0, metadata !3320, metadata !173), !dbg !3358
  tail call void @llvm.dbg.value(metadata i32 -16, i64 0, metadata !3312, metadata !173), !dbg !3328
  br label %56, !dbg !3382

; <label>:47:                                     ; preds = %42
  %48 = and i32 %33, 8, !dbg !3383
  %49 = icmp eq i32 %48, 0, !dbg !3383
  br i1 %49, label %51, label %50, !dbg !3386

; <label>:50:                                     ; preds = %47
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.11, i32 0, i32 0)) #9, !dbg !3387
  tail call void @llvm.dbg.value(metadata i32 128, i64 0, metadata !3320, metadata !173), !dbg !3358
  tail call void @llvm.dbg.value(metadata i32 -11, i64 0, metadata !3312, metadata !173), !dbg !3328
  br label %56, !dbg !3390

; <label>:51:                                     ; preds = %47
  %52 = and i32 %33, 4, !dbg !3391
  %53 = icmp eq i32 %52, 0, !dbg !3391
  br i1 %53, label %56, label %54, !dbg !3394

; <label>:54:                                     ; preds = %51
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.12, i32 0, i32 0)) #9, !dbg !3395
  tail call void @llvm.dbg.value(metadata i32 128, i64 0, metadata !3320, metadata !173), !dbg !3358
  tail call void @llvm.dbg.value(metadata i32 -6, i64 0, metadata !3312, metadata !173), !dbg !3328
  %55 = tail call i32 @usb1_rx_err_handle(i32 -6) #10, !dbg !3398
  br label %56, !dbg !3399

; <label>:56:                                     ; preds = %54, %51, %50, %45, %41, %36
  %57 = phi i32 [ -16, %45 ], [ -11, %50 ], [ -6, %54 ], [ 0, %51 ], [ %39, %36 ], [ %39, %41 ]
  %58 = phi i32 [ %46, %45 ], [ 128, %50 ], [ 128, %54 ], [ %33, %51 ], [ 16, %36 ], [ 16, %41 ]
  tail call void @llvm.dbg.value(metadata i32 %58, i64 0, metadata !3320, metadata !173), !dbg !3358
  tail call void @llvm.dbg.value(metadata i32 %57, i64 0, metadata !3312, metadata !173), !dbg !3328
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %9, i32 %58) #10, !dbg !3400
  tail call void @llvm.dbg.value(metadata i32 %57, i64 0, metadata !3312, metadata !173), !dbg !3328
  br label %59, !dbg !3401

; <label>:59:                                     ; preds = %56, %18, %17, %11
  %60 = phi i32 [ %57, %56 ], [ -10, %17 ], [ 0, %18 ], [ -1, %11 ]
  ret i32 %60, !dbg !3402
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_ep_read_async(i8 zeroext, i8 zeroext, i8 zeroext, i8*, i32, i32, i32) local_unnamed_addr #3 !dbg !3403 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !3405, metadata !173), !dbg !3412
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !3406, metadata !173), !dbg !3413
  tail call void @llvm.dbg.value(metadata i8 %2, i64 0, metadata !3407, metadata !173), !dbg !3414
  tail call void @llvm.dbg.value(metadata i8* %3, i64 0, metadata !3408, metadata !173), !dbg !3415
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !3409, metadata !173), !dbg !3416
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !3410, metadata !173), !dbg !3417
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !3411, metadata !173), !dbg !3418
  %8 = icmp eq i8 %0, 0, !dbg !3419
  br i1 %8, label %9, label %11, !dbg !3421

; <label>:9:                                      ; preds = %7
  %10 = tail call i32 @usb0_h_ep_read_async(i8 zeroext 0, i8 zeroext %1, i8 zeroext %2, i8* %3, i32 %4, i32 %5, i32 %6) #10, !dbg !3422
  br label %13, !dbg !3424

; <label>:11:                                     ; preds = %7
  %12 = tail call i32 @usb1_h_ep_read_async(i8 zeroext 1, i8 zeroext %1, i8 zeroext %2, i8* %3, i32 %4, i32 %5, i32 %6) #10, !dbg !3425
  br label %13, !dbg !3427

; <label>:13:                                     ; preds = %11, %9
  %14 = phi i32 [ %10, %9 ], [ %12, %11 ]
  ret i32 %14, !dbg !3428
}

; Function Attrs: minsize nounwind optsize
define i32 @usb1_h_ep_burst_read_async(i8 zeroext, i8 zeroext, i8 zeroext, i32, i32*, i8*, i32, i32, i32) local_unnamed_addr #3 !dbg !3429 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !3433, metadata !173), !dbg !3455
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !3434, metadata !173), !dbg !3456
  tail call void @llvm.dbg.value(metadata i8 %2, i64 0, metadata !3435, metadata !173), !dbg !3457
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !3436, metadata !173), !dbg !3458
  tail call void @llvm.dbg.value(metadata i32* %4, i64 0, metadata !3437, metadata !173), !dbg !3459
  tail call void @llvm.dbg.value(metadata i8* %5, i64 0, metadata !3438, metadata !173), !dbg !3460
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !3439, metadata !173), !dbg !3461
  tail call void @llvm.dbg.value(metadata i32 %7, i64 0, metadata !3440, metadata !173), !dbg !3462
  tail call void @llvm.dbg.value(metadata i32 %8, i64 0, metadata !3441, metadata !173), !dbg !3463
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3442, metadata !173), !dbg !3464
  %10 = zext i8 %1 to i32, !dbg !3465
  %11 = add i8 %1, -3, !dbg !3467
  %12 = icmp ult i8 %11, 2, !dbg !3467
  br i1 %12, label %13, label %104, !dbg !3467

; <label>:13:                                     ; preds = %9
  %14 = icmp eq i32 %8, 0, !dbg !3468
  br i1 %14, label %37, label %15, !dbg !3469

; <label>:15:                                     ; preds = %13
  %16 = tail call i8* @usb_get_dma_raddr(i8 zeroext %0, i32 %10) #10, !dbg !3470
  tail call void @llvm.dbg.value(metadata i8* %16, i64 0, metadata !3443, metadata !173), !dbg !3471
  %17 = icmp eq i8* %16, null, !dbg !3472
  br i1 %17, label %104, label %18, !dbg !3474

; <label>:18:                                     ; preds = %15
  %19 = tail call i32 @usb_read_devctl(i8 zeroext %0) #10, !dbg !3475
  %20 = and i32 %19, 4, !dbg !3477
  %21 = icmp eq i32 %20, 0, !dbg !3478
  br i1 %21, label %22, label %23, !dbg !3479

; <label>:22:                                     ; preds = %18
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.8, i32 0, i32 0), i32 1831) #9, !dbg !3480
  br label %104, !dbg !3483

; <label>:23:                                     ; preds = %18
  %24 = zext i8 %0 to i32, !dbg !3484
  %25 = getelementptr inbounds [2 x i8], [2 x i8]* @host_speed, i32 0, i32 %24, !dbg !3484
  %26 = load i8, i8* %25, align 1, !dbg !3484, !tbaa !692
  %27 = zext i8 %26 to i32, !dbg !3484
  %28 = add nsw i32 %27, -1, !dbg !3485
  %29 = getelementptr inbounds [3 x i8], [3 x i8]* @speed_table, i32 0, i32 %28, !dbg !3486
  %30 = load i8, i8* %29, align 1, !dbg !3486, !tbaa !692
  %31 = zext i8 %30 to i32, !dbg !3486
  %32 = shl nuw nsw i32 %31, 6, !dbg !3487
  %33 = shl i32 %7, 4, !dbg !3488
  %34 = zext i8 %2 to i32, !dbg !3489
  %35 = or i32 %33, %34, !dbg !3490
  %36 = or i32 %35, %32, !dbg !3491
  tail call void @usb_write_rxtype(i8 zeroext %0, i32 %10, i32 %36) #10, !dbg !3492
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %10, i32 32) #10, !dbg !3493
  br label %104, !dbg !3494

; <label>:37:                                     ; preds = %13
  %38 = icmp eq i32 %3, 0, !dbg !3495
  %39 = icmp eq i32* %4, null, !dbg !3497
  %40 = or i1 %38, %39, !dbg !3499
  br i1 %40, label %104, label %41, !dbg !3499

; <label>:41:                                     ; preds = %37
  %42 = zext i8 %0 to i32, !dbg !3500
  %43 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %42, !dbg !3500
  %44 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %43, align 4, !dbg !3500, !tbaa !244
  %45 = add nsw i32 %10, -1, !dbg !3501
  %46 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %44, i32 0, i32 4, i32 %45, !dbg !3500
  %47 = bitcast i32* %46 to i8**, !dbg !3500
  %48 = load i8*, i8** %47, align 4, !dbg !3500, !tbaa !214
  tail call void @llvm.dbg.value(metadata i8* %48, i64 0, metadata !3446, metadata !173), !dbg !3502
  %49 = tail call i32 @usb_read_rxcsr(i8 zeroext %0, i32 %10) #10, !dbg !3503
  tail call void @llvm.dbg.value(metadata i32 %49, i64 0, metadata !3450, metadata !173), !dbg !3504
  %50 = and i32 %49, 1, !dbg !3505
  %51 = icmp eq i32 %50, 0, !dbg !3505
  br i1 %51, label %87, label %52, !dbg !3506

; <label>:52:                                     ; preds = %41
  tail call void @llvm.dbg.value(metadata i32* inttoptr (i32 92240 to i32*), i64 0, metadata !3449, metadata !173), !dbg !3507
  %53 = add nsw i32 %10, -3, !dbg !3508
  %54 = getelementptr inbounds i32, i32* inttoptr (i32 92240 to i32*), i32 %53, !dbg !3509
  tail call void @llvm.dbg.value(metadata i32* %54, i64 0, metadata !3449, metadata !173), !dbg !3507
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3451, metadata !173), !dbg !3510
  br label %55, !dbg !3511

; <label>:55:                                     ; preds = %78, %52
  %56 = phi i32 [ %6, %52 ], [ %85, %78 ]
  %57 = phi i32 [ 0, %52 ], [ %81, %78 ]
  %58 = phi i8* [ %5, %52 ], [ %80, %78 ]
  %59 = phi i8* [ %48, %52 ], [ %84, %78 ]
  %60 = phi i32 [ 0, %52 ], [ %86, %78 ]
  tail call void @llvm.dbg.value(metadata i32 %60, i64 0, metadata !3451, metadata !173), !dbg !3510
  tail call void @llvm.dbg.value(metadata i8* %59, i64 0, metadata !3446, metadata !173), !dbg !3502
  tail call void @llvm.dbg.value(metadata i8* %58, i64 0, metadata !3438, metadata !173), !dbg !3460
  tail call void @llvm.dbg.value(metadata i32 %57, i64 0, metadata !3442, metadata !173), !dbg !3464
  tail call void @llvm.dbg.value(metadata i32 %56, i64 0, metadata !3439, metadata !173), !dbg !3461
  %61 = icmp eq i32 %60, %3, !dbg !3512
  br i1 %61, label %100, label %62, !dbg !3515

; <label>:62:                                     ; preds = %55
  %63 = load volatile i32, i32* %54, align 4, !dbg !3517, !tbaa !214
  %64 = and i32 %63, -29, !dbg !3517
  %65 = shl i32 %60, 2, !dbg !3517
  %66 = and i32 %65, 28, !dbg !3517
  %67 = or i32 %64, %66, !dbg !3517
  store volatile i32 %67, i32* %54, align 4, !dbg !3517, !tbaa !214
  tail call void @llvm.pi32v2.csync(), !dbg !3519
  tail call void @llvm.pi32v2.csync(), !dbg !3520
  tail call void @llvm.pi32v2.csync(), !dbg !3521
  tail call void @llvm.pi32v2.csync(), !dbg !3522
  tail call void @llvm.pi32v2.csync(), !dbg !3523
  %68 = load volatile i32, i32* %54, align 4, !dbg !3524, !tbaa !214
  %69 = lshr i32 %68, 5, !dbg !3525
  %70 = and i32 %69, 4095, !dbg !3526
  %71 = getelementptr inbounds i32, i32* %4, i32 %60, !dbg !3527
  store i32 %70, i32* %71, align 4, !dbg !3528, !tbaa !214
  %72 = icmp ult i32 %70, %56, !dbg !3529
  %73 = select i1 %72, i32 %70, i32 %56, !dbg !3530
  tail call void @llvm.dbg.value(metadata i32 %73, i64 0, metadata !3448, metadata !173), !dbg !3532
  %74 = icmp eq i8* %58, null, !dbg !3533
  br i1 %74, label %78, label %75, !dbg !3535

; <label>:75:                                     ; preds = %62
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull %58, i8* %59, i32 %73, i32 1, i1 false), !dbg !3536
  %76 = getelementptr inbounds i8, i8* %58, i32 %73, !dbg !3538
  tail call void @llvm.dbg.value(metadata i8* %76, i64 0, metadata !3438, metadata !173), !dbg !3460
  %77 = load i32, i32* %71, align 4, !tbaa !214
  br label %78, !dbg !3539

; <label>:78:                                     ; preds = %75, %62
  %79 = phi i32 [ %77, %75 ], [ %70, %62 ], !dbg !3540
  %80 = phi i8* [ %76, %75 ], [ null, %62 ]
  tail call void @llvm.dbg.value(metadata i8* %80, i64 0, metadata !3438, metadata !173), !dbg !3460
  %81 = add i32 %79, %57, !dbg !3541
  tail call void @llvm.dbg.value(metadata i32 %81, i64 0, metadata !3442, metadata !173), !dbg !3464
  %82 = add i32 %79, 3, !dbg !3542
  %83 = and i32 %82, -4, !dbg !3543
  %84 = getelementptr inbounds i8, i8* %59, i32 %83, !dbg !3544
  tail call void @llvm.dbg.value(metadata i8* %84, i64 0, metadata !3446, metadata !173), !dbg !3502
  %85 = sub i32 %56, %73, !dbg !3545
  tail call void @llvm.dbg.value(metadata i32 %85, i64 0, metadata !3439, metadata !173), !dbg !3461
  %86 = add nuw nsw i32 %60, 1, !dbg !3546
  tail call void @llvm.dbg.value(metadata i32 %86, i64 0, metadata !3451, metadata !173), !dbg !3510
  br label %55, !dbg !3548, !llvm.loop !3549

; <label>:87:                                     ; preds = %41
  %88 = and i32 %49, 64, !dbg !3552
  %89 = icmp eq i32 %88, 0, !dbg !3552
  br i1 %89, label %92, label %90, !dbg !3555

; <label>:90:                                     ; preds = %87
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.10, i32 0, i32 0)) #9, !dbg !3557
  %91 = and i32 %49, -65, !dbg !3560
  tail call void @llvm.dbg.value(metadata i32 %91, i64 0, metadata !3450, metadata !173), !dbg !3504
  tail call void @llvm.dbg.value(metadata i32 -16, i64 0, metadata !3442, metadata !173), !dbg !3464
  br label %101, !dbg !3561

; <label>:92:                                     ; preds = %87
  %93 = and i32 %49, 8, !dbg !3562
  %94 = icmp eq i32 %93, 0, !dbg !3562
  br i1 %94, label %96, label %95, !dbg !3565

; <label>:95:                                     ; preds = %92
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.11, i32 0, i32 0)) #9, !dbg !3566
  tail call void @llvm.dbg.value(metadata i32 128, i64 0, metadata !3450, metadata !173), !dbg !3504
  tail call void @llvm.dbg.value(metadata i32 -11, i64 0, metadata !3442, metadata !173), !dbg !3464
  br label %101, !dbg !3569

; <label>:96:                                     ; preds = %92
  %97 = and i32 %49, 4, !dbg !3570
  %98 = icmp eq i32 %97, 0, !dbg !3570
  br i1 %98, label %101, label %99, !dbg !3573

; <label>:99:                                     ; preds = %96
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.12, i32 0, i32 0)) #9, !dbg !3574
  tail call void @llvm.dbg.value(metadata i32 128, i64 0, metadata !3450, metadata !173), !dbg !3504
  tail call void @llvm.dbg.value(metadata i32 -6, i64 0, metadata !3442, metadata !173), !dbg !3464
  br label %101, !dbg !3577

; <label>:100:                                    ; preds = %55
  br label %101, !dbg !3504

; <label>:101:                                    ; preds = %100, %99, %96, %95, %90
  %102 = phi i32 [ -16, %90 ], [ -11, %95 ], [ -6, %99 ], [ 0, %96 ], [ %57, %100 ]
  %103 = phi i32 [ %91, %90 ], [ 128, %95 ], [ 128, %99 ], [ %49, %96 ], [ 16, %100 ]
  tail call void @llvm.dbg.value(metadata i32 %103, i64 0, metadata !3450, metadata !173), !dbg !3504
  tail call void @llvm.dbg.value(metadata i32 %102, i64 0, metadata !3442, metadata !173), !dbg !3464
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %10, i32 %103) #10, !dbg !3578
  br label %104

; <label>:104:                                    ; preds = %101, %37, %23, %22, %15, %9
  %105 = phi i32 [ %102, %101 ], [ -31, %37 ], [ -31, %9 ], [ -10, %22 ], [ 0, %23 ], [ -1, %15 ]
  ret i32 %105
}

; Function Attrs: nounwind
declare void @llvm.pi32v2.csync() #7

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_ep_burst_read_async(i8 zeroext, i8 zeroext, i8 zeroext, i32, i32*, i8*, i32, i32, i32) local_unnamed_addr #3 !dbg !3579 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !3581, metadata !173), !dbg !3590
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !3582, metadata !173), !dbg !3591
  tail call void @llvm.dbg.value(metadata i8 %2, i64 0, metadata !3583, metadata !173), !dbg !3592
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !3584, metadata !173), !dbg !3593
  tail call void @llvm.dbg.value(metadata i32* %4, i64 0, metadata !3585, metadata !173), !dbg !3594
  tail call void @llvm.dbg.value(metadata i8* %5, i64 0, metadata !3586, metadata !173), !dbg !3595
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !3587, metadata !173), !dbg !3596
  tail call void @llvm.dbg.value(metadata i32 %7, i64 0, metadata !3588, metadata !173), !dbg !3597
  tail call void @llvm.dbg.value(metadata i32 %8, i64 0, metadata !3589, metadata !173), !dbg !3598
  %10 = icmp eq i8 %0, 1, !dbg !3599
  br i1 %10, label %11, label %13, !dbg !3601

; <label>:11:                                     ; preds = %9
  %12 = tail call i32 @usb1_h_ep_burst_read_async(i8 zeroext 1, i8 zeroext %1, i8 zeroext %2, i32 %3, i32* %4, i8* %5, i32 %6, i32 %7, i32 %8) #10, !dbg !3602
  br label %13, !dbg !3604

; <label>:13:                                     ; preds = %11, %9
  %14 = phi i32 [ %12, %11 ], [ 0, %9 ]
  ret i32 %14, !dbg !3605
}

; Function Attrs: minsize nounwind optsize
define i32 @usb0_h_ep_read(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32, i32) local_unnamed_addr #3 !dbg !3606 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !3610, metadata !173), !dbg !3629
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !3611, metadata !173), !dbg !3630
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !3612, metadata !173), !dbg !3631
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !3613, metadata !173), !dbg !3632
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !3614, metadata !173), !dbg !3633
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !3615, metadata !173), !dbg !3634
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !3616, metadata !173), !dbg !3635
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !3617, metadata !173), !dbg !3636
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3620, metadata !173), !dbg !3637
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !3621, metadata !173), !dbg !3638
  tail call void @sys_local_irq_disable() #9, !dbg !3639
  %8 = zext i8 %1 to i32, !dbg !3642
  tail call void @musb_write_index(i8 zeroext %0, i32 %8) #10, !dbg !3643
  %9 = shl i32 %6, 4, !dbg !3644
  %10 = zext i8 %3 to i32, !dbg !3645
  %11 = or i32 %9, %10, !dbg !3646
  tail call void @musb_write_usb(i8 zeroext %0, i32 26, i32 %11) #10, !dbg !3647
  tail call void @musb_write_usb(i8 zeroext %0, i32 20, i32 32) #10, !dbg !3648
  tail call void @sys_local_irq_enable() #9, !dbg !3649
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3622, metadata !173), !dbg !3652
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3623, metadata !173), !dbg !3653
  %12 = zext i8 %0 to i32, !dbg !3654
  %13 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %12, !dbg !3654
  %14 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %13, align 4, !dbg !3654, !tbaa !244
  %15 = icmp eq %struct.usb_ep_addr_t* %14, null, !dbg !3654
  br i1 %15, label %16, label %19, !dbg !3656

; <label>:16:                                     ; preds = %7
  %17 = load volatile i32, i32* @jiffies, align 4, !dbg !3657, !tbaa !193
  %18 = add i32 %17, 20, !dbg !3660
  tail call void @llvm.dbg.value(metadata i32 %18, i64 0, metadata !3623, metadata !173), !dbg !3653
  tail call void @llvm.dbg.value(metadata i32 %27, i64 0, metadata !3623, metadata !173), !dbg !3653
  br label %31, !dbg !3661

; <label>:19:                                     ; preds = %7
  %20 = add nsw i32 %8, -1, !dbg !3662
  %21 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %14, i32 0, i32 7, i32 %20, !dbg !3664
  %22 = load i32, i32* %21, align 4, !dbg !3664, !tbaa !214
  tail call void @llvm.dbg.value(metadata i32 %22, i64 0, metadata !3624, metadata !173), !dbg !3665
  %23 = load volatile i32, i32* @jiffies, align 4, !dbg !3666, !tbaa !193
  %24 = udiv i32 %5, %22, !dbg !3668
  %25 = shl i32 %24, 1, !dbg !3669
  tail call void @llvm.dbg.value(metadata i32 %26, i64 0, metadata !3623, metadata !173), !dbg !3653
  %26 = add i32 %23, 200, !dbg !3670
  %27 = add i32 %26, %25, !dbg !3671
  tail call void @llvm.dbg.value(metadata i32 %27, i64 0, metadata !3623, metadata !173), !dbg !3653
  tail call void @llvm.dbg.value(metadata i32 %27, i64 0, metadata !3623, metadata !173), !dbg !3653
  %28 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %14, i32 0, i32 5, i32 %8, !dbg !3672
  %29 = load i32, i32* %28, align 4, !dbg !3672, !tbaa !214
  %30 = icmp ne i32 %29, 0
  br label %31

; <label>:31:                                     ; preds = %19, %16
  %32 = phi i32 [ %27, %19 ], [ %18, %16 ]
  %33 = phi i1 [ %30, %19 ], [ false, %16 ]
  %34 = add nsw i32 %8, -1
  br label %35, !dbg !3653

; <label>:35:                                     ; preds = %119, %31
  %36 = phi i32 [ %5, %31 ], [ %107, %119 ]
  %37 = phi i8* [ %4, %31 ], [ %114, %119 ]
  %38 = phi i32 [ %5, %31 ], [ %45, %119 ]
  %39 = phi i32 [ undef, %31 ], [ %93, %119 ]
  %40 = phi i32 [ 0, %31 ], [ %85, %119 ]
  %41 = phi i32 [ 0, %31 ], [ %86, %119 ]
  %42 = phi i32 [ %32, %31 ], [ %87, %119 ]
  %43 = icmp eq i32 %36, 0
  br label %44, !dbg !3676

; <label>:44:                                     ; preds = %134, %35
  %45 = phi i32 [ %38, %35 ], [ %135, %134 ]
  %46 = phi i32 [ %39, %35 ], [ %136, %134 ]
  %47 = phi i32 [ %40, %35 ], [ %85, %134 ]
  %48 = phi i32 [ %41, %35 ], [ %86, %134 ]
  %49 = phi i32 [ %42, %35 ], [ %87, %134 ]
  br label %50, !dbg !3678

; <label>:50:                                     ; preds = %133, %44
  %51 = phi i32 [ %93, %133 ], [ %46, %44 ]
  %52 = phi i32 [ %85, %133 ], [ %47, %44 ]
  %53 = phi i32 [ %86, %133 ], [ %48, %44 ]
  %54 = phi i32 [ %87, %133 ], [ %49, %44 ]
  tail call void @llvm.dbg.value(metadata i32 %54, i64 0, metadata !3623, metadata !173), !dbg !3653
  tail call void @llvm.dbg.value(metadata i32 %53, i64 0, metadata !3622, metadata !173), !dbg !3652
  tail call void @llvm.dbg.value(metadata i32 %52, i64 0, metadata !3620, metadata !173), !dbg !3637
  tail call void @llvm.dbg.value(metadata i32 %51, i64 0, metadata !3619, metadata !173), !dbg !3680
  tail call void @llvm.dbg.value(metadata i32 %45, i64 0, metadata !3617, metadata !173), !dbg !3636
  tail call void @llvm.dbg.value(metadata i8* %37, i64 0, metadata !3614, metadata !173), !dbg !3633
  tail call void @llvm.dbg.value(metadata i32 %36, i64 0, metadata !3615, metadata !173), !dbg !3634
  br i1 %43, label %138, label %55, !dbg !3681

; <label>:55:                                     ; preds = %50
  %56 = load volatile i32, i32* @jiffies, align 4, !dbg !3682, !tbaa !193
  %57 = icmp slt i32 %54, %56, !dbg !3685
  br i1 %57, label %58, label %84, !dbg !3686

; <label>:58:                                     ; preds = %55
  %59 = add i32 %53, 1, !dbg !3687
  tail call void @llvm.dbg.value(metadata i32 %59, i64 0, metadata !3622, metadata !173), !dbg !3652
  %60 = icmp ugt i32 %59, 10, !dbg !3689
  br i1 %60, label %61, label %62, !dbg !3691

; <label>:61:                                     ; preds = %58
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.13, i32 0, i32 0)) #9, !dbg !3692
  br label %140, !dbg !3695

; <label>:62:                                     ; preds = %58
  %63 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %13, align 4, !dbg !3696, !tbaa !244
  %64 = icmp eq %struct.usb_ep_addr_t* %63, null, !dbg !3696
  br i1 %64, label %73, label %65, !dbg !3698

; <label>:65:                                     ; preds = %62
  %66 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %63, i32 0, i32 7, i32 %34, !dbg !3699
  %67 = load i32, i32* %66, align 4, !dbg !3699, !tbaa !214
  tail call void @llvm.dbg.value(metadata i32 %67, i64 0, metadata !3624, metadata !173), !dbg !3665
  %68 = load volatile i32, i32* @jiffies, align 4, !dbg !3701, !tbaa !193
  %69 = udiv i32 %36, %67, !dbg !3703
  %70 = shl i32 %69, 1, !dbg !3704
  tail call void @llvm.dbg.value(metadata i32 %71, i64 0, metadata !3623, metadata !173), !dbg !3653
  %71 = add i32 %68, 200, !dbg !3705
  %72 = add i32 %71, %70, !dbg !3706
  tail call void @llvm.dbg.value(metadata i32 %72, i64 0, metadata !3623, metadata !173), !dbg !3653
  br label %76, !dbg !3707

; <label>:73:                                     ; preds = %62
  %74 = load volatile i32, i32* @jiffies, align 4, !dbg !3708, !tbaa !193
  %75 = add i32 %74, 20, !dbg !3711
  tail call void @llvm.dbg.value(metadata i32 %75, i64 0, metadata !3623, metadata !173), !dbg !3653
  br label %76

; <label>:76:                                     ; preds = %73, %65
  %77 = phi i32 [ %72, %65 ], [ %75, %73 ]
  tail call void @llvm.dbg.value(metadata i32 %77, i64 0, metadata !3623, metadata !173), !dbg !3653
  %78 = tail call i32 @usb_h_dev_status(i8 zeroext %0) #10, !dbg !3712
  %79 = icmp eq i32 %78, 0, !dbg !3712
  %80 = add i32 %52, 1, !dbg !3714
  tail call void @llvm.dbg.value(metadata i32 %80, i64 0, metadata !3620, metadata !173), !dbg !3637
  %81 = select i1 %79, i32 0, i32 %80, !dbg !3716
  tail call void @llvm.dbg.value(metadata i32 %81, i64 0, metadata !3620, metadata !173), !dbg !3637
  %82 = icmp ugt i32 %81, 5, !dbg !3717
  br i1 %82, label %138, label %83, !dbg !3719

; <label>:83:                                     ; preds = %76
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.14, i32 0, i32 0), i32 %51) #9, !dbg !3720
  br label %84, !dbg !3722

; <label>:84:                                     ; preds = %83, %55
  %85 = phi i32 [ %81, %83 ], [ %52, %55 ]
  %86 = phi i32 [ %59, %83 ], [ %53, %55 ]
  %87 = phi i32 [ %77, %83 ], [ %54, %55 ]
  tail call void @llvm.dbg.value(metadata i32 %87, i64 0, metadata !3623, metadata !173), !dbg !3653
  tail call void @llvm.dbg.value(metadata i32 %86, i64 0, metadata !3622, metadata !173), !dbg !3652
  tail call void @llvm.dbg.value(metadata i32 %85, i64 0, metadata !3620, metadata !173), !dbg !3637
  %88 = tail call i32 @usb_read_devctl(i8 zeroext %0) #10, !dbg !3723
  %89 = and i32 %88, 4, !dbg !3725
  %90 = icmp eq i32 %89, 0, !dbg !3726
  br i1 %90, label %91, label %92, !dbg !3727

; <label>:91:                                     ; preds = %84
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.8, i32 0, i32 0), i32 1966) #9, !dbg !3728
  br label %140, !dbg !3731

; <label>:92:                                     ; preds = %84
  tail call void @sys_local_irq_disable() #9, !dbg !3732
  tail call void @musb_write_index(i8 zeroext %0, i32 %8) #10, !dbg !3735
  %93 = tail call i32 @musb_read_usb(i8 zeroext %0, i32 20) #10, !dbg !3736
  tail call void @llvm.dbg.value(metadata i32 %93, i64 0, metadata !3619, metadata !173), !dbg !3680
  %94 = and i32 %93, 1, !dbg !3737
  %95 = icmp eq i32 %94, 0, !dbg !3737
  br i1 %95, label %120, label %96, !dbg !3738

; <label>:96:                                     ; preds = %92
  %97 = tail call i8* @usb_get_dma_raddr(i8 zeroext %0, i32 %8) #10, !dbg !3739
  tail call void @llvm.dbg.value(metadata i8* %97, i64 0, metadata !3618, metadata !173), !dbg !3740
  %98 = icmp eq i8* %97, null, !dbg !3741
  br i1 %98, label %99, label %100, !dbg !3743

; <label>:99:                                     ; preds = %96
  tail call void @sys_local_irq_enable() #9, !dbg !3744
  br label %140, !dbg !3748

; <label>:100:                                    ; preds = %96
  %101 = tail call i32 @musb_read_usb(i8 zeroext %0, i32 22) #10, !dbg !3749
  %102 = tail call i32 @musb_read_usb(i8 zeroext %0, i32 23) #10, !dbg !3750
  %103 = shl i32 %102, 8, !dbg !3752
  %104 = or i32 %103, %101, !dbg !3753
  tail call void @llvm.dbg.value(metadata i32 %104, i64 0, metadata !3625, metadata !173), !dbg !3754
  %105 = icmp ult i32 %104, %36, !dbg !3755
  %106 = select i1 %105, i32 %104, i32 %36, !dbg !3755
  tail call void @llvm.dbg.value(metadata i32 %106, i64 0, metadata !3625, metadata !173), !dbg !3754
  %107 = sub i32 %36, %106, !dbg !3756
  tail call void @llvm.dbg.value(metadata i32 %107, i64 0, metadata !3615, metadata !173), !dbg !3634
  br i1 %33, label %108, label %109, !dbg !3757

; <label>:108:                                    ; preds = %100
  tail call void @musb_write_usb(i8 zeroext %0, i32 20, i32 16) #10, !dbg !3758
  br label %109, !dbg !3761

; <label>:109:                                    ; preds = %108, %100
  %110 = icmp eq i8* %37, null, !dbg !3762
  br i1 %110, label %113, label %111, !dbg !3764

; <label>:111:                                    ; preds = %109
  tail call void asm sideeffect "ssync", ""() #7, !dbg !3765, !srcloc !3767
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull %37, i8* nonnull %97, i32 %106, i32 1, i1 false), !dbg !3768
  %112 = getelementptr inbounds i8, i8* %37, i32 %106, !dbg !3769
  tail call void @llvm.dbg.value(metadata i8* %112, i64 0, metadata !3614, metadata !173), !dbg !3633
  br label %113, !dbg !3770

; <label>:113:                                    ; preds = %111, %109
  %114 = phi i8* [ %112, %111 ], [ null, %109 ]
  tail call void @llvm.dbg.value(metadata i8* %114, i64 0, metadata !3614, metadata !173), !dbg !3633
  br i1 %33, label %116, label %115, !dbg !3771

; <label>:115:                                    ; preds = %113
  tail call void @musb_write_usb(i8 zeroext %0, i32 20, i32 16) #10, !dbg !3772
  br label %116, !dbg !3775

; <label>:116:                                    ; preds = %115, %113
  %117 = icmp eq i32 %107, 0, !dbg !3776
  br i1 %117, label %119, label %118, !dbg !3778

; <label>:118:                                    ; preds = %116
  tail call void @musb_write_usb(i8 zeroext %0, i32 26, i32 %11) #10, !dbg !3779
  tail call void @musb_write_usb(i8 zeroext %0, i32 20, i32 32) #10, !dbg !3781
  br label %119, !dbg !3782

; <label>:119:                                    ; preds = %118, %116
  tail call void @sys_local_irq_enable() #9, !dbg !3783
  br label %35

; <label>:120:                                    ; preds = %92
  %121 = and i32 %93, 64, !dbg !3786
  %122 = icmp eq i32 %121, 0, !dbg !3786
  br i1 %122, label %125, label %123, !dbg !3789

; <label>:123:                                    ; preds = %120
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.10, i32 0, i32 0)) #9, !dbg !3791
  %124 = and i32 %93, -65, !dbg !3794
  tail call void @llvm.dbg.value(metadata i32 %124, i64 0, metadata !3619, metadata !173), !dbg !3680
  br label %134, !dbg !3795

; <label>:125:                                    ; preds = %120
  %126 = and i32 %93, 8, !dbg !3796
  %127 = icmp eq i32 %126, 0, !dbg !3796
  br i1 %127, label %129, label %128, !dbg !3799

; <label>:128:                                    ; preds = %125
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.11, i32 0, i32 0)) #9, !dbg !3800
  tail call void @llvm.dbg.value(metadata i32 128, i64 0, metadata !3619, metadata !173), !dbg !3680
  tail call void @llvm.dbg.value(metadata i32 -11, i64 0, metadata !3617, metadata !173), !dbg !3636
  br label %134, !dbg !3803

; <label>:129:                                    ; preds = %125
  %130 = and i32 %93, 4, !dbg !3804
  %131 = icmp eq i32 %130, 0, !dbg !3804
  br i1 %131, label %133, label %132, !dbg !3807

; <label>:132:                                    ; preds = %129
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.12, i32 0, i32 0)) #9, !dbg !3808
  tail call void @llvm.dbg.value(metadata i32 128, i64 0, metadata !3619, metadata !173), !dbg !3680
  tail call void @llvm.dbg.value(metadata i32 -6, i64 0, metadata !3617, metadata !173), !dbg !3636
  br label %134

; <label>:133:                                    ; preds = %129
  tail call void @sys_local_irq_enable() #9, !dbg !3811
  br label %50, !dbg !3815, !llvm.loop !3816

; <label>:134:                                    ; preds = %132, %128, %123
  %135 = phi i32 [ %45, %123 ], [ -11, %128 ], [ -6, %132 ]
  %136 = phi i32 [ %124, %123 ], [ 128, %128 ], [ 128, %132 ]
  tail call void @llvm.dbg.value(metadata i32 %136, i64 0, metadata !3619, metadata !173), !dbg !3680
  tail call void @llvm.dbg.value(metadata i32 %135, i64 0, metadata !3617, metadata !173), !dbg !3636
  %137 = and i32 %136, 191, !dbg !3819
  tail call void @musb_write_usb(i8 zeroext %0, i32 20, i32 %137) #10, !dbg !3820
  tail call void @sys_local_irq_enable() #9, !dbg !3821
  br label %44, !dbg !3681, !llvm.loop !3816

; <label>:138:                                    ; preds = %76, %50
  %139 = phi i32 [ %45, %50 ], [ -10, %76 ]
  br label %140, !dbg !3824

; <label>:140:                                    ; preds = %138, %99, %91, %61
  %141 = phi i32 [ -8, %61 ], [ -10, %91 ], [ -1, %99 ], [ %139, %138 ]
  ret i32 %141, !dbg !3825
}

; Function Attrs: minsize nounwind optsize
define i32 @usb1_h_ep_read(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32, i32) local_unnamed_addr #3 !dbg !3826 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !3828, metadata !173), !dbg !3847
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !3829, metadata !173), !dbg !3848
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !3830, metadata !173), !dbg !3849
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !3831, metadata !173), !dbg !3850
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !3832, metadata !173), !dbg !3851
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !3833, metadata !173), !dbg !3852
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !3834, metadata !173), !dbg !3853
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !3835, metadata !173), !dbg !3854
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3838, metadata !173), !dbg !3855
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !3839, metadata !173), !dbg !3856
  %8 = zext i8 %1 to i32, !dbg !3857
  %9 = zext i8 %0 to i32, !dbg !3858
  %10 = getelementptr inbounds [2 x i8], [2 x i8]* @host_speed, i32 0, i32 %9, !dbg !3858
  %11 = load i8, i8* %10, align 1, !dbg !3858, !tbaa !692
  %12 = zext i8 %11 to i32, !dbg !3858
  %13 = add nsw i32 %12, -1, !dbg !3859
  %14 = getelementptr inbounds [3 x i8], [3 x i8]* @speed_table, i32 0, i32 %13, !dbg !3860
  %15 = load i8, i8* %14, align 1, !dbg !3860, !tbaa !692
  %16 = zext i8 %15 to i32, !dbg !3860
  %17 = shl nuw nsw i32 %16, 6, !dbg !3861
  %18 = shl i32 %6, 4, !dbg !3862
  %19 = zext i8 %3 to i32, !dbg !3863
  %20 = or i32 %18, %19, !dbg !3864
  %21 = or i32 %20, %17, !dbg !3865
  tail call void @usb_write_rxtype(i8 zeroext %0, i32 %8, i32 %21) #10, !dbg !3866
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %8, i32 32) #10, !dbg !3867
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3840, metadata !173), !dbg !3868
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !3841, metadata !173), !dbg !3869
  %22 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %9, !dbg !3870
  %23 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %22, align 4, !dbg !3870, !tbaa !244
  %24 = icmp eq %struct.usb_ep_addr_t* %23, null, !dbg !3870
  br i1 %24, label %25, label %28, !dbg !3872

; <label>:25:                                     ; preds = %7
  %26 = load volatile i32, i32* @jiffies, align 4, !dbg !3873, !tbaa !193
  %27 = add i32 %26, 20, !dbg !3876
  tail call void @llvm.dbg.value(metadata i32 %27, i64 0, metadata !3841, metadata !173), !dbg !3869
  tail call void @llvm.dbg.value(metadata i32 %36, i64 0, metadata !3841, metadata !173), !dbg !3869
  br label %40, !dbg !3877

; <label>:28:                                     ; preds = %7
  %29 = add nsw i32 %8, -1, !dbg !3878
  %30 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %23, i32 0, i32 7, i32 %29, !dbg !3880
  %31 = load i32, i32* %30, align 4, !dbg !3880, !tbaa !214
  tail call void @llvm.dbg.value(metadata i32 %31, i64 0, metadata !3842, metadata !173), !dbg !3881
  %32 = load volatile i32, i32* @jiffies, align 4, !dbg !3882, !tbaa !193
  %33 = udiv i32 %5, %31, !dbg !3884
  %34 = shl i32 %33, 1, !dbg !3885
  tail call void @llvm.dbg.value(metadata i32 %35, i64 0, metadata !3841, metadata !173), !dbg !3869
  %35 = add i32 %32, 200, !dbg !3886
  %36 = add i32 %35, %34, !dbg !3887
  tail call void @llvm.dbg.value(metadata i32 %36, i64 0, metadata !3841, metadata !173), !dbg !3869
  tail call void @llvm.dbg.value(metadata i32 %36, i64 0, metadata !3841, metadata !173), !dbg !3869
  %37 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %23, i32 0, i32 5, i32 %8, !dbg !3888
  %38 = load i32, i32* %37, align 4, !dbg !3888, !tbaa !214
  %39 = icmp ne i32 %38, 0
  br label %40

; <label>:40:                                     ; preds = %28, %25
  %41 = phi i32 [ %36, %28 ], [ %27, %25 ]
  %42 = phi i1 [ %39, %28 ], [ false, %25 ]
  %43 = add nsw i32 %8, -1
  br label %44, !dbg !3869

; <label>:44:                                     ; preds = %123, %40
  %45 = phi i32 [ %5, %40 ], [ %124, %123 ]
  %46 = phi i8* [ %4, %40 ], [ %119, %123 ]
  %47 = phi i32 [ %5, %40 ], [ %54, %123 ]
  %48 = phi i32 [ undef, %40 ], [ %102, %123 ]
  %49 = phi i32 [ 0, %40 ], [ %94, %123 ]
  %50 = phi i32 [ 0, %40 ], [ %95, %123 ]
  %51 = phi i32 [ %41, %40 ], [ %96, %123 ]
  %52 = icmp eq i32 %45, 0
  br label %53, !dbg !3892

; <label>:53:                                     ; preds = %147, %44
  %54 = phi i32 [ %47, %44 ], [ %148, %147 ]
  %55 = phi i32 [ %48, %44 ], [ %149, %147 ]
  %56 = phi i32 [ %49, %44 ], [ %94, %147 ]
  %57 = phi i32 [ %50, %44 ], [ %95, %147 ]
  %58 = phi i32 [ %51, %44 ], [ %96, %147 ]
  br label %59, !dbg !3894

; <label>:59:                                     ; preds = %143, %53
  %60 = phi i32 [ %102, %143 ], [ %55, %53 ]
  %61 = phi i32 [ %94, %143 ], [ %56, %53 ]
  %62 = phi i32 [ %95, %143 ], [ %57, %53 ]
  %63 = phi i32 [ %96, %143 ], [ %58, %53 ]
  tail call void @llvm.dbg.value(metadata i32 %63, i64 0, metadata !3841, metadata !173), !dbg !3869
  tail call void @llvm.dbg.value(metadata i32 %62, i64 0, metadata !3840, metadata !173), !dbg !3868
  tail call void @llvm.dbg.value(metadata i32 %61, i64 0, metadata !3838, metadata !173), !dbg !3855
  tail call void @llvm.dbg.value(metadata i32 %60, i64 0, metadata !3837, metadata !173), !dbg !3896
  tail call void @llvm.dbg.value(metadata i32 %54, i64 0, metadata !3835, metadata !173), !dbg !3854
  tail call void @llvm.dbg.value(metadata i8* %46, i64 0, metadata !3832, metadata !173), !dbg !3851
  tail call void @llvm.dbg.value(metadata i32 %45, i64 0, metadata !3833, metadata !173), !dbg !3852
  br i1 %52, label %150, label %64, !dbg !3897

; <label>:64:                                     ; preds = %59
  %65 = load volatile i32, i32* @jiffies, align 4, !dbg !3898, !tbaa !193
  %66 = icmp slt i32 %63, %65, !dbg !3901
  br i1 %66, label %67, label %93, !dbg !3902

; <label>:67:                                     ; preds = %64
  %68 = add i32 %62, 1, !dbg !3903
  tail call void @llvm.dbg.value(metadata i32 %68, i64 0, metadata !3840, metadata !173), !dbg !3868
  %69 = icmp ugt i32 %68, 10, !dbg !3905
  br i1 %69, label %70, label %71, !dbg !3907

; <label>:70:                                     ; preds = %67
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.13, i32 0, i32 0)) #9, !dbg !3908
  br label %153, !dbg !3911

; <label>:71:                                     ; preds = %67
  %72 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %22, align 4, !dbg !3912, !tbaa !244
  %73 = icmp eq %struct.usb_ep_addr_t* %72, null, !dbg !3912
  br i1 %73, label %82, label %74, !dbg !3914

; <label>:74:                                     ; preds = %71
  %75 = getelementptr inbounds %struct.usb_ep_addr_t, %struct.usb_ep_addr_t* %72, i32 0, i32 7, i32 %43, !dbg !3915
  %76 = load i32, i32* %75, align 4, !dbg !3915, !tbaa !214
  tail call void @llvm.dbg.value(metadata i32 %76, i64 0, metadata !3842, metadata !173), !dbg !3881
  %77 = load volatile i32, i32* @jiffies, align 4, !dbg !3917, !tbaa !193
  %78 = udiv i32 %45, %76, !dbg !3919
  %79 = shl i32 %78, 1, !dbg !3920
  tail call void @llvm.dbg.value(metadata i32 %80, i64 0, metadata !3841, metadata !173), !dbg !3869
  %80 = add i32 %77, 200, !dbg !3921
  %81 = add i32 %80, %79, !dbg !3922
  tail call void @llvm.dbg.value(metadata i32 %81, i64 0, metadata !3841, metadata !173), !dbg !3869
  br label %85, !dbg !3923

; <label>:82:                                     ; preds = %71
  %83 = load volatile i32, i32* @jiffies, align 4, !dbg !3924, !tbaa !193
  %84 = add i32 %83, 20, !dbg !3927
  tail call void @llvm.dbg.value(metadata i32 %84, i64 0, metadata !3841, metadata !173), !dbg !3869
  br label %85

; <label>:85:                                     ; preds = %82, %74
  %86 = phi i32 [ %81, %74 ], [ %84, %82 ]
  tail call void @llvm.dbg.value(metadata i32 %86, i64 0, metadata !3841, metadata !173), !dbg !3869
  %87 = tail call i32 @usb_h_dev_status(i8 zeroext %0) #10, !dbg !3928
  %88 = icmp eq i32 %87, 0, !dbg !3928
  %89 = add i32 %61, 1, !dbg !3930
  tail call void @llvm.dbg.value(metadata i32 %89, i64 0, metadata !3838, metadata !173), !dbg !3855
  %90 = select i1 %88, i32 0, i32 %89, !dbg !3932
  tail call void @llvm.dbg.value(metadata i32 %90, i64 0, metadata !3838, metadata !173), !dbg !3855
  %91 = icmp ugt i32 %90, 5, !dbg !3933
  br i1 %91, label %150, label %92, !dbg !3935

; <label>:92:                                     ; preds = %85
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.14, i32 0, i32 0), i32 %60) #9, !dbg !3936
  br label %93, !dbg !3938

; <label>:93:                                     ; preds = %92, %64
  %94 = phi i32 [ %90, %92 ], [ %61, %64 ]
  %95 = phi i32 [ %68, %92 ], [ %62, %64 ]
  %96 = phi i32 [ %86, %92 ], [ %63, %64 ]
  tail call void @llvm.dbg.value(metadata i32 %96, i64 0, metadata !3841, metadata !173), !dbg !3869
  tail call void @llvm.dbg.value(metadata i32 %95, i64 0, metadata !3840, metadata !173), !dbg !3868
  tail call void @llvm.dbg.value(metadata i32 %94, i64 0, metadata !3838, metadata !173), !dbg !3855
  %97 = tail call i32 @usb_read_devctl(i8 zeroext %0) #10, !dbg !3939
  %98 = and i32 %97, 4, !dbg !3941
  %99 = icmp eq i32 %98, 0, !dbg !3942
  br i1 %99, label %100, label %101, !dbg !3943

; <label>:100:                                    ; preds = %93
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.8, i32 0, i32 0), i32 2078) #9, !dbg !3944
  br label %153, !dbg !3947

; <label>:101:                                    ; preds = %93
  %102 = tail call i32 @usb_read_rxcsr(i8 zeroext %0, i32 %8) #10, !dbg !3948
  tail call void @llvm.dbg.value(metadata i32 %102, i64 0, metadata !3837, metadata !173), !dbg !3896
  %103 = and i32 %102, 1, !dbg !3949
  %104 = icmp eq i32 %103, 0, !dbg !3949
  br i1 %104, label %134, label %105, !dbg !3950

; <label>:105:                                    ; preds = %101
  %106 = tail call i8* @usb_get_dma_raddr(i8 zeroext %0, i32 %8) #10, !dbg !3951
  tail call void @llvm.dbg.value(metadata i8* %106, i64 0, metadata !3836, metadata !173), !dbg !3952
  %107 = icmp eq i8* %106, null, !dbg !3953
  br i1 %107, label %152, label %108, !dbg !3955

; <label>:108:                                    ; preds = %105
  %109 = tail call i32 @usb_read_rxcount(i8 zeroext %0, i32 %8) #10, !dbg !3956
  tail call void @llvm.dbg.value(metadata i32 %109, i64 0, metadata !3843, metadata !173), !dbg !3957
  %110 = icmp ult i32 %109, %45, !dbg !3958
  %111 = select i1 %110, i32 %109, i32 %45, !dbg !3958
  tail call void @llvm.dbg.value(metadata i32 %111, i64 0, metadata !3843, metadata !173), !dbg !3957
  %112 = sub i32 %45, %111, !dbg !3959
  tail call void @llvm.dbg.value(metadata i32 %112, i64 0, metadata !3833, metadata !173), !dbg !3852
  br i1 %42, label %113, label %114, !dbg !3960

; <label>:113:                                    ; preds = %108
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %8, i32 16) #10, !dbg !3961
  br label %114, !dbg !3964

; <label>:114:                                    ; preds = %113, %108
  %115 = icmp eq i8* %46, null, !dbg !3965
  br i1 %115, label %118, label %116, !dbg !3967

; <label>:116:                                    ; preds = %114
  tail call void asm sideeffect "ssync", ""() #7, !dbg !3968, !srcloc !3970
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* nonnull %46, i8* nonnull %106, i32 %111, i32 1, i1 false), !dbg !3971
  %117 = getelementptr inbounds i8, i8* %46, i32 %111, !dbg !3972
  tail call void @llvm.dbg.value(metadata i8* %117, i64 0, metadata !3832, metadata !173), !dbg !3851
  br label %118, !dbg !3973

; <label>:118:                                    ; preds = %116, %114
  %119 = phi i8* [ %117, %116 ], [ null, %114 ]
  tail call void @llvm.dbg.value(metadata i8* %119, i64 0, metadata !3832, metadata !173), !dbg !3851
  br i1 %42, label %121, label %120, !dbg !3974

; <label>:120:                                    ; preds = %118
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %8, i32 16) #10, !dbg !3975
  br label %121, !dbg !3978

; <label>:121:                                    ; preds = %120, %118
  %122 = icmp eq i32 %112, 0, !dbg !3979
  br i1 %122, label %123, label %125, !dbg !3981

; <label>:123:                                    ; preds = %125, %121
  %124 = phi i32 [ %112, %125 ], [ 0, %121 ]
  br label %44

; <label>:125:                                    ; preds = %121
  %126 = load i8, i8* %10, align 1, !dbg !3982, !tbaa !692
  %127 = zext i8 %126 to i32, !dbg !3982
  %128 = add nsw i32 %127, -1, !dbg !3984
  %129 = getelementptr inbounds [3 x i8], [3 x i8]* @speed_table, i32 0, i32 %128, !dbg !3985
  %130 = load i8, i8* %129, align 1, !dbg !3985, !tbaa !692
  %131 = zext i8 %130 to i32, !dbg !3985
  %132 = shl nuw nsw i32 %131, 6, !dbg !3986
  %133 = or i32 %20, %132, !dbg !3987
  tail call void @usb_write_rxtype(i8 zeroext %0, i32 %8, i32 %133) #10, !dbg !3988
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %8, i32 32) #10, !dbg !3989
  br label %123, !dbg !3990

; <label>:134:                                    ; preds = %101
  %135 = and i32 %102, 64, !dbg !3991
  %136 = icmp eq i32 %135, 0, !dbg !3991
  br i1 %136, label %139, label %137, !dbg !3994

; <label>:137:                                    ; preds = %134
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([46 x i8], [46 x i8]* @.str.10, i32 0, i32 0)) #9, !dbg !3996
  %138 = and i32 %102, -65, !dbg !3999
  tail call void @llvm.dbg.value(metadata i32 %138, i64 0, metadata !3837, metadata !173), !dbg !3896
  br label %147, !dbg !4000

; <label>:139:                                    ; preds = %134
  %140 = and i32 %102, 8, !dbg !4001
  %141 = icmp eq i32 %140, 0, !dbg !4001
  br i1 %141, label %143, label %142, !dbg !4004

; <label>:142:                                    ; preds = %139
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.11, i32 0, i32 0)) #9, !dbg !4005
  tail call void @llvm.dbg.value(metadata i32 128, i64 0, metadata !3837, metadata !173), !dbg !3896
  tail call void @llvm.dbg.value(metadata i32 -11, i64 0, metadata !3835, metadata !173), !dbg !3854
  br label %147, !dbg !4008

; <label>:143:                                    ; preds = %139
  %144 = and i32 %102, 4, !dbg !4009
  %145 = icmp eq i32 %144, 0, !dbg !4009
  br i1 %145, label %59, label %146, !dbg !4012, !llvm.loop !4013

; <label>:146:                                    ; preds = %143
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([49 x i8], [49 x i8]* @.str.12, i32 0, i32 0)) #9, !dbg !4016
  tail call void @llvm.dbg.value(metadata i32 128, i64 0, metadata !3837, metadata !173), !dbg !3896
  tail call void @llvm.dbg.value(metadata i32 -6, i64 0, metadata !3835, metadata !173), !dbg !3854
  br label %147

; <label>:147:                                    ; preds = %146, %142, %137
  %148 = phi i32 [ %54, %137 ], [ -11, %142 ], [ -6, %146 ]
  %149 = phi i32 [ %138, %137 ], [ 128, %142 ], [ 128, %146 ]
  tail call void @llvm.dbg.value(metadata i32 %149, i64 0, metadata !3837, metadata !173), !dbg !3896
  tail call void @llvm.dbg.value(metadata i32 %148, i64 0, metadata !3835, metadata !173), !dbg !3854
  tail call void @usb_write_rxcsr(i8 zeroext %0, i32 %8, i32 %149) #10, !dbg !4019
  br label %53, !dbg !3897, !llvm.loop !4013

; <label>:150:                                    ; preds = %85, %59
  %151 = phi i32 [ -10, %85 ], [ %54, %59 ]
  br label %153, !dbg !4020

; <label>:152:                                    ; preds = %105
  br label %153, !dbg !4021

; <label>:153:                                    ; preds = %152, %150, %100, %70
  %154 = phi i32 [ -8, %70 ], [ -10, %100 ], [ %151, %150 ], [ -1, %152 ]
  ret i32 %154, !dbg !4022
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_ep_read(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32, i32) local_unnamed_addr #3 !dbg !4023 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4025, metadata !173), !dbg !4032
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !4026, metadata !173), !dbg !4033
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !4027, metadata !173), !dbg !4034
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !4028, metadata !173), !dbg !4035
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !4029, metadata !173), !dbg !4036
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !4030, metadata !173), !dbg !4037
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !4031, metadata !173), !dbg !4038
  %8 = icmp eq i8 %0, 0, !dbg !4039
  br i1 %8, label %9, label %11, !dbg !4041

; <label>:9:                                      ; preds = %7
  %10 = tail call i32 @usb0_h_ep_read(i8 zeroext 0, i8 zeroext %1, i16 zeroext undef, i8 zeroext %3, i8* %4, i32 %5, i32 %6) #10, !dbg !4042
  br label %13, !dbg !4044

; <label>:11:                                     ; preds = %7
  %12 = tail call i32 @usb1_h_ep_read(i8 zeroext %0, i8 zeroext %1, i16 zeroext undef, i8 zeroext %3, i8* %4, i32 %5, i32 %6) #10, !dbg !4045
  br label %13, !dbg !4047

; <label>:13:                                     ; preds = %11, %9
  %14 = phi i32 [ %10, %9 ], [ %12, %11 ]
  ret i32 %14, !dbg !4048
}

; Function Attrs: minsize nounwind optsize
define void @usb_h_sie_init(i8 zeroext) local_unnamed_addr #3 !dbg !4049 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4051, metadata !173), !dbg !4052
  %2 = zext i8 %0 to i32, !dbg !4053
  %3 = icmp eq i8 %0, 0, !dbg !4055
  br i1 %3, label %4, label %27, !dbg !4056

; <label>:4:                                      ; preds = %1
  %5 = getelementptr inbounds [2 x %struct.JL_USB_IO_TypeDef*], [2 x %struct.JL_USB_IO_TypeDef*]* @usb_io_regs, i32 0, i32 %2, !dbg !4057
  %6 = load %struct.JL_USB_IO_TypeDef*, %struct.JL_USB_IO_TypeDef** %5, align 4, !dbg !4057, !tbaa !244
  %7 = getelementptr inbounds %struct.JL_USB_IO_TypeDef, %struct.JL_USB_IO_TypeDef* %6, i32 0, i32 0, !dbg !4057
  store volatile i32 0, i32* %7, align 4, !dbg !4059, !tbaa !1323
  %8 = getelementptr inbounds %struct.JL_USB_IO_TypeDef, %struct.JL_USB_IO_TypeDef* %6, i32 0, i32 1, !dbg !4060
  store volatile i32 0, i32* %8, align 4, !dbg !4061, !tbaa !4062
  tail call void @delay(i32 1000) #9, !dbg !4063
  %9 = shl nuw nsw i32 %2, 1, !dbg !4064
  %10 = add nuw nsw i32 %9, 149, !dbg !4065
  %11 = tail call i32 @gpio_set_die(i32 %10, i32 1) #9, !dbg !4066
  %12 = add nuw nsw i32 %9, 148, !dbg !4067
  %13 = tail call i32 @gpio_set_die(i32 %12, i32 1) #9, !dbg !4068
  %14 = tail call i32 @gpio_set_pull_up(i32 %10, i32 0) #9, !dbg !4069
  %15 = tail call i32 @gpio_set_pull_up(i32 %12, i32 0) #9, !dbg !4070
  %16 = tail call i32 @gpio_set_pull_down(i32 %10, i32 1) #9, !dbg !4071
  %17 = tail call i32 @gpio_set_pull_down(i32 %12, i32 1) #9, !dbg !4072
  %18 = load volatile i32, i32* %7, align 4, !dbg !4073, !tbaa !1323
  %19 = and i32 %18, -257, !dbg !4073
  store volatile i32 %19, i32* %7, align 4, !dbg !4073, !tbaa !1323
  %20 = load volatile i32, i32* %7, align 4, !dbg !4074, !tbaa !1323
  %21 = and i32 %20, -2049, !dbg !4074
  store volatile i32 %21, i32* %7, align 4, !dbg !4074, !tbaa !1323
  %22 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %2, !dbg !4075
  %23 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %22, align 4, !dbg !4075, !tbaa !244
  %24 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %23, i32 0, i32 0, !dbg !4075
  %25 = load volatile i32, i32* %24, align 4, !dbg !4076, !tbaa !246
  %26 = or i32 %25, 37, !dbg !4076
  store volatile i32 %26, i32* %24, align 4, !dbg !4076, !tbaa !246
  tail call void @delay(i32 1000) #9, !dbg !4077
  br label %47, !dbg !4078

; <label>:27:                                     ; preds = %1
  store volatile i8 0, i8* inttoptr (i32 90113 to i8*), align 1, !dbg !4079, !tbaa !692
  store volatile i32 0, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4081, !tbaa !214
  %28 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4082, !tbaa !214
  %29 = or i32 %28, 28, !dbg !4082
  store volatile i32 %29, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4082, !tbaa !214
  %30 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4083, !tbaa !214
  %31 = or i32 %30, 1, !dbg !4083
  store volatile i32 %31, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4083, !tbaa !214
  tail call void @delay(i32 1000) #9, !dbg !4084
  %32 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4085, !tbaa !214
  %33 = or i32 %32, 2, !dbg !4085
  store volatile i32 %33, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4085, !tbaa !214
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.15, i32 0, i32 0)) #9, !dbg !4086
  %34 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4088, !tbaa !214
  %35 = or i32 %34, 3, !dbg !4088
  store volatile i32 %35, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4088, !tbaa !214
  br label %36, !dbg !4089

; <label>:36:                                     ; preds = %36, %27
  %37 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4090, !tbaa !214
  %38 = and i32 %37, 16, !dbg !4092
  %39 = icmp eq i32 %38, 0, !dbg !4093
  br i1 %39, label %36, label %40, !dbg !4094, !llvm.loop !4095

; <label>:40:                                     ; preds = %36
  %41 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4097, !tbaa !214
  %42 = or i32 %41, 6144, !dbg !4097
  store volatile i32 %42, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4097, !tbaa !214
  %43 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4098, !tbaa !214
  %44 = and i32 %43, -20971521, !dbg !4098
  store volatile i32 %44, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4098, !tbaa !214
  %45 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4099, !tbaa !214
  %46 = or i32 %45, 41943040, !dbg !4099
  store volatile i32 %46, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4099, !tbaa !214
  store volatile i16 -1, i16* inttoptr (i32 90946 to i16*), align 2, !dbg !4100, !tbaa !1206
  store volatile i16 -1, i16* inttoptr (i32 90944 to i16*), align 64, !dbg !4101, !tbaa !1206
  br label %47

; <label>:47:                                     ; preds = %40, %4
  ret void, !dbg !4102
}

; Function Attrs: minsize optsize
declare i32 @gpio_set_pull_up(i32, i32) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare i32 @gpio_set_pull_down(i32, i32) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define void @usb_h_sie_close(i8 zeroext) local_unnamed_addr #3 !dbg !4103 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4105, metadata !173), !dbg !4106
  %2 = zext i8 %0 to i32, !dbg !4107
  %3 = icmp eq i8 %0, 0, !dbg !4109
  br i1 %3, label %4, label %19, !dbg !4110

; <label>:4:                                      ; preds = %1
  %5 = getelementptr inbounds [2 x %struct.JL_USB_IO_TypeDef*], [2 x %struct.JL_USB_IO_TypeDef*]* @usb_io_regs, i32 0, i32 %2, !dbg !4111
  %6 = load %struct.JL_USB_IO_TypeDef*, %struct.JL_USB_IO_TypeDef** %5, align 4, !dbg !4111, !tbaa !244
  %7 = getelementptr inbounds %struct.JL_USB_IO_TypeDef, %struct.JL_USB_IO_TypeDef* %6, i32 0, i32 0, !dbg !4111
  %8 = load volatile i32, i32* %7, align 4, !dbg !4113, !tbaa !1323
  %9 = and i32 %8, -49, !dbg !4113
  store volatile i32 %9, i32* %7, align 4, !dbg !4113, !tbaa !1323
  %10 = load volatile i32, i32* %7, align 4, !dbg !4114, !tbaa !1323
  %11 = and i32 %10, -193, !dbg !4114
  store volatile i32 %11, i32* %7, align 4, !dbg !4114, !tbaa !1323
  %12 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %2, !dbg !4115
  %13 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %12, align 4, !dbg !4115, !tbaa !244
  %14 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %13, i32 0, i32 0, !dbg !4115
  %15 = load volatile i32, i32* %14, align 4, !dbg !4116, !tbaa !246
  %16 = and i32 %15, 16776960, !dbg !4116
  store volatile i32 %16, i32* %14, align 4, !dbg !4116, !tbaa !246
  %17 = load volatile i32, i32* %14, align 4, !dbg !4117, !tbaa !246
  %18 = or i32 %17, 21, !dbg !4117
  store volatile i32 %18, i32* %14, align 4, !dbg !4117, !tbaa !246
  store volatile i32 0, i32* %14, align 4, !dbg !4118, !tbaa !246
  br label %19, !dbg !4119

; <label>:19:                                     ; preds = %4, %1
  ret void, !dbg !4120
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_chirp_and_reset(i8 zeroext, i32, i32) local_unnamed_addr #3 !dbg !4121 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4125, metadata !173), !dbg !4131
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !4126, metadata !173), !dbg !4132
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !4127, metadata !173), !dbg !4133
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !4129, metadata !173), !dbg !4134
  %4 = tail call i32 bitcast (i32 (...)* @get_jiffies to i32 ()*)() #9, !dbg !4135
  %5 = add i32 %4, %2, !dbg !4136
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !4130, metadata !173), !dbg !4137
  %6 = zext i8 %0 to i32, !dbg !4138
  %7 = icmp eq i8 %0, 0, !dbg !4140
  tail call void @usb_write_devctl(i8 zeroext %0, i32 3) #10, !dbg !4141
  br i1 %7, label %9, label %8, !dbg !4143

; <label>:8:                                      ; preds = %3
  br label %54, !dbg !4134

; <label>:9:                                      ; preds = %3
  br label %10, !dbg !4144

; <label>:10:                                     ; preds = %35, %9
  %11 = phi i32 [ %21, %35 ], [ 0, %9 ]
  tail call void @llvm.dbg.value(metadata i32 %11, i64 0, metadata !4129, metadata !173), !dbg !4134
  %12 = tail call i32 @usb_read_devctl(i8 zeroext 0) #10, !dbg !4146
  %13 = tail call i32 @usb_host_timeout(i32 %5) #9, !dbg !4148
  %14 = icmp eq i32 %13, 0, !dbg !4148
  br i1 %14, label %17, label %15, !dbg !4150

; <label>:15:                                     ; preds = %10
  %16 = and i32 %12, 255, !dbg !4151
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.16, i32 0, i32 0), i32 %16) #9, !dbg !4151
  br label %94, !dbg !4154

; <label>:17:                                     ; preds = %10
  %18 = tail call i32 @usb_h_dev_status(i8 zeroext 0) #10, !dbg !4155
  %19 = icmp eq i32 %18, 0, !dbg !4155
  %20 = add i32 %11, 1, !dbg !4157
  tail call void @llvm.dbg.value(metadata i32 %20, i64 0, metadata !4129, metadata !173), !dbg !4134
  %21 = select i1 %19, i32 0, i32 %20, !dbg !4159
  tail call void @llvm.dbg.value(metadata i32 %21, i64 0, metadata !4129, metadata !173), !dbg !4134
  %22 = and i32 %12, 4, !dbg !4160
  %23 = icmp eq i32 %22, 0, !dbg !4162
  %24 = icmp ugt i32 %21, 1000, !dbg !4163
  %25 = or i1 %23, %24, !dbg !4165
  br i1 %25, label %26, label %27, !dbg !4165

; <label>:26:                                     ; preds = %17
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.17, i32 0, i32 0)) #9, !dbg !4166
  br label %94, !dbg !4169

; <label>:27:                                     ; preds = %17
  %28 = and i32 %12, 64, !dbg !4170
  %29 = icmp eq i32 %28, 0, !dbg !4170
  br i1 %29, label %31, label %30, !dbg !4172

; <label>:30:                                     ; preds = %27
  tail call void (i32, i8*, i8*, ...) @log_print(i32 1, i8* null, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.18, i32 0, i32 0)) #9, !dbg !4173
  br label %36, !dbg !4176

; <label>:31:                                     ; preds = %27
  %32 = and i32 %12, 32, !dbg !4177
  %33 = icmp eq i32 %32, 0, !dbg !4177
  br i1 %33, label %35, label %34, !dbg !4179

; <label>:34:                                     ; preds = %31
  tail call void (i32, i8*, i8*, ...) @log_print(i32 1, i8* null, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.19, i32 0, i32 0)) #9, !dbg !4180
  tail call void @usb_set_low_speed(i8 zeroext 0, i8 zeroext 1) #10, !dbg !4183
  br label %36, !dbg !4184

; <label>:35:                                     ; preds = %31
  tail call void @usb_mdelay(i32 1) #9, !dbg !4185
  br label %10, !dbg !4186, !llvm.loop !4188

; <label>:36:                                     ; preds = %34, %30
  %37 = phi i8 [ 1, %34 ], [ 2, %30 ]
  %38 = getelementptr inbounds [2 x i8], [2 x i8]* @host_speed, i32 0, i32 %6
  store i8 %37, i8* %38, align 1, !tbaa !692
  %39 = tail call i32 bitcast (i32 (...)* @get_jiffies to i32 ()*)() #9, !dbg !4191
  %40 = add i32 %39, %2, !dbg !4192
  tail call void @llvm.dbg.value(metadata i32 %40, i64 0, metadata !4130, metadata !173), !dbg !4137
  br label %41, !dbg !4193, !llvm.loop !4194

; <label>:41:                                     ; preds = %48, %36
  %42 = tail call i32 @usb_read_power(i8 zeroext 0) #10, !dbg !4196
  %43 = and i32 %42, 247, !dbg !4198
  %44 = or i32 %43, 8, !dbg !4199
  tail call void @usb_write_power(i8 zeroext 0, i32 %44) #10, !dbg !4200
  %45 = tail call i32 @usb_host_timeout(i32 %40) #9, !dbg !4201
  %46 = icmp eq i32 %45, 0, !dbg !4201
  br i1 %46, label %48, label %47, !dbg !4203

; <label>:47:                                     ; preds = %41
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.20, i32 0, i32 0)) #9, !dbg !4204
  br label %94, !dbg !4207

; <label>:48:                                     ; preds = %41
  %49 = and i32 %42, 8, !dbg !4208
  %50 = icmp eq i32 %49, 0, !dbg !4210
  br i1 %50, label %41, label %51, !dbg !4211, !llvm.loop !4194

; <label>:51:                                     ; preds = %48
  tail call void @usb_mdelay(i32 %1) #9, !dbg !4213
  %52 = tail call i32 @usb_read_power(i8 zeroext 0) #10, !dbg !4214
  %53 = and i32 %52, 247, !dbg !4215
  tail call void @usb_write_power(i8 zeroext 0, i32 %53) #10, !dbg !4216
  br label %94, !dbg !4217

; <label>:54:                                     ; preds = %67, %8
  tail call void @llvm.dbg.value(metadata i32 undef, i64 0, metadata !4129, metadata !173), !dbg !4134
  %55 = tail call i32 @usb_read_devctl(i8 zeroext %0) #10, !dbg !4218
  %56 = tail call i32 @usb_host_timeout(i32 %5) #9, !dbg !4221
  %57 = icmp eq i32 %56, 0, !dbg !4221
  br i1 %57, label %60, label %58, !dbg !4223

; <label>:58:                                     ; preds = %54
  %59 = and i32 %55, 255, !dbg !4224
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.16, i32 0, i32 0), i32 %59) #9, !dbg !4224
  br label %94, !dbg !4227

; <label>:60:                                     ; preds = %54
  %61 = tail call i32 @usb_h_dev_status(i8 zeroext %0) #10, !dbg !4228
  %62 = and i32 %55, 64, !dbg !4230
  %63 = icmp eq i32 %62, 0, !dbg !4230
  br i1 %63, label %64, label %68, !dbg !4232

; <label>:64:                                     ; preds = %60
  %65 = and i32 %55, 32, !dbg !4233
  %66 = icmp eq i32 %65, 0, !dbg !4233
  br i1 %66, label %67, label %68, !dbg !4235

; <label>:67:                                     ; preds = %64
  tail call void @usb_mdelay(i32 1) #9, !dbg !4236
  br label %54, !dbg !4237, !llvm.loop !4239

; <label>:68:                                     ; preds = %64, %60
  %69 = phi i8 [ 2, %60 ], [ 1, %64 ]
  %70 = getelementptr inbounds [2 x i8], [2 x i8]* @host_speed, i32 0, i32 %6
  store i8 %69, i8* %70, align 1, !tbaa !692
  %71 = tail call i32 bitcast (i32 (...)* @get_jiffies to i32 ()*)() #9, !dbg !4242
  %72 = add i32 %71, %2, !dbg !4243
  tail call void @llvm.dbg.value(metadata i32 %72, i64 0, metadata !4130, metadata !173), !dbg !4137
  br label %73, !dbg !4244, !llvm.loop !4245

; <label>:73:                                     ; preds = %80, %68
  %74 = tail call i32 @usb_read_power(i8 zeroext %0) #10, !dbg !4247
  %75 = and i32 %74, 247, !dbg !4249
  %76 = or i32 %75, 8, !dbg !4250
  tail call void @usb_write_power(i8 zeroext %0, i32 %76) #10, !dbg !4251
  %77 = tail call i32 @usb_host_timeout(i32 %72) #9, !dbg !4252
  %78 = icmp eq i32 %77, 0, !dbg !4252
  br i1 %78, label %80, label %79, !dbg !4254

; <label>:79:                                     ; preds = %73
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.20, i32 0, i32 0)) #9, !dbg !4255
  br label %94, !dbg !4258

; <label>:80:                                     ; preds = %73
  %81 = and i32 %74, 8, !dbg !4259
  %82 = icmp eq i32 %81, 0, !dbg !4261
  br i1 %82, label %73, label %83, !dbg !4262, !llvm.loop !4245

; <label>:83:                                     ; preds = %80
  tail call void @usb_mdelay(i32 %1) #9, !dbg !4264
  %84 = tail call i32 @usb_read_power(i8 zeroext %0) #10, !dbg !4265
  %85 = and i32 %84, 247, !dbg !4266
  tail call void @usb_write_power(i8 zeroext %0, i32 %85) #10, !dbg !4267
  tail call void asm sideeffect "csync;", ""() #7, !dbg !4268, !srcloc !4271
  %86 = tail call i32 @usb_read_power(i8 zeroext %0) #10, !dbg !4272
  %87 = load i8, i8* %70, align 1, !dbg !4273, !tbaa !692
  switch i8 %87, label %94 [
    i8 2, label %88
    i8 1, label %93
  ], !dbg !4275

; <label>:88:                                     ; preds = %83
  %89 = and i32 %86, 16, !dbg !4276
  %90 = icmp eq i32 %89, 0, !dbg !4276
  br i1 %90, label %92, label %91, !dbg !4279

; <label>:91:                                     ; preds = %88
  tail call void (i32, i8*, i8*, ...) @log_print(i32 1, i8* null, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.21, i32 0, i32 0)) #9, !dbg !4280
  store i8 3, i8* %70, align 1, !dbg !4283, !tbaa !692
  br label %94, !dbg !4284

; <label>:92:                                     ; preds = %88
  tail call void (i32, i8*, i8*, ...) @log_print(i32 1, i8* null, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.18, i32 0, i32 0)) #9, !dbg !4285
  br label %94

; <label>:93:                                     ; preds = %83
  tail call void (i32, i8*, i8*, ...) @log_print(i32 1, i8* null, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.19, i32 0, i32 0)) #9, !dbg !4288
  br label %94, !dbg !4292

; <label>:94:                                     ; preds = %93, %92, %91, %83, %79, %58, %51, %47, %26, %15
  %95 = phi i32 [ -6, %15 ], [ -10, %26 ], [ 1, %47 ], [ -6, %58 ], [ 1, %79 ], [ 0, %83 ], [ 0, %92 ], [ 0, %91 ], [ 0, %93 ], [ 0, %51 ]
  ret i32 %95, !dbg !4293
}

; Function Attrs: minsize optsize
declare i32 @get_jiffies(...) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare i32 @usb_host_timeout(i32) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare void @usb_mdelay(i32) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define void @usb_h_sie_reset(i8 zeroext) local_unnamed_addr #3 !dbg !4294 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4296, metadata !173), !dbg !4297
  %2 = icmp eq i8 %0, 0, !dbg !4298
  br i1 %2, label %3, label %8, !dbg !4300

; <label>:3:                                      ; preds = %1
  %4 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !4301, !tbaa !246
  %5 = and i32 %4, -5, !dbg !4301
  store volatile i32 %5, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !4301, !tbaa !246
  tail call void @delay(i32 10000) #9, !dbg !4303
  %6 = load volatile i32, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !4304, !tbaa !246
  %7 = or i32 %6, 4, !dbg !4304
  store volatile i32 %7, i32* inttoptr (i32 71680 to i32*), align 2048, !dbg !4304, !tbaa !246
  br label %11, !dbg !4305

; <label>:8:                                      ; preds = %1
  %9 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4306, !tbaa !214
  %10 = and i32 %9, -4, !dbg !4306
  store volatile i32 %10, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4306, !tbaa !214
  tail call void @delay(i32 10000) #9, !dbg !4308
  br label %11

; <label>:11:                                     ; preds = %8, %3
  tail call void @usb_h_sie_init(i8 zeroext %0) #10, !dbg !4309
  ret void, !dbg !4310
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_force_reset(i8 zeroext) local_unnamed_addr #3 !dbg !4311 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4313, metadata !173), !dbg !4314
  %2 = icmp eq i8 %0, 0, !dbg !4315
  br i1 %2, label %3, label %4, !dbg !4317

; <label>:3:                                      ; preds = %1
  tail call void @usb_io_reset(i8 zeroext 0) #10, !dbg !4318
  br label %7, !dbg !4320

; <label>:4:                                      ; preds = %1
  %5 = load volatile i32, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4321, !tbaa !214
  %6 = and i32 %5, -4, !dbg !4321
  store volatile i32 %6, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4321, !tbaa !214
  br label %7

; <label>:7:                                      ; preds = %4, %3
  ret i32 0, !dbg !4323
}

; Function Attrs: minsize nounwind optsize
define void @usb_io_reset(i8 zeroext) local_unnamed_addr #3 !dbg !4324 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4326, metadata !173), !dbg !4327
  %2 = icmp eq i8 %0, 0, !dbg !4328
  br i1 %2, label %3, label %14, !dbg !4330

; <label>:3:                                      ; preds = %1
  %4 = tail call i32 @gpio_set_die(i32 148, i32 0) #9, !dbg !4331
  %5 = tail call i32 @gpio_set_die(i32 149, i32 0) #9, !dbg !4333
  %6 = tail call i32 @gpio_set_dieh(i32 148, i32 0) #9, !dbg !4334
  %7 = tail call i32 @gpio_set_dieh(i32 149, i32 0) #9, !dbg !4335
  %8 = tail call i32 @gpio_set_pull_up(i32 148, i32 0) #9, !dbg !4336
  %9 = tail call i32 @gpio_set_pull_up(i32 149, i32 0) #9, !dbg !4337
  %10 = tail call i32 @gpio_set_pull_down(i32 148, i32 0) #9, !dbg !4338
  %11 = tail call i32 @gpio_set_pull_down(i32 149, i32 0) #9, !dbg !4339
  %12 = tail call i32 @gpio_direction_output(i32 148, i32 0) #9, !dbg !4340
  %13 = tail call i32 @gpio_direction_output(i32 149, i32 0) #9, !dbg !4341
  br label %14, !dbg !4342

; <label>:14:                                     ; preds = %3, %1
  ret void, !dbg !4343
}

; Function Attrs: minsize nounwind optsize
define void @usb_hotplug_disable(i8 zeroext) local_unnamed_addr #3 !dbg !4344 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4346, metadata !173), !dbg !4347
  %2 = zext i8 %0 to i32, !dbg !4348
  %3 = icmp eq i8 %0, 0, !dbg !4350
  br i1 %3, label %4, label %11, !dbg !4351

; <label>:4:                                      ; preds = %1
  %5 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %2, !dbg !4352
  %6 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %5, align 4, !dbg !4352, !tbaa !244
  %7 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %6, i32 0, i32 0, !dbg !4352
  store volatile i32 4097, i32* %7, align 4, !dbg !4354, !tbaa !246
  %8 = getelementptr inbounds [2 x %struct.JL_USB_IO_TypeDef*], [2 x %struct.JL_USB_IO_TypeDef*]* @usb_io_regs, i32 0, i32 %2, !dbg !4355
  %9 = load %struct.JL_USB_IO_TypeDef*, %struct.JL_USB_IO_TypeDef** %8, align 4, !dbg !4355, !tbaa !244
  %10 = getelementptr inbounds %struct.JL_USB_IO_TypeDef, %struct.JL_USB_IO_TypeDef* %9, i32 0, i32 0, !dbg !4355
  store volatile i32 12, i32* %10, align 4, !dbg !4356, !tbaa !1323
  br label %20, !dbg !4357

; <label>:11:                                     ; preds = %1
  %12 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4358, !tbaa !214
  %13 = and i32 %12, -33, !dbg !4358
  store volatile i32 %13, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4358, !tbaa !214
  %14 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4360, !tbaa !214
  %15 = and i32 %14, -769, !dbg !4360
  store volatile i32 %15, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4360, !tbaa !214
  %16 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4361, !tbaa !214
  %17 = and i32 %16, -1879048193, !dbg !4361
  store volatile i32 %17, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4361, !tbaa !214
  %18 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4362, !tbaa !214
  %19 = and i32 %18, -31, !dbg !4362
  store volatile i32 %19, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4362, !tbaa !214
  br label %20

; <label>:20:                                     ; preds = %11, %4
  ret void, !dbg !4363
}

; Function Attrs: minsize nounwind optsize
define void @usb_hotplug_enable(i8 zeroext, i32) local_unnamed_addr #3 !dbg !4364 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4366, metadata !173), !dbg !4368
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !4367, metadata !173), !dbg !4369
  %3 = zext i8 %0 to i32, !dbg !4370
  %4 = icmp eq i8 %0, 0, !dbg !4372
  br i1 %4, label %5, label %38, !dbg !4373

; <label>:5:                                      ; preds = %2
  tail call void @usb_hotplug_disable(i8 zeroext 0) #10, !dbg !4374
  %6 = shl nuw nsw i32 %3, 1, !dbg !4376
  %7 = add nuw nsw i32 %6, 148, !dbg !4377
  %8 = tail call i32 @gpio_direction_input(i32 %7) #9, !dbg !4378
  %9 = tail call i32 @gpio_set_die(i32 %7, i32 1) #9, !dbg !4379
  %10 = tail call i32 @gpio_set_dieh(i32 %7, i32 1) #9, !dbg !4380
  %11 = tail call i32 @gpio_set_pull_up(i32 %7, i32 0) #9, !dbg !4381
  %12 = tail call i32 @gpio_set_pull_down(i32 %7, i32 1) #9, !dbg !4382
  %13 = and i32 %1, 8, !dbg !4383
  %14 = icmp eq i32 %13, 0, !dbg !4383
  %15 = add nuw nsw i32 %6, 149
  %16 = tail call i32 @gpio_direction_input(i32 %15) #9, !dbg !4385
  br i1 %14, label %22, label %17, !dbg !4387

; <label>:17:                                     ; preds = %5
  %18 = tail call i32 @gpio_set_die(i32 %15, i32 0) #9, !dbg !4388
  %19 = tail call i32 @gpio_set_dieh(i32 %15, i32 0) #9, !dbg !4389
  %20 = tail call i32 @gpio_set_pull_up(i32 %15, i32 0) #9, !dbg !4390
  %21 = tail call i32 @gpio_set_pull_down(i32 %15, i32 0) #9, !dbg !4391
  br label %27, !dbg !4392

; <label>:22:                                     ; preds = %5
  %23 = tail call i32 @gpio_set_die(i32 %15, i32 1) #9, !dbg !4393
  %24 = tail call i32 @gpio_set_dieh(i32 %15, i32 1) #9, !dbg !4395
  %25 = tail call i32 @gpio_set_pull_up(i32 %15, i32 0) #9, !dbg !4396
  %26 = tail call i32 @gpio_set_pull_down(i32 %15, i32 1) #9, !dbg !4397
  br label %27

; <label>:27:                                     ; preds = %22, %17
  %28 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %3, !dbg !4398
  %29 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %28, align 4, !dbg !4398, !tbaa !244
  %30 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %29, i32 0, i32 0, !dbg !4398
  %31 = load volatile i32, i32* %30, align 4, !dbg !4399, !tbaa !246
  %32 = or i32 %31, 1, !dbg !4399
  store volatile i32 %32, i32* %30, align 4, !dbg !4399, !tbaa !246
  %33 = and i32 %1, 2, !dbg !4400
  %34 = icmp eq i32 %33, 0, !dbg !4400
  br i1 %34, label %58, label %35, !dbg !4402

; <label>:35:                                     ; preds = %27
  %36 = load volatile i32, i32* %30, align 4, !dbg !4403, !tbaa !246
  %37 = or i32 %36, 512, !dbg !4403
  store volatile i32 %37, i32* %30, align 4, !dbg !4403, !tbaa !246
  br label %58, !dbg !4405

; <label>:38:                                     ; preds = %2
  %39 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4406, !tbaa !214
  %40 = or i32 %39, 7, !dbg !4406
  store volatile i32 %40, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4406, !tbaa !214
  %41 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4408, !tbaa !214
  %42 = or i32 %41, 24, !dbg !4408
  store volatile i32 %42, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4408, !tbaa !214
  %43 = and i32 %1, 2, !dbg !4409
  %44 = icmp eq i32 %43, 0, !dbg !4409
  br i1 %44, label %48, label %45, !dbg !4411

; <label>:45:                                     ; preds = %38
  %46 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4412, !tbaa !214
  %47 = or i32 %46, 805306368, !dbg !4412
  store volatile i32 %47, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4412, !tbaa !214
  br label %48, !dbg !4414

; <label>:48:                                     ; preds = %45, %38
  %49 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4415, !tbaa !214
  %50 = or i32 %49, 32, !dbg !4415
  store volatile i32 %50, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4415, !tbaa !214
  %51 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4416, !tbaa !214
  %52 = or i32 %51, 256, !dbg !4416
  store volatile i32 %52, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4416, !tbaa !214
  %53 = and i32 %1, 8, !dbg !4417
  %54 = icmp eq i32 %53, 0, !dbg !4419
  br i1 %54, label %55, label %58, !dbg !4420

; <label>:55:                                     ; preds = %48
  %56 = load volatile i32, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4421, !tbaa !214
  %57 = or i32 %56, 512, !dbg !4421
  store volatile i32 %57, i32* inttoptr (i32 92684 to i32*), align 4, !dbg !4421, !tbaa !214
  br label %58, !dbg !4423

; <label>:58:                                     ; preds = %55, %48, %35, %27
  ret void, !dbg !4424
}

; Function Attrs: minsize optsize
declare i32 @gpio_direction_input(i32) local_unnamed_addr #5

; Function Attrs: minsize optsize
declare i32 @gpio_set_dieh(i32, i32) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define void @usb_sie_close(i8 zeroext) local_unnamed_addr #3 !dbg !4425 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4427, metadata !173), !dbg !4428
  %2 = zext i8 %0 to i32, !dbg !4429
  %3 = icmp eq i8 %0, 0, !dbg !4431
  br i1 %3, label %4, label %12, !dbg !4432

; <label>:4:                                      ; preds = %1
  %5 = getelementptr inbounds [2 x %struct.JL_USB_TypeDef*], [2 x %struct.JL_USB_TypeDef*]* @usb_regs, i32 0, i32 %2, !dbg !4433
  %6 = load %struct.JL_USB_TypeDef*, %struct.JL_USB_TypeDef** %5, align 4, !dbg !4433, !tbaa !244
  %7 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %6, i32 0, i32 0, !dbg !4433
  store volatile i32 0, i32* %7, align 4, !dbg !4435, !tbaa !246
  %8 = getelementptr inbounds %struct.JL_USB_TypeDef, %struct.JL_USB_TypeDef* %6, i32 0, i32 1, !dbg !4436
  store volatile i32 0, i32* %8, align 4, !dbg !4437, !tbaa !254
  %9 = getelementptr inbounds [2 x %struct.JL_USB_IO_TypeDef*], [2 x %struct.JL_USB_IO_TypeDef*]* @usb_io_regs, i32 0, i32 %2, !dbg !4438
  %10 = load %struct.JL_USB_IO_TypeDef*, %struct.JL_USB_IO_TypeDef** %9, align 4, !dbg !4438, !tbaa !244
  %11 = getelementptr inbounds %struct.JL_USB_IO_TypeDef, %struct.JL_USB_IO_TypeDef* %10, i32 0, i32 0, !dbg !4438
  store volatile i32 12, i32* %11, align 4, !dbg !4439, !tbaa !1323
  store i8 0, i8* @otg_prevent_detect, align 1, !dbg !4440, !tbaa !692
  br label %13, !dbg !4441

; <label>:12:                                     ; preds = %1
  store volatile i32 0, i32* inttoptr (i32 92160 to i32*), align 2048, !dbg !4442, !tbaa !214
  br label %13

; <label>:13:                                     ; preds = %12, %4
  ret void, !dbg !4444
}

; Function Attrs: minsize nounwind optsize
define void @usb_sie_close_all() local_unnamed_addr #3 !dbg !4445 {
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !4447, metadata !173), !dbg !4448
  br label %1, !dbg !4449

; <label>:1:                                      ; preds = %4, %0
  %2 = phi i8 [ 0, %0 ], [ %5, %4 ]
  tail call void @llvm.dbg.value(metadata i8 %2, i64 0, metadata !4447, metadata !173), !dbg !4448
  %3 = icmp eq i8 %2, 2, !dbg !4451
  br i1 %3, label %6, label %4, !dbg !4454

; <label>:4:                                      ; preds = %1
  tail call void @usb_sie_close(i8 zeroext %2) #10, !dbg !4456
  %5 = add nuw nsw i8 %2, 1, !dbg !4458
  tail call void @llvm.dbg.value(metadata i8 %5, i64 0, metadata !4447, metadata !173), !dbg !4448
  br label %1, !dbg !4460, !llvm.loop !4461

; <label>:6:                                      ; preds = %1
  ret void, !dbg !4464
}

; Function Attrs: minsize optsize
declare i32 @gpio_direction_output(i32, i32) local_unnamed_addr #5

; Function Attrs: minsize nounwind optsize
define void @usb_var_init(i8 zeroext, i8*) local_unnamed_addr #3 !dbg !4465 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4469, metadata !173), !dbg !4471
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !4470, metadata !173), !dbg !4472
  %3 = zext i8 %0 to i32, !dbg !4473
  %4 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %3, !dbg !4473
  %5 = bitcast %struct.usb_ep_addr_t** %4 to i8**, !dbg !4474
  store i8* %1, i8** %5, align 4, !dbg !4474, !tbaa !244
  %6 = icmp eq i8* %1, null, !dbg !4475
  br i1 %6, label %8, label %7, !dbg !4477

; <label>:7:                                      ; preds = %2
  tail call void @llvm.memset.p0i8.i32(i8* nonnull %1, i8 0, i32 104, i32 4, i1 false), !dbg !4478
  br label %8, !dbg !4480

; <label>:8:                                      ; preds = %7, %2
  ret void, !dbg !4481
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i32(i8* nocapture writeonly, i8, i32, i32, i1) #1

; Function Attrs: minsize nounwind optsize
define void @usb_var_release(i8 zeroext) local_unnamed_addr #3 !dbg !4482 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !4484, metadata !173), !dbg !4485
  %2 = zext i8 %0 to i32, !dbg !4486
  %3 = getelementptr inbounds [2 x %struct.usb_ep_addr_t*], [2 x %struct.usb_ep_addr_t*]* @usb_ep_addr, i32 0, i32 %2, !dbg !4486
  %4 = load %struct.usb_ep_addr_t*, %struct.usb_ep_addr_t** %3, align 4, !dbg !4486, !tbaa !244
  %5 = icmp eq %struct.usb_ep_addr_t* %4, null, !dbg !4486
  br i1 %5, label %7, label %6, !dbg !4488

; <label>:6:                                      ; preds = %1
  store %struct.usb_ep_addr_t* null, %struct.usb_ep_addr_t** %3, align 4, !dbg !4489, !tbaa !244
  br label %7, !dbg !4491

; <label>:7:                                      ; preds = %6, %1
  ret void, !dbg !4492
}

; Function Attrs: minsize optsize
declare void @P33_SYSTEM_RESET() local_unnamed_addr #5

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #8

attributes #0 = { minsize noreturn nounwind optsize "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { minsize norecurse nounwind optsize "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { minsize nounwind optsize "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { minsize nounwind optsize "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { minsize optsize "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { minsize nounwind optsize readonly "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind }
attributes #8 = { nounwind readnone }
attributes #9 = { minsize nounwind optsize }
attributes #10 = { minsize optsize }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!170, !171}
!llvm.ident = !{!172}

!0 = !DIGlobalVariableExpression(var: !1)
!1 = distinct !DIGlobalVariable(name: "usb_ep_addr", scope: !2, file: !3, line: 67, type: !169, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 4.0.1 () ()", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !50, globals: !107)
!3 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/cpu/wl82/usb.c", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!4 = !{!5, !41}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "dev_err", file: !6, line: 109, size: 32, elements: !7)
!6 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/device/device_drive.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!7 = !{!8, !9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40}
!8 = !DIEnumerator(name: "DEV_ERR_NONE", value: 0)
!9 = !DIEnumerator(name: "DEV_ERR_NOT_MOUNT", value: 1)
!10 = !DIEnumerator(name: "DEV_ERR_OVER_CAPACITY", value: 2)
!11 = !DIEnumerator(name: "DEV_ERR_UNKNOW_CLASS", value: 3)
!12 = !DIEnumerator(name: "DEV_ERR_NOT_READY", value: 4)
!13 = !DIEnumerator(name: "DEV_ERR_LUN", value: 5)
!14 = !DIEnumerator(name: "DEV_ERR_TIMEOUT", value: 6)
!15 = !DIEnumerator(name: "DEV_ERR_CMD_TIMEOUT", value: 7)
!16 = !DIEnumerator(name: "DEV_ERR_READ_TIMEOUT", value: 8)
!17 = !DIEnumerator(name: "DEV_ERR_WRITE_TIMEOUT", value: 9)
!18 = !DIEnumerator(name: "DEV_ERR_OFFLINE", value: 10)
!19 = !DIEnumerator(name: "DEV_ERR_CRC", value: 11)
!20 = !DIEnumerator(name: "DEV_ERR_CMD_CRC", value: 12)
!21 = !DIEnumerator(name: "DEV_ERR_READ_CRC", value: 13)
!22 = !DIEnumerator(name: "DEV_ERR_WRITE_CRC", value: 14)
!23 = !DIEnumerator(name: "DEV_ERR_CONTROL_STALL", value: 15)
!24 = !DIEnumerator(name: "DEV_ERR_RXSTALL", value: 16)
!25 = !DIEnumerator(name: "DEV_ERR_TXSTALL", value: 17)
!26 = !DIEnumerator(name: "DEV_ERR_CONTROL", value: 18)
!27 = !DIEnumerator(name: "DEV_ERR_NOT_STORAGE", value: 19)
!28 = !DIEnumerator(name: "DEV_ERR_INVALID_PATH", value: 20)
!29 = !DIEnumerator(name: "DEV_ERR_INVALID_DATA", value: 21)
!30 = !DIEnumerator(name: "DEV_ERR_OUTOFMEMORY", value: 22)
!31 = !DIEnumerator(name: "DEV_ERR_HANDLE_FREE", value: 23)
!32 = !DIEnumerator(name: "DEV_ERR_INVALID_HANDLE", value: 24)
!33 = !DIEnumerator(name: "DEV_ERR_INVALID_BUF", value: 25)
!34 = !DIEnumerator(name: "DEV_ERR_INUSE", value: 26)
!35 = !DIEnumerator(name: "DEV_ERR_NO_READ", value: 27)
!36 = !DIEnumerator(name: "DEV_ERR_NO_WRITE", value: 28)
!37 = !DIEnumerator(name: "DEV_ERR_NO_IOCTL", value: 29)
!38 = !DIEnumerator(name: "DEV_ERR_NO_POWER", value: 30)
!39 = !DIEnumerator(name: "DEV_ERR_NOT_EXIST", value: 31)
!40 = !DIEnumerator(name: "DEV_ERR_UNKNOW", value: 32)
!41 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "usb_device_speed", file: !42, line: 922, size: 32, elements: !43)
!42 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/device/usb/ch9.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!43 = !{!44, !45, !46, !47, !48, !49}
!44 = !DIEnumerator(name: "USB_SPEED_UNKNOWN", value: 0)
!45 = !DIEnumerator(name: "USB_SPEED_LOW", value: 1)
!46 = !DIEnumerator(name: "USB_SPEED_FULL", value: 2)
!47 = !DIEnumerator(name: "USB_SPEED_HIGH", value: 3)
!48 = !DIEnumerator(name: "USB_SPEED_WIRELESS", value: 4)
!49 = !DIEnumerator(name: "USB_SPEED_SUPER", value: 5)
!50 = !{!51, !55, !52, !57, !61, !62, !59, !64, !66, !80, !91, !92}
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 32)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "u8", file: !53, line: 14, baseType: !54)
!53 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/cpu.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!54 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "u16", file: !53, line: 17, baseType: !56)
!56 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 32)
!58 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !59)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "u32", file: !53, line: 19, baseType: !60)
!60 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 32)
!63 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !52)
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 32)
!65 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !55)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 32)
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "husb_ep_reg_t", file: !3, line: 783, size: 128, elements: !68)
!68 = !{!69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "txmaxp", scope: !67, file: !3, line: 784, baseType: !65, size: 16)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "txcsr", scope: !67, file: !3, line: 785, baseType: !65, size: 16, offset: 16)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "rxmaxp", scope: !67, file: !3, line: 786, baseType: !65, size: 16, offset: 32)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "rxcsr", scope: !67, file: !3, line: 787, baseType: !65, size: 16, offset: 48)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "rxcount", scope: !67, file: !3, line: 788, baseType: !65, size: 16, offset: 64)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "txtype", scope: !67, file: !3, line: 789, baseType: !63, size: 8, offset: 80)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "txinterval", scope: !67, file: !3, line: 790, baseType: !63, size: 8, offset: 88)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "rxtype", scope: !67, file: !3, line: 791, baseType: !63, size: 8, offset: 96)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "rxinterval", scope: !67, file: !3, line: 792, baseType: !63, size: 8, offset: 104)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "reserve", scope: !67, file: !3, line: 793, baseType: !63, size: 8, offset: 112)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "fifosize", scope: !67, file: !3, line: 794, baseType: !63, size: 8, offset: 120)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 32)
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "husb_func_reg_t", file: !3, line: 796, size: 64, elements: !82)
!82 = !{!83, !84, !85, !86, !87, !88, !89, !90}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "txfuncaddr", scope: !81, file: !3, line: 797, baseType: !63, size: 8)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "res0", scope: !81, file: !3, line: 798, baseType: !52, size: 8, offset: 8)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "txhubaddr", scope: !81, file: !3, line: 799, baseType: !63, size: 8, offset: 16)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "txhubport", scope: !81, file: !3, line: 800, baseType: !63, size: 8, offset: 24)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "rxfuncaddr", scope: !81, file: !3, line: 801, baseType: !63, size: 8, offset: 32)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !81, file: !3, line: 802, baseType: !52, size: 8, offset: 40)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "rxhubaddr", scope: !81, file: !3, line: 803, baseType: !63, size: 8, offset: 48)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "rxhubport", scope: !81, file: !3, line: 804, baseType: !63, size: 8, offset: 56)
!91 = !DIBasicType(name: "long int", size: 32, encoding: DW_ATE_signed)
!92 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !93, size: 32)
!93 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "usb_ep_addr_t", file: !94, line: 134, size: 832, align: 32, elements: !95)
!94 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/usb.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!95 = !{!96, !97, !98, !102, !103, !104, !105, !106}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "ep0_addr", scope: !93, file: !94, line: 135, baseType: !59, size: 32)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "ep_usage", scope: !93, file: !94, line: 136, baseType: !59, size: 32, offset: 32)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "ep_taddr", scope: !93, file: !94, line: 137, baseType: !99, size: 128, offset: 64)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !59, size: 128, elements: !100)
!100 = !{!101}
!101 = !DISubrange(count: 4)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "ep_dual_taddr", scope: !93, file: !94, line: 138, baseType: !99, size: 128, offset: 192)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "ep_raddr", scope: !93, file: !94, line: 139, baseType: !99, size: 128, offset: 320)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "ep_dual_raddr", scope: !93, file: !94, line: 140, baseType: !99, size: 128, offset: 448)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "ep_tsize", scope: !93, file: !94, line: 141, baseType: !99, size: 128, offset: 576)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "ep_rsize", scope: !93, file: !94, line: 142, baseType: !99, size: 128, offset: 704)
!107 = !{!0, !108, !121, !126, !152, !163}
!108 = !DIGlobalVariableExpression(var: !109)
!109 = distinct !DIGlobalVariable(name: "usb_flag", scope: !110, file: !3, line: 87, type: !116, isLocal: true, isDefinition: true)
!110 = distinct !DISubprogram(name: "nvram_set_boot_state", scope: !3, file: !3, line: 85, type: !111, isLocal: false, isDefinition: true, scopeLine: 86, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !113)
!111 = !DISubroutineType(types: !112)
!112 = !{null, !59}
!113 = !{!114, !115}
!114 = !DILocalVariable(name: "state", arg: 1, scope: !110, file: !3, line: 85, type: !59)
!115 = !DILocalVariable(name: "addr", scope: !110, file: !3, line: 88, type: !51)
!116 = !DICompositeType(tag: DW_TAG_array_type, baseType: !117, size: 128, elements: !119)
!117 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !118)
!118 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!119 = !{!120}
!120 = !DISubrange(count: 16)
!121 = !DIGlobalVariableExpression(var: !122)
!122 = distinct !DIGlobalVariable(name: "host_speed", scope: !2, file: !3, line: 83, type: !123, isLocal: true, isDefinition: true)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 16, elements: !124)
!124 = !{!125}
!125 = !DISubrange(count: 2)
!126 = !DIGlobalVariableExpression(var: !127)
!127 = distinct !DIGlobalVariable(name: "usb_regs", scope: !2, file: !3, line: 69, type: !128, isLocal: true, isDefinition: true)
!128 = !DICompositeType(tag: DW_TAG_array_type, baseType: !129, size: 64, elements: !124)
!129 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !130)
!130 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !131, size: 32)
!131 = !DIDerivedType(tag: DW_TAG_typedef, name: "JL_USB_TypeDef", file: !132, line: 482, baseType: !133)
!132 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/WL82.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!133 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !132, line: 465, size: 512, elements: !134)
!134 = !{!135, !137, !138, !139, !140, !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151}
!135 = !DIDerivedType(tag: DW_TAG_member, name: "CON0", scope: !133, file: !132, line: 466, baseType: !136, size: 32)
!136 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !60)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "CON1", scope: !133, file: !132, line: 467, baseType: !136, size: 32, offset: 32)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "EP0_CNT", scope: !133, file: !132, line: 468, baseType: !136, size: 32, offset: 64)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "EP1_CNT", scope: !133, file: !132, line: 469, baseType: !136, size: 32, offset: 96)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "EP2_CNT", scope: !133, file: !132, line: 470, baseType: !136, size: 32, offset: 128)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "EP3_CNT", scope: !133, file: !132, line: 471, baseType: !136, size: 32, offset: 160)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "EP0_ADR", scope: !133, file: !132, line: 472, baseType: !136, size: 32, offset: 192)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "EP1_TADR", scope: !133, file: !132, line: 473, baseType: !136, size: 32, offset: 224)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "EP1_RADR", scope: !133, file: !132, line: 474, baseType: !136, size: 32, offset: 256)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "EP2_TADR", scope: !133, file: !132, line: 475, baseType: !136, size: 32, offset: 288)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "EP2_RADR", scope: !133, file: !132, line: 476, baseType: !136, size: 32, offset: 320)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "EP3_TADR", scope: !133, file: !132, line: 477, baseType: !136, size: 32, offset: 352)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "EP3_RADR", scope: !133, file: !132, line: 478, baseType: !136, size: 32, offset: 384)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "EP4_CNT", scope: !133, file: !132, line: 479, baseType: !136, size: 32, offset: 416)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "EP4_TADR", scope: !133, file: !132, line: 480, baseType: !136, size: 32, offset: 448)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "EP4_RADR", scope: !133, file: !132, line: 481, baseType: !136, size: 32, offset: 480)
!152 = !DIGlobalVariableExpression(var: !153)
!153 = distinct !DIGlobalVariable(name: "usb_io_regs", scope: !2, file: !3, line: 73, type: !154, isLocal: true, isDefinition: true)
!154 = !DICompositeType(tag: DW_TAG_array_type, baseType: !155, size: 64, elements: !124)
!155 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !156)
!156 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !157, size: 32)
!157 = !DIDerivedType(tag: DW_TAG_typedef, name: "JL_USB_IO_TypeDef", file: !132, line: 292, baseType: !158)
!158 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !132, line: 288, size: 96, elements: !159)
!159 = !{!160, !161, !162}
!160 = !DIDerivedType(tag: DW_TAG_member, name: "CON0", scope: !158, file: !132, line: 289, baseType: !136, size: 32)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "CON1", scope: !158, file: !132, line: 290, baseType: !136, size: 32, offset: 32)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "CON2", scope: !158, file: !132, line: 291, baseType: !136, size: 32, offset: 64)
!163 = !DIGlobalVariableExpression(var: !164)
!164 = distinct !DIGlobalVariable(name: "speed_table", scope: !2, file: !3, line: 1480, type: !165, isLocal: true, isDefinition: true)
!165 = !DICompositeType(tag: DW_TAG_array_type, baseType: !166, size: 24, elements: !167)
!166 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !52)
!167 = !{!168}
!168 = !DISubrange(count: 3)
!169 = !DICompositeType(tag: DW_TAG_array_type, baseType: !92, size: 64, elements: !124)
!170 = !{i32 2, !"Dwarf Version", i32 4}
!171 = !{i32 2, !"Debug Info Version", i32 3}
!172 = !{!"clang version 4.0.1 () ()"}
!173 = !DIExpression()
!174 = !DILocation(line: 85, column: 31, scope: !110)
!175 = !DILocation(line: 88, column: 9, scope: !110)
!176 = !DILocation(line: 89, column: 5, scope: !110)
!177 = !DILocation(line: 216, column: 5, scope: !178, inlinedAt: !182)
!178 = distinct !DISubprogram(name: "cpu_reset", scope: !53, file: !53, line: 210, type: !179, isLocal: true, isDefinition: true, scopeLine: 211, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !181)
!179 = !DISubroutineType(types: !180)
!180 = !{null}
!181 = !{}
!182 = distinct !DILocation(line: 90, column: 5, scope: !110)
!183 = !DILocation(line: 217, column: 5, scope: !178, inlinedAt: !182)
!184 = !DILocation(line: 217, column: 5, scope: !185, inlinedAt: !182)
!185 = !DILexicalBlockFile(scope: !178, file: !53, discriminator: 1)
!186 = distinct !{!186, !187, !188}
!187 = !DILocation(line: 217, column: 5, scope: !178)
!188 = !DILocation(line: 217, column: 14, scope: !178)
!189 = distinct !DISubprogram(name: "usb_get_jiffies", scope: !3, file: !3, line: 92, type: !190, isLocal: false, isDefinition: true, scopeLine: 93, isOptimized: true, unit: !2, variables: !181)
!190 = !DISubroutineType(types: !191)
!191 = !{!59}
!192 = !DILocation(line: 94, column: 12, scope: !189)
!193 = !{!194, !194, i64 0}
!194 = !{!"long", !195, i64 0}
!195 = !{!"omnipotent char", !196, i64 0}
!196 = !{!"Simple C/C++ TBAA"}
!197 = !DILocation(line: 94, column: 5, scope: !189)
!198 = distinct !DISubprogram(name: "musb_read_usb", scope: !3, file: !3, line: 97, type: !199, isLocal: false, isDefinition: true, scopeLine: 98, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !203)
!199 = !DISubroutineType(types: !200)
!200 = !{!59, !201, !59}
!201 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !202)
!202 = !DIDerivedType(tag: DW_TAG_typedef, name: "usb_dev", file: !94, line: 146, baseType: !52)
!203 = !{!204, !205, !206, !207}
!204 = !DILocalVariable(name: "id", arg: 1, scope: !198, file: !3, line: 97, type: !201)
!205 = !DILocalVariable(name: "addr", arg: 2, scope: !198, file: !3, line: 97, type: !59)
!206 = !DILocalVariable(name: "ot", scope: !198, file: !3, line: 100, type: !59)
!207 = !DILocalVariable(name: "data", scope: !198, file: !3, line: 101, type: !59)
!208 = !DILocation(line: 97, column: 33, scope: !198)
!209 = !DILocation(line: 97, column: 41, scope: !198)
!210 = !DILocation(line: 99, column: 5, scope: !211)
!211 = !DILexicalBlockFile(scope: !212, file: !3, discriminator: 1)
!212 = distinct !DILexicalBlock(scope: !213, file: !3, line: 99, column: 5)
!213 = distinct !DILexicalBlock(scope: !198, file: !3, line: 99, column: 5)
!214 = !{!215, !215, i64 0}
!215 = !{!"int", !195, i64 0}
!216 = !DILocation(line: 99, column: 5, scope: !217)
!217 = !DILexicalBlockFile(scope: !213, file: !3, discriminator: 1)
!218 = !DILocation(line: 99, column: 5, scope: !219)
!219 = !DILexicalBlockFile(scope: !220, file: !3, discriminator: 1)
!220 = distinct !DILexicalBlock(scope: !212, file: !3, line: 99, column: 5)
!221 = !DILocation(line: 99, column: 5, scope: !222)
!222 = !DILexicalBlockFile(scope: !223, file: !3, discriminator: 2)
!223 = distinct !DILexicalBlock(scope: !224, file: !3, line: 99, column: 5)
!224 = distinct !DILexicalBlock(scope: !220, file: !3, line: 99, column: 5)
!225 = !DILocation(line: 99, column: 5, scope: !226)
!226 = !DILexicalBlockFile(scope: !223, file: !3, discriminator: 4)
!227 = !DILocation(line: 99, column: 5, scope: !228)
!228 = !DILexicalBlockFile(scope: !223, file: !3, discriminator: 5)
!229 = !DILocation(line: 99, column: 5, scope: !230)
!230 = !DILexicalBlockFile(scope: !223, file: !3, discriminator: 6)
!231 = !DILocation(line: 99, column: 5, scope: !232)
!232 = !DILexicalBlockFile(scope: !233, file: !3, discriminator: 3)
!233 = distinct !DILexicalBlock(scope: !212, file: !3, line: 99, column: 5)
!234 = !DILocation(line: 216, column: 5, scope: !178, inlinedAt: !235)
!235 = distinct !DILocation(line: 99, column: 5, scope: !236)
!236 = !DILexicalBlockFile(scope: !237, file: !3, discriminator: 6)
!237 = distinct !DILexicalBlock(scope: !238, file: !3, line: 99, column: 5)
!238 = distinct !DILexicalBlock(scope: !233, file: !3, line: 99, column: 5)
!239 = !DILocation(line: 217, column: 5, scope: !178, inlinedAt: !235)
!240 = !DILocation(line: 217, column: 5, scope: !185, inlinedAt: !235)
!241 = !DILocation(line: 100, column: 9, scope: !198)
!242 = !DILocation(line: 103, column: 11, scope: !243)
!243 = distinct !DILexicalBlock(scope: !198, file: !3, line: 103, column: 9)
!244 = !{!245, !245, i64 0}
!245 = !{!"any pointer", !195, i64 0}
!246 = !{!247, !215, i64 0}
!247 = !{!"", !215, i64 0, !215, i64 4, !215, i64 8, !215, i64 12, !215, i64 16, !215, i64 20, !215, i64 24, !215, i64 28, !215, i64 32, !215, i64 36, !215, i64 40, !215, i64 44, !215, i64 48, !215, i64 52, !215, i64 56, !215, i64 60}
!248 = !DILocation(line: 103, column: 38, scope: !243)
!249 = !DILocation(line: 103, column: 9, scope: !198)
!250 = !DILocation(line: 106, column: 49, scope: !198)
!251 = !DILocation(line: 106, column: 55, scope: !198)
!252 = !DILocation(line: 106, column: 5, scope: !198)
!253 = !DILocation(line: 106, column: 32, scope: !198)
!254 = !{!247, !215, i64 4}
!255 = !DILocation(line: 107, column: 5, scope: !198)
!256 = !{i32 3850}
!257 = !DILocation(line: 108, column: 5, scope: !198)
!258 = !DILocation(line: 108, column: 13, scope: !259)
!259 = !DILexicalBlockFile(scope: !198, file: !3, discriminator: 1)
!260 = !DILocation(line: 108, column: 53, scope: !259)
!261 = !DILocation(line: 108, column: 5, scope: !259)
!262 = !DILocation(line: 109, column: 18, scope: !263)
!263 = distinct !DILexicalBlock(scope: !264, file: !3, line: 109, column: 13)
!264 = distinct !DILexicalBlock(scope: !198, file: !3, line: 108, column: 59)
!265 = !DILocation(line: 109, column: 13, scope: !264)
!266 = distinct !{!266, !257, !267}
!267 = !DILocation(line: 112, column: 5, scope: !198)
!268 = !DILocation(line: 113, column: 12, scope: !198)
!269 = !DILocation(line: 113, column: 39, scope: !198)
!270 = !DILocation(line: 101, column: 9, scope: !198)
!271 = !DILocation(line: 114, column: 5, scope: !198)
!272 = !DILocation(line: 115, column: 1, scope: !198)
!273 = !DILocation(line: 115, column: 1, scope: !259)
!274 = distinct !DISubprogram(name: "musb_write_usb", scope: !3, file: !3, line: 117, type: !275, isLocal: false, isDefinition: true, scopeLine: 118, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !277)
!275 = !DISubroutineType(types: !276)
!276 = !{null, !201, !59, !59}
!277 = !{!278, !279, !280, !281}
!278 = !DILocalVariable(name: "id", arg: 1, scope: !274, file: !3, line: 117, type: !201)
!279 = !DILocalVariable(name: "addr", arg: 2, scope: !274, file: !3, line: 117, type: !59)
!280 = !DILocalVariable(name: "data", arg: 3, scope: !274, file: !3, line: 117, type: !59)
!281 = !DILocalVariable(name: "ot", scope: !274, file: !3, line: 120, type: !59)
!282 = !DILocation(line: 117, column: 35, scope: !274)
!283 = !DILocation(line: 117, column: 43, scope: !274)
!284 = !DILocation(line: 117, column: 53, scope: !274)
!285 = !DILocation(line: 119, column: 5, scope: !286)
!286 = !DILexicalBlockFile(scope: !287, file: !3, discriminator: 1)
!287 = distinct !DILexicalBlock(scope: !288, file: !3, line: 119, column: 5)
!288 = distinct !DILexicalBlock(scope: !274, file: !3, line: 119, column: 5)
!289 = !DILocation(line: 119, column: 5, scope: !290)
!290 = !DILexicalBlockFile(scope: !288, file: !3, discriminator: 1)
!291 = !DILocation(line: 119, column: 5, scope: !292)
!292 = !DILexicalBlockFile(scope: !293, file: !3, discriminator: 1)
!293 = distinct !DILexicalBlock(scope: !287, file: !3, line: 119, column: 5)
!294 = !DILocation(line: 119, column: 5, scope: !295)
!295 = !DILexicalBlockFile(scope: !296, file: !3, discriminator: 2)
!296 = distinct !DILexicalBlock(scope: !297, file: !3, line: 119, column: 5)
!297 = distinct !DILexicalBlock(scope: !293, file: !3, line: 119, column: 5)
!298 = !DILocation(line: 119, column: 5, scope: !299)
!299 = !DILexicalBlockFile(scope: !296, file: !3, discriminator: 4)
!300 = !DILocation(line: 119, column: 5, scope: !301)
!301 = !DILexicalBlockFile(scope: !296, file: !3, discriminator: 5)
!302 = !DILocation(line: 119, column: 5, scope: !303)
!303 = !DILexicalBlockFile(scope: !296, file: !3, discriminator: 6)
!304 = !DILocation(line: 119, column: 5, scope: !305)
!305 = !DILexicalBlockFile(scope: !306, file: !3, discriminator: 3)
!306 = distinct !DILexicalBlock(scope: !287, file: !3, line: 119, column: 5)
!307 = !DILocation(line: 216, column: 5, scope: !178, inlinedAt: !308)
!308 = distinct !DILocation(line: 119, column: 5, scope: !309)
!309 = !DILexicalBlockFile(scope: !310, file: !3, discriminator: 6)
!310 = distinct !DILexicalBlock(scope: !311, file: !3, line: 119, column: 5)
!311 = distinct !DILexicalBlock(scope: !306, file: !3, line: 119, column: 5)
!312 = !DILocation(line: 217, column: 5, scope: !178, inlinedAt: !308)
!313 = !DILocation(line: 217, column: 5, scope: !185, inlinedAt: !308)
!314 = !DILocation(line: 120, column: 9, scope: !274)
!315 = !DILocation(line: 121, column: 11, scope: !316)
!316 = distinct !DILexicalBlock(scope: !274, file: !3, line: 121, column: 9)
!317 = !DILocation(line: 121, column: 38, scope: !316)
!318 = !DILocation(line: 121, column: 9, scope: !274)
!319 = !DILocation(line: 124, column: 49, scope: !274)
!320 = !DILocation(line: 124, column: 57, scope: !274)
!321 = !DILocation(line: 124, column: 55, scope: !274)
!322 = !DILocation(line: 124, column: 5, scope: !274)
!323 = !DILocation(line: 124, column: 32, scope: !274)
!324 = !DILocation(line: 125, column: 5, scope: !274)
!325 = !{i32 4334}
!326 = !DILocation(line: 126, column: 5, scope: !274)
!327 = !DILocation(line: 126, column: 13, scope: !328)
!328 = !DILexicalBlockFile(scope: !274, file: !3, discriminator: 1)
!329 = !DILocation(line: 126, column: 53, scope: !328)
!330 = !DILocation(line: 126, column: 5, scope: !328)
!331 = !DILocation(line: 127, column: 18, scope: !332)
!332 = distinct !DILexicalBlock(scope: !333, file: !3, line: 127, column: 13)
!333 = distinct !DILexicalBlock(scope: !274, file: !3, line: 126, column: 59)
!334 = !DILocation(line: 127, column: 13, scope: !333)
!335 = distinct !{!335, !326, !336}
!336 = !DILocation(line: 130, column: 5, scope: !274)
!337 = !DILocation(line: 131, column: 1, scope: !338)
!338 = !DILexicalBlockFile(scope: !274, file: !3, discriminator: 2)
!339 = !DILocation(line: 131, column: 1, scope: !328)
!340 = distinct !DISubprogram(name: "usb_dev_con0", scope: !3, file: !3, line: 133, type: !341, isLocal: false, isDefinition: true, scopeLine: 134, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !343)
!341 = !DISubroutineType(types: !342)
!342 = !{!59, !201}
!343 = !{!344}
!344 = !DILocalVariable(name: "id", arg: 1, scope: !340, file: !3, line: 133, type: !201)
!345 = !DILocation(line: 133, column: 32, scope: !340)
!346 = !DILocation(line: 135, column: 12, scope: !347)
!347 = distinct !DILexicalBlock(scope: !340, file: !3, line: 135, column: 9)
!348 = !DILocation(line: 135, column: 9, scope: !340)
!349 = !DILocation(line: 136, column: 16, scope: !350)
!350 = distinct !DILexicalBlock(scope: !347, file: !3, line: 135, column: 18)
!351 = !DILocation(line: 136, column: 9, scope: !350)
!352 = !DILocation(line: 140, column: 1, scope: !340)
!353 = distinct !DISubprogram(name: "usb_check_dpo", scope: !3, file: !3, line: 141, type: !341, isLocal: false, isDefinition: true, scopeLine: 142, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !354)
!354 = !{!355}
!355 = !DILocalVariable(name: "id", arg: 1, scope: !353, file: !3, line: 141, type: !201)
!356 = !DILocation(line: 141, column: 33, scope: !353)
!357 = !DILocation(line: 143, column: 12, scope: !358)
!358 = distinct !DILexicalBlock(scope: !353, file: !3, line: 143, column: 9)
!359 = !DILocation(line: 143, column: 9, scope: !353)
!360 = !DILocation(line: 144, column: 19, scope: !361)
!361 = distinct !DILexicalBlock(scope: !358, file: !3, line: 143, column: 18)
!362 = !DILocation(line: 144, column: 16, scope: !361)
!363 = !DILocation(line: 144, column: 9, scope: !361)
!364 = !DILocation(line: 146, column: 19, scope: !365)
!365 = distinct !DILexicalBlock(scope: !358, file: !3, line: 145, column: 12)
!366 = !DILocation(line: 146, column: 16, scope: !365)
!367 = !DILocation(line: 146, column: 9, scope: !365)
!368 = !DILocation(line: 148, column: 1, scope: !353)
!369 = distinct !DISubprogram(name: "usb_check_dmo", scope: !3, file: !3, line: 149, type: !341, isLocal: false, isDefinition: true, scopeLine: 150, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !370)
!370 = !{!371}
!371 = !DILocalVariable(name: "id", arg: 1, scope: !369, file: !3, line: 149, type: !201)
!372 = !DILocation(line: 149, column: 33, scope: !369)
!373 = !DILocation(line: 151, column: 12, scope: !374)
!374 = distinct !DILexicalBlock(scope: !369, file: !3, line: 151, column: 9)
!375 = !DILocation(line: 151, column: 9, scope: !369)
!376 = !DILocation(line: 154, column: 19, scope: !377)
!377 = distinct !DILexicalBlock(scope: !374, file: !3, line: 153, column: 12)
!378 = !DILocation(line: 154, column: 16, scope: !377)
!379 = !DILocation(line: 154, column: 9, scope: !377)
!380 = !DILocation(line: 156, column: 1, scope: !369)
!381 = distinct !DISubprogram(name: "usb_read_dp_se", scope: !3, file: !3, line: 157, type: !341, isLocal: false, isDefinition: true, scopeLine: 158, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !382)
!382 = !{!383}
!383 = !DILocalVariable(name: "id", arg: 1, scope: !381, file: !3, line: 157, type: !201)
!384 = !DILocation(line: 157, column: 34, scope: !381)
!385 = !DILocation(line: 159, column: 12, scope: !386)
!386 = distinct !DILexicalBlock(scope: !381, file: !3, line: 159, column: 9)
!387 = !DILocation(line: 159, column: 9, scope: !381)
!388 = !DILocation(line: 160, column: 19, scope: !389)
!389 = distinct !DILexicalBlock(scope: !386, file: !3, line: 159, column: 18)
!390 = !DILocation(line: 160, column: 16, scope: !389)
!391 = !DILocation(line: 160, column: 9, scope: !389)
!392 = !DILocation(line: 162, column: 19, scope: !393)
!393 = distinct !DILexicalBlock(scope: !386, file: !3, line: 161, column: 12)
!394 = !DILocation(line: 162, column: 16, scope: !393)
!395 = !DILocation(line: 162, column: 9, scope: !393)
!396 = !DILocation(line: 164, column: 1, scope: !381)
!397 = distinct !DISubprogram(name: "usb_read_dm_se", scope: !3, file: !3, line: 165, type: !341, isLocal: false, isDefinition: true, scopeLine: 166, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !398)
!398 = !{!399}
!399 = !DILocalVariable(name: "id", arg: 1, scope: !397, file: !3, line: 165, type: !201)
!400 = !DILocation(line: 165, column: 34, scope: !397)
!401 = !DILocation(line: 167, column: 12, scope: !402)
!402 = distinct !DILexicalBlock(scope: !397, file: !3, line: 167, column: 9)
!403 = !DILocation(line: 167, column: 9, scope: !397)
!404 = !DILocation(line: 172, column: 1, scope: !397)
!405 = distinct !DISubprogram(name: "usb_read_sofpnd", scope: !3, file: !3, line: 173, type: !341, isLocal: false, isDefinition: true, scopeLine: 174, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !406)
!406 = !{!407}
!407 = !DILocalVariable(name: "id", arg: 1, scope: !405, file: !3, line: 173, type: !201)
!408 = !DILocation(line: 173, column: 35, scope: !405)
!409 = !DILocation(line: 175, column: 12, scope: !410)
!410 = distinct !DILexicalBlock(scope: !405, file: !3, line: 175, column: 9)
!411 = !DILocation(line: 175, column: 9, scope: !405)
!412 = !DILocation(line: 182, column: 1, scope: !405)
!413 = distinct !DISubprogram(name: "usb_phy_status", scope: !3, file: !3, line: 183, type: !341, isLocal: false, isDefinition: true, scopeLine: 184, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !414)
!414 = !{!415}
!415 = !DILocalVariable(name: "id", arg: 1, scope: !413, file: !3, line: 183, type: !201)
!416 = !DILocation(line: 183, column: 34, scope: !413)
!417 = !DILocation(line: 185, column: 12, scope: !418)
!418 = distinct !DILexicalBlock(scope: !413, file: !3, line: 185, column: 9)
!419 = !DILocation(line: 185, column: 9, scope: !413)
!420 = !DILocation(line: 190, column: 1, scope: !413)
!421 = distinct !DISubprogram(name: "usb_sie_status", scope: !3, file: !3, line: 191, type: !341, isLocal: false, isDefinition: true, scopeLine: 192, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !422)
!422 = !{!423, !424}
!423 = !DILocalVariable(name: "id", arg: 1, scope: !421, file: !3, line: 191, type: !201)
!424 = !DILocalVariable(name: "status", scope: !421, file: !3, line: 193, type: !59)
!425 = !DILocation(line: 191, column: 34, scope: !421)
!426 = !DILocation(line: 193, column: 9, scope: !421)
!427 = !DILocation(line: 194, column: 12, scope: !428)
!428 = distinct !DILexicalBlock(scope: !421, file: !3, line: 194, column: 9)
!429 = !DILocation(line: 194, column: 9, scope: !421)
!430 = !DILocation(line: 195, column: 21, scope: !431)
!431 = distinct !DILexicalBlock(scope: !428, file: !3, line: 194, column: 18)
!432 = !DILocation(line: 195, column: 18, scope: !431)
!433 = !DILocation(line: 196, column: 5, scope: !431)
!434 = !DILocation(line: 197, column: 14, scope: !435)
!435 = distinct !DILexicalBlock(scope: !436, file: !3, line: 197, column: 13)
!436 = distinct !DILexicalBlock(scope: !428, file: !3, line: 196, column: 12)
!437 = !DILocation(line: 197, column: 27, scope: !435)
!438 = !DILocation(line: 197, column: 49, scope: !435)
!439 = !DILocation(line: 198, column: 14, scope: !435)
!440 = !DILocation(line: 198, column: 27, scope: !435)
!441 = !DILocation(line: 198, column: 47, scope: !435)
!442 = !DILocation(line: 199, column: 14, scope: !435)
!443 = !DILocation(line: 197, column: 13, scope: !444)
!444 = !DILexicalBlockFile(scope: !436, file: !3, discriminator: 1)
!445 = !DILocation(line: 203, column: 5, scope: !421)
!446 = distinct !DISubprogram(name: "usb_sie_enable", scope: !3, file: !3, line: 205, type: !447, isLocal: false, isDefinition: true, scopeLine: 206, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !449)
!447 = !DISubroutineType(types: !448)
!448 = !{null, !201}
!449 = !{!450}
!450 = !DILocalVariable(name: "id", arg: 1, scope: !446, file: !3, line: 205, type: !201)
!451 = !DILocation(line: 205, column: 35, scope: !446)
!452 = !DILocation(line: 207, column: 12, scope: !453)
!453 = distinct !DILexicalBlock(scope: !446, file: !3, line: 207, column: 9)
!454 = !DILocation(line: 207, column: 9, scope: !446)
!455 = !DILocation(line: 212, column: 1, scope: !446)
!456 = distinct !DISubprogram(name: "usb_sie_disable", scope: !3, file: !3, line: 213, type: !447, isLocal: false, isDefinition: true, scopeLine: 214, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !457)
!457 = !{!458}
!458 = !DILocalVariable(name: "id", arg: 1, scope: !456, file: !3, line: 213, type: !201)
!459 = !DILocation(line: 213, column: 36, scope: !456)
!460 = !DILocation(line: 215, column: 12, scope: !461)
!461 = distinct !DILexicalBlock(scope: !456, file: !3, line: 215, column: 9)
!462 = !DILocation(line: 215, column: 9, scope: !456)
!463 = !DILocation(line: 220, column: 1, scope: !456)
!464 = distinct !DISubprogram(name: "usb_sofie_enable", scope: !3, file: !3, line: 221, type: !447, isLocal: false, isDefinition: true, scopeLine: 222, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !465)
!465 = !{!466}
!466 = !DILocalVariable(name: "id", arg: 1, scope: !464, file: !3, line: 221, type: !201)
!467 = !DILocation(line: 221, column: 37, scope: !464)
!468 = !DILocation(line: 223, column: 12, scope: !469)
!469 = distinct !DILexicalBlock(scope: !464, file: !3, line: 223, column: 9)
!470 = !DILocation(line: 223, column: 9, scope: !464)
!471 = !DILocation(line: 228, column: 1, scope: !464)
!472 = distinct !DISubprogram(name: "usb_sofie_disable", scope: !3, file: !3, line: 229, type: !447, isLocal: false, isDefinition: true, scopeLine: 230, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !473)
!473 = !{!474}
!474 = !DILocalVariable(name: "id", arg: 1, scope: !472, file: !3, line: 229, type: !201)
!475 = !DILocation(line: 229, column: 38, scope: !472)
!476 = !DILocation(line: 231, column: 12, scope: !477)
!477 = distinct !DILexicalBlock(scope: !472, file: !3, line: 231, column: 9)
!478 = !DILocation(line: 231, column: 9, scope: !472)
!479 = !DILocation(line: 236, column: 1, scope: !472)
!480 = distinct !DISubprogram(name: "usb_sof_clr_pnd", scope: !3, file: !3, line: 237, type: !447, isLocal: false, isDefinition: true, scopeLine: 238, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !481)
!481 = !{!482}
!482 = !DILocalVariable(name: "id", arg: 1, scope: !480, file: !3, line: 237, type: !201)
!483 = !DILocation(line: 237, column: 36, scope: !480)
!484 = !DILocation(line: 239, column: 12, scope: !485)
!485 = distinct !DILexicalBlock(scope: !480, file: !3, line: 239, column: 9)
!486 = !DILocation(line: 239, column: 9, scope: !480)
!487 = !DILocation(line: 240, column: 9, scope: !488)
!488 = !DILexicalBlockFile(scope: !489, file: !3, discriminator: 1)
!489 = distinct !DILexicalBlock(scope: !490, file: !3, line: 240, column: 9)
!490 = distinct !DILexicalBlock(scope: !485, file: !3, line: 239, column: 18)
!491 = !DILocation(line: 241, column: 9, scope: !490)
!492 = !DILocation(line: 242, column: 9, scope: !493)
!493 = !DILexicalBlockFile(scope: !494, file: !3, discriminator: 1)
!494 = distinct !DILexicalBlock(scope: !490, file: !3, line: 242, column: 9)
!495 = !DILocation(line: 243, column: 5, scope: !490)
!496 = !DILocation(line: 244, column: 22, scope: !497)
!497 = distinct !DILexicalBlock(scope: !485, file: !3, line: 243, column: 12)
!498 = !DILocation(line: 246, column: 1, scope: !480)
!499 = distinct !DISubprogram(name: "usb_write_ep_cnt", scope: !3, file: !3, line: 247, type: !275, isLocal: false, isDefinition: true, scopeLine: 248, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !500)
!500 = !{!501, !502, !503, !504, !507, !509}
!501 = !DILocalVariable(name: "id", arg: 1, scope: !499, file: !3, line: 247, type: !201)
!502 = !DILocalVariable(name: "ep", arg: 2, scope: !499, file: !3, line: 247, type: !59)
!503 = !DILocalVariable(name: "len", arg: 3, scope: !499, file: !3, line: 247, type: !59)
!504 = !DILocalVariable(name: "tcnt", scope: !505, file: !3, line: 260, type: !57)
!505 = distinct !DILexicalBlock(scope: !506, file: !3, line: 249, column: 18)
!506 = distinct !DILexicalBlock(scope: !499, file: !3, line: 249, column: 9)
!507 = !DILocalVariable(name: "tcnt", scope: !508, file: !3, line: 265, type: !57)
!508 = distinct !DILexicalBlock(scope: !506, file: !3, line: 264, column: 12)
!509 = !DILocalVariable(name: "dma_size", scope: !510, file: !3, line: 269, type: !59)
!510 = distinct !DILexicalBlock(scope: !511, file: !3, line: 268, column: 84)
!511 = distinct !DILexicalBlock(scope: !508, file: !3, line: 268, column: 13)
!512 = !DILocation(line: 247, column: 37, scope: !499)
!513 = !DILocation(line: 247, column: 45, scope: !499)
!514 = !DILocation(line: 247, column: 53, scope: !499)
!515 = !DILocation(line: 249, column: 12, scope: !506)
!516 = !DILocation(line: 249, column: 9, scope: !499)
!517 = !DILocation(line: 251, column: 9, scope: !518)
!518 = !DILexicalBlockFile(scope: !519, file: !3, discriminator: 1)
!519 = distinct !DILexicalBlock(scope: !505, file: !3, line: 251, column: 9)
!520 = !DILocation(line: 252, column: 16, scope: !521)
!521 = distinct !DILexicalBlock(scope: !505, file: !3, line: 252, column: 13)
!522 = !DILocation(line: 252, column: 13, scope: !505)
!523 = !DILocation(line: 253, column: 43, scope: !524)
!524 = distinct !DILexicalBlock(scope: !521, file: !3, line: 252, column: 22)
!525 = !{!247, !215, i64 52}
!526 = !DILocation(line: 254, column: 13, scope: !524)
!527 = !{i32 7362}
!528 = !DILocation(line: 255, column: 13, scope: !529)
!529 = !DILexicalBlockFile(scope: !530, file: !3, discriminator: 1)
!530 = distinct !DILexicalBlock(scope: !524, file: !3, line: 255, column: 13)
!531 = !DILocation(line: 256, column: 13, scope: !524)
!532 = !DILocation(line: 260, column: 23, scope: !505)
!533 = !DILocation(line: 261, column: 14, scope: !505)
!534 = !DILocation(line: 262, column: 15, scope: !505)
!535 = !DILocation(line: 263, column: 9, scope: !536)
!536 = !DILexicalBlockFile(scope: !537, file: !3, discriminator: 1)
!537 = distinct !DILexicalBlock(scope: !505, file: !3, line: 263, column: 9)
!538 = !DILocation(line: 264, column: 5, scope: !505)
!539 = !DILocation(line: 265, column: 23, scope: !508)
!540 = !DILocation(line: 266, column: 14, scope: !508)
!541 = !DILocation(line: 268, column: 22, scope: !511)
!542 = !DILocation(line: 268, column: 38, scope: !543)
!543 = !DILexicalBlockFile(scope: !511, file: !3, discriminator: 1)
!544 = !DILocation(line: 268, column: 61, scope: !543)
!545 = !DILocation(line: 268, column: 13, scope: !546)
!546 = !DILexicalBlockFile(scope: !508, file: !3, discriminator: 1)
!547 = !DILocation(line: 269, column: 28, scope: !510)
!548 = !DILocation(line: 269, column: 17, scope: !510)
!549 = !DILocation(line: 270, column: 43, scope: !510)
!550 = !DILocation(line: 270, column: 50, scope: !510)
!551 = !DILocation(line: 271, column: 9, scope: !510)
!552 = !DILocation(line: 275, column: 5, scope: !499)
!553 = !{i32 8031}
!554 = !DILocation(line: 276, column: 5, scope: !499)
!555 = !{i32 8049}
!556 = !DILocation(line: 277, column: 1, scope: !499)
!557 = !DILocation(line: 277, column: 1, scope: !558)
!558 = !DILexicalBlockFile(scope: !499, file: !3, discriminator: 1)
!559 = distinct !DISubprogram(name: "usb_read_txcsr", scope: !3, file: !3, line: 823, type: !199, isLocal: false, isDefinition: true, scopeLine: 824, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !560)
!560 = !{!561, !562, !563, !566}
!561 = !DILocalVariable(name: "id", arg: 1, scope: !559, file: !3, line: 823, type: !201)
!562 = !DILocalVariable(name: "ep", arg: 2, scope: !559, file: !3, line: 823, type: !59)
!563 = !DILocalVariable(name: "txcsr", scope: !564, file: !3, line: 828, type: !59)
!564 = distinct !DILexicalBlock(scope: !565, file: !3, line: 825, column: 18)
!565 = distinct !DILexicalBlock(scope: !559, file: !3, line: 825, column: 9)
!566 = !DILocalVariable(name: "ep_reg", scope: !567, file: !3, line: 833, type: !66)
!567 = distinct !DILexicalBlock(scope: !565, file: !3, line: 832, column: 12)
!568 = !DILocation(line: 823, column: 34, scope: !559)
!569 = !DILocation(line: 823, column: 42, scope: !559)
!570 = !DILocation(line: 825, column: 12, scope: !565)
!571 = !DILocation(line: 825, column: 9, scope: !559)
!572 = !DILocation(line: 826, column: 9, scope: !573)
!573 = !DILexicalBlockFile(scope: !574, file: !3, discriminator: 1)
!574 = distinct !DILexicalBlock(scope: !564, file: !3, line: 826, column: 9)
!575 = !DILocation(line: 827, column: 9, scope: !564)
!576 = !DILocation(line: 828, column: 21, scope: !564)
!577 = !DILocation(line: 828, column: 55, scope: !578)
!578 = !DILexicalBlockFile(scope: !564, file: !3, discriminator: 1)
!579 = !DILocation(line: 828, column: 86, scope: !564)
!580 = !DILocation(line: 828, column: 52, scope: !564)
!581 = !DILocation(line: 828, column: 13, scope: !564)
!582 = !DILocation(line: 829, column: 9, scope: !583)
!583 = !DILexicalBlockFile(scope: !584, file: !3, discriminator: 1)
!584 = distinct !DILexicalBlock(scope: !564, file: !3, line: 829, column: 9)
!585 = !DILocation(line: 833, column: 31, scope: !567)
!586 = !DILocation(line: 834, column: 23, scope: !567)
!587 = !DILocation(line: 835, column: 9, scope: !567)
!588 = !{i32 23064}
!589 = !DILocation(line: 836, column: 24, scope: !567)
!590 = !{!591, !592, i64 2}
!591 = !{!"husb_ep_reg_t", !592, i64 0, !592, i64 2, !592, i64 4, !592, i64 6, !592, i64 8, !195, i64 10, !195, i64 11, !195, i64 12, !195, i64 13, !195, i64 14, !195, i64 15}
!592 = !{!"short", !195, i64 0}
!593 = !DILocation(line: 836, column: 16, scope: !567)
!594 = !DILocation(line: 839, column: 1, scope: !559)
!595 = distinct !DISubprogram(name: "usb_get_dma_size", scope: !3, file: !3, line: 346, type: !199, isLocal: false, isDefinition: true, scopeLine: 347, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !596)
!596 = !{!597, !598}
!597 = !DILocalVariable(name: "id", arg: 1, scope: !595, file: !3, line: 346, type: !201)
!598 = !DILocalVariable(name: "ep", arg: 2, scope: !595, file: !3, line: 346, type: !59)
!599 = !DILocation(line: 346, column: 36, scope: !595)
!600 = !DILocation(line: 346, column: 44, scope: !595)
!601 = !DILocation(line: 348, column: 9, scope: !602)
!602 = distinct !DILexicalBlock(scope: !595, file: !3, line: 348, column: 9)
!603 = !DILocation(line: 348, column: 25, scope: !602)
!604 = !DILocation(line: 348, column: 9, scope: !595)
!605 = !DILocation(line: 351, column: 41, scope: !595)
!606 = !DILocation(line: 351, column: 12, scope: !595)
!607 = !DILocation(line: 351, column: 5, scope: !595)
!608 = !DILocation(line: 352, column: 1, scope: !595)
!609 = distinct !DISubprogram(name: "usb_g_dev_status", scope: !3, file: !3, line: 278, type: !341, isLocal: false, isDefinition: true, scopeLine: 279, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !610)
!610 = !{!611}
!611 = !DILocalVariable(name: "id", arg: 1, scope: !609, file: !3, line: 278, type: !201)
!612 = !DILocation(line: 278, column: 36, scope: !609)
!613 = !DILocation(line: 280, column: 12, scope: !614)
!614 = distinct !DILexicalBlock(scope: !609, file: !3, line: 280, column: 9)
!615 = !DILocation(line: 280, column: 9, scope: !609)
!616 = !DILocation(line: 281, column: 18, scope: !617)
!617 = distinct !DILexicalBlock(scope: !614, file: !3, line: 280, column: 18)
!618 = !DILocation(line: 281, column: 45, scope: !617)
!619 = !DILocation(line: 281, column: 74, scope: !617)
!620 = !DILocation(line: 281, column: 9, scope: !617)
!621 = !DILocation(line: 285, column: 1, scope: !609)
!622 = distinct !DISubprogram(name: "usb_h_dev_status", scope: !3, file: !3, line: 286, type: !341, isLocal: false, isDefinition: true, scopeLine: 287, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !623)
!623 = !{!624, !625, !626}
!624 = !DILocalVariable(name: "id", arg: 1, scope: !622, file: !3, line: 286, type: !201)
!625 = !DILocalVariable(name: "dp_se", scope: !622, file: !3, line: 288, type: !59)
!626 = !DILocalVariable(name: "dm_se", scope: !622, file: !3, line: 289, type: !59)
!627 = !DILocation(line: 286, column: 36, scope: !622)
!628 = !DILocation(line: 288, column: 17, scope: !622)
!629 = !DILocation(line: 288, column: 9, scope: !622)
!630 = !DILocation(line: 289, column: 17, scope: !622)
!631 = !DILocation(line: 289, column: 9, scope: !622)
!632 = !DILocation(line: 290, column: 20, scope: !622)
!633 = !DILocation(line: 290, column: 20, scope: !634)
!634 = !DILexicalBlockFile(scope: !622, file: !3, discriminator: 2)
!635 = !DILocation(line: 290, column: 5, scope: !634)
!636 = distinct !DISubprogram(name: "usb_set_low_speed", scope: !3, file: !3, line: 292, type: !637, isLocal: false, isDefinition: true, scopeLine: 293, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !639)
!637 = !DISubroutineType(types: !638)
!638 = !{null, !201, !52}
!639 = !{!640, !641}
!640 = !DILocalVariable(name: "id", arg: 1, scope: !636, file: !3, line: 292, type: !201)
!641 = !DILocalVariable(name: "flag", arg: 2, scope: !636, file: !3, line: 292, type: !52)
!642 = !DILocation(line: 292, column: 38, scope: !636)
!643 = !DILocation(line: 292, column: 45, scope: !636)
!644 = !DILocation(line: 294, column: 12, scope: !645)
!645 = distinct !DILexicalBlock(scope: !636, file: !3, line: 294, column: 9)
!646 = !DILocation(line: 294, column: 9, scope: !636)
!647 = !DILocation(line: 295, column: 13, scope: !648)
!648 = distinct !DILexicalBlock(scope: !649, file: !3, line: 295, column: 13)
!649 = distinct !DILexicalBlock(scope: !645, file: !3, line: 294, column: 18)
!650 = !DILocation(line: 298, column: 13, scope: !651)
!651 = distinct !DILexicalBlock(scope: !648, file: !3, line: 297, column: 16)
!652 = !DILocation(line: 296, column: 13, scope: !653)
!653 = distinct !DILexicalBlock(scope: !648, file: !3, line: 295, column: 19)
!654 = !DILocation(line: 295, column: 13, scope: !649)
!655 = !DILocation(line: 300, column: 5, scope: !649)
!656 = !DILocation(line: 303, column: 1, scope: !636)
!657 = distinct !DISubprogram(name: "usb_write_ep0", scope: !3, file: !3, line: 304, type: !658, isLocal: false, isDefinition: true, scopeLine: 305, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !661)
!658 = !DISubroutineType(types: !659)
!659 = !{null, !201, !660, !59}
!660 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !166, size: 32)
!661 = !{!662, !663, !664}
!662 = !DILocalVariable(name: "id", arg: 1, scope: !657, file: !3, line: 304, type: !201)
!663 = !DILocalVariable(name: "ptr", arg: 2, scope: !657, file: !3, line: 304, type: !660)
!664 = !DILocalVariable(name: "len", arg: 3, scope: !657, file: !3, line: 304, type: !59)
!665 = !DILocation(line: 304, column: 34, scope: !657)
!666 = !DILocation(line: 304, column: 48, scope: !657)
!667 = !DILocation(line: 304, column: 57, scope: !657)
!668 = !DILocation(line: 306, column: 9, scope: !669)
!669 = distinct !DILexicalBlock(scope: !657, file: !3, line: 306, column: 9)
!670 = !DILocation(line: 306, column: 12, scope: !669)
!671 = !DILocation(line: 306, column: 9, scope: !657)
!672 = !DILocation(line: 307, column: 13, scope: !673)
!673 = distinct !DILexicalBlock(scope: !674, file: !3, line: 307, column: 13)
!674 = distinct !DILexicalBlock(scope: !669, file: !3, line: 306, column: 18)
!675 = !DILocation(line: 307, column: 13, scope: !674)
!676 = !DILocation(line: 308, column: 46, scope: !677)
!677 = distinct !DILexicalBlock(scope: !673, file: !3, line: 307, column: 30)
!678 = !{!679, !215, i64 0}
!679 = !{!"usb_ep_addr_t", !215, i64 0, !215, i64 4, !195, i64 8, !195, i64 24, !195, i64 40, !195, i64 56, !195, i64 72, !195, i64 88}
!680 = !DILocation(line: 308, column: 13, scope: !677)
!681 = !DILocation(line: 309, column: 13, scope: !677)
!682 = !DILocation(line: 309, column: 43, scope: !677)
!683 = !{!247, !215, i64 8}
!684 = !DILocation(line: 310, column: 9, scope: !677)
!685 = !DILocation(line: 312, column: 9, scope: !686)
!686 = !DILexicalBlockFile(scope: !687, file: !3, discriminator: 1)
!687 = distinct !DILexicalBlock(scope: !669, file: !3, line: 311, column: 12)
!688 = !DILocation(line: 312, column: 20, scope: !686)
!689 = !DILocation(line: 313, column: 28, scope: !690)
!690 = distinct !DILexicalBlock(scope: !687, file: !3, line: 312, column: 24)
!691 = !DILocation(line: 313, column: 24, scope: !690)
!692 = !{!195, !195, i64 0}
!693 = !DILocation(line: 313, column: 22, scope: !690)
!694 = distinct !{!694, !695, !696}
!695 = !DILocation(line: 312, column: 9, scope: !687)
!696 = !DILocation(line: 314, column: 9, scope: !687)
!697 = !DILocation(line: 316, column: 1, scope: !657)
!698 = !DILocation(line: 316, column: 1, scope: !699)
!699 = !DILexicalBlockFile(scope: !657, file: !3, discriminator: 1)
!700 = distinct !DISubprogram(name: "usb_read_ep0", scope: !3, file: !3, line: 318, type: !701, isLocal: false, isDefinition: true, scopeLine: 319, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !703)
!701 = !DISubroutineType(types: !702)
!702 = !{null, !201, !51, !59}
!703 = !{!704, !705, !706}
!704 = !DILocalVariable(name: "id", arg: 1, scope: !700, file: !3, line: 318, type: !201)
!705 = !DILocalVariable(name: "ptr", arg: 2, scope: !700, file: !3, line: 318, type: !51)
!706 = !DILocalVariable(name: "len", arg: 3, scope: !700, file: !3, line: 318, type: !59)
!707 = !DILocation(line: 318, column: 33, scope: !700)
!708 = !DILocation(line: 318, column: 41, scope: !700)
!709 = !DILocation(line: 318, column: 50, scope: !700)
!710 = !DILocation(line: 320, column: 12, scope: !711)
!711 = distinct !DILexicalBlock(scope: !700, file: !3, line: 320, column: 9)
!712 = !DILocation(line: 320, column: 9, scope: !700)
!713 = !DILocation(line: 321, column: 13, scope: !714)
!714 = distinct !DILexicalBlock(scope: !715, file: !3, line: 321, column: 13)
!715 = distinct !DILexicalBlock(scope: !711, file: !3, line: 320, column: 18)
!716 = !DILocation(line: 321, column: 13, scope: !715)
!717 = !DILocation(line: 322, column: 51, scope: !718)
!718 = distinct !DILexicalBlock(scope: !714, file: !3, line: 321, column: 30)
!719 = !DILocation(line: 322, column: 13, scope: !718)
!720 = !DILocation(line: 323, column: 9, scope: !718)
!721 = !DILocation(line: 325, column: 9, scope: !722)
!722 = !DILexicalBlockFile(scope: !723, file: !3, discriminator: 1)
!723 = distinct !DILexicalBlock(scope: !724, file: !3, line: 325, column: 9)
!724 = distinct !DILexicalBlock(scope: !711, file: !3, line: 324, column: 12)
!725 = !DILocation(line: 326, column: 20, scope: !724)
!726 = !DILocation(line: 327, column: 9, scope: !724)
!727 = !{i32 9235}
!728 = !DILocation(line: 328, column: 9, scope: !724)
!729 = !{i32 9257}
!730 = !DILocation(line: 329, column: 9, scope: !724)
!731 = !DILocation(line: 329, column: 9, scope: !732)
!732 = !DILexicalBlockFile(scope: !724, file: !3, discriminator: 1)
!733 = !DILocation(line: 329, column: 20, scope: !734)
!734 = !DILexicalBlockFile(scope: !724, file: !3, discriminator: 2)
!735 = !DILocation(line: 330, column: 22, scope: !736)
!736 = distinct !DILexicalBlock(scope: !724, file: !3, line: 329, column: 24)
!737 = !DILocation(line: 330, column: 17, scope: !736)
!738 = !DILocation(line: 330, column: 20, scope: !736)
!739 = !DILocation(line: 329, column: 9, scope: !734)
!740 = distinct !{!740, !730, !741}
!741 = !DILocation(line: 331, column: 9, scope: !724)
!742 = !DILocation(line: 332, column: 20, scope: !724)
!743 = !DILocation(line: 333, column: 9, scope: !744)
!744 = !DILexicalBlockFile(scope: !745, file: !3, discriminator: 1)
!745 = distinct !DILexicalBlock(scope: !724, file: !3, line: 333, column: 9)
!746 = !DILocation(line: 335, column: 1, scope: !700)
!747 = distinct !DISubprogram(name: "usb_get_dma_taddr", scope: !3, file: !3, line: 336, type: !748, isLocal: false, isDefinition: true, scopeLine: 337, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !750)
!748 = !DISubroutineType(types: !749)
!749 = !{!61, !201, !59}
!750 = !{!751, !752}
!751 = !DILocalVariable(name: "id", arg: 1, scope: !747, file: !3, line: 336, type: !201)
!752 = !DILocalVariable(name: "ep", arg: 2, scope: !747, file: !3, line: 336, type: !59)
!753 = !DILocation(line: 336, column: 39, scope: !747)
!754 = !DILocation(line: 336, column: 47, scope: !747)
!755 = !DILocation(line: 338, column: 9, scope: !756)
!756 = distinct !DILexicalBlock(scope: !747, file: !3, line: 338, column: 9)
!757 = !DILocation(line: 338, column: 25, scope: !756)
!758 = !DILocation(line: 338, column: 9, scope: !747)
!759 = !DILocation(line: 341, column: 12, scope: !760)
!760 = distinct !DILexicalBlock(scope: !747, file: !3, line: 341, column: 9)
!761 = !DILocation(line: 344, column: 50, scope: !747)
!762 = !DILocation(line: 344, column: 21, scope: !747)
!763 = !DILocation(line: 342, column: 42, scope: !764)
!764 = distinct !DILexicalBlock(scope: !760, file: !3, line: 341, column: 18)
!765 = !DILocation(line: 341, column: 9, scope: !747)
!766 = !DILocation(line: 345, column: 1, scope: !747)
!767 = !DILocation(line: 345, column: 1, scope: !768)
!768 = !DILexicalBlockFile(scope: !747, file: !3, discriminator: 1)
!769 = distinct !DISubprogram(name: "usb_set_dma_tsize", scope: !3, file: !3, line: 353, type: !275, isLocal: false, isDefinition: true, scopeLine: 354, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !770)
!770 = !{!771, !772, !773}
!771 = !DILocalVariable(name: "id", arg: 1, scope: !769, file: !3, line: 353, type: !201)
!772 = !DILocalVariable(name: "ep", arg: 2, scope: !769, file: !3, line: 353, type: !59)
!773 = !DILocalVariable(name: "size", arg: 3, scope: !769, file: !3, line: 353, type: !59)
!774 = !DILocation(line: 353, column: 38, scope: !769)
!775 = !DILocation(line: 353, column: 46, scope: !769)
!776 = !DILocation(line: 353, column: 54, scope: !769)
!777 = !DILocation(line: 355, column: 9, scope: !778)
!778 = distinct !DILexicalBlock(scope: !769, file: !3, line: 355, column: 9)
!779 = !DILocation(line: 355, column: 25, scope: !778)
!780 = !DILocation(line: 355, column: 9, scope: !769)
!781 = !DILocation(line: 358, column: 34, scope: !769)
!782 = !DILocation(line: 358, column: 5, scope: !769)
!783 = !DILocation(line: 358, column: 39, scope: !769)
!784 = !DILocation(line: 359, column: 1, scope: !769)
!785 = !DILocation(line: 359, column: 1, scope: !786)
!786 = !DILexicalBlockFile(scope: !769, file: !3, discriminator: 1)
!787 = distinct !DISubprogram(name: "usb_set_dma_rsize", scope: !3, file: !3, line: 360, type: !275, isLocal: false, isDefinition: true, scopeLine: 361, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !788)
!788 = !{!789, !790, !791}
!789 = !DILocalVariable(name: "id", arg: 1, scope: !787, file: !3, line: 360, type: !201)
!790 = !DILocalVariable(name: "ep", arg: 2, scope: !787, file: !3, line: 360, type: !59)
!791 = !DILocalVariable(name: "size", arg: 3, scope: !787, file: !3, line: 360, type: !59)
!792 = !DILocation(line: 360, column: 38, scope: !787)
!793 = !DILocation(line: 360, column: 46, scope: !787)
!794 = !DILocation(line: 360, column: 54, scope: !787)
!795 = !DILocation(line: 362, column: 9, scope: !796)
!796 = distinct !DILexicalBlock(scope: !787, file: !3, line: 362, column: 9)
!797 = !DILocation(line: 362, column: 25, scope: !796)
!798 = !DILocation(line: 362, column: 9, scope: !787)
!799 = !DILocation(line: 365, column: 34, scope: !787)
!800 = !DILocation(line: 365, column: 5, scope: !787)
!801 = !DILocation(line: 365, column: 39, scope: !787)
!802 = !DILocation(line: 366, column: 1, scope: !787)
!803 = !DILocation(line: 366, column: 1, scope: !804)
!804 = !DILexicalBlockFile(scope: !787, file: !3, discriminator: 1)
!805 = distinct !DISubprogram(name: "usb_set_dma_taddr", scope: !3, file: !3, line: 368, type: !806, isLocal: false, isDefinition: true, scopeLine: 369, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !808)
!806 = !DISubroutineType(types: !807)
!807 = !{null, !201, !59, !61}
!808 = !{!809, !810, !811, !812, !815}
!809 = !DILocalVariable(name: "id", arg: 1, scope: !805, file: !3, line: 368, type: !201)
!810 = !DILocalVariable(name: "ep", arg: 2, scope: !805, file: !3, line: 368, type: !59)
!811 = !DILocalVariable(name: "ptr", arg: 3, scope: !805, file: !3, line: 368, type: !61)
!812 = !DILocalVariable(name: "taddr", scope: !813, file: !3, line: 391, type: !57)
!813 = distinct !DILexicalBlock(scope: !814, file: !3, line: 373, column: 18)
!814 = distinct !DILexicalBlock(scope: !805, file: !3, line: 373, column: 9)
!815 = !DILocalVariable(name: "taddr", scope: !816, file: !3, line: 402, type: !57)
!816 = distinct !DILexicalBlock(scope: !814, file: !3, line: 397, column: 12)
!817 = !DILocation(line: 368, column: 38, scope: !805)
!818 = !DILocation(line: 368, column: 46, scope: !805)
!819 = !DILocation(line: 368, column: 56, scope: !805)
!820 = !DILocation(line: 370, column: 9, scope: !821)
!821 = distinct !DILexicalBlock(scope: !805, file: !3, line: 370, column: 9)
!822 = !DILocation(line: 370, column: 25, scope: !821)
!823 = !DILocation(line: 370, column: 9, scope: !805)
!824 = !DILocation(line: 373, column: 12, scope: !814)
!825 = !DILocation(line: 373, column: 9, scope: !805)
!826 = !DILocation(line: 374, column: 13, scope: !813)
!827 = !DILocation(line: 375, column: 45, scope: !828)
!828 = distinct !DILexicalBlock(scope: !829, file: !3, line: 374, column: 22)
!829 = distinct !DILexicalBlock(scope: !813, file: !3, line: 374, column: 13)
!830 = !DILocation(line: 375, column: 13, scope: !828)
!831 = !DILocation(line: 375, column: 43, scope: !828)
!832 = !{!247, !215, i64 24}
!833 = !DILocation(line: 376, column: 13, scope: !828)
!834 = !{i32 10369}
!835 = !DILocation(line: 377, column: 13, scope: !828)
!836 = !{i32 10395}
!837 = !DILocation(line: 378, column: 13, scope: !828)
!838 = !DILocation(line: 378, column: 30, scope: !828)
!839 = !DILocation(line: 378, column: 39, scope: !828)
!840 = !DILocation(line: 379, column: 13, scope: !828)
!841 = !DILocation(line: 382, column: 16, scope: !842)
!842 = distinct !DILexicalBlock(scope: !813, file: !3, line: 382, column: 13)
!843 = !DILocation(line: 383, column: 13, scope: !844)
!844 = distinct !DILexicalBlock(scope: !842, file: !3, line: 382, column: 22)
!845 = !DILocation(line: 382, column: 13, scope: !813)
!846 = !DILocation(line: 383, column: 46, scope: !847)
!847 = !DILexicalBlockFile(scope: !844, file: !3, discriminator: 1)
!848 = !DILocation(line: 383, column: 13, scope: !847)
!849 = !DILocation(line: 383, column: 44, scope: !847)
!850 = !{!247, !215, i64 56}
!851 = !DILocation(line: 384, column: 13, scope: !844)
!852 = !{i32 10642}
!853 = !DILocation(line: 385, column: 13, scope: !844)
!854 = !{i32 10668}
!855 = !DILocation(line: 386, column: 13, scope: !844)
!856 = !DILocation(line: 386, column: 47, scope: !844)
!857 = !DILocation(line: 387, column: 13, scope: !844)
!858 = !DILocation(line: 391, column: 32, scope: !813)
!859 = !DILocation(line: 391, column: 23, scope: !813)
!860 = !DILocation(line: 392, column: 26, scope: !813)
!861 = !DILocation(line: 392, column: 20, scope: !813)
!862 = !DILocation(line: 392, column: 15, scope: !813)
!863 = !DILocation(line: 393, column: 18, scope: !813)
!864 = !DILocation(line: 393, column: 16, scope: !813)
!865 = !DILocation(line: 394, column: 9, scope: !813)
!866 = !{i32 10961}
!867 = !DILocation(line: 395, column: 9, scope: !813)
!868 = !{i32 10983}
!869 = !DILocation(line: 396, column: 9, scope: !813)
!870 = !DILocation(line: 396, column: 43, scope: !813)
!871 = !DILocation(line: 397, column: 5, scope: !813)
!872 = !DILocation(line: 398, column: 13, scope: !816)
!873 = !DILocation(line: 399, column: 41, scope: !874)
!874 = distinct !DILexicalBlock(scope: !875, file: !3, line: 398, column: 22)
!875 = distinct !DILexicalBlock(scope: !816, file: !3, line: 398, column: 13)
!876 = !DILocation(line: 399, column: 30, scope: !874)
!877 = !DILocation(line: 399, column: 39, scope: !874)
!878 = !DILocation(line: 400, column: 13, scope: !874)
!879 = !DILocation(line: 402, column: 23, scope: !816)
!880 = !DILocation(line: 403, column: 26, scope: !816)
!881 = !DILocation(line: 403, column: 20, scope: !816)
!882 = !DILocation(line: 403, column: 15, scope: !816)
!883 = !DILocation(line: 404, column: 18, scope: !816)
!884 = !DILocation(line: 404, column: 16, scope: !816)
!885 = !DILocation(line: 405, column: 9, scope: !816)
!886 = !{i32 11277}
!887 = !DILocation(line: 406, column: 9, scope: !816)
!888 = !{i32 11299}
!889 = !DILocation(line: 407, column: 9, scope: !816)
!890 = !DILocation(line: 407, column: 43, scope: !816)
!891 = !DILocation(line: 409, column: 1, scope: !805)
!892 = distinct !DISubprogram(name: "usb_get_dma_raddr", scope: !3, file: !3, line: 410, type: !748, isLocal: false, isDefinition: true, scopeLine: 411, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !893)
!893 = !{!894, !895}
!894 = !DILocalVariable(name: "id", arg: 1, scope: !892, file: !3, line: 410, type: !201)
!895 = !DILocalVariable(name: "ep", arg: 2, scope: !892, file: !3, line: 410, type: !59)
!896 = !DILocation(line: 410, column: 39, scope: !892)
!897 = !DILocation(line: 410, column: 47, scope: !892)
!898 = !DILocation(line: 412, column: 9, scope: !899)
!899 = distinct !DILexicalBlock(scope: !892, file: !3, line: 412, column: 9)
!900 = !DILocation(line: 412, column: 25, scope: !899)
!901 = !DILocation(line: 412, column: 9, scope: !892)
!902 = !DILocation(line: 415, column: 12, scope: !903)
!903 = distinct !DILexicalBlock(scope: !892, file: !3, line: 415, column: 9)
!904 = !DILocation(line: 415, column: 9, scope: !892)
!905 = !DILocation(line: 416, column: 42, scope: !906)
!906 = distinct !DILexicalBlock(scope: !903, file: !3, line: 415, column: 18)
!907 = !DILocation(line: 416, column: 9, scope: !906)
!908 = !DILocation(line: 418, column: 48, scope: !909)
!909 = distinct !DILexicalBlock(scope: !892, file: !3, line: 418, column: 9)
!910 = !DILocation(line: 418, column: 14, scope: !909)
!911 = !DILocation(line: 418, column: 11, scope: !909)
!912 = !DILocation(line: 418, column: 9, scope: !892)
!913 = !DILocation(line: 419, column: 13, scope: !914)
!914 = distinct !DILexicalBlock(scope: !915, file: !3, line: 419, column: 13)
!915 = distinct !DILexicalBlock(scope: !909, file: !3, line: 418, column: 54)
!916 = !DILocation(line: 419, column: 47, scope: !914)
!917 = !DILocation(line: 419, column: 13, scope: !915)
!918 = !DILocation(line: 420, column: 89, scope: !919)
!919 = distinct !DILexicalBlock(scope: !914, file: !3, line: 419, column: 90)
!920 = !DILocation(line: 420, column: 130, scope: !919)
!921 = !DILocation(line: 420, column: 126, scope: !919)
!922 = !DILocation(line: 420, column: 87, scope: !919)
!923 = !DILocation(line: 420, column: 123, scope: !919)
!924 = !DILocation(line: 420, column: 39, scope: !919)
!925 = !DILocation(line: 420, column: 13, scope: !919)
!926 = !DILocation(line: 421, column: 29, scope: !919)
!927 = !DILocation(line: 421, column: 13, scope: !919)
!928 = !DILocation(line: 423, column: 39, scope: !929)
!929 = distinct !DILexicalBlock(scope: !914, file: !3, line: 422, column: 16)
!930 = !DILocation(line: 423, column: 13, scope: !929)
!931 = !DILocation(line: 424, column: 29, scope: !929)
!932 = !DILocation(line: 424, column: 70, scope: !929)
!933 = !DILocation(line: 424, column: 111, scope: !929)
!934 = !DILocation(line: 424, column: 107, scope: !929)
!935 = !DILocation(line: 424, column: 68, scope: !929)
!936 = !DILocation(line: 424, column: 104, scope: !929)
!937 = !DILocation(line: 424, column: 20, scope: !929)
!938 = !DILocation(line: 424, column: 13, scope: !929)
!939 = !DILocation(line: 428, column: 39, scope: !892)
!940 = !DILocation(line: 428, column: 5, scope: !892)
!941 = !DILocation(line: 429, column: 21, scope: !892)
!942 = !DILocation(line: 429, column: 5, scope: !892)
!943 = !DILocation(line: 430, column: 1, scope: !892)
!944 = distinct !DISubprogram(name: "usb_set_dma_raddr", scope: !3, file: !3, line: 431, type: !806, isLocal: false, isDefinition: true, scopeLine: 432, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !945)
!945 = !{!946, !947, !948, !949, !952}
!946 = !DILocalVariable(name: "id", arg: 1, scope: !944, file: !3, line: 431, type: !201)
!947 = !DILocalVariable(name: "ep", arg: 2, scope: !944, file: !3, line: 431, type: !59)
!948 = !DILocalVariable(name: "ptr", arg: 3, scope: !944, file: !3, line: 431, type: !61)
!949 = !DILocalVariable(name: "raddr", scope: !950, file: !3, line: 456, type: !57)
!950 = distinct !DILexicalBlock(scope: !951, file: !3, line: 433, column: 18)
!951 = distinct !DILexicalBlock(scope: !944, file: !3, line: 433, column: 9)
!952 = !DILocalVariable(name: "raddr", scope: !953, file: !3, line: 470, type: !57)
!953 = distinct !DILexicalBlock(scope: !951, file: !3, line: 462, column: 12)
!954 = !DILocation(line: 431, column: 38, scope: !944)
!955 = !DILocation(line: 431, column: 46, scope: !944)
!956 = !DILocation(line: 431, column: 56, scope: !944)
!957 = !DILocation(line: 433, column: 9, scope: !951)
!958 = !DILocation(line: 433, column: 12, scope: !951)
!959 = !DILocation(line: 433, column: 9, scope: !944)
!960 = !DILocation(line: 434, column: 16, scope: !961)
!961 = distinct !DILexicalBlock(scope: !950, file: !3, line: 434, column: 13)
!962 = !DILocation(line: 434, column: 13, scope: !950)
!963 = !DILocation(line: 435, column: 45, scope: !964)
!964 = distinct !DILexicalBlock(scope: !961, file: !3, line: 434, column: 22)
!965 = !DILocation(line: 435, column: 13, scope: !964)
!966 = !DILocation(line: 435, column: 43, scope: !964)
!967 = !DILocation(line: 436, column: 13, scope: !964)
!968 = !{i32 12574}
!969 = !DILocation(line: 437, column: 13, scope: !964)
!970 = !{i32 12600}
!971 = !DILocation(line: 438, column: 17, scope: !972)
!972 = distinct !DILexicalBlock(scope: !964, file: !3, line: 438, column: 17)
!973 = !DILocation(line: 438, column: 17, scope: !964)
!974 = !DILocation(line: 439, column: 34, scope: !975)
!975 = distinct !DILexicalBlock(scope: !972, file: !3, line: 438, column: 34)
!976 = !DILocation(line: 439, column: 43, scope: !975)
!977 = !DILocation(line: 440, column: 13, scope: !975)
!978 = !DILocation(line: 444, column: 13, scope: !979)
!979 = distinct !DILexicalBlock(scope: !950, file: !3, line: 444, column: 13)
!980 = !DILocation(line: 444, column: 29, scope: !979)
!981 = !DILocation(line: 444, column: 13, scope: !950)
!982 = !DILocation(line: 448, column: 16, scope: !983)
!983 = distinct !DILexicalBlock(scope: !950, file: !3, line: 448, column: 13)
!984 = !DILocation(line: 449, column: 13, scope: !985)
!985 = distinct !DILexicalBlock(scope: !983, file: !3, line: 448, column: 22)
!986 = !DILocation(line: 448, column: 13, scope: !950)
!987 = !DILocation(line: 449, column: 46, scope: !988)
!988 = !DILexicalBlockFile(scope: !985, file: !3, discriminator: 1)
!989 = !DILocation(line: 449, column: 13, scope: !988)
!990 = !DILocation(line: 449, column: 44, scope: !988)
!991 = !{!247, !215, i64 60}
!992 = !DILocation(line: 450, column: 13, scope: !985)
!993 = !{i32 12970}
!994 = !DILocation(line: 451, column: 13, scope: !985)
!995 = !{i32 12996}
!996 = !DILocation(line: 452, column: 13, scope: !985)
!997 = !DILocation(line: 452, column: 47, scope: !985)
!998 = !DILocation(line: 453, column: 13, scope: !985)
!999 = !DILocation(line: 456, column: 32, scope: !950)
!1000 = !DILocation(line: 456, column: 23, scope: !950)
!1001 = !DILocation(line: 457, column: 26, scope: !950)
!1002 = !DILocation(line: 457, column: 20, scope: !950)
!1003 = !DILocation(line: 457, column: 15, scope: !950)
!1004 = !DILocation(line: 458, column: 18, scope: !950)
!1005 = !DILocation(line: 458, column: 16, scope: !950)
!1006 = !DILocation(line: 459, column: 9, scope: !950)
!1007 = !{i32 13288}
!1008 = !DILocation(line: 460, column: 9, scope: !950)
!1009 = !{i32 13310}
!1010 = !DILocation(line: 461, column: 9, scope: !950)
!1011 = !DILocation(line: 461, column: 43, scope: !950)
!1012 = !DILocation(line: 462, column: 5, scope: !950)
!1013 = !DILocation(line: 463, column: 13, scope: !1014)
!1014 = distinct !DILexicalBlock(scope: !953, file: !3, line: 463, column: 13)
!1015 = !DILocation(line: 463, column: 29, scope: !1014)
!1016 = !DILocation(line: 463, column: 13, scope: !953)
!1017 = !DILocation(line: 466, column: 16, scope: !1018)
!1018 = distinct !DILexicalBlock(scope: !953, file: !3, line: 466, column: 13)
!1019 = !DILocation(line: 466, column: 13, scope: !953)
!1020 = !DILocation(line: 467, column: 41, scope: !1021)
!1021 = distinct !DILexicalBlock(scope: !1018, file: !3, line: 466, column: 22)
!1022 = !DILocation(line: 467, column: 30, scope: !1021)
!1023 = !DILocation(line: 467, column: 39, scope: !1021)
!1024 = !DILocation(line: 468, column: 13, scope: !1021)
!1025 = !DILocation(line: 470, column: 23, scope: !953)
!1026 = !DILocation(line: 472, column: 26, scope: !953)
!1027 = !DILocation(line: 472, column: 20, scope: !953)
!1028 = !DILocation(line: 472, column: 15, scope: !953)
!1029 = !DILocation(line: 473, column: 18, scope: !953)
!1030 = !DILocation(line: 473, column: 16, scope: !953)
!1031 = !DILocation(line: 474, column: 9, scope: !953)
!1032 = !{i32 13753}
!1033 = !DILocation(line: 475, column: 9, scope: !953)
!1034 = !{i32 13775}
!1035 = !DILocation(line: 476, column: 9, scope: !953)
!1036 = !DILocation(line: 476, column: 43, scope: !953)
!1037 = !DILocation(line: 480, column: 1, scope: !944)
!1038 = distinct !DISubprogram(name: "usb_set_dma_dual_raddr", scope: !3, file: !3, line: 481, type: !806, isLocal: false, isDefinition: true, scopeLine: 482, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1039)
!1039 = !{!1040, !1041, !1042}
!1040 = !DILocalVariable(name: "id", arg: 1, scope: !1038, file: !3, line: 481, type: !201)
!1041 = !DILocalVariable(name: "ep", arg: 2, scope: !1038, file: !3, line: 481, type: !59)
!1042 = !DILocalVariable(name: "ptr", arg: 3, scope: !1038, file: !3, line: 481, type: !61)
!1043 = !DILocation(line: 481, column: 43, scope: !1038)
!1044 = !DILocation(line: 481, column: 51, scope: !1038)
!1045 = !DILocation(line: 481, column: 61, scope: !1038)
!1046 = !DILocation(line: 483, column: 9, scope: !1047)
!1047 = distinct !DILexicalBlock(scope: !1038, file: !3, line: 483, column: 9)
!1048 = !DILocation(line: 483, column: 25, scope: !1047)
!1049 = !DILocation(line: 483, column: 9, scope: !1038)
!1050 = !DILocation(line: 486, column: 46, scope: !1038)
!1051 = !DILocation(line: 486, column: 39, scope: !1038)
!1052 = !DILocation(line: 486, column: 5, scope: !1038)
!1053 = !DILocation(line: 486, column: 44, scope: !1038)
!1054 = !DILocation(line: 487, column: 1, scope: !1038)
!1055 = !DILocation(line: 487, column: 1, scope: !1056)
!1056 = !DILexicalBlockFile(scope: !1038, file: !3, discriminator: 1)
!1057 = distinct !DISubprogram(name: "musb_write_index", scope: !3, file: !3, line: 489, type: !1058, isLocal: false, isDefinition: true, scopeLine: 490, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1060)
!1058 = !DISubroutineType(types: !1059)
!1059 = !{null, !202, !59}
!1060 = !{!1061, !1062}
!1061 = !DILocalVariable(name: "id", arg: 1, scope: !1057, file: !3, line: 489, type: !202)
!1062 = !DILocalVariable(name: "endpoint", arg: 2, scope: !1057, file: !3, line: 489, type: !59)
!1063 = !DILocation(line: 489, column: 31, scope: !1057)
!1064 = !DILocation(line: 489, column: 39, scope: !1057)
!1065 = !DILocation(line: 491, column: 5, scope: !1066)
!1066 = !DILexicalBlockFile(scope: !1067, file: !3, discriminator: 1)
!1067 = distinct !DILexicalBlock(scope: !1068, file: !3, line: 491, column: 5)
!1068 = distinct !DILexicalBlock(scope: !1057, file: !3, line: 491, column: 5)
!1069 = !DILocation(line: 491, column: 5, scope: !1070)
!1070 = !DILexicalBlockFile(scope: !1068, file: !3, discriminator: 1)
!1071 = !DILocation(line: 491, column: 5, scope: !1072)
!1072 = !DILexicalBlockFile(scope: !1073, file: !3, discriminator: 1)
!1073 = distinct !DILexicalBlock(scope: !1067, file: !3, line: 491, column: 5)
!1074 = !DILocation(line: 491, column: 5, scope: !1075)
!1075 = !DILexicalBlockFile(scope: !1076, file: !3, discriminator: 2)
!1076 = distinct !DILexicalBlock(scope: !1077, file: !3, line: 491, column: 5)
!1077 = distinct !DILexicalBlock(scope: !1073, file: !3, line: 491, column: 5)
!1078 = !DILocation(line: 491, column: 5, scope: !1079)
!1079 = !DILexicalBlockFile(scope: !1076, file: !3, discriminator: 4)
!1080 = !DILocation(line: 491, column: 5, scope: !1081)
!1081 = !DILexicalBlockFile(scope: !1076, file: !3, discriminator: 5)
!1082 = !DILocation(line: 491, column: 5, scope: !1083)
!1083 = !DILexicalBlockFile(scope: !1076, file: !3, discriminator: 6)
!1084 = !DILocation(line: 491, column: 5, scope: !1085)
!1085 = !DILexicalBlockFile(scope: !1086, file: !3, discriminator: 3)
!1086 = distinct !DILexicalBlock(scope: !1067, file: !3, line: 491, column: 5)
!1087 = !DILocation(line: 216, column: 5, scope: !178, inlinedAt: !1088)
!1088 = distinct !DILocation(line: 491, column: 5, scope: !1089)
!1089 = !DILexicalBlockFile(scope: !1090, file: !3, discriminator: 6)
!1090 = distinct !DILexicalBlock(scope: !1091, file: !3, line: 491, column: 5)
!1091 = distinct !DILexicalBlock(scope: !1086, file: !3, line: 491, column: 5)
!1092 = !DILocation(line: 217, column: 5, scope: !178, inlinedAt: !1088)
!1093 = !DILocation(line: 217, column: 5, scope: !185, inlinedAt: !1088)
!1094 = !DILocation(line: 492, column: 5, scope: !1057)
!1095 = !DILocation(line: 493, column: 1, scope: !1057)
!1096 = distinct !DISubprogram(name: "usb_write_power", scope: !3, file: !3, line: 494, type: !1058, isLocal: false, isDefinition: true, scopeLine: 495, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1097)
!1097 = !{!1098, !1099}
!1098 = !DILocalVariable(name: "id", arg: 1, scope: !1096, file: !3, line: 494, type: !202)
!1099 = !DILocalVariable(name: "value", arg: 2, scope: !1096, file: !3, line: 494, type: !59)
!1100 = !DILocation(line: 494, column: 30, scope: !1096)
!1101 = !DILocation(line: 494, column: 38, scope: !1096)
!1102 = !DILocation(line: 496, column: 12, scope: !1103)
!1103 = distinct !DILexicalBlock(scope: !1096, file: !3, line: 496, column: 9)
!1104 = !DILocation(line: 496, column: 9, scope: !1096)
!1105 = !DILocation(line: 497, column: 9, scope: !1106)
!1106 = !DILexicalBlockFile(scope: !1107, file: !3, discriminator: 1)
!1107 = distinct !DILexicalBlock(scope: !1108, file: !3, line: 497, column: 9)
!1108 = distinct !DILexicalBlock(scope: !1103, file: !3, line: 496, column: 18)
!1109 = !DILocation(line: 498, column: 9, scope: !1108)
!1110 = !DILocation(line: 499, column: 9, scope: !1111)
!1111 = !DILexicalBlockFile(scope: !1112, file: !3, discriminator: 1)
!1112 = distinct !DILexicalBlock(scope: !1108, file: !3, line: 499, column: 9)
!1113 = !DILocation(line: 500, column: 5, scope: !1108)
!1114 = !DILocation(line: 501, column: 20, scope: !1115)
!1115 = distinct !DILexicalBlock(scope: !1103, file: !3, line: 500, column: 12)
!1116 = !DILocation(line: 501, column: 18, scope: !1115)
!1117 = !DILocation(line: 503, column: 1, scope: !1096)
!1118 = distinct !DISubprogram(name: "usb_read_power", scope: !3, file: !3, line: 504, type: !1119, isLocal: false, isDefinition: true, scopeLine: 505, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1121)
!1119 = !DISubroutineType(types: !1120)
!1120 = !{!59, !202}
!1121 = !{!1122, !1123}
!1122 = !DILocalVariable(name: "id", arg: 1, scope: !1118, file: !3, line: 504, type: !202)
!1123 = !DILocalVariable(name: "power", scope: !1124, file: !3, line: 508, type: !52)
!1124 = distinct !DILexicalBlock(scope: !1125, file: !3, line: 506, column: 18)
!1125 = distinct !DILexicalBlock(scope: !1118, file: !3, line: 506, column: 9)
!1126 = !DILocation(line: 504, column: 28, scope: !1118)
!1127 = !DILocation(line: 506, column: 12, scope: !1125)
!1128 = !DILocation(line: 506, column: 9, scope: !1118)
!1129 = !DILocation(line: 507, column: 9, scope: !1130)
!1130 = !DILexicalBlockFile(scope: !1131, file: !3, discriminator: 1)
!1131 = distinct !DILexicalBlock(scope: !1124, file: !3, line: 507, column: 9)
!1132 = !DILocation(line: 508, column: 20, scope: !1124)
!1133 = !DILocation(line: 508, column: 12, scope: !1124)
!1134 = !DILocation(line: 509, column: 9, scope: !1135)
!1135 = !DILexicalBlockFile(scope: !1136, file: !3, discriminator: 1)
!1136 = distinct !DILexicalBlock(scope: !1124, file: !3, line: 509, column: 9)
!1137 = !DILocation(line: 512, column: 16, scope: !1138)
!1138 = distinct !DILexicalBlock(scope: !1125, file: !3, line: 511, column: 12)
!1139 = !DILocation(line: 512, column: 9, scope: !1138)
!1140 = !DILocation(line: 514, column: 1, scope: !1118)
!1141 = distinct !DISubprogram(name: "usb_read_devctl", scope: !3, file: !3, line: 515, type: !1119, isLocal: false, isDefinition: true, scopeLine: 516, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1142)
!1142 = !{!1143, !1144}
!1143 = !DILocalVariable(name: "id", arg: 1, scope: !1141, file: !3, line: 515, type: !202)
!1144 = !DILocalVariable(name: "val", scope: !1145, file: !3, line: 519, type: !52)
!1145 = distinct !DILexicalBlock(scope: !1146, file: !3, line: 517, column: 18)
!1146 = distinct !DILexicalBlock(scope: !1141, file: !3, line: 517, column: 9)
!1147 = !DILocation(line: 515, column: 29, scope: !1141)
!1148 = !DILocation(line: 517, column: 12, scope: !1146)
!1149 = !DILocation(line: 517, column: 9, scope: !1141)
!1150 = !DILocation(line: 518, column: 9, scope: !1151)
!1151 = !DILexicalBlockFile(scope: !1152, file: !3, discriminator: 1)
!1152 = distinct !DILexicalBlock(scope: !1145, file: !3, line: 518, column: 9)
!1153 = !DILocation(line: 519, column: 18, scope: !1145)
!1154 = !DILocation(line: 519, column: 12, scope: !1145)
!1155 = !DILocation(line: 520, column: 9, scope: !1156)
!1156 = !DILexicalBlockFile(scope: !1157, file: !3, discriminator: 1)
!1157 = distinct !DILexicalBlock(scope: !1145, file: !3, line: 520, column: 9)
!1158 = !DILocation(line: 523, column: 16, scope: !1159)
!1159 = distinct !DILexicalBlock(scope: !1146, file: !3, line: 522, column: 12)
!1160 = !DILocation(line: 523, column: 9, scope: !1159)
!1161 = !DILocation(line: 525, column: 1, scope: !1141)
!1162 = distinct !DISubprogram(name: "usb_write_devctl", scope: !3, file: !3, line: 526, type: !1058, isLocal: false, isDefinition: true, scopeLine: 527, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1163)
!1163 = !{!1164, !1165}
!1164 = !DILocalVariable(name: "id", arg: 1, scope: !1162, file: !3, line: 526, type: !202)
!1165 = !DILocalVariable(name: "value", arg: 2, scope: !1162, file: !3, line: 526, type: !59)
!1166 = !DILocation(line: 526, column: 31, scope: !1162)
!1167 = !DILocation(line: 526, column: 39, scope: !1162)
!1168 = !DILocation(line: 528, column: 12, scope: !1169)
!1169 = distinct !DILexicalBlock(scope: !1162, file: !3, line: 528, column: 9)
!1170 = !DILocation(line: 528, column: 9, scope: !1162)
!1171 = !DILocation(line: 529, column: 9, scope: !1172)
!1172 = !DILexicalBlockFile(scope: !1173, file: !3, discriminator: 1)
!1173 = distinct !DILexicalBlock(scope: !1174, file: !3, line: 529, column: 9)
!1174 = distinct !DILexicalBlock(scope: !1169, file: !3, line: 528, column: 18)
!1175 = !DILocation(line: 530, column: 9, scope: !1174)
!1176 = !DILocation(line: 531, column: 9, scope: !1177)
!1177 = !DILexicalBlockFile(scope: !1178, file: !3, discriminator: 1)
!1178 = distinct !DILexicalBlock(scope: !1174, file: !3, line: 531, column: 9)
!1179 = !DILocation(line: 532, column: 5, scope: !1174)
!1180 = !DILocation(line: 533, column: 21, scope: !1181)
!1181 = distinct !DILexicalBlock(scope: !1169, file: !3, line: 532, column: 12)
!1182 = !DILocation(line: 533, column: 19, scope: !1181)
!1183 = !DILocation(line: 535, column: 1, scope: !1162)
!1184 = distinct !DISubprogram(name: "usb_read_csr0", scope: !3, file: !3, line: 536, type: !1119, isLocal: false, isDefinition: true, scopeLine: 537, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1185)
!1185 = !{!1186, !1187}
!1186 = !DILocalVariable(name: "id", arg: 1, scope: !1184, file: !3, line: 536, type: !202)
!1187 = !DILocalVariable(name: "csr0", scope: !1188, file: !3, line: 541, type: !59)
!1188 = distinct !DILexicalBlock(scope: !1189, file: !3, line: 538, column: 18)
!1189 = distinct !DILexicalBlock(scope: !1184, file: !3, line: 538, column: 9)
!1190 = !DILocation(line: 536, column: 27, scope: !1184)
!1191 = !DILocation(line: 538, column: 12, scope: !1189)
!1192 = !DILocation(line: 538, column: 9, scope: !1184)
!1193 = !DILocation(line: 539, column: 9, scope: !1194)
!1194 = !DILexicalBlockFile(scope: !1195, file: !3, discriminator: 1)
!1195 = distinct !DILexicalBlock(scope: !1188, file: !3, line: 539, column: 9)
!1196 = !DILocation(line: 540, column: 9, scope: !1188)
!1197 = !DILocation(line: 541, column: 21, scope: !1188)
!1198 = !DILocation(line: 541, column: 13, scope: !1188)
!1199 = !DILocation(line: 542, column: 9, scope: !1200)
!1200 = !DILexicalBlockFile(scope: !1201, file: !3, discriminator: 1)
!1201 = distinct !DILexicalBlock(scope: !1188, file: !3, line: 542, column: 9)
!1202 = !DILocation(line: 545, column: 9, scope: !1203)
!1203 = distinct !DILexicalBlock(scope: !1189, file: !3, line: 544, column: 12)
!1204 = !{i32 15424}
!1205 = !DILocation(line: 546, column: 16, scope: !1203)
!1206 = !{!592, !592, i64 0}
!1207 = !DILocation(line: 546, column: 9, scope: !1203)
!1208 = !DILocation(line: 548, column: 1, scope: !1184)
!1209 = distinct !DISubprogram(name: "usb_write_csr0", scope: !3, file: !3, line: 550, type: !1058, isLocal: false, isDefinition: true, scopeLine: 551, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1210)
!1210 = !{!1211, !1212}
!1211 = !DILocalVariable(name: "id", arg: 1, scope: !1209, file: !3, line: 550, type: !202)
!1212 = !DILocalVariable(name: "csr0", arg: 2, scope: !1209, file: !3, line: 550, type: !59)
!1213 = !DILocation(line: 550, column: 29, scope: !1209)
!1214 = !DILocation(line: 550, column: 37, scope: !1209)
!1215 = !DILocation(line: 552, column: 12, scope: !1216)
!1216 = distinct !DILexicalBlock(scope: !1209, file: !3, line: 552, column: 9)
!1217 = !DILocation(line: 552, column: 9, scope: !1209)
!1218 = !DILocation(line: 553, column: 9, scope: !1219)
!1219 = !DILexicalBlockFile(scope: !1220, file: !3, discriminator: 1)
!1220 = distinct !DILexicalBlock(scope: !1221, file: !3, line: 553, column: 9)
!1221 = distinct !DILexicalBlock(scope: !1216, file: !3, line: 552, column: 18)
!1222 = !DILocation(line: 554, column: 9, scope: !1221)
!1223 = !DILocation(line: 555, column: 9, scope: !1221)
!1224 = !DILocation(line: 556, column: 9, scope: !1225)
!1225 = !DILexicalBlockFile(scope: !1226, file: !3, discriminator: 1)
!1226 = distinct !DILexicalBlock(scope: !1221, file: !3, line: 556, column: 9)
!1227 = !DILocation(line: 557, column: 5, scope: !1221)
!1228 = !DILocation(line: 558, column: 19, scope: !1229)
!1229 = distinct !DILexicalBlock(scope: !1216, file: !3, line: 557, column: 12)
!1230 = !DILocation(line: 558, column: 17, scope: !1229)
!1231 = !DILocation(line: 559, column: 9, scope: !1229)
!1232 = !{i32 15714}
!1233 = !DILocation(line: 560, column: 9, scope: !1229)
!1234 = !{i32 15736}
!1235 = !DILocation(line: 562, column: 1, scope: !1209)
!1236 = distinct !DISubprogram(name: "musb_read_sofframe", scope: !3, file: !3, line: 563, type: !1237, isLocal: false, isDefinition: true, scopeLine: 564, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1239)
!1237 = !DISubroutineType(types: !1238)
!1238 = !{!55, !201}
!1239 = !{!1240, !1241}
!1240 = !DILocalVariable(name: "id", arg: 1, scope: !1236, file: !3, line: 563, type: !201)
!1241 = !DILocalVariable(name: "sof", scope: !1242, file: !3, line: 566, type: !55)
!1242 = distinct !DILexicalBlock(scope: !1243, file: !3, line: 565, column: 18)
!1243 = distinct !DILexicalBlock(scope: !1236, file: !3, line: 565, column: 9)
!1244 = !DILocation(line: 563, column: 38, scope: !1236)
!1245 = !DILocation(line: 565, column: 12, scope: !1243)
!1246 = !DILocation(line: 565, column: 9, scope: !1236)
!1247 = !DILocation(line: 567, column: 9, scope: !1248)
!1248 = !DILexicalBlockFile(scope: !1249, file: !3, discriminator: 1)
!1249 = distinct !DILexicalBlock(scope: !1242, file: !3, line: 567, column: 9)
!1250 = !DILocation(line: 568, column: 15, scope: !1242)
!1251 = !DILocation(line: 568, column: 49, scope: !1252)
!1252 = !DILexicalBlockFile(scope: !1242, file: !3, discriminator: 1)
!1253 = !DILocation(line: 568, column: 80, scope: !1242)
!1254 = !DILocation(line: 568, column: 46, scope: !1242)
!1255 = !DILocation(line: 566, column: 13, scope: !1242)
!1256 = !DILocation(line: 569, column: 9, scope: !1257)
!1257 = !DILexicalBlockFile(scope: !1258, file: !3, discriminator: 1)
!1258 = distinct !DILexicalBlock(scope: !1242, file: !3, line: 569, column: 9)
!1259 = !DILocation(line: 572, column: 16, scope: !1260)
!1260 = distinct !DILexicalBlock(scope: !1243, file: !3, line: 571, column: 12)
!1261 = !DILocation(line: 572, column: 9, scope: !1260)
!1262 = !DILocation(line: 574, column: 1, scope: !1236)
!1263 = distinct !DISubprogram(name: "usb_ep0_ClrRxPktRdy", scope: !3, file: !3, line: 576, type: !447, isLocal: false, isDefinition: true, scopeLine: 577, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1264)
!1264 = !{!1265}
!1265 = !DILocalVariable(name: "id", arg: 1, scope: !1263, file: !3, line: 576, type: !201)
!1266 = !DILocation(line: 576, column: 40, scope: !1263)
!1267 = !DILocation(line: 578, column: 5, scope: !1263)
!1268 = !DILocation(line: 579, column: 1, scope: !1263)
!1269 = distinct !DISubprogram(name: "usb_ep0_TxPktEnd", scope: !3, file: !3, line: 581, type: !447, isLocal: false, isDefinition: true, scopeLine: 582, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1270)
!1270 = !{!1271}
!1271 = !DILocalVariable(name: "id", arg: 1, scope: !1269, file: !3, line: 581, type: !201)
!1272 = !DILocation(line: 581, column: 37, scope: !1269)
!1273 = !DILocation(line: 583, column: 5, scope: !1269)
!1274 = !DILocation(line: 584, column: 1, scope: !1269)
!1275 = distinct !DISubprogram(name: "usb_ep0_RxPktEnd", scope: !3, file: !3, line: 586, type: !447, isLocal: false, isDefinition: true, scopeLine: 587, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1276)
!1276 = !{!1277}
!1277 = !DILocalVariable(name: "id", arg: 1, scope: !1275, file: !3, line: 586, type: !201)
!1278 = !DILocation(line: 586, column: 37, scope: !1275)
!1279 = !DILocation(line: 588, column: 5, scope: !1275)
!1280 = !DILocation(line: 589, column: 1, scope: !1275)
!1281 = distinct !DISubprogram(name: "usb_ep0_Set_Stall", scope: !3, file: !3, line: 591, type: !447, isLocal: false, isDefinition: true, scopeLine: 592, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1282)
!1282 = !{!1283}
!1283 = !DILocalVariable(name: "id", arg: 1, scope: !1281, file: !3, line: 591, type: !201)
!1284 = !DILocation(line: 591, column: 38, scope: !1281)
!1285 = !DILocation(line: 593, column: 5, scope: !1281)
!1286 = !DILocation(line: 594, column: 1, scope: !1281)
!1287 = distinct !DISubprogram(name: "usb_ep0_Set_ignore", scope: !3, file: !3, line: 596, type: !1288, isLocal: false, isDefinition: true, scopeLine: 597, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1290)
!1288 = !DISubroutineType(types: !1289)
!1289 = !{null, !201, !59}
!1290 = !{!1291, !1292, !1293}
!1291 = !DILocalVariable(name: "id", arg: 1, scope: !1287, file: !3, line: 596, type: !201)
!1292 = !DILocalVariable(name: "addr", arg: 2, scope: !1287, file: !3, line: 596, type: !59)
!1293 = !DILocalVariable(name: "reg", scope: !1294, file: !3, line: 602, type: !55)
!1294 = distinct !DILexicalBlock(scope: !1295, file: !3, line: 601, column: 19)
!1295 = distinct !DILexicalBlock(scope: !1296, file: !3, line: 598, column: 18)
!1296 = distinct !DILexicalBlock(scope: !1287, file: !3, line: 598, column: 9)
!1297 = !DILocation(line: 596, column: 39, scope: !1287)
!1298 = !DILocation(line: 596, column: 47, scope: !1287)
!1299 = !DILocation(line: 598, column: 9, scope: !1296)
!1300 = !DILocation(line: 598, column: 12, scope: !1296)
!1301 = !DILocation(line: 598, column: 9, scope: !1287)
!1302 = !DILocation(line: 599, column: 9, scope: !1295)
!1303 = !DILocation(line: 601, column: 9, scope: !1295)
!1304 = !DILocation(line: 602, column: 23, scope: !1294)
!1305 = !DILocation(line: 603, column: 21, scope: !1306)
!1306 = distinct !DILexicalBlock(scope: !1294, file: !3, line: 603, column: 17)
!1307 = !DILocation(line: 603, column: 17, scope: !1294)
!1308 = !DILocation(line: 605, column: 26, scope: !1309)
!1309 = distinct !DILexicalBlock(scope: !1310, file: !3, line: 605, column: 25)
!1310 = distinct !DILexicalBlock(scope: !1311, file: !3, line: 604, column: 27)
!1311 = distinct !DILexicalBlock(scope: !1306, file: !3, line: 603, column: 40)
!1312 = !DILocation(line: 605, column: 26, scope: !1313)
!1313 = !DILexicalBlockFile(scope: !1309, file: !3, discriminator: 1)
!1314 = !DILocation(line: 605, column: 53, scope: !1313)
!1315 = !DILocation(line: 605, column: 82, scope: !1313)
!1316 = !DILocation(line: 605, column: 25, scope: !1317)
!1317 = !DILexicalBlockFile(scope: !1310, file: !3, discriminator: 1)
!1318 = distinct !{!1318, !1319, !1320}
!1319 = !DILocation(line: 604, column: 17, scope: !1311)
!1320 = !DILocation(line: 608, column: 17, scope: !1311)
!1321 = !DILocation(line: 609, column: 17, scope: !1311)
!1322 = !DILocation(line: 609, column: 50, scope: !1311)
!1323 = !{!1324, !215, i64 0}
!1324 = !{!"", !215, i64 0, !215, i64 4, !215, i64 8}
!1325 = !DILocation(line: 610, column: 17, scope: !1311)
!1326 = !DILocation(line: 618, column: 1, scope: !1287)
!1327 = distinct !DISubprogram(name: "usb_write_faddr", scope: !3, file: !3, line: 773, type: !1288, isLocal: false, isDefinition: true, scopeLine: 774, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1328)
!1328 = !{!1329, !1330}
!1329 = !DILocalVariable(name: "id", arg: 1, scope: !1327, file: !3, line: 773, type: !201)
!1330 = !DILocalVariable(name: "addr", arg: 2, scope: !1327, file: !3, line: 773, type: !59)
!1331 = !DILocation(line: 773, column: 36, scope: !1327)
!1332 = !DILocation(line: 773, column: 44, scope: !1327)
!1333 = !DILocation(line: 775, column: 12, scope: !1334)
!1334 = distinct !DILexicalBlock(scope: !1327, file: !3, line: 775, column: 9)
!1335 = !DILocation(line: 775, column: 9, scope: !1327)
!1336 = !DILocation(line: 776, column: 9, scope: !1337)
!1337 = !DILexicalBlockFile(scope: !1338, file: !3, discriminator: 1)
!1338 = distinct !DILexicalBlock(scope: !1339, file: !3, line: 776, column: 9)
!1339 = distinct !DILexicalBlock(scope: !1334, file: !3, line: 775, column: 18)
!1340 = !DILocation(line: 777, column: 9, scope: !1339)
!1341 = !DILocation(line: 778, column: 9, scope: !1342)
!1342 = !DILexicalBlockFile(scope: !1343, file: !3, discriminator: 1)
!1343 = distinct !DILexicalBlock(scope: !1339, file: !3, line: 778, column: 9)
!1344 = !DILocation(line: 779, column: 5, scope: !1339)
!1345 = !DILocation(line: 780, column: 20, scope: !1346)
!1346 = distinct !DILexicalBlock(scope: !1334, file: !3, line: 779, column: 12)
!1347 = !DILocation(line: 780, column: 18, scope: !1346)
!1348 = !DILocation(line: 782, column: 1, scope: !1327)
!1349 = distinct !DISubprogram(name: "usb_recover_io_status", scope: !3, file: !3, line: 619, type: !447, isLocal: false, isDefinition: true, scopeLine: 620, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1350)
!1350 = !{!1351}
!1351 = !DILocalVariable(name: "id", arg: 1, scope: !1349, file: !3, line: 619, type: !201)
!1352 = !DILocation(line: 619, column: 42, scope: !1349)
!1353 = !DILocation(line: 621, column: 12, scope: !1354)
!1354 = distinct !DILexicalBlock(scope: !1349, file: !3, line: 621, column: 9)
!1355 = !DILocation(line: 621, column: 9, scope: !1349)
!1356 = !DILocation(line: 622, column: 9, scope: !1357)
!1357 = distinct !DILexicalBlock(scope: !1354, file: !3, line: 621, column: 18)
!1358 = !DILocation(line: 623, column: 42, scope: !1357)
!1359 = !DILocation(line: 624, column: 5, scope: !1357)
!1360 = !DILocation(line: 627, column: 1, scope: !1349)
!1361 = distinct !DISubprogram(name: "usb_read_count0", scope: !3, file: !3, line: 628, type: !341, isLocal: false, isDefinition: true, scopeLine: 629, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1362)
!1362 = !{!1363, !1364}
!1363 = !DILocalVariable(name: "id", arg: 1, scope: !1361, file: !3, line: 628, type: !201)
!1364 = !DILocalVariable(name: "rxcount", scope: !1365, file: !3, line: 633, type: !59)
!1365 = distinct !DILexicalBlock(scope: !1366, file: !3, line: 630, column: 18)
!1366 = distinct !DILexicalBlock(scope: !1361, file: !3, line: 630, column: 9)
!1367 = !DILocation(line: 628, column: 35, scope: !1361)
!1368 = !DILocation(line: 630, column: 12, scope: !1366)
!1369 = !DILocation(line: 630, column: 9, scope: !1361)
!1370 = !DILocation(line: 631, column: 9, scope: !1371)
!1371 = !DILexicalBlockFile(scope: !1372, file: !3, discriminator: 1)
!1372 = distinct !DILexicalBlock(scope: !1365, file: !3, line: 631, column: 9)
!1373 = !DILocation(line: 632, column: 9, scope: !1365)
!1374 = !DILocation(line: 633, column: 23, scope: !1365)
!1375 = !DILocation(line: 633, column: 13, scope: !1365)
!1376 = !DILocation(line: 634, column: 9, scope: !1377)
!1377 = !DILexicalBlockFile(scope: !1378, file: !3, discriminator: 1)
!1378 = distinct !DILexicalBlock(scope: !1365, file: !3, line: 634, column: 9)
!1379 = !DILocation(line: 637, column: 16, scope: !1380)
!1380 = distinct !DILexicalBlock(scope: !1366, file: !3, line: 636, column: 12)
!1381 = !DILocation(line: 637, column: 9, scope: !1380)
!1382 = !DILocation(line: 639, column: 1, scope: !1361)
!1383 = distinct !DISubprogram(name: "usb_read_intr", scope: !3, file: !3, line: 641, type: !1384, isLocal: false, isDefinition: true, scopeLine: 645, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1388)
!1384 = !DISubroutineType(types: !1385)
!1385 = !{null, !201, !1386, !1386, !1386}
!1386 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1387)
!1387 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 32)
!1388 = !{!1389, !1390, !1391, !1392}
!1389 = !DILocalVariable(name: "id", arg: 1, scope: !1383, file: !3, line: 641, type: !201)
!1390 = !DILocalVariable(name: "intr_usb", arg: 2, scope: !1383, file: !3, line: 642, type: !1386)
!1391 = !DILocalVariable(name: "intr_tx", arg: 3, scope: !1383, file: !3, line: 643, type: !1386)
!1392 = !DILocalVariable(name: "intr_rx", arg: 4, scope: !1383, file: !3, line: 644, type: !1386)
!1393 = !DILocation(line: 641, column: 34, scope: !1383)
!1394 = !DILocation(line: 642, column: 31, scope: !1383)
!1395 = !DILocation(line: 643, column: 31, scope: !1383)
!1396 = !DILocation(line: 644, column: 31, scope: !1383)
!1397 = !DILocation(line: 647, column: 5, scope: !1398)
!1398 = !DILexicalBlockFile(scope: !1399, file: !3, discriminator: 1)
!1399 = distinct !DILexicalBlock(scope: !1383, file: !3, line: 647, column: 5)
!1400 = !DILocation(line: 648, column: 12, scope: !1401)
!1401 = distinct !DILexicalBlock(scope: !1383, file: !3, line: 648, column: 9)
!1402 = !DILocation(line: 648, column: 9, scope: !1383)
!1403 = !DILocation(line: 649, column: 21, scope: !1404)
!1404 = distinct !DILexicalBlock(scope: !1401, file: !3, line: 648, column: 18)
!1405 = !DILocation(line: 649, column: 19, scope: !1404)
!1406 = !DILocation(line: 650, column: 20, scope: !1404)
!1407 = !DILocation(line: 650, column: 54, scope: !1408)
!1408 = !DILexicalBlockFile(scope: !1404, file: !3, discriminator: 1)
!1409 = !DILocation(line: 650, column: 86, scope: !1404)
!1410 = !DILocation(line: 650, column: 52, scope: !1404)
!1411 = !DILocation(line: 650, column: 18, scope: !1404)
!1412 = !DILocation(line: 651, column: 20, scope: !1404)
!1413 = !DILocation(line: 651, column: 54, scope: !1408)
!1414 = !DILocation(line: 651, column: 86, scope: !1404)
!1415 = !DILocation(line: 651, column: 52, scope: !1404)
!1416 = !DILocation(line: 651, column: 18, scope: !1404)
!1417 = !DILocation(line: 652, column: 5, scope: !1404)
!1418 = !DILocation(line: 653, column: 20, scope: !1419)
!1419 = distinct !DILexicalBlock(scope: !1401, file: !3, line: 652, column: 12)
!1420 = !DILocation(line: 654, column: 9, scope: !1419)
!1421 = !{i32 18064}
!1422 = !DILocation(line: 655, column: 9, scope: !1419)
!1423 = !{i32 18086}
!1424 = !DILocation(line: 656, column: 21, scope: !1419)
!1425 = !DILocation(line: 656, column: 19, scope: !1419)
!1426 = !DILocation(line: 657, column: 20, scope: !1419)
!1427 = !DILocation(line: 657, column: 18, scope: !1419)
!1428 = !DILocation(line: 658, column: 20, scope: !1419)
!1429 = !DILocation(line: 658, column: 18, scope: !1419)
!1430 = !DILocation(line: 659, column: 20, scope: !1419)
!1431 = !DILocation(line: 661, column: 5, scope: !1432)
!1432 = !DILexicalBlockFile(scope: !1433, file: !3, discriminator: 1)
!1433 = distinct !DILexicalBlock(scope: !1383, file: !3, line: 661, column: 5)
!1434 = !DILocation(line: 662, column: 1, scope: !1383)
!1435 = distinct !DISubprogram(name: "usb_read_intre", scope: !3, file: !3, line: 663, type: !1384, isLocal: false, isDefinition: true, scopeLine: 667, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1436)
!1436 = !{!1437, !1438, !1439, !1440}
!1437 = !DILocalVariable(name: "id", arg: 1, scope: !1435, file: !3, line: 663, type: !201)
!1438 = !DILocalVariable(name: "intr_usbe", arg: 2, scope: !1435, file: !3, line: 664, type: !1386)
!1439 = !DILocalVariable(name: "intr_txe", arg: 3, scope: !1435, file: !3, line: 665, type: !1386)
!1440 = !DILocalVariable(name: "intr_rxe", arg: 4, scope: !1435, file: !3, line: 666, type: !1386)
!1441 = !DILocation(line: 663, column: 35, scope: !1435)
!1442 = !DILocation(line: 664, column: 32, scope: !1435)
!1443 = !DILocation(line: 665, column: 32, scope: !1435)
!1444 = !DILocation(line: 666, column: 32, scope: !1435)
!1445 = !DILocation(line: 668, column: 5, scope: !1446)
!1446 = !DILexicalBlockFile(scope: !1447, file: !3, discriminator: 1)
!1447 = distinct !DILexicalBlock(scope: !1435, file: !3, line: 668, column: 5)
!1448 = !DILocation(line: 669, column: 12, scope: !1449)
!1449 = distinct !DILexicalBlock(scope: !1435, file: !3, line: 669, column: 9)
!1450 = !DILocation(line: 669, column: 9, scope: !1435)
!1451 = !DILocation(line: 670, column: 22, scope: !1452)
!1452 = distinct !DILexicalBlock(scope: !1449, file: !3, line: 669, column: 18)
!1453 = !DILocation(line: 670, column: 20, scope: !1452)
!1454 = !DILocation(line: 671, column: 21, scope: !1452)
!1455 = !DILocation(line: 671, column: 56, scope: !1456)
!1456 = !DILexicalBlockFile(scope: !1452, file: !3, discriminator: 1)
!1457 = !DILocation(line: 671, column: 89, scope: !1452)
!1458 = !DILocation(line: 671, column: 54, scope: !1452)
!1459 = !DILocation(line: 671, column: 19, scope: !1452)
!1460 = !DILocation(line: 672, column: 21, scope: !1452)
!1461 = !DILocation(line: 672, column: 56, scope: !1462)
!1462 = !DILexicalBlockFile(scope: !1452, file: !3, discriminator: 2)
!1463 = !DILocation(line: 672, column: 89, scope: !1452)
!1464 = !DILocation(line: 672, column: 54, scope: !1452)
!1465 = !DILocation(line: 673, column: 5, scope: !1452)
!1466 = !DILocation(line: 674, column: 22, scope: !1467)
!1467 = distinct !DILexicalBlock(scope: !1449, file: !3, line: 673, column: 12)
!1468 = !DILocation(line: 674, column: 20, scope: !1467)
!1469 = !DILocation(line: 675, column: 21, scope: !1467)
!1470 = !DILocation(line: 675, column: 19, scope: !1467)
!1471 = !DILocation(line: 676, column: 21, scope: !1467)
!1472 = !DILocation(line: 672, column: 19, scope: !1456)
!1473 = !DILocation(line: 678, column: 5, scope: !1474)
!1474 = !DILexicalBlockFile(scope: !1475, file: !3, discriminator: 1)
!1475 = distinct !DILexicalBlock(scope: !1435, file: !3, line: 678, column: 5)
!1476 = !DILocation(line: 679, column: 1, scope: !1435)
!1477 = distinct !DISubprogram(name: "usb_write_intr_usbe", scope: !3, file: !3, line: 680, type: !1288, isLocal: false, isDefinition: true, scopeLine: 681, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1478)
!1478 = !{!1479, !1480}
!1479 = !DILocalVariable(name: "id", arg: 1, scope: !1477, file: !3, line: 680, type: !201)
!1480 = !DILocalVariable(name: "intr_usbe", arg: 2, scope: !1477, file: !3, line: 680, type: !59)
!1481 = !DILocation(line: 680, column: 40, scope: !1477)
!1482 = !DILocation(line: 680, column: 48, scope: !1477)
!1483 = !DILocation(line: 682, column: 5, scope: !1484)
!1484 = !DILexicalBlockFile(scope: !1485, file: !3, discriminator: 1)
!1485 = distinct !DILexicalBlock(scope: !1477, file: !3, line: 682, column: 5)
!1486 = !DILocation(line: 683, column: 12, scope: !1487)
!1487 = distinct !DILexicalBlock(scope: !1477, file: !3, line: 683, column: 9)
!1488 = !DILocation(line: 683, column: 9, scope: !1477)
!1489 = !DILocation(line: 684, column: 9, scope: !1490)
!1490 = distinct !DILexicalBlock(scope: !1487, file: !3, line: 683, column: 18)
!1491 = !DILocation(line: 685, column: 5, scope: !1490)
!1492 = !DILocation(line: 686, column: 23, scope: !1493)
!1493 = distinct !DILexicalBlock(scope: !1487, file: !3, line: 685, column: 12)
!1494 = !DILocation(line: 686, column: 21, scope: !1493)
!1495 = !DILocation(line: 688, column: 5, scope: !1496)
!1496 = !DILexicalBlockFile(scope: !1497, file: !3, discriminator: 1)
!1497 = distinct !DILexicalBlock(scope: !1477, file: !3, line: 688, column: 5)
!1498 = !DILocation(line: 689, column: 1, scope: !1477)
!1499 = distinct !DISubprogram(name: "usb_set_intr_txe", scope: !3, file: !3, line: 690, type: !1288, isLocal: false, isDefinition: true, scopeLine: 691, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1500)
!1500 = !{!1501, !1502, !1503}
!1501 = !DILocalVariable(name: "id", arg: 1, scope: !1499, file: !3, line: 690, type: !201)
!1502 = !DILocalVariable(name: "ep", arg: 2, scope: !1499, file: !3, line: 690, type: !59)
!1503 = !DILocalVariable(name: "intr_txe", scope: !1499, file: !3, line: 693, type: !55)
!1504 = !DILocation(line: 690, column: 37, scope: !1499)
!1505 = !DILocation(line: 690, column: 45, scope: !1499)
!1506 = !DILocation(line: 692, column: 5, scope: !1507)
!1507 = !DILexicalBlockFile(scope: !1508, file: !3, discriminator: 1)
!1508 = distinct !DILexicalBlock(scope: !1499, file: !3, line: 692, column: 5)
!1509 = !DILocation(line: 693, column: 9, scope: !1499)
!1510 = !DILocation(line: 694, column: 12, scope: !1511)
!1511 = distinct !DILexicalBlock(scope: !1499, file: !3, line: 694, column: 9)
!1512 = !DILocation(line: 694, column: 9, scope: !1499)
!1513 = !DILocation(line: 695, column: 20, scope: !1514)
!1514 = distinct !DILexicalBlock(scope: !1511, file: !3, line: 694, column: 18)
!1515 = !DILocation(line: 695, column: 55, scope: !1516)
!1516 = !DILexicalBlockFile(scope: !1514, file: !3, discriminator: 1)
!1517 = !DILocation(line: 695, column: 88, scope: !1514)
!1518 = !DILocation(line: 696, column: 21, scope: !1514)
!1519 = !DILocation(line: 695, column: 53, scope: !1514)
!1520 = !DILocation(line: 696, column: 18, scope: !1514)
!1521 = !DILocation(line: 697, column: 52, scope: !1514)
!1522 = !DILocation(line: 697, column: 9, scope: !1514)
!1523 = !DILocation(line: 698, column: 52, scope: !1514)
!1524 = !DILocation(line: 698, column: 9, scope: !1514)
!1525 = !DILocation(line: 699, column: 5, scope: !1514)
!1526 = !DILocation(line: 700, column: 20, scope: !1527)
!1527 = distinct !DILexicalBlock(scope: !1511, file: !3, line: 699, column: 12)
!1528 = !DILocation(line: 701, column: 21, scope: !1527)
!1529 = !DILocation(line: 701, column: 18, scope: !1527)
!1530 = !DILocation(line: 702, column: 20, scope: !1527)
!1531 = !DILocation(line: 705, column: 5, scope: !1532)
!1532 = !DILexicalBlockFile(scope: !1533, file: !3, discriminator: 1)
!1533 = distinct !DILexicalBlock(scope: !1499, file: !3, line: 705, column: 5)
!1534 = !DILocation(line: 707, column: 1, scope: !1499)
!1535 = distinct !DISubprogram(name: "usb_clr_intr_txe", scope: !3, file: !3, line: 708, type: !1288, isLocal: false, isDefinition: true, scopeLine: 709, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1536)
!1536 = !{!1537, !1538, !1539}
!1537 = !DILocalVariable(name: "id", arg: 1, scope: !1535, file: !3, line: 708, type: !201)
!1538 = !DILocalVariable(name: "ep", arg: 2, scope: !1535, file: !3, line: 708, type: !59)
!1539 = !DILocalVariable(name: "intr_txe", scope: !1535, file: !3, line: 711, type: !55)
!1540 = !DILocation(line: 708, column: 37, scope: !1535)
!1541 = !DILocation(line: 708, column: 45, scope: !1535)
!1542 = !DILocation(line: 710, column: 5, scope: !1543)
!1543 = !DILexicalBlockFile(scope: !1544, file: !3, discriminator: 1)
!1544 = distinct !DILexicalBlock(scope: !1535, file: !3, line: 710, column: 5)
!1545 = !DILocation(line: 711, column: 9, scope: !1535)
!1546 = !DILocation(line: 712, column: 12, scope: !1547)
!1547 = distinct !DILexicalBlock(scope: !1535, file: !3, line: 712, column: 9)
!1548 = !DILocation(line: 712, column: 9, scope: !1535)
!1549 = !DILocation(line: 713, column: 20, scope: !1550)
!1550 = distinct !DILexicalBlock(scope: !1547, file: !3, line: 712, column: 18)
!1551 = !DILocation(line: 713, column: 55, scope: !1552)
!1552 = !DILexicalBlockFile(scope: !1550, file: !3, discriminator: 2)
!1553 = !DILocation(line: 714, column: 16, scope: !1554)
!1554 = distinct !DILexicalBlock(scope: !1550, file: !3, line: 714, column: 13)
!1555 = !DILocation(line: 714, column: 13, scope: !1550)
!1556 = !DILocation(line: 713, column: 88, scope: !1557)
!1557 = !DILexicalBlockFile(scope: !1550, file: !3, discriminator: 1)
!1558 = !DILocation(line: 713, column: 53, scope: !1557)
!1559 = !DILocation(line: 717, column: 26, scope: !1560)
!1560 = distinct !DILexicalBlock(scope: !1554, file: !3, line: 716, column: 16)
!1561 = !DILocation(line: 717, column: 22, scope: !1560)
!1562 = !DILocation(line: 719, column: 52, scope: !1550)
!1563 = !DILocation(line: 719, column: 9, scope: !1550)
!1564 = !DILocation(line: 720, column: 52, scope: !1550)
!1565 = !DILocation(line: 720, column: 9, scope: !1550)
!1566 = !DILocation(line: 722, column: 5, scope: !1550)
!1567 = !DILocation(line: 723, column: 20, scope: !1568)
!1568 = distinct !DILexicalBlock(scope: !1547, file: !3, line: 722, column: 12)
!1569 = !DILocation(line: 724, column: 16, scope: !1570)
!1570 = distinct !DILexicalBlock(scope: !1568, file: !3, line: 724, column: 13)
!1571 = !DILocation(line: 724, column: 13, scope: !1568)
!1572 = !DILocation(line: 727, column: 26, scope: !1573)
!1573 = distinct !DILexicalBlock(scope: !1570, file: !3, line: 726, column: 16)
!1574 = !DILocation(line: 727, column: 25, scope: !1573)
!1575 = !DILocation(line: 727, column: 22, scope: !1573)
!1576 = !DILocation(line: 729, column: 20, scope: !1568)
!1577 = !DILocation(line: 731, column: 5, scope: !1578)
!1578 = !DILexicalBlockFile(scope: !1579, file: !3, discriminator: 1)
!1579 = distinct !DILexicalBlock(scope: !1535, file: !3, line: 731, column: 5)
!1580 = !DILocation(line: 732, column: 1, scope: !1535)
!1581 = distinct !DISubprogram(name: "usb_set_intr_rxe", scope: !3, file: !3, line: 733, type: !1288, isLocal: false, isDefinition: true, scopeLine: 734, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1582)
!1582 = !{!1583, !1584, !1585}
!1583 = !DILocalVariable(name: "id", arg: 1, scope: !1581, file: !3, line: 733, type: !201)
!1584 = !DILocalVariable(name: "ep", arg: 2, scope: !1581, file: !3, line: 733, type: !59)
!1585 = !DILocalVariable(name: "intr_rxe", scope: !1581, file: !3, line: 736, type: !55)
!1586 = !DILocation(line: 733, column: 37, scope: !1581)
!1587 = !DILocation(line: 733, column: 45, scope: !1581)
!1588 = !DILocation(line: 735, column: 5, scope: !1589)
!1589 = !DILexicalBlockFile(scope: !1590, file: !3, discriminator: 1)
!1590 = distinct !DILexicalBlock(scope: !1581, file: !3, line: 735, column: 5)
!1591 = !DILocation(line: 737, column: 12, scope: !1592)
!1592 = distinct !DILexicalBlock(scope: !1581, file: !3, line: 737, column: 9)
!1593 = !DILocation(line: 737, column: 9, scope: !1581)
!1594 = !DILocation(line: 738, column: 20, scope: !1595)
!1595 = distinct !DILexicalBlock(scope: !1592, file: !3, line: 737, column: 18)
!1596 = !DILocation(line: 738, column: 55, scope: !1597)
!1597 = !DILexicalBlockFile(scope: !1595, file: !3, discriminator: 1)
!1598 = !DILocation(line: 738, column: 88, scope: !1595)
!1599 = !DILocation(line: 739, column: 21, scope: !1595)
!1600 = !DILocation(line: 738, column: 53, scope: !1595)
!1601 = !DILocation(line: 739, column: 18, scope: !1595)
!1602 = !DILocation(line: 740, column: 52, scope: !1595)
!1603 = !DILocation(line: 740, column: 9, scope: !1595)
!1604 = !DILocation(line: 741, column: 52, scope: !1595)
!1605 = !DILocation(line: 741, column: 9, scope: !1595)
!1606 = !DILocation(line: 742, column: 5, scope: !1595)
!1607 = !DILocation(line: 743, column: 20, scope: !1608)
!1608 = distinct !DILexicalBlock(scope: !1592, file: !3, line: 742, column: 12)
!1609 = !DILocation(line: 736, column: 9, scope: !1581)
!1610 = !DILocation(line: 744, column: 21, scope: !1608)
!1611 = !DILocation(line: 744, column: 18, scope: !1608)
!1612 = !DILocation(line: 745, column: 20, scope: !1608)
!1613 = !DILocation(line: 747, column: 5, scope: !1614)
!1614 = !DILexicalBlockFile(scope: !1615, file: !3, discriminator: 1)
!1615 = distinct !DILexicalBlock(scope: !1581, file: !3, line: 747, column: 5)
!1616 = !DILocation(line: 748, column: 1, scope: !1581)
!1617 = distinct !DISubprogram(name: "usb_clr_intr_rxe", scope: !3, file: !3, line: 749, type: !1288, isLocal: false, isDefinition: true, scopeLine: 750, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1618)
!1618 = !{!1619, !1620, !1621}
!1619 = !DILocalVariable(name: "id", arg: 1, scope: !1617, file: !3, line: 749, type: !201)
!1620 = !DILocalVariable(name: "ep", arg: 2, scope: !1617, file: !3, line: 749, type: !59)
!1621 = !DILocalVariable(name: "intr_rxe", scope: !1617, file: !3, line: 751, type: !55)
!1622 = !DILocation(line: 749, column: 37, scope: !1617)
!1623 = !DILocation(line: 749, column: 45, scope: !1617)
!1624 = !DILocation(line: 751, column: 9, scope: !1617)
!1625 = !DILocation(line: 752, column: 5, scope: !1626)
!1626 = !DILexicalBlockFile(scope: !1627, file: !3, discriminator: 1)
!1627 = distinct !DILexicalBlock(scope: !1617, file: !3, line: 752, column: 5)
!1628 = !DILocation(line: 753, column: 12, scope: !1629)
!1629 = distinct !DILexicalBlock(scope: !1617, file: !3, line: 753, column: 9)
!1630 = !DILocation(line: 753, column: 9, scope: !1617)
!1631 = !DILocation(line: 754, column: 20, scope: !1632)
!1632 = distinct !DILexicalBlock(scope: !1629, file: !3, line: 753, column: 18)
!1633 = !DILocation(line: 754, column: 55, scope: !1634)
!1634 = !DILexicalBlockFile(scope: !1632, file: !3, discriminator: 2)
!1635 = !DILocation(line: 755, column: 16, scope: !1636)
!1636 = distinct !DILexicalBlock(scope: !1632, file: !3, line: 755, column: 13)
!1637 = !DILocation(line: 755, column: 13, scope: !1632)
!1638 = !DILocation(line: 754, column: 88, scope: !1639)
!1639 = !DILexicalBlockFile(scope: !1632, file: !3, discriminator: 1)
!1640 = !DILocation(line: 754, column: 53, scope: !1639)
!1641 = !DILocation(line: 758, column: 26, scope: !1642)
!1642 = distinct !DILexicalBlock(scope: !1636, file: !3, line: 757, column: 16)
!1643 = !DILocation(line: 758, column: 22, scope: !1642)
!1644 = !DILocation(line: 760, column: 52, scope: !1632)
!1645 = !DILocation(line: 760, column: 9, scope: !1632)
!1646 = !DILocation(line: 761, column: 52, scope: !1632)
!1647 = !DILocation(line: 761, column: 9, scope: !1632)
!1648 = !DILocation(line: 762, column: 5, scope: !1632)
!1649 = !DILocation(line: 763, column: 20, scope: !1650)
!1650 = distinct !DILexicalBlock(scope: !1629, file: !3, line: 762, column: 12)
!1651 = !DILocation(line: 764, column: 16, scope: !1652)
!1652 = distinct !DILexicalBlock(scope: !1650, file: !3, line: 764, column: 13)
!1653 = !DILocation(line: 764, column: 13, scope: !1650)
!1654 = !DILocation(line: 767, column: 26, scope: !1655)
!1655 = distinct !DILexicalBlock(scope: !1652, file: !3, line: 766, column: 16)
!1656 = !DILocation(line: 767, column: 25, scope: !1655)
!1657 = !DILocation(line: 767, column: 22, scope: !1655)
!1658 = !DILocation(line: 769, column: 20, scope: !1650)
!1659 = !DILocation(line: 771, column: 5, scope: !1660)
!1660 = !DILexicalBlockFile(scope: !1661, file: !3, discriminator: 1)
!1661 = distinct !DILexicalBlock(scope: !1617, file: !3, line: 771, column: 5)
!1662 = !DILocation(line: 772, column: 1, scope: !1617)
!1663 = distinct !DISubprogram(name: "usb_write_txcsr", scope: !3, file: !3, line: 807, type: !275, isLocal: false, isDefinition: true, scopeLine: 808, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1664)
!1664 = !{!1665, !1666, !1667, !1668}
!1665 = !DILocalVariable(name: "id", arg: 1, scope: !1663, file: !3, line: 807, type: !201)
!1666 = !DILocalVariable(name: "ep", arg: 2, scope: !1663, file: !3, line: 807, type: !59)
!1667 = !DILocalVariable(name: "txcsr", arg: 3, scope: !1663, file: !3, line: 807, type: !59)
!1668 = !DILocalVariable(name: "ep_reg", scope: !1669, file: !3, line: 816, type: !66)
!1669 = distinct !DILexicalBlock(scope: !1670, file: !3, line: 815, column: 12)
!1670 = distinct !DILexicalBlock(scope: !1663, file: !3, line: 809, column: 9)
!1671 = !DILocation(line: 807, column: 36, scope: !1663)
!1672 = !DILocation(line: 807, column: 44, scope: !1663)
!1673 = !DILocation(line: 807, column: 52, scope: !1663)
!1674 = !DILocation(line: 809, column: 12, scope: !1670)
!1675 = !DILocation(line: 809, column: 9, scope: !1663)
!1676 = !DILocation(line: 810, column: 9, scope: !1677)
!1677 = !DILexicalBlockFile(scope: !1678, file: !3, discriminator: 1)
!1678 = distinct !DILexicalBlock(scope: !1679, file: !3, line: 810, column: 9)
!1679 = distinct !DILexicalBlock(scope: !1670, file: !3, line: 809, column: 18)
!1680 = !DILocation(line: 811, column: 9, scope: !1679)
!1681 = !DILocation(line: 812, column: 47, scope: !1679)
!1682 = !DILocation(line: 812, column: 9, scope: !1679)
!1683 = !DILocation(line: 813, column: 47, scope: !1679)
!1684 = !DILocation(line: 813, column: 9, scope: !1679)
!1685 = !DILocation(line: 814, column: 9, scope: !1686)
!1686 = !DILexicalBlockFile(scope: !1687, file: !3, discriminator: 1)
!1687 = distinct !DILexicalBlock(scope: !1679, file: !3, line: 814, column: 9)
!1688 = !DILocation(line: 815, column: 5, scope: !1679)
!1689 = !DILocation(line: 816, column: 31, scope: !1669)
!1690 = !DILocation(line: 817, column: 23, scope: !1669)
!1691 = !DILocation(line: 818, column: 25, scope: !1669)
!1692 = !DILocation(line: 818, column: 17, scope: !1669)
!1693 = !DILocation(line: 818, column: 23, scope: !1669)
!1694 = !DILocation(line: 819, column: 9, scope: !1669)
!1695 = !{i32 22621}
!1696 = !DILocation(line: 820, column: 9, scope: !1669)
!1697 = !{i32 22643}
!1698 = !DILocation(line: 822, column: 1, scope: !1663)
!1699 = distinct !DISubprogram(name: "usb_write_rxcsr", scope: !3, file: !3, line: 840, type: !275, isLocal: false, isDefinition: true, scopeLine: 841, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1700)
!1700 = !{!1701, !1702, !1703, !1704}
!1701 = !DILocalVariable(name: "id", arg: 1, scope: !1699, file: !3, line: 840, type: !201)
!1702 = !DILocalVariable(name: "ep", arg: 2, scope: !1699, file: !3, line: 840, type: !59)
!1703 = !DILocalVariable(name: "rxcsr", arg: 3, scope: !1699, file: !3, line: 840, type: !59)
!1704 = !DILocalVariable(name: "ep_reg", scope: !1705, file: !3, line: 849, type: !66)
!1705 = distinct !DILexicalBlock(scope: !1706, file: !3, line: 848, column: 12)
!1706 = distinct !DILexicalBlock(scope: !1699, file: !3, line: 842, column: 9)
!1707 = !DILocation(line: 840, column: 36, scope: !1699)
!1708 = !DILocation(line: 840, column: 44, scope: !1699)
!1709 = !DILocation(line: 840, column: 52, scope: !1699)
!1710 = !DILocation(line: 842, column: 12, scope: !1706)
!1711 = !DILocation(line: 842, column: 9, scope: !1699)
!1712 = !DILocation(line: 843, column: 9, scope: !1713)
!1713 = !DILexicalBlockFile(scope: !1714, file: !3, discriminator: 1)
!1714 = distinct !DILexicalBlock(scope: !1715, file: !3, line: 843, column: 9)
!1715 = distinct !DILexicalBlock(scope: !1706, file: !3, line: 842, column: 18)
!1716 = !DILocation(line: 844, column: 9, scope: !1715)
!1717 = !DILocation(line: 845, column: 47, scope: !1715)
!1718 = !DILocation(line: 845, column: 9, scope: !1715)
!1719 = !DILocation(line: 846, column: 47, scope: !1715)
!1720 = !DILocation(line: 846, column: 9, scope: !1715)
!1721 = !DILocation(line: 847, column: 9, scope: !1722)
!1722 = !DILexicalBlockFile(scope: !1723, file: !3, discriminator: 1)
!1723 = distinct !DILexicalBlock(scope: !1715, file: !3, line: 847, column: 9)
!1724 = !DILocation(line: 848, column: 5, scope: !1715)
!1725 = !DILocation(line: 849, column: 31, scope: !1705)
!1726 = !DILocation(line: 850, column: 23, scope: !1705)
!1727 = !DILocation(line: 851, column: 25, scope: !1705)
!1728 = !DILocation(line: 851, column: 17, scope: !1705)
!1729 = !DILocation(line: 851, column: 23, scope: !1705)
!1730 = !{!591, !592, i64 6}
!1731 = !DILocation(line: 852, column: 9, scope: !1705)
!1732 = !{i32 23553}
!1733 = !DILocation(line: 853, column: 9, scope: !1705)
!1734 = !{i32 23575}
!1735 = !DILocation(line: 855, column: 1, scope: !1699)
!1736 = distinct !DISubprogram(name: "usb_read_rxcsr", scope: !3, file: !3, line: 856, type: !199, isLocal: false, isDefinition: true, scopeLine: 857, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1737)
!1737 = !{!1738, !1739, !1740, !1743}
!1738 = !DILocalVariable(name: "id", arg: 1, scope: !1736, file: !3, line: 856, type: !201)
!1739 = !DILocalVariable(name: "ep", arg: 2, scope: !1736, file: !3, line: 856, type: !59)
!1740 = !DILocalVariable(name: "rxcsr", scope: !1741, file: !3, line: 861, type: !59)
!1741 = distinct !DILexicalBlock(scope: !1742, file: !3, line: 858, column: 18)
!1742 = distinct !DILexicalBlock(scope: !1736, file: !3, line: 858, column: 9)
!1743 = !DILocalVariable(name: "ep_reg", scope: !1744, file: !3, line: 865, type: !66)
!1744 = distinct !DILexicalBlock(scope: !1742, file: !3, line: 864, column: 12)
!1745 = !DILocation(line: 856, column: 34, scope: !1736)
!1746 = !DILocation(line: 856, column: 42, scope: !1736)
!1747 = !DILocation(line: 858, column: 12, scope: !1742)
!1748 = !DILocation(line: 858, column: 9, scope: !1736)
!1749 = !DILocation(line: 859, column: 9, scope: !1750)
!1750 = !DILexicalBlockFile(scope: !1751, file: !3, discriminator: 1)
!1751 = distinct !DILexicalBlock(scope: !1741, file: !3, line: 859, column: 9)
!1752 = !DILocation(line: 860, column: 9, scope: !1741)
!1753 = !DILocation(line: 861, column: 21, scope: !1741)
!1754 = !DILocation(line: 861, column: 55, scope: !1755)
!1755 = !DILexicalBlockFile(scope: !1741, file: !3, discriminator: 1)
!1756 = !DILocation(line: 861, column: 86, scope: !1741)
!1757 = !DILocation(line: 861, column: 52, scope: !1741)
!1758 = !DILocation(line: 861, column: 13, scope: !1741)
!1759 = !DILocation(line: 862, column: 9, scope: !1760)
!1760 = !DILexicalBlockFile(scope: !1761, file: !3, discriminator: 1)
!1761 = distinct !DILexicalBlock(scope: !1741, file: !3, line: 862, column: 9)
!1762 = !DILocation(line: 865, column: 31, scope: !1744)
!1763 = !DILocation(line: 866, column: 23, scope: !1744)
!1764 = !DILocation(line: 867, column: 9, scope: !1744)
!1765 = !{i32 23995}
!1766 = !DILocation(line: 868, column: 24, scope: !1744)
!1767 = !DILocation(line: 868, column: 16, scope: !1744)
!1768 = !DILocation(line: 871, column: 1, scope: !1736)
!1769 = distinct !DISubprogram(name: "usb_write_rxmaxp", scope: !3, file: !3, line: 872, type: !275, isLocal: false, isDefinition: true, scopeLine: 873, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1770)
!1770 = !{!1771, !1772, !1773, !1774}
!1771 = !DILocalVariable(name: "id", arg: 1, scope: !1769, file: !3, line: 872, type: !201)
!1772 = !DILocalVariable(name: "ep", arg: 2, scope: !1769, file: !3, line: 872, type: !59)
!1773 = !DILocalVariable(name: "value", arg: 3, scope: !1769, file: !3, line: 872, type: !59)
!1774 = !DILocalVariable(name: "ep_reg", scope: !1775, file: !3, line: 880, type: !66)
!1775 = distinct !DILexicalBlock(scope: !1776, file: !3, line: 879, column: 12)
!1776 = distinct !DILexicalBlock(scope: !1769, file: !3, line: 874, column: 9)
!1777 = !DILocation(line: 872, column: 37, scope: !1769)
!1778 = !DILocation(line: 872, column: 45, scope: !1769)
!1779 = !DILocation(line: 872, column: 53, scope: !1769)
!1780 = !DILocation(line: 874, column: 12, scope: !1776)
!1781 = !DILocation(line: 874, column: 9, scope: !1769)
!1782 = !DILocation(line: 875, column: 9, scope: !1783)
!1783 = !DILexicalBlockFile(scope: !1784, file: !3, discriminator: 1)
!1784 = distinct !DILexicalBlock(scope: !1785, file: !3, line: 875, column: 9)
!1785 = distinct !DILexicalBlock(scope: !1776, file: !3, line: 874, column: 18)
!1786 = !DILocation(line: 876, column: 9, scope: !1785)
!1787 = !DILocation(line: 877, column: 9, scope: !1785)
!1788 = !DILocation(line: 878, column: 9, scope: !1789)
!1789 = !DILexicalBlockFile(scope: !1790, file: !3, discriminator: 1)
!1790 = distinct !DILexicalBlock(scope: !1785, file: !3, line: 878, column: 9)
!1791 = !DILocation(line: 879, column: 5, scope: !1785)
!1792 = !DILocation(line: 880, column: 31, scope: !1775)
!1793 = !DILocation(line: 881, column: 23, scope: !1775)
!1794 = !DILocation(line: 882, column: 26, scope: !1775)
!1795 = !DILocation(line: 882, column: 17, scope: !1775)
!1796 = !DILocation(line: 882, column: 24, scope: !1775)
!1797 = !{!591, !592, i64 4}
!1798 = !DILocation(line: 883, column: 9, scope: !1775)
!1799 = !{i32 24427}
!1800 = !DILocation(line: 884, column: 9, scope: !1775)
!1801 = !{i32 24449}
!1802 = !DILocation(line: 886, column: 1, scope: !1769)
!1803 = distinct !DISubprogram(name: "usb_write_txmaxp", scope: !3, file: !3, line: 887, type: !275, isLocal: false, isDefinition: true, scopeLine: 888, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1804)
!1804 = !{!1805, !1806, !1807, !1808}
!1805 = !DILocalVariable(name: "id", arg: 1, scope: !1803, file: !3, line: 887, type: !201)
!1806 = !DILocalVariable(name: "ep", arg: 2, scope: !1803, file: !3, line: 887, type: !59)
!1807 = !DILocalVariable(name: "value", arg: 3, scope: !1803, file: !3, line: 887, type: !59)
!1808 = !DILocalVariable(name: "ep_reg", scope: !1809, file: !3, line: 895, type: !66)
!1809 = distinct !DILexicalBlock(scope: !1810, file: !3, line: 894, column: 12)
!1810 = distinct !DILexicalBlock(scope: !1803, file: !3, line: 889, column: 9)
!1811 = !DILocation(line: 887, column: 37, scope: !1803)
!1812 = !DILocation(line: 887, column: 45, scope: !1803)
!1813 = !DILocation(line: 887, column: 53, scope: !1803)
!1814 = !DILocation(line: 889, column: 12, scope: !1810)
!1815 = !DILocation(line: 889, column: 9, scope: !1803)
!1816 = !DILocation(line: 890, column: 9, scope: !1817)
!1817 = !DILexicalBlockFile(scope: !1818, file: !3, discriminator: 1)
!1818 = distinct !DILexicalBlock(scope: !1819, file: !3, line: 890, column: 9)
!1819 = distinct !DILexicalBlock(scope: !1810, file: !3, line: 889, column: 18)
!1820 = !DILocation(line: 891, column: 9, scope: !1819)
!1821 = !DILocation(line: 892, column: 9, scope: !1819)
!1822 = !DILocation(line: 893, column: 9, scope: !1823)
!1823 = !DILexicalBlockFile(scope: !1824, file: !3, discriminator: 1)
!1824 = distinct !DILexicalBlock(scope: !1819, file: !3, line: 893, column: 9)
!1825 = !DILocation(line: 894, column: 5, scope: !1819)
!1826 = !DILocation(line: 895, column: 31, scope: !1809)
!1827 = !DILocation(line: 896, column: 23, scope: !1809)
!1828 = !DILocation(line: 897, column: 26, scope: !1809)
!1829 = !DILocation(line: 897, column: 17, scope: !1809)
!1830 = !DILocation(line: 897, column: 24, scope: !1809)
!1831 = !{!591, !592, i64 0}
!1832 = !DILocation(line: 898, column: 9, scope: !1809)
!1833 = !{i32 24849}
!1834 = !DILocation(line: 899, column: 9, scope: !1809)
!1835 = !{i32 24871}
!1836 = !DILocation(line: 901, column: 1, scope: !1803)
!1837 = distinct !DISubprogram(name: "usb_write_txtype", scope: !3, file: !3, line: 902, type: !1838, isLocal: false, isDefinition: true, scopeLine: 903, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1841)
!1838 = !DISubroutineType(types: !1839)
!1839 = !{null, !202, !1840, !59}
!1840 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !59)
!1841 = !{!1842, !1843, !1844, !1845}
!1842 = !DILocalVariable(name: "id", arg: 1, scope: !1837, file: !3, line: 902, type: !202)
!1843 = !DILocalVariable(name: "ep", arg: 2, scope: !1837, file: !3, line: 902, type: !1840)
!1844 = !DILocalVariable(name: "value", arg: 3, scope: !1837, file: !3, line: 902, type: !59)
!1845 = !DILocalVariable(name: "ep_reg", scope: !1846, file: !3, line: 910, type: !66)
!1846 = distinct !DILexicalBlock(scope: !1847, file: !3, line: 909, column: 12)
!1847 = distinct !DILexicalBlock(scope: !1837, file: !3, line: 904, column: 9)
!1848 = !DILocation(line: 902, column: 31, scope: !1837)
!1849 = !DILocation(line: 902, column: 45, scope: !1837)
!1850 = !DILocation(line: 902, column: 53, scope: !1837)
!1851 = !DILocation(line: 904, column: 12, scope: !1847)
!1852 = !DILocation(line: 904, column: 9, scope: !1837)
!1853 = !DILocation(line: 905, column: 9, scope: !1854)
!1854 = !DILexicalBlockFile(scope: !1855, file: !3, discriminator: 1)
!1855 = distinct !DILexicalBlock(scope: !1856, file: !3, line: 905, column: 9)
!1856 = distinct !DILexicalBlock(scope: !1847, file: !3, line: 904, column: 18)
!1857 = !DILocation(line: 906, column: 9, scope: !1856)
!1858 = !DILocation(line: 907, column: 9, scope: !1856)
!1859 = !DILocation(line: 908, column: 9, scope: !1860)
!1860 = !DILexicalBlockFile(scope: !1861, file: !3, discriminator: 1)
!1861 = distinct !DILexicalBlock(scope: !1856, file: !3, line: 908, column: 9)
!1862 = !DILocation(line: 909, column: 5, scope: !1856)
!1863 = !DILocation(line: 910, column: 31, scope: !1846)
!1864 = !DILocation(line: 911, column: 23, scope: !1846)
!1865 = !DILocation(line: 912, column: 26, scope: !1846)
!1866 = !DILocation(line: 912, column: 17, scope: !1846)
!1867 = !DILocation(line: 912, column: 24, scope: !1846)
!1868 = !{!591, !195, i64 10}
!1869 = !DILocation(line: 913, column: 9, scope: !1846)
!1870 = !{i32 25271}
!1871 = !DILocation(line: 915, column: 1, scope: !1837)
!1872 = distinct !DISubprogram(name: "usb_write_rxtype", scope: !3, file: !3, line: 916, type: !1873, isLocal: false, isDefinition: true, scopeLine: 917, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1875)
!1873 = !DISubroutineType(types: !1874)
!1874 = !{null, !201, !1840, !59}
!1875 = !{!1876, !1877, !1878, !1879}
!1876 = !DILocalVariable(name: "id", arg: 1, scope: !1872, file: !3, line: 916, type: !201)
!1877 = !DILocalVariable(name: "ep", arg: 2, scope: !1872, file: !3, line: 916, type: !1840)
!1878 = !DILocalVariable(name: "value", arg: 3, scope: !1872, file: !3, line: 916, type: !59)
!1879 = !DILocalVariable(name: "ep_reg", scope: !1880, file: !3, line: 924, type: !66)
!1880 = distinct !DILexicalBlock(scope: !1881, file: !3, line: 923, column: 12)
!1881 = distinct !DILexicalBlock(scope: !1872, file: !3, line: 918, column: 9)
!1882 = !DILocation(line: 916, column: 37, scope: !1872)
!1883 = !DILocation(line: 916, column: 51, scope: !1872)
!1884 = !DILocation(line: 916, column: 59, scope: !1872)
!1885 = !DILocation(line: 918, column: 12, scope: !1881)
!1886 = !DILocation(line: 918, column: 9, scope: !1872)
!1887 = !DILocation(line: 919, column: 9, scope: !1888)
!1888 = !DILexicalBlockFile(scope: !1889, file: !3, discriminator: 1)
!1889 = distinct !DILexicalBlock(scope: !1890, file: !3, line: 919, column: 9)
!1890 = distinct !DILexicalBlock(scope: !1881, file: !3, line: 918, column: 18)
!1891 = !DILocation(line: 920, column: 9, scope: !1890)
!1892 = !DILocation(line: 921, column: 9, scope: !1890)
!1893 = !DILocation(line: 922, column: 9, scope: !1894)
!1894 = !DILexicalBlockFile(scope: !1895, file: !3, discriminator: 1)
!1895 = distinct !DILexicalBlock(scope: !1890, file: !3, line: 922, column: 9)
!1896 = !DILocation(line: 923, column: 5, scope: !1890)
!1897 = !DILocation(line: 924, column: 31, scope: !1880)
!1898 = !DILocation(line: 925, column: 23, scope: !1880)
!1899 = !DILocation(line: 926, column: 26, scope: !1880)
!1900 = !DILocation(line: 926, column: 17, scope: !1880)
!1901 = !DILocation(line: 926, column: 24, scope: !1880)
!1902 = !{!591, !195, i64 12}
!1903 = !DILocation(line: 927, column: 9, scope: !1880)
!1904 = !{i32 25677}
!1905 = !DILocation(line: 929, column: 1, scope: !1872)
!1906 = distinct !DISubprogram(name: "usb_write_txinterval", scope: !3, file: !3, line: 930, type: !1873, isLocal: false, isDefinition: true, scopeLine: 931, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1907)
!1907 = !{!1908, !1909, !1910, !1911}
!1908 = !DILocalVariable(name: "id", arg: 1, scope: !1906, file: !3, line: 930, type: !201)
!1909 = !DILocalVariable(name: "ep", arg: 2, scope: !1906, file: !3, line: 930, type: !1840)
!1910 = !DILocalVariable(name: "value", arg: 3, scope: !1906, file: !3, line: 930, type: !59)
!1911 = !DILocalVariable(name: "ep_reg", scope: !1912, file: !3, line: 939, type: !66)
!1912 = distinct !DILexicalBlock(scope: !1913, file: !3, line: 938, column: 12)
!1913 = distinct !DILexicalBlock(scope: !1906, file: !3, line: 932, column: 9)
!1914 = !DILocation(line: 930, column: 41, scope: !1906)
!1915 = !DILocation(line: 930, column: 55, scope: !1906)
!1916 = !DILocation(line: 930, column: 63, scope: !1906)
!1917 = !DILocation(line: 932, column: 12, scope: !1913)
!1918 = !DILocation(line: 932, column: 9, scope: !1906)
!1919 = !DILocation(line: 933, column: 9, scope: !1920)
!1920 = !DILexicalBlockFile(scope: !1921, file: !3, discriminator: 1)
!1921 = distinct !DILexicalBlock(scope: !1922, file: !3, line: 933, column: 9)
!1922 = distinct !DILexicalBlock(scope: !1913, file: !3, line: 932, column: 18)
!1923 = !DILocation(line: 934, column: 9, scope: !1922)
!1924 = !DILocation(line: 935, column: 9, scope: !1922)
!1925 = !DILocation(line: 936, column: 9, scope: !1926)
!1926 = !DILexicalBlockFile(scope: !1927, file: !3, discriminator: 1)
!1927 = distinct !DILexicalBlock(scope: !1922, file: !3, line: 936, column: 9)
!1928 = !DILocation(line: 938, column: 5, scope: !1922)
!1929 = !DILocation(line: 939, column: 31, scope: !1912)
!1930 = !DILocation(line: 940, column: 23, scope: !1912)
!1931 = !DILocation(line: 941, column: 30, scope: !1912)
!1932 = !DILocation(line: 941, column: 17, scope: !1912)
!1933 = !DILocation(line: 941, column: 28, scope: !1912)
!1934 = !{!591, !195, i64 11}
!1935 = !DILocation(line: 942, column: 9, scope: !1912)
!1936 = !{i32 26106}
!1937 = !DILocation(line: 944, column: 1, scope: !1906)
!1938 = distinct !DISubprogram(name: "usb_write_rxinterval", scope: !3, file: !3, line: 945, type: !1873, isLocal: false, isDefinition: true, scopeLine: 946, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1939)
!1939 = !{!1940, !1941, !1942, !1943}
!1940 = !DILocalVariable(name: "id", arg: 1, scope: !1938, file: !3, line: 945, type: !201)
!1941 = !DILocalVariable(name: "ep", arg: 2, scope: !1938, file: !3, line: 945, type: !1840)
!1942 = !DILocalVariable(name: "value", arg: 3, scope: !1938, file: !3, line: 945, type: !59)
!1943 = !DILocalVariable(name: "ep_reg", scope: !1944, file: !3, line: 953, type: !66)
!1944 = distinct !DILexicalBlock(scope: !1945, file: !3, line: 952, column: 12)
!1945 = distinct !DILexicalBlock(scope: !1938, file: !3, line: 947, column: 9)
!1946 = !DILocation(line: 945, column: 41, scope: !1938)
!1947 = !DILocation(line: 945, column: 55, scope: !1938)
!1948 = !DILocation(line: 945, column: 63, scope: !1938)
!1949 = !DILocation(line: 947, column: 12, scope: !1945)
!1950 = !DILocation(line: 947, column: 9, scope: !1938)
!1951 = !DILocation(line: 948, column: 9, scope: !1952)
!1952 = !DILexicalBlockFile(scope: !1953, file: !3, discriminator: 1)
!1953 = distinct !DILexicalBlock(scope: !1954, file: !3, line: 948, column: 9)
!1954 = distinct !DILexicalBlock(scope: !1945, file: !3, line: 947, column: 18)
!1955 = !DILocation(line: 949, column: 9, scope: !1954)
!1956 = !DILocation(line: 950, column: 9, scope: !1954)
!1957 = !DILocation(line: 951, column: 9, scope: !1958)
!1958 = !DILexicalBlockFile(scope: !1959, file: !3, discriminator: 1)
!1959 = distinct !DILexicalBlock(scope: !1954, file: !3, line: 951, column: 9)
!1960 = !DILocation(line: 952, column: 5, scope: !1954)
!1961 = !DILocation(line: 953, column: 31, scope: !1944)
!1962 = !DILocation(line: 954, column: 23, scope: !1944)
!1963 = !DILocation(line: 955, column: 30, scope: !1944)
!1964 = !DILocation(line: 955, column: 17, scope: !1944)
!1965 = !DILocation(line: 955, column: 28, scope: !1944)
!1966 = !{!591, !195, i64 13}
!1967 = !DILocation(line: 956, column: 9, scope: !1944)
!1968 = !{i32 26534}
!1969 = !DILocation(line: 958, column: 1, scope: !1938)
!1970 = distinct !DISubprogram(name: "usb_read_rxcount", scope: !3, file: !3, line: 960, type: !199, isLocal: false, isDefinition: true, scopeLine: 961, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1971)
!1971 = !{!1972, !1973, !1974, !1977, !1979}
!1972 = !DILocalVariable(name: "id", arg: 1, scope: !1970, file: !3, line: 960, type: !201)
!1973 = !DILocalVariable(name: "ep", arg: 2, scope: !1970, file: !3, line: 960, type: !59)
!1974 = !DILocalVariable(name: "rxcount", scope: !1975, file: !3, line: 964, type: !59)
!1975 = distinct !DILexicalBlock(scope: !1976, file: !3, line: 962, column: 18)
!1976 = distinct !DILexicalBlock(scope: !1970, file: !3, line: 962, column: 9)
!1977 = !DILocalVariable(name: "rxcount", scope: !1978, file: !3, line: 973, type: !59)
!1978 = distinct !DILexicalBlock(scope: !1976, file: !3, line: 972, column: 12)
!1979 = !DILocalVariable(name: "ep_reg", scope: !1978, file: !3, line: 974, type: !66)
!1980 = !DILocation(line: 960, column: 36, scope: !1970)
!1981 = !DILocation(line: 960, column: 44, scope: !1970)
!1982 = !DILocation(line: 962, column: 12, scope: !1976)
!1983 = !DILocation(line: 962, column: 9, scope: !1970)
!1984 = !DILocation(line: 963, column: 9, scope: !1985)
!1985 = !DILexicalBlockFile(scope: !1986, file: !3, discriminator: 1)
!1986 = distinct !DILexicalBlock(scope: !1975, file: !3, line: 963, column: 9)
!1987 = !DILocation(line: 964, column: 13, scope: !1975)
!1988 = !DILocation(line: 965, column: 9, scope: !1975)
!1989 = !DILocation(line: 966, column: 13, scope: !1990)
!1990 = distinct !DILexicalBlock(scope: !1975, file: !3, line: 966, column: 13)
!1991 = !DILocation(line: 966, column: 44, scope: !1990)
!1992 = !DILocation(line: 966, column: 13, scope: !1975)
!1993 = !DILocation(line: 967, column: 23, scope: !1994)
!1994 = distinct !DILexicalBlock(scope: !1990, file: !3, line: 966, column: 63)
!1995 = !DILocation(line: 967, column: 59, scope: !1996)
!1996 = !DILexicalBlockFile(scope: !1994, file: !3, discriminator: 1)
!1997 = !DILocation(line: 967, column: 92, scope: !1994)
!1998 = !DILocation(line: 967, column: 56, scope: !1994)
!1999 = !DILocation(line: 968, column: 9, scope: !1994)
!2000 = !DILocation(line: 969, column: 9, scope: !2001)
!2001 = !DILexicalBlockFile(scope: !2002, file: !3, discriminator: 1)
!2002 = distinct !DILexicalBlock(scope: !1975, file: !3, line: 969, column: 9)
!2003 = !DILocation(line: 973, column: 13, scope: !1978)
!2004 = !DILocation(line: 974, column: 31, scope: !1978)
!2005 = !DILocation(line: 975, column: 23, scope: !1978)
!2006 = !DILocation(line: 976, column: 9, scope: !1978)
!2007 = !{i32 27090}
!2008 = !DILocation(line: 977, column: 21, scope: !2009)
!2009 = distinct !DILexicalBlock(scope: !1978, file: !3, line: 977, column: 13)
!2010 = !DILocation(line: 977, column: 27, scope: !2009)
!2011 = !DILocation(line: 977, column: 13, scope: !1978)
!2012 = !DILocation(line: 978, column: 31, scope: !2013)
!2013 = distinct !DILexicalBlock(scope: !2009, file: !3, line: 977, column: 46)
!2014 = !{!591, !592, i64 8}
!2015 = !DILocation(line: 978, column: 23, scope: !2013)
!2016 = !DILocation(line: 979, column: 9, scope: !2013)
!2017 = !DILocation(line: 982, column: 1, scope: !1970)
!2018 = distinct !DISubprogram(name: "usb_write_txfuncaddr", scope: !3, file: !3, line: 983, type: !2019, isLocal: false, isDefinition: true, scopeLine: 984, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2021)
!2019 = !DISubroutineType(types: !2020)
!2020 = !{null, !201, !1840, !1840}
!2021 = !{!2022, !2023, !2024, !2025}
!2022 = !DILocalVariable(name: "id", arg: 1, scope: !2018, file: !3, line: 983, type: !201)
!2023 = !DILocalVariable(name: "ep", arg: 2, scope: !2018, file: !3, line: 983, type: !1840)
!2024 = !DILocalVariable(name: "devnum", arg: 3, scope: !2018, file: !3, line: 983, type: !1840)
!2025 = !DILocalVariable(name: "ep_reg", scope: !2026, file: !3, line: 986, type: !80)
!2026 = distinct !DILexicalBlock(scope: !2027, file: !3, line: 985, column: 18)
!2027 = distinct !DILexicalBlock(scope: !2018, file: !3, line: 985, column: 9)
!2028 = !DILocation(line: 983, column: 41, scope: !2018)
!2029 = !DILocation(line: 983, column: 55, scope: !2018)
!2030 = !DILocation(line: 983, column: 69, scope: !2018)
!2031 = !DILocation(line: 985, column: 12, scope: !2027)
!2032 = !DILocation(line: 985, column: 9, scope: !2018)
!2033 = !DILocation(line: 986, column: 33, scope: !2026)
!2034 = !DILocation(line: 989, column: 30, scope: !2026)
!2035 = !DILocation(line: 989, column: 17, scope: !2026)
!2036 = !DILocation(line: 989, column: 28, scope: !2026)
!2037 = !{!2038, !195, i64 0}
!2038 = !{!"husb_func_reg_t", !195, i64 0, !195, i64 1, !195, i64 2, !195, i64 3, !195, i64 4, !195, i64 5, !195, i64 6, !195, i64 7}
!2039 = !DILocation(line: 990, column: 9, scope: !2026)
!2040 = !{i32 27484}
!2041 = !DILocation(line: 992, column: 5, scope: !2026)
!2042 = !DILocation(line: 993, column: 1, scope: !2018)
!2043 = distinct !DISubprogram(name: "usb_write_rxfuncaddr", scope: !3, file: !3, line: 994, type: !2019, isLocal: false, isDefinition: true, scopeLine: 995, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2044)
!2044 = !{!2045, !2046, !2047, !2048}
!2045 = !DILocalVariable(name: "id", arg: 1, scope: !2043, file: !3, line: 994, type: !201)
!2046 = !DILocalVariable(name: "ep", arg: 2, scope: !2043, file: !3, line: 994, type: !1840)
!2047 = !DILocalVariable(name: "devnum", arg: 3, scope: !2043, file: !3, line: 994, type: !1840)
!2048 = !DILocalVariable(name: "ep_reg", scope: !2049, file: !3, line: 997, type: !80)
!2049 = distinct !DILexicalBlock(scope: !2050, file: !3, line: 996, column: 18)
!2050 = distinct !DILexicalBlock(scope: !2043, file: !3, line: 996, column: 9)
!2051 = !DILocation(line: 994, column: 41, scope: !2043)
!2052 = !DILocation(line: 994, column: 55, scope: !2043)
!2053 = !DILocation(line: 994, column: 69, scope: !2043)
!2054 = !DILocation(line: 996, column: 12, scope: !2050)
!2055 = !DILocation(line: 996, column: 9, scope: !2043)
!2056 = !DILocation(line: 997, column: 33, scope: !2049)
!2057 = !DILocation(line: 1000, column: 30, scope: !2049)
!2058 = !DILocation(line: 1000, column: 17, scope: !2049)
!2059 = !DILocation(line: 1000, column: 28, scope: !2049)
!2060 = !{!2038, !195, i64 4}
!2061 = !DILocation(line: 1001, column: 9, scope: !2049)
!2062 = !{i32 27759}
!2063 = !DILocation(line: 1003, column: 5, scope: !2049)
!2064 = !DILocation(line: 1004, column: 1, scope: !2043)
!2065 = distinct !DISubprogram(name: "usb_write_fifosize", scope: !3, file: !3, line: 1005, type: !1873, isLocal: false, isDefinition: true, scopeLine: 1006, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2066)
!2066 = !{!2067, !2068, !2069, !2070}
!2067 = !DILocalVariable(name: "id", arg: 1, scope: !2065, file: !3, line: 1005, type: !201)
!2068 = !DILocalVariable(name: "ep", arg: 2, scope: !2065, file: !3, line: 1005, type: !1840)
!2069 = !DILocalVariable(name: "fifosize", arg: 3, scope: !2065, file: !3, line: 1005, type: !59)
!2070 = !DILocalVariable(name: "ep_reg", scope: !2071, file: !3, line: 1008, type: !66)
!2071 = distinct !DILexicalBlock(scope: !2072, file: !3, line: 1007, column: 18)
!2072 = distinct !DILexicalBlock(scope: !2065, file: !3, line: 1007, column: 9)
!2073 = !DILocation(line: 1005, column: 39, scope: !2065)
!2074 = !DILocation(line: 1005, column: 53, scope: !2065)
!2075 = !DILocation(line: 1005, column: 61, scope: !2065)
!2076 = !DILocation(line: 1007, column: 12, scope: !2072)
!2077 = !DILocation(line: 1007, column: 9, scope: !2065)
!2078 = !DILocation(line: 1008, column: 31, scope: !2071)
!2079 = !DILocation(line: 1009, column: 22, scope: !2071)
!2080 = !DILocation(line: 1010, column: 28, scope: !2071)
!2081 = !DILocation(line: 1010, column: 17, scope: !2071)
!2082 = !DILocation(line: 1010, column: 26, scope: !2071)
!2083 = !{!591, !195, i64 15}
!2084 = !DILocation(line: 1011, column: 5, scope: !2071)
!2085 = !DILocation(line: 1012, column: 1, scope: !2065)
!2086 = distinct !DISubprogram(name: "usb_g_ep_read64byte_fast", scope: !3, file: !3, line: 1013, type: !2087, isLocal: false, isDefinition: true, scopeLine: 1014, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2089)
!2087 = !DISubroutineType(types: !2088)
!2088 = !{!59, !201, !1840, !51, !59}
!2089 = !{!2090, !2091, !2092, !2093, !2094, !2095, !2096, !2097, !2098, !2099}
!2090 = !DILocalVariable(name: "id", arg: 1, scope: !2086, file: !3, line: 1013, type: !201)
!2091 = !DILocalVariable(name: "ep", arg: 2, scope: !2086, file: !3, line: 1013, type: !1840)
!2092 = !DILocalVariable(name: "ptr", arg: 3, scope: !2086, file: !3, line: 1013, type: !51)
!2093 = !DILocalVariable(name: "len", arg: 4, scope: !2086, file: !3, line: 1013, type: !59)
!2094 = !DILocalVariable(name: "_len", scope: !2086, file: !3, line: 1015, type: !59)
!2095 = !DILocalVariable(name: "st", scope: !2086, file: !3, line: 1016, type: !59)
!2096 = !DILocalVariable(name: "rx_addr", scope: !2086, file: !3, line: 1017, type: !51)
!2097 = !DILocalVariable(name: "rx_len", scope: !2086, file: !3, line: 1018, type: !59)
!2098 = !DILocalVariable(name: "rxcsr", scope: !2086, file: !3, line: 1019, type: !59)
!2099 = !DILocalVariable(name: "ot", scope: !2086, file: !3, line: 1020, type: !59)
!2100 = !DILocation(line: 1013, column: 44, scope: !2086)
!2101 = !DILocation(line: 1013, column: 58, scope: !2086)
!2102 = !DILocation(line: 1013, column: 66, scope: !2086)
!2103 = !DILocation(line: 1013, column: 75, scope: !2086)
!2104 = !DILocation(line: 1015, column: 9, scope: !2086)
!2105 = !DILocation(line: 1016, column: 9, scope: !2086)
!2106 = !DILocation(line: 1018, column: 9, scope: !2086)
!2107 = !DILocation(line: 1019, column: 9, scope: !2086)
!2108 = !DILocation(line: 94, column: 12, scope: !189, inlinedAt: !2109)
!2109 = distinct !DILocation(line: 1020, column: 14, scope: !2086)
!2110 = !DILocation(line: 1020, column: 39, scope: !2086)
!2111 = !DILocation(line: 1020, column: 9, scope: !2086)
!2112 = !DILocation(line: 1020, column: 32, scope: !2086)
!2113 = !DILocation(line: 1021, column: 8, scope: !2086)
!2114 = !DILocation(line: 1022, column: 5, scope: !2086)
!2115 = !DILocation(line: 1022, column: 5, scope: !2116)
!2116 = !DILexicalBlockFile(scope: !2086, file: !3, discriminator: 1)
!2117 = !DILocation(line: 94, column: 12, scope: !2118, inlinedAt: !2119)
!2118 = !DILexicalBlockFile(scope: !189, file: !3, discriminator: 1)
!2119 = distinct !DILocation(line: 1023, column: 13, scope: !2120)
!2120 = distinct !DILexicalBlock(scope: !2121, file: !3, line: 1023, column: 13)
!2121 = distinct !DILexicalBlock(scope: !2086, file: !3, line: 1022, column: 17)
!2122 = !DILocation(line: 1023, column: 13, scope: !2120)
!2123 = !DILocation(line: 1023, column: 13, scope: !2121)
!2124 = !DILocation(line: 1024, column: 13, scope: !2125)
!2125 = distinct !DILexicalBlock(scope: !2126, file: !3, line: 1024, column: 13)
!2126 = distinct !DILexicalBlock(scope: !2120, file: !3, line: 1023, column: 48)
!2127 = !DILocation(line: 1025, column: 13, scope: !2126)
!2128 = !DILocation(line: 1027, column: 9, scope: !2129)
!2129 = !DILexicalBlockFile(scope: !2130, file: !3, discriminator: 1)
!2130 = distinct !DILexicalBlock(scope: !2121, file: !3, line: 1027, column: 9)
!2131 = !DILocation(line: 1028, column: 9, scope: !2121)
!2132 = !DILocation(line: 1029, column: 17, scope: !2121)
!2133 = !DILocation(line: 1030, column: 19, scope: !2134)
!2134 = distinct !DILexicalBlock(scope: !2121, file: !3, line: 1030, column: 13)
!2135 = !DILocation(line: 1030, column: 13, scope: !2121)
!2136 = !DILocation(line: 1037, column: 19, scope: !2121)
!2137 = !DILocation(line: 1017, column: 9, scope: !2086)
!2138 = !DILocation(line: 1048, column: 68, scope: !2121)
!2139 = !DILocation(line: 1048, column: 9, scope: !2121)
!2140 = !DILocation(line: 1049, column: 9, scope: !2141)
!2141 = !DILexicalBlockFile(scope: !2142, file: !3, discriminator: 1)
!2142 = distinct !DILexicalBlock(scope: !2121, file: !3, line: 1049, column: 9)
!2143 = !DILocation(line: 1050, column: 13, scope: !2144)
!2144 = distinct !DILexicalBlock(scope: !2121, file: !3, line: 1050, column: 13)
!2145 = !DILocation(line: 1050, column: 13, scope: !2121)
!2146 = !DILocation(line: 1033, column: 13, scope: !2147)
!2147 = !DILexicalBlockFile(scope: !2148, file: !3, discriminator: 1)
!2148 = distinct !DILexicalBlock(scope: !2149, file: !3, line: 1033, column: 13)
!2149 = distinct !DILexicalBlock(scope: !2134, file: !3, line: 1032, column: 16)
!2150 = !DILocation(line: 1034, column: 13, scope: !2149)
!2151 = distinct !{!2151, !2114, !2152}
!2152 = !DILocation(line: 1057, column: 5, scope: !2086)
!2153 = !DILocation(line: 1051, column: 13, scope: !2154)
!2154 = distinct !DILexicalBlock(scope: !2144, file: !3, line: 1050, column: 18)
!2155 = !{i32 29105}
!2156 = !DILocation(line: 1052, column: 13, scope: !2154)
!2157 = !DILocation(line: 1053, column: 17, scope: !2154)
!2158 = !DILocation(line: 1054, column: 9, scope: !2154)
!2159 = !DILocation(line: 1055, column: 13, scope: !2121)
!2160 = !DILocation(line: 1056, column: 14, scope: !2121)
!2161 = !DILocation(line: 1022, column: 5, scope: !2162)
!2162 = !DILexicalBlockFile(scope: !2086, file: !3, discriminator: 2)
!2163 = !DILocation(line: 1060, column: 1, scope: !2086)
!2164 = !DILocation(line: 1060, column: 1, scope: !2116)
!2165 = distinct !DISubprogram(name: "usb_g_ep_read", scope: !3, file: !3, line: 1061, type: !2166, isLocal: false, isDefinition: true, scopeLine: 1062, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2168)
!2166 = !DISubroutineType(types: !2167)
!2167 = !{!59, !201, !59, !51, !59, !59}
!2168 = !{!2169, !2170, !2171, !2172, !2173, !2174, !2175, !2176, !2177, !2178, !2179, !2180, !2181, !2183, !2188}
!2169 = !DILocalVariable(name: "id", arg: 1, scope: !2165, file: !3, line: 1061, type: !201)
!2170 = !DILocalVariable(name: "ep", arg: 2, scope: !2165, file: !3, line: 1061, type: !59)
!2171 = !DILocalVariable(name: "ptr", arg: 3, scope: !2165, file: !3, line: 1061, type: !51)
!2172 = !DILocalVariable(name: "len", arg: 4, scope: !2165, file: !3, line: 1061, type: !59)
!2173 = !DILocalVariable(name: "block", arg: 5, scope: !2165, file: !3, line: 1061, type: !59)
!2174 = !DILocalVariable(name: "_len", scope: !2165, file: !3, line: 1063, type: !59)
!2175 = !DILocalVariable(name: "st", scope: !2165, file: !3, line: 1064, type: !59)
!2176 = !DILocalVariable(name: "rx_addr", scope: !2165, file: !3, line: 1066, type: !51)
!2177 = !DILocalVariable(name: "toogle", scope: !2165, file: !3, line: 1067, type: !59)
!2178 = !DILocalVariable(name: "is_dual_buf", scope: !2165, file: !3, line: 1068, type: !52)
!2179 = !DILocalVariable(name: "ot", scope: !2165, file: !3, line: 1069, type: !59)
!2180 = !DILocalVariable(name: "pkt_size", scope: !2165, file: !3, line: 1070, type: !59)
!2181 = !DILocalVariable(name: "rx_len", scope: !2182, file: !3, line: 1091, type: !59)
!2182 = distinct !DILexicalBlock(scope: !2165, file: !3, line: 1085, column: 17)
!2183 = !DILocalVariable(name: "rxcsr", scope: !2184, file: !3, line: 1094, type: !59)
!2184 = distinct !DILexicalBlock(scope: !2185, file: !3, line: 1093, column: 25)
!2185 = distinct !DILexicalBlock(scope: !2186, file: !3, line: 1093, column: 17)
!2186 = distinct !DILexicalBlock(scope: !2187, file: !3, line: 1092, column: 26)
!2187 = distinct !DILexicalBlock(scope: !2182, file: !3, line: 1092, column: 13)
!2188 = !DILocalVariable(name: "rxcsr", scope: !2182, file: !3, line: 1106, type: !59)
!2189 = !DILocation(line: 1061, column: 33, scope: !2165)
!2190 = !DILocation(line: 1061, column: 41, scope: !2165)
!2191 = !DILocation(line: 1061, column: 49, scope: !2165)
!2192 = !DILocation(line: 1061, column: 58, scope: !2165)
!2193 = !DILocation(line: 1061, column: 67, scope: !2165)
!2194 = !DILocation(line: 1063, column: 9, scope: !2165)
!2195 = !DILocation(line: 1064, column: 9, scope: !2165)
!2196 = !DILocation(line: 1067, column: 9, scope: !2165)
!2197 = !DILocation(line: 1068, column: 8, scope: !2165)
!2198 = !DILocation(line: 1069, column: 9, scope: !2165)
!2199 = !DILocation(line: 1070, column: 9, scope: !2165)
!2200 = !DILocation(line: 1071, column: 9, scope: !2201)
!2201 = distinct !DILexicalBlock(scope: !2165, file: !3, line: 1071, column: 9)
!2202 = !DILocation(line: 1071, column: 9, scope: !2165)
!2203 = !DILocation(line: 94, column: 12, scope: !189, inlinedAt: !2204)
!2204 = distinct !DILocation(line: 1076, column: 14, scope: !2205)
!2205 = distinct !DILexicalBlock(scope: !2201, file: !3, line: 1075, column: 12)
!2206 = !DILocation(line: 1076, column: 32, scope: !2205)
!2207 = !DILocation(line: 1078, column: 9, scope: !2165)
!2208 = !DILocation(line: 1072, column: 49, scope: !2209)
!2209 = distinct !DILexicalBlock(scope: !2201, file: !3, line: 1071, column: 26)
!2210 = !DILocation(line: 1072, column: 20, scope: !2209)
!2211 = !DILocation(line: 94, column: 12, scope: !2118, inlinedAt: !2212)
!2212 = distinct !DILocation(line: 1073, column: 14, scope: !2209)
!2213 = !DILocation(line: 1073, column: 38, scope: !2209)
!2214 = !DILocation(line: 1073, column: 49, scope: !2209)
!2215 = !DILocation(line: 1073, column: 32, scope: !2209)
!2216 = !DILocation(line: 1074, column: 12, scope: !2209)
!2217 = !DILocation(line: 1079, column: 47, scope: !2218)
!2218 = distinct !DILexicalBlock(scope: !2219, file: !3, line: 1079, column: 13)
!2219 = distinct !DILexicalBlock(scope: !2220, file: !3, line: 1078, column: 26)
!2220 = distinct !DILexicalBlock(scope: !2165, file: !3, line: 1078, column: 9)
!2221 = !DILocation(line: 1079, column: 13, scope: !2218)
!2222 = !DILocation(line: 1085, column: 5, scope: !2223)
!2223 = !DILexicalBlockFile(scope: !2165, file: !3, discriminator: 1)
!2224 = !DILocation(line: 1061, column: 49, scope: !2223)
!2225 = !DILocation(line: 94, column: 12, scope: !2226, inlinedAt: !2227)
!2226 = !DILexicalBlockFile(scope: !189, file: !3, discriminator: 2)
!2227 = distinct !DILocation(line: 1086, column: 13, scope: !2228)
!2228 = distinct !DILexicalBlock(scope: !2182, file: !3, line: 1086, column: 13)
!2229 = !DILocation(line: 1086, column: 13, scope: !2228)
!2230 = !DILocation(line: 1086, column: 13, scope: !2182)
!2231 = !DILocation(line: 1087, column: 13, scope: !2232)
!2232 = distinct !DILexicalBlock(scope: !2233, file: !3, line: 1087, column: 13)
!2233 = distinct !DILexicalBlock(scope: !2228, file: !3, line: 1086, column: 48)
!2234 = !DILocation(line: 1088, column: 13, scope: !2233)
!2235 = !DILocation(line: 1091, column: 22, scope: !2182)
!2236 = !DILocation(line: 1091, column: 13, scope: !2182)
!2237 = !DILocation(line: 1092, column: 20, scope: !2187)
!2238 = !DILocation(line: 1092, column: 13, scope: !2182)
!2239 = !DILocation(line: 1093, column: 17, scope: !2186)
!2240 = distinct !{!2240, !2241, !2242}
!2241 = !DILocation(line: 1085, column: 5, scope: !2165)
!2242 = !DILocation(line: 1136, column: 5, scope: !2165)
!2243 = !DILocation(line: 1094, column: 29, scope: !2184)
!2244 = !DILocation(line: 1094, column: 21, scope: !2184)
!2245 = !DILocation(line: 1095, column: 27, scope: !2246)
!2246 = distinct !DILexicalBlock(scope: !2184, file: !3, line: 1095, column: 21)
!2247 = !DILocation(line: 1095, column: 21, scope: !2184)
!2248 = !DILocation(line: 1096, column: 62, scope: !2249)
!2249 = distinct !DILexicalBlock(scope: !2246, file: !3, line: 1095, column: 49)
!2250 = !DILocation(line: 1096, column: 21, scope: !2249)
!2251 = !DILocation(line: 1097, column: 17, scope: !2249)
!2252 = !DILocation(line: 1103, column: 20, scope: !2253)
!2253 = distinct !DILexicalBlock(scope: !2182, file: !3, line: 1103, column: 13)
!2254 = !DILocation(line: 1103, column: 13, scope: !2182)
!2255 = !DILocation(line: 1106, column: 21, scope: !2182)
!2256 = !DILocation(line: 1106, column: 13, scope: !2182)
!2257 = !DILocation(line: 1107, column: 19, scope: !2182)
!2258 = !DILocation(line: 1066, column: 9, scope: !2165)
!2259 = !DILocation(line: 1118, column: 19, scope: !2260)
!2260 = distinct !DILexicalBlock(scope: !2261, file: !3, line: 1117, column: 38)
!2261 = distinct !DILexicalBlock(scope: !2182, file: !3, line: 1117, column: 13)
!2262 = !DILocation(line: 1123, column: 13, scope: !2182)
!2263 = !DILocation(line: 1124, column: 54, scope: !2264)
!2264 = distinct !DILexicalBlock(scope: !2265, file: !3, line: 1123, column: 26)
!2265 = distinct !DILexicalBlock(scope: !2182, file: !3, line: 1123, column: 13)
!2266 = !DILocation(line: 1124, column: 13, scope: !2264)
!2267 = !DILocation(line: 1125, column: 9, scope: !2264)
!2268 = !DILocation(line: 1126, column: 13, scope: !2269)
!2269 = distinct !DILexicalBlock(scope: !2182, file: !3, line: 1126, column: 13)
!2270 = !DILocation(line: 1126, column: 13, scope: !2182)
!2271 = !DILocation(line: 1127, column: 13, scope: !2272)
!2272 = distinct !DILexicalBlock(scope: !2269, file: !3, line: 1126, column: 18)
!2273 = !{i32 31156}
!2274 = !DILocation(line: 1128, column: 13, scope: !2272)
!2275 = !DILocation(line: 1129, column: 17, scope: !2272)
!2276 = !DILocation(line: 1130, column: 9, scope: !2272)
!2277 = !DILocation(line: 1131, column: 13, scope: !2182)
!2278 = !DILocation(line: 1132, column: 54, scope: !2279)
!2279 = distinct !DILexicalBlock(scope: !2280, file: !3, line: 1131, column: 27)
!2280 = distinct !DILexicalBlock(scope: !2182, file: !3, line: 1131, column: 13)
!2281 = !DILocation(line: 1132, column: 13, scope: !2279)
!2282 = !DILocation(line: 1133, column: 9, scope: !2279)
!2283 = !DILocation(line: 1134, column: 13, scope: !2182)
!2284 = !DILocation(line: 1135, column: 14, scope: !2182)
!2285 = !DILocation(line: 1139, column: 1, scope: !2165)
!2286 = !DILocation(line: 1139, column: 1, scope: !2223)
!2287 = distinct !DISubprogram(name: "usb_g_tx_flushfifo", scope: !3, file: !3, line: 1141, type: !275, isLocal: false, isDefinition: true, scopeLine: 1142, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2288)
!2288 = !{!2289, !2290, !2291, !2292}
!2289 = !DILocalVariable(name: "id", arg: 1, scope: !2287, file: !3, line: 1141, type: !201)
!2290 = !DILocalVariable(name: "ep", arg: 2, scope: !2287, file: !3, line: 1141, type: !59)
!2291 = !DILocalVariable(name: "size", arg: 3, scope: !2287, file: !3, line: 1141, type: !59)
!2292 = !DILocalVariable(name: "txcsr", scope: !2287, file: !3, line: 1144, type: !59)
!2293 = !DILocation(line: 1141, column: 39, scope: !2287)
!2294 = !DILocation(line: 1141, column: 47, scope: !2287)
!2295 = !DILocation(line: 1141, column: 55, scope: !2287)
!2296 = !DILocation(line: 1143, column: 5, scope: !2287)
!2297 = !DILocation(line: 1144, column: 17, scope: !2287)
!2298 = !DILocation(line: 1144, column: 9, scope: !2287)
!2299 = !DILocation(line: 1145, column: 11, scope: !2287)
!2300 = !DILocation(line: 1146, column: 5, scope: !2287)
!2301 = !DILocation(line: 1147, column: 1, scope: !2287)
!2302 = distinct !DISubprogram(name: "usb_g_ep_write", scope: !3, file: !3, line: 1148, type: !2303, isLocal: false, isDefinition: true, scopeLine: 1149, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2305)
!2303 = !DISubroutineType(types: !2304)
!2304 = !{!59, !201, !59, !660, !59}
!2305 = !{!2306, !2307, !2308, !2309, !2310, !2311, !2312, !2313, !2314, !2315, !2316, !2317}
!2306 = !DILocalVariable(name: "id", arg: 1, scope: !2302, file: !3, line: 1148, type: !201)
!2307 = !DILocalVariable(name: "ep", arg: 2, scope: !2302, file: !3, line: 1148, type: !59)
!2308 = !DILocalVariable(name: "ptr", arg: 3, scope: !2302, file: !3, line: 1148, type: !660)
!2309 = !DILocalVariable(name: "len", arg: 4, scope: !2302, file: !3, line: 1148, type: !59)
!2310 = !DILocalVariable(name: "tx_addr", scope: !2302, file: !3, line: 1150, type: !51)
!2311 = !DILocalVariable(name: "txcsr", scope: !2302, file: !3, line: 1151, type: !59)
!2312 = !DILocalVariable(name: "_len", scope: !2302, file: !3, line: 1152, type: !59)
!2313 = !DILocalVariable(name: "ot", scope: !2302, file: !3, line: 1153, type: !59)
!2314 = !DILocalVariable(name: "pkt_size", scope: !2302, file: !3, line: 1154, type: !59)
!2315 = !DILocalVariable(name: "st", scope: !2302, file: !3, line: 1155, type: !59)
!2316 = !DILocalVariable(name: "dma_size", scope: !2302, file: !3, line: 1156, type: !1840)
!2317 = !DILocalVariable(name: "pkt_size", scope: !2318, file: !3, line: 1201, type: !59)
!2318 = distinct !DILexicalBlock(scope: !2302, file: !3, line: 1164, column: 8)
!2319 = !DILocation(line: 1148, column: 34, scope: !2302)
!2320 = !DILocation(line: 1148, column: 42, scope: !2302)
!2321 = !DILocation(line: 1148, column: 56, scope: !2302)
!2322 = !DILocation(line: 1148, column: 65, scope: !2302)
!2323 = !DILocation(line: 1150, column: 19, scope: !2302)
!2324 = !DILocation(line: 1150, column: 9, scope: !2302)
!2325 = !DILocation(line: 1152, column: 9, scope: !2302)
!2326 = !DILocation(line: 1153, column: 9, scope: !2302)
!2327 = !DILocation(line: 1154, column: 9, scope: !2302)
!2328 = !DILocation(line: 1155, column: 9, scope: !2302)
!2329 = !DILocation(line: 1156, column: 26, scope: !2302)
!2330 = !DILocation(line: 1156, column: 15, scope: !2302)
!2331 = !DILocation(line: 1157, column: 9, scope: !2332)
!2332 = distinct !DILexicalBlock(scope: !2302, file: !3, line: 1157, column: 9)
!2333 = !DILocation(line: 1157, column: 9, scope: !2302)
!2334 = !DILocation(line: 1158, column: 49, scope: !2335)
!2335 = distinct !DILexicalBlock(scope: !2332, file: !3, line: 1157, column: 26)
!2336 = !DILocation(line: 1158, column: 20, scope: !2335)
!2337 = !DILocation(line: 94, column: 12, scope: !189, inlinedAt: !2338)
!2338 = distinct !DILocation(line: 1159, column: 14, scope: !2335)
!2339 = !DILocation(line: 1159, column: 38, scope: !2335)
!2340 = !DILocation(line: 1159, column: 49, scope: !2335)
!2341 = !DILocation(line: 1159, column: 32, scope: !2335)
!2342 = !DILocation(line: 1160, column: 12, scope: !2335)
!2343 = !DILocation(line: 1161, column: 5, scope: !2335)
!2344 = distinct !{!2344, !2345, !2346}
!2345 = !DILocation(line: 1164, column: 5, scope: !2302)
!2346 = !DILocation(line: 1210, column: 17, scope: !2302)
!2347 = !DILocation(line: 94, column: 12, scope: !2118, inlinedAt: !2348)
!2348 = distinct !DILocation(line: 1162, column: 14, scope: !2349)
!2349 = distinct !DILexicalBlock(scope: !2332, file: !3, line: 1161, column: 12)
!2350 = !DILocation(line: 1162, column: 32, scope: !2349)
!2351 = !DILocation(line: 1165, column: 9, scope: !2318)
!2352 = !DILocation(line: 94, column: 12, scope: !2226, inlinedAt: !2353)
!2353 = distinct !DILocation(line: 1166, column: 17, scope: !2354)
!2354 = distinct !DILexicalBlock(scope: !2355, file: !3, line: 1166, column: 17)
!2355 = distinct !DILexicalBlock(scope: !2318, file: !3, line: 1165, column: 19)
!2356 = !DILocation(line: 1166, column: 17, scope: !2354)
!2357 = !DILocation(line: 1166, column: 17, scope: !2355)
!2358 = !DILocation(line: 1167, column: 17, scope: !2359)
!2359 = distinct !DILexicalBlock(scope: !2360, file: !3, line: 1167, column: 17)
!2360 = distinct !DILexicalBlock(scope: !2354, file: !3, line: 1166, column: 52)
!2361 = !DILocation(line: 1168, column: 17, scope: !2360)
!2362 = !DILocation(line: 1170, column: 21, scope: !2355)
!2363 = !DILocation(line: 1151, column: 9, scope: !2302)
!2364 = !DILocation(line: 1172, column: 24, scope: !2365)
!2365 = distinct !DILexicalBlock(scope: !2355, file: !3, line: 1172, column: 17)
!2366 = !DILocation(line: 1172, column: 43, scope: !2365)
!2367 = !DILocation(line: 1172, column: 17, scope: !2355)
!2368 = !DILocation(line: 1184, column: 27, scope: !2369)
!2369 = distinct !DILexicalBlock(scope: !2370, file: !3, line: 1184, column: 21)
!2370 = distinct !DILexicalBlock(scope: !2371, file: !3, line: 1183, column: 46)
!2371 = distinct !DILexicalBlock(scope: !2355, file: !3, line: 1183, column: 17)
!2372 = !DILocation(line: 1183, column: 17, scope: !2355)
!2373 = !DILocation(line: 1189, column: 23, scope: !2374)
!2374 = distinct !DILexicalBlock(scope: !2355, file: !3, line: 1189, column: 17)
!2375 = !DILocation(line: 1189, column: 17, scope: !2355)
!2376 = !DILocation(line: 94, column: 12, scope: !2377, inlinedAt: !2353)
!2377 = !DILexicalBlockFile(scope: !189, file: !3, discriminator: 3)
!2378 = distinct !{!2378, !2351, !2379}
!2379 = !DILocation(line: 1199, column: 9, scope: !2318)
!2380 = !DILocation(line: 1190, column: 17, scope: !2381)
!2381 = distinct !DILexicalBlock(scope: !2374, file: !3, line: 1189, column: 42)
!2382 = !DILocation(line: 1191, column: 23, scope: !2381)
!2383 = !DILocation(line: 1192, column: 17, scope: !2381)
!2384 = !DILocation(line: 1193, column: 21, scope: !2381)
!2385 = !DILocation(line: 1194, column: 27, scope: !2386)
!2386 = distinct !DILexicalBlock(scope: !2387, file: !3, line: 1193, column: 49)
!2387 = distinct !DILexicalBlock(scope: !2381, file: !3, line: 1193, column: 21)
!2388 = !DILocation(line: 1195, column: 21, scope: !2386)
!2389 = !DILocation(line: 1196, column: 21, scope: !2386)
!2390 = !DILocation(line: 1201, column: 24, scope: !2318)
!2391 = !DILocation(line: 1201, column: 13, scope: !2318)
!2392 = !DILocation(line: 1202, column: 13, scope: !2393)
!2393 = distinct !DILexicalBlock(scope: !2318, file: !3, line: 1202, column: 13)
!2394 = !DILocation(line: 1202, column: 13, scope: !2318)
!2395 = !DILocation(line: 1203, column: 13, scope: !2396)
!2396 = distinct !DILexicalBlock(scope: !2393, file: !3, line: 1202, column: 18)
!2397 = !DILocation(line: 1204, column: 13, scope: !2396)
!2398 = !{i32 33255}
!2399 = !DILocation(line: 1205, column: 17, scope: !2396)
!2400 = !DILocation(line: 1206, column: 9, scope: !2396)
!2401 = !DILocation(line: 1207, column: 9, scope: !2318)
!2402 = !DILocation(line: 1208, column: 9, scope: !2318)
!2403 = !DILocation(line: 1209, column: 13, scope: !2318)
!2404 = !DILocation(line: 1210, column: 5, scope: !2405)
!2405 = !DILexicalBlockFile(scope: !2318, file: !3, discriminator: 1)
!2406 = !DILocation(line: 1213, column: 1, scope: !2302)
!2407 = !DILocation(line: 1213, column: 1, scope: !2408)
!2408 = !DILexicalBlockFile(scope: !2302, file: !3, discriminator: 1)
!2409 = !DILocation(line: 1213, column: 1, scope: !2410)
!2410 = !DILexicalBlockFile(scope: !2302, file: !3, discriminator: 2)
!2411 = distinct !DISubprogram(name: "usb_g_ep_config", scope: !3, file: !3, line: 1215, type: !2412, isLocal: false, isDefinition: true, scopeLine: 1216, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2414)
!2412 = !DISubroutineType(types: !2413)
!2413 = !{!59, !201, !59, !59, !59, !51, !59}
!2414 = !{!2415, !2416, !2417, !2418, !2419, !2420, !2421, !2428}
!2415 = !DILocalVariable(name: "id", arg: 1, scope: !2411, file: !3, line: 1215, type: !201)
!2416 = !DILocalVariable(name: "ep", arg: 2, scope: !2411, file: !3, line: 1215, type: !59)
!2417 = !DILocalVariable(name: "type", arg: 3, scope: !2411, file: !3, line: 1215, type: !59)
!2418 = !DILocalVariable(name: "ie", arg: 4, scope: !2411, file: !3, line: 1215, type: !59)
!2419 = !DILocalVariable(name: "ptr", arg: 5, scope: !2411, file: !3, line: 1215, type: !51)
!2420 = !DILocalVariable(name: "dma_size", arg: 6, scope: !2411, file: !3, line: 1215, type: !59)
!2421 = !DILocalVariable(name: "maxpsize", scope: !2422, file: !3, line: 1227, type: !59)
!2422 = distinct !DILexicalBlock(scope: !2423, file: !3, line: 1226, column: 50)
!2423 = distinct !DILexicalBlock(scope: !2424, file: !3, line: 1226, column: 17)
!2424 = distinct !DILexicalBlock(scope: !2425, file: !3, line: 1223, column: 45)
!2425 = distinct !DILexicalBlock(scope: !2426, file: !3, line: 1223, column: 13)
!2426 = distinct !DILexicalBlock(scope: !2427, file: !3, line: 1217, column: 26)
!2427 = distinct !DILexicalBlock(scope: !2411, file: !3, line: 1217, column: 9)
!2428 = !DILocalVariable(name: "maxpsize", scope: !2429, file: !3, line: 1254, type: !59)
!2429 = distinct !DILexicalBlock(scope: !2430, file: !3, line: 1253, column: 50)
!2430 = distinct !DILexicalBlock(scope: !2431, file: !3, line: 1253, column: 17)
!2431 = distinct !DILexicalBlock(scope: !2432, file: !3, line: 1249, column: 52)
!2432 = distinct !DILexicalBlock(scope: !2433, file: !3, line: 1249, column: 20)
!2433 = distinct !DILexicalBlock(scope: !2434, file: !3, line: 1247, column: 13)
!2434 = distinct !DILexicalBlock(scope: !2427, file: !3, line: 1242, column: 12)
!2435 = !DILocation(line: 1215, column: 35, scope: !2411)
!2436 = !DILocation(line: 1215, column: 43, scope: !2411)
!2437 = !DILocation(line: 1215, column: 51, scope: !2411)
!2438 = !DILocation(line: 1215, column: 61, scope: !2411)
!2439 = !DILocation(line: 1215, column: 69, scope: !2411)
!2440 = !DILocation(line: 1215, column: 78, scope: !2411)
!2441 = !DILocation(line: 1217, column: 12, scope: !2427)
!2442 = !DILocation(line: 1217, column: 9, scope: !2411)
!2443 = !DILocation(line: 1218, column: 12, scope: !2426)
!2444 = !DILocation(line: 1219, column: 9, scope: !2426)
!2445 = !DILocation(line: 1220, column: 9, scope: !2426)
!2446 = !DILocation(line: 1221, column: 9, scope: !2426)
!2447 = !DILocation(line: 1222, column: 9, scope: !2426)
!2448 = !DILocation(line: 1223, column: 18, scope: !2425)
!2449 = !DILocation(line: 1223, column: 13, scope: !2426)
!2450 = !DILocation(line: 1224, column: 13, scope: !2424)
!2451 = !DILocation(line: 1226, column: 20, scope: !2423)
!2452 = !DILocation(line: 1226, column: 37, scope: !2453)
!2453 = !DILexicalBlockFile(scope: !2423, file: !3, discriminator: 1)
!2454 = !DILocation(line: 1226, column: 25, scope: !2423)
!2455 = !DILocation(line: 1226, column: 32, scope: !2453)
!2456 = !DILocation(line: 1227, column: 42, scope: !2422)
!2457 = !DILocation(line: 1227, column: 65, scope: !2422)
!2458 = !DILocation(line: 1227, column: 72, scope: !2422)
!2459 = !DILocation(line: 1227, column: 77, scope: !2422)
!2460 = !DILocation(line: 1227, column: 51, scope: !2422)
!2461 = !DILocation(line: 1227, column: 21, scope: !2422)
!2462 = !DILocation(line: 1228, column: 17, scope: !2422)
!2463 = !DILocation(line: 1229, column: 17, scope: !2422)
!2464 = !DILocation(line: 1230, column: 21, scope: !2422)
!2465 = !DILocation(line: 1235, column: 13, scope: !2422)
!2466 = !DILocation(line: 1237, column: 13, scope: !2467)
!2467 = distinct !DILexicalBlock(scope: !2426, file: !3, line: 1237, column: 13)
!2468 = !DILocation(line: 1237, column: 13, scope: !2426)
!2469 = !DILocation(line: 1238, column: 13, scope: !2470)
!2470 = distinct !DILexicalBlock(scope: !2467, file: !3, line: 1237, column: 17)
!2471 = !DILocation(line: 1239, column: 9, scope: !2470)
!2472 = !DILocation(line: 1240, column: 13, scope: !2473)
!2473 = distinct !DILexicalBlock(scope: !2467, file: !3, line: 1239, column: 16)
!2474 = !DILocation(line: 1243, column: 9, scope: !2434)
!2475 = !DILocation(line: 1244, column: 9, scope: !2434)
!2476 = !DILocation(line: 1245, column: 9, scope: !2434)
!2477 = !DILocation(line: 1246, column: 9, scope: !2434)
!2478 = !DILocation(line: 1247, column: 18, scope: !2433)
!2479 = !DILocation(line: 1247, column: 13, scope: !2434)
!2480 = !DILocation(line: 1248, column: 13, scope: !2481)
!2481 = distinct !DILexicalBlock(scope: !2433, file: !3, line: 1247, column: 45)
!2482 = !DILocation(line: 1249, column: 9, scope: !2481)
!2483 = !DILocation(line: 1249, column: 25, scope: !2484)
!2484 = !DILexicalBlockFile(scope: !2432, file: !3, discriminator: 1)
!2485 = !DILocation(line: 1250, column: 13, scope: !2431)
!2486 = !DILocation(line: 1249, column: 20, scope: !2487)
!2487 = !DILexicalBlockFile(scope: !2433, file: !3, discriminator: 1)
!2488 = !DILocation(line: 1251, column: 13, scope: !2431)
!2489 = !DILocation(line: 1253, column: 20, scope: !2430)
!2490 = !DILocation(line: 1253, column: 37, scope: !2491)
!2491 = !DILexicalBlockFile(scope: !2430, file: !3, discriminator: 1)
!2492 = !DILocation(line: 1253, column: 25, scope: !2430)
!2493 = !DILocation(line: 1253, column: 32, scope: !2491)
!2494 = !DILocation(line: 1254, column: 42, scope: !2429)
!2495 = !DILocation(line: 1254, column: 65, scope: !2429)
!2496 = !DILocation(line: 1254, column: 72, scope: !2429)
!2497 = !DILocation(line: 1254, column: 79, scope: !2429)
!2498 = !DILocation(line: 1254, column: 51, scope: !2429)
!2499 = !DILocation(line: 1254, column: 21, scope: !2429)
!2500 = !DILocation(line: 1255, column: 17, scope: !2429)
!2501 = !DILocation(line: 1256, column: 17, scope: !2429)
!2502 = !DILocation(line: 1257, column: 21, scope: !2429)
!2503 = !DILocation(line: 1264, column: 13, scope: !2429)
!2504 = !DILocation(line: 1268, column: 13, scope: !2505)
!2505 = distinct !DILexicalBlock(scope: !2434, file: !3, line: 1268, column: 13)
!2506 = !DILocation(line: 1268, column: 13, scope: !2434)
!2507 = !DILocation(line: 1269, column: 13, scope: !2508)
!2508 = distinct !DILexicalBlock(scope: !2505, file: !3, line: 1268, column: 17)
!2509 = !DILocation(line: 1270, column: 9, scope: !2508)
!2510 = !DILocation(line: 1271, column: 13, scope: !2511)
!2511 = distinct !DILexicalBlock(scope: !2505, file: !3, line: 1270, column: 16)
!2512 = !DILocation(line: 1274, column: 5, scope: !2411)
!2513 = distinct !DISubprogram(name: "usb_pll_init", scope: !3, file: !3, line: 1276, type: !179, isLocal: false, isDefinition: true, scopeLine: 1277, isOptimized: true, unit: !2, variables: !181)
!2514 = !DILocation(line: 1279, column: 11, scope: !2515)
!2515 = distinct !DILexicalBlock(scope: !2513, file: !3, line: 1279, column: 9)
!2516 = !DILocation(line: 1279, column: 25, scope: !2515)
!2517 = !DILocation(line: 1279, column: 9, scope: !2513)
!2518 = !DILocation(line: 1280, column: 23, scope: !2519)
!2519 = distinct !DILexicalBlock(scope: !2515, file: !3, line: 1279, column: 36)
!2520 = !DILocation(line: 1281, column: 9, scope: !2519)
!2521 = !DILocation(line: 1284, column: 24, scope: !2519)
!2522 = !DILocation(line: 1285, column: 23, scope: !2519)
!2523 = !DILocation(line: 1287, column: 9, scope: !2519)
!2524 = !DILocation(line: 1288, column: 9, scope: !2519)
!2525 = !DILocation(line: 1289, column: 9, scope: !2519)
!2526 = !DILocation(line: 1290, column: 9, scope: !2519)
!2527 = !DILocation(line: 1292, column: 23, scope: !2519)
!2528 = !DILocation(line: 1293, column: 23, scope: !2519)
!2529 = !DILocation(line: 1295, column: 23, scope: !2519)
!2530 = !DILocation(line: 1297, column: 23, scope: !2519)
!2531 = !DILocation(line: 1298, column: 9, scope: !2519)
!2532 = !DILocation(line: 1299, column: 23, scope: !2519)
!2533 = !DILocation(line: 1300, column: 9, scope: !2519)
!2534 = !DILocation(line: 1301, column: 23, scope: !2519)
!2535 = !DILocation(line: 1302, column: 9, scope: !2519)
!2536 = !DILocation(line: 1303, column: 5, scope: !2519)
!2537 = !DILocation(line: 1304, column: 1, scope: !2513)
!2538 = distinct !DISubprogram(name: "usb_g_sie_init", scope: !3, file: !3, line: 1305, type: !447, isLocal: false, isDefinition: true, scopeLine: 1306, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2539)
!2539 = !{!2540}
!2540 = !DILocalVariable(name: "id", arg: 1, scope: !2538, file: !3, line: 1305, type: !201)
!2541 = !DILocation(line: 1305, column: 35, scope: !2538)
!2542 = !DILocation(line: 1307, column: 9, scope: !2543)
!2543 = distinct !DILexicalBlock(scope: !2538, file: !3, line: 1307, column: 9)
!2544 = !DILocation(line: 1307, column: 12, scope: !2543)
!2545 = !DILocation(line: 1307, column: 9, scope: !2538)
!2546 = !DILocation(line: 1308, column: 39, scope: !2547)
!2547 = distinct !DILexicalBlock(scope: !2543, file: !3, line: 1307, column: 18)
!2548 = !DILocation(line: 1308, column: 33, scope: !2547)
!2549 = !DILocation(line: 1308, column: 9, scope: !2547)
!2550 = !DILocation(line: 1309, column: 33, scope: !2547)
!2551 = !DILocation(line: 1309, column: 9, scope: !2547)
!2552 = !DILocation(line: 1311, column: 9, scope: !2547)
!2553 = !DILocation(line: 1311, column: 42, scope: !2547)
!2554 = !DILocation(line: 1312, column: 42, scope: !2547)
!2555 = !DILocation(line: 1313, column: 9, scope: !2547)
!2556 = !DILocation(line: 1313, column: 36, scope: !2547)
!2557 = !DILocation(line: 1314, column: 9, scope: !2547)
!2558 = !DILocation(line: 1314, column: 36, scope: !2547)
!2559 = !DILocation(line: 1315, column: 36, scope: !2547)
!2560 = !DILocation(line: 1317, column: 42, scope: !2547)
!2561 = !DILocation(line: 1318, column: 42, scope: !2547)
!2562 = !DILocation(line: 1320, column: 42, scope: !2547)
!2563 = !DILocation(line: 1323, column: 36, scope: !2547)
!2564 = !DILocation(line: 1324, column: 5, scope: !2547)
!2565 = !DILocation(line: 1329, column: 18, scope: !2566)
!2566 = distinct !DILexicalBlock(scope: !2543, file: !3, line: 1324, column: 12)
!2567 = !DILocation(line: 1330, column: 22, scope: !2566)
!2568 = !DILocation(line: 1331, column: 24, scope: !2566)
!2569 = !DILocation(line: 1332, column: 24, scope: !2566)
!2570 = !DILocation(line: 1337, column: 24, scope: !2566)
!2571 = !DILocation(line: 1341, column: 24, scope: !2566)
!2572 = !DILocation(line: 1342, column: 9, scope: !2566)
!2573 = !DILocation(line: 1343, column: 24, scope: !2566)
!2574 = !DILocation(line: 1346, column: 22, scope: !2566)
!2575 = !DILocation(line: 1348, column: 9, scope: !2566)
!2576 = !DILocation(line: 1348, column: 17, scope: !2577)
!2577 = !DILexicalBlockFile(scope: !2566, file: !3, discriminator: 1)
!2578 = !DILocation(line: 1348, column: 30, scope: !2577)
!2579 = !DILocation(line: 1348, column: 52, scope: !2577)
!2580 = !DILocation(line: 1348, column: 9, scope: !2577)
!2581 = distinct !{!2581, !2575, !2582}
!2582 = !DILocation(line: 1348, column: 59, scope: !2566)
!2583 = !DILocation(line: 1351, column: 24, scope: !2566)
!2584 = !DILocation(line: 1352, column: 24, scope: !2566)
!2585 = !DILocation(line: 1353, column: 24, scope: !2566)
!2586 = !DILocation(line: 1354, column: 24, scope: !2566)
!2587 = !DILocation(line: 1356, column: 22, scope: !2566)
!2588 = !DILocation(line: 1358, column: 23, scope: !2566)
!2589 = !DILocation(line: 1359, column: 23, scope: !2566)
!2590 = !DILocation(line: 1363, column: 1, scope: !2538)
!2591 = distinct !DISubprogram(name: "usb_enable_ep", scope: !3, file: !3, line: 1364, type: !1288, isLocal: false, isDefinition: true, scopeLine: 1365, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2592)
!2592 = !{!2593, !2594}
!2593 = !DILocalVariable(name: "id", arg: 1, scope: !2591, file: !3, line: 1364, type: !201)
!2594 = !DILocalVariable(name: "ep", arg: 2, scope: !2591, file: !3, line: 1364, type: !59)
!2595 = !DILocation(line: 1364, column: 34, scope: !2591)
!2596 = !DILocation(line: 1364, column: 42, scope: !2591)
!2597 = !DILocation(line: 1366, column: 12, scope: !2598)
!2598 = distinct !DILexicalBlock(scope: !2591, file: !3, line: 1366, column: 9)
!2599 = !DILocation(line: 1366, column: 9, scope: !2591)
!2600 = !DILocation(line: 1367, column: 56, scope: !2601)
!2601 = distinct !DILexicalBlock(scope: !2598, file: !3, line: 1366, column: 18)
!2602 = !DILocation(line: 1367, column: 45, scope: !2601)
!2603 = !DILocation(line: 1367, column: 39, scope: !2601)
!2604 = !DILocation(line: 1367, column: 36, scope: !2601)
!2605 = !DILocation(line: 1368, column: 5, scope: !2601)
!2606 = !DILocation(line: 1369, column: 1, scope: !2591)
!2607 = distinct !DISubprogram(name: "usb_disable_ep", scope: !3, file: !3, line: 1370, type: !1288, isLocal: false, isDefinition: true, scopeLine: 1371, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2608)
!2608 = !{!2609, !2610}
!2609 = !DILocalVariable(name: "id", arg: 1, scope: !2607, file: !3, line: 1370, type: !201)
!2610 = !DILocalVariable(name: "ep", arg: 2, scope: !2607, file: !3, line: 1370, type: !59)
!2611 = !DILocation(line: 1370, column: 35, scope: !2607)
!2612 = !DILocation(line: 1370, column: 43, scope: !2607)
!2613 = !DILocation(line: 1372, column: 12, scope: !2614)
!2614 = distinct !DILexicalBlock(scope: !2607, file: !3, line: 1372, column: 9)
!2615 = !DILocation(line: 1372, column: 9, scope: !2607)
!2616 = !DILocation(line: 1373, column: 55, scope: !2617)
!2617 = distinct !DILexicalBlock(scope: !2614, file: !3, line: 1372, column: 18)
!2618 = !DILocation(line: 1373, column: 44, scope: !2617)
!2619 = !DILocation(line: 1373, column: 36, scope: !2617)
!2620 = !DILocation(line: 1374, column: 5, scope: !2617)
!2621 = !DILocation(line: 1375, column: 1, scope: !2607)
!2622 = distinct !DISubprogram(name: "usb_g_hold", scope: !3, file: !3, line: 1376, type: !447, isLocal: false, isDefinition: true, scopeLine: 1377, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2623)
!2623 = !{!2624}
!2624 = !DILocalVariable(name: "id", arg: 1, scope: !2622, file: !3, line: 1376, type: !201)
!2625 = !DILocation(line: 1376, column: 31, scope: !2622)
!2626 = !DILocation(line: 1378, column: 9, scope: !2627)
!2627 = distinct !DILexicalBlock(scope: !2622, file: !3, line: 1378, column: 9)
!2628 = !DILocation(line: 1378, column: 12, scope: !2627)
!2629 = !DILocation(line: 1378, column: 9, scope: !2622)
!2630 = !DILocation(line: 1379, column: 39, scope: !2631)
!2631 = distinct !DILexicalBlock(scope: !2627, file: !3, line: 1378, column: 18)
!2632 = !DILocation(line: 1379, column: 33, scope: !2631)
!2633 = !DILocation(line: 1379, column: 9, scope: !2631)
!2634 = !DILocation(line: 1380, column: 33, scope: !2631)
!2635 = !DILocation(line: 1380, column: 9, scope: !2631)
!2636 = !DILocation(line: 1381, column: 9, scope: !2631)
!2637 = !DILocation(line: 1381, column: 42, scope: !2631)
!2638 = !DILocation(line: 1382, column: 42, scope: !2631)
!2639 = !DILocation(line: 1384, column: 9, scope: !2631)
!2640 = !DILocation(line: 1384, column: 36, scope: !2631)
!2641 = !DILocation(line: 1387, column: 5, scope: !2631)
!2642 = !DILocation(line: 1388, column: 22, scope: !2643)
!2643 = distinct !DILexicalBlock(scope: !2627, file: !3, line: 1387, column: 12)
!2644 = !DILocation(line: 1391, column: 1, scope: !2622)
!2645 = distinct !DISubprogram(name: "usb_get_ep_num", scope: !3, file: !3, line: 1392, type: !2646, isLocal: false, isDefinition: true, scopeLine: 1393, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2648)
!2646 = !DISubroutineType(types: !2647)
!2647 = !{!59, !201, !59, !59}
!2648 = !{!2649, !2650, !2651, !2652}
!2649 = !DILocalVariable(name: "id", arg: 1, scope: !2645, file: !3, line: 1392, type: !201)
!2650 = !DILocalVariable(name: "ep_dir", arg: 2, scope: !2645, file: !3, line: 1392, type: !59)
!2651 = !DILocalVariable(name: "type", arg: 3, scope: !2645, file: !3, line: 1392, type: !59)
!2652 = !DILocalVariable(name: "ep", scope: !2645, file: !3, line: 1394, type: !52)
!2653 = !DILocation(line: 1392, column: 34, scope: !2645)
!2654 = !DILocation(line: 1392, column: 42, scope: !2645)
!2655 = !DILocation(line: 1392, column: 54, scope: !2645)
!2656 = !DILocation(line: 1394, column: 8, scope: !2645)
!2657 = !DILocation(line: 1413, column: 16, scope: !2658)
!2658 = distinct !DILexicalBlock(scope: !2645, file: !3, line: 1413, column: 9)
!2659 = !DILocation(line: 1413, column: 9, scope: !2645)
!2660 = !DILocation(line: 1414, column: 9, scope: !2661)
!2661 = distinct !DILexicalBlock(scope: !2658, file: !3, line: 1413, column: 31)
!2662 = !DILocation(line: 1416, column: 18, scope: !2663)
!2663 = distinct !DILexicalBlock(scope: !2664, file: !3, line: 1416, column: 17)
!2664 = distinct !DILexicalBlock(scope: !2661, file: !3, line: 1414, column: 23)
!2665 = !DILocation(line: 1416, column: 35, scope: !2663)
!2666 = !{!679, !215, i64 4}
!2667 = !DILocation(line: 1416, column: 44, scope: !2663)
!2668 = !DILocation(line: 1416, column: 54, scope: !2663)
!2669 = !DILocation(line: 1416, column: 17, scope: !2664)
!2670 = !DILocation(line: 1417, column: 43, scope: !2671)
!2671 = distinct !DILexicalBlock(scope: !2663, file: !3, line: 1416, column: 60)
!2672 = !DILocation(line: 1419, column: 13, scope: !2671)
!2673 = !DILocation(line: 1419, column: 51, scope: !2674)
!2674 = !DILexicalBlockFile(scope: !2675, file: !3, discriminator: 1)
!2675 = distinct !DILexicalBlock(scope: !2663, file: !3, line: 1419, column: 24)
!2676 = !DILocation(line: 1419, column: 61, scope: !2674)
!2677 = !DILocation(line: 1419, column: 24, scope: !2678)
!2678 = !DILexicalBlockFile(scope: !2663, file: !3, discriminator: 1)
!2679 = !DILocation(line: 1420, column: 43, scope: !2680)
!2680 = distinct !DILexicalBlock(scope: !2675, file: !3, line: 1419, column: 67)
!2681 = !DILocation(line: 1422, column: 13, scope: !2680)
!2682 = !DILocation(line: 1425, column: 18, scope: !2683)
!2683 = distinct !DILexicalBlock(scope: !2664, file: !3, line: 1425, column: 17)
!2684 = !DILocation(line: 1425, column: 35, scope: !2683)
!2685 = !DILocation(line: 1425, column: 44, scope: !2683)
!2686 = !DILocation(line: 1425, column: 54, scope: !2683)
!2687 = !DILocation(line: 1425, column: 17, scope: !2664)
!2688 = !DILocation(line: 1426, column: 43, scope: !2689)
!2689 = distinct !DILexicalBlock(scope: !2683, file: !3, line: 1425, column: 60)
!2690 = !DILocation(line: 1428, column: 13, scope: !2689)
!2691 = !DILocation(line: 1428, column: 51, scope: !2692)
!2692 = !DILexicalBlockFile(scope: !2693, file: !3, discriminator: 1)
!2693 = distinct !DILexicalBlock(scope: !2683, file: !3, line: 1428, column: 24)
!2694 = !DILocation(line: 1428, column: 61, scope: !2692)
!2695 = !DILocation(line: 1428, column: 24, scope: !2696)
!2696 = !DILexicalBlockFile(scope: !2683, file: !3, discriminator: 1)
!2697 = !DILocation(line: 1429, column: 43, scope: !2698)
!2698 = distinct !DILexicalBlock(scope: !2693, file: !3, line: 1428, column: 67)
!2699 = !DILocation(line: 1431, column: 13, scope: !2698)
!2700 = !DILocation(line: 1434, column: 18, scope: !2701)
!2701 = distinct !DILexicalBlock(scope: !2664, file: !3, line: 1434, column: 17)
!2702 = !DILocation(line: 1434, column: 35, scope: !2701)
!2703 = !DILocation(line: 1434, column: 44, scope: !2701)
!2704 = !DILocation(line: 1434, column: 54, scope: !2701)
!2705 = !DILocation(line: 1434, column: 17, scope: !2664)
!2706 = !DILocation(line: 1435, column: 43, scope: !2707)
!2707 = distinct !DILexicalBlock(scope: !2701, file: !3, line: 1434, column: 60)
!2708 = !DILocation(line: 1437, column: 13, scope: !2707)
!2709 = !DILocation(line: 1437, column: 51, scope: !2710)
!2710 = !DILexicalBlockFile(scope: !2711, file: !3, discriminator: 1)
!2711 = distinct !DILexicalBlock(scope: !2701, file: !3, line: 1437, column: 24)
!2712 = !DILocation(line: 1437, column: 61, scope: !2710)
!2713 = !DILocation(line: 1437, column: 24, scope: !2714)
!2714 = !DILexicalBlockFile(scope: !2701, file: !3, discriminator: 1)
!2715 = !DILocation(line: 1438, column: 43, scope: !2716)
!2716 = distinct !DILexicalBlock(scope: !2711, file: !3, line: 1437, column: 67)
!2717 = !DILocation(line: 1440, column: 13, scope: !2716)
!2718 = !DILocation(line: 1444, column: 9, scope: !2719)
!2719 = distinct !DILexicalBlock(scope: !2658, file: !3, line: 1443, column: 12)
!2720 = !DILocation(line: 1446, column: 18, scope: !2721)
!2721 = distinct !DILexicalBlock(scope: !2722, file: !3, line: 1446, column: 17)
!2722 = distinct !DILexicalBlock(scope: !2719, file: !3, line: 1444, column: 23)
!2723 = !DILocation(line: 1446, column: 35, scope: !2721)
!2724 = !DILocation(line: 1446, column: 44, scope: !2721)
!2725 = !DILocation(line: 1446, column: 59, scope: !2721)
!2726 = !DILocation(line: 1446, column: 17, scope: !2722)
!2727 = !DILocation(line: 1447, column: 43, scope: !2728)
!2728 = distinct !DILexicalBlock(scope: !2721, file: !3, line: 1446, column: 65)
!2729 = !DILocation(line: 1449, column: 13, scope: !2728)
!2730 = !DILocation(line: 1449, column: 51, scope: !2731)
!2731 = !DILexicalBlockFile(scope: !2732, file: !3, discriminator: 1)
!2732 = distinct !DILexicalBlock(scope: !2721, file: !3, line: 1449, column: 24)
!2733 = !DILocation(line: 1449, column: 66, scope: !2731)
!2734 = !DILocation(line: 1449, column: 24, scope: !2735)
!2735 = !DILexicalBlockFile(scope: !2721, file: !3, discriminator: 1)
!2736 = !DILocation(line: 1450, column: 43, scope: !2737)
!2737 = distinct !DILexicalBlock(scope: !2732, file: !3, line: 1449, column: 72)
!2738 = !DILocation(line: 1452, column: 13, scope: !2737)
!2739 = !DILocation(line: 1455, column: 18, scope: !2740)
!2740 = distinct !DILexicalBlock(scope: !2722, file: !3, line: 1455, column: 17)
!2741 = !DILocation(line: 1455, column: 35, scope: !2740)
!2742 = !DILocation(line: 1455, column: 44, scope: !2740)
!2743 = !DILocation(line: 1455, column: 59, scope: !2740)
!2744 = !DILocation(line: 1455, column: 17, scope: !2722)
!2745 = !DILocation(line: 1456, column: 43, scope: !2746)
!2746 = distinct !DILexicalBlock(scope: !2740, file: !3, line: 1455, column: 65)
!2747 = !DILocation(line: 1458, column: 13, scope: !2746)
!2748 = !DILocation(line: 1458, column: 51, scope: !2749)
!2749 = !DILexicalBlockFile(scope: !2750, file: !3, discriminator: 1)
!2750 = distinct !DILexicalBlock(scope: !2740, file: !3, line: 1458, column: 24)
!2751 = !DILocation(line: 1458, column: 66, scope: !2749)
!2752 = !DILocation(line: 1458, column: 24, scope: !2753)
!2753 = !DILexicalBlockFile(scope: !2740, file: !3, discriminator: 1)
!2754 = !DILocation(line: 1459, column: 43, scope: !2755)
!2755 = distinct !DILexicalBlock(scope: !2750, file: !3, line: 1458, column: 72)
!2756 = !DILocation(line: 1461, column: 13, scope: !2755)
!2757 = !DILocation(line: 1464, column: 18, scope: !2758)
!2758 = distinct !DILexicalBlock(scope: !2722, file: !3, line: 1464, column: 17)
!2759 = !DILocation(line: 1464, column: 35, scope: !2758)
!2760 = !DILocation(line: 1464, column: 44, scope: !2758)
!2761 = !DILocation(line: 1464, column: 59, scope: !2758)
!2762 = !DILocation(line: 1464, column: 17, scope: !2722)
!2763 = !DILocation(line: 1465, column: 43, scope: !2764)
!2764 = distinct !DILexicalBlock(scope: !2758, file: !3, line: 1464, column: 65)
!2765 = !DILocation(line: 1467, column: 13, scope: !2764)
!2766 = !DILocation(line: 1467, column: 51, scope: !2767)
!2767 = !DILexicalBlockFile(scope: !2768, file: !3, discriminator: 1)
!2768 = distinct !DILexicalBlock(scope: !2758, file: !3, line: 1467, column: 24)
!2769 = !DILocation(line: 1467, column: 66, scope: !2767)
!2770 = !DILocation(line: 1467, column: 24, scope: !2771)
!2771 = !DILexicalBlockFile(scope: !2758, file: !3, discriminator: 1)
!2772 = !DILocation(line: 1468, column: 43, scope: !2773)
!2773 = distinct !DILexicalBlock(scope: !2768, file: !3, line: 1467, column: 72)
!2774 = !DILocation(line: 1470, column: 13, scope: !2773)
!2775 = !DILocation(line: 1475, column: 12, scope: !2776)
!2776 = distinct !DILexicalBlock(scope: !2645, file: !3, line: 1475, column: 9)
!2777 = !DILocation(line: 1476, column: 9, scope: !2778)
!2778 = distinct !DILexicalBlock(scope: !2776, file: !3, line: 1475, column: 32)
!2779 = !DILocation(line: 1479, column: 1, scope: !2645)
!2780 = distinct !DISubprogram(name: "usb_h_ep_config", scope: !3, file: !3, line: 1481, type: !2781, isLocal: false, isDefinition: true, scopeLine: 1482, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2783)
!2781 = !DISubroutineType(types: !2782)
!2782 = !{!59, !201, !59, !59, !59, !59, !51, !59}
!2783 = !{!2784, !2785, !2786, !2787, !2788, !2789, !2790, !2791}
!2784 = !DILocalVariable(name: "id", arg: 1, scope: !2780, file: !3, line: 1481, type: !201)
!2785 = !DILocalVariable(name: "ep", arg: 2, scope: !2780, file: !3, line: 1481, type: !59)
!2786 = !DILocalVariable(name: "type", arg: 3, scope: !2780, file: !3, line: 1481, type: !59)
!2787 = !DILocalVariable(name: "ie", arg: 4, scope: !2780, file: !3, line: 1481, type: !59)
!2788 = !DILocalVariable(name: "interval", arg: 5, scope: !2780, file: !3, line: 1481, type: !59)
!2789 = !DILocalVariable(name: "ptr", arg: 6, scope: !2780, file: !3, line: 1481, type: !51)
!2790 = !DILocalVariable(name: "dma_size", arg: 7, scope: !2780, file: !3, line: 1481, type: !59)
!2791 = !DILocalVariable(name: "maxpsize", scope: !2780, file: !3, line: 1483, type: !59)
!2792 = !DILocation(line: 1481, column: 35, scope: !2780)
!2793 = !DILocation(line: 1481, column: 43, scope: !2780)
!2794 = !DILocation(line: 1481, column: 51, scope: !2780)
!2795 = !DILocation(line: 1481, column: 61, scope: !2780)
!2796 = !DILocation(line: 1481, column: 69, scope: !2780)
!2797 = !DILocation(line: 1481, column: 83, scope: !2780)
!2798 = !DILocation(line: 1481, column: 92, scope: !2780)
!2799 = !DILocation(line: 1484, column: 12, scope: !2800)
!2800 = distinct !DILexicalBlock(scope: !2780, file: !3, line: 1484, column: 9)
!2801 = !DILocation(line: 1484, column: 9, scope: !2780)
!2802 = !DILocation(line: 1486, column: 9, scope: !2803)
!2803 = distinct !DILexicalBlock(scope: !2800, file: !3, line: 1484, column: 26)
!2804 = !DILocation(line: 1487, column: 9, scope: !2803)
!2805 = !DILocation(line: 1488, column: 9, scope: !2803)
!2806 = !DILocation(line: 1489, column: 9, scope: !2803)
!2807 = !DILocation(line: 1490, column: 13, scope: !2803)
!2808 = !DILocation(line: 1491, column: 13, scope: !2809)
!2809 = distinct !DILexicalBlock(scope: !2810, file: !3, line: 1490, column: 45)
!2810 = distinct !DILexicalBlock(scope: !2803, file: !3, line: 1490, column: 13)
!2811 = !DILocation(line: 1493, column: 9, scope: !2809)
!2812 = !DILocation(line: 1494, column: 13, scope: !2813)
!2813 = distinct !DILexicalBlock(scope: !2814, file: !3, line: 1493, column: 52)
!2814 = distinct !DILexicalBlock(scope: !2810, file: !3, line: 1493, column: 20)
!2815 = !DILocation(line: 1495, column: 13, scope: !2813)
!2816 = !DILocation(line: 1496, column: 20, scope: !2817)
!2817 = distinct !DILexicalBlock(scope: !2813, file: !3, line: 1496, column: 17)
!2818 = !DILocation(line: 1496, column: 37, scope: !2819)
!2819 = !DILexicalBlockFile(scope: !2817, file: !3, discriminator: 1)
!2820 = !DILocation(line: 1496, column: 25, scope: !2817)
!2821 = !DILocation(line: 1496, column: 32, scope: !2819)
!2822 = !DILocation(line: 1497, column: 38, scope: !2823)
!2823 = distinct !DILexicalBlock(scope: !2817, file: !3, line: 1496, column: 50)
!2824 = !DILocation(line: 1497, column: 61, scope: !2823)
!2825 = !DILocation(line: 1497, column: 68, scope: !2823)
!2826 = !DILocation(line: 1497, column: 75, scope: !2823)
!2827 = !DILocation(line: 1497, column: 47, scope: !2823)
!2828 = !DILocation(line: 1483, column: 9, scope: !2780)
!2829 = !DILocation(line: 1498, column: 17, scope: !2823)
!2830 = !DILocation(line: 1499, column: 17, scope: !2823)
!2831 = !DILocation(line: 1501, column: 21, scope: !2823)
!2832 = !DILocation(line: 1506, column: 13, scope: !2823)
!2833 = !DILocation(line: 1508, column: 13, scope: !2834)
!2834 = distinct !DILexicalBlock(scope: !2835, file: !3, line: 1507, column: 51)
!2835 = distinct !DILexicalBlock(scope: !2814, file: !3, line: 1507, column: 20)
!2836 = !DILocation(line: 1509, column: 13, scope: !2834)
!2837 = !DILocation(line: 1510, column: 9, scope: !2834)
!2838 = !DILocation(line: 1511, column: 13, scope: !2839)
!2839 = distinct !DILexicalBlock(scope: !2803, file: !3, line: 1511, column: 13)
!2840 = !DILocation(line: 1511, column: 13, scope: !2803)
!2841 = !DILocation(line: 1512, column: 13, scope: !2842)
!2842 = distinct !DILexicalBlock(scope: !2839, file: !3, line: 1511, column: 17)
!2843 = !DILocation(line: 1513, column: 9, scope: !2842)
!2844 = !DILocation(line: 1514, column: 13, scope: !2845)
!2845 = distinct !DILexicalBlock(scope: !2839, file: !3, line: 1513, column: 16)
!2846 = !DILocation(line: 1519, column: 9, scope: !2847)
!2847 = distinct !DILexicalBlock(scope: !2800, file: !3, line: 1516, column: 12)
!2848 = !DILocation(line: 1520, column: 9, scope: !2847)
!2849 = !DILocation(line: 1521, column: 9, scope: !2847)
!2850 = !DILocation(line: 1522, column: 9, scope: !2847)
!2851 = !DILocation(line: 1523, column: 13, scope: !2847)
!2852 = !DILocation(line: 1526, column: 13, scope: !2853)
!2853 = distinct !DILexicalBlock(scope: !2854, file: !3, line: 1525, column: 52)
!2854 = distinct !DILexicalBlock(scope: !2855, file: !3, line: 1525, column: 20)
!2855 = distinct !DILexicalBlock(scope: !2847, file: !3, line: 1523, column: 13)
!2856 = !DILocation(line: 1527, column: 20, scope: !2857)
!2857 = distinct !DILexicalBlock(scope: !2853, file: !3, line: 1527, column: 17)
!2858 = !DILocation(line: 1527, column: 37, scope: !2859)
!2859 = !DILexicalBlockFile(scope: !2857, file: !3, discriminator: 1)
!2860 = !DILocation(line: 1527, column: 25, scope: !2857)
!2861 = !DILocation(line: 1527, column: 32, scope: !2859)
!2862 = !DILocation(line: 1528, column: 38, scope: !2863)
!2863 = distinct !DILexicalBlock(scope: !2857, file: !3, line: 1527, column: 50)
!2864 = !DILocation(line: 1528, column: 61, scope: !2863)
!2865 = !DILocation(line: 1528, column: 68, scope: !2863)
!2866 = !DILocation(line: 1528, column: 75, scope: !2863)
!2867 = !DILocation(line: 1528, column: 47, scope: !2863)
!2868 = !DILocation(line: 1529, column: 17, scope: !2863)
!2869 = !DILocation(line: 1530, column: 17, scope: !2863)
!2870 = !DILocation(line: 1532, column: 21, scope: !2863)
!2871 = !DILocation(line: 1537, column: 13, scope: !2863)
!2872 = !DILocation(line: 1539, column: 13, scope: !2873)
!2873 = distinct !DILexicalBlock(scope: !2874, file: !3, line: 1538, column: 51)
!2874 = distinct !DILexicalBlock(scope: !2854, file: !3, line: 1538, column: 20)
!2875 = !DILocation(line: 1540, column: 9, scope: !2873)
!2876 = !DILocation(line: 1541, column: 13, scope: !2877)
!2877 = distinct !DILexicalBlock(scope: !2847, file: !3, line: 1541, column: 13)
!2878 = !DILocation(line: 1541, column: 13, scope: !2847)
!2879 = !DILocation(line: 1542, column: 13, scope: !2880)
!2880 = distinct !DILexicalBlock(scope: !2877, file: !3, line: 1541, column: 17)
!2881 = !DILocation(line: 1543, column: 9, scope: !2880)
!2882 = !DILocation(line: 1544, column: 13, scope: !2883)
!2883 = distinct !DILexicalBlock(scope: !2877, file: !3, line: 1543, column: 16)
!2884 = !DILocation(line: 1547, column: 5, scope: !2780)
!2885 = distinct !DISubprogram(name: "usb_h_ep_write_async", scope: !3, file: !3, line: 1549, type: !2886, isLocal: false, isDefinition: true, scopeLine: 1550, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !2889)
!2886 = !DISubroutineType(types: !2887)
!2887 = !{!2888, !201, !52, !55, !52, !660, !59, !59, !59}
!2888 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!2889 = !{!2890, !2891, !2892, !2893, !2894, !2895, !2896, !2897, !2898, !2899, !2902}
!2890 = !DILocalVariable(name: "id", arg: 1, scope: !2885, file: !3, line: 1549, type: !201)
!2891 = !DILocalVariable(name: "host_ep", arg: 2, scope: !2885, file: !3, line: 1549, type: !52)
!2892 = !DILocalVariable(name: "txmaxp", arg: 3, scope: !2885, file: !3, line: 1549, type: !55)
!2893 = !DILocalVariable(name: "target_ep", arg: 4, scope: !2885, file: !3, line: 1549, type: !52)
!2894 = !DILocalVariable(name: "ptr", arg: 5, scope: !2885, file: !3, line: 1549, type: !660)
!2895 = !DILocalVariable(name: "len", arg: 6, scope: !2885, file: !3, line: 1549, type: !59)
!2896 = !DILocalVariable(name: "xfer", arg: 7, scope: !2885, file: !3, line: 1549, type: !59)
!2897 = !DILocalVariable(name: "kstart", arg: 8, scope: !2885, file: !3, line: 1549, type: !59)
!2898 = !DILocalVariable(name: "ret", scope: !2885, file: !3, line: 1551, type: !2888)
!2899 = !DILocalVariable(name: "txcsr", scope: !2900, file: !3, line: 1554, type: !59)
!2900 = distinct !DILexicalBlock(scope: !2901, file: !3, line: 1552, column: 18)
!2901 = distinct !DILexicalBlock(scope: !2885, file: !3, line: 1552, column: 9)
!2902 = !DILocalVariable(name: "tx_addr", scope: !2903, file: !3, line: 1576, type: !51)
!2903 = distinct !DILexicalBlock(scope: !2904, file: !3, line: 1575, column: 24)
!2904 = distinct !DILexicalBlock(scope: !2885, file: !3, line: 1575, column: 9)
!2905 = !DILocation(line: 1549, column: 40, scope: !2885)
!2906 = !DILocation(line: 1549, column: 47, scope: !2885)
!2907 = !DILocation(line: 1549, column: 60, scope: !2885)
!2908 = !DILocation(line: 1549, column: 71, scope: !2885)
!2909 = !DILocation(line: 1549, column: 92, scope: !2885)
!2910 = !DILocation(line: 1549, column: 101, scope: !2885)
!2911 = !DILocation(line: 1549, column: 110, scope: !2885)
!2912 = !DILocation(line: 1549, column: 120, scope: !2885)
!2913 = !DILocation(line: 1551, column: 9, scope: !2885)
!2914 = !DILocation(line: 1552, column: 10, scope: !2901)
!2915 = !DILocation(line: 1552, column: 9, scope: !2885)
!2916 = !DILocation(line: 1554, column: 40, scope: !2900)
!2917 = !DILocation(line: 1554, column: 21, scope: !2900)
!2918 = !DILocation(line: 1554, column: 13, scope: !2900)
!2919 = !DILocation(line: 1555, column: 19, scope: !2920)
!2920 = distinct !DILexicalBlock(scope: !2900, file: !3, line: 1555, column: 13)
!2921 = !DILocation(line: 1555, column: 13, scope: !2900)
!2922 = !DILocation(line: 1556, column: 19, scope: !2923)
!2923 = distinct !DILexicalBlock(scope: !2920, file: !3, line: 1555, column: 33)
!2924 = !DILocation(line: 1557, column: 9, scope: !2923)
!2925 = !DILocation(line: 1557, column: 26, scope: !2926)
!2926 = !DILexicalBlockFile(scope: !2927, file: !3, discriminator: 1)
!2927 = distinct !DILexicalBlock(scope: !2920, file: !3, line: 1557, column: 20)
!2928 = !DILocation(line: 1557, column: 20, scope: !2929)
!2929 = !DILexicalBlockFile(scope: !2920, file: !3, discriminator: 1)
!2930 = !DILocation(line: 1558, column: 19, scope: !2931)
!2931 = distinct !DILexicalBlock(scope: !2927, file: !3, line: 1557, column: 44)
!2932 = !DILocation(line: 1559, column: 13, scope: !2933)
!2933 = distinct !DILexicalBlock(scope: !2931, file: !3, line: 1559, column: 13)
!2934 = !DILocation(line: 1561, column: 9, scope: !2931)
!2935 = !DILocation(line: 1561, column: 26, scope: !2936)
!2936 = !DILexicalBlockFile(scope: !2937, file: !3, discriminator: 1)
!2937 = distinct !DILexicalBlock(scope: !2927, file: !3, line: 1561, column: 20)
!2938 = !DILocation(line: 1561, column: 20, scope: !2926)
!2939 = !DILocation(line: 1562, column: 19, scope: !2940)
!2940 = distinct !DILexicalBlock(scope: !2937, file: !3, line: 1561, column: 42)
!2941 = !DILocation(line: 1563, column: 13, scope: !2942)
!2942 = distinct !DILexicalBlock(scope: !2940, file: !3, line: 1563, column: 13)
!2943 = !DILocation(line: 1565, column: 9, scope: !2940)
!2944 = !DILocation(line: 1567, column: 9, scope: !2900)
!2945 = !DILocation(line: 1568, column: 5, scope: !2900)
!2946 = !DILocation(line: 1569, column: 14, scope: !2947)
!2947 = distinct !DILexicalBlock(scope: !2948, file: !3, line: 1569, column: 13)
!2948 = distinct !DILexicalBlock(scope: !2901, file: !3, line: 1568, column: 12)
!2949 = !DILocation(line: 1569, column: 34, scope: !2947)
!2950 = !DILocation(line: 1569, column: 44, scope: !2947)
!2951 = !DILocation(line: 1569, column: 13, scope: !2948)
!2952 = !DILocation(line: 1570, column: 13, scope: !2953)
!2953 = distinct !DILexicalBlock(scope: !2954, file: !3, line: 1570, column: 13)
!2954 = distinct !DILexicalBlock(scope: !2947, file: !3, line: 1569, column: 50)
!2955 = !DILocation(line: 1571, column: 13, scope: !2954)
!2956 = !DILocation(line: 1575, column: 16, scope: !2904)
!2957 = !DILocation(line: 1576, column: 45, scope: !2903)
!2958 = !DILocation(line: 1576, column: 23, scope: !2903)
!2959 = !DILocation(line: 1576, column: 13, scope: !2903)
!2960 = !DILocation(line: 1578, column: 9, scope: !2903)
!2961 = !DILocation(line: 1579, column: 13, scope: !2962)
!2962 = distinct !DILexicalBlock(scope: !2903, file: !3, line: 1579, column: 13)
!2963 = !DILocation(line: 1579, column: 13, scope: !2903)
!2964 = !DILocation(line: 1580, column: 13, scope: !2965)
!2965 = distinct !DILexicalBlock(scope: !2962, file: !3, line: 1579, column: 18)
!2966 = !DILocation(line: 1581, column: 13, scope: !2965)
!2967 = !{i32 47282}
!2968 = !DILocation(line: 1582, column: 9, scope: !2965)
!2969 = !DILocation(line: 1583, column: 16, scope: !2970)
!2970 = distinct !DILexicalBlock(scope: !2903, file: !3, line: 1583, column: 13)
!2971 = !DILocation(line: 1583, column: 13, scope: !2903)
!2972 = !DILocation(line: 1584, column: 13, scope: !2973)
!2973 = !DILexicalBlockFile(scope: !2974, file: !3, discriminator: 1)
!2974 = distinct !DILexicalBlock(scope: !2975, file: !3, line: 1584, column: 13)
!2975 = distinct !DILexicalBlock(scope: !2970, file: !3, line: 1583, column: 22)
!2976 = !DILocation(line: 1585, column: 13, scope: !2975)
!2977 = !DILocation(line: 1586, column: 13, scope: !2975)
!2978 = !DILocation(line: 1587, column: 51, scope: !2975)
!2979 = !DILocation(line: 1587, column: 59, scope: !2975)
!2980 = !DILocation(line: 1587, column: 57, scope: !2975)
!2981 = !DILocation(line: 1587, column: 13, scope: !2975)
!2982 = !DILocation(line: 1588, column: 13, scope: !2975)
!2983 = !DILocation(line: 1589, column: 13, scope: !2984)
!2984 = !DILexicalBlockFile(scope: !2985, file: !3, discriminator: 1)
!2985 = distinct !DILexicalBlock(scope: !2975, file: !3, line: 1589, column: 13)
!2986 = !DILocation(line: 1590, column: 9, scope: !2975)
!2987 = !DILocation(line: 1583, column: 13, scope: !2988)
!2988 = !DILexicalBlockFile(scope: !2970, file: !3, discriminator: 1)
!2989 = !DILocation(line: 1591, column: 13, scope: !2990)
!2990 = distinct !DILexicalBlock(scope: !2970, file: !3, line: 1590, column: 16)
!2991 = !DILocation(line: 1592, column: 56, scope: !2990)
!2992 = !DILocation(line: 1592, column: 71, scope: !2990)
!2993 = !DILocation(line: 1592, column: 44, scope: !2990)
!2994 = !DILocation(line: 1592, column: 76, scope: !2990)
!2995 = !DILocation(line: 1592, column: 90, scope: !2990)
!2996 = !DILocation(line: 1592, column: 98, scope: !2990)
!2997 = !DILocation(line: 1592, column: 82, scope: !2990)
!2998 = !DILocation(line: 1592, column: 96, scope: !2990)
!2999 = !DILocation(line: 1592, column: 13, scope: !2990)
!3000 = !DILocation(line: 1593, column: 13, scope: !2990)
!3001 = !DILocation(line: 1597, column: 1, scope: !2885)
!3002 = distinct !DISubprogram(name: "usb_h_ep_write", scope: !3, file: !3, line: 1598, type: !3003, isLocal: false, isDefinition: true, scopeLine: 1599, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !3005)
!3003 = !DISubroutineType(types: !3004)
!3004 = !{!2888, !201, !52, !55, !52, !660, !59, !59}
!3005 = !{!3006, !3007, !3008, !3009, !3010, !3011, !3012, !3013, !3014, !3015, !3016, !3017, !3018, !3019, !3021}
!3006 = !DILocalVariable(name: "id", arg: 1, scope: !3002, file: !3, line: 1598, type: !201)
!3007 = !DILocalVariable(name: "host_ep", arg: 2, scope: !3002, file: !3, line: 1598, type: !52)
!3008 = !DILocalVariable(name: "txmaxp", arg: 3, scope: !3002, file: !3, line: 1598, type: !55)
!3009 = !DILocalVariable(name: "target_ep", arg: 4, scope: !3002, file: !3, line: 1598, type: !52)
!3010 = !DILocalVariable(name: "ptr", arg: 5, scope: !3002, file: !3, line: 1598, type: !660)
!3011 = !DILocalVariable(name: "len", arg: 6, scope: !3002, file: !3, line: 1598, type: !59)
!3012 = !DILocalVariable(name: "xfer", arg: 7, scope: !3002, file: !3, line: 1598, type: !59)
!3013 = !DILocalVariable(name: "_len", scope: !3002, file: !3, line: 1600, type: !59)
!3014 = !DILocalVariable(name: "st", scope: !3002, file: !3, line: 1601, type: !59)
!3015 = !DILocalVariable(name: "tx_addr", scope: !3002, file: !3, line: 1602, type: !51)
!3016 = !DILocalVariable(name: "ot", scope: !3002, file: !3, line: 1606, type: !59)
!3017 = !DILocalVariable(name: "ot_times", scope: !3002, file: !3, line: 1607, type: !59)
!3018 = !DILocalVariable(name: "pkt_size", scope: !3002, file: !3, line: 1608, type: !59)
!3019 = !DILocalVariable(name: "tx_len", scope: !3020, file: !3, line: 1618, type: !59)
!3020 = distinct !DILexicalBlock(scope: !3002, file: !3, line: 1617, column: 8)
!3021 = !DILocalVariable(name: "txcsr", scope: !3022, file: !3, line: 1662, type: !59)
!3022 = distinct !DILexicalBlock(scope: !3020, file: !3, line: 1634, column: 19)
!3023 = !DILocation(line: 1598, column: 34, scope: !3002)
!3024 = !DILocation(line: 1598, column: 41, scope: !3002)
!3025 = !DILocation(line: 1598, column: 54, scope: !3002)
!3026 = !DILocation(line: 1598, column: 65, scope: !3002)
!3027 = !DILocation(line: 1598, column: 86, scope: !3002)
!3028 = !DILocation(line: 1598, column: 95, scope: !3002)
!3029 = !DILocation(line: 1598, column: 104, scope: !3002)
!3030 = !DILocation(line: 1600, column: 9, scope: !3002)
!3031 = !DILocation(line: 1601, column: 9, scope: !3002)
!3032 = !DILocation(line: 1602, column: 41, scope: !3002)
!3033 = !DILocation(line: 1602, column: 19, scope: !3002)
!3034 = !DILocation(line: 1602, column: 9, scope: !3002)
!3035 = !DILocation(line: 1603, column: 17, scope: !3036)
!3036 = distinct !DILexicalBlock(scope: !3002, file: !3, line: 1603, column: 9)
!3037 = !DILocation(line: 1603, column: 9, scope: !3002)
!3038 = !DILocation(line: 1606, column: 9, scope: !3002)
!3039 = !DILocation(line: 1607, column: 9, scope: !3002)
!3040 = !DILocation(line: 1609, column: 9, scope: !3041)
!3041 = distinct !DILexicalBlock(scope: !3002, file: !3, line: 1609, column: 9)
!3042 = !DILocation(line: 1609, column: 9, scope: !3002)
!3043 = !DILocation(line: 1610, column: 54, scope: !3044)
!3044 = distinct !DILexicalBlock(scope: !3041, file: !3, line: 1609, column: 26)
!3045 = !DILocation(line: 1610, column: 20, scope: !3044)
!3046 = !DILocation(line: 1608, column: 9, scope: !3002)
!3047 = !DILocation(line: 94, column: 12, scope: !189, inlinedAt: !3048)
!3048 = distinct !DILocation(line: 1611, column: 14, scope: !3044)
!3049 = !DILocation(line: 1611, column: 38, scope: !3044)
!3050 = !DILocation(line: 1611, column: 49, scope: !3044)
!3051 = !DILocation(line: 1611, column: 32, scope: !3044)
!3052 = !DILocation(line: 1612, column: 12, scope: !3044)
!3053 = !DILocation(line: 1613, column: 5, scope: !3044)
!3054 = distinct !{!3054, !3055, !3056}
!3055 = !DILocation(line: 1617, column: 5, scope: !3002)
!3056 = !DILocation(line: 1688, column: 17, scope: !3002)
!3057 = !DILocation(line: 94, column: 12, scope: !2118, inlinedAt: !3058)
!3058 = distinct !DILocation(line: 1614, column: 14, scope: !3059)
!3059 = distinct !DILexicalBlock(scope: !3041, file: !3, line: 1613, column: 12)
!3060 = !DILocation(line: 1614, column: 32, scope: !3059)
!3061 = !DILocation(line: 1618, column: 22, scope: !3020)
!3062 = !DILocation(line: 1618, column: 13, scope: !3020)
!3063 = !DILocation(line: 1619, column: 13, scope: !3064)
!3064 = distinct !DILexicalBlock(scope: !3020, file: !3, line: 1619, column: 13)
!3065 = !DILocation(line: 1619, column: 13, scope: !3020)
!3066 = !DILocation(line: 1620, column: 13, scope: !3067)
!3067 = distinct !DILexicalBlock(scope: !3064, file: !3, line: 1619, column: 18)
!3068 = !DILocation(line: 1621, column: 13, scope: !3067)
!3069 = !{i32 48541}
!3070 = !DILocation(line: 1622, column: 9, scope: !3067)
!3071 = !DILocation(line: 1623, column: 13, scope: !3020)
!3072 = !DILocation(line: 1624, column: 13, scope: !3073)
!3073 = distinct !DILexicalBlock(scope: !3074, file: !3, line: 1623, column: 22)
!3074 = distinct !DILexicalBlock(scope: !3020, file: !3, line: 1623, column: 13)
!3075 = !DILocation(line: 1625, column: 13, scope: !3073)
!3076 = !DILocation(line: 1626, column: 13, scope: !3073)
!3077 = !DILocation(line: 1627, column: 9, scope: !3073)
!3078 = !DILocation(line: 1629, column: 13, scope: !3079)
!3079 = distinct !DILexicalBlock(scope: !3074, file: !3, line: 1627, column: 16)
!3080 = !DILocation(line: 1630, column: 56, scope: !3079)
!3081 = !DILocation(line: 1630, column: 71, scope: !3079)
!3082 = !DILocation(line: 1630, column: 44, scope: !3079)
!3083 = !DILocation(line: 1630, column: 76, scope: !3079)
!3084 = !DILocation(line: 1630, column: 96, scope: !3079)
!3085 = !DILocation(line: 1630, column: 13, scope: !3079)
!3086 = !DILocation(line: 1631, column: 13, scope: !3079)
!3087 = !DILocation(line: 1632, column: 13, scope: !3079)
!3088 = !DILocation(line: 1607, column: 9, scope: !3089)
!3089 = !DILexicalBlockFile(scope: !3002, file: !3, discriminator: 1)
!3090 = !DILocation(line: 94, column: 12, scope: !2226, inlinedAt: !3091)
!3091 = distinct !DILocation(line: 1635, column: 17, scope: !3092)
!3092 = distinct !DILexicalBlock(scope: !3022, file: !3, line: 1635, column: 17)
!3093 = !DILocation(line: 1635, column: 17, scope: !3092)
!3094 = !DILocation(line: 1635, column: 17, scope: !3022)
!3095 = !DILocation(line: 1636, column: 26, scope: !3096)
!3096 = distinct !DILexicalBlock(scope: !3092, file: !3, line: 1635, column: 52)
!3097 = !DILocation(line: 1637, column: 30, scope: !3098)
!3098 = distinct !DILexicalBlock(scope: !3096, file: !3, line: 1637, column: 21)
!3099 = !DILocation(line: 1637, column: 21, scope: !3096)
!3100 = !DILocation(line: 1638, column: 21, scope: !3101)
!3101 = distinct !DILexicalBlock(scope: !3102, file: !3, line: 1638, column: 21)
!3102 = distinct !DILexicalBlock(scope: !3098, file: !3, line: 1637, column: 36)
!3103 = !DILocation(line: 1639, column: 21, scope: !3102)
!3104 = !DILocation(line: 1641, column: 21, scope: !3105)
!3105 = distinct !DILexicalBlock(scope: !3096, file: !3, line: 1641, column: 21)
!3106 = !DILocation(line: 1641, column: 21, scope: !3096)
!3107 = !DILocation(line: 1642, column: 32, scope: !3108)
!3108 = distinct !DILexicalBlock(scope: !3105, file: !3, line: 1641, column: 38)
!3109 = !DILocation(line: 94, column: 12, scope: !2377, inlinedAt: !3110)
!3110 = distinct !DILocation(line: 1643, column: 26, scope: !3108)
!3111 = !DILocation(line: 1643, column: 50, scope: !3108)
!3112 = !DILocation(line: 1643, column: 61, scope: !3108)
!3113 = !DILocation(line: 1643, column: 44, scope: !3108)
!3114 = !DILocation(line: 1644, column: 24, scope: !3108)
!3115 = !DILocation(line: 1645, column: 17, scope: !3108)
!3116 = !DILocation(line: 94, column: 12, scope: !3117, inlinedAt: !3118)
!3117 = !DILexicalBlockFile(scope: !189, file: !3, discriminator: 4)
!3118 = distinct !DILocation(line: 1646, column: 26, scope: !3119)
!3119 = distinct !DILexicalBlock(scope: !3105, file: !3, line: 1645, column: 24)
!3120 = !DILocation(line: 1646, column: 44, scope: !3119)
!3121 = !DILocation(line: 1648, column: 21, scope: !3122)
!3122 = distinct !DILexicalBlock(scope: !3096, file: !3, line: 1648, column: 21)
!3123 = !DILocation(line: 1649, column: 24, scope: !3124)
!3124 = distinct !DILexicalBlock(scope: !3122, file: !3, line: 1648, column: 43)
!3125 = !DILocation(line: 1648, column: 21, scope: !3096)
!3126 = !DILocation(line: 1653, column: 24, scope: !3127)
!3127 = distinct !DILexicalBlock(scope: !3096, file: !3, line: 1653, column: 21)
!3128 = !DILocation(line: 1653, column: 21, scope: !3096)
!3129 = !DILocation(line: 1657, column: 18, scope: !3130)
!3130 = distinct !DILexicalBlock(scope: !3022, file: !3, line: 1657, column: 17)
!3131 = !DILocation(line: 1657, column: 38, scope: !3130)
!3132 = !DILocation(line: 1657, column: 48, scope: !3130)
!3133 = !DILocation(line: 1657, column: 17, scope: !3022)
!3134 = !DILocation(line: 1658, column: 17, scope: !3135)
!3135 = distinct !DILexicalBlock(scope: !3136, file: !3, line: 1658, column: 17)
!3136 = distinct !DILexicalBlock(scope: !3130, file: !3, line: 1657, column: 54)
!3137 = !DILocation(line: 1659, column: 17, scope: !3136)
!3138 = !DILocation(line: 1662, column: 25, scope: !3022)
!3139 = !DILocation(line: 1662, column: 17, scope: !3022)
!3140 = !DILocation(line: 1663, column: 23, scope: !3141)
!3141 = distinct !DILexicalBlock(scope: !3022, file: !3, line: 1663, column: 17)
!3142 = !DILocation(line: 1663, column: 17, scope: !3022)
!3143 = !DILocation(line: 1664, column: 23, scope: !3144)
!3144 = distinct !DILexicalBlock(scope: !3141, file: !3, line: 1663, column: 37)
!3145 = !DILocation(line: 1665, column: 17, scope: !3144)
!3146 = !DILocation(line: 1666, column: 17, scope: !3144)
!3147 = !DILocation(line: 1667, column: 30, scope: !3148)
!3148 = distinct !DILexicalBlock(scope: !3141, file: !3, line: 1667, column: 24)
!3149 = !DILocation(line: 1667, column: 24, scope: !3141)
!3150 = !DILocation(line: 1668, column: 23, scope: !3151)
!3151 = distinct !DILexicalBlock(scope: !3148, file: !3, line: 1667, column: 48)
!3152 = !DILocation(line: 1669, column: 17, scope: !3151)
!3153 = !DILocation(line: 1670, column: 17, scope: !3154)
!3154 = distinct !DILexicalBlock(scope: !3151, file: !3, line: 1670, column: 17)
!3155 = !DILocation(line: 1672, column: 30, scope: !3156)
!3156 = distinct !DILexicalBlock(scope: !3148, file: !3, line: 1672, column: 24)
!3157 = !DILocation(line: 1672, column: 24, scope: !3148)
!3158 = !DILocation(line: 1673, column: 23, scope: !3159)
!3159 = distinct !DILexicalBlock(scope: !3156, file: !3, line: 1672, column: 46)
!3160 = !DILocation(line: 1674, column: 17, scope: !3159)
!3161 = !DILocation(line: 1675, column: 17, scope: !3162)
!3162 = distinct !DILexicalBlock(scope: !3159, file: !3, line: 1675, column: 17)
!3163 = !DILocation(line: 1676, column: 17, scope: !3159)
!3164 = !DILocation(line: 1677, column: 32, scope: !3165)
!3165 = distinct !DILexicalBlock(scope: !3156, file: !3, line: 1677, column: 24)
!3166 = !DILocation(line: 1677, column: 24, scope: !3156)
!3167 = distinct !{!3167, !3168, !3169}
!3168 = !DILocation(line: 1634, column: 9, scope: !3020)
!3169 = !DILocation(line: 1687, column: 9, scope: !3020)
!3170 = !DILocation(line: 1680, column: 25, scope: !3171)
!3171 = distinct !DILexicalBlock(scope: !3172, file: !3, line: 1679, column: 26)
!3172 = distinct !DILexicalBlock(scope: !3173, file: !3, line: 1679, column: 21)
!3173 = distinct !DILexicalBlock(scope: !3165, file: !3, line: 1677, column: 52)
!3174 = !DILocation(line: 1679, column: 21, scope: !3173)
!3175 = !DILocation(line: 1682, column: 21, scope: !3173)
!3176 = !DILocation(line: 1683, column: 17, scope: !3173)
!3177 = !DILocation(line: 1688, column: 5, scope: !3178)
!3178 = !DILexicalBlockFile(scope: !3020, file: !3, discriminator: 3)
!3179 = !DILocation(line: 1690, column: 5, scope: !3002)
!3180 = !DILocation(line: 1691, column: 5, scope: !3002)
!3181 = !DILocation(line: 1692, column: 1, scope: !3089)
!3182 = distinct !DISubprogram(name: "usb0_h_ep_read_async", scope: !3, file: !3, line: 1693, type: !3183, isLocal: false, isDefinition: true, scopeLine: 1694, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !3185)
!3183 = !DISubroutineType(types: !3184)
!3184 = !{!2888, !201, !52, !52, !51, !59, !59, !59}
!3185 = !{!3186, !3187, !3188, !3189, !3190, !3191, !3192, !3193, !3194, !3197, !3201}
!3186 = !DILocalVariable(name: "id", arg: 1, scope: !3182, file: !3, line: 1693, type: !201)
!3187 = !DILocalVariable(name: "host_ep", arg: 2, scope: !3182, file: !3, line: 1693, type: !52)
!3188 = !DILocalVariable(name: "target_ep", arg: 3, scope: !3182, file: !3, line: 1693, type: !52)
!3189 = !DILocalVariable(name: "ptr", arg: 4, scope: !3182, file: !3, line: 1693, type: !51)
!3190 = !DILocalVariable(name: "len", arg: 5, scope: !3182, file: !3, line: 1693, type: !59)
!3191 = !DILocalVariable(name: "xfer", arg: 6, scope: !3182, file: !3, line: 1693, type: !59)
!3192 = !DILocalVariable(name: "kstart", arg: 7, scope: !3182, file: !3, line: 1693, type: !59)
!3193 = !DILocalVariable(name: "rx_len", scope: !3182, file: !3, line: 1695, type: !2888)
!3194 = !DILocalVariable(name: "rx_addr", scope: !3195, file: !3, line: 1697, type: !61)
!3195 = distinct !DILexicalBlock(scope: !3196, file: !3, line: 1696, column: 17)
!3196 = distinct !DILexicalBlock(scope: !3182, file: !3, line: 1696, column: 9)
!3197 = !DILocalVariable(name: "rx_addr", scope: !3198, file: !3, line: 1714, type: !61)
!3198 = distinct !DILexicalBlock(scope: !3199, file: !3, line: 1713, column: 22)
!3199 = distinct !DILexicalBlock(scope: !3200, file: !3, line: 1713, column: 13)
!3200 = distinct !DILexicalBlock(scope: !3196, file: !3, line: 1712, column: 12)
!3201 = !DILocalVariable(name: "reg", scope: !3198, file: !3, line: 1717, type: !59)
!3202 = !DILocation(line: 1693, column: 40, scope: !3182)
!3203 = !DILocation(line: 1693, column: 47, scope: !3182)
!3204 = !DILocation(line: 1693, column: 60, scope: !3182)
!3205 = !DILocation(line: 1693, column: 75, scope: !3182)
!3206 = !DILocation(line: 1693, column: 84, scope: !3182)
!3207 = !DILocation(line: 1693, column: 93, scope: !3182)
!3208 = !DILocation(line: 1693, column: 103, scope: !3182)
!3209 = !DILocation(line: 1695, column: 9, scope: !3182)
!3210 = !DILocation(line: 1696, column: 9, scope: !3196)
!3211 = !DILocation(line: 1714, column: 29, scope: !3198)
!3212 = !DILocation(line: 1696, column: 9, scope: !3182)
!3213 = !DILocation(line: 1697, column: 15, scope: !3195)
!3214 = !DILocation(line: 1698, column: 21, scope: !3215)
!3215 = distinct !DILexicalBlock(scope: !3195, file: !3, line: 1698, column: 13)
!3216 = !DILocation(line: 1698, column: 13, scope: !3195)
!3217 = !DILocation(line: 1701, column: 14, scope: !3218)
!3218 = distinct !DILexicalBlock(scope: !3195, file: !3, line: 1701, column: 13)
!3219 = !DILocation(line: 1701, column: 34, scope: !3218)
!3220 = !DILocation(line: 1701, column: 44, scope: !3218)
!3221 = !DILocation(line: 1701, column: 13, scope: !3195)
!3222 = !DILocation(line: 1702, column: 13, scope: !3223)
!3223 = distinct !DILexicalBlock(scope: !3224, file: !3, line: 1702, column: 13)
!3224 = distinct !DILexicalBlock(scope: !3218, file: !3, line: 1701, column: 50)
!3225 = !DILocation(line: 1703, column: 13, scope: !3224)
!3226 = !DILocation(line: 1706, column: 9, scope: !3227)
!3227 = !DILexicalBlockFile(scope: !3228, file: !3, discriminator: 1)
!3228 = distinct !DILexicalBlock(scope: !3195, file: !3, line: 1706, column: 9)
!3229 = !DILocation(line: 1707, column: 9, scope: !3195)
!3230 = !DILocation(line: 1708, column: 47, scope: !3195)
!3231 = !DILocation(line: 1708, column: 55, scope: !3195)
!3232 = !DILocation(line: 1708, column: 53, scope: !3195)
!3233 = !DILocation(line: 1708, column: 9, scope: !3195)
!3234 = !DILocation(line: 1709, column: 9, scope: !3195)
!3235 = !DILocation(line: 1710, column: 9, scope: !3236)
!3236 = !DILexicalBlockFile(scope: !3237, file: !3, discriminator: 1)
!3237 = distinct !DILexicalBlock(scope: !3195, file: !3, line: 1710, column: 9)
!3238 = !DILocation(line: 1711, column: 9, scope: !3195)
!3239 = !DILocation(line: 1714, column: 19, scope: !3198)
!3240 = !DILocation(line: 1715, column: 13, scope: !3241)
!3241 = !DILexicalBlockFile(scope: !3242, file: !3, discriminator: 1)
!3242 = distinct !DILexicalBlock(scope: !3198, file: !3, line: 1715, column: 13)
!3243 = !DILocation(line: 1716, column: 13, scope: !3198)
!3244 = !DILocation(line: 1717, column: 23, scope: !3198)
!3245 = !DILocation(line: 1717, column: 17, scope: !3198)
!3246 = !DILocation(line: 1718, column: 21, scope: !3247)
!3247 = distinct !DILexicalBlock(scope: !3198, file: !3, line: 1718, column: 17)
!3248 = !DILocation(line: 1718, column: 17, scope: !3198)
!3249 = !DILocation(line: 1720, column: 26, scope: !3250)
!3250 = distinct !DILexicalBlock(scope: !3247, file: !3, line: 1718, column: 40)
!3251 = !DILocation(line: 1720, column: 62, scope: !3252)
!3252 = !DILexicalBlockFile(scope: !3250, file: !3, discriminator: 1)
!3253 = !DILocation(line: 1720, column: 95, scope: !3250)
!3254 = !DILocation(line: 1720, column: 59, scope: !3250)
!3255 = !DILocation(line: 1721, column: 26, scope: !3250)
!3256 = !DILocation(line: 1722, column: 21, scope: !3257)
!3257 = distinct !DILexicalBlock(scope: !3250, file: !3, line: 1722, column: 21)
!3258 = !DILocation(line: 1722, column: 21, scope: !3250)
!3259 = !DILocation(line: 1723, column: 21, scope: !3260)
!3260 = distinct !DILexicalBlock(scope: !3257, file: !3, line: 1722, column: 26)
!3261 = !{i32 52378}
!3262 = !DILocation(line: 1724, column: 21, scope: !3260)
!3263 = !DILocation(line: 1725, column: 17, scope: !3260)
!3264 = !DILocation(line: 1728, column: 28, scope: !3265)
!3265 = !DILexicalBlockFile(scope: !3266, file: !3, discriminator: 1)
!3266 = distinct !DILexicalBlock(scope: !3247, file: !3, line: 1728, column: 24)
!3267 = !DILocation(line: 1728, column: 24, scope: !3268)
!3268 = !DILexicalBlockFile(scope: !3247, file: !3, discriminator: 1)
!3269 = !DILocation(line: 1729, column: 17, scope: !3270)
!3270 = distinct !DILexicalBlock(scope: !3271, file: !3, line: 1729, column: 17)
!3271 = distinct !DILexicalBlock(scope: !3266, file: !3, line: 1728, column: 46)
!3272 = !DILocation(line: 1730, column: 22, scope: !3271)
!3273 = !DILocation(line: 1732, column: 13, scope: !3271)
!3274 = !DILocation(line: 1732, column: 28, scope: !3275)
!3275 = !DILexicalBlockFile(scope: !3276, file: !3, discriminator: 1)
!3276 = distinct !DILexicalBlock(scope: !3266, file: !3, line: 1732, column: 24)
!3277 = !DILocation(line: 1732, column: 24, scope: !3265)
!3278 = !DILocation(line: 1733, column: 17, scope: !3279)
!3279 = distinct !DILexicalBlock(scope: !3280, file: !3, line: 1733, column: 17)
!3280 = distinct !DILexicalBlock(scope: !3276, file: !3, line: 1732, column: 48)
!3281 = !DILocation(line: 1736, column: 13, scope: !3280)
!3282 = !DILocation(line: 1736, column: 28, scope: !3283)
!3283 = !DILexicalBlockFile(scope: !3284, file: !3, discriminator: 1)
!3284 = distinct !DILexicalBlock(scope: !3276, file: !3, line: 1736, column: 24)
!3285 = !DILocation(line: 1736, column: 24, scope: !3275)
!3286 = !DILocation(line: 1737, column: 17, scope: !3287)
!3287 = distinct !DILexicalBlock(scope: !3288, file: !3, line: 1737, column: 17)
!3288 = distinct !DILexicalBlock(scope: !3284, file: !3, line: 1736, column: 44)
!3289 = !DILocation(line: 1740, column: 13, scope: !3288)
!3290 = !DILocation(line: 1741, column: 13, scope: !3198)
!3291 = !DILocation(line: 1742, column: 13, scope: !3292)
!3292 = !DILexicalBlockFile(scope: !3293, file: !3, discriminator: 1)
!3293 = distinct !DILexicalBlock(scope: !3198, file: !3, line: 1742, column: 13)
!3294 = !DILocation(line: 1745, column: 5, scope: !3182)
!3295 = !DILocation(line: 1747, column: 1, scope: !3182)
!3296 = distinct !DISubprogram(name: "usb1_rx_err_handle", scope: !3, file: !3, line: 1749, type: !3297, isLocal: false, isDefinition: true, scopeLine: 1750, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !3299)
!3297 = !DISubroutineType(types: !3298)
!3298 = !{!2888, !2888}
!3299 = !{!3300}
!3300 = !DILocalVariable(name: "rxlen", arg: 1, scope: !3296, file: !3, line: 1749, type: !2888)
!3301 = !DILocation(line: 1749, column: 50, scope: !3296)
!3302 = !DILocation(line: 1752, column: 1, scope: !3296)
!3303 = distinct !DISubprogram(name: "usb1_h_ep_read_async", scope: !3, file: !3, line: 1754, type: !3183, isLocal: false, isDefinition: true, scopeLine: 1755, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !3304)
!3304 = !{!3305, !3306, !3307, !3308, !3309, !3310, !3311, !3312, !3313, !3316, !3320}
!3305 = !DILocalVariable(name: "id", arg: 1, scope: !3303, file: !3, line: 1754, type: !201)
!3306 = !DILocalVariable(name: "host_ep", arg: 2, scope: !3303, file: !3, line: 1754, type: !52)
!3307 = !DILocalVariable(name: "target_ep", arg: 3, scope: !3303, file: !3, line: 1754, type: !52)
!3308 = !DILocalVariable(name: "ptr", arg: 4, scope: !3303, file: !3, line: 1754, type: !51)
!3309 = !DILocalVariable(name: "len", arg: 5, scope: !3303, file: !3, line: 1754, type: !59)
!3310 = !DILocalVariable(name: "xfer", arg: 6, scope: !3303, file: !3, line: 1754, type: !59)
!3311 = !DILocalVariable(name: "kstart", arg: 7, scope: !3303, file: !3, line: 1754, type: !59)
!3312 = !DILocalVariable(name: "rx_len", scope: !3303, file: !3, line: 1756, type: !2888)
!3313 = !DILocalVariable(name: "rx_addr", scope: !3314, file: !3, line: 1758, type: !61)
!3314 = distinct !DILexicalBlock(scope: !3315, file: !3, line: 1757, column: 17)
!3315 = distinct !DILexicalBlock(scope: !3303, file: !3, line: 1757, column: 9)
!3316 = !DILocalVariable(name: "rx_addr", scope: !3317, file: !3, line: 1771, type: !61)
!3317 = distinct !DILexicalBlock(scope: !3318, file: !3, line: 1770, column: 22)
!3318 = distinct !DILexicalBlock(scope: !3319, file: !3, line: 1770, column: 13)
!3319 = distinct !DILexicalBlock(scope: !3315, file: !3, line: 1769, column: 12)
!3320 = !DILocalVariable(name: "reg", scope: !3317, file: !3, line: 1772, type: !59)
!3321 = !DILocation(line: 1754, column: 40, scope: !3303)
!3322 = !DILocation(line: 1754, column: 47, scope: !3303)
!3323 = !DILocation(line: 1754, column: 60, scope: !3303)
!3324 = !DILocation(line: 1754, column: 75, scope: !3303)
!3325 = !DILocation(line: 1754, column: 84, scope: !3303)
!3326 = !DILocation(line: 1754, column: 93, scope: !3303)
!3327 = !DILocation(line: 1754, column: 103, scope: !3303)
!3328 = !DILocation(line: 1756, column: 9, scope: !3303)
!3329 = !DILocation(line: 1757, column: 9, scope: !3315)
!3330 = !DILocation(line: 1771, column: 29, scope: !3317)
!3331 = !DILocation(line: 1757, column: 9, scope: !3303)
!3332 = !DILocation(line: 1758, column: 15, scope: !3314)
!3333 = !DILocation(line: 1759, column: 21, scope: !3334)
!3334 = distinct !DILexicalBlock(scope: !3314, file: !3, line: 1759, column: 13)
!3335 = !DILocation(line: 1759, column: 13, scope: !3314)
!3336 = !DILocation(line: 1762, column: 14, scope: !3337)
!3337 = distinct !DILexicalBlock(scope: !3314, file: !3, line: 1762, column: 13)
!3338 = !DILocation(line: 1762, column: 34, scope: !3337)
!3339 = !DILocation(line: 1762, column: 44, scope: !3337)
!3340 = !DILocation(line: 1762, column: 13, scope: !3314)
!3341 = !DILocation(line: 1763, column: 13, scope: !3342)
!3342 = distinct !DILexicalBlock(scope: !3343, file: !3, line: 1763, column: 13)
!3343 = distinct !DILexicalBlock(scope: !3337, file: !3, line: 1762, column: 50)
!3344 = !DILocation(line: 1764, column: 13, scope: !3343)
!3345 = !DILocation(line: 1766, column: 52, scope: !3314)
!3346 = !DILocation(line: 1766, column: 67, scope: !3314)
!3347 = !DILocation(line: 1766, column: 40, scope: !3314)
!3348 = !DILocation(line: 1766, column: 72, scope: !3314)
!3349 = !DILocation(line: 1766, column: 86, scope: !3314)
!3350 = !DILocation(line: 1766, column: 94, scope: !3314)
!3351 = !DILocation(line: 1766, column: 78, scope: !3314)
!3352 = !DILocation(line: 1766, column: 92, scope: !3314)
!3353 = !DILocation(line: 1766, column: 9, scope: !3314)
!3354 = !DILocation(line: 1767, column: 9, scope: !3314)
!3355 = !DILocation(line: 1768, column: 9, scope: !3314)
!3356 = !DILocation(line: 1771, column: 19, scope: !3317)
!3357 = !DILocation(line: 1772, column: 23, scope: !3317)
!3358 = !DILocation(line: 1772, column: 17, scope: !3317)
!3359 = !DILocation(line: 1773, column: 21, scope: !3360)
!3360 = distinct !DILexicalBlock(scope: !3317, file: !3, line: 1773, column: 17)
!3361 = !DILocation(line: 1773, column: 17, scope: !3317)
!3362 = !DILocation(line: 1774, column: 26, scope: !3363)
!3363 = distinct !DILexicalBlock(scope: !3360, file: !3, line: 1773, column: 40)
!3364 = !DILocation(line: 1776, column: 26, scope: !3363)
!3365 = !DILocation(line: 1777, column: 21, scope: !3366)
!3366 = distinct !DILexicalBlock(scope: !3363, file: !3, line: 1777, column: 21)
!3367 = !DILocation(line: 1777, column: 21, scope: !3363)
!3368 = !DILocation(line: 1778, column: 21, scope: !3369)
!3369 = distinct !DILexicalBlock(scope: !3366, file: !3, line: 1777, column: 26)
!3370 = !{i32 54388}
!3371 = !DILocation(line: 1779, column: 21, scope: !3369)
!3372 = !DILocation(line: 1780, column: 17, scope: !3369)
!3373 = !DILocation(line: 1782, column: 28, scope: !3374)
!3374 = !DILexicalBlockFile(scope: !3375, file: !3, discriminator: 1)
!3375 = distinct !DILexicalBlock(scope: !3360, file: !3, line: 1782, column: 24)
!3376 = !DILocation(line: 1782, column: 24, scope: !3377)
!3377 = !DILexicalBlockFile(scope: !3360, file: !3, discriminator: 1)
!3378 = !DILocation(line: 1783, column: 17, scope: !3379)
!3379 = distinct !DILexicalBlock(scope: !3380, file: !3, line: 1783, column: 17)
!3380 = distinct !DILexicalBlock(scope: !3375, file: !3, line: 1782, column: 46)
!3381 = !DILocation(line: 1784, column: 22, scope: !3380)
!3382 = !DILocation(line: 1786, column: 13, scope: !3380)
!3383 = !DILocation(line: 1786, column: 28, scope: !3384)
!3384 = !DILexicalBlockFile(scope: !3385, file: !3, discriminator: 1)
!3385 = distinct !DILexicalBlock(scope: !3375, file: !3, line: 1786, column: 24)
!3386 = !DILocation(line: 1786, column: 24, scope: !3374)
!3387 = !DILocation(line: 1787, column: 17, scope: !3388)
!3388 = distinct !DILexicalBlock(scope: !3389, file: !3, line: 1787, column: 17)
!3389 = distinct !DILexicalBlock(scope: !3385, file: !3, line: 1786, column: 48)
!3390 = !DILocation(line: 1790, column: 13, scope: !3389)
!3391 = !DILocation(line: 1790, column: 28, scope: !3392)
!3392 = !DILexicalBlockFile(scope: !3393, file: !3, discriminator: 1)
!3393 = distinct !DILexicalBlock(scope: !3385, file: !3, line: 1790, column: 24)
!3394 = !DILocation(line: 1790, column: 24, scope: !3384)
!3395 = !DILocation(line: 1791, column: 17, scope: !3396)
!3396 = distinct !DILexicalBlock(scope: !3397, file: !3, line: 1791, column: 17)
!3397 = distinct !DILexicalBlock(scope: !3393, file: !3, line: 1790, column: 44)
!3398 = !DILocation(line: 1794, column: 17, scope: !3397)
!3399 = !DILocation(line: 1795, column: 13, scope: !3397)
!3400 = !DILocation(line: 1796, column: 13, scope: !3317)
!3401 = !DILocation(line: 1799, column: 5, scope: !3303)
!3402 = !DILocation(line: 1801, column: 1, scope: !3303)
!3403 = distinct !DISubprogram(name: "usb_h_ep_read_async", scope: !3, file: !3, line: 1802, type: !3183, isLocal: false, isDefinition: true, scopeLine: 1803, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !3404)
!3404 = !{!3405, !3406, !3407, !3408, !3409, !3410, !3411}
!3405 = !DILocalVariable(name: "id", arg: 1, scope: !3403, file: !3, line: 1802, type: !201)
!3406 = !DILocalVariable(name: "host_ep", arg: 2, scope: !3403, file: !3, line: 1802, type: !52)
!3407 = !DILocalVariable(name: "target_ep", arg: 3, scope: !3403, file: !3, line: 1802, type: !52)
!3408 = !DILocalVariable(name: "ptr", arg: 4, scope: !3403, file: !3, line: 1802, type: !51)
!3409 = !DILocalVariable(name: "len", arg: 5, scope: !3403, file: !3, line: 1802, type: !59)
!3410 = !DILocalVariable(name: "xfer", arg: 6, scope: !3403, file: !3, line: 1802, type: !59)
!3411 = !DILocalVariable(name: "kstart", arg: 7, scope: !3403, file: !3, line: 1802, type: !59)
!3412 = !DILocation(line: 1802, column: 39, scope: !3403)
!3413 = !DILocation(line: 1802, column: 46, scope: !3403)
!3414 = !DILocation(line: 1802, column: 59, scope: !3403)
!3415 = !DILocation(line: 1802, column: 74, scope: !3403)
!3416 = !DILocation(line: 1802, column: 83, scope: !3403)
!3417 = !DILocation(line: 1802, column: 92, scope: !3403)
!3418 = !DILocation(line: 1802, column: 102, scope: !3403)
!3419 = !DILocation(line: 1804, column: 12, scope: !3420)
!3420 = distinct !DILexicalBlock(scope: !3403, file: !3, line: 1804, column: 9)
!3421 = !DILocation(line: 1804, column: 9, scope: !3403)
!3422 = !DILocation(line: 1805, column: 16, scope: !3423)
!3423 = distinct !DILexicalBlock(scope: !3420, file: !3, line: 1804, column: 18)
!3424 = !DILocation(line: 1805, column: 9, scope: !3423)
!3425 = !DILocation(line: 1807, column: 16, scope: !3426)
!3426 = distinct !DILexicalBlock(scope: !3420, file: !3, line: 1806, column: 12)
!3427 = !DILocation(line: 1807, column: 9, scope: !3426)
!3428 = !DILocation(line: 1809, column: 1, scope: !3403)
!3429 = distinct !DISubprogram(name: "usb1_h_ep_burst_read_async", scope: !3, file: !3, line: 1810, type: !3430, isLocal: false, isDefinition: true, scopeLine: 1819, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !3432)
!3430 = !DISubroutineType(types: !3431)
!3431 = !{!2888, !201, !52, !52, !59, !1387, !51, !59, !59, !59}
!3432 = !{!3433, !3434, !3435, !3436, !3437, !3438, !3439, !3440, !3441, !3442, !3443, !3446, !3448, !3449, !3450, !3451}
!3433 = !DILocalVariable(name: "id", arg: 1, scope: !3429, file: !3, line: 1810, type: !201)
!3434 = !DILocalVariable(name: "host_ep", arg: 2, scope: !3429, file: !3, line: 1811, type: !52)
!3435 = !DILocalVariable(name: "target_ep", arg: 3, scope: !3429, file: !3, line: 1812, type: !52)
!3436 = !DILocalVariable(name: "dma_cnt", arg: 4, scope: !3429, file: !3, line: 1813, type: !59)
!3437 = !DILocalVariable(name: "rx_len_table", arg: 5, scope: !3429, file: !3, line: 1814, type: !1387)
!3438 = !DILocalVariable(name: "ptr", arg: 6, scope: !3429, file: !3, line: 1815, type: !51)
!3439 = !DILocalVariable(name: "len", arg: 7, scope: !3429, file: !3, line: 1816, type: !59)
!3440 = !DILocalVariable(name: "xfer", arg: 8, scope: !3429, file: !3, line: 1817, type: !59)
!3441 = !DILocalVariable(name: "kstart", arg: 9, scope: !3429, file: !3, line: 1818, type: !59)
!3442 = !DILocalVariable(name: "rx_len", scope: !3429, file: !3, line: 1820, type: !2888)
!3443 = !DILocalVariable(name: "rx_addr", scope: !3444, file: !3, line: 1826, type: !61)
!3444 = distinct !DILexicalBlock(scope: !3445, file: !3, line: 1825, column: 17)
!3445 = distinct !DILexicalBlock(scope: !3429, file: !3, line: 1825, column: 9)
!3446 = !DILocalVariable(name: "rx_addr", scope: !3447, file: !3, line: 1838, type: !51)
!3447 = distinct !DILexicalBlock(scope: !3445, file: !3, line: 1837, column: 12)
!3448 = !DILocalVariable(name: "cur_rlen", scope: !3447, file: !3, line: 1839, type: !2888)
!3449 = !DILocalVariable(name: "iso_reg", scope: !3447, file: !3, line: 1840, type: !57)
!3450 = !DILocalVariable(name: "reg", scope: !3447, file: !3, line: 1841, type: !59)
!3451 = !DILocalVariable(name: "i", scope: !3452, file: !3, line: 1851, type: !2888)
!3452 = distinct !DILexicalBlock(scope: !3453, file: !3, line: 1851, column: 13)
!3453 = distinct !DILexicalBlock(scope: !3454, file: !3, line: 1848, column: 36)
!3454 = distinct !DILexicalBlock(scope: !3447, file: !3, line: 1848, column: 13)
!3455 = !DILocation(line: 1810, column: 46, scope: !3429)
!3456 = !DILocation(line: 1811, column: 35, scope: !3429)
!3457 = !DILocation(line: 1812, column: 35, scope: !3429)
!3458 = !DILocation(line: 1813, column: 36, scope: !3429)
!3459 = !DILocation(line: 1814, column: 37, scope: !3429)
!3460 = !DILocation(line: 1815, column: 36, scope: !3429)
!3461 = !DILocation(line: 1816, column: 36, scope: !3429)
!3462 = !DILocation(line: 1817, column: 36, scope: !3429)
!3463 = !DILocation(line: 1818, column: 36, scope: !3429)
!3464 = !DILocation(line: 1820, column: 9, scope: !3429)
!3465 = !DILocation(line: 1822, column: 9, scope: !3466)
!3466 = distinct !DILexicalBlock(scope: !3429, file: !3, line: 1822, column: 9)
!3467 = !DILocation(line: 1822, column: 22, scope: !3466)
!3468 = !DILocation(line: 1825, column: 9, scope: !3445)
!3469 = !DILocation(line: 1825, column: 9, scope: !3429)
!3470 = !DILocation(line: 1826, column: 25, scope: !3444)
!3471 = !DILocation(line: 1826, column: 15, scope: !3444)
!3472 = !DILocation(line: 1827, column: 21, scope: !3473)
!3473 = distinct !DILexicalBlock(scope: !3444, file: !3, line: 1827, column: 13)
!3474 = !DILocation(line: 1827, column: 13, scope: !3444)
!3475 = !DILocation(line: 1830, column: 14, scope: !3476)
!3476 = distinct !DILexicalBlock(scope: !3444, file: !3, line: 1830, column: 13)
!3477 = !DILocation(line: 1830, column: 34, scope: !3476)
!3478 = !DILocation(line: 1830, column: 44, scope: !3476)
!3479 = !DILocation(line: 1830, column: 13, scope: !3444)
!3480 = !DILocation(line: 1831, column: 13, scope: !3481)
!3481 = distinct !DILexicalBlock(scope: !3482, file: !3, line: 1831, column: 13)
!3482 = distinct !DILexicalBlock(scope: !3476, file: !3, line: 1830, column: 50)
!3483 = !DILocation(line: 1832, column: 13, scope: !3482)
!3484 = !DILocation(line: 1834, column: 52, scope: !3444)
!3485 = !DILocation(line: 1834, column: 67, scope: !3444)
!3486 = !DILocation(line: 1834, column: 40, scope: !3444)
!3487 = !DILocation(line: 1834, column: 72, scope: !3444)
!3488 = !DILocation(line: 1834, column: 86, scope: !3444)
!3489 = !DILocation(line: 1834, column: 94, scope: !3444)
!3490 = !DILocation(line: 1834, column: 78, scope: !3444)
!3491 = !DILocation(line: 1834, column: 92, scope: !3444)
!3492 = !DILocation(line: 1834, column: 9, scope: !3444)
!3493 = !DILocation(line: 1835, column: 9, scope: !3444)
!3494 = !DILocation(line: 1836, column: 9, scope: !3444)
!3495 = !DILocation(line: 1843, column: 14, scope: !3496)
!3496 = distinct !DILexicalBlock(scope: !3447, file: !3, line: 1843, column: 13)
!3497 = !DILocation(line: 1843, column: 38, scope: !3498)
!3498 = !DILexicalBlockFile(scope: !3496, file: !3, discriminator: 1)
!3499 = !DILocation(line: 1843, column: 22, scope: !3496)
!3500 = !DILocation(line: 1846, column: 27, scope: !3447)
!3501 = !DILocation(line: 1846, column: 61, scope: !3447)
!3502 = !DILocation(line: 1838, column: 13, scope: !3447)
!3503 = !DILocation(line: 1847, column: 15, scope: !3447)
!3504 = !DILocation(line: 1841, column: 13, scope: !3447)
!3505 = !DILocation(line: 1848, column: 17, scope: !3454)
!3506 = !DILocation(line: 1848, column: 13, scope: !3447)
!3507 = !DILocation(line: 1840, column: 23, scope: !3447)
!3508 = !DILocation(line: 1850, column: 32, scope: !3453)
!3509 = !DILocation(line: 1850, column: 21, scope: !3453)
!3510 = !DILocation(line: 1851, column: 22, scope: !3452)
!3511 = !DILocation(line: 1851, column: 18, scope: !3452)
!3512 = !DILocation(line: 1851, column: 31, scope: !3513)
!3513 = !DILexicalBlockFile(scope: !3514, file: !3, discriminator: 1)
!3514 = distinct !DILexicalBlock(scope: !3452, file: !3, line: 1851, column: 13)
!3515 = !DILocation(line: 1851, column: 13, scope: !3516)
!3516 = !DILexicalBlockFile(scope: !3452, file: !3, discriminator: 1)
!3517 = !DILocation(line: 1852, column: 17, scope: !3518)
!3518 = distinct !DILexicalBlock(scope: !3514, file: !3, line: 1851, column: 47)
!3519 = !DILocation(line: 1853, column: 17, scope: !3518)
!3520 = !DILocation(line: 1854, column: 17, scope: !3518)
!3521 = !DILocation(line: 1855, column: 17, scope: !3518)
!3522 = !DILocation(line: 1856, column: 17, scope: !3518)
!3523 = !DILocation(line: 1857, column: 17, scope: !3518)
!3524 = !DILocation(line: 1858, column: 36, scope: !3518)
!3525 = !DILocation(line: 1858, column: 45, scope: !3518)
!3526 = !DILocation(line: 1858, column: 51, scope: !3518)
!3527 = !DILocation(line: 1858, column: 17, scope: !3518)
!3528 = !DILocation(line: 1858, column: 33, scope: !3518)
!3529 = !DILocation(line: 1867, column: 28, scope: !3518)
!3530 = !DILocation(line: 1867, column: 28, scope: !3531)
!3531 = !DILexicalBlockFile(scope: !3518, file: !3, discriminator: 1)
!3532 = !DILocation(line: 1839, column: 13, scope: !3447)
!3533 = !DILocation(line: 1868, column: 21, scope: !3534)
!3534 = distinct !DILexicalBlock(scope: !3518, file: !3, line: 1868, column: 21)
!3535 = !DILocation(line: 1868, column: 21, scope: !3518)
!3536 = !DILocation(line: 1869, column: 21, scope: !3537)
!3537 = distinct !DILexicalBlock(scope: !3534, file: !3, line: 1868, column: 26)
!3538 = !DILocation(line: 1870, column: 25, scope: !3537)
!3539 = !DILocation(line: 1871, column: 17, scope: !3537)
!3540 = !DILocation(line: 1872, column: 27, scope: !3518)
!3541 = !DILocation(line: 1872, column: 24, scope: !3518)
!3542 = !DILocation(line: 1873, column: 45, scope: !3518)
!3543 = !DILocation(line: 1873, column: 54, scope: !3518)
!3544 = !DILocation(line: 1873, column: 25, scope: !3518)
!3545 = !DILocation(line: 1874, column: 21, scope: !3518)
!3546 = !DILocation(line: 1851, column: 43, scope: !3547)
!3547 = !DILexicalBlockFile(scope: !3514, file: !3, discriminator: 2)
!3548 = !DILocation(line: 1851, column: 13, scope: !3547)
!3549 = distinct !{!3549, !3550, !3551}
!3550 = !DILocation(line: 1851, column: 13, scope: !3452)
!3551 = !DILocation(line: 1875, column: 13, scope: !3452)
!3552 = !DILocation(line: 1877, column: 24, scope: !3553)
!3553 = !DILexicalBlockFile(scope: !3554, file: !3, discriminator: 1)
!3554 = distinct !DILexicalBlock(scope: !3454, file: !3, line: 1877, column: 20)
!3555 = !DILocation(line: 1877, column: 20, scope: !3556)
!3556 = !DILexicalBlockFile(scope: !3454, file: !3, discriminator: 1)
!3557 = !DILocation(line: 1878, column: 13, scope: !3558)
!3558 = distinct !DILexicalBlock(scope: !3559, file: !3, line: 1878, column: 13)
!3559 = distinct !DILexicalBlock(scope: !3554, file: !3, line: 1877, column: 42)
!3560 = !DILocation(line: 1879, column: 18, scope: !3559)
!3561 = !DILocation(line: 1881, column: 9, scope: !3559)
!3562 = !DILocation(line: 1881, column: 24, scope: !3563)
!3563 = !DILexicalBlockFile(scope: !3564, file: !3, discriminator: 1)
!3564 = distinct !DILexicalBlock(scope: !3554, file: !3, line: 1881, column: 20)
!3565 = !DILocation(line: 1881, column: 20, scope: !3553)
!3566 = !DILocation(line: 1882, column: 13, scope: !3567)
!3567 = distinct !DILexicalBlock(scope: !3568, file: !3, line: 1882, column: 13)
!3568 = distinct !DILexicalBlock(scope: !3564, file: !3, line: 1881, column: 44)
!3569 = !DILocation(line: 1885, column: 9, scope: !3568)
!3570 = !DILocation(line: 1885, column: 24, scope: !3571)
!3571 = !DILexicalBlockFile(scope: !3572, file: !3, discriminator: 1)
!3572 = distinct !DILexicalBlock(scope: !3564, file: !3, line: 1885, column: 20)
!3573 = !DILocation(line: 1885, column: 20, scope: !3563)
!3574 = !DILocation(line: 1886, column: 13, scope: !3575)
!3575 = distinct !DILexicalBlock(scope: !3576, file: !3, line: 1886, column: 13)
!3576 = distinct !DILexicalBlock(scope: !3572, file: !3, line: 1885, column: 40)
!3577 = !DILocation(line: 1889, column: 9, scope: !3576)
!3578 = !DILocation(line: 1890, column: 9, scope: !3447)
!3579 = distinct !DISubprogram(name: "usb_h_ep_burst_read_async", scope: !3, file: !3, line: 1894, type: !3430, isLocal: false, isDefinition: true, scopeLine: 1903, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !3580)
!3580 = !{!3581, !3582, !3583, !3584, !3585, !3586, !3587, !3588, !3589}
!3581 = !DILocalVariable(name: "id", arg: 1, scope: !3579, file: !3, line: 1894, type: !201)
!3582 = !DILocalVariable(name: "host_ep", arg: 2, scope: !3579, file: !3, line: 1895, type: !52)
!3583 = !DILocalVariable(name: "target_ep", arg: 3, scope: !3579, file: !3, line: 1896, type: !52)
!3584 = !DILocalVariable(name: "dma_cnt", arg: 4, scope: !3579, file: !3, line: 1897, type: !59)
!3585 = !DILocalVariable(name: "rx_len_table", arg: 5, scope: !3579, file: !3, line: 1898, type: !1387)
!3586 = !DILocalVariable(name: "ptr", arg: 6, scope: !3579, file: !3, line: 1899, type: !51)
!3587 = !DILocalVariable(name: "len", arg: 7, scope: !3579, file: !3, line: 1900, type: !59)
!3588 = !DILocalVariable(name: "xfer", arg: 8, scope: !3579, file: !3, line: 1901, type: !59)
!3589 = !DILocalVariable(name: "kstart", arg: 9, scope: !3579, file: !3, line: 1902, type: !59)
!3590 = !DILocation(line: 1894, column: 45, scope: !3579)
!3591 = !DILocation(line: 1895, column: 34, scope: !3579)
!3592 = !DILocation(line: 1896, column: 34, scope: !3579)
!3593 = !DILocation(line: 1897, column: 35, scope: !3579)
!3594 = !DILocation(line: 1898, column: 36, scope: !3579)
!3595 = !DILocation(line: 1899, column: 35, scope: !3579)
!3596 = !DILocation(line: 1900, column: 35, scope: !3579)
!3597 = !DILocation(line: 1901, column: 35, scope: !3579)
!3598 = !DILocation(line: 1902, column: 35, scope: !3579)
!3599 = !DILocation(line: 1904, column: 12, scope: !3600)
!3600 = distinct !DILexicalBlock(scope: !3579, file: !3, line: 1904, column: 9)
!3601 = !DILocation(line: 1904, column: 9, scope: !3579)
!3602 = !DILocation(line: 1905, column: 16, scope: !3603)
!3603 = distinct !DILexicalBlock(scope: !3600, file: !3, line: 1904, column: 18)
!3604 = !DILocation(line: 1905, column: 9, scope: !3603)
!3605 = !DILocation(line: 1908, column: 1, scope: !3579)
!3606 = distinct !DISubprogram(name: "usb0_h_ep_read", scope: !3, file: !3, line: 1909, type: !3607, isLocal: false, isDefinition: true, scopeLine: 1910, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !3609)
!3607 = !DISubroutineType(types: !3608)
!3608 = !{!2888, !201, !52, !55, !52, !51, !59, !59}
!3609 = !{!3610, !3611, !3612, !3613, !3614, !3615, !3616, !3617, !3618, !3619, !3620, !3621, !3622, !3623, !3624, !3625}
!3610 = !DILocalVariable(name: "id", arg: 1, scope: !3606, file: !3, line: 1909, type: !201)
!3611 = !DILocalVariable(name: "host_ep", arg: 2, scope: !3606, file: !3, line: 1909, type: !52)
!3612 = !DILocalVariable(name: "rxmaxp", arg: 3, scope: !3606, file: !3, line: 1909, type: !55)
!3613 = !DILocalVariable(name: "target_ep", arg: 4, scope: !3606, file: !3, line: 1909, type: !52)
!3614 = !DILocalVariable(name: "ptr", arg: 5, scope: !3606, file: !3, line: 1909, type: !51)
!3615 = !DILocalVariable(name: "len", arg: 6, scope: !3606, file: !3, line: 1909, type: !59)
!3616 = !DILocalVariable(name: "xfer", arg: 7, scope: !3606, file: !3, line: 1909, type: !59)
!3617 = !DILocalVariable(name: "_len", scope: !3606, file: !3, line: 1911, type: !59)
!3618 = !DILocalVariable(name: "rx_addr", scope: !3606, file: !3, line: 1912, type: !51)
!3619 = !DILocalVariable(name: "reg", scope: !3606, file: !3, line: 1913, type: !59)
!3620 = !DILocalVariable(name: "st", scope: !3606, file: !3, line: 1914, type: !59)
!3621 = !DILocalVariable(name: "is_dual_buf", scope: !3606, file: !3, line: 1915, type: !52)
!3622 = !DILocalVariable(name: "ot_times", scope: !3606, file: !3, line: 1923, type: !59)
!3623 = !DILocalVariable(name: "ot", scope: !3606, file: !3, line: 1924, type: !59)
!3624 = !DILocalVariable(name: "pkt_size", scope: !3606, file: !3, line: 1925, type: !59)
!3625 = !DILocalVariable(name: "rx_len", scope: !3626, file: !3, line: 1983, type: !59)
!3626 = distinct !DILexicalBlock(scope: !3627, file: !3, line: 1976, column: 36)
!3627 = distinct !DILexicalBlock(scope: !3628, file: !3, line: 1976, column: 13)
!3628 = distinct !DILexicalBlock(scope: !3606, file: !3, line: 1940, column: 17)
!3629 = !DILocation(line: 1909, column: 34, scope: !3606)
!3630 = !DILocation(line: 1909, column: 41, scope: !3606)
!3631 = !DILocation(line: 1909, column: 54, scope: !3606)
!3632 = !DILocation(line: 1909, column: 65, scope: !3606)
!3633 = !DILocation(line: 1909, column: 80, scope: !3606)
!3634 = !DILocation(line: 1909, column: 89, scope: !3606)
!3635 = !DILocation(line: 1909, column: 98, scope: !3606)
!3636 = !DILocation(line: 1911, column: 9, scope: !3606)
!3637 = !DILocation(line: 1914, column: 9, scope: !3606)
!3638 = !DILocation(line: 1915, column: 8, scope: !3606)
!3639 = !DILocation(line: 1917, column: 5, scope: !3640)
!3640 = !DILexicalBlockFile(scope: !3641, file: !3, discriminator: 1)
!3641 = distinct !DILexicalBlock(scope: !3606, file: !3, line: 1917, column: 5)
!3642 = !DILocation(line: 1918, column: 26, scope: !3606)
!3643 = !DILocation(line: 1918, column: 5, scope: !3606)
!3644 = !DILocation(line: 1919, column: 43, scope: !3606)
!3645 = !DILocation(line: 1919, column: 51, scope: !3606)
!3646 = !DILocation(line: 1919, column: 49, scope: !3606)
!3647 = !DILocation(line: 1919, column: 5, scope: !3606)
!3648 = !DILocation(line: 1920, column: 5, scope: !3606)
!3649 = !DILocation(line: 1921, column: 5, scope: !3650)
!3650 = !DILexicalBlockFile(scope: !3651, file: !3, discriminator: 1)
!3651 = distinct !DILexicalBlock(scope: !3606, file: !3, line: 1921, column: 5)
!3652 = !DILocation(line: 1923, column: 9, scope: !3606)
!3653 = !DILocation(line: 1924, column: 9, scope: !3606)
!3654 = !DILocation(line: 1926, column: 9, scope: !3655)
!3655 = distinct !DILexicalBlock(scope: !3606, file: !3, line: 1926, column: 9)
!3656 = !DILocation(line: 1926, column: 9, scope: !3606)
!3657 = !DILocation(line: 94, column: 12, scope: !189, inlinedAt: !3658)
!3658 = distinct !DILocation(line: 1931, column: 14, scope: !3659)
!3659 = distinct !DILexicalBlock(scope: !3655, file: !3, line: 1930, column: 12)
!3660 = !DILocation(line: 1931, column: 32, scope: !3659)
!3661 = !DILocation(line: 1933, column: 9, scope: !3606)
!3662 = !DILocation(line: 1927, column: 54, scope: !3663)
!3663 = distinct !DILexicalBlock(scope: !3655, file: !3, line: 1926, column: 26)
!3664 = !DILocation(line: 1927, column: 20, scope: !3663)
!3665 = !DILocation(line: 1925, column: 9, scope: !3606)
!3666 = !DILocation(line: 94, column: 12, scope: !2118, inlinedAt: !3667)
!3667 = distinct !DILocation(line: 1928, column: 14, scope: !3663)
!3668 = !DILocation(line: 1928, column: 38, scope: !3663)
!3669 = !DILocation(line: 1928, column: 49, scope: !3663)
!3670 = !DILocation(line: 1928, column: 32, scope: !3663)
!3671 = !DILocation(line: 1929, column: 12, scope: !3663)
!3672 = !DILocation(line: 1934, column: 13, scope: !3673)
!3673 = distinct !DILexicalBlock(scope: !3674, file: !3, line: 1934, column: 13)
!3674 = distinct !DILexicalBlock(scope: !3675, file: !3, line: 1933, column: 26)
!3675 = distinct !DILexicalBlock(scope: !3606, file: !3, line: 1933, column: 9)
!3676 = !DILocation(line: 1924, column: 9, scope: !3677)
!3677 = !DILexicalBlockFile(scope: !3606, file: !3, discriminator: 1)
!3678 = !DILocation(line: 1924, column: 9, scope: !3679)
!3679 = !DILexicalBlockFile(scope: !3606, file: !3, discriminator: 2)
!3680 = !DILocation(line: 1913, column: 9, scope: !3606)
!3681 = !DILocation(line: 1940, column: 5, scope: !3677)
!3682 = !DILocation(line: 94, column: 12, scope: !2226, inlinedAt: !3683)
!3683 = distinct !DILocation(line: 1941, column: 13, scope: !3684)
!3684 = distinct !DILexicalBlock(scope: !3628, file: !3, line: 1941, column: 13)
!3685 = !DILocation(line: 1941, column: 13, scope: !3684)
!3686 = !DILocation(line: 1941, column: 13, scope: !3628)
!3687 = !DILocation(line: 1942, column: 23, scope: !3688)
!3688 = distinct !DILexicalBlock(scope: !3684, file: !3, line: 1941, column: 48)
!3689 = !DILocation(line: 1943, column: 26, scope: !3690)
!3690 = distinct !DILexicalBlock(scope: !3688, file: !3, line: 1943, column: 17)
!3691 = !DILocation(line: 1943, column: 17, scope: !3688)
!3692 = !DILocation(line: 1944, column: 17, scope: !3693)
!3693 = distinct !DILexicalBlock(scope: !3694, file: !3, line: 1944, column: 17)
!3694 = distinct !DILexicalBlock(scope: !3690, file: !3, line: 1943, column: 32)
!3695 = !DILocation(line: 1945, column: 17, scope: !3694)
!3696 = !DILocation(line: 1947, column: 17, scope: !3697)
!3697 = distinct !DILexicalBlock(scope: !3688, file: !3, line: 1947, column: 17)
!3698 = !DILocation(line: 1947, column: 17, scope: !3688)
!3699 = !DILocation(line: 1948, column: 28, scope: !3700)
!3700 = distinct !DILexicalBlock(scope: !3697, file: !3, line: 1947, column: 34)
!3701 = !DILocation(line: 94, column: 12, scope: !2377, inlinedAt: !3702)
!3702 = distinct !DILocation(line: 1949, column: 22, scope: !3700)
!3703 = !DILocation(line: 1949, column: 46, scope: !3700)
!3704 = !DILocation(line: 1949, column: 57, scope: !3700)
!3705 = !DILocation(line: 1949, column: 40, scope: !3700)
!3706 = !DILocation(line: 1950, column: 20, scope: !3700)
!3707 = !DILocation(line: 1951, column: 13, scope: !3700)
!3708 = !DILocation(line: 94, column: 12, scope: !3117, inlinedAt: !3709)
!3709 = distinct !DILocation(line: 1952, column: 22, scope: !3710)
!3710 = distinct !DILexicalBlock(scope: !3697, file: !3, line: 1951, column: 20)
!3711 = !DILocation(line: 1952, column: 40, scope: !3710)
!3712 = !DILocation(line: 1954, column: 17, scope: !3713)
!3713 = distinct !DILexicalBlock(scope: !3688, file: !3, line: 1954, column: 17)
!3714 = !DILocation(line: 1955, column: 20, scope: !3715)
!3715 = distinct !DILexicalBlock(scope: !3713, file: !3, line: 1954, column: 39)
!3716 = !DILocation(line: 1954, column: 17, scope: !3688)
!3717 = !DILocation(line: 1959, column: 20, scope: !3718)
!3718 = distinct !DILexicalBlock(scope: !3688, file: !3, line: 1959, column: 17)
!3719 = !DILocation(line: 1959, column: 17, scope: !3688)
!3720 = !DILocation(line: 1962, column: 13, scope: !3721)
!3721 = distinct !DILexicalBlock(scope: !3688, file: !3, line: 1962, column: 13)
!3722 = !DILocation(line: 1963, column: 9, scope: !3688)
!3723 = !DILocation(line: 1965, column: 14, scope: !3724)
!3724 = distinct !DILexicalBlock(scope: !3628, file: !3, line: 1965, column: 13)
!3725 = !DILocation(line: 1965, column: 34, scope: !3724)
!3726 = !DILocation(line: 1965, column: 44, scope: !3724)
!3727 = !DILocation(line: 1965, column: 13, scope: !3628)
!3728 = !DILocation(line: 1966, column: 13, scope: !3729)
!3729 = distinct !DILexicalBlock(scope: !3730, file: !3, line: 1966, column: 13)
!3730 = distinct !DILexicalBlock(scope: !3724, file: !3, line: 1965, column: 50)
!3731 = !DILocation(line: 1967, column: 13, scope: !3730)
!3732 = !DILocation(line: 1973, column: 9, scope: !3733)
!3733 = !DILexicalBlockFile(scope: !3734, file: !3, discriminator: 1)
!3734 = distinct !DILexicalBlock(scope: !3628, file: !3, line: 1973, column: 9)
!3735 = !DILocation(line: 1974, column: 9, scope: !3628)
!3736 = !DILocation(line: 1975, column: 15, scope: !3628)
!3737 = !DILocation(line: 1976, column: 17, scope: !3627)
!3738 = !DILocation(line: 1976, column: 13, scope: !3628)
!3739 = !DILocation(line: 1977, column: 23, scope: !3626)
!3740 = !DILocation(line: 1912, column: 9, scope: !3606)
!3741 = !DILocation(line: 1978, column: 25, scope: !3742)
!3742 = distinct !DILexicalBlock(scope: !3626, file: !3, line: 1978, column: 17)
!3743 = !DILocation(line: 1978, column: 17, scope: !3626)
!3744 = !DILocation(line: 1979, column: 17, scope: !3745)
!3745 = !DILexicalBlockFile(scope: !3746, file: !3, discriminator: 1)
!3746 = distinct !DILexicalBlock(scope: !3747, file: !3, line: 1979, column: 17)
!3747 = distinct !DILexicalBlock(scope: !3742, file: !3, line: 1978, column: 34)
!3748 = !DILocation(line: 1980, column: 17, scope: !3747)
!3749 = !DILocation(line: 1983, column: 26, scope: !3626)
!3750 = !DILocation(line: 1983, column: 62, scope: !3751)
!3751 = !DILexicalBlockFile(scope: !3626, file: !3, discriminator: 1)
!3752 = !DILocation(line: 1983, column: 95, scope: !3626)
!3753 = !DILocation(line: 1983, column: 59, scope: !3626)
!3754 = !DILocation(line: 1983, column: 17, scope: !3626)
!3755 = !DILocation(line: 1984, column: 22, scope: !3626)
!3756 = !DILocation(line: 1985, column: 17, scope: !3626)
!3757 = !DILocation(line: 1986, column: 17, scope: !3626)
!3758 = !DILocation(line: 1987, column: 17, scope: !3759)
!3759 = distinct !DILexicalBlock(scope: !3760, file: !3, line: 1986, column: 30)
!3760 = distinct !DILexicalBlock(scope: !3626, file: !3, line: 1986, column: 17)
!3761 = !DILocation(line: 1988, column: 13, scope: !3759)
!3762 = !DILocation(line: 1989, column: 21, scope: !3763)
!3763 = distinct !DILexicalBlock(scope: !3626, file: !3, line: 1989, column: 17)
!3764 = !DILocation(line: 1989, column: 17, scope: !3626)
!3765 = !DILocation(line: 1990, column: 17, scope: !3766)
!3766 = distinct !DILexicalBlock(scope: !3763, file: !3, line: 1989, column: 30)
!3767 = !{i32 61772}
!3768 = !DILocation(line: 1991, column: 17, scope: !3766)
!3769 = !DILocation(line: 1992, column: 21, scope: !3766)
!3770 = !DILocation(line: 1993, column: 13, scope: !3766)
!3771 = !DILocation(line: 1994, column: 17, scope: !3626)
!3772 = !DILocation(line: 1995, column: 17, scope: !3773)
!3773 = distinct !DILexicalBlock(scope: !3774, file: !3, line: 1994, column: 31)
!3774 = distinct !DILexicalBlock(scope: !3626, file: !3, line: 1994, column: 17)
!3775 = !DILocation(line: 1996, column: 13, scope: !3773)
!3776 = !DILocation(line: 1997, column: 17, scope: !3777)
!3777 = distinct !DILexicalBlock(scope: !3626, file: !3, line: 1997, column: 17)
!3778 = !DILocation(line: 1997, column: 17, scope: !3626)
!3779 = !DILocation(line: 1998, column: 17, scope: !3780)
!3780 = distinct !DILexicalBlock(scope: !3777, file: !3, line: 1997, column: 22)
!3781 = !DILocation(line: 1999, column: 17, scope: !3780)
!3782 = !DILocation(line: 2000, column: 13, scope: !3780)
!3783 = !DILocation(line: 2001, column: 13, scope: !3784)
!3784 = !DILexicalBlockFile(scope: !3785, file: !3, discriminator: 1)
!3785 = distinct !DILexicalBlock(scope: !3626, file: !3, line: 2001, column: 13)
!3786 = !DILocation(line: 2003, column: 24, scope: !3787)
!3787 = !DILexicalBlockFile(scope: !3788, file: !3, discriminator: 1)
!3788 = distinct !DILexicalBlock(scope: !3627, file: !3, line: 2003, column: 20)
!3789 = !DILocation(line: 2003, column: 20, scope: !3790)
!3790 = !DILexicalBlockFile(scope: !3627, file: !3, discriminator: 1)
!3791 = !DILocation(line: 2004, column: 13, scope: !3792)
!3792 = distinct !DILexicalBlock(scope: !3793, file: !3, line: 2004, column: 13)
!3793 = distinct !DILexicalBlock(scope: !3788, file: !3, line: 2003, column: 42)
!3794 = !DILocation(line: 2005, column: 18, scope: !3793)
!3795 = !DILocation(line: 2006, column: 9, scope: !3793)
!3796 = !DILocation(line: 2006, column: 24, scope: !3797)
!3797 = !DILexicalBlockFile(scope: !3798, file: !3, discriminator: 1)
!3798 = distinct !DILexicalBlock(scope: !3788, file: !3, line: 2006, column: 20)
!3799 = !DILocation(line: 2006, column: 20, scope: !3787)
!3800 = !DILocation(line: 2007, column: 13, scope: !3801)
!3801 = distinct !DILexicalBlock(scope: !3802, file: !3, line: 2007, column: 13)
!3802 = distinct !DILexicalBlock(scope: !3798, file: !3, line: 2006, column: 44)
!3803 = !DILocation(line: 2010, column: 9, scope: !3802)
!3804 = !DILocation(line: 2010, column: 24, scope: !3805)
!3805 = !DILexicalBlockFile(scope: !3806, file: !3, discriminator: 1)
!3806 = distinct !DILexicalBlock(scope: !3798, file: !3, line: 2010, column: 20)
!3807 = !DILocation(line: 2010, column: 20, scope: !3797)
!3808 = !DILocation(line: 2011, column: 13, scope: !3809)
!3809 = distinct !DILexicalBlock(scope: !3810, file: !3, line: 2011, column: 13)
!3810 = distinct !DILexicalBlock(scope: !3806, file: !3, line: 2010, column: 40)
!3811 = !DILocation(line: 2015, column: 13, scope: !3812)
!3812 = !DILexicalBlockFile(scope: !3813, file: !3, discriminator: 1)
!3813 = distinct !DILexicalBlock(scope: !3814, file: !3, line: 2015, column: 13)
!3814 = distinct !DILexicalBlock(scope: !3806, file: !3, line: 2014, column: 16)
!3815 = !DILocation(line: 2016, column: 13, scope: !3814)
!3816 = distinct !{!3816, !3817, !3818}
!3817 = !DILocation(line: 1940, column: 5, scope: !3606)
!3818 = !DILocation(line: 2020, column: 5, scope: !3606)
!3819 = !DILocation(line: 2018, column: 45, scope: !3628)
!3820 = !DILocation(line: 2018, column: 9, scope: !3628)
!3821 = !DILocation(line: 2019, column: 9, scope: !3822)
!3822 = !DILexicalBlockFile(scope: !3823, file: !3, discriminator: 1)
!3823 = distinct !DILexicalBlock(scope: !3628, file: !3, line: 2019, column: 9)
!3824 = !DILocation(line: 2022, column: 1, scope: !3606)
!3825 = !DILocation(line: 2022, column: 1, scope: !3677)
!3826 = distinct !DISubprogram(name: "usb1_h_ep_read", scope: !3, file: !3, line: 2023, type: !3607, isLocal: false, isDefinition: true, scopeLine: 2024, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !3827)
!3827 = !{!3828, !3829, !3830, !3831, !3832, !3833, !3834, !3835, !3836, !3837, !3838, !3839, !3840, !3841, !3842, !3843}
!3828 = !DILocalVariable(name: "id", arg: 1, scope: !3826, file: !3, line: 2023, type: !201)
!3829 = !DILocalVariable(name: "host_ep", arg: 2, scope: !3826, file: !3, line: 2023, type: !52)
!3830 = !DILocalVariable(name: "rxmaxp", arg: 3, scope: !3826, file: !3, line: 2023, type: !55)
!3831 = !DILocalVariable(name: "target_ep", arg: 4, scope: !3826, file: !3, line: 2023, type: !52)
!3832 = !DILocalVariable(name: "ptr", arg: 5, scope: !3826, file: !3, line: 2023, type: !51)
!3833 = !DILocalVariable(name: "len", arg: 6, scope: !3826, file: !3, line: 2023, type: !59)
!3834 = !DILocalVariable(name: "xfer", arg: 7, scope: !3826, file: !3, line: 2023, type: !59)
!3835 = !DILocalVariable(name: "_len", scope: !3826, file: !3, line: 2025, type: !59)
!3836 = !DILocalVariable(name: "rx_addr", scope: !3826, file: !3, line: 2026, type: !51)
!3837 = !DILocalVariable(name: "reg", scope: !3826, file: !3, line: 2027, type: !59)
!3838 = !DILocalVariable(name: "st", scope: !3826, file: !3, line: 2028, type: !59)
!3839 = !DILocalVariable(name: "is_dual_buf", scope: !3826, file: !3, line: 2029, type: !52)
!3840 = !DILocalVariable(name: "ot_times", scope: !3826, file: !3, line: 2035, type: !59)
!3841 = !DILocalVariable(name: "ot", scope: !3826, file: !3, line: 2036, type: !59)
!3842 = !DILocalVariable(name: "pkt_size", scope: !3826, file: !3, line: 2037, type: !59)
!3843 = !DILocalVariable(name: "rx_len", scope: !3844, file: !3, line: 2090, type: !59)
!3844 = distinct !DILexicalBlock(scope: !3845, file: !3, line: 2084, column: 36)
!3845 = distinct !DILexicalBlock(scope: !3846, file: !3, line: 2084, column: 13)
!3846 = distinct !DILexicalBlock(scope: !3826, file: !3, line: 2052, column: 17)
!3847 = !DILocation(line: 2023, column: 34, scope: !3826)
!3848 = !DILocation(line: 2023, column: 41, scope: !3826)
!3849 = !DILocation(line: 2023, column: 54, scope: !3826)
!3850 = !DILocation(line: 2023, column: 65, scope: !3826)
!3851 = !DILocation(line: 2023, column: 80, scope: !3826)
!3852 = !DILocation(line: 2023, column: 89, scope: !3826)
!3853 = !DILocation(line: 2023, column: 98, scope: !3826)
!3854 = !DILocation(line: 2025, column: 9, scope: !3826)
!3855 = !DILocation(line: 2028, column: 9, scope: !3826)
!3856 = !DILocation(line: 2029, column: 8, scope: !3826)
!3857 = !DILocation(line: 2032, column: 26, scope: !3826)
!3858 = !DILocation(line: 2032, column: 48, scope: !3826)
!3859 = !DILocation(line: 2032, column: 63, scope: !3826)
!3860 = !DILocation(line: 2032, column: 36, scope: !3826)
!3861 = !DILocation(line: 2032, column: 68, scope: !3826)
!3862 = !DILocation(line: 2032, column: 82, scope: !3826)
!3863 = !DILocation(line: 2032, column: 90, scope: !3826)
!3864 = !DILocation(line: 2032, column: 74, scope: !3826)
!3865 = !DILocation(line: 2032, column: 88, scope: !3826)
!3866 = !DILocation(line: 2032, column: 5, scope: !3826)
!3867 = !DILocation(line: 2033, column: 5, scope: !3826)
!3868 = !DILocation(line: 2035, column: 9, scope: !3826)
!3869 = !DILocation(line: 2036, column: 9, scope: !3826)
!3870 = !DILocation(line: 2038, column: 9, scope: !3871)
!3871 = distinct !DILexicalBlock(scope: !3826, file: !3, line: 2038, column: 9)
!3872 = !DILocation(line: 2038, column: 9, scope: !3826)
!3873 = !DILocation(line: 94, column: 12, scope: !189, inlinedAt: !3874)
!3874 = distinct !DILocation(line: 2043, column: 14, scope: !3875)
!3875 = distinct !DILexicalBlock(scope: !3871, file: !3, line: 2042, column: 12)
!3876 = !DILocation(line: 2043, column: 32, scope: !3875)
!3877 = !DILocation(line: 2045, column: 9, scope: !3826)
!3878 = !DILocation(line: 2039, column: 54, scope: !3879)
!3879 = distinct !DILexicalBlock(scope: !3871, file: !3, line: 2038, column: 26)
!3880 = !DILocation(line: 2039, column: 20, scope: !3879)
!3881 = !DILocation(line: 2037, column: 9, scope: !3826)
!3882 = !DILocation(line: 94, column: 12, scope: !2118, inlinedAt: !3883)
!3883 = distinct !DILocation(line: 2040, column: 14, scope: !3879)
!3884 = !DILocation(line: 2040, column: 38, scope: !3879)
!3885 = !DILocation(line: 2040, column: 49, scope: !3879)
!3886 = !DILocation(line: 2040, column: 32, scope: !3879)
!3887 = !DILocation(line: 2041, column: 12, scope: !3879)
!3888 = !DILocation(line: 2046, column: 13, scope: !3889)
!3889 = distinct !DILexicalBlock(scope: !3890, file: !3, line: 2046, column: 13)
!3890 = distinct !DILexicalBlock(scope: !3891, file: !3, line: 2045, column: 26)
!3891 = distinct !DILexicalBlock(scope: !3826, file: !3, line: 2045, column: 9)
!3892 = !DILocation(line: 2036, column: 9, scope: !3893)
!3893 = !DILexicalBlockFile(scope: !3826, file: !3, discriminator: 1)
!3894 = !DILocation(line: 2036, column: 9, scope: !3895)
!3895 = !DILexicalBlockFile(scope: !3826, file: !3, discriminator: 2)
!3896 = !DILocation(line: 2027, column: 9, scope: !3826)
!3897 = !DILocation(line: 2052, column: 5, scope: !3893)
!3898 = !DILocation(line: 94, column: 12, scope: !2226, inlinedAt: !3899)
!3899 = distinct !DILocation(line: 2053, column: 13, scope: !3900)
!3900 = distinct !DILexicalBlock(scope: !3846, file: !3, line: 2053, column: 13)
!3901 = !DILocation(line: 2053, column: 13, scope: !3900)
!3902 = !DILocation(line: 2053, column: 13, scope: !3846)
!3903 = !DILocation(line: 2054, column: 23, scope: !3904)
!3904 = distinct !DILexicalBlock(scope: !3900, file: !3, line: 2053, column: 48)
!3905 = !DILocation(line: 2055, column: 26, scope: !3906)
!3906 = distinct !DILexicalBlock(scope: !3904, file: !3, line: 2055, column: 17)
!3907 = !DILocation(line: 2055, column: 17, scope: !3904)
!3908 = !DILocation(line: 2056, column: 17, scope: !3909)
!3909 = distinct !DILexicalBlock(scope: !3910, file: !3, line: 2056, column: 17)
!3910 = distinct !DILexicalBlock(scope: !3906, file: !3, line: 2055, column: 32)
!3911 = !DILocation(line: 2057, column: 17, scope: !3910)
!3912 = !DILocation(line: 2059, column: 17, scope: !3913)
!3913 = distinct !DILexicalBlock(scope: !3904, file: !3, line: 2059, column: 17)
!3914 = !DILocation(line: 2059, column: 17, scope: !3904)
!3915 = !DILocation(line: 2060, column: 28, scope: !3916)
!3916 = distinct !DILexicalBlock(scope: !3913, file: !3, line: 2059, column: 34)
!3917 = !DILocation(line: 94, column: 12, scope: !2377, inlinedAt: !3918)
!3918 = distinct !DILocation(line: 2061, column: 22, scope: !3916)
!3919 = !DILocation(line: 2061, column: 46, scope: !3916)
!3920 = !DILocation(line: 2061, column: 57, scope: !3916)
!3921 = !DILocation(line: 2061, column: 40, scope: !3916)
!3922 = !DILocation(line: 2062, column: 20, scope: !3916)
!3923 = !DILocation(line: 2063, column: 13, scope: !3916)
!3924 = !DILocation(line: 94, column: 12, scope: !3117, inlinedAt: !3925)
!3925 = distinct !DILocation(line: 2064, column: 22, scope: !3926)
!3926 = distinct !DILexicalBlock(scope: !3913, file: !3, line: 2063, column: 20)
!3927 = !DILocation(line: 2064, column: 40, scope: !3926)
!3928 = !DILocation(line: 2066, column: 17, scope: !3929)
!3929 = distinct !DILexicalBlock(scope: !3904, file: !3, line: 2066, column: 17)
!3930 = !DILocation(line: 2067, column: 20, scope: !3931)
!3931 = distinct !DILexicalBlock(scope: !3929, file: !3, line: 2066, column: 39)
!3932 = !DILocation(line: 2066, column: 17, scope: !3904)
!3933 = !DILocation(line: 2071, column: 20, scope: !3934)
!3934 = distinct !DILexicalBlock(scope: !3904, file: !3, line: 2071, column: 17)
!3935 = !DILocation(line: 2071, column: 17, scope: !3904)
!3936 = !DILocation(line: 2074, column: 13, scope: !3937)
!3937 = distinct !DILexicalBlock(scope: !3904, file: !3, line: 2074, column: 13)
!3938 = !DILocation(line: 2075, column: 9, scope: !3904)
!3939 = !DILocation(line: 2077, column: 14, scope: !3940)
!3940 = distinct !DILexicalBlock(scope: !3846, file: !3, line: 2077, column: 13)
!3941 = !DILocation(line: 2077, column: 34, scope: !3940)
!3942 = !DILocation(line: 2077, column: 44, scope: !3940)
!3943 = !DILocation(line: 2077, column: 13, scope: !3846)
!3944 = !DILocation(line: 2078, column: 13, scope: !3945)
!3945 = distinct !DILexicalBlock(scope: !3946, file: !3, line: 2078, column: 13)
!3946 = distinct !DILexicalBlock(scope: !3940, file: !3, line: 2077, column: 50)
!3947 = !DILocation(line: 2079, column: 13, scope: !3946)
!3948 = !DILocation(line: 2083, column: 15, scope: !3846)
!3949 = !DILocation(line: 2084, column: 17, scope: !3845)
!3950 = !DILocation(line: 2084, column: 13, scope: !3846)
!3951 = !DILocation(line: 2085, column: 23, scope: !3844)
!3952 = !DILocation(line: 2026, column: 9, scope: !3826)
!3953 = !DILocation(line: 2086, column: 25, scope: !3954)
!3954 = distinct !DILexicalBlock(scope: !3844, file: !3, line: 2086, column: 17)
!3955 = !DILocation(line: 2086, column: 17, scope: !3844)
!3956 = !DILocation(line: 2090, column: 26, scope: !3844)
!3957 = !DILocation(line: 2090, column: 17, scope: !3844)
!3958 = !DILocation(line: 2091, column: 22, scope: !3844)
!3959 = !DILocation(line: 2092, column: 17, scope: !3844)
!3960 = !DILocation(line: 2093, column: 17, scope: !3844)
!3961 = !DILocation(line: 2094, column: 17, scope: !3962)
!3962 = distinct !DILexicalBlock(scope: !3963, file: !3, line: 2093, column: 30)
!3963 = distinct !DILexicalBlock(scope: !3844, file: !3, line: 2093, column: 17)
!3964 = !DILocation(line: 2095, column: 13, scope: !3962)
!3965 = !DILocation(line: 2096, column: 21, scope: !3966)
!3966 = distinct !DILexicalBlock(scope: !3844, file: !3, line: 2096, column: 17)
!3967 = !DILocation(line: 2096, column: 17, scope: !3844)
!3968 = !DILocation(line: 2097, column: 17, scope: !3969)
!3969 = distinct !DILexicalBlock(scope: !3966, file: !3, line: 2096, column: 30)
!3970 = !{i32 65241}
!3971 = !DILocation(line: 2098, column: 17, scope: !3969)
!3972 = !DILocation(line: 2099, column: 21, scope: !3969)
!3973 = !DILocation(line: 2100, column: 13, scope: !3969)
!3974 = !DILocation(line: 2101, column: 17, scope: !3844)
!3975 = !DILocation(line: 2102, column: 17, scope: !3976)
!3976 = distinct !DILexicalBlock(scope: !3977, file: !3, line: 2101, column: 31)
!3977 = distinct !DILexicalBlock(scope: !3844, file: !3, line: 2101, column: 17)
!3978 = !DILocation(line: 2103, column: 13, scope: !3976)
!3979 = !DILocation(line: 2104, column: 17, scope: !3980)
!3980 = distinct !DILexicalBlock(scope: !3844, file: !3, line: 2104, column: 17)
!3981 = !DILocation(line: 2104, column: 17, scope: !3844)
!3982 = !DILocation(line: 2105, column: 60, scope: !3983)
!3983 = distinct !DILexicalBlock(scope: !3980, file: !3, line: 2104, column: 22)
!3984 = !DILocation(line: 2105, column: 75, scope: !3983)
!3985 = !DILocation(line: 2105, column: 48, scope: !3983)
!3986 = !DILocation(line: 2105, column: 80, scope: !3983)
!3987 = !DILocation(line: 2105, column: 100, scope: !3983)
!3988 = !DILocation(line: 2105, column: 17, scope: !3983)
!3989 = !DILocation(line: 2106, column: 17, scope: !3983)
!3990 = !DILocation(line: 2107, column: 13, scope: !3983)
!3991 = !DILocation(line: 2109, column: 24, scope: !3992)
!3992 = !DILexicalBlockFile(scope: !3993, file: !3, discriminator: 1)
!3993 = distinct !DILexicalBlock(scope: !3845, file: !3, line: 2109, column: 20)
!3994 = !DILocation(line: 2109, column: 20, scope: !3995)
!3995 = !DILexicalBlockFile(scope: !3845, file: !3, discriminator: 1)
!3996 = !DILocation(line: 2110, column: 13, scope: !3997)
!3997 = distinct !DILexicalBlock(scope: !3998, file: !3, line: 2110, column: 13)
!3998 = distinct !DILexicalBlock(scope: !3993, file: !3, line: 2109, column: 42)
!3999 = !DILocation(line: 2111, column: 18, scope: !3998)
!4000 = !DILocation(line: 2112, column: 9, scope: !3998)
!4001 = !DILocation(line: 2112, column: 24, scope: !4002)
!4002 = !DILexicalBlockFile(scope: !4003, file: !3, discriminator: 1)
!4003 = distinct !DILexicalBlock(scope: !3993, file: !3, line: 2112, column: 20)
!4004 = !DILocation(line: 2112, column: 20, scope: !3992)
!4005 = !DILocation(line: 2113, column: 13, scope: !4006)
!4006 = distinct !DILexicalBlock(scope: !4007, file: !3, line: 2113, column: 13)
!4007 = distinct !DILexicalBlock(scope: !4003, file: !3, line: 2112, column: 44)
!4008 = !DILocation(line: 2116, column: 9, scope: !4007)
!4009 = !DILocation(line: 2116, column: 24, scope: !4010)
!4010 = !DILexicalBlockFile(scope: !4011, file: !3, discriminator: 1)
!4011 = distinct !DILexicalBlock(scope: !4003, file: !3, line: 2116, column: 20)
!4012 = !DILocation(line: 2116, column: 20, scope: !4002)
!4013 = distinct !{!4013, !4014, !4015}
!4014 = !DILocation(line: 2052, column: 5, scope: !3826)
!4015 = !DILocation(line: 2124, column: 5, scope: !3826)
!4016 = !DILocation(line: 2117, column: 13, scope: !4017)
!4017 = distinct !DILexicalBlock(scope: !4018, file: !3, line: 2117, column: 13)
!4018 = distinct !DILexicalBlock(scope: !4011, file: !3, line: 2116, column: 40)
!4019 = !DILocation(line: 2123, column: 9, scope: !3846)
!4020 = !DILocation(line: 2126, column: 1, scope: !3826)
!4021 = !DILocation(line: 2126, column: 1, scope: !3893)
!4022 = !DILocation(line: 2126, column: 1, scope: !3895)
!4023 = distinct !DISubprogram(name: "usb_h_ep_read", scope: !3, file: !3, line: 2127, type: !3607, isLocal: false, isDefinition: true, scopeLine: 2128, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4024)
!4024 = !{!4025, !4026, !4027, !4028, !4029, !4030, !4031}
!4025 = !DILocalVariable(name: "id", arg: 1, scope: !4023, file: !3, line: 2127, type: !201)
!4026 = !DILocalVariable(name: "host_ep", arg: 2, scope: !4023, file: !3, line: 2127, type: !52)
!4027 = !DILocalVariable(name: "rxmaxp", arg: 3, scope: !4023, file: !3, line: 2127, type: !55)
!4028 = !DILocalVariable(name: "target_ep", arg: 4, scope: !4023, file: !3, line: 2127, type: !52)
!4029 = !DILocalVariable(name: "ptr", arg: 5, scope: !4023, file: !3, line: 2127, type: !51)
!4030 = !DILocalVariable(name: "len", arg: 6, scope: !4023, file: !3, line: 2127, type: !59)
!4031 = !DILocalVariable(name: "xfer", arg: 7, scope: !4023, file: !3, line: 2127, type: !59)
!4032 = !DILocation(line: 2127, column: 33, scope: !4023)
!4033 = !DILocation(line: 2127, column: 40, scope: !4023)
!4034 = !DILocation(line: 2127, column: 53, scope: !4023)
!4035 = !DILocation(line: 2127, column: 64, scope: !4023)
!4036 = !DILocation(line: 2127, column: 79, scope: !4023)
!4037 = !DILocation(line: 2127, column: 88, scope: !4023)
!4038 = !DILocation(line: 2127, column: 97, scope: !4023)
!4039 = !DILocation(line: 2129, column: 12, scope: !4040)
!4040 = distinct !DILexicalBlock(scope: !4023, file: !3, line: 2129, column: 9)
!4041 = !DILocation(line: 2129, column: 9, scope: !4023)
!4042 = !DILocation(line: 2130, column: 16, scope: !4043)
!4043 = distinct !DILexicalBlock(scope: !4040, file: !3, line: 2129, column: 18)
!4044 = !DILocation(line: 2130, column: 9, scope: !4043)
!4045 = !DILocation(line: 2132, column: 16, scope: !4046)
!4046 = distinct !DILexicalBlock(scope: !4040, file: !3, line: 2131, column: 12)
!4047 = !DILocation(line: 2132, column: 9, scope: !4046)
!4048 = !DILocation(line: 2134, column: 1, scope: !4023)
!4049 = distinct !DISubprogram(name: "usb_h_sie_init", scope: !3, file: !3, line: 2136, type: !447, isLocal: false, isDefinition: true, scopeLine: 2137, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4050)
!4050 = !{!4051}
!4051 = !DILocalVariable(name: "id", arg: 1, scope: !4049, file: !3, line: 2136, type: !201)
!4052 = !DILocation(line: 2136, column: 35, scope: !4049)
!4053 = !DILocation(line: 2138, column: 9, scope: !4054)
!4054 = distinct !DILexicalBlock(scope: !4049, file: !3, line: 2138, column: 9)
!4055 = !DILocation(line: 2138, column: 12, scope: !4054)
!4056 = !DILocation(line: 2138, column: 9, scope: !4049)
!4057 = !DILocation(line: 2141, column: 9, scope: !4058)
!4058 = distinct !DILexicalBlock(scope: !4054, file: !3, line: 2138, column: 18)
!4059 = !DILocation(line: 2141, column: 39, scope: !4058)
!4060 = !DILocation(line: 2142, column: 9, scope: !4058)
!4061 = !DILocation(line: 2142, column: 39, scope: !4058)
!4062 = !{!1324, !215, i64 4}
!4063 = !DILocation(line: 2143, column: 9, scope: !4058)
!4064 = !DILocation(line: 2144, column: 37, scope: !4058)
!4065 = !DILocation(line: 2144, column: 33, scope: !4058)
!4066 = !DILocation(line: 2144, column: 9, scope: !4058)
!4067 = !DILocation(line: 2146, column: 33, scope: !4058)
!4068 = !DILocation(line: 2146, column: 9, scope: !4058)
!4069 = !DILocation(line: 2147, column: 9, scope: !4058)
!4070 = !DILocation(line: 2148, column: 9, scope: !4058)
!4071 = !DILocation(line: 2149, column: 9, scope: !4058)
!4072 = !DILocation(line: 2150, column: 9, scope: !4058)
!4073 = !DILocation(line: 2152, column: 42, scope: !4058)
!4074 = !DILocation(line: 2153, column: 42, scope: !4058)
!4075 = !DILocation(line: 2155, column: 9, scope: !4058)
!4076 = !DILocation(line: 2155, column: 36, scope: !4058)
!4077 = !DILocation(line: 2156, column: 9, scope: !4058)
!4078 = !DILocation(line: 2167, column: 5, scope: !4058)
!4079 = !DILocation(line: 2172, column: 18, scope: !4080)
!4080 = distinct !DILexicalBlock(scope: !4054, file: !3, line: 2167, column: 12)
!4081 = !DILocation(line: 2173, column: 22, scope: !4080)
!4082 = !DILocation(line: 2179, column: 24, scope: !4080)
!4083 = !DILocation(line: 2181, column: 24, scope: !4080)
!4084 = !DILocation(line: 2182, column: 9, scope: !4080)
!4085 = !DILocation(line: 2183, column: 24, scope: !4080)
!4086 = !DILocation(line: 2185, column: 9, scope: !4087)
!4087 = distinct !DILexicalBlock(scope: !4080, file: !3, line: 2185, column: 9)
!4088 = !DILocation(line: 2186, column: 22, scope: !4080)
!4089 = !DILocation(line: 2187, column: 9, scope: !4080)
!4090 = !DILocation(line: 2187, column: 17, scope: !4091)
!4091 = !DILexicalBlockFile(scope: !4080, file: !3, discriminator: 1)
!4092 = !DILocation(line: 2187, column: 30, scope: !4091)
!4093 = !DILocation(line: 2187, column: 52, scope: !4091)
!4094 = !DILocation(line: 2187, column: 9, scope: !4091)
!4095 = distinct !{!4095, !4089, !4096}
!4096 = !DILocation(line: 2187, column: 59, scope: !4080)
!4097 = !DILocation(line: 2189, column: 22, scope: !4080)
!4098 = !DILocation(line: 2191, column: 24, scope: !4080)
!4099 = !DILocation(line: 2192, column: 24, scope: !4080)
!4100 = !DILocation(line: 2194, column: 23, scope: !4080)
!4101 = !DILocation(line: 2195, column: 23, scope: !4080)
!4102 = !DILocation(line: 2197, column: 1, scope: !4049)
!4103 = distinct !DISubprogram(name: "usb_h_sie_close", scope: !3, file: !3, line: 2199, type: !447, isLocal: false, isDefinition: true, scopeLine: 2200, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4104)
!4104 = !{!4105}
!4105 = !DILocalVariable(name: "id", arg: 1, scope: !4103, file: !3, line: 2199, type: !201)
!4106 = !DILocation(line: 2199, column: 36, scope: !4103)
!4107 = !DILocation(line: 2201, column: 9, scope: !4108)
!4108 = distinct !DILexicalBlock(scope: !4103, file: !3, line: 2201, column: 9)
!4109 = !DILocation(line: 2201, column: 12, scope: !4108)
!4110 = !DILocation(line: 2201, column: 9, scope: !4103)
!4111 = !DILocation(line: 2206, column: 9, scope: !4112)
!4112 = distinct !DILexicalBlock(scope: !4108, file: !3, line: 2201, column: 18)
!4113 = !DILocation(line: 2206, column: 42, scope: !4112)
!4114 = !DILocation(line: 2207, column: 42, scope: !4112)
!4115 = !DILocation(line: 2208, column: 9, scope: !4112)
!4116 = !DILocation(line: 2208, column: 36, scope: !4112)
!4117 = !DILocation(line: 2209, column: 36, scope: !4112)
!4118 = !DILocation(line: 2210, column: 36, scope: !4112)
!4119 = !DILocation(line: 2211, column: 5, scope: !4112)
!4120 = !DILocation(line: 2214, column: 1, scope: !4103)
!4121 = distinct !DISubprogram(name: "usb_h_chirp_and_reset", scope: !3, file: !3, line: 2216, type: !4122, isLocal: false, isDefinition: true, scopeLine: 2217, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4124)
!4122 = !DISubroutineType(types: !4123)
!4123 = !{!2888, !201, !59, !59}
!4124 = !{!4125, !4126, !4127, !4128, !4129, !4130}
!4125 = !DILocalVariable(name: "id", arg: 1, scope: !4121, file: !3, line: 2216, type: !201)
!4126 = !DILocalVariable(name: "reset_delay", arg: 2, scope: !4121, file: !3, line: 2216, type: !59)
!4127 = !DILocalVariable(name: "timeout", arg: 3, scope: !4121, file: !3, line: 2216, type: !59)
!4128 = !DILocalVariable(name: "reg", scope: !4121, file: !3, line: 2218, type: !52)
!4129 = !DILocalVariable(name: "st", scope: !4121, file: !3, line: 2219, type: !59)
!4130 = !DILocalVariable(name: "ot", scope: !4121, file: !3, line: 2220, type: !59)
!4131 = !DILocation(line: 2216, column: 41, scope: !4121)
!4132 = !DILocation(line: 2216, column: 49, scope: !4121)
!4133 = !DILocation(line: 2216, column: 66, scope: !4121)
!4134 = !DILocation(line: 2219, column: 9, scope: !4121)
!4135 = !DILocation(line: 2220, column: 14, scope: !4121)
!4136 = !DILocation(line: 2220, column: 28, scope: !4121)
!4137 = !DILocation(line: 2220, column: 9, scope: !4121)
!4138 = !DILocation(line: 2222, column: 9, scope: !4139)
!4139 = distinct !DILexicalBlock(scope: !4121, file: !3, line: 2222, column: 9)
!4140 = !DILocation(line: 2222, column: 12, scope: !4139)
!4141 = !DILocation(line: 2223, column: 9, scope: !4142)
!4142 = distinct !DILexicalBlock(scope: !4139, file: !3, line: 2222, column: 18)
!4143 = !DILocation(line: 2222, column: 9, scope: !4121)
!4144 = !DILocation(line: 2219, column: 9, scope: !4145)
!4145 = !DILexicalBlockFile(scope: !4121, file: !3, discriminator: 1)
!4146 = !DILocation(line: 2226, column: 19, scope: !4147)
!4147 = distinct !DILexicalBlock(scope: !4142, file: !3, line: 2225, column: 19)
!4148 = !DILocation(line: 2227, column: 17, scope: !4149)
!4149 = distinct !DILexicalBlock(scope: !4147, file: !3, line: 2227, column: 17)
!4150 = !DILocation(line: 2227, column: 17, scope: !4147)
!4151 = !DILocation(line: 2228, column: 17, scope: !4152)
!4152 = distinct !DILexicalBlock(scope: !4153, file: !3, line: 2228, column: 17)
!4153 = distinct !DILexicalBlock(scope: !4149, file: !3, line: 2227, column: 39)
!4154 = !DILocation(line: 2229, column: 17, scope: !4153)
!4155 = !DILocation(line: 2231, column: 17, scope: !4156)
!4156 = distinct !DILexicalBlock(scope: !4147, file: !3, line: 2231, column: 17)
!4157 = !DILocation(line: 2232, column: 20, scope: !4158)
!4158 = distinct !DILexicalBlock(scope: !4156, file: !3, line: 2231, column: 39)
!4159 = !DILocation(line: 2231, column: 17, scope: !4147)
!4160 = !DILocation(line: 2236, column: 23, scope: !4161)
!4161 = distinct !DILexicalBlock(scope: !4147, file: !3, line: 2236, column: 17)
!4162 = !DILocation(line: 2236, column: 33, scope: !4161)
!4163 = !DILocation(line: 2236, column: 46, scope: !4164)
!4164 = !DILexicalBlockFile(scope: !4161, file: !3, discriminator: 1)
!4165 = !DILocation(line: 2236, column: 39, scope: !4161)
!4166 = !DILocation(line: 2237, column: 17, scope: !4167)
!4167 = distinct !DILexicalBlock(scope: !4168, file: !3, line: 2237, column: 17)
!4168 = distinct !DILexicalBlock(scope: !4161, file: !3, line: 2236, column: 55)
!4169 = !DILocation(line: 2238, column: 17, scope: !4168)
!4170 = !DILocation(line: 2240, column: 21, scope: !4171)
!4171 = distinct !DILexicalBlock(scope: !4147, file: !3, line: 2240, column: 17)
!4172 = !DILocation(line: 2240, column: 17, scope: !4147)
!4173 = !DILocation(line: 2241, column: 17, scope: !4174)
!4174 = distinct !DILexicalBlock(scope: !4175, file: !3, line: 2241, column: 17)
!4175 = distinct !DILexicalBlock(scope: !4171, file: !3, line: 2240, column: 31)
!4176 = !DILocation(line: 2243, column: 17, scope: !4175)
!4177 = !DILocation(line: 2246, column: 21, scope: !4178)
!4178 = distinct !DILexicalBlock(scope: !4147, file: !3, line: 2246, column: 17)
!4179 = !DILocation(line: 2246, column: 17, scope: !4147)
!4180 = !DILocation(line: 2247, column: 17, scope: !4181)
!4181 = distinct !DILexicalBlock(scope: !4182, file: !3, line: 2247, column: 17)
!4182 = distinct !DILexicalBlock(scope: !4178, file: !3, line: 2246, column: 31)
!4183 = !DILocation(line: 2248, column: 17, scope: !4182)
!4184 = !DILocation(line: 2250, column: 17, scope: !4182)
!4185 = !DILocation(line: 2252, column: 13, scope: !4147)
!4186 = !DILocation(line: 2225, column: 9, scope: !4187)
!4187 = !DILexicalBlockFile(scope: !4142, file: !3, discriminator: 2)
!4188 = distinct !{!4188, !4189, !4190}
!4189 = !DILocation(line: 2225, column: 9, scope: !4142)
!4190 = !DILocation(line: 2253, column: 9, scope: !4142)
!4191 = !DILocation(line: 2255, column: 14, scope: !4142)
!4192 = !DILocation(line: 2255, column: 28, scope: !4142)
!4193 = !DILocation(line: 2257, column: 9, scope: !4142)
!4194 = distinct !{!4194, !4193, !4195}
!4195 = !DILocation(line: 2264, column: 33, scope: !4142)
!4196 = !DILocation(line: 2258, column: 19, scope: !4197)
!4197 = distinct !DILexicalBlock(scope: !4142, file: !3, line: 2257, column: 12)
!4198 = !DILocation(line: 2259, column: 33, scope: !4197)
!4199 = !DILocation(line: 2259, column: 37, scope: !4197)
!4200 = !DILocation(line: 2259, column: 13, scope: !4197)
!4201 = !DILocation(line: 2260, column: 17, scope: !4202)
!4202 = distinct !DILexicalBlock(scope: !4197, file: !3, line: 2260, column: 17)
!4203 = !DILocation(line: 2260, column: 17, scope: !4197)
!4204 = !DILocation(line: 2261, column: 17, scope: !4205)
!4205 = distinct !DILexicalBlock(scope: !4206, file: !3, line: 2261, column: 17)
!4206 = distinct !DILexicalBlock(scope: !4202, file: !3, line: 2260, column: 39)
!4207 = !DILocation(line: 2262, column: 17, scope: !4206)
!4208 = !DILocation(line: 2264, column: 24, scope: !4209)
!4209 = !DILexicalBlockFile(scope: !4142, file: !3, discriminator: 1)
!4210 = !DILocation(line: 2264, column: 18, scope: !4209)
!4211 = !DILocation(line: 2264, column: 9, scope: !4212)
!4212 = !DILexicalBlockFile(scope: !4197, file: !3, discriminator: 1)
!4213 = !DILocation(line: 2267, column: 9, scope: !4142)
!4214 = !DILocation(line: 2269, column: 15, scope: !4142)
!4215 = !DILocation(line: 2270, column: 13, scope: !4142)
!4216 = !DILocation(line: 2271, column: 9, scope: !4142)
!4217 = !DILocation(line: 2273, column: 5, scope: !4142)
!4218 = !DILocation(line: 2277, column: 19, scope: !4219)
!4219 = distinct !DILexicalBlock(scope: !4220, file: !3, line: 2276, column: 19)
!4220 = distinct !DILexicalBlock(scope: !4139, file: !3, line: 2273, column: 12)
!4221 = !DILocation(line: 2278, column: 17, scope: !4222)
!4222 = distinct !DILexicalBlock(scope: !4219, file: !3, line: 2278, column: 17)
!4223 = !DILocation(line: 2278, column: 17, scope: !4219)
!4224 = !DILocation(line: 2279, column: 17, scope: !4225)
!4225 = distinct !DILexicalBlock(scope: !4226, file: !3, line: 2279, column: 17)
!4226 = distinct !DILexicalBlock(scope: !4222, file: !3, line: 2278, column: 39)
!4227 = !DILocation(line: 2280, column: 17, scope: !4226)
!4228 = !DILocation(line: 2282, column: 17, scope: !4229)
!4229 = distinct !DILexicalBlock(scope: !4219, file: !3, line: 2282, column: 17)
!4230 = !DILocation(line: 2291, column: 21, scope: !4231)
!4231 = distinct !DILexicalBlock(scope: !4219, file: !3, line: 2291, column: 17)
!4232 = !DILocation(line: 2291, column: 17, scope: !4219)
!4233 = !DILocation(line: 2295, column: 21, scope: !4234)
!4234 = distinct !DILexicalBlock(scope: !4219, file: !3, line: 2295, column: 17)
!4235 = !DILocation(line: 2295, column: 17, scope: !4219)
!4236 = !DILocation(line: 2299, column: 13, scope: !4219)
!4237 = !DILocation(line: 2276, column: 9, scope: !4238)
!4238 = !DILexicalBlockFile(scope: !4220, file: !3, discriminator: 2)
!4239 = distinct !{!4239, !4240, !4241}
!4240 = !DILocation(line: 2276, column: 9, scope: !4220)
!4241 = !DILocation(line: 2300, column: 9, scope: !4220)
!4242 = !DILocation(line: 2302, column: 14, scope: !4220)
!4243 = !DILocation(line: 2302, column: 28, scope: !4220)
!4244 = !DILocation(line: 2304, column: 9, scope: !4220)
!4245 = distinct !{!4245, !4244, !4246}
!4246 = !DILocation(line: 2311, column: 33, scope: !4220)
!4247 = !DILocation(line: 2305, column: 19, scope: !4248)
!4248 = distinct !DILexicalBlock(scope: !4220, file: !3, line: 2304, column: 12)
!4249 = !DILocation(line: 2306, column: 33, scope: !4248)
!4250 = !DILocation(line: 2306, column: 37, scope: !4248)
!4251 = !DILocation(line: 2306, column: 13, scope: !4248)
!4252 = !DILocation(line: 2307, column: 17, scope: !4253)
!4253 = distinct !DILexicalBlock(scope: !4248, file: !3, line: 2307, column: 17)
!4254 = !DILocation(line: 2307, column: 17, scope: !4248)
!4255 = !DILocation(line: 2308, column: 17, scope: !4256)
!4256 = distinct !DILexicalBlock(scope: !4257, file: !3, line: 2308, column: 17)
!4257 = distinct !DILexicalBlock(scope: !4253, file: !3, line: 2307, column: 39)
!4258 = !DILocation(line: 2309, column: 17, scope: !4257)
!4259 = !DILocation(line: 2311, column: 24, scope: !4260)
!4260 = !DILexicalBlockFile(scope: !4220, file: !3, discriminator: 1)
!4261 = !DILocation(line: 2311, column: 18, scope: !4260)
!4262 = !DILocation(line: 2311, column: 9, scope: !4263)
!4263 = !DILexicalBlockFile(scope: !4248, file: !3, discriminator: 1)
!4264 = !DILocation(line: 2314, column: 9, scope: !4220)
!4265 = !DILocation(line: 2316, column: 15, scope: !4220)
!4266 = !DILocation(line: 2317, column: 13, scope: !4220)
!4267 = !DILocation(line: 2318, column: 9, scope: !4220)
!4268 = !DILocation(line: 2320, column: 9, scope: !4269)
!4269 = !DILexicalBlockFile(scope: !4270, file: !3, discriminator: 1)
!4270 = distinct !DILexicalBlock(scope: !4220, file: !3, line: 2320, column: 9)
!4271 = !{i32 -2146368404}
!4272 = !DILocation(line: 2321, column: 15, scope: !4220)
!4273 = !DILocation(line: 2322, column: 13, scope: !4274)
!4274 = distinct !DILexicalBlock(scope: !4220, file: !3, line: 2322, column: 13)
!4275 = !DILocation(line: 2322, column: 13, scope: !4220)
!4276 = !DILocation(line: 2323, column: 21, scope: !4277)
!4277 = distinct !DILexicalBlock(scope: !4278, file: !3, line: 2323, column: 17)
!4278 = distinct !DILexicalBlock(scope: !4274, file: !3, line: 2322, column: 47)
!4279 = !DILocation(line: 2323, column: 17, scope: !4278)
!4280 = !DILocation(line: 2324, column: 17, scope: !4281)
!4281 = distinct !DILexicalBlock(scope: !4282, file: !3, line: 2324, column: 17)
!4282 = distinct !DILexicalBlock(scope: !4277, file: !3, line: 2323, column: 31)
!4283 = !DILocation(line: 2325, column: 32, scope: !4282)
!4284 = !DILocation(line: 2326, column: 13, scope: !4282)
!4285 = !DILocation(line: 2327, column: 17, scope: !4286)
!4286 = distinct !DILexicalBlock(scope: !4287, file: !3, line: 2327, column: 17)
!4287 = distinct !DILexicalBlock(scope: !4277, file: !3, line: 2326, column: 20)
!4288 = !DILocation(line: 2330, column: 13, scope: !4289)
!4289 = distinct !DILexicalBlock(scope: !4290, file: !3, line: 2330, column: 13)
!4290 = distinct !DILexicalBlock(scope: !4291, file: !3, line: 2329, column: 53)
!4291 = distinct !DILexicalBlock(scope: !4274, file: !3, line: 2329, column: 20)
!4292 = !DILocation(line: 2331, column: 9, scope: !4290)
!4293 = !DILocation(line: 2335, column: 1, scope: !4121)
!4294 = distinct !DISubprogram(name: "usb_h_sie_reset", scope: !3, file: !3, line: 2337, type: !447, isLocal: false, isDefinition: true, scopeLine: 2338, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4295)
!4295 = !{!4296}
!4296 = !DILocalVariable(name: "id", arg: 1, scope: !4294, file: !3, line: 2337, type: !201)
!4297 = !DILocation(line: 2337, column: 36, scope: !4294)
!4298 = !DILocation(line: 2339, column: 12, scope: !4299)
!4299 = distinct !DILexicalBlock(scope: !4294, file: !3, line: 2339, column: 9)
!4300 = !DILocation(line: 2339, column: 9, scope: !4294)
!4301 = !DILocation(line: 2340, column: 36, scope: !4302)
!4302 = distinct !DILexicalBlock(scope: !4299, file: !3, line: 2339, column: 18)
!4303 = !DILocation(line: 2341, column: 9, scope: !4302)
!4304 = !DILocation(line: 2342, column: 36, scope: !4302)
!4305 = !DILocation(line: 2343, column: 5, scope: !4302)
!4306 = !DILocation(line: 2344, column: 22, scope: !4307)
!4307 = distinct !DILexicalBlock(scope: !4299, file: !3, line: 2343, column: 12)
!4308 = !DILocation(line: 2345, column: 9, scope: !4307)
!4309 = !DILocation(line: 2347, column: 5, scope: !4294)
!4310 = !DILocation(line: 2348, column: 1, scope: !4294)
!4311 = distinct !DISubprogram(name: "usb_h_force_reset", scope: !3, file: !3, line: 2350, type: !341, isLocal: false, isDefinition: true, scopeLine: 2351, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4312)
!4312 = !{!4313}
!4313 = !DILocalVariable(name: "id", arg: 1, scope: !4311, file: !3, line: 2350, type: !201)
!4314 = !DILocation(line: 2350, column: 37, scope: !4311)
!4315 = !DILocation(line: 2352, column: 12, scope: !4316)
!4316 = distinct !DILexicalBlock(scope: !4311, file: !3, line: 2352, column: 9)
!4317 = !DILocation(line: 2352, column: 9, scope: !4311)
!4318 = !DILocation(line: 2353, column: 9, scope: !4319)
!4319 = distinct !DILexicalBlock(scope: !4316, file: !3, line: 2352, column: 18)
!4320 = !DILocation(line: 2354, column: 5, scope: !4319)
!4321 = !DILocation(line: 2355, column: 22, scope: !4322)
!4322 = distinct !DILexicalBlock(scope: !4316, file: !3, line: 2354, column: 12)
!4323 = !DILocation(line: 2357, column: 5, scope: !4311)
!4324 = distinct !DISubprogram(name: "usb_io_reset", scope: !3, file: !3, line: 2460, type: !447, isLocal: false, isDefinition: true, scopeLine: 2461, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4325)
!4325 = !{!4326}
!4326 = !DILocalVariable(name: "id", arg: 1, scope: !4324, file: !3, line: 2460, type: !201)
!4327 = !DILocation(line: 2460, column: 33, scope: !4324)
!4328 = !DILocation(line: 2462, column: 12, scope: !4329)
!4329 = distinct !DILexicalBlock(scope: !4324, file: !3, line: 2462, column: 9)
!4330 = !DILocation(line: 2462, column: 9, scope: !4324)
!4331 = !DILocation(line: 2463, column: 9, scope: !4332)
!4332 = distinct !DILexicalBlock(scope: !4329, file: !3, line: 2462, column: 18)
!4333 = !DILocation(line: 2464, column: 9, scope: !4332)
!4334 = !DILocation(line: 2465, column: 9, scope: !4332)
!4335 = !DILocation(line: 2466, column: 9, scope: !4332)
!4336 = !DILocation(line: 2468, column: 9, scope: !4332)
!4337 = !DILocation(line: 2469, column: 9, scope: !4332)
!4338 = !DILocation(line: 2471, column: 9, scope: !4332)
!4339 = !DILocation(line: 2472, column: 9, scope: !4332)
!4340 = !DILocation(line: 2473, column: 9, scope: !4332)
!4341 = !DILocation(line: 2474, column: 9, scope: !4332)
!4342 = !DILocation(line: 2475, column: 5, scope: !4332)
!4343 = !DILocation(line: 2478, column: 1, scope: !4324)
!4344 = distinct !DISubprogram(name: "usb_hotplug_disable", scope: !3, file: !3, line: 2360, type: !447, isLocal: false, isDefinition: true, scopeLine: 2361, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4345)
!4345 = !{!4346}
!4346 = !DILocalVariable(name: "id", arg: 1, scope: !4344, file: !3, line: 2360, type: !201)
!4347 = !DILocation(line: 2360, column: 40, scope: !4344)
!4348 = !DILocation(line: 2362, column: 9, scope: !4349)
!4349 = distinct !DILexicalBlock(scope: !4344, file: !3, line: 2362, column: 9)
!4350 = !DILocation(line: 2362, column: 12, scope: !4349)
!4351 = !DILocation(line: 2362, column: 9, scope: !4344)
!4352 = !DILocation(line: 2363, column: 9, scope: !4353)
!4353 = distinct !DILexicalBlock(scope: !4349, file: !3, line: 2362, column: 18)
!4354 = !DILocation(line: 2363, column: 36, scope: !4353)
!4355 = !DILocation(line: 2364, column: 9, scope: !4353)
!4356 = !DILocation(line: 2364, column: 42, scope: !4353)
!4357 = !DILocation(line: 2365, column: 5, scope: !4353)
!4358 = !DILocation(line: 2366, column: 24, scope: !4359)
!4359 = distinct !DILexicalBlock(scope: !4349, file: !3, line: 2365, column: 12)
!4360 = !DILocation(line: 2367, column: 24, scope: !4359)
!4361 = !DILocation(line: 2368, column: 24, scope: !4359)
!4362 = !DILocation(line: 2370, column: 24, scope: !4359)
!4363 = !DILocation(line: 2372, column: 1, scope: !4344)
!4364 = distinct !DISubprogram(name: "usb_hotplug_enable", scope: !3, file: !3, line: 2394, type: !1288, isLocal: false, isDefinition: true, scopeLine: 2395, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4365)
!4365 = !{!4366, !4367}
!4366 = !DILocalVariable(name: "id", arg: 1, scope: !4364, file: !3, line: 2394, type: !201)
!4367 = !DILocalVariable(name: "mode", arg: 2, scope: !4364, file: !3, line: 2394, type: !59)
!4368 = !DILocation(line: 2394, column: 39, scope: !4364)
!4369 = !DILocation(line: 2394, column: 47, scope: !4364)
!4370 = !DILocation(line: 2396, column: 9, scope: !4371)
!4371 = distinct !DILexicalBlock(scope: !4364, file: !3, line: 2396, column: 9)
!4372 = !DILocation(line: 2396, column: 12, scope: !4371)
!4373 = !DILocation(line: 2396, column: 9, scope: !4364)
!4374 = !DILocation(line: 2397, column: 9, scope: !4375)
!4375 = distinct !DILexicalBlock(scope: !4371, file: !3, line: 2396, column: 18)
!4376 = !DILocation(line: 2398, column: 45, scope: !4375)
!4377 = !DILocation(line: 2398, column: 41, scope: !4375)
!4378 = !DILocation(line: 2398, column: 9, scope: !4375)
!4379 = !DILocation(line: 2399, column: 9, scope: !4375)
!4380 = !DILocation(line: 2400, column: 9, scope: !4375)
!4381 = !DILocation(line: 2401, column: 9, scope: !4375)
!4382 = !DILocation(line: 2402, column: 9, scope: !4375)
!4383 = !DILocation(line: 2404, column: 18, scope: !4384)
!4384 = distinct !DILexicalBlock(scope: !4375, file: !3, line: 2404, column: 13)
!4385 = !DILocation(line: 2405, column: 13, scope: !4386)
!4386 = distinct !DILexicalBlock(scope: !4384, file: !3, line: 2404, column: 37)
!4387 = !DILocation(line: 2404, column: 13, scope: !4375)
!4388 = !DILocation(line: 2406, column: 13, scope: !4386)
!4389 = !DILocation(line: 2407, column: 13, scope: !4386)
!4390 = !DILocation(line: 2408, column: 13, scope: !4386)
!4391 = !DILocation(line: 2409, column: 13, scope: !4386)
!4392 = !DILocation(line: 2410, column: 9, scope: !4386)
!4393 = !DILocation(line: 2412, column: 13, scope: !4394)
!4394 = distinct !DILexicalBlock(scope: !4384, file: !3, line: 2410, column: 16)
!4395 = !DILocation(line: 2413, column: 13, scope: !4394)
!4396 = !DILocation(line: 2414, column: 13, scope: !4394)
!4397 = !DILocation(line: 2415, column: 13, scope: !4394)
!4398 = !DILocation(line: 2417, column: 9, scope: !4375)
!4399 = !DILocation(line: 2417, column: 36, scope: !4375)
!4400 = !DILocation(line: 2418, column: 18, scope: !4401)
!4401 = distinct !DILexicalBlock(scope: !4375, file: !3, line: 2418, column: 13)
!4402 = !DILocation(line: 2418, column: 13, scope: !4375)
!4403 = !DILocation(line: 2419, column: 40, scope: !4404)
!4404 = distinct !DILexicalBlock(scope: !4401, file: !3, line: 2418, column: 36)
!4405 = !DILocation(line: 2420, column: 9, scope: !4404)
!4406 = !DILocation(line: 2424, column: 24, scope: !4407)
!4407 = distinct !DILexicalBlock(scope: !4371, file: !3, line: 2421, column: 12)
!4408 = !DILocation(line: 2425, column: 24, scope: !4407)
!4409 = !DILocation(line: 2426, column: 18, scope: !4410)
!4410 = distinct !DILexicalBlock(scope: !4407, file: !3, line: 2426, column: 13)
!4411 = !DILocation(line: 2426, column: 13, scope: !4407)
!4412 = !DILocation(line: 2427, column: 28, scope: !4413)
!4413 = distinct !DILexicalBlock(scope: !4410, file: !3, line: 2426, column: 36)
!4414 = !DILocation(line: 2431, column: 9, scope: !4413)
!4415 = !DILocation(line: 2432, column: 24, scope: !4407)
!4416 = !DILocation(line: 2433, column: 24, scope: !4407)
!4417 = !DILocation(line: 2434, column: 19, scope: !4418)
!4418 = distinct !DILexicalBlock(scope: !4407, file: !3, line: 2434, column: 13)
!4419 = !DILocation(line: 2434, column: 38, scope: !4418)
!4420 = !DILocation(line: 2434, column: 13, scope: !4407)
!4421 = !DILocation(line: 2435, column: 28, scope: !4422)
!4422 = distinct !DILexicalBlock(scope: !4418, file: !3, line: 2434, column: 44)
!4423 = !DILocation(line: 2436, column: 9, scope: !4422)
!4424 = !DILocation(line: 2438, column: 1, scope: !4364)
!4425 = distinct !DISubprogram(name: "usb_sie_close", scope: !3, file: !3, line: 2440, type: !447, isLocal: false, isDefinition: true, scopeLine: 2441, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4426)
!4426 = !{!4427}
!4427 = !DILocalVariable(name: "id", arg: 1, scope: !4425, file: !3, line: 2440, type: !201)
!4428 = !DILocation(line: 2440, column: 34, scope: !4425)
!4429 = !DILocation(line: 2442, column: 9, scope: !4430)
!4430 = distinct !DILexicalBlock(scope: !4425, file: !3, line: 2442, column: 9)
!4431 = !DILocation(line: 2442, column: 12, scope: !4430)
!4432 = !DILocation(line: 2442, column: 9, scope: !4425)
!4433 = !DILocation(line: 2443, column: 9, scope: !4434)
!4434 = distinct !DILexicalBlock(scope: !4430, file: !3, line: 2442, column: 18)
!4435 = !DILocation(line: 2443, column: 36, scope: !4434)
!4436 = !DILocation(line: 2444, column: 9, scope: !4434)
!4437 = !DILocation(line: 2444, column: 36, scope: !4434)
!4438 = !DILocation(line: 2445, column: 9, scope: !4434)
!4439 = !DILocation(line: 2445, column: 42, scope: !4434)
!4440 = !DILocation(line: 2447, column: 28, scope: !4434)
!4441 = !DILocation(line: 2448, column: 5, scope: !4434)
!4442 = !DILocation(line: 2449, column: 22, scope: !4443)
!4443 = distinct !DILexicalBlock(scope: !4430, file: !3, line: 2448, column: 12)
!4444 = !DILocation(line: 2451, column: 1, scope: !4425)
!4445 = distinct !DISubprogram(name: "usb_sie_close_all", scope: !3, file: !3, line: 2453, type: !179, isLocal: false, isDefinition: true, scopeLine: 2454, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4446)
!4446 = !{!4447}
!4447 = !DILocalVariable(name: "id", scope: !4445, file: !3, line: 2455, type: !202)
!4448 = !DILocation(line: 2455, column: 13, scope: !4445)
!4449 = !DILocation(line: 2456, column: 10, scope: !4450)
!4450 = distinct !DILexicalBlock(scope: !4445, file: !3, line: 2456, column: 5)
!4451 = !DILocation(line: 2456, column: 21, scope: !4452)
!4452 = !DILexicalBlockFile(scope: !4453, file: !3, discriminator: 1)
!4453 = distinct !DILexicalBlock(scope: !4450, file: !3, line: 2456, column: 5)
!4454 = !DILocation(line: 2456, column: 5, scope: !4455)
!4455 = !DILexicalBlockFile(scope: !4450, file: !3, discriminator: 1)
!4456 = !DILocation(line: 2457, column: 9, scope: !4457)
!4457 = distinct !DILexicalBlock(scope: !4453, file: !3, line: 2456, column: 45)
!4458 = !DILocation(line: 2456, column: 41, scope: !4459)
!4459 = !DILexicalBlockFile(scope: !4453, file: !3, discriminator: 2)
!4460 = !DILocation(line: 2456, column: 5, scope: !4459)
!4461 = distinct !{!4461, !4462, !4463}
!4462 = !DILocation(line: 2456, column: 5, scope: !4450)
!4463 = !DILocation(line: 2458, column: 5, scope: !4450)
!4464 = !DILocation(line: 2459, column: 1, scope: !4445)
!4465 = distinct !DISubprogram(name: "usb_var_init", scope: !3, file: !3, line: 2480, type: !4466, isLocal: false, isDefinition: true, scopeLine: 2481, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4468)
!4466 = !DISubroutineType(types: !4467)
!4467 = !{null, !201, !61}
!4468 = !{!4469, !4470}
!4469 = !DILocalVariable(name: "id", arg: 1, scope: !4465, file: !3, line: 2480, type: !201)
!4470 = !DILocalVariable(name: "ptr", arg: 2, scope: !4465, file: !3, line: 2480, type: !61)
!4471 = !DILocation(line: 2480, column: 33, scope: !4465)
!4472 = !DILocation(line: 2480, column: 43, scope: !4465)
!4473 = !DILocation(line: 2482, column: 5, scope: !4465)
!4474 = !DILocation(line: 2482, column: 21, scope: !4465)
!4475 = !DILocation(line: 2483, column: 9, scope: !4476)
!4476 = distinct !DILexicalBlock(scope: !4465, file: !3, line: 2483, column: 9)
!4477 = !DILocation(line: 2483, column: 9, scope: !4465)
!4478 = !DILocation(line: 2484, column: 9, scope: !4479)
!4479 = distinct !DILexicalBlock(scope: !4476, file: !3, line: 2483, column: 26)
!4480 = !DILocation(line: 2485, column: 5, scope: !4479)
!4481 = !DILocation(line: 2486, column: 1, scope: !4465)
!4482 = distinct !DISubprogram(name: "usb_var_release", scope: !3, file: !3, line: 2487, type: !447, isLocal: false, isDefinition: true, scopeLine: 2488, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !4483)
!4483 = !{!4484}
!4484 = !DILocalVariable(name: "id", arg: 1, scope: !4482, file: !3, line: 2487, type: !201)
!4485 = !DILocation(line: 2487, column: 36, scope: !4482)
!4486 = !DILocation(line: 2489, column: 9, scope: !4487)
!4487 = distinct !DILexicalBlock(scope: !4482, file: !3, line: 2489, column: 9)
!4488 = !DILocation(line: 2489, column: 9, scope: !4482)
!4489 = !DILocation(line: 2490, column: 25, scope: !4490)
!4490 = distinct !DILexicalBlock(scope: !4487, file: !3, line: 2489, column: 26)
!4491 = !DILocation(line: 2491, column: 5, scope: !4490)
!4492 = !DILocation(line: 2492, column: 1, scope: !4482)
