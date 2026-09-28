; ModuleID = '/tmp/claude-1000/-home-ubuntu-llvm-project/8aeebf17-9c73-413d-b44d-f6985f3428f5/scratchpad/work/sdk/rtos/pmsis/bsp/adc/tlv320/tlv320.c'
source_filename = "/tmp/claude-1000/-home-ubuntu-llvm-project/8aeebf17-9c73-413d-b44d-f6985f3428f5/scratchpad/work/sdk/rtos/pmsis/bsp/adc/tlv320/tlv320.c"
target datalayout = "e-m:e-p:32:32-i64:64-n32-S128"
target triple = "riscv32-unknown-unknown-elf"

%union.tlv320_register_sw_reset_t = type { %struct.anon }
%struct.anon = type { i8 }
%union.tlv320_register_pwr_cfg_t = type { %struct.anon.30 }
%struct.anon.30 = type { i8 }
%struct.pi_device_api = type { ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }
%struct.pi_device = type { ptr, ptr, ptr }
%struct.pi_tlv320_data_t = type { i8, %struct.pi_device }
%struct.tlv320_confreg_t = type { %struct.tlv320_pwr_t, %struct.tlv320_asi_t, %struct.tlv320_dsp_t, %struct.tlv320_int_t, %struct.tlv320_sleep_t, %struct.tlv320_shdn_t, %struct.tlv320_bias_t, %struct.tlv320_gpio_t, [4 x %struct.tlv320_gpi_t], [4 x %struct.tlv320_gpo_t], [8 x %struct.tlv320_ch_t] }
%struct.tlv320_pwr_t = type { i32, i32, i32, i32, i32 }
%struct.tlv320_asi_t = type { i32, i32, i32, i32, i32, %struct.tlv320_asi_tx_t, i32, i32, i32, %struct.tlv320_master_cfg_t, i32, i32, i32, i32, i32, [4 x i32] }
%struct.tlv320_asi_tx_t = type { i32, i32, i32, i32, i8 }
%struct.tlv320_master_cfg_t = type { i32, i32, i32, i32, i32, i32 }
%struct.tlv320_dsp_t = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.tlv320_int_t = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.tlv320_sleep_t = type { i32, i32, i32, i32 }
%struct.tlv320_shdn_t = type { i32, i32, i32 }
%struct.tlv320_bias_t = type { i32, i32 }
%struct.tlv320_gpio_t = type { i32, i32, i32, i32 }
%struct.tlv320_gpi_t = type { i32, i32 }
%struct.tlv320_gpo_t = type { i32, i32, i32 }
%struct.tlv320_ch_t = type { i32, i32, i32, i8, i8, i8, i8, %struct.tlv320_ch_asi_slot_cfg_t, i32, i32, i32, i32 }
%struct.tlv320_ch_asi_slot_cfg_t = type { i32, i8 }
%union.tlv320_register_sleep_cfg_t = type { %struct.anon.0 }
%struct.anon.0 = type { i8 }
%union.tlv320_register_shdn_cfg_t = type { %struct.anon.1 }
%struct.anon.1 = type { i8 }
%union.tlv320_register_asi_cfg0_t = type { %struct.anon.2 }
%struct.anon.2 = type { i8 }
%union.tlv320_register_asi_cfg1_t = type { %struct.anon.3 }
%struct.anon.3 = type { i8 }
%union.tlv320_register_asi_cfg2_t = type { %struct.anon.4 }
%struct.anon.4 = type { i8, i8 }
%union.tlv320_register_asi_ch_t = type { %struct.anon.5 }
%struct.anon.5 = type { i8 }
%union.tlv320_register_mst_cfg0_t = type { %struct.anon.6 }
%struct.anon.6 = type { i8 }
%union.tlv320_register_mst_cfg1_t = type { %struct.anon.7 }
%struct.anon.7 = type { i8 }
%union.tlv320_register_clk_src_t = type { %struct.anon.8 }
%struct.anon.8 = type { i8 }
%union.tlv320_register_pdmclk_cfg_t = type { %struct.anon.9 }
%struct.anon.9 = type { i8 }
%union.tlv320_register_pdmin_cfg_t = type { %struct.anon.10 }
%struct.anon.10 = type { i8 }
%union.tlv320_register_gpo_cfg_t = type { %struct.anon.11 }
%struct.anon.11 = type { i8 }
%union.tlv320_register_gpo_val_t = type { %struct.anon.12 }
%struct.anon.12 = type { i8 }
%union.tlv320_register_gpio_mon_t = type { %struct.anon.13 }
%struct.anon.13 = type { i8 }
%union.tlv320_register_gpi_cfg_t = type { %struct.anon.14 }
%struct.anon.14 = type { i8 }
%union.tlv320_register_gpi_mon_t = type { %struct.anon.15 }
%struct.anon.15 = type { i8 }
%union.tlv320_register_int_cfg_t = type { %struct.anon.16 }
%struct.anon.16 = type { i8 }
%union.tlv320_register_int_mask0_t = type { %struct.anon.17 }
%struct.anon.17 = type { i8 }
%union.tlv320_register_bias_cfg_t = type { %struct.anon.18 }
%struct.anon.18 = type { i8 }
%union.tlv320_register_ch_cfg0_t = type { %struct.anon.19 }
%struct.anon.19 = type { i8 }
%union.tlv320_register_ch_cfg1_t = type { %struct.anon.20 }
%struct.anon.20 = type { i8 }
%union.tlv320_register_ch_cfg2_t = type { %struct.anon.21 }
%struct.anon.21 = type { i8 }
%union.tlv320_register_ch_cfg3_t = type { %struct.anon.22 }
%struct.anon.22 = type { i8 }
%union.tlv320_register_ch_cfg4_t = type { %struct.anon.23 }
%struct.anon.23 = type { i8 }
%union.tlv320_register_dsp_cfg0_t = type { %struct.anon.24 }
%struct.anon.24 = type { i8 }
%union.tlv320_register_dsp_cfg1_t = type { %struct.anon.25 }
%struct.anon.25 = type { i8 }
%union.tlv320_register_dre_cfg0_t = type { %struct.anon.26 }
%struct.anon.26 = type { i8 }
%union.tlv320_register_agc_cfg0_t = type { %struct.anon.27 }
%struct.anon.27 = type { i8 }
%union.tlv320_register_in_ch_en_t = type { %struct.anon.28 }
%struct.anon.28 = type { i8 }
%union.tlv320_register_asi_out_ch_en_t = type { %struct.anon.29 }
%struct.anon.29 = type { i8 }
%union.tlv320_register_asi_sts_t = type { %struct.anon.31 }
%struct.anon.31 = type { i8 }
%struct.pi_i2c_conf = type { i8, i16, i8, i16, i32, i8, i8 }
%struct.pi_tlv320_conf_t = type { i8, i8, i8, i8, ptr, ptr, ptr, ptr, ptr }

@__const.pi_tlv320_reset.reg = private unnamed_addr constant %union.tlv320_register_sw_reset_t { %struct.anon { i8 1 } }, align 1
@__const.pi_tlv320_start.pwr_cfg = private unnamed_addr constant %union.tlv320_register_pwr_cfg_t { %struct.anon.30 { i8 -32 } }, align 1
@tlv320_api = dso_local global %struct.pi_device_api { ptr @__tlv320_open, ptr @__tlv320_close, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null }, align 4

; Function Attrs: nounwind null_pointer_is_valid optsize
define dso_local i32 @pi_tlv320_reset(ptr noundef %device) #0 {
entry:
  %device.addr = alloca ptr, align 4
  %err = alloca i32, align 4
  %reg = alloca %union.tlv320_register_sw_reset_t, align 1
  store ptr %device, ptr %device.addr, align 4, !tbaa !6
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  %0 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %data = getelementptr inbounds nuw %struct.pi_device, ptr %0, i32 0, i32 2
  %1 = load ptr, ptr %data, align 4, !tbaa !13
  %call = call i32 @__tlv320_page_set(ptr noundef %1, i8 noundef zeroext 0) #7
  store i32 %call, ptr %err, align 4, !tbaa !11
  %2 = load i32, ptr %err, align 4, !tbaa !11
  %tobool = icmp ne i32 %2, 0
  br i1 %tobool, label %if.end5, label %if.then

if.then:                                          ; preds = %entry
  call void @llvm.lifetime.start.p0(i64 1, ptr %reg) #6
  call void @llvm.memcpy.p0.p0.i32(ptr align 1 %reg, ptr align 1 @__const.pi_tlv320_reset.reg, i32 1, i1 false)
  %3 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %data1 = getelementptr inbounds nuw %struct.pi_device, ptr %3, i32 0, i32 2
  %4 = load ptr, ptr %data1, align 4, !tbaa !13
  %5 = load i8, ptr %reg, align 1, !tbaa !16
  %call2 = call i32 @__tlv320_write(ptr noundef %4, i8 noundef zeroext 1, i8 noundef zeroext %5) #7
  store i32 %call2, ptr %err, align 4, !tbaa !11
  %6 = load i32, ptr %err, align 4, !tbaa !11
  %tobool3 = icmp ne i32 %6, 0
  br i1 %tobool3, label %if.then4, label %if.end

if.then4:                                         ; preds = %if.then
  br label %if.end

if.end:                                           ; preds = %if.then4, %if.then
  call void @llvm.lifetime.end.p0(i64 1, ptr %reg) #6
  br label %if.end5

if.end5:                                          ; preds = %if.end, %entry
  %7 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  ret i32 %7
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind null_pointer_is_valid optsize
define internal i32 @__tlv320_page_set(ptr noundef %data, i8 noundef zeroext %page) #0 {
entry:
  %data.addr = alloca ptr, align 4
  %page.addr = alloca i8, align 1
  %err = alloca i32, align 4
  store ptr %data, ptr %data.addr, align 4, !tbaa !17
  store i8 %page, ptr %page.addr, align 1, !tbaa !16
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  %0 = load ptr, ptr %data.addr, align 4, !tbaa !17
  %1 = load i8, ptr %page.addr, align 1, !tbaa !16
  %call = call i32 @__tlv320_write(ptr noundef %0, i8 noundef zeroext 0, i8 noundef zeroext %1) #7
  store i32 %call, ptr %err, align 4, !tbaa !11
  %2 = load i32, ptr %err, align 4, !tbaa !11
  %tobool = icmp ne i32 %2, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %3 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  ret i32 %3
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i32(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i32, i1 immarg) #2

; Function Attrs: nounwind null_pointer_is_valid optsize
define internal i32 @__tlv320_write(ptr noundef %data, i8 noundef zeroext %addr, i8 noundef zeroext %value) #0 {
entry:
  %data.addr = alloca ptr, align 4
  %addr.addr = alloca i8, align 1
  %value.addr = alloca i8, align 1
  %buffer = alloca [2 x i8], align 1
  store ptr %data, ptr %data.addr, align 4, !tbaa !17
  store i8 %addr, ptr %addr.addr, align 1, !tbaa !16
  store i8 %value, ptr %value.addr, align 1, !tbaa !16
  call void @llvm.lifetime.start.p0(i64 2, ptr %buffer) #6
  %0 = load i8, ptr %addr.addr, align 1, !tbaa !16
  store i8 %0, ptr %buffer, align 1, !tbaa !16
  %arrayinit.element = getelementptr inbounds i8, ptr %buffer, i32 1
  %1 = load i8, ptr %value.addr, align 1, !tbaa !16
  store i8 %1, ptr %arrayinit.element, align 1, !tbaa !16
  %2 = load ptr, ptr %data.addr, align 4, !tbaa !17
  %i2c = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %2, i32 0, i32 1
  %arraydecay = getelementptr inbounds [2 x i8], ptr %buffer, i32 0, i32 0
  %call = call i32 @pi_i2c_write(ptr noundef %i2c, ptr noundef %arraydecay, i32 noundef 2, i32 noundef 0) #7
  call void @llvm.lifetime.end.p0(i64 2, ptr %buffer) #6
  ret i32 %call
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: nounwind null_pointer_is_valid optsize
define dso_local void @pi_tlv320_confreg_init(ptr noundef %confreg) #0 {
entry:
  %confreg.addr = alloca ptr, align 4
  %id = alloca i8, align 1
  %id64 = alloca i8, align 1
  %id88 = alloca i8, align 1
  store ptr %confreg, ptr %confreg.addr, align 4, !tbaa !17
  %0 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %pwr = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %0, i32 0, i32 0
  %micbias = getelementptr inbounds nuw %struct.tlv320_pwr_t, ptr %pwr, i32 0, i32 0
  store i32 0, ptr %micbias, align 4, !tbaa !18
  %1 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %pwr1 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %1, i32 0, i32 0
  %adc = getelementptr inbounds nuw %struct.tlv320_pwr_t, ptr %pwr1, i32 0, i32 1
  store i32 0, ptr %adc, align 4, !tbaa !29
  %2 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %pwr2 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %2, i32 0, i32 0
  %pll = getelementptr inbounds nuw %struct.tlv320_pwr_t, ptr %pwr2, i32 0, i32 2
  store i32 0, ptr %pll, align 4, !tbaa !30
  %3 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %pwr3 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %3, i32 0, i32 0
  %dyn_ch = getelementptr inbounds nuw %struct.tlv320_pwr_t, ptr %pwr3, i32 0, i32 3
  store i32 0, ptr %dyn_ch, align 4, !tbaa !31
  %4 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %pwr4 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %4, i32 0, i32 0
  %dyn_ch_sel = getelementptr inbounds nuw %struct.tlv320_pwr_t, ptr %pwr4, i32 0, i32 4
  store i32 0, ptr %dyn_ch_sel, align 4, !tbaa !32
  %5 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %5, i32 0, i32 1
  %format = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi, i32 0, i32 0
  store i32 0, ptr %format, align 4, !tbaa !33
  %6 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi5 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %6, i32 0, i32 1
  %wlen = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi5, i32 0, i32 1
  store i32 3, ptr %wlen, align 4, !tbaa !34
  %7 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi6 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %7, i32 0, i32 1
  %fsync_pol = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi6, i32 0, i32 2
  store i32 0, ptr %fsync_pol, align 4, !tbaa !35
  %8 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi7 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %8, i32 0, i32 1
  %bclk_pol = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi7, i32 0, i32 3
  store i32 0, ptr %bclk_pol, align 4, !tbaa !36
  %9 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi8 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %9, i32 0, i32 1
  %daisy = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi8, i32 0, i32 4
  store i32 0, ptr %daisy, align 4, !tbaa !37
  %10 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi9 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %10, i32 0, i32 1
  %tx = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi9, i32 0, i32 5
  %edge = getelementptr inbounds nuw %struct.tlv320_asi_tx_t, ptr %tx, i32 0, i32 0
  store i32 0, ptr %edge, align 4, !tbaa !38
  %11 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi10 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %11, i32 0, i32 1
  %tx11 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi10, i32 0, i32 5
  %fill = getelementptr inbounds nuw %struct.tlv320_asi_tx_t, ptr %tx11, i32 0, i32 1
  store i32 0, ptr %fill, align 4, !tbaa !39
  %12 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi12 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %12, i32 0, i32 1
  %tx13 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi12, i32 0, i32 5
  %lsb = getelementptr inbounds nuw %struct.tlv320_asi_tx_t, ptr %tx13, i32 0, i32 2
  store i32 0, ptr %lsb, align 4, !tbaa !40
  %13 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi14 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %13, i32 0, i32 1
  %tx15 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi14, i32 0, i32 5
  %keeper = getelementptr inbounds nuw %struct.tlv320_asi_tx_t, ptr %tx15, i32 0, i32 3
  store i32 0, ptr %keeper, align 4, !tbaa !41
  %14 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi16 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %14, i32 0, i32 1
  %tx17 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi16, i32 0, i32 5
  %offset = getelementptr inbounds nuw %struct.tlv320_asi_tx_t, ptr %tx17, i32 0, i32 4
  store i8 0, ptr %offset, align 4, !tbaa !42
  %15 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi18 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %15, i32 0, i32 1
  %err = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi18, i32 0, i32 6
  store i32 0, ptr %err, align 4, !tbaa !43
  %16 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi19 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %16, i32 0, i32 1
  %err_rcov = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi19, i32 0, i32 7
  store i32 0, ptr %err_rcov, align 4, !tbaa !44
  %17 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi20 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %17, i32 0, i32 1
  %mode = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi20, i32 0, i32 8
  store i32 0, ptr %mode, align 4, !tbaa !45
  %18 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi21 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %18, i32 0, i32 1
  %master = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi21, i32 0, i32 9
  %mclk_freq_sel_mode = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master, i32 0, i32 0
  store i32 0, ptr %mclk_freq_sel_mode, align 4, !tbaa !46
  %19 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi22 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %19, i32 0, i32 1
  %master23 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi22, i32 0, i32 9
  %mclk_freq = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master23, i32 0, i32 1
  store i32 2, ptr %mclk_freq, align 4, !tbaa !47
  %20 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi24 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %20, i32 0, i32 1
  %master25 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi24, i32 0, i32 9
  %gate = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master25, i32 0, i32 2
  store i32 0, ptr %gate, align 4, !tbaa !48
  %21 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi26 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %21, i32 0, i32 1
  %master27 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi26, i32 0, i32 9
  %fs = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master27, i32 0, i32 3
  store i32 4, ptr %fs, align 4, !tbaa !49
  %22 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi28 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %22, i32 0, i32 1
  %master29 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi28, i32 0, i32 9
  %bclk_ratio = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master29, i32 0, i32 4
  store i32 8, ptr %bclk_ratio, align 4, !tbaa !50
  %23 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi30 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %23, i32 0, i32 1
  %master31 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi30, i32 0, i32 9
  %fs_mode = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master31, i32 0, i32 5
  store i32 0, ptr %fs_mode, align 4, !tbaa !51
  %24 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi32 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %24, i32 0, i32 1
  %auto_clk = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi32, i32 0, i32 10
  store i32 0, ptr %auto_clk, align 4, !tbaa !52
  %25 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi33 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %25, i32 0, i32 1
  %auto_clk_pll = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi33, i32 0, i32 11
  store i32 0, ptr %auto_clk_pll, align 4, !tbaa !53
  %26 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi34 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %26, i32 0, i32 1
  %audio_root_clk_src = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi34, i32 0, i32 12
  store i32 0, ptr %audio_root_clk_src, align 4, !tbaa !54
  %27 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi35 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %27, i32 0, i32 1
  %mclk_fsync_ratio = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi35, i32 0, i32 13
  store i32 2, ptr %mclk_fsync_ratio, align 4, !tbaa !55
  %28 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi36 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %28, i32 0, i32 1
  %pdmclk_div = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi36, i32 0, i32 14
  store i32 0, ptr %pdmclk_div, align 4, !tbaa !56
  call void @llvm.lifetime.start.p0(i64 1, ptr %id) #6
  store i8 0, ptr %id, align 1, !tbaa !16
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %29 = load i8, ptr %id, align 1, !tbaa !16
  %conv = zext i8 %29 to i32
  %cmp = icmp slt i32 %conv, 4
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  call void @llvm.lifetime.end.p0(i64 1, ptr %id) #6
  br label %for.end

for.body:                                         ; preds = %for.cond
  %30 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi38 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %30, i32 0, i32 1
  %pdmin_edge = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi38, i32 0, i32 15
  %31 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom = zext i8 %31 to i32
  %arrayidx = getelementptr inbounds nuw [4 x i32], ptr %pdmin_edge, i32 0, i32 %idxprom
  store i32 0, ptr %arrayidx, align 4, !tbaa !11
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %32 = load i8, ptr %id, align 1, !tbaa !16
  %inc = add i8 %32, 1
  store i8 %inc, ptr %id, align 1, !tbaa !16
  br label %for.cond, !llvm.loop !57

for.end:                                          ; preds = %for.cond.cleanup
  %33 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %33, i32 0, i32 2
  %deci_filter = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp, i32 0, i32 0
  store i32 0, ptr %deci_filter, align 4, !tbaa !59
  %34 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp39 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %34, i32 0, i32 2
  %sum = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp39, i32 0, i32 1
  store i32 0, ptr %sum, align 4, !tbaa !60
  %35 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp40 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %35, i32 0, i32 2
  %hpf = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp40, i32 0, i32 2
  store i32 1, ptr %hpf, align 4, !tbaa !61
  %36 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp41 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %36, i32 0, i32 2
  %dvol_gang = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp41, i32 0, i32 3
  store i32 0, ptr %dvol_gang, align 4, !tbaa !62
  %37 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp42 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %37, i32 0, i32 2
  %biquad = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp42, i32 0, i32 4
  store i32 2, ptr %biquad, align 4, !tbaa !63
  %38 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp43 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %38, i32 0, i32 2
  %soft_stepping = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp43, i32 0, i32 5
  store i32 0, ptr %soft_stepping, align 4, !tbaa !64
  %39 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp44 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %39, i32 0, i32 2
  %dre_agc_sel = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp44, i32 0, i32 6
  store i32 0, ptr %dre_agc_sel, align 4, !tbaa !65
  %40 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp45 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %40, i32 0, i32 2
  %dre_lvl = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp45, i32 0, i32 7
  store i32 7, ptr %dre_lvl, align 4, !tbaa !66
  %41 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp46 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %41, i32 0, i32 2
  %dre_maxgain = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp46, i32 0, i32 8
  store i32 11, ptr %dre_maxgain, align 4, !tbaa !67
  %42 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp47 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %42, i32 0, i32 2
  %agc_lvl = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp47, i32 0, i32 9
  store i32 14, ptr %agc_lvl, align 4, !tbaa !68
  %43 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp48 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %43, i32 0, i32 2
  %agc_maxgain = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp48, i32 0, i32 10
  store i32 7, ptr %agc_maxgain, align 4, !tbaa !69
  %44 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %44, i32 0, i32 3
  %pol = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt, i32 0, i32 0
  store i32 0, ptr %pol, align 4, !tbaa !70
  %45 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt49 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %45, i32 0, i32 3
  %event = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt49, i32 0, i32 1
  store i32 0, ptr %event, align 4, !tbaa !71
  %46 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt50 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %46, i32 0, i32 3
  %readback = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt50, i32 0, i32 2
  store i32 0, ptr %readback, align 4, !tbaa !72
  %47 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt51 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %47, i32 0, i32 3
  %asi_clk_err_mask = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt51, i32 0, i32 3
  store i32 1, ptr %asi_clk_err_mask, align 4, !tbaa !73
  %48 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt52 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %48, i32 0, i32 3
  %pll_lock_int_mask = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt52, i32 0, i32 4
  store i32 1, ptr %pll_lock_int_mask, align 4, !tbaa !74
  %49 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt53 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %49, i32 0, i32 3
  %asi_clk_err_latch = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt53, i32 0, i32 5
  store i32 0, ptr %asi_clk_err_latch, align 4, !tbaa !75
  %50 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt54 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %50, i32 0, i32 3
  %pll_lock_int_latch = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt54, i32 0, i32 6
  store i32 0, ptr %pll_lock_int_latch, align 4, !tbaa !76
  %51 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %sleep = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %51, i32 0, i32 4
  %areg = getelementptr inbounds nuw %struct.tlv320_sleep_t, ptr %sleep, i32 0, i32 0
  store i32 0, ptr %areg, align 4, !tbaa !77
  %52 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %sleep55 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %52, i32 0, i32 4
  %vref_qchg = getelementptr inbounds nuw %struct.tlv320_sleep_t, ptr %sleep55, i32 0, i32 1
  store i32 0, ptr %vref_qchg, align 4, !tbaa !78
  %53 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %sleep56 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %53, i32 0, i32 4
  %broadcast = getelementptr inbounds nuw %struct.tlv320_sleep_t, ptr %sleep56, i32 0, i32 2
  store i32 0, ptr %broadcast, align 4, !tbaa !79
  %54 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %sleep57 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %54, i32 0, i32 4
  %sleep_enz = getelementptr inbounds nuw %struct.tlv320_sleep_t, ptr %sleep57, i32 0, i32 3
  store i32 0, ptr %sleep_enz, align 4, !tbaa !80
  %55 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %shdn = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %55, i32 0, i32 5
  %incap_qchg = getelementptr inbounds nuw %struct.tlv320_shdn_t, ptr %shdn, i32 0, i32 0
  store i32 0, ptr %incap_qchg, align 4, !tbaa !81
  %56 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %shdn58 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %56, i32 0, i32 5
  %shdn_cfg = getelementptr inbounds nuw %struct.tlv320_shdn_t, ptr %shdn58, i32 0, i32 1
  store i32 1, ptr %shdn_cfg, align 4, !tbaa !82
  %57 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %shdn59 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %57, i32 0, i32 5
  %dreg_ka_time = getelementptr inbounds nuw %struct.tlv320_shdn_t, ptr %shdn59, i32 0, i32 2
  store i32 1, ptr %dreg_ka_time, align 4, !tbaa !83
  %58 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %bias = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %58, i32 0, i32 6
  %adc_fscale = getelementptr inbounds nuw %struct.tlv320_bias_t, ptr %bias, i32 0, i32 0
  store i32 0, ptr %adc_fscale, align 4, !tbaa !84
  %59 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %bias60 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %59, i32 0, i32 6
  %mbias_val = getelementptr inbounds nuw %struct.tlv320_bias_t, ptr %bias60, i32 0, i32 1
  store i32 0, ptr %mbias_val, align 4, !tbaa !85
  %60 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpio = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %60, i32 0, i32 7
  %cfg = getelementptr inbounds nuw %struct.tlv320_gpio_t, ptr %gpio, i32 0, i32 0
  store i32 2, ptr %cfg, align 4, !tbaa !86
  %61 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpio61 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %61, i32 0, i32 7
  %drv = getelementptr inbounds nuw %struct.tlv320_gpio_t, ptr %gpio61, i32 0, i32 1
  store i32 2, ptr %drv, align 4, !tbaa !87
  %62 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpio62 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %62, i32 0, i32 7
  %value = getelementptr inbounds nuw %struct.tlv320_gpio_t, ptr %gpio62, i32 0, i32 2
  store i32 0, ptr %value, align 4, !tbaa !88
  %63 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpio63 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %63, i32 0, i32 7
  %mon = getelementptr inbounds nuw %struct.tlv320_gpio_t, ptr %gpio63, i32 0, i32 3
  store i32 0, ptr %mon, align 4, !tbaa !89
  call void @llvm.lifetime.start.p0(i64 1, ptr %id64) #6
  store i8 0, ptr %id64, align 1, !tbaa !16
  br label %for.cond65

