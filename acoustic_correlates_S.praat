#####################################################
# Praat script to measure duration, center of gravity, and voicelessness of /s/
# in Rich's Barranquilla corpus
#
# (c) 2014 Earl K. Brown www-personal.ksu.edu/~ekbrown
# This script can be freely modified and redistributed for non-profit purposes
#####################################################

# NOTE:
# Before running this script, you need to make sure the WAV files
# and their corresponding TextGrid files have the same names,
# including capitalization or the lack thereof

#####################################
# CHANGE THE FOLLOWING LINES AS NEEDED

# defines the folder with the WAV files and the folder with the TextGrid files
input_sound_folder$ = "/path/to/directory/with/sound/files/"
input_textgrid_folder$ = "/path/to/directory/with/textgrid/files/"

# creates output files in the same folder where this script is saved
output_file_i$ = "Data_Barranquilla_i.csv"
output_file_s$ = "Data_Barranquilla_s.csv"
output_file_imp$ = "Data_Barranquilla_impressionistic_codes.csv"
output_file_cog_ten$ = "Data_Barranquilla_cog_ten.csv"

#####################################

# creates headings for the columns and saves them in the /i/ output file
headings$ = "FILE'tab$'STRING'tab$'TIME'tab$'DUR'tab$'
...F0_50'tab$'F0_MEAN'tab$'F0_SD'tab$'
...F1_50'tab$'F1_MEAN'tab$'F1_SD'tab$'
...F2_50'tab$'F2_MEAN'tab$'F2_SD'tab$'
...F3_50'tab$'F3_MEAN'tab$'F3_SD'tab$'
...F4_50'tab$'F4_MEAN'tab$'F4_SD'tab$'"
...+newline$
headings$ > 'output_file_i$'

# creates headings for the columns and saves them in the /s/ output file
headings$ = "FILE'tab$'STRING'tab$'START'tab$'END'tab$'DUR'tab$'COG_MID'tab$'UNVOI"
...+newline$
headings$ > 'output_file_s$'

# creates headings for the columns and save them in the impressionistic codes file
headings$ = "FILE'tab$'TIME'tab$'CODE"
...+newline$
headings$ > 'output_file_imp$'

# creates headings in the file with cog at every 10% mark
headings$ = "FILE'tab$'STRING'tab$'TIME'tab$'PERC'tab$'COG"
...+newline$
headings$ > 'output_file_cog_ten$'

#####################################

clearinfo

# gets the names of the textgrids and how many there are
Create Strings as file list... textgrid_list 'input_textgrid_folder$'*.TextGrid
num_textgrids = Get number of strings

# sets textgrid counter to zero
nr_completed = 0

# loop over the textgrid files
for i to num_textgrids

     # (re)select the textgrid list, as it may have lost focus in the previous iteration
     select Strings textgrid_list

     # gets the name of the current textgrid file
     grid_name$ = Get string... i

     # reads the textgrid into the Objects window
     Read from file... 'input_textgrid_folder$''grid_name$'
     cur_grid = selected ("TextGrid")

     # gets basename of the current file
     base_name$ = selected$ ("TextGrid")

     # gets the sex of the current speaker
     sex$ = mid$ (base_name$, 5, 1)

     # prints progress report
     printline Working on 'base_name$'...

     # puts the "wav" extension in a variable
     ext1$ = ".wav"

     # creates sound file pathway
     sound_file_name$ = input_sound_folder$+base_name$+ext1$

     # tests whether the sound file can be read into Praat
     if fileReadable (sound_file_name$)

          # reads in audio file
          Open long sound file... 'sound_file_name$'
          sound_one = selected("LongSound")

          select 'sound_one'
          plus 'cur_grid'
          View & Edit

          #############################################
          # first, the /i/ tier, tier 1

# gets number of intervals in the /i/ tier
cur_tier_num = 1
select TextGrid 'base_name$'
num_intervals = Get number of intervals... 'cur_tier_num'
printline 'tab$'Working on tier 'cur_tier_num', the /i/ tier...

