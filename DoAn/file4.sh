#!/bin/bash
# h. BAN CD
sinh_id_hoa_don() {
    if [ ! -s "$INVOICE_FILE" ]; then
        echo "HD001"
    else
        last=$(awk -F'|' '/^HD[0-9]+\|/ {print $1}' "$INVOICE_FILE" | grep -oE '[0-9]+' | sort -n | tail -1)
        [ -z "$last" ] && last=0
        printf "HD%03d" $((last + 1))
    fi
}

cap_nhat_so_luong_cd() {
    local ma_cd="$1"
    local so_luong_moi="$2"
    local tmp_file="${CD_FILE}.tmp.$$"

    awk -F'|' -v OFS='|' -v id="$ma_cd" -v sl="$so_luong_moi" '
        $1 == id {$7 = sl}
        {print}
    ' "$CD_FILE" > "$tmp_file" && mv "$tmp_file" "$CD_FILE"
}

ban_cd() {
    clear
    double_line
    echo -e "${BOLD}${BLUE}        BAN CD${NC}"
    double_line

    if [ ! -s "$CD_FILE" ]; then
        msg_warn "Chua co du lieu CD nao."
        pause; return
    fi

    read -rp "Nhap ma CD can ban: " id
    id=$(echo "$id" | tr '[:lower:]' '[:upper:]')

    dong=$(grep "^${id}|" "$CD_FILE")
    if [ -z "$dong" ]; then
        msg_err "Khong tim thay CD co ma '${id}'!"
        pause; return
    fi

    ten_cd=$(echo "$dong" | cut -d'|' -f2)
    gia_ban=$(echo "$dong" | cut -d'|' -f6)
    ton_kho=$(echo "$dong" | cut -d'|' -f7)

    echo -e "${CYAN}CD: ${BOLD}${ten_cd}${NC}"
    echo -e "Gia ban: $(printf "%'.0f" "$gia_ban") VNĐ"
    echo -e "Ton kho hien tai: ${ton_kho}"

    while true; do
        read -rp "Nhap so luong can ban: " so_luong_ban
        [[ "$so_luong_ban" =~ ^[0-9]+$ ]] && [ "$so_luong_ban" -gt 0 ] && break
        msg_err "So luong phai la so nguyen duong!"
    done

    if [ "$so_luong_ban" -gt "$ton_kho" ]; then
        msg_err "So luong ban vuot qua ton kho hien tai!"
        pause; return
    fi

    read -rp "Nhap ten khach hang: " ten_kh
    if [ -z "$ten_kh" ]; then
        msg_err "Ten khach hang khong duoc de trong!"
        pause; return
    fi

    thanh_tien=$((gia_ban * so_luong_ban))
    ton_kho_moi=$((ton_kho - so_luong_ban))
    ma_hd=$(sinh_id_hoa_don)
    ngay_ban=$(date +"%d/%m/%Y")

    cap_nhat_so_luong_cd "$id" "$ton_kho_moi"
    echo "${ma_hd}|${ngay_ban}|${ten_kh}|${id}|${ten_cd}|${so_luong_ban}|${gia_ban}|${thanh_tien}" >> "$INVOICE_FILE"

    echo
    msg_ok "Da ban thanh cong ${so_luong_ban} dia CD ${id}. Ma hoa don: ${ma_hd}"
    pause
}

# ============================================================
# i. IN HOA DON BAN HANG
in_hoa_don_ban_hang() {
    clear
    double_line
    echo -e "${BOLD}${BLUE}        IN HOA DON BAN HANG${NC}"
    double_line

    if [ ! -s "$INVOICE_FILE" ]; then
        msg_warn "Chua co hoa don nao."
        pause; return
    fi

    invoice_id="$1"
    if [ -z "$invoice_id" ]; then
        read -rp "Nhập mã hóa đơn cần in : " invoice_id
    fi

    if [ -z "$invoice_id" ]; then
        invoice_id=$(awk -F'|' 'NF{last=$1} END{print last}' "$INVOICE_FILE")
    fi

    dong=$(grep "^${invoice_id}|" "$INVOICE_FILE")
    if [ -z "$dong" ]; then
        msg_err "Không tìm thấy hóa đơn '${invoice_id}'."
        pause; return
    fi

    IFS='|' read -r ma_hd ngay ten_kh id_cd ten_cd sl don_gia thanh_tien <<< "$dong"
    clear
    double_line
    echo -e "${BOLD}${BLUE}               HOA DON BAN HANG${NC}"
    double_line
    echo -e "Ma hoa don  : ${BOLD}${ma_hd}${NC}"
    echo -e "Ngay lap    : ${ngay}"
    echo -e "Khach hang  : ${ten_kh}"
    echo -e "Ma CD       : ${id_cd}"
    echo -e "Ten CD      : ${ten_cd}"
    echo -e "So luong    : ${sl}"
    echo -e "Don gia     : $(printf "%'.0f" "$don_gia") VNĐ"
    echo -e "Thanh tien  : $(printf "%'.0f" "$thanh_tien") VNĐ"
    line

    {
        echo "============================================================"
        echo "HOA DON BAN HANG: ${ma_hd}"
        echo "Ngay lap    : ${ngay}"
        echo "Khach hang  : ${ten_kh}"
        echo "Ma CD       : ${id_cd}"
        echo "Ten CD      : ${ten_cd}"
        echo "So luong    : ${sl}"
        echo "Don gia     : $(printf "%'.0f" "$don_gia") VNĐ"
        echo "Thanh tien  : $(printf "%'.0f" "$thanh_tien") VNĐ"
        echo "============================================================"
        echo
    } >> "$INVOICE_FILE"

    msg_ok "Da ghi hoa don vao file invoices.txt."
    pause
}