for.cond65:                                       ; preds = %for.inc85, %for.end
  %64 = load i8, ptr %id64, align 1, !tbaa !16
  %conv66 = zext i8 %64 to i32
  %cmp67 = icmp slt i32 %conv66, 4
  br i1 %cmp67, label %for.body70, label %for.cond.cleanup69

for.cond.cleanup69:                               ; preds = %for.cond65
  call void @llvm.lifetime.end.p0(i64 1, ptr %id64) #6
  br label %for.end87

for.body70:                                       ; preds = %for.cond65
  %65 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpi = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %65, i32 0, i32 8
  %66 = load i8, ptr %id64, align 1, !tbaa !16
  %idxprom71 = zext i8 %66 to i32
  %arrayidx72 = getelementptr inbounds nuw [4 x %struct.tlv320_gpi_t], ptr %gpi, i32 0, i32 %idxprom71
  %cfg73 = getelementptr inbounds nuw %struct.tlv320_gpi_t, ptr %arrayidx72, i32 0, i32 0
  store i32 0, ptr %cfg73, align 4, !tbaa !90
  %67 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpi74 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %67, i32 0, i32 8
  %68 = load i8, ptr %id64, align 1, !tbaa !16
  %idxprom75 = zext i8 %68 to i32
  %arrayidx76 = getelementptr inbounds nuw [4 x %struct.tlv320_gpi_t], ptr %gpi74, i32 0, i32 %idxprom75
  %mon77 = getelementptr inbounds nuw %struct.tlv320_gpi_t, ptr %arrayidx76, i32 0, i32 1
  store i32 0, ptr %mon77, align 4, !tbaa !91
  %69 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpo = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %69, i32 0, i32 9
  %70 = load i8, ptr %id64, align 1, !tbaa !16
  %idxprom78 = zext i8 %70 to i32
  %arrayidx79 = getelementptr inbounds nuw [4 x %struct.tlv320_gpo_t], ptr %gpo, i32 0, i32 %idxprom78
  %cfg80 = getelementptr inbounds nuw %struct.tlv320_gpo_t, ptr %arrayidx79, i32 0, i32 0
  store i32 0, ptr %cfg80, align 4, !tbaa !92
  %71 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpo81 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %71, i32 0, i32 9
  %72 = load i8, ptr %id64, align 1, !tbaa !16
  %idxprom82 = zext i8 %72 to i32
  %arrayidx83 = getelementptr inbounds nuw [4 x %struct.tlv320_gpo_t], ptr %gpo81, i32 0, i32 %idxprom82
  %drv84 = getelementptr inbounds nuw %struct.tlv320_gpo_t, ptr %arrayidx83, i32 0, i32 1
  store i32 0, ptr %drv84, align 4, !tbaa !93
  br label %for.inc85

for.inc85:                                        ; preds = %for.body70
  %73 = load i8, ptr %id64, align 1, !tbaa !16
  %inc86 = add i8 %73, 1
  store i8 %inc86, ptr %id64, align 1, !tbaa !16
  br label %for.cond65, !llvm.loop !94

for.end87:                                        ; preds = %for.cond.cleanup69
  call void @llvm.lifetime.start.p0(i64 1, ptr %id88) #6
  store i8 0, ptr %id88, align 1, !tbaa !16
  br label %for.cond89

for.cond89:                                       ; preds = %for.inc142, %for.end87
  %74 = load i8, ptr %id88, align 1, !tbaa !16
  %conv90 = zext i8 %74 to i32
  %cmp91 = icmp slt i32 %conv90, 8
  br i1 %cmp91, label %for.body94, label %for.cond.cleanup93

for.cond.cleanup93:                               ; preds = %for.cond89
  call void @llvm.lifetime.end.p0(i64 1, ptr %id88) #6
  br label %for.end144

for.body94:                                       ; preds = %for.cond89
  %75 = load i8, ptr %id88, align 1, !tbaa !16
  %conv95 = zext i8 %75 to i32
  %cmp96 = icmp sle i32 %conv95, 3
  br i1 %cmp96, label %if.then, label %if.else

if.then:                                          ; preds = %for.body94
  %76 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %76, i32 0, i32 10
  %77 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom98 = zext i8 %77 to i32
  %arrayidx99 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel, i32 0, i32 %idxprom98
  %type = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx99, i32 0, i32 0
  store i32 0, ptr %type, align 4, !tbaa !95
  %78 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel100 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %78, i32 0, i32 10
  %79 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom101 = zext i8 %79 to i32
  %arrayidx102 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel100, i32 0, i32 %idxprom101
  %src = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx102, i32 0, i32 8
  store i32 0, ptr %src, align 4, !tbaa !98
  %80 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel103 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %80, i32 0, i32 10
  %81 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom104 = zext i8 %81 to i32
  %arrayidx105 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel103, i32 0, i32 %idxprom104
  %coupling = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx105, i32 0, i32 9
  store i32 0, ptr %coupling, align 4, !tbaa !99
  %82 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel106 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %82, i32 0, i32 10
  %83 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom107 = zext i8 %83 to i32
  %arrayidx108 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel106, i32 0, i32 %idxprom107
  %impedance = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx108, i32 0, i32 10
  store i32 0, ptr %impedance, align 4, !tbaa !100
  %84 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel109 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %84, i32 0, i32 10
  %85 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom110 = zext i8 %85 to i32
  %arrayidx111 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel109, i32 0, i32 %idxprom110
  %dre = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx111, i32 0, i32 11
  store i32 0, ptr %dre, align 4, !tbaa !101
  %86 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel112 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %86, i32 0, i32 10
  %87 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom113 = zext i8 %87 to i32
  %arrayidx114 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel112, i32 0, i32 %idxprom113
  %gain = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx114, i32 0, i32 3
  store i8 0, ptr %gain, align 4, !tbaa !102
  %88 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel115 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %88, i32 0, i32 10
  %89 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom116 = zext i8 %89 to i32
  %arrayidx117 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel115, i32 0, i32 %idxprom116
  %in_ch_en = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx117, i32 0, i32 1
  store i32 1, ptr %in_ch_en, align 4, !tbaa !103
  br label %if.end

if.else:                                          ; preds = %for.body94
  %90 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel118 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %90, i32 0, i32 10
  %91 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom119 = zext i8 %91 to i32
  %arrayidx120 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel118, i32 0, i32 %idxprom119
  %in_ch_en121 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx120, i32 0, i32 1
  store i32 0, ptr %in_ch_en121, align 4, !tbaa !103
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %92 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel122 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %92, i32 0, i32 10
  %93 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom123 = zext i8 %93 to i32
  %arrayidx124 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel122, i32 0, i32 %idxprom123
  %asi_out_en = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx124, i32 0, i32 2
  store i32 0, ptr %asi_out_en, align 4, !tbaa !104
  %94 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel125 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %94, i32 0, i32 10
  %95 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom126 = zext i8 %95 to i32
  %arrayidx127 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel125, i32 0, i32 %idxprom126
  %digital_volume = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx127, i32 0, i32 4
  store i8 -55, ptr %digital_volume, align 1, !tbaa !105
  %96 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel128 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %96, i32 0, i32 10
  %97 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom129 = zext i8 %97 to i32
  %arrayidx130 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel128, i32 0, i32 %idxprom129
  %gain_calib = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx130, i32 0, i32 5
  store i8 8, ptr %gain_calib, align 2, !tbaa !106
  %98 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel131 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %98, i32 0, i32 10
  %99 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom132 = zext i8 %99 to i32
  %arrayidx133 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel131, i32 0, i32 %idxprom132
  %phase_calib = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx133, i32 0, i32 6
  store i8 0, ptr %phase_calib, align 1, !tbaa !107
  %100 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel134 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %100, i32 0, i32 10
  %101 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom135 = zext i8 %101 to i32
  %arrayidx136 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel134, i32 0, i32 %idxprom135
  %asi137 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx136, i32 0, i32 7
  %output = getelementptr inbounds nuw %struct.tlv320_ch_asi_slot_cfg_t, ptr %asi137, i32 0, i32 0
  store i32 0, ptr %output, align 4, !tbaa !108
  %102 = load i8, ptr %id88, align 1, !tbaa !16
  %103 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel138 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %103, i32 0, i32 10
  %104 = load i8, ptr %id88, align 1, !tbaa !16
  %idxprom139 = zext i8 %104 to i32
  %arrayidx140 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel138, i32 0, i32 %idxprom139
  %asi141 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx140, i32 0, i32 7
  %slot = getelementptr inbounds nuw %struct.tlv320_ch_asi_slot_cfg_t, ptr %asi141, i32 0, i32 1
  store i8 %102, ptr %slot, align 4, !tbaa !109
  br label %for.inc142

for.inc142:                                       ; preds = %if.end
  %105 = load i8, ptr %id88, align 1, !tbaa !16
  %inc143 = add i8 %105, 1
  store i8 %inc143, ptr %id88, align 1, !tbaa !16
  br label %for.cond89, !llvm.loop !110

for.end144:                                       ; preds = %for.cond.cleanup93
  ret void
}

; Function Attrs: nounwind null_pointer_is_valid optsize
define dso_local i32 @pi_tlv320_configure(ptr noundef %device, ptr noundef %confreg) #0 {
entry:
  %device.addr = alloca ptr, align 4
  %confreg.addr = alloca ptr, align 4
  %err = alloca i32, align 4
  %data = alloca ptr, align 4
  %sleep_cfg = alloca %union.tlv320_register_sleep_cfg_t, align 1
  %shdn_cfg = alloca %union.tlv320_register_shdn_cfg_t, align 1
  %asi_cfg0 = alloca %union.tlv320_register_asi_cfg0_t, align 1
  %asi_cfg1 = alloca %union.tlv320_register_asi_cfg1_t, align 1
  %asi_cfg2 = alloca %union.tlv320_register_asi_cfg2_t, align 1
  %asi_ch = alloca [8 x %union.tlv320_register_asi_ch_t], align 1
  %mst_cfg0 = alloca %union.tlv320_register_mst_cfg0_t, align 1
  %mst_cfg1 = alloca %union.tlv320_register_mst_cfg1_t, align 1
  %clk_src = alloca %union.tlv320_register_clk_src_t, align 1
  %pdmclk_cfg = alloca %union.tlv320_register_pdmclk_cfg_t, align 1
  %pdmin_cfg = alloca %union.tlv320_register_pdmin_cfg_t, align 1
  %gpio_cfg0 = alloca %union.tlv320_register_gpo_cfg_t, align 1
  %gpo_cfg = alloca [4 x %union.tlv320_register_gpo_cfg_t], align 1
  %gpo_val = alloca %union.tlv320_register_gpo_val_t, align 1
  %gpio_mon = alloca %union.tlv320_register_gpio_mon_t, align 1
  %gpi_cfg = alloca [4 x %union.tlv320_register_gpi_cfg_t], align 1
  %gpi_mon = alloca %union.tlv320_register_gpi_mon_t, align 1
  %int_cfg = alloca %union.tlv320_register_int_cfg_t, align 1
  %int_mask0 = alloca %union.tlv320_register_int_mask0_t, align 1
  %bias_cfg = alloca %union.tlv320_register_bias_cfg_t, align 1
  %ch_cfg0 = alloca [4 x %union.tlv320_register_ch_cfg0_t], align 1
  %ch_cfg1 = alloca [4 x %union.tlv320_register_ch_cfg1_t], align 1
  %ch_cfg2 = alloca [8 x %union.tlv320_register_ch_cfg2_t], align 1
  %ch_cfg3 = alloca [8 x %union.tlv320_register_ch_cfg3_t], align 1
  %ch_cfg4 = alloca [8 x %union.tlv320_register_ch_cfg4_t], align 1
  %dsp_cfg0 = alloca %union.tlv320_register_dsp_cfg0_t, align 1
  %dsp_cfg1 = alloca %union.tlv320_register_dsp_cfg1_t, align 1
  %dre_cfg0 = alloca %union.tlv320_register_dre_cfg0_t, align 1
  %agc_cfg0 = alloca %union.tlv320_register_agc_cfg0_t, align 1
  %in_ch_en = alloca %union.tlv320_register_in_ch_en_t, align 1
  %asi_out_ch_en = alloca %union.tlv320_register_asi_out_ch_en_t, align 1
  %pwr_cfg = alloca %union.tlv320_register_pwr_cfg_t, align 1
  %id = alloca i8, align 1
  %id357 = alloca i8, align 1
  %id429 = alloca i8, align 1
  store ptr %device, ptr %device.addr, align 4, !tbaa !6
  store ptr %confreg, ptr %confreg.addr, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %data) #6
  %0 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %data1 = getelementptr inbounds nuw %struct.pi_device, ptr %0, i32 0, i32 2
  %1 = load ptr, ptr %data1, align 4, !tbaa !13
  store ptr %1, ptr %data, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 1, ptr %sleep_cfg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %sleep_cfg, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %shdn_cfg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %shdn_cfg, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %asi_cfg0) #6
  call void @llvm.memset.p0.i32(ptr align 1 %asi_cfg0, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %asi_cfg1) #6
  call void @llvm.memset.p0.i32(ptr align 1 %asi_cfg1, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 2, ptr %asi_cfg2) #6
  call void @llvm.memset.p0.i32(ptr align 1 %asi_cfg2, i8 0, i32 2, i1 false)
  call void @llvm.lifetime.start.p0(i64 8, ptr %asi_ch) #6
  call void @llvm.memset.p0.i32(ptr align 1 %asi_ch, i8 0, i32 8, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %mst_cfg0) #6
  call void @llvm.memset.p0.i32(ptr align 1 %mst_cfg0, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %mst_cfg1) #6
  call void @llvm.memset.p0.i32(ptr align 1 %mst_cfg1, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %clk_src) #6
  call void @llvm.memset.p0.i32(ptr align 1 %clk_src, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %pdmclk_cfg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %pdmclk_cfg, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %pdmin_cfg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %pdmin_cfg, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %gpio_cfg0) #6
  call void @llvm.memset.p0.i32(ptr align 1 %gpio_cfg0, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 4, ptr %gpo_cfg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %gpo_cfg, i8 0, i32 4, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %gpo_val) #6
  call void @llvm.memset.p0.i32(ptr align 1 %gpo_val, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %gpio_mon) #6
  call void @llvm.memset.p0.i32(ptr align 1 %gpio_mon, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 4, ptr %gpi_cfg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %gpi_cfg, i8 0, i32 4, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %gpi_mon) #6
  call void @llvm.memset.p0.i32(ptr align 1 %gpi_mon, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %int_cfg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %int_cfg, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %int_mask0) #6
  call void @llvm.memset.p0.i32(ptr align 1 %int_mask0, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %bias_cfg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %bias_cfg, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 4, ptr %ch_cfg0) #6
  call void @llvm.memset.p0.i32(ptr align 1 %ch_cfg0, i8 0, i32 4, i1 false)
  call void @llvm.lifetime.start.p0(i64 4, ptr %ch_cfg1) #6
  call void @llvm.memset.p0.i32(ptr align 1 %ch_cfg1, i8 0, i32 4, i1 false)
  call void @llvm.lifetime.start.p0(i64 8, ptr %ch_cfg2) #6
  call void @llvm.memset.p0.i32(ptr align 1 %ch_cfg2, i8 0, i32 8, i1 false)
  call void @llvm.lifetime.start.p0(i64 8, ptr %ch_cfg3) #6
  call void @llvm.memset.p0.i32(ptr align 1 %ch_cfg3, i8 0, i32 8, i1 false)
  call void @llvm.lifetime.start.p0(i64 8, ptr %ch_cfg4) #6
  call void @llvm.memset.p0.i32(ptr align 1 %ch_cfg4, i8 0, i32 8, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %dsp_cfg0) #6
  call void @llvm.memset.p0.i32(ptr align 1 %dsp_cfg0, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %dsp_cfg1) #6
  call void @llvm.memset.p0.i32(ptr align 1 %dsp_cfg1, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %dre_cfg0) #6
  call void @llvm.memset.p0.i32(ptr align 1 %dre_cfg0, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %agc_cfg0) #6
  call void @llvm.memset.p0.i32(ptr align 1 %agc_cfg0, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %in_ch_en) #6
  call void @llvm.memset.p0.i32(ptr align 1 %in_ch_en, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %asi_out_ch_en) #6
  call void @llvm.memset.p0.i32(ptr align 1 %asi_out_ch_en, i8 0, i32 1, i1 false)
  call void @llvm.lifetime.start.p0(i64 1, ptr %pwr_cfg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %pwr_cfg, i8 0, i32 1, i1 false)
  %2 = load ptr, ptr %data, align 4, !tbaa !17
  %call = call i32 @__tlv320_page_set(ptr noundef %2, i8 noundef zeroext 0) #7
  %3 = load i32, ptr %err, align 4, !tbaa !11
  %add = add i32 %3, %call
  store i32 %add, ptr %err, align 4, !tbaa !11
  %4 = load ptr, ptr %data, align 4, !tbaa !17
  %call2 = call i32 @__tlv320_read(ptr noundef %4, i8 noundef zeroext 117, ptr noundef %pwr_cfg) #7
  %5 = load i32, ptr %err, align 4, !tbaa !11
  %add3 = add i32 %5, %call2
  store i32 %add3, ptr %err, align 4, !tbaa !11
  %6 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %sleep = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %6, i32 0, i32 4
  %sleep_enz = getelementptr inbounds nuw %struct.tlv320_sleep_t, ptr %sleep, i32 0, i32 3
  %7 = load i32, ptr %sleep_enz, align 4, !tbaa !80
  %conv = trunc i32 %7 to i8
  %bf.load = load i8, ptr %sleep_cfg, align 1
  %bf.value = and i8 %conv, 1
  %bf.clear = and i8 %bf.load, -2
  %bf.set = or i8 %bf.clear, %bf.value
  store i8 %bf.set, ptr %sleep_cfg, align 1
  %8 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %sleep4 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %8, i32 0, i32 4
  %broadcast = getelementptr inbounds nuw %struct.tlv320_sleep_t, ptr %sleep4, i32 0, i32 2
  %9 = load i32, ptr %broadcast, align 4, !tbaa !79
  %conv5 = trunc i32 %9 to i8
  %bf.load6 = load i8, ptr %sleep_cfg, align 1
  %bf.value7 = and i8 %conv5, 1
  %bf.shl = shl i8 %bf.value7, 2
  %bf.clear8 = and i8 %bf.load6, -5
  %bf.set9 = or i8 %bf.clear8, %bf.shl
  store i8 %bf.set9, ptr %sleep_cfg, align 1
  %10 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %sleep10 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %10, i32 0, i32 4
  %vref_qchg = getelementptr inbounds nuw %struct.tlv320_sleep_t, ptr %sleep10, i32 0, i32 1
  %11 = load i32, ptr %vref_qchg, align 4, !tbaa !78
  %conv11 = trunc i32 %11 to i8
  %bf.load12 = load i8, ptr %sleep_cfg, align 1
  %bf.value13 = and i8 %conv11, 3
  %bf.shl14 = shl i8 %bf.value13, 3
  %bf.clear15 = and i8 %bf.load12, -25
  %bf.set16 = or i8 %bf.clear15, %bf.shl14
  store i8 %bf.set16, ptr %sleep_cfg, align 1
  %12 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %sleep17 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %12, i32 0, i32 4
  %areg = getelementptr inbounds nuw %struct.tlv320_sleep_t, ptr %sleep17, i32 0, i32 0
  %13 = load i32, ptr %areg, align 4, !tbaa !77
  %conv18 = trunc i32 %13 to i8
  %bf.load19 = load i8, ptr %sleep_cfg, align 1
  %bf.value20 = and i8 %conv18, 1
  %bf.shl21 = shl i8 %bf.value20, 7
  %bf.clear22 = and i8 %bf.load19, 127
  %bf.set23 = or i8 %bf.clear22, %bf.shl21
  store i8 %bf.set23, ptr %sleep_cfg, align 1
  %14 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %shdn = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %14, i32 0, i32 5
  %dreg_ka_time = getelementptr inbounds nuw %struct.tlv320_shdn_t, ptr %shdn, i32 0, i32 2
  %15 = load i32, ptr %dreg_ka_time, align 4, !tbaa !83
  %conv24 = trunc i32 %15 to i8
  %bf.load25 = load i8, ptr %shdn_cfg, align 1
  %bf.value26 = and i8 %conv24, 3
  %bf.clear27 = and i8 %bf.load25, -4
  %bf.set28 = or i8 %bf.clear27, %bf.value26
  store i8 %bf.set28, ptr %shdn_cfg, align 1
  %16 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %shdn29 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %16, i32 0, i32 5
  %shdn_cfg30 = getelementptr inbounds nuw %struct.tlv320_shdn_t, ptr %shdn29, i32 0, i32 1
  %17 = load i32, ptr %shdn_cfg30, align 4, !tbaa !82
  %conv31 = trunc i32 %17 to i8
  %bf.load32 = load i8, ptr %shdn_cfg, align 1
  %bf.value33 = and i8 %conv31, 3
  %bf.shl34 = shl i8 %bf.value33, 2
  %bf.clear35 = and i8 %bf.load32, -13
  %bf.set36 = or i8 %bf.clear35, %bf.shl34
  store i8 %bf.set36, ptr %shdn_cfg, align 1
  %18 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %shdn37 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %18, i32 0, i32 5
  %incap_qchg = getelementptr inbounds nuw %struct.tlv320_shdn_t, ptr %shdn37, i32 0, i32 0
  %19 = load i32, ptr %incap_qchg, align 4, !tbaa !81
  %conv38 = trunc i32 %19 to i8
  %bf.load39 = load i8, ptr %shdn_cfg, align 1
  %bf.value40 = and i8 %conv38, 3
  %bf.shl41 = shl i8 %bf.value40, 4
  %bf.clear42 = and i8 %bf.load39, -49
  %bf.set43 = or i8 %bf.clear42, %bf.shl41
  store i8 %bf.set43, ptr %shdn_cfg, align 1
  %20 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %20, i32 0, i32 1
  %tx = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi, i32 0, i32 5
  %fill = getelementptr inbounds nuw %struct.tlv320_asi_tx_t, ptr %tx, i32 0, i32 1
  %21 = load i32, ptr %fill, align 4, !tbaa !39
  %conv44 = trunc i32 %21 to i8
  %bf.load45 = load i8, ptr %asi_cfg0, align 1
  %bf.value46 = and i8 %conv44, 1
  %bf.clear47 = and i8 %bf.load45, -2
  %bf.set48 = or i8 %bf.clear47, %bf.value46
  store i8 %bf.set48, ptr %asi_cfg0, align 1
  %22 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi49 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %22, i32 0, i32 1
  %tx50 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi49, i32 0, i32 5
  %edge = getelementptr inbounds nuw %struct.tlv320_asi_tx_t, ptr %tx50, i32 0, i32 0
  %23 = load i32, ptr %edge, align 4, !tbaa !38
  %conv51 = trunc i32 %23 to i8
  %bf.load52 = load i8, ptr %asi_cfg0, align 1
  %bf.value53 = and i8 %conv51, 1
  %bf.shl54 = shl i8 %bf.value53, 1
  %bf.clear55 = and i8 %bf.load52, -3
  %bf.set56 = or i8 %bf.clear55, %bf.shl54
  store i8 %bf.set56, ptr %asi_cfg0, align 1
  %24 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi57 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %24, i32 0, i32 1
  %bclk_pol = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi57, i32 0, i32 3
  %25 = load i32, ptr %bclk_pol, align 4, !tbaa !36
  %conv58 = trunc i32 %25 to i8
  %bf.load59 = load i8, ptr %asi_cfg0, align 1
  %bf.value60 = and i8 %conv58, 1
  %bf.shl61 = shl i8 %bf.value60, 2
  %bf.clear62 = and i8 %bf.load59, -5
  %bf.set63 = or i8 %bf.clear62, %bf.shl61
  store i8 %bf.set63, ptr %asi_cfg0, align 1
  %26 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi64 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %26, i32 0, i32 1
  %fsync_pol = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi64, i32 0, i32 2
  %27 = load i32, ptr %fsync_pol, align 4, !tbaa !35
  %conv65 = trunc i32 %27 to i8
  %bf.load66 = load i8, ptr %asi_cfg0, align 1
  %bf.value67 = and i8 %conv65, 1
  %bf.shl68 = shl i8 %bf.value67, 3
  %bf.clear69 = and i8 %bf.load66, -9
  %bf.set70 = or i8 %bf.clear69, %bf.shl68
  store i8 %bf.set70, ptr %asi_cfg0, align 1
  %28 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi71 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %28, i32 0, i32 1
  %wlen = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi71, i32 0, i32 1
  %29 = load i32, ptr %wlen, align 4, !tbaa !34
  %conv72 = trunc i32 %29 to i8
  %bf.load73 = load i8, ptr %asi_cfg0, align 1
  %bf.value74 = and i8 %conv72, 3
  %bf.shl75 = shl i8 %bf.value74, 4
  %bf.clear76 = and i8 %bf.load73, -49
  %bf.set77 = or i8 %bf.clear76, %bf.shl75
  store i8 %bf.set77, ptr %asi_cfg0, align 1
  %30 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi78 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %30, i32 0, i32 1
  %format = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi78, i32 0, i32 0
  %31 = load i32, ptr %format, align 4, !tbaa !33
  %conv79 = trunc i32 %31 to i8
  %bf.load80 = load i8, ptr %asi_cfg0, align 1
  %bf.value81 = and i8 %conv79, 3
  %bf.shl82 = shl i8 %bf.value81, 6
  %bf.clear83 = and i8 %bf.load80, 63
  %bf.set84 = or i8 %bf.clear83, %bf.shl82
  store i8 %bf.set84, ptr %asi_cfg0, align 1
  %32 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi85 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %32, i32 0, i32 1
  %tx86 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi85, i32 0, i32 5
  %offset = getelementptr inbounds nuw %struct.tlv320_asi_tx_t, ptr %tx86, i32 0, i32 4
  %33 = load i8, ptr %offset, align 4, !tbaa !42
  %bf.load87 = load i8, ptr %asi_cfg1, align 1
  %bf.value88 = and i8 %33, 31
  %bf.clear89 = and i8 %bf.load87, -32
  %bf.set90 = or i8 %bf.clear89, %bf.value88
  store i8 %bf.set90, ptr %asi_cfg1, align 1
  %34 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi91 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %34, i32 0, i32 1
  %tx92 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi91, i32 0, i32 5
  %keeper = getelementptr inbounds nuw %struct.tlv320_asi_tx_t, ptr %tx92, i32 0, i32 3
  %35 = load i32, ptr %keeper, align 4, !tbaa !41
  %conv93 = trunc i32 %35 to i8
  %bf.load94 = load i8, ptr %asi_cfg1, align 1
  %bf.value95 = and i8 %conv93, 3
  %bf.shl96 = shl i8 %bf.value95, 5
  %bf.clear97 = and i8 %bf.load94, -97
  %bf.set98 = or i8 %bf.clear97, %bf.shl96
  store i8 %bf.set98, ptr %asi_cfg1, align 1
  %36 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi99 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %36, i32 0, i32 1
  %tx100 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi99, i32 0, i32 5
  %lsb = getelementptr inbounds nuw %struct.tlv320_asi_tx_t, ptr %tx100, i32 0, i32 2
  %37 = load i32, ptr %lsb, align 4, !tbaa !40
  %conv101 = trunc i32 %37 to i8
  %bf.load102 = load i8, ptr %asi_cfg1, align 1
  %bf.value103 = and i8 %conv101, 1
  %bf.shl104 = shl i8 %bf.value103, 7
  %bf.clear105 = and i8 %bf.load102, 127
  %bf.set106 = or i8 %bf.clear105, %bf.shl104
  store i8 %bf.set106, ptr %asi_cfg1, align 1
  %38 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi107 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %38, i32 0, i32 1
  %err_rcov = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi107, i32 0, i32 7
  %39 = load i32, ptr %err_rcov, align 4, !tbaa !44
  %conv108 = trunc i32 %39 to i8
  %bf.load109 = load i8, ptr %asi_cfg2, align 1
  %bf.value110 = and i8 %conv108, 3
  %bf.shl111 = shl i8 %bf.value110, 4
  %bf.clear112 = and i8 %bf.load109, -49
  %bf.set113 = or i8 %bf.clear112, %bf.shl111
  store i8 %bf.set113, ptr %asi_cfg2, align 1
  %40 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi114 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %40, i32 0, i32 1
  %err115 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi114, i32 0, i32 6
  %41 = load i32, ptr %err115, align 4, !tbaa !43
  %conv116 = trunc i32 %41 to i8
  %bf.load117 = load i8, ptr %asi_cfg2, align 1
  %bf.value118 = and i8 %conv116, 1
  %bf.shl119 = shl i8 %bf.value118, 6
  %bf.clear120 = and i8 %bf.load117, -65
  %bf.set121 = or i8 %bf.clear120, %bf.shl119
  store i8 %bf.set121, ptr %asi_cfg2, align 1
  %42 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi122 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %42, i32 0, i32 1
  %daisy = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi122, i32 0, i32 4
  %43 = load i32, ptr %daisy, align 4, !tbaa !37
  %conv123 = trunc i32 %43 to i8
  %asi_daisy = getelementptr inbounds nuw %struct.anon.4, ptr %asi_cfg2, i32 0, i32 1
  %bf.load124 = load i8, ptr %asi_daisy, align 1
  %bf.value125 = and i8 %conv123, 1
  %bf.clear126 = and i8 %bf.load124, -2
  %bf.set127 = or i8 %bf.clear126, %bf.value125
  store i8 %bf.set127, ptr %asi_daisy, align 1
  call void @llvm.lifetime.start.p0(i64 1, ptr %id) #6
  store i8 0, ptr %id, align 1, !tbaa !16
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %44 = load i8, ptr %id, align 1, !tbaa !16
  %conv128 = zext i8 %44 to i32
  %cmp = icmp slt i32 %conv128, 8
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.cond
  call void @llvm.lifetime.end.p0(i64 1, ptr %id) #6
  br label %for.end

