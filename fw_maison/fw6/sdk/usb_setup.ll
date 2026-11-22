; ModuleID = 'usb_setup.c.o'
source_filename = "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/device/usb/device/usb_setup.c"
target datalayout = "e-m:e-p:32:32-i1:32-i64:32:32-f64:32:32-n8:16:32-a:0:32"
target triple = "pi32v2"

%struct.usb_setup_t = type { %struct.usb_device_t, %struct.usb_ctrlrequest, [8 x i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)*], [8 x void (%struct.usb_device_t*, i32)*] }
%struct.usb_device_t = type { i8, i8, i16, i8*, i8*, i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)*, i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)*, i8, i8, i8, i8, i8, i8 }
%struct.usb_ctrlrequest = type { i8, i8, i16, i16, i16 }

@usb_setup = local_unnamed_addr global [2 x %struct.usb_setup_t*] zeroinitializer, align 4, !dbg !0
@.str = private unnamed_addr constant [9 x i8] c"Standard\00", align 1
@.str.1 = private unnamed_addr constant [6 x i8] c"CLASS\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"VENDOR\00", align 1
@.str.3 = private unnamed_addr constant [9 x i8] c"RESERVED\00", align 1
@dump_setup_request.types = private unnamed_addr constant [4 x i8*] [i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.1, i32 0, i32 0), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.3, i32 0, i32 0)], align 4
@.str.4 = private unnamed_addr constant [7 x i8] c"DEVICE\00", align 1
@.str.5 = private unnamed_addr constant [10 x i8] c"INTERFACE\00", align 1
@.str.6 = private unnamed_addr constant [9 x i8] c"ENDPOINT\00", align 1
@.str.7 = private unnamed_addr constant [6 x i8] c"OTHER\00", align 1
@dump_setup_request.recips = private unnamed_addr constant [4 x i8*] [i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i32 0, i32 0), i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.6, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.7, i32 0, i32 0)], align 4
@.str.8 = private unnamed_addr constant [11 x i8] c"GET_STATUS\00", align 1
@.str.9 = private unnamed_addr constant [14 x i8] c"CLEAR_FEATURE\00", align 1
@.str.10 = private unnamed_addr constant [11 x i8] c"unkown req\00", align 1
@.str.11 = private unnamed_addr constant [12 x i8] c"SET_FEATURE\00", align 1
@.str.12 = private unnamed_addr constant [12 x i8] c"SET_ADDRESS\00", align 1
@.str.13 = private unnamed_addr constant [15 x i8] c"GET_DESCRIPTOR\00", align 1
@.str.14 = private unnamed_addr constant [15 x i8] c"SET_DESCRIPTOR\00", align 1
@.str.15 = private unnamed_addr constant [18 x i8] c"GET_CONFIGURATION\00", align 1
@.str.16 = private unnamed_addr constant [18 x i8] c"SET_CONFIGURATION\00", align 1
@.str.17 = private unnamed_addr constant [14 x i8] c"GET_INTERFACE\00", align 1
@.str.18 = private unnamed_addr constant [14 x i8] c"SET_INTERFACE\00", align 1
@dump_setup_request.bRequests = private unnamed_addr constant [12 x i8*] [i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.8, i32 0, i32 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.9, i32 0, i32 0), i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.10, i32 0, i32 0), i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.11, i32 0, i32 0), i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.10, i32 0, i32 0), i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.12, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.13, i32 0, i32 0), i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.14, i32 0, i32 0), i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.15, i32 0, i32 0), i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.16, i32 0, i32 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.17, i32 0, i32 0), i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.18, i32 0, i32 0)], align 4
@log_tag_const_i_USB = external local_unnamed_addr constant i8, align 1
@.str.19 = private unnamed_addr constant [109 x i8] c"[Info]: [USB]DIR: %s(%x) Type: %s(%x) Recipient: %s(%x) bRequest: %s(%x) wValue: %x wIndex: %x wLength: %x\0D\0A\00", align 1
@.str.20 = private unnamed_addr constant [4 x i8] c"D2H\00", align 1
@.str.21 = private unnamed_addr constant [4 x i8] c"H2D\00", align 1
@log_tag_const_e_USB = external local_unnamed_addr constant i8, align 1
@.str.22 = private unnamed_addr constant [32 x i8] c"<Error>: [USB]usb_setup NULL\0A\0D\0A\00", align 1
@.str.23 = private unnamed_addr constant [26 x i8] c"[Info]: [USB]high speed\0D\0A\00", align 1
@.str.24 = private unnamed_addr constant [26 x i8] c"[Info]: [USB]full speed\0D\0A\00", align 1
@.str.25 = private unnamed_addr constant [29 x i8] c"[Info]: [USB]user setup,%d\0D\0A\00", align 1
@.str.26 = private unnamed_addr constant [32 x i8] c"<Error>: [USB]unkonw desc %x\0A\0D\0A\00", align 1
@.str.27 = private unnamed_addr constant [36 x i8] c"<Error>: [USB]unkonw bRequest %x\0A\0D\0A\00", align 1
@test_mode.pattern = internal constant [53 x i8] c"\00\00\00\00\00\00\00\00\00\AA\AA\AA\AA\AA\AA\AA\AA\EE\EE\EE\EE\EE\EE\EE\EE\FE\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\7F\BF\DF\EF\F7\FB\FD\FC~\BF\DF\EF\F7\FB\FD~", align 1, !dbg !83
@log_tag_const_d_USB = external local_unnamed_addr constant i8, align 1
@.str.28 = private unnamed_addr constant [27 x i8] c"[Debug]: [USB]%s() %x %x\0D\0A\00", align 1
@__func__.test_mode = private unnamed_addr constant [10 x i8] c"test_mode\00", align 1
@.str.29 = private unnamed_addr constant [42 x i8] c"<Error>: [USB]%s() if: %d call %x fail\0A\0D\0A\00", align 1
@__func__.setup_interface = private unnamed_addr constant [16 x i8] c"setup_interface\00", align 1
@ep_in_status = internal unnamed_addr global [2 x i16] zeroinitializer, align 2, !dbg !97
@ep_out_status = internal unnamed_addr global [2 x i16] zeroinitializer, align 2, !dbg !102
@.str.30 = private unnamed_addr constant [42 x i8] c"<Error>: [USB]ep0 TXCSRP_TxPktRdy busy\0A\0D\0A\00", align 1

; Function Attrs: minsize nounwind optsize readonly
define zeroext i8 @usb_device2id(%struct.usb_device_t* nocapture readonly) local_unnamed_addr #0 !dbg !108 {
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115), !dbg !116
  %2 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 12, !dbg !117
  %3 = load i8, i8* %2, align 1, !dbg !117
  %4 = and i8 %3, 1, !dbg !117
  ret i8 %4, !dbg !118
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: minsize nounwind optsize readonly
define %struct.usb_device_t* @usb_id2device(i8 zeroext) local_unnamed_addr #0 !dbg !119 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !123, metadata !115), !dbg !124
  %2 = zext i8 %0 to i32, !dbg !125
  %3 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %2, !dbg !125
  %4 = load %struct.usb_setup_t*, %struct.usb_setup_t** %3, align 4, !dbg !125, !tbaa !126
  %5 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %4, i32 0, i32 0, !dbg !130
  ret %struct.usb_device_t* %5, !dbg !131
}

; Function Attrs: minsize nounwind optsize readonly
define i8* @usb_get_setup_buffer(%struct.usb_device_t* nocapture readonly) local_unnamed_addr #0 !dbg !132 {
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !136, metadata !115), !dbg !137
  %2 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 3, !dbg !138
  %3 = load i8*, i8** %2, align 4, !dbg !138, !tbaa !139
  ret i8* %3, !dbg !142
}

; Function Attrs: minsize nounwind optsize
define void @usb_device_set_class(%struct.usb_device_t* nocapture, i32) local_unnamed_addr #2 !dbg !143 {
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !145, metadata !115), !dbg !147
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !146, metadata !115), !dbg !148
  %3 = trunc i32 %1 to i8, !dbg !149
  %4 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 9, !dbg !150
  store i8 %3, i8* %4, align 2, !dbg !151, !tbaa !152
  ret void, !dbg !153
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_set_interface_hander(i8 zeroext, i32, i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)*) local_unnamed_addr #2 !dbg !154 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !158, metadata !115), !dbg !161
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !159, metadata !115), !dbg !162
  tail call void @llvm.dbg.value(metadata i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)* %2, i64 0, metadata !160, metadata !115), !dbg !163
  %4 = icmp ugt i32 %1, 7, !dbg !164
  br i1 %4, label %12, label %5, !dbg !166

; <label>:5:                                      ; preds = %3
  %6 = zext i8 %0 to i32, !dbg !167
  %7 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %6, !dbg !167
  %8 = load %struct.usb_setup_t*, %struct.usb_setup_t** %7, align 4, !dbg !167, !tbaa !126
  %9 = icmp eq %struct.usb_setup_t* %8, null, !dbg !167
  br i1 %9, label %12, label %10, !dbg !169

; <label>:10:                                     ; preds = %5
  %11 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %8, i32 0, i32 2, i32 %1, !dbg !170
  store i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)* %2, i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)** %11, align 4, !dbg !172, !tbaa !126
  br label %12, !dbg !173

; <label>:12:                                     ; preds = %10, %5, %3
  %13 = phi i32 [ 0, %3 ], [ %1, %5 ], [ %1, %10 ]
  ret i32 %13, !dbg !174
}

; Function Attrs: minsize nounwind optsize
define void @dump_setup_request(%struct.usb_ctrlrequest* nocapture readonly) local_unnamed_addr #2 !dbg !175 {
  tail call void @llvm.dbg.value(metadata %struct.usb_ctrlrequest* %0, i64 0, metadata !181, metadata !115), !dbg !196
  tail call void @llvm.dbg.declare(metadata [4 x i8*]* @dump_setup_request.types, metadata !182, metadata !115), !dbg !197
  tail call void @llvm.dbg.declare(metadata [4 x i8*]* @dump_setup_request.recips, metadata !189, metadata !115), !dbg !198
  tail call void @llvm.dbg.declare(metadata [12 x i8*]* @dump_setup_request.bRequests, metadata !190, metadata !115), !dbg !199
  %2 = getelementptr inbounds %struct.usb_ctrlrequest, %struct.usb_ctrlrequest* %0, i32 0, i32 0, !dbg !200
  %3 = load i8, i8* %2, align 1, !dbg !200, !tbaa !201
  %4 = zext i8 %3 to i32, !dbg !203
  %5 = lshr i32 %4, 5, !dbg !204
  %6 = and i32 %5, 3, !dbg !204
  tail call void @llvm.dbg.value(metadata i32 %6, i64 0, metadata !194, metadata !115), !dbg !205
  %7 = and i32 %4, 31, !dbg !206
  tail call void @llvm.dbg.value(metadata i32 %7, i64 0, metadata !195, metadata !115), !dbg !207
  %8 = load i8, i8* @log_tag_const_i_USB, align 1, !dbg !208, !tbaa !210
  %9 = icmp eq i8 %8, 0, !dbg !208
  br i1 %9, label %34, label %10, !dbg !211

; <label>:10:                                     ; preds = %1
  %11 = and i32 %4, 128, !dbg !212
  %12 = icmp ne i32 %11, 0, !dbg !212
  %13 = select i1 %12, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.20, i32 0, i32 0), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.21, i32 0, i32 0), !dbg !212
  %14 = getelementptr inbounds [4 x i8*], [4 x i8*]* @dump_setup_request.types, i32 0, i32 %6, !dbg !212
  %15 = load i8*, i8** %14, align 4, !dbg !212, !tbaa !126
  %16 = getelementptr inbounds [4 x i8*], [4 x i8*]* @dump_setup_request.recips, i32 0, i32 %7, !dbg !212
  %17 = load i8*, i8** %16, align 4, !dbg !212, !tbaa !126
  %18 = getelementptr inbounds %struct.usb_ctrlrequest, %struct.usb_ctrlrequest* %0, i32 0, i32 1, !dbg !212
  %19 = load i8, i8* %18, align 1, !dbg !212, !tbaa !214
  %20 = icmp ult i8 %19, 12, !dbg !212
  %21 = zext i8 %19 to i32, !dbg !212
  %22 = select i1 %20, i32 %21, i32 2, !dbg !212
  %23 = getelementptr inbounds [12 x i8*], [12 x i8*]* @dump_setup_request.bRequests, i32 0, i32 %22
  %24 = load i8*, i8** %23, align 4, !tbaa !126
  %25 = getelementptr inbounds %struct.usb_ctrlrequest, %struct.usb_ctrlrequest* %0, i32 0, i32 2, !dbg !212
  %26 = load i16, i16* %25, align 1, !dbg !212, !tbaa !215
  %27 = zext i16 %26 to i32, !dbg !212
  %28 = getelementptr inbounds %struct.usb_ctrlrequest, %struct.usb_ctrlrequest* %0, i32 0, i32 3, !dbg !212
  %29 = load i16, i16* %28, align 1, !dbg !212, !tbaa !216
  %30 = zext i16 %29 to i32, !dbg !212
  %31 = getelementptr inbounds %struct.usb_ctrlrequest, %struct.usb_ctrlrequest* %0, i32 0, i32 4, !dbg !212
  %32 = load i16, i16* %31, align 1, !dbg !212, !tbaa !217
  %33 = zext i16 %32 to i32, !dbg !212
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([109 x i8], [109 x i8]* @.str.19, i32 0, i32 0), i8* %13, i32 %11, i8* %15, i32 %6, i8* %17, i32 %7, i8* %24, i32 %21, i32 %27, i32 %30, i32 %33) #5, !dbg !212
  br label %34, !dbg !212

; <label>:34:                                     ; preds = %10, %1
  ret void, !dbg !218
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture writeonly, i8* nocapture readonly, i32, i32, i1) #3

; Function Attrs: minsize optsize
declare void @log_print(i32, i8*, i8*, ...) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define void @usb_control_transfer(%struct.usb_device_t*) local_unnamed_addr #2 !dbg !219 {
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !223, metadata !115), !dbg !226
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115), !dbg !227
  %2 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 12, !dbg !229
  %3 = load i8, i8* %2, align 1, !dbg !229
  %4 = and i8 %3, 1, !dbg !229
  tail call void @llvm.dbg.value(metadata i8 %4, i64 0, metadata !224, metadata !115), !dbg !230
  %5 = zext i8 %4 to i32, !dbg !231
  %6 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %5, !dbg !231
  %7 = load %struct.usb_setup_t*, %struct.usb_setup_t** %6, align 4, !dbg !231, !tbaa !126
  %8 = icmp eq %struct.usb_setup_t* %7, null, !dbg !233
  br i1 %8, label %9, label %13, !dbg !234

; <label>:9:                                      ; preds = %1
  %10 = load i8, i8* @log_tag_const_e_USB, align 1, !dbg !235, !tbaa !210
  %11 = icmp eq i8 %10, 0, !dbg !235
  br i1 %11, label %411, label %12, !dbg !238

; <label>:12:                                     ; preds = %9
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.22, i32 0, i32 0)) #5, !dbg !239
  br label %411, !dbg !239

; <label>:13:                                     ; preds = %1
  %14 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 10, !dbg !241
  %15 = load i8, i8* %14, align 1, !dbg !241
  %16 = and i8 %15, 2, !dbg !241
  %17 = icmp eq i8 %16, 0, !dbg !243
  br i1 %17, label %25, label %18, !dbg !244

; <label>:18:                                     ; preds = %13
  %19 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %7, i32 0, i32 0, i32 7, !dbg !245
  store i8 3, i8* %19, align 4, !dbg !247, !tbaa !248
  %20 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 0, !dbg !250
  %21 = load i8, i8* %20, align 4, !dbg !250, !tbaa !251
  %22 = zext i8 %21 to i32, !dbg !252
  tail call void @usb_write_faddr(i8 zeroext %4, i32 %22) #5, !dbg !253
  %23 = load i8, i8* %14, align 1, !dbg !254
  %24 = and i8 %23, -3, !dbg !254
  store i8 %24, i8* %14, align 1, !dbg !254
  br label %25, !dbg !255

; <label>:25:                                     ; preds = %18, %13
  %26 = tail call i32 @usb_read_csr0(i8 zeroext %4) #5, !dbg !256
  tail call void @llvm.dbg.value(metadata i32 %26, i64 0, metadata !225, metadata !115), !dbg !257
  %27 = and i32 %26, 4, !dbg !258
  %28 = icmp eq i32 %27, 0, !dbg !258
  br i1 %28, label %34, label %29, !dbg !260

; <label>:29:                                     ; preds = %25
  tail call void @usb_write_csr0(i8 zeroext %4, i32 0) #5, !dbg !261
  %30 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 1, !dbg !263
  %31 = load i8, i8* %30, align 1, !dbg !263, !tbaa !265
  %32 = icmp eq i8 %31, 4, !dbg !266
  br i1 %32, label %411, label %33, !dbg !267

; <label>:33:                                     ; preds = %29
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115), !dbg !274
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115), !dbg !277
  store i8 0, i8* %30, align 1, !dbg !278, !tbaa !265
  br label %411, !dbg !279

; <label>:34:                                     ; preds = %25
  %35 = and i32 %26, 16, !dbg !280
  %36 = icmp eq i32 %35, 0, !dbg !280
  br i1 %36, label %42, label %37, !dbg !282

; <label>:37:                                     ; preds = %34
  tail call void @usb_write_csr0(i8 zeroext %4, i32 128) #5, !dbg !283
  %38 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 1, !dbg !285
  %39 = load i8, i8* %38, align 1, !dbg !285, !tbaa !265
  %40 = icmp eq i8 %39, 4, !dbg !287
  br i1 %40, label %406, label %41, !dbg !288

; <label>:41:                                     ; preds = %37
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115), !dbg !289
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115), !dbg !292
  store i8 0, i8* %38, align 1, !dbg !293, !tbaa !265
  br label %45, !dbg !295

; <label>:42:                                     ; preds = %34
  %43 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 1
  %44 = load i8, i8* %43, align 1, !tbaa !265
  switch i8 %44, label %411 [
    i8 0, label %45
    i8 1, label %386
    i8 2, label %387
    i8 4, label %406
  ], !dbg !296

; <label>:45:                                     ; preds = %42, %41
  %46 = phi i8* [ %38, %41 ], [ %43, %42 ]
  %47 = and i32 %26, 1, !dbg !298
  %48 = icmp eq i32 %47, 0, !dbg !298
  br i1 %48, label %411, label %49, !dbg !301

; <label>:49:                                     ; preds = %45
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !302, metadata !115) #6, !dbg !307
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115) #6, !dbg !310
  %50 = load i8, i8* %2, align 1, !dbg !312
  %51 = and i8 %50, 1, !dbg !312
  tail call void @llvm.dbg.value(metadata i8 %51, i64 0, metadata !305, metadata !115) #6, !dbg !314
  %52 = zext i8 %51 to i32, !dbg !315
  %53 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %52, !dbg !315
  %54 = load %struct.usb_setup_t*, %struct.usb_setup_t** %53, align 4, !dbg !315, !tbaa !126
  %55 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %54, i32 0, i32 1, i32 0, !dbg !316
  tail call void @usb_read_ep0(i8 zeroext %51, i8* %55, i32 8) #5, !dbg !317
  %56 = load %struct.usb_setup_t*, %struct.usb_setup_t** %53, align 4, !dbg !318, !tbaa !126
  %57 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %56, i32 0, i32 1, i32 0, !dbg !319
  %58 = load i8, i8* %57, align 4, !dbg !319, !tbaa !320
  %59 = and i8 %58, 31, !dbg !321
  %60 = zext i8 %59 to i32, !dbg !321
  tail call void @llvm.dbg.value(metadata i32 %60, i64 0, metadata !306, metadata !115) #6, !dbg !322
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !323
  tail call void @llvm.dbg.value(metadata i8 3, i64 0, metadata !273, metadata !115) #6, !dbg !325
  store i8 3, i8* %46, align 1, !dbg !326, !tbaa !265
  %61 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 5, !dbg !328
  %62 = load i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)*, i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)** %61, align 4, !dbg !328, !tbaa !330
  %63 = icmp eq i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)* %62, null, !dbg !331
  br i1 %63, label %69, label %64, !dbg !332

; <label>:64:                                     ; preds = %49
  %65 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %56, i32 0, i32 1, !dbg !333
  %66 = tail call i32 %62(%struct.usb_device_t* nonnull %0, %struct.usb_ctrlrequest* %65) #5, !dbg !336
  %67 = icmp eq i32 %66, 0, !dbg !336
  tail call void @llvm.dbg.value(metadata i32 -1, i64 0, metadata !306, metadata !115) #6, !dbg !322
  %68 = select i1 %67, i32 %60, i32 -1, !dbg !337
  br label %69, !dbg !337

; <label>:69:                                     ; preds = %64, %49
  %70 = phi i32 [ %60, %49 ], [ %68, %64 ]
  tail call void @llvm.dbg.value(metadata i32 %70, i64 0, metadata !306, metadata !115) #6, !dbg !322
  switch i32 %70, label %368 [
    i32 0, label %71
    i32 1, label %239
    i32 2, label %266
    i32 -1, label %362
  ], !dbg !338

; <label>:71:                                     ; preds = %69
  %72 = load %struct.usb_setup_t*, %struct.usb_setup_t** %53, align 4, !dbg !339, !tbaa !126
  %73 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, !dbg !341
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !342, metadata !115) #6, !dbg !354
  tail call void @llvm.dbg.value(metadata %struct.usb_ctrlrequest* %73, i64 0, metadata !345, metadata !115) #6, !dbg !356
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115) #6, !dbg !357
  %74 = load i8, i8* %2, align 1, !dbg !359
  %75 = and i8 %74, 1, !dbg !359
  tail call void @llvm.dbg.value(metadata i8 %75, i64 0, metadata !346, metadata !115) #6, !dbg !361
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !347, metadata !115) #6, !dbg !362
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !136, metadata !115) #6, !dbg !363
  %76 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 3, !dbg !365
  %77 = load i8*, i8** %76, align 4, !dbg !365, !tbaa !139
  tail call void @llvm.dbg.value(metadata i8* %77, i64 0, metadata !348, metadata !115) #6, !dbg !366
  %78 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 1, !dbg !367
  %79 = load i8, i8* %78, align 1, !dbg !367, !tbaa !214
  %80 = zext i8 %79 to i32, !dbg !368
  switch i8 %79, label %235 [
    i8 5, label %81
    i8 11, label %368
    i8 3, label %105
    i8 1, label %143
    i8 6, label %161
    i8 9, label %194
    i8 8, label %215
    i8 0, label %223
  ], !dbg !369

; <label>:81:                                     ; preds = %71
  %82 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 7, !dbg !370
  %83 = load i8, i8* %82, align 4, !dbg !370, !tbaa !372
  %84 = icmp eq i8 %83, 4, !dbg !373
  br i1 %84, label %375, label %85, !dbg !374

