(defun c:FIXBLK (/ ss i blkRef blkName blkDef doc colBlks listBlkName obj count)
  ;; Khoi tao moi truong Visual Lisp
  (vl-load-com)
  (setq doc (vla-get-activedocument (vlax-get-acad-object)))
  (setq colBlks (vla-get-blocks doc))
  (setq listBlkName '()) 
  
  (princ "\nQuet chon cac Block can chuan hoa (Layer 0, Color ByBlock): ")
  (if (setq ss (ssget '((0 . "INSERT"))))
    (progn
      (vla-startundomark doc)
      
      ;; 1. Loc lay danh sach ten cac Block duoc chon (tranh lap lai)
      (setq i 0)
      (repeat (sslength ss)
        (setq blkRef (vlax-ename->vla-object (ssname ss i)))
        
        ;; Lay ten Block (Xu ly ca Dynamic Block)
        (if (vlax-property-available-p blkRef 'EffectiveName)
          (setq blkName (vla-get-EffectiveName blkRef))
          (setq blkName (vla-get-Name blkRef))
        )
        
        ;; Neu ten chua co trong danh sach thi them vao
        (if (not (member blkName listBlkName))
          (setq listBlkName (cons blkName listBlkName))
        )
        (setq i (1+ i))
      )
      
      ;; 2. Duyet qua tung Dinh nghia Block va sua doi tuong ben trong
      (setq count 0)
      (foreach name listBlkName
        (if (not (wcmatch name "`**")) ;; Bo qua cac block vo danh he thong
          (progn
             (setq blkDef (vla-item colBlks name))
             (vlax-for obj blkDef
               ;; Chuyen ve Layer 0
               (vla-put-Layer obj "0")
               ;; Chuyen mau ve ByBlock (Ma mau 0)
               (vla-put-Color obj 0)
               ;; Chuyen kieu net ve ByBlock (Option them cho sach)
               (vla-put-Linetype obj "ByBlock")
               (vla-put-Lineweight obj -2) ;; -2 la ByBlock
             )
             (setq count (1+ count))
          )
        )
      )
      
      ;; 3. Regen de cap nhat hien thi
      (vla-regen doc 1) ;; acAllViewports
      (vla-endundomark doc)
      
      (princ (strcat "\nDa chuan hoa thanh cong " (itoa count) " loai Block!"))
    )
    (princ "\nKhong chon duoc Block nao.")
  )
  (princ)
)