for.body:                                         ; preds = %for.cond
  %45 = load i8, ptr %id, align 1, !tbaa !16
  %conv130 = zext i8 %45 to i32
  %cmp131 = icmp sle i32 %conv130, 3
  br i1 %cmp131, label %if.then, label %if.end

if.then:                                          ; preds = %for.body
  %46 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %46, i32 0, i32 10
  %47 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom = zext i8 %47 to i32
  %arrayidx = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel, i32 0, i32 %idxprom
  %dre = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx, i32 0, i32 11
  %48 = load i32, ptr %dre, align 4, !tbaa !101
  %conv133 = trunc i32 %48 to i8
  %49 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom134 = zext i8 %49 to i32
  %arrayidx135 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg0_t], ptr %ch_cfg0, i32 0, i32 %idxprom134
  %bf.load136 = load i8, ptr %arrayidx135, align 1
  %bf.value137 = and i8 %conv133, 1
  %bf.clear138 = and i8 %bf.load136, -2
  %bf.set139 = or i8 %bf.clear138, %bf.value137
  store i8 %bf.set139, ptr %arrayidx135, align 1
  %50 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel140 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %50, i32 0, i32 10
  %51 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom141 = zext i8 %51 to i32
  %arrayidx142 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel140, i32 0, i32 %idxprom141
  %impedance = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx142, i32 0, i32 10
  %52 = load i32, ptr %impedance, align 4, !tbaa !100
  %conv143 = trunc i32 %52 to i8
  %53 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom144 = zext i8 %53 to i32
  %arrayidx145 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg0_t], ptr %ch_cfg0, i32 0, i32 %idxprom144
  %bf.load146 = load i8, ptr %arrayidx145, align 1
  %bf.value147 = and i8 %conv143, 3
  %bf.shl148 = shl i8 %bf.value147, 2
  %bf.clear149 = and i8 %bf.load146, -13
  %bf.set150 = or i8 %bf.clear149, %bf.shl148
  store i8 %bf.set150, ptr %arrayidx145, align 1
  %54 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel151 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %54, i32 0, i32 10
  %55 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom152 = zext i8 %55 to i32
  %arrayidx153 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel151, i32 0, i32 %idxprom152
  %coupling = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx153, i32 0, i32 9
  %56 = load i32, ptr %coupling, align 4, !tbaa !99
  %conv154 = trunc i32 %56 to i8
  %57 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom155 = zext i8 %57 to i32
  %arrayidx156 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg0_t], ptr %ch_cfg0, i32 0, i32 %idxprom155
  %bf.load157 = load i8, ptr %arrayidx156, align 1
  %bf.value158 = and i8 %conv154, 1
  %bf.shl159 = shl i8 %bf.value158, 4
  %bf.clear160 = and i8 %bf.load157, -17
  %bf.set161 = or i8 %bf.clear160, %bf.shl159
  store i8 %bf.set161, ptr %arrayidx156, align 1
  %58 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel162 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %58, i32 0, i32 10
  %59 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom163 = zext i8 %59 to i32
  %arrayidx164 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel162, i32 0, i32 %idxprom163
  %src = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx164, i32 0, i32 8
  %60 = load i32, ptr %src, align 4, !tbaa !98
  %conv165 = trunc i32 %60 to i8
  %61 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom166 = zext i8 %61 to i32
  %arrayidx167 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg0_t], ptr %ch_cfg0, i32 0, i32 %idxprom166
  %bf.load168 = load i8, ptr %arrayidx167, align 1
  %bf.value169 = and i8 %conv165, 3
  %bf.shl170 = shl i8 %bf.value169, 5
  %bf.clear171 = and i8 %bf.load168, -97
  %bf.set172 = or i8 %bf.clear171, %bf.shl170
  store i8 %bf.set172, ptr %arrayidx167, align 1
  %62 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel173 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %62, i32 0, i32 10
  %63 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom174 = zext i8 %63 to i32
  %arrayidx175 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel173, i32 0, i32 %idxprom174
  %type = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx175, i32 0, i32 0
  %64 = load i32, ptr %type, align 4, !tbaa !95
  %conv176 = trunc i32 %64 to i8
  %65 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom177 = zext i8 %65 to i32
  %arrayidx178 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg0_t], ptr %ch_cfg0, i32 0, i32 %idxprom177
  %bf.load179 = load i8, ptr %arrayidx178, align 1
  %bf.value180 = and i8 %conv176, 1
  %bf.shl181 = shl i8 %bf.value180, 7
  %bf.clear182 = and i8 %bf.load179, 127
  %bf.set183 = or i8 %bf.clear182, %bf.shl181
  store i8 %bf.set183, ptr %arrayidx178, align 1
  %66 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel184 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %66, i32 0, i32 10
  %67 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom185 = zext i8 %67 to i32
  %arrayidx186 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel184, i32 0, i32 %idxprom185
  %gain = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx186, i32 0, i32 3
  %68 = load i8, ptr %gain, align 4, !tbaa !102
  %69 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom187 = zext i8 %69 to i32
  %arrayidx188 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg1_t], ptr %ch_cfg1, i32 0, i32 %idxprom187
  %bf.load189 = load i8, ptr %arrayidx188, align 1
  %bf.value190 = and i8 %68, 63
  %bf.shl191 = shl i8 %bf.value190, 2
  %bf.clear192 = and i8 %bf.load189, 3
  %bf.set193 = or i8 %bf.clear192, %bf.shl191
  store i8 %bf.set193, ptr %arrayidx188, align 1
  br label %if.end

if.end:                                           ; preds = %if.then, %for.body
  %70 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel194 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %70, i32 0, i32 10
  %71 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom195 = zext i8 %71 to i32
  %arrayidx196 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel194, i32 0, i32 %idxprom195
  %asi197 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx196, i32 0, i32 7
  %slot = getelementptr inbounds nuw %struct.tlv320_ch_asi_slot_cfg_t, ptr %asi197, i32 0, i32 1
  %72 = load i8, ptr %slot, align 4, !tbaa !109
  %73 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom198 = zext i8 %73 to i32
  %arrayidx199 = getelementptr inbounds nuw [8 x %union.tlv320_register_asi_ch_t], ptr %asi_ch, i32 0, i32 %idxprom198
  %bf.load200 = load i8, ptr %arrayidx199, align 1
  %bf.value201 = and i8 %72, 63
  %bf.clear202 = and i8 %bf.load200, -64
  %bf.set203 = or i8 %bf.clear202, %bf.value201
  store i8 %bf.set203, ptr %arrayidx199, align 1
  %74 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel204 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %74, i32 0, i32 10
  %75 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom205 = zext i8 %75 to i32
  %arrayidx206 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel204, i32 0, i32 %idxprom205
  %asi207 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx206, i32 0, i32 7
  %output = getelementptr inbounds nuw %struct.tlv320_ch_asi_slot_cfg_t, ptr %asi207, i32 0, i32 0
  %76 = load i32, ptr %output, align 4, !tbaa !108
  %conv208 = trunc i32 %76 to i8
  %77 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom209 = zext i8 %77 to i32
  %arrayidx210 = getelementptr inbounds nuw [8 x %union.tlv320_register_asi_ch_t], ptr %asi_ch, i32 0, i32 %idxprom209
  %bf.load211 = load i8, ptr %arrayidx210, align 1
  %bf.value212 = and i8 %conv208, 1
  %bf.shl213 = shl i8 %bf.value212, 6
  %bf.clear214 = and i8 %bf.load211, -65
  %bf.set215 = or i8 %bf.clear214, %bf.shl213
  store i8 %bf.set215, ptr %arrayidx210, align 1
  %78 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel216 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %78, i32 0, i32 10
  %79 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom217 = zext i8 %79 to i32
  %arrayidx218 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel216, i32 0, i32 %idxprom217
  %digital_volume = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx218, i32 0, i32 4
  %80 = load i8, ptr %digital_volume, align 1, !tbaa !105
  %81 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom219 = zext i8 %81 to i32
  %arrayidx220 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg2_t], ptr %ch_cfg2, i32 0, i32 %idxprom219
  store i8 %80, ptr %arrayidx220, align 1
  %82 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel221 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %82, i32 0, i32 10
  %83 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom222 = zext i8 %83 to i32
  %arrayidx223 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel221, i32 0, i32 %idxprom222
  %gain_calib = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx223, i32 0, i32 5
  %84 = load i8, ptr %gain_calib, align 2, !tbaa !106
  %85 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom224 = zext i8 %85 to i32
  %arrayidx225 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg3_t], ptr %ch_cfg3, i32 0, i32 %idxprom224
  %bf.load226 = load i8, ptr %arrayidx225, align 1
  %bf.value227 = and i8 %84, 15
  %bf.shl228 = shl i8 %bf.value227, 4
  %bf.clear229 = and i8 %bf.load226, 15
  %bf.set230 = or i8 %bf.clear229, %bf.shl228
  store i8 %bf.set230, ptr %arrayidx225, align 1
  %86 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel231 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %86, i32 0, i32 10
  %87 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom232 = zext i8 %87 to i32
  %arrayidx233 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel231, i32 0, i32 %idxprom232
  %phase_calib = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx233, i32 0, i32 6
  %88 = load i8, ptr %phase_calib, align 1, !tbaa !107
  %89 = load i8, ptr %id, align 1, !tbaa !16
  %idxprom234 = zext i8 %89 to i32
  %arrayidx235 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg4_t], ptr %ch_cfg4, i32 0, i32 %idxprom234
  %ch_pcal = getelementptr inbounds nuw %struct.anon.23, ptr %arrayidx235, i32 0, i32 0
  store i8 %88, ptr %ch_pcal, align 1, !tbaa !16
  br label %for.inc

for.inc:                                          ; preds = %if.end
  %90 = load i8, ptr %id, align 1, !tbaa !16
  %inc = add i8 %90, 1
  store i8 %inc, ptr %id, align 1, !tbaa !16
  br label %for.cond, !llvm.loop !111

