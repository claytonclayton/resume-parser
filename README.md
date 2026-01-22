# resume-parser

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
        - [ ] make fast cli
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