; <label>:85:                                     ; preds = %81
  %86 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 2, !dbg !375
  %87 = load i16, i16* %86, align 1, !dbg !375, !tbaa !215
  %88 = trunc i16 %87 to i8, !dbg !375
  %89 = and i16 %87, 255, !dbg !375
  %90 = icmp eq i16 %89, 128, !dbg !378
  br i1 %90, label %375, label %91, !dbg !379

; <label>:91:                                     ; preds = %85
  %92 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 3, !dbg !380
  %93 = load i16, i16* %92, align 1, !dbg !380, !tbaa !216
  %94 = icmp eq i16 %93, 0, !dbg !383
  br i1 %94, label %95, label %99, !dbg !384

; <label>:95:                                     ; preds = %91
  %96 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 4, !dbg !385
  %97 = load i16, i16* %96, align 1, !dbg !385, !tbaa !217
  %98 = icmp eq i16 %97, 0, !dbg !386
  br i1 %98, label %101, label %99, !dbg !387

; <label>:99:                                     ; preds = %95, %91
  %100 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 0, !dbg !389
  store i8 %88, i8* %100, align 4, !dbg !391, !tbaa !251
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !392
  tail call void @llvm.dbg.value(metadata i8 4, i64 0, metadata !273, metadata !115) #6, !dbg !394
  store i8 4, i8* %46, align 1, !dbg !395, !tbaa !265
  br label %377, !dbg !397

; <label>:101:                                    ; preds = %95
  %102 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 0, !dbg !398
  store i8 %88, i8* %102, align 4, !dbg !400, !tbaa !251
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !401
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !403
  store i8 0, i8* %46, align 1, !dbg !404, !tbaa !265
  %103 = load i8, i8* %14, align 1, !dbg !406
  %104 = or i8 %103, 2, !dbg !406
  store i8 %104, i8* %14, align 1, !dbg !406
  br label %368

; <label>:105:                                    ; preds = %71
  %106 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 2, !dbg !407
  %107 = load i16, i16* %106, align 1, !dbg !407, !tbaa !215
  %108 = and i16 %107, 255, !dbg !407
  %109 = icmp eq i16 %108, 1, !dbg !409
  br i1 %109, label %110, label %119, !dbg !410

; <label>:110:                                    ; preds = %105
  %111 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 7, !dbg !411
  %112 = load i8, i8* %111, align 4, !dbg !411, !tbaa !372
  switch i8 %112, label %368 [
    i8 2, label %375
    i8 3, label %113
    i8 4, label %116
  ], !dbg !414

; <label>:113:                                    ; preds = %110
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !415
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !419
  store i8 0, i8* %46, align 1, !dbg !420, !tbaa !265
  %114 = load i8, i8* %14, align 1, !dbg !422
  %115 = or i8 %114, 1, !dbg !422
  store i8 %115, i8* %14, align 1, !dbg !422
  br label %368, !dbg !423

; <label>:116:                                    ; preds = %110
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !424
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !428
  store i8 0, i8* %46, align 1, !dbg !429, !tbaa !265
  %117 = load i8, i8* %14, align 1, !dbg !431
  %118 = or i8 %117, 1, !dbg !431
  store i8 %118, i8* %14, align 1, !dbg !431
  br label %368, !dbg !432

; <label>:119:                                    ; preds = %105
  %120 = icmp eq i16 %107, 2, !dbg !433
  br i1 %120, label %121, label %368, !dbg !436

; <label>:121:                                    ; preds = %119
  %122 = icmp eq i8 %75, 0, !dbg !438
  br i1 %122, label %375, label %123, !dbg !441

; <label>:123:                                    ; preds = %121
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !89, metadata !115) #6, !dbg !442
  tail call void @llvm.dbg.value(metadata %struct.usb_ctrlrequest* %73, i64 0, metadata !90, metadata !115) #6, !dbg !445
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115) #6, !dbg !446
  tail call void @llvm.dbg.value(metadata i8 %75, i64 0, metadata !91, metadata !115) #6, !dbg !448
  %124 = load i8, i8* @log_tag_const_d_USB, align 1, !dbg !449, !tbaa !210
  %125 = icmp eq i8 %124, 0, !dbg !449
  %126 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 3
  br i1 %125, label %130, label %127, !dbg !451

; <label>:127:                                    ; preds = %123
  %128 = load i16, i16* %126, align 1, !dbg !452, !tbaa !216
  %129 = zext i16 %128 to i32, !dbg !452
  tail call void (i32, i8*, i8*, ...) @log_print(i32 1, i8* null, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.28, i32 0, i32 0), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @__func__.test_mode, i32 0, i32 0), i32 %129, i32 2) #5, !dbg !452
  br label %130, !dbg !452

; <label>:130:                                    ; preds = %127, %123
  %131 = load i16, i16* %126, align 1, !dbg !454, !tbaa !216
  %132 = and i16 %131, 255, !dbg !454
  %133 = icmp eq i16 %132, 0, !dbg !456
  br i1 %133, label %134, label %368, !dbg !457

; <label>:134:                                    ; preds = %130
  tail call void @usb_write_csr0(i8 zeroext %75, i32 72) #5, !dbg !458
  %135 = tail call i32 bitcast (i32 (...)* @udelay to i32 (i32)*)(i32 1000) #5, !dbg !459
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !460
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !462
  store i8 0, i8* %46, align 1, !dbg !463, !tbaa !265
  %136 = load i16, i16* %126, align 1, !dbg !465, !tbaa !216
  %137 = lshr i16 %136, 8, !dbg !465
  %138 = trunc i16 %137 to i8, !dbg !466
  switch i8 %138, label %373 [
    i8 1, label %139
    i8 2, label %140
    i8 3, label %141
    i8 4, label %142
  ], !dbg !466

; <label>:139:                                    ; preds = %134
  store volatile i8 2, i8* inttoptr (i32 90127 to i8*), align 1, !dbg !467, !tbaa !210
  br label %368, !dbg !469

; <label>:140:                                    ; preds = %134
  store volatile i8 4, i8* inttoptr (i32 90127 to i8*), align 1, !dbg !470, !tbaa !210
  br label %368, !dbg !471

; <label>:141:                                    ; preds = %134
  store volatile i8 1, i8* inttoptr (i32 90127 to i8*), align 1, !dbg !472, !tbaa !210
  br label %368, !dbg !473

; <label>:142:                                    ; preds = %134
  tail call void @usb_write_ep0(i8 zeroext %75, i8* getelementptr inbounds ([53 x i8], [53 x i8]* @test_mode.pattern, i32 0, i32 0), i32 53) #5, !dbg !474
  tail call void @usb_write_csr0(i8 zeroext %75, i32 2) #5, !dbg !475
  store volatile i8 8, i8* inttoptr (i32 90127 to i8*), align 1, !dbg !476, !tbaa !210
  tail call void @unrequest_irq(i8 zeroext 54, i8 zeroext 0) #5, !dbg !477
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !480
  tail call void @llvm.dbg.value(metadata i8 5, i64 0, metadata !273, metadata !115) #6, !dbg !482
  store i8 5, i8* %46, align 1, !dbg !483, !tbaa !265
  br label %411, !dbg !485

; <label>:143:                                    ; preds = %71
  %144 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 2, !dbg !486
  %145 = load i16, i16* %144, align 1, !dbg !486, !tbaa !215
  %146 = trunc i16 %145 to i8, !dbg !488
  switch i8 %146, label %368 [
    i8 1, label %147
    i8 2, label %156
  ], !dbg !488

; <label>:147:                                    ; preds = %143
  %148 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 7, !dbg !489
  %149 = load i8, i8* %148, align 4, !dbg !489, !tbaa !372
  switch i8 %149, label %368 [
    i8 2, label %375
    i8 3, label %150
    i8 4, label %153
  ], !dbg !492

; <label>:150:                                    ; preds = %147
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !493
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !497
  store i8 0, i8* %46, align 1, !dbg !498, !tbaa !265
  %151 = load i8, i8* %14, align 1, !dbg !500
  %152 = and i8 %151, -2, !dbg !500
  store i8 %152, i8* %14, align 1, !dbg !500
  br label %368, !dbg !501

; <label>:153:                                    ; preds = %147
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !502
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !506
  store i8 0, i8* %46, align 1, !dbg !507, !tbaa !265
  %154 = load i8, i8* %14, align 1, !dbg !509
  %155 = and i8 %154, -2, !dbg !509
  store i8 %155, i8* %14, align 1, !dbg !509
  br label %368, !dbg !510

; <label>:156:                                    ; preds = %143
  %157 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 7, !dbg !511
  %158 = load i8, i8* %157, align 4, !dbg !511, !tbaa !372
  %159 = add i8 %158, -2, !dbg !515
  %160 = icmp ult i8 %159, 3, !dbg !515
  br i1 %160, label %375, label %368, !dbg !515

; <label>:161:                                    ; preds = %71
  %162 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 2, !dbg !516
  %163 = load i16, i16* %162, align 1, !dbg !516, !tbaa !215
  %164 = zext i16 %163 to i32, !dbg !516
  %165 = lshr i16 %163, 8, !dbg !516
  %166 = trunc i16 %165 to i8, !dbg !518
  switch i8 %166, label %184 [
    i8 1, label %167
    i8 2, label %168
    i8 3, label %173
  ], !dbg !518

; <label>:167:                                    ; preds = %161
  tail call void @get_device_descriptor(i8* %77, i8 zeroext %75) #5, !dbg !519
  tail call void @llvm.dbg.value(metadata i32 18, i64 0, metadata !347, metadata !115) #6, !dbg !362
  tail call void @llvm.dbg.value(metadata i32 %189, i64 0, metadata !347, metadata !115) #6, !dbg !362
  br label %191, !dbg !521

; <label>:168:                                    ; preds = %161
  %169 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 9, !dbg !522
  %170 = load i8, i8* %169, align 2, !dbg !522, !tbaa !152
  %171 = zext i8 %170 to i32, !dbg !523
  %172 = tail call i32 @set_descriptor(i8 zeroext %75, i32 %171, i8* %77, i32 768) #5, !dbg !524
  tail call void @llvm.dbg.value(metadata i32 %172, i64 0, metadata !347, metadata !115) #6, !dbg !362
  br label %188, !dbg !525

; <label>:173:                                    ; preds = %161
  %174 = trunc i16 %163 to i8, !dbg !526
  switch i8 %174, label %180 [
    i8 0, label %175
    i8 1, label %176
    i8 2, label %177
    i8 3, label %178
    i8 -18, label %179
  ], !dbg !526

; <label>:175:                                    ; preds = %173
  tail call void @get_language_str(i8* %77) #5, !dbg !527
  br label %181, !dbg !530

; <label>:176:                                    ; preds = %173
  tail call void @get_manufacture_str(i8* %77) #5, !dbg !531
  br label %181, !dbg !534

; <label>:177:                                    ; preds = %173
  tail call void @get_product_str(i8* %77) #5, !dbg !535
  br label %181, !dbg !538

; <label>:178:                                    ; preds = %173
  tail call void @get_iserialnumber_str(i8* %77) #5, !dbg !539
  br label %181, !dbg !542

; <label>:179:                                    ; preds = %173
  tail call void @get_string_ee(i8* %77) #5, !dbg !543
  br label %181, !dbg !546

; <label>:180:                                    ; preds = %173
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !547
  tail call void @llvm.dbg.value(metadata i8 3, i64 0, metadata !273, metadata !115) #6, !dbg !550
  store i8 3, i8* %46, align 1, !dbg !551, !tbaa !265
  store i8 0, i8* %77, align 1, !dbg !553, !tbaa !210
  br label %181

; <label>:181:                                    ; preds = %180, %179, %178, %177, %176, %175
  %182 = load i8, i8* %77, align 1, !dbg !554, !tbaa !210
  %183 = zext i8 %182 to i32, !dbg !554
  tail call void @llvm.dbg.value(metadata i32 %183, i64 0, metadata !347, metadata !115) #6, !dbg !362
  br label %188, !dbg !555

; <label>:184:                                    ; preds = %161
  %185 = load i8, i8* @log_tag_const_e_USB, align 1, !dbg !556, !tbaa !210
  %186 = icmp eq i8 %185, 0, !dbg !556
  br i1 %186, label %368, label %187, !dbg !558

; <label>:187:                                    ; preds = %184
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.26, i32 0, i32 0), i32 %164) #5, !dbg !559
  br label %368, !dbg !559

; <label>:188:                                    ; preds = %181, %168
  %189 = phi i32 [ %183, %181 ], [ %172, %168 ]
  tail call void @llvm.dbg.value(metadata i32 %189, i64 0, metadata !347, metadata !115) #6, !dbg !362
  %190 = icmp eq i32 %189, 0, !dbg !561
  br i1 %190, label %368, label %191, !dbg !564

; <label>:191:                                    ; preds = %188, %167
  %192 = phi i32 [ 18, %167 ], [ %189, %188 ]
  %193 = tail call i8* @usb_set_data_payload(%struct.usb_device_t* nonnull %0, %struct.usb_ctrlrequest* nonnull %73, i8* %77, i32 %192) #5, !dbg !566
  br label %368, !dbg !568

; <label>:194:                                    ; preds = %71
  %195 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 3, !dbg !569
  %196 = load i16, i16* %195, align 1, !dbg !569, !tbaa !216
  %197 = icmp eq i16 %196, 0, !dbg !570
  br i1 %197, label %198, label %375, !dbg !571

; <label>:198:                                    ; preds = %194
  %199 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 4, !dbg !572
  %200 = load i16, i16* %199, align 1, !dbg !572, !tbaa !217
  %201 = icmp eq i16 %200, 0, !dbg !574
  br i1 %201, label %202, label %375, !dbg !575

; <label>:202:                                    ; preds = %198
  %203 = zext i8 %75 to i32, !dbg !577
  %204 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %203, !dbg !577
  %205 = load %struct.usb_setup_t*, %struct.usb_setup_t** %204, align 4, !dbg !577, !tbaa !126
  %206 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %205, i32 0, i32 0, i32 7, !dbg !579
  %207 = load i8, i8* %206, align 4, !dbg !579, !tbaa !248
  %208 = icmp eq i8 %207, 2, !dbg !580
  br i1 %208, label %375, label %209, !dbg !581

; <label>:209:                                    ; preds = %202
  %210 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %72, i32 0, i32 1, i32 2, !dbg !582
  %211 = load i16, i16* %210, align 1, !dbg !582, !tbaa !215
  %212 = trunc i16 %211 to i8, !dbg !583
  switch i8 %212, label %375 [
    i8 0, label %213
    i8 1, label %214
  ], !dbg !583

; <label>:213:                                    ; preds = %209
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !584
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !588
  store i8 0, i8* %46, align 1, !dbg !589, !tbaa !265
  store i8 3, i8* %206, align 4, !dbg !591, !tbaa !248
  tail call void @usb_disable_ep(i8 zeroext %75, i32 1) #5, !dbg !592
  tail call void @usb_disable_ep(i8 zeroext %75, i32 2) #5, !dbg !593
  tail call void @usb_disable_ep(i8 zeroext %75, i32 3) #5, !dbg !594
  tail call void @usb_disable_ep(i8 zeroext %75, i32 4) #5, !dbg !595
  br label %368, !dbg !596

; <label>:214:                                    ; preds = %209
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !597
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !601
  store i8 0, i8* %46, align 1, !dbg !602, !tbaa !265
  store i8 4, i8* %206, align 4, !dbg !604, !tbaa !248
  br label %368, !dbg !605

; <label>:215:                                    ; preds = %71
  %216 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 7, !dbg !606
  %217 = load i8, i8* %216, align 4, !dbg !606, !tbaa !372
  %218 = icmp eq i8 %217, 2, !dbg !608
  br i1 %218, label %375, label %219, !dbg !609

; <label>:219:                                    ; preds = %215
  tail call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !347, metadata !115) #6, !dbg !362
  %220 = icmp eq i8 %217, 4, !dbg !610
  %221 = zext i1 %220 to i8, !dbg !612
  store i8 %221, i8* %77, align 1, !dbg !613, !tbaa !210
  %222 = tail call i8* @usb_set_data_payload(%struct.usb_device_t* nonnull %0, %struct.usb_ctrlrequest* nonnull %73, i8* %77, i32 1) #5, !dbg !614
  br label %368

; <label>:223:                                    ; preds = %71
  %224 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 7, !dbg !615
  %225 = load i8, i8* %224, align 4, !dbg !615, !tbaa !372
  %226 = icmp eq i8 %225, 2, !dbg !617
  br i1 %226, label %375, label %227, !dbg !618

; <label>:227:                                    ; preds = %223
  store i8 0, i8* %77, align 1, !dbg !619, !tbaa !210
  %228 = getelementptr inbounds i8, i8* %77, i32 1, !dbg !621
  store i8 0, i8* %228, align 1, !dbg !622, !tbaa !210
  %229 = load i8, i8* %14, align 1, !dbg !623
  %230 = and i8 %229, 1, !dbg !623
  %231 = icmp eq i8 %230, 0, !dbg !625
  br i1 %231, label %233, label %232, !dbg !626

; <label>:232:                                    ; preds = %227
  store i8 2, i8* %77, align 1, !dbg !627, !tbaa !210
  br label %233, !dbg !629

; <label>:233:                                    ; preds = %232, %227
  tail call void @llvm.dbg.value(metadata i32 2, i64 0, metadata !347, metadata !115) #6, !dbg !362
  %234 = tail call i8* @usb_set_data_payload(%struct.usb_device_t* nonnull %0, %struct.usb_ctrlrequest* nonnull %73, i8* nonnull %77, i32 2) #5, !dbg !630
  br label %368

; <label>:235:                                    ; preds = %71
  %236 = load i8, i8* @log_tag_const_e_USB, align 1, !dbg !631, !tbaa !210
  %237 = icmp eq i8 %236, 0, !dbg !631
  br i1 %237, label %368, label %238, !dbg !633

; <label>:238:                                    ; preds = %235
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.27, i32 0, i32 0), i32 %80) #5, !dbg !634
  br label %368, !dbg !634

; <label>:239:                                    ; preds = %69
  %240 = load %struct.usb_setup_t*, %struct.usb_setup_t** %53, align 4, !dbg !636, !tbaa !126
  %241 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %240, i32 0, i32 1, !dbg !637
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !638, metadata !115) #6, !dbg !644
  tail call void @llvm.dbg.value(metadata %struct.usb_ctrlrequest* %241, i64 0, metadata !641, metadata !115) #6, !dbg !646
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115) #6, !dbg !647
  %242 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %240, i32 0, i32 1, i32 3, !dbg !649
  %243 = load i16, i16* %242, align 1, !dbg !649, !tbaa !216
  %244 = and i16 %243, 255, !dbg !649
  %245 = zext i16 %244 to i32, !dbg !649
  tail call void @llvm.dbg.value(metadata i32 %245, i64 0, metadata !643, metadata !115) #6, !dbg !650
  %246 = icmp ult i16 %244, 8, !dbg !651
  br i1 %246, label %247, label %368, !dbg !653

; <label>:247:                                    ; preds = %239
  %248 = load i8, i8* %2, align 1, !dbg !654
  %249 = and i8 %248, 1, !dbg !654
  %250 = zext i8 %249 to i32, !dbg !656
  %251 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %250, !dbg !656
  %252 = load %struct.usb_setup_t*, %struct.usb_setup_t** %251, align 4, !dbg !656, !tbaa !126
  %253 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %252, i32 0, i32 2, i32 %245, !dbg !656
  %254 = load i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)*, i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)** %253, align 4, !dbg !656, !tbaa !126
  %255 = icmp eq i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)* %254, null, !dbg !656
  br i1 %255, label %368, label %256, !dbg !657

; <label>:256:                                    ; preds = %247
  %257 = tail call i32 %254(%struct.usb_device_t* nonnull %0, %struct.usb_ctrlrequest* nonnull %241) #5, !dbg !659
  %258 = icmp ne i32 %257, 0, !dbg !662
  %259 = load i8, i8* @log_tag_const_e_USB, align 1, !dbg !663
  %260 = icmp ne i8 %259, 0, !dbg !663
  %261 = and i1 %258, %260, !dbg !666
  br i1 %261, label %262, label %368, !dbg !666

; <label>:262:                                    ; preds = %256
  %263 = load %struct.usb_setup_t*, %struct.usb_setup_t** %251, align 4, !dbg !667, !tbaa !126
  %264 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %263, i32 0, i32 2, i32 %245, !dbg !667
  %265 = load i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)*, i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)** %264, align 4, !dbg !667, !tbaa !126
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.29, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @__func__.setup_interface, i32 0, i32 0), i32 %245, i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)* %265) #5, !dbg !667
  br label %368, !dbg !667

; <label>:266:                                    ; preds = %69
  %267 = load %struct.usb_setup_t*, %struct.usb_setup_t** %53, align 4, !dbg !669, !tbaa !126
  %268 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %267, i32 0, i32 1, !dbg !670
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !671, metadata !115) #6, !dbg !679
  tail call void @llvm.dbg.value(metadata %struct.usb_ctrlrequest* %268, i64 0, metadata !674, metadata !115) #6, !dbg !681
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115) #6, !dbg !682
  %269 = load i8, i8* %2, align 1, !dbg !684
  %270 = and i8 %269, 1, !dbg !684
  tail call void @llvm.dbg.value(metadata i8 %270, i64 0, metadata !675, metadata !115) #6, !dbg !686
  tail call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !676, metadata !115) #6, !dbg !687
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !136, metadata !115) #6, !dbg !688
  %271 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 3, !dbg !690
  %272 = load i8*, i8** %271, align 4, !dbg !690, !tbaa !139
  tail call void @llvm.dbg.value(metadata i8* %272, i64 0, metadata !677, metadata !115) #6, !dbg !692
  %273 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %267, i32 0, i32 1, i32 3, !dbg !693
  %274 = load i16, i16* %273, align 1, !dbg !693, !tbaa !216
  %275 = and i16 %274, 15, !dbg !694
  %276 = zext i16 %275 to i32, !dbg !694
  tail call void @llvm.dbg.value(metadata i32 %276, i64 0, metadata !678, metadata !115) #6, !dbg !695
  %277 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %267, i32 0, i32 1, i32 1, !dbg !696
  %278 = load i8, i8* %277, align 1, !dbg !696, !tbaa !214
  switch i8 %278, label %368 [
    i8 1, label %279
    i8 0, label %305
    i8 3, label %344
  ], !dbg !697

; <label>:279:                                    ; preds = %266
  %280 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 7, !dbg !698
  %281 = load i8, i8* %280, align 4, !dbg !698, !tbaa !372
  switch i8 %281, label %368 [
    i8 2, label %375
    i8 3, label %282
    i8 4, label %285
  ], !dbg !701

