; ModuleID = 'usb_phy.c.o'
source_filename = "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/device/usb/usb_phy.c"
target datalayout = "e-m:e-p:32:32-i1:32-i64:32:32-f64:32:32-n8:16:32-a:0:32"
target triple = "pi32v2"

%struct.usb_host_device = type opaque

@jiffies = external global i32, align 4
@log_tag_const_e_USB = external local_unnamed_addr constant i8, align 1
@.str = private unnamed_addr constant [32 x i8] c"<Error>: [USB]usb_host_reset\0A\0D\0A\00", align 1

; Function Attrs: minsize norecurse nounwind optsize
define i32 @get_jiffies() local_unnamed_addr #0 !dbg !29 {
  %1 = load volatile i32, i32* @jiffies, align 4, !dbg !35, !tbaa !36
  ret i32 %1, !dbg !40
}

; Function Attrs: minsize nounwind optsize
define void @usb_mdelay(i32) local_unnamed_addr #1 !dbg !41 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !45, metadata !47), !dbg !48
  %2 = udiv i32 %0, 10, !dbg !49
  %3 = urem i32 %0, 10, !dbg !50
  %4 = icmp ugt i32 %3, 5, !dbg !51
  %5 = zext i1 %4 to i32, !dbg !52
  %6 = add nuw nsw i32 %5, %2, !dbg !53
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !46, metadata !47), !dbg !54
  %7 = icmp eq i32 %6, 0, !dbg !55
  %8 = select i1 %7, i32 1, i32 %6, !dbg !56
  tail call void @os_time_dly(i32 %8) #5, !dbg !57
  ret void, !dbg !59
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #3

; Function Attrs: minsize optsize
declare void @os_time_dly(i32) local_unnamed_addr #4

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #3

; Function Attrs: minsize nounwind optsize
define i32 @usb_host_timeout(i32) local_unnamed_addr #1 !dbg !60 {
  tail call void @llvm.dbg.value(metadata i32 %0, i64 0, metadata !64, metadata !47), !dbg !65
  %2 = load volatile i32, i32* @jiffies, align 4, !dbg !66, !tbaa !36
  %3 = icmp sgt i32 %2, %0, !dbg !68
  %4 = zext i1 %3 to i32, !dbg !68
  ret i32 %4, !dbg !69
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_bulk_read64byte_fast(i8 zeroext, i32, i8*, i32) local_unnamed_addr #1 !dbg !70 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !80, metadata !47), !dbg !84
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !81, metadata !47), !dbg !85
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !82, metadata !47), !dbg !86
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !83, metadata !47), !dbg !87
  %5 = tail call i32 @usb_g_ep_read64byte_fast(i8 zeroext %0, i32 %1, i8* %2, i32 %3) #5, !dbg !88
  ret i32 %5, !dbg !89
}

; Function Attrs: minsize optsize
declare i32 @usb_g_ep_read64byte_fast(i8 zeroext, i32, i8*, i32) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_bulk_read(i8 zeroext, i32, i8*, i32, i32) local_unnamed_addr #1 !dbg !90 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !94, metadata !47), !dbg !99
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !95, metadata !47), !dbg !100
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !96, metadata !47), !dbg !101
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !97, metadata !47), !dbg !102
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !98, metadata !47), !dbg !103
  %6 = tail call i32 @usb_g_ep_read(i8 zeroext %0, i32 %1, i8* %2, i32 %3, i32 %4) #5, !dbg !104
  ret i32 %6, !dbg !105
}

; Function Attrs: minsize optsize
declare i32 @usb_g_ep_read(i8 zeroext, i32, i8*, i32, i32) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_bulk_write(i8 zeroext, i32, i8*, i32) local_unnamed_addr #1 !dbg !106 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !112, metadata !47), !dbg !116
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !113, metadata !47), !dbg !117
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !114, metadata !47), !dbg !118
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !115, metadata !47), !dbg !119
  %5 = tail call i32 @usb_g_ep_write(i8 zeroext %0, i32 %1, i8* %2, i32 %3) #5, !dbg !120
  ret i32 %5, !dbg !121
}

; Function Attrs: minsize optsize
declare i32 @usb_g_ep_write(i8 zeroext, i32, i8*, i32) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_intr_read(i8 zeroext, i32, i8*, i32, i32) local_unnamed_addr #1 !dbg !122 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !124, metadata !47), !dbg !129
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !125, metadata !47), !dbg !130
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !126, metadata !47), !dbg !131
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !127, metadata !47), !dbg !132
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !128, metadata !47), !dbg !133
  %6 = tail call i32 @usb_g_ep_read(i8 zeroext %0, i32 %1, i8* %2, i32 %3, i32 %4) #5, !dbg !134
  ret i32 %6, !dbg !135
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_intr_write(i8 zeroext, i32, i8*, i32) local_unnamed_addr #1 !dbg !136 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !138, metadata !47), !dbg !142
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !139, metadata !47), !dbg !143
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !140, metadata !47), !dbg !144
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !141, metadata !47), !dbg !145
  %5 = tail call i32 @usb_g_ep_write(i8 zeroext %0, i32 %1, i8* %2, i32 %3) #5, !dbg !146
  ret i32 %5, !dbg !147
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_iso_read(i8 zeroext, i32, i8*, i32, i32) local_unnamed_addr #1 !dbg !148 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !150, metadata !47), !dbg !155
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !151, metadata !47), !dbg !156
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !152, metadata !47), !dbg !157
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !153, metadata !47), !dbg !158
  tail call void @llvm.dbg.value(metadata i32 %4, i64 0, metadata !154, metadata !47), !dbg !159
  %6 = tail call i32 @usb_g_ep_read(i8 zeroext %0, i32 %1, i8* %2, i32 %3, i32 %4) #5, !dbg !160
  ret i32 %6, !dbg !161
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_g_iso_write(i8 zeroext, i32, i8*, i32) local_unnamed_addr #1 !dbg !162 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !164, metadata !47), !dbg !168
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !165, metadata !47), !dbg !169
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !166, metadata !47), !dbg !170
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !167, metadata !47), !dbg !171
  %5 = tail call i32 @usb_g_ep_write(i8 zeroext %0, i32 %1, i8* %2, i32 %3) #5, !dbg !172
  ret i32 %5, !dbg !173
}