for.end:                                          ; preds = %for.cond.cleanup
  %91 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi236 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %91, i32 0, i32 1
  %master = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi236, i32 0, i32 9
  %mclk_freq = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master, i32 0, i32 1
  %92 = load i32, ptr %mclk_freq, align 4, !tbaa !47
  %conv237 = trunc i32 %92 to i8
  %bf.load238 = load i8, ptr %mst_cfg0, align 1
  %bf.value239 = and i8 %conv237, 7
  %bf.clear240 = and i8 %bf.load238, -8
  %bf.set241 = or i8 %bf.clear240, %bf.value239
  store i8 %bf.set241, ptr %mst_cfg0, align 1
  %93 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi242 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %93, i32 0, i32 1
  %master243 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi242, i32 0, i32 9
  %fs_mode = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master243, i32 0, i32 5
  %94 = load i32, ptr %fs_mode, align 4, !tbaa !51
  %conv244 = trunc i32 %94 to i8
  %bf.load245 = load i8, ptr %mst_cfg0, align 1
  %bf.value246 = and i8 %conv244, 1
  %bf.shl247 = shl i8 %bf.value246, 3
  %bf.clear248 = and i8 %bf.load245, -9
  %bf.set249 = or i8 %bf.clear248, %bf.shl247
  store i8 %bf.set249, ptr %mst_cfg0, align 1
  %95 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi250 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %95, i32 0, i32 1
  %master251 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi250, i32 0, i32 9
  %gate = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master251, i32 0, i32 2
  %96 = load i32, ptr %gate, align 4, !tbaa !48
  %conv252 = trunc i32 %96 to i8
  %bf.load253 = load i8, ptr %mst_cfg0, align 1
  %bf.value254 = and i8 %conv252, 1
  %bf.shl255 = shl i8 %bf.value254, 4
  %bf.clear256 = and i8 %bf.load253, -17
  %bf.set257 = or i8 %bf.clear256, %bf.shl255
  store i8 %bf.set257, ptr %mst_cfg0, align 1
  %97 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi258 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %97, i32 0, i32 1
  %auto_clk_pll = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi258, i32 0, i32 11
  %98 = load i32, ptr %auto_clk_pll, align 4, !tbaa !53
  %conv259 = trunc i32 %98 to i8
  %bf.load260 = load i8, ptr %mst_cfg0, align 1
  %bf.value261 = and i8 %conv259, 1
  %bf.shl262 = shl i8 %bf.value261, 5
  %bf.clear263 = and i8 %bf.load260, -33
  %bf.set264 = or i8 %bf.clear263, %bf.shl262
  store i8 %bf.set264, ptr %mst_cfg0, align 1
  %99 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi265 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %99, i32 0, i32 1
  %auto_clk = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi265, i32 0, i32 10
  %100 = load i32, ptr %auto_clk, align 4, !tbaa !52
  %conv266 = trunc i32 %100 to i8
  %bf.load267 = load i8, ptr %mst_cfg0, align 1
  %bf.value268 = and i8 %conv266, 1
  %bf.shl269 = shl i8 %bf.value268, 6
  %bf.clear270 = and i8 %bf.load267, -65
  %bf.set271 = or i8 %bf.clear270, %bf.shl269
  store i8 %bf.set271, ptr %mst_cfg0, align 1
  %101 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi272 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %101, i32 0, i32 1
  %mode = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi272, i32 0, i32 8
  %102 = load i32, ptr %mode, align 4, !tbaa !45
  %conv273 = trunc i32 %102 to i8
  %bf.load274 = load i8, ptr %mst_cfg0, align 1
  %bf.value275 = and i8 %conv273, 1
  %bf.shl276 = shl i8 %bf.value275, 7
  %bf.clear277 = and i8 %bf.load274, 127
  %bf.set278 = or i8 %bf.clear277, %bf.shl276
  store i8 %bf.set278, ptr %mst_cfg0, align 1
  %103 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi279 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %103, i32 0, i32 1
  %master280 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi279, i32 0, i32 9
  %bclk_ratio = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master280, i32 0, i32 4
  %104 = load i32, ptr %bclk_ratio, align 4, !tbaa !50
  %conv281 = trunc i32 %104 to i8
  %bf.load282 = load i8, ptr %mst_cfg1, align 1
  %bf.value283 = and i8 %conv281, 15
  %bf.clear284 = and i8 %bf.load282, -16
  %bf.set285 = or i8 %bf.clear284, %bf.value283
  store i8 %bf.set285, ptr %mst_cfg1, align 1
  %105 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi286 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %105, i32 0, i32 1
  %master287 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi286, i32 0, i32 9
  %fs = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master287, i32 0, i32 3
  %106 = load i32, ptr %fs, align 4, !tbaa !49
  %conv288 = trunc i32 %106 to i8
  %bf.load289 = load i8, ptr %mst_cfg1, align 1
  %bf.value290 = and i8 %conv288, 15
  %bf.shl291 = shl i8 %bf.value290, 4
  %bf.clear292 = and i8 %bf.load289, 15
  %bf.set293 = or i8 %bf.clear292, %bf.shl291
  store i8 %bf.set293, ptr %mst_cfg1, align 1
  %107 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi294 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %107, i32 0, i32 1
  %mclk_fsync_ratio = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi294, i32 0, i32 13
  %108 = load i32, ptr %mclk_fsync_ratio, align 4, !tbaa !55
  %conv295 = trunc i32 %108 to i8
  %bf.load296 = load i8, ptr %clk_src, align 1
  %bf.value297 = and i8 %conv295, 7
  %bf.shl298 = shl i8 %bf.value297, 3
  %bf.clear299 = and i8 %bf.load296, -57
  %bf.set300 = or i8 %bf.clear299, %bf.shl298
  store i8 %bf.set300, ptr %clk_src, align 1
  %109 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi301 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %109, i32 0, i32 1
  %master302 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi301, i32 0, i32 9
  %mclk_freq_sel_mode = getelementptr inbounds nuw %struct.tlv320_master_cfg_t, ptr %master302, i32 0, i32 0
  %110 = load i32, ptr %mclk_freq_sel_mode, align 4, !tbaa !46
  %conv303 = trunc i32 %110 to i8
  %bf.load304 = load i8, ptr %clk_src, align 1
  %bf.value305 = and i8 %conv303, 1
  %bf.shl306 = shl i8 %bf.value305, 6
  %bf.clear307 = and i8 %bf.load304, -65
  %bf.set308 = or i8 %bf.clear307, %bf.shl306
  store i8 %bf.set308, ptr %clk_src, align 1
  %111 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi309 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %111, i32 0, i32 1
  %audio_root_clk_src = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi309, i32 0, i32 12
  %112 = load i32, ptr %audio_root_clk_src, align 4, !tbaa !54
  %conv310 = trunc i32 %112 to i8
  %bf.load311 = load i8, ptr %clk_src, align 1
  %bf.value312 = and i8 %conv310, 1
  %bf.shl313 = shl i8 %bf.value312, 7
  %bf.clear314 = and i8 %bf.load311, 127
  %bf.set315 = or i8 %bf.clear314, %bf.shl313
  store i8 %bf.set315, ptr %clk_src, align 1
  %113 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi316 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %113, i32 0, i32 1
  %pdmclk_div = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi316, i32 0, i32 14
  %114 = load i32, ptr %pdmclk_div, align 4, !tbaa !56
  %conv317 = trunc i32 %114 to i8
  %bf.load318 = load i8, ptr %pdmclk_cfg, align 1
  %bf.value319 = and i8 %conv317, 3
  %bf.clear320 = and i8 %bf.load318, -4
  %bf.set321 = or i8 %bf.clear320, %bf.value319
  store i8 %bf.set321, ptr %pdmclk_cfg, align 1
  %115 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi322 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %115, i32 0, i32 1
  %pdmin_edge = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi322, i32 0, i32 15
  %arrayidx323 = getelementptr inbounds nuw [4 x i32], ptr %pdmin_edge, i32 0, i32 0
  %116 = load i32, ptr %arrayidx323, align 4, !tbaa !11
  %conv324 = trunc i32 %116 to i8
  %bf.load325 = load i8, ptr %pdmin_cfg, align 1
  %bf.value326 = and i8 %conv324, 1
  %bf.shl327 = shl i8 %bf.value326, 7
  %bf.clear328 = and i8 %bf.load325, 127
  %bf.set329 = or i8 %bf.clear328, %bf.shl327
  store i8 %bf.set329, ptr %pdmin_cfg, align 1
  %117 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi330 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %117, i32 0, i32 1
  %pdmin_edge331 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi330, i32 0, i32 15
  %arrayidx332 = getelementptr inbounds nuw [4 x i32], ptr %pdmin_edge331, i32 0, i32 1
  %118 = load i32, ptr %arrayidx332, align 4, !tbaa !11
  %conv333 = trunc i32 %118 to i8
  %bf.load334 = load i8, ptr %pdmin_cfg, align 1
  %bf.value335 = and i8 %conv333, 1
  %bf.shl336 = shl i8 %bf.value335, 6
  %bf.clear337 = and i8 %bf.load334, -65
  %bf.set338 = or i8 %bf.clear337, %bf.shl336
  store i8 %bf.set338, ptr %pdmin_cfg, align 1
  %119 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi339 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %119, i32 0, i32 1
  %pdmin_edge340 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi339, i32 0, i32 15
  %arrayidx341 = getelementptr inbounds nuw [4 x i32], ptr %pdmin_edge340, i32 0, i32 2
  %120 = load i32, ptr %arrayidx341, align 4, !tbaa !11
  %conv342 = trunc i32 %120 to i8
  %bf.load343 = load i8, ptr %pdmin_cfg, align 1
  %bf.value344 = and i8 %conv342, 1
  %bf.shl345 = shl i8 %bf.value344, 5
  %bf.clear346 = and i8 %bf.load343, -33
  %bf.set347 = or i8 %bf.clear346, %bf.shl345
  store i8 %bf.set347, ptr %pdmin_cfg, align 1
  %121 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %asi348 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %121, i32 0, i32 1
  %pdmin_edge349 = getelementptr inbounds nuw %struct.tlv320_asi_t, ptr %asi348, i32 0, i32 15
  %arrayidx350 = getelementptr inbounds nuw [4 x i32], ptr %pdmin_edge349, i32 0, i32 3
  %122 = load i32, ptr %arrayidx350, align 4, !tbaa !11
  %conv351 = trunc i32 %122 to i8
  %bf.load352 = load i8, ptr %pdmin_cfg, align 1
  %bf.value353 = and i8 %conv351, 1
  %bf.shl354 = shl i8 %bf.value353, 4
  %bf.clear355 = and i8 %bf.load352, -17
  %bf.set356 = or i8 %bf.clear355, %bf.shl354
  store i8 %bf.set356, ptr %pdmin_cfg, align 1
  call void @llvm.lifetime.start.p0(i64 1, ptr %id357) #6
  store i8 0, ptr %id357, align 1, !tbaa !16
  br label %for.cond358

for.cond358:                                      ; preds = %for.inc384, %for.end
  %123 = load i8, ptr %id357, align 1, !tbaa !16
  %conv359 = zext i8 %123 to i32
  %cmp360 = icmp slt i32 %conv359, 4
  br i1 %cmp360, label %for.body363, label %for.cond.cleanup362

for.cond.cleanup362:                              ; preds = %for.cond358
  call void @llvm.lifetime.end.p0(i64 1, ptr %id357) #6
  br label %for.end386

for.body363:                                      ; preds = %for.cond358
  %124 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpo = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %124, i32 0, i32 9
  %125 = load i8, ptr %id357, align 1, !tbaa !16
  %idxprom364 = zext i8 %125 to i32
  %arrayidx365 = getelementptr inbounds nuw [4 x %struct.tlv320_gpo_t], ptr %gpo, i32 0, i32 %idxprom364
  %drv = getelementptr inbounds nuw %struct.tlv320_gpo_t, ptr %arrayidx365, i32 0, i32 1
  %126 = load i32, ptr %drv, align 4, !tbaa !93
  %conv366 = trunc i32 %126 to i8
  %127 = load i8, ptr %id357, align 1, !tbaa !16
  %idxprom367 = zext i8 %127 to i32
  %arrayidx368 = getelementptr inbounds nuw [4 x %union.tlv320_register_gpo_cfg_t], ptr %gpo_cfg, i32 0, i32 %idxprom367
  %bf.load369 = load i8, ptr %arrayidx368, align 1
  %bf.value370 = and i8 %conv366, 7
  %bf.clear371 = and i8 %bf.load369, -8
  %bf.set372 = or i8 %bf.clear371, %bf.value370
  store i8 %bf.set372, ptr %arrayidx368, align 1
  %128 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpo373 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %128, i32 0, i32 9
  %129 = load i8, ptr %id357, align 1, !tbaa !16
  %idxprom374 = zext i8 %129 to i32
  %arrayidx375 = getelementptr inbounds nuw [4 x %struct.tlv320_gpo_t], ptr %gpo373, i32 0, i32 %idxprom374
  %cfg = getelementptr inbounds nuw %struct.tlv320_gpo_t, ptr %arrayidx375, i32 0, i32 0
  %130 = load i32, ptr %cfg, align 4, !tbaa !92
  %conv376 = trunc i32 %130 to i8
  %131 = load i8, ptr %id357, align 1, !tbaa !16
  %idxprom377 = zext i8 %131 to i32
  %arrayidx378 = getelementptr inbounds nuw [4 x %union.tlv320_register_gpo_cfg_t], ptr %gpo_cfg, i32 0, i32 %idxprom377
  %bf.load379 = load i8, ptr %arrayidx378, align 1
  %bf.value380 = and i8 %conv376, 15
  %bf.shl381 = shl i8 %bf.value380, 4
  %bf.clear382 = and i8 %bf.load379, 15
  %bf.set383 = or i8 %bf.clear382, %bf.shl381
  store i8 %bf.set383, ptr %arrayidx378, align 1
  br label %for.inc384

for.inc384:                                       ; preds = %for.body363
  %132 = load i8, ptr %id357, align 1, !tbaa !16
  %inc385 = add i8 %132, 1
  store i8 %inc385, ptr %id357, align 1, !tbaa !16
  br label %for.cond358, !llvm.loop !112

for.end386:                                       ; preds = %for.cond.cleanup362
  %133 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpio = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %133, i32 0, i32 7
  %value = getelementptr inbounds nuw %struct.tlv320_gpio_t, ptr %gpio, i32 0, i32 2
  %134 = load i32, ptr %value, align 4, !tbaa !88
  %conv387 = trunc i32 %134 to i8
  %bf.load388 = load i8, ptr %gpo_val, align 1
  %bf.value389 = and i8 %conv387, 1
  %bf.shl390 = shl i8 %bf.value389, 7
  %bf.clear391 = and i8 %bf.load388, 127
  %bf.set392 = or i8 %bf.clear391, %bf.shl390
  store i8 %bf.set392, ptr %gpo_val, align 1
  %135 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpo393 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %135, i32 0, i32 9
  %arrayidx394 = getelementptr inbounds nuw [4 x %struct.tlv320_gpo_t], ptr %gpo393, i32 0, i32 0
  %value395 = getelementptr inbounds nuw %struct.tlv320_gpo_t, ptr %arrayidx394, i32 0, i32 2
  %136 = load i32, ptr %value395, align 4, !tbaa !113
  %conv396 = trunc i32 %136 to i8
  %bf.load397 = load i8, ptr %gpo_val, align 1
  %bf.value398 = and i8 %conv396, 1
  %bf.shl399 = shl i8 %bf.value398, 6
  %bf.clear400 = and i8 %bf.load397, -65
  %bf.set401 = or i8 %bf.clear400, %bf.shl399
  store i8 %bf.set401, ptr %gpo_val, align 1
  %137 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpo402 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %137, i32 0, i32 9
  %arrayidx403 = getelementptr inbounds nuw [4 x %struct.tlv320_gpo_t], ptr %gpo402, i32 0, i32 1
  %value404 = getelementptr inbounds nuw %struct.tlv320_gpo_t, ptr %arrayidx403, i32 0, i32 2
  %138 = load i32, ptr %value404, align 4, !tbaa !113
  %conv405 = trunc i32 %138 to i8
  %bf.load406 = load i8, ptr %gpo_val, align 1
  %bf.value407 = and i8 %conv405, 1
  %bf.shl408 = shl i8 %bf.value407, 5
  %bf.clear409 = and i8 %bf.load406, -33
  %bf.set410 = or i8 %bf.clear409, %bf.shl408
  store i8 %bf.set410, ptr %gpo_val, align 1
  %139 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpo411 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %139, i32 0, i32 9
  %arrayidx412 = getelementptr inbounds nuw [4 x %struct.tlv320_gpo_t], ptr %gpo411, i32 0, i32 2
  %value413 = getelementptr inbounds nuw %struct.tlv320_gpo_t, ptr %arrayidx412, i32 0, i32 2
  %140 = load i32, ptr %value413, align 4, !tbaa !113
  %conv414 = trunc i32 %140 to i8
  %bf.load415 = load i8, ptr %gpo_val, align 1
  %bf.value416 = and i8 %conv414, 1
  %bf.shl417 = shl i8 %bf.value416, 4
  %bf.clear418 = and i8 %bf.load415, -17
  %bf.set419 = or i8 %bf.clear418, %bf.shl417
  store i8 %bf.set419, ptr %gpo_val, align 1
  %141 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpo420 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %141, i32 0, i32 9
  %arrayidx421 = getelementptr inbounds nuw [4 x %struct.tlv320_gpo_t], ptr %gpo420, i32 0, i32 3
  %value422 = getelementptr inbounds nuw %struct.tlv320_gpo_t, ptr %arrayidx421, i32 0, i32 2
  %142 = load i32, ptr %value422, align 4, !tbaa !113
  %conv423 = trunc i32 %142 to i8
  %bf.load424 = load i8, ptr %gpo_val, align 1
  %bf.value425 = and i8 %conv423, 1
  %bf.shl426 = shl i8 %bf.value425, 3
  %bf.clear427 = and i8 %bf.load424, -9
  %bf.set428 = or i8 %bf.clear427, %bf.shl426
  store i8 %bf.set428, ptr %gpo_val, align 1
  call void @llvm.lifetime.start.p0(i64 1, ptr %id429) #6
  store i8 0, ptr %id429, align 1, !tbaa !16
  br label %for.cond430

for.cond430:                                      ; preds = %for.inc460, %for.end386
  %143 = load i8, ptr %id429, align 1, !tbaa !16
  %conv431 = zext i8 %143 to i32
  %cmp432 = icmp slt i32 %conv431, 2
  br i1 %cmp432, label %for.body435, label %for.cond.cleanup434

for.cond.cleanup434:                              ; preds = %for.cond430
  call void @llvm.lifetime.end.p0(i64 1, ptr %id429) #6
  br label %for.end462

for.body435:                                      ; preds = %for.cond430
  %144 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpi = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %144, i32 0, i32 8
  %145 = load i8, ptr %id429, align 1, !tbaa !16
  %conv436 = zext i8 %145 to i32
  %mul = mul nsw i32 %conv436, 2
  %arrayidx437 = getelementptr inbounds [4 x %struct.tlv320_gpi_t], ptr %gpi, i32 0, i32 %mul
  %cfg438 = getelementptr inbounds nuw %struct.tlv320_gpi_t, ptr %arrayidx437, i32 0, i32 0
  %146 = load i32, ptr %cfg438, align 4, !tbaa !90
  %conv439 = trunc i32 %146 to i8
  %147 = load i8, ptr %id429, align 1, !tbaa !16
  %idxprom440 = zext i8 %147 to i32
  %arrayidx441 = getelementptr inbounds nuw [4 x %union.tlv320_register_gpi_cfg_t], ptr %gpi_cfg, i32 0, i32 %idxprom440
  %bf.load442 = load i8, ptr %arrayidx441, align 1
  %bf.value443 = and i8 %conv439, 7
  %bf.clear444 = and i8 %bf.load442, -8
  %bf.set445 = or i8 %bf.clear444, %bf.value443
  store i8 %bf.set445, ptr %arrayidx441, align 1
  %148 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpi446 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %148, i32 0, i32 8
  %149 = load i8, ptr %id429, align 1, !tbaa !16
  %conv447 = zext i8 %149 to i32
  %mul448 = mul nsw i32 %conv447, 2
  %add449 = add nsw i32 %mul448, 1
  %arrayidx450 = getelementptr inbounds [4 x %struct.tlv320_gpi_t], ptr %gpi446, i32 0, i32 %add449
  %cfg451 = getelementptr inbounds nuw %struct.tlv320_gpi_t, ptr %arrayidx450, i32 0, i32 0
  %150 = load i32, ptr %cfg451, align 4, !tbaa !90
  %conv452 = trunc i32 %150 to i8
  %151 = load i8, ptr %id429, align 1, !tbaa !16
  %idxprom453 = zext i8 %151 to i32
  %arrayidx454 = getelementptr inbounds nuw [4 x %union.tlv320_register_gpi_cfg_t], ptr %gpi_cfg, i32 0, i32 %idxprom453
  %bf.load455 = load i8, ptr %arrayidx454, align 1
  %bf.value456 = and i8 %conv452, 7
  %bf.shl457 = shl i8 %bf.value456, 4
  %bf.clear458 = and i8 %bf.load455, -113
  %bf.set459 = or i8 %bf.clear458, %bf.shl457
  store i8 %bf.set459, ptr %arrayidx454, align 1
  br label %for.inc460

for.inc460:                                       ; preds = %for.body435
  %152 = load i8, ptr %id429, align 1, !tbaa !16
  %inc461 = add i8 %152, 1
  store i8 %inc461, ptr %id429, align 1, !tbaa !16
  br label %for.cond430, !llvm.loop !114

