# Praat script to:
# 1. Extract first four formants from vowels in Sound object;
# 2. Create sine waves with the same frequency (Hz) and sound pressure (Pa) as the formants;
# 3. Combine the four sine waves.

# Written by Earl Kjar Brown (ekbrown byu edu)
# Tested on Praat version 6.4.25

# start of script
writeInfoLine: "Let's go!"

# loop over object ID numbers of individual Sound objects, each with a separate vowel
for k from 147 to 149
	appendInfoLine: ""	
	appendInfoLine: "Object: ", k
	appendInfoLine: ""
	selectObject: k
	sound = selected("Sound")

	# create a spectrum object
	spectrum = To Spectrum: "yes"

	# create a formant object
	selectObject: sound
	formant = To Formant (burg): 0, 5, 5000, 0.025, 50

	# loop over one to four to extract those formants from current vowel
	for i from 1 to 4
		selectObject: formant
		cur_formant = Get mean: i, 0, 0, "hertz"
		selectObject: spectrum
		hz = Get frequency of nearest maximum: cur_formant
		db = Get sound pressure level of nearest maximum: cur_formant
		pa = 0.000020 * 10^(db/20)
		appendInfoLine: "Formant ", i, ": Hz = ", cur_formant, ", nearest_peak = ", hz, ", dB = ", db, ", Pa = ", pa
		
		# create sine waves
		if i == 1
			first = Create Sound as pure tone: "pure_" + string$(i), 1, 0, 0.4, 44100, cur_formant, pa*10, 0.01, 0.01
		else
			Create Sound as pure tone: "pure_" + string$(i), 1, 0, 0.4, 44100, cur_formant, pa*10, 0.01, 0.01
		endif
	endfor

	# combine the sine waves
	selectObject: first
	plusObject: first+1
	plusObject: first+2
	plusObject: first+3
	Combine to stereo

endfor

appendInfoLine: ""
appendInfoLine: "All done!"