; Function Attrs: minsize nounwind optsize
define void @usb_slave_init(i8 zeroext) local_unnamed_addr #1 !dbg !174 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !178, metadata !47), !dbg !179
  tail call void @usb_write_intr_usbe(i8 zeroext %0, i32 0) #5, !dbg !180
  tail call void @usb_clr_intr_txe(i8 zeroext %0, i32 -1) #5, !dbg !181
  tail call void @usb_clr_intr_rxe(i8 zeroext %0, i32 -1) #5, !dbg !182
  tail call void @usb_sie_enable(i8 zeroext %0) #5, !dbg !183
  ret void, !dbg !184
}

; Function Attrs: minsize optsize
declare void @usb_write_intr_usbe(i8 zeroext, i32) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_clr_intr_txe(i8 zeroext, i32) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_clr_intr_rxe(i8 zeroext, i32) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_sie_enable(i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define zeroext i16 @usb_read_sofframe(i8 zeroext) local_unnamed_addr #1 !dbg !185 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !191, metadata !47), !dbg !192
  %2 = tail call zeroext i16 @musb_read_sofframe(i8 zeroext %0) #5, !dbg !193
  ret i16 %2, !dbg !194
}

; Function Attrs: minsize optsize
declare zeroext i16 @musb_read_sofframe(i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_bulk_read(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32) local_unnamed_addr #1 !dbg !195 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !200, metadata !47), !dbg !206
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !201, metadata !47), !dbg !207
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !202, metadata !47), !dbg !208
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !203, metadata !47), !dbg !209
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !204, metadata !47), !dbg !210
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !205, metadata !47), !dbg !211
  %7 = tail call i32 @usb_h_ep_read(i8 zeroext %0, i8 zeroext %1, i16 zeroext %2, i8 zeroext %3, i8* %4, i32 %5, i32 2) #5, !dbg !212
  ret i32 %7, !dbg !213
}

; Function Attrs: minsize optsize
declare i32 @usb_h_ep_read(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32, i32) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_bulk_write(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32) local_unnamed_addr #1 !dbg !214 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !216, metadata !47), !dbg !222
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !217, metadata !47), !dbg !223
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !218, metadata !47), !dbg !224
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !219, metadata !47), !dbg !225
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !220, metadata !47), !dbg !226
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !221, metadata !47), !dbg !227
  %7 = tail call i32 @usb_h_ep_write(i8 zeroext %0, i8 zeroext %1, i16 zeroext %2, i8 zeroext %3, i8* %4, i32 %5, i32 2) #5, !dbg !228
  ret i32 %7, !dbg !229
}

; Function Attrs: minsize optsize
declare i32 @usb_h_ep_write(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32, i32) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_intr_read(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32) local_unnamed_addr #1 !dbg !230 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !232, metadata !47), !dbg !238
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !233, metadata !47), !dbg !239
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !234, metadata !47), !dbg !240
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !235, metadata !47), !dbg !241
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !236, metadata !47), !dbg !242
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !237, metadata !47), !dbg !243
  %7 = tail call i32 @usb_h_ep_read(i8 zeroext %0, i8 zeroext %1, i16 zeroext %2, i8 zeroext %3, i8* %4, i32 %5, i32 3) #5, !dbg !244
  ret i32 %7, !dbg !245
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_intr_write(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32) local_unnamed_addr #1 !dbg !246 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !248, metadata !47), !dbg !254
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !249, metadata !47), !dbg !255
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !250, metadata !47), !dbg !256
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !251, metadata !47), !dbg !257
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !252, metadata !47), !dbg !258
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !253, metadata !47), !dbg !259
  %7 = tail call i32 @usb_h_ep_write(i8 zeroext %0, i8 zeroext %1, i16 zeroext %2, i8 zeroext %3, i8* %4, i32 %5, i32 3) #5, !dbg !260
  ret i32 %7, !dbg !261
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_iso_read(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32) local_unnamed_addr #1 !dbg !262 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !264, metadata !47), !dbg !270
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !265, metadata !47), !dbg !271
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !266, metadata !47), !dbg !272
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !267, metadata !47), !dbg !273
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !268, metadata !47), !dbg !274
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !269, metadata !47), !dbg !275
  %7 = tail call i32 @usb_h_ep_read(i8 zeroext %0, i8 zeroext %1, i16 zeroext %2, i8 zeroext %3, i8* %4, i32 %5, i32 1) #5, !dbg !276
  ret i32 %7, !dbg !277
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_h_iso_write(i8 zeroext, i8 zeroext, i16 zeroext, i8 zeroext, i8*, i32) local_unnamed_addr #1 !dbg !278 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !280, metadata !47), !dbg !286
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !281, metadata !47), !dbg !287
  tail call void @llvm.dbg.value(metadata i16 %2, i64 0, metadata !282, metadata !47), !dbg !288
  tail call void @llvm.dbg.value(metadata i8 %3, i64 0, metadata !283, metadata !47), !dbg !289
  tail call void @llvm.dbg.value(metadata i8* %4, i64 0, metadata !284, metadata !47), !dbg !290
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !285, metadata !47), !dbg !291
  %7 = tail call i32 @usb_h_ep_write(i8 zeroext %0, i8 zeroext %1, i16 zeroext %2, i8 zeroext %3, i8* %4, i32 %5, i32 1) #5, !dbg !292
  ret i32 %7, !dbg !293
}

; Function Attrs: minsize nounwind optsize
define void @usb_h_entry_suspend(i8 zeroext) local_unnamed_addr #1 !dbg !294 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !296, metadata !47), !dbg !298
  %2 = tail call i32 @usb_read_power(i8 zeroext %0) #5, !dbg !299
  %3 = and i32 %2, 253, !dbg !300
  %4 = or i32 %3, 2, !dbg !301
  tail call void @usb_write_power(i8 zeroext %0, i32 %4) #5, !dbg !302
  %5 = load volatile i32, i32* inttoptr (i32 65552 to i32*), align 16, !dbg !303, !tbaa !304
  %6 = or i32 %5, 3, !dbg !303
  store volatile i32 %6, i32* inttoptr (i32 65552 to i32*), align 16, !dbg !303, !tbaa !304
  ret void, !dbg !307
}

; Function Attrs: minsize optsize
declare i32 @usb_read_power(i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_write_power(i8 zeroext, i32) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define void @usb_h_resume(i8 zeroext) local_unnamed_addr #1 !dbg !308 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !310, metadata !47), !dbg !312
  %2 = load volatile i32, i32* inttoptr (i32 65552 to i32*), align 16, !dbg !313, !tbaa !304
  %3 = and i32 %2, -4, !dbg !313
  store volatile i32 %3, i32* inttoptr (i32 65552 to i32*), align 16, !dbg !313, !tbaa !304
  tail call void @usb_mdelay(i32 2) #6, !dbg !314
  %4 = tail call i32 @usb_read_power(i8 zeroext %0) #5, !dbg !315
  %5 = and i32 %4, 251, !dbg !316
  %6 = or i32 %5, 4, !dbg !317
  tail call void @usb_write_power(i8 zeroext %0, i32 %6) #5, !dbg !318
  tail call void @usb_mdelay(i32 20) #6, !dbg !319
  %7 = tail call i32 @usb_read_power(i8 zeroext %0) #5, !dbg !320
  %8 = and i32 %7, 251, !dbg !321
  tail call void @usb_write_power(i8 zeroext %0, i32 %8) #5, !dbg !322
  ret void, !dbg !323
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_host_init(i8 zeroext, i32, i32) local_unnamed_addr #1 !dbg !324 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !328, metadata !47), !dbg !331
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !329, metadata !47), !dbg !332
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !330, metadata !47), !dbg !333
  tail call void @usb_write_intr_usbe(i8 zeroext %0, i32 0) #5, !dbg !334
  tail call void @usb_clr_intr_txe(i8 zeroext %0, i32 -1) #5, !dbg !335
  tail call void @usb_clr_intr_rxe(i8 zeroext %0, i32 -1) #5, !dbg !336
  %4 = tail call i32 @usb_h_chirp_and_reset(i8 zeroext %0, i32 %1, i32 %2) #5, !dbg !337
  ret i32 %4, !dbg !338
}

; Function Attrs: minsize optsize
declare i32 @usb_h_chirp_and_reset(i8 zeroext, i32, i32) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i32 @usb_host_reset(i8 zeroext, i32, i32) local_unnamed_addr #1 !dbg !339 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !341, metadata !47), !dbg !344
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !342, metadata !47), !dbg !345
  tail call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !343, metadata !47), !dbg !346
  %4 = load i8, i8* @log_tag_const_e_USB, align 1, !dbg !347, !tbaa !349
  %5 = icmp eq i8 %4, 0, !dbg !347
  br i1 %5, label %7, label %6, !dbg !350

; <label>:6:                                      ; preds = %3
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str, i32 0, i32 0)) #5, !dbg !351
  br label %7, !dbg !351

; <label>:7:                                      ; preds = %6, %3
  %8 = tail call i32 @usb_h_chirp_and_reset(i8 zeroext %0, i32 %1, i32 %2) #5, !dbg !353
  ret i32 %8, !dbg !354
}

; Function Attrs: minsize optsize
declare void @log_print(i32, i8*, i8*, ...) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define void @usb_disable_for_ota() local_unnamed_addr #1 !dbg !355 {
  tail call void @usb_sie_close_all() #5, !dbg !358
  ret void, !dbg !359
}

; Function Attrs: minsize optsize
declare void @usb_sie_close_all() local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i32 @user_host_speaker_control(i8*) local_unnamed_addr #1 !dbg !360 {
  %2 = alloca [32 x i8], align 1
  tail call void @llvm.dbg.value(metadata i8* %0, i64 0, metadata !366, metadata !47), !dbg !377
  %3 = bitcast i8* %0 to %struct.usb_host_device*, !dbg !378
  tail call void @llvm.dbg.value(metadata %struct.usb_host_device* %3, i64 0, metadata !367, metadata !47), !dbg !379
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !370, metadata !47), !dbg !380
  tail call void @llvm.dbg.value(metadata i16 1024, i64 0, metadata !371, metadata !47), !dbg !381
  tail call void @llvm.dbg.value(metadata i16 768, i64 0, metadata !372, metadata !47), !dbg !382
  %4 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i32 0, i32 0, !dbg !383
  call void @llvm.lifetime.start(i64 32, i8* nonnull %4) #7, !dbg !383
  tail call void @llvm.dbg.declare(metadata [32 x i8]* %2, metadata !373, metadata !47), !dbg !384
  %5 = call i32 @usb_control_msg(%struct.usb_host_device* %3, i8 zeroext -127, i8 zeroext -95, i16 zeroext 1024, i16 zeroext 768, i8* nonnull %4, i16 zeroext 32) #5, !dbg !385
  call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !370, metadata !47), !dbg !380
  call void @CrcDecode(i8* nonnull %4, i16 zeroext 32) #5, !dbg !386
  %6 = call i32 @usb_control_msg(%struct.usb_host_device* %3, i8 zeroext 1, i8 zeroext 33, i16 zeroext 1024, i16 zeroext 768, i8* nonnull %4, i16 zeroext 32) #5, !dbg !387
  call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !370, metadata !47), !dbg !380
  call void @llvm.lifetime.end(i64 32, i8* nonnull %4) #7, !dbg !388
  ret i32 %6, !dbg !389
}

; Function Attrs: minsize optsize
declare i32 @usb_control_msg(%struct.usb_host_device*, i8 zeroext, i8 zeroext, i16 zeroext, i16 zeroext, i8*, i16 zeroext) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @CrcDecode(i8*, i16 zeroext) local_unnamed_addr #4

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #2