for j from 1 to 'num_intervals'

select TextGrid 'base_name$'
name_interval$ = Get label of interval... 'cur_tier_num' j
if name_interval$ != ""

# progress report
#printline 'tab$''tab$''name_interval$'

# gets times of points of current vowel
vowel_onset = Get starting point... 'cur_tier_num' j
vowel_offset = Get end point... 'cur_tier_num' j
vowel_dur = 'vowel_offset' - 'vowel_onset'
mid50 = vowel_onset + (vowel_dur / 2)

# extracts vowel to Objects window
select LongSound 'base_name$'
Extract part... ('vowel_onset'-1) ('vowel_offset'+1) yes
part_name$ = selected$ ("Sound")

####################
# gets F0 values
select Sound 'part_name$'
To Pitch... 0 75 600
f0_50 = Get value at time... 'mid50' Hertz Linear
f0_mean = Get mean... 'vowel_onset' 'vowel_offset' Hertz
f0_sd = Get standard deviation... 'vowel_onset' 'vowel_offset' Hertz

####################
# creates a Format object in preparation for getting F1 - F4
select Sound 'part_name$'
if sex$ = "F"
To Formant (burg)... 0 4 5500 0.025 50
elsif sex$ = "M"
To Formant (burg)... 0 4 5000 0.025 50
else
exit *** Error! The fifth character in the TextGrid file name doesn't seem to be either an "F" or an "M"! ***
endif
part_name_formant$ = selected$ ("Formant")

####################
# gets F1 values, using the Formant object just created and still selected
f1_50 = Get value at time... 1 'mid50' Hertz Linear
f1_mean = Get mean... 1 'vowel_onset' 'vowel_offset' Hertz
f1_sd = Get standard deviation... 1 'vowel_onset' 'vowel_offset' Hertz

####################
# gets F2 values
f2_50 = Get value at time... 2 'mid50' Hertz Linear
f2_mean = Get mean... 2 'vowel_onset' 'vowel_offset' Hertz
f2_sd = Get standard deviation... 2 'vowel_onset' 'vowel_offset' Hertz

####################
# gets F3 values
f3_50 = Get value at time... 3 'mid50' Hertz Linear
f3_mean = Get mean... 3 'vowel_onset' 'vowel_offset' Hertz
f3_sd = Get standard deviation... 3 'vowel_onset' 'vowel_offset' Hertz

####################
# gets F4 values
f4_50 = Get value at time... 4 'mid50' Hertz Linear
f4_mean = Get mean... 4 'vowel_onset' 'vowel_offset' Hertz
f4_sd = Get standard deviation... 4 'vowel_onset' 'vowel_offset' Hertz

####################
# creates results string and saves it to the output file
resultline_i$ = "'base_name$''tab$''name_interval$''tab$'
...'vowel_onset''tab$''vowel_dur''tab$'
...'f0_50''tab$''f0_mean''tab$''f0_sd''tab$'
...'f1_50''tab$''f1_mean''tab$''f1_sd''tab$'
...'f2_50''tab$''f2_mean''tab$''f2_sd''tab$'
...'f3_50''tab$''f3_mean''tab$''f3_sd''tab$'
...'f4_50''tab$''f4_mean''tab$''f4_sd''tab$'"
...+newline$

resultline_i$ >> 'output_file_i$'

####################
# cleans up
select Formant 'part_name_formant$'
plus Sound 'part_name$'
Remove

     endif # end of if the current interval has something in it

endfor # next interval, j loop in /i/ tier

#############################################
# second, the maintained /s/ tier, tier 2

select cur_grid
cur_tier_num = 2
num_intervals = Get number of intervals... 'cur_tier_num'
printline 'tab$'Working on tier 'cur_tier_num', the maintained /s/ tier...

for j from 1 to 'num_intervals'

select TextGrid 'base_name$'
interval_name$ = Get label of interval... 'cur_tier_num' j

if interval_name$ != ""

