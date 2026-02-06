
# Testing

## Sanitiser
- [ ] \ escapes
    - [ ] escapes should be performed greedily(?) left to right
    - [ ] final unescaped \ of a line should be removed
        - this is just for users who want to make flats look pretty when their mds are rendered to html
- [ ] comments
    - [ ] start of line
    - [ ] mid line
- [ ] literals
    - [ ] non escaped \ should be turned into literals (\textbackslash)
        - do this with a lexer?
    - [ ] same for $, #, ~ etc 
- [ ] bolds, italics, strikethroughs

## Grouper
- [ ] blocks and dots do not need to be contained within sections
    - use invisible sections

## Cli
- [ ] use correct parser for .md and .org file extensions
- [ ] -md and -org flags override file extension check
- [ ] out path defaults to resume.pdf
- [ ] unspecified in and out paths result in a lorem impsum example
    - this might be downright confusing for users so might change
- [ ] -tex flag outputs tex

## Parser
- [ ] too many | throws an error

## Lexer
- [ ] comments are removed
