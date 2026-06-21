# e. TÌM KIẾM CD THEO THỂ LOẠI
tim_cd_the_loai() {
    clear
    double_line
    echo -e "${BOLD}${BLUE}        TÌM KIẾM CD THEO THỂ LOẠI${NC}"
    double_line

    if [ ! -s "$CD_FILE" ]; then
        msg_warn "Chưa có dữ liệu CD nào."
        pause; return
    fi

    read -rp "Nhập thể loại cần tìm: " the_loai_tim
    if [ -z "$the_loai_tim" ]; then
        msg_err "Thể loại không được để trống!"
        pause; return
    fi

    the_loai_tim_lc=$(echo "$the_loai_tim" | tr '[:upper:]' '[:lower:]')
    found=0

    clear
    double_line
    echo -e "${BOLD}${BLUE}        KẾT QUẢ TÌM KIẾM THEO THỂ LOẠI${NC}"
    double_line
    printf "${BOLD}%-8s %-25s %-20s %-15s %12s %6s${NC}\n" \
        "Mã CD" "Tên CD" "Tác giả" "Thể loại" "Giá (VNĐ)" "SL"
    line

    while IFS='|' read -r id ten tac_gia the_loai nam gia sl; do
        the_loai_line=$(echo "$the_loai" | tr '[:upper:]' '[:lower:]')
        if printf '%s\n' "$the_loai_line" | grep -Fq -- "$the_loai_tim_lc"; then
            printf "%-8s %-25s %-20s %-15s %12s %6s\n" \
                "$id" "${ten:0:24}" "${tac_gia:0:19}" "${the_loai:0:14}" \
                "$(printf "%'.0f" "$gia")" "$sl"
            found=1
        fi
    done < "$CD_FILE"

    line
    if [ "$found" -eq 0 ]; then
        msg_warn "Không tìm thấy CD nào có thể loại '${the_loai_tim}'."
    else
        msg_ok "Đã hoàn thành tìm kiếm theo thể loại."
    fi
    pause
} 
# f. TIM KIEM CD THEO TAC GIA
tim_cd_the_tac_gia() {
    clear
    double_line
    echo -e "${BOLD}${BLUE}        TIM KIEM CD THEO TAC GIA${NC}"
    double_line

    if [ ! -s "$CD_FILE" ]; then
        msg_warn "Chua co du lieu CD nao."
        pause; return
    fi

    read -rp "Nhap tac gia can tim: " tac_gia_tim
    if [ -z "$tac_gia_tim" ]; then
        msg_err "Tac gia khong duoc de trong!"
        pause; return
    fi

    tac_gia_tim_lc=$(echo "$tac_gia_tim" | tr '[:upper:]' '[:lower:]')
    found=0

    clear
    double_line
    echo -e "${BOLD}${BLUE}        KET QUA TIM KIEM THEO TAC GIA${NC}"
    double_line
    printf "${BOLD}%-8s %-25s %-20s %-15s %12s %6s${NC}\n" \
        "Ma CD" "Ten CD" "Tac gia" "The loai" "Gia (VND)" "SL"
    line

    while IFS='|' read -r id ten tac_gia the_loai nam gia sl; do
        tac_gia_line=$(echo "$tac_gia" | tr '[:upper:]' '[:lower:]')
        if printf '%s\n' "$tac_gia_line" | grep -Fq -- "$tac_gia_tim_lc"; then
            printf "%-8s %-25s %-20s %-15s %12s %6s\n" \
                "$id" "${ten:0:24}" "${tac_gia:0:19}" "${the_loai:0:14}" \
                "$(printf "%'.0f" "$gia")" "$sl"
            found=1
        fi
    done < "$CD_FILE"

    line
    if [ "$found" -eq 0 ]; then
        msg_warn "Khong tim thay CD nao co tac gia '${tac_gia_tim}'."
    else
        msg_ok "Da hoan thanh tim kiem theo tac gia."
    fi
    pause
}

# g. TIM KIEM CD THEO TEN BAI HAT
tim_cd_theo_bai_hat() {
    clear
    double_line
    echo -e "${BOLD}${BLUE}        TIM KIEM CD THEO TEN BAI HAT${NC}"
    double_line

    if [ ! -s "$CD_FILE" ]; then
        msg_warn "Chua co du lieu CD nao."
        pause; return
    fi

    if [ ! -s "$DETAIL_FILE" ]; then
        msg_warn "Chua co du lieu bai hat chi tiet nao."
        pause; return
    fi

    read -rp "Nhap ten bai hat can tim: " bai_hat_tim
    if [ -z "$bai_hat_tim" ]; then
        msg_err "Ten bai hat khong duoc de trong!"
        pause; return
    fi

    bai_hat_tim_lc=$(echo "$bai_hat_tim" | tr '[:upper:]' '[:lower:]')
    found=0

    clear
    double_line
    echo -e "${BOLD}${BLUE}        KET QUA TIM KIEM THEO TEN BAI HAT${NC}"
    double_line

    while IFS='|' read -r id ten tac_gia the_loai nam gia sl; do
        detail=$(grep "^${id}|" "$DETAIL_FILE")
        [ -z "$detail" ] && continue

        bai_hat_list=$(echo "$detail" | cut -d'|' -f2)
        match_list=()

        IFS=';' read -r -a songs <<< "$bai_hat_list"
        for song in "${songs[@]}"; do
            song_lc=$(echo "$song" | tr '[:upper:]' '[:lower:]')
            case "$song_lc" in
                *"$bai_hat_tim_lc"*) match_list+=("$song") ;;
            esac
        done

        if [ ${#match_list[@]} -gt 0 ]; then
            echo -e "${BOLD}${YELLOW}▶ Mã CD      :${NC} ${id}"
            echo -e "  ${BOLD}Tên CD     :${NC} ${ten}"
            echo -e "  ${BOLD}Tác giả    :${NC} ${tac_gia}"
            echo -e "  ${BOLD}Thể loại   :${NC} ${the_loai}"
            echo -e "  ${BOLD}Bài hát khớp:${NC}"
            printf '%s\n' "${match_list[@]}" | nl -w4 -s'. ' | sed 's/^/    /'
            line
            found=1
        fi
    done < "$CD_FILE"

    if [ "$found" -eq 0 ]; then
        msg_warn "Khong tim thay CD nao chua bai hat '${bai_hat_tim}'."
    else
        msg_ok "Da hoan thanh tim kiem theo ten bai hat."
    fi
    pause
}