(defun c:CB (/ ss i blkobj blkname namelist assoc_item msg)
  (vl-load-com)
  (princ "\nQuet chon cac Block can dem: ")
  
  ;; Chi loc lay doi tuong la BLOCK (INSERT)
  (setq ss (ssget '((0 . "INSERT"))))
  
  (if ss
    (progn
      (setq namelist '())
      (setq i 0)
      
      ;; Duyet qua tung Block duoc chon
      (repeat (sslength ss)
        (setq blkobj (vlax-ename->vla-object (ssname ss i)))
        
        ;; Lay ten Block (Xu ly ca Block dong - Dynamic Block)
        (if (vlax-property-available-p blkobj 'EffectiveName)
          (setq blkname (vla-get-EffectiveName blkobj)) ;; Neu la Dynamic Block
          (setq blkname (vla-get-Name blkobj))          ;; Neu la Block thuong
        )
        
        ;; Kiem tra xem ten da co trong danh sach chua
        (setq assoc_item (assoc blkname namelist))
        
        (if assoc_item
          ;; Neu co roi thi tang so luong len 1
          (setq namelist (subst (cons blkname (1+ (cdr assoc_item))) assoc_item namelist))
          ;; Neu chua co thi them moi vao danh sach voi so luong la 1
          (setq namelist (cons (cons blkname 1) namelist))
        )
        (setq i (1+ i))
      )
      
      ;; Tao chuoi ket qua de hien thi
      (setq msg "KET QUA DEM BLOCK:\n----------------------\n")
      (foreach item namelist
        (setq msg (strcat msg (car item) ": " (itoa (cdr item)) " cai\n"))
      )
      (setq msg (strcat msg "----------------------\nTONG CONG: " (itoa (sslength ss)) " Block"))
      
      ;; Hien thi hop thoai
      (alert msg)
      
      ;; In ra dong lenh F2
      (princ (strcat "\n" msg))
    )
    (princ "\nKhong tim thay Block nao.")
  )
  (princ)
)