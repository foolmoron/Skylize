Grid = IgeEntity.extend
    classId: 'Grid'

    MOUSE_POSITION_HACK_X: -15
    MOUSE_POSITION_HACK_Y: -75
    
    init: (@_gridSize, @_tileSize) ->
        IgeEntity::init.call @

        @_grid = []
        for i in [0..@_gridSize] # index at 0 to add extra column
            row = []
            for j in [0..@_gridSize] # index at 0 to add extra row
                newTile = new Tile(@_tileSize)
                    .id("#{i}x#{j}")
                    .translateTo i * @_tileSize, j * @_tileSize, 0
                    .depth i * @_gridSize + j
                    .mount @
                row.push newTile

                if i == @_gridSize && j == @_gridSize
                    for light of newTile._lights
                        newTile._lights[light].destroy()
                        delete newTile._lights[light]
                else if i == @_gridSize
                    for light of newTile._lights
                        if light != 'l'
                            newTile._lights[light].destroy()
                            delete newTile._lights[light]
                else if j == @_gridSize
                    for light of newTile._lights
                        if light != 't'
                            newTile._lights[light].destroy()
                            delete newTile._lights[light]

        @_mouseEventCatcher = new IgeEntity()
            .width (@_gridSize + 1) * @_tileSize
            .height (@_gridSize + 1) * @_tileSize
            .translateTo (SL.GRID_SIZE / 2 - 0.5) * SL.TILE_SIZE, (SL.GRID_SIZE / 2 - 0.5) * SL.TILE_SIZE, 0
            .mouseDown (evt) =>
                point =
                    x: evt.x + @MOUSE_POSITION_HACK_X
                    y: evt.y + @MOUSE_POSITION_HACK_Y
                @handleDown(evt, point)
            .mouseMove (evt) =>
                point =
                    x: evt.x + @MOUSE_POSITION_HACK_X
                    y: evt.y + @MOUSE_POSITION_HACK_Y
                @handleMove(evt, point)
            .mouseUp (evt) =>
                point =
                    x: evt.x + @MOUSE_POSITION_HACK_X
                    y: evt.y + @MOUSE_POSITION_HACK_Y
                @handleUp(evt, point)
            .mount @

    handleDown: (evt, point) ->
        console.log(point)

    handleMove: (evt, point) ->
        console.log(point)

    handleUp: (evt, point) ->
        console.log(point)

module.exports = Grid if module?.exports?