# progress report
#printline 'tab$''tab$''interval_name$'

####################
# gets duration of /s/

s_onset = Get starting point... 'cur_tier_num' 'j'
s_offset = Get end point... 'cur_tier_num' 'j'
s_dur = 's_offset' - 's_onset'

####################
# gets center of gravity of middle 20% of /s/ interval

tenth_of_s = s_dur/10
select LongSound 'base_name$'
start_span = 's_onset'+('tenth_of_s'*4)
end_span = 's_onset'+('tenth_of_s'*6)
Extract part... start_span end_span yes
part_name = selected("Sound")
select 'part_name'
Filter (pass Hann band)... 750 11025 100
To Spectrum... Fast
spectrum = selected("Spectrum")
select 'spectrum'

cog_mid = Get centre of gravity... 2

####################
# gets center of gravity of 10%-intervals across the /s/ interval

perc = 10
for k from 'perc' to 100
if k mod 'perc' == 0
start_span = s_onset + (s_dur * ((k - 'perc') / 100))
end_span = s_onset + (s_dur * (k / 100))
select sound_one
Extract part... start_span end_span yes
sound_two = selected ("Sound")
select 'sound_two'
Filter (pass Hann band)... 750 11025 100
To Spectrum... Fast
spectrum = selected ("Spectrum")
select 'spectrum'
cog$ = Get centre of gravity... 2
cog$ = left$ (cog$, 6)

resultline$ = "'base_name$''tab$''interval_name$''tab$'
...'s_onset''tab$''k''tab$''cog$'"
...+newline$

resultline$ >> 'output_file_cog_ten$'

endif
endfor

####################
# gets voicelessness

intStartLess = 's_onset' - 's_dur'
intEndMore = 's_offset' + 's_dur'

editor TextGrid 'base_name$'
Zoom... 'intStartLess' 'intEndMore'
Select... 's_onset' 's_offset'
voiceReport$ = Voice report
unvoiced = extractNumber (voiceReport$, "unvoiced frames: ")
endeditor

####################
# creates results string and saves it to the output file

resultline$ = "'base_name$''tab$''interval_name$''tab$'
...'s_onset''tab$''s_offset''tab$'
...'s_dur''tab$''cog_mid''tab$''unvoiced'"
...+newline$

resultline$ >> 'output_file_s$'

####################
# cleans up

select all
minus 'sound_one'
minus 'cur_grid'
minus Strings textgrid_list
Remove

endif # end of if there is something in the interval

endfor # next interval, j loop

#############################################
# third, the impressionistic code tier, tier 4

select cur_grid
cur_tier_num = 4
num_points = Get number of points... 'cur_tier_num'
printline 'tab$'Working on tier 'cur_tier_num', the impressionistic code tier...

for j from 1 to 'num_points'

select TextGrid 'base_name$'
point_name$ = Get label of point... 'cur_tier_num' j
point_time = Get time of point... 'cur_tier_num' j

resultline$ = "'base_name$''tab$''point_time''tab$''point_name$''tab$'"
...+newline$

resultline$ >> 'output_file_imp$'

endfor # next impressionistic code

#############################################

nr_completed = nr_completed + 1

else # if the file is not readable

# prints an error message if the wav file isn't readable
printline *** Error! No sound file 'input_sound_folder$''base_name$''ext1$' found. ***

# removes the selected textgrid that doesn't have a matching sound file
Remove

endif # end of if file is readable

# cleans up
select LongSound 'base_name$'
plus TextGrid 'base_name$'
Remove

endfor # next textgrid, i loop

# removes the textgrid list
select Strings textgrid_list
Remove

# announces finish
printline
printline Done!
printline
printline 'nr_completed' of 'num_textgrids' TextGrid files processed
printline
printline The result files are named:
printline "'output_file_i$'"
printline "'output_file_s$'"
printline "'output_file_imp$'"
printline "'output_file_cog_ten$'"
printline
printline and are in the folder where this script is saved
printline
