/obj/item/robot_model/centcom //Sprites by QuartzAdachi
	name = "Central Command"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/pen/cyborg,
		/obj/item/clipboard/cyborg,
		/obj/item/hand_labeler/cyborg,
		/obj/item/stamp/centcom,
		/obj/item/borg/paperplane_crossbow,
		/obj/item/weldingtool/mini,
		/obj/item/megaphone/command,
		/obj/item/paint/anycolor/cyborg,
		/obj/item/soap/nanotrasen/cyborg,
		/obj/item/borg/cyborghug/medical,
		/obj/item/borg/lollipop,
		/obj/item/reagent_containers/borghypo/centcom,
		/obj/item/extinguisher/mini,
		/obj/item/borg/apparatus/paper_manipulator,
		/obj/item/screwdriver/cyborg,
		/obj/item/crowbar/cyborg,
		/obj/item/picket_sign/cyborg,
		/obj/item/borg/stun,
	)
	radio_channels = list(RADIO_CHANNEL_CENTCOM, RADIO_CHANNEL_COMMAND)
	model_traits = list(TRAIT_PUSHIMMUNE, TRAIT_NOFLASH)
	emag_modules = list(
		/obj/item/reagent_containers/spray/cyborg_lube,
		/obj/item/paperplane/syndicate/hardlight
	)
	special_light_key = null
	borg_skins = list(
		"Vale" = list(SKIN_ICON_STATE = "valecc", SKIN_ICON = CYBORG_ICON_CENTCOM_WIDE_BUBBER, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK, R_TRAIT_WIDE))
	)

/obj/item/robot_model/centcom/rebuild_modules()
	..()
	var/mob/living/silicon/robot/cyborg = loc
	cyborg.faction |= ROLE_DEATHSQUAD //You're part of CENTCOM now

/obj/item/robot_model/syndicate/remove_module(obj/item/removed_module, delete_after)
	..()
	var/mob/living/silicon/robot/cyborg = loc
	cyborg.faction -= ROLE_DEATHSQUAD //You're no longer part of CENTCOM

/obj/item/robot_model/science //Currently, basically just an Engineering borg but worse
	name = "Science"
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/borg/sight/meson,
		/obj/item/construction/rcd/borg,
		/obj/item/extinguisher,
		/obj/item/weldingtool/largetank/cyborg,
		/obj/item/screwdriver/cyborg/power,
		/obj/item/crowbar/cyborg/power,
		/obj/item/multitool/cyborg,
		/obj/item/analyzer,
		/obj/item/assembly/signaler/cyborg,
		/obj/item/electroadaptive_pseudocircuit,
		/obj/item/stack/sheet/iron,
		/obj/item/stack/sheet/glass,
		/obj/item/borg/apparatus/sheet_manipulator,
		/obj/item/stack/rods/cyborg,
		/obj/item/lightreplacer/cyborg,
		/obj/item/stack/tile/iron/base/cyborg,
		/obj/item/stack/cable_coil,
	)
	radio_channels = list(RADIO_CHANNEL_SCIENCE)
	emag_modules = list(
		/obj/item/borg/stun,
	)
	cyborg_base_icon = "science"
	cyborg_icon_override = 'modular_zubbers/modules/borgs/sprites/widerobot_sci.dmi'
	model_select_icon = "science"
	model_select_alternate_icon = 'modular_skyrat/modules/borgs/icons/screen_cyborg.dmi' //Skyrat already has a sciborg icon, so why not use it?
	model_traits = list(TRAIT_NEGATES_GRAVITY)
	hat_offset = -4
	borg_skins = list()

/* BUBBER SPRITE ADDITIONS BELOW */
/obj/item/robot_model/medical/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Raptor" = list(SKIN_ICON_STATE = CYBORG_ICON_TYPE_RAPTOR, SKIN_ICON = CYBORG_ICON_MED_WIDE_BUBBER, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK, R_TRAIT_WIDE))
	)

/obj/item/robot_model/engineering/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Raptor" = list(SKIN_ICON_STATE = CYBORG_ICON_TYPE_RAPTOR, SKIN_ICON = CYBORG_ICON_ENG_WIDE_BUBBER, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK, R_TRAIT_WIDE))
	)

/obj/item/robot_model/janitor/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Raptor" = list(SKIN_ICON_STATE = CYBORG_ICON_TYPE_RAPTOR, SKIN_ICON = CYBORG_ICON_JANI_WIDE_BUBBER, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK, R_TRAIT_WIDE))
	)

/obj/item/robot_model/miner/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Raptor" = list(SKIN_ICON_STATE = CYBORG_ICON_TYPE_RAPTOR, SKIN_ICON = CYBORG_ICON_MINING_WIDE_BUBBER, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK, R_TRAIT_WIDE))
	)

/obj/item/robot_model/security/Initialize()
	. = ..()
	borg_skins |= list(
		"Meka - Bluesec" = list(SKIN_ICON_STATE = "mekasecalt", SKIN_ICON = CYBORG_ICON_SEC_TALL_BUBBER, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK, R_TRAIT_UNIQUETIP, R_TRAIT_TALL), SKIN_HAT_OFFSET = 15),
		"Raptor" = list(SKIN_ICON_STATE = CYBORG_ICON_TYPE_RAPTOR, SKIN_ICON = CYBORG_ICON_SEC_WIDE_BUBBER, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK, R_TRAIT_WIDE)),
	)

/obj/item/robot_model/service/Initialize(mapload)
	. = ..()
	borg_skins |= list(
		"Raptor" = list(SKIN_ICON_STATE = CYBORG_ICON_TYPE_RAPTOR, SKIN_ICON = CYBORG_ICON_SERVICE_WIDE_BUBBER, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK, R_TRAIT_WIDE))
	)

/obj/item/robot_model/syndicatejack/Initialize()
	. = ..()
	borg_skins |= list(
		"Vale" = list(SKIN_ICON_STATE = "vale", SKIN_ICON = CYBORG_ICON_SYNDIE_WIDE_BUBBER, SKIN_FEATURES = list(R_TRAIT_UNIQUEWRECK, R_TRAIT_WIDE)),
		"Pupdozer" = list(SKIN_ICON_STATE = "pupdozer", SKIN_ICON = CYBORG_ICON_SYNDIE_WIDE_BUBBER, SKIN_FEATURES = list(R_TRAIT_WIDE)),
	)
