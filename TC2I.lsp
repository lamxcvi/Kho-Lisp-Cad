(defun c:TC2I (/ doc layers lay colObj colMethod idx cnt)
  (vl-load-com)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (setq layers (vla-get-layers doc))
  (setq cnt 0)
  
  (princ "\nDang xu ly chuyen doi mau layer...")
  
  ;; Duyệt qua từng layer trong bản vẽ
  (vlax-for lay layers
    (setq colObj (vla-get-truecolor lay))
    
    ;; Kiểm tra xem Layer có đang dùng True Color (RGB) không
    ;; acColorMethodByRGB = 194
    (if (= (vla-get-colormethod colObj) 194) 
      (progn
        ;; Lấy chỉ số màu Index gần nhất (AutoCAD tự tính toán)
        (setq idx (vla-get-colorindex colObj))
        
        ;; Gán lại màu cho layer bằng Index Color
        (vla-put-color lay idx)
        (setq cnt (1+ cnt))
      )
    )
  )
  
  ;; Cập nhật lại màn hình
  (vla-regen doc acAllViewports)
  
  (princ (strcat "\nHoan thanh! Da chuyen doi " (itoa cnt) " layer ve Index Color."))
  (princ)
)