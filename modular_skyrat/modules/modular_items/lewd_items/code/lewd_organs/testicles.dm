/obj/item/organ/genital/testicles
	internal_fluid_datum = /datum/reagent/consumable/cum

/obj/item/organ/genital/testicles/build_from_dna(datum/dna/DNA, associated_key)
	. = ..()
	var/size = 0.5
	if(DNA.features["balls_size"] > 0)
		size = DNA.features["balls_size"]

	internal_fluid_maximum = size * 20
	if(internal_fluid_maximum > 300)
		internal_fluid_maximum = 300