for.end462:                                       ; preds = %for.cond.cleanup434
  %153 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpi463 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %153, i32 0, i32 8
  %arrayidx464 = getelementptr inbounds nuw [4 x %struct.tlv320_gpi_t], ptr %gpi463, i32 0, i32 0
  %mon = getelementptr inbounds nuw %struct.tlv320_gpi_t, ptr %arrayidx464, i32 0, i32 1
  %154 = load i32, ptr %mon, align 4, !tbaa !91
  %conv465 = trunc i32 %154 to i8
  %bf.load466 = load i8, ptr %gpi_mon, align 1
  %bf.value467 = and i8 %conv465, 1
  %bf.shl468 = shl i8 %bf.value467, 7
  %bf.clear469 = and i8 %bf.load466, 127
  %bf.set470 = or i8 %bf.clear469, %bf.shl468
  store i8 %bf.set470, ptr %gpi_mon, align 1
  %155 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpi471 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %155, i32 0, i32 8
  %arrayidx472 = getelementptr inbounds nuw [4 x %struct.tlv320_gpi_t], ptr %gpi471, i32 0, i32 1
  %mon473 = getelementptr inbounds nuw %struct.tlv320_gpi_t, ptr %arrayidx472, i32 0, i32 1
  %156 = load i32, ptr %mon473, align 4, !tbaa !91
  %conv474 = trunc i32 %156 to i8
  %bf.load475 = load i8, ptr %gpi_mon, align 1
  %bf.value476 = and i8 %conv474, 1
  %bf.shl477 = shl i8 %bf.value476, 6
  %bf.clear478 = and i8 %bf.load475, -65
  %bf.set479 = or i8 %bf.clear478, %bf.shl477
  store i8 %bf.set479, ptr %gpi_mon, align 1
  %157 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpi480 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %157, i32 0, i32 8
  %arrayidx481 = getelementptr inbounds nuw [4 x %struct.tlv320_gpi_t], ptr %gpi480, i32 0, i32 2
  %mon482 = getelementptr inbounds nuw %struct.tlv320_gpi_t, ptr %arrayidx481, i32 0, i32 1
  %158 = load i32, ptr %mon482, align 4, !tbaa !91
  %conv483 = trunc i32 %158 to i8
  %bf.load484 = load i8, ptr %gpi_mon, align 1
  %bf.value485 = and i8 %conv483, 1
  %bf.shl486 = shl i8 %bf.value485, 5
  %bf.clear487 = and i8 %bf.load484, -33
  %bf.set488 = or i8 %bf.clear487, %bf.shl486
  store i8 %bf.set488, ptr %gpi_mon, align 1
  %159 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpi489 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %159, i32 0, i32 8
  %arrayidx490 = getelementptr inbounds nuw [4 x %struct.tlv320_gpi_t], ptr %gpi489, i32 0, i32 3
  %mon491 = getelementptr inbounds nuw %struct.tlv320_gpi_t, ptr %arrayidx490, i32 0, i32 1
  %160 = load i32, ptr %mon491, align 4, !tbaa !91
  %conv492 = trunc i32 %160 to i8
  %bf.load493 = load i8, ptr %gpi_mon, align 1
  %bf.value494 = and i8 %conv492, 1
  %bf.shl495 = shl i8 %bf.value494, 4
  %bf.clear496 = and i8 %bf.load493, -17
  %bf.set497 = or i8 %bf.clear496, %bf.shl495
  store i8 %bf.set497, ptr %gpi_mon, align 1
  %161 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpio498 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %161, i32 0, i32 7
  %cfg499 = getelementptr inbounds nuw %struct.tlv320_gpio_t, ptr %gpio498, i32 0, i32 0
  %162 = load i32, ptr %cfg499, align 4, !tbaa !86
  %conv500 = trunc i32 %162 to i8
  %bf.load501 = load i8, ptr %gpio_cfg0, align 1
  %bf.value502 = and i8 %conv500, 15
  %bf.shl503 = shl i8 %bf.value502, 4
  %bf.clear504 = and i8 %bf.load501, 15
  %bf.set505 = or i8 %bf.clear504, %bf.shl503
  store i8 %bf.set505, ptr %gpio_cfg0, align 1
  %163 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpio506 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %163, i32 0, i32 7
  %drv507 = getelementptr inbounds nuw %struct.tlv320_gpio_t, ptr %gpio506, i32 0, i32 1
  %164 = load i32, ptr %drv507, align 4, !tbaa !87
  %conv508 = trunc i32 %164 to i8
  %bf.load509 = load i8, ptr %gpio_cfg0, align 1
  %bf.value510 = and i8 %conv508, 7
  %bf.clear511 = and i8 %bf.load509, -8
  %bf.set512 = or i8 %bf.clear511, %bf.value510
  store i8 %bf.set512, ptr %gpio_cfg0, align 1
  %165 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %gpio513 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %165, i32 0, i32 7
  %mon514 = getelementptr inbounds nuw %struct.tlv320_gpio_t, ptr %gpio513, i32 0, i32 3
  %166 = load i32, ptr %mon514, align 4, !tbaa !89
  %conv515 = trunc i32 %166 to i8
  %bf.load516 = load i8, ptr %gpio_mon, align 1
  %bf.value517 = and i8 %conv515, 1
  %bf.shl518 = shl i8 %bf.value517, 7
  %bf.clear519 = and i8 %bf.load516, 127
  %bf.set520 = or i8 %bf.clear519, %bf.shl518
  store i8 %bf.set520, ptr %gpio_mon, align 1
  %167 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %167, i32 0, i32 3
  %readback = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt, i32 0, i32 2
  %168 = load i32, ptr %readback, align 4, !tbaa !72
  %conv521 = trunc i32 %168 to i8
  %bf.load522 = load i8, ptr %int_cfg, align 1
  %bf.value523 = and i8 %conv521, 1
  %bf.shl524 = shl i8 %bf.value523, 2
  %bf.clear525 = and i8 %bf.load522, -5
  %bf.set526 = or i8 %bf.clear525, %bf.shl524
  store i8 %bf.set526, ptr %int_cfg, align 1
  %169 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt527 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %169, i32 0, i32 3
  %event = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt527, i32 0, i32 1
  %170 = load i32, ptr %event, align 4, !tbaa !71
  %conv528 = trunc i32 %170 to i8
  %bf.load529 = load i8, ptr %int_cfg, align 1
  %bf.value530 = and i8 %conv528, 3
  %bf.shl531 = shl i8 %bf.value530, 5
  %bf.clear532 = and i8 %bf.load529, -97
  %bf.set533 = or i8 %bf.clear532, %bf.shl531
  store i8 %bf.set533, ptr %int_cfg, align 1
  %171 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt534 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %171, i32 0, i32 3
  %pol = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt534, i32 0, i32 0
  %172 = load i32, ptr %pol, align 4, !tbaa !70
  %conv535 = trunc i32 %172 to i8
  %bf.load536 = load i8, ptr %int_cfg, align 1
  %bf.value537 = and i8 %conv535, 1
  %bf.shl538 = shl i8 %bf.value537, 7
  %bf.clear539 = and i8 %bf.load536, 127
  %bf.set540 = or i8 %bf.clear539, %bf.shl538
  store i8 %bf.set540, ptr %int_cfg, align 1
  %173 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt541 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %173, i32 0, i32 3
  %pll_lock_int_mask = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt541, i32 0, i32 4
  %174 = load i32, ptr %pll_lock_int_mask, align 4, !tbaa !74
  %conv542 = trunc i32 %174 to i8
  %bf.load543 = load i8, ptr %int_mask0, align 1
  %bf.value544 = and i8 %conv542, 1
  %bf.shl545 = shl i8 %bf.value544, 6
  %bf.clear546 = and i8 %bf.load543, -65
  %bf.set547 = or i8 %bf.clear546, %bf.shl545
  store i8 %bf.set547, ptr %int_mask0, align 1
  %175 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %interrupt548 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %175, i32 0, i32 3
  %asi_clk_err_mask = getelementptr inbounds nuw %struct.tlv320_int_t, ptr %interrupt548, i32 0, i32 3
  %176 = load i32, ptr %asi_clk_err_mask, align 4, !tbaa !73
  %conv549 = trunc i32 %176 to i8
  %bf.load550 = load i8, ptr %int_mask0, align 1
  %bf.value551 = and i8 %conv549, 1
  %bf.shl552 = shl i8 %bf.value551, 7
  %bf.clear553 = and i8 %bf.load550, 127
  %bf.set554 = or i8 %bf.clear553, %bf.shl552
  store i8 %bf.set554, ptr %int_mask0, align 1
  %177 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %bias = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %177, i32 0, i32 6
  %adc_fscale = getelementptr inbounds nuw %struct.tlv320_bias_t, ptr %bias, i32 0, i32 0
  %178 = load i32, ptr %adc_fscale, align 4, !tbaa !84
  %conv555 = trunc i32 %178 to i8
  %bf.load556 = load i8, ptr %bias_cfg, align 1
  %bf.value557 = and i8 %conv555, 3
  %bf.clear558 = and i8 %bf.load556, -4
  %bf.set559 = or i8 %bf.clear558, %bf.value557
  store i8 %bf.set559, ptr %bias_cfg, align 1
  %179 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %bias560 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %179, i32 0, i32 6
  %mbias_val = getelementptr inbounds nuw %struct.tlv320_bias_t, ptr %bias560, i32 0, i32 1
  %180 = load i32, ptr %mbias_val, align 4, !tbaa !85
  %conv561 = trunc i32 %180 to i8
  %bf.load562 = load i8, ptr %bias_cfg, align 1
  %bf.value563 = and i8 %conv561, 7
  %bf.shl564 = shl i8 %bf.value563, 4
  %bf.clear565 = and i8 %bf.load562, -113
  %bf.set566 = or i8 %bf.clear565, %bf.shl564
  store i8 %bf.set566, ptr %bias_cfg, align 1
  %181 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %181, i32 0, i32 2
  %hpf = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp, i32 0, i32 2
  %182 = load i32, ptr %hpf, align 4, !tbaa !61
  %conv567 = trunc i32 %182 to i8
  %bf.load568 = load i8, ptr %dsp_cfg0, align 1
  %bf.value569 = and i8 %conv567, 3
  %bf.clear570 = and i8 %bf.load568, -4
  %bf.set571 = or i8 %bf.clear570, %bf.value569
  store i8 %bf.set571, ptr %dsp_cfg0, align 1
  %183 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp572 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %183, i32 0, i32 2
  %sum = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp572, i32 0, i32 1
  %184 = load i32, ptr %sum, align 4, !tbaa !60
  %conv573 = trunc i32 %184 to i8
  %bf.load574 = load i8, ptr %dsp_cfg0, align 1
  %bf.value575 = and i8 %conv573, 3
  %bf.shl576 = shl i8 %bf.value575, 2
  %bf.clear577 = and i8 %bf.load574, -13
  %bf.set578 = or i8 %bf.clear577, %bf.shl576
  store i8 %bf.set578, ptr %dsp_cfg0, align 1
  %185 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp579 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %185, i32 0, i32 2
  %deci_filter = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp579, i32 0, i32 0
  %186 = load i32, ptr %deci_filter, align 4, !tbaa !59
  %conv580 = trunc i32 %186 to i8
  %bf.load581 = load i8, ptr %dsp_cfg0, align 1
  %bf.value582 = and i8 %conv580, 3
  %bf.shl583 = shl i8 %bf.value582, 4
  %bf.clear584 = and i8 %bf.load581, -49
  %bf.set585 = or i8 %bf.clear584, %bf.shl583
  store i8 %bf.set585, ptr %dsp_cfg0, align 1
  %187 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp586 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %187, i32 0, i32 2
  %dre_agc_sel = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp586, i32 0, i32 6
  %188 = load i32, ptr %dre_agc_sel, align 4, !tbaa !65
  %conv587 = trunc i32 %188 to i8
  %bf.load588 = load i8, ptr %dsp_cfg1, align 1
  %bf.value589 = and i8 %conv587, 1
  %bf.shl590 = shl i8 %bf.value589, 3
  %bf.clear591 = and i8 %bf.load588, -9
  %bf.set592 = or i8 %bf.clear591, %bf.shl590
  store i8 %bf.set592, ptr %dsp_cfg1, align 1
  %189 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp593 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %189, i32 0, i32 2
  %soft_stepping = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp593, i32 0, i32 5
  %190 = load i32, ptr %soft_stepping, align 4, !tbaa !64
  %conv594 = trunc i32 %190 to i8
  %bf.load595 = load i8, ptr %dsp_cfg1, align 1
  %bf.value596 = and i8 %conv594, 1
  %bf.shl597 = shl i8 %bf.value596, 4
  %bf.clear598 = and i8 %bf.load595, -17
  %bf.set599 = or i8 %bf.clear598, %bf.shl597
  store i8 %bf.set599, ptr %dsp_cfg1, align 1
  %191 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp600 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %191, i32 0, i32 2
  %biquad = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp600, i32 0, i32 4
  %192 = load i32, ptr %biquad, align 4, !tbaa !63
  %conv601 = trunc i32 %192 to i8
  %bf.load602 = load i8, ptr %dsp_cfg1, align 1
  %bf.value603 = and i8 %conv601, 3
  %bf.shl604 = shl i8 %bf.value603, 5
  %bf.clear605 = and i8 %bf.load602, -97
  %bf.set606 = or i8 %bf.clear605, %bf.shl604
  store i8 %bf.set606, ptr %dsp_cfg1, align 1
  %193 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp607 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %193, i32 0, i32 2
  %dvol_gang = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp607, i32 0, i32 3
  %194 = load i32, ptr %dvol_gang, align 4, !tbaa !62
  %conv608 = trunc i32 %194 to i8
  %bf.load609 = load i8, ptr %dsp_cfg1, align 1
  %bf.value610 = and i8 %conv608, 1
  %bf.shl611 = shl i8 %bf.value610, 7
  %bf.clear612 = and i8 %bf.load609, 127
  %bf.set613 = or i8 %bf.clear612, %bf.shl611
  store i8 %bf.set613, ptr %dsp_cfg1, align 1
  %195 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp614 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %195, i32 0, i32 2
  %dre_maxgain = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp614, i32 0, i32 8
  %196 = load i32, ptr %dre_maxgain, align 4, !tbaa !67
  %conv615 = trunc i32 %196 to i8
  %bf.load616 = load i8, ptr %dre_cfg0, align 1
  %bf.value617 = and i8 %conv615, 15
  %bf.clear618 = and i8 %bf.load616, -16
  %bf.set619 = or i8 %bf.clear618, %bf.value617
  store i8 %bf.set619, ptr %dre_cfg0, align 1
  %197 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp620 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %197, i32 0, i32 2
  %dre_lvl = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp620, i32 0, i32 7
  %198 = load i32, ptr %dre_lvl, align 4, !tbaa !66
  %conv621 = trunc i32 %198 to i8
  %bf.load622 = load i8, ptr %dre_cfg0, align 1
  %bf.value623 = and i8 %conv621, 15
  %bf.shl624 = shl i8 %bf.value623, 4
  %bf.clear625 = and i8 %bf.load622, 15
  %bf.set626 = or i8 %bf.clear625, %bf.shl624
  store i8 %bf.set626, ptr %dre_cfg0, align 1
  %199 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp627 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %199, i32 0, i32 2
  %agc_maxgain = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp627, i32 0, i32 10
  %200 = load i32, ptr %agc_maxgain, align 4, !tbaa !69
  %conv628 = trunc i32 %200 to i8
  %bf.load629 = load i8, ptr %agc_cfg0, align 1
  %bf.value630 = and i8 %conv628, 15
  %bf.clear631 = and i8 %bf.load629, -16
  %bf.set632 = or i8 %bf.clear631, %bf.value630
  store i8 %bf.set632, ptr %agc_cfg0, align 1
  %201 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %dsp633 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %201, i32 0, i32 2
  %agc_lvl = getelementptr inbounds nuw %struct.tlv320_dsp_t, ptr %dsp633, i32 0, i32 9
  %202 = load i32, ptr %agc_lvl, align 4, !tbaa !68
  %conv634 = trunc i32 %202 to i8
  %bf.load635 = load i8, ptr %agc_cfg0, align 1
  %bf.value636 = and i8 %conv634, 15
  %bf.shl637 = shl i8 %bf.value636, 4
  %bf.clear638 = and i8 %bf.load635, 15
  %bf.set639 = or i8 %bf.clear638, %bf.shl637
  store i8 %bf.set639, ptr %agc_cfg0, align 1
  %203 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel640 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %203, i32 0, i32 10
  %arrayidx641 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel640, i32 0, i32 7
  %in_ch_en642 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx641, i32 0, i32 1
  %204 = load i32, ptr %in_ch_en642, align 4, !tbaa !103
  %conv643 = trunc i32 %204 to i8
  %bf.load644 = load i8, ptr %in_ch_en, align 1
  %bf.value645 = and i8 %conv643, 1
  %bf.clear646 = and i8 %bf.load644, -2
  %bf.set647 = or i8 %bf.clear646, %bf.value645
  store i8 %bf.set647, ptr %in_ch_en, align 1
  %205 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel648 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %205, i32 0, i32 10
  %arrayidx649 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel648, i32 0, i32 6
  %in_ch_en650 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx649, i32 0, i32 1
  %206 = load i32, ptr %in_ch_en650, align 4, !tbaa !103
  %conv651 = trunc i32 %206 to i8
  %bf.load652 = load i8, ptr %in_ch_en, align 1
  %bf.value653 = and i8 %conv651, 1
  %bf.shl654 = shl i8 %bf.value653, 1
  %bf.clear655 = and i8 %bf.load652, -3
  %bf.set656 = or i8 %bf.clear655, %bf.shl654
  store i8 %bf.set656, ptr %in_ch_en, align 1
  %207 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel657 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %207, i32 0, i32 10
  %arrayidx658 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel657, i32 0, i32 5
  %in_ch_en659 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx658, i32 0, i32 1
  %208 = load i32, ptr %in_ch_en659, align 4, !tbaa !103
  %conv660 = trunc i32 %208 to i8
  %bf.load661 = load i8, ptr %in_ch_en, align 1
  %bf.value662 = and i8 %conv660, 1
  %bf.shl663 = shl i8 %bf.value662, 2
  %bf.clear664 = and i8 %bf.load661, -5
  %bf.set665 = or i8 %bf.clear664, %bf.shl663
  store i8 %bf.set665, ptr %in_ch_en, align 1
  %209 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel666 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %209, i32 0, i32 10
  %arrayidx667 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel666, i32 0, i32 4
  %in_ch_en668 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx667, i32 0, i32 1
  %210 = load i32, ptr %in_ch_en668, align 4, !tbaa !103
  %conv669 = trunc i32 %210 to i8
  %bf.load670 = load i8, ptr %in_ch_en, align 1
  %bf.value671 = and i8 %conv669, 1
  %bf.shl672 = shl i8 %bf.value671, 3
  %bf.clear673 = and i8 %bf.load670, -9
  %bf.set674 = or i8 %bf.clear673, %bf.shl672
  store i8 %bf.set674, ptr %in_ch_en, align 1
  %211 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel675 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %211, i32 0, i32 10
  %arrayidx676 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel675, i32 0, i32 3
  %in_ch_en677 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx676, i32 0, i32 1
  %212 = load i32, ptr %in_ch_en677, align 4, !tbaa !103
  %conv678 = trunc i32 %212 to i8
  %bf.load679 = load i8, ptr %in_ch_en, align 1
  %bf.value680 = and i8 %conv678, 1
  %bf.shl681 = shl i8 %bf.value680, 4
  %bf.clear682 = and i8 %bf.load679, -17
  %bf.set683 = or i8 %bf.clear682, %bf.shl681
  store i8 %bf.set683, ptr %in_ch_en, align 1
  %213 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel684 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %213, i32 0, i32 10
  %arrayidx685 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel684, i32 0, i32 2
  %in_ch_en686 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx685, i32 0, i32 1
  %214 = load i32, ptr %in_ch_en686, align 4, !tbaa !103
  %conv687 = trunc i32 %214 to i8
  %bf.load688 = load i8, ptr %in_ch_en, align 1
  %bf.value689 = and i8 %conv687, 1
  %bf.shl690 = shl i8 %bf.value689, 5
  %bf.clear691 = and i8 %bf.load688, -33
  %bf.set692 = or i8 %bf.clear691, %bf.shl690
  store i8 %bf.set692, ptr %in_ch_en, align 1
  %215 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel693 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %215, i32 0, i32 10
  %arrayidx694 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel693, i32 0, i32 1
  %in_ch_en695 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx694, i32 0, i32 1
  %216 = load i32, ptr %in_ch_en695, align 4, !tbaa !103
  %conv696 = trunc i32 %216 to i8
  %bf.load697 = load i8, ptr %in_ch_en, align 1
  %bf.value698 = and i8 %conv696, 1
  %bf.shl699 = shl i8 %bf.value698, 6
  %bf.clear700 = and i8 %bf.load697, -65
  %bf.set701 = or i8 %bf.clear700, %bf.shl699
  store i8 %bf.set701, ptr %in_ch_en, align 1
  %217 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel702 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %217, i32 0, i32 10
  %arrayidx703 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel702, i32 0, i32 0
  %in_ch_en704 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx703, i32 0, i32 1
  %218 = load i32, ptr %in_ch_en704, align 4, !tbaa !103
  %conv705 = trunc i32 %218 to i8
  %bf.load706 = load i8, ptr %in_ch_en, align 1
  %bf.value707 = and i8 %conv705, 1
  %bf.shl708 = shl i8 %bf.value707, 7
  %bf.clear709 = and i8 %bf.load706, 127
  %bf.set710 = or i8 %bf.clear709, %bf.shl708
  store i8 %bf.set710, ptr %in_ch_en, align 1
  %219 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel711 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %219, i32 0, i32 10
  %arrayidx712 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel711, i32 0, i32 7
  %asi_out_en = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx712, i32 0, i32 2
  %220 = load i32, ptr %asi_out_en, align 4, !tbaa !104
  %conv713 = trunc i32 %220 to i8
  %bf.load714 = load i8, ptr %asi_out_ch_en, align 1
  %bf.value715 = and i8 %conv713, 1
  %bf.clear716 = and i8 %bf.load714, -2
  %bf.set717 = or i8 %bf.clear716, %bf.value715
  store i8 %bf.set717, ptr %asi_out_ch_en, align 1
  %221 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel718 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %221, i32 0, i32 10
  %arrayidx719 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel718, i32 0, i32 6
  %asi_out_en720 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx719, i32 0, i32 2
  %222 = load i32, ptr %asi_out_en720, align 4, !tbaa !104
  %conv721 = trunc i32 %222 to i8
  %bf.load722 = load i8, ptr %asi_out_ch_en, align 1
  %bf.value723 = and i8 %conv721, 1
  %bf.shl724 = shl i8 %bf.value723, 1
  %bf.clear725 = and i8 %bf.load722, -3
  %bf.set726 = or i8 %bf.clear725, %bf.shl724
  store i8 %bf.set726, ptr %asi_out_ch_en, align 1
  %223 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel727 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %223, i32 0, i32 10
  %arrayidx728 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel727, i32 0, i32 5
  %asi_out_en729 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx728, i32 0, i32 2
  %224 = load i32, ptr %asi_out_en729, align 4, !tbaa !104
  %conv730 = trunc i32 %224 to i8
  %bf.load731 = load i8, ptr %asi_out_ch_en, align 1
  %bf.value732 = and i8 %conv730, 1
  %bf.shl733 = shl i8 %bf.value732, 2
  %bf.clear734 = and i8 %bf.load731, -5
  %bf.set735 = or i8 %bf.clear734, %bf.shl733
  store i8 %bf.set735, ptr %asi_out_ch_en, align 1
  %225 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel736 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %225, i32 0, i32 10
  %arrayidx737 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel736, i32 0, i32 4
  %asi_out_en738 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx737, i32 0, i32 2
  %226 = load i32, ptr %asi_out_en738, align 4, !tbaa !104
  %conv739 = trunc i32 %226 to i8
  %bf.load740 = load i8, ptr %asi_out_ch_en, align 1
  %bf.value741 = and i8 %conv739, 1
  %bf.shl742 = shl i8 %bf.value741, 3
  %bf.clear743 = and i8 %bf.load740, -9
  %bf.set744 = or i8 %bf.clear743, %bf.shl742
  store i8 %bf.set744, ptr %asi_out_ch_en, align 1
  %227 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel745 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %227, i32 0, i32 10
  %arrayidx746 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel745, i32 0, i32 3
  %asi_out_en747 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx746, i32 0, i32 2
  %228 = load i32, ptr %asi_out_en747, align 4, !tbaa !104
  %conv748 = trunc i32 %228 to i8
  %bf.load749 = load i8, ptr %asi_out_ch_en, align 1
  %bf.value750 = and i8 %conv748, 1
  %bf.shl751 = shl i8 %bf.value750, 4
  %bf.clear752 = and i8 %bf.load749, -17
  %bf.set753 = or i8 %bf.clear752, %bf.shl751
  store i8 %bf.set753, ptr %asi_out_ch_en, align 1
  %229 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel754 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %229, i32 0, i32 10
  %arrayidx755 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel754, i32 0, i32 2
  %asi_out_en756 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx755, i32 0, i32 2
  %230 = load i32, ptr %asi_out_en756, align 4, !tbaa !104
  %conv757 = trunc i32 %230 to i8
  %bf.load758 = load i8, ptr %asi_out_ch_en, align 1
  %bf.value759 = and i8 %conv757, 1
  %bf.shl760 = shl i8 %bf.value759, 5
  %bf.clear761 = and i8 %bf.load758, -33
  %bf.set762 = or i8 %bf.clear761, %bf.shl760
  store i8 %bf.set762, ptr %asi_out_ch_en, align 1
  %231 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel763 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %231, i32 0, i32 10
  %arrayidx764 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel763, i32 0, i32 1
  %asi_out_en765 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx764, i32 0, i32 2
  %232 = load i32, ptr %asi_out_en765, align 4, !tbaa !104
  %conv766 = trunc i32 %232 to i8
  %bf.load767 = load i8, ptr %asi_out_ch_en, align 1
  %bf.value768 = and i8 %conv766, 1
  %bf.shl769 = shl i8 %bf.value768, 6
  %bf.clear770 = and i8 %bf.load767, -65
  %bf.set771 = or i8 %bf.clear770, %bf.shl769
  store i8 %bf.set771, ptr %asi_out_ch_en, align 1
  %233 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %channel772 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %233, i32 0, i32 10
  %arrayidx773 = getelementptr inbounds nuw [8 x %struct.tlv320_ch_t], ptr %channel772, i32 0, i32 0
  %asi_out_en774 = getelementptr inbounds nuw %struct.tlv320_ch_t, ptr %arrayidx773, i32 0, i32 2
  %234 = load i32, ptr %asi_out_en774, align 4, !tbaa !104
  %conv775 = trunc i32 %234 to i8
  %bf.load776 = load i8, ptr %asi_out_ch_en, align 1
  %bf.value777 = and i8 %conv775, 1
  %bf.shl778 = shl i8 %bf.value777, 7
  %bf.clear779 = and i8 %bf.load776, 127
  %bf.set780 = or i8 %bf.clear779, %bf.shl778
  store i8 %bf.set780, ptr %asi_out_ch_en, align 1
  %235 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %pwr = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %235, i32 0, i32 0
  %dyn_ch_sel = getelementptr inbounds nuw %struct.tlv320_pwr_t, ptr %pwr, i32 0, i32 4
  %236 = load i32, ptr %dyn_ch_sel, align 4, !tbaa !32
  %conv781 = trunc i32 %236 to i8
  %bf.load782 = load i8, ptr %pwr_cfg, align 1
  %bf.value783 = and i8 %conv781, 3
  %bf.shl784 = shl i8 %bf.value783, 2
  %bf.clear785 = and i8 %bf.load782, -13
  %bf.set786 = or i8 %bf.clear785, %bf.shl784
  store i8 %bf.set786, ptr %pwr_cfg, align 1
  %237 = load ptr, ptr %confreg.addr, align 4, !tbaa !17
  %pwr787 = getelementptr inbounds nuw %struct.tlv320_confreg_t, ptr %237, i32 0, i32 0
  %dyn_ch = getelementptr inbounds nuw %struct.tlv320_pwr_t, ptr %pwr787, i32 0, i32 3
  %238 = load i32, ptr %dyn_ch, align 4, !tbaa !31
  %conv788 = trunc i32 %238 to i8
  %bf.load789 = load i8, ptr %pwr_cfg, align 1
  %bf.value790 = and i8 %conv788, 1
  %bf.shl791 = shl i8 %bf.value790, 4
  %bf.clear792 = and i8 %bf.load789, -17
  %bf.set793 = or i8 %bf.clear792, %bf.shl791
  store i8 %bf.set793, ptr %pwr_cfg, align 1
  %239 = load ptr, ptr %data, align 4, !tbaa !17
  %240 = load i8, ptr %sleep_cfg, align 1, !tbaa !16
  %call794 = call i32 @__tlv320_check(ptr noundef %239, i8 noundef zeroext 2, i8 noundef zeroext %240) #7
  %241 = load i32, ptr %err, align 4, !tbaa !11
  %add795 = add i32 %241, %call794
  store i32 %add795, ptr %err, align 4, !tbaa !11
  %242 = load ptr, ptr %data, align 4, !tbaa !17
  %243 = load i8, ptr %shdn_cfg, align 1, !tbaa !16
  %call796 = call i32 @__tlv320_check(ptr noundef %242, i8 noundef zeroext 5, i8 noundef zeroext %243) #7
  %244 = load i32, ptr %err, align 4, !tbaa !11
  %add797 = add i32 %244, %call796
  store i32 %add797, ptr %err, align 4, !tbaa !11
  %245 = load ptr, ptr %data, align 4, !tbaa !17
  %246 = load i8, ptr %asi_cfg0, align 1, !tbaa !16
  %call798 = call i32 @__tlv320_check(ptr noundef %245, i8 noundef zeroext 7, i8 noundef zeroext %246) #7
  %247 = load i32, ptr %err, align 4, !tbaa !11
  %add799 = add i32 %247, %call798
  store i32 %add799, ptr %err, align 4, !tbaa !11
  %248 = load ptr, ptr %data, align 4, !tbaa !17
  %249 = load i8, ptr %asi_cfg1, align 1, !tbaa !16
  %call800 = call i32 @__tlv320_check(ptr noundef %248, i8 noundef zeroext 8, i8 noundef zeroext %249) #7
  %250 = load i32, ptr %err, align 4, !tbaa !11
  %add801 = add i32 %250, %call800
  store i32 %add801, ptr %err, align 4, !tbaa !11
  %251 = load ptr, ptr %data, align 4, !tbaa !17
  %252 = load i8, ptr %asi_cfg2, align 1, !tbaa !16
  %call802 = call i32 @__tlv320_check(ptr noundef %251, i8 noundef zeroext 9, i8 noundef zeroext %252) #7
  %253 = load i32, ptr %err, align 4, !tbaa !11
  %add803 = add i32 %253, %call802
  store i32 %add803, ptr %err, align 4, !tbaa !11
  %254 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx804 = getelementptr inbounds nuw [8 x %union.tlv320_register_asi_ch_t], ptr %asi_ch, i32 0, i32 0
  %255 = load i8, ptr %arrayidx804, align 1, !tbaa !16
  %call805 = call i32 @__tlv320_check(ptr noundef %254, i8 noundef zeroext 11, i8 noundef zeroext %255) #7
  %256 = load i32, ptr %err, align 4, !tbaa !11
  %add806 = add i32 %256, %call805
  store i32 %add806, ptr %err, align 4, !tbaa !11
  %257 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx807 = getelementptr inbounds nuw [8 x %union.tlv320_register_asi_ch_t], ptr %asi_ch, i32 0, i32 1
  %258 = load i8, ptr %arrayidx807, align 1, !tbaa !16
  %call808 = call i32 @__tlv320_check(ptr noundef %257, i8 noundef zeroext 12, i8 noundef zeroext %258) #7
  %259 = load i32, ptr %err, align 4, !tbaa !11
  %add809 = add i32 %259, %call808
  store i32 %add809, ptr %err, align 4, !tbaa !11
  %260 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx810 = getelementptr inbounds nuw [8 x %union.tlv320_register_asi_ch_t], ptr %asi_ch, i32 0, i32 2
  %261 = load i8, ptr %arrayidx810, align 1, !tbaa !16
  %call811 = call i32 @__tlv320_check(ptr noundef %260, i8 noundef zeroext 13, i8 noundef zeroext %261) #7
  %262 = load i32, ptr %err, align 4, !tbaa !11
  %add812 = add i32 %262, %call811
  store i32 %add812, ptr %err, align 4, !tbaa !11
  %263 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx813 = getelementptr inbounds nuw [8 x %union.tlv320_register_asi_ch_t], ptr %asi_ch, i32 0, i32 3
  %264 = load i8, ptr %arrayidx813, align 1, !tbaa !16
  %call814 = call i32 @__tlv320_check(ptr noundef %263, i8 noundef zeroext 14, i8 noundef zeroext %264) #7
  %265 = load i32, ptr %err, align 4, !tbaa !11
  %add815 = add i32 %265, %call814
  store i32 %add815, ptr %err, align 4, !tbaa !11
  %266 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx816 = getelementptr inbounds nuw [8 x %union.tlv320_register_asi_ch_t], ptr %asi_ch, i32 0, i32 4
  %267 = load i8, ptr %arrayidx816, align 1, !tbaa !16
  %call817 = call i32 @__tlv320_check(ptr noundef %266, i8 noundef zeroext 15, i8 noundef zeroext %267) #7
  %268 = load i32, ptr %err, align 4, !tbaa !11
  %add818 = add i32 %268, %call817
  store i32 %add818, ptr %err, align 4, !tbaa !11
  %269 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx819 = getelementptr inbounds nuw [8 x %union.tlv320_register_asi_ch_t], ptr %asi_ch, i32 0, i32 5
  %270 = load i8, ptr %arrayidx819, align 1, !tbaa !16
  %call820 = call i32 @__tlv320_check(ptr noundef %269, i8 noundef zeroext 16, i8 noundef zeroext %270) #7
  %271 = load i32, ptr %err, align 4, !tbaa !11
  %add821 = add i32 %271, %call820
  store i32 %add821, ptr %err, align 4, !tbaa !11
  %272 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx822 = getelementptr inbounds nuw [8 x %union.tlv320_register_asi_ch_t], ptr %asi_ch, i32 0, i32 6
  %273 = load i8, ptr %arrayidx822, align 1, !tbaa !16
  %call823 = call i32 @__tlv320_check(ptr noundef %272, i8 noundef zeroext 17, i8 noundef zeroext %273) #7
  %274 = load i32, ptr %err, align 4, !tbaa !11
  %add824 = add i32 %274, %call823
  store i32 %add824, ptr %err, align 4, !tbaa !11
  %275 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx825 = getelementptr inbounds nuw [8 x %union.tlv320_register_asi_ch_t], ptr %asi_ch, i32 0, i32 7
  %276 = load i8, ptr %arrayidx825, align 1, !tbaa !16
  %call826 = call i32 @__tlv320_check(ptr noundef %275, i8 noundef zeroext 18, i8 noundef zeroext %276) #7
  %277 = load i32, ptr %err, align 4, !tbaa !11
  %add827 = add i32 %277, %call826
  store i32 %add827, ptr %err, align 4, !tbaa !11
  %278 = load ptr, ptr %data, align 4, !tbaa !17
  %279 = load i8, ptr %mst_cfg0, align 1, !tbaa !16
  %call828 = call i32 @__tlv320_check(ptr noundef %278, i8 noundef zeroext 19, i8 noundef zeroext %279) #7
  %280 = load i32, ptr %err, align 4, !tbaa !11
  %add829 = add i32 %280, %call828
  store i32 %add829, ptr %err, align 4, !tbaa !11
  %281 = load ptr, ptr %data, align 4, !tbaa !17
  %282 = load i8, ptr %mst_cfg1, align 1, !tbaa !16
  %call830 = call i32 @__tlv320_check(ptr noundef %281, i8 noundef zeroext 20, i8 noundef zeroext %282) #7
  %283 = load i32, ptr %err, align 4, !tbaa !11
  %add831 = add i32 %283, %call830
  store i32 %add831, ptr %err, align 4, !tbaa !11
  %284 = load ptr, ptr %data, align 4, !tbaa !17
  %285 = load i8, ptr %clk_src, align 1, !tbaa !16
  %call832 = call i32 @__tlv320_check(ptr noundef %284, i8 noundef zeroext 22, i8 noundef zeroext %285) #7
  %286 = load i32, ptr %err, align 4, !tbaa !11
  %add833 = add i32 %286, %call832
  store i32 %add833, ptr %err, align 4, !tbaa !11
  %287 = load ptr, ptr %data, align 4, !tbaa !17
  %288 = load i8, ptr %pdmclk_cfg, align 1, !tbaa !16
  %call834 = call i32 @__tlv320_check(ptr noundef %287, i8 noundef zeroext 31, i8 noundef zeroext %288) #7
  %289 = load i32, ptr %err, align 4, !tbaa !11
  %add835 = add i32 %289, %call834
  store i32 %add835, ptr %err, align 4, !tbaa !11
  %290 = load ptr, ptr %data, align 4, !tbaa !17
  %291 = load i8, ptr %pdmin_cfg, align 1, !tbaa !16
  %call836 = call i32 @__tlv320_check(ptr noundef %290, i8 noundef zeroext 32, i8 noundef zeroext %291) #7
  %292 = load i32, ptr %err, align 4, !tbaa !11
  %add837 = add i32 %292, %call836
  store i32 %add837, ptr %err, align 4, !tbaa !11
  %293 = load ptr, ptr %data, align 4, !tbaa !17
  %294 = load i8, ptr %gpio_cfg0, align 1, !tbaa !16
  %call838 = call i32 @__tlv320_check(ptr noundef %293, i8 noundef zeroext 33, i8 noundef zeroext %294) #7
  %295 = load i32, ptr %err, align 4, !tbaa !11
  %add839 = add i32 %295, %call838
  store i32 %add839, ptr %err, align 4, !tbaa !11
  %296 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx840 = getelementptr inbounds nuw [4 x %union.tlv320_register_gpo_cfg_t], ptr %gpo_cfg, i32 0, i32 0
  %297 = load i8, ptr %arrayidx840, align 1, !tbaa !16
  %call841 = call i32 @__tlv320_check(ptr noundef %296, i8 noundef zeroext 34, i8 noundef zeroext %297) #7
  %298 = load i32, ptr %err, align 4, !tbaa !11
  %add842 = add i32 %298, %call841
  store i32 %add842, ptr %err, align 4, !tbaa !11
  %299 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx843 = getelementptr inbounds nuw [4 x %union.tlv320_register_gpo_cfg_t], ptr %gpo_cfg, i32 0, i32 1
  %300 = load i8, ptr %arrayidx843, align 1, !tbaa !16
  %call844 = call i32 @__tlv320_check(ptr noundef %299, i8 noundef zeroext 35, i8 noundef zeroext %300) #7
  %301 = load i32, ptr %err, align 4, !tbaa !11
  %add845 = add i32 %301, %call844
  store i32 %add845, ptr %err, align 4, !tbaa !11
  %302 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx846 = getelementptr inbounds nuw [4 x %union.tlv320_register_gpo_cfg_t], ptr %gpo_cfg, i32 0, i32 2
  %303 = load i8, ptr %arrayidx846, align 1, !tbaa !16
  %call847 = call i32 @__tlv320_check(ptr noundef %302, i8 noundef zeroext 36, i8 noundef zeroext %303) #7
  %304 = load i32, ptr %err, align 4, !tbaa !11
  %add848 = add i32 %304, %call847
  store i32 %add848, ptr %err, align 4, !tbaa !11
  %305 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx849 = getelementptr inbounds nuw [4 x %union.tlv320_register_gpo_cfg_t], ptr %gpo_cfg, i32 0, i32 3
  %306 = load i8, ptr %arrayidx849, align 1, !tbaa !16
  %call850 = call i32 @__tlv320_check(ptr noundef %305, i8 noundef zeroext 37, i8 noundef zeroext %306) #7
  %307 = load i32, ptr %err, align 4, !tbaa !11
  %add851 = add i32 %307, %call850
  store i32 %add851, ptr %err, align 4, !tbaa !11
  %308 = load ptr, ptr %data, align 4, !tbaa !17
  %309 = load i8, ptr %gpo_val, align 1, !tbaa !16
  %call852 = call i32 @__tlv320_check(ptr noundef %308, i8 noundef zeroext 41, i8 noundef zeroext %309) #7
  %310 = load i32, ptr %err, align 4, !tbaa !11
  %add853 = add i32 %310, %call852
  store i32 %add853, ptr %err, align 4, !tbaa !11
  %311 = load ptr, ptr %data, align 4, !tbaa !17
  %312 = load i8, ptr %gpio_mon, align 1, !tbaa !16
  %call854 = call i32 @__tlv320_check(ptr noundef %311, i8 noundef zeroext 42, i8 noundef zeroext %312) #7
  %313 = load i32, ptr %err, align 4, !tbaa !11
  %add855 = add i32 %313, %call854
  store i32 %add855, ptr %err, align 4, !tbaa !11
  %314 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx856 = getelementptr inbounds nuw [4 x %union.tlv320_register_gpi_cfg_t], ptr %gpi_cfg, i32 0, i32 0
  %315 = load i8, ptr %arrayidx856, align 1, !tbaa !16
  %call857 = call i32 @__tlv320_check(ptr noundef %314, i8 noundef zeroext 43, i8 noundef zeroext %315) #7
  %316 = load i32, ptr %err, align 4, !tbaa !11
  %add858 = add i32 %316, %call857
  store i32 %add858, ptr %err, align 4, !tbaa !11
  %317 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx859 = getelementptr inbounds nuw [4 x %union.tlv320_register_gpi_cfg_t], ptr %gpi_cfg, i32 0, i32 1
  %318 = load i8, ptr %arrayidx859, align 1, !tbaa !16
  %call860 = call i32 @__tlv320_check(ptr noundef %317, i8 noundef zeroext 44, i8 noundef zeroext %318) #7
  %319 = load i32, ptr %err, align 4, !tbaa !11
  %add861 = add i32 %319, %call860
  store i32 %add861, ptr %err, align 4, !tbaa !11
  %320 = load ptr, ptr %data, align 4, !tbaa !17
  %321 = load i8, ptr %gpi_mon, align 1, !tbaa !16
  %call862 = call i32 @__tlv320_check(ptr noundef %320, i8 noundef zeroext 47, i8 noundef zeroext %321) #7
  %322 = load i32, ptr %err, align 4, !tbaa !11
  %add863 = add i32 %322, %call862
  store i32 %add863, ptr %err, align 4, !tbaa !11
  %323 = load ptr, ptr %data, align 4, !tbaa !17
  %324 = load i8, ptr %int_cfg, align 1, !tbaa !16
  %call864 = call i32 @__tlv320_check(ptr noundef %323, i8 noundef zeroext 50, i8 noundef zeroext %324) #7
  %325 = load i32, ptr %err, align 4, !tbaa !11
  %add865 = add i32 %325, %call864
  store i32 %add865, ptr %err, align 4, !tbaa !11
  %326 = load ptr, ptr %data, align 4, !tbaa !17
  %327 = load i8, ptr %int_mask0, align 1, !tbaa !16
  %call866 = call i32 @__tlv320_check(ptr noundef %326, i8 noundef zeroext 51, i8 noundef zeroext %327) #7
  %328 = load i32, ptr %err, align 4, !tbaa !11
  %add867 = add i32 %328, %call866
  store i32 %add867, ptr %err, align 4, !tbaa !11
  %329 = load ptr, ptr %data, align 4, !tbaa !17
  %330 = load i8, ptr %bias_cfg, align 1, !tbaa !16
  %call868 = call i32 @__tlv320_check(ptr noundef %329, i8 noundef zeroext 59, i8 noundef zeroext %330) #7
  %331 = load i32, ptr %err, align 4, !tbaa !11
  %add869 = add i32 %331, %call868
  store i32 %add869, ptr %err, align 4, !tbaa !11
  %332 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx870 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg0_t], ptr %ch_cfg0, i32 0, i32 0
  %333 = load i8, ptr %arrayidx870, align 1, !tbaa !16
  %call871 = call i32 @__tlv320_check(ptr noundef %332, i8 noundef zeroext 60, i8 noundef zeroext %333) #7
  %334 = load i32, ptr %err, align 4, !tbaa !11
  %add872 = add i32 %334, %call871
  store i32 %add872, ptr %err, align 4, !tbaa !11
  %335 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx873 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg1_t], ptr %ch_cfg1, i32 0, i32 0
  %336 = load i8, ptr %arrayidx873, align 1, !tbaa !16
  %call874 = call i32 @__tlv320_check(ptr noundef %335, i8 noundef zeroext 61, i8 noundef zeroext %336) #7
  %337 = load i32, ptr %err, align 4, !tbaa !11
  %add875 = add i32 %337, %call874
  store i32 %add875, ptr %err, align 4, !tbaa !11
  %338 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx876 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg2_t], ptr %ch_cfg2, i32 0, i32 0
  %339 = load i8, ptr %arrayidx876, align 1, !tbaa !16
  %call877 = call i32 @__tlv320_check(ptr noundef %338, i8 noundef zeroext 62, i8 noundef zeroext %339) #7
  %340 = load i32, ptr %err, align 4, !tbaa !11
  %add878 = add i32 %340, %call877
  store i32 %add878, ptr %err, align 4, !tbaa !11
  %341 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx879 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg4_t], ptr %ch_cfg4, i32 0, i32 0
  %342 = load i8, ptr %arrayidx879, align 1, !tbaa !16
  %call880 = call i32 @__tlv320_check(ptr noundef %341, i8 noundef zeroext 64, i8 noundef zeroext %342) #7
  %343 = load i32, ptr %err, align 4, !tbaa !11
  %add881 = add i32 %343, %call880
  store i32 %add881, ptr %err, align 4, !tbaa !11
  %344 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx882 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg0_t], ptr %ch_cfg0, i32 0, i32 1
  %345 = load i8, ptr %arrayidx882, align 1, !tbaa !16
  %call883 = call i32 @__tlv320_check(ptr noundef %344, i8 noundef zeroext 65, i8 noundef zeroext %345) #7
  %346 = load i32, ptr %err, align 4, !tbaa !11
  %add884 = add i32 %346, %call883
  store i32 %add884, ptr %err, align 4, !tbaa !11
  %347 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx885 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg1_t], ptr %ch_cfg1, i32 0, i32 1
  %348 = load i8, ptr %arrayidx885, align 1, !tbaa !16
  %call886 = call i32 @__tlv320_check(ptr noundef %347, i8 noundef zeroext 66, i8 noundef zeroext %348) #7
  %349 = load i32, ptr %err, align 4, !tbaa !11
  %add887 = add i32 %349, %call886
  store i32 %add887, ptr %err, align 4, !tbaa !11
  %350 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx888 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg2_t], ptr %ch_cfg2, i32 0, i32 1
  %351 = load i8, ptr %arrayidx888, align 1, !tbaa !16
  %call889 = call i32 @__tlv320_check(ptr noundef %350, i8 noundef zeroext 67, i8 noundef zeroext %351) #7
  %352 = load i32, ptr %err, align 4, !tbaa !11
  %add890 = add i32 %352, %call889
  store i32 %add890, ptr %err, align 4, !tbaa !11
  %353 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx891 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg3_t], ptr %ch_cfg3, i32 0, i32 1
  %354 = load i8, ptr %arrayidx891, align 1, !tbaa !16
  %call892 = call i32 @__tlv320_check(ptr noundef %353, i8 noundef zeroext 68, i8 noundef zeroext %354) #7
  %355 = load i32, ptr %err, align 4, !tbaa !11
  %add893 = add i32 %355, %call892
  store i32 %add893, ptr %err, align 4, !tbaa !11
  %356 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx894 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg4_t], ptr %ch_cfg4, i32 0, i32 1
  %357 = load i8, ptr %arrayidx894, align 1, !tbaa !16
  %call895 = call i32 @__tlv320_check(ptr noundef %356, i8 noundef zeroext 69, i8 noundef zeroext %357) #7
  %358 = load i32, ptr %err, align 4, !tbaa !11
  %add896 = add i32 %358, %call895
  store i32 %add896, ptr %err, align 4, !tbaa !11
  %359 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx897 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg0_t], ptr %ch_cfg0, i32 0, i32 2
  %360 = load i8, ptr %arrayidx897, align 1, !tbaa !16
  %call898 = call i32 @__tlv320_check(ptr noundef %359, i8 noundef zeroext 70, i8 noundef zeroext %360) #7
  %361 = load i32, ptr %err, align 4, !tbaa !11
  %add899 = add i32 %361, %call898
  store i32 %add899, ptr %err, align 4, !tbaa !11
  %362 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx900 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg1_t], ptr %ch_cfg1, i32 0, i32 2
  %363 = load i8, ptr %arrayidx900, align 1, !tbaa !16
  %call901 = call i32 @__tlv320_check(ptr noundef %362, i8 noundef zeroext 71, i8 noundef zeroext %363) #7
  %364 = load i32, ptr %err, align 4, !tbaa !11
  %add902 = add i32 %364, %call901
  store i32 %add902, ptr %err, align 4, !tbaa !11
  %365 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx903 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg2_t], ptr %ch_cfg2, i32 0, i32 2
  %366 = load i8, ptr %arrayidx903, align 1, !tbaa !16
  %call904 = call i32 @__tlv320_check(ptr noundef %365, i8 noundef zeroext 72, i8 noundef zeroext %366) #7
  %367 = load i32, ptr %err, align 4, !tbaa !11
  %add905 = add i32 %367, %call904
  store i32 %add905, ptr %err, align 4, !tbaa !11
  %368 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx906 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg3_t], ptr %ch_cfg3, i32 0, i32 2
  %369 = load i8, ptr %arrayidx906, align 1, !tbaa !16
  %call907 = call i32 @__tlv320_check(ptr noundef %368, i8 noundef zeroext 73, i8 noundef zeroext %369) #7
  %370 = load i32, ptr %err, align 4, !tbaa !11
  %add908 = add i32 %370, %call907
  store i32 %add908, ptr %err, align 4, !tbaa !11
  %371 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx909 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg4_t], ptr %ch_cfg4, i32 0, i32 2
  %372 = load i8, ptr %arrayidx909, align 1, !tbaa !16
  %call910 = call i32 @__tlv320_check(ptr noundef %371, i8 noundef zeroext 74, i8 noundef zeroext %372) #7
  %373 = load i32, ptr %err, align 4, !tbaa !11
  %add911 = add i32 %373, %call910
  store i32 %add911, ptr %err, align 4, !tbaa !11
  %374 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx912 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg0_t], ptr %ch_cfg0, i32 0, i32 3
  %375 = load i8, ptr %arrayidx912, align 1, !tbaa !16
  %call913 = call i32 @__tlv320_check(ptr noundef %374, i8 noundef zeroext 75, i8 noundef zeroext %375) #7
  %376 = load i32, ptr %err, align 4, !tbaa !11
  %add914 = add i32 %376, %call913
  store i32 %add914, ptr %err, align 4, !tbaa !11
  %377 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx915 = getelementptr inbounds nuw [4 x %union.tlv320_register_ch_cfg1_t], ptr %ch_cfg1, i32 0, i32 3
  %378 = load i8, ptr %arrayidx915, align 1, !tbaa !16
  %call916 = call i32 @__tlv320_check(ptr noundef %377, i8 noundef zeroext 76, i8 noundef zeroext %378) #7
  %379 = load i32, ptr %err, align 4, !tbaa !11
  %add917 = add i32 %379, %call916
  store i32 %add917, ptr %err, align 4, !tbaa !11
  %380 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx918 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg2_t], ptr %ch_cfg2, i32 0, i32 3
  %381 = load i8, ptr %arrayidx918, align 1, !tbaa !16
  %call919 = call i32 @__tlv320_check(ptr noundef %380, i8 noundef zeroext 77, i8 noundef zeroext %381) #7
  %382 = load i32, ptr %err, align 4, !tbaa !11
  %add920 = add i32 %382, %call919
  store i32 %add920, ptr %err, align 4, !tbaa !11
  %383 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx921 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg3_t], ptr %ch_cfg3, i32 0, i32 3
  %384 = load i8, ptr %arrayidx921, align 1, !tbaa !16
  %call922 = call i32 @__tlv320_check(ptr noundef %383, i8 noundef zeroext 78, i8 noundef zeroext %384) #7
  %385 = load i32, ptr %err, align 4, !tbaa !11
  %add923 = add i32 %385, %call922
  store i32 %add923, ptr %err, align 4, !tbaa !11
  %386 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx924 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg4_t], ptr %ch_cfg4, i32 0, i32 3
  %387 = load i8, ptr %arrayidx924, align 1, !tbaa !16
  %call925 = call i32 @__tlv320_check(ptr noundef %386, i8 noundef zeroext 79, i8 noundef zeroext %387) #7
  %388 = load i32, ptr %err, align 4, !tbaa !11
  %add926 = add i32 %388, %call925
  store i32 %add926, ptr %err, align 4, !tbaa !11
  %389 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx927 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg2_t], ptr %ch_cfg2, i32 0, i32 4
  %390 = load i8, ptr %arrayidx927, align 1, !tbaa !16
  %call928 = call i32 @__tlv320_check(ptr noundef %389, i8 noundef zeroext 82, i8 noundef zeroext %390) #7
  %391 = load i32, ptr %err, align 4, !tbaa !11
  %add929 = add i32 %391, %call928
  store i32 %add929, ptr %err, align 4, !tbaa !11
  %392 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx930 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg3_t], ptr %ch_cfg3, i32 0, i32 4
  %393 = load i8, ptr %arrayidx930, align 1, !tbaa !16
  %call931 = call i32 @__tlv320_check(ptr noundef %392, i8 noundef zeroext 83, i8 noundef zeroext %393) #7
  %394 = load i32, ptr %err, align 4, !tbaa !11
  %add932 = add i32 %394, %call931
  store i32 %add932, ptr %err, align 4, !tbaa !11
  %395 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx933 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg4_t], ptr %ch_cfg4, i32 0, i32 4
  %396 = load i8, ptr %arrayidx933, align 1, !tbaa !16
  %call934 = call i32 @__tlv320_check(ptr noundef %395, i8 noundef zeroext 84, i8 noundef zeroext %396) #7
  %397 = load i32, ptr %err, align 4, !tbaa !11
  %add935 = add i32 %397, %call934
  store i32 %add935, ptr %err, align 4, !tbaa !11
  %398 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx936 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg2_t], ptr %ch_cfg2, i32 0, i32 5
  %399 = load i8, ptr %arrayidx936, align 1, !tbaa !16
  %call937 = call i32 @__tlv320_check(ptr noundef %398, i8 noundef zeroext 87, i8 noundef zeroext %399) #7
  %400 = load i32, ptr %err, align 4, !tbaa !11
  %add938 = add i32 %400, %call937
  store i32 %add938, ptr %err, align 4, !tbaa !11
  %401 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx939 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg3_t], ptr %ch_cfg3, i32 0, i32 5
  %402 = load i8, ptr %arrayidx939, align 1, !tbaa !16
  %call940 = call i32 @__tlv320_check(ptr noundef %401, i8 noundef zeroext 88, i8 noundef zeroext %402) #7
  %403 = load i32, ptr %err, align 4, !tbaa !11
  %add941 = add i32 %403, %call940
  store i32 %add941, ptr %err, align 4, !tbaa !11
  %404 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx942 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg4_t], ptr %ch_cfg4, i32 0, i32 5
  %405 = load i8, ptr %arrayidx942, align 1, !tbaa !16
  %call943 = call i32 @__tlv320_check(ptr noundef %404, i8 noundef zeroext 89, i8 noundef zeroext %405) #7
  %406 = load i32, ptr %err, align 4, !tbaa !11
  %add944 = add i32 %406, %call943
  store i32 %add944, ptr %err, align 4, !tbaa !11
  %407 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx945 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg2_t], ptr %ch_cfg2, i32 0, i32 6
  %408 = load i8, ptr %arrayidx945, align 1, !tbaa !16
  %call946 = call i32 @__tlv320_check(ptr noundef %407, i8 noundef zeroext 92, i8 noundef zeroext %408) #7
  %409 = load i32, ptr %err, align 4, !tbaa !11
  %add947 = add i32 %409, %call946
  store i32 %add947, ptr %err, align 4, !tbaa !11
  %410 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx948 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg3_t], ptr %ch_cfg3, i32 0, i32 6
  %411 = load i8, ptr %arrayidx948, align 1, !tbaa !16
  %call949 = call i32 @__tlv320_check(ptr noundef %410, i8 noundef zeroext 93, i8 noundef zeroext %411) #7
  %412 = load i32, ptr %err, align 4, !tbaa !11
  %add950 = add i32 %412, %call949
  store i32 %add950, ptr %err, align 4, !tbaa !11
  %413 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx951 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg4_t], ptr %ch_cfg4, i32 0, i32 6
  %414 = load i8, ptr %arrayidx951, align 1, !tbaa !16
  %call952 = call i32 @__tlv320_check(ptr noundef %413, i8 noundef zeroext 94, i8 noundef zeroext %414) #7
  %415 = load i32, ptr %err, align 4, !tbaa !11
  %add953 = add i32 %415, %call952
  store i32 %add953, ptr %err, align 4, !tbaa !11
  %416 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx954 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg2_t], ptr %ch_cfg2, i32 0, i32 7
  %417 = load i8, ptr %arrayidx954, align 1, !tbaa !16
  %call955 = call i32 @__tlv320_check(ptr noundef %416, i8 noundef zeroext 97, i8 noundef zeroext %417) #7
  %418 = load i32, ptr %err, align 4, !tbaa !11
  %add956 = add i32 %418, %call955
  store i32 %add956, ptr %err, align 4, !tbaa !11
  %419 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx957 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg3_t], ptr %ch_cfg3, i32 0, i32 7
  %420 = load i8, ptr %arrayidx957, align 1, !tbaa !16
  %call958 = call i32 @__tlv320_check(ptr noundef %419, i8 noundef zeroext 98, i8 noundef zeroext %420) #7
  %421 = load i32, ptr %err, align 4, !tbaa !11
  %add959 = add i32 %421, %call958
  store i32 %add959, ptr %err, align 4, !tbaa !11
  %422 = load ptr, ptr %data, align 4, !tbaa !17
  %arrayidx960 = getelementptr inbounds nuw [8 x %union.tlv320_register_ch_cfg4_t], ptr %ch_cfg4, i32 0, i32 7
  %423 = load i8, ptr %arrayidx960, align 1, !tbaa !16
  %call961 = call i32 @__tlv320_check(ptr noundef %422, i8 noundef zeroext 99, i8 noundef zeroext %423) #7
  %424 = load i32, ptr %err, align 4, !tbaa !11
  %add962 = add i32 %424, %call961
  store i32 %add962, ptr %err, align 4, !tbaa !11
  %425 = load ptr, ptr %data, align 4, !tbaa !17
  %426 = load i8, ptr %dsp_cfg0, align 1, !tbaa !16
  %call963 = call i32 @__tlv320_check(ptr noundef %425, i8 noundef zeroext 107, i8 noundef zeroext %426) #7
  %427 = load i32, ptr %err, align 4, !tbaa !11
  %add964 = add i32 %427, %call963
  store i32 %add964, ptr %err, align 4, !tbaa !11
  %428 = load ptr, ptr %data, align 4, !tbaa !17
  %429 = load i8, ptr %dsp_cfg1, align 1, !tbaa !16
  %call965 = call i32 @__tlv320_check(ptr noundef %428, i8 noundef zeroext 108, i8 noundef zeroext %429) #7
  %430 = load i32, ptr %err, align 4, !tbaa !11
  %add966 = add i32 %430, %call965
  store i32 %add966, ptr %err, align 4, !tbaa !11
  %431 = load ptr, ptr %data, align 4, !tbaa !17
  %432 = load i8, ptr %dre_cfg0, align 1, !tbaa !16
  %call967 = call i32 @__tlv320_check(ptr noundef %431, i8 noundef zeroext 109, i8 noundef zeroext %432) #7
  %433 = load i32, ptr %err, align 4, !tbaa !11
  %add968 = add i32 %433, %call967
  store i32 %add968, ptr %err, align 4, !tbaa !11
  %434 = load ptr, ptr %data, align 4, !tbaa !17
  %435 = load i8, ptr %agc_cfg0, align 1, !tbaa !16
  %call969 = call i32 @__tlv320_check(ptr noundef %434, i8 noundef zeroext 112, i8 noundef zeroext %435) #7
  %436 = load i32, ptr %err, align 4, !tbaa !11
  %add970 = add i32 %436, %call969
  store i32 %add970, ptr %err, align 4, !tbaa !11
  %437 = load ptr, ptr %data, align 4, !tbaa !17
  %438 = load i8, ptr %in_ch_en, align 1, !tbaa !16
  %call971 = call i32 @__tlv320_check(ptr noundef %437, i8 noundef zeroext 115, i8 noundef zeroext %438) #7
  %439 = load i32, ptr %err, align 4, !tbaa !11
  %add972 = add i32 %439, %call971
  store i32 %add972, ptr %err, align 4, !tbaa !11
  %440 = load ptr, ptr %data, align 4, !tbaa !17
  %441 = load i8, ptr %asi_out_ch_en, align 1, !tbaa !16
  %call973 = call i32 @__tlv320_check(ptr noundef %440, i8 noundef zeroext 116, i8 noundef zeroext %441) #7
  %442 = load i32, ptr %err, align 4, !tbaa !11
  %add974 = add i32 %442, %call973
  store i32 %add974, ptr %err, align 4, !tbaa !11
  %443 = load ptr, ptr %data, align 4, !tbaa !17
  %444 = load i8, ptr %pwr_cfg, align 1, !tbaa !16
  %call975 = call i32 @__tlv320_check(ptr noundef %443, i8 noundef zeroext 117, i8 noundef zeroext %444) #7
  %445 = load i32, ptr %err, align 4, !tbaa !11
  %add976 = add i32 %445, %call975
  store i32 %add976, ptr %err, align 4, !tbaa !11
  %446 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 1, ptr %pwr_cfg) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %asi_out_ch_en) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %in_ch_en) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %agc_cfg0) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %dre_cfg0) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %dsp_cfg1) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %dsp_cfg0) #6
  call void @llvm.lifetime.end.p0(i64 8, ptr %ch_cfg4) #6
  call void @llvm.lifetime.end.p0(i64 8, ptr %ch_cfg3) #6
  call void @llvm.lifetime.end.p0(i64 8, ptr %ch_cfg2) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %ch_cfg1) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %ch_cfg0) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %bias_cfg) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %int_mask0) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %int_cfg) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %gpi_mon) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %gpi_cfg) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %gpio_mon) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %gpo_val) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %gpo_cfg) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %gpio_cfg0) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %pdmin_cfg) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %pdmclk_cfg) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %clk_src) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %mst_cfg1) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %mst_cfg0) #6
  call void @llvm.lifetime.end.p0(i64 8, ptr %asi_ch) #6
  call void @llvm.lifetime.end.p0(i64 2, ptr %asi_cfg2) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %asi_cfg1) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %asi_cfg0) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %shdn_cfg) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %sleep_cfg) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %data) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  ret i32 %446
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i32(ptr nocapture writeonly, i8, i32, i1 immarg) #3

