Grid = IgeEntity.extend
    classId: 'Grid'

    MOUSE_POSITION_HACK_X: -15
    MOUSE_POSITION_HACK_Y: -75

    PICKER_OFFSETX: 126
    PICKER_OFFSETY: -65
    PICKER_GAPX: 60
    PICKER_SIZE: 50
    PICKER_FADE_OPACITY: 0.25

    VELOCITY_TIERS: [5, 16, 26, 36, 46, 55]
    
    init: (@_gridSize, @_tileSize) ->
        IgeEntity::init.call @
        self = @

        @pickers = {}
        pickerX = @PICKER_OFFSETX
        colors = (value for key, value of Light.COLOR)
        colors.push 'all'
        for color in colors
            self.pickers[color] = new IgeEntity()
                .texture(SL.tex['picker' + color])
                .width self.PICKER_SIZE
                .height self.PICKER_SIZE
                .opacity self.PICKER_FADE_OPACITY
                .mouseDown ->
                    self._currentColor = @_color
                    for key, picker of self.pickers
                        if key == @_color
                            picker.opacity 1
                        else
                            picker.opacity self.PICKER_FADE_OPACITY
                .translateTo pickerX, self.PICKER_OFFSETY, 0
                .mount self
            self.pickers[color]._color = color
            pickerX += @PICKER_GAPX
        @pickers['all'].mouseDown().call @pickers['all']

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

        currentColor = @_currentColor
        switch velocityTier
            when 0
                currentColor = Light.COLOR.RED if currentColor == 'all'
                for light of tile._lights when light in ['t', 'l', 'f', 'b', 'h', 'v']
                    tile._lights[light].color(currentColor)
                @_grid[tilePos.x + 1]?[tilePos.y]?._lights['l'].color(currentColor)
                @_grid[tilePos.x]?[tilePos.y + 1]?._lights['t'].color(currentColor)
            when 1
                currentColor = Light.COLOR.BLUE if currentColor == 'all'
                for light of tile._lights when light in ['t', 'l', 'f', 'b']
                    tile._lights[light].color(currentColor)
                @_grid[tilePos.x + 1]?[tilePos.y]?._lights['l'].color(currentColor)
                @_grid[tilePos.x]?[tilePos.y + 1]?._lights['t'].color(currentColor)
            when 2
                currentColor = Light.COLOR.WHITE if currentColor == 'all'
                for light of tile._lights when light in ['t', 'l']
                    tile._lights[light].color(currentColor)
                @_grid[tilePos.x + 1]?[tilePos.y]?._lights['l'].color(currentColor)
                @_grid[tilePos.x]?[tilePos.y + 1]?._lights['t'].color(currentColor)
            when 3
                currentColor = Light.COLOR.RED if currentColor == 'all'
                for light of tile._lights when light in ['f', 'b']
                    tile._lights[light].color(currentColor)
            when 4
                currentColor = Light.COLOR.GREEN if currentColor == 'all'
                for light of tile._lights when light in ['h', 'v']
                    tile._lights[light].color(currentColor)
            when 5
                currentColor = Light.COLOR.YELLOW if currentColor == 'all'
                for light of tile._lights when light in ['h']
                    tile._lights[light].color(currentColor)

    handleUp: (evt, point) ->
        @_painting = false
        @_lastTouch = null

module.exports = Grid if module?.exports?