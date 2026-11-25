import { createHash } from "node:crypto";
import { sbRest, sbStorageSign } from "./api.mjs";
import { createLineClient } from "./client.mjs";

function reportType(value) {
  return String(value || "").split("~", 1)[0];
}

function bamMa(ma) {
  return createHash("sha256").update(String(ma).trim()).digest("hex");
}

function layGioVietNam() {
  const parts = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Ho_Chi_Minh",
    weekday: "short",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    hourCycle: "h23",
  }).formatToParts(new Date());
  const get = (type) => parts.find((p) => p.type === type)?.value || "";
  const thuMap = { Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6, Sun: 7 };
  const gio = `${get("hour")}:${get("minute")}`;
  return { thu: thuMap[get("weekday")] || 1, gio, ngay: `${get("year")}-${get("month")}-${get("day")}` };
}

function ngayVietNam(value) {
  const parts = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Asia/Ho_Chi_Minh",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).formatToParts(new Date(value));
  const get = (type) => parts.find((p) => p.type === type)?.value || "";
  return `${get("year")}-${get("month")}-${get("day")}`;
}

function soPhut(gio) {
  const [h, m] = String(gio || "00:00").slice(0, 5).split(":").map(Number);
  return h * 60 + m;
}

function hienThiNgay(khoaNgay) {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(String(khoaNgay || ""));
  return match ? `${match[3]}/${match[2]}/${match[1]}` : String(khoaNgay || "");
}

function so(v) {
  const n = typeof v === "number" ? v : Number(v);
  return Number.isFinite(n) ? n : 0;
}

function dinhDangSo(value, toiDa = 2) {
  return new Intl.NumberFormat("vi-VN", {
    minimumFractionDigits: 0,
    maximumFractionDigits: toiDa,
  }).format(value);
}

function dinhDangPhanTram(value) {
  return `${dinhDangSo(value, 1)}%`;
}

async function stillActive(id) {
  const data = await sbRest("dmx_line_lich_gui", {
    query: {
      select: "id,dmx_line_nhom!inner(dang_hoat_dong)",
      id: `eq.${id}`,
      dang_hoat_dong: "eq.true",
      "dmx_line_nhom.dang_hoat_dong": "eq.true",
    },
    single: true,
  });
  return Boolean(data?.id);
}

async function mark(id) {
  await sbRest("dmx_line_lich_gui", {
    method: "PATCH",
    query: { id: `eq.${id}` },
    body: { lan_gui_cuoi: new Date().toISOString() },
  });
}

async function ganNhom(ma, lineGroupId, tenNhom) {
  const maGan = await sbRest("dmx_line_ma_gan_nhom", {
    query: {
      select: "nguoi_dung_id",
      ma_hash: `eq.${bamMa(ma)}`,
      het_han: `gt.${new Date().toISOString()}`,
    },
    single: true,
  });
  if (!maGan?.nguoi_dung_id) throw new Error("Mã gắn nhóm không đúng hoặc đã hết hạn.");
  await sbRest("dmx_line_nhom", {
    method: "POST",
    query: { on_conflict: "line_group_id,nguoi_dung_id" },
    prefer: "resolution=merge-duplicates",
    body: {
      line_group_id: lineGroupId,
      nguoi_dung_id: maGan.nguoi_dung_id,
      ten_nhom: String(tenNhom || "Nhóm LINE").slice(0, 120),
      dang_hoat_dong: true,
      ngay_cap_nhat: new Date().toISOString(),
    },
  });
  await sbRest("dmx_line_ma_gan_nhom", {
    method: "DELETE",
    query: { ma_hash: `eq.${bamMa(ma)}` },
  });
}

