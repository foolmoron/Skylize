Grid = IgeEntity.extend
    classId: 'Grid'

    MOUSE_POSITION_HACK_X: -15
    MOUSE_POSITION_HACK_Y: -75

    VELOCITY_TIERS: [5, 10, 20, 30, 40, 50]
    
    init: (@_gridSize, @_tileSize) ->
        IgeEntity::init.call @

        @_grid = []
        for i in [0..@_gridSize] # index at 0 to add extra column
            row = []
            @_grid.push row
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
                    for light of newTile._lights when light != 'l'
                        newTile._lights[light].destroy()
                        delete newTile._lights[light]
                else if j == @_gridSize
                    for light of newTile._lights when light != 't'
                        newTile._lights[light].destroy()
                        delete newTile._lights[light]

        @_painting = false
        @_lastTouch = null
        @_mouseEventCatcher = new IgeEntity()
            .width (@_gridSize + 1) * @_tileSize
            .height (@_gridSize + 1) * @_tileSize
            .translateTo (SL.GRID_SIZE / 2 - 0.5) * SL.TILE_SIZE, (SL.GRID_SIZE / 2 - 0.5) * SL.TILE_SIZE, 0
            .mouseDown (evt) =>
                point =
                    x: evt.x + @MOUSE_POSITION_HACK_X
                    y: evt.y + @MOUSE_POSITION_HACK_Y
                @handleDown(evt, point) if point.x >= 0 && point.y >= 0
            .mouseMove (evt) =>
                point =
                    x: evt.x + @MOUSE_POSITION_HACK_X
                    y: evt.y + @MOUSE_POSITION_HACK_Y
                @handleMove(evt, point) if point.x >= 0 && point.y >= 0
            .mouseUp (evt) =>
                point =
                    x: evt.x + @MOUSE_POSITION_HACK_X
                    y: evt.y + @MOUSE_POSITION_HACK_Y
                @handleUp(evt, point) if point.x >= 0 && point.y >= 0
            .mount @

    handleDown: (evt, point) ->
        @_painting = true
        @_lastTouch = point

    handleMove: (evt, point) ->
        unless @_painting
            return

        tilePos = {x: Math.floor(point.x / @_tileSize), y: Math.floor(point.y / @_tileSize)}
        tile = @_grid[tilePos.x][tilePos.y]
        displacement = {x: @_lastTouch.x - point.x, y: @_lastTouch.y - point.y}
        velocity = Math.abs(displacement.x) + Math.abs(displacement.y)
        velocityTier = 0
        velocityTier++ for tier in @VELOCITY_TIERS when tier <= velocity
        @_lastTouch = point

        switch velocityTier
            when 0
                for light of tile._lights when light in ['t', 'l', 'f', 'b', 'h', 'v']
                    tile._lights[light].color(Light.COLOR.RED)
                @_grid[tilePos.x + 1]?[tilePos.y]?._lights['l'].color(Light.COLOR.RED)
                @_grid[tilePos.x]?[tilePos.y + 1]?._lights['t'].color(Light.COLOR.RED)
            when 1
                for light of tile._lights when light in ['t', 'l', 'f', 'b']
                    tile._lights[light].color(Light.COLOR.RED)
                @_grid[tilePos.x + 1]?[tilePos.y]?._lights['l'].color(Light.COLOR.RED)
                @_grid[tilePos.x]?[tilePos.y + 1]?._lights['t'].color(Light.COLOR.RED)
            when 2
                for light of tile._lights when light in ['t', 'l']
                    tile._lights[light].color(Light.COLOR.RED)
                @_grid[tilePos.x + 1]?[tilePos.y]?._lights['l'].color(Light.COLOR.RED)
                @_grid[tilePos.x]?[tilePos.y + 1]?._lights['t'].color(Light.COLOR.RED)
            when 3
                for light of tile._lights when light in ['f', 'b']
                    tile._lights[light].color(Light.COLOR.RED)
            when 4
                for light of tile._lights when light in ['h', 'v']
                    tile._lights[light].color(Light.COLOR.RED)
            when 5
                for light of tile._lights when light in ['h']
                    tile._lights[light].color(Light.COLOR.RED)

    handleUp: (evt, point) ->
        @_painting = false
        @_lastTouch = null

module.exports = Grid if module?.exports?