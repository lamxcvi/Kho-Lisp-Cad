(defun c:UpdateTitleBlock (/ csvFile openFile line data layName dwgName dwgNo ss blk)
  ;; Yeu cau chon file CSV
  (setq csvFile (getfiled "Chon file CSV danh muc ban ve" "" "csv" 4))
  
  (if csvFile
    (progn
      (setq openFile (open csvFile "r"))
      (while (setq line (read-line openFile))
        ;; Ham tach chuoi CSV don gian (phan cach boi dau phay)
        (setq data (LM:str->lst line ",")) 
        
        ;; Gia su: Cot 1 = Ten Layout, Cot 2 = Ten Ban Ve, Cot 3 = So Hieu
        (setq layName (nth 0 data))
        (setq dwgName (nth 1 data))
        (setq dwgNo   (nth 2 data))

        ;; Kiem tra xem Layout co ton tai khong
        (if (member layName (layoutlist))
          (progn
            (setvar "ctab" layName) ;; Chuyen sang layout do
            
            ;; Quet chon Block khung ten (Ban can sua ten Block o day)
            (setq ss (ssget "X" (list '(0 . "INSERT") '(2 . "TEN_BLOCK_CUA_BAN") (cons 410 layName))))
            
            (if ss
              (progn
                (setq blk (vlax-ename->vla-object (ssname ss 0)))
                ;; Cap nhat Attribute (Sua Tag Name o day)
                (foreach att (vlax-invoke blk 'GetAttributes)
                  (if (= (vla-get-TagString att) "DWG_TITLE") (vla-put-TextString att dwgName))
                  (if (= (vla-get-TagString att) "DWG_NO")    (vla-put-TextString att dwgNo))
                )
              )
            )
          )
        )
      )
      (close openFile)
      (princ "\nDa cap nhat xong!")
    )
  )
  (princ)
)

;; Ham bo tro: Chuyen chuoi thanh danh sach (List)
(defun LM:str->lst ( str del / pos len lst )
    (setq len (1+ (strlen del)))
    (while (setq pos (vl-string-search del str))
        (setq lst (cons (substr str 1 pos) lst)
              str (substr str (+ pos len)))
    )
    (reverse (cons str lst))
)
(vl-load-com)