async function layLichDenHan() {
  const { thu, gio, ngay } = layGioVietNam();
  const data = await sbRest("dmx_line_lich_gui", {
    query: {
      select: "id,line_group_id,nguoi_dung_id,sieu_thi_id,gio,cac_thu,cac_noi_dung,kieu_gui,lan_gui_cuoi,dmx_line_nhom!inner(dang_hoat_dong,ten_nhom)",
      dang_hoat_dong: "eq.true",
      "dmx_line_nhom.dang_hoat_dong": "eq.true",
      cac_thu: `cs.{${thu}}`,
    },
  });
  const phutHienTai = soPhut(gio);
  return (data || []).filter((item) => {
    if (soPhut(item.gio) > phutHienTai) return false;
    return !item.lan_gui_cuoi || ngayVietNam(item.lan_gui_cuoi) !== ngay;
  });
}

async function kiemTraAnhMoi(lineGroupId, nguoiDungId, sieuThiId, loai, phienBanAnh) {
  const data = await sbRest("dmx_line_anh_da_gui", {
    query: {
      select: "phien_ban_anh,ngay_gui",
      line_group_id: `eq.${lineGroupId}`,
      nguoi_dung_id: `eq.${nguoiDungId}`,
      sieu_thi_id: `eq.${sieuThiId}`,
      loai: `eq.${loai}`,
    },
    single: true,
  });
  const ngayHienTai = layGioVietNam().ngay;
  const daGuiHomNay = Boolean(data?.ngay_gui) && ngayVietNam(data.ngay_gui) === ngayHienTai;
  return !(daGuiHomNay && data?.phien_ban_anh === phienBanAnh);
}

async function danhDauAnhDaGui(lineGroupId, nguoiDungId, sieuThiId, loai, phienBanAnh) {
  await sbRest("dmx_line_anh_da_gui", {
    method: "POST",
    query: { on_conflict: "line_group_id,nguoi_dung_id,sieu_thi_id,loai" },
    prefer: "resolution=merge-duplicates",
    body: {
      line_group_id: lineGroupId,
      nguoi_dung_id: nguoiDungId,
      sieu_thi_id: sieuThiId,
      loai,
      phien_ban_anh: phienBanAnh,
      ngay_gui: new Date().toISOString(),
    },
  });
}

