(load-template "page.rkt")

(current-title       "Randomized La-Mulana (and thoughts on randomizing games)")
(current-description "My experience playing 30 hours of La-Mulana with all items shuffled")
(current-keywords    "random lamulana games")
(current-filetarget  "randomulana.html")
(current-date        "2020-01-20")

(para "In this post I want to talk about a fun experience I had playing one of my favorite indie games " (link-to "La-Mulana" "https://store.steampowered.com/app/230700/LaMulana/") " and what I thought about the idea of it, and how I feel it may be applicable to extending the natural lifespan of all games.")


(h2 "What is La-Mulana?")

(para "La-Mulana is an indie game about exploring an ancient ruins, solving riddles and various puzzles, and defeating ancient evils that lay deep inside. It is no-doubt one of the best games I've ever played. It's also one of the hardest. But besides it being fun and difficult, I find it fascinating.")

(para "At a glance, it's a game about collecting various treasures to further progress and explore an ancient ruins. Deeper underneath, it's about discovering a story. Under the final layer, it's a difficult boss fighting game with many tactics and strategies. There's many facets to the game that adds to it's replayability.")

(para "However, I played La-Mulana extensively many years ago, beating the game several times under different conditions: beating the game once, beating the game on hard mode, beating the game on hard mode with no sub-weapons used on bosses, beating the game under 10 hours, I even went as far as beating the game on my friend's Steam account. My 100+ hours of La-Mulana have pointed to the notion that maybe I was just kind of done, and that there was nothing left to do.")

(kbi "I spent a lot of time in this game. I will probably not be looking to get all achievements though."
     "web/lm-playtime.png")

(para "So I did the natural thing to do: I moved onto the sequel, La-Mulana 2. Playing La-Mulana 2 was often times a struggle for me. I spent many hours wandering around aimlessly, looking for clues and solutions, trying to avoid looking up answers online as I did with La-Mulana original. Many people would say \"don't look up answers, you'll ruin the game\", but simply put, I didn't exactly find it fun to be lost in an ancient ruins for as long as I did. And quite frankly, some answers I don't think I would have been clever enough to figure out.")


(para "Everything about La-Mulana 2 made me want to go back to playing La-Mulana 1. I don't know why, but the items and combat and layout of the map made me nostalgic, so one day after joining the La-Mulana fan discord, I discovered a " (link-to "Randomizer program for La-Mulana 1" "https://github.com/thezerothcat/LaMulanaRandomizer") ". Now comes the fun stuff...")


(h2 "La-Mulana, except it's Shuffled")

(kbi "This is the beginning of the game, in Elder Leader Xelpud's hut. He's supposed to give you some email software to install on your laptop, but instead he gives you something that can pause time for 10 seconds; it takes hours to find this item normally..."
     "web/lm-random1.png")

(para "I mentioned that La-Mulana is mostly about collecting stuff and using said stuff to locate more stuff. This can best be represented by a data struct known as a Graph. Pretend each item is a Node, and the Edges that connect these nodes can be represented as a list of Items.")

(para "The core idea behind the Randomizer is that it loads all items from the game data, puts it into a Graph structure, and then moves the items around, and tests if the game can be fully completed based on that newly-randomized graph.")

(para "Let's pretend for a moment that we're writing this in Haskell. An Item is a sum-type representing the different type of items in La-Mulana. A Node is a combination of both the Item the Node (chest) stores, and the requirements to reach (unlock) the Node. There may be some requirements, or there may be none at all, so we'll use a Maybe type here.")


(code "
data Item = HandScanner
          | HolyGrail
          | Feather
          | SerpentStaff
          | ...
          deriving (Show, Eq)

data Node = Node Item (Maybe [Item])
          deriving (Show, Eq)
")

(para "The thing we want to determine is whether we can reach a certain Node based on what items we already have. Let's say we have a pre-defined list of items the player obtained, and a list of Nodes in the game.")

(code "
myItems = [HandScanner, ReaderExe, HolyGrail]

nodes = [
  Node HolyGrail Nothing,
  Node Feather $ Just [SerpentStaff]
  ]

canObtain :: Node -> [Item] -> Bool
canObtain (Node _ Nothing)         _    = True 
canObtain (Node i (Just reqList)) iList = satisfied 
  where satisfied = all (/=Nothing) $ map (\\x -> find (==x) iList) reqList
")

(para "Essentially we just take the Node's required items and map them against what we already have. If we can find each required item in our player's bag, then we can absolutely reach this Node.")

(para "Naturally, this code doesn't include Locations, which are also a problem in itself: some Locations are also item-restricted, so you can't access a range of Items unless you are able to get into the parent Location. The real Randomizer does in fact take this into account, as well as the number of tricks you can pull off to get into certain Locations, but I won't be going into that much.")

(para "The code for the Randomizer (written in Java) shuffles every item and tests it against restrictions that make the game incomplete-able. It's easier to just move pieces around and brute-force test if it works. There's also special settings you can configure so that you get a few items at the get-go, or maybe start in a completely different place. It's quite detailed, and playing it made me feel like it added a new breath of life into a game I've already played so much of.")

(para "After that, it got me thinking: is randomizing in games like this something that might make games more fun? My thoughts and reasoning might lead me to say: Yes, it quite frankly is and extends the game's lifespan even further.")

(h2 "Randomization and the Roguelike Nature")

(para "La-Mulana shares many game qualities with titles like " (link-to "Legend of Zelda: Link to the Past" "https://en.wikipedia.org/wiki/The_Legend_of_Zelda:_A_Link_to_the_Past") ", " (link-to "Super Metroid" "https://en.wikipedia.org/wiki/Super_Metroid") ", " (link-to "Resident Evil" "https://store.steampowered.com/app/304240/Resident_Evil__biohazard_HD_REMASTER/") ", and many more games that depend on searching areas for items to continuously progress through a game. In fact, long before I discovered La-Mulana randomization, I already knew about randomization in LTTP and Super Metroid; " (link-to "Check out this speedrun from AGDQ 2020 where they played Random LTTP" "https://www.youtube.com/watch?v=YpjTxcFQXo0") ".")

(kbi "The run (which takes about 4 hours) involved a lot of running around and weird strategies. On the lower-left side, you can see a collection tracking program that shows what the runner has found so far, since finding these items is again, completely random."
     "web/randomized-lttp.png")


(para "Going back to Resident Evil, RE1 is a game where you are trapped in a mansion, and must solve a series of puzzles and find keys to escape. The nature in which you can obtain keys is generally fixed, but if randomized, would open up the opportunity to create new routes and layers of difficulty by forcing the player to explore areas that they probably aren't ready for (ie: you find the key to the more difficult area of the mansion, but you're only equipped with a knife).")

(para "I suspect many games fall in the category of 'laundry list collection'. Technically the famous game " (link-to "DOOM" "https://store.steampowered.com/app/2280/Ultimate_Doom/") " also does this with their red/blue/yellow key system that guides the player towards their goal. There's something roguelike-ish about the idea of changing locations of important items in games that I find fascinating. Though I suspect many games that may appear to do this, wouldn't benefit much; one example being the Silent Hill series.")


(kbi "Silent Hill 2 has the player go to very scary places in order to collect items to use in a puzzle to proceed to the next area. Given that these items are often times one-use disposable items, randomizing wouldn't be much benefit here, as they're very area-specific. At best it might change the order in which you obtain weapons, but Silent Hill has never been known for it's combat after all."
     "web/silent-hill2.png")

(para "In a sense, randomization takes after it's parent game category of roguelikes. Games that clearly weren't designed to be randomized which can be, will take on some properties of roguelikes. If you're playing something like Nethack, the objective is to find the correct items for your character to live. But the order in which these items may appear (if at all), is random.")


(para "Something like Binding of Isaac, where item discovery is completely random, makes a fun game out of the idea that different items create different, never-before-seen interactions. At first your innocent box full of spiders is just a box that makes a few friendly spiders appear to help defeat enemies for you. Later on, that box of spiders may be duplicated or recharged instantly, making many more spiders appear. Then you find the item that makes spiders stronger, and then it won't be long before your entire game screen is just spiders everywhere.")

(para "This format of gameplay works best when the player/character is able to move around more freely in a game world. But after discovering this " (link-to "gigantic list of all game randomizers known" "https://www.debigare.com/randomizers/") ", it's crazy the number of randomizers game fans have worked on for their favorite games to add more life to games.")


(h2 "Wrap-Up")

(para "I like the idea of randomizing a game to make it more interesting. The feeling I got from La-Mulana was mostly the core concept of 'the items are completely random, and getting access to more requires intimate knowledge of how to get to certain things'. I had a lot of knowledge of La-Mulana going in (although I am pretty rusty), but I learned even more, and the joy of opening up boxes and thinking about new possibilities for exploration was really amazing.")

(para "I finally beat my first La-Mulana Randomized run. It took game-time about 7 hours to complete, with maybe some stops along the way to find hidden things I clearly didn't know about. This is after several hour-long attempts, where each time I had a deadpause and had to reveal the location of an item, I gave up because I simply felt lost not being able to discover it on my own.")

(kbi "Many hours of work and progress and exploration later, this is my final inventory for my La-Mulana randomized run. I am still missing some non-essential items, like maps or software, but those are not essential for me beating the game."
     "web/lmr-final.png")

(para "I have some minor interest in picking up another randomizer game, maybe something like " (link-to "Dark Souls 2" "https://store.steampowered.com/app/335300/DARK_SOULS_II_Scholar_of_the_First_Sin/") ", but I think I need to take a break from randomized games for a bit. La-Mulana randomized has been a blast, and I'm happy to have experienced it, even if it was only one fully-completed run. Every other attempt, even if futile, was still fun to play.")

(kbi "The end."
     "web/lmr-ending.jpg")
