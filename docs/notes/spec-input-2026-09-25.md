# Spec input — Ahsan, 2026-09-25: geo hierarchy and routing (Part 7)

Raw, unedited: the product owner's words, pasted from the session 2.1 chat so
the specification can cite a file. Do not edit; corrections go in a later
dated note.

---

Basically we need to start part seven where I want to give you some information about the geo hierarchy. How would the geo hierarchy work, so that the routing of the leads would work accordingly. First of all, we have the smallest unit is village, right? And further, on top of village, we have BSUs, basic sales unit area, BSUs, and each BSA, generally there is one franchisee, one Naya Savera franchisee exists, right? And one BSA has multiple villages, right? And further, on top of BSUs we have territory, and one territory can have multiple BSUs. And each territory is being taken care by one SUL, sales unit lead. One sales unit lead looks after one territory, right? And on top of territory we have regions. One region has multiple territories, and one region is being taken care by one regional sales manager, RSM. And on top of region we have zone, and one zone has multiple regions. And each zone is being taken care by zonal sales manager. And throughout Pakistan we have four zones: Lahore zone, Multan zone, Bahawalpur zone, and Hyderabad zone. All over Pakistan has been divided into four zones, right? Whenever any lead comes in, we try to make sure to capture their coordinates. And based on their coordinate, we map the relevant territory. Like we know that this coordinate exists in this village, and this village belongs to this territory, BSA in this territory. And this is how we reverse geocode and map the lead with the sales unit lead. And this is how we'll be ensuring routing. And for that, when it comes to digitization, we have Punjab and Sindh villages' boundaries digitized all over Pakistan. All over Pakistan's digital boundaries for Punjab and Sindh has been digitized. Punjab and Sindh make up around 95% of our sales agriculture area, and that's why there won't be any problem to reverse geocode the coordinates. And for other areas, if we have coordinates, then we'll try to map the nearest SUL based on the centroids. We'll draw a centroid and based on that we'll be mapping the nearest sales unit. But that makes up only less than 5% of the cases. And maybe I'm open to any other solution apart from centroid.

---

Same day, Part 7 questions:

**Outside Punjab and Sindh — first answer.** Answer: apart from punjab and sindh we don't have digital boundaries of villages/BSAs; just have single coordinates of franchise location and even SUL location

**Outside Punjab and Sindh — refined.** Answer: Nearest franchise point, with a distance cap [beyond the cap, the regional pool; marked "nearest franchise" on the lead].

**Placement order.** Answer: coordinate is mandatory if the coordinate is not available then at least complete address to be be converted to coordinate

**Which coordinate places the grower.** Answer: The most recent coordinate, unless an SUL confirmed one.

---

2026-09-28, Part 7 questions re-asked from the start at Ahsan's request ("start asking once again all questions of part 7 from zero"). These answers replace the ones above.

**1 Outside Punjab and Sindh.** Answer: Nearest franchise point, with a distance cap [beyond the cap, the regional pool; marked "nearest franchise"].

**2 Placement.** Answer: Coordinate mandatory; a full address is converted to one [with neither, the regional pool and Hina asks for the address as a gap].

**3 Which coordinate places the grower.** Answer: The most recent coordinate, unless an SUL confirmed one.

**4 Franchise per BSA.** Answer: One list: the franchise is a property of the BSA.

**5 Geo ownership.** Answer: DBO owns structure; rest is owned by the admin (digital team) [boundary files, address conversion, SUL and franchise points loaded by Admin; structure edited by DBO].

**6 Structure gaps.** Answer: Regional pool, and the gap is shown to DBO.

**Assumption P7-8 — which pool beyond the cap.** Answer: The region of the nearest franchise, however far.

**Assumption P7-14 — address conversion service.** Answer: we won't make it a part of phase 3; instead we will do in the phase 1; and we might not need an external service; we may develop it internally and api will be shared; however; there is still a possibility of integrating external service; you should keep the provision for both; will let you know at a later stage

Part 7 approved ("part 7 approved"), 2026-09-28.