; Function Attrs: nounwind null_pointer_is_valid optsize
define internal i32 @__tlv320_read(ptr noundef %data, i8 noundef zeroext %addr, ptr noundef %read) #0 {
entry:
  %data.addr = alloca ptr, align 4
  %addr.addr = alloca i8, align 1
  %read.addr = alloca ptr, align 4
  store ptr %data, ptr %data.addr, align 4, !tbaa !17
  store i8 %addr, ptr %addr.addr, align 1, !tbaa !16
  store ptr %read, ptr %read.addr, align 4, !tbaa !115
  %0 = load ptr, ptr %data.addr, align 4, !tbaa !17
  %i2c = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %0, i32 0, i32 1
  %1 = load ptr, ptr %read.addr, align 4, !tbaa !115
  call void @pi_i2c_write_read(ptr noundef %i2c, ptr noundef %addr.addr, ptr noundef %1, i32 noundef 1, i32 noundef 1) #7
  ret i32 0
}

; Function Attrs: nounwind null_pointer_is_valid optsize
define internal i32 @__tlv320_check(ptr noundef %data, i8 noundef zeroext %addr, i8 noundef zeroext %value) #0 {
entry:
  %data.addr = alloca ptr, align 4
  %addr.addr = alloca i8, align 1
  %value.addr = alloca i8, align 1
  %err = alloca i32, align 4
  %read = alloca i8, align 1
  store ptr %data, ptr %data.addr, align 4, !tbaa !17
  store i8 %addr, ptr %addr.addr, align 1, !tbaa !16
  store i8 %value, ptr %value.addr, align 1, !tbaa !16
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 1, ptr %read) #6
  store i8 0, ptr %read, align 1, !tbaa !16
  %0 = load ptr, ptr %data.addr, align 4, !tbaa !17
  %1 = load i8, ptr %addr.addr, align 1, !tbaa !16
  %2 = load i8, ptr %value.addr, align 1, !tbaa !16
  %call = call i32 @__tlv320_write(ptr noundef %0, i8 noundef zeroext %1, i8 noundef zeroext %2) #7
  store i32 %call, ptr %err, align 4, !tbaa !11
  %3 = load i32, ptr %err, align 4, !tbaa !11
  %tobool = icmp ne i32 %3, 0
  br i1 %tobool, label %if.end8, label %if.then

