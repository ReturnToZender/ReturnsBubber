/datum/element/crawlable
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH_ON_HOST_DESTROY // Detach for turfs
	argument_hash_start_idx = 2
	///Time it takes to crawl under the object
	var/crawl_time
	///Stun duration for when you get under the object
	var/crawl_stun
	///Assoc list of object being climbed on - crawlers.  This allows us to check who needs to be shoved off a crawlable object when its clicked on.
	var/list/current_crawlers

/datum/element/crawlable/Attach(datum/target, crawl_time = 2 SECONDS, crawl_stun = 2 SECONDS,)
	. = ..()

	if(!isatom(target) || isarea(target))
		return ELEMENT_INCOMPATIBLE
	src.crawl_time = crawl_time
	src.crawl_stun = crawl_stun

	RegisterSignal(target, COMSIG_ATOM_ATTACK_HAND, PROC_REF(attack_hand))
	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_MOUSEDROPPED_ONTO, PROC_REF(mousedrop_receive))
	ADD_TRAIT(target, TRAIT_CRAWLABLE, ELEMENT_TRAIT(type))

/datum/element/crawlable/Detach(datum/target)
	UnregisterSignal(target, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_EXAMINE, COMSIG_MOUSEDROPPED_ONTO, COMSIG_ATOM_BUMPED))
	REMOVE_TRAIT(target, TRAIT_CRAWLABLE, ELEMENT_TRAIT(type))
	return ..()

/datum/element/crawlable/proc/on_examine(atom/source, mob/user, list/examine_texts)
	SIGNAL_HANDLER
	examine_texts += span_notice("[source] looks crawlable.")

/datum/element/crawlable/proc/can_crawl(atom/source, mob/user)
	var/dir_step = get_dir(user, source.loc)
	//To jump over a railing you have to be standing next to it, not far behind it.
	if(source.flags_1 & ON_BORDER_1 && user.loc != source.loc && (dir_step & source.dir) == source.dir)
		return FALSE
	return TRUE

/datum/element/crawlable/proc/attack_hand(atom/crawled_thing, mob/user)
	SIGNAL_HANDLER
	var/list/crawlers = LAZYACCESS(current_crawlers, crawled_thing)
	for(var/i in crawlers)
		var/mob/living/structure_crawler = i
		if(structure_crawler == user)
			return
		user.changeNext_move(CLICK_CD_MELEE)
		user.do_attack_animation(crawled_thing)
		structure_crawler.Paralyze(40)
		structure_crawler.visible_message(span_warning("[structure_crawler] is knocked off [crawled_thing]."), span_warning("You're knocked off [crawled_thing]!"), span_hear("You hear a cry from [structure_crawler], followed by a slam."))

/datum/element/crawlable/proc/crawl_structure(atom/crawled_thing, mob/living/user, params)
	if(!can_crawl(crawled_thing, user))
		return
	crawled_thing.add_fingerprint(user)
	user.visible_message(span_warning("[user] starts crawling under [crawled_thing]."), \
								span_notice("You start crawling under [crawled_thing]..."))
	var/adjusted_crawl_time = crawl_time
	var/adjusted_crawl_stun = crawl_stun
	if(HAS_TRAIT(user, TRAIT_HANDS_BLOCKED)) //crawling takes twice as long without help from the hands.
		adjusted_crawl_time *= 2
	if(isalien(user))
		adjusted_crawl_time *= 0.25 //aliens are terrifyingly fast
	if(HAS_TRAIT(user, TRAIT_FREERUNNING)) //do you have any idea how fast I am???
		adjusted_crawl_time *= 0.8
		adjusted_crawl_stun *= 0.8
	if(HAS_TRAIT(user, TRAIT_SETTLER)) //hold on, gimme a moment, my tiny legs can't get over the goshdamn table
		adjusted_crawl_time *= 1.5
		adjusted_crawl_stun *= 1.5
	LAZYADDASSOCLIST(current_crawlers, crawled_thing, user)
	if(do_after(user, adjusted_crawl_time, crawled_thing))
		if(QDELETED(crawled_thing)) //Checking if structure has been destroyed
			return
		if(do_crawl(crawled_thing, user, params))
			user.visible_message(span_warning("[user] crawls under [crawled_thing]."), \
								span_notice("You crawl under [crawled_thing]."))
			log_combat(user, crawled_thing, "crawled under")
			if(adjusted_crawl_stun)
				user.Stun(adjusted_crawl_stun)
		else
			to_chat(user, span_warning("You fail to crawl under [crawled_thing]."))
	LAZYREMOVEASSOC(current_crawlers, crawled_thing, user)

/datum/element/crawlable/proc/do_crawl(atom/crawled_thing, mob/living/user, params)
	if(!can_crawl(crawled_thing, user))
		return
	crawled_thing.set_density(FALSE)
	var/dir_step = get_dir(user, crawled_thing.loc)
	var/same_loc = crawled_thing.loc == user.loc
	// on-border objects can be vaulted over and into the next turf.
	// The reverse dir check is for when normal behavior should apply instead (e.g. John Doe hops east of a railing facing west, ending on the same turf as it).
	if(crawled_thing.flags_1 & ON_BORDER_1 && (same_loc || !(dir_step & REVERSE_DIR(crawled_thing.dir))))
		//it can be vaulted over in two different cardinal directions. we choose one.
		if(ISDIAGONALDIR(crawled_thing.dir) && same_loc)
			if(params) //we check the icon x and y parameters of the click-drag to determine step_dir.
				var/list/modifiers = params2list(params)
				var/x_dist = (text2num(LAZYACCESS(modifiers, ICON_X)) - world.icon_size/2) * (crawled_thing.dir & WEST ? -1 : 1)
				var/y_dist = (text2num(LAZYACCESS(modifiers, ICON_Y)) - world.icon_size/2) * (crawled_thing.dir & SOUTH ? -1 : 1)
				dir_step = (x_dist >= y_dist ? (EAST|WEST) : (NORTH|SOUTH)) & crawled_thing.dir
		else
			dir_step = get_dir(user, get_step(crawled_thing, crawled_thing.dir))
	. = step(user, dir_step)
	crawled_thing.set_density(TRUE)

///Handles crawling under the atom when you click-drag
/datum/element/crawlable/proc/mousedrop_receive(atom/crawled_thing, atom/movable/dropped_atom, mob/user, params)
	SIGNAL_HANDLER
	if(user != dropped_atom || !isliving(dropped_atom))
		return
	if(!HAS_TRAIT(dropped_atom, TRAIT_FENCE_CLIMBER) && !HAS_TRAIT(dropped_atom, TRAIT_CAN_HOLD_ITEMS)) // If you can hold items you can probably crawl a fence
		return
	var/mob/living/living_target = dropped_atom
	if(living_target.mobility_flags & MOBILITY_MOVE && living_target.resting)
		INVOKE_ASYNC(src, PROC_REF(crawl_structure), crawled_thing, living_target, params)
