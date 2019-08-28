(current-template
 `(html
   (head
    (title "Computer Builds")
    (link ([rel "stylesheet"] [href "static/css/style.css"]))
    (meta ([charset "utf-8"]))
    (meta ([viewport "width=device-width, initial-scale=1.0"]))
    (meta ([keywords "Steven Leibrock personal website"]))
    (meta ([author "Steven Leibrock"]))
    (meta ([description "Steven Leibrock's personal website"])))
   
   (body
    (article
      (h1 "Computer Builds")
     (section
      (p "Below is an example section of computers I've assembled from various computer parts based on use-cases and price ranges.")

      (i (p "Note: costs listed are based on when parts were purchased."))

      (h2 "FX-8350 x RX280")

      (p "This computer was designed for gaming purposes without breaking the client's wallet. It achieves 60 FPS in many online multiplayer games, balancing load across the 8350's eight core architecture. The TDP of AMD processors tends to be higher so 3rd party heatsinks are necessary to keep it below 55C.")

      ,(unordered-list '("AMD FX-8350 CPU - $150"
                         "Gigabyte GA-970A motherboard - $120"
                         "AMD RX280 GPU - $200"
                         "Corsair 8GB RAM - $90"
                         "Corsair H100i Watercooler - $110"))

      (p "With a case this comes out to a little over $800 USD. Multiplayer games tested were World of Warcraft, Dota 2, Counter-Strike: Global Offensive, League of Legends, Fortnite. The total cost does not include hard drives, which were re-used from older computers.")

      (h2 "FX-8350 x RX480")

      (p "This is actually my personal desktop computer. I chose to stick with FX-8350 for this, opting out of picking something like the FX-9590, which has a higher TDP and higher temperature requirement while offering minimal improvements.")

      ,(unordered-list '("AMD FX-8350 CPU - $150"
                         "Gigabyte GA-970A motherboard - $120"
                         "AMD RX480 GPU - $250"
                         "Corsair 16GB RAM - $170"
                         "Corsair H110i Watercooler  - $110"
                         "Kingston 120GB SSD - $60"
                         "Crucial 240GB SSD - $60"
                         "Seagate 1TB 7200RPM HDD - $50"))

      (p "I use the SSDs for two operating systems to dual-boot OSes between Windows and Linux. The 1TB HDD serves as a central disk for sharing data between OSes as Windows cannot boot into GPT partitioned disks without additional drivers by default.")

      (p "The RX400 series of GPUs had come out at this time so I opted to pay more for better FPS as opposed to putting priority into the CPU. I find that the 8350 is very fast for my own work and the RX480 is a great video card as well.")

      (h2 "Ryzen 2700 x GTX 1070")

      (p "The Ryzen series of AMD processors had come out recently, and a client wanted to explore the possibility of using an AMD processor as opposed to normal (expensive) Intel CPUs. For this we chose the Ryzen 2700 and a GTX 1070 as the base framework.")

      ,(unordered-list '(""
                         ""
                         ))

      (h2 "4790k x GTX 970")

      (p "I've built this computer several times as the performance was fantastic for the cost at the time of hardware costs. The 4790k Haswell proved to be a real workhorse compared to AMD chipsets at the time, and comes highly recommended from multiple sources as one of the better overclocked Intel processors.")

      (p (i "Note: I measured the thermals and determined that even under load, the stock heatsink/fan proved to be enough."))

      ,(unordered-list '("Intel 4790k Haswell - $300"
                         "NVIDIA GTX 970 GPU - $400"
                         ""
                         ))

      (h2 "6700k x GTX 980 Ti")

      ))
      

    (hr)
    (footer
     (nav
      (p "Steven Leibrock 2019"))))))

(xexpr->file (current-template) "public/builds.html") 
