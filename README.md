# resume-parser

## Roadmap
- [ ] implement 'parse' button (maybe think of a better name).   
      converts from md to latex then either shows the user an error or complete status.
    - [ ] produce some failing md test cases
        - [x] download hoogle cli
        - [x] understand liftM, runMaybeT stackoverflow post 
        - [x] refactor parseLine using unlawful \*> 
        - [x] refactor Line
        - [ ] refactor Grouper
        - [ ] refactor parseBlockTraits with unlawful \*>
    - [ ] haskell nvim error highlight plugin?
    - [ ] QuickCheck?
    - [ ] display basic errors on front end
    - [ ] add line numbers to md box. see codeforces
- [ ] implement 'render' button 
    - [ ] open pdf in new tab
    - [ ] show preview box
- [ ] sanitise input
- [ ] peruse competitors githubs
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

## Features I want
- [ ] AI that converts resume pdfs into md
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

