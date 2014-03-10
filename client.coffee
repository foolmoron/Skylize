SL = window.SL = window.SL ? {}

SL.SPRITE_DIRECTORY = "./sprites/"
SL.FONTSHEET_DIRECTORY = "./font/"
SL.AUDIO_DIRECTORY = "./audio/"

SL.tex = {} # holds all textures
SL.font = {} # hold all fontsheets

Client = IgeClass.extend
    classId: 'Client',

    init: ->
        # Engine setup
        ige.globalSmoothing true
        #ige.addComponent(IgeEditorComponent);
        
        # Setup this
        self = this
        
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
        test = new IgeEntity()
            .id 'test'
            .texture SL.tex['irrelon']
            .dimensionsFromCell()
            .mount @gameScene

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