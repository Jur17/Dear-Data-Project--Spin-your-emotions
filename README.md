# Dear-Data-Project--Emotion Sound Wheel
This is a data-driven visualisation that combines colours with emotions and sound along with sound-volume with emotion intensities. Each day is displayed as bar arranged around a circle like a spin a wheel, with both visual and audio behaviour to respond to users interactions.

**OVERVIEW**
This project diplays 100 days worth data onto a circular layout.
Where each spinners-bar represents a single day with
- Color -->the primary emotions of the day
- Length -->the emotion intensity on a range of (1-10, where 1=lowest and 10=highest)
- Vibration -->noises based motions
- Hovering and Pinning -->user can hover over the bar and there would be a tooltip that is visualised by the user and if the user clicks it, they can pin it.

I have attahed my favourite song in the month of december as it is christmas as well as I sat down to code this project.

the audio loops and the sketch adjust its volume and the playback speed depending on the emotions intensity data.

**CONCEPTS & DESIGN APPROACH**
The circular layout captures the idea of time and days looping and repeating while the bars of the wheel represents an emotional feel across the days.
Colors were chosen by selective preference to what I think an colour an emotion would be in real life if they exist as living things.
Integrating the sound was key as it reflects to the emotional intensity which dynamically adjusted the colume and pitch of the audio.

**FEATURES**
-- interactive circular emotional wheel
-- hover detection with displayed information on the day and the emotion intensity       along side with the primary emotion of the day.
--clicking the background , makes sure the visualization resets and returns with the   base volume normal pitch of the audio.
-- Audio that adapts and reacts to the emotional intensity.
-- Emotion and intensity legend for quick reference
-- Pinning system to llock the focused day
--animated highlighes for the tooltip and the emotion menu

**Technical Details**
This project is built in Processing and uses the sound Library.
The hover detection is performed using angle an distance calculation (atan()) so that each bar has a different angle to fit a perfect circle.
Emotion colours are defined with the HSB color model and the legends highlights based on the current focus by the user with the mouse interactions.

**INSTALLATION**
Install Processing(JAVA MODE)
Install Sound library
- Sketch ->Import Library -> Add library
- Search for Sound and install it.
Place the project folder in Processing and add data/ folder containing
- emotions_data_100.csv
- SantaBaby.mp3
Lastly Run the sketch.

**Recordings**
I recorded my data using an excel sheet where every 2 hours, I recorded what emotions I was feeling and what is the intensity ranging from 1-10 and tallying it for 7 times a day and taking the the average and have a table displaying these emotion.

Then I converted the excel sheet(.xlsv) into a csv file (.csv) by doing the following
Open Excel File.
Click File --> Save as.
Choose the folder you want to save it.
Save as type and choose CSV file(.csv) and Click save.

**CSV FORMAT**
The csv format is 
Day, Primary Emotion, Intensity
1, Joy, 10 -->example

**REPLACEABLE AREADS WHERE ONE CAN MODIFY**
- The emotion colours which is inside getColorForEmotion() method
- audio file - can be replaced with any other audio
- Intensity mapping and the tooptip styling

**About the Dear Data Project**
Dear Data is a year-long collaboration between two friends, Giorgia Lupi and Stefanie Posavec who were designers. Each week, they collected personal data about their lives and turned it into hand-made or such I say hand-drawn postcode to be mailed to each other. The project shows how data can be visualised in many ways and it can intimate, emotional and creative. It is often refered to as a key example of "humanised data or data humanism" , where everyday experiences are transformed into visual stories.

**How has the Dear Data Project inspire to my own project**
Like Giorgia and Stephanie, i wanted to explore how personal data - like my emotions can be representated expressively visually. Instead of postcards to be mailed of to a friend, I decidedto add an interactive touch , but teh goal were the same, to visualise small moments of my everyday life and reveal patterns with how my emotions work. I focused on designing and experience that feels alive where i use colors, movement and sound for my emotion intensity. 