attributes #0 = { minsize norecurse nounwind optsize "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { minsize nounwind optsize "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readnone }
attributes #3 = { argmemonly nounwind }
attributes #4 = { minsize optsize "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { minsize nounwind optsize }
attributes #6 = { minsize optsize }
attributes #7 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!26, !27}
!llvm.ident = !{!28}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 4.0.1 () ()", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !10)
!1 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/device/usb/usb_phy.c", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!2 = !{!3}
!3 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !4, line: 284, size: 32, elements: !5)
!4 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/clock_hw.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!5 = !{!6, !7, !8, !9}
!6 = !DIEnumerator(name: "USB_CLOCK_IN_PLL48M", value: 0)
!7 = !DIEnumerator(name: "USB_CLOCK_IN_OSC", value: 1)
!8 = !DIEnumerator(name: "USB_CLOCK_IN_LSB", value: 2)
!9 = !DIEnumerator(name: "USB_CLOCK_IN_DISABLE", value: 3)
!10 = !{!11, !12}
!11 = !DIBasicType(name: "long int", size: 32, encoding: DW_ATE_signed)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 32)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "JL_CLOCK_TypeDef", file: !14, line: 355, baseType: !15)
!14 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/WL82.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!15 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !14, line: 347, size: 224, elements: !16)
!16 = !{!17, !20, !21, !22, !23, !24, !25}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "PWR_CON", scope: !15, file: !14, line: 348, baseType: !18, size: 32)
!18 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !19)
!19 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "RESERVED0", scope: !15, file: !14, line: 349, baseType: !18, size: 32, offset: 32)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "SYS_DIV", scope: !15, file: !14, line: 350, baseType: !18, size: 32, offset: 64)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "CLK_CON0", scope: !15, file: !14, line: 351, baseType: !18, size: 32, offset: 96)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "CLK_CON1", scope: !15, file: !14, line: 352, baseType: !18, size: 32, offset: 128)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "CLK_CON2", scope: !15, file: !14, line: 353, baseType: !18, size: 32, offset: 160)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "CLK_CON3", scope: !15, file: !14, line: 354, baseType: !18, size: 32, offset: 192)
!26 = !{i32 2, !"Dwarf Version", i32 4}
!27 = !{i32 2, !"Debug Info Version", i32 3}
!28 = !{!"clang version 4.0.1 () ()"}
!29 = distinct !DISubprogram(name: "get_jiffies", scope: !1, file: !1, line: 24, type: !30, isLocal: false, isDefinition: true, scopeLine: 25, isOptimized: true, unit: !0, variables: !34)
!30 = !DISubroutineType(types: !31)
!31 = !{!32}
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "u32", file: !33, line: 19, baseType: !19)
!33 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/cpu.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!34 = !{}
!35 = !DILocation(line: 26, column: 12, scope: !29)
!36 = !{!37, !37, i64 0}
!37 = !{!"long", !38, i64 0}
!38 = !{!"omnipotent char", !39, i64 0}
!39 = !{!"Simple C/C++ TBAA"}
!40 = !DILocation(line: 26, column: 5, scope: !29)
!41 = distinct !DISubprogram(name: "usb_mdelay", scope: !1, file: !1, line: 29, type: !42, isLocal: false, isDefinition: true, scopeLine: 30, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !44)
!42 = !DISubroutineType(types: !43)
!43 = !{null, !19}
!44 = !{!45, !46}
!45 = !DILocalVariable(name: "ms", arg: 1, scope: !41, file: !1, line: 29, type: !19)
!46 = !DILocalVariable(name: "t", scope: !41, file: !1, line: 31, type: !19)
!47 = !DIExpression()
!48 = !DILocation(line: 29, column: 30, scope: !41)
!49 = !DILocation(line: 33, column: 12, scope: !41)
!50 = !DILocation(line: 33, column: 24, scope: !41)
!51 = !DILocation(line: 33, column: 30, scope: !41)
!52 = !DILocation(line: 33, column: 20, scope: !41)
!53 = !DILocation(line: 33, column: 17, scope: !41)
!54 = !DILocation(line: 31, column: 18, scope: !41)
!55 = !DILocation(line: 35, column: 19, scope: !41)
!56 = !DILocation(line: 35, column: 17, scope: !41)
!57 = !DILocation(line: 35, column: 5, scope: !58)
!58 = !DILexicalBlockFile(scope: !41, file: !1, discriminator: 3)
!59 = !DILocation(line: 36, column: 1, scope: !41)
!60 = distinct !DISubprogram(name: "usb_host_timeout", scope: !1, file: !1, line: 39, type: !61, isLocal: false, isDefinition: true, scopeLine: 40, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!32, !32}
!63 = !{!64}
!64 = !DILocalVariable(name: "ot", arg: 1, scope: !60, file: !1, line: 39, type: !32)
!65 = !DILocation(line: 39, column: 26, scope: !60)
!66 = !DILocation(line: 26, column: 12, scope: !29, inlinedAt: !67)
!67 = distinct !DILocation(line: 41, column: 12, scope: !60)
!68 = !DILocation(line: 41, column: 12, scope: !60)
!69 = !DILocation(line: 41, column: 5, scope: !60)
!70 = distinct !DISubprogram(name: "usb_g_bulk_read64byte_fast", scope: !1, file: !1, line: 47, type: !71, isLocal: false, isDefinition: true, scopeLine: 48, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !79)
!71 = !DISubroutineType(types: !72)
!72 = !{!32, !73, !32, !78, !32}
!73 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !74)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "usb_dev", file: !75, line: 146, baseType: !76)
!75 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/usb.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "u8", file: !33, line: 14, baseType: !77)
!77 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 32)
!79 = !{!80, !81, !82, !83}
!80 = !DILocalVariable(name: "usb_id", arg: 1, scope: !70, file: !1, line: 47, type: !73)
!81 = !DILocalVariable(name: "ep", arg: 2, scope: !70, file: !1, line: 47, type: !32)
!82 = !DILocalVariable(name: "ptr", arg: 3, scope: !70, file: !1, line: 47, type: !78)
!83 = !DILocalVariable(name: "len", arg: 4, scope: !70, file: !1, line: 47, type: !32)
!84 = !DILocation(line: 47, column: 46, scope: !70)
!85 = !DILocation(line: 47, column: 58, scope: !70)
!86 = !DILocation(line: 47, column: 66, scope: !70)
!87 = !DILocation(line: 47, column: 75, scope: !70)
!88 = !DILocation(line: 49, column: 12, scope: !70)
!89 = !DILocation(line: 49, column: 5, scope: !70)
!90 = distinct !DISubprogram(name: "usb_g_bulk_read", scope: !1, file: !1, line: 51, type: !91, isLocal: false, isDefinition: true, scopeLine: 52, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !93)
!91 = !DISubroutineType(types: !92)
!92 = !{!32, !73, !32, !78, !32, !32}
!93 = !{!94, !95, !96, !97, !98}
!94 = !DILocalVariable(name: "usb_id", arg: 1, scope: !90, file: !1, line: 51, type: !73)
!95 = !DILocalVariable(name: "ep", arg: 2, scope: !90, file: !1, line: 51, type: !32)
!96 = !DILocalVariable(name: "ptr", arg: 3, scope: !90, file: !1, line: 51, type: !78)
!97 = !DILocalVariable(name: "len", arg: 4, scope: !90, file: !1, line: 51, type: !32)
!98 = !DILocalVariable(name: "block", arg: 5, scope: !90, file: !1, line: 51, type: !32)
!99 = !DILocation(line: 51, column: 35, scope: !90)
!100 = !DILocation(line: 51, column: 47, scope: !90)
!101 = !DILocation(line: 51, column: 55, scope: !90)
!102 = !DILocation(line: 51, column: 64, scope: !90)
!103 = !DILocation(line: 51, column: 73, scope: !90)
!104 = !DILocation(line: 53, column: 12, scope: !90)
!105 = !DILocation(line: 53, column: 5, scope: !90)
!106 = distinct !DISubprogram(name: "usb_g_bulk_write", scope: !1, file: !1, line: 55, type: !107, isLocal: false, isDefinition: true, scopeLine: 56, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !111)
!107 = !DISubroutineType(types: !108)
!108 = !{!32, !73, !32, !109, !32}
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !110, size: 32)
!110 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !76)
!111 = !{!112, !113, !114, !115}
!112 = !DILocalVariable(name: "usb_id", arg: 1, scope: !106, file: !1, line: 55, type: !73)
!113 = !DILocalVariable(name: "ep", arg: 2, scope: !106, file: !1, line: 55, type: !32)
!114 = !DILocalVariable(name: "ptr", arg: 3, scope: !106, file: !1, line: 55, type: !109)
!115 = !DILocalVariable(name: "len", arg: 4, scope: !106, file: !1, line: 55, type: !32)
!116 = !DILocation(line: 55, column: 36, scope: !106)
!117 = !DILocation(line: 55, column: 48, scope: !106)
!118 = !DILocation(line: 55, column: 62, scope: !106)
!119 = !DILocation(line: 55, column: 71, scope: !106)
!120 = !DILocation(line: 57, column: 12, scope: !106)
!121 = !DILocation(line: 57, column: 5, scope: !106)
!122 = distinct !DISubprogram(name: "usb_g_intr_read", scope: !1, file: !1, line: 59, type: !91, isLocal: false, isDefinition: true, scopeLine: 60, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !123)
!123 = !{!124, !125, !126, !127, !128}
!124 = !DILocalVariable(name: "usb_id", arg: 1, scope: !122, file: !1, line: 59, type: !73)
!125 = !DILocalVariable(name: "ep", arg: 2, scope: !122, file: !1, line: 59, type: !32)
!126 = !DILocalVariable(name: "ptr", arg: 3, scope: !122, file: !1, line: 59, type: !78)
!127 = !DILocalVariable(name: "len", arg: 4, scope: !122, file: !1, line: 59, type: !32)
!128 = !DILocalVariable(name: "block", arg: 5, scope: !122, file: !1, line: 59, type: !32)
!129 = !DILocation(line: 59, column: 35, scope: !122)
!130 = !DILocation(line: 59, column: 47, scope: !122)
!131 = !DILocation(line: 59, column: 55, scope: !122)
!132 = !DILocation(line: 59, column: 64, scope: !122)
!133 = !DILocation(line: 59, column: 74, scope: !122)
!134 = !DILocation(line: 61, column: 12, scope: !122)
!135 = !DILocation(line: 61, column: 5, scope: !122)
!136 = distinct !DISubprogram(name: "usb_g_intr_write", scope: !1, file: !1, line: 63, type: !107, isLocal: false, isDefinition: true, scopeLine: 64, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !137)
!137 = !{!138, !139, !140, !141}
!138 = !DILocalVariable(name: "usb_id", arg: 1, scope: !136, file: !1, line: 63, type: !73)
!139 = !DILocalVariable(name: "ep", arg: 2, scope: !136, file: !1, line: 63, type: !32)
!140 = !DILocalVariable(name: "ptr", arg: 3, scope: !136, file: !1, line: 63, type: !109)
!141 = !DILocalVariable(name: "len", arg: 4, scope: !136, file: !1, line: 63, type: !32)
!142 = !DILocation(line: 63, column: 36, scope: !136)
!143 = !DILocation(line: 63, column: 48, scope: !136)
!144 = !DILocation(line: 63, column: 62, scope: !136)
!145 = !DILocation(line: 63, column: 71, scope: !136)
!146 = !DILocation(line: 65, column: 12, scope: !136)
!147 = !DILocation(line: 65, column: 5, scope: !136)
!148 = distinct !DISubprogram(name: "usb_g_iso_read", scope: !1, file: !1, line: 67, type: !91, isLocal: false, isDefinition: true, scopeLine: 68, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !149)
!149 = !{!150, !151, !152, !153, !154}
!150 = !DILocalVariable(name: "usb_id", arg: 1, scope: !148, file: !1, line: 67, type: !73)
!151 = !DILocalVariable(name: "ep", arg: 2, scope: !148, file: !1, line: 67, type: !32)
!152 = !DILocalVariable(name: "ptr", arg: 3, scope: !148, file: !1, line: 67, type: !78)
!153 = !DILocalVariable(name: "len", arg: 4, scope: !148, file: !1, line: 67, type: !32)
!154 = !DILocalVariable(name: "block", arg: 5, scope: !148, file: !1, line: 67, type: !32)
!155 = !DILocation(line: 67, column: 34, scope: !148)
!156 = !DILocation(line: 67, column: 46, scope: !148)
!157 = !DILocation(line: 67, column: 54, scope: !148)
!158 = !DILocation(line: 67, column: 63, scope: !148)
!159 = !DILocation(line: 67, column: 72, scope: !148)
!160 = !DILocation(line: 69, column: 12, scope: !148)
!161 = !DILocation(line: 69, column: 5, scope: !148)
!162 = distinct !DISubprogram(name: "usb_g_iso_write", scope: !1, file: !1, line: 71, type: !107, isLocal: false, isDefinition: true, scopeLine: 72, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !163)
!163 = !{!164, !165, !166, !167}
!164 = !DILocalVariable(name: "usb_id", arg: 1, scope: !162, file: !1, line: 71, type: !73)
!165 = !DILocalVariable(name: "ep", arg: 2, scope: !162, file: !1, line: 71, type: !32)
!166 = !DILocalVariable(name: "ptr", arg: 3, scope: !162, file: !1, line: 71, type: !109)
!167 = !DILocalVariable(name: "len", arg: 4, scope: !162, file: !1, line: 71, type: !32)
!168 = !DILocation(line: 71, column: 35, scope: !162)
!169 = !DILocation(line: 71, column: 47, scope: !162)
!170 = !DILocation(line: 71, column: 61, scope: !162)
!171 = !DILocation(line: 71, column: 70, scope: !162)
!172 = !DILocation(line: 73, column: 12, scope: !162)
!173 = !DILocation(line: 73, column: 5, scope: !162)
!174 = distinct !DISubprogram(name: "usb_slave_init", scope: !1, file: !1, line: 75, type: !175, isLocal: false, isDefinition: true, scopeLine: 76, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !177)
!175 = !DISubroutineType(types: !176)
!176 = !{null, !73}
!177 = !{!178}
!178 = !DILocalVariable(name: "usb_id", arg: 1, scope: !174, file: !1, line: 75, type: !73)
!179 = !DILocation(line: 75, column: 35, scope: !174)
!180 = !DILocation(line: 78, column: 5, scope: !174)
!181 = !DILocation(line: 79, column: 5, scope: !174)
!182 = !DILocation(line: 80, column: 5, scope: !174)
!183 = !DILocation(line: 81, column: 5, scope: !174)
!184 = !DILocation(line: 82, column: 1, scope: !174)
!185 = distinct !DISubprogram(name: "usb_read_sofframe", scope: !1, file: !1, line: 84, type: !186, isLocal: false, isDefinition: true, scopeLine: 85, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !190)
!186 = !DISubroutineType(types: !187)
!187 = !{!188, !73}
!188 = !DIDerivedType(tag: DW_TAG_typedef, name: "u16", file: !33, line: 17, baseType: !189)
!189 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!190 = !{!191}
!191 = !DILocalVariable(name: "id", arg: 1, scope: !185, file: !1, line: 84, type: !73)
!192 = !DILocation(line: 84, column: 37, scope: !185)
!193 = !DILocation(line: 86, column: 12, scope: !185)
!194 = !DILocation(line: 86, column: 5, scope: !185)
!195 = distinct !DISubprogram(name: "usb_h_bulk_read", scope: !1, file: !1, line: 93, type: !196, isLocal: false, isDefinition: true, scopeLine: 94, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !199)
!196 = !DISubroutineType(types: !197)
!197 = !{!198, !73, !76, !188, !76, !78, !32}
!198 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!199 = !{!200, !201, !202, !203, !204, !205}
!200 = !DILocalVariable(name: "usb_id", arg: 1, scope: !195, file: !1, line: 93, type: !73)
!201 = !DILocalVariable(name: "host_ep", arg: 2, scope: !195, file: !1, line: 93, type: !76)
!202 = !DILocalVariable(name: "rxmaxp", arg: 3, scope: !195, file: !1, line: 93, type: !188)
!203 = !DILocalVariable(name: "target_ep", arg: 4, scope: !195, file: !1, line: 93, type: !76)
!204 = !DILocalVariable(name: "ptr", arg: 5, scope: !195, file: !1, line: 93, type: !78)
!205 = !DILocalVariable(name: "len", arg: 6, scope: !195, file: !1, line: 93, type: !32)
!206 = !DILocation(line: 93, column: 35, scope: !195)
!207 = !DILocation(line: 93, column: 46, scope: !195)
!208 = !DILocation(line: 93, column: 59, scope: !195)
!209 = !DILocation(line: 93, column: 70, scope: !195)
!210 = !DILocation(line: 93, column: 85, scope: !195)
!211 = !DILocation(line: 93, column: 94, scope: !195)
!212 = !DILocation(line: 95, column: 12, scope: !195)
!213 = !DILocation(line: 95, column: 5, scope: !195)
!214 = distinct !DISubprogram(name: "usb_h_bulk_write", scope: !1, file: !1, line: 97, type: !196, isLocal: false, isDefinition: true, scopeLine: 98, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !215)
!215 = !{!216, !217, !218, !219, !220, !221}
!216 = !DILocalVariable(name: "usb_id", arg: 1, scope: !214, file: !1, line: 97, type: !73)
!217 = !DILocalVariable(name: "host_ep", arg: 2, scope: !214, file: !1, line: 97, type: !76)
!218 = !DILocalVariable(name: "txmaxp", arg: 3, scope: !214, file: !1, line: 97, type: !188)
!219 = !DILocalVariable(name: "target_ep", arg: 4, scope: !214, file: !1, line: 97, type: !76)
!220 = !DILocalVariable(name: "ptr", arg: 5, scope: !214, file: !1, line: 97, type: !78)
!221 = !DILocalVariable(name: "len", arg: 6, scope: !214, file: !1, line: 97, type: !32)
!222 = !DILocation(line: 97, column: 36, scope: !214)
!223 = !DILocation(line: 97, column: 47, scope: !214)
!224 = !DILocation(line: 97, column: 60, scope: !214)
!225 = !DILocation(line: 97, column: 71, scope: !214)
!226 = !DILocation(line: 97, column: 86, scope: !214)
!227 = !DILocation(line: 97, column: 95, scope: !214)
!228 = !DILocation(line: 99, column: 12, scope: !214)
!229 = !DILocation(line: 99, column: 5, scope: !214)
!230 = distinct !DISubprogram(name: "usb_h_intr_read", scope: !1, file: !1, line: 101, type: !196, isLocal: false, isDefinition: true, scopeLine: 102, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !231)
!231 = !{!232, !233, !234, !235, !236, !237}
!232 = !DILocalVariable(name: "usb_id", arg: 1, scope: !230, file: !1, line: 101, type: !73)
!233 = !DILocalVariable(name: "host_ep", arg: 2, scope: !230, file: !1, line: 101, type: !76)
!234 = !DILocalVariable(name: "rxmaxp", arg: 3, scope: !230, file: !1, line: 101, type: !188)
!235 = !DILocalVariable(name: "target_ep", arg: 4, scope: !230, file: !1, line: 101, type: !76)
!236 = !DILocalVariable(name: "ptr", arg: 5, scope: !230, file: !1, line: 101, type: !78)
!237 = !DILocalVariable(name: "len", arg: 6, scope: !230, file: !1, line: 101, type: !32)
!238 = !DILocation(line: 101, column: 35, scope: !230)
!239 = !DILocation(line: 101, column: 46, scope: !230)
!240 = !DILocation(line: 101, column: 59, scope: !230)
!241 = !DILocation(line: 101, column: 70, scope: !230)
!242 = !DILocation(line: 101, column: 85, scope: !230)
!243 = !DILocation(line: 101, column: 94, scope: !230)
!244 = !DILocation(line: 103, column: 12, scope: !230)
!245 = !DILocation(line: 103, column: 5, scope: !230)
!246 = distinct !DISubprogram(name: "usb_h_intr_write", scope: !1, file: !1, line: 105, type: !196, isLocal: false, isDefinition: true, scopeLine: 106, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !247)
!247 = !{!248, !249, !250, !251, !252, !253}
!248 = !DILocalVariable(name: "usb_id", arg: 1, scope: !246, file: !1, line: 105, type: !73)
!249 = !DILocalVariable(name: "host_ep", arg: 2, scope: !246, file: !1, line: 105, type: !76)
!250 = !DILocalVariable(name: "txmaxp", arg: 3, scope: !246, file: !1, line: 105, type: !188)
!251 = !DILocalVariable(name: "target_ep", arg: 4, scope: !246, file: !1, line: 105, type: !76)
!252 = !DILocalVariable(name: "ptr", arg: 5, scope: !246, file: !1, line: 105, type: !78)
!253 = !DILocalVariable(name: "len", arg: 6, scope: !246, file: !1, line: 105, type: !32)
!254 = !DILocation(line: 105, column: 36, scope: !246)
!255 = !DILocation(line: 105, column: 47, scope: !246)
!256 = !DILocation(line: 105, column: 60, scope: !246)
!257 = !DILocation(line: 105, column: 71, scope: !246)
!258 = !DILocation(line: 105, column: 86, scope: !246)
!259 = !DILocation(line: 105, column: 95, scope: !246)
!260 = !DILocation(line: 107, column: 12, scope: !246)
!261 = !DILocation(line: 107, column: 5, scope: !246)
!262 = distinct !DISubprogram(name: "usb_h_iso_read", scope: !1, file: !1, line: 109, type: !196, isLocal: false, isDefinition: true, scopeLine: 110, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !263)
!263 = !{!264, !265, !266, !267, !268, !269}
!264 = !DILocalVariable(name: "usb_id", arg: 1, scope: !262, file: !1, line: 109, type: !73)
!265 = !DILocalVariable(name: "host_ep", arg: 2, scope: !262, file: !1, line: 109, type: !76)
!266 = !DILocalVariable(name: "rxmaxp", arg: 3, scope: !262, file: !1, line: 109, type: !188)
!267 = !DILocalVariable(name: "target_ep", arg: 4, scope: !262, file: !1, line: 109, type: !76)
!268 = !DILocalVariable(name: "ptr", arg: 5, scope: !262, file: !1, line: 109, type: !78)
!269 = !DILocalVariable(name: "len", arg: 6, scope: !262, file: !1, line: 109, type: !32)
!270 = !DILocation(line: 109, column: 34, scope: !262)
!271 = !DILocation(line: 109, column: 45, scope: !262)
!272 = !DILocation(line: 109, column: 58, scope: !262)
!273 = !DILocation(line: 109, column: 69, scope: !262)
!274 = !DILocation(line: 109, column: 84, scope: !262)
!275 = !DILocation(line: 109, column: 93, scope: !262)
!276 = !DILocation(line: 111, column: 12, scope: !262)
!277 = !DILocation(line: 111, column: 5, scope: !262)
!278 = distinct !DISubprogram(name: "usb_h_iso_write", scope: !1, file: !1, line: 113, type: !196, isLocal: false, isDefinition: true, scopeLine: 114, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !279)
!279 = !{!280, !281, !282, !283, !284, !285}
!280 = !DILocalVariable(name: "usb_id", arg: 1, scope: !278, file: !1, line: 113, type: !73)
!281 = !DILocalVariable(name: "host_ep", arg: 2, scope: !278, file: !1, line: 113, type: !76)
!282 = !DILocalVariable(name: "txmaxp", arg: 3, scope: !278, file: !1, line: 113, type: !188)
!283 = !DILocalVariable(name: "target_ep", arg: 4, scope: !278, file: !1, line: 113, type: !76)
!284 = !DILocalVariable(name: "ptr", arg: 5, scope: !278, file: !1, line: 113, type: !78)
!285 = !DILocalVariable(name: "len", arg: 6, scope: !278, file: !1, line: 113, type: !32)
!286 = !DILocation(line: 113, column: 35, scope: !278)
!287 = !DILocation(line: 113, column: 46, scope: !278)
!288 = !DILocation(line: 113, column: 59, scope: !278)
!289 = !DILocation(line: 113, column: 70, scope: !278)
!290 = !DILocation(line: 113, column: 85, scope: !278)
!291 = !DILocation(line: 113, column: 94, scope: !278)
!292 = !DILocation(line: 115, column: 12, scope: !278)
!293 = !DILocation(line: 115, column: 5, scope: !278)
!294 = distinct !DISubprogram(name: "usb_h_entry_suspend", scope: !1, file: !1, line: 117, type: !175, isLocal: false, isDefinition: true, scopeLine: 118, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !295)
!295 = !{!296, !297}
!296 = !DILocalVariable(name: "usb_id", arg: 1, scope: !294, file: !1, line: 117, type: !73)
!297 = !DILocalVariable(name: "power", scope: !294, file: !1, line: 119, type: !76)
!298 = !DILocation(line: 117, column: 40, scope: !294)
!299 = !DILocation(line: 119, column: 16, scope: !294)
!300 = !DILocation(line: 120, column: 29, scope: !294)
!301 = !DILocation(line: 120, column: 35, scope: !294)
!302 = !DILocation(line: 120, column: 5, scope: !294)
!303 = !DILocation(line: 123, column: 5, scope: !294)
!304 = !{!305, !306, i64 16}
!305 = !{!"", !306, i64 0, !306, i64 4, !306, i64 8, !306, i64 12, !306, i64 16, !306, i64 20, !306, i64 24}
!306 = !{!"int", !38, i64 0}
!307 = !DILocation(line: 124, column: 1, scope: !294)
!308 = distinct !DISubprogram(name: "usb_h_resume", scope: !1, file: !1, line: 126, type: !175, isLocal: false, isDefinition: true, scopeLine: 127, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !309)
!309 = !{!310, !311}
!310 = !DILocalVariable(name: "usb_id", arg: 1, scope: !308, file: !1, line: 126, type: !73)
!311 = !DILocalVariable(name: "power", scope: !308, file: !1, line: 134, type: !76)
!312 = !DILocation(line: 126, column: 33, scope: !308)
!313 = !DILocation(line: 131, column: 5, scope: !308)
!314 = !DILocation(line: 133, column: 5, scope: !308)
!315 = !DILocation(line: 134, column: 16, scope: !308)
!316 = !DILocation(line: 135, column: 29, scope: !308)
!317 = !DILocation(line: 135, column: 35, scope: !308)
!318 = !DILocation(line: 135, column: 5, scope: !308)
!319 = !DILocation(line: 136, column: 5, scope: !308)
!320 = !DILocation(line: 137, column: 13, scope: !308)
!321 = !DILocation(line: 138, column: 11, scope: !308)
!322 = !DILocation(line: 139, column: 5, scope: !308)
!323 = !DILocation(line: 141, column: 1, scope: !308)
!324 = distinct !DISubprogram(name: "usb_host_init", scope: !1, file: !1, line: 143, type: !325, isLocal: false, isDefinition: true, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !327)
!325 = !DISubroutineType(types: !326)
!326 = !{!198, !73, !32, !32}
!327 = !{!328, !329, !330}
!328 = !DILocalVariable(name: "usb_id", arg: 1, scope: !324, file: !1, line: 143, type: !73)
!329 = !DILocalVariable(name: "reset_delay", arg: 2, scope: !324, file: !1, line: 143, type: !32)
!330 = !DILocalVariable(name: "timeout", arg: 3, scope: !324, file: !1, line: 143, type: !32)
!331 = !DILocation(line: 143, column: 33, scope: !324)
!332 = !DILocation(line: 143, column: 45, scope: !324)
!333 = !DILocation(line: 143, column: 62, scope: !324)
!334 = !DILocation(line: 145, column: 5, scope: !324)
!335 = !DILocation(line: 146, column: 5, scope: !324)
!336 = !DILocation(line: 147, column: 5, scope: !324)
!337 = !DILocation(line: 149, column: 12, scope: !324)
!338 = !DILocation(line: 149, column: 5, scope: !324)
!339 = distinct !DISubprogram(name: "usb_host_reset", scope: !1, file: !1, line: 151, type: !325, isLocal: false, isDefinition: true, scopeLine: 152, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !340)
!340 = !{!341, !342, !343}
!341 = !DILocalVariable(name: "usb_id", arg: 1, scope: !339, file: !1, line: 151, type: !73)
!342 = !DILocalVariable(name: "reset_delay", arg: 2, scope: !339, file: !1, line: 151, type: !32)
!343 = !DILocalVariable(name: "timeout", arg: 3, scope: !339, file: !1, line: 151, type: !32)
!344 = !DILocation(line: 151, column: 34, scope: !339)
!345 = !DILocation(line: 151, column: 46, scope: !339)
!346 = !DILocation(line: 151, column: 63, scope: !339)
!347 = !DILocation(line: 153, column: 5, scope: !348)
!348 = distinct !DILexicalBlock(scope: !339, file: !1, line: 153, column: 5)
!349 = !{!38, !38, i64 0}
!350 = !DILocation(line: 153, column: 5, scope: !339)
!351 = !DILocation(line: 153, column: 5, scope: !352)
!352 = !DILexicalBlockFile(scope: !348, file: !1, discriminator: 1)
!353 = !DILocation(line: 154, column: 12, scope: !339)
!354 = !DILocation(line: 154, column: 5, scope: !339)
!355 = distinct !DISubprogram(name: "usb_disable_for_ota", scope: !1, file: !1, line: 157, type: !356, isLocal: false, isDefinition: true, scopeLine: 158, isOptimized: true, unit: !0, variables: !34)
!356 = !DISubroutineType(types: !357)
!357 = !{null}
!358 = !DILocation(line: 159, column: 5, scope: !355)
!359 = !DILocation(line: 160, column: 1, scope: !355)
!360 = distinct !DISubprogram(name: "user_host_speaker_control", scope: !1, file: !1, line: 292, type: !361, isLocal: false, isDefinition: true, scopeLine: 293, flags: DIFlagPrototyped, isOptimized: true, unit: !0, variables: !365)
!361 = !DISubroutineType(types: !362)
!362 = !{!363, !364}
!363 = !DIDerivedType(tag: DW_TAG_typedef, name: "s32", file: !33, line: 20, baseType: !198)
!364 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!365 = !{!366, !367, !370, !371, !372, !373}
!366 = !DILocalVariable(name: "hdl", arg: 1, scope: !360, file: !1, line: 292, type: !364)
!367 = !DILocalVariable(name: "host_dev", scope: !360, file: !1, line: 294, type: !368)
!368 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !369, size: 32)
!369 = !DICompositeType(tag: DW_TAG_structure_type, name: "usb_host_device", scope: !360, file: !1, line: 294, flags: DIFlagFwdDecl)
!370 = !DILocalVariable(name: "ret", scope: !360, file: !1, line: 295, type: !198)
!371 = !DILocalVariable(name: "value_cs", scope: !360, file: !1, line: 296, type: !188)
!372 = !DILocalVariable(name: "unit_index", scope: !360, file: !1, line: 297, type: !188)
!373 = !DILocalVariable(name: "rdata", scope: !360, file: !1, line: 298, type: !374)
!374 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 256, elements: !375)
!375 = !{!376}
!376 = !DISubrange(count: 32)
!377 = !DILocation(line: 292, column: 37, scope: !360)
!378 = !DILocation(line: 294, column: 40, scope: !360)
!379 = !DILocation(line: 294, column: 29, scope: !360)
!380 = !DILocation(line: 295, column: 9, scope: !360)
!381 = !DILocation(line: 296, column: 9, scope: !360)
!382 = !DILocation(line: 297, column: 9, scope: !360)
!383 = !DILocation(line: 298, column: 5, scope: !360)
!384 = !DILocation(line: 298, column: 8, scope: !360)
!385 = !DILocation(line: 304, column: 11, scope: !360)
!386 = !DILocation(line: 307, column: 5, scope: !360)
!387 = !DILocation(line: 310, column: 11, scope: !360)
!388 = !DILocation(line: 313, column: 1, scope: !360)
!389 = !DILocation(line: 312, column: 5, scope: !360)
