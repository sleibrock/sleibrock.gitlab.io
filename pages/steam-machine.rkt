(load-template "page.rkt")

(current-title       "Steam Machine and NixOS")
(current-description "Repairing and replacing SteamOS")
(current-keywords    "steamos steam machine nixos")
(current-filetarget  "nix-machine.html")
(current-date        "2020-01-02")

(para "I recently took into my possession a blast from the past: a four-year old machine. And by that I mean a " (link-to "Alienware Alpha" "https://www.dell.com/ng/p/alienware-steam-machine/pd") ". With some intention of replacing our 'living room entertainment PC' (a 10+ year old laptop), I had some ambitions with this, so let's dive into it right away.")

(h2 "Part 1: Darkness")

(kbi "The blue LEDs on the front of the Alienware Alpha case"
     "web/leds-alienix.jpg")

(para "The Alienware Alpha comes with some decent-looking specs at first, and my first instinct when looking it was always to customize it with a real operating system instead of SteamOS. Let's say I didn't have a desktop, I'd consider even using this as a miniature-grade desktop PC.")

(ul '("Intel i5-4590T"
      "Nvidia GeForce GTX 860M"
      "8GB DDR3 RAM"
      "500GB 5400RPM HDD"))

(para "The hard drive is a little bit slow but otherwise the specs are decent. Then let's move onto the next bit:")

(para "It doesn't turn on. So let's figure out how to fix this.")

(h2 "Part 2: Repairs")

(kbi "The CMOS battery on the underside of the motherboard"
     "web/cmos-alienix.jpg")


(para "The minute I plug the machine in, the Alienware logo flashes yellow five times, then repeats this ad finem until power is removed. After research, it points to an issue with the motherboard being unable to fully start the BIOS up. Multiple users even report it being an issue specifically with the CMOS battery itself. But for a machine that was hardly used, is it really the CMOS that's dead now? Laptops last longer than this.")

(para "More investigating showed that there is a more elegant solution to this: resetting the BIOS with an electrical pin switch. There's a cap on two pins on the board that when removed will trigger a BIOS reset. After pulling it off, my system no longer flashed yellow lights and went into a recovery. I wasn't exactly sure if there was anything specific I had to do after that (other than change boot priorities for later), but it was able to boot into the stock SteamOS image on the hard drive perfectly fine.")

(para "From here I'm not really able to do much more without ripping into the guts of the system, which I didn't particularly feel like doing. I'll consider this SteamOS hard drive my control for the experiment I'm about to run, so I'll be taking it out shortly and putting in a (tiny) solid state drive I have that isn't being utilized.")

(h2 "Part 3: Theorizing NixOS")

(kbi "Top-down view of the Alienware Alpha; the board has two different fans for both the CPU and the GPU"
     "web/topdown-alienix.jpg")

(para "The next part is using something a bit fresher for my Linux experience. If I want this to truly replace our living room PC, it would need more up-to-date software and compatibility to play some games. Our basic needs would look something like this:")

(ul '("Internet browser"
      "Movie/music player"
      "Steam support"
      "Emulators (snes/gba/maybe psx)"
      "Full support for HID/360/PS3 controllers"
      "Functionality with Clone Hero guitars"
      ))

(para "Luckily I can cross off a lot of these bullets from regular working knowledge of my current daily-driver Linux distribution: NixOS.")

(para "Right off the bat, I know that we will be getting a decently-updated system by moving in this direction; Firefox, mpv/vlc, snes9x/virtualboy, and Steam Controllers are all things that I tend to use on a regular basis. Our other wireless peripherals may need some testing, but really it's just up to getting wide-spread controller support so we can easily plug something in and have it working immediately for any game we throw at it.")

(para "So my starting point goes back to this: is SteamOS worth using now, years after it's release, where it seemingly has little-to-no future of being updated? It seems that all SteamOS does is bootstrap into a basic Steam Docker-like container so that Steam can take control of the heavy lifting as far as managing video drivers (I'm pretty certain Steam includes a basic Ubuntu environment of sorts for graphics).")

(para "So off we go to our fancy NixOS live image and we start building a Nix configuration from scratch right from the get-go. I can lift a lot of heavy-lifting by using some lines of my " (link-to "current NixOS config" "https://github.com/sleibrock/nixfiles/blob/master/configuration.nix") " and playing around, so that saves some time. A big thing that I can immediately be sure that will work are the Steam Controllers themselves, since I figured out how to incorporate their udev rules by previous Google research.")