; <label>:282:                                    ; preds = %279
  %283 = icmp eq i16 %275, 0, !dbg !702
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !706
  br i1 %283, label %284, label %375, !dbg !709

; <label>:284:                                    ; preds = %282
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !710
  store i8 0, i8* %46, align 1, !dbg !711, !tbaa !265
  br label %373, !dbg !713

; <label>:285:                                    ; preds = %279
  %286 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %267, i32 0, i32 1, i32 2, !dbg !714
  %287 = load i16, i16* %286, align 1, !dbg !714, !tbaa !215
  %288 = and i16 %287, 255, !dbg !714
  %289 = icmp eq i16 %288, 0, !dbg !718
  br i1 %289, label %290, label %368, !dbg !719

; <label>:290:                                    ; preds = %285
  %291 = trunc i16 %274 to i8, !dbg !720
  %292 = icmp slt i8 %291, 0, !dbg !720
  br i1 %292, label %293, label %294, !dbg !723

; <label>:293:                                    ; preds = %290
  tail call void @usb_write_txcsr(i8 zeroext %270, i32 %276, i32 64) #5, !dbg !724
  br label %295, !dbg !726

; <label>:294:                                    ; preds = %290
  tail call void @usb_write_rxcsr(i8 zeroext %270, i32 %276, i32 128) #5, !dbg !727
  br label %295

; <label>:295:                                    ; preds = %294, %293
  %296 = phi [2 x i16]* [ @ep_out_status, %294 ], [ @ep_in_status, %293 ]
  %297 = shl i32 1, %276
  %298 = xor i32 %297, 65535
  %299 = zext i8 %270 to i32
  %300 = getelementptr inbounds [2 x i16], [2 x i16]* %296, i32 0, i32 %299
  %301 = load i16, i16* %300, align 2, !tbaa !729
  %302 = zext i16 %301 to i32
  %303 = and i32 %302, %298
  %304 = trunc i32 %303 to i16
  store i16 %304, i16* %300, align 2, !tbaa !729
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !730
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !732
  store i8 0, i8* %46, align 1, !dbg !733, !tbaa !265
  br label %373, !dbg !735

; <label>:305:                                    ; preds = %266
  %306 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 7, !dbg !736
  %307 = load i8, i8* %306, align 4, !dbg !736, !tbaa !372
  switch i8 %307, label %368 [
    i8 2, label %375
    i8 3, label %308
    i8 4, label %326
  ], !dbg !738

; <label>:308:                                    ; preds = %305
  %309 = icmp eq i16 %275, 0, !dbg !739
  br i1 %309, label %310, label %375, !dbg !743

; <label>:310:                                    ; preds = %308
  store i8 0, i8* %272, align 1, !dbg !744, !tbaa !210
  %311 = getelementptr inbounds i8, i8* %272, i32 1, !dbg !746
  store i8 0, i8* %311, align 1, !dbg !747, !tbaa !210
  %312 = load i16, i16* %273, align 1, !dbg !748, !tbaa !216
  %313 = trunc i16 %312 to i8, !dbg !750
  %314 = icmp slt i8 %313, 0, !dbg !750
  br i1 %314, label %315, label %324, !dbg !751

; <label>:315:                                    ; preds = %310
  %316 = shl i32 1, %276, !dbg !752
  %317 = zext i8 %270 to i32, !dbg !755
  %318 = getelementptr inbounds [2 x i16], [2 x i16]* @ep_in_status, i32 0, i32 %317, !dbg !755
  %319 = load i16, i16* %318, align 2, !dbg !755, !tbaa !729
  %320 = zext i16 %319 to i32, !dbg !755
  %321 = and i32 %320, %316, !dbg !756
  %322 = icmp eq i32 %321, 0, !dbg !756
  br i1 %322, label %324, label %323, !dbg !757

; <label>:323:                                    ; preds = %315
  store i8 1, i8* %272, align 1, !dbg !758, !tbaa !210
  br label %324, !dbg !760

; <label>:324:                                    ; preds = %323, %315, %310
  tail call void @llvm.dbg.value(metadata i32 2, i64 0, metadata !676, metadata !115) #6, !dbg !687
  %325 = tail call i8* @usb_set_data_payload(%struct.usb_device_t* nonnull %0, %struct.usb_ctrlrequest* nonnull %268, i8* nonnull %272, i32 2) #5, !dbg !761
  br label %368, !dbg !762

; <label>:326:                                    ; preds = %305
  store i8 0, i8* %272, align 1, !dbg !763, !tbaa !210
  %327 = getelementptr inbounds i8, i8* %272, i32 1, !dbg !766
  store i8 0, i8* %327, align 1, !dbg !767, !tbaa !210
  %328 = load i16, i16* %273, align 1, !dbg !768, !tbaa !216
  %329 = trunc i16 %328 to i8, !dbg !770
  %330 = icmp slt i8 %329, 0, !dbg !770
  %331 = shl i32 1, %276
  %332 = zext i8 %270 to i32
  %333 = getelementptr inbounds [2 x i16], [2 x i16]* @ep_in_status, i32 0, i32 %332
  %334 = load i16, i16* %333, align 2, !tbaa !729
  %335 = zext i16 %334 to i32
  %336 = and i32 %335, %331
  %337 = icmp ne i32 %336, 0
  br i1 %330, label %338, label %340, !dbg !771

; <label>:338:                                    ; preds = %326
  br i1 %337, label %339, label %342, !dbg !772

; <label>:339:                                    ; preds = %338
  store i8 1, i8* %272, align 1, !dbg !774, !tbaa !210
  br label %342, !dbg !777

; <label>:340:                                    ; preds = %326
  br i1 %337, label %341, label %342, !dbg !778

; <label>:341:                                    ; preds = %340
  store i8 1, i8* %272, align 1, !dbg !780, !tbaa !210
  br label %342, !dbg !783

; <label>:342:                                    ; preds = %341, %340, %339, %338
  tail call void @llvm.dbg.value(metadata i32 2, i64 0, metadata !676, metadata !115) #6, !dbg !687
  %343 = tail call i8* @usb_set_data_payload(%struct.usb_device_t* nonnull %0, %struct.usb_ctrlrequest* nonnull %268, i8* nonnull %272, i32 2) #5, !dbg !784
  br label %368, !dbg !785

; <label>:344:                                    ; preds = %266
  %345 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 7, !dbg !786
  %346 = load i8, i8* %345, align 4, !dbg !786, !tbaa !372
  switch i8 %346, label %368 [
    i8 2, label %375
    i8 3, label %347
    i8 4, label %350
  ], !dbg !788

; <label>:347:                                    ; preds = %344
  %348 = icmp eq i16 %275, 0, !dbg !789
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !793
  br i1 %348, label %349, label %375, !dbg !796

; <label>:349:                                    ; preds = %347
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !797
  store i8 0, i8* %46, align 1, !dbg !798, !tbaa !265
  br label %373, !dbg !800

; <label>:350:                                    ; preds = %344
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !801
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !805
  store i8 0, i8* %46, align 1, !dbg !806, !tbaa !265
  %351 = trunc i16 %274 to i8, !dbg !808
  %352 = icmp slt i8 %351, 0, !dbg !808
  %353 = shl i32 1, %276
  %354 = zext i8 %270 to i32
  %355 = getelementptr inbounds [2 x i16], [2 x i16]* @ep_out_status, i32 0, i32 %354, !dbg !810
  %356 = getelementptr inbounds [2 x i16], [2 x i16]* @ep_in_status, i32 0, i32 %354, !dbg !812
  %357 = select i1 %352, i16* %356, i16* %355, !dbg !814
  %358 = load i16, i16* %357, align 2, !tbaa !729
  %359 = zext i16 %358 to i32
  %360 = or i32 %359, %353
  %361 = trunc i32 %360 to i16
  store i16 %361, i16* %357, align 2, !tbaa !729
  br label %368, !dbg !815

; <label>:362:                                    ; preds = %69
  %363 = load i8, i8* @log_tag_const_i_USB, align 1, !dbg !816, !tbaa !210
  %364 = icmp eq i8 %363, 0, !dbg !816
  br i1 %364, label %368, label %365, !dbg !818

; <label>:365:                                    ; preds = %362
  %366 = load i8, i8* %46, align 1, !dbg !819, !tbaa !265
  %367 = zext i8 %366 to i32, !dbg !819
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.25, i32 0, i32 0), i32 %367) #5, !dbg !819
  br label %368, !dbg !819

; <label>:368:                                    ; preds = %365, %362, %350, %344, %342, %324, %305, %285, %279, %266, %262, %256, %247, %239, %238, %235, %233, %219, %214, %213, %191, %188, %187, %184, %156, %153, %150, %147, %143, %141, %140, %139, %130, %119, %116, %113, %110, %101, %71, %69
  %369 = load i8, i8* %46, align 1, !dbg !821, !tbaa !265
  switch i8 %369, label %411 [
    i8 0, label %373
    i8 1, label %374
    i8 2, label %374
    i8 3, label %376
    i8 4, label %370
  ], !dbg !824

; <label>:370:                                    ; preds = %368
  %371 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 0
  %372 = load i8, i8* %371, align 4, !tbaa !251
  br label %377, !dbg !826

; <label>:373:                                    ; preds = %368, %349, %295, %284, %134
  tail call void @usb_ep0_RxPktEnd(i8 zeroext %51) #5, !dbg !828
  br label %382, !dbg !830

; <label>:374:                                    ; preds = %368, %368
  tail call void @usb_ep0_ClrRxPktRdy(i8 zeroext %51) #5, !dbg !831
  br label %382, !dbg !834

; <label>:375:                                    ; preds = %347, %344, %308, %305, %282, %279, %223, %215, %209, %202, %198, %194, %156, %147, %121, %110, %85, %81
  store i8 3, i8* %46, align 1, !dbg !835, !tbaa !265
  br label %376, !dbg !839

; <label>:376:                                    ; preds = %375, %368
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !839
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115) #6, !dbg !843
  store i8 0, i8* %46, align 1, !dbg !844, !tbaa !265
  tail call void @usb_ep0_Set_Stall(i8 zeroext %51) #5, !dbg !846
  br label %382, !dbg !847

; <label>:377:                                    ; preds = %370, %99
  %378 = phi i8 [ %372, %370 ], [ %88, %99 ], !dbg !848
  %379 = zext i8 %378 to i32, !dbg !851
  tail call void @usb_ep0_Set_ignore(i8 zeroext %51, i32 %379) #5, !dbg !852
  %380 = load i8, i8* %14, align 1, !dbg !853
  %381 = and i8 %380, -3, !dbg !853
  store i8 %381, i8* %14, align 1, !dbg !853
  br label %382, !dbg !854

; <label>:382:                                    ; preds = %377, %376, %374, %373
  %383 = load i8, i8* %46, align 1, !dbg !855, !tbaa !265
  %384 = icmp eq i8 %383, 1, !dbg !858
  br i1 %384, label %385, label %411, !dbg !859

; <label>:385:                                    ; preds = %382
  tail call fastcc void @ep0_stage_tx(%struct.usb_device_t* nonnull %0) #5, !dbg !860
  br label %411, !dbg !862

; <label>:386:                                    ; preds = %42
  tail call fastcc void @ep0_stage_tx(%struct.usb_device_t* nonnull %0) #7, !dbg !863
  br label %411, !dbg !864

; <label>:387:                                    ; preds = %42
  %388 = and i32 %26, 1, !dbg !865
  %389 = icmp eq i32 %388, 0, !dbg !865
  br i1 %389, label %411, label %390, !dbg !867

; <label>:390:                                    ; preds = %387
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !868, metadata !115) #6, !dbg !875
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115) #6, !dbg !878
  %391 = load i8, i8* %2, align 1, !dbg !880
  %392 = and i8 %391, 1, !dbg !880
  tail call void @llvm.dbg.value(metadata i8 %392, i64 0, metadata !871, metadata !115) #6, !dbg !882
  %393 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 6, !dbg !883
  %394 = load i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)*, i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)** %393, align 4, !dbg !883, !tbaa !884
  %395 = icmp eq i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)* %394, null, !dbg !885
  br i1 %395, label %396, label %397, !dbg !886

; <label>:396:                                    ; preds = %390
  store i8 0, i8* %43, align 1, !dbg !887, !tbaa !265
  br label %404, !dbg !891

; <label>:397:                                    ; preds = %390
  %398 = zext i8 %392 to i32, !dbg !892
  %399 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %398, !dbg !892
  %400 = load %struct.usb_setup_t*, %struct.usb_setup_t** %399, align 4, !dbg !892, !tbaa !126
  %401 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %400, i32 0, i32 1, !dbg !893
  %402 = tail call i32 %394(%struct.usb_device_t* nonnull %0, %struct.usb_ctrlrequest* %401) #5, !dbg !894
  tail call void @llvm.dbg.value(metadata i32 %402, i64 0, metadata !872, metadata !115) #6, !dbg !895
  %403 = trunc i32 %402 to i8, !dbg !896
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115) #6, !dbg !897
  tail call void @llvm.dbg.value(metadata i8 %403, i64 0, metadata !273, metadata !115) #6, !dbg !899
  store i8 %403, i8* %43, align 1, !dbg !900, !tbaa !265
  switch i8 %403, label %411 [
    i8 0, label %404
    i8 2, label %405
  ], !dbg !902

; <label>:404:                                    ; preds = %397, %396
  tail call void @usb_ep0_RxPktEnd(i8 zeroext %392) #5, !dbg !904
  br label %411, !dbg !907

; <label>:405:                                    ; preds = %397
  tail call void @usb_ep0_ClrRxPktRdy(i8 zeroext %392) #5, !dbg !908
  br label %411, !dbg !911

; <label>:406:                                    ; preds = %42, %37
  %407 = phi i8* [ %43, %42 ], [ %38, %37 ]
  %408 = and i32 %26, 1, !dbg !912
  %409 = icmp eq i32 %408, 0, !dbg !912
  br i1 %409, label %411, label %410, !dbg !914

; <label>:410:                                    ; preds = %406
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115), !dbg !915
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115), !dbg !918
  store i8 0, i8* %407, align 1, !dbg !919, !tbaa !265
  tail call void @usb_recover_io_status(i8 zeroext %4) #5, !dbg !921
  br label %411, !dbg !922

; <label>:411:                                    ; preds = %410, %406, %405, %404, %397, %387, %386, %385, %382, %368, %142, %45, %42, %33, %29, %12, %9
  ret void, !dbg !923
}

; Function Attrs: minsize optsize
declare void @usb_write_faddr(i8 zeroext, i32) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare i32 @usb_read_csr0(i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_write_csr0(i8 zeroext, i32) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define void @usb_set_setup_phase(%struct.usb_device_t* nocapture, i8 zeroext) local_unnamed_addr #2 !dbg !269 {
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115), !dbg !925
  tail call void @llvm.dbg.value(metadata i8 %1, i64 0, metadata !273, metadata !115), !dbg !926
  %3 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 1, !dbg !927
  store i8 %1, i8* %3, align 1, !dbg !928, !tbaa !265
  ret void, !dbg !929
}

; Function Attrs: minsize nounwind optsize
define internal fastcc void @ep0_stage_tx(%struct.usb_device_t* nocapture) unnamed_addr #2 !dbg !930 {
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !932, metadata !115), !dbg !939
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115), !dbg !940
  %2 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 12, !dbg !942
  %3 = load i8, i8* %2, align 1, !dbg !942
  %4 = and i8 %3, 1, !dbg !942
  tail call void @llvm.dbg.value(metadata i8 %4, i64 0, metadata !933, metadata !115), !dbg !943
  %5 = tail call i32 @usb_read_csr0(i8 zeroext %4) #5, !dbg !944
  tail call void @llvm.dbg.value(metadata i32 %5, i64 0, metadata !934, metadata !115), !dbg !945
  %6 = and i32 %5, 2, !dbg !946
  %7 = icmp eq i32 %6, 0, !dbg !946
  br i1 %7, label %12, label %8, !dbg !947

; <label>:8:                                      ; preds = %1
  %9 = load i8, i8* @log_tag_const_e_USB, align 1, !dbg !948, !tbaa !210
  %10 = icmp eq i8 %9, 0, !dbg !948
  br i1 %10, label %39, label %11, !dbg !951

; <label>:11:                                     ; preds = %8
  tail call void (i32, i8*, i8*, ...) @log_print(i32 4, i8* null, i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.30, i32 0, i32 0)) #5, !dbg !952
  br label %39, !dbg !952

; <label>:12:                                     ; preds = %1
  %13 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 2, !dbg !954
  %14 = load i16, i16* %13, align 2, !dbg !954, !tbaa !955
  %15 = icmp eq i16 %14, 0, !dbg !956
  br i1 %15, label %16, label %18, !dbg !957

; <label>:16:                                     ; preds = %12
  tail call void @usb_ep0_TxPktEnd(i8 zeroext %4) #5, !dbg !958
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115), !dbg !960
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115), !dbg !962
  %17 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 1, !dbg !963
  store i8 0, i8* %17, align 1, !dbg !964, !tbaa !265
  br label %39, !dbg !965

; <label>:18:                                     ; preds = %12
  %19 = icmp ult i16 %14, 64, !dbg !966
  %20 = select i1 %19, i16 %14, i16 64, !dbg !966
  %21 = zext i16 %20 to i32, !dbg !966
  tail call void @llvm.dbg.value(metadata i32 %21, i64 0, metadata !935, metadata !115), !dbg !967
  %22 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 4, !dbg !968
  %23 = load i8*, i8** %22, align 4, !dbg !968, !tbaa !969
  tail call void @usb_write_ep0(i8 zeroext %4, i8* %23, i32 %21) #5, !dbg !970
  %24 = load i8*, i8** %22, align 4, !dbg !971, !tbaa !969
  %25 = getelementptr inbounds i8, i8* %24, i32 %21, !dbg !971
  store i8* %25, i8** %22, align 4, !dbg !971, !tbaa !969
  %26 = load i16, i16* %13, align 2, !dbg !972, !tbaa !955
  %27 = zext i16 %26 to i32, !dbg !972
  %28 = sub nsw i32 %27, %21, !dbg !972
  %29 = trunc i32 %28 to i16, !dbg !972
  store i16 %29, i16* %13, align 2, !dbg !972, !tbaa !955
  %30 = and i32 %28, 65535, !dbg !973
  %31 = icmp eq i32 %30, 0, !dbg !973
  br i1 %31, label %32, label %36, !dbg !975

; <label>:32:                                     ; preds = %18
  %33 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 8, !dbg !976
  %34 = load i8, i8* %33, align 1, !dbg !976, !tbaa !978
  %35 = icmp eq i8 %34, 0, !dbg !979
  br i1 %35, label %37, label %36, !dbg !980

; <label>:36:                                     ; preds = %32, %18
  tail call void @usb_write_csr0(i8 zeroext %4, i32 2) #5, !dbg !982
  br label %39, !dbg !984

; <label>:37:                                     ; preds = %32
  tail call void @usb_ep0_TxPktEnd(i8 zeroext %4) #5, !dbg !985
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115), !dbg !987
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115), !dbg !989
  %38 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 1, !dbg !990
  store i8 0, i8* %38, align 1, !dbg !991, !tbaa !265
  br label %39

; <label>:39:                                     ; preds = %37, %36, %16, %11, %8
  ret void, !dbg !992
}

; Function Attrs: minsize optsize
declare void @usb_recover_io_status(i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i8* @usb_set_data_payload(%struct.usb_device_t* nocapture, %struct.usb_ctrlrequest* nocapture readonly, i8* readonly, i32) local_unnamed_addr #2 !dbg !994 {
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !1000, metadata !115), !dbg !1007
  tail call void @llvm.dbg.value(metadata %struct.usb_ctrlrequest* %1, i64 0, metadata !1001, metadata !115), !dbg !1008
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !1002, metadata !115), !dbg !1009
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !1003, metadata !115), !dbg !1010
  %5 = icmp eq i32 %3, 0, !dbg !1011
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115), !dbg !1013
  %6 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 1, !dbg !1016
  br i1 %5, label %7, label %8, !dbg !1017

; <label>:7:                                      ; preds = %4
  tail call void @llvm.dbg.value(metadata i8 0, i64 0, metadata !273, metadata !115), !dbg !1018
  store i8 0, i8* %6, align 1, !dbg !1019, !tbaa !265
  br label %28, !dbg !1020

; <label>:8:                                      ; preds = %4
  tail call void @llvm.dbg.value(metadata i8 1, i64 0, metadata !273, metadata !115), !dbg !1021
  store i8 1, i8* %6, align 1, !dbg !1023, !tbaa !265
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !136, metadata !115), !dbg !1024
  %9 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 3, !dbg !1026
  %10 = load i8*, i8** %9, align 4, !dbg !1026, !tbaa !139
  tail call void @llvm.dbg.value(metadata i8* %10, i64 0, metadata !1004, metadata !115), !dbg !1027
  tail call void @llvm.dbg.value(metadata i32 %3, i64 0, metadata !1006, metadata !115), !dbg !1028
  %11 = getelementptr inbounds %struct.usb_ctrlrequest, %struct.usb_ctrlrequest* %1, i32 0, i32 4, !dbg !1029
  %12 = load i16, i16* %11, align 1, !dbg !1029, !tbaa !217
  %13 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 2, !dbg !1030
  store i16 %12, i16* %13, align 2, !dbg !1031, !tbaa !955
  %14 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 4, !dbg !1032
  store i8* %10, i8** %14, align 4, !dbg !1033, !tbaa !969
  %15 = zext i16 %12 to i32, !dbg !1034
  %16 = icmp ugt i32 %15, %3, !dbg !1036
  br i1 %16, label %17, label %19, !dbg !1037

; <label>:17:                                     ; preds = %8
  %18 = trunc i32 %3 to i16, !dbg !1038
  store i16 %18, i16* %13, align 2, !dbg !1040, !tbaa !955
  br label %19, !dbg !1041

; <label>:19:                                     ; preds = %17, %8
  %20 = phi i16 [ %18, %17 ], [ %12, %8 ], !dbg !1042
  %21 = phi i8 [ 1, %17 ], [ 0, %8 ]
  %22 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 8
  store i8 %21, i8* %22, align 1, !tbaa !978
  %23 = icmp eq i16 %20, 0, !dbg !1044
  %24 = icmp eq i8* %10, %2, !dbg !1045
  %25 = or i1 %24, %23, !dbg !1048
  br i1 %25, label %28, label %26, !dbg !1048

; <label>:26:                                     ; preds = %19
  %27 = zext i16 %20 to i32, !dbg !1049
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %10, i8* %2, i32 %27, i32 1, i1 false), !dbg !1051
  br label %28, !dbg !1052

; <label>:28:                                     ; preds = %26, %19, %7
  %29 = phi i8* [ null, %7 ], [ %10, %19 ], [ %10, %26 ]
  ret i8* %29, !dbg !1053
}

