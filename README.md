# ZearchQR_V2
 ZearchQR Paperchase app in swift.
 
 ZearchQR API - in Python Flask
 
 API can be found running on Azure cloud services at https://zearchqr-api.azurewebsites.net/
 
 Published through a docker container.  
  

## Dependencies
https://github.com/yuriy-budiyev/code-scanner  
Should already be included but if not just File > Swift Packages > Add Package Dependency and enter its repository URL.  

I've also used some code from StackOverflow regardning userlocation/timer/map with modifications to it.  
Didn't keep track of links since it's an individual project and I assume you're allowed to use codesnippets avaliable to you like in the real world.  
  

## Videos
Please download the videos to see the project in action, filenames are pretty self explanatory.
  

## Hours
Roughly estimated at 150+ hours...  
  

## License
See the [LICENSE](LICENSE.md) file for license rights and limitations (MIT).  
  


## Idea's left to implement (if I had more time)
  ### ~~Website~~
  This idea was scratched since I was working overtime, otherwise it would just generate a new route without any set start/goal locations as well as allow the user to upload a      respective picture for the route.
  
  ### Route view
  Once you're playing the game I would want it to update your current location and display a route from where you are to the goal in real-time.  
  Currently only shows the Start/Goal.
  
  ### Clean Up
  The code is a complete mess.  
  Keep in mind that I've never used a Mac or Swift before this... (Bought one at the start of the project)
  As the progress progressed I've learned more and more but I don't have time to clean it up or fix it at this times.  
  I also have som very, very bad variables around like "test" "test2222"...
  
  There's also some spelling errors I forgot to fix for example "Scan" with 2x n.  Just realized 2021-03-08 (18:22) Hehe...

  ### Bugs
  I'm sure there's a lot.  
  When scanning start/goal it "seems" to show the correct error messages but I've encountered times where it dosn't. Havn't looked in to this further but it's most likely just     adding some more if/else as usuall.
  
  The sorting of lists when updating score seems to be working sort of correctly... at times... This should be done in the API instead for easy of use.