(para "In my household, there's a bias towards Windows as the premier gaming platform since we've all grown around it. I however have only been using NixOS as my personal desktop environment for a few months now, and I would rather be pretty firm in not using Windows in this instance since it would lead down a path of darkness. Because of that, we will have to rely on Steam's Proton/Wine system to do any work in running Windows-only applications. This could be something of an issue on older hardware, but I'm certain whatever we'd want to run on this tiny piece of hardware will be fine. We naturally aren't going to run " (link-to "The Witcher 3" "https://store.steampowered.com/app/292030/The_Witcher_3_Wild_Hunt/") " on here anytime soon.")


(h2 "Part 4: Installing NixOS")

(kbi "Did I mention I have four Steam controllers now?"
     "web/four-steam-controllers.jpg")

(para "The next step is actually installing NixOS itself. Using my handy-dandy NixOS USB drive that I have from installing NixOS on two other devices, so I'm just gonna pop this in and see what happens.")

(para "So the system is able to boot into the live environment, but for whatever reason, starting up the KDE desktop fails? Not the biggest deal but it would have been nice to have a live working environment before installing it. But I have no fear since I didn't wipe the SteamOS install and can always fall back to that for safety.")

(para "The normal NixOS manual install steps work, and doing a preliminary config file gets me a fully working NixOS system. The Alienware Alpha does indeed come with a wireless card, so turning on NetworkManager covers all of that good stuff. So let's dive into getting Steam to work.")

(para "After a lot of trials on different games, I realized that I never properly configured the Nvidia drivers to ever be installed. I tried several games, some didn't work, and then had the realization I lacked drivers after much Googling. There are a lot of packages intended to work around this, but quite frankly I had issues with them working. So I just used the tried-and-true default Steam package and configured Nix to look for Nvidia drivers. After this the build time took several minutes, so a lot of time spent waiting...")

(para "Once they were installed, games started working magically with Steam's Proton layer. I tried 'The Witness', one of my favorite puzzle games, before installing drivers and it was unusable. Then once I turned on the Nvidia drivers, it worked much better, although not perfect.")

(para "Since this is a box intended for Steam Big Picture purposes, it would help if I could amend something to the system to turn on Steam automatically. Here I'm using xfce4, so I head over to the sessions part of the settings manager and put Steam on through the autostart at the beginning of sessions. I also have my user profile auto-logged in with sddm")

(para "The Steam Controllers are the next obstacle that I've already solved from my desktop NixOS. Udev rules have to be added in order for the controllers to be properly recognized by software, so it's a matter of identifying which devices are specifically Steam Controllers. I was able to figure out the serial codes from a Nix package I didn't feel much like incorporating and instead hard-coded myself.")

(para "So after getting all the software installed via Nix, proper kernel modules and udev rules, testing the four controllers in my possession and sync'ing them to the single receiver plugged into the underside of the console, I think I can finally say that I have a Steam Machine running NixOS successfully. We will be migrating it and really testing it over in the living room in a few days time and giving it some tests and making changes based on feedback slowly.")

(h2 "Conclusion")

(para "Overall, the experience wasn't the worst. There's always some level of research you have to do when it comes to playing with new hardware and Linux. I know that best from first-hand experience over the years that there is always a learning curve as to what works and what doesn't work. Steam makes a good concious effort at improving the experience on Linux, and I think it shows with Proton and Steam Controllers.")

(para "The hardware isn't bad, and I was using it as a desktop environment for a good chunk of the day just to put it through the motions and see what I could do. Everything from web browsing to playing games on Big Picture, and making sure things would work the way I hope they would when it came to switching in and out of Big Picture mode. All that's left is to find the right type of games, get some friends, and try some new things out, and make changes based on results.")

(para "If you are reading this because you also have an old Steam Machine and are curious about NixOS, I will be putting the files up on my " (link-to "Nixfiles repo" "https://github.com/sleibrock/nixfiles") " in a separate folder (as well as making some much-needed changes to the structure of that project) for all to see.")

(para "I hope this dive into Steam Machines with NixOS has been a fun one for you as much as it was for me.")

; end
