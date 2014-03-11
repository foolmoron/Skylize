SL = window.SL = window.SL ? {}

SL.GOOGLE_API_KEY = "AIzaSyClmp-OcgOFVF9fPybWuFAutXOlYr7PAl8"
SL.SPRITE_DIRECTORY = "./sprites/"
SL.FONTSHEET_DIRECTORY = "./font/"
SL.AUDIO_DIRECTORY = "./audio/"

SL.GRID_SIZE = 15
SL.TILE_SIZE = 48

SL.tex = {} # holds all textures
SL.font = {} # hold all fontsheets

Client = IgeClass.extend
    classId: 'Client',

    init: ->
        # Engine setup
        ige.globalSmoothing true
        #ige.addComponent IgeEditorComponent

        # Setup AJAX to talk with google Url shortener
        $.ajaxSetup
            async: false
            contentType: 'application/json'
        
        # Wait for our textures to load before continuing
        ige.on 'texturesLoaded', =>
            # Create the HTML canvas
            ige.createFrontBuffer true

            ige.start (success) =>
                if success
                    ige.viewportDepth true
                    
                    do @setupScene
                    do @setupEntities
        
        do @load

    setupScene: ->
        @mainScene = new IgeScene2d()
            .id 'mainScene'

        # Create the main viewport
        @vpMain = new IgeViewport()
            .id 'vpMain'
            .autoSize true
            .scene @mainScene
            .drawBounds false
            .drawBoundsData false
            #.drawCompositeBounds true
            .mount ige

        @bgScene = new IgeScene2d()
            .id 'bgScene'
            .layer 1
            .translateTo 0, 0, 0
            .mount @mainScene

        @gameScene = new IgeScene2d()
            .id 'gameScene'
            .layer 2
            .translateTo 0, 0, 0
            .mount @mainScene

        @fgScene = new IgeScene2d()
            .id 'fgScene'
            .layer 3
            .translateTo 0, 0, 0
            .mount @mainScene
            
        @vpMain._oldResizeEvent = @vpMain._resizeEvent
        @vpMain._resizeEvent = (event) => # transplant additional code into existing resize handler
            @vpMain._oldResizeEvent.call @vpMain, event
            @_resizeEvent.call @
        do @vpMain._resizeEvent

    setupEntities: ->
        grid = new Grid(SL.GRID_SIZE, SL.TILE_SIZE)
            .id 'grid'
            .translateTo -(SL.GRID_SIZE / 2 - 0.5) * SL.TILE_SIZE, -(SL.GRID_SIZE / 2 - 0.5) * SL.TILE_SIZE, 0
            .mount @gameScene

    convertToLongString: (shortString) ->
        longUrl = null
        $.get "https://www.googleapis.com/urlshortener/v1/url?key=" + SL.GOOGLE_API_KEY + "&shortUrl=http://goo.gl/" + shortString, (data) ->
            longUrl = data.longUrl # synchronously obtain original long URL from goo.gl
        return longUrl.split('?q=')[1] if longUrl? && longUrl.split('?q=').length > 0

    convertToShortString: (longString) ->
        shortUrl = null
        $.post "https://www.googleapis.com/urlshortener/v1/url?key=" + SL.GOOGLE_API_KEY, '{"longUrl": "foolmoron.io?q=' + longString + '"}', (data) ->
            shortUrl = data.id # synchronously obtain shortened URL from goo.gl
        return shortUrl.split('/')[shortUrl.split('/').length - 1] if shortUrl?

    _resizeEvent: ->
        unless @vpMain.resizing
            windowWidth = window.innerWidth ? document.documentElement.clientWidth ? d.getElementsByTagName('body')[0].clientWidth
            if windowWidth <= 740
                @vpMain.resizing = true
                @vpMain.minimumVisibleArea 740, 700
                @vpMain.resizing = false
            else
                delete @vpMain._lockDimension
                @vpMain.scaleTo 1, 1, 1

module.exports = Client if module?.exports?