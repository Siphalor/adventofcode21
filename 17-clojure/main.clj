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
(def allHits (atom []))
(def fileContent (slurp (last *command-line-args*)))

(defn findHits [ vy0 dvy _tx1 _tx2 _ty1 _ty2 ]
  (let [ unchanged (atom UNCHANGED_CNT)
        tx1 (min _tx1 _tx2)
        tx2 (max _tx1 _tx2)
        ty1 (max _ty1 _ty2)
        ty2 (min _ty1 _ty2)
        vy (atom vy0) ]
    (while (> @unchanged 0)
      (if DEBUG (println "vy:" @vy))
      (let [ vx (atom 0) ]
        (swap! vx (vector 0))
        (while (<= @vx tx2)
          (if (traceShot tx1 ty1 tx2 ty2 0 0 @vx @vy)
            (do
              (if DEBUG (println "found vx:" @vx "vy:" @vy))
              (let [ pair [ @vx @vy ] ]
                (swap! allHits (fn [prev] (conj prev pair)))
                (swap! highest (constantly pair)))
              (swap! unchanged (constantly UNCHANGED_CNT))))
          (swap! vx inc))
        (swap! vy (fn [prev] (+ prev dvy)))

        (swap! unchanged dec)
        (if DEBUG (println @unchanged "unchanged left")))
      )))

(let [ [ _ g1 g2 g3 g4 ]
      (map read-string (re-find #"target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)\s*" fileContent)) ]
  (case (first *command-line-args*)
    "part01" (do
               (findHits g3 1 g1 g2 g3 g4)
               (println "best pair:" @highest)
               (println "largest height:" (* (/ (second @highest) 2) (+ (second @highest) 1))))
    "part02" (let [ ymin (min g3 g4) ]
               (findHits ymin -1 g1 g2 g3 g4)
               (findHits (inc ymin) 1 g1 g2 g3 g4)
               (if DEBUG (println @allHits))
               (println "count of all matching velocities:" (count @allHits)))
    (println "unknown subcommand"))
  )
