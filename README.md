# The Project!
The goal is to make a website where you can type out your resume in markdown and then have it be converted into a pretty resume pdf. To see an example of a markdown input check out ```me/md/resume.md```, and to see its pdf counterpart check out ```me/pipeline/pdf/resume.pdf```.

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

### Install latexmk
You will also need to download latexmk. Essentially the program just transpiles markdown into latex and then I just use a latex renderer to make the pdf. If you have a mac, you can download MacTex which just gets you latexmk automatically.

https://www.tug.org/mactex/mactex-download.html

Alternatively I think you can just download latexmk directly here too. 

https://mgeier.github.io/latexmk.html

### Running the server
Then make sure you are in the project root directory and run ```stack run server``` or alternatively run the script ```me/scripts/./server.sh``` (make sure you chmod 775 this file first), and then the server will be up and running. An extremely basic front end is implemented in ```static/index.html``` (fully AI generated because I have never written front end before). Access the front page at:

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

This is a condensed version of the file at ```src/Resume/Server.hs```. All this means is the site is exposed at port 3000, and that you can ```GET /``` and ```POST /render```. Unfortunately these are all the endpoints we have exposed at the moment. The next step will be to work on the lint button.

### And away you go!
And that's the bare minimum you need to start writing the frontend! Make it look any way you like as long as it roughly adheres to requirements in the Features section above. Most important thing to remember is to take your time. According to the commit history I've spent like 2-3 months on this already which is insanely slow. It's probably due to not consistently working on this everyday, which I plan to do while staying at bruce so hopefully my speed picks up.

If you want some extra knowledge I have added some extra optional material below that may help. Also be sure to check out the 'Roadmap' and 'Features I want' section at the very end of the README. Feel free to make a roadmap for the frontend too if you would like.

# The Optional Stuff

## How to use the CLI
Alongside the server, there is also an accompanying cli!   

Use the command ```me/scripts/./gen.sh``` to run the cli. When given no arguments it will convert the file at ```me/md/resume.md``` into the pdf at ```me/pipeline/pdf/resume.pdf```. You can give it a file path as an argument too and it will convert that file into the pdf at the same location stated previously.  

Currently this command runs pretty slow because it includes building the entire project, as well as some other reasons. I will make a faster version in the future.

## The backend program structure
The main flow of the program exists in ```src/Resume/Render.hs```. This program calls the following programs in the order: Preprocessor.hs ->  Parser.hs -> Grouper.hs -> Generator.hs. The preprocessor sanitises the input (to avoid me getting hacked lol) -> the parser isolates each element of the input -> the grouper groups these elements into a more ordered data structure -> and then the generator converts this data structure into latex, which is later rendered into a pdf via latexmk. 

If you would like some tips on how to read Haskell, just ask me.

## How to make your own resume template
I only have one template made so far, but I have this feeling that it would be pretty easy to alter existing latex templates to fit our program. 

https://www.overleaf.com/gallery/tagged/cv

Honestly I think you could just paste my template at ```me/pipeline/tex/resume.tex``` into chatgpt alongside one of the templates above and ask it to rewrite the template in my styling. If you want to do it yourself, just ask me and I can give you a crash course. 

## Inline comments
I haven't really written any comments within my code lol, but if you would like me to, just ask.  

# TODOs
## Backend Roadmap
- [x] implement render button. converts from md to latex then either shows the user an error or complete status.
    - [x] produce parse errors
        - [x] download hoogle cli
        - [x] understand liftM, runMaybeT stackoverflow post 
        - [x] refactor parseLine using unlawful \*> 
        - [x] refactor Line
        - [x] refactor Grouper
        - [x] refactor Cli and Render with System.Process
        - [x] refactor parseBlockTraits with unlawful \*>
    - [x] create documentation for anna
        - [x] make basic render button work on frontend
        - [x] add app explanation to README
        - [x] add cli usage explanation to README
    - [x] display basic errors on front end
    - [x] open pdf in new tab
- [x] suppress latexmk errors
    - [x] research haskell handle pattern
    - [x] research readert pattern
    - [x] refactor render with ReaderT
    - [x] give Render.render an option to suppress latexmk prompts/stdout
- [ ] begin job search
    - [x] mostly finalise software.md
        - [x] send to dom. ask about orgmode
    - [ ] make clayton's problems user friendly
        - [ ] ensure check.sh works on macos
        - [ ] write readme
    - [ ] make resume-parser open source! 
        - [ ] gitignore resume.md, resume.tex, resume.pdf
        - [ ] purge all senstive files from all commits
- [ ] haskell nvim error highlight plugin
    - [x] browse reddit
    - [ ] set up hls on another macOS account
- [ ] begin test suite 
    - [ ] QuickCheck?
    - [ ] unit tests
    - [ ] produce group errors 
    - [ ] implement RemainingLines error
- [ ] begin linter
    - [ ] get inspired by bearblog github
    - [ ] add line numbers to md box. see codeforces
    - [ ] markdown syntax highlighting
    - [ ] spellcheck
    - [ ] full stops, capital letters
    - [ ] abbreviation consistency (Dec vs December)
- [ ] template display
    - [ ] convert one latex resume templates into my style
    - [ ] convert another
- [ ] sanitise input
    - [ ] mv Preprocessor.hs Sanitiser.hs
- [ ] peruse Competitors githubs
    - [ ] rendercv
    - [ ] SmartResume
    - [ ] Resumey.Pro
    - [ ] markdown-resume
    - [ ] check out markdown real time render web apps
    - [ ] check out typst resume templates
- [ ] make fast cli
- [ ] fix intro email link
- [ ] sublists (see julie resume)
- [ ] block title wrap (see scott resume)
- [ ] implement italics, bolds, strikethroughs
- [ ] refactor Grouper with State
- [ ] refactor Generator to use only neccessary amount of optional latex args
      eg. don't use Block{}[][][][]
        - [ ] make fast cli
- [ ] write tutorial blog
- [ ] implement orgmode, typst parser
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
- [ ] the textbox autodetects sections and blocks and allows you to quickly
      click and drag them around the place. you can easily do this via copy
      and pasting but this would be more convenient. 
- [ ] create a mode that allows you to create a dynamic form instead of write md.
      click buttons that create new sections, dots etc.  
- [ ] implement inline comments to allow users to jot down informal ideas
- [ ] implement bold, italics, strikethroughs
