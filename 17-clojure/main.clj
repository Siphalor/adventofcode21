(if (not (== (count *command-line-args*) 2))
  (do
    (println "incorrect number of arguments")
    (System/exit 1)))

(defn traceShot
  [tx1 ty1 tx2 ty2 x y vx vy]
  (do
    (cond
      (or (> x tx2) (< y ty2)) false 
      (and (>= x tx1) (<= y ty1)) true
      :else (recur
              tx1 ty1 tx2 ty2
              (+ x vx)
              (+ y vy)
              (cond
                (< vx 0) (+ vx 1)
                (> vx 0) (- vx 1)
                :else 0
              )
              (- vy 1)))))

(def ^:const DEBUG false)
(def ^:const UNCHANGED_CNT 50)

(def highest (atom [ -1 0 ]))
(def fileContent (slurp (last *command-line-args*)))
(let [ [ _ g1 g2 g3 g4 ]
      (map read-string (re-find #"target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)\s*" fileContent))
      ]
  (let [ unchanged (atom UNCHANGED_CNT)
         tx1 (min g1 g2)
         tx2 (max g1 g2)
         ty1 (max g3 g4)
         ty2 (min g3 g4)
         vy (atom ty1) ]
    (while (> @unchanged 0)
      (if DEBUG (println "vy:" @vy))
      (let [ vx (atom 0) ]
        (swap! vx (vector 0))
        (while (<= @vx tx1)
          (if (traceShot tx1 ty1 tx2 ty2 0 0 @vx @vy)
            (do
              (if DEBUG (println "found vx:" @vx "vy:" @vy))
              (swap! highest (constantly [ @vx @vy ]))
              (swap! unchanged (constantly UNCHANGED_CNT))))
          (swap! vx inc))
      (swap! vy inc))

      (if (> @vy 0) (swap! unchanged dec))
      (if DEBUG (println @unchanged "unchanged left")))
    )
  )

(println "best pair:" @highest)
(println "largest height:" (* (/ (second @highest) 2) (+ (second @highest) 1)))
