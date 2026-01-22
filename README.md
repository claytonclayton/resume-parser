# The Short Explanation
The goal is to make a website where you can type out your resume in markdown and then have it be converted into a pretty resume pdf. 

Below is me trying my best to quickly explain the features I am working towards, and how get started as soon as possible.

## Features
Here are the main features I am working towards in order of importance:

### The render button
The front page will contain a large text box where you can type out your resume and underneath it there will be a button that says 'render'. When you click it, it will download your resume in pdf form

### The lint button
underneath the text box there will also be a button that says 'lint'. after clicking it, it basically performs a spell check on the text you put in the textbox. Incorrect spellings, missing full stops, uncapitalised letters will be highlighted in red. Hovering over the highlighted text opens a small text panel on the right hand side of the text box, which displays an explanation of the error. Next to the lint button will also be an 'auto-lint' button which automatically fixes all mistakes you've made.

### Template showcase
The website will have a series of resume templates to choose from. Underneath the render button there should be a drop down menu of some sort displaying all the template types. There should also be a separate page to the front page where you can browse all the templates in a more comfortable way.

Honestly if we implement all three of these things we could totally wrap up the project, but if we have time there are additional goals we could work towards

### Embed images
Be able to upload images to the site and embed them into your resume. Some people like putting in headshots or photos of their work in their resmes so this is probs important.

### Pdf to pdf conversion
Write an algorithm that converts a pdf resume into markdown format and then back into pdf. Allows users to convert their already made resumes into the templates we have on our site.

### Create an account to save previous work
Allow users to create an account and have their previous md files saved. Could include a basic version control system that allows you to go back to previous versions of resumes you've written.

### Subscription service
I also have this idea of adding a $1 per 100 years subscription service lol. The idea is that if our friends want to help chip in we'll be able to write on our actual resumes something like "developed a web app with a paid subscription service, serving 10 clients concurrently.". Am I a genius or what? The subscrition model will allow users to create the account described above, which is actually a neccessity since allowing users to make accounts for free might let evil users flood the database with noise.
 
That's basically it! Scroll down to the bottom of the README to see some other feature ideas I have. Feel free to add more yourself.

## Getting Started
### Install ghcup
After you git clone the project you will need to download ghcup to run the server (there is no docker instance for the project yet). Use the link below.

https://www.haskell.org/ghcup/

Haskell is pretty massive so it might take 5-10 mins to download. After it has finished use the command ```ghcup tui``` to make sure you have GHC 9.6.7 installed.

### Running the server
Then make sure you are in the project root directory and run 'stack run server' or alternatively run the script 'me/scripts/./server.sh' (make sure you chmod 775 this file first), and then the server will be up and running. An extremely basic front end is implemented in static/index.html (fully AI generated because I have never written front end before). Access the front page at:

http://localhost:3000/  

### Comprehending the server
```
server :: IO ()
server = 
  scotty 3000 $ do

    get "/" $ do 
      -- do stuff

    post "/render" $ do
      -- do more stuff
```

# The Long Explanation

## Roadmap
- [ ] implement render button. converts from md to latex then either shows the user an error or complete status.
    - [x] produce parse errors
        - [x] download hoogle cli
        - [x] understand liftM, runMaybeT stackoverflow post 
        - [x] refactor parseLine using unlawful \*> 
        - [x] refactor Line
        - [x] refactor Grouper
        - [x] refactor Cli and Render with System.Process
        - [x] refactor parseBlockTraits with unlawful \*>
    - [ ] create documentation for anna
        - [x] make basic render button work on frontend
        - [ ] add comments on all files
        - [ ] add app explanation to README
        - [ ] add cli usage explanation to README
    - [ ] remove gitignored files on all versions of the repo
    - [ ] display basic errors on front end
    - [ ] produce latexmk errors?
    - [ ] haskell nvim error highlight plugin?
    - [ ] add line numbers to md box. see codeforces
    - [ ] open pdf in new tab
    - [ ] show preview box
- [ ] make fast cli
- [ ] begin linter
- [ ] begin test suite 
    - [ ] QuickCheck?
    - [ ] unit tests
    - [ ] produce group errors 
    - [ ] implement RemainingLines error
- [ ] sanitise input
    - [ ] mv Preprocessor.hs Sanitiser.hs
- [ ] peruse Competitors githubs
    - [ ] rendercv
    - [ ] SmartResume
    - [ ] Resumey.Pro
    - [ ] markdown-resume
    - [ ] check out markdown real time render web apps
    - [ ] check out typst resume templates
- [ ] fix intro email link
- [ ] sublists (see julie resume)
- [ ] block title wrap (see scott resume)
- [ ] convert some latex resume templates into my style
- [ ] work on the front end. probs react
    - [ ] get inspired by bearblog github
- [ ] implement italics, bolds, strikethroughs
- [ ] refactor Grouper with State
- [ ] refactor Generator to use only neccessary amount of optional latex args
      eg. don't use Block{}[][][][]
        - [ ] make fast cli
- [ ] deploy!

## Features I want
- [ ] algorithm that converts resume pdfs into md
- [ ] database that saves your md files
- [ ] linter
    - [ ] spell check
    - [ ] adds missing full stops, capital letters
    - [ ] auto linter
- [ ] tutorial blog
- [ ] $1/100 years paid subscription
    - [ ] ask scott about contracts rammifications of this.
          can I add a clause that says I can just revoke this
          subscription whenever I want despite promising them
          100 years?
- [ ] frontend error messages
    - [ ] errors underlined 
    - [ ] error lines highlighted red
    - [ ] error sidebar messages show on hover
- [ ] resume show case section
- [ ] ability to write arbitrary latex if you have
    an account? could get latex injected
- [ ] choose from a variety of resume templates
- [ ] be able to convert from md, orgmode and typst
- [ ] upload images and embed them in resumes