if.then:                                          ; preds = %entry
  %4 = load ptr, ptr %data.addr, align 4, !tbaa !17
  %5 = load i8, ptr %addr.addr, align 1, !tbaa !16
  %call1 = call i32 @__tlv320_read(ptr noundef %4, i8 noundef zeroext %5, ptr noundef %read) #7
  store i32 %call1, ptr %err, align 4, !tbaa !11
  %6 = load i32, ptr %err, align 4, !tbaa !11
  %tobool2 = icmp ne i32 %6, 0
  br i1 %tobool2, label %if.end7, label %if.then3

if.then3:                                         ; preds = %if.then
  %7 = load i8, ptr %read, align 1, !tbaa !16
  %conv = zext i8 %7 to i32
  %8 = load i8, ptr %value.addr, align 1, !tbaa !16
  %conv4 = zext i8 %8 to i32
  %cmp = icmp ne i32 %conv, %conv4
  br i1 %cmp, label %if.then6, label %if.end

if.then6:                                         ; preds = %if.then3
  store i32 1, ptr %err, align 4, !tbaa !11
  br label %if.end

if.end:                                           ; preds = %if.then6, %if.then3
  br label %if.end7

if.end7:                                          ; preds = %if.end, %if.then
  br label %if.end8

if.end8:                                          ; preds = %if.end7, %entry
  %9 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 1, ptr %read) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  ret i32 %9
}

; Function Attrs: nounwind null_pointer_is_valid optsize
define dso_local i32 @pi_tlv320_start(ptr noundef %device) #0 {
entry:
  %device.addr = alloca ptr, align 4
  %err = alloca i32, align 4
  %data = alloca ptr, align 4
  %pwr_cfg = alloca %union.tlv320_register_pwr_cfg_t, align 1
  store ptr %device, ptr %device.addr, align 4, !tbaa !6
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %data) #6
  %0 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %data1 = getelementptr inbounds nuw %struct.pi_device, ptr %0, i32 0, i32 2
  %1 = load ptr, ptr %data1, align 4, !tbaa !13
  store ptr %1, ptr %data, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 1, ptr %pwr_cfg) #6
  call void @llvm.memcpy.p0.p0.i32(ptr align 1 %pwr_cfg, ptr align 1 @__const.pi_tlv320_start.pwr_cfg, i32 1, i1 false)
  %2 = load ptr, ptr %data, align 4, !tbaa !17
  %call = call i32 @__tlv320_page_set(ptr noundef %2, i8 noundef zeroext 0) #7
  store i32 %call, ptr %err, align 4, !tbaa !11
  %3 = load i32, ptr %err, align 4, !tbaa !11
  %tobool = icmp ne i32 %3, 0
  br i1 %tobool, label %if.end5, label %if.then

if.then:                                          ; preds = %entry
  %4 = load ptr, ptr %data, align 4, !tbaa !17
  %5 = load i8, ptr %pwr_cfg, align 1, !tbaa !16
  %call2 = call i32 @__tlv320_write(ptr noundef %4, i8 noundef zeroext 117, i8 noundef zeroext %5) #7
  store i32 %call2, ptr %err, align 4, !tbaa !11
  %6 = load i32, ptr %err, align 4, !tbaa !11
  %tobool3 = icmp ne i32 %6, 0
  br i1 %tobool3, label %if.else, label %if.then4

if.then4:                                         ; preds = %if.then
  br label %if.end

if.else:                                          ; preds = %if.then
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then4
  br label %if.end5

if.end5:                                          ; preds = %if.end, %entry
  %7 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 1, ptr %pwr_cfg) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %data) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  ret i32 %7
}

; Function Attrs: nounwind null_pointer_is_valid optsize
define dso_local i32 @pi_tlv320_stop(ptr noundef %device) #0 {
entry:
  %device.addr = alloca ptr, align 4
  %err = alloca i32, align 4
  %data = alloca ptr, align 4
  %pwr_cfg = alloca %union.tlv320_register_pwr_cfg_t, align 1
  store ptr %device, ptr %device.addr, align 4, !tbaa !6
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 4, ptr %data) #6
  %0 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %data1 = getelementptr inbounds nuw %struct.pi_device, ptr %0, i32 0, i32 2
  %1 = load ptr, ptr %data1, align 4, !tbaa !13
  store ptr %1, ptr %data, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 1, ptr %pwr_cfg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %pwr_cfg, i8 0, i32 1, i1 false)
  %2 = load ptr, ptr %data, align 4, !tbaa !17
  %call = call i32 @__tlv320_page_set(ptr noundef %2, i8 noundef zeroext 0) #7
  store i32 %call, ptr %err, align 4, !tbaa !11
  %3 = load i32, ptr %err, align 4, !tbaa !11
  %tobool = icmp ne i32 %3, 0
  br i1 %tobool, label %if.end5, label %if.then

if.then:                                          ; preds = %entry
  %4 = load ptr, ptr %data, align 4, !tbaa !17
  %5 = load i8, ptr %pwr_cfg, align 1, !tbaa !16
  %call2 = call i32 @__tlv320_write(ptr noundef %4, i8 noundef zeroext 117, i8 noundef zeroext %5) #7
  store i32 %call2, ptr %err, align 4, !tbaa !11
  %6 = load i32, ptr %err, align 4, !tbaa !11
  %tobool3 = icmp ne i32 %6, 0
  br i1 %tobool3, label %if.else, label %if.then4

if.then4:                                         ; preds = %if.then
  br label %if.end

if.else:                                          ; preds = %if.then
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then4
  br label %if.end5

if.end5:                                          ; preds = %if.end, %entry
  %7 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 1, ptr %pwr_cfg) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %data) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  ret i32 %7
}

; Function Attrs: nounwind null_pointer_is_valid optsize
define dso_local i32 @pi_tlv320_fs_get(ptr noundef %device, ptr noundef %fs) #0 {
entry:
  %device.addr = alloca ptr, align 4
  %fs.addr = alloca ptr, align 4
  %err = alloca i32, align 4
  %sts_reg = alloca %union.tlv320_register_asi_sts_t, align 1
  store ptr %device, ptr %device.addr, align 4, !tbaa !6
  store ptr %fs, ptr %fs.addr, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 1, ptr %sts_reg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %sts_reg, i8 0, i32 1, i1 false)
  %0 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %data = getelementptr inbounds nuw %struct.pi_device, ptr %0, i32 0, i32 2
  %1 = load ptr, ptr %data, align 4, !tbaa !13
  %call = call i32 @__tlv320_read(ptr noundef %1, i8 noundef zeroext 21, ptr noundef %sts_reg) #7
  store i32 %call, ptr %err, align 4, !tbaa !11
  %2 = load i32, ptr %err, align 4, !tbaa !11
  %tobool = icmp ne i32 %2, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.end

if.else:                                          ; preds = %entry
  %bf.load = load i8, ptr %sts_reg, align 1
  %bf.lshr = lshr i8 %bf.load, 4
  %conv = zext i8 %bf.lshr to i32
  %3 = load ptr, ptr %fs.addr, align 4, !tbaa !17
  store i32 %conv, ptr %3, align 4, !tbaa !11
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %4 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 1, ptr %sts_reg) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  ret i32 %4
}

; Function Attrs: nounwind null_pointer_is_valid optsize
define dso_local i32 @pi_tlv320_bclk_fs_ratio_get(ptr noundef %device, ptr noundef %ratio) #0 {
entry:
  %device.addr = alloca ptr, align 4
  %ratio.addr = alloca ptr, align 4
  %err = alloca i32, align 4
  %sts_reg = alloca %union.tlv320_register_asi_sts_t, align 1
  store ptr %device, ptr %device.addr, align 4, !tbaa !6
  store ptr %ratio, ptr %ratio.addr, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 1, ptr %sts_reg) #6
  call void @llvm.memset.p0.i32(ptr align 1 %sts_reg, i8 0, i32 1, i1 false)
  %0 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %data = getelementptr inbounds nuw %struct.pi_device, ptr %0, i32 0, i32 2
  %1 = load ptr, ptr %data, align 4, !tbaa !13
  %call = call i32 @__tlv320_read(ptr noundef %1, i8 noundef zeroext 21, ptr noundef %sts_reg) #7
  store i32 %call, ptr %err, align 4, !tbaa !11
  %2 = load i32, ptr %err, align 4, !tbaa !11
  %tobool = icmp ne i32 %2, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  br label %if.end

if.else:                                          ; preds = %entry
  %bf.load = load i8, ptr %sts_reg, align 1
  %bf.clear = and i8 %bf.load, 15
  %conv = zext i8 %bf.clear to i32
  %3 = load ptr, ptr %ratio.addr, align 4, !tbaa !17
  store i32 %conv, ptr %3, align 4, !tbaa !11
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %4 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 1, ptr %sts_reg) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  ret i32 %4
}

; Function Attrs: nounwind null_pointer_is_valid optsize
define internal i32 @__tlv320_open(ptr noundef %device) #0 {
entry:
  %device.addr = alloca ptr, align 4
  %data = alloca ptr, align 4
  %conf = alloca ptr, align 4
  %err = alloca i32, align 4
  %i2c_conf = alloca %struct.pi_i2c_conf, align 4
  %slave_adress = alloca i8, align 1
  store ptr %device, ptr %device.addr, align 4, !tbaa !6
  call void @llvm.lifetime.start.p0(i64 4, ptr %data) #6
  %0 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %data1 = getelementptr inbounds nuw %struct.pi_device, ptr %0, i32 0, i32 2
  %1 = load ptr, ptr %data1, align 4, !tbaa !13
  store ptr %1, ptr %data, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 4, ptr %conf) #6
  %2 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %config = getelementptr inbounds nuw %struct.pi_device, ptr %2, i32 0, i32 1
  %3 = load ptr, ptr %config, align 4, !tbaa !117
  store ptr %3, ptr %conf, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  %4 = load ptr, ptr %data, align 4, !tbaa !17
  %reentrance = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %4, i32 0, i32 0
  %5 = load i8, ptr %reentrance, align 4, !tbaa !118
  %tobool = icmp ne i8 %5, 0
  br i1 %tobool, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %6 = load ptr, ptr %data, align 4, !tbaa !17
  %reentrance2 = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %6, i32 0, i32 0
  %7 = load i8, ptr %reentrance2, align 4, !tbaa !118
  %inc = add i8 %7, 1
  store i8 %inc, ptr %reentrance2, align 4, !tbaa !118
  br label %if.end27

if.else:                                          ; preds = %entry
  %8 = load ptr, ptr %conf, align 4, !tbaa !17
  %bsp_open = getelementptr inbounds nuw %struct.pi_tlv320_conf_t, ptr %8, i32 0, i32 4
  %9 = load ptr, ptr %bsp_open, align 4, !tbaa !120
  %tobool3 = icmp ne ptr %9, null
  br i1 %tobool3, label %if.then4, label %if.end

if.then4:                                         ; preds = %if.else
  %10 = load ptr, ptr %conf, align 4, !tbaa !17
  %bsp_open5 = getelementptr inbounds nuw %struct.pi_tlv320_conf_t, ptr %10, i32 0, i32 4
  %11 = load ptr, ptr %bsp_open5, align 4, !tbaa !120
  %12 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %call = call i32 %11(ptr noundef %12) #7
  store i32 %call, ptr %err, align 4, !tbaa !11
  br label %if.end

if.end:                                           ; preds = %if.then4, %if.else
  %13 = load i32, ptr %err, align 4, !tbaa !11
  %tobool6 = icmp ne i32 %13, 0
  br i1 %tobool6, label %if.end26, label %if.then7

