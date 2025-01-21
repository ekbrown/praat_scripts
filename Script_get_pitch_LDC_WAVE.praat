### Praat v.6.4.25 script to get pitch of 10-millisecond frames in WAV files in one dirtectory
### Earl Kjar Brown, ekbrown byu edu (add characters to create email)
### Written in January 2025

### start script ###

# progress report to user
writeInfoLine: "Let's get started!"

# pathway to in directory with wav files
in_dir$ = "Z:\LDCSpeechDataSampler\WAVE"

# pathway to outfile
out_file$ = "C:\pathway\to\pitches.csv"

# write headers on columns in CSV files
writeFileLine: out_file$, "filename,timestamp,pitch"

# get the filenames of the WAV files in the in directory
file_list = Create Strings as file list: "fileList", in_dir$ + "/*.wav"  

# get the number of files in the in directory (whose filenames are now being held as a string object in Praat)
n_files = Get number of strings

# loop over indexes of WAV files in string object
for i from 1 to n_files

	# select the string object holding the filenames
	selectObject: file_list

	# get current WAV file's name
	file_name$ = Get string: i

	# progress report to user
	appendInfoLine: "Working on file: 'file_name$'"

	# read in current WAV file
	sound = Read from file: in_dir$ + "/" + file_name$

	# create pitch object
	pitch = To Pitch: 0, 75, 600

	# get number of 10-millisecond frames
	n_frames = Get number of frames

	# loop over indexes of the frames in the current WAV files
	for j from 1 to n_frames

			# get timestamp of current frame
   		time = Get time from frame number: j

			# get pitch of current frame
    		pitch = Get value in frame: j, "Hertz"

			# append filename, timestamp, and pitch to CSV out file
    		appendFileLine: out_file$, "'file_name$','time','pitch'"

	# next frame index in current WAV file
	endfor

# next WAV file index
endfor

# progress report to user
appendInfoLine: "All done!"

### end script ###