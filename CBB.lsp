(defun c:CBB (/ ss i obj doc)
  ;; Khoi tao moi truong Visual Lisp
  (vl-load-com)
  
  (princ "\nQuet chon cac doi tuong muon chuyen mau ve ByBlock: ")
  (setq ss (ssget))
  
  (if ss
    (progn
      ;; Lay doi tuong Document de quan ly Undo
      (setq doc (vla-get-activedocument (vlax-get-acad-object)))
      (vla-startundomark doc) ;; Bat dau nhom Undo (de Ctrl+Z 1 phat la het)
      
      (setq i 0)
      (repeat (sslength ss)
        (setq obj (vlax-ename->vla-object (ssname ss i)))
        
        ;; 0 la ma mau cua ByBlock
        ;; 256 la ma mau cua ByLayer
        (vla-put-color obj 0) 
        
        (setq i (1+ i))
      )
      
      (vla-endundomark doc) ;; Ket thuc nhom Undo
      (princ (strcat "\nDa chuyen " (itoa (sslength ss)) " doi tuong thanh mau ByBlock."))
    )
    (princ "\nKhong co doi tuong nao duoc chon.")
  )
  (princ)
)