async function taiBaoCaoTuSupabase(loai, userId, sieuThiId) {
  const banGhiNgay = await sbRest("dmx_du_lieu_ngay", {
    query: {
      select: "ngay,du_lieu,ngay_cap_nhat",
      nguoi_dung_id: `eq.${userId}`,
      sieu_thi_id: `eq.${sieuThiId}`,
      order: "ngay_cap_nhat.desc",
      limit: "1",
    },
    single: true,
  });
  const ngay = String(banGhiNgay?.ngay || layGioVietNam().ngay);
  const ngayHienThi = hienThiNgay(ngay);
  const duLieu = banGhiNgay?.du_lieu || {};
  const luyKe = duLieu.doanhThu || {};
  const realtime = duLieu.doanhThuRealtime || {};
  const donVi = String(duLieu.thongTinDonVi || "ĐIỆN MÁY XANH").trim();

  const loaiAnhMap = {
    tongquan: "luyke_du_kien",
    doanhthu: "luyke_du_kien",
    luyke: "doanhthu_thidua_luyke",
    thidua: "doanhthu_thidua_luyke",
    realtime: "doanhthu_thidua_realtime",
    nhanvien: "xep_hang_nv_luyke",
    suckhoe: "bieu_do_suc_khoe_nv",
  };
  const loaiAnh = loaiAnhMap[loai] || loai;
  let anhRow = await sbRest("dmx_line_anh_bao_cao", {
    query: {
      select: "ngay,nha_cung_cap,duong_dan_luu_tru,url_ben_ngoai,ngay_cap_nhat",
      nguoi_dung_id: `eq.${userId}`,
      sieu_thi_id: `eq.${sieuThiId}`,
      loai: `eq.${loaiAnh}`,
      ngay: `eq.${ngay}`,
    },
    single: true,
  });
  if (!anhRow) {
    anhRow = await sbRest("dmx_line_anh_bao_cao", {
      query: {
        select: "ngay,nha_cung_cap,duong_dan_luu_tru,url_ben_ngoai,ngay_cap_nhat",
        nguoi_dung_id: `eq.${userId}`,
        sieu_thi_id: `eq.${sieuThiId}`,
        loai: `eq.${loaiAnh}`,
        order: "ngay_cap_nhat.desc",
        limit: "1",
      },
      single: true,
    });
  }

  let imageUrl = "";
  if (anhRow?.nha_cung_cap === "google_drive" && anhRow?.url_ben_ngoai) {
    imageUrl = String(anhRow.url_ben_ngoai);
  } else if (anhRow?.duong_dan_luu_tru) {
    imageUrl = await sbStorageSign("dmx-du-lieu", anhRow.duong_dan_luu_tru, 1800);
  }

  const tieuDeMap = {
    luyke_du_kien: "DOANH THU LŨY KẾ",
    doanhthu_thidua_luyke: "DOANH THU & THI ĐUA LŨY KẾ",
    doanhthu_thidua_realtime: "DOANH THU & THI ĐUA REALTIME",
    xep_hang_nv_luyke: "XẾP HẠNG NHÂN VIÊN LŨY KẾ",
    xep_hang_nv_realtime: "XẾP HẠNG NHÂN VIÊN REALTIME",
    bieu_do_realtime_thang: "BIỂU ĐỒ REALTIME THÁNG",
    bieu_do_suc_khoe_nv: "SỨC KHỎE ĐỘI NGŨ",
  };
  const tieuDe = tieuDeMap[loaiAnh] || "BÁO CÁO DMX";
  const dtLK = so(luyKe.doanhThuThuc);
  const qdLK = so(luyKe.doanhThuQuyDoi);
  const dtRT = so(realtime.doanhThuThuc);
  const qdRT = so(realtime.doanhThuQuyDoi);
  const fullText = [
    `${tieuDe} ${ngayHienThi}`,
    donVi,
    `• Lũy kế: DT ${dinhDangSo(dtLK)} | QĐ ${dinhDangSo(qdLK)}`,
    `• Realtime: DT ${dinhDangSo(dtRT)} | QĐ ${dinhDangSo(qdRT)}`,
    `• Trả góp: ${dinhDangPhanTram(so(luyKe.phanTramTraGop))} | Quy đổi: ${dinhDangPhanTram(so(luyKe.phanTramQuyDoi))}`,
  ].join("\n");

  return {
    text: `${tieuDe} ngày ${ngayHienThi}`,
    fullText,
    imageUrl,
    reportType: loaiAnh,
    date: String(anhRow?.ngay || ngay),
    updatedAt: String(anhRow?.ngay_cap_nhat || banGhiNgay?.ngay_cap_nhat || ""),
  };
}

async function sendText(chat, text) {
  try {
    return await chat.sendMessage(text);
  } catch (error) {
    if (error?.data?.code !== "E2EE_RETRY_PLAIN") throw error;
    await base.talk.sendMessage({ to: chat.mid, text, e2ee: false });
  }
}

async function acceptInvitations() {
  const all = await base.talk.getAllChatMids({
    request: { withMemberChats: true, withInvitedChats: true },
    syncReason: "INTERNAL",
  });
  for (const chatMid of all.invitedChatMids || []) {
    await base.talk.acceptChatInvitation({
      request: { reqSeq: await base.getReqseq(), chatMid },
    });
    console.log(`ACCEPTED_GROUP=${chatMid}`);
  }
}

const { base, client } = await createLineClient();
await acceptInvitations();
const chats = await client.fetchJoinedChats();

for (const chat of chats) {
  try {
    const messages = await chat.fetchMessages(10);
    for (const message of messages) {
      if (message.isMyMessage) continue;
      const match = String(message.text || "").trim().match(/^\/gannhom\s+(\d{6})$/i);
      if (!match) continue;
      try {
        await ganNhom(match[1], chat.mid, chat.name);
        await sendText(chat, "✅ Đã gắn nhóm với ứng dụng DMX. Bây giờ có thể chọn nhóm này và lưu lịch gửi trong app.");
        console.log(`LINKED_GROUP=${chat.mid}`);
      } catch {
        // Mã đã dùng/hết hạn hoặc tin nhắn cũ: bỏ qua để không làm phiền nhóm.
      }
    }
  } catch (error) {
    console.error(`GROUP_SCAN_FAILED=${chat.mid}`, error);
  }
}

