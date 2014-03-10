SL = window.SL ? {}
Client::load = ->
    SPRITE_DESCRIPTIONS = [
        'irrelon.png',
        'side.png'
    ]
    CELLSHEET_DESCRIPTIONS = [
    ]
    FONTSHEET_DESCRIPTIONS = [
    ]

    for description in SPRITE_DESCRIPTIONS
        index = description.split('.')[0].replace(/(\/|\\)/g, '')
        SL.tex[index] = new IgeTexture(SL.SPRITE_DIRECTORY + description)
    for description in CELLSHEET_DESCRIPTIONS
        index = description[0].split('.')[0].replace(/(\/|\\)/g, '')
        SL.tex[index] = new IgeCellSheet(SL.SPRITE_DIRECTORY + description[0], description[1], description[2])
    for description in FONTSHEET_DESCRIPTIONS
        index = description.split(".")[0].replace(/(\/|\\)/g, '')
        SL.font[index] = new IgeFontSheet(SL.FONTSHEET_DIRECTORY + description)