; Function Attrs: minsize nounwind optsize
define i32 @usb_set_reset_hander(i8 zeroext, i32, void (%struct.usb_device_t*, i32)*) local_unnamed_addr #2 !dbg !1055 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1059, metadata !115), !dbg !1062
  tail call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !1060, metadata !115), !dbg !1063
  tail call void @llvm.dbg.value(metadata void (%struct.usb_device_t*, i32)* %2, i64 0, metadata !1061, metadata !115), !dbg !1064
  %4 = icmp ugt i32 %1, 8, !dbg !1065
  br i1 %4, label %12, label %5, !dbg !1067

; <label>:5:                                      ; preds = %3
  %6 = zext i8 %0 to i32, !dbg !1068
  %7 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %6, !dbg !1068
  %8 = load %struct.usb_setup_t*, %struct.usb_setup_t** %7, align 4, !dbg !1068, !tbaa !126
  %9 = icmp eq %struct.usb_setup_t* %8, null, !dbg !1068
  br i1 %9, label %12, label %10, !dbg !1070

; <label>:10:                                     ; preds = %5
  %11 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %8, i32 0, i32 3, i32 %1, !dbg !1071
  store void (%struct.usb_device_t*, i32)* %2, void (%struct.usb_device_t*, i32)** %11, align 4, !dbg !1073, !tbaa !126
  br label %12, !dbg !1074

; <label>:12:                                     ; preds = %10, %5, %3
  %13 = phi i32 [ 0, %3 ], [ %1, %5 ], [ %1, %10 ]
  ret i32 %13, !dbg !1075
}

; Function Attrs: minsize nounwind optsize
define void @usb_reset_interface(%struct.usb_device_t*) local_unnamed_addr #2 !dbg !1076 {
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !1078, metadata !115), !dbg !1086
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115), !dbg !1087
  %2 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 12, !dbg !1089
  %3 = load i8, i8* %2, align 1, !dbg !1089
  %4 = and i8 %3, 1, !dbg !1089
  tail call void @llvm.dbg.value(metadata i8 %4, i64 0, metadata !1079, metadata !115), !dbg !1090
  %5 = zext i8 %4 to i32, !dbg !1091
  %6 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %5, !dbg !1091
  %7 = load %struct.usb_setup_t*, %struct.usb_setup_t** %6, align 4, !dbg !1091, !tbaa !126
  %8 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %7, i32 0, i32 0, i32 7, !dbg !1092
  store i8 2, i8* %8, align 4, !dbg !1093, !tbaa !248
  %9 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 10, !dbg !1094
  %10 = load i8, i8* %9, align 1, !dbg !1095
  %11 = and i8 %10, -3, !dbg !1095
  store i8 %11, i8* %9, align 1, !dbg !1095
  %12 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 0, !dbg !1096
  store i8 0, i8* %12, align 4, !dbg !1097, !tbaa !251
  tail call void @usb_write_faddr(i8 zeroext %4, i32 0) #5, !dbg !1098
  %13 = load %struct.usb_setup_t*, %struct.usb_setup_t** %6, align 4, !dbg !1099, !tbaa !126
  %14 = icmp eq %struct.usb_setup_t* %13, null, !dbg !1099
  br i1 %14, label %28, label %15, !dbg !1100

; <label>:15:                                     ; preds = %1
  br label %16, !dbg !1101

; <label>:16:                                     ; preds = %25, %15
  %17 = phi i32 [ %26, %25 ], [ 0, %15 ]
  tail call void @llvm.dbg.value(metadata i32 %17, i64 0, metadata !1080, metadata !115), !dbg !1101
  %18 = icmp eq i32 %17, 8, !dbg !1102
  br i1 %18, label %27, label %19, !dbg !1105

; <label>:19:                                     ; preds = %16
  %20 = load %struct.usb_setup_t*, %struct.usb_setup_t** %6, align 4, !dbg !1107, !tbaa !126
  %21 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %20, i32 0, i32 3, i32 %17, !dbg !1107
  %22 = load void (%struct.usb_device_t*, i32)*, void (%struct.usb_device_t*, i32)** %21, align 4, !dbg !1107, !tbaa !126
  %23 = icmp eq void (%struct.usb_device_t*, i32)* %22, null, !dbg !1107
  br i1 %23, label %25, label %24, !dbg !1110

; <label>:24:                                     ; preds = %19
  tail call void %22(%struct.usb_device_t* %0, i32 -1) #5, !dbg !1111
  br label %25, !dbg !1113

; <label>:25:                                     ; preds = %24, %19
  %26 = add nuw nsw i32 %17, 1, !dbg !1114
  tail call void @llvm.dbg.value(metadata i32 %26, i64 0, metadata !1080, metadata !115), !dbg !1101
  br label %16, !dbg !1116, !llvm.loop !1117

; <label>:27:                                     ; preds = %16
  br label %28, !dbg !1120

; <label>:28:                                     ; preds = %27, %1
  %29 = tail call i32 @usb_read_power(i8 zeroext %4) #5, !dbg !1121
  tail call void @llvm.dbg.value(metadata i32 %29, i64 0, metadata !1085, metadata !115), !dbg !1123
  %30 = and i32 %29, 16, !dbg !1124
  %31 = icmp eq i32 %30, 0, !dbg !1124
  %32 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 11
  br i1 %31, label %37, label %33, !dbg !1126

; <label>:33:                                     ; preds = %28
  store i8 3, i8* %32, align 4, !dbg !1127, !tbaa !1129
  %34 = load i8, i8* @log_tag_const_i_USB, align 1, !dbg !1130, !tbaa !210
  %35 = icmp eq i8 %34, 0, !dbg !1130
  br i1 %35, label %41, label %36, !dbg !1132

; <label>:36:                                     ; preds = %33
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.23, i32 0, i32 0)) #5, !dbg !1133
  br label %41, !dbg !1133

; <label>:37:                                     ; preds = %28
  store i8 2, i8* %32, align 4, !dbg !1135, !tbaa !1129
  %38 = load i8, i8* @log_tag_const_i_USB, align 1, !dbg !1137, !tbaa !210
  %39 = icmp eq i8 %38, 0, !dbg !1137
  br i1 %39, label %41, label %40, !dbg !1139

; <label>:40:                                     ; preds = %37
  tail call void (i32, i8*, i8*, ...) @log_print(i32 2, i8* null, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.24, i32 0, i32 0)) #5, !dbg !1140
  br label %41, !dbg !1140

; <label>:41:                                     ; preds = %40, %37, %36, %33
  ret void, !dbg !1142
}

; Function Attrs: minsize optsize
declare i32 @usb_read_power(i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define void @usb_set_setup_recv(%struct.usb_device_t* nocapture, i8*) local_unnamed_addr #2 !dbg !1143 {
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !1147, metadata !115), !dbg !1150
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !1148, metadata !115), !dbg !1151
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115), !dbg !1152
  %3 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 12, !dbg !1154
  %4 = load i8, i8* %3, align 1, !dbg !1154
  %5 = and i8 %4, 1, !dbg !1154
  tail call void @llvm.dbg.value(metadata i8 %5, i64 0, metadata !1149, metadata !115), !dbg !1155
  %6 = zext i8 %5 to i32, !dbg !1156
  %7 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %6, !dbg !1156
  %8 = load %struct.usb_setup_t*, %struct.usb_setup_t** %7, align 4, !dbg !1156, !tbaa !126
  %9 = icmp eq %struct.usb_setup_t* %8, null, !dbg !1156
  br i1 %9, label %13, label %10, !dbg !1158

; <label>:10:                                     ; preds = %2
  %11 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 6, !dbg !1159
  %12 = bitcast i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)** %11 to i8**, !dbg !1161
  store i8* %1, i8** %12, align 4, !dbg !1161, !tbaa !884
  br label %13, !dbg !1162

; <label>:13:                                     ; preds = %10, %2
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !268, metadata !115), !dbg !1163
  tail call void @llvm.dbg.value(metadata i8 2, i64 0, metadata !273, metadata !115), !dbg !1165
  %14 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 1, !dbg !1166
  store i8 2, i8* %14, align 1, !dbg !1167, !tbaa !265
  ret void, !dbg !1168
}

; Function Attrs: minsize nounwind optsize
define void @usb_set_setup_hook(%struct.usb_device_t* nocapture, i8*) local_unnamed_addr #2 !dbg !1169 {
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !1171, metadata !115), !dbg !1174
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !1172, metadata !115), !dbg !1175
  tail call void @llvm.dbg.value(metadata %struct.usb_device_t* %0, i64 0, metadata !114, metadata !115), !dbg !1176
  %3 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 12, !dbg !1178
  %4 = load i8, i8* %3, align 1, !dbg !1178
  %5 = and i8 %4, 1, !dbg !1178
  tail call void @llvm.dbg.value(metadata i8 %5, i64 0, metadata !1173, metadata !115), !dbg !1179
  %6 = zext i8 %5 to i32, !dbg !1180
  %7 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %6, !dbg !1180
  %8 = load %struct.usb_setup_t*, %struct.usb_setup_t** %7, align 4, !dbg !1180, !tbaa !126
  %9 = icmp eq %struct.usb_setup_t* %8, null, !dbg !1180
  br i1 %9, label %13, label %10, !dbg !1182

; <label>:10:                                     ; preds = %2
  %11 = getelementptr inbounds %struct.usb_device_t, %struct.usb_device_t* %0, i32 0, i32 5, !dbg !1183
  %12 = bitcast i32 (%struct.usb_device_t*, %struct.usb_ctrlrequest*)** %11 to i8**, !dbg !1185
  store i8* %1, i8** %12, align 4, !dbg !1185, !tbaa !330
  br label %13, !dbg !1186

; <label>:13:                                     ; preds = %10, %2
  ret void, !dbg !1187
}

; Function Attrs: minsize nounwind optsize
define void @usb_setup_init(i8 zeroext, i8*, i8*) local_unnamed_addr #2 !dbg !1188 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1192, metadata !115), !dbg !1198
  tail call void @llvm.dbg.value(metadata i8* %1, i64 0, metadata !1193, metadata !115), !dbg !1199
  tail call void @llvm.dbg.value(metadata i8* %2, i64 0, metadata !1194, metadata !115), !dbg !1200
  %4 = zext i8 %0 to i32, !dbg !1201
  %5 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %4, !dbg !1201
  %6 = bitcast %struct.usb_setup_t** %5 to i8**, !dbg !1202
  store i8* %1, i8** %6, align 4, !dbg !1202, !tbaa !126
  %7 = icmp eq i8* %1, null, !dbg !1203
  br i1 %7, label %24, label %8, !dbg !1204

; <label>:8:                                      ; preds = %3
  %9 = getelementptr inbounds i8, i8* %1, i32 25, !dbg !1205
  %10 = load i8, i8* %9, align 1, !dbg !1206
  %11 = and i8 %0, 1, !dbg !1206
  %12 = and i8 %10, -2, !dbg !1206
  %13 = or i8 %12, %11, !dbg !1206
  store i8 %13, i8* %9, align 1, !dbg !1206
  %14 = load %struct.usb_setup_t*, %struct.usb_setup_t** %5, align 4, !dbg !1207, !tbaa !126
  %15 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %14, i32 0, i32 0, i32 3, !dbg !1208
  store i8* %2, i8** %15, align 4, !dbg !1209, !tbaa !1210
  %16 = load %struct.usb_setup_t*, %struct.usb_setup_t** %5, align 4, !dbg !1211, !tbaa !126
  %17 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %16, i32 0, i32 0, i32 7, !dbg !1212
  store i8 2, i8* %17, align 4, !dbg !1213, !tbaa !248
  %18 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %16, i32 0, i32 0, i32 3, !dbg !1214
  %19 = load i8*, i8** %18, align 4, !dbg !1214, !tbaa !139
  tail call void @llvm.dbg.value(metadata i8* %19, i64 0, metadata !1195, metadata !115), !dbg !1216
  %20 = getelementptr inbounds %struct.usb_setup_t, %struct.usb_setup_t* %16, i32 0, i32 0, i32 9, !dbg !1217
  %21 = load i8, i8* %20, align 2, !dbg !1217, !tbaa !1218
  %22 = zext i8 %21 to i32, !dbg !1219
  %23 = tail call i32 @set_descriptor(i8 zeroext %0, i32 %22, i8* %19, i32 768) #5, !dbg !1220
  br label %24, !dbg !1221

; <label>:24:                                     ; preds = %8, %3
  ret void, !dbg !1222
}

; Function Attrs: minsize optsize
declare i32 @set_descriptor(i8 zeroext, i32, i8*, i32) local_unnamed_addr #4

; Function Attrs: minsize nounwind optsize
define i32 @usb_setup_release(i8 zeroext) local_unnamed_addr #2 !dbg !1223 {
  tail call void @llvm.dbg.value(metadata i8 %0, i64 0, metadata !1227, metadata !115), !dbg !1228
  %2 = zext i8 %0 to i32, !dbg !1229
  %3 = getelementptr inbounds [2 x %struct.usb_setup_t*], [2 x %struct.usb_setup_t*]* @usb_setup, i32 0, i32 %2, !dbg !1229
  %4 = load %struct.usb_setup_t*, %struct.usb_setup_t** %3, align 4, !dbg !1229, !tbaa !126
  %5 = icmp eq %struct.usb_setup_t* %4, null, !dbg !1229
  br i1 %5, label %7, label %6, !dbg !1231

; <label>:6:                                      ; preds = %1
  store %struct.usb_setup_t* null, %struct.usb_setup_t** %3, align 4, !dbg !1232, !tbaa !126
  br label %7, !dbg !1234

; <label>:7:                                      ; preds = %6, %1
  ret i32 0, !dbg !1235
}