if.then7:                                         ; preds = %if.end
  call void @llvm.lifetime.start.p0(i64 16, ptr %i2c_conf) #6
  call void @pi_i2c_conf_init(ptr noundef %i2c_conf) #7
  %14 = load ptr, ptr %conf, align 4, !tbaa !17
  %i2c_itf = getelementptr inbounds nuw %struct.pi_tlv320_conf_t, ptr %14, i32 0, i32 0
  %15 = load i8, ptr %i2c_itf, align 4, !tbaa !122
  %itf = getelementptr inbounds nuw %struct.pi_i2c_conf, ptr %i2c_conf, i32 0, i32 0
  store i8 %15, ptr %itf, align 4, !tbaa !123
  call void @llvm.lifetime.start.p0(i64 1, ptr %slave_adress) #6
  %16 = load ptr, ptr %conf, align 4, !tbaa !17
  %call8 = call zeroext i8 @__tlv320_slave_address_get(ptr noundef %16) #7
  store i8 %call8, ptr %slave_adress, align 1, !tbaa !16
  %17 = load i8, ptr %slave_adress, align 1, !tbaa !16
  %conv = zext i8 %17 to i32
  %shl = shl i32 %conv, 1
  %conv9 = trunc i32 %shl to i16
  call void @pi_i2c_conf_set_slave_addr(ptr noundef %i2c_conf, i16 noundef zeroext %conv9, i8 noundef signext 0) #7
  %18 = load ptr, ptr %data, align 4, !tbaa !17
  %i2c = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %18, i32 0, i32 1
  call void @pi_open_from_conf(ptr noundef %i2c, ptr noundef %i2c_conf) #7
  %19 = load ptr, ptr %data, align 4, !tbaa !17
  %i2c10 = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %19, i32 0, i32 1
  %call11 = call i32 @pi_i2c_open(ptr noundef %i2c10) #7
  store i32 %call11, ptr %err, align 4, !tbaa !11
  %20 = load i32, ptr %err, align 4, !tbaa !11
  %tobool12 = icmp ne i32 %20, 0
  br i1 %tobool12, label %if.else24, label %if.then13

if.then13:                                        ; preds = %if.then7
  %21 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %call14 = call i32 @pi_tlv320_reset(ptr noundef %21) #7
  store i32 %call14, ptr %err, align 4, !tbaa !11
  %22 = load i32, ptr %err, align 4, !tbaa !11
  %tobool15 = icmp ne i32 %22, 0
  br i1 %tobool15, label %if.end23, label %if.then16

if.then16:                                        ; preds = %if.then13
  %23 = load ptr, ptr %data, align 4, !tbaa !17
  %call17 = call i32 @__tlv320_check_default(ptr noundef %23) #7
  store i32 %call17, ptr %err, align 4, !tbaa !11
  %24 = load i32, ptr %err, align 4, !tbaa !11
  %tobool18 = icmp ne i32 %24, 0
  br i1 %tobool18, label %if.end22, label %if.then19

if.then19:                                        ; preds = %if.then16
  %25 = load ptr, ptr %data, align 4, !tbaa !17
  %reentrance20 = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %25, i32 0, i32 0
  %26 = load i8, ptr %reentrance20, align 4, !tbaa !118
  %inc21 = add i8 %26, 1
  store i8 %inc21, ptr %reentrance20, align 4, !tbaa !118
  br label %if.end22

if.end22:                                         ; preds = %if.then19, %if.then16
  br label %if.end23

if.end23:                                         ; preds = %if.end22, %if.then13
  br label %if.end25

if.else24:                                        ; preds = %if.then7
  br label %if.end25

if.end25:                                         ; preds = %if.else24, %if.end23
  call void @llvm.lifetime.end.p0(i64 1, ptr %slave_adress) #6
  call void @llvm.lifetime.end.p0(i64 16, ptr %i2c_conf) #6
  br label %if.end26

if.end26:                                         ; preds = %if.end25, %if.end
  br label %if.end27

if.end27:                                         ; preds = %if.end26, %if.then
  %27 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %conf) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %data) #6
  ret i32 %27
}

; Function Attrs: nounwind null_pointer_is_valid optsize
define internal i32 @__tlv320_close(ptr noundef %device) #0 {
entry:
  %device.addr = alloca ptr, align 4
  %data = alloca ptr, align 4
  %conf = alloca ptr, align 4
  %err = alloca i32, align 4
  store ptr %device, ptr %device.addr, align 4, !tbaa !6
  call void @llvm.lifetime.start.p0(i64 4, ptr %data) #6
  %0 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %data1 = getelementptr inbounds nuw %struct.pi_device, ptr %0, i32 0, i32 2
  %1 = load ptr, ptr %data1, align 4, !tbaa !13
  store ptr %1, ptr %data, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 4, ptr %conf) #6
  %2 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %config = getelementptr inbounds nuw %struct.pi_device, ptr %2, i32 0, i32 1
  %3 = load ptr, ptr %config, align 4, !tbaa !117
  store ptr %3, ptr %conf, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  %4 = load ptr, ptr %data, align 4, !tbaa !17
  %reentrance = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %4, i32 0, i32 0
  %5 = load i8, ptr %reentrance, align 4, !tbaa !118
  %conv = zext i8 %5 to i32
  %cmp = icmp sgt i32 %conv, 0
  br i1 %cmp, label %if.then, label %if.end12

if.then:                                          ; preds = %entry
  %6 = load ptr, ptr %data, align 4, !tbaa !17
  %reentrance3 = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %6, i32 0, i32 0
  %7 = load i8, ptr %reentrance3, align 4, !tbaa !118
  %dec = add i8 %7, -1
  store i8 %dec, ptr %reentrance3, align 4, !tbaa !118
  %8 = load ptr, ptr %data, align 4, !tbaa !17
  %reentrance4 = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %8, i32 0, i32 0
  %9 = load i8, ptr %reentrance4, align 4, !tbaa !118
  %conv5 = zext i8 %9 to i32
  %cmp6 = icmp eq i32 %conv5, 0
  br i1 %cmp6, label %if.then8, label %if.else

if.then8:                                         ; preds = %if.then
  %10 = load ptr, ptr %data, align 4, !tbaa !17
  %i2c = getelementptr inbounds nuw %struct.pi_tlv320_data_t, ptr %10, i32 0, i32 1
  call void @pi_i2c_close(ptr noundef %i2c) #7
  %11 = load ptr, ptr %conf, align 4, !tbaa !17
  %bsp_close = getelementptr inbounds nuw %struct.pi_tlv320_conf_t, ptr %11, i32 0, i32 5
  %12 = load ptr, ptr %bsp_close, align 4, !tbaa !126
  %tobool = icmp ne ptr %12, null
  br i1 %tobool, label %if.then9, label %if.end

if.then9:                                         ; preds = %if.then8
  %13 = load ptr, ptr %conf, align 4, !tbaa !17
  %bsp_close10 = getelementptr inbounds nuw %struct.pi_tlv320_conf_t, ptr %13, i32 0, i32 5
  %14 = load ptr, ptr %bsp_close10, align 4, !tbaa !126
  %15 = load ptr, ptr %device.addr, align 4, !tbaa !6
  %call = call i32 %14(ptr noundef %15) #7
  store i32 %call, ptr %err, align 4, !tbaa !11
  br label %if.end

if.end:                                           ; preds = %if.then9, %if.then8
  br label %if.end11

if.else:                                          ; preds = %if.then
  br label %if.end11

if.end11:                                         ; preds = %if.else, %if.end
  br label %if.end12

if.end12:                                         ; preds = %if.end11, %entry
  %16 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %conf) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %data) #6
  ret i32 %16
}

; Function Attrs: null_pointer_is_valid optsize
declare dso_local i32 @pi_i2c_write(ptr noundef, ptr noundef, i32 noundef, i32 noundef) #4

; Function Attrs: null_pointer_is_valid optsize
declare dso_local void @pi_i2c_write_read(ptr noundef, ptr noundef, ptr noundef, i32 noundef, i32 noundef) #4

; Function Attrs: null_pointer_is_valid optsize
declare dso_local void @pi_i2c_conf_init(ptr noundef) #4

; Function Attrs: inlinehint nounwind null_pointer_is_valid optsize
define internal zeroext i8 @__tlv320_slave_address_get(ptr noundef %conf) #5 {
entry:
  %conf.addr = alloca ptr, align 4
  store ptr %conf, ptr %conf.addr, align 4, !tbaa !17
  %0 = load ptr, ptr %conf.addr, align 4, !tbaa !17
  %addr0_sclk = getelementptr inbounds nuw %struct.pi_tlv320_conf_t, ptr %0, i32 0, i32 2
  %1 = load i8, ptr %addr0_sclk, align 2, !tbaa !127
  %conv = zext i8 %1 to i32
  %or = or i32 76, %conv
  %2 = load ptr, ptr %conf.addr, align 4, !tbaa !17
  %addr1_miso = getelementptr inbounds nuw %struct.pi_tlv320_conf_t, ptr %2, i32 0, i32 3
  %3 = load i8, ptr %addr1_miso, align 1, !tbaa !128
  %conv1 = zext i8 %3 to i32
  %shl = shl i32 %conv1, 1
  %or2 = or i32 %or, %shl
  %conv3 = trunc i32 %or2 to i8
  ret i8 %conv3
}

; Function Attrs: null_pointer_is_valid optsize
declare dso_local void @pi_i2c_conf_set_slave_addr(ptr noundef, i16 noundef zeroext, i8 noundef signext) #4

; Function Attrs: null_pointer_is_valid optsize
declare dso_local void @pi_open_from_conf(ptr noundef, ptr noundef) #4

; Function Attrs: null_pointer_is_valid optsize
declare dso_local i32 @pi_i2c_open(ptr noundef) #4

; Function Attrs: nounwind null_pointer_is_valid optsize
define internal i32 @__tlv320_check_default(ptr noundef %data) #0 {
entry:
  %data.addr = alloca ptr, align 4
  %err = alloca i32, align 4
  %ch1_cfg2_reg = alloca i8, align 1
  %ch1_cfg3_reg = alloca i8, align 1
  store ptr %data, ptr %data.addr, align 4, !tbaa !17
  call void @llvm.lifetime.start.p0(i64 4, ptr %err) #6
  store i32 0, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.start.p0(i64 1, ptr %ch1_cfg2_reg) #6
  store i8 0, ptr %ch1_cfg2_reg, align 1, !tbaa !16
  call void @llvm.lifetime.start.p0(i64 1, ptr %ch1_cfg3_reg) #6
  store i8 0, ptr %ch1_cfg3_reg, align 1, !tbaa !16
  %0 = load ptr, ptr %data.addr, align 4, !tbaa !17
  %call = call i32 @__tlv320_page_set(ptr noundef %0, i8 noundef zeroext 0) #7
  store i32 %call, ptr %err, align 4, !tbaa !11
  %1 = load i32, ptr %err, align 4, !tbaa !11
  %tobool = icmp ne i32 %1, 0
  br i1 %tobool, label %if.end11, label %if.then

if.then:                                          ; preds = %entry
  %2 = load ptr, ptr %data.addr, align 4, !tbaa !17
  %call1 = call i32 @__tlv320_read(ptr noundef %2, i8 noundef zeroext 62, ptr noundef %ch1_cfg2_reg) #7
  store i32 %call1, ptr %err, align 4, !tbaa !11
  %3 = load ptr, ptr %data.addr, align 4, !tbaa !17
  %call2 = call i32 @__tlv320_read(ptr noundef %3, i8 noundef zeroext 63, ptr noundef %ch1_cfg3_reg) #7
  %4 = load i32, ptr %err, align 4, !tbaa !11
  %add = add i32 %4, %call2
  store i32 %add, ptr %err, align 4, !tbaa !11
  %5 = load i32, ptr %err, align 4, !tbaa !11
  %tobool3 = icmp ne i32 %5, 0
  br i1 %tobool3, label %if.end10, label %if.then4

if.then4:                                         ; preds = %if.then
  %6 = load i8, ptr %ch1_cfg2_reg, align 1, !tbaa !16
  %conv = zext i8 %6 to i32
  %cmp = icmp ne i32 201, %conv
  br i1 %cmp, label %if.then9, label %lor.lhs.false

lor.lhs.false:                                    ; preds = %if.then4
  %7 = load i8, ptr %ch1_cfg3_reg, align 1, !tbaa !16
  %conv6 = zext i8 %7 to i32
  %cmp7 = icmp ne i32 128, %conv6
  br i1 %cmp7, label %if.then9, label %if.end

if.then9:                                         ; preds = %lor.lhs.false, %if.then4
  store i32 1, ptr %err, align 4, !tbaa !11
  br label %if.end

if.end:                                           ; preds = %if.then9, %lor.lhs.false
  br label %if.end10

if.end10:                                         ; preds = %if.end, %if.then
  br label %if.end11

if.end11:                                         ; preds = %if.end10, %entry
  %8 = load i32, ptr %err, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0(i64 1, ptr %ch1_cfg3_reg) #6
  call void @llvm.lifetime.end.p0(i64 1, ptr %ch1_cfg2_reg) #6
  call void @llvm.lifetime.end.p0(i64 4, ptr %err) #6
  ret i32 %8
}

; Function Attrs: null_pointer_is_valid optsize
declare dso_local void @pi_i2c_close(ptr noundef) #4

attributes #0 = { nounwind null_pointer_is_valid optsize "no-jump-tables"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+xpulpv,+zfinx,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-relax,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #4 = { null_pointer_is_valid optsize "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+xpulpv,+zfinx,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-relax,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #5 = { inlinehint nounwind null_pointer_is_valid optsize "no-jump-tables"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv32" "target-features"="+32bit,+c,+m,+xpulpv,+zfinx,+zicsr,+zmmul,-a,-b,-d,-e,-experimental-sdext,-experimental-sdtrig,-experimental-smctr,-experimental-ssctr,-experimental-svukte,-experimental-xqcia,-experimental-xqciac,-experimental-xqcicli,-experimental-xqcicm,-experimental-xqcics,-experimental-xqcicsr,-experimental-xqciint,-experimental-xqcilo,-experimental-xqcilsm,-experimental-xqcisls,-experimental-zalasr,-experimental-zicfilp,-experimental-zicfiss,-experimental-zvbc32e,-experimental-zvkgs,-f,-h,-relax,-sha,-shcounterenw,-shgatpa,-shtvala,-shvsatpa,-shvstvala,-shvstvecd,-smaia,-smcdeleg,-smcsrind,-smdbltrp,-smepmp,-smmpm,-smnpm,-smrnmi,-smstateen,-ssaia,-ssccfg,-ssccptr,-sscofpmf,-sscounterenw,-sscsrind,-ssdbltrp,-ssnpm,-sspm,-ssqosid,-ssstateen,-ssstrict,-sstc,-sstvala,-sstvecd,-ssu64xl,-supm,-svade,-svadu,-svbare,-svinval,-svnapot,-svpbmt,-svvptc,-v,-xcvalu,-xcvbi,-xcvbitmanip,-xcvelw,-xcvmac,-xcvmem,-xcvsimd,-xdma,-xfalthalf,-xfaltquarter,-xfauxalthalf,-xfauxaltquarter,-xfauxhalf,-xfauxquarter,-xfauxvecalthalf,-xfauxvecaltquarter,-xfauxvechalf,-xfauxvecquarter,-xfauxvecsingle,-xfexpauxvecalthalf,-xfexpauxvecaltquarter,-xfexpauxvechalf,-xfexpauxvecquarter,-xfquarter,-xfrep,-xfvecalthalf,-xfvecaltquarter,-xfvechalf,-xfvecquarter,-xfvecsingle,-xmempool,-xmipscmove,-xmipslsp,-xsfcease,-xsfvcp,-xsfvfnrclipxfqf,-xsfvfwmaccqqq,-xsfvqmaccdod,-xsfvqmaccqoq,-xsifivecdiscarddlone,-xsifivecflushdlone,-xssr,-xtheadba,-xtheadbb,-xtheadbs,-xtheadcmo,-xtheadcondmov,-xtheadfmemidx,-xtheadmac,-xtheadmemidx,-xtheadmempair,-xtheadsync,-xtheadvdot,-xventanacondops,-xwchc,-za128rs,-za64rs,-zaamo,-zabha,-zacas,-zalrsc,-zama16b,-zawrs,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zca,-zcb,-zcd,-zce,-zcf,-zcmop,-zcmp,-zcmt,-zdinx,-zfa,-zfbfmin,-zfh,-zfhmin,-zhinx,-zhinxmin,-zic64b,-zicbom,-zicbop,-zicboz,-ziccamoa,-ziccif,-zicclsm,-ziccrse,-zicntr,-zicond,-zifencei,-zihintntl,-zihintpause,-zihpm,-zimop,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-ztso,-zvbb,-zvbc,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvfbfmin,-zvfbfwma,-zvfh,-zvfhmin,-zvkb,-zvkg,-zvkn,-zvknc,-zvkned,-zvkng,-zvknha,-zvknhb,-zvks,-zvksc,-zvksed,-zvksg,-zvksh,-zvkt,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #6 = { nounwind }
attributes #7 = { optsize }

!llvm.module.flags = !{!0, !1, !2, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"target-abi", !"ilp32"}
!2 = !{i32 6, !"riscv-isa", !3}
!3 = !{!"rv32i2p1_m2p0_c2p0_zicsr2p0_zmmul1p0_zfinx1p0_xpulpv2p0"}
!4 = !{i32 8, !"SmallDataLimit", i32 0}
!5 = !{!"clang version 20.1.8 (https://github.com/albsposito/llvm-project.git 7459255b6120075684cf3aef0b310567d60b5f80)"}
!6 = !{!7, !7, i64 0}
!7 = !{!"p1 _ZTS9pi_device", !8, i64 0}
!8 = !{!"any pointer", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C/C++ TBAA"}
!11 = !{!12, !12, i64 0}
!12 = !{!"int", !9, i64 0}
!13 = !{!14, !8, i64 8}
!14 = !{!"pi_device", !15, i64 0, !8, i64 4, !8, i64 8}
!15 = !{!"p1 _ZTS13pi_device_api", !8, i64 0}
!16 = !{!9, !9, i64 0}
!17 = !{!8, !8, i64 0}
!18 = !{!19, !12, i64 0}
!19 = !{!"", !20, i64 0, !21, i64 20, !24, i64 132, !25, i64 176, !26, i64 204, !27, i64 220, !28, i64 232, !26, i64 240, !9, i64 256, !9, i64 288, !9, i64 336}
!20 = !{!"", !12, i64 0, !12, i64 4, !12, i64 8, !12, i64 12, !12, i64 16}
!21 = !{!"", !12, i64 0, !12, i64 4, !12, i64 8, !12, i64 12, !12, i64 16, !22, i64 20, !12, i64 40, !12, i64 44, !12, i64 48, !23, i64 52, !12, i64 76, !12, i64 80, !12, i64 84, !12, i64 88, !12, i64 92, !9, i64 96}
!22 = !{!"", !12, i64 0, !12, i64 4, !12, i64 8, !12, i64 12, !9, i64 16}
!23 = !{!"", !12, i64 0, !12, i64 4, !12, i64 8, !12, i64 12, !12, i64 16, !12, i64 20}
!24 = !{!"", !12, i64 0, !12, i64 4, !12, i64 8, !12, i64 12, !12, i64 16, !12, i64 20, !12, i64 24, !12, i64 28, !12, i64 32, !12, i64 36, !12, i64 40}
!25 = !{!"", !12, i64 0, !12, i64 4, !12, i64 8, !12, i64 12, !12, i64 16, !12, i64 20, !12, i64 24}
!26 = !{!"", !12, i64 0, !12, i64 4, !12, i64 8, !12, i64 12}
!27 = !{!"", !12, i64 0, !12, i64 4, !12, i64 8}
!28 = !{!"", !12, i64 0, !12, i64 4}
!29 = !{!19, !12, i64 4}
!30 = !{!19, !12, i64 8}
!31 = !{!19, !12, i64 12}
!32 = !{!19, !12, i64 16}
!33 = !{!19, !12, i64 20}
!34 = !{!19, !12, i64 24}
!35 = !{!19, !12, i64 28}
!36 = !{!19, !12, i64 32}
!37 = !{!19, !12, i64 36}
!38 = !{!19, !12, i64 40}
!39 = !{!19, !12, i64 44}
!40 = !{!19, !12, i64 48}
!41 = !{!19, !12, i64 52}
!42 = !{!19, !9, i64 56}
!43 = !{!19, !12, i64 60}
!44 = !{!19, !12, i64 64}
!45 = !{!19, !12, i64 68}
!46 = !{!19, !12, i64 72}
!47 = !{!19, !12, i64 76}
!48 = !{!19, !12, i64 80}
!49 = !{!19, !12, i64 84}
!50 = !{!19, !12, i64 88}
!51 = !{!19, !12, i64 92}
!52 = !{!19, !12, i64 96}
!53 = !{!19, !12, i64 100}
!54 = !{!19, !12, i64 104}
!55 = !{!19, !12, i64 108}
!56 = !{!19, !12, i64 112}
!57 = distinct !{!57, !58}
!58 = !{!"llvm.loop.mustprogress"}
!59 = !{!19, !12, i64 132}
!60 = !{!19, !12, i64 136}
!61 = !{!19, !12, i64 140}
!62 = !{!19, !12, i64 144}
!63 = !{!19, !12, i64 148}
!64 = !{!19, !12, i64 152}
!65 = !{!19, !12, i64 156}
!66 = !{!19, !12, i64 160}
!67 = !{!19, !12, i64 164}
!68 = !{!19, !12, i64 168}
!69 = !{!19, !12, i64 172}
!70 = !{!19, !12, i64 176}
!71 = !{!19, !12, i64 180}
!72 = !{!19, !12, i64 184}
!73 = !{!19, !12, i64 188}
!74 = !{!19, !12, i64 192}
!75 = !{!19, !12, i64 196}
!76 = !{!19, !12, i64 200}
!77 = !{!19, !12, i64 204}
!78 = !{!19, !12, i64 208}
!79 = !{!19, !12, i64 212}
!80 = !{!19, !12, i64 216}
!81 = !{!19, !12, i64 220}
!82 = !{!19, !12, i64 224}
!83 = !{!19, !12, i64 228}
!84 = !{!19, !12, i64 232}
!85 = !{!19, !12, i64 236}
!86 = !{!19, !12, i64 240}
!87 = !{!19, !12, i64 244}
!88 = !{!19, !12, i64 248}
!89 = !{!19, !12, i64 252}
!90 = !{!28, !12, i64 0}
!91 = !{!28, !12, i64 4}
!92 = !{!27, !12, i64 0}
!93 = !{!27, !12, i64 4}
!94 = distinct !{!94, !58}
!95 = !{!96, !12, i64 0}
!96 = !{!"", !12, i64 0, !12, i64 4, !12, i64 8, !9, i64 12, !9, i64 13, !9, i64 14, !9, i64 15, !97, i64 16, !12, i64 24, !12, i64 28, !12, i64 32, !12, i64 36}
!97 = !{!"", !12, i64 0, !9, i64 4}
!98 = !{!96, !12, i64 24}
!99 = !{!96, !12, i64 28}
!100 = !{!96, !12, i64 32}
!101 = !{!96, !12, i64 36}
!102 = !{!96, !9, i64 12}
!103 = !{!96, !12, i64 4}
!104 = !{!96, !12, i64 8}
!105 = !{!96, !9, i64 13}
!106 = !{!96, !9, i64 14}
!107 = !{!96, !9, i64 15}
!108 = !{!96, !12, i64 16}
!109 = !{!96, !9, i64 20}
!110 = distinct !{!110, !58}
!111 = distinct !{!111, !58}
!112 = distinct !{!112, !58}
!113 = !{!27, !12, i64 8}
!114 = distinct !{!114, !58}
!115 = !{!116, !116, i64 0}
!116 = !{!"p1 omnipotent char", !8, i64 0}
!117 = !{!14, !8, i64 4}
!118 = !{!119, !9, i64 0}
!119 = !{!"", !9, i64 0, !14, i64 4}
!120 = !{!121, !8, i64 4}
!121 = !{!"", !9, i64 0, !9, i64 1, !9, i64 2, !9, i64 3, !8, i64 4, !8, i64 8, !8, i64 12, !8, i64 16, !8, i64 20}
!122 = !{!121, !9, i64 0}
!123 = !{!124, !9, i64 0}
!124 = !{!"pi_i2c_conf", !9, i64 0, !125, i64 2, !9, i64 4, !125, i64 6, !12, i64 8, !9, i64 12, !9, i64 13}
!125 = !{!"short", !9, i64 0}
!126 = !{!121, !8, i64 8}
!127 = !{!121, !9, i64 2}
!128 = !{!121, !9, i64 3}