const dueList = await layLichDenHan();
if (!Array.isArray(dueList) || dueList.length === 0) {
  console.log("NO_DUE_REPORTS");
  process.exit(0);
}

const chatByMid = new Map(chats.map((chat) => [chat.mid.toLowerCase(), chat]));
const chatsByName = new Map();
for (const chat of chats) {
  const key = chat.name.trim().toLocaleLowerCase("vi-VN");
  chatsByName.set(key, [...(chatsByName.get(key) || []), chat]);
}

for (const schedule of dueList) {
  try {
    if (!await stillActive(schedule.id)) continue;
    const groupKey = String(schedule.line_group_id || "").toLowerCase();
    let chat = chatByMid.get(groupKey);
    let savedGroupName = "";
    if (!chat) {
      const relation = Array.isArray(schedule.dmx_line_nhom)
        ? schedule.dmx_line_nhom[0]
        : schedule.dmx_line_nhom;
      savedGroupName = String(relation?.ten_nhom || "").trim();
      const matches = chatsByName.get(savedGroupName.toLocaleLowerCase("vi-VN")) || [];
      if (matches.length === 1) chat = matches[0];
    }
    if (!chat) throw new Error(`Tài khoản BOT chưa ở trong nhóm "${savedGroupName || schedule.line_group_id}"`);

    let success = true;
    for (const rawType of schedule.cac_noi_dung || []) {
      if (!await stillActive(schedule.id)) { success = false; break; }
      const type = reportType(rawType);
      const report = await taiBaoCaoTuSupabase(type, schedule.nguoi_dung_id, schedule.sieu_thi_id);

      if (schedule.kieu_gui === "text") {
        await sendText(chat, String(report.fullText || report.text || "Báo cáo chưa có nội dung.").slice(0, 5000));
        continue;
      }

      const imageUrl = String(report.imageUrl || "");
      if (imageUrl) {
        const version = [report.reportType || type, report.date || "", report.updatedAt || "", report.updatedAt ? "" : imageUrl].join("|");
        const canGui = await kiemTraAnhMoi(
          schedule.line_group_id,
          schedule.nguoi_dung_id,
          schedule.sieu_thi_id,
          type,
          version
        );
        if (!canGui) continue;
        const imageResponse = await fetch(imageUrl);
        if (!imageResponse.ok) {
          const fallback = String(report.fullText || report.text || "").trim();
          if (!fallback) throw new Error(`Không tải được ảnh ${type}: HTTP ${imageResponse.status}`);
          await sendText(chat, `⚠️ Ảnh báo cáo không còn trên kho, gửi nội dung thay thế:\n\n${fallback}`.slice(0, 5000));
          continue;
        }
        const imageBlob = await imageResponse.blob();
        try {
          await base.obs.uploadMediaByE2EE({
            data: imageBlob, oType: "image", to: chat.mid, filename: `${type}.jpg`,
          });
        } catch (error) {
          if (error?.data?.code !== "E2EE_RETRY_PLAIN") throw error;
          await base.obs.uploadObjTalk(chat.mid, "image", imageBlob, undefined, `${type}.jpg`);
        }
        await danhDauAnhDaGui(
          schedule.line_group_id,
          schedule.nguoi_dung_id,
          schedule.sieu_thi_id,
          type,
          version
        );
      }
      const title = String(report.text || "").trim();
      if (title) await sendText(chat, title.slice(0, 5000));
    }
    if (success) await mark(schedule.id);
    console.log(`SENT_SCHEDULE=${schedule.id}`);
  } catch (error) {
    console.error(`SCHEDULE_FAILED=${schedule.id}`, error);
  }
}

process.exit(0);