; Function Attrs: minsize optsize
declare void @usb_read_ep0(i8 zeroext, i8*, i32) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_ep0_RxPktEnd(i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_ep0_ClrRxPktRdy(i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_ep0_Set_Stall(i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_ep0_Set_ignore(i8 zeroext, i32) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @get_device_descriptor(i8*, i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @get_language_str(i8*) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @get_manufacture_str(i8*) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @get_product_str(i8*) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @get_iserialnumber_str(i8*) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @get_string_ee(i8*) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_disable_ep(i8 zeroext, i32) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare i32 @udelay(...) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_write_ep0(i8 zeroext, i8*, i32) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @unrequest_irq(i8 zeroext, i8 zeroext) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_write_txcsr(i8 zeroext, i32, i32) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_write_rxcsr(i8 zeroext, i32, i32) local_unnamed_addr #4

; Function Attrs: minsize optsize
declare void @usb_ep0_TxPktEnd(i8 zeroext) local_unnamed_addr #4

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #1

attributes #0 = { minsize nounwind optsize readonly "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { minsize nounwind optsize "allow-nullptr-deref" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { minsize optsize "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="r3" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { minsize nounwind optsize }
attributes #6 = { nounwind }
attributes #7 = { minsize optsize }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!105, !106}
!llvm.ident = !{!107}

!0 = !DIGlobalVariableExpression(var: !1)
!1 = distinct !DIGlobalVariable(name: "usb_setup", scope: !2, file: !3, line: 15, type: !104, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 4.0.1 () ()", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !23, globals: !82)
!3 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver/device/usb/device/usb_setup.c", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 23, size: 32, elements: !7)
!6 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/device/usb/device/usb_stack.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!7 = !{!8, !9, !10, !11, !12, !13}
!8 = !DIEnumerator(name: "USB_ATTACHED", value: 0)
!9 = !DIEnumerator(name: "USB_POWERED", value: 1)
!10 = !DIEnumerator(name: "USB_DEFAULT", value: 2)
!11 = !DIEnumerator(name: "USB_ADDRESS", value: 3)
!12 = !DIEnumerator(name: "USB_CONFIGURED", value: 4)
!13 = !DIEnumerator(name: "USB_SUSPENDED", value: 5)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "usb_device_speed", file: !15, line: 922, size: 32, elements: !16)
!15 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/device/usb/ch9.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!16 = !{!17, !18, !19, !20, !21, !22}
!17 = !DIEnumerator(name: "USB_SPEED_UNKNOWN", value: 0)
!18 = !DIEnumerator(name: "USB_SPEED_LOW", value: 1)
!19 = !DIEnumerator(name: "USB_SPEED_FULL", value: 2)
!20 = !DIEnumerator(name: "USB_SPEED_HIGH", value: 3)
!21 = !DIEnumerator(name: "USB_SPEED_WIRELESS", value: 4)
!22 = !DIEnumerator(name: "USB_SPEED_SUPER", value: 5)
!23 = !{!24, !29, !30, !42, !26, !39, !80}
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "usb_dev", file: !25, line: 146, baseType: !26)
!25 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/usb.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "u8", file: !27, line: 14, baseType: !28)
!27 = !DIFile(filename: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/include_lib/driver/cpu/wl82/asm/cpu.h", directory: "/jks/workspace/wifi_sdk_all_export_gitlab/wifi_sdk/lib/driver")
!28 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 32)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 32)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "usb_setup_t", file: !6, line: 63, size: 800, align: 32, elements: !32)
!32 = !{!33, !68, !69, !74}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "usb_device", scope: !31, file: !6, line: 64, baseType: !34, size: 224)
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "usb_device_t", file: !6, line: 33, size: 224, elements: !35)
!35 = !{!36, !37, !38, !41, !43, !44, !59, !60, !61, !62, !63, !64, !65, !66, !67}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "baddr", scope: !34, file: !6, line: 34, baseType: !26, size: 8)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "bsetup_phase", scope: !34, file: !6, line: 35, baseType: !26, size: 8, offset: 8)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "wDataLength", scope: !34, file: !6, line: 36, baseType: !39, size: 16, offset: 16)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "u16", file: !27, line: 17, baseType: !40)
!40 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "setup_buffer", scope: !34, file: !6, line: 38, baseType: !42, size: 32, offset: 32)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 32)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "setup_ptr", scope: !34, file: !6, line: 39, baseType: !42, size: 32, offset: 64)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "setup_hook", scope: !34, file: !6, line: 40, baseType: !45, size: 32, offset: 96)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 32)
!46 = !DISubroutineType(types: !47)
!47 = !{!48, !50, !51}
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "u32", file: !27, line: 19, baseType: !49)
!49 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 32)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 32)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "usb_ctrlrequest", file: !15, line: 188, size: 64, elements: !53)
!53 = !{!54, !55, !56, !57, !58}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "bRequestType", scope: !52, file: !15, line: 189, baseType: !26, size: 8)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "bRequest", scope: !52, file: !15, line: 190, baseType: !26, size: 8, offset: 8)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "wValue", scope: !52, file: !15, line: 191, baseType: !39, size: 16, offset: 16)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "wIndex", scope: !52, file: !15, line: 192, baseType: !39, size: 16, offset: 32)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "wLength", scope: !52, file: !15, line: 193, baseType: !39, size: 16, offset: 48)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "setup_recv", scope: !34, file: !6, line: 41, baseType: !45, size: 32, offset: 128)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "bDeviceStates", scope: !34, file: !6, line: 43, baseType: !26, size: 8, offset: 160)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "bDataOverFlag", scope: !34, file: !6, line: 44, baseType: !26, size: 8, offset: 168)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "wDeviceClass", scope: !34, file: !6, line: 45, baseType: !26, size: 8, offset: 176)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "bRemoteWakup", scope: !34, file: !6, line: 46, baseType: !26, size: 1, offset: 184, flags: DIFlagBitField, extraData: i64 184)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "baddr_config", scope: !34, file: !6, line: 47, baseType: !26, size: 1, offset: 185, flags: DIFlagBitField, extraData: i64 184)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "bSpeed", scope: !34, file: !6, line: 48, baseType: !26, size: 8, offset: 192)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "usb_id", scope: !34, file: !6, line: 50, baseType: !26, size: 1, offset: 200, flags: DIFlagBitField, extraData: i64 200)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "res", scope: !34, file: !6, line: 51, baseType: !26, size: 5, offset: 201, flags: DIFlagBitField, extraData: i64 200)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "request", scope: !31, file: !6, line: 65, baseType: !52, size: 64, offset: 224)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "interface_hander", scope: !31, file: !6, line: 66, baseType: !70, size: 256, offset: 288)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 256, elements: !72)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "itf_hander", file: !6, line: 57, baseType: !45)
!72 = !{!73}
!73 = !DISubrange(count: 8)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "reset_hander", scope: !31, file: !6, line: 67, baseType: !75, size: 256, offset: 544)
!75 = !DICompositeType(tag: DW_TAG_array_type, baseType: !76, size: 256, elements: !72)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "itf_reset_hander", file: !6, line: 58, baseType: !77)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 32)
!78 = !DISubroutineType(types: !79)
!79 = !{null, !50, !48}
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 32)
!81 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !26)
!82 = !{!0, !83, !97, !102}
!83 = !DIGlobalVariableExpression(var: !84)
!84 = distinct !DIGlobalVariable(name: "pattern", scope: !85, file: !3, line: 82, type: !93, isLocal: true, isDefinition: true)
!85 = distinct !DISubprogram(name: "test_mode", scope: !3, file: !3, line: 80, type: !86, isLocal: true, isDefinition: true, scopeLine: 81, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !88)
!86 = !DISubroutineType(types: !87)
!87 = !{null, !50, !51}
!88 = !{!89, !90, !91}
!89 = !DILocalVariable(name: "usb_device", arg: 1, scope: !85, file: !3, line: 80, type: !50)
!90 = !DILocalVariable(name: "req", arg: 2, scope: !85, file: !3, line: 80, type: !51)
!91 = !DILocalVariable(name: "usb_id", scope: !85, file: !3, line: 92, type: !92)
!92 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!93 = !DICompositeType(tag: DW_TAG_array_type, baseType: !94, size: 424, elements: !95)
!94 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!95 = !{!96}
!96 = !DISubrange(count: 53)
!97 = !DIGlobalVariableExpression(var: !98)
!98 = distinct !DIGlobalVariable(name: "ep_in_status", scope: !2, file: !3, line: 311, type: !99, isLocal: true, isDefinition: true)
!99 = !DICompositeType(tag: DW_TAG_array_type, baseType: !39, size: 32, elements: !100)
!100 = !{!101}
!101 = !DISubrange(count: 2)
!102 = !DIGlobalVariableExpression(var: !103)
!103 = distinct !DIGlobalVariable(name: "ep_out_status", scope: !2, file: !3, line: 312, type: !99, isLocal: true, isDefinition: true)
!104 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 64, elements: !100)
!105 = !{i32 2, !"Dwarf Version", i32 4}
!106 = !{i32 2, !"Debug Info Version", i32 3}
!107 = !{!"clang version 4.0.1 () ()"}
!108 = distinct !DISubprogram(name: "usb_device2id", scope: !3, file: !3, line: 17, type: !109, isLocal: false, isDefinition: true, scopeLine: 18, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !113)
!109 = !DISubroutineType(types: !110)
!110 = !{!92, !111}
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 32)
!112 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!113 = !{!114}
!114 = !DILocalVariable(name: "usb_device", arg: 1, scope: !108, file: !3, line: 17, type: !111)
!115 = !DIExpression()
!116 = !DILocation(line: 17, column: 56, scope: !108)
!117 = !DILocation(line: 20, column: 33, scope: !108)
!118 = !DILocation(line: 20, column: 5, scope: !108)
!119 = distinct !DISubprogram(name: "usb_id2device", scope: !3, file: !3, line: 25, type: !120, isLocal: false, isDefinition: true, scopeLine: 26, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !122)
!120 = !DISubroutineType(types: !121)
!121 = !{!50, !92}
!122 = !{!123}
!123 = !DILocalVariable(name: "usb_id", arg: 1, scope: !119, file: !3, line: 25, type: !92)
!124 = !DILocation(line: 25, column: 50, scope: !119)
!125 = !DILocation(line: 27, column: 14, scope: !119)
!126 = !{!127, !127, i64 0}
!127 = !{!"any pointer", !128, i64 0}
!128 = !{!"omnipotent char", !129, i64 0}
!129 = !{!"Simple C/C++ TBAA"}
!130 = !DILocation(line: 27, column: 33, scope: !119)
!131 = !DILocation(line: 27, column: 5, scope: !119)
!132 = distinct !DISubprogram(name: "usb_get_setup_buffer", scope: !3, file: !3, line: 29, type: !133, isLocal: false, isDefinition: true, scopeLine: 30, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !135)
!133 = !DISubroutineType(types: !134)
!134 = !{!29, !111}
!135 = !{!136}
!136 = !DILocalVariable(name: "usb_device", arg: 1, scope: !132, file: !3, line: 29, type: !111)
!137 = !DILocation(line: 29, column: 55, scope: !132)
!138 = !DILocation(line: 31, column: 24, scope: !132)
!139 = !{!140, !127, i64 4}
!140 = !{!"usb_device_t", !128, i64 0, !128, i64 1, !141, i64 2, !127, i64 4, !127, i64 8, !127, i64 12, !127, i64 16, !128, i64 20, !128, i64 21, !128, i64 22, !128, i64 23, !128, i64 23, !128, i64 24, !128, i64 25, !128, i64 25}
!141 = !{!"short", !128, i64 0}
!142 = !DILocation(line: 31, column: 5, scope: !132)
!143 = distinct !DISubprogram(name: "usb_device_set_class", scope: !3, file: !3, line: 33, type: !78, isLocal: false, isDefinition: true, scopeLine: 34, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !144)
!144 = !{!145, !146}
!145 = !DILocalVariable(name: "usb_device", arg: 1, scope: !143, file: !3, line: 33, type: !50)
!146 = !DILocalVariable(name: "class_config", arg: 2, scope: !143, file: !3, line: 33, type: !48)
!147 = !DILocation(line: 33, column: 48, scope: !143)
!148 = !DILocation(line: 33, column: 64, scope: !143)
!149 = !DILocation(line: 35, column: 32, scope: !143)
!150 = !DILocation(line: 35, column: 17, scope: !143)
!151 = !DILocation(line: 35, column: 30, scope: !143)
!152 = !{!140, !128, i64 22}
!153 = !DILocation(line: 36, column: 1, scope: !143)
!154 = distinct !DISubprogram(name: "usb_set_interface_hander", scope: !3, file: !3, line: 300, type: !155, isLocal: false, isDefinition: true, scopeLine: 301, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !157)
!155 = !DISubroutineType(types: !156)
!156 = !{!48, !92, !48, !71}
!157 = !{!158, !159, !160}
!158 = !DILocalVariable(name: "usb_id", arg: 1, scope: !154, file: !3, line: 300, type: !92)
!159 = !DILocalVariable(name: "itf_num", arg: 2, scope: !154, file: !3, line: 300, type: !48)
!160 = !DILocalVariable(name: "hander", arg: 3, scope: !154, file: !3, line: 300, type: !71)
!161 = !DILocation(line: 300, column: 44, scope: !154)
!162 = !DILocation(line: 300, column: 56, scope: !154)
!163 = !DILocation(line: 300, column: 76, scope: !154)
!164 = !DILocation(line: 302, column: 17, scope: !165)
!165 = distinct !DILexicalBlock(scope: !154, file: !3, line: 302, column: 9)
!166 = !DILocation(line: 302, column: 9, scope: !154)
!167 = !DILocation(line: 305, column: 9, scope: !168)
!168 = distinct !DILexicalBlock(scope: !154, file: !3, line: 305, column: 9)
!169 = !DILocation(line: 305, column: 9, scope: !154)
!170 = !DILocation(line: 306, column: 9, scope: !171)
!171 = distinct !DILexicalBlock(scope: !168, file: !3, line: 305, column: 28)
!172 = !DILocation(line: 306, column: 54, scope: !171)
!173 = !DILocation(line: 307, column: 5, scope: !171)
!174 = !DILocation(line: 309, column: 1, scope: !154)
!175 = distinct !DISubprogram(name: "dump_setup_request", scope: !3, file: !3, line: 403, type: !176, isLocal: false, isDefinition: true, scopeLine: 404, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !180)
!176 = !DISubroutineType(types: !177)
!177 = !{null, !178}
!178 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !179, size: 32)
!179 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !52)
!180 = !{!181, !182, !189, !190, !194, !195}
!181 = !DILocalVariable(name: "request", arg: 1, scope: !175, file: !3, line: 403, type: !178)
!182 = !DILocalVariable(name: "types", scope: !175, file: !3, line: 405, type: !183)
!183 = !DICompositeType(tag: DW_TAG_array_type, baseType: !184, size: 128, elements: !187)
!184 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !185, size: 32)
!185 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !186)
!186 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!187 = !{!188}
!188 = !DISubrange(count: 4)
!189 = !DILocalVariable(name: "recips", scope: !175, file: !3, line: 406, type: !183)
!190 = !DILocalVariable(name: "bRequests", scope: !175, file: !3, line: 407, type: !191)
!191 = !DICompositeType(tag: DW_TAG_array_type, baseType: !184, size: 384, elements: !192)
!192 = !{!193}
!193 = !DISubrange(count: 12)
!194 = !DILocalVariable(name: "bRequestType", scope: !175, file: !3, line: 410, type: !48)
!195 = !DILocalVariable(name: "recip", scope: !175, file: !3, line: 412, type: !48)
!196 = !DILocation(line: 403, column: 55, scope: !175)
!197 = !DILocation(line: 405, column: 17, scope: !175)
!198 = !DILocation(line: 406, column: 17, scope: !175)
!199 = !DILocation(line: 407, column: 17, scope: !175)
!200 = !DILocation(line: 410, column: 33, scope: !175)
!201 = !{!202, !128, i64 0}
!202 = !{!"usb_ctrlrequest", !128, i64 0, !128, i64 1, !141, i64 2, !141, i64 4, !141, i64 6}
!203 = !DILocation(line: 410, column: 24, scope: !175)
!204 = !DILocation(line: 411, column: 18, scope: !175)
!205 = !DILocation(line: 410, column: 9, scope: !175)
!206 = !DILocation(line: 412, column: 39, scope: !175)
!207 = !DILocation(line: 412, column: 9, scope: !175)
!208 = !DILocation(line: 413, column: 5, scope: !209)
!209 = distinct !DILexicalBlock(scope: !175, file: !3, line: 413, column: 5)
!210 = !{!128, !128, i64 0}
!211 = !DILocation(line: 413, column: 5, scope: !175)
!212 = !DILocation(line: 413, column: 5, scope: !213)
!213 = !DILexicalBlockFile(scope: !209, file: !3, discriminator: 1)
!214 = !{!202, !128, i64 1}
!215 = !{!202, !141, i64 2}
!216 = !{!202, !141, i64 4}
!217 = !{!202, !141, i64 6}
!218 = !DILocation(line: 419, column: 1, scope: !175)
!219 = distinct !DISubprogram(name: "usb_control_transfer", scope: !3, file: !3, line: 482, type: !220, isLocal: false, isDefinition: true, scopeLine: 483, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !222)
!220 = !DISubroutineType(types: !221)
!221 = !{null, !50}
!222 = !{!223, !224, !225}
!223 = !DILocalVariable(name: "usb_device", arg: 1, scope: !219, file: !3, line: 482, type: !50)
!224 = !DILocalVariable(name: "usb_id", scope: !219, file: !3, line: 484, type: !92)
!225 = !DILocalVariable(name: "reg", scope: !219, file: !3, line: 485, type: !48)
!226 = !DILocation(line: 482, column: 48, scope: !219)
!227 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !228)
!228 = distinct !DILocation(line: 484, column: 28, scope: !219)
!229 = !DILocation(line: 20, column: 33, scope: !108, inlinedAt: !228)
!230 = !DILocation(line: 484, column: 19, scope: !219)
!231 = !DILocation(line: 486, column: 9, scope: !232)
!232 = distinct !DILexicalBlock(scope: !219, file: !3, line: 486, column: 9)
!233 = !DILocation(line: 486, column: 27, scope: !232)
!234 = !DILocation(line: 486, column: 9, scope: !219)
!235 = !DILocation(line: 487, column: 9, scope: !236)
!236 = distinct !DILexicalBlock(scope: !237, file: !3, line: 487, column: 9)
!237 = distinct !DILexicalBlock(scope: !232, file: !3, line: 486, column: 36)
!238 = !DILocation(line: 487, column: 9, scope: !237)
!239 = !DILocation(line: 487, column: 9, scope: !240)
!240 = !DILexicalBlockFile(scope: !236, file: !3, discriminator: 1)
!241 = !DILocation(line: 491, column: 21, scope: !242)
!242 = distinct !DILexicalBlock(scope: !219, file: !3, line: 491, column: 9)
!243 = !DILocation(line: 491, column: 9, scope: !242)
!244 = !DILocation(line: 491, column: 9, scope: !219)
!245 = !DILocation(line: 492, column: 39, scope: !246)
!246 = distinct !DILexicalBlock(scope: !242, file: !3, line: 491, column: 35)
!247 = !DILocation(line: 492, column: 53, scope: !246)
!248 = !{!249, !128, i64 20}
!249 = !{!"usb_setup_t", !140, i64 0, !202, i64 28, !128, i64 36, !128, i64 68}
!250 = !DILocation(line: 493, column: 45, scope: !246)
!251 = !{!140, !128, i64 0}
!252 = !DILocation(line: 493, column: 33, scope: !246)
!253 = !DILocation(line: 493, column: 9, scope: !246)
!254 = !DILocation(line: 494, column: 34, scope: !246)
!255 = !DILocation(line: 495, column: 5, scope: !246)
!256 = !DILocation(line: 497, column: 11, scope: !219)
!257 = !DILocation(line: 485, column: 9, scope: !219)
!258 = !DILocation(line: 498, column: 13, scope: !259)
!259 = distinct !DILexicalBlock(scope: !219, file: !3, line: 498, column: 9)
!260 = !DILocation(line: 498, column: 9, scope: !219)
!261 = !DILocation(line: 499, column: 9, scope: !262)
!262 = distinct !DILexicalBlock(scope: !259, file: !3, line: 498, column: 32)
!263 = !DILocation(line: 500, column: 25, scope: !264)
!264 = distinct !DILexicalBlock(scope: !262, file: !3, line: 500, column: 13)
!265 = !{!140, !128, i64 1}
!266 = !DILocation(line: 500, column: 38, scope: !264)
!267 = !DILocation(line: 500, column: 13, scope: !262)
!268 = !DILocalVariable(name: "usb_device", arg: 1, scope: !269, file: !3, line: 538, type: !50)
!269 = distinct !DISubprogram(name: "usb_set_setup_phase", scope: !3, file: !3, line: 538, type: !270, isLocal: false, isDefinition: true, scopeLine: 539, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !272)
!270 = !DISubroutineType(types: !271)
!271 = !{null, !50, !26}
!272 = !{!268, !273}
!273 = !DILocalVariable(name: "setup_phase", arg: 2, scope: !269, file: !3, line: 538, type: !26)
!274 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !275)
!275 = distinct !DILocation(line: 501, column: 13, scope: !276)
!276 = distinct !DILexicalBlock(scope: !264, file: !3, line: 500, column: 57)
!277 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !275)
!278 = !DILocation(line: 540, column: 30, scope: !269, inlinedAt: !275)
!279 = !DILocation(line: 502, column: 9, scope: !276)
!280 = !DILocation(line: 506, column: 13, scope: !281)
!281 = distinct !DILexicalBlock(scope: !219, file: !3, line: 506, column: 9)
!282 = !DILocation(line: 506, column: 9, scope: !219)
!283 = !DILocation(line: 507, column: 9, scope: !284)
!284 = distinct !DILexicalBlock(scope: !281, file: !3, line: 506, column: 31)
!285 = !DILocation(line: 508, column: 25, scope: !286)
!286 = distinct !DILexicalBlock(scope: !284, file: !3, line: 508, column: 13)
!287 = !DILocation(line: 508, column: 38, scope: !286)
!288 = !DILocation(line: 508, column: 13, scope: !284)
!289 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !290)
!290 = distinct !DILocation(line: 509, column: 13, scope: !291)
!291 = distinct !DILexicalBlock(scope: !286, file: !3, line: 508, column: 57)
!292 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !290)
!293 = !DILocation(line: 540, column: 30, scope: !294, inlinedAt: !290)
!294 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 1)
!295 = !DILocation(line: 513, column: 5, scope: !219)
!296 = !DILocation(line: 513, column: 5, scope: !297)
!297 = !DILexicalBlockFile(scope: !219, file: !3, discriminator: 1)
!298 = !DILocation(line: 515, column: 17, scope: !299)
!299 = distinct !DILexicalBlock(scope: !300, file: !3, line: 515, column: 13)
!300 = distinct !DILexicalBlock(scope: !219, file: !3, line: 513, column: 39)
!301 = !DILocation(line: 515, column: 13, scope: !300)
!302 = !DILocalVariable(name: "usb_device", arg: 1, scope: !303, file: !3, line: 420, type: !50)
!303 = distinct !DISubprogram(name: "usb_setup_dispatch", scope: !3, file: !3, line: 420, type: !220, isLocal: true, isDefinition: true, scopeLine: 421, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !304)
!304 = !{!302, !305, !306}
!305 = !DILocalVariable(name: "usb_id", scope: !303, file: !3, line: 422, type: !92)
!306 = !DILocalVariable(name: "recip", scope: !303, file: !3, line: 424, type: !48)
!307 = !DILocation(line: 420, column: 53, scope: !303, inlinedAt: !308)
!308 = distinct !DILocation(line: 516, column: 13, scope: !309)
!309 = distinct !DILexicalBlock(scope: !299, file: !3, line: 515, column: 35)
!310 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !311)
!311 = distinct !DILocation(line: 422, column: 28, scope: !303, inlinedAt: !308)
!312 = !DILocation(line: 20, column: 33, scope: !313, inlinedAt: !311)
!313 = !DILexicalBlockFile(scope: !108, file: !3, discriminator: 1)
!314 = !DILocation(line: 422, column: 19, scope: !303, inlinedAt: !308)
!315 = !DILocation(line: 423, column: 36, scope: !303, inlinedAt: !308)
!316 = !DILocation(line: 423, column: 26, scope: !303, inlinedAt: !308)
!317 = !DILocation(line: 423, column: 5, scope: !303, inlinedAt: !308)
!318 = !DILocation(line: 424, column: 17, scope: !303, inlinedAt: !308)
!319 = !DILocation(line: 424, column: 44, scope: !303, inlinedAt: !308)
!320 = !{!249, !128, i64 28}
!321 = !DILocation(line: 424, column: 57, scope: !303, inlinedAt: !308)
!322 = !DILocation(line: 424, column: 9, scope: !303, inlinedAt: !308)
!323 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !324)
!324 = distinct !DILocation(line: 426, column: 5, scope: !303, inlinedAt: !308)
!325 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !324)
!326 = !DILocation(line: 540, column: 30, scope: !327, inlinedAt: !324)
!327 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 2)
!328 = !DILocation(line: 428, column: 21, scope: !329, inlinedAt: !308)
!329 = distinct !DILexicalBlock(scope: !303, file: !3, line: 428, column: 9)
!330 = !{!140, !127, i64 12}
!331 = !DILocation(line: 428, column: 9, scope: !329, inlinedAt: !308)
!332 = !DILocation(line: 428, column: 9, scope: !303, inlinedAt: !308)
!333 = !DILocation(line: 429, column: 69, scope: !334, inlinedAt: !308)
!334 = distinct !DILexicalBlock(scope: !335, file: !3, line: 429, column: 13)
!335 = distinct !DILexicalBlock(scope: !329, file: !3, line: 428, column: 33)
!336 = !DILocation(line: 429, column: 13, scope: !334, inlinedAt: !308)
!337 = !DILocation(line: 429, column: 13, scope: !335, inlinedAt: !308)
!338 = !DILocation(line: 434, column: 5, scope: !303, inlinedAt: !308)
!339 = !DILocation(line: 436, column: 35, scope: !340, inlinedAt: !308)
!340 = distinct !DILexicalBlock(scope: !303, file: !3, line: 434, column: 20)
!341 = !DILocation(line: 436, column: 54, scope: !340, inlinedAt: !308)
!342 = !DILocalVariable(name: "usb_device", arg: 1, scope: !343, file: !3, line: 131, type: !50)
!343 = distinct !DISubprogram(name: "setup_device", scope: !3, file: !3, line: 131, type: !86, isLocal: true, isDefinition: true, scopeLine: 132, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !344)
!344 = !{!342, !345, !346, !347, !348, !349}
!345 = !DILocalVariable(name: "req", arg: 2, scope: !343, file: !3, line: 131, type: !51)
!346 = !DILocalVariable(name: "usb_id", scope: !343, file: !3, line: 133, type: !92)
!347 = !DILocalVariable(name: "tx_len", scope: !343, file: !3, line: 134, type: !48)
!348 = !DILocalVariable(name: "tx_payload", scope: !343, file: !3, line: 135, type: !42)
!349 = !DILocalVariable(name: "bDevConfig", scope: !350, file: !3, line: 243, type: !26)
!350 = distinct !DILexicalBlock(scope: !351, file: !3, line: 242, column: 16)
!351 = distinct !DILexicalBlock(scope: !352, file: !3, line: 240, column: 20)
!352 = distinct !DILexicalBlock(scope: !353, file: !3, line: 238, column: 13)
!353 = distinct !DILexicalBlock(scope: !343, file: !3, line: 137, column: 28)
!354 = !DILocation(line: 131, column: 47, scope: !343, inlinedAt: !355)
!355 = distinct !DILocation(line: 436, column: 9, scope: !340, inlinedAt: !308)
!356 = !DILocation(line: 131, column: 83, scope: !343, inlinedAt: !355)
!357 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !358)
!358 = distinct !DILocation(line: 133, column: 28, scope: !343, inlinedAt: !355)
!359 = !DILocation(line: 20, column: 33, scope: !360, inlinedAt: !358)
!360 = !DILexicalBlockFile(scope: !108, file: !3, discriminator: 2)
!361 = !DILocation(line: 133, column: 19, scope: !343, inlinedAt: !355)
!362 = !DILocation(line: 134, column: 9, scope: !343, inlinedAt: !355)
!363 = !DILocation(line: 29, column: 55, scope: !132, inlinedAt: !364)
!364 = distinct !DILocation(line: 135, column: 22, scope: !343, inlinedAt: !355)
!365 = !DILocation(line: 31, column: 24, scope: !132, inlinedAt: !364)
!366 = !DILocation(line: 135, column: 9, scope: !343, inlinedAt: !355)
!367 = !DILocation(line: 137, column: 18, scope: !343, inlinedAt: !355)
!368 = !DILocation(line: 137, column: 13, scope: !343, inlinedAt: !355)
!369 = !DILocation(line: 137, column: 5, scope: !343, inlinedAt: !355)
!370 = !DILocation(line: 139, column: 25, scope: !371, inlinedAt: !355)
!371 = distinct !DILexicalBlock(scope: !353, file: !3, line: 139, column: 13)
!372 = !{!140, !128, i64 20}
!373 = !DILocation(line: 139, column: 39, scope: !371, inlinedAt: !355)
!374 = !DILocation(line: 139, column: 13, scope: !353, inlinedAt: !355)
!375 = !DILocation(line: 142, column: 17, scope: !376, inlinedAt: !355)
!376 = distinct !DILexicalBlock(scope: !377, file: !3, line: 142, column: 17)
!377 = distinct !DILexicalBlock(scope: !371, file: !3, line: 141, column: 16)
!378 = !DILocation(line: 142, column: 37, scope: !376, inlinedAt: !355)
!379 = !DILocation(line: 142, column: 17, scope: !377, inlinedAt: !355)
!380 = !DILocation(line: 144, column: 29, scope: !381, inlinedAt: !355)
!381 = !DILexicalBlockFile(scope: !382, file: !3, discriminator: 1)
!382 = distinct !DILexicalBlock(scope: !376, file: !3, line: 144, column: 24)
!383 = !DILocation(line: 144, column: 24, scope: !381, inlinedAt: !355)
!384 = !DILocation(line: 144, column: 36, scope: !381, inlinedAt: !355)
!385 = !DILocation(line: 144, column: 44, scope: !381, inlinedAt: !355)
!386 = !DILocation(line: 144, column: 39, scope: !381, inlinedAt: !355)
!387 = !DILocation(line: 144, column: 24, scope: !388, inlinedAt: !355)
!388 = !DILexicalBlockFile(scope: !376, file: !3, discriminator: 1)
!389 = !DILocation(line: 145, column: 29, scope: !390, inlinedAt: !355)
!390 = distinct !DILexicalBlock(scope: !382, file: !3, line: 144, column: 53)
!391 = !DILocation(line: 145, column: 35, scope: !390, inlinedAt: !355)
!392 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !393)
!393 = distinct !DILocation(line: 146, column: 17, scope: !390, inlinedAt: !355)
!394 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !393)
!395 = !DILocation(line: 540, column: 30, scope: !396, inlinedAt: !393)
!396 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 3)
!397 = !DILocation(line: 463, column: 9, scope: !303, inlinedAt: !308)
!398 = !DILocation(line: 148, column: 29, scope: !399, inlinedAt: !355)
!399 = distinct !DILexicalBlock(scope: !382, file: !3, line: 147, column: 20)
!400 = !DILocation(line: 148, column: 35, scope: !399, inlinedAt: !355)
!401 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !402)
!402 = distinct !DILocation(line: 149, column: 17, scope: !399, inlinedAt: !355)
!403 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !402)
!404 = !DILocation(line: 540, column: 30, scope: !405, inlinedAt: !402)
!405 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 4)
!406 = !DILocation(line: 150, column: 42, scope: !399, inlinedAt: !355)
!407 = !DILocation(line: 157, column: 13, scope: !408, inlinedAt: !355)
!408 = distinct !DILexicalBlock(scope: !353, file: !3, line: 157, column: 13)
!409 = !DILocation(line: 157, column: 33, scope: !408, inlinedAt: !355)
!410 = !DILocation(line: 157, column: 13, scope: !353, inlinedAt: !355)
!411 = !DILocation(line: 158, column: 29, scope: !412, inlinedAt: !355)
!412 = distinct !DILexicalBlock(scope: !413, file: !3, line: 158, column: 17)
!413 = distinct !DILexicalBlock(scope: !408, file: !3, line: 157, column: 39)
!414 = !DILocation(line: 158, column: 17, scope: !413, inlinedAt: !355)
!415 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !416)
!416 = distinct !DILocation(line: 161, column: 17, scope: !417, inlinedAt: !355)
!417 = distinct !DILexicalBlock(scope: !418, file: !3, line: 160, column: 66)
!418 = distinct !DILexicalBlock(scope: !412, file: !3, line: 160, column: 24)
!419 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !416)
!420 = !DILocation(line: 540, column: 30, scope: !421, inlinedAt: !416)
!421 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 5)
!422 = !DILocation(line: 162, column: 42, scope: !417, inlinedAt: !355)
!423 = !DILocation(line: 163, column: 13, scope: !417, inlinedAt: !355)
!424 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !425)
!425 = distinct !DILocation(line: 164, column: 17, scope: !426, inlinedAt: !355)
!426 = distinct !DILexicalBlock(scope: !427, file: !3, line: 163, column: 69)
!427 = distinct !DILexicalBlock(scope: !418, file: !3, line: 163, column: 24)
!428 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !425)
!429 = !DILocation(line: 540, column: 30, scope: !430, inlinedAt: !425)
!430 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 6)
!431 = !DILocation(line: 165, column: 42, scope: !426, inlinedAt: !355)
!432 = !DILocation(line: 166, column: 13, scope: !426, inlinedAt: !355)
!433 = !DILocation(line: 167, column: 32, scope: !434, inlinedAt: !355)
!434 = !DILexicalBlockFile(scope: !435, file: !3, discriminator: 1)
!435 = distinct !DILexicalBlock(scope: !408, file: !3, line: 167, column: 20)
!436 = !DILocation(line: 167, column: 20, scope: !437, inlinedAt: !355)
!437 = !DILexicalBlockFile(scope: !408, file: !3, discriminator: 1)
!438 = !DILocation(line: 168, column: 24, scope: !439, inlinedAt: !355)
!439 = distinct !DILexicalBlock(scope: !440, file: !3, line: 168, column: 17)
!440 = distinct !DILexicalBlock(scope: !435, file: !3, line: 167, column: 57)
!441 = !DILocation(line: 168, column: 17, scope: !440, inlinedAt: !355)
!442 = !DILocation(line: 80, column: 44, scope: !85, inlinedAt: !443)
!443 = distinct !DILocation(line: 171, column: 17, scope: !444, inlinedAt: !355)
!444 = distinct !DILexicalBlock(scope: !439, file: !3, line: 170, column: 20)
!445 = !DILocation(line: 80, column: 80, scope: !85, inlinedAt: !443)
!446 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !447)
!447 = distinct !DILocation(line: 92, column: 28, scope: !85, inlinedAt: !443)
!448 = !DILocation(line: 92, column: 19, scope: !85, inlinedAt: !443)
!449 = !DILocation(line: 94, column: 5, scope: !450, inlinedAt: !443)
!450 = distinct !DILexicalBlock(scope: !85, file: !3, line: 94, column: 5)
!451 = !DILocation(line: 94, column: 5, scope: !85, inlinedAt: !443)
!452 = !DILocation(line: 94, column: 5, scope: !453, inlinedAt: !443)
!453 = !DILexicalBlockFile(scope: !450, file: !3, discriminator: 1)
!454 = !DILocation(line: 95, column: 9, scope: !455, inlinedAt: !443)
!455 = distinct !DILexicalBlock(scope: !85, file: !3, line: 95, column: 9)
!456 = !DILocation(line: 95, column: 29, scope: !455, inlinedAt: !443)
!457 = !DILocation(line: 95, column: 9, scope: !85, inlinedAt: !443)
!458 = !DILocation(line: 98, column: 5, scope: !85, inlinedAt: !443)
!459 = !DILocation(line: 99, column: 5, scope: !85, inlinedAt: !443)
!460 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !461)
!461 = distinct !DILocation(line: 100, column: 5, scope: !85, inlinedAt: !443)
!462 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !461)
!463 = !DILocation(line: 540, column: 30, scope: !464, inlinedAt: !461)
!464 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 7)
!465 = !DILocation(line: 102, column: 13, scope: !85, inlinedAt: !443)
!466 = !DILocation(line: 102, column: 5, scope: !85, inlinedAt: !443)
!467 = !DILocation(line: 104, column: 21, scope: !468, inlinedAt: !443)
!468 = distinct !DILexicalBlock(scope: !85, file: !3, line: 102, column: 34)
!469 = !DILocation(line: 105, column: 9, scope: !468, inlinedAt: !443)
!470 = !DILocation(line: 107, column: 21, scope: !468, inlinedAt: !443)
!471 = !DILocation(line: 108, column: 9, scope: !468, inlinedAt: !443)
!472 = !DILocation(line: 110, column: 21, scope: !468, inlinedAt: !443)
!473 = !DILocation(line: 111, column: 9, scope: !468, inlinedAt: !443)
!474 = !DILocation(line: 113, column: 9, scope: !468, inlinedAt: !443)
!475 = !DILocation(line: 114, column: 9, scope: !468, inlinedAt: !443)
!476 = !DILocation(line: 116, column: 21, scope: !468, inlinedAt: !443)
!477 = !DILocation(line: 121, column: 13, scope: !478, inlinedAt: !443)
!478 = distinct !DILexicalBlock(scope: !479, file: !3, line: 120, column: 16)
!479 = distinct !DILexicalBlock(scope: !468, file: !3, line: 118, column: 13)
!480 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !481)
!481 = distinct !DILocation(line: 123, column: 9, scope: !468, inlinedAt: !443)
!482 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !481)
!483 = !DILocation(line: 540, column: 30, scope: !484, inlinedAt: !481)
!484 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 8)
!485 = !DILocation(line: 478, column: 9, scope: !303, inlinedAt: !308)
!486 = !DILocation(line: 176, column: 13, scope: !487, inlinedAt: !355)
!487 = distinct !DILexicalBlock(scope: !353, file: !3, line: 176, column: 13)
!488 = !DILocation(line: 176, column: 13, scope: !353, inlinedAt: !355)
!489 = !DILocation(line: 177, column: 29, scope: !490, inlinedAt: !355)
!490 = distinct !DILexicalBlock(scope: !491, file: !3, line: 177, column: 17)
!491 = distinct !DILexicalBlock(scope: !487, file: !3, line: 176, column: 39)
!492 = !DILocation(line: 177, column: 17, scope: !491, inlinedAt: !355)
!493 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !494)
!494 = distinct !DILocation(line: 180, column: 17, scope: !495, inlinedAt: !355)
!495 = distinct !DILexicalBlock(scope: !496, file: !3, line: 179, column: 66)
!496 = distinct !DILexicalBlock(scope: !490, file: !3, line: 179, column: 24)
!497 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !494)
!498 = !DILocation(line: 540, column: 30, scope: !499, inlinedAt: !494)
!499 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 9)
!500 = !DILocation(line: 181, column: 42, scope: !495, inlinedAt: !355)
!501 = !DILocation(line: 182, column: 13, scope: !495, inlinedAt: !355)
!502 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !503)
!503 = distinct !DILocation(line: 183, column: 17, scope: !504, inlinedAt: !355)
!504 = distinct !DILexicalBlock(scope: !505, file: !3, line: 182, column: 69)
!505 = distinct !DILexicalBlock(scope: !496, file: !3, line: 182, column: 24)
!506 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !503)
!507 = !DILocation(line: 540, column: 30, scope: !508, inlinedAt: !503)
!508 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 10)
!509 = !DILocation(line: 184, column: 42, scope: !504, inlinedAt: !355)
!510 = !DILocation(line: 185, column: 13, scope: !504, inlinedAt: !355)
!511 = !DILocation(line: 187, column: 29, scope: !512, inlinedAt: !355)
!512 = distinct !DILexicalBlock(scope: !513, file: !3, line: 187, column: 17)
!513 = distinct !DILexicalBlock(scope: !514, file: !3, line: 186, column: 46)
!514 = distinct !DILexicalBlock(scope: !487, file: !3, line: 186, column: 20)
!515 = !DILocation(line: 187, column: 17, scope: !513, inlinedAt: !355)
!516 = !DILocation(line: 198, column: 17, scope: !517, inlinedAt: !355)
!517 = distinct !DILexicalBlock(scope: !353, file: !3, line: 197, column: 34)
!518 = !DILocation(line: 198, column: 9, scope: !517, inlinedAt: !355)
!519 = !DILocation(line: 200, column: 13, scope: !520, inlinedAt: !355)
!520 = distinct !DILexicalBlock(scope: !517, file: !3, line: 198, column: 38)
!521 = !DILocation(line: 231, column: 13, scope: !517, inlinedAt: !355)
!522 = !DILocation(line: 205, column: 49, scope: !520, inlinedAt: !355)
!523 = !DILocation(line: 205, column: 37, scope: !520, inlinedAt: !355)
!524 = !DILocation(line: 204, column: 22, scope: !520, inlinedAt: !355)
!525 = !DILocation(line: 208, column: 13, scope: !520, inlinedAt: !355)
!526 = !DILocation(line: 210, column: 17, scope: !520, inlinedAt: !355)
!527 = !DILocation(line: 211, column: 17, scope: !528, inlinedAt: !355)
!528 = distinct !DILexicalBlock(scope: !529, file: !3, line: 210, column: 43)
!529 = distinct !DILexicalBlock(scope: !520, file: !3, line: 210, column: 17)
!530 = !DILocation(line: 212, column: 13, scope: !528, inlinedAt: !355)
!531 = !DILocation(line: 213, column: 17, scope: !532, inlinedAt: !355)
!532 = distinct !DILexicalBlock(scope: !533, file: !3, line: 212, column: 50)
!533 = distinct !DILexicalBlock(scope: !529, file: !3, line: 212, column: 24)
!534 = !DILocation(line: 214, column: 13, scope: !532, inlinedAt: !355)
!535 = !DILocation(line: 215, column: 17, scope: !536, inlinedAt: !355)
!536 = distinct !DILexicalBlock(scope: !537, file: !3, line: 214, column: 50)
!537 = distinct !DILexicalBlock(scope: !533, file: !3, line: 214, column: 24)
!538 = !DILocation(line: 216, column: 13, scope: !536, inlinedAt: !355)
!539 = !DILocation(line: 217, column: 17, scope: !540, inlinedAt: !355)
!540 = distinct !DILexicalBlock(scope: !541, file: !3, line: 216, column: 50)
!541 = distinct !DILexicalBlock(scope: !537, file: !3, line: 216, column: 24)
!542 = !DILocation(line: 218, column: 13, scope: !540, inlinedAt: !355)
!543 = !DILocation(line: 219, column: 17, scope: !544, inlinedAt: !355)
!544 = distinct !DILexicalBlock(scope: !545, file: !3, line: 218, column: 53)
!545 = distinct !DILexicalBlock(scope: !541, file: !3, line: 218, column: 24)
!546 = !DILocation(line: 220, column: 13, scope: !544, inlinedAt: !355)
!547 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !548)
!548 = distinct !DILocation(line: 221, column: 17, scope: !549, inlinedAt: !355)
!549 = distinct !DILexicalBlock(scope: !545, file: !3, line: 220, column: 20)
!550 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !548)
!551 = !DILocation(line: 540, column: 30, scope: !552, inlinedAt: !548)
!552 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 11)
!553 = !DILocation(line: 222, column: 31, scope: !549, inlinedAt: !355)
!554 = !DILocation(line: 225, column: 22, scope: !520, inlinedAt: !355)
!555 = !DILocation(line: 226, column: 13, scope: !520, inlinedAt: !355)
!556 = !DILocation(line: 228, column: 13, scope: !557, inlinedAt: !355)
!557 = distinct !DILexicalBlock(scope: !520, file: !3, line: 228, column: 13)
!558 = !DILocation(line: 228, column: 13, scope: !520, inlinedAt: !355)
!559 = !DILocation(line: 228, column: 13, scope: !560, inlinedAt: !355)
!560 = !DILexicalBlockFile(scope: !557, file: !3, discriminator: 1)
!561 = !DILocation(line: 231, column: 13, scope: !562, inlinedAt: !355)
!562 = !DILexicalBlockFile(scope: !563, file: !3, discriminator: 1)
!563 = distinct !DILexicalBlock(scope: !517, file: !3, line: 231, column: 13)
!564 = !DILocation(line: 231, column: 13, scope: !565, inlinedAt: !355)
!565 = !DILexicalBlockFile(scope: !517, file: !3, discriminator: 1)
!566 = !DILocation(line: 232, column: 13, scope: !567, inlinedAt: !355)
!567 = distinct !DILexicalBlock(scope: !563, file: !3, line: 231, column: 21)
!568 = !DILocation(line: 233, column: 9, scope: !567, inlinedAt: !355)
!569 = !DILocation(line: 238, column: 19, scope: !352, inlinedAt: !355)
!570 = !DILocation(line: 238, column: 13, scope: !352, inlinedAt: !355)
!571 = !DILocation(line: 238, column: 27, scope: !352, inlinedAt: !355)
!572 = !DILocation(line: 238, column: 36, scope: !573, inlinedAt: !355)
!573 = !DILexicalBlockFile(scope: !352, file: !3, discriminator: 1)
!574 = !DILocation(line: 238, column: 30, scope: !573, inlinedAt: !355)
!575 = !DILocation(line: 238, column: 13, scope: !576, inlinedAt: !355)
!576 = !DILexicalBlockFile(scope: !353, file: !3, discriminator: 1)
!577 = !DILocation(line: 240, column: 20, scope: !578, inlinedAt: !355)
!578 = !DILexicalBlockFile(scope: !351, file: !3, discriminator: 1)
!579 = !DILocation(line: 240, column: 50, scope: !578, inlinedAt: !355)
!580 = !DILocation(line: 240, column: 64, scope: !578, inlinedAt: !355)
!581 = !DILocation(line: 240, column: 20, scope: !573, inlinedAt: !355)
!582 = !DILocation(line: 243, column: 29, scope: !350, inlinedAt: !355)
!583 = !DILocation(line: 244, column: 17, scope: !350, inlinedAt: !355)
!584 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !585)
!585 = distinct !DILocation(line: 245, column: 17, scope: !586, inlinedAt: !355)
!586 = distinct !DILexicalBlock(scope: !587, file: !3, line: 244, column: 34)
!587 = distinct !DILexicalBlock(scope: !350, file: !3, line: 244, column: 17)
!588 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !585)
!589 = !DILocation(line: 540, column: 30, scope: !590, inlinedAt: !585)
!590 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 12)
!591 = !DILocation(line: 246, column: 61, scope: !586, inlinedAt: !355)
!592 = !DILocation(line: 247, column: 17, scope: !586, inlinedAt: !355)
!593 = !DILocation(line: 248, column: 17, scope: !586, inlinedAt: !355)
!594 = !DILocation(line: 249, column: 17, scope: !586, inlinedAt: !355)
!595 = !DILocation(line: 250, column: 17, scope: !586, inlinedAt: !355)
!596 = !DILocation(line: 251, column: 13, scope: !586, inlinedAt: !355)
!597 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !598)
!598 = distinct !DILocation(line: 252, column: 17, scope: !599, inlinedAt: !355)
!599 = distinct !DILexicalBlock(scope: !600, file: !3, line: 251, column: 41)
!600 = distinct !DILexicalBlock(scope: !587, file: !3, line: 251, column: 24)
!601 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !598)
!602 = !DILocation(line: 540, column: 30, scope: !603, inlinedAt: !598)
!603 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 13)
!604 = !DILocation(line: 253, column: 61, scope: !599, inlinedAt: !355)
!605 = !DILocation(line: 254, column: 13, scope: !599, inlinedAt: !355)
!606 = !DILocation(line: 261, column: 25, scope: !607, inlinedAt: !355)
!607 = distinct !DILexicalBlock(scope: !353, file: !3, line: 261, column: 13)
!608 = !DILocation(line: 261, column: 39, scope: !607, inlinedAt: !355)
!609 = !DILocation(line: 261, column: 13, scope: !353, inlinedAt: !355)
!610 = !DILocation(line: 265, column: 56, scope: !611, inlinedAt: !355)
!611 = distinct !DILexicalBlock(scope: !607, file: !3, line: 263, column: 16)
!612 = !DILocation(line: 265, column: 29, scope: !611, inlinedAt: !355)
!613 = !DILocation(line: 265, column: 27, scope: !611, inlinedAt: !355)
!614 = !DILocation(line: 266, column: 13, scope: !611, inlinedAt: !355)
!615 = !DILocation(line: 270, column: 25, scope: !616, inlinedAt: !355)
!616 = distinct !DILexicalBlock(scope: !353, file: !3, line: 270, column: 13)
!617 = !DILocation(line: 270, column: 39, scope: !616, inlinedAt: !355)
!618 = !DILocation(line: 270, column: 13, scope: !353, inlinedAt: !355)
!619 = !DILocation(line: 273, column: 27, scope: !620, inlinedAt: !355)
!620 = distinct !DILexicalBlock(scope: !616, file: !3, line: 272, column: 16)
!621 = !DILocation(line: 274, column: 13, scope: !620, inlinedAt: !355)
!622 = !DILocation(line: 274, column: 27, scope: !620, inlinedAt: !355)
!623 = !DILocation(line: 275, column: 29, scope: !624, inlinedAt: !355)
!624 = distinct !DILexicalBlock(scope: !620, file: !3, line: 275, column: 17)
!625 = !DILocation(line: 275, column: 17, scope: !624, inlinedAt: !355)
!626 = !DILocation(line: 275, column: 17, scope: !620, inlinedAt: !355)
!627 = !DILocation(line: 276, column: 31, scope: !628, inlinedAt: !355)
!628 = distinct !DILexicalBlock(scope: !624, file: !3, line: 275, column: 43)
!629 = !DILocation(line: 277, column: 13, scope: !628, inlinedAt: !355)
!630 = !DILocation(line: 279, column: 13, scope: !620, inlinedAt: !355)
!631 = !DILocation(line: 283, column: 9, scope: !632, inlinedAt: !355)
!632 = distinct !DILexicalBlock(scope: !353, file: !3, line: 283, column: 9)
!633 = !DILocation(line: 283, column: 9, scope: !353, inlinedAt: !355)
!634 = !DILocation(line: 283, column: 9, scope: !635, inlinedAt: !355)
!635 = !DILexicalBlockFile(scope: !632, file: !3, discriminator: 1)
!636 = !DILocation(line: 439, column: 38, scope: !340, inlinedAt: !308)
!637 = !DILocation(line: 439, column: 57, scope: !340, inlinedAt: !308)
!638 = !DILocalVariable(name: "usb_device", arg: 1, scope: !639, file: !3, line: 287, type: !50)
!639 = distinct !DISubprogram(name: "setup_interface", scope: !3, file: !3, line: 287, type: !86, isLocal: true, isDefinition: true, scopeLine: 288, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !640)
!640 = !{!638, !641, !642, !643}
!641 = !DILocalVariable(name: "req", arg: 2, scope: !639, file: !3, line: 287, type: !51)
!642 = !DILocalVariable(name: "usb_id", scope: !639, file: !3, line: 289, type: !92)
!643 = !DILocalVariable(name: "itf_num", scope: !639, file: !3, line: 290, type: !48)
!644 = !DILocation(line: 287, column: 50, scope: !639, inlinedAt: !645)
!645 = distinct !DILocation(line: 439, column: 9, scope: !340, inlinedAt: !308)
!646 = !DILocation(line: 287, column: 86, scope: !639, inlinedAt: !645)
!647 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !648)
!648 = distinct !DILocation(line: 289, column: 28, scope: !639, inlinedAt: !645)
!649 = !DILocation(line: 290, column: 19, scope: !639, inlinedAt: !645)
!650 = !DILocation(line: 290, column: 9, scope: !639, inlinedAt: !645)
!651 = !DILocation(line: 292, column: 18, scope: !652, inlinedAt: !645)
!652 = distinct !DILexicalBlock(scope: !639, file: !3, line: 292, column: 9)
!653 = !DILocation(line: 292, column: 39, scope: !652, inlinedAt: !645)
!654 = !DILocation(line: 20, column: 33, scope: !655, inlinedAt: !648)
!655 = !DILexicalBlockFile(scope: !108, file: !3, discriminator: 3)
!656 = !DILocation(line: 293, column: 9, scope: !652, inlinedAt: !645)
!657 = !DILocation(line: 292, column: 9, scope: !658, inlinedAt: !645)
!658 = !DILexicalBlockFile(scope: !639, file: !3, discriminator: 1)
!659 = !DILocation(line: 294, column: 14, scope: !660, inlinedAt: !645)
!660 = distinct !DILexicalBlock(scope: !661, file: !3, line: 294, column: 13)
!661 = distinct !DILexicalBlock(scope: !652, file: !3, line: 293, column: 55)
!662 = !DILocation(line: 294, column: 76, scope: !660, inlinedAt: !645)
!663 = !DILocation(line: 295, column: 13, scope: !664, inlinedAt: !645)
!664 = distinct !DILexicalBlock(scope: !665, file: !3, line: 295, column: 13)
!665 = distinct !DILexicalBlock(scope: !660, file: !3, line: 294, column: 83)
!666 = !DILocation(line: 294, column: 13, scope: !661, inlinedAt: !645)
!667 = !DILocation(line: 295, column: 13, scope: !668, inlinedAt: !645)
!668 = !DILexicalBlockFile(scope: !664, file: !3, discriminator: 1)
!669 = !DILocation(line: 442, column: 37, scope: !340, inlinedAt: !308)
!670 = !DILocation(line: 442, column: 56, scope: !340, inlinedAt: !308)
!671 = !DILocalVariable(name: "usb_device", arg: 1, scope: !672, file: !3, line: 314, type: !50)
!672 = distinct !DISubprogram(name: "setup_endpoint", scope: !3, file: !3, line: 314, type: !86, isLocal: true, isDefinition: true, scopeLine: 315, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !673)
!673 = !{!671, !674, !675, !676, !677, !678}
!674 = !DILocalVariable(name: "req", arg: 2, scope: !672, file: !3, line: 314, type: !51)
!675 = !DILocalVariable(name: "usb_id", scope: !672, file: !3, line: 316, type: !92)
!676 = !DILocalVariable(name: "tx_len", scope: !672, file: !3, line: 317, type: !48)
!677 = !DILocalVariable(name: "tx_payload", scope: !672, file: !3, line: 318, type: !42)
!678 = !DILocalVariable(name: "ep", scope: !672, file: !3, line: 320, type: !48)
!679 = !DILocation(line: 314, column: 49, scope: !672, inlinedAt: !680)
!680 = distinct !DILocation(line: 442, column: 9, scope: !340, inlinedAt: !308)
!681 = !DILocation(line: 314, column: 85, scope: !672, inlinedAt: !680)
!682 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !683)
!683 = distinct !DILocation(line: 316, column: 28, scope: !672, inlinedAt: !680)
!684 = !DILocation(line: 20, column: 33, scope: !685, inlinedAt: !683)
!685 = !DILexicalBlockFile(scope: !108, file: !3, discriminator: 4)
!686 = !DILocation(line: 316, column: 19, scope: !672, inlinedAt: !680)
!687 = !DILocation(line: 317, column: 9, scope: !672, inlinedAt: !680)
!688 = !DILocation(line: 29, column: 55, scope: !132, inlinedAt: !689)
!689 = distinct !DILocation(line: 318, column: 22, scope: !672, inlinedAt: !680)
!690 = !DILocation(line: 31, column: 24, scope: !691, inlinedAt: !689)
!691 = !DILexicalBlockFile(scope: !132, file: !3, discriminator: 1)
!692 = !DILocation(line: 318, column: 9, scope: !672, inlinedAt: !680)
!693 = !DILocation(line: 320, column: 14, scope: !672, inlinedAt: !680)
!694 = !DILocation(line: 320, column: 34, scope: !672, inlinedAt: !680)
!695 = !DILocation(line: 320, column: 9, scope: !672, inlinedAt: !680)
!696 = !DILocation(line: 321, column: 18, scope: !672, inlinedAt: !680)
!697 = !DILocation(line: 321, column: 5, scope: !672, inlinedAt: !680)
!698 = !DILocation(line: 323, column: 25, scope: !699, inlinedAt: !680)
!699 = distinct !DILexicalBlock(scope: !700, file: !3, line: 323, column: 13)
!700 = distinct !DILexicalBlock(scope: !672, file: !3, line: 321, column: 28)
!701 = !DILocation(line: 323, column: 13, scope: !700, inlinedAt: !680)
!702 = !DILocation(line: 326, column: 20, scope: !703, inlinedAt: !680)
!703 = distinct !DILexicalBlock(scope: !704, file: !3, line: 326, column: 17)
!704 = distinct !DILexicalBlock(scope: !705, file: !3, line: 325, column: 62)
!705 = distinct !DILexicalBlock(scope: !699, file: !3, line: 325, column: 20)
!706 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !707)
!707 = distinct !DILocation(line: 327, column: 17, scope: !708, inlinedAt: !680)
!708 = distinct !DILexicalBlock(scope: !703, file: !3, line: 326, column: 26)
!709 = !DILocation(line: 326, column: 17, scope: !704, inlinedAt: !680)
!710 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !707)
!711 = !DILocation(line: 540, column: 30, scope: !712, inlinedAt: !707)
!712 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 14)
!713 = !DILocation(line: 328, column: 13, scope: !708, inlinedAt: !680)
!714 = !DILocation(line: 332, column: 17, scope: !715, inlinedAt: !680)
!715 = distinct !DILexicalBlock(scope: !716, file: !3, line: 332, column: 17)
!716 = distinct !DILexicalBlock(scope: !717, file: !3, line: 331, column: 65)
!717 = distinct !DILexicalBlock(scope: !705, file: !3, line: 331, column: 20)
!718 = !DILocation(line: 332, column: 37, scope: !715, inlinedAt: !680)
!719 = !DILocation(line: 332, column: 17, scope: !716, inlinedAt: !680)
!720 = !DILocation(line: 333, column: 33, scope: !721, inlinedAt: !680)
!721 = distinct !DILexicalBlock(scope: !722, file: !3, line: 333, column: 21)
!722 = distinct !DILexicalBlock(scope: !715, file: !3, line: 332, column: 43)
!723 = !DILocation(line: 333, column: 21, scope: !722, inlinedAt: !680)
!724 = !DILocation(line: 334, column: 21, scope: !725, inlinedAt: !680)
!725 = distinct !DILexicalBlock(scope: !721, file: !3, line: 333, column: 47)
!726 = !DILocation(line: 336, column: 17, scope: !725, inlinedAt: !680)
!727 = !DILocation(line: 337, column: 21, scope: !728, inlinedAt: !680)
!728 = distinct !DILexicalBlock(scope: !721, file: !3, line: 336, column: 24)
!729 = !{!141, !141, i64 0}
!730 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !731)
!731 = distinct !DILocation(line: 340, column: 17, scope: !722, inlinedAt: !680)
!732 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !731)
!733 = !DILocation(line: 540, column: 30, scope: !734, inlinedAt: !731)
!734 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 15)
!735 = !DILocation(line: 341, column: 13, scope: !722, inlinedAt: !680)
!736 = !DILocation(line: 345, column: 25, scope: !737, inlinedAt: !680)
!737 = distinct !DILexicalBlock(scope: !700, file: !3, line: 345, column: 13)
!738 = !DILocation(line: 345, column: 13, scope: !700, inlinedAt: !680)
!739 = !DILocation(line: 348, column: 20, scope: !740, inlinedAt: !680)
!740 = distinct !DILexicalBlock(scope: !741, file: !3, line: 348, column: 17)
!741 = distinct !DILexicalBlock(scope: !742, file: !3, line: 347, column: 62)
!742 = distinct !DILexicalBlock(scope: !737, file: !3, line: 347, column: 20)
!743 = !DILocation(line: 348, column: 17, scope: !741, inlinedAt: !680)
!744 = !DILocation(line: 349, column: 31, scope: !745, inlinedAt: !680)
!745 = distinct !DILexicalBlock(scope: !740, file: !3, line: 348, column: 26)
!746 = !DILocation(line: 350, column: 17, scope: !745, inlinedAt: !680)
!747 = !DILocation(line: 350, column: 31, scope: !745, inlinedAt: !680)
!748 = !DILocation(line: 351, column: 26, scope: !749, inlinedAt: !680)
!749 = distinct !DILexicalBlock(scope: !745, file: !3, line: 351, column: 21)
!750 = !DILocation(line: 351, column: 33, scope: !749, inlinedAt: !680)
!751 = !DILocation(line: 351, column: 21, scope: !745, inlinedAt: !680)
!752 = !DILocation(line: 352, column: 25, scope: !753, inlinedAt: !680)
!753 = distinct !DILexicalBlock(scope: !754, file: !3, line: 352, column: 25)
!754 = distinct !DILexicalBlock(scope: !749, file: !3, line: 351, column: 47)
!755 = !DILocation(line: 352, column: 35, scope: !753, inlinedAt: !680)
!756 = !DILocation(line: 352, column: 33, scope: !753, inlinedAt: !680)
!757 = !DILocation(line: 352, column: 25, scope: !754, inlinedAt: !680)
!758 = !DILocation(line: 353, column: 39, scope: !759, inlinedAt: !680)
!759 = distinct !DILexicalBlock(scope: !753, file: !3, line: 352, column: 57)
!760 = !DILocation(line: 354, column: 21, scope: !759, inlinedAt: !680)
!761 = !DILocation(line: 361, column: 17, scope: !745, inlinedAt: !680)
!762 = !DILocation(line: 362, column: 13, scope: !745, inlinedAt: !680)
!763 = !DILocation(line: 366, column: 27, scope: !764, inlinedAt: !680)
!764 = distinct !DILexicalBlock(scope: !765, file: !3, line: 365, column: 65)
!765 = distinct !DILexicalBlock(scope: !742, file: !3, line: 365, column: 20)
!766 = !DILocation(line: 367, column: 13, scope: !764, inlinedAt: !680)
!767 = !DILocation(line: 367, column: 27, scope: !764, inlinedAt: !680)
!768 = !DILocation(line: 368, column: 22, scope: !769, inlinedAt: !680)
!769 = distinct !DILexicalBlock(scope: !764, file: !3, line: 368, column: 17)
!770 = !DILocation(line: 368, column: 29, scope: !769, inlinedAt: !680)
!771 = !DILocation(line: 368, column: 17, scope: !764, inlinedAt: !680)
!772 = !DILocation(line: 369, column: 21, scope: !773, inlinedAt: !680)
!773 = distinct !DILexicalBlock(scope: !769, file: !3, line: 368, column: 43)
!774 = !DILocation(line: 370, column: 35, scope: !775, inlinedAt: !680)
!775 = distinct !DILexicalBlock(scope: !776, file: !3, line: 369, column: 53)
!776 = distinct !DILexicalBlock(scope: !773, file: !3, line: 369, column: 21)
!777 = !DILocation(line: 371, column: 17, scope: !775, inlinedAt: !680)
!778 = !DILocation(line: 373, column: 21, scope: !779, inlinedAt: !680)
!779 = distinct !DILexicalBlock(scope: !769, file: !3, line: 372, column: 20)
!780 = !DILocation(line: 374, column: 35, scope: !781, inlinedAt: !680)
!781 = distinct !DILexicalBlock(scope: !782, file: !3, line: 373, column: 53)
!782 = distinct !DILexicalBlock(scope: !779, file: !3, line: 373, column: 21)
!783 = !DILocation(line: 375, column: 17, scope: !781, inlinedAt: !680)
!784 = !DILocation(line: 378, column: 13, scope: !764, inlinedAt: !680)
!785 = !DILocation(line: 379, column: 9, scope: !764, inlinedAt: !680)
!786 = !DILocation(line: 382, column: 25, scope: !787, inlinedAt: !680)
!787 = distinct !DILexicalBlock(scope: !700, file: !3, line: 382, column: 13)
!788 = !DILocation(line: 382, column: 13, scope: !700, inlinedAt: !680)
!789 = !DILocation(line: 385, column: 20, scope: !790, inlinedAt: !680)
!790 = distinct !DILexicalBlock(scope: !791, file: !3, line: 385, column: 17)
!791 = distinct !DILexicalBlock(scope: !792, file: !3, line: 384, column: 62)
!792 = distinct !DILexicalBlock(scope: !787, file: !3, line: 384, column: 20)
!793 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !794)
!794 = distinct !DILocation(line: 386, column: 17, scope: !795, inlinedAt: !680)
!795 = distinct !DILexicalBlock(scope: !790, file: !3, line: 385, column: 26)
!796 = !DILocation(line: 385, column: 17, scope: !791, inlinedAt: !680)
!797 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !794)
!798 = !DILocation(line: 540, column: 30, scope: !799, inlinedAt: !794)
!799 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 16)
!800 = !DILocation(line: 387, column: 13, scope: !795, inlinedAt: !680)
!801 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !802)
!802 = distinct !DILocation(line: 391, column: 13, scope: !803, inlinedAt: !680)
!803 = distinct !DILexicalBlock(scope: !804, file: !3, line: 390, column: 65)
!804 = distinct !DILexicalBlock(scope: !792, file: !3, line: 390, column: 20)
!805 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !802)
!806 = !DILocation(line: 540, column: 30, scope: !807, inlinedAt: !802)
!807 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 17)
!808 = !DILocation(line: 392, column: 29, scope: !809, inlinedAt: !680)
!809 = distinct !DILexicalBlock(scope: !803, file: !3, line: 392, column: 17)
!810 = !DILocation(line: 395, column: 17, scope: !811, inlinedAt: !680)
!811 = distinct !DILexicalBlock(scope: !809, file: !3, line: 394, column: 20)
!812 = !DILocation(line: 393, column: 17, scope: !813, inlinedAt: !680)
!813 = distinct !DILexicalBlock(scope: !809, file: !3, line: 392, column: 43)
!814 = !DILocation(line: 392, column: 17, scope: !803, inlinedAt: !680)
!815 = !DILocation(line: 397, column: 9, scope: !803, inlinedAt: !680)
!816 = !DILocation(line: 447, column: 9, scope: !817, inlinedAt: !308)
!817 = distinct !DILexicalBlock(scope: !340, file: !3, line: 447, column: 9)
!818 = !DILocation(line: 447, column: 9, scope: !340, inlinedAt: !308)
!819 = !DILocation(line: 447, column: 9, scope: !820, inlinedAt: !308)
!820 = !DILexicalBlockFile(scope: !817, file: !3, discriminator: 1)
!821 = !DILocation(line: 463, column: 21, scope: !822, inlinedAt: !308)
!822 = !DILexicalBlockFile(scope: !823, file: !3, discriminator: 1)
!823 = distinct !DILexicalBlock(scope: !303, file: !3, line: 463, column: 9)
!824 = !DILocation(line: 463, column: 9, scope: !825, inlinedAt: !308)
!825 = !DILexicalBlockFile(scope: !303, file: !3, discriminator: 1)
!826 = !DILocation(line: 463, column: 9, scope: !827, inlinedAt: !308)
!827 = !DILexicalBlockFile(scope: !303, file: !3, discriminator: 2)
!828 = !DILocation(line: 464, column: 9, scope: !829, inlinedAt: !308)
!829 = distinct !DILexicalBlock(scope: !823, file: !3, line: 463, column: 58)
!830 = !DILocation(line: 465, column: 5, scope: !829, inlinedAt: !308)
!831 = !DILocation(line: 467, column: 9, scope: !832, inlinedAt: !308)
!832 = distinct !DILexicalBlock(scope: !833, file: !3, line: 466, column: 65)
!833 = distinct !DILexicalBlock(scope: !823, file: !3, line: 465, column: 16)
!834 = !DILocation(line: 468, column: 5, scope: !832, inlinedAt: !308)
!835 = !DILocation(line: 540, column: 30, scope: !836, inlinedAt: !837)
!836 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 18)
!837 = distinct !DILocation(line: 140, column: 13, scope: !838, inlinedAt: !355)
!838 = distinct !DILexicalBlock(scope: !371, file: !3, line: 139, column: 58)
!839 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !840)
!840 = distinct !DILocation(line: 469, column: 9, scope: !841, inlinedAt: !308)
!841 = distinct !DILexicalBlock(scope: !842, file: !3, line: 468, column: 63)
!842 = distinct !DILexicalBlock(scope: !833, file: !3, line: 468, column: 16)
!843 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !840)
!844 = !DILocation(line: 540, column: 30, scope: !845, inlinedAt: !840)
!845 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 19)
!846 = !DILocation(line: 470, column: 9, scope: !841, inlinedAt: !308)
!847 = !DILocation(line: 471, column: 5, scope: !841, inlinedAt: !308)
!848 = !DILocation(line: 472, column: 48, scope: !849, inlinedAt: !308)
!849 = distinct !DILexicalBlock(scope: !850, file: !3, line: 471, column: 60)
!850 = distinct !DILexicalBlock(scope: !842, file: !3, line: 471, column: 16)
!851 = !DILocation(line: 472, column: 36, scope: !849, inlinedAt: !308)
!852 = !DILocation(line: 472, column: 9, scope: !849, inlinedAt: !308)
!853 = !DILocation(line: 473, column: 34, scope: !849, inlinedAt: !308)
!854 = !DILocation(line: 474, column: 5, scope: !849, inlinedAt: !308)
!855 = !DILocation(line: 478, column: 21, scope: !856, inlinedAt: !308)
!856 = !DILexicalBlockFile(scope: !857, file: !3, discriminator: 1)
!857 = distinct !DILexicalBlock(scope: !303, file: !3, line: 478, column: 9)
!858 = !DILocation(line: 478, column: 34, scope: !856, inlinedAt: !308)
!859 = !DILocation(line: 478, column: 9, scope: !825, inlinedAt: !308)
!860 = !DILocation(line: 479, column: 9, scope: !861, inlinedAt: !308)
!861 = distinct !DILexicalBlock(scope: !857, file: !3, line: 478, column: 55)
!862 = !DILocation(line: 480, column: 5, scope: !861, inlinedAt: !308)
!863 = !DILocation(line: 520, column: 9, scope: !300)
!864 = !DILocation(line: 521, column: 9, scope: !300)
!865 = !DILocation(line: 523, column: 17, scope: !866)
!866 = distinct !DILexicalBlock(scope: !300, file: !3, line: 523, column: 13)
!867 = !DILocation(line: 523, column: 13, scope: !300)
!868 = !DILocalVariable(name: "usb_device", arg: 1, scope: !869, file: !3, line: 62, type: !50)
!869 = distinct !DISubprogram(name: "ep0_stage_rx", scope: !3, file: !3, line: 62, type: !220, isLocal: true, isDefinition: true, scopeLine: 63, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !870)
!870 = !{!868, !871, !872}
!871 = !DILocalVariable(name: "usb_id", scope: !869, file: !3, line: 64, type: !92)
!872 = !DILocalVariable(name: "phase", scope: !873, file: !3, line: 66, type: !48)
!873 = distinct !DILexicalBlock(scope: !874, file: !3, line: 65, column: 33)
!874 = distinct !DILexicalBlock(scope: !869, file: !3, line: 65, column: 9)
!875 = !DILocation(line: 62, column: 47, scope: !869, inlinedAt: !876)
!876 = distinct !DILocation(line: 524, column: 13, scope: !877)
!877 = distinct !DILexicalBlock(scope: !866, file: !3, line: 523, column: 35)
!878 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !879)
!879 = distinct !DILocation(line: 64, column: 28, scope: !869, inlinedAt: !876)
!880 = !DILocation(line: 20, column: 33, scope: !881, inlinedAt: !879)
!881 = !DILexicalBlockFile(scope: !108, file: !3, discriminator: 5)
!882 = !DILocation(line: 64, column: 19, scope: !869, inlinedAt: !876)
!883 = !DILocation(line: 65, column: 21, scope: !874, inlinedAt: !876)
!884 = !{!140, !127, i64 16}
!885 = !DILocation(line: 65, column: 9, scope: !874, inlinedAt: !876)
!886 = !DILocation(line: 65, column: 9, scope: !869, inlinedAt: !876)
!887 = !DILocation(line: 540, column: 30, scope: !888, inlinedAt: !889)
!888 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 20)
!889 = distinct !DILocation(line: 72, column: 9, scope: !890, inlinedAt: !876)
!890 = distinct !DILexicalBlock(scope: !874, file: !3, line: 71, column: 12)
!891 = !DILocation(line: 74, column: 9, scope: !869, inlinedAt: !876)
!892 = !DILocation(line: 66, column: 58, scope: !873, inlinedAt: !876)
!893 = !DILocation(line: 66, column: 77, scope: !873, inlinedAt: !876)
!894 = !DILocation(line: 66, column: 21, scope: !873, inlinedAt: !876)
!895 = !DILocation(line: 66, column: 13, scope: !873, inlinedAt: !876)
!896 = !DILocation(line: 67, column: 41, scope: !873, inlinedAt: !876)
!897 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !898)
!898 = distinct !DILocation(line: 67, column: 9, scope: !873, inlinedAt: !876)
!899 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !898)
!900 = !DILocation(line: 540, column: 30, scope: !901, inlinedAt: !889)
!901 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 21)
!902 = !DILocation(line: 74, column: 9, scope: !903, inlinedAt: !876)
!903 = !DILexicalBlockFile(scope: !869, file: !3, discriminator: 1)
!904 = !DILocation(line: 75, column: 9, scope: !905, inlinedAt: !876)
!905 = distinct !DILexicalBlock(scope: !906, file: !3, line: 74, column: 58)
!906 = distinct !DILexicalBlock(scope: !869, file: !3, line: 74, column: 9)
!907 = !DILocation(line: 76, column: 5, scope: !905, inlinedAt: !876)
!908 = !DILocation(line: 77, column: 9, scope: !909, inlinedAt: !876)
!909 = distinct !DILexicalBlock(scope: !910, file: !3, line: 76, column: 63)
!910 = distinct !DILexicalBlock(scope: !906, file: !3, line: 76, column: 16)
!911 = !DILocation(line: 78, column: 5, scope: !909, inlinedAt: !876)
!912 = !DILocation(line: 528, column: 17, scope: !913)
!913 = distinct !DILexicalBlock(scope: !300, file: !3, line: 528, column: 13)
!914 = !DILocation(line: 528, column: 13, scope: !300)
!915 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !916)
!916 = distinct !DILocation(line: 529, column: 13, scope: !917)
!917 = distinct !DILexicalBlock(scope: !913, file: !3, line: 528, column: 35)
!918 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !916)
!919 = !DILocation(line: 540, column: 30, scope: !920, inlinedAt: !916)
!920 = !DILexicalBlockFile(scope: !269, file: !3, discriminator: 22)
!921 = !DILocation(line: 530, column: 13, scope: !917)
!922 = !DILocation(line: 532, column: 9, scope: !917)
!923 = !DILocation(line: 537, column: 1, scope: !924)
!924 = !DILexicalBlockFile(scope: !219, file: !3, discriminator: 2)
!925 = !DILocation(line: 538, column: 47, scope: !269)
!926 = !DILocation(line: 538, column: 62, scope: !269)
!927 = !DILocation(line: 540, column: 17, scope: !269)
!928 = !DILocation(line: 540, column: 30, scope: !269)
!929 = !DILocation(line: 541, column: 1, scope: !269)
!930 = distinct !DISubprogram(name: "ep0_stage_tx", scope: !3, file: !3, line: 37, type: !220, isLocal: true, isDefinition: true, scopeLine: 38, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !931)
!931 = !{!932, !933, !934, !935}
!932 = !DILocalVariable(name: "usb_device", arg: 1, scope: !930, file: !3, line: 37, type: !50)
!933 = !DILocalVariable(name: "usb_id", scope: !930, file: !3, line: 39, type: !92)
!934 = !DILocalVariable(name: "reg", scope: !930, file: !3, line: 40, type: !48)
!935 = !DILocalVariable(name: "len", scope: !936, file: !3, line: 49, type: !48)
!936 = distinct !DILexicalBlock(scope: !937, file: !3, line: 48, column: 12)
!937 = distinct !DILexicalBlock(scope: !938, file: !3, line: 45, column: 16)
!938 = distinct !DILexicalBlock(scope: !930, file: !3, line: 42, column: 9)
!939 = !DILocation(line: 37, column: 47, scope: !930)
!940 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !941)
!941 = distinct !DILocation(line: 39, column: 28, scope: !930)
!942 = !DILocation(line: 20, column: 33, scope: !108, inlinedAt: !941)
!943 = !DILocation(line: 39, column: 19, scope: !930)
!944 = !DILocation(line: 41, column: 11, scope: !930)
!945 = !DILocation(line: 40, column: 9, scope: !930)
!946 = !DILocation(line: 42, column: 13, scope: !938)
!947 = !DILocation(line: 42, column: 9, scope: !930)
!948 = !DILocation(line: 43, column: 9, scope: !949)
!949 = distinct !DILexicalBlock(scope: !950, file: !3, line: 43, column: 9)
!950 = distinct !DILexicalBlock(scope: !938, file: !3, line: 42, column: 31)
!951 = !DILocation(line: 43, column: 9, scope: !950)
!952 = !DILocation(line: 43, column: 9, scope: !953)
!953 = !DILexicalBlockFile(scope: !949, file: !3, discriminator: 1)
!954 = !DILocation(line: 45, column: 28, scope: !937)
!955 = !{!140, !141, i64 2}
!956 = !DILocation(line: 45, column: 40, scope: !937)
!957 = !DILocation(line: 45, column: 16, scope: !938)
!958 = !DILocation(line: 46, column: 9, scope: !959)
!959 = distinct !DILexicalBlock(scope: !937, file: !3, line: 45, column: 46)
!960 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !961)
!961 = distinct !DILocation(line: 47, column: 9, scope: !959)
!962 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !961)
!963 = !DILocation(line: 540, column: 17, scope: !269, inlinedAt: !961)
!964 = !DILocation(line: 540, column: 30, scope: !269, inlinedAt: !961)
!965 = !DILocation(line: 48, column: 5, scope: !959)
!966 = !DILocation(line: 49, column: 19, scope: !936)
!967 = !DILocation(line: 49, column: 13, scope: !936)
!968 = !DILocation(line: 50, column: 43, scope: !936)
!969 = !{!140, !127, i64 8}
!970 = !DILocation(line: 50, column: 9, scope: !936)
!971 = !DILocation(line: 52, column: 31, scope: !936)
!972 = !DILocation(line: 53, column: 33, scope: !936)
!973 = !DILocation(line: 54, column: 13, scope: !974)
!974 = distinct !DILexicalBlock(scope: !936, file: !3, line: 54, column: 13)
!975 = !DILocation(line: 54, column: 37, scope: !974)
!976 = !DILocation(line: 54, column: 52, scope: !977)
!977 = !DILexicalBlockFile(scope: !974, file: !3, discriminator: 1)
!978 = !{!140, !128, i64 21}
!979 = !DILocation(line: 54, column: 40, scope: !977)
!980 = !DILocation(line: 54, column: 13, scope: !981)
!981 = !DILexicalBlockFile(scope: !936, file: !3, discriminator: 1)
!982 = !DILocation(line: 55, column: 13, scope: !983)
!983 = distinct !DILexicalBlock(scope: !974, file: !3, line: 54, column: 67)
!984 = !DILocation(line: 56, column: 9, scope: !983)
!985 = !DILocation(line: 57, column: 13, scope: !986)
!986 = distinct !DILexicalBlock(scope: !974, file: !3, line: 56, column: 16)
!987 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !988)
!988 = distinct !DILocation(line: 58, column: 13, scope: !986)
!989 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !988)
!990 = !DILocation(line: 540, column: 17, scope: !294, inlinedAt: !988)
!991 = !DILocation(line: 540, column: 30, scope: !294, inlinedAt: !988)
!992 = !DILocation(line: 61, column: 1, scope: !993)
!993 = !DILexicalBlockFile(scope: !930, file: !3, discriminator: 2)
!994 = distinct !DISubprogram(name: "usb_set_data_payload", scope: !3, file: !3, line: 542, type: !995, isLocal: false, isDefinition: true, scopeLine: 543, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !999)
!995 = !DISubroutineType(types: !996)
!996 = !{!42, !50, !51, !997, !48}
!997 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !998, size: 32)
!998 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!999 = !{!1000, !1001, !1002, !1003, !1004, !1006}
!1000 = !DILocalVariable(name: "usb_device", arg: 1, scope: !994, file: !3, line: 542, type: !50)
!1001 = !DILocalVariable(name: "req", arg: 2, scope: !994, file: !3, line: 542, type: !51)
!1002 = !DILocalVariable(name: "data", arg: 3, scope: !994, file: !3, line: 542, type: !997)
!1003 = !DILocalVariable(name: "len", arg: 4, scope: !994, file: !3, line: 542, type: !48)
!1004 = !DILocalVariable(name: "setup_buffer", scope: !994, file: !3, line: 550, type: !1005)
!1005 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !42)
!1006 = !DILocalVariable(name: "tx_len", scope: !994, file: !3, line: 551, type: !48)
!1007 = !DILocation(line: 542, column: 47, scope: !994)
!1008 = !DILocation(line: 542, column: 83, scope: !994)
!1009 = !DILocation(line: 542, column: 100, scope: !994)
!1010 = !DILocation(line: 542, column: 110, scope: !994)
!1011 = !DILocation(line: 544, column: 13, scope: !1012)
!1012 = distinct !DILexicalBlock(scope: !994, file: !3, line: 544, column: 9)
!1013 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !1014)
!1014 = distinct !DILocation(line: 545, column: 9, scope: !1015)
!1015 = distinct !DILexicalBlock(scope: !1012, file: !3, line: 544, column: 19)
!1016 = !DILocation(line: 540, column: 17, scope: !269, inlinedAt: !1014)
!1017 = !DILocation(line: 544, column: 9, scope: !994)
!1018 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !1014)
!1019 = !DILocation(line: 540, column: 30, scope: !294, inlinedAt: !1014)
!1020 = !DILocation(line: 546, column: 9, scope: !1015)
!1021 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !1022)
!1022 = distinct !DILocation(line: 548, column: 5, scope: !994)
!1023 = !DILocation(line: 540, column: 30, scope: !327, inlinedAt: !1022)
!1024 = !DILocation(line: 29, column: 55, scope: !132, inlinedAt: !1025)
!1025 = distinct !DILocation(line: 550, column: 30, scope: !994)
!1026 = !DILocation(line: 31, column: 24, scope: !132, inlinedAt: !1025)
!1027 = !DILocation(line: 550, column: 15, scope: !994)
!1028 = !DILocation(line: 551, column: 9, scope: !994)
!1029 = !DILocation(line: 553, column: 36, scope: !994)
!1030 = !DILocation(line: 553, column: 17, scope: !994)
!1031 = !DILocation(line: 553, column: 29, scope: !994)
!1032 = !DILocation(line: 554, column: 17, scope: !994)
!1033 = !DILocation(line: 554, column: 27, scope: !994)
!1034 = !DILocation(line: 556, column: 9, scope: !1035)
!1035 = distinct !DILexicalBlock(scope: !994, file: !3, line: 556, column: 9)
!1036 = !DILocation(line: 556, column: 33, scope: !1035)
!1037 = !DILocation(line: 556, column: 9, scope: !994)
!1038 = !DILocation(line: 557, column: 35, scope: !1039)
!1039 = distinct !DILexicalBlock(scope: !1035, file: !3, line: 556, column: 43)
!1040 = !DILocation(line: 557, column: 33, scope: !1039)
!1041 = !DILocation(line: 559, column: 5, scope: !1039)
!1042 = !DILocation(line: 562, column: 21, scope: !1043)
!1043 = distinct !DILexicalBlock(scope: !994, file: !3, line: 562, column: 9)
!1044 = !DILocation(line: 562, column: 9, scope: !1043)
!1045 = !DILocation(line: 563, column: 18, scope: !1046)
!1046 = distinct !DILexicalBlock(scope: !1047, file: !3, line: 563, column: 13)
!1047 = distinct !DILexicalBlock(scope: !1043, file: !3, line: 562, column: 34)
!1048 = !DILocation(line: 562, column: 9, scope: !994)
!1049 = !DILocation(line: 564, column: 40, scope: !1050)
!1050 = distinct !DILexicalBlock(scope: !1046, file: !3, line: 563, column: 35)
!1051 = !DILocation(line: 564, column: 13, scope: !1050)
!1052 = !DILocation(line: 565, column: 9, scope: !1050)
!1053 = !DILocation(line: 569, column: 1, scope: !1054)
!1054 = !DILexicalBlockFile(scope: !994, file: !3, discriminator: 1)
!1055 = distinct !DISubprogram(name: "usb_set_reset_hander", scope: !3, file: !3, line: 570, type: !1056, isLocal: false, isDefinition: true, scopeLine: 571, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1058)
!1056 = !DISubroutineType(types: !1057)
!1057 = !{!48, !92, !48, !76}
!1058 = !{!1059, !1060, !1061}
!1059 = !DILocalVariable(name: "usb_id", arg: 1, scope: !1055, file: !3, line: 570, type: !92)
!1060 = !DILocalVariable(name: "itf_num", arg: 2, scope: !1055, file: !3, line: 570, type: !48)
!1061 = !DILocalVariable(name: "hander", arg: 3, scope: !1055, file: !3, line: 570, type: !76)
!1062 = !DILocation(line: 570, column: 40, scope: !1055)
!1063 = !DILocation(line: 570, column: 52, scope: !1055)
!1064 = !DILocation(line: 570, column: 78, scope: !1055)
!1065 = !DILocation(line: 572, column: 17, scope: !1066)
!1066 = distinct !DILexicalBlock(scope: !1055, file: !3, line: 572, column: 9)
!1067 = !DILocation(line: 572, column: 9, scope: !1055)
!1068 = !DILocation(line: 575, column: 9, scope: !1069)
!1069 = distinct !DILexicalBlock(scope: !1055, file: !3, line: 575, column: 9)
!1070 = !DILocation(line: 575, column: 9, scope: !1055)
!1071 = !DILocation(line: 576, column: 9, scope: !1072)
!1072 = distinct !DILexicalBlock(scope: !1069, file: !3, line: 575, column: 28)
!1073 = !DILocation(line: 576, column: 50, scope: !1072)
!1074 = !DILocation(line: 577, column: 5, scope: !1072)
!1075 = !DILocation(line: 579, column: 1, scope: !1055)
!1076 = distinct !DISubprogram(name: "usb_reset_interface", scope: !3, file: !3, line: 581, type: !220, isLocal: false, isDefinition: true, scopeLine: 582, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1077)
!1077 = !{!1078, !1079, !1080, !1085}
!1078 = !DILocalVariable(name: "usb_device", arg: 1, scope: !1076, file: !3, line: 581, type: !50)
!1079 = !DILocalVariable(name: "usb_id", scope: !1076, file: !3, line: 583, type: !92)
!1080 = !DILocalVariable(name: "i", scope: !1081, file: !3, line: 589, type: !1084)
!1081 = distinct !DILexicalBlock(scope: !1082, file: !3, line: 589, column: 9)
!1082 = distinct !DILexicalBlock(scope: !1083, file: !3, line: 588, column: 28)
!1083 = distinct !DILexicalBlock(scope: !1076, file: !3, line: 588, column: 9)
!1084 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!1085 = !DILocalVariable(name: "reg", scope: !1076, file: !3, line: 595, type: !48)
!1086 = !DILocation(line: 581, column: 47, scope: !1076)
!1087 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !1088)
!1088 = distinct !DILocation(line: 583, column: 28, scope: !1076)
!1089 = !DILocation(line: 20, column: 33, scope: !108, inlinedAt: !1088)
!1090 = !DILocation(line: 583, column: 19, scope: !1076)
!1091 = !DILocation(line: 584, column: 5, scope: !1076)
!1092 = !DILocation(line: 584, column: 35, scope: !1076)
!1093 = !DILocation(line: 584, column: 49, scope: !1076)
!1094 = !DILocation(line: 585, column: 17, scope: !1076)
!1095 = !DILocation(line: 585, column: 30, scope: !1076)
!1096 = !DILocation(line: 586, column: 17, scope: !1076)
!1097 = !DILocation(line: 586, column: 23, scope: !1076)
!1098 = !DILocation(line: 587, column: 5, scope: !1076)
!1099 = !DILocation(line: 588, column: 9, scope: !1083)
!1100 = !DILocation(line: 588, column: 9, scope: !1076)
!1101 = !DILocation(line: 589, column: 18, scope: !1081)
!1102 = !DILocation(line: 589, column: 27, scope: !1103)
!1103 = !DILexicalBlockFile(scope: !1104, file: !3, discriminator: 1)
!1104 = distinct !DILexicalBlock(scope: !1081, file: !3, line: 589, column: 9)
!1105 = !DILocation(line: 589, column: 9, scope: !1106)
!1106 = !DILexicalBlockFile(scope: !1081, file: !3, discriminator: 1)
!1107 = !DILocation(line: 590, column: 17, scope: !1108)
!1108 = distinct !DILexicalBlock(scope: !1109, file: !3, line: 590, column: 17)
!1109 = distinct !DILexicalBlock(scope: !1104, file: !3, line: 589, column: 53)
!1110 = !DILocation(line: 590, column: 17, scope: !1109)
!1111 = !DILocation(line: 591, column: 17, scope: !1112)
!1112 = distinct !DILexicalBlock(scope: !1108, file: !3, line: 590, column: 53)
!1113 = !DILocation(line: 592, column: 13, scope: !1112)
!1114 = !DILocation(line: 589, column: 49, scope: !1115)
!1115 = !DILexicalBlockFile(scope: !1104, file: !3, discriminator: 2)
!1116 = !DILocation(line: 589, column: 9, scope: !1115)
!1117 = distinct !{!1117, !1118, !1119}
!1118 = !DILocation(line: 589, column: 9, scope: !1081)
!1119 = !DILocation(line: 593, column: 9, scope: !1081)
!1120 = !DILocation(line: 595, column: 15, scope: !1076)
!1121 = !DILocation(line: 595, column: 15, scope: !1122)
!1122 = !DILexicalBlockFile(scope: !1076, file: !3, discriminator: 1)
!1123 = !DILocation(line: 595, column: 9, scope: !1076)
!1124 = !DILocation(line: 596, column: 13, scope: !1125)
!1125 = distinct !DILexicalBlock(scope: !1076, file: !3, line: 596, column: 9)
!1126 = !DILocation(line: 596, column: 9, scope: !1076)
!1127 = !DILocation(line: 597, column: 28, scope: !1128)
!1128 = distinct !DILexicalBlock(scope: !1125, file: !3, line: 596, column: 23)
!1129 = !{!140, !128, i64 24}
!1130 = !DILocation(line: 598, column: 9, scope: !1131)
!1131 = distinct !DILexicalBlock(scope: !1128, file: !3, line: 598, column: 9)
!1132 = !DILocation(line: 598, column: 9, scope: !1128)
!1133 = !DILocation(line: 598, column: 9, scope: !1134)
!1134 = !DILexicalBlockFile(scope: !1131, file: !3, discriminator: 1)
!1135 = !DILocation(line: 600, column: 28, scope: !1136)
!1136 = distinct !DILexicalBlock(scope: !1125, file: !3, line: 599, column: 12)
!1137 = !DILocation(line: 601, column: 9, scope: !1138)
!1138 = distinct !DILexicalBlock(scope: !1136, file: !3, line: 601, column: 9)
!1139 = !DILocation(line: 601, column: 9, scope: !1136)
!1140 = !DILocation(line: 601, column: 9, scope: !1141)
!1141 = !DILexicalBlockFile(scope: !1138, file: !3, discriminator: 1)
!1142 = !DILocation(line: 603, column: 1, scope: !1076)
!1143 = distinct !DISubprogram(name: "usb_set_setup_recv", scope: !3, file: !3, line: 604, type: !1144, isLocal: false, isDefinition: true, scopeLine: 605, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1146)
!1144 = !DISubroutineType(types: !1145)
!1145 = !{null, !50, !29}
!1146 = !{!1147, !1148, !1149}
!1147 = !DILocalVariable(name: "usb_device", arg: 1, scope: !1143, file: !3, line: 604, type: !50)
!1148 = !DILocalVariable(name: "recv", arg: 2, scope: !1143, file: !3, line: 604, type: !29)
!1149 = !DILocalVariable(name: "usb_id", scope: !1143, file: !3, line: 606, type: !92)
!1150 = !DILocation(line: 604, column: 46, scope: !1143)
!1151 = !DILocation(line: 604, column: 64, scope: !1143)
!1152 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !1153)
!1153 = distinct !DILocation(line: 606, column: 28, scope: !1143)
!1154 = !DILocation(line: 20, column: 33, scope: !108, inlinedAt: !1153)
!1155 = !DILocation(line: 606, column: 19, scope: !1143)
!1156 = !DILocation(line: 607, column: 9, scope: !1157)
!1157 = distinct !DILexicalBlock(scope: !1143, file: !3, line: 607, column: 9)
!1158 = !DILocation(line: 607, column: 9, scope: !1143)
!1159 = !DILocation(line: 608, column: 21, scope: !1160)
!1160 = distinct !DILexicalBlock(scope: !1157, file: !3, line: 607, column: 28)
!1161 = !DILocation(line: 608, column: 32, scope: !1160)
!1162 = !DILocation(line: 609, column: 5, scope: !1160)
!1163 = !DILocation(line: 538, column: 47, scope: !269, inlinedAt: !1164)
!1164 = distinct !DILocation(line: 610, column: 5, scope: !1143)
!1165 = !DILocation(line: 538, column: 62, scope: !269, inlinedAt: !1164)
!1166 = !DILocation(line: 540, column: 17, scope: !269, inlinedAt: !1164)
!1167 = !DILocation(line: 540, column: 30, scope: !269, inlinedAt: !1164)
!1168 = !DILocation(line: 611, column: 1, scope: !1143)
!1169 = distinct !DISubprogram(name: "usb_set_setup_hook", scope: !3, file: !3, line: 612, type: !1144, isLocal: false, isDefinition: true, scopeLine: 613, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1170)
!1170 = !{!1171, !1172, !1173}
!1171 = !DILocalVariable(name: "usb_device", arg: 1, scope: !1169, file: !3, line: 612, type: !50)
!1172 = !DILocalVariable(name: "hook", arg: 2, scope: !1169, file: !3, line: 612, type: !29)
!1173 = !DILocalVariable(name: "usb_id", scope: !1169, file: !3, line: 614, type: !92)
!1174 = !DILocation(line: 612, column: 46, scope: !1169)
!1175 = !DILocation(line: 612, column: 64, scope: !1169)
!1176 = !DILocation(line: 17, column: 56, scope: !108, inlinedAt: !1177)
!1177 = distinct !DILocation(line: 614, column: 28, scope: !1169)
!1178 = !DILocation(line: 20, column: 33, scope: !108, inlinedAt: !1177)
!1179 = !DILocation(line: 614, column: 19, scope: !1169)
!1180 = !DILocation(line: 615, column: 9, scope: !1181)
!1181 = distinct !DILexicalBlock(scope: !1169, file: !3, line: 615, column: 9)
!1182 = !DILocation(line: 615, column: 9, scope: !1169)
!1183 = !DILocation(line: 616, column: 21, scope: !1184)
!1184 = distinct !DILexicalBlock(scope: !1181, file: !3, line: 615, column: 28)
!1185 = !DILocation(line: 616, column: 32, scope: !1184)
!1186 = !DILocation(line: 617, column: 5, scope: !1184)
!1187 = !DILocation(line: 618, column: 1, scope: !1169)
!1188 = distinct !DISubprogram(name: "usb_setup_init", scope: !3, file: !3, line: 619, type: !1189, isLocal: false, isDefinition: true, scopeLine: 620, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1191)
!1189 = !DISubroutineType(types: !1190)
!1190 = !{null, !92, !29, !42}
!1191 = !{!1192, !1193, !1194, !1195}
!1192 = !DILocalVariable(name: "usb_id", arg: 1, scope: !1188, file: !3, line: 619, type: !92)
!1193 = !DILocalVariable(name: "ptr", arg: 2, scope: !1188, file: !3, line: 619, type: !29)
!1194 = !DILocalVariable(name: "setup_buffer", arg: 3, scope: !1188, file: !3, line: 619, type: !42)
!1195 = !DILocalVariable(name: "tx_payload", scope: !1196, file: !3, line: 628, type: !42)
!1196 = distinct !DILexicalBlock(scope: !1197, file: !3, line: 622, column: 28)
!1197 = distinct !DILexicalBlock(scope: !1188, file: !3, line: 622, column: 9)
!1198 = !DILocation(line: 619, column: 35, scope: !1188)
!1199 = !DILocation(line: 619, column: 49, scope: !1188)
!1200 = !DILocation(line: 619, column: 58, scope: !1188)
!1201 = !DILocation(line: 621, column: 5, scope: !1188)
!1202 = !DILocation(line: 621, column: 23, scope: !1188)
!1203 = !DILocation(line: 622, column: 9, scope: !1197)
!1204 = !DILocation(line: 622, column: 9, scope: !1188)
!1205 = !DILocation(line: 624, column: 39, scope: !1196)
!1206 = !DILocation(line: 624, column: 46, scope: !1196)
!1207 = !DILocation(line: 626, column: 9, scope: !1196)
!1208 = !DILocation(line: 626, column: 39, scope: !1196)
!1209 = !DILocation(line: 626, column: 52, scope: !1196)
!1210 = !{!249, !127, i64 4}
!1211 = !DILocation(line: 627, column: 9, scope: !1196)
!1212 = !DILocation(line: 627, column: 39, scope: !1196)
!1213 = !DILocation(line: 627, column: 53, scope: !1196)
!1214 = !DILocation(line: 31, column: 24, scope: !132, inlinedAt: !1215)
!1215 = distinct !DILocation(line: 628, column: 26, scope: !1196)
!1216 = !DILocation(line: 628, column: 13, scope: !1196)
!1217 = !DILocation(line: 630, column: 54, scope: !1196)
!1218 = !{!249, !128, i64 22}
!1219 = !DILocation(line: 630, column: 24, scope: !1196)
!1220 = !DILocation(line: 629, column: 9, scope: !1196)
!1221 = !DILocation(line: 633, column: 5, scope: !1196)
!1222 = !DILocation(line: 634, column: 1, scope: !1188)
!1223 = distinct !DISubprogram(name: "usb_setup_release", scope: !3, file: !3, line: 635, type: !1224, isLocal: false, isDefinition: true, scopeLine: 636, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !1226)
!1224 = !DISubroutineType(types: !1225)
!1225 = !{!48, !92}
!1226 = !{!1227}
!1227 = !DILocalVariable(name: "usb_id", arg: 1, scope: !1223, file: !3, line: 635, type: !92)
!1228 = !DILocation(line: 635, column: 37, scope: !1223)
!1229 = !DILocation(line: 637, column: 9, scope: !1230)
!1230 = distinct !DILexicalBlock(scope: !1223, file: !3, line: 637, column: 9)
!1231 = !DILocation(line: 637, column: 9, scope: !1223)
!1232 = !DILocation(line: 638, column: 27, scope: !1233)
!1233 = distinct !DILexicalBlock(scope: !1230, file: !3, line: 637, column: 28)
!1234 = !DILocation(line: 639, column: 5, scope: !1233)
!1235 = !DILocation(line: 640, column: 5, scope: !1223)
