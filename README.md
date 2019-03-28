# Flatiron W.O.D.
An app that suggests tailored workout routines for aspiring coders.

## Description
Flatiron WOD is an app that suggests tailored workout routines for aspiring coders.

Aspiring coders often spend much time to work on learning a new skill. This means many hours spent in front of a computer, and they face the dilemma on whether to debug or to eat proper meals, let alone to workout.

We have been in the same place, and have designed Flatiron WOD to overcome this dilemma. Our exercises library consists of exercises that are named after familiar coding syntaxes and methods. By performing these exercises, we don't just remind ourselves of these useful syntaxes, but are able to _embody_ their various functions.

## Functionalities of the app:
- Users can random WODs (Workout of the Day), based on how long they want to work out.
- Users can know the equivalent of lines of codes they would have written with their WOD, or how much calories it would burn.
- Users can select their favourite exercises from an exercises library and create their own WOD.
- Users can add their own custom exercises to the exercises library. Edit and delete functions are then also available.
- When ready to workout, exercises will be voice narrated so that users can closely follow instructions without looking at the screen.
- If users insist on looking at the screen, pretty ASCII animations are also available.
- As it has been scientifically proven that aspiring coders are the ones who need meditation the most, it is incorporated automatically into all WODs.
- Users can input a postcode anywhere in the world and find the nearest gyms in the vicinity.
- Users can delete their own account and all associated information from the app's database, a special feature that adheres to the latest GDPR regulations.

## Technical Details
Technically, Flatiron WOD uses a database to persist information using the following skills and knowledge:
- Ruby
- Object Orientation
- Relationships (via ActiveRecord)
- Problem Solving (via creating a Command Line Interface (CLI))

## Installation
After you've downloaded the entire project folder, open up your Terminal. Everything will run from there.
If you are not sure how to use Terminal, take a look at this documentation: https://blog.teamtreehouse.com/introduction-to-the-mac-os-x-command-line.
Once in the terminal and navigated to the project folder:
- Run `bundle install` to ensure all dependencies are installed.
- Run `rake db:drop db:create db:migrate db:seed` to initialise the app.
- Run `rake run`.

Then off you go!

If anything goes wrong, please use Ctrl+C on MacOS.

## Authors and acknowledgment
The authors are George Wong and JiaXuan Hon from Inglorious Bashterds of Flatiron School in London.
George did the crazy animations and media files. JiaXuan did the backend.
This app was built specifically as a project for Module 1 at Flatiron School. We acknowledge the help of all Technical Coaches at Flatiron School - Nico, Guy and Vasile, and the entire Inglorious Bashterds (London, 2019).

## Support
You could find the authors at george.wong@flatironschool.com or jiaxuan.hon@flatironschool